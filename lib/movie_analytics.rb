# app/lib/movie_analytics.rb
# Movie Analytics Library
# This library provides advanced analytics and data processing functions for movies
# Author: [Your Name]
# Created: [Date]

module MovieAnalytics
  # MovieStatistics class provides statistical analysis for movie collections
  class MovieStatistics
    attr_reader :movies

    # Initialize with a collection of movies
    # @param movies [ActiveRecord::Relation] collection of Movie objects
    def initialize(movies)
      @movies = movies
      validate_movies_collection
    end

    # Calculate overall statistics for the movie collection
    # @return [Hash] statistics including count, average rating, etc.
    def overall_statistics
      {
        total_movies: total_count,
        average_rating: calculate_average_rating,
        rating_standard_deviation: calculate_rating_std_dev,
        highest_rated_movie: highest_rated,
        lowest_rated_movie: lowest_rated,
        category_distribution: category_stats,
        year_distribution: year_stats
      }
    end

    # Calculate average rating with precision
    # @param precision [Integer] decimal precision
    # @return [Float] average rating
    def calculate_average_rating(precision: 2)
      rated_movies = @movies.where.not(average_rating: nil)
      return 0.0 if rated_movies.empty?

      total = rated_movies.sum(:average_rating)
      count = rated_movies.count

      (total.to_f / count).round(precision)
    end

    # Calculate standard deviation of ratings
    # @return [Float] standard deviation
    def calculate_rating_std_dev
      rated_movies = @movies.where.not(average_rating: nil)
      return 0.0 if rated_movies.count <= 1

      ratings = rated_movies.pluck(:average_rating)
      mean = ratings.sum.to_f / ratings.size

      sum_of_squares = ratings.sum { |rating| (rating - mean) ** 2 }
      variance = sum_of_squares / (ratings.size - 1)

      Math.sqrt(variance).round(3)
    end

    # Find the highest rated movie(s)
    # @return [Hash] movie details or array if ties
    def highest_rated
      max_rating = @movies.maximum(:average_rating)
      return nil unless max_rating

      top_movies = @movies.where(average_rating: max_rating)

      if top_movies.count == 1
        format_movie_stats(top_movies.first)
      else
        top_movies.map { |movie| format_movie_stats(movie) }
      end
    end

    # Find the lowest rated movie(s)
    # @return [Hash] movie details or array if ties
    def lowest_rated
      min_rating = @movies.where.not(average_rating: nil).minimum(:average_rating)
      return nil unless min_rating

      bottom_movies = @movies.where(average_rating: min_rating)

      if bottom_movies.count == 1
        format_movie_stats(bottom_movies.first)
      else
        bottom_movies.map { |movie| format_movie_stats(movie) }
      end
    end

    # Get category statistics
    # @return [Hash] count and percentage for each category
    def category_stats
      categories = @movies.group(:category).count
      total = categories.values.sum

      categories.transform_values do |count|
        {
          count: count,
          percentage: total > 0 ? ((count.to_f / total) * 100).round(2) : 0
        }
      end
    end

    # Get year statistics
    # @return [Hash] count by release year
    def year_stats
      @movies.group(:release_year)
             .order(:release_year)
             .count
             .transform_keys(&:to_i)
    end

    # Calculate rating distribution in buckets
    # @param buckets [Array<Range>] rating ranges
    # @return [Hash] count per bucket
    def rating_distribution(buckets: [ 0..1, 1..2, 2..3, 3..4, 4..5 ])
      distribution = {}

      buckets.each do |bucket|
        count = @movies.where(average_rating: bucket).count
        distribution[bucket] = count
      end

      distribution
    end

    # Predict rating based on category and country averages
    # @param category [String] movie category
    # @param country [String] movie country
    # @return [Float] predicted rating
    def predict_rating(category:, country:)
      category_avg = @movies.where(category: category)
                           .where.not(average_rating: nil)
                           .average(:average_rating)
                           &.to_f || 0

      country_avg = @movies.where(country: country)
                          .where.not(average_rating: nil)
                          .average(:average_rating)
                          &.to_f || 0

      # Weighted average (category 60%, country 40%)
      ((category_avg * 0.6) + (country_avg * 0.4)).round(2)
    end

    # Find similar movies based on category and rating
    # @param movie [Movie] reference movie
    # @param limit [Integer] number of similar movies to return
    # @return [Array<Movie>] similar movies
    def find_similar_movies(movie, limit: 5)
      @movies.where(category: movie.category)
             .where.not(id: movie.id)
             .order("ABS(average_rating - #{movie.average_rating || 0})")
             .limit(limit)
    end

    # Export statistics to CSV format
    # @return [String] CSV formatted data
    def to_csv
      CSV.generate do |csv|
        csv << [ "Statistic", "Value" ]
        csv << [ "Total Movies", total_count ]
        csv << [ "Average Rating", calculate_average_rating ]
        csv << [ "Rating Std Dev", calculate_rating_std_dev ]

        category_stats.each do |category, stats|
          csv << [ "Category: #{category}", "#{stats[:count]} (#{stats[:percentage]}%)" ]
        end
      end
    end

    private

    def total_count
      @movies.count
    end

    def validate_movies_collection
      raise ArgumentError, "Movies collection cannot be nil" if @movies.nil?
      raise ArgumentError, "Movies must be an ActiveRecord relation or array" unless @movies.respond_to?(:each)
    end

    def format_movie_stats(movie)
      {
        id: movie.id,
        title: movie.title,
        category: movie.category,
        country: movie.country,
        release_year: movie.release_year,
        rating: movie.average_rating,
        description: movie.description&.truncate(100)
      }
    end
  end

  # MovieRecommendation class provides recommendation functionality
  class MovieRecommendation
    def initialize(movies)
      @movies = movies
    end

    # Recommend movies based on user preferences
    # @param preferences [Hash] user preferences
    # @return [Array<Movie>] recommended movies
    def recommend(preferences)
      query = @movies.all

      if preferences[:category]
        query = query.where(category: preferences[:category])
      end

      if preferences[:min_rating]
        query = query.where("average_rating >= ?", preferences[:min_rating])
      end

      if preferences[:country]
        query = query.where(country: preferences[:country])
      end

      query.order(average_rating: :desc).limit(preferences[:limit] || 10)
    end
  end

  # MovieImportExport class handles data import/export
  class MovieImportExport
    class ImportError < StandardError; end

    # Import movies from CSV file
    # @param file_path [String] path to CSV file
    # @return [Array<Movie>] imported movies
    def import_from_csv(file_path)
      movies = []

      CSV.foreach(file_path, headers: true) do |row|
        movie = Movie.new(
          title: row["title"],
          category: row["category"] || "Others",
          country: row["country"] || "Unknown",
          release_year: row["release_year"].to_i,
          average_rating: row["average_rating"].to_f,
          description: row["description"]
        )

        if movie.save
          movies << movie
        else
          raise ImportError, "Failed to import movie: #{movie.errors.full_messages.join(', ')}"
        end
      end

      movies
    end

    # Export movies to CSV
    # @param movies [ActiveRecord::Relation] movies to export
    # @return [String] CSV data
    def export_to_csv(movies)
      CSV.generate do |csv|
        csv << [ "ID", "Title", "Category", "Country", "Release Year", "Rating", "Description" ]

        movies.each do |movie|
          csv << [
            movie.id,
            movie.title,
            movie.category,
            movie.country,
            movie.release_year,
            movie.average_rating,
            movie.description
          ]
        end
      end
    end
  end
end
