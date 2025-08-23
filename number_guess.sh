#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~ Number Guessing Game ~~~\n"

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


GET_USER


