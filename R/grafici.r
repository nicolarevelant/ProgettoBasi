library("RPostgreSQL")

db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="test", user="test")

# istogramma frequenza di spese per fascie d'importo

spese <- dbReadTable(db, "spesa")

importi = spese$importo
len = length(importi)
n = ceiling(log2(len)) + 1 # Sturges's formula
#n = ceiling(sqrt(len)) # Square-root choice
#n = ceiling(2 * (len ** (1 / 3))) # Rice rule

png("grafico.png", 1000, 1000)

ret = hist(importi, n - 1, # -1 poiché hist() vuole il numero di breaks che è il numero di colonne +1
    main = "Frequenza spese per fascie d'importo",
    xlab = "Importo",
    ylab = "Frequenza")

dev.off()

dbDisconnect(db)
