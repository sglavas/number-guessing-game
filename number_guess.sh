#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


MIN=1
MAX=1000

# generate random number between 1 and 1000
RANDOM_NUMBER=$(($RANDOM%($MAX-$MIN+1)+$MIN))

GUESS_COUNTER=0

echo "Enter your username:"

read USERNAME


GET_USER() {
  # get user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  # if it doesn't exist
  if [[ -z $USER_ID ]]
  then
    # insert new user into database
    INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(name, games_played, best_game) VALUES('$USERNAME', 0, NULL)")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    echo "Guess the secret number between 1 and 1000:"
  # if it exists
  else
    # get games_played
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name='$USERNAME'")
    
    # get best_game
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name='$USERNAME'")

    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    echo "Guess the secret number between 1 and 1000:"
  fi

}

PLAY_GAME() {
  if [[ $1 ]]
  then
    echo "$1"
  fi


  read USER_GUESS
  
  if ! [[ "$USER_GUESS" =~ ^[0-9]+$ ]]
  then
    PLAY_GAME "That is not an integer, guess again:"
  else
    # if user_guess is greater than random_number
    if [[ $USER_GUESS -gt $RANDOM_NUMBER ]]
    then
      GUESS_COUNTER=$(( $GUESS_COUNTER+1 ))
      PLAY_GAME "It's lower than that, guess again:"

    # if user_guess is less than random_number
    elif [[ $USER_GUESS -lt $RANDOM_NUMBER ]]
    then
      GUESS_COUNTER=$(( $GUESS_COUNTER+1 ))
      PLAY_GAME "It's higher than that, guess again:"
      
    # if user_guess is equal to random_number
    else
      GUESS_COUNTER=$(( $GUESS_COUNTER+1 ))
      echo "You guessed it in $GUESS_COUNTER tries. The secret number was $RANDOM_NUMBER. Nice job!"

      # check for games played 
      GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name='$USERNAME'")

      # if empty
      if [[ $GAMES_PLAYED -eq 0 ]]
      then
        # update games_played to 1 and best_game to $GUESS_COUNTER
        UPDATE_ROWS_RESULT=$($PSQL "UPDATE users SET games_played=1, best_game=$GUESS_COUNTER WHERE name='$USERNAME'")
     
      # if not empty
      else
        # increment games_played
        GAMES_PLAYED=$(( $GAMES_PLAYED+1 ))
        # get best_game
        BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name='$USERNAME'")
        
        # check if $GUESS_COUNTER less than $BEST_GAME
        if [[ $GUESS_COUNTER -lt $BEST_GAME ]]
        # if less than, update games_played with the incremented $GAMES_PLAYED amd best_game with the $GUESS_COUNTER
        then
          UPDATE_ROWS_RESULT=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED, best_game=$GUESS_COUNTER WHERE name='$USERNAME'")
        # if greater than, only update games_played with the incremented $GAMES_PLAYED
        else
          UPDATE_ROWS_RESULT=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE name='$USERNAME'")
        fi
      fi
    fi
  fi  
}

GET_USER
PLAY_GAME

