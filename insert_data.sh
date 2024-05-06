#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE teams,games RESTART IDENTITY")"

cat games.csv | while IFS="," read YEAR ROUND TEAMWINNAME TEAMOPPNAME TEAMWINSCORE TEAMOPPSCORE
do
  #to skip top row, check that $YEAR isn't 'year'
  if [[ $YEAR != year ]]
  then
    #query table teams for $TEAMWINNAME
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAMWINNAME'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert $TEAMWINNAME to table teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAMWINNAME')")
      echo $INSERT_TEAM_RESULT
    fi
    #query table teams for $TEAMOPPNAME
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAMOPPNAME'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert $TEAMOPPNAME to table teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAMOPPNAME')")
      echo $INSERT_TEAM_RESULT
    fi
    #determine winner id and opponent id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAMWINNAME'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAMOPPNAME'")

    #insert $YEAR, $ROUND, $TEAMWINNAME, $TEAMOPPNAME, $TEAMWINSCORE, $TEAMWINSCORE, $WINNER_ID, $OPP_ID to table games in col year
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$TEAMWINSCORE,$TEAMOPPSCORE,$WINNER_ID,$OPP_ID)")
      echo$INSERT_YEAR_RESULT

  fi
done
