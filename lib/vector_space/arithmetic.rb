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

    # Scalar division (by multiplication)
    def /(n)
      self * (1.0 / n)
    end
  end
end
