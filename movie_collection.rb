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
        f = m.send(field)
        filtrated << m if case value
          when Range
            value === field
          when Regexp
            if f.is_a?(Array)
              f.any? {|i| value =~ i}
            else
              value =~ f
            end
          else
            f.include?(value)
          end
        filtrated
      end
    end
    return movies
  end

  def stats(param)
    @movies
      .each_with_object(Hash.new { 0 }) do |m, stats|
        if m.send(param).is_a?(Array)
          m.send(param).each { |name| stats[name] += 1 }
        else
          stats[m.send(param)] += 1
        end
      end
      .sort
  end

  def include_genre?(genre)
    @movies.any? { |m| m.genres.include?(genre)}
  end
end

