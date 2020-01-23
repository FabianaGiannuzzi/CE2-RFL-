install.packages("RCurl")
library(RCurl)
library(rvest)
library(tidyverse)


url <- URLencode("http://www.beppegrillo.it/un-mare-diplastica-ci-sommergera/")

browseURL("http://www.beppegrillo.it/robots.txt")

##User-agent: *
##Disallow: /wp-admin/
##  Allow: /wp-admin/admin-ajax.php

##Sitemap: http://www.beppegrillo.it/sitemap.xml.gz

## The user-agent refers to the robots to whom the Disallow and Allow codes apply. In this case the "*" refers
##to every robot.

##"Disallow: /wp-admin/" means that every robot are excluded from this specific part of the server.
##"Allow: /wp-admin/admin-ajax.php" means that every robot is allowed to scrape the "admin-ajax.php".