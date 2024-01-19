# Progetto Basi

# TODO

- create table, constraint, trigger, index
- query semplici
- script in R per popolamento database
- completare relazione finale: introduzione, descrizione soluzione, schema ER, progettazione fisica/implementazione SQL

# Smistamento lavoro

- Ion: create table, constraint, trigger, index + query semplici
- Revelant: introduzione, descrizione soluzione
- Tridente: schema ER, progettazione fisica/implemSQL

## Descrizione attributi derivati

- Condominio.Ammontare-complessivo: sommatoria di "quota anno corrente" di ogni appartamento appartenente al condominio
- Proprietario.indirizzo: Indirizzo del condominio a cui appartiene l'appartamento in cui vive
- Appartamento.è-affittato: Vero sse ci abita una Persona che non è proprietario di tale appartamento

## Vincoli di integrità

- Proprietario.indirizzo: NULL sse il proprietario abita in un appartamento che possiede
- Ogni proprietario abita in un appartamento che possiede oppure paga l'affitto per abitare in un altro appartamento come inquilino

### Tabella operazioni

| Operazione                                              | Frequenza                 |
|---------------------------------------------------------|---------------------------|
| Modifica Appartamento.Quota-anno-corrente               | 45 volte/mese             |
| Cancella Condominio                                     | 0.2 volte/anno            |
| Inserimento Appartamento                                | 1 volta/anno              |
| Query Condominio.Ammontare-complessivo (calcolarlo)     | 4 volte/anno              |
| Query Proprietario.indirizzo                            | 1 volta/giorno            |
| Query dato x proprietario per ogni condominio avente almeno 1 app. posseduto da x, elencare le ultime 5 spese dal registro spese | 2 volte/mese |
| Query elenco spese dell'anno corrente dei condomini che possiedono almeno 10 appartamenti | 1 volta/anno |
| Query importo complessivo delle spese di tutti i condomini con **ammontareComplessivo** tra 50 e 100 compresi | 5 volte/anno |
| Query elenco persone che possiedono l'appartamento in cui abitano | 3 volte/anno |
| Query elenco persone più anziane che possiedono un appartamento di superficie >= 50 | 2 volte/mese |

## Tabella valori

| Concetto     | Tipo      | Volume |
|--------------|-----------|--------|
| Persona      | Entità    | 1000   |
| Proprietario | Entità    | 200    |
| Appartamento | Entità    | 1500   |
| Condominio   | Entità    | 150    |
| Spesa        | Entità    | 4500   |
| abita        | Relazione | 1000   |
| possiede     | Relazione | 1500   |
| appartenenza | Relazione | 1500   |
| paga         | Relazione | 4500   |

## Analisi ridondanze

L'analisi delle ridondanze è stata effettuata tenendo in considerazione l'attributo derivato Ammontare-Complessivo dell'entità Condominio, andando a calcolare il costo delle seguenti due operazioni nel caso in cui è presente l'attributo derivato oppure no:
> OP1 := inserimento Appartamento
> 
> OP2 := calcolare ammontare complessivo di un Condominio

Con frequenza rispettivamente di 1 volta/anno e 4 volte/anno

La seguente tabella ci sarà utile in seguito per calcolare il costo delle operazioni.
| Operazione    | Costo (u) |
|---------------|-----------|
| Scrittura (w) | 2         |
| Lettura (r)   | 1         |

L'obbiettivo che ci poniamo è quello di dimostrare che tenere l'attributo derivato sia computazionalmente vantaggioso, nel caso delle due operazioni in esame. Focalizziamo la nostra attenzione sulle entità **Condominio** e **Appartamento** e sulla relazione **Appartenenza**.

***Costo delle due operazione nel caso in cui la ridondanza venga tolta***

Per quanto riguarda l'operazione 1 abbiamo bisogno di un accesso in scrittura all'entità Appartamento e un accesso in scrittura alla relazione Appartenenza.

Per quanto riguarda l'operazione 2 serve un accesso in lettura all'entità Condominio, per ricavare il condominio in questione e 10 letture alla relazione Appartenenza (ottenuto dividendo il volume dell'entità Appartamento per il volume dell'entità Condominio).

Quindi,

> Costo_OP1 = 2w
> 
> Costo_OP2 = 1r + (1500/150)r = 11r

Andando a moltiplicare i costi per le relative frequenze delle due operazioni e tenendo in considerazione la tabella subito sopra

> Costo_OP1 = 2 * 2 * 1 volta/anno = 4 accessi all'anno
> 
> Costo_OP2 = 11 * 1 * 4 volte/anno = 44 accessi all'anno
>
> Costo_TOT_senza_rid = 48 accessi all'anno

***Costo delle due operazione nel caso in cui la ridondanza venga mantenuta***

Per quanto riguarda l'operazione 1 abbiamo bisogno di un accesso in scrittura all'entità Appartamento (per inserire l'appartamento), un accesso in scrittura alla relazione Appartenenza (per memorizzare la coppia condominio-appartamento), un accesso in lettura all'entità Condominio (per cercare il condominio in questione) e un accesso in scrittura all'entità Condominio (sommando all'attributo derivato il valore dell'attributo Quota-anno-corrente dell'appartamento appena inserito).

Per quanto riguarda l'operazione 2 serve un solo accesso in lettura all'entità Condominio, per leggere il contenuto dell'attributo derivato Ammontare-complessivo.

Quindi,

> Costo_OP1 = 1r + 3w
> 
> Costo_OP2 = 1r

Andando a moltiplicare i costi per le relative frequenze delle due operazioni e tenendo in considerazione la tabella subito sopra

> Costo_OP1 = 1 + (3 * 2) * 1 volta/anno = 7 accessi all'anno
> 
> Costo_OP2 = 1 * 4 volte/anno = 4 accessi all'anno
>
> Costo_TOT_con_rid = 11 accessi all'anno

E quindi siccome Costo_TOT_con_rid < Costo_TOT_senza_rid allora conviene mantenere l'attributo derivato Ammontare-complessivo.

## Schema logico

Dopo aver completato lo schema concettuale è necessario tradurlo in uno schema logico
direttamente implementabile in un linguaggio di interrogazione come l'SQL, in quanto
ogni tabella dello schema logico corrisponde ad una tabella memorizzata nella base di dati.

L'attributo condominio.ammontareComplessivo è un attributo derivato ma è comunque presente nello schema logico
in quanto lo studio sulla ridondanza ha sottolineato che mantenerlo porta una maggiore efficienza computazionale della basi di dati.

Nello schema ER l'entità Proprietario è una specializzazione totale dell'entità Persona.
Dato che l'entità Persona non ha altre specializzazioni, le 2 entità vengolo collise in 1 sola tabella: **persona**

Ognuna delle restanti relazioni dello schema ER è stata tradotta in 1 tabella con lo stesso nome.

> condominio(**codice**, contoCorrente, indirizzo, ammontareComplessivo)
>
> spesa(**dataOra,** ***condominio***, importo, causale)
>
> appartamento(**numero,** ***condominio***, quotaAnnoCorrente, sommaPagata, telefono, superficie, *proprietario*)
>
> persona(_cf__, nome, dataNascita, indirizzo, *numeroAppartamento, condominio*)

### Chiavi esterne

Di seguito sono elencate le chiavi esterne, la freccia indica che l'attributo (o l'insieme di attributi)
a sinistra è chiave esterna dell'entità a destra

> spesa.condominio --\> condominio
>
> appartamento.condominio --\> condominio
>
> appartamento.proprietario --\> persona
>
> \{persona.numeroAppartamento, persona.condominio\} --\> appartamento

# SQL

# Progettazione fisica

> CREATE DATABASE dbProgetto
\
TODO: create table, constraint, trigger, index

## Query

#TODO: conversione query tabella operazioni
TODO: script in R per popolamento database

# Grafici

TODO: R plot()


