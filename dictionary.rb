require 'pathname'

class Dictionary
  DICTIONARY_FILE = 'dict/google-10000-english-no-swears.txt'

  def self.load_words
    dictionary_path = Pathname.new(DICTIONARY_FILE)
    words = []

    if dictionary_path.exist?
      File.open(dictionary_path, 'r') do |file|
        file.each_line do |line|
          words << line.chomp.downcase
        end
      end
    else
      puts "Oops! The dictionary file '#{DICTIONARY_FILE}' does not exist."
    end

    words
  end

  def self.select_secret_word(words)
    words.sample
  end
end
