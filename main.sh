#!/usr/bin/env bash

echo -n "Generazione PDF relazione: " &&
(cd relazione && ./generate.sh > /dev/null 2> /dev/null) &&
echo "OK" &&

echo -n "Creazione DB: " &&
psql basi28 basi28 < ddl_dml.sql > /dev/null 2> /dev/null &&
echo "OK" &&

echo -n "Popolamento DB: " &&
(cd R && Rscript popolamentoDB.r > /dev/null 2> /dev/null &&
         Rscript grafici.r > /dev/null 2> /dev/null) &&
echo "OK" && exit 0

echo
echo
echo "-- ERRORE --"
exit 1
