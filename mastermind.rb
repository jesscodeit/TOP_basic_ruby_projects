class LetsPlay
  COLORS = ["blue", "red", "yellow", "purple", "orange", "green"]
  @@secret_code = []
  @@player_profile
  @@computer_profile

  def initialize

    draw_line
    puts "Welcome!"
    puts "What is your name, player?"
    draw_line
    @@player_profile = Player.new(gets.chomp.capitalize)
    @@computer_profile = Player.new("Mr. Dator")
    draw_line
    puts "Welcome, #{@@player_profile.name}!"
    puts "Let's play some Mastermind!"
    need_instructions?
    play_mastermind
  end

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
      puts "Your guess is #{@@guesses}"
      self.historical_guesses = @@historical_guesses.push(@@guesses)
    end

    def display_feedback
      puts "Here is your feedback:"
      puts "..."
      @@historical_guesses.each_with_index do |value, index|
        if index === 0
          puts "Guess #{index +1}: #{value}"
        elsif index.even?
          puts "Guess #{index}: #{value}"
        else
          puts "Feedback: #{value}"
          puts "..."
        end
      end
    end

  end

  def play_mastermind
    choose_position
    if @@player_profile.position === "setter"
      puts "Let's set that secret code!"
      puts "..."
      set_specific_code(COLORS)

    elsif @@player_profile.position === "guesser"
      @@secret_code = create_random_code(COLORS)
      puts "Ok! #{@@computer_profile.name} has set the code."
      puts "hint, its #{@@secret_code}"
      draw_line
      @@player_profile.make_guess(COLORS)
      draw_line
      compare_codes
      @@player_profile.display_feedback

      draw_line
      @@player_profile.make_guess(COLORS)
      draw_line
      compare_codes
      @@player_profile.display_feedback
      

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