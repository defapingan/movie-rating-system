class Movie < ApplicationRecord
  CATEGORIES = [ "ScienceFiction", "Mystery", "Art", "Comedy", "Others" ].freeze
  COUNTRIES = [ "United States", "United Kingdom", "Japan", "China", "France",
               "South Korea", "India", "Germany", "Canada", "Australia" ].freeze

  validates :title, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :country, presence: true, inclusion: { in: COUNTRIES }
  validates :release_year, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1900,
    less_than_or_equal_to: Date.today.year
  }
  validates :average_rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }, allow_nil: true

  def self.search(query)
    return all unless query.present?
    where("LOWER(title) LIKE ?", "%#{query.downcase}%")
  end
end
