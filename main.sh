#!/usr/bin/env bash

echo -n "Creazione DB: " &&
psql basi28 basi28 < ddl_dml.sql > /dev/null 2> /dev/null &&
echo "OK" &&

echo -n "Popolamento DB: " &&
(cd R && Rscript popolamentoDB.r) &&
echo "OK" &&

echo -n "Generazione grafici: " &&
(cd R && Rscript grafici.r) &&
echo "OK" &&

echo -n "Generazione PDF relazione: " &&
(cd relazione && ./generate.sh > /dev/null 2> /dev/null) &&
echo "OK" && exit 0

echo
echo
echo "-- ERRORE --"
exit 1
