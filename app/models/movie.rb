class Movie < ApplicationRecord
  CATEGORIES = [ "Comedy", "Mystery", "ScienceFiction", "Art", "Others" ]
  COUNTRIES = [ "Chinese", "American", "Japanese", "Korean", "British", "France", "India" ]

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :country, inclusion: { in: COUNTRIES }
  validates :average_rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
end

