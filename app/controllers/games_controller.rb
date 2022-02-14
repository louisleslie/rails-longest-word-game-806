require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    #If the letters have been passed in the params (from the score page) then use those, otherwise use an array of random letters
    @letters = params[:letters] || Array.new(10) { ("A".."Z").to_a.sample } 

  end

  def score
    @guess = params[:guess]
    @letters = params[:letters].split
    @guess_array = @guess.upcase.chars 
    # do all the letters in the guess_array match the letters given? will be true or false
    letters_match = @guess_array.all? {|l| @guess_array.count(l) <= @letters.count(l) }
    if letters_match
      # check api if the guess is a valid word
      url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
      api_call = JSON.parse(URI.open(url).read)
      if api_call["found"] # we use strings instead of symbols because ruby can be a pain
        @score = api_call["length"]
        @message = "Hooray, well done!"
      else
        @score = 0
        @message = "Sorry, #{@guess} is not a valid word"
      end
    else
      # the word doesn't contain the right letters, so no point in calling the API
      @score = 0
      @message = "Sorry, those characters aren't in the list of words"
    end
    
  end
end
