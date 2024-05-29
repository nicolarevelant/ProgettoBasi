library("RPostgreSQL")

set.seed(16784)

# acquisizione dati

db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="test", user="test")

importi <- dbGetQuery(db, "SELECT importo FROM spesa")
ammCompl <- dbGetQuery(db, "SELECT \"ammontareComplessivo\", count FROM (SELECT condominio, COUNT(*) AS count FROM appartamento GROUP BY condominio) INNER JOIN condominio ON condominio = codice")
appSuperQuota <- dbGetQuery(db, "SELECT superficie, \"quotaAnnoCorrente\" FROM appartamento")

condomini <- dbGetQuery(db, "SELECT codice FROM condominio")$codice
appSuper <- dbGetQuery(db, paste("SELECT superficie FROM appartamento WHERE condominio =", sample(condomini, 1)))

stopifnot(dbDisconnect(db))

cairo_pdf("grafici.pdf", 7, 5)


# ---------- Grafici ---------------


# 1: istogramma frequenza di spese per fascie d'importo

len = length(importi$importo)
n = ceiling(log2(len)) + 1 # Sturges's formula
#n = ceiling(sqrt(len)) # Square-root choice
#n = ceiling(2 * (len ** (1 / 3))) # Rice rule

hist(importi$importo, n - 1, # -1 poiché hist() vuole il numero di breaks che è il numero di colonne +1
    main = "Frequenza spese per fascie d'importo",
    xlab = "Importo",
    ylab = "Frequenza")


# 2: ammontareComplessivo (y) per numero di appartamenti (x)

plot(ammCompl$count, ammCompl$ammontareComplessivo,
    main = "Ammontare complessivo per numero di appartamenti",
    xlab = "# di appartamenti",
    ylab = "Ammontare complessivo (€)")

# 3: relazione tra superficie e quota anno corrente degli appartamenti
plot(appSuperQuota$superficie, appSuperQuota$quotaAnnoCorrente,
    main = "Relazione tra superficie e quota anno corrente degli appartamenti")
plot(appSuperQuota$quotaAnnoCorrente, appSuperQuota$superficie,
    main = "Relazione tra superficie e quota anno corrente degli appartamenti")

# 4: distribuzione superficie appartamenti di 1 dato condominio
len = length(importi$importo)
n = ceiling(sqrt(len))
hist(appSuper$superficie, n - 1,
    main = "Distribuzione superficie appartamenti di 1 dato condominio",
    xlab = "Superficie",
    ylab = "Frequenza")

# 5: confronto quota anno corrente con somma pagata (plot doppia barra)

# 6: percentuale causali spese di 1 condominio (plot a torta)



# dev.off() non serve con cairo_pdf() il quale supporta UTF-8 a differenza di pdf()
