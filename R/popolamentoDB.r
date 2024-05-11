library("RPostgreSQL")

# TODO: elencoIndirizzi

# elencoIndirizzi: datset online comuni italiani

# Genera elenco condomini senza ammontareComplessivo (codice, CC, indirizzo)
# l'ammontare complessivo viene calcolato da un trigger SQL

indirizzi = readLines("indirizzi.txt")

condomini.size <- 150
condomini.codice <- sample(1:1000000, condomini.size)
condomini.CC <- sample(100000000:999999999, condomini.size)
condomini.indirizzo <- sample(indirizzi, condomini.size, replace=T) # TODO: togliere replace=T

condomini <- data.frame(codice = condomini.codice,
			CC = condomini.CC,
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

spese.importo <- sample(100:3000, spese.size, replace=T)
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

appartamenti <- data.frame(numero = appartamenti.numero,
			   condominio = appartamenti.condominio,
			   quotaAnnoCorrente = appartamenti.quotaAnnoCorrente,
			   sommaPagata = appartamenti.sommaPagata,
			   telefono = appartamenti.telefono,
			   superficie = appartamenti.superficie)




# Genera elenco persone senza indirizzo (cf, nome, dataNascita, appartamento, condominio)
# l'indirizzo viene calcolato da un trigger SQL

dataMin <- as.numeric(as.POSIXct("1990-01-01 00:00:00"))
dataMax <- as.numeric(as.POSIXct("2023-12-31 23:59:59"))

nomi <- readLines("nomi.txt")
cognomi <- readLines("cognomi.txt")

persone.size <- 1000

# TODO: fix codice fiscale
persone.cf <- paste(sep="", "CF_", sample(1:1000000, persone.size))
persone.nome <- paste(sample(nomi, persone.size, replace=T),
		      sample(cognomi, persone.size, replace=T))
persone.dataNascita <- as.character(as.POSIXct(sample(dataMin:dataMax, persone.size, replace=T)))

indici <- sample.int(appartamenti.size, persone.size)
persone.appartamento <- appartamenti.numero[indici]
persone.condominio <- appartamenti.condominio[indici]

persone = data.frame(cf = persone.cf,
		     nome = persone.nome,
		     dataNascita = persone.dataNascita,
		     appartamento = persone.appartamento,
		     condominio = persone.condominio)




db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="test", user="test")

dbWriteTable(db, "condominio", condomini)
dbWriteTable(db, "spesa", spese)
dbWriteTable(db, "appartamento", appartamenti)
dbWriteTable(db, "persona", persone)

#dbDisconnect(db)
