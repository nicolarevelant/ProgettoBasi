# Query SQL

1. Query dato x proprietario per ogni condominio avente almeno 1 app. posseduto da x, elencare le ultime 5 spese dal registro spese
2. Query elenco spese dell'anno corrente dei condomini che possiedono almeno 10 appartamenti

---

# 1 bozza

> Per ogni condominio avente almeno 1 appartamente posseduto da "RVL", calcolare importo complessivo delle ultime 5 spese

> CREATE VIEW speseRecentiDi(condominio, importo) AS
>        (SELECT condominio, importo FROM spesa WHERE EXISTS
>                (SELECT * FROM appartamento WHERE condominio = spesa.condominio AND proprietario = "RVL") ORDER BY dataOra DESC LIMIT 5 // NOT WORKS
>
> SELECT condominio, SUM(importo) FROM speseRecentiDi GROUP BY condominio

# 2

> CREATE VIEW condominiMedioGrandi(condominio) AS
>        (SELECT condominio FROM appartamento GROUP BY condominio HAVING COUNT(\*) \>= 10);
>
> SELECT condominio, dataOra, importo, causale FROM condominiMedioGrandi INNER JOIN spesa S ON condominio = S.condominio;
