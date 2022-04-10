#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART")
cat games.csv| while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $WINNER != 'winner' ]]
    then
      # get the team_id

       TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # If team_id not found
      if [[ -z $TEAM_ID  ]]
         then
      # Insert team   
             INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
             
             echo "Inserted: $WINNER"
      fi
  fi 
  if [[ $OPPONENT != 'opponent' ]]
    then
     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
     if [[ -z $OPPONENT_ID ]]
       then 
         INSERT_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
         echo "Inserted: $OPPONENT"
      fi

   
  
  
   fi
       
done
cat games.csv| while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  #get the new team_id
  WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") 
  OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  

  # #insert into games
  if  [[ $YEAR != 'year' &&  $ROUND != 'round'  && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
     then 
       INSERT_YEAR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,  '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
       echo "Inserting : $YEAR,  '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS" 
   
  fi
  

done

