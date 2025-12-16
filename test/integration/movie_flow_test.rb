require "test_helper"

class MovieFlowTest < ActionDispatch::IntegrationTest
  test "should get movies index" do
    get movies_url
    assert_response :success
    assert_select "h1", "Movie Rating System"
  end

  test "should get new movie form" do
    get new_movie_url
    assert_response :success
    assert_select "h1", "Add new movie"
  end

  test "should get edit movie form" do
    movie = movies(:one)
    get edit_movie_url(movie)
    assert_response :success
    assert_select "h1", "Edit movie"
  end

  test "should access analytics page" do
    get analytics_path
    assert_response :success
    assert_select "h1", "Data Analytics"
  end

  test "should show movie" do
    movie = movies(:one)
    get movie_url(movie)
    assert_response :success
    assert_select "h1", movie.title
  end
end
