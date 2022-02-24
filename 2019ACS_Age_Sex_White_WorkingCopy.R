#Loading libraries
library(tidyverse)
library(readxl)
library(httr)
library(rlang)
library(dplyr)

#janitor

#Understanding which path directory R is looking at
getwd()

#Telling R where to look
setwd("~/Projects/Resource Map/Data/RACE")

#Calling in data and viewing it
acs_agesex_white1 <- read_csv("~/Projects/Resource Map/Data/RACE/2019ACS_Age_Sex_White_WorkingCopy.csv", skip = 1)
view(acs_agesex_white1)

#Deleting columns with 'Margin' labels
acs_agesex_white2 <- select(acs_agesex_white1, -contains('Margin'))

#Moving vars to beginning of data frame
acs_agesex_white2 <- acs_agesex_white2 %>% 
  relocate(3, .before=2) #Just specify which columns you want to relocate from and where to
view(acs_agesex_white2)

#Renaming column headers with a vector
updated_names <-
  c("ID", "ZIP", 
    )

  acs_agesex_white3 <-
    acs_agesex_white2 %>% 
    set_names(updated_names)
 
   view(acs_agesex_white3) 
