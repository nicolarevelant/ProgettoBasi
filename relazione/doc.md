# Autori

- Nomi autori TODO

# Introduzione

TODO: piccola descrizione del progetto

# Descrizione soluzione

TODO: approccio usato (top down,...)

# Schema entità/relazioni (ER)

# Analisi ridondanze

## Tabella operazioni

## Tabella valori

# Schema logico relazionale

Lo schema logico permette di rappresentare i concetti derivanti dallo schema ER
nel modello logico utilizzato dalla base di dati.

In questo progetto viene utilizzato il modello relazionale il quale utilizza le relazioni
(o tabelle) e le associazioni fra di esse per rappresentare i dati richiesti dal modello
concettuale.

Il seguente schema logico ha tradotto le entità dello schema ER in tabelle, e le relazioni
di tipo 1 a N dall'entità A all'entità B in associazioni tra la chiave esterna di A che
fa riferimento alla chiave primaria di B.

In questo schema ER è presente una singola specializzazione parziale di Persona in
Proprietario pertanto viene unita al genitore, e tutti gli attributi e relazioni del figlio
ora sono sono del genitore.

L'attributo condominio.ammontareComplessivo è un attributo derivato ma è comunque presente
nello schema logico in quanto lo studio sulla ridondanza ha sottolineato che mantenerlo porta
una maggiore efficienza computazionale della basi di dati.

> condominio(**codice**, contoCorrente, indirizzo, ammontareComplessivo)
>
> spesa(**dataOra,** ***condominio***, importo, causale)
>
> appartamento(**numero,** ***condominio***, quotaAnnoCorrente, sommaPagata, telefono, superficie, *proprietario*)
>
> persona(**cf**, nome, dataNascita, indirizzo, *numeroAppartamento, condominio*)

# Progettazione fisica

# Implementazione in SQL

# Analisi dati


