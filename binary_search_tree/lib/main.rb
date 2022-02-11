require_relative 'tree.rb'

elm = Tree.new([1,7,4,23,8,9,4,3,5,7,9,67,6345,324])

puts "initial tree"
elm.pretty_print

puts "adding nodes"
elm.insert(42)
elm.insert(41)
elm.insert(100)
elm.insert(142)
elm.insert(111)
elm.insert(70)
elm.insert(99)
elm.pretty_print

puts "deleting nodes 3 and 67"
elm.delete(3)
elm.delete(67)
elm.pretty_print