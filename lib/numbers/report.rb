module Numbers
  class Report
    class << self
      # Create a new report and query the API.
      def query(params={})
        new(params).query(params)
      end
    end

    # Create a new report for a given profile, metrics, and dimensions.
    def initialize(params={})
      @profile_id = params[:profile_id]
      @profile_id = params[:profile].id if params[:profile]

      @metrics = Utils.prefix([params[:metrics]])
      @dimensions = Utils.prefix([params[:dimensions]])

      raise ArgumentError, 'You must supply at least one metric.' if @metrics.empty?
    end

    # Query the API for the given date range.
    def query(options={})
      response = Client.instance.request(:data,
        'start-date' => (options[:from] || '2012-01-01'),
        'end-date' => (options[:to] || Time.now.strftime('%Y-%m-%d')),
        'ids' => "ga:#{@profile_id}",
        'metrics' => @metrics.join(','),
        'dimensions' => @dimensions.join(','))
        

      headers = column_headers(response['columnHeaders'])
      group(response['rows'], headers)
    end

  private
    # Cast a value to the given type.
    def cast(value, type)
      case type
      when :string
        value
      when :integer
        value.to_i
      when :float
        value.to_f
      when :percent
        value.to_f
      when :currency
        BigDecimal(value)
      when :time
        value.to_i
      when :date
        value.to_i
      end
    end

    # Extract and cast column header information from the response.
    def column_headers(data)
      headers = { :types => [], :names => [] }

      data.map do |header|
        name = Utils.unprefix(header['name'])
        type = header['dataType'].downcase.to_sym
        type = :date if name == :date

        headers[:types] << type
        headers[:names] << name
      end

      headers
    end

    # Group the rows from the response by metric name, then by dimension value.
    def group(rows, headers={})
      data = {}
      
      rows.each do |row|
        row.each_with_index do |value, index| # metrics.each
          next if index < @dimensions.size

          name = headers[:names][index]
          value = cast(value, headers[:types][index])
          
          next data[name] = value if @dimensions.empty?
          scope = (data[name] ||= {})            

          row.each_with_index do |dimension, count| # dimensions.each
            next if count >= @dimensions.size

            dimension = cast(dimension, headers[:types][count])

            if count + 1 == @dimensions.size
              scope[dimension] = value
            else
              scope = (scope[dimension] ||= {})
            end
          end
        end
      end

      data
    end
  end
end