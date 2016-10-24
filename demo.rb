require './movie.rb'
require './movie_collection.rb'

def print_movies(movies)
  movies.each { |movie| puts "#{movie.title} (#{movie.date}; #{movie.genres.join("/")}) - #{movie.duration} min ; #{movie.actors.join("/")}" }
end


file_name = ARGV[0] || "movies.txt"

movies = MovieCollection.new(file_name)


puts "\n5 самых длинных фильмов"
print_movies(movies.all
  .sort_by(&:duration)
  .last(5)
  .reverse
)

puts "\nИтальянские комедии"
print_movies(movies.filter(genres: 'Comedy', countries: "Italy"))

puts "\nФильмы Копполы"
print_movies(movies.filter(director: 'Francis Ford Coppola'))

puts "\nФильмы с участием Моргана"
print_movies(movies.filter(actors: /morgan/i))

puts "\nФильмы Копполы 2"
print_movies(movies.filter(director: /coppola/i))

puts "\n10 комедий (первые по дате выхода)"
print_movies(movies.filter(year: 1979..1980)
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
movies.stats(:actors)
  .first(5)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nСтраны"
movies.stats(:countries)
  .first(5)
  .each {|key, value| puts "#{key}: #{value}" }

puts "\nЖанры"
movies.stats(:genres)
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
