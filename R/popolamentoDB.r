library("RPostgreSQL")

# TODO: elencoIndirizzi, elencoCausali, elencoNominativi

# elencoIndirizzi: datset online comuni italiani
# elencoCausali: decina di causali su CSV
# elencoNominativi: nomi.txt e cognomi.txt su Teams Basi Laboratorio
# condomini con x app. : x distribuzione normale media 10
# spese : 30 dataOra per condominio

# Genera elenco condomini senza ammontareComplessivo (codice, CC, indirizzo)

condomini.size <- 150
condomini.codice <- sample(1:1000000, condomini.size)
condomini.CC <- sample(100000000:999999999, condomini.size)
condomini.indirizzo <- paste("via Roma ", sample.int(100, condomini.size, replace=TRUE))

condomini <- data.frame(codice = condomini.codice, CC = condomini.CC, indirizzo = condomini.indirizzo)




# Genera elenco spese (dataOra, condominio, importo, causale)

dataMin <- as.numeric(as.POSIXct("1990-01-01 00:00:00"))
dataMax <- as.numeric(as.POSIXct("2023-12-31 23:59:59"))
elencoCausali <- c("Causale 1", "Causale 2")

spese.size <- 4500
spese.dataOra <- as.character(as.POSIXct(sample(dataMin:dataMax, spese.size, replace=T)))
spese.condominio <- sample(condomini.codice, spese.size, replace=T) # TODO: coppia (dataOra, condominio) deve essere univoca !!!
spese.importo <- sample(100:3000, spese.size, replace=T)
spese.causale <- sample(elencoCausali, spese.size, replace=T)

spese <- data.frame(dataOra = spese.dataOra, condominio = spese.condominio, importo = spese.importo, causale = spese.causale)




# Genera elenco appartamenti senza proprietario (numero, condominio, quotaAnnoCorrente, sommaPagata, telefono, superficie)

appartamenti.size <- condomini.size * 10 # TODO: ogni condominio ha 10 appartamenti con numero da 1 a 10?
appartamenti.numero <- NULL
appartamenti.condominio <- NULL

for (condominio in condomini.codice) {
	appartamenti.numero <- c(appartamenti.numero, 1:10)
	appartamenti.condominio <- c(appartamenti.condominio, rep(condominio, 10))
}

appartamenti.quotaAnnoCorrente <- sample(0:1000, appartamenti.size)
appartamenti.sommaPagata = NULL

for (x in appartamenti.quotaAnnoCorrente) {
	appartamenti.sommaPagata <- c(appartamenti.sommaPagata, sample(0:x, 1))
}

appartamenti.telefono <- NULL

for (x in 1:10) {
	appartamenti.telefono <- paste(sep="", appartamenti.telefono, sample(0:9, appartamenti.size))
}

appartamenti.superficie <- sample(40:300, appartament.size)




# Genera elenco persone senza appartamento in cui abita (cf, nome, dataNascita, indirizzo?)

dataMin <- as.numeric(as.POSIXct("1990-01-01 00:00:00"))
dataMax <- as.numeric(as.POSIXct("2023-12-31 23:59:59"))


persone.size <- 1000
persone.cf <- paste(sep="", "CF_", sample(1:1000000, persone.size))
persone.nome <- "Mario Rossi" # TODO: dove prendo i nominativi??
persone.dataNascita <- as.character(as.POSIXct(sample(dataMin:dataMax, spese.size, replace=T)))
persone.indirizzo <- paste("via Roma ", sample.int(100, condomini.size, replace=TRUE))



#db <- dbConnect(dbDriver("PostgreSQL"), dbname="test", user="test")

#dbDisconnect(db)
