# TescoIrelandFavoritePrices
Script written in R to login onto a Tesco Ireland account and web scrap your list of favourite items (based on Clubcard usage and online shopping) with current prices and promos, exporting the data to a CSV file.

The only parameters that need to be changed are: login, password, number of pages in the favorites (for the loop) and destination folder of the csv export file.

Libraries used: rvest, dplyr, stringr
Built on R 3.6.1
