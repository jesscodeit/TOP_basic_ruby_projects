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

    def word_set(word)
        length = word.length
        <<~HEREDOC
        - - - - - - - - - - - - - - - - - - - - - - - - -
        Here we go! 
        We've got a super secret word picked out for you.
        It is #{length} letters long.
        HEREDOC
    end

    DOUBLE_CHECK = <<~HEREDOC
        - - - - - - - - - - - - - - - - - - - - - - - - -
        It look's like you're playing a game that you
        have not saved... 

        Are you sure you want to open a different game?
        Or would you like to save your open game first?

        [save] To save your current game
        [1] To start a new game
        [2] To continue a saved game
        - - - - - - - - - - - - - - - - - - - - - - - - -
        HEREDOC

    GIBBERISH = <<~HEREDOC
        - - - - - - - - - - - - - - - - - - - - - - - - -
        Sorry, I didn't understand that...
        Please re-enter your response.
        - - - - - - - - - - - - - - - - - - - - - - - - -
        HEREDOC

    def template()
        <<~HEREDOC
        - - - - - - - - - - - - - - - - - - - - - - - - -
        - - - - - - - - - - - - - - - - - - - - - - - - -
        HEREDOC
    end

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
          |     
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