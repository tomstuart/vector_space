module VectorSpace
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    attr_reader :dimensions

    def components
      dimensions
    end

    def reflect_on_component(component)
      @component_reflections[component]
    end

    def zero
      new Hash[dimensions.map { |dimension| [dimension, reflect_on_component(dimension).zero] }]
    end

    def order
      @order || :product
    end

    private
      def has_dimension(dimension, options = {})
        (@dimensions ||= []) << dimension
        (@component_reflections ||= {})[dimension] = DimensionReflection.new(dimension, options)
      end

      def has_order(order)
        @order = order
      end
  end

  module InstanceMethods
    def self.included(base)
      base.class_eval do
        extend Forwardable
        def_delegators :'self.class', :components, :dimensions, :order, :reflect_on_component

        include PartialOrder
        include Arithmetic
      end
    end

    def project(component)
      reflection = reflect_on_component(component)
      reflection.value(send(reflection.getter))
    end

    def map_components(components, *vectors)
      Array(components).map { |component| [component, yield(*([self] + vectors).map { |vector| vector.project(component) })] }
    end

    def map_values(components, *vectors, &block)
      map_components(components, *vectors, &block).map { |component, value| value }
    end

    def zero?
      map_values(dimensions) { |value| value.zero? }.all?
    end

    # Decides whether the receiver is compatible with some other object for general operations (e.g. arithmetic and comparison).
    def compatible_with?(other)
      other.class == self.class
    end

    # Compares the receiver against another object, returning -1, 0, +1 or nil depending on whether the receiver is less than,
    # equal to, greater than, or incomparable with the other object.
    # This works just like the #<=> expected by Comparable, but also returns nil iff the two objects are incomparable.
    def <=>(other)
      if compatible_with?(other)
        comparisons = map_values(dimensions, other) { |a, b| a <=> b }

        case order
        when :product
          comparisons.inject { |a, b| a + b if a && b && a * b >= 0 }
        when :lexicographic
          comparisons.inject { |a, b| a == 0 ? b : a }
        end
      end
    end

    def eql?(other)
      map_values(components, other) { |a, b| a.eql?(b) }.all?
    end

    def hash
      map_values(components) { |value| value }.hash
    end

    private
      def operate_on_values(*vectors, &block)
        self.class.new Hash[map_components(dimensions, *vectors, &block)]
      end
  end
end
