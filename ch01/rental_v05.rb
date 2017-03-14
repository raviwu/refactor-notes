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

  def amount
    @amount ||= calculate_amount
  end

  def frequent_rental_points
    add_bonus_rental_point? ? 2 : 1
  end

  private

  def calculate_amount
    @amount = 0

    case movie.price_code
    when Movie::REGULAR
      @amount += 2
      if days_rented > 2
        @amount += (days_rented - 2) * 1.5
      end
    when Movie::NEW_RELEASE
      @amount += days_rented * 3
    when Movie::CHILDRENS
      @amount += 1.5
      if days_rented > 3
        @amount += (days_rented - 3) * 1.5
      end
    end

    @amount
  end

  def add_bonus_rental_point?
    movie.price_code == Movie::NEW_RELEASE && days_rented > 1
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
      # show figures for this rental
      result += "\t#{rental.movie.title}\t#{rental.amount}\n"
    end

    # add footer lines
    result += "Amount owed is #{total_charge}\n"
    result += "You earned #{total_rental_points} frequent renter points."
    result
  end

  def html_statement
    result = "<h1>Rental Record for <em>#{name}</em></h1><ul>\n"

    rentals.each do |rental|
      # show figures for this rental
      result += "<li>#{rental.movie.title}: <em>#{rental.amount}</em></li>\n"
    end

    # add footer lines
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
