module VectorSpace
  module PartialOrder
    # Ruby's Comparable isn't well-behaved for partial orders: its operations raise ArgumentError if #<=> returns nil.
    # This module provides operations which simply return false when two values are incomparable.

    [:<, :<=, :==, :>=, :>].each do |operation|
      define_method operation do |other|
        ((result = self <=> other) && result.send(operation, 0)) == true
      end
    end

    def comparable_with?(other)
      !(self <=> other).nil?
    end
  end
end
