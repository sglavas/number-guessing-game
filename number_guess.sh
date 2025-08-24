#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~ Number Guessing Game ~~~\n"

MIN=1
MAX=1000

RANDOM_NUMBER=$(($RANDOM%($MAX-$MIN+1)+$MIN))

GET_USER() {
  echo "Enter your username:"

  read USERNAME

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  if [[ -z $USER_ID ]]
  then
    INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    echo "Welcome, $USERNAME! It looks like this is your first time here."  
  else
    echo "Welcome back, $USERNAME! You have played <games_played> games, and your best game took <best_game> guesses."
  fi
}

PLAY_GAME() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nGuess the secret number between 1 and 1000:"

  read USER_GUESS


  if [[ $USER_GUESS -gt $RANDOM_NUMBER ]]
  then
    echo "The random number is $RANDOM_NUMBER"
    PLAY_GAME "It's lower than that, guess again:"
  elif [[ $USER_GUESS -lt $RANDOM_NUMBER ]]
  then
    echo "The random number is $RANDOM_NUMBER"
    PLAY_GAME "It's higher than that, guess again:"
  else
    echo "The random number is $RANDOM_NUMBER"
    echo -e "\nYou guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!"
  fi
}

GET_USER
PLAY_GAME

