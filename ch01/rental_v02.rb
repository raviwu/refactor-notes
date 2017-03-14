# movie
class Movie
  CHILDRENS = 2
  REGULAR = 0
  NEW_RELEASE = 1

  attr_reader :title
  attr_accessor :price_code

  def initialize(opts = {})
    @title = opts[:title]
    @price_code = opts[:price_code]
  end
end

# rental
class Rental
  attr_reader :movie, :days_rented

  def initialize(opts)
    @movie = opts[:movie]
    @days_rented = opts[:days_rented]
  end
end

# customer
class Customer
  attr_reader :name, :rentals

  def initialize(opts = {})
    @name = opts[:name]
    @rentals = []
  end

  def add_rental(rental)
    @rentals << rental
  end

  def statement
    total_amount = 0
    frequent_rental_points = 0
    result = "Rental Record for #{name}\n"

    while rentals.size > 0
      each = rentals.shift

      this_amount = amount_for(each)

      # add frequent rental point
      frequent_rental_points += 1
      # add bonus for two day new release rental
      if each.movie.price_code == Movie::NEW_RELEASE && each.days_rented > 1
        frequent_rental_points += 1
      end

      # show figures for this rental
      result += "\t#{each.movie.title}\t#{this_amount}\n"
      total_amount += this_amount
    end

    # add footer lines
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_rental_points} frequent renter points."
    result
  end

  private

  def amount_for(rental)
    this_amount = 0

    case rental.movie.price_code
    when Movie::REGULAR
      this_amount += 2
      if rental.days_rented > 2
        this_amount += (rental.days_rented - 2) * 1.5
      end
    when Movie::NEW_RELEASE
      this_amount += rental.days_rented * 3
    when Movie::CHILDRENS
      this_amount += 1.5
      if rental.days_rented > 3
        this_amount += (rental.days_rented - 3) * 1.5
      end
    end

    this_amount
  end
end
