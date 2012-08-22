module Numbers
  # Performs the actual requests to the Google Analytics API.
  #
  # Most actions require an OAuth 2.0 token, which can be a string or a
  # string-like object (see Numbers::AuthToken):
  #
  #   Numbers.token = '1/A1bcde2FgH3iJK4LMnoPQrST5678uVWxyZa9bcd012E'
  #   Numbers.token = Numbers::AuthToken.new(email, private_key)
  #
  class Client
    include Singleton

    # A valid OAuth 2.0 token.
    attr_accessor :token

    # Query the Google Analytics API with the given parameters.
    # A list of valid actions and their parameters can be found in the README.
    def request(action, params={})
      retried = true

      begin
        response = HTTParty.send(*request_arguments(action, params))
        validate response

      rescue RequestError => e
        if e.invalid_token? and @token.respond_to?(:expired!) and not retried
          @token.expired!
          retried = true
          retry
        end

        return if e.not_found?
        raise 
      end
    end

  private
    # If the request was invalid or otherwise unsuccessful, throw an error.
    def validate(response)
      unless response.code == 200
        message = response.parsed_response
        message = message['error']   if message.respond_to?(:has_key?) and message.has_key?('error')
        message = message['message'] if message.respond_to?(:has_key?) and message.has_key?('message')
        raise RequestError.new(message, response.code)
      end

      response
    end

    #:nodoc:
    def headers
      { 'Authorization' => "Bearer #{@token}" } if @token
    end

    #:nodoc:
    def request_arguments(action, params={})
      unless options = API_ACTIONS[action]
        raise ArgumentError, "#{action} is not a valid action."
      end
      
      url = options[:url]
      url = url.call(params) if url.respond_to?(:call)

      method = options[:method] || :get
      params = options[:params].merge(params) if options[:params]
      params = { PARAMS_KEY[method] => params, :headers => headers }

      [method, url, params]
    end
  end


  # Represents an invalid or otherwise unsuccessful request.
  #
  # See the API documentation for a list of possible error codes:
  # https://developers.google.com/analytics/devguides/reporting/core/v3/coreErrors
  class RequestError < Exception
    attr_reader :code

    def initialize(message, code)
      @code = code
      super "#{@code} #{message}"
    end

    # Was the supplied token invalid or expired?
    def invalid_token?
      @code == 401
    end

    # Was the requested item not found or inaccessible?
    def not_found?
      @code == 403 or @code == 404
    end
  end

  # The key for a given method to use for passing parameters.
  PARAMS_KEY = {
    :get => :query,
    :post => :body
  }

  # The valid actions and their default parameters.
  API_ACTIONS = {
    :accounts => {
      :url => 'https://www.googleapis.com/analytics/v3/management/accounts',
      :params => { :fields => 'items(id,name,selfLink)' }
    },
    :authentication => {
      :url => 'https://accounts.google.com/o/oauth2/token',
      :method => :post,
      :params => { :grant_type => 'urn:ietf:params:oauth:grant-type:jwt-bearer' }
    },
    :data => {
      :url => 'https://www.googleapis.com/analytics/v3/data/ga',
      :params => { 'max-results' => 10000, 'fields' => 'columnHeaders(name,dataType),rows' }
    },
    :profiles => {
      :url => lambda { |o| "https://www.googleapis.com/analytics/v3/management/accounts/#{o[:account_id]}/webproperties/#{o[:web_property_id]}/profiles" },
      :params => { :fields => 'items(id,name,selfLink,accountId,webPropertyId)' }
    },
    :web_properties => {
      :url => lambda { |o| "https://www.googleapis.com/analytics/v3/management/accounts/#{o[:account_id]}/webproperties" },
      :params => { :fields => 'items(id,name,selfLink,websiteUrl,accountId,internalWebPropertyId)' }
    }
  }
end