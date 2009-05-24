module VectorSpace
  class SimpleIndexedVector < SimpleVector
    include Family

    def initialize(attributes = {})
      if index_value = attributes[index] || reflect_on_component(index).default
        super attributes.merge(index => index_value)
      else
        raise ArgumentError, "must provide value for #{index} index or configure a default"
      end
    end

    private
      def describe_value(dimension)
        if describe = reflect_on_component(dimension).options[:describe]
          describe.to_proc.call(project(index), project(dimension))
        else
          super
        end
      end

    class << self
      def indexed_by(index, attributes = {})
        define_method (reflection = super(index, attributes)).getter do
          reflection.value(@attributes[index])
        end
      end
    end
  end
end
