def fibs(number)
  arr = []
  number.times do |i|
    if i == 0
      arr << 0
    elsif i == 1
      arr << 1
    else
      arr << (arr[-1] + arr[-2])
    end
  end

  p arr
end

def fibs_rec(number)
  #base case
  return [0,1] if number == 2 

  #recursive case
  arr = fibs_rec(number - 1)
  arr << arr[-1] + arr[-2]
end

fibs(10)
p fibs_rec(10)