install.packages("RCurl")
library(RCurl)
library(rvest)
library(tidyverse)

# POINT 1 ----------------------------------------------------------------------------------------------------
## Inspect the robot.txt and describe what you can and what you should not do. Pay attention to the allow / di sallow statements and the definition of user-agent. What do these lines mean?

#Storing the url to creare a tidy structure of the file using the URLencode() to avoid potential problems with formatting the URL
url <- URLencode("http://www.beppegrillo.it/un-mare-diplastica-ci-sommergera/")

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

