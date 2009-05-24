module VectorSpace
  class ComponentReflection
    def initialize(component, options = {})
      @component, @options = component, options
    end

    def to_s
      "#{component} component (#{default.class})"
    end

    attr_reader :component, :options

    def getter
      options[:getter] || component.to_sym
    end

    def value(value)
      value ||= default

      if options[:coerce]
        options[:coerce].to_proc.call(value)
      else
        value
      end
    end
  end
end
