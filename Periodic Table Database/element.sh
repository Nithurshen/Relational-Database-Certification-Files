#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]; then
    echo Please provide an element as an argument.
    exit 0
fi

input="$1"

result=$($PSQL "
SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
FROM elements e
JOIN properties p ON e.atomic_number = p.atomic_number
JOIN types t ON p.type_id = t.type_id
WHERE e.atomic_number::text = '$input' OR e.symbol = '$input' OR e.name = '$input';
")

if [ -z "$result" ]; then
    echo "I could not find that element in the database."
else
    IFS='|' read -r atomic_number symbol name atomic_mass melting boiling type <<< "$result"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting celsius and a boiling point of $boiling celsius."
fi
