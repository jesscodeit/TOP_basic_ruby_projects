=begin 
Implement a method #substrings that takes a word as the first argument 
and then an array of valid substrings (your dictionary) as the second argument. 
It should return a hash listing each substring (case insensitive) that was found 
in the original string and how many times it was found.
=end

def substrings(string = "Can you not think of a string?", ordbok)
    # create hash to store found words
    found_words = {}

    # split up the string into an array of words
    word_array = string.downcase.split(" ")

    # for each word in ordboken, iterate though each word in the word_array to see if it includes a word from ordbok
    ordbok.each do |b_word|
        word_array.each do |s_word|
            if s_word.include?(b_word)
                # if word exists in found_words array, increase value count by 1, otherwise assign value of 1
                found_words.include?(b_word) ? found_words[b_word] += 1 : found_words[b_word] = 1
            end
        end
    end
    # display the count of dictionary words found in the given string
    found_words
end

dictionary = [
    "and", "but", "can", "do", "even", "for", "get", "he", "in", "just", "know", "like", "my", 
    "no", "or", "pet", "query", "ran", "so", "the", "up", "van", "we", "xing", "you", "zoo"
]

substrings("Yes, I would like a pet, but not a formidable zoo!", dictionary)