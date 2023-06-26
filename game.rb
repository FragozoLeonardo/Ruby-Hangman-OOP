require 'pathname'

class Game
  def initialize
    @guessed_letters = []
    @incorrect_guesses = []
    @max_guesses = 6
    @hangman = [
      '  O  ',
      ' /|\\ ',
      '  |  ',
      ' / \\ ',
      '-----'
    ]
  end

  def display_word(word)
    display = word.chars.map { |letter| @guessed_letters.include?(letter) ? letter : '_' }
    display.join(' ')
  end

  def display_game_state(word)
    puts "Word: #{display_word(word)}"
    puts "Incorrect Guesses: #{@incorrect_guesses.join(', ')}"
    puts "Guesses Remaining: #{@max_guesses - @incorrect_guesses.length}"
    puts "\n"
    display_hangman
  end

  def display_hangman
    puts '  You'
    puts @hangman[0] if @incorrect_guesses.length >= 1
    puts @hangman[1] if @incorrect_guesses.length >= 2
    puts @hangman[2] if @incorrect_guesses.length >= 3
    puts @hangman[3] if @incorrect_guesses.length >= 4
    puts @hangman[4] if @incorrect_guesses.length >= 5
  end

  def game_over(word)
    puts "Game Over! You ran out of guesses. The word was '#{word}'."
  end

  def try_again?
    puts "\nDo you want to try again? (Y/N)"
    choice = gets.chomp.downcase
    choice == 'y'
  end

  def valid_guess?(guess)
    /^[a-zA-Z]$/.match?(guess)
  end

  def start_game
    loop do
      # Load the dictionary file
      dictionary_path = Pathname.new('dict/google-10000-english-no-swears.txt')
      dictionary = File.readlines(dictionary_path).map(&:chomp)

      # Select a random word between 5 and 12 characters long
      secret_word = ''
      loop do
        secret_word = dictionary.sample
        break if (5..12).cover?(secret_word.length)
      end

      puts 'Hangman Game Started!'

      loop do
        display_game_state(secret_word)

        puts "\nEnter your guess (a letter):"
        guess = gets.chomp.downcase

        unless valid_guess?(guess)
          puts "Invalid guess. Please enter a single alphabetic letter."
          next
        end

        if @guessed_letters.include?(guess) || @incorrect_guesses.include?(guess)
          puts "You already guessed '#{guess}'. Try again."
          next
        end

        if secret_word.include?(guess)
          @guessed_letters << guess
          puts "Correct guess! '#{guess}' is in the word."
        else
          @incorrect_guesses << guess
          puts "Incorrect guess. '#{guess}' is not in the word."
        end

        if @incorrect_guesses.length >= @max_guesses
          game_over(secret_word)
          break
        end

        if secret_word.chars.all? { |letter| @guessed_letters.include?(letter) }
          puts "Congratulations! You guessed the word '#{secret_word}' correctly!"
          break
        end
      end

      break unless try_again?
      reset_game
    end
  end

  private

  def reset_game
    @guessed_letters = []
    @incorrect_guesses = []
  end
end

game = Game.new
game.start_game
