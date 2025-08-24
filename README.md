# Number Guessing Game

## Overview

This is a simple command-line number guessing game built in Bash with a PostgreSQL backend to store user statistics.

---

## Features

- Generates a random number between **1 and 1000**.
- Stores user information (’username’, ‘games_played’, ‘best_game’) in PostgreSQL.
- Tracks the number of guesses per game.
- Updates user’s **best game** if they beat their previous record.
- Ensures only integers are accepted as guesses.

---

## Technologies Used

- **Bash**
- **PostgreSQL**

---

## Installation & Setup

1. Clone the repo
  ```bash
  git clone https://github.com/sglavas/number-guessing-game.git
  cd number-guessing-game
  ```
2.  Create the PostgreSQL database
  ```sql
  CREATE DATABASE number_guess;
  ```
3. Set up the users table
  ```sql
  CREATE TABLE users(
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(22) NOT NULL,
    games_played INT NOT NULL,
    best_game INT
  );
  ```
4. Run the game
  ```bash
  ./number_guess.sh
  ```

---

## Usage Example

```bash
$ ./number_guess.sh
Enter your username:
alex
Welcome, alex! It looks like this is your first time here.
Guess the secret number between 1 and 1000:
500
It's lower than that, guess again:
250
It's higher than that, guess again:
375
You guessed it in 3 tries. The secret number was 375. Nice job!
```

---

## Future Improvements

* Add difficulty levels (e.g., 1-100, 1-5000).
* Add different messages according to how close the user's guess is to the random number
* Add a leaderboard feature.

---

## Author

Developed as a learning project for Bash scripting, PostgreSQL integration, and using VCS.
