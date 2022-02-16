require './lib/calculator'

describe Calculator do    ##describe the class
  describe "#add" do      ##describe the method example group
    it "returns the sum of two numbers" do    ##write your test case/example with it
      calculator = Calculator.new
      expect(calculator.add(5,2)).to eql(7)   ##write your expectation using expect, limit one expect clause per test case
    end

    it "returns the sum of more than two numbers" do
      calculator = Calculator.new
      expect(calculator.add(2,5,7)).to eql(14)
    end
  end

  describe "#multiply" do
    it "returns the total of one number multiplied by another" do
      calculator = Calculator.new
      expect(calculator.multiply(5,2)).to eql(10)
    end

    it "returns the total of a number multiplied by more than one number" do
      calculator = Calculator.new
      expect(calculator.multiply(5,2,7)).to eql(70)
    end
  end
end