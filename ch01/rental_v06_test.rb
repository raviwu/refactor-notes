require_relative 'rental_v06'
require 'minitest/autorun'

class TestRental < Minitest::Test
  def setup
    @movie_paul = Movie.new(title: 'Paul', price_code: Movie::NEW_RELEASE)
    @movie_dory = Movie.new(title: 'Dory', price_code: Movie::CHILDRENS)
    @movie_seven = Movie.new(title: 'se7en', price_code: Movie::REGULAR)
  end

  def test_statement_empty_rental
    customer = Customer.new(name: 'Ravi Wu')
    expected_statement =
      header(customer.name) +
      footer(total: 0, renter_point: 0)

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_regular_rental_within_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      header(customer.name) +
      line_item(@movie_seven.title => 2) +
      footer(total: 2, renter_point: 1)

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_regular_rental_more_than_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 5))
    rental_cost = 2 + (5 - 2) * 1.5

    expected_statement =
      header(customer.name) +
      line_item(@movie_seven.title => rental_cost) +
      footer(total: rental_cost, renter_point: 1)

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_new_release
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_paul, days_rented: 2))

    # additional frequent point for new release
    expected_statement =
      header(customer.name) +
      line_item(@movie_paul.title => 6) +
      footer(total: 6, renter_point: 2)

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_children_within_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))

    expected_statement =
      header(customer.name) +
      line_item(@movie_dory.title => 1.5) +
      footer(total: 1.5, renter_point: 1)

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_children_more_than_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 5))
    rental_cost = 1.5 + (5 - 3) * 1.5

    expected_statement =
      header(customer.name) +
      line_item(@movie_dory.title => rental_cost) +
      footer(total: rental_cost, renter_point: 1)

    assert_equal(expected_statement, customer.statement)
  end

  def test_multi_rentals
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      header(customer.name) +
      line_item(@movie_dory.title => 1.5, @movie_seven.title => 2) +
      footer(total: 3.5, renter_point: 2)

    assert_equal(expected_statement, customer.statement)
  end

  def test_html_statement_empty_rental
    customer = Customer.new(name: 'Ravi Wu')
    expected_statement =
      html_header(customer.name) +
      html_footer(total: 0, renter_point: 0)

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_regular_rental_within_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      html_header(customer.name) +
      html_line_item(@movie_seven.title => 2) +
      html_footer(total: 2, renter_point: 1)

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_regular_rental_more_than_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 5))
    rental_cost = 2 + (5 - 2) * 1.5

    expected_statement =
      html_header(customer.name) +
      html_line_item(@movie_seven.title => rental_cost) +
      html_footer(total: rental_cost, renter_point: 1)

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_new_release
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_paul, days_rented: 2))

    # additional frequent point for new release
    expected_statement =
      html_header(customer.name) +
      html_line_item(@movie_paul.title => 6) +
      html_footer(total: 6, renter_point: 2)

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_children_within_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))

    expected_statement =
      html_header(customer.name) +
      html_line_item(@movie_dory.title => 1.5) +
      html_footer(total: 1.5, renter_point: 1)

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_children_more_than_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 5))
    rental_cost = 1.5 + (5 - 3) * 1.5

    expected_statement =
      html_header(customer.name) +
      html_line_item(@movie_dory.title => rental_cost) +
      html_footer(total: rental_cost, renter_point: 1)

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_multi_rentals
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      html_header(customer.name) +
      html_line_item(@movie_dory.title => 1.5, @movie_seven.title => 2) +
      html_footer(total: 3.5, renter_point: 2)

    assert_equal(expected_statement, customer.html_statement)
  end

  private

  def header(name)
    "Rental Record for #{name}\n"
  end

  def html_header(name)
    "<h1>Rental Record for <em>#{name}</em></h1><ul>\n"
  end

  def footer(total:, renter_point:)
    "Amount owed is #{total}\n" +
    "You earned #{renter_point} frequent renter points."
  end

  def html_footer(total:, renter_point:)
    "</ul><p>Amount owed is <em>#{total}</em></p>\n" +
    "<p>You earned <em>#{renter_point}</em> frequent renter points.</p>"
  end

  def line_item(rentals)
    rentals.map do |title, amount|
      "\t#{title}\t#{amount}\n"
    end.join
  end

  def html_line_item(rentals)
    rentals.map do |title, amount|
      "<li>#{title}: <em>#{amount}</em></li>\n"
    end.join
  end
end
