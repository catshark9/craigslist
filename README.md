# craigslist
Craigslist Webscraper

### To set up for reoccuring task:
# Save all R files in a single directory

# Run the following in R to create a bat file

r_loc = "C:/Program Files\R/R-3.3.0/bin/R.exe"

scraper_loc = "C:/Users/User/Project/clscraper.R"

system(r_loc CMD BATCH scraper_loc)

# in task schedular, create a task that points to bat file

