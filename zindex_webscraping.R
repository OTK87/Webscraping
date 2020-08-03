library(rvest)
library(dplyr)
library(data.table)
library(stringr)
library(xlsx)
library(writexl)
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
               "url" = rep(NA, nrow(links)),
               "Bidder_participation" = rep(NA, nrow(links)),
               "Winner_concentration" = rep(NA, nrow(links)),
               "Pro_competitive_tools" = rep(NA, nrow(links)),
               "Public_procurement_share_on_total_purchases" = rep(NA, nrow(links)),
               "Legal_misconduct" = rep(NA, nrow(links)),
               "Competitive_contracting" = rep(NA, nrow(links)),
               "Consistent_conduct" = rep(NA, nrow(links)),
               "Journal_data_quality" = rep(NA, nrow(links)),
               "Buyer_profile_data_quality" = rep(NA, nrow(links)))
  
  # run for each ID
  count <- 1
  url_specific <- url_general
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
    zindex_data <- 
      data.frame("zindex" = html_nodes(webpage, ".value") %>%
                 html_text()) %>%
      filter(str_detect(zindex, ".", negate = T)) 
      
    ranking_data <- 
      data.frame("ranking" = html_nodes(webpage, ".value") %>%
                 html_text()) %>%
      filter(str_detect(ranking, "%", negate = T)) 
      
   
   indicator_values <-
     data.frame("indicators" = html_nodes(webpage, ".indicator_value") %>%
                         html_text())
    
    # write data into data frame
    output_data$ranking[count] <- ranking_data$ranking[1]
    #output_data$ranking[count] <- html_nodes(webpage, ".value") %>%
      #html_text()
 # filter(str_detect(ranking, "%", negate = T))
    output_data$obec_name[count] <- html_nodes(webpage, "h1") %>% 
      html_text()
   # output_data$ico[count] <- ico_data$ico[1]
    output_data$ico[count] <-html_nodes(webpage, ".header_ico") %>%
    html_text() 
  #  output_data$zindex[count] <- html_nodes(webpage, ".value") %>%
     # html_text()
 # filter(str_detect(zindex, ".", negate = T))
    output_data$zindex[count] <- zindex_data$zindex[2]
    output_data$url[count] <- url_specific
    output_data$Bidder_participation[count] <- indicator_values[1,]
      output_data$Winner_concentration[count] <- indicator_values[2,]
      output_data$Pro_competitive_tools[count] <- indicator_values[3,]
      output_data$Public_procurement_share_on_total_purchases[count] <- indicator_values[4,]
      output_data$Legal_misconduct[count] <- indicator_values[5,]
      output_data$Competitive_contracting[count] <- indicator_values[6,]
      output_data$Consistent_conduct[count] <- indicator_values[7,]
      output_data$Journal_data_quality[count] <- indicator_values[8,]
      output_data$Buyer_profile_data_quality[count] <- indicator_values[9,]
    print(i)
    
    # increase the counter
    count <- count + 1
  }
  library(writexl)
  write.xlsx(x = output_data, 
              file = paste("/Users/otakarkorinek/Documents/Research-PublicProcurement/WebscrapingZindex_webscraping", ".xlsx", sep = ""), 
              append = F, row.names = F)

