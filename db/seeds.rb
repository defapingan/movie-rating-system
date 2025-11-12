# Clear existing data
Movie.destroy_all

# Add test movie data (using English categories and countries)
movies = [
  {
    title: "The Wandering Earth 2",
    category: "Science fiction",
    country: "Chinese",
    release_year: 2023,
    average_rating: 4.5,
    description: "Sci-fi adventure movie about humanity pushing Earth out of solar system"
  },
  {
    title: "Full River Red",
    category: "Mystery",
    country: "Chinese",
    release_year: 2023,
    average_rating: 4.2,
    description: "Historical mystery comedy set in Southern Song dynasty"
  },
  {
    title: "Avatar: The Way of Water",
    category: "Science fiction",
    country: "American",
    release_year: 2022,
    average_rating: 4.3,
    description: "Sci-fi epic about the underwater world of Pandora"
  }
]

movies.each do |movie_data|
  Movie.create!(movie_data)
end

puts "Successfully created #{Movie.count} movies"
