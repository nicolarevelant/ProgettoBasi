# Query semplici SQL

1. Query restituire ammontare complessivo per ogni condominio
2. Query restituire l'indirizzo di ogni proprietario

---

# 1

> Restituire ammontare complessivo per ogni condominio

> SELECT codice, ammontareComplessivo
> 
> FROM condominio;


# 2

> Restituire l'indirizzo di ogni proprietario

> SELECT p.indirizzo
> 
> FROM persona p, appartamento a
> 
> WHERE p.cf = a.proprietario AND p.indirizzo IS NOT NULL;
> 
> UNION
> 
> SELECT c.indirizzo
> 
> FROM persona p, appartamento a, condominio c
> 
> WHERE p.cf = a.proprietario AND p.indirizzo IS NULL;
