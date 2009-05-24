module VectorSpace
  class DimensionReflection < ComponentReflection
    def zero
      @options[:zero] || 0
    end

    def default
      zero
    end
  end
end
