#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~ Number Guessing Game ~~~\n"

MIN=1
MAX=1000

# generate random number between 1 and 1000
RANDOM_NUMBER=$(($RANDOM%($MAX-$MIN+1)+$MIN))

GUESS_COUNTER=0

GET_USER() {
  echo "Enter your username:"

  read USERNAME

  # get user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  # if it doesn't exist
  if [[ -z $USER_ID ]]
  then
    # insert new user into database
    INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    echo "Welcome, $USERNAME! It looks like this is your first time here."  
  # if it exists
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

  # if user_guess is greater than random_number
  if [[ $USER_GUESS -gt $RANDOM_NUMBER ]]
  then
    echo "The random number is $RANDOM_NUMBER"
    GUESS_COUNTER=$(( $GUESS_COUNTER+1 ))
    PLAY_GAME "It's lower than that, guess again:"

  # if user_guess is less than random_number
  elif [[ $USER_GUESS -lt $RANDOM_NUMBER ]]
  then
    echo "The random number is $RANDOM_NUMBER"
    GUESS_COUNTER=$(( $GUESS_COUNTER+1 ))
    PLAY_GAME "It's higher than that, guess again:"
    
  # if user_guess is equal to random_number
  else
    echo "The random number is $RANDOM_NUMBER"
    GUESS_COUNTER=$(( $GUESS_COUNTER+1 ))
    echo -e "\nYou guessed it in $GUESS_COUNTER tries. The secret number was $RANDOM_NUMBER. Nice job!"
  fi
}

GET_USER
PLAY_GAME

