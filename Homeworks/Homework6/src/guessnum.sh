#!/bin/bash

target=$(( RANDOM % 100 + 1 ))

max_attempts=5
attempt=1

echo "Guess the number between 1 and 100! You have $max_attempts attempts."

while [ $attempt -le $max_attempts ]; do
  read -p "Attempt $attempt: Enter your guess: " guess

  if ! echo "$guess" | grep -qE '^[0-9]+$'; then
    echo "Please enter a valid number."
    continue
  fi

  guess_num=$((guess))

  if [ "$guess_num" -eq "$target" ]; then
    echo "🎉 Congratulations! You guessed the right number."
    exit 0
  elif [ "$guess_num" -lt "$target" ]; then
    echo "Too low!"
  else
    echo "Too high!"
  fi

  ((attempt++))
done

echo "❌ Sorry, you've run out of attempts. The correct number was $target."

