class Calculator
  def add(a,*args)
    args.each {|i| a += i} 
    a
  end

  def multiply(a,*args)
    args.each { |i| a *= i}
    a
  end
end