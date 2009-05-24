module VectorSpace
  # These operations depend only upon addition and multiplication of the underlying values, so work in a vector space
  module Arithmetic
    # Vector addition
    def +(vector)
      if compatible_with?(vector)
        operate_on_values(vector) { |a, b| a + b }
      else
        raise ArgumentError, "can't add #{vector.inspect} to #{self.inspect}"
      end
    end

    # Scalar multiplication
    def *(n)
      operate_on_values { |value| value * n }
    end

    # Additive inverse
    def -@
      operate_on_values { |value| -value }
    end

    # Vector subtraction (by addition)
    def -(vector)
      self + (-vector)
    end

    def /(divisor)
      if divisor.zero?
        raise ZeroDivisionError
      else
        if divisor.is_a?(Numeric)
          # Scalar division (by multiplication)
          self * (1.0 / divisor)
        elsif compatible_with?(divisor)
          # Vector division
          map_values(dimensions.reject { |dimension| divisor.project(dimension).zero? }, divisor) { |a, b| a / b }.min
        else
          raise ArgumentError, "can't divide #{self.inspect} by #{divisor.inspect}"
        end
      end
    end
  end
end
