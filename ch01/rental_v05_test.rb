require_relative 'rental_v05'
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
      "Rental Record for Ravi Wu\n" +
      "Amount owed is 0\n" +
      "You earned 0 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_regular_rental_within_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      "Rental Record for Ravi Wu\n" +
      "\tse7en\t2\n" +
      "Amount owed is 2\n" +
      "You earned 1 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_regular_rental_more_than_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 5))
    rental_cost = 2 + (5 - 2) * 1.5

    expected_statement =
      "Rental Record for Ravi Wu\n" +
      "\tse7en\t#{rental_cost}\n" +
      "Amount owed is #{rental_cost}\n" +
      "You earned 1 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_new_release
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_paul, days_rented: 2))

    # additional frequent point for new release
    expected_statement =
      "Rental Record for Ravi Wu\n" +
      "\tPaul\t6\n" +
      "Amount owed is 6\n" +
      "You earned 2 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_children_within_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))

    expected_statement =
      "Rental Record for Ravi Wu\n" +
      "\tDory\t1.5\n" +
      "Amount owed is 1.5\n" +
      "You earned 1 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_statement_children_more_than_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 5))
    rental_cost = 1.5 + (5 - 3) * 1.5

    expected_statement =
      "Rental Record for Ravi Wu\n" +
      "\tDory\t#{rental_cost}\n" +
      "Amount owed is #{rental_cost}\n" +
      "You earned 1 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_multi_rentals
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      "Rental Record for Ravi Wu\n" +
      "\tDory\t1.5\n" +
      "\tse7en\t2\n" +
      "Amount owed is 3.5\n" +
      "You earned 2 frequent renter points."

    assert_equal(expected_statement, customer.statement)
  end

  def test_html_statement_empty_rental
    customer = Customer.new(name: 'Ravi Wu')
    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "</ul><p>Amount owed is <em>0</em></p>\n" +
      "<p>You earned <em>0</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_regular_rental_within_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "<li>se7en: <em>2</em></li>\n" +
      "</ul><p>Amount owed is <em>2</em></p>\n" +
      "<p>You earned <em>1</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_regular_rental_more_than_2_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 5))
    rental_cost = 2 + (5 - 2) * 1.5

    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "<li>se7en: <em>#{rental_cost}</em></li>\n" +
      "</ul><p>Amount owed is <em>#{rental_cost}</em></p>\n" +
      "<p>You earned <em>1</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_new_release
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_paul, days_rented: 2))

    # additional frequent point for new release
    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "<li>Paul: <em>6</em></li>\n" +
      "</ul><p>Amount owed is <em>6</em></p>\n" +
      "<p>You earned <em>2</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_children_within_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))

    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "<li>Dory: <em>1.5</em></li>\n" +
      "</ul><p>Amount owed is <em>1.5</em></p>\n" +
      "<p>You earned <em>1</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_statement_children_more_than_3_days
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 5))
    rental_cost = 1.5 + (5 - 3) * 1.5

    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "<li>Dory: <em>#{rental_cost}</em></li>\n" +
      "</ul><p>Amount owed is <em>#{rental_cost}</em></p>\n" +
      "<p>You earned <em>1</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end

  def test_html_multi_rentals
    customer = Customer.new(name: 'Ravi Wu')
    customer.add_rental(Rental.new(movie: @movie_dory, days_rented: 2))
    customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

    expected_statement =
      "<h1>Rental Record for <em>Ravi Wu</em></h1><ul>\n" +
      "<li>Dory: <em>1.5</em></li>\n" +
      "<li>se7en: <em>2</em></li>\n" +
      "</ul><p>Amount owed is <em>3.5</em></p>\n" +
      "<p>You earned <em>2</em> frequent renter points.</p>"

    assert_equal(expected_statement, customer.html_statement)
  end
end
