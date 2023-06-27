require_relative 'dictionary'
require_relative 'game_ui'
require 'yaml'

class Hangman
  SAVE_FILE = 'hangman_save.txt'

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

  def load_game
    if File.exist?(SAVE_FILE)
      saved_game = YAML.load_file(SAVE_FILE)
      if saved_game.is_a?(Hash)
        @guessed_letters = saved_game[:guessed_letters] || []
        @incorrect_guesses = saved_game[:incorrect_guesses] || []
        return saved_game[:secret_word]
      end
    end

    puts "No save file found. Please play a new game and create a new save."
    nil
  end

  def save_game(secret_word)
    game_state = {
      secret_word: secret_word,
      guessed_letters: @guessed_letters,
      incorrect_guesses: @incorrect_guesses
    }
    File.open(SAVE_FILE, 'w') do |file|
      file.write(YAML.dump(game_state))
    end
    puts "Game saved successfully!"
  end

  def select_secret_word
    words = Dictionary.load_words
    Dictionary.select_secret_word(words)
  end

  def reset_game
    @guessed_letters = []
    @incorrect_guesses = []
  end

  def display_word(word)
    guessed_word = word.chars.map { |letter| @guessed_letters.include?(letter) ? letter : '*' }.join('')
    if guessed_word == word && word.delete(' ').length > 0
      puts "\nSecret word: #{guessed_word.gsub('_', '*')}"
      puts "Guessed letters: #{@guessed_letters}"
      puts "Correct guesses: #{@guessed_letters & word.chars}"
      puts "Incorrect guesses: #{@incorrect_guesses}"
      GameUI.display_hangman(@hangman, @incorrect_guesses.length)
      puts "\nCongratulations! You guessed the word '#{word}' correctly!"
      return :win
    else
      return guessed_word
    end
  end

  def display_game_state(secret_word)
    guessed_word = display_word(secret_word).gsub('_', ' ')
    puts "\nSecret word: #{guessed_word}"
    puts "Guessed letters: #{@guessed_letters}"
    puts "Correct guesses: #{@guessed_letters & secret_word.chars}"
    puts "Incorrect guesses: #{@incorrect_guesses}"
    GameUI.display_hangman(@hangman, @incorrect_guesses.length)
  end

  def valid_guess?(guess)
    GameUI.valid_guess?(guess)
  end

  def try_again?
    GameUI.try_again?
  end

  def game_over(secret_word)
    GameUI.game_over(secret_word)
  end

  def start_game
    loop do
      puts "Hangman Game Started! - a game by Leonardo Quadros Fragozo."
      puts "1. New Game"
      puts "2. Load Game"
      choice = gets.chomp.to_i

      case choice
      when 1
        secret_word = select_secret_word
      when 2
        secret_word = load_game
        next unless secret_word
      else
        puts "Invalid choice. Please select 1 or 2."
        next
      end

      loop do
        display_game_state(secret_word)

        puts "\nEnter a letter to guess or type 'save' to save the game:"
        choice = gets.chomp.downcase

        if choice == 'save'
          save_game(secret_word)
          next
        end

        if choice.length != 1 || !valid_guess?(choice)
          puts "Invalid input. Please enter a single letter or type 'save' to save the game."
          next
        end

        guess = choice.downcase

        if @guessed_letters.include?(guess)
          puts "You have already guessed that letter. Please try again."
          next
        end

        @guessed_letters << guess

        if secret_word.include?(guess)
          puts "Correct guess!"
        else
          puts "Incorrect guess!"
          @incorrect_guesses << guess
        end

        if display_word(secret_word) == :win
          break unless try_again?
          reset_game
          break
        end

        if @incorrect_guesses.length >= @max_guesses
          display_game_state(secret_word)
          game_over(secret_word)
          break
        end
      end

      break unless try_again?
      reset_game
    end
  end

  def word_guessed?(secret_word)
    secret_word.chars.all? { |letter| @guessed_letters.include?(letter) }
  end
end
