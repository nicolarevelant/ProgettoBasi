-- Query 1: Dato P proprietario per ogni condominio avente almeno 1 app. posseduto da P, elencare le ultime 5 spese dal registro spese.

SELECT *
FROM   spesa S1
WHERE  condominio IN
        (SELECT condominio
         FROM appartamento
         WHERE proprietario = 'x')
AND "dataOra" IN
        (SELECT "dataOra"
         FROM spesa S2
         WHERE S1.condominio = S2.condominio
         ORDER BY "dataOra" DESC LIMIT 5);

-- Query 2: Elenco spese dell'anno corrente dei condomini che possiedono almeno 10 appartamenti.

CREATE VIEW "condominiMedioGrandi"(condominio) AS
(SELECT   condominio
 FROM     appartamento
 GROUP BY condominio HAVING COUNT(*) >= 10);

SELECT   C.condominio, "dataOra", importo, causale
FROM     "condominiMedioGrandi" C INNER JOIN spesa S ON C.condominio = S.condominio
ORDER BY "dataOra", C.condominio;

-- Query 2 - variante 2

SELECT C.condominio, "dataOra", importo, causale
FROM   (SELECT condominio
        FROM appartamento
        GROUP BY condominio HAVING COUNT(*) >= 10) C
INNER JOIN spesa S ON C.condominio = S.condominio ORDER BY "dataOra", C.condominio;

-- Query 3: Importo complessivo delle spese di tutti i condomini con **ammontareComplessivo** tra 50 e 100 compresi.

SELECT SUM(importo)
FROM   (condominio C JOIN spesa S ON C.codice = S.condominio)
WHERE  "ammontareComplessivo" BETWEEN 50 AND 100;

-- Query 4: Query elenco persone che possiedono l'appartamento in cui abitano.

SELECT cf
FROM   persona P
WHERE  EXISTS  (SELECT *
                FROM   appartamento
                WHERE  P."numeroAppartamento" = numero AND
                       P.condominio = condominio AND
                       P.cf = proprietario);

-- Query 4 - variante 2

SELECT cf
FROM   (persona P JOIN appartamento A ON P.cf = A.proprietario)
WHERE  P."numeroAppartamento" = A.numero AND P.condominio = A.condominio;

-- Query 5: Query elenco persone più anziane che possiedono un appartamento di superficie >= 50.

SELECT cf
FROM   (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
WHERE  superficie >= 50 AND "dataNascita" = (SELECT MIN(P2."dataNascita")
                                             FROM   persona P2);

-- Query 5 - variante 2

SELECT DISTINCT P.cf
FROM   (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
WHERE  A.superficie >= 50 AND "dataNascita" = (SELECT MIN(P2."dataNascita")
                                               FROM   (persona P2 JOIN appartamento A2 ON P2.cf = A2.proprietario)
                                               WHERE  A2.superficie >= 50);

-- Query semplice 1: Ammontare complessivo per ogni condominio

SELECT codice, "ammontareComplessivo"
FROM condominio;

-- Query semplice 2: Indirizzo di ogni proprietario

SELECT P.cf, P.indirizzo
FROM persona P INNER JOIN appartamento A ON P.cf = A.proprietario
WHERE P.indirizzo IS NOT NULL

UNION

SELECT P.cf, C.indirizzo
FROM (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
INNER JOIN condominio C
ON P.condominio = C.codice
WHERE P.indirizzo IS NULL;

