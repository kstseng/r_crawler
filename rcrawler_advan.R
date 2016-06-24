library(rvest)
#---
# set url
#---
advan_url <- "http://www.directindustry.com/prod/advantech-4657.html" 
advan <- read_html(advan_url, encoding="UTF-8") 

#---
# Crawl by different id number and make data frame in a list
#---
id_list <- c(37722, 37724, 37725, 225117, 98993, 259394)
RES <- list()
for (i in 1:length(id_list)) {
  id <- id_list[i]
  xpath_i <- sprintf("//div[@id='group-product-list_%s']//div[contains(@class, 'group-product-list-item')]//a[not(@class) and not(@name)]/text()", id)
  res <- advan %>% html_nodes(xpath=xpath_i) %>% html_text()
  res_rm <- gsub("[ \t\v\f\r\n]", "", res)
  # res_rm <- gsub("®", "@", res)
  res_rm <- res_rm[res_rm != ""]
  res_rm <- as.data.frame(res_rm)
  colnames(res_rm) <- "Products"
  rownames(res_rm) <- NULL
  RES[[i]] <- res_rm
}

#---
# write multiple dataframe into a xlsx with multiple sheets
# set ID name as xlsx sheet name
#---
ID_name <- c("Industrial Automation", "Embedded Boards & Design-in Services", "Digital Healthcare", "Intelligent Systems", 
             "Digital Logistics, iRetail & Hospitality", "Industrial Communication")
library(xlsx)
write.xlsx(x = RES[[1]], file = "C:\\Users\\David79.Tseng\\Desktop\\AdvanCrawler.xlsx", sheetName = ID_name[1], col.names = TRUE, row.names = FALSE)
for (j in 2:length(ID_name)) {
  write.xlsx(x = RES[[j]], file = "C:\\Users\\David79.Tseng\\Desktop\\AdvanCrawler.xlsx", sheetName = ID_name[j], col.names = TRUE, row.names = FALSE, append = T)  
}
