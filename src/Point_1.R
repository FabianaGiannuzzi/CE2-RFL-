#data access  CE_02
#richi_fabi_ludo
#2th tremester

# Source setup scripts:
source(here::here("src","00_setup.R"))

here::here("")


# POINT 1 ----------------------------------------------------------------------------------------------------
## Inspect the robot.txt and describe what you can and what you should not do. Pay attention to the allow / disallow statements and the definition of user-agent. What do these lines mean?

#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/")

#Inspecting the robot.txt to see what we are allowed to scrape. 
browseURL("http://www.beppegrillo.it/robots.txt")

#Commenting the results

#We obtained "User-agent: *". The user-agent refers to the robots to whom the Disallow and Allow codes apply. In this case the "*" refers to every robot.
#"Disallow: /wp-admin/" means that every robot is excluded from this specific part of the server.
#"Allow: /wp-admin/admin-ajax.php" means that every robot is allowed to scrape "admin-ajax.php".

# POINT 2 ------------------------------------------------------------------------------------------------------
##Check out the following link: http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/. Download it using RCcurl::getURL() to download the page while informing the webmaster about your browser details and providing your email.

##Downloading the file
page <- RCurl::getURL(url, 
               useragent = str_c(R.version$platform,
                                 R.version$version.string,
                                 sep = ", "),
               httpheader = c(From = "giannuzzifabianagemma@gmail.com"))


#Saving the page
writeLines(page, 
           con = here::here("/data/Beppe_grillo_blog.html"))


# POINT 3 --------------------------------------------------------------
# Create a data frame with all the HTML links in the page using the XML::getHTMLLinks().
# Then, use a regex to keep only those links that re-direct to other posts of the beppegrillo.it blog (so remove all other links).

##Getting all the links
links <- XML::getHTMLLinks("http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/")

##Filtering the links to keep only those from the blog
filteredlinks <- str_subset(links, "^http://www\\.beppegrillo\\.it")

dat <- tibble(
  links = filteredlinks)

dat

#Using rvest:: instead of XML.

