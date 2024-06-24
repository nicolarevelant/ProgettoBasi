-- Query 1

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

-- Query 2

CREATE VIEW "condominiMedioGrandi"(condominio) AS
(SELECT   condominio
 FROM     appartamento
 GROUP BY condominio HAVING COUNT(*) >= 10);

SELECT   C.condominio, "dataOra", importo, causale
FROM     "condominiMedioGrandi" C INNER JOIN spesa S ON C.condominio = S.condominio
ORDER BY "dataOra", C.condominio;

-- variante 2

SELECT C.condominio, "dataOra", importo, causale
FROM   (SELECT condominio
        FROM appartamento
        GROUP BY condominio HAVING COUNT(*) >= 10) C
INNER JOIN spesa S ON C.condominio = S.condominio ORDER BY "dataOra", C.condominio;

-- Query 3

SELECT SUM(importo)
FROM   (condominio C JOIN spesa S ON C.codice = S.condominio)
WHERE  "ammontareComplessivo" BETWEEN 50 AND 100;

-- Query 4

SELECT cf
FROM   persona P
WHERE  EXISTS  (SELECT *
                FROM   appartamento
                WHERE  P."numeroAppartamento" = numero AND
                       P.condominio = condominio AND
                       P.cf = proprietario);

-- variante 2

SELECT cf
FROM   (persona P JOIN appartamento A ON P.cf = A.proprietario)
WHERE  P."numeroAppartamento" = A.numero AND P.condominio = A.condominio;

-- Query 5

SELECT cf
FROM   (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
WHERE  superficie >= 50 AND "dataNascita" = (SELECT MIN(P2."dataNascita")
                                             FROM   persona P2);

-- variante 2

SELECT DISTINCT P.cf
FROM   (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
WHERE  A.superficie >= 50 AND "dataNascita" = (SELECT MIN(P2."dataNascita")
                                               FROM   (persona P2 JOIN appartamento A2 ON P2.cf = A2.proprietario)
                                               WHERE  A2.superficie >= 50);

-- Query semplice 1

SELECT codice, "ammontareComplessivo"
FROM condominio;

-- Query semplice 2

SELECT P.cf, P.indirizzo
FROM persona P INNER JOIN appartamento A ON P.cf = A.proprietario
WHERE P.indirizzo IS NOT NULL

UNION

SELECT P.cf, C.indirizzo
FROM (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
INNER JOIN condominio C
ON P.condominio = C.codice
WHERE P.indirizzo IS NULL;

-- Test query semplice 2:

CREATE VIEW tmpView AS (
        SELECT P.cf, P.indirizzo
        FROM persona P INNER JOIN appartamento A ON P.cf = A.proprietario
        WHERE P.indirizzo IS NOT NULL

        UNION

        SELECT P.cf, C.indirizzo
        FROM (persona P INNER JOIN appartamento A ON P.cf = A.proprietario)
        INNER JOIN condominio C
        ON P.condominio = C.codice
        WHERE P.indirizzo IS NULL
)

SELECT * FROM tmpView ORDER BY cf;
