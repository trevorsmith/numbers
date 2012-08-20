module Numbers
  module Utils
    extend self

    PREFIX = 'ga:'

    def prefix(value)
      if Array === value
        return value.flatten.compact.map { |v| prefix(v) }
      end

      value = value.to_s
      return value if value =~ /^#{PREFIX}/

      value = value.gsub(/(?:^|_)(.)/) { $1.upcase }
      value[0] = value[0,1].downcase
      "#{PREFIX}#{value}"
    end

    def unprefix(value)
      if Array === value
        return value.flatten.compact.map { |v| unprefix(v) }
      end

      value = value.to_s.sub(/^#{PREFIX}/, '')
      value = value.gsub(/([A-Z])/, '_\1')
      value.downcase.to_sym
    end
  end
end