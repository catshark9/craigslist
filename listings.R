query1 <- c('dresser', 'black')
query2 <- c('media', 'cabinet')
query3 <- c('nintendo')

listings1 <- data.frame(CLQuery(query1, 50, 100), term=paste0(query1, collapse = ' '))
listings2 <- data.frame(CLQuery(query2, 150, 600), term=paste0(query2, collapse = ' '))
listings3 <- data.frame(CLQuery(query3, 10, 100), term=paste0(query3, collapse = ' '))

listings1 <- listings1[grepl('[D|d]resser', listings1$desc)|grepl('[C|c]hest', listings1$desc), ]
listings2 <- listings2[grepl('[M|m]edia', listings2$desc)|grepl('[C|c]abinet', listings2$desc), ]
listings3 <- listings3[grepl('64', listings3$desc), ]

listings <- rbind(listings1, listings2, listings3)              


# if database connection open, else save to excel 
if(database){
  
  library('RPostgreSQL')
  pg = dbDriver("PostgreSQL")
  con = dbConnect(pg, user="user", password="password",
                  host="localhost", port=5432, dbname="Craigslist")
  listings_prev <- dbGetQuery(con, "SELECT * from listings")
  
  
  
  listings_all <- rbind(listings, listings_prev)
  listings_all <- listings_all[!duplicated(listings_all$url), ]
  
  listings_new <- listings[!(listings$url%in%listings_prev$url), ]
  
  dbRemoveTable(con,"listings_new")
  dbWriteTable(con,'listings_new', listings_new, row.names=FALSE)
  
  dbWriteTable(con, 'listings', value=listings_new,append=TRUE, row.names=FALSE)


} else {
  listings_prev <- read_csv("C:/Users/Jon Kelley/Desktop/CL/listings.csv")
  
  listings_all <- rbind(listings, listings_prev)
  listings_all <- listings_all[!duplicated(listings_all$url), ]
  
  listings_new <- listings[!(listings$url%in%listings_prev$url), ]
}

  write.csv(listings_all, file='listings.csv',  row.names=FALSE)




