Movie.destroy_all

movies = [
  {
    title: "The Wandering Earth 2",
    category: "ScienceFiction",
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
    category: "ScienceFiction",
    country: "American",
    release_year: 2022,
    average_rating: 4.3,
    description: "Sci-fi epic about the underwater world of Pandora"
  },
  {
    title: "The Grand Budapest Hotel",
    category: "Comedy",
    country: "American",
    release_year: 2014,
    average_rating: 4.1,
    description: "A writer encounters the owner of an aging high-class hotel, who tells him of his early years serving as a lobby boy in the hotel's glorious years under an exceptional concierge."
  },
  {
    title: "Spirited Away",
    category: "Art",
    country: "Japanese",
    release_year: 2001,
    average_rating: 4.8,
    description: "During her family's move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits, and where humans are changed into beasts."
  },
  {
    title: "Inception",
    category: "Others",
    country: "American",
    release_year: 2010,
    average_rating: 4.7,
    description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O."
  }
]

movies.each do |movie_data|
  Movie.create!(movie_data)
end

puts "Successfully created #{Movie.count} movies covering all categories: #{Movie.distinct.pluck(:category).join(', ')}"
