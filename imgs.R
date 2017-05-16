is.na(listings_new$img) <- TRUE

for(l in listings_new$url){
  img <- tryCatch(
    l %>% 
      read_html() %>%
      html_nodes('img') %>%
      html_attr("src"),
    error = function(e){'404'}    # a function that returns NA regardless of what it's passed
  )
  if(length(img)>1){
    img <- img[1]
  } else if(length(img)<1){
    img <- 'http://www.clads.us/wp-content/plugins/sortable-post-grid/img/default-no-image.png'
  } 
  
  listings_new[listings_new$url==l, 'img'] <- img
}

listings_new <- listings_new[listings_new$img!='404', ]
