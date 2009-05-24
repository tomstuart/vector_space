module VectorSpace
  module Family
    def self.included(base)
      base.class_eval do
        include VectorSpace
        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      attr_reader :index

      def indexed_by(index, options = {})
        @index = index
        (@component_reflections ||= {})[index] = IndexReflection.new(index, options)
      end

      def components
        [index] + super
      end

      def zero(attributes = {})
        new Hash[*([index, attributes[index] || reflect_on_component(index).default] + dimensions.map { |dimension| [dimension, reflect_on_component(dimension).zero] }).flatten]
      end
    end

    module InstanceMethods
      def self.included(base)
        base.class_eval do
          def_delegator :'self.class', :index
        end
      end

      def compatible_with?(other)
        super && project(index) == other.project(index)
      end

      private
        def operate_on_values(*vectors, &block)
          self.class.new Hash[*(map_components(index, *vectors) { |*values| values.inject { |a, b| a if a == b } } + map_components(dimensions, *vectors, &block)).flatten]
        end
    end
  end
end
