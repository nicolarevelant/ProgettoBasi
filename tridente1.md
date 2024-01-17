# 3

### Query importo complessivo delle spese di tutti i condomini con ammontare complessivo tra 50 e 100 compresi

```
SELECT SUM(importo)
FROM   condominio C JOIN spesa S ON C.codice = S.condominio
WHERE  ammontareComplessivo BETWEEN 50 AND 100;
```

# 4

### Query elenco persone che possiedono l'appartamento in cui abitano

```

```

# 5

### Query elenco persone più anziane che possiedono un appartamento di superficie >= 50

```

```

