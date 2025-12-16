# test/system/movies_test.rb
require "application_system_test_case"

class MovieTest < ActiveSupport::TestCase
  setup do
    @movie = movies(:one)
  end

  test "movie model exists" do
    assert Movie
  end

  test "movie has required constants" do
    assert Movie::CATEGORIES
    assert Movie::COUNTRIES
    assert Movie::CATEGORIES.include?("ScienceFiction")
    assert Movie::COUNTRIES.include?("United States")
  end

  test "movie has search method" do
    assert_respond_to Movie, :search
  end

  test "search returns activerecord relation" do
    results = Movie.search("test")
    assert results.is_a?(ActiveRecord::Relation)
  end

  test "fixture is valid" do
    assert @movie.valid?
  end

  test "can create valid movie" do
    movie = Movie.new(
      title: "Valid Movie",
      category: "ScienceFiction",
      country: "United States",
      release_year: 2023,
      average_rating: 4.5
    )
    assert movie.valid?
  end

  test "allows nil rating" do
    movie = Movie.new(
      title: "Movie Without Rating",
      category: "ScienceFiction",
      country: "United States",
      release_year: 2023,
      average_rating: nil
    )
    assert movie.valid?
  end

  test "requires title" do
    movie = Movie.new(
      category: "ScienceFiction",
      country: "United States",
      release_year: 2023
    )
    assert_not movie.valid?
    assert_includes movie.errors[:title], "can't be blank"
  end

  test "requires valid category" do
    movie = Movie.new(
      title: "Test Movie",
      category: "InvalidCategory",
      country: "United States",
      release_year: 2023
    )
    assert_not movie.valid?
  end

  test "requires valid country" do
    movie = Movie.new(
      title: "Test Movie",
      category: "ScienceFiction",
      country: "InvalidCountry",
      release_year: 2023
    )
    assert_not movie.valid?
  end
end
