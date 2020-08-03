library(rvest)
#defining base url for Karlovarsky kraj
url_Karlovarsky<- "http://www.epusa.cz/index.php?platnost_k=0&sessID=0&jazyk=cz&obec="
#defining url for each municipality in Karlovarsky kraj
  url_Karlovarsky_obec<-url_Karlovarsky
  Karlovarsky_kraj_Data$url_obec<-url_Karlovarsky_obec
for (i in 1:nrow(Karlovarsky_kraj_Data))
  {
  url_Karlovarsky_obec<-paste(url_Karlovarsky_obec, Karlovarsky_kraj_Data[i, "code"], sep = '')
  Karlovarsky_kraj_Data[i, "url_obec"]<-url_Karlovarsky_obec
  url_Karlovarsky_obec<-url_Karlovarsky
}
  web_Karlovarsky_obec <- ''
  mail_Karlovarsky_obec <- ''
  
  Karlovarsky_kraj_Data$web_obec <- web_Karlovarsky_obec
  Karlovarsky_kraj_Data$mail_obec <- mail_Karlovarsky_obec
  
  for (i in 1:nrow(Karlovarsky_kraj_Data))
    {
    webpage <- read_html(Karlovarsky_kraj_Data[i, "url_obec"])
    web_obec_html <- html_nodes(webpage, "dd a")
    web_Karlovarsky_obec <- html_text(web_obec_html)
   
  }
  for (i in 1:nrow(Karlovarsky_kraj_Data)) {
    webpage <- read_html(Karlovarsky_kraj_Data[i, "url_obec"])
    mail_obec_html <- html_nodes(webpage, "dd a")
    mail_Karlovarsky_obec <- html_text(mail_obec_html)
    
  }
  web_Karlovarsky_obec <- ''
  mail_Karlovarsky_obec <- ''
  
  Karlovarsky_kraj_Data$web_obec <- web_Karlovarsky_obec
  Karlovarsky_kraj_Data$mail_obec <- mail_Karlovarsky_obec
  
  for (i in 1:nrow(Karlovarsky_kraj_Data)) {
    webpage <- read_html(Karlovarsky_kraj_Data[i, "url_obec"])
    mail_obec_html <- html_nodes(webpage, "dd a")
    mail_Karlovarsky_obec <- html_text(mail_obec_html)
    Karlovarsky_kraj_Data[i, "mail_obec"] <- mail_Karlovarsky_obec[1]
    Karlovarsky_kraj_Data[i, "web_obec"] <- mail_Karlovarsky_obec[2]
  }
  print(mail_Karlovarsky_obec)
  
  