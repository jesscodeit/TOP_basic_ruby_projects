require_relative 'visuals.rb'
require 'yaml'

class Hangman 
  include Visuals

  def initialize()
    main_menu()
  end

  def main_menu()
    puts welcome("Hangman")
    puts ASK_TO_PLAY
    get_response()
  end

  def get_response()
    response = gets.chomp.strip

    case response
    when "1"
      start_new()
    when "2"
      continue_saved()
      # ^^ have not coded this method yet
    else
      puts GIBBERISH
      get_response()
    end
  end

  def reset()
    @wrong_letters = []
    @gallow_array = [GALLOW_0, GALLOW_1, GALLOW_2, GALLOW_3, GALLOW_4, GALLOW_5, GALLOW_6]
    @current_gallows = @gallow_array[0]
  end

  def start_new()
    reset()
    puts STARTING_NEW_GAME
    generate_secret_word()    
    make_letter_collector()
    puts WORD_SET
    #puts "HINT HINT, the word is '#{@secret_word}'."
    game_play()
  end

  def game_play()
    puts @current_gallows
    display_letter_collector()
    take_turns()
    display_outcome()

    if play_again?()
      main_menu()
    else
      puts GOODBYE
      exit
    end
  end

  def play_again?()
    puts PLAY_AGAIN
    answer = gets.chomp.strip

    if answer == "y"
      return true
    elsif answer == "n"
      return false
    else
      puts GIBBERISH
      play_again?
    end
  end

  def generate_secret_word()
    dictionary = File.readlines('dictionary.txt').select { |word| word if word.strip.length.between?(5,12) }
    @secret_word = dictionary.sample.chomp
    @game_filename = "#{dictionary.sample.chomp}_#{dictionary.sample.chomp}.yaml"
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
      puts WINNER
    else
      puts loser()
    end

    reset()
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
    puts "Or enter [save] to save this game for later."
    puts DRAW_LINE
    @guess = gets.chomp.strip.downcase
    puts DRAW_LINE

    if @guess.match(/[^a-z]/)
      puts "That's not a letter, silly. Try again.\n "
      guess_letter()
    elsif @wrong_letters.include?(@guess) || @letter_collector.include?(@guess)
      puts "You've already guessed that letter! Try again.\n "
      guess_letter()
    elsif @guess == "save"
      puts "Ok. Let's save your game!"
    elsif @guess.length > 1
      puts "Only guess one letter at a time. Try again.\n "
      guess_letter()
    else
      puts "Got it. Let's see if #{@guess} is a match!"
    end
  end

  def check_guess()
    if @secret_word.match(@guess)
      update_letter_collector()
    elsif @guess == "save"
      save_game()
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

  # functionality for saving games and loading saved games

  def continue_saved()
    pick_gamefile()
    yaml_to_game()
    game_play()
  end

  def save_game()
    Dir.mkdir 'saved_games' unless Dir.exist? 'saved_games'

    File.open("saved_games/#{@game_filename}", 'w') do |file|
      file.puts game_to_yaml()
    end

    puts " \nGame save successful!"
    puts "Your game filename is: #{@game_filename}"
    puts "Sending you back to the main menu now.\n "
    main_menu()
  end

  def game_to_yaml()
    YAML.dump(
      'secret_word' => @secret_word,
      'game_filename' => @game_filename,
      'letter_collector' => @letter_collector,
      'wrong_letters' => @wrong_letters,
      'gallow_array' => @gallow_array,
      'current_gallows' => @current_gallows
    )
  end

  def yaml_to_game()
    yaml_file = YAML.load(File.read("saved_games/#{@game}"))
    @secret_word = yaml_file['secret_word']
    @game_filename = yaml_file['game_filename']
    @letter_collector = yaml_file['letter_collector']
    @wrong_letters = yaml_file['wrong_letters']
    @gallow_array = yaml_file['gallow_array']
    @current_gallows = yaml_file['current_gallows']
  end

  def ordered_gamefile_list()
    @file_list = []

    Dir.entries('saved_games').each do |file| 
      @file_list.push(file) if file.match(".yaml")
    end

    @file_list.each_with_index do |file, index|
      puts "[#{index + 1}] #{file}"
    end
  end

  def pick_gamefile()
    puts PROMPT_FIND_GAME
    ordered_gamefile_list()
    puts DRAW_LINE
    gamefile_index = gets.chomp.strip.downcase
    if gamefile_index.match(/[0-9]/) && gamefile_index.to_i.between?(1, @file_list.length)
      gamefile_index = gamefile_index.to_i
      @game = @file_list[gamefile_index - 1]
      puts game_found()
    else
      puts INVALID_GAMEFILE_INDEX
      pick_gamefile()
    end
  end
end