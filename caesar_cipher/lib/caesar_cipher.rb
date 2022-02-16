class CaesarCipher
  #return a shifted string using the given string and shift factor
  def shift_this(string, shift_factor)
    array = string_to_ascii_array(string)
    shift_factor = min_shift(shift_factor)
    shifted_array = shift_array(array, shift_factor)
    return ascii_array_to_string(shifted_array)
  end

  ########## ideally, the below methods would be private
  #have left them public bc the last task was to test w/ RSpec

  #convert given string into an array of ascii decimal values
  #return the array
  def string_to_ascii_array(string)
    arr = string.split("").map { |x| x.ord }
    arr
  end

  #keep the shift factor as its minimum representative number
  #return the (un)altered shift factor
  def min_shift(shift_factor)
    if shift_factor >= 26
      shift_factor % 26 
    elsif shift_factor <= -26
      shift_factor % -26
    else
      shift_factor
    end
  end

  #in given array, shift each ascii decimal value by the shift factor
  #do not shift values that are not representative of letters
  #return an array of the shifted values
  def shift_array(array, shift_factor)
    array.map do |n|
      # uppercase letter
      if n.between?(65,90)
        if shift_factor.positive?
          (n + shift_factor > 90) ? (n + shift_factor - 26) : (n + shift_factor)
        else
          (n + shift_factor < 65) ? (n + shift_factor + 26) : (n + shift_factor)
        end

      # lowercase letter    
      elsif n.between?(97,122)
        if shift_factor.positive?
          (n + shift_factor > 122) ? (n + shift_factor - 26) : (n + shift_factor)
        else
          (n + shift_factor < 97) ? (n + shift_factor + 26) : (n + shift_factor)
        end

      # other character
      else
        n
      end
    end
  end

  #convert given array of ascii decimals into respective characters
  #return joined as a string
  def ascii_array_to_string(array)
    array.map { |n| n.chr }.join
  end
end