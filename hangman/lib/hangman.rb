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
    puts STARTING_NEW_GAME
    generate_secret_word()
    puts "HINT HINT, the word is #{@secret_word}"
    puts word_set(@secret_word)
    puts GALLOW_0
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

