# test/system/movies_test.rb
require "application_system_test_case"

class MoviesTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    @movie = movies(:one)
    @user = users(:one) if defined?(users(:one))
  end

  test "visiting the index" do
    visit movies_url
    assert_selector "h1", text: "Movie Rating System"
    assert_selector ".movie-card", minimum: 1
  end

  test "creating a movie" do
    visit movies_url
    click_on "Add Movie"

    fill_in "Title", with: "System Test Movie"
    select "ScienceFiction", from: "Category"
    select "United States", from: "Country"
    fill_in "Release Year", with: "2024"
    fill_in "rating (0-5)", with: "4.5"
    fill_in "Description", with: "A movie created during system testing"

    click_on "Create Movie"

    assert_text "Movie was successfully created."
    assert_selector ".movie-card", text: "System Test Movie"
  end

  test "viewing a movie" do
    visit movie_url(@movie)
    assert_text @movie.title
    assert_text @movie.category
    assert_text @movie.country
    assert_text @movie.release_year.to_s
  end

  test "updating a movie" do
    visit movies_url
    click_on "Edit", match: :first

    fill_in "Title", with: "Updated System Test Movie"
    click_on "Update Movie"

    assert_text "Movie was successfully updated."
    assert_selector ".movie-card", text: "Updated System Test Movie"
  end

  test "filtering movies" do
    # Create test movies with different categories
    Movie.create!(title: "Action Movie", category: "ScienceFiction", country: "USA", release_year: 2023, average_rating: 4.5)
    Movie.create!(title: "Comedy Movie", category: "Comedy", country: "UK", release_year: 2023, average_rating: 3.5)

    visit movies_url

    # Count initial movies
    initial_count = all(".movie-item").count

    # Filter by category
    select "ScienceFiction", from: "select category"

    # Wait for filtering (JavaScript)
    sleep 0.5

    # Should show only ScienceFiction movies
    assert_selector '.movie-item[data-category="ScienceFiction"]', minimum: 1
    assert_no_selector '.movie-item[data-category="Comedy"]', visible: true

    # Clear filter
    select "all the class", from: "select category"
    sleep 0.5

    # Should show all movies again
    assert_equal initial_count, all(".movie-item").count
  end

  test "visiting analytics page" do
    visit analytics_path

    assert_text "Data Analytics"
    assert_selector ".stat-card", count: 4
    assert_selector ".chart-container", count: 4

    # Verify charts are rendered
    assert_selector "#categoryChart"
    assert_selector "#countryChart"
    assert_selector "#ratingChart"
    assert_selector "#yearChart"
  end

  test "search functionality" do
    visit movies_url

    # This would test search if implemented
    # fill_in 'search', with: @movie.title
    # click_on 'Search'
    # assert_selector '.movie-card', text: @movie.title
  end
end
