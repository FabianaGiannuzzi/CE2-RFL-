#data access  CE_02
#richi_fabi_ludo
#2th tremester

# Source setup scripts:
source(here::here("src","00_setup.R"))

here::here("")


# POINT 1 ----------------------------------------------------------------------------------------------------
## Inspect the robot.txt and describe what you can and what you should not do. Pay attention to the allow / di sallow statements and the definition of user-agent. What do these lines mean?

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

page <- RCurl::getURL(url, 
               useragent = str_c(R.version$platform,
                                 R.version$version.string,
                                 sep = ", "),
               httpheader = c(From = "giannuzzifabianagemma@gmail.com"))



writeLines(page, 
           con = here::here("/data/Beppe_grillo_blog.html"))


# POINT 3 --------------------------------------------------------------
# Create a data frame with all the HTML links in the page using the XML::getHTMLLinks().
# Then, use a regex to keep only those links that re-direct to other posts of the beppegrillo.it blog (so remove all other links).

links <- XML::getHTMLLinks("http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/")

filteredlinks <- str_subset(links, "^http://www\\.beppegrillo\\.it")

dat <- tibble(
  links = filteredlinks)

dat

# Finally, achieve the same result using rvest:: instead of XML.

links2 <- read_html(here::here("data/Beppe_grillo_blog.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links2

filteredlinks2 <- str_subset(links2, "^http://www\\.beppegrillo\\.it")

dat2 <- tibble(
  links2 = filteredlinks2
)
dat2

#Creating a dataset with both variables 
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
#     - cat()
#     - Get the page and save it, providing our personal e-mail;
#     - Parse the file and extract want we are interested to; 
#     - Of course, we will use "sys.sleep(2)" to make this process less stressful for the program.



#POINT 5------------------------------------------------------------------------------------------------------------
##Check out the following link: http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/. Download it using RCcurl::getURL() to download the page while informing the webmaster about your browser details and providing your email.

url_2 <- URLencode("https://www.beppegrillo.it/category/archivio/2016/")
browseURL(url_2)
url_2


page2 <- getURL(url_2, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it")) 



writeLines(page2, 
           con = here::here("data/Beppe_grillo_archivio_2016.html"))


#For each of the 47 pages, get all the links and place them into a list (or character vector)

link_archivio <- lapply(paste0("https://www.beppegrillo.it/category/archivio/2016/page/", 1:47),
                        function(url){
                          url_2 %>% read_html() %>% 
                            html_nodes(".td_module_10 .td-module-title a") %>% 
                            html_attr("href") 
                        })

link_archivio <- unlist(link_archivio)

#LOOP:

# I want to create a folder where to store all the pages:
dir.create("data/archivio_2016")

LINKS3 <- vector(mode = "list", length = length(link_archivio))

for (i in 226:length(link_archivio)) {
  
  cat("Iteration:", i, ". Scraping:", link_archivio[i],"\n")
  
  # Get the page
  page3 <- RCurl::getURL(link_archivio[i], 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "giannuzzifabianagemma@gmail.com"))
  
  # Save the page:
  file_path_1 <- here::here("data/archivio_2016", str_c("archivio_", i, ".html"))
  writeLines(page3, 
             con = file_path_1)
  
  # Parse and extract:
  LINKS3[[i]] <- read_html(file_path_1) %>% 
    html_nodes("p") %>% 
    html_text()
  
  # Rest!
  Sys.sleep(2)
} 

LINKS3
