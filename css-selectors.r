
#SELECTOR EXAMPLES USING RVEST

library(rvest)

website <- read_html("https://blueshift.io/selectors2.html")


#CSS Selector: Tag
allListItems <- html_nodes(website,"li") %>% html_text()
allListItems

#CSS Selector: Class
firstItems <- html_nodes(website,".item1") %>% html_text()
firstItems

#CSS Selector: ID
fruitList <-  html_nodes(website,"#fruits") %>% html_text()
fruitList

#CSS Selector: ID
cssExample <- html_nodes(website,"#programming-languages .item2") %>% html_text()
cssExample


#****SELECT BY XPATH****
xpathExample <- html_nodes(website, xpath = "//*[@id='fruits']/li[1]") %>% html_text()
xpathExample
