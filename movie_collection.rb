require 'date'
require 'csv'

class MovieCollection
  FIELDS = %i(link title year countries date genres duration rate
    director actors)
  COL_SEP = "|"

  def initialize(file_name)
    abort "Ошибка! Файл #{file_name} не найден." unless File.file?("./#{file_name}")

    @movies = CSV.read(file_name, { :col_sep => COL_SEP })
      .map { |movie| #puts FIELDS.zip(movie).to_h[:collection] = self
        Movie.new (FIELDS.zip(movie)<<[:collection, self]).to_h
         # Movie.new(FIELDS.zip(movie).to_h, collection: self)
      }
    existing_genres
  end

  def all
    @movies
  end

  def sort_by(param)
    @movies.sort_by(&param)
  end

  def filter(parameters = {})
    parameters.reduce(@movies) do |filtrated, parameter|
      filtrated.select { |m| m.match_filter?(parameter[0], parameter[1]) }
    end
  end

  def stats(param)
    @movies
      .map(&param)
      .flatten
      .each_with_object(Hash.new { 0 }) { |m, stats| stats[m] += 1}
      .sort
  end

  def existing_genres
    @existing_genres ||= @movies.flat_map(&:genres).uniq
  end

  def include_genre?(genre)
    existing_genres.include?(genre)
  end
end
