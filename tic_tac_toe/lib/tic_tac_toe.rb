# create a game of tic tac toe, played between two humans on the command line.

$the_board = [1,2,3,4,5,6,7,8,9]

class Player
  attr_accessor :turns, :gets_next_turn
  attr_reader :player_mark 

  def initialize(player_mark)
    @player_mark = player_mark
    @turns = 0
    @wins = 0
    @gets_next_turn = false
  end
end

def start_game(player1, player2)
  puts "Let's play Tic Tac Toe!"
  reset_board
  display_board
  if (player1.turns === 0 && player2.turns === 0) || (player2.gets_next_turn === false)
    puts "Player #{player1.player_mark} you're up!"
    player2.gets_next_turn = true
    player1.turn
    next_turn(player1, player2)
  elsif player1.gets_next_turn === false
    puts "Player #{player2.player_mark} you're up!"
    player1.gets_next_turn = true
    player2.turn
    next_turn(player1, player2)
  end
end

def toggle_turn(player)
  player.gets_next_turn = !player.gets_next_turn
end

def next_turn(player1, player2)
  until winner?
    if player1.gets_next_turn === true
      toggle_turn(player1)
      toggle_turn(player2)
      player1.turn
    elsif player2.gets_next_turn === true
      toggle_turn(player1)
      toggle_turn(player2)
      player2.turn
    else
      puts "Uh oh, I don't know whose turn it is..."
    end
  end
end   

def turn
  puts "Player #{@player_mark}, where do you want to place your mark? Enter a number (1-9) for a spot that is open:"
  spot_choice = gets.chomp.to_i
  if spot_choice == $the_board[spot_choice - 1]
    $the_board[spot_choice - 1] = @player_mark
    puts "Ok. Your mark has been placed on spot #{spot_choice}."
    display_board
    @turns += 1
    if winner?
      declare_winner
      reset_game
    end
  elsif spot_choice.is_a? Numeric
    puts "I can't understand that. Please pick a number, 1-9 that hasn't already been marked."
    turn
  else 
    puts "Try again. Please pick a number (1-9) that hasn't already been marked."
    turn
  end
end

def winner?
  if ((@player_mark === $the_board[0]) && (@player_mark === $the_board[1]) && (@player_mark === $the_board[2])) ||
     ((@player_mark === $the_board[3]) && (@player_mark === $the_board[4]) && (@player_mark === $the_board[5])) ||
     ((@player_mark === $the_board[6]) && (@player_mark === $the_board[7]) && (@player_mark === $the_board[8])) ||
     #above checks for horizontal 3 in a row, below checks for vertical
     ((@player_mark === $the_board[0]) && (@player_mark === $the_board[3]) && (@player_mark === $the_board[6])) ||
     ((@player_mark === $the_board[1]) && (@player_mark === $the_board[4]) && (@player_mark === $the_board[7])) ||
     ((@player_mark === $the_board[2]) && (@player_mark === $the_board[5]) && (@player_mark === $the_board[8])) ||
     #below checks for diagonal 3 in a row
     ((@player_mark === $the_board[0]) && (@player_mark === $the_board[4]) && (@player_mark === $the_board[8])) ||
     ((@player_mark === $the_board[2]) && (@player_mark === $the_board[4]) && (@player_mark === $the_board[6]))
    return true
  else
    return false
  end
end

def declare_winner
  puts "That is three in a row! Player #{@player_mark} wins!"
  @wins += 1
end

def reset_board
  $the_board = [1,2,3,4,5,6,7,8,9]
end

def reset_game
  reset_board
  puts "Great game! Let's play again!"
  display_board
end

def display_board
  puts "Here is the board:"
  puts "#{$the_board[0]} #{$the_board[1]} #{$the_board[2]}"
  puts "#{$the_board[3]} #{$the_board[4]} #{$the_board[5]}"
  puts "#{$the_board[6]} #{$the_board[7]} #{$the_board[8]}"
end

# let's play

x = Player.new("X")
o = Player.new("O")

start_game(x, o)