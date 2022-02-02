# GAME START:
# prompt user to start new game OR a load saved game

# for new game:
# load dictionary, randomly select a secret word between 5 and 12 char long.
# display _ for each letter long the secret word is
# display an empty hangman "picture"

# TURNS:
# prompt user to guess a letter
  # if not a letter or more than one letter, reprompt
  # if letter exists in word:
    # in secret word display, replace _ with the letter, in each spot it appears
    # display current state of wrong letters guessed list
    # display current state of hangman picture
  # if letter does not exist in word:
    # display current state of secret word display
    # add letter to wrong letters guessed list, display updated list
    # add body part to hangman picture, display hangman picture
# below prompt, offer secondary input options:
  # offer an input that triggers save game.
  # offer an input that triggers to quit game w/o saving.
  # offer an input that lets the user guess the entire word.

require_relative 'visuals.rb'

class Hangman 
  include Visuals

  def initialize()
    @game_saved
    @asked_again
    puts welcome("Hangman")
    main_menu()
  end

  def main_menu()
    puts ASK_TO_PLAY
    get_response()
  end

  def get_response()
    response = gets.chomp.strip

    case response
    when "save"
      save_game()
      # ^^ have not coded this method yet
    when "1"
      if @game_saved == false && @asked_again == false
        puts DOUBLE_CHECK
        @asked_again = true
        get_response()
      else
        start_new()
      end
    when "2"
      if @game_saved == false && @asked_again == false
        puts DOUBLE_CHECK
        @asked_again = true
        get_response()
      else
        continue_saved()
        # ^^ have not coded this method yet
      end
    else
      puts GIBBERISH
      get_response()
    end
  end

  def start_new()
    @game_saved = false
    @asked_again = false
    @wrong_letters = []
    @gallow_array = [GALLOW_0, GALLOW_1, GALLOW_2, GALLOW_3, GALLOW_4, GALLOW_5, GALLOW_6]
    @current_gallows = @gallow_array[0]

    puts STARTING_NEW_GAME
    generate_secret_word()
    puts WORD_SET
    puts "HINT HINT, the word is '#{@secret_word}'."
    puts @current_gallows
    make_letter_collector()
    display_letter_collector()
    take_turns()
    display_outcome()
  end

  def make_letter_collector()
    @letter_collector = Array.new(@secret_word.length) { |letter| "_" }
  end

  def update_letter_collector()
    secret_array = @secret_word.split("")
    collector_array = @letter_collector

    secret_array.each_with_index do |letter, index|
      if letter == @guess
        collector_array[index] = @guess
      end
    end

    @letter_collector = collector_array
  end

  def display_letter_collector()
    puts "The secret word is #{@secret_word.length} letters long: #{@letter_collector.join("")}"
    puts "Incorrect letter(s): #{@wrong_letters.join(", ")}"
    puts DRAW_LINE
  end

  def display_outcome()
    if word_matched?
      puts "Winner, Winner!!"
    else
      puts "WOMP, WOMP."
    end
  end

  def take_turns()

    while @gallow_array.length > 1 && !word_matched?
      guess_letter()
      puts DRAW_LINE
      check_guess()
      display_result()
    end
  end

  def word_matched?()
    @secret_word == @letter_collector.join("") ? true : false
  end

  def guess_letter()
    puts "Guess a letter!"
    puts DRAW_LINE
    @guess = gets.chomp.strip.downcase
    puts DRAW_LINE

    if @guess.match(/[^a-z]/)
      puts "That's not a letter, silly. Try again."
      guess_letter()
    elsif @guess.length > 1
      puts "Only guess one letter at a time. Try again."
      guess_letter()
    else
      puts "Got it. Let's see if #{@guess} is a match!"
    end
  end

  def check_guess()
   if @secret_word.match(@guess)
    update_letter_collector()
   else
     @wrong_letters.push(@guess)
     @gallow_array.shift
     @current_gallows = @gallow_array[0]
   end
  end

  def display_result()
    puts @current_gallows
    display_letter_collector()
  end

  def continue_saved()
    puts "I haven't coded this yet."
  end

  def save_game()
    puts "not coded yet."
  end

  def generate_secret_word()
    dictionary = File.readlines('dictionary.txt').select { |word| word if word.strip.length.between?(5,12) }
    @secret_word = dictionary.sample.chomp
  end
end

