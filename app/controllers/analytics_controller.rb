class AnalyticsController < ApplicationController
  def index
    @movies = Movie.all

    @movies_count = @movies.count
    @average_rating = calculate_average_rating

    @category_data = @movies.group(:category).count
    @country_data  = @movies.group(:country).count

    @categories_count = @category_data.keys.count
    @countries_count  = @country_data.keys.count

    @rating_distribution = calculate_rating_distribution
    @year_data = calculate_year_data
  end

  private

  def calculate_average_rating
    avg = @movies.where.not(average_rating: nil).average(:average_rating)
    avg ? avg.round(1) : 0.0
  end

  def calculate_rating_distribution
    distribution = {}

    ranges = {
      5 => (4.5..5.0),
      4 => (3.5...4.5),
      3 => (2.5...3.5),
      2 => (1.5...2.5),
      1 => (0.0...1.5)
    }

    total = @movies.where.not(average_rating: nil).count

    (1..5).each { |i| distribution[i] = 0 }

    return distribution if total.zero?

    ranges.each do |stars, range|
      count = @movies.where(average_rating: range).count
      distribution[stars] = ((count.to_f / total) * 100).round(1)
    end

    distribution
  end

  def calculate_year_data
    data = @movies.group(:release_year).count.compact

    return {} if data.empty?

    data.sort.to_h
  end
end
