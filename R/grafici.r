library("RPostgreSQL")

set.seed(16784)

# acquisizione dati

db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname = "test", user = "test")

importi <- dbGetQuery(db, "SELECT importo FROM spesa")
ammCompl <- dbGetQuery(db, "SELECT count, \"ammontareComplessivo\" FROM (SELECT condominio, COUNT(*) AS count FROM appartamento GROUP BY condominio) INNER JOIN condominio ON condominio = codice")
ammCompl2 <- dbGetQuery(db, "SELECT count, AVG(\"ammontareComplessivo\") AS avg_ammontare FROM (SELECT condominio, COUNT(*) AS count FROM appartamento GROUP BY condominio) INNER JOIN condominio ON condominio = codice GROUP BY count ORDER BY count")
appSuperQuota <- dbGetQuery(db, "SELECT superficie, \"quotaAnnoCorrente\" FROM appartamento")

condomini <- dbGetQuery(db, "SELECT codice FROM condominio")$codice
appSuper <- dbGetQuery(db, paste("SELECT superficie FROM appartamento WHERE condominio =", sample(condomini, 1)))
appSuper2 <- dbGetQuery(db, "SELECT superficie FROM appartamento")
appSpese <- dbGetQuery(db, "SELECT \"sommaPagata\" / \"quotaAnnoCorrente\" AS ratio FROM appartamento WHERE \"quotaAnnoCorrente\" > 0")

appSpeseSuperficie <- dbGetQuery(db, "SELECT superficie, SUM(\"sommaPagata\") / SUM(\"quotaAnnoCorrente\") AS ratio FROM appartamento GROUP BY superficie HAVING SUM(\"quotaAnnoCorrente\") > 0 ORDER BY superficie")

causali <- dbGetQuery(db, paste("SELECT causale, COUNT(*) AS n FROM spesa WHERE condominio =", sample(condomini, 1), "GROUP BY causale"))
causali2 <- dbGetQuery(db, paste("SELECT causale, COUNT(*) AS n FROM spesa GROUP BY causale"))

stopifnot(dbDisconnect(db))

# cairo_pdf() supporta UTF-8 a differenza di pdf() e non richiede dev.off()
cairo_pdf("grafici.pdf", 10, 7)


# ---------- Grafici ---------------


# 1: istogramma frequenza di spese per fascie d'importo

len <- length(importi$importo)
n <- ceiling(log2(len)) + 1 # metodo 1 (Sturges's formula)
# metodo 2 (Square-root choice) n <- ceiling(sqrt(len))
# metodo 3 (Rice rule) n <- ceiling(2 * (len ** (1 / 3)))

# -1 poiché hist() vuole il numero di breaks che è il numero di colonne +1
hist(importi$importo, n - 1,
     main = "Frequenza spese per fascie d'importo",
     xlab = "Importo",
     ylab = "Frequenza")


# 2: ammontareComplessivo (y) per numero di appartamenti (x)
plot(ammCompl,
     main = "Ammontare complessivo dei condomini per numero di appartamenti",
     xlab = "# di appartamenti",
     ylab = "Ammontare complessivo (€)")

# 2 variante 2: ammontareComplessivo (y) per numero di appartamenti (x)
barplot(ammCompl2$avg_ammontare,
        names.arg = ammCompl2$count,
        ylim = c(0, 21000),
        main = "Ammontare complessivo dei condomini per numero di appartamenti",
        xlab = "# di appartamenti",
        ylab = "Ammontare complessivo (€)")

# 3: relazione tra superficie e quota anno corrente degli appartamenti
plot(appSuperQuota$superficie, appSuperQuota$quotaAnnoCorrente,
     main = "Relazione tra superficie e quota anno corrente degli appartamenti",
     xlab = "Superficie",
     ylab = "Quota anno corrente")

# 3 variante 2
plot(appSuperQuota$quotaAnnoCorrente, appSuperQuota$superficie,
     main = "Relazione tra quota anno corrente e superficie degli appartamenti",
     xlab = "Quota anno corrente",
     ylab = "Superficie")

# 4: distribuzione superficie appartamenti di 1 dato condominio
n <- ceiling(sqrt(length(importi$importo)))
hist(appSuper$superficie, n - 1,
     main = "Distribuzione superficie appartamenti di 1 dato condominio",
     xlab = "Superficie",
     ylab = "Frequenza")

# 4 variante 2: distribuzione superficie appartamenti
n <- ceiling(log2(length(importi$importo))) + 1
hist(appSuper2$superficie, n - 1,
     main = "Distribuzione superficie appartamenti",
     xlab = "Superficie",
     ylab = "Frequenza")

# 5: confronto quota anno corrente con somma pagata (plot doppia barra)
n <- ceiling(log2(length(appSpese$ratio))) + 1
hist(appSpese$ratio, n - 1,
     main = "Distribuzione del rapporto tra la somma pagata e la quota anno corrente degli appartamenti",
     xlab = "Rapporto somma pagata diviso quota anno corrente",
     ylab = "Frequenza")


# 5 variante: rapoorto sommaPagata/quotaAnnoCorrente appartamenti per superficie
n <- ceiling(log2(length(appSpeseSuperficie$ratio))) + 1
plot(appSpeseSuperficie,
     main = "Rapporto tra la somma pagata e la quota anno corrente per superficie",
     xlab = "Superficie",
     ylab = "Rapporto somma pagata diviso quota anno corrente")

# 6: percentuale causali spese di 1 condominio (plot a torta)
# TODO: legenda copre il pie chart
colors <- terrain.colors(length(causali$n))
pie(causali$n, col = colors,
    labels = paste(100 * causali$n / length(causali$n), "%"),
    main = "Percentuale causali spese di 1 condominio")
legend("bottomright", causali$causale, fill = colors)

# TODO: meglio pie chart o barplot?
# 6 variante 2: percentuale causali spese di 1 condominio (plot a torta)
colors <- terrain.colors(length(causali$n))
barplot(causali$n, col = colors, ylim = c(0, 5),
        main = "Percentuale causali spese di 1 condominio")
legend("topright", causali$causale, fill = colors)

# 6 variante 3: percentuale causali spese
colors <- terrain.colors(length(causali2$n))
barplot(causali2$n, col = colors, ylim = c(0, 1000),
        main = "Percentuale causali spese")
legend("topright", causali2$causale, fill = colors)
