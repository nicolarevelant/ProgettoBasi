#!/usr/bin/env bash

(
    echo -n "Generazione PDF relazione: " &&
    (cd relazione && ./generate.sh > /dev/null 2> /dev/null) &&
    echo "OK"

    echo -n "Creazione DB: " &&
    psql test test < ddl_dml.sql > /dev/null 2> /dev/null &&
    echo "OK" &&

    echo -n "Popolamento DB: " &&
    (cd R && Rscript popolamentoDB.r > /dev/null 2> /dev/null) &&
    echo "OK"
) || (
    echo
    echo
    echo "-- ERRORE --"
)