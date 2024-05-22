library("RPostgreSQL")

db <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="test", user="test")



#dbDisconnect(db)