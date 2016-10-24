require 'date'
require 'csv'

class MovieCollection
  FIELDS = %i(link title year countries date genres duration rate
    director actors)
  COL_SEP = "|"

  def initialize(file_name)
    abort "Ошибка! Файл #{file_name} не найден." unless File.file?("./#{file_name}")

    @movies = CSV.read(file_name, { :col_sep => COL_SEP })
      .map { |movie| Movie.new (FIELDS.zip(movie)<<[:collection, self]).to_h }
    existing_genres
  end

  def all
    @movies
  end

  def sort_by(param)
    @movies.sort_by(&param)
  end

  def filter(parameters = {})
    movies = @movies.dup
    parameters.each do |field, value|
      movies = movies.reduce(Array.new) do |filtrated, m|
        filtrated << m if m.match_filter?(field, value);
        filtrated
      end
    end
    return movies
  end

  def stats(param)
    @movies
      .map { |m| m.send(param)}
      .flatten
      .each_with_object(Hash.new { 0 }) { |m, stats| stats[m] += 1}
      .sort
  end

  def existing_genres
    @existing_genres ||= @movies.map { |m| m.genres } .flatten.uniq
  end

  def include_genre?(genre)
    @existing_genres.include?(genre)
  end
end

