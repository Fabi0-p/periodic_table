#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1';" | sed -r 's/^ *| *$//g')
    if [[ -z $ATOMIC_NUMBER ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1';" | sed -r 's/^ *| *$//g')
    fi
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1';" | sed -r 's/^ *| *$//g')
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;" | sed -r 's/^ *| *$//g')
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;" | sed -r 's/^ *| *$//g')    
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass::REAL FROM properties WHERE atomic_number = $ATOMIC_NUMBER;" | sed -r 's/^ *| *$//g')
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;" | sed -r 's/^ *| *$//g')
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;" | sed -r 's/^ *| *$//g')
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER;" | sed -r 's/^ *| *$//g')
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
