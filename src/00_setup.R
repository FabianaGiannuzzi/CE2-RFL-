#data access  CE_02
#richi_fabi_ludo
#2th tremester

# Installing packages ---------------------------------------------------------------------------------

want = c("here","RCurl","tidyverse", "rvest")  # list of required packages
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)

library("here")
library("RCurl")
library("tidyverse")
library("rvest")
