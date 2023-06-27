class GameUI
  def self.display_word(word, guessed_letters)
    display = word.chars.map { |letter| guessed_letters.include?(letter) ? letter : '_' }
    display.join(' ')
  end

  def self.display_hangman(hangman, incorrect_guesses)
    puts hangman.take(incorrect_guesses).join("\n")
  end

  def self.valid_guess?(guess)
    guess.match?(/[a-zA-Z]/)
  end

  def self.try_again?
    puts "\nDo you want to play again? (y/n)"
    choice = gets.chomp.downcase
    choice == 'y'
  end

  def self.game_over(secret_word)
    puts "\nGame Over! You ran out of guesses."
    puts "The secret word was '#{secret_word}'."
  end
end
