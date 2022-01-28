class LetsPlay
  COLORS = ["blue", "red", "yellow", "purple", "orange", "green"]
  ALL_POSS = COLORS.repeated_combination(4).to_a
  @@secret_code = []
  @@player_profile
  @@computer_profile

  def initialize
    draw_line
    puts "Welcome!"
    puts "What is your name, player?"
    draw_line
    @@player_profile = Human.new(gets.chomp.capitalize)
    @@computer_profile = Bot.new("Mr. Dator")
    draw_line
    puts "Welcome, #{@@player_profile.name}!"
    puts "Let's play some Mastermind!"
    need_instructions?
    play_mastermind
  end

  # player class start
  class Player
    @@position
    @@guesses = []
    @@historical_guesses = []

    attr_accessor :name, :position, :guesses, :historical_guesses

    def initialize(name)
      @name = name
    end

    def make_guess(choices)
      @@guesses = []
      while @@guesses.length < 4
        puts "What is your guess for spot number #{@@guesses.length + 1}?"
        puts "Enter one choice: #{choices}."
        @guess = gets.chomp.downcase.strip

        if choices.include?(@guess)
          self.guesses = @@guesses.push(@guess)
        else 
          puts "Oops, that didn't match an option. Let's try again."
        end
      end
      puts "..."
      puts "Ok. Got it!"
      puts "Your current guess is #{@@guesses}"
      self.historical_guesses = @@historical_guesses.push(@@guesses)
    end

    def display_feedback
      puts "Here is the feedback from the guesses:"
      puts "..."
      @@historical_guesses.each_with_index do |value, index|
        if index === 0
          puts "Guess #{index +1}: #{value}"
        elsif index === 2
          puts "Guess #{index}: #{value}"
        elsif index.even?
          puts "Guess #{index -1}: #{value}"
        else
          puts "Feedback: #{value}"
          puts "..."
        end
      end
    end

    def reset_game
      self.position = ""
      self.guesses = []
      self.historical_guesses = []
    end

  end
  # player class end

  class Bot < Player
    @remaining_possibilies = []

    attr_accessor :remaining_possibilies

    def find_possibilities(array, code_length)
      self.remaining_possibilies = array.repeated_combination(code_length).to_a
    end

    def make_guess
      current_guess = @remaining_possibilies.sample
      self.guesses = current_guess
      self.historical_guesses = @@historical_guesses.push(current_guess)

      puts "#{self.name} guesses #{current_guess}"
    end

    def remove_possibilities
      guess = @@historical_guesses[-2]
      feedback = @@historical_guesses.last
      correct_spot = feedback["This many guesses were in the correct color and spot:"]
      correct_color = feedback["This many guesses were the correct color but in the wrong spot:"]
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

      elsif correct_color > 0 && correct_spot === 0 
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
      elsif correct_color + correct_spot === 4
        colors_to_keep = guess.uniq
        colors_to_keep.each do |color|
          @remaining_possibilies.each do |possible_code|
            unless possible_code.include?(color)
              codes_to_elim.push(possible_code)
            end
          end
        end
        @remaining_possibilies = (@remaining_possibilies - codes_to_elim)
      end
      # puts "The last hist. feedback was: #{feedback}"
      # puts "Number of guesses in correct spot: #{correct_spot}"
      # puts "Number of guesses of correct color but in wrong spot: #{correct_color}"
      # puts "The last guess was: #{guess}"
      puts "The #{@remaining_possibilies.length} remaining possibilities are: #{@remaining_possibilies}"
    end

  end

  class Human < Player

  end



  def play_mastermind
    @@player_profile.reset_game
    @@computer_profile.reset_game
    choose_position
    if @@player_profile.position === "setter"
      puts "Let's set that secret code!"
      puts "..."
      set_specific_code(COLORS)
      puts "Now let's pass the torch to #{@@computer_profile.name}."
      puts "#{@@computer_profile.name} will get 12 chances to guess your secret code."
      @@computer_profile.find_possibilities(COLORS, 4)
      draw_line
      lets_continue

      3.times do |x|
        if x === 3
          draw_line
          puts "That was the last guess!"
          puts "It looks like #{@@computer_profile.name} didn't figure it out!"
          puts "You bested the bot!"
          puts "..."
          if play_again? then play_mastermind else break end
        end
        draw_line
        @@computer_profile.make_guess
        draw_line
        new_compare_codes(@@computer_profile)
        @@computer_profile.display_feedback
        draw_line
        if is_match?(@@secret_code, @@computer_profile.guesses) 
          puts declare_winner 
          @@player_profile.position = ""
          if play_again?
            play_mastermind
          else
            break
          end
        end
        @@computer_profile.remove_possibilities
        lets_continue
      end



      ##### Here is where I am at in the logic timeline


    elsif @@player_profile.position === "guesser"
      @@player_profile.historical_guesses = []
      @@secret_code = create_random_code(COLORS)
      puts "Ok! #{@@computer_profile.name} has set the secret code."
      puts "hint, its #{@@secret_code}"
      puts "You've got 12 chances to guess the secret code."

      12.times do |x|
        draw_line
        puts "Let's have guess number #{x + 1}!"
        @@player_profile.make_guess(COLORS)
        draw_line
        compare_codes
        @@player_profile.display_feedback
        if is_match?(@@secret_code, @@player_profile.guesses) 
          puts declare_winner 
          @@player_profile.position = "" ## ADDED THIS LINE
            if play_again?
              play_mastermind
            else
              break
            end
        end
      end
      
    else
      puts "Hmm.. how did this go wrong?"
      play_mastermind
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

  ###
  ### this is where I am working
  ###


  def new_compare_codes(whose_guess)
    @correct_spot = 0
    @correct_color = 0

    (whose_guess.guesses).each_with_index do |color, index|
      if @@secret_code[index] === color
        @correct_spot += 1
      elsif (@@secret_code.include?(color)) && (@@secret_code[index] != color)
        @correct_color += 1
      end
    end

    @feedback = {
      "This many guesses were in the correct color and spot:" => @correct_spot,
      "This many guesses were the correct color but in the wrong spot:" => @correct_color
    }

    whose_guess.historical_guesses = whose_guess.historical_guesses.push(@feedback)
  end


  # things for guessing version of game
  def create_random_code(choices)
    [choices.sample, choices.sample, choices.sample, choices.sample]
  end


  def compare_codes
    @correct_spot = 0
    @correct_color = 0
    @feedback = {}

    @@secret_code.each_with_index do |color, index|
      if @@player_profile.guesses[index] === color
        @correct_spot += 1
      elsif @@player_profile.guesses.include?(color)
        @correct_color += 1
      end
    end

    @feedback = {
      "This many guesses were in the correct color and spot:" => @correct_spot,
      "This many guesses were the correct color but in the wrong spot" => @correct_color
    }

    @@player_profile.historical_guesses = @@player_profile.historical_guesses.push(@feedback)
  end

  def is_match?(code, guess)
    code === guess
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

  def choose_position
    puts "Do you want to SET the secret code?"
    puts "Or do you want to GUESS the secret code?"
    puts "Enter 'set' to be the setter."
    puts "Enter 'guess' to be the guesser."
    draw_line
    @response = gets.chomp.downcase.strip
    draw_line

    if @response === "guess"
      @@player_profile.position = "guesser"
      puts "Excellent choice! Guessing is the most fun!"
    elsif @response === "set"
      @@player_profile.position = "setter"
      puts "Super choice! Let's see if you can best the bot!"
    else
      puts "Hmm... I didn't understand that..."
      choose_position
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
      puts "Got it #{@@player_profile.name}? Now, let's play!"
      puts "Your bot opponent is #{@@computer_profile.name}!"
      draw_line
    elsif @response === "n"
      draw_line
      puts "Ok then #{@@player_profile.name}, let's play!"
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

a_game = LetsPlay.new