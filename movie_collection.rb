require 'date'
require 'csv'

class MovieCollection
  FIELDS = %i(link title year countries date genres duration rate
    director actors)
  COL_SEP = "|"

  def initialize(file_name)
    abort "Ошибка! Файл #{file_name} не найден." unless File.file?("./#{file_name}")

    @movies = CSV.read(file_name, { :col_sep => COL_SEP })
      .map { |movie| Movie.new(**FIELDS.zip(movie).to_h, collection: self) }
  end

  def all
    @movies
  end

  def sort_by(param)
    @movies.sort_by(&param)
  end

  def filter(parameters = {})
    parameters.reduce(@movies) do |filtrated, (key, value)|
      filtrated.select { |m| m.match_filter?(key, value) }
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
