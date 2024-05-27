library("RPostgreSQL")

# acquisizione dati

db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="test", user="test")

importi <- dbGetQuery(db, "SELECT importo FROM spesa")
ammCompl <- dbGetQuery(db, "SELECT \"ammontareComplessivo\", count FROM (SELECT condominio, COUNT(*) AS count FROM appartamento GROUP BY condominio) INNER JOIN condominio ON condominio = codice")

dbDisconnect(db)

cairo_pdf("grafici.pdf", 7, 5)


# ---------- Grafici ---------------


# 1: istogramma frequenza di spese per fascie d'importo

len = length(importi$importo)
n = ceiling(log2(len)) + 1 # Sturges's formula
#n = ceiling(sqrt(len)) # Square-root choice
#n = ceiling(2 * (len ** (1 / 3))) # Rice rule

ret = hist(importi$importo, n - 1, # -1 poiché hist() vuole il numero di breaks che è il numero di colonne +1
    main = "Frequenza spese per fascie d'importo",
    xlab = "Importo",
    ylab = "Frequenza")


# 2: ammontareComplessivo (y) per numero di appartamenti (x)

plot(ammCompl$count, ammCompl$ammontareComplessivo,
    main = "Ammontare complessivo per numero di appartamenti",
    xlab = "# di appartamenti",
    ylab = "Ammontare complessivo (€)")



# Salvataggio

dev.off()
