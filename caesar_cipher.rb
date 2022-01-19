# implement a caesar cipher that takes a string and the shift factor and then outputs the modified string
require 'pry-byebug'

def caesar_cipher(string, shift_factor = -27)
    # covert string into an array of ascii decimal values
    ascii_array = string.split("").map { |x| x.ord }

    # keep the shift factor to its mimimum representative number
    shift_factor = (shift_factor >= 26) ? (shift_factor % 26) : shift_factor
    shift_factor = (shift_factor <= -26) ? (shift_factor % -26) : shift_factor

    shifted_asciis = ascii_array.map do |index|
        # if uppercase letter
       if index.between?(65,90)
            if shift_factor.positive?
                (index + shift_factor > 90) ? (index + shift_factor - 26) : (index + shift_factor)
            else
                (index + shift_factor < 65) ? (index + shift_factor + 26) : (index + shift_factor)
            end
        # else if lowercase letter    
       elsif index.between?(97,122)
            if shift_factor.positive?
                (index + shift_factor > 122) ? (index + shift_factor - 26) : (index + shift_factor)
            else
                (index + shift_factor < 97) ? (index + shift_factor + 26) : (index + shift_factor)
            end
        # else if other character, keep as is 
       else
           index
       end
    end

    # convert shifted ascii decimals back into characters and join all
    shifted_string = shifted_asciis.map { |decimal| decimal.chr }.join

    puts "The original message: '#{string}' has been altered by a shift factor of #{shift_factor}"
    puts "The ciphered message is:'#{shifted_string}'"
end

caesar_cipher("It's me, Jess!")
