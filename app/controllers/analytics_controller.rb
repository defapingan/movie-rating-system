# app/controllers/analytics_controller.rb
class AnalyticsController < ApplicationController
  def index
    @movies = Movie.all

    # Use our MovieAnalytics library
    analytics = MovieAnalytics::MovieStatistics.new(@movies)

    # Get statistics from library
    @stats = analytics.overall_statistics

    # Assign to instance variables for view
    @movies_count = @movies.count
    @average_rating = analytics.calculate_average_rating(precision: 1)

    # Category and country data
    @category_data = @movies.group(:category).count
    @country_data = @movies.group(:country).count

    @categories_count = @category_data.keys.count
    @countries_count = @country_data.keys.count

    # Rating distribution using library
    @rating_distribution = calculate_rating_distribution_with_library(analytics)

    # Year data
    @year_data = analytics.year_stats

    # Additional library-based statistics for view
    @highest_rated = analytics.highest_rated
    @lowest_rated = analytics.lowest_rated
    @rating_std_dev = analytics.calculate_rating_std_dev

    # For CSV export
    respond_to do |format|
      format.html
      format.csv do
        send_data analytics.to_csv,
                  filename: "movie-analytics-#{Date.today}.csv",
                  type: "text/csv"
      end
    end
  end

  # New action to demonstrate library functionality
  def advanced_analytics
    @movies = Movie.all
    analytics = MovieAnalytics::MovieStatistics.new(@movies)

    @predictions = {
      scifi_usa: analytics.predict_rating(category: "ScienceFiction", country: "United States"),
      drama_korea: analytics.predict_rating(category: "Drama", country: "South Korea"),
      comedy_uk: analytics.predict_rating(category: "Comedy", country: "United Kingdom")
    }

    # Get similar movies for a sample movie
    sample_movie = @movies.first
    @similar_movies = sample_movie ? analytics.find_similar_movies(sample_movie, limit: 3) : []

    # Rating distribution in custom buckets
    @custom_distribution = analytics.rating_distribution(
      buckets: [ 0..1, 1..2, 2..3, 3..4, 4..5 ]
    )
  end

  private

  def calculate_rating_distribution_with_library(analytics)
    distribution = {}

    ranges = {
      5 => (4.5..5.0),
      4 => (3.5...4.5),
      3 => (2.5...3.5),
      2 => (1.5...2.5),
      1 => (0.0...1.5)
    }

    total = @movies.where.not(average_rating: nil).count

    return distribution if total.zero?

    ranges.each do |stars, range|
      count = @movies.where(average_rating: range).count
      distribution[stars] = ((count.to_f / total) * 100).round(1)
    end

    distribution
  end
end
