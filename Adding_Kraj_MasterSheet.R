library(readxl)
read_excel("/Users/otakarkorinek/Documents/Research-PublicProcurement/Kontakty na Obce/Seznam_Mest_a_Obci.xlsx")
View("/Users/otakarkorinek/Documents/Research-PublicProcurement/Kontakty na Obce/Seznam_Mest_a_Obci.xlsx")
for(i in  1:nrow(Seznam_Mest_a_Obci)) {
  #current code of town on the row
  current_townid <- Seznam_Mest_a_Obci[i, 2]
  current_row <- obce_data[which(grepl(current_townid, obce_data$obec_id)), ]
  current_kraj <- current_row[1, 5]
  Seznam_Mest_a_Obci[i, 13] <- current_kraj
  print(current_kraj)
  print(current_row)
}
