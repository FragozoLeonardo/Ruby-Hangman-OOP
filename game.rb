require 'securerandom'
require 'pathname'

dictionary_path = Pathname.new('dict/google-10000-english-no-swears.txt')

dictionary = File.readlines(dictionary_path).map(&:chomp)

secret_word = ''
loop do
  secret_word = dictionary.sample
  break if (5..12).cover?(secret_word.length)
end

puts "Secret Word: #{secret_word}"
