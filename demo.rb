require './movie.rb'
require './movie_collection.rb'

def print_movies(movies)
  movies.each { |movie| puts "#{movie.title} (#{movie.date}; #{movie.genres.join("/")}) - #{movie.duration} min" }
end


file_name = ARGV[0] || "movies.txt"

movies = MovieCollection.new(file_name)


puts "\n5 самых длинных фильмов"
print_movies(movies.all
  .sort_by(&:duration)
  .last(5)
  .reverse
)

puts "\n10 комедий (первые по дате выхода)"
 print_movies(movies.filter(genre: 'Comedy', country: "USA")
   .sort_by(&:date)
   .first(10)
 )

 movies.stats(:month)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nРежисеры"
movies.stats(:director)
  .first(5)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nАктеры"
movies.stats(:actor)
  .first(5)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nСтраны"
movies.stats(:country)
  .first(5)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nЖанры"
movies.stats(:genre)
  .first(5)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nАктеры первого фильма"
puts movies.all.first.actors

begin
  puts movies.all.first.has_genre?('Comedy')
  puts movies.all.first.has_genre?('выапComedy')
  puts movies.all.first.has_genre?('Cdomedy')
rescue ArgumentError => err
  puts err
end
