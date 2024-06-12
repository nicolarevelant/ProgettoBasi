# Query difficili 3, 4, 5 di SQL
## Descrizioni
3. Query importo complessivo delle spese di tutti i condomini con **ammontareComplessivo** tra 50 e 100 compresi.
4. Query elenco persone che possiedono l'appartamento in cui abitano.
5. Query elenco persone più anziane che possiedono un appartamento di superficie >= 50.
## Query 3
```
SELECT SUM(importo)
FROM   (condominio C JOIN spesa S ON C.codice = S.condominio)
WHERE  ammontareComplessivo BETWEEN 50 AND 100;
```
## Query 4
### Modo 1
```
SELECT cf
FROM   persona P
WHERE  EXISTS  (SELECT \*
                FROM   appartamento
                WHERE  P."numeroAppartamento" = numero AND
                       P.condominio = condominio AND
                       P.cf = proprietario);
```
### Modo 2
```
SELECT cf
FROM   (persona P JOIN appartamento A ON P.cf = A.proprietario)
WHERE  P."numeroAppartamento" = A.numero AND P.condominio = A.condominio;
```
## Query 5
```
SELECT cf
FROM   (persona P JOIN appartamento A ON P.cf = A.proprietario)
WHERE  superficie >= 50 AND "dataNascita" = (SELECT MIN(P2."dataNascita")
                                             FROM   persona P2);
```
