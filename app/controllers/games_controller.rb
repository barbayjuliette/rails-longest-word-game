require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    @array_of_letters = ('A'..'Z').to_a
    10.times { @grid << @array_of_letters.sample }
  end

  def score
    grid = params[:grid].split(" ")
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    api = JSON.parse(URI.open(url).read)

    @result =
      if only_grid_letters(grid) == false
        "Sorry but #{@word.upcase} cannot be built out of #{grid.join(" ")}"
      elsif api["found"] == false
        "Sorry but #{@word.upcase} is not a valid english word"
      else
        "Congratulations! #{@word.upcase} is a valid word"
      end
  end

  private

  def only_grid_letters(grid)
    array_of_letters = @word.upcase.chars
    array_of_letters.each do |letter|
      return false unless grid.include?(letter)

      index = grid.find_index(letter)
      grid.delete_at(index)
    end
  end

end
