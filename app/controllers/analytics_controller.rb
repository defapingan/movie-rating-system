class AnalyticsController < ApplicationController
  def index
    @movies = Movie.all
    @movies_count = @movies.count
    @average_rating = calculate_average_rating
    @categories_count = @movies.distinct.count(:category)
    @countries_count = @movies.distinct.count(:country)

    # 分类数据 - 用于饼图
    @category_data = @movies.group(:category).count

    # 国家数据 - 用于环形图
    @country_data = @movies.group(:country).count

    # 评分分布 - 用于条形图
    @rating_distribution = calculate_rating_distribution

    # 年度数据 - 用于折线图
    @year_data = calculate_year_data
  end

  private

  def calculate_average_rating
    # 计算所有电影的平均评分
    average = @movies.where.not(average_rating: nil).average(:average_rating)
    average ? average.round(1) : 0.0
  end

  def calculate_rating_distribution
    distribution = {}

    # 定义评分区间
    rating_ranges = {
      5 => { min: 4.5, max: 5.0 },    # 4.5-5.0 -> 5星
      4 => { min: 3.5, max: 4.5 },    # 3.5-4.5 -> 4星
      3 => { min: 2.5, max: 3.5 },    # 2.5-3.5 -> 3星
      2 => { min: 1.5, max: 2.5 },    # 1.5-2.5 -> 2星
      1 => { min: 0.0, max: 1.5 }     # 0.0-1.5 -> 1星
    }

    total_movies_with_rating = @movies.where.not(average_rating: nil).count

    if total_movies_with_rating > 0
      rating_ranges.each do |stars, range|
        count = @movies.where('average_rating >= ? AND average_rating < ?', range[:min], range[:max]).count
        percentage = (count.to_f / total_movies_with_rating * 100).round(1)
        distribution[stars] = percentage
      end
    else
      # 如果没有评分数据，显示0%
      (1..5).each { |rating| distribution[rating] = 0 }
    end

    distribution
  end

  def calculate_year_data
    year_counts = @movies.group(:release_year).count

    # 如果没有数据，创建一些示例数据用于演示
    if year_counts.empty?
      current_year = Date.today.year
      {
        current_year - 2 => 2,
        current_year - 1 => 3,
        current_year => 1
      }
    else
      # 按年份排序并确保至少有3个数据点
      sorted_years = year_counts.sort.to_h

      # 如果数据点太少，补充一些数据
      if sorted_years.keys.size < 3
        min_year = sorted_years.keys.min
        max_year = sorted_years.keys.max

        # 补充中间年份的数据
        (min_year..max_year).each do |year|
          sorted_years[year] ||= 0
        end
      end

      sorted_years
    end
  end
end