links2 <- read_html(here::here("data/Beppe_grillo_blog.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links2

filteredlinks2 <- str_subset(links2, "^http://www\\.beppegrillo\\.it")

dat2 <- tibble(
  links2 = filteredlinks2
)
dat2

#Creating a dataset with both variables to check them easily
dat3 <- tibble(
  links = filteredlinks,
  links2 = filteredlinks2
)
dat3


# POINT 4-----------------------------------------------------------------------------------
# Go back to the initial link and focus on the bottom of the page: "Prossimo articolo" it means following article. Scrape this link and then use it to scrape the article "In Svizzera il tragitto casa-ufficio è orario di lavoro” (i.e. the following page). 

#Scraping the link "Prossimo articolo" 
linkNEXTART <- read_html (here::here("data/Beppe_grillo_blog.html")) %>% 
  html_nodes (css = ".td-post-next-post a") %>% 
  html_attr ("href")

linkNEXTART

#Scraping the article 
nextarticle <- read_html(linkNEXTART) %>% 
  html_nodes(css = "p") %>% 
  html_text()

nextarticle

#How could you use these previous and following links to scrape many more blog posts? [don’t do it, just sketch the ideas and the R functions you should use] 

#To repeat the same process for many links we should use the function *for loop* which allows us
# to apply the same codes to many pages. To do that we have to follow some steps:
# 1. We have to generate an output container, which means creating a vector specifying the mode and the length;
# 2. There are two ways to index the links: the first way consists to index all the links directly while a second and preferable way consists in using simple indices;
# 3. We have then to create a folder in which all the pages can be stored with the function "dir.create" and specifying the name that we want to assign to the folder;
# 4. At this point we can start working with the loop function:
#     - the first step is specify the index;
#     - Then we print the outputs with cat()
#     - Get the page and save it, providing our personal e-mail;
#     - Parse the file and extract want we are interested to; 
#     - Of course, we will use "sys.sleep(2)" to make this process less stressful for the program.



#POINT 5------------------------------------------------------------------------------------------------------------
##Check out the following link: http://www.beppegrillo.it/category/archivio/2016/ . It contains the entire blog for 2016. There are 47 pages of entries. Scrape all the posts for 2016 following this strategy:
##a)For each of the 47 pages, get all the links and place them into a list (or character vector)
##b)For each link, download the files and sys.sleep() for few seconds
##c)For each downloaded page, scrape the main text. Ask yourself what happens if a page contains no text.


#Browsing the page 
url_2 <- URLencode("https://www.beppegrillo.it/category/archivio/2016/")
browseURL(url_2)
url_2

#Downloading the page while specifying our browser and providing our email
page2 <- getURL(url_2, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it")) 


#Saving the page 
writeLines(page2, 
           con = here::here("data/Beppe_grillo_archivio_2016.html"))

#Creating an object to grab all the links from the 47 pages
link_archivio <- lapply(paste0("https://www.beppegrillo.it/category/archivio/2016/page/", 1:47),
                        function(url){
                          url_2 %>% read_html() %>% 
                            html_nodes(".td_module_10 .td-module-title a") %>% 
                            html_attr("href") 
                        })

link_archivio <- unlist(link_archivio)

#LOOP:

#Creating a folder where to store all the pages:
dir.create("data/archivio_2016")

#Specifying lenght and mode of the vector
articoli_archivio_2016 <- vector(mode = "list", length = length(link_archivio))

#Applying the for loop function to get all the links and their texts from the 47 pages of the 2016 archivio.
for (i in 1:length(link_archivio)) {
  
  cat("Iteration:", i, ". Scraping:", link_archivio[i],"\n")
  
  #Getting the page
  page3 <- RCurl::getURL(link_archivio[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "giannuzzifabianagemma@gmail.com"))
  
  #Saving the page:
  file_path_1 <- here::here("data/archivio_2016", str_c("archivio_", i, ".html"))
  writeLines(page3, 
             con = file_path_1)
  
  #Parsing and extracting
  articoli_archivio_2016[[i]] <- read_html(file_path_1) %>% 
    html_nodes("p") %>% 
    html_text()
  
  #Setting the amount of time in which the code rests.
  Sys.sleep(2)
} 

articoli_archivio_2016

##c) If a page contains no text we expect the iteration to stop and print an error and then we would delete the link with no text in it and start again from there substituing the 1 with the position the empty link had so that it can continue from there.
## A way to make the code reproducible is to use the if else condition so that you don't have to do it manually. In fact, when you use this function R automatically reacts to the error by skipping the empty page.

#POINT 6 -----------------------------------------------------------------------------
#Check out the RCrawler package and its accompanying paper. What does it mean to “ crawl” ? and what is it a “web spider” ? How is this different from a scraper you have built at point 5? 
#Inspect the package documentation and sketch how you could build a spider scraper: which function(s) should you use? With which arguments? Don't do it, just sketch and explain.

## According to Salim Khalil and Mohamed Fakir, Web crawlers are programs used to retrieve and collect data from the web. They browse and download web pages in an automated way.
## They differ according to the content of the pages they crawl: universal crawlers crawl all the web pages, preferential ones have a specific focus.
## A web spider is a web crawler and it  can read, parse and download a large amount of data on the internet. A web spider use some pre-selected criteria to search information on all the available source on internet, inspect the robots.txt file and automatically download data in a readable format.
##Our simple scrape script does not provide the same function of  crawling, because they can only parse and extract contents from URLs, which the user must collect and provide manually. Therefore, they are not able to traverse web pages, collecting links and data automatically.
##The main difference is that our script “scraper” is able to download all the data, only from a single web-page, while a crawler made the same things from a lot of pages on internet.
##A typical web spider is the script of google that scrape all the internet domain and save all the web link in a hierarchical list.

##


















