=begin 
Implement a method #substrings that takes a word as the first argument 
and then an array of valid substrings (your dictionary) as the second argument. 
It should return a hash listing each substring (case insensitive) that was found 
in the original string and how many times it was found.
=end

ordbok = [
    "and", "but", "can", "do", "even", "for", "get", "he", "in", "just", "know", "like", "my", 
    "no", "or", "pet", "query", "ran", "so", "the", "up", "van", "we", "xing", "you", "zoo"
]

def substrings(string = "Can we not think of a string?", dictionary = ordbok)
    
end

substrings("But how many pets is the correct number? And can we call it a zoo?", ordbok)