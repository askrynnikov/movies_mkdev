require 'date'

class Movie
  attr_reader :link, :title, :year, :countries, :date, :genres, :duration, :rate, :director, :actors

  def initialize(link:, title:, year:, countries:, date:, genres:, duration:,
      rate:, director:, actors:)
    @link = link.to_i
    @title = title
    @year = year.to_i
    @countries = countries.split(",")
    @date = parse_date(date)
    @genres = genres.split(",")
    @duration = duration.to_i
    @rate = rate.to_f
    @director = director
    @actors = actors.split(",")
  end

  def month
    @date.month
  end

  def has_genre?(genre, movies)
    raise ArgumentError, " Нет такого жанра: #{genre}.}" unless movies.include_genre?(genre)
    genres.include?(genre)
  end

  private

  def parse_date(date)
    # добавляем месяц если отсутствует
    date += "-01" if date.split("-").size == 1
    # добавляем число месяца если отсутствует
    date += "-01" if date.split("-").size == 2
    Date.strptime(date, '%Y-%m-%d')
  end
end
