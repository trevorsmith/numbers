module Numbers
  class WebProperty
    # ID of the web property of the form UA-XXXXX-YY
    attr_reader :id

    # Name of the web property.
    attr_reader :name

    # Link to the web property.
    attr_reader :link

    # Link to the admin panel for the web property.
    attr_reader :website_url

    # Account ID to which the web property belongs.
    attr_reader :account_id

    # Internal ID for the web property.
    attr_reader :internal_id

    class << self
      # Retrieve all web properties to which the current user has access.
      def all(params={})
        @all ||= {}

        params = setup_query(params)
        return @all[params] if @all[params]

        if response = Client.instance.request(:web_properties, params)
          items = response['items'].map do |item|
            item.merge!(:account => params[:account])
            new(item)
          end
        end

        @all[params] = items || []
      end

      # Find a web property by ID.
      def find(id)
        all.find { |web_property| web_property.id == id }
      end

    private
      #:nodoc:
      def setup_query(params)
        account_id = params[:account_id]
        account_id = params[:account].id if params[:account]
        account_id ||= '~all'
        { :account_id => account_id }
      end
    end

    

    def initialize(attributes={})
      @id = attributes['id']
      @name = attributes['name']
      @link = attributes['selfLink']
      @website_url = attributes['websiteUrl']
      @internal_id = attributes['internalWebPropertyId'].to_i
      @account = attributes[:account]
      @account_id = attributes['accountId'].to_i
    end

    # The account associated with this profile.
    def account
      @account ||= Account.find(@account_id)
    end

    def profiles
      Profile.all(:account => account, :web_property => self)
    end
  end
end