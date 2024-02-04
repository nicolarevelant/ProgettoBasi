library("RPostgreSQL")

# TODO: indirizziCondominio, elencoCausali

db <- dbConnect(dbDriver("PostgreSQL"), dbname="test", user="test")

# Genera elenco condomini (codice, CC, indirizzo)

condomini.size <- 10000
condomini.codice <- sample.int(condomini.size)
condomini.CC <- sample(100000000:999999999, condomini.size)
condomini.indirizzo <- paste("via Roma ", sample.int(100, condomini.size, replace=TRUE))

condomini <- data.frame(codice = condomini.codice, CC = condomini.CC, indirizzo = condomini.indirizzo)

# Genera elenco spese (dataOra, condominio, importo, causale)

dataMin <- as.numeric(as.POSIXct("1990-01-01 00:00:00"))
dataMax <- as.numeric(as.POSIXct("2023-12-31 23:59:59"))
elencoCausali <- c("Causale 1", "Causale 2")

spese.size <- 1000
spese.dataOra <- as.character(as.POSIXct(sample(dataMin:dataMax, spese.size, replace=T)))
spese.condominio <- sample(condomini.codice, spese.size, replace=T)
spese.importo <- sample(100:3000, spese.size, replace=T)
spese.causale <- sample(elencoCausali, spese.size, replace=T)

spese <- data.frame(dataOra = spese.dataOra, condominio = spese.condominio, importo = spese.importo, causale = spese.causale)

dbDisconnect(db)
