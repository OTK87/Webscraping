library(rvest)
library(dplyr)
library(data.table)
library(stringr)
library(xlsx)

#links for big cities
URL <- "https://www.zindex.cz/category/detail/VELKA_OBEC/9/"

pg <- read_html(URL)

links <- data_frame(html_attr(html_nodes(pg, "a"), "href"))

for (i in 1:nrow(links)){
  links[i,1] <-  paste("https://www.zindex.cz", 
          links[i,1], sep = "")}

#links for government

# base url
url_general_government <- "https://www.zindex.cz/category/detail/STATNI_SPRAVA/13/"

# get id of all municipalities
webpage <- read_html(url_general_government)

# get links
pg <- read_html(url_general_government)

links_government <- data_frame(html_attr(html_nodes(pg, "a"), "href"))
links_government<- links_government[-c(1:6),]


for (i in 1:nrow(links_government)){
  links_government[i,1] <-  paste("https://www.zindex.cz", 
                                  links_government[i,1], sep = "")}