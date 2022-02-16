require './lib/caesar_cipher'

describe CaesarCipher do
  describe '#string_to_ascii_array' do
    it "returns an array of each string character's representative ascii decimal value" do
      cc = CaesarCipher.new
      expect(cc.string_to_ascii_array("Hello")).to eql([72, 101, 108, 108, 111])
    end

    it "functions with non letter characters in string" do
      cc = CaesarCipher.new
      expect(cc.string_to_ascii_array("1 tea, pls!")).to eql([49, 32, 116, 101, 97, 44, 32, 112, 108, 115, 33])
    end
  end

  describe "#min_shift" do
    it "returns the minimum representative shift factor if number given is larger than 25" do
      cc = CaesarCipher.new
      expect(cc.min_shift(50)).to eql(24)
    end

    it "returns the minimum representative shift factor if number given is smaller than -25" do
      cc = CaesarCipher.new
      expect(cc.min_shift(-30)).to eql(-4)
    end
  end

  describe "#shift_array" do
    it "returns an array of shifted ascii decimal values if all characters are letters" do
      cc = CaesarCipher.new
      arr = [72, 101, 108, 108, 111]
      sf = 3
      expect(cc.shift_array(arr, sf)).to eql([75, 104, 111, 111, 114])
    end

    it "returns an array of shifted ascii decimal values but does not shift values for characters that are not letters" do
      cc = CaesarCipher.new
      arr = [52, 50, 32, 99, 97, 116, 115, 33, 33]
      sf = 3
      expect(cc.shift_array(arr, sf)).to eql([52, 50, 32, 102, 100, 119, 118, 33, 33])
    end
  end

  describe "#ascii_array_to_string" do
    it "returns a string from an array of ascii values" do
      cc = CaesarCipher.new
      arr = [52, 50, 32, 99, 97, 116, 115, 33, 33]
      expect(cc.ascii_array_to_string(arr)).to eql("42 cats!!")
    end
  end

  describe "#shift_this" do
    it "it returns the given string that has been modified by the given shift factor" do
      cc = CaesarCipher.new
      expect(cc.shift_this("...Entirely unlike tea.", 42)).to eql("...Udjyhubo kdbyau juq.")
    end
  end
end