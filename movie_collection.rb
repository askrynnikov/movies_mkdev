require 'date'
require 'csv'

class MovieCollection
  FIELDS = %i(link title year countries date genres duration rate
    director actors)
  COL_SEP = "|"

  def initialize(file_name)
    abort "Ошибка! Файл #{file_name} не найден." unless File.file?("./#{file_name}")

    @movies = CSV.read(file_name, { :col_sep => COL_SEP })
      .map { |movie| Movie.new(FIELDS.zip(movie).to_h)}
  end

  def all()
    @movies
  end

  def sort_by(param)
    @movies.sort_by(&param)
  end

  def filter(param)
    movies = @movies.dup
    movies.select! { |m| m.genres.include?(param[:genre]) } unless param[:genre].nil?
    movies.select! { |m| m.countries.include?(param[:country]) } unless param[:country].nil?
    return movies
  end

  def stats(param)
    case param
    when :director
      @movies
        .each_with_object(Hash.new { 0 }) { |m, stats| stats[m.director] += 1 }
        .sort
    when :year
      @movies
        .each_with_object(Hash.new { 0 }) { |m, stats| stats[m.year] += 1 }
        .sort
    when :month
      @movies
        .each_with_object(Hash.new { 0 }) { |m, stats| stats[m.date.month] += 1 }
        .sort
        # .each {|key, value| puts "#{Date::MONTHNAMES[key]}: #{value}" }
    when :actor
      @movies
        .each_with_object(Hash.new { 0 }) { |m, stats|  m.actors.each { |name|stats[name] += 1 } }
        .sort
    when :country
      @movies
        .each_with_object(Hash.new { 0 }) { |m, stats|  m.countries.each { |name|stats[name] += 1 } }
        .sort
    when :genre
      @movies
        .each_with_object(Hash.new { 0 }) { |m, stats|  m.genres.each { |name|stats[name] += 1 } }
        .sort
    end
  end
end
