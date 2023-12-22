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
| Query Condominio.Ammontare-complessivo (calcolarlo)     | 4 volte/anno              |
| Cancella Condominio                                     | 0.2 volte/anno            |
| Query Proprietario.indirizzo                            | 1 volta/giorno            |
| Query dato x proprietario per ogni condominio avente almeno 1 app. posseduto da x, elencare le ultime 5 spese dal registro spese | 2 volte/mese |

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

Il seguente schema è solo una bozza, è da decidere se rimuovere o meno l'entita Proprietario!!

> condominio(**codice**, indirizzo, contoCorrente, indirizzo, ammontareComplessivo)
>
> spesa(**dataOra,** ***condominio***, importo, causale)
>
> appartamento(**numero,** ***condominio***, quotaAnnoCorrente, sommaPagata, telefono, superficie, *proprietario*)
>
> persona(**cf**, nome, dataNascita, *condominio, numeroAppartamento*)

> spesa.condominio --\> condominio.codice
>
> appartamento.condominio --\> condominio.codice
>
> appartamento.proprietario --\> persona.cf
>
> \{persona.condominio, persona.numeroAppartamento\} --\> \{appartamento.condominio, appartamento.numero}

# Note

- Rimozione età persona
- Modifica delle frequenze della Tabella delle operazioni (tenendo conto della frequenza totale)
