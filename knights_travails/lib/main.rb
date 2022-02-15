require_relative 'board.rb'
require_relative 'knight.rb'

meep = Board.new 
start = [0,1]
stop = [7,7]
puts "Find path from #{start} to #{stop}:"
meep.find_path(start, stop)