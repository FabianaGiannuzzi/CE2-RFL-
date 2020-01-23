install.packages("RCurl")
library(RCurl)
library(rvest)
library(tidyverse)

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
##Check out the following link: http://www.beppegrillo.it/un-mare-di- plastica-ci-sommergera/. Download it using RCcurl::getURL() to download the page while informing the webmaster about your browser details and providing your email.

        ## ???????? stop ("giannuzzifabianagemma@gmail.com")
page <- RCurl::getURL(url, 
               useragent = str_c(R.version$platform,
                                 R.version$version.string,
                                 sep = ", "),
               httpheader = c(From = "giannuzzifabianagemma@gmail.com")) 

writeLines(page, 
           con = here::here("Beppe_grillo_blog.html"))


# POINT 3 --------------------------------------------------------------
# Create a data frame with all the HTML links in the page using the XML::getHTMLLinks(). Then, use a regex to keep only those links that re-direct to other posts of the beppegrillo.it blog (so remove all other links). Finally, achieve the same result using rvest:: instead of XML.
# ?????? XML::getHTMLLinks("Beppe_grillo_blog.html")

links <- XML::getHTMLLinks("http://www.beppegrillo.it/un-mare-di-plastica-ci-sommergera/")

filteredlinks <- str_subset(links, "^http://www\\.beppegrillo\\.it")

dat <- tibble(
  links = filteredlinks
)
dat

links2 <- read_html(here::here("Beppe_grillo_blog.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

links2

filteredlinks2 <- str_subset(links2, "^http://www\\.beppegrillo\\.it")

dat2 <- tibble(
  links2 = filteredlinks2
)
dat2

dat3 <- tibble(
  links = filteredlinks,
  links2 = filteredlinks2
)
dat3




