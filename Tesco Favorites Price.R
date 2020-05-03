library(rvest)
library(dplyr)
library(stringr)

# address of Tesco Ireland's login page
login<-"https://secure.tesco.ie/register/?from=https://www.tesco.ie/groceries/%3fanonLogin=true%26vCount=1"

# creating a web session with the login information
pgsession<-html_session(login)
pgform<-html_form(pgsession)[[1]]  #in this case the submit is the 2nd form
filled_form<-set_values(pgform, loginID="XXXX", password="XXXX")
submit_form(pgsession, filled_form)

results<-data.frame()

# loop through the number of available pages, currently setup for 3 pages. Please change the middle number in seq function below
# to your number of pages: 1 page = 0, 2 pages = 100, 3 pages = 200, 4 pages = 300, etc.

for (i in seq(0, 200, 100))
{
tescopage <- "https://www.tesco.ie/groceries/favourites/browse/default.aspx?N=0&Nao="
tescopage <- paste0(tescopage, i)

page<-jump_to(pgsession, tescopage)

favorites<-html_nodes(page, "div .productLists")

name<-matrix(html_text(html_nodes(favorites, "h3"), trim=TRUE), ncol=1, byrow = TRUE)

price<-matrix(html_text(html_nodes(favorites, "p.price"), trim=TRUE), ncol=1, byrow = TRUE)

promo<-matrix(html_text(html_nodes(favorites, "div.descContent"), trim=TRUE), ncol=1, byrow = TRUE)

promo<-str_replace_all(promo, "   ","")
promo<-str_replace_all(promo, "\r\n"," ")
promo1<-str_locate(promo, "Rest of") 
promo <- str_sub(promo,1,promo1[,1]-1)

# create temp results and bind them to obtain final results dataframe.
rtemp<-cbind(name, price, promo)
results<-rbind(results, rtemp)
}

# changing column names.
colnames(results)[1] <- "Name"
colnames(results)[2] <- "Price"
colnames(results)[3] <- "Promo"

# if the number of rows is an exact hundred (100, 200, 300, etc), it is very likely that you're missing following pages.
# If that is the case, please adjust the seq function end number on the for loop (row 19).
nrow(results)

# creating and cleaning current time for file export
currtime <- format(Sys.time(), "%d_%m_%Y %X")
currtime <- str_replace_all(currtime, ":","_")
currtime <- str_replace_all(currtime, " ","_")

# please change the destination folder of the file.
# I've decided to keep the timestamp in order to mantain history of the prices, for future comparison and dashboard creation.
write.csv(results,paste0("D:\\New\\tesco_",currtime ,".csv"), row.names = TRUE)
