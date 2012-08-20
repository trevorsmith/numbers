module Numbers
  # Represents a Google Analytics account.
  # https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts
  class Account
    # The account ID.
    attr_reader :id

    # The account name.
    attr_reader :name

    # Link to the account.
    attr_reader :link

    
    class << self
      # Retrieve all accounts to which the current user has access.
      def all
        @all ||= Client.instance.request(:accounts)['items'].map do |attributes|
          new(attributes)
        end
      end

      # Find an account by ID.
      def find(id)
        all.find { |account| account.id == id }
      end
    end


    def initialize(attributes={})
      @id = attributes['id'].to_i
      @name = attributes['name']
      @link = attributes['selfLink']
    end

    # Retrieve all web properties associated with this account.
    def web_properties
      WebProperty.all(:account => self)
    end
  end
end