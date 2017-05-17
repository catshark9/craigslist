terms <- as.character(unique(listings_new$term))
n.rgroup = c(count(listings_new$term)$freq)


listings_new$time <- round(Sys.time() - strptime(listings_new$time, "%Y-%m-%d %H:%M"), 2)

for(t in 1:nrow(listings_new)){
  time <- as.numeric(listings_new$time[t])
  if(time <=0.15){
    listings_new[t, 'time'] <- 'just now'
  } else if(time < 1){
    listings_new[t, 'time'] <- paste0(round(time*60, 0), ' minutes ago') 
  } else if(time < 24){
    listings_new[t, 'time'] <- paste0(round(time, 0), ' hours ago') 
  } else if(time < 30*24){
    listings_new[t, 'time'] <- paste0(round(time/24, 0), ' days ago') 
  } else {
    listings_new[t, 'time'] <- 'over 30 days ago'
  }
}


listings_new$term <- NULL
if(nrow(listings_new)>0){
  listings_new$desc <- paste0('<a href="', listings_new$url, '"><img src="', listings_new$img, '" width="300"><br>', listings_new$desc, 
                              '</a><br>', listings_new$price, ': posted ', listings_new$time)
  listings_new$url <- NULL
  listings_new$img <- NULL
  listings_new$price <- NULL
  listings_new$time <- NULL
  listingsTable <- htmlTable(listings_new,
                             header =  names(listings_new),
                             rnames = FALSE,
                             rgroup = terms,
                             n.rgroup = n.rgroup,
                             # cgroup = c("Cgroup 1", "Cgroup 2&dagger;"),
                             # n.cgroup = c(2,2), 
                             caption="Listings on Craigslist", 
                             tfoot="&dagger; "")
  
  email <- mime(
    To = "email@icloud.com",
    From = "email@gmail.com",
    Subject = paste0("Recent CL postings"))
  email <- html_body(email, paste(listingsTable))
  send_message(email)
}



