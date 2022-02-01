# Hangman
This is a command line version of the Hangman game. It is project prompt is from The Odin Project curriculum.

## About & Features
### Start Game
- When gameplay is initiated, a secret word that is between 5 and 12 characters long will be selected from this [dictionary file](https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt).
- The game will display an empty hangman diagram, tell the player how long the secret word is and also display the word as an underscore in replace of each letter: _ _ _ _ _ 

### Game Turns
- The player guesses the word one letter at a time.
- If the letter guessed exists in the word, the game will show the letter as it appears in the secret word: _ e _ _ e _ 
- If the letter guessed does not exist in the word, the game will add the letter to a list of guessed letters and add a body part to the hangman diagram.
- There are six body parts in total. The player can continue to guess until either the word is complete or the body is drawn in full.

### Save Game
- The player is given the option to save the game at any time.
- When gameplay is complete the player can start a new game or load a previously saved game.