# app/models/movie.rb
class Movie < ApplicationRecord
  # 简化的验证规则
  validates :title, presence: true
  validates :category, presence: true
  validates :country, presence: true
  validates :release_year, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1900
  }
  validates :average_rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }, allow_nil: true

  # 添加search方法
  def self.search(query)
    return all unless query.present?
    where("LOWER(title) LIKE ?", "%#{query.downcase}%")
  end
end
