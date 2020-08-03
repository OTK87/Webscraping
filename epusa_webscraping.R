library(rvest)
library(dplyr)
library(data.table)
library(stringr)
library(xlsx)

all_kraj_number <- c(51, 19, 35, 116, 86, 78, 132, 124, 94, 43, 27, 60, 108, 141)
all_kraj_name <- c("Karlovarský kraj", "Hlavní město Praha", "Jihočeský kraj", 
                   "Jihomoravský kraj", "Královehradecký kraj", "Liberecký kraj",
                   "Moravskoslezský kraj", "Olomoucký kraj", "Pardubický kraj",
                   "Plzeňský kraj", "Středočeský kraj", "Ústecký kraj", 
                   "Kraj Vysočina", "Zlínský kraj")

for (j in 1:length(all_kraj_number)){
  insert_kraj_number <- all_kraj_number[j]
  insert_kraj_name <- all_kraj_name[j]
  
  
  # input parameters for the code
  #insert_kraj_number <- 51
  #insert_kraj_name <- "Karlovarský kraj"
  
  # base url
  url_general <- paste("http://www.epusa.cz/index.php?platnost_k=0&sessID=0&jazyk=cz&kraj=", 
                       insert_kraj_number, 
                       "&zkratka=obce", sep = "")
  
  # get id of all municipalities
  webpage <- read_html(url_general)
  obec_data <- 
    data.frame("webpage" = html_attr(html_nodes(webpage, "a"), "href")) %>%
    filter(str_detect(string = webpage, pattern = "&obec=(.?)")) %>%
    rowwise() %>%
    mutate(obec_id = trimws(str_extract(webpage, "(?<=\\&obec=)\\d+")))
  
  # define output data frame
  output_data <- 
    data.frame("kraj_id" = rep(NA, nrow(obec_data)),
               "kraj_name" = rep(NA, nrow(obec_data)),
               "obec_id" = rep(NA, nrow(obec_data)),
               "obec_name" = rep(NA, nrow(obec_data)),
               "email" = rep(NA, nrow(obec_data)),
               "website" = rep(NA, nrow(obec_data)),
               "url" = rep(NA, nrow(obec_data)))
  
  # run for each ID
  count <- 1
  for (i in obec_data$obec_id){
    
    # i <- "554979"
    url_specific <- 
      paste("http://www.epusa.cz/index.php?platnost_k=0&sessID=0&jazyk=cz&obec=", 
            i, sep = "")}
    
    
    # open specific web page
    webpage <- read_html(url_specific)
    
    # download the data
    
    # - email
    ## here be careful, if the resulted set of email will be more than 2, feel free to add additional restrictions
    email_data <- 
      data.frame("mail" = html_attr(html_nodes(webpage, "a"), "href")) %>%
      filter(str_detect(mail, "index", negate = T)) %>%
      filter(str_detect(mail, "help", negate = T)) %>%
      filter(str_detect(mail, "http", negate = T)) %>%
      filter(str_detect(mail, "mailto:")) %>%
      rowwise() %>%
      mutate(mail_final = trimws(str_replace_all(mail, "mailto:", "")))
    
    # - website
    website_data <- 
      data.frame("website" = html_attr(html_nodes(webpage, "a"), "href")) %>%
      filter(str_detect(website, "http", negate = F)) %>%
      filter(str_detect(website, "mapy", negate = T)) %>%
      filter(str_detect(website, "asociacekraju", negate = T)) %>%
      filter(str_detect(website, "vdb.czso.cz", negate = T))
    
    # write data into data frame
    output_data$kraj_id[count] <- insert_kraj_number
    output_data$kraj_name[count] <- insert_kraj_name
    output_data$obec_name[count] <- html_nodes(webpage, "h1") %>% html_text()
    output_data$obec_id[count] <- i
    output_data$email[count] <- email_data$mail_final[1]
    output_data$website[count] <- website_data$website[1]
    output_data$url[count] <- url_specific
    
    print(i)
    
    # increase the counter
    count <- count + 1
  }
  
  write.table(x = output_data, 
              file = paste(insert_kraj_name, ".xlsx", sep = ""), 
              append = F, row.names = F)
}

