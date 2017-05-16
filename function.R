CLQuery <- function(query, min_price, max_price){
  
  
  url <- read_html(paste0('https://dallas.craigslist.org/search/sss?query=', paste0(query, '+', collapse = ''), '&min_price=', min_price, '&max_price=', max_price))
  # fua = furniture 
  name <- url %>% 
    html_nodes(xpath='//*[@class="result-title hdrlnk"]') %>%
    html_text()
  
  links <- url %>% 
    html_nodes(xpath='//*[@class="result-title hdrlnk"]') %>%
    html_attr("href")
  links <- paste0('https://dallas.craigslist.org', links)
  
  price <- url %>% 
    html_nodes(xpath='//*[@class="result-price"]') %>%
    html_text()
  price <- price[seq(1, length(price), 2)]
  # price is missing for #54
  
  time <- url %>% 
    html_nodes(xpath='//*[@class="result-date"]') %>%
    html_attr("datetime")
  
  # img <- url %>% 
  #   html_nodes(xpath='//*[@class="swipe-wrap"]/div/img') %>%
  #   html_attr("href")
  # img <- paste0('https://dallas.craigslist.org', img)

  
  
  
  listings <- data.frame(desc = name[1:min(54, length(links))],
                         price = price[1:min(54, length(links))],
                         time = time[1:min(54, length(links))],
                         url = links[1:min(54, length(links))], 
                         stringsAsFactors = FALSE)
  return(listings)
  
}