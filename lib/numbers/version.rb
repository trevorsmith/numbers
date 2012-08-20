module Numbers
  module Version
    MAJOR = 0
    MINOR = 9
    TINY  = 1

    class << self
      # :nodoc:
      def to_s
        [MAJOR, MINOR, TINY].join('.')
      end
    end
  end
end
