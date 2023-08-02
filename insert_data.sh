#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then
  # Get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  # If not found
  if [[ -z $WINNER_ID ]]
  then
    # Insert into teams
​    INSERT_INTO_TEAMS_RESULT_1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
​    if [[ $INSERT_INTO_TEAMS_RESULT_1 == "INSERT 0 1" ]]
​    then
​      echo "Inserted into teams: winner: $WINNER"
​    fi
  fi
  # Get winner_id again
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

  # Get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  # If not found
  if [[ -z $OPPONENT_ID ]]
  then
    # Insert into teams
​    INSERT_INTO_TEAMS_RESULT_2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
​    if [[ $INSERT_INTO_TEAMS_RESULT_2 == "INSERT 0 1" ]]
​    then
​      echo "Inserted into teams: opponent: $OPPONENT"
​    fi
  fi
  # Get opponent_id again
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")


  # Insert into games
  INSERT_INTO_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_INTO_GAMES_RESULT == "INSERT 0 1" ]]
  then
    echo "Inserted into games: year:$YEAR round:$ROUND winner_id:$WINNER_ID opponent_id:$OPPONENT_ID winner_goals:$WINNER_GOALS opponent_goals:$OPPONENT_GOALS"
  fi

fi
done