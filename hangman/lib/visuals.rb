module Visuals 
    def welcome(game)
        <<~HEREDOC
        - - - - - - - - - - - - - - - - - - - - - - - - -
        * * * * * * * * * * * * * * * * * * * * * * * * *
        Welcome to #{game}! 
        * * * * * * * * * * * * * * * * * * * * * * * * *
        HEREDOC
    end
    
    ASK_TO_PLAY = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    How would you like to play?

    [1] To start a new game
    [2] To continue a saved game
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    STARTING_NEW_GAME = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    Okay! Let's start a new game.
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    WORD_SET = <<~HEREDOC
    Here we go! 

    We've got a super secret word picked out for you.
    HEREDOC

    GIBBERISH = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    Sorry, I didn't understand that...
    Please try again.
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    WINNER = <<~HEREDOC
    * * * * * * * * * * * * * * * * * * * * * * * * *
    Winner, Winner! 
    Excellent work with that puzzle!
    * * * * * * * * * * * * * * * * * * * * * * * * *
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    def loser()
        <<~HEREDOC
        Womp, womp!
        Looks like you didn't quite figure it out...
        The secret word was: #{@secret_word}
        - - - - - - - - - - - - - - - - - - - - - - - - -
        HEREDOC
    end

    PROMPT_FIND_GAME = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    What gamefile would you like to load?

    HEREDOC

    def game_found()
        <<~HEREDOC
        - - - - - - - - - - - - - - - - - - - - - - - - -
        Okay!
        Here is the saved game "#{@game}" 
        
        HEREDOC
    end

    INVALID_GAMEFILE_INDEX = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    Sorry, I didn't understand that...
    Please enter a valid gamefile index number.
    HEREDOC
    
    PLAY_AGAIN = <<~HEREDOC
    So...
    Do you want to play again?

    [y] for yes
    [n] for no
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    GOODBYE = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    Okey dokey!

    Thanks for playing and have a fantastic day!
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    DRAW_LINE = <<~HEREDOC
    - - - - - - - - - - - - - - - - - - - - - - - - -
    HEREDOC

    GALLOW_0 = %q{
        ___________
         \|/     |
          |     
          |     
          |      
          |     
        _/|\________
        [][][][][][]

    }
    
    GALLOW_1 = %q{
        ___________
         \|/     |
          |     (*)
          |     
          |     
          |     
        _/|\________
        [][][][][][]

    }

    GALLOW_2 = %q{
        ___________
         \|/     |
          |     (*)
          |      |
          |      |
          |     
        _/|\________
        [][][][][][]

    }

    GALLOW_3 = %q{
        ___________
         \|/     |
          |     (*)
          |     /|
          |      |
          |     
        _/|\________
        [][][][][][]

    }

    GALLOW_4 = %q{
        ___________
         \|/     |
          |     (*)
          |     /|\
          |      |
          |    
        _/|\________
        [][][][][][]

    }

    GALLOW_5 = %q{
        ___________
         \|/     |
          |     (*)
          |     /|\
          |      |
          |     / 
        _/|\________
        [][][][][][]

    }

    GALLOW_6 = %q{
        ___________
         \|/     |
          |     (*)
          |     /|\
          |      |
          |     / \
        _/|\________
        [][][][][][]

    }
end