class AnalyticsController < ApplicationController
  def index
    # 调试：检查是否有Movie数据
    Rails.logger.info "=== Analytics Controller Called ==="
    Rails.logger.info "Movie count: #{Movie.count}"

    @movies = Movie.all
    Rails.logger.info "@movies: #{@movies.inspect}"

    @movies_count = @movies.count
    @average_rating = calculate_average_rating

    @category_data = @movies.group(:category).count
    @country_data  = @movies.group(:country).count

    # 确保数据不为nil
    @category_data = {} if @category_data.nil?
    @country_data = {} if @country_data.nil?

    @categories_count = @category_data.keys.count
    @countries_count  = @country_data.keys.count

    @rating_distribution = calculate_rating_distribution
    @year_data = calculate_year_data

    # 调试日志
    Rails.logger.info "Category Data: #{@category_data}"
    Rails.logger.info "Country Data: #{@country_data}"
    Rails.logger.info "Rating Distribution: #{@rating_distribution}"
    Rails.logger.info "Year Data: #{@year_data}"

    # 如果数据为空，添加示例数据用于测试
    if @category_data.empty?
      Rails.logger.info "No category data found, adding sample data for testing"
      @category_data = {
        "ScienceFiction" => 5,
        "Mystery" => 3,
        "Art" => 2,
        "Comedy" => 4,
        "Others" => 1
      }
      @categories_count = 5
    end

    if @country_data.empty?
      @country_data = {
        "United States" => 8,
        "United Kingdom" => 3,
        "Japan" => 2,
        "China" => 1
      }
      @countries_count = 4
    end

    if @rating_distribution.empty?
      @rating_distribution = {
        5 => 30.0,
        4 => 40.0,
        3 => 20.0,
        2 => 8.0,
        1 => 2.0
      }
    end

    if @year_data.empty?
      current_year = Date.today.year
      @year_data = {
        current_year-3 => 2,
        current_year-2 => 4,
        current_year-1 => 6,
        current_year => 3
      }
    end
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
