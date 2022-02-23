# create a game of tic tac toe, played between two humans on the command line.
require_relative 'player.rb'

class Game
  def initialize
    @player_x = Player.new('X')
    @player_o = Player.new('O')
    @board = [1,2,3,4,5,6,7,8,9]
    @current_p = @player_x
  end

  def play
    reset_game

    until winner?(@player_x) || winner?(@player_o) || tie?
      display_board
      turn(@current_p)
      switch
    end

    display_board
    if winner?(@player_x)
      @player_x.wins += 1
      declare_winner(@player_x)
    elsif winner?(@player_o)
      @player_o.wins += 1
      declare_winner(@player_o)
    else
      declare_tie
    end

    if play_again?
      play
    else
      puts "\nThanks for playing! Goodbye."
    end
  end

  def turn(player)
    prompt_turn(player)
    spot_choice = gets.chomp.to_i

    if spot_choice == @board[spot_choice -1]
      @board[spot_choice -1] = player.mark
    else
      puts "\nERROR! Please pick a number (1-9) that has not already been marked."
      turn(player)
    end
  end

  def switch
    if @current_p == @player_x
      @current_p = @player_o
    else
      @current_p = @player_x
    end
  end

  def winner?(player)
    m = player.mark
    b = @board

    if  ((b[0] == m) && (b[1] == m) && (b[2] == m)) ||
        ((b[3] == m) && (b[4] == m) && (b[5] == m)) ||
        ((b[6] == m) && (b[7] == m) && (b[8] == m)) ||
        #above checks horizontal wins
        ((b[0] == m) && (b[3] == m) && (b[6] == m)) ||
        ((b[1] == m) && (b[4] == m) && (b[7] == m)) ||
        ((b[2] == m) && (b[5] == m) && (b[8] == m)) ||
        #above checks vertical wins
        ((b[0] == m) && (b[4] == m) && (b[8] == m)) ||
        ((b[2] == m) && (b[4] == m) && (b[6] == m)) 
        #above checks diagonal wins
      return true
    else
      return false
    end
  end

  def tie?
    if @board.any? { |spot| spot.is_a? Numeric }
      return false
    else
      return true
    end
  end

  def play_again?
    prompt_play_again
    a = gets.chomp.to_i

    if a == 1
      true
    elsif a == 2
      false
    else 
      puts "\nERROR! Please submit the number 1 OR 2 to answer."
      play_again?
    end

  end

  def reset_game
    @board = [1,2,3,4,5,6,7,8,9]
    @current_p = @player_x
  end

  private

  def display_board
    puts <<~HEREDOC

     #{@board[0]} | #{@board[1]} | #{@board[2]}
    ---+---+---
     #{@board[3]} | #{@board[4]} | #{@board[5]}
    ---+---+---
     #{@board[6]} | #{@board[7]} | #{@board[8]}
    HEREDOC
  end

  def prompt_turn(player)
    puts <<~HEREDOC

    Player #{player.mark},
    Where do you want to place your mark?

    Enter a number (1-9) to choose the corresponding spot.

    HEREDOC

  end

  def declare_tie
    puts <<~HEREDOC

    This game has ended in a tie. 
    What a match-up!

    HEREDOC
  end

  def declare_winner(player)
    puts <<~HEREDOC

    *  *  *  *  *  *  *  *  *  *
    Congrats Player #{player.mark}!! YOU WIN!
    *  *  *  *  *  *  *  *  *  *

    Historical Game Wins:
    #{@player_x.mark}: #{@player_x.wins}
    #{@player_o.mark}: #{@player_o.wins}

    HEREDOC
  end

  def prompt_play_again
    puts <<~HEREDOC

    Would you like to play again?

    Enter:
    [1] To play again
    [2] To end game

    HEREDOC
  end

end