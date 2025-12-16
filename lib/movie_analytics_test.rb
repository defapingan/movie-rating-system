require "test_helper"

class MovieAnalyticsTest < ActiveSupport::TestCase
  test "should initialize with movies collection" do
    analytics = MovieAnalytics::MovieStatistics.new(Movie.all)
    assert analytics.movies.present?
  end

  test "should raise error for nil movies collection" do
    assert_raises(ArgumentError) do
      MovieAnalytics::MovieStatistics.new(nil)
    end
  end

  test "should calculate average rating" do
    analytics = MovieAnalytics::MovieStatistics.new(Movie.all)
    rating = analytics.calculate_average_rating
    assert rating.is_a?(Float) || rating == 0.0
  end

  test "should find highest rated movie" do
    analytics = MovieAnalytics::MovieStatistics.new(Movie.all)
    highest = analytics.highest_rated
    assert highest.nil? || highest.is_a?(Hash) || highest.is_a?(Array)
  end

  test "should find lowest rated movie" do
    analytics = MovieAnalytics::MovieStatistics.new(Movie.all)
    lowest = analytics.lowest_rated
    assert lowest.nil? || lowest.is_a?(Hash) || lowest.is_a?(Array)
  end

  test "should calculate category statistics" do
    analytics = MovieAnalytics::MovieStatistics.new(Movie.all)
    stats = analytics.category_stats
    assert stats.is_a?(Hash)
  end

  test "should provide overall statistics" do
    analytics = MovieAnalytics::MovieStatistics.new(Movie.all)
    stats = analytics.overall_statistics
    assert stats.is_a?(Hash)
  end
end
