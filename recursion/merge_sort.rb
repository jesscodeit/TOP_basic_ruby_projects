def merge_sort(arr)
  #base case
  if arr.length == 1
    return arr

  #recursive case
  else
    #sort left half
    l = merge_sort(arr[0...(arr.length/2)])
    #sort right half
    r = merge_sort(arr[(arr.length/2)..])
    #merge sorted halves
    merge(l,r)
  end
end

def merge(l, r)
  sorted_arr = []

  while !l.empty? && !r.empty?
    if l[0] > r[0]
      sorted_arr << r.shift
    else
      sorted_arr << l.shift
    end
  end

  #concat the remaining single number that can't be matched against nil
  sorted_arr.concat(l).concat(r)
end

a = [4,2,5,1,6,3]
puts "Unsorted: #{a}" 
puts "Sorted: #{merge_sort(a)}"