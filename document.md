# Progetto Basi

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
| Inserimento Proprietario                                | 2 volte/anno              |
| Modifica Appartamento.Quota-anno-corrente               | 45 volte/mese             |
| Cancella Condominio                                     | 0.2 volte/anno            |
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
> persona(**cf**, nome, dataNascita, indirizzo, *numeroAppartamento, condominio*)

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

# TODO

- Rimozione età persona (foto ER.png)
