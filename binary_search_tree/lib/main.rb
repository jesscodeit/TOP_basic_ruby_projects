require_relative 'tree.rb'

elm = Tree.new(Array.new(15) { rand(1..100) })
elm.pretty_print

puts "Is tree balanced?"
p elm.balanced?

puts "Level Order:"
elm.level_order
puts "Preorder:"
p elm.preorder
puts "Postorder:"
p elm.postorder
puts "In-order:"
p elm.inorder

puts "Adding nodes:r"
elm.insert(142)
elm.insert(242)
elm.insert(111)
elm.insert(250)
elm.pretty_print

puts "Is tree balanced?"
p elm.balanced?

puts "Rebalance:"
elm.rebalance
elm.pretty_print

puts "Is tree balanced?"
p elm.balanced?

puts "Level Order:"
elm.level_order
puts "Preorder:"
p elm.preorder
puts "Postorder:"
p elm.postorder
puts "In-order:"
p elm.inorder