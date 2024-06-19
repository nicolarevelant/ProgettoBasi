# Query semplici SQL

1. Query restituire ammontare complessivo per ogni condominio
2. Query restituire l'indirizzo di ogni proprietario

---

# 1

> Restituire ammontare complessivo per ogni condominio

```
SELECT codice, "ammontareComplessivo"
FROM condominio;
```

# 2

> Restituire l'indirizzo di ogni proprietario

```
SELECT p.cf, p.indirizzo
FROM persona p INNER JOIN appartamento a ON p.cf = a.proprietario
WHERE p.indirizzo IS NOT NULL

UNION

SELECT p.cf, c.indirizzo
FROM (persona p INNER JOIN appartamento a ON p.cf = a.proprietario) INNER JOIN condominio c
ON a.condominio = c.codice
WHERE p.indirizzo IS NULL;
```
