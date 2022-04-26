#Purpose:This script is used to clean the 2020 demographic and housing estimates census tract data that I pulled from the Census

#Notes:
#1. If you have ways to improve the code below, feel free to make changes and submit a code request

#Loading libraries
library(datapasta)
library(tidyverse)
library(readxl)
library(httr)
library(rlang)
library(dplyr)
library(janitor)

#Understanding which path directory R is looking at
getwd()

#Telling R where to look
setwd("C:/Users/slawinskimc/OneDrive - Florida Department of Health/Documents/Projects/Resource Map/Data/Demographic & Housing Estimates")

#Calling in data and viewing  it
CT_2020_1  <- read_xlsx("2020ACS_DemographicHousingEstimates_CensusTracks_WorkingCopy.xlsx", skip = 4)
