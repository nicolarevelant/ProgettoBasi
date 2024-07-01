# Query SQL

1. Query dato P proprietario per ogni condominio avente almeno 1 app. posseduto da P, elencare le ultime 5 spese dal registro spese.
2. Query elenco spese dell'anno corrente dei condomini che possiedono almeno 10 appartamenti.

---

# 1

> Per ogni condominio avente almeno 1 appartamente posseduto da "x",
> elencare le ultime 5 spese dal registro spese

```
SELECT \*
FROM spesa S1
WHERE condominio IN
        (SELECT condominio
         FROM appartamento
         WHERE proprietario = "x")
        AND "dataOra" IN
                (SELECT "dataOra"
                 FROM spesa S2
                 WHERE S1.condominio = S2.condominio
                 ORDER BY "dataOra" DESC LIMIT 5);
```

# 2

## Modo 1

```
CREATE VIEW "condominiMedioGrandi"(condominio) AS
(SELECT condominio
 FROM appartamento
 GROUP BY condominio HAVING COUNT(\*) \>= 10);

SELECT condominio, "dataOra", importo, causale
FROM "condominiMedioGrandi" INNER JOIN spesa S ON condominio = S.condominio;
```

## Modo 2

```
SELECT condominio, dataOra, importo, causale
FROM (SELECT condominio
      FROM appartamento
      GROUP BY condominio HAVING COUNT(\*) \>= 10)
        INNER JOIN spesa S ON condominio = S.condominio;
```
