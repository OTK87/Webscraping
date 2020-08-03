library(readxl)
setwd('/Users/otakarkorinek/Documents/Research-PublicProcurement/Kontakty na Obce')
filenames <- list.files("./", pattern="*.xlsx")
obce_data<-data.frame()
split_kraj_name <- ""
for(i in 1:length(filenames)){
  temp_obce_data <- read_excel(filenames[i], range = cell_cols("C:F"))
 temp_obce_data$kraj <- sapply(strsplit(gsub(".xlsx", "", filenames[i]), "_"), function(x) {
    x[2]
  })
 split_kraj_name <- strsplit(filenames[i], ".", TRUE, FALSE,)
 substr(split_kraj_name, start = 1, stop = "x")
  for(j in 1:nrow(temp_obce_data)){
    temp_obce_data[j, 5] <- split_kraj_name[[1]][1]
      }
  obce_data <- rbind(obce_data, temp_obce_data)
}

all_kraje_wd<-list.files(paste("Kontakty na Obce", filenames, sep="/"))

read_excel("/Users/otakarkorinek/Documents/Research-PublicProcurement/Kontakty na kraje/Seznam Měst a Obcí.xlsx")

for(i in  1:nrow(Seznam_Me_st_a_Obci_)) {
  #current code of town on the row
  current_townid <- Seznam_Me_st_a_Obci_[i, 2]
  current_row <- obce_data[which(grepl(current_townid, obce_data$obec_id)), ]
  current_mail <- current_row[1, 3]
  current_web <- current_row[1, 4]
  Seznam_Me_st_a_Obci_[i, 10] <- current_mail
  Seznam_Me_st_a_Obci_[i, 12] <- current_web
  print(current_row)
}