VectorSpace
===========

A Ruby library for treating multidimensional values as elements of a vector space.

Examples
--------

A simple vector space:

    class Round < VectorSpace::SimpleVector
      has_dimension :hoegaarden
      has_dimension :franziskaner
      has_dimension :fruli
      has_dimension :water
    end

    >> Round.new
    => 0 and 0 and 0 and 0

    >> Round.new :hoegaarden => 5, :fruli => 3
    => 5 and 0 and 3 and 0

With custom descriptions:

    class Round < VectorSpace::SimpleVector
      has_dimension :hoegaarden,    :describe => lambda { |n| "#{n} Hoegaardens" unless n.zero? }
      has_dimension :franziskaner,  :describe => lambda { |n| "#{n} Franziskaners" unless n.zero? }
      has_dimension :fruli,         :describe => lambda { |n| "#{n} Frülis" unless n.zero? }
      has_dimension :water,         :describe => lambda { |n| "#{n} waters" unless n.zero? }
      has_zero_description 'no drinks'
    end

    >> Round.new
    => no drinks

    >> Round.new :hoegaarden => 5, :fruli => 3
    => 5 Hoegaardens and 3 Frülis

    >> Round.new(:hoegaarden => 2, :franziskaner => 3) + Round.new(:water => 2, :fruli => 2, :hoegaarden => 1)
    => 3 Hoegaardens and 3 Franziskaners and 2 Frülis and 2 waters

    >> (Round.new(:hoegaarden => 2, :franziskaner => 3) * 2) - Round.new(:hoegaarden => 1)
    => 3 Hoegaardens and 6 Franziskaners

An indexed family of vector spaces with custom descriptions:

    class Cocktail < VectorSpace::SimpleIndexedVector
      indexed_by :units
      has_dimension :gin,       :describe => lambda { |units, n| "#{n}#{units} gin" unless n.zero? }
      has_dimension :vermouth,  :describe => lambda { |units, n| "#{n}#{units} vermouth" unless n.zero? }
      has_dimension :whisky,    :describe => lambda { |units, n| "#{n}#{units} whisky" unless n.zero? }
      has_dimension :vodka,     :describe => lambda { |units, n| "#{n}#{units} vodka" unless n.zero? }
      has_dimension :kahlua,    :describe => lambda { |units, n| "#{n}#{units} Kahlúa" unless n.zero? }
      has_dimension :cream,     :describe => lambda { |units, n| "#{n}#{units} cream" unless n.zero? }
    end

    >> martini = Cocktail.new :units => :cl, :gin => 5.5, :vermouth => 1.5
    => 5.5cl gin and 1.5cl vermouth

    >> manhattan = Cocktail.new :units => :cl, :whisky => 5, :vermouth => 2
    => 2cl vermouth and 5cl whisky

    >> white_russian = Cocktail.new :units => :oz, :vodka => 2, :kahlua => 1, :cream => 1.5
    => 2oz vodka and 1oz Kahlúa and 1.5oz cream

    >> martini * 2
    => 11cl gin and 3cl vermouth

    >> martini + manhattan
    => 5.5cl gin and 3.5cl vermouth and 5cl whisky

    >> martini + white_russian
    ArgumentError: can't add 5.5cl gin and 1.5cl vermouth to 2oz vodka and 1oz Kahlúa and 1.5oz cream

A real (one-dimensional) example:

    class Money < VectorSpace::SimpleIndexedVector
      indexed_by :currency, :default => Currency::GBP
      has_dimension :cents,
        :coerce   => lambda { |n| n.round }, # or just :coerce => :round if you have Symbol#to_proc
        :describe => lambda { |currency, cents| "#{currency.symbol}#{cents / 100}.#{sprintf('%02d', cents % 100)}" }
    end

    >> a = Money.new(:currency => Currency::GBP, :cents => 9900)
    => £99.00

    >> b = Money.new(:currency => Currency::GBP, :cents => 1500)
    => £15.00

    >> a < b
    => false

    >> a > b
    => true

    >> a + b
    => £114.00

    >> c = Money.new(:currency => Currency::USD, :cents => 99)
    => $0.99

    >> a < c
    => false

    >> c < a
    => false

    >> a + c
    ArgumentError: can't add $0.99 to £99.00
