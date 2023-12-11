# Progetto Basi

## Descrizione attributi derivati

- Condominio.Ammontare-complessivo: sommatoria di "quota anno corrente" di ogni appartamento appartenente al condominio
- Proprietario.indirizzo: Indirizzo del condominio a cui appartiene l'appartamento in cui vive
- Appartamento.è-affittato: Vero sse ci abita una Persona che non è proprietario di tale appartamento

## Vincoli di integrità

- Proprietario.indirizzo: NULL sse il proprietario abita in un appartamento che possiede
- Ogni proprietario abita in un appartamento che possiede oppure paga l'affitto per abitare in un altro appartamento come inquilino

## Analisi ridondanze

### Tabella operazioni

| Operazione                                              | Frequenza                 |
|---------------------------------------------------------|---------------------------|
| Inserimento Proprietario                                | 2 volte/anno              |
| Modifica Appartamento: quota anno corrente              | 1 volta/mese              |
| Inserimento Spesa                                       | 2.5 volte/mese            |
| Modifica proprietario Appartamento (relazione possiede) | 2 volte/mese              |
| Modifica residenza Persona (relazione abita)            | 0.06 volte/anno           |
| Cancella Condominio                                     | 0.2 volte/anno            |
| Query Proprietario.indirizzo                            | 1 volta/giorno            |
| Query Appartamento.Quota-anno-corrente                  | 1 volta/settimana         |
| Query Appartamento.è-affittato                          | 1.5 volte/giorno          |

# Note

- Rimozione età persona
