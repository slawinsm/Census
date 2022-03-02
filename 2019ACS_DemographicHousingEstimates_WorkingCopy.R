#Purpose: This script is used to clean the demographic and housing estimates zip code data that I pulled from the Census

#Loading libraries
library(tidyverse)
library(readxl)
library(httr)
library(rlang)
library(dplyr)
library(janitor)

#Understanding which path directory R is looking at
getwd()

#Telling R where to look
setwd("~/Projects/Resource Map/Data/Demographic & Housing Estimates")

#Calling in data and viewing it
acs_demohouse <- read.csv("C:/Users/slawinskimc/OneDrive - Florida Department of Health/Documents/Projects/Resource Map/Data/Demographic & Housing Estimates/2019ACS_DemographicHousingEstimates_WorkingCopy.csv", skip = 1)
View(acs_demohouse)

#Deleting columns with 'Margin' labels
acs_demohouse2 <- select(acs_demohouse, -contains('Margin'))

#Moving vars to beginning of data frame
acs_demohouse3 <- acs_demohouse2 %>% 
  relocate(180, .before=1)
view(acs_demohouse3)

acs_demohouse4 <- acs_demohouse3 %>% 
  relocate(180, .before=2)

#Subsetting out the columns with no data
acs_demohouse5 <- subset( acs_demohouse4, select = -c(10, 38, 58, 66, 73, 74, 117, 118) )

#Renaming column variables
#Use data dictionary
updated_names <-
  c("ZIP", "ID", 
  )

acs_demohouse6 <-
  acs_demohouse5 %>% 
  set_names(updated_names)

view(acs_agesex_white3) 

#Cleaning up ZIP

