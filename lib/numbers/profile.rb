module Numbers
  # Represents a Google Analytics profile.
  # https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles
  class Profile
    # The profile ID.
    attr_reader :id

    # Name of the profile.
    attr_reader :name

    # Link to the profile.
    attr_reader :link

    # Account ID to which the profile belongs.
    attr_reader :account_id

    # Web property ID of the form UA-XXXXX-YY to which the profile belongs.
    attr_reader :web_property_id

    # Internal ID for the web property to which the profile belongs.
    attr_reader :internal_id


    class << self
      # Retrieve all profiles to which the current user has acccess.
      def all(params={})
        @all ||= {}

        params = setup_query(params)
        return @all[params] if @all[params]

        if response = Client.instance.request(:profiles, params)
          items = response['items'].map do |item|
            item.merge!(:account => params[:account], :web_property => params[:web_property])
            new(item)
          end
        end

        @all[params] = items || []
      end

      # Find a profile by ID.
      def find(id)
        all.find { |profile| profile.id == id }
      end

    private
      #:nodoc:
      def setup_query(params)
        params[:account_id] = params[:account].id if params[:account]
        params[:web_property_id] = params[:web_property].id if params[:web_property]

        if params[:web_property_id] and not params[:account_id]
          raise ArgumentError, 'You must specify an :account or :account_id to find a profile by ID'
        end
        
        params[:account_id] ||= '~all'
        params[:web_property_id] ||= '~all'
        params
      end
    end


    def initialize(attributes={})
      @id = attributes['id'].to_i
      @name = attributes['name']
      @link = attributes['selfLink']
      @account = attributes[:account]
      @account_id = attributes['accountId'].to_i
      @web_property = attributes[:web_property]
      @web_property_id = attributes['webPropertyId']
    end

    # The account associated with this profile.
    def account
      @account ||= Account.find(@account_id)
    end

    # The web property associated with this profile.
    def web_property
      @web_property ||= WebProperty.find(@web_property_id)
    end
  end
end