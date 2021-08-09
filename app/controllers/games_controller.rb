require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("a".."z").to_a.sample.capitalize }
    return @letters
  end

  def score
    @answer = params[:answer].upcase
    @letters = params[:letters]
    if english?("https://wagon-dictionary.herokuapp.com/#{params[:answer]}") == false
      @score = "Sorry but #{@answer} does not seem to be a valid English word.."
    elsif included?(@answer, @letters) == false
      @score = "Sorry but #{@answer} can't be built out of #{@letters}"
    else
      @score = "Congratulations !"
    end
  end

  private

  def included?(answer, letters)
    answer.chars.all? { |letter| answer.count(letter) <= letters.count(letter) }
  end

  def english?(url)
    # url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    word["found"] == true
  end

end
