# DOMANDA PER VOI!!!!!

Io non vedo la necessità di cambiare gli indici delle tabelle, perché guardando la frequenza che abbiamo scelto per ogni operazione è molo bassa...l'unica altina è quella che richiede di restituire indirizzo di ogni propietario che viene effettuata una volta al giorno

Secondo voi, quindi, c'è un modo per rendere più efficiente questa query?

# Nicola:

La frequenza delle operazioni non influisce sulla scelta degli indici,
in quanto un'operazione che viene svolta 1 volta all'anno non può
impiegare 10 minuti se è possibile ridurli a pochi millisecondi con un indice

Quindi per ogni operazione se l'esecuzione richiede un tempo
tetha(n)
allora è necessario introdurre un indice.

> Esempio: spese(id: integer, dataOra: timestamp)
> elencare le spese tra il "2024-03-23" e il "2024-04-30" è tetha(n)
> con l'indice su dataOra diventa tetha(log(n))

Secondo me l'unica eccezione dove non serve l'indice è in una tabella
dove non ci saranno **MAI** molti record (> 100 000)
