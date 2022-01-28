class PlayMastermind
  COLORS = ["blue", "red", "yellow", "purple", "orange", "green"]
  ALL_POSS = COLORS.repeated_combination(4).to_a
  @@secret_code = []

  @@human_profile
  @@computer_profile

  $curr_guess = []
  $hist_guesses = []
  $hist_feedback = []

  def initialize
    draw_line
    puts "Welcome!"
    puts "What is your name, player?"
    draw_line
    @@human_profile = Human.new(gets.chomp.capitalize)
    @@computer_profile = Bot.new("Mr. Dator")
    draw_line
    puts "Welcome, #{@@human_profile.name}!"
    puts "Let's play Mastermind!"
    need_instructions?
    play_mastermind
  end

  class Player
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
  # end of player class

  class Bot < Player
    @remaining_possibilies = []

    attr_accessor :remaining_possibilies

    def make_guess
      current_guess = @remaining_possibilies.sample
      $curr_guess = current_guess

      $hist_guesses.push($curr_guess)

      puts "#{self.name} guesses #{$curr_guess}"
    end


    def find_possibilities(array, code_length)
      self.remaining_possibilies = array.repeated_combination(code_length).to_a
    end


    def remove_possibilities
      guess = $hist_guesses.last
      feedback = $hist_feedback.last
      correct_spot = feedback[:spot]
      correct_color = feedback[:color]
      codes_to_elim = [] 

      if correct_color === 0 && correct_spot === 0
        guess.each do |color|
          @remaining_possibilies.each_with_index do |possible_code, index|
            if possible_code.include?(color)
              codes_to_elim.push(possible_code)
            end
          end
        end
        @remaining_possibilies = (@remaining_possibilies - codes_to_elim)

      elsif correct_color > 1 && correct_spot === 0 
        guess.each_with_index do |guess_color, color_index|
          @remaining_possibilies.each do |possible_code|
            possible_code.each_with_index do |code_color, code_index|
              if code_color === guess_color && code_index === color_index
                codes_to_elim.push(possible_code)
              end
            end
          end
        end
        @remaining_possibilies = (@remaining_possibilies - codes_to_elim)
      end

      #puts "The #{@remaining_possibilies.length} remaining possibilities are: #{@remaining_possibilies}"
    end
  end
  # end of bot class

  class Human < Player
    def make_guess(choices)
      code_guess = []
      $curr_guess = []

      while $curr_guess.length < 4
        puts "What is your guess for spot number #{$curr_guess.length + 1}?"
        puts "Enter one choice: #{choices}."
        spot_guess = gets.chomp.downcase.strip

        if choices.include?(spot_guess)
          $curr_guess = $curr_guess.push(spot_guess)
        else 
          puts "Oops, that didn't match an option. Let's try again."
        end
      end

      puts "..."
      puts "Ok. Got it!"
      puts "Your current guess is #{$curr_guess}"
      $hist_guesses = $hist_guesses.push($curr_guess)
    end
  end

  def play_setter
    $curr_guess = []
    $hist_guesses = []
    $hist_feedback = []
    puts "Let's set that secret code!"
    puts "..."
    set_specific_code(COLORS)
    puts "Now let's pass the torch to #{@@computer_profile.name}."
    puts "#{@@computer_profile.name} will only get 4 chances to guess your secret code."
    @@computer_profile.find_possibilities(COLORS, 4)
    draw_line
    lets_continue

    5.times do |x|
      if x === 4
        draw_line
        puts "That was the last guess!"
        puts "It looks like #{@@computer_profile.name} didn't figure it out!"
        puts "You bested the bot!"
        puts "..."

        if play_again?  
          play_mastermind 
        else 
          break 
        end
      end

      draw_line
      @@computer_profile.make_guess
      draw_line
      compare_codes
      display_feedback
      draw_line

      if is_match?(@@secret_code, $curr_guess) 
        puts declare_winner 

        if play_again?
          play_mastermind
        else
          break
        end
      else
        @@computer_profile.remove_possibilities
        lets_continue
      end
    end
  end

  def play_guesser
    $hist_guesses = []
    $hist_feedback = []
    @@secret_code = create_random_code(COLORS)
    puts "Ok! #{@@computer_profile.name} has set the secret code."
    puts "hint, its #{@@secret_code}"
    puts "You've got 12 chances to guess the secret code."

    12.times do |x|
      draw_line
      puts "Let's have guess number #{x + 1}!"
      puts"..."
      @@human_profile.make_guess(COLORS)
      draw_line
      compare_codes
      display_feedback
      if is_match?(@@secret_code, $curr_guess) 
        puts declare_winner 
          if play_again?
            play_mastermind
          else 
            break
          end
      end
    end
  end

  def play_mastermind
    if be_guesser? 
      play_guesser 
    else
      play_setter
    end
  end
    
  # things for setting version of game
  def set_specific_code(choices)
    @@secret_code = []
    while @@secret_code.length < 4
      puts "What color do you want to place in spot number #{@@secret_code.length + 1} of 4?"
      puts "Enter one choice: #{choices}."
      @color = gets.chomp.downcase.strip

      if choices.include?(@color)
        @@secret_code.push(@color)
      else 
        puts "Oops, that didn't match an option. Let's try again."
      end
    end
    draw_line
    puts "Nice work! Your secret code is: #{@@secret_code}"
    draw_line
  end

  def compare_codes
    @correct_spot = 0
    @correct_color = 0

    $curr_guess.each_with_index do |color, index|
      if @@secret_code[index] === color
        @correct_spot += 1
      elsif @@secret_code.include?(color)
        @correct_color += 1
      end
    end

    @feedback = { spot: @correct_spot, color: @correct_color }
    $hist_feedback = $hist_feedback.push(@feedback)
  end

  # things for guessing version of game
  def create_random_code(choices)
    [choices.sample, choices.sample, choices.sample, choices.sample]
  end

  def display_feedback
    puts "Here is the guess feedback:"
    puts "..."
    $hist_guesses.each_with_index do |value, index|
      puts "Guess #{index +1}: #{value}"
      puts "#{$hist_feedback[index][:spot]} symbols were placed correctly."
      puts "#{$hist_feedback[index][:color]} symbols were placed incorrectly, but were the correct color."
      puts " "
    end
  end

  def is_match?(code, guess)
    code === guess
  end

  def reset_game
    @@secret_code = []
    $curr_guess = []
    $hist_guesses = []
    $hist_feedback = []
  end

  def declare_winner
    puts "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
    puts "* * We have a match! The last guess IS the secret code! * *"
    puts "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
  end

  def play_again?
    draw_line
    puts "Would you like to play again?"
    puts "..."
    puts "Enter 'y' for yes or 'n' for no."
    draw_line
    response = gets.chomp.downcase.strip
    draw_line

    if response === "y"
      puts "Ok, let's do it!"
      reset_game
      return true
    elsif response === "n"
      puts "Okay! Thanks for playing! Have a great day!"
      draw_line
      return false
    else
      puts "I am but a simple machine and could not understand your response.."
      play_again?
    end
  end

  def be_guesser?
    puts "Do you want to SET the secret code?"
    puts "Or do you want to GUESS the secret code?"
    puts "Enter 'set' to be the setter."
    puts "Enter 'guess' to be the guesser."
    draw_line
    @response = gets.chomp.downcase.strip
    draw_line

    if @response === "guess"
      return true
      puts "Excellent choice! Guessing is the most fun!"
    elsif @response === "set"
      return false
      puts "Super choice! Let's see if you can best the bot!"
    else
      puts "Hmm... I didn't understand that..."
      be_guesser?
    end
  end

  def need_instructions?
    puts "Do you want me to explain the rules?"
    puts "Enter 'y' for yes, 'n' for no."
    draw_line
    @response = gets.chomp.downcase.strip

    if @response === "y"
      draw_line
      puts "You are in for some fun!"
      puts "Let me explain the game."
      puts_instructions
      puts "Got it #{@@human_profile.name}? Now, let's play!"
      puts "Your bot opponent is #{@@computer_profile.name}!"
      draw_line
    elsif @response === "n"
      draw_line
      puts "Ok then #{@@human_profile.name}, let's play!"
      puts "Your bot opponent is #{@@computer_profile.name}!"
      draw_line
    else
      draw_line
      puts "Sorry, I didn't recognize that answer."
      need_instructions?
    end
  end

  def lets_continue
    puts "..."
    puts ""
    puts "Press any key to continue."
    gets
    puts "..."
  end

  def draw_line
    puts "--- --- --- --- --- --- --- --- --- ---"
  end

  def puts_instructions
    draw_line
    puts "How to Play Mastermind"
    puts "..."
    puts "This is a game between two players."
    puts "One player comes up with a 'secret code'"
    puts "and the other player tries to guess it."
    puts "..."
    puts "In this version of the game"
    puts "we will be using colors as our code symbols."
    puts "..."
    puts "The secret code will be four symbols long."
    puts "And each symbol can be 1 of 6 colors:"
    puts "blue, red, yellow, purple, orange or green."
    puts "..."
    puts "Here are a few examples of secret codes:"
    puts "['orange', 'blue', 'yellow', 'red']"
    puts "['red', 'red', 'yellow', 'purple']"
    puts "..."
    puts "The objective of the player guessing"
    puts "is to guess the correct colors"
    puts "in the correct order, within 12 guesses."
    draw_line
  end

end

a_game = PlayMastermind.new