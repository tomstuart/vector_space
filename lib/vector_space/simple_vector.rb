module VectorSpace
  class SimpleVector
    include Enumerable
    include VectorSpace
    def_delegators :'self.class', :description_prefix, :description_suffix, :description_separator, :zero_description

    def initialize(attributes = {})
      @attributes = attributes
    end

    def to_s
      if zero? && zero_description
        zero_description
      else
        [
          description_prefix,
          dimensions.map { |dimension| describe_value(dimension) }.compact.join(description_separator),
          description_suffix
        ].join
      end
    end

    def inspect
      to_s
    end

    def [](component)
      project(component)
    end

    def each
      dimensions.each do |dimension| yield [dimension, project(dimension)] end
    end

    private
      def describe_value(dimension)
        if describe = reflect_on_component(dimension).options[:describe]
          describe.to_proc.call(project(dimension))
        else
          project(dimension)
        end
      end

    class << self
      attr_reader :description_prefix, :description_suffix, :zero_description

      def has_dimension(dimension, attributes = {})
        define_method (reflection = super(dimension, attributes)).getter do
          reflection.value(@attributes[dimension])
        end
      end

      def has_description_prefix(description_prefix)
        @description_prefix = description_prefix
      end

      def has_description_suffix(description_suffix)
        @description_suffix = description_suffix
      end

      def has_description_separator(description_separator)
        @description_separator = description_separator
      end

      def has_zero_description(zero_description)
        @zero_description = zero_description
      end

      def description_separator
        @description_separator || ' and '
      end
    end
  end
end
