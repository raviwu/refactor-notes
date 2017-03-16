# price
class Price
  def calculate_amount(days_rented)
    base_amount + days_rented_based_amount(days_rented)
  end

  def calculate_frequent_rental_points(days_rented)
    add_bonus_rental_point?(days_rented) ? 2 : 1
  end

  private

  def add_bonus_rental_point?(*)
    raise '#add_bonus_rental_point? not yet implemented.'
  end

  def day_rent_base_amount
    raise '@day_rent_base_amount not yet assigned.' unless @day_rent_base_amount
    @day_rent_base_amount
  end

  def day_rent_calculate_base_reduction
    raise '@day_rent_calculate_base_reduction not yet assigned.' unless @day_rent_calculate_base_reduction
    @day_rent_calculate_base_reduction
  end

  def days_rented_based_amount(days_rented)
    calculate_rent_days(days_rented) * day_rent_base_amount
  end

  def calculate_rent_days(days_rented)
    calculate_rent_days = days_rented - day_rent_calculate_base_reduction
    calculate_rent_days > 0 ? calculate_rent_days : 0
  end

  def base_amount
    raise '@base_amount not yet assigned.' unless @base_amount
    @base_amount
  end
end

# children price
class ChildrenPrice < Price
  def initialize
    super
    @base_amount = 1.5
    @day_rent_base_amount = 1.5
    @day_rent_calculate_base_reduction = 3
  end

  private

  def add_bonus_rental_point?(*)
    false
  end
end

# regular price
class RegularPrice < Price
  def initialize
    super
    @base_amount = 2.0
    @day_rent_base_amount = 1.5
    @day_rent_calculate_base_reduction = 2
  end

  private

  def add_bonus_rental_point?(*)
    false
  end
end

# new release price
class NewReleasePrice < Price
  def initialize
    super
    @base_amount = 0.0
    @day_rent_base_amount = 3.0
    @day_rent_calculate_base_reduction = 0
  end

  private

  def add_bonus_rental_point?(days_rented)
    days_rented > 1
  end
end

# movie
class Movie
  attr_reader :title, :price

  def initialize(opts = {})
    @title = opts[:title]
    @price = opts[:price]
  end

  def calculate_amount(days_rented)
    price.calculate_amount(days_rented)
  end

  def calculate_frequent_rental_points(days_rented)
    price.calculate_frequent_rental_points(days_rented)
  end
end

# rental
class Rental
  attr_reader :movie, :days_rented

  def initialize(opts)
    @movie = opts[:movie]
    @days_rented = opts[:days_rented]
  end

  def amount
    movie.calculate_amount(days_rented)
  end

  def frequent_rental_points
    movie.calculate_frequent_rental_points(days_rented)
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
    result = "Rental Record for #{name}\n"

    rentals.each do |rental|
      result += "\t#{rental.movie.title}\t#{rental.amount}\n"
    end

    result += "Amount owed is #{total_charge}\n"
    result += "You earned #{total_rental_points} frequent renter points."
    result
  end

  def html_statement
    result = "<h1>Rental Record for <em>#{name}</em></h1><ul>\n"

    rentals.each do |rental|
      result += "<li>#{rental.movie.title}: <em>#{rental.amount}</em></li>\n"
    end

    result += "</ul><p>Amount owed is <em>#{total_charge}</em></p>\n"
    result += "<p>You earned <em>#{total_rental_points}</em> frequent renter points.</p>"
    result
  end

  private

  def total_charge
    rentals.inject(0) do |sum, rental|
      sum += rental.amount
    end
  end

  def total_rental_points
    rentals.inject(0) do |sum, rental|
      sum += rental.frequent_rental_points
    end
  end
end
