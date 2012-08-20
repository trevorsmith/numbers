module Numbers
  # Represents an OAuth 2.0 token for Service Accounts.
  # This token will automatically renew itself when it expires.
  #
  # Example:
  #   token = Numbers::AuthToken.new('123@developer.gserviceaccount.com', File.read('client_key.p12'))
  #   Numbers::Client.instance.token = token
  #
  #
  # To set up OAuth access for your application:
  #
  # 1. Register with the Google APIs Console: https://code.google.com/apis/console
  #
  # 2. Add a new project to represent your application, and enable
  #    the Analytics API under Services.
  #
  # 3. Create a client ID in the API Access section. Choose "Service account"
  #    for the application type.
  #
  # 4. Note the email address for your new client ID.
  #
  # 5. Save the private key someplace safe. You'll need to provide this key and
  #    the email address from step 4 everytime you authenticate with Numbers.
  #
  # 6. In the Team section, ensure your new service account has "Can view" or
  #    better permissions.
  #
  # 7. In the Google Analytics admin panel for your account, add a User with
  #    the email address from step 4. Give it access to the desired profile(s).
  #
  #
  # https://developers.google.com/accounts/docs/OAuth2ServiceAccount
  # https://developers.google.com/analytics/devguides/reporting/core/v2/gdataAuthentication
  class AuthToken
    def initialize(email, key)
      @email = email
      @key = OpenSSL::PKCS12.new(key, 'notasecret').key
    end

    # The actual token string. If the token has expired, it will be renewed.
    def to_s
      renew if expired?
      @token
    end

    # Forcibly expire this token.
    def expired!
      @token = @expires_at = nil
    end

    # Has this token expired?
    def expired?
      return true unless @expires_at and @token
      Time.now.utc + 10 > @expires_at
    end

  private
    def renew
      return if @renewing
      @renewing = true

      now = Time.now.utc
      claim = { 
        'iss'   => @email,
        'iat'   => now.to_i,
        'exp'   => now.to_i + 3600,
        'aud'   => 'https://accounts.google.com/o/oauth2/token',
        'scope' => 'https://www.googleapis.com/auth/analytics.readonly'
      }

      assertion = JWT.encode(claim, @key, 'RS256')
      response = Client.instance.request(:authentication, :assertion => assertion)

      @renewing = false
      @expires_at = Time.now.utc + response['expires_in']
      @token = response['access_token']
    end
  end
end