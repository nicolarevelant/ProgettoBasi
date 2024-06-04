library("RPostgreSQL")

set.seed(16784)

# TODO: elencoIndirizzi

# elencoIndirizzi: datset online comuni italiani

# Genera elenco condomini senza ammontareComplessivo (codice, CC, indirizzo)
# l'ammontare complessivo viene calcolato da un trigger SQL

indirizzi = read.csv("indirizzi_US.csv")[,"FULL.ADDRESS"]

condomini.size <- 150
condomini.codice <- sample(1:1000000, condomini.size)
condomini.CC <- sample(100000000:999999999, condomini.size)
condomini.indirizzo <- sample(indirizzi, condomini.size, replace=T) # TODO: togliere replace=T

condomini <- data.frame(codice = condomini.codice,
			contoCorrente = condomini.CC,
			indirizzo = condomini.indirizzo)




# Genera elenco spese (dataOra, condominio, importo, causale)

dataMin <- as.numeric(as.POSIXct("1990-01-01 00:00:00"))
dataMax <- as.numeric(as.POSIXct("2023-12-31 23:59:59"))
elencoCausali <- readLines("causali.txt")

varianza <- 10
distr_normale <- rnorm(condomini.size, 30, varianza)

spese.dataOra <- NULL
spese.condominio <- NULL

i <- 1
while (i <= condomini.size) {
	ripetizioni <- round(distr_normale[i])
	if (ripetizioni < 1) {
		ripetizioni <- 1
	}
	spese.dataOra <- c(spese.dataOra, as.character(as.POSIXct(sample(dataMin:dataMax, ripetizioni))))
	spese.condominio <- c(spese.condominio, rep(condomini.codice[i], ripetizioni))
	i <- i + 1
}

# size: indicativamente 4500 (in media 30 spese * 150 condomini)
spese.size <- length(spese.dataOra)

spese.importo <- sample(20:800, spese.size, replace=T)
spese.causale <- sample(elencoCausali, spese.size, replace=T)

spese <- data.frame(dataOra = spese.dataOra,
		    condominio = spese.condominio,
		    importo = spese.importo,
		    causale = spese.causale)




# Genera elenco appartamenti senza proprietario (numero, condominio, quotaAnnoCorrente,
#                                                sommaPagata, telefono?, superficie)

varianza <- 3
distr_normale <- rnorm(condomini.size, 10, varianza)

appartamenti.numero <- NULL
appartamenti.condominio <- NULL

i <- 1
while (i <= condomini.size) {
	ripetizioni = round(distr_normale[i])
	if (ripetizioni < 1) {
		ripetizioni <- 1
	}
	appartamenti.numero <- c(appartamenti.numero, 1:ripetizioni)
	appartamenti.condominio <- c(appartamenti.condominio, rep(condomini.codice[i], ripetizioni))
	i <- i + 1
}

# size: indicativamente 1500 (in media 10 app. * 150 condomini)
appartamenti.size <- length(appartamenti.numero)
indici <- sample.int(appartamenti.size)
appartamenti.numero <- appartamenti.numero[indici]
appartamenti.condominio <- appartamenti.condominio[indici]

appartamenti.quotaAnnoCorrente <- sample(0:1000, appartamenti.size, replace=T)
appartamenti.sommaPagata <- NULL

for (x in appartamenti.quotaAnnoCorrente) {
	appartamenti.sommaPagata <- c(appartamenti.sommaPagata, sample(0:x, 1))
}

# TODO: telefono è un campo opzionale
appartamenti.telefono <- replicate(appartamenti.size, paste(sample(0:9, 10, replace=T), collapse=""))
appartamenti.superficie <- sample(40:300, appartamenti.size, replace=T)




# Genera elenco persone senza indirizzo (cf, nome, dataNascita, appartamento, condominio)
# l'indirizzo viene calcolato da un trigger SQL

dataMin <- as.numeric(as.POSIXct("1990-01-01 00:00:00"))
dataMax <- as.numeric(as.POSIXct("2023-12-31 23:59:59"))

nomi <- readLines("nomi.txt")
cognomi <- readLines("cognomi.txt")

persone.size <- 1200

# TODO: fix codice fiscale
persone.cf <- replicate(persone.size, paste(sample(0:9, 16, replace=T), collapse=""))
persone.nome <- paste(sample(nomi, persone.size, replace=T),
		      sample(cognomi, persone.size, replace=T))
persone.dataNascita <- as.character(as.POSIXct(sample(dataMin:dataMax, persone.size, replace=T)))

# assegno abitazione
indici <- sample.int(appartamenti.size, persone.size)
persone.appartamento <- appartamenti.numero[indici]
persone.condominio <- appartamenti.condominio[indici]

persone = data.frame(cf = persone.cf,
		     nome = persone.nome,
		     dataNascita = persone.dataNascita,
		     numeroAppartamento = persone.appartamento,
		     condominio = persone.condominio)




# assegno proprietario
proprietari = sample(persone.cf, 200)
appartamenti.proprietario = sample(proprietari, appartamenti.size, replace=T) # TODO: solo 200 proprietari

appartamenti <- data.frame(numero = appartamenti.numero,
			   condominio = appartamenti.condominio,
			   quotaAnnoCorrente = appartamenti.quotaAnnoCorrente,
			   sommaPagata = appartamenti.sommaPagata,
			   telefono = appartamenti.telefono,
			   superficie = appartamenti.superficie,
			   proprietario = appartamenti.proprietario)


db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="basi28", user="basi28")

# previene creazione tabelle
stopifnot(dbExistsTable(db, "condominio"))
stopifnot(dbExistsTable(db, "spesa"))
stopifnot(dbExistsTable(db, "appartamento"))
stopifnot(dbExistsTable(db, "persona"))

dbBegin(db)

print(" -- Delete old records --")

dbExecute(db, 'DELETE FROM persona')
dbExecute(db, 'DELETE FROM appartamento')
dbExecute(db, 'DELETE FROM spesa')
dbExecute(db, 'DELETE FROM condominio')

print(" -- Insert new records --")

dbWriteTable(db, "condominio", condomini, append=T, row.names=F)
dbWriteTable(db, "spesa", spese, append=T, row.names=F)
dbWriteTable(db, "appartamento", appartamenti, append=T, row.names=F)
dbWriteTable(db, "persona", persone, append=T, row.names=F)

dbCommit(db)

dbDisconnect(db)
