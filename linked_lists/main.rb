require_relative 'class_linked_list.rb'

animals = LinkedList.new

animals.append("freyja")
animals.append("kira")
animals.append("ella")
animals.prepnd("mischa")
animals.to_s
p animals.size
animals.at(3)
animals.pop
animals.remove_at(0)
animals.to_s