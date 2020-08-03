library(rvest)
library(dplyr)
library(data.table)
library(stringr)
library(xlsx)
# base url
url_general <- "https://www.zindex.cz/category/detail/VELKA_OBEC/9/"

# get id of all municipalities
webpage <- read_html(url_general)
#obec_data <- 
# data.frame("webpage" = html_attr(html_nodes(webpage, "a"), "href")) %>%
#filter(str_detect(string = webpage, pattern = "&obec=(.?)")) %>%
#rowwise() %>%
#mutate(obec_id = trimws(str_extract(webpage, "(?<=\\&obec=)\\d+")))

# define output data frame
output_data <- 
  data.frame("ranking" = rep(NA, nrow(links)),
             "obec_name" = rep(NA, nrow(links)),
             "ico" = rep(NA, nrow(links)),
             "zindex" = rep(NA, nrow(links)),
             "url" = rep(NA, nrow(links)))
webpage <- read_html(url_general)
# run for each ID
count <- 1
url_specific
for (i in 1:74){
  url_specific <- links$`html_attr(html_nodes(pg, "a"), "href")`[i]
  
  
  # open specific web page
  webpage <- read_html(url_specific)
  
  # download the data
  
  # - email
  ## here be careful, if the resulted set of email will be more than 2, feel free to add additional restrictions
  #ico_data <- 
  #  data.frame("ico" = html_attr(html_nodes(webpage, ".header_ico")) %>%
  #  html_text()) %>%
  # rowwise() %>%
  
  # - website
  # zindex_data <- 
  # data.frame("zindex" = html_nodes(webpage, ".value") %>%
  #          html_text()) %>%
  #filter(str_detect(zindex, ".", negate = T)) 
  
  # ranking_data <- 
  # data.frame("ranking" = html_nodes(webpage, ".value") %>%
  #           html_text()) %>%
  # filter(str_detect(ranking, "%", negate = T)) 
  
  
  # write data into data frame
  # output_data$ranking[count] <- ranking_data$ranking[1]
  output_data$ranking[count] <- html_nodes(webpage, ".value") %>%
    html_text() %>%
    # filter(str_detect(ranking, "%", negate = T))
    output_data$obec_name[count] <- html_nodes(webpage, "h1") %>% html_text()
  # output_data$ico[count] <- ico_data$ico[1]
  output_data$ico[count] <-html_nodes(webpage, ".header_ico")
  
  output_data$zindex[count] <- html_nodes(webpage, ".value") %>%
    html_text() %>%
    # filter(str_detect(zindex, ".", negate = T))
    #zindex_data$zindex[1]
    output_data$url[count] <- url_specific
  
  print(i)
  
  # increase the counter
  count <- count + 1
}

write.table(x = output_data, 
            file = paste("zindex_webscraping", ".xlsx", sep = ""), 
            append = F, row.names = F)