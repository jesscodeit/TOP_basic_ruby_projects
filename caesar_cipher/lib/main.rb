require_relative 'caesar_cipher.rb'

cc = CaesarCipher.new
p cc.shift_this("Almost, but not quite, entirely unlike tea.", -42)