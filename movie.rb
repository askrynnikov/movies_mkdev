require 'date'

class Movie
  attr_reader :link, :title, :year, :countries, :date, :genres, :duration, :rate, :director, :actors

  GERNES = %w(Action Adventure Animation Biography Comedy Crime Drama Family
    Fantasy Film-Noir History Horror Music Musical Mystery Romance Sci-Fi Sport
    Thriller War Western)

  def initialize(movie = {})
    @link, @title, @year, @countries, @date, @genres, @duration,
    @rate, @director, @actors =
      post_process(movie)
      .values_at(:link, :title, :year, :countries, :date, :genres, :duration,
      :rate, :director, :actors)
  end

  def has_genre?(genre)
    if GERNES.include?(genre)
      genres.include?(genre)
    else
      raise ArgumentError, " Нет такого жанра: #{genre}. Список допустимых: #{GERNES.join(" ,")}"
    end
  end

  private

  def parse_date(date)
    # добавляем месяц если отсутствует
    date += "-01" if date.split("-").size == 1
    # добавляем число месяца если отсутствует
    date += "-01" if date.split("-").size == 2
    Date.strptime(date, '%Y-%m-%d')
  end

  def post_process(movie)
    movie[:year] = movie[:year].to_i
    movie[:countries] = movie[:countries].split(",")
    movie[:date] = parse_date(movie[:date])
    movie[:genres] = movie[:genres].split(",")
    movie[:duration] = movie[:duration].to_i
    movie[:actors] = movie[:actors].split(",")
    movie
  end

end
