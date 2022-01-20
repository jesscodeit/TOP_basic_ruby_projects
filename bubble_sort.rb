=begin
Build a method #bubble_sort that takes an array and returns a sorted array. 
It must use the bubble sort methodology. 
=end

def bubble_sort(array_of_numbers)
    # create a repeat value that will ensure code loops enough times to sort all numbers
    (array_of_numbers.length - 1).times do |repeat_num|

        # for each number in the array, do the following
        array_of_numbers.each_with_index do |number, index|

            # and if the number we are looking at is not the last number, do this
            if index < array_of_numbers.length - 1

                # is the current number bigger than the next number
                if number > array_of_numbers[index + 1]

                    # if so, swap the numbers
                    bigger_num = array_of_numbers[index] 
                    array_of_numbers[index] = array_of_numbers[index + 1]
                    array_of_numbers[index + 1] = bigger_num

                end
            end
        end
    end
    p array_of_numbers
end

numbers = [4,3,78,2,0,2]

bubble_sort(numbers)   