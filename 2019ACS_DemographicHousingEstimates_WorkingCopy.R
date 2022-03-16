#Purpose:This script is used to clean the demographic and housing estimates zip code data that I pulled from the Census

#Notes:
  #1. If you have ways to improve the code below, feel free to make changes and submit a code request
  #2. To view the data dictionary associated with this data set, open the .xlsx file and it will be on sheet #2
  #3. The Census does a great job with labeling their variables. However, my community will not want to have to figure out what "DP05_0019E" stands for

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
setwd("C:/Users/slawinskimc/OneDrive - Florida Department of Health/Documents/GitHub/Census")

#Calling in data and viewing  it
acs_demohouse  <- read_xlsx("2019ACS_DemographicHousingEstimates_WorkingCopy.xlsx", skip = 1)
  View(acs_demohouse)

#Deleting columns with Margin labels
acs_demohouse2 <- select(acs_demohouse, -contains("Margin"))
  View(acs_demohouse2)

#Moving vars to beginning of data frame
acs_demohouse3  <-  acs_demohouse2 %>%  
    relocate(180, .before=1)

    view(acs_demohouse3)

acs_demohouse4 <- acs_demohouse3  %>%  
    relocate(180, .before=2)

    view(acs_demohouse4)

#Subsetting  out  the  columns  with  no  data or duplicate data - see data dictionary sheet of data file 
acs_demohouse5 <- subset(acs_demohouse4, select = -c(4, 10, 38, 51, 52, 58, 59, 60, 66, 67, 68, 73, 74, 117, 118, 142))
    view(acs_demohouse5)
    
  #Renaming  column  variables
  #Use  data  dictionary
  updated_names  <-
    c(
    "Zipcode",
    "ID",
    "TotalPop_Estimate",
    "Male_Estimate",
    "Male_Percent",
    "Female_Estimate",
    "Female_Percent",
    "Male_SexRatio_Estimate",
    "Under5_Estimate",
    "Under5_Percent",
    "5to9_Estimate",
    "5to9_Percent",
    "10to14_Estimate",
    "10to14_Percent",
    "15to19_Estimate",
    "15to19_Percent",
    "20to24_Estimate",
    "20to24_Percent",
    "25to34_Estimate",
    "25to34_Percent",
    "35to44_Estimate",
    "35to44_Percent",
    "45to54_Estimate",
    "45to54_Percent",
    "55to59_Estimate",
    "55to59_Percent",
    "60to64_Estimate",
    "60to64_Percent",
    "65to74_Estimate",
    "65to74_Percent",
    "75to84_Estimate",
    "75to84_Percent",
    "85andOver_Estimate",
    "85andOver_Percent",
    "MedianAge_Estimate",
    "Under18_Estimate",
    "Under18_Percent",
    "16andOver_Estimate",
    "16andOver_Percent",
    "18andOver_Estimate",
    "18andOver_Percent",
    "21andOver_Estimate",
    "21andOver_Percent",
    "62andOver_Estimate",
    "62andOver_Percent",
    "65andOver_Estimate",
    "65andOver_Percent",
    "Male_18andOver_Estimate",
    "Male_18andOver_Percent",
    "Female_18andOver_Estimate",
    "Female_18andOver_Percent",
    "Male_18andOver_SexRatio_Estimate",
    "Male_65andOver_Estimate",
    "Male_65andOver_Percent",
    "Female_65andOver_Estimate",
    "Female_65andOver_Percent",
    "Male_65andOver_SexRatio_Estimate",
    "OneRace_Estimate",
    "OneRace_Percent",
    "TwoRace_Estimate",
    "TwoRace_Percent",
    "OneRace_White_Estimate",
    "OneRace_White_Percent",
    "OneRace_BlackAA_Estimate",
    "OneRace_BlackAA_Percent",
    "OneRace_AIAN_Estimate",
    "OneRace_AIAN_Percent",
    "OneRace_AIAN_Cherokee_Estimate",
    "OneRace_AIAN_Cherokee_Percent",
    "OneRace_AIAN_Chippewa_Estimate",
    "OneRace_AIAN_Chippewa_Percent",
    "OneRace_AIAN_Navajo_Estimate",
    "OneRace_AIAN_Navajo_Percent",
    "OneRace_AIAN_Sioux_Estimate",
    "OneRace_AIAN_Sioux_Percent",
    "OneRace_Asian_Estimate",
    "OneRace_Asian_Percent",
    "OneRace_Asian_AsianIndian_Estimate",
    "OneRace_Asian_AsianIndian_Percent",
    "OneRace_Asian_Chinese_Estimate",
    "OneRace_Asian_Chinese_Percent",
    "OneRace_Asian_Filipino_Estimate",
    "OneRace_Asian_Filipino_Percent",
    "OneRace_Asian_Japanese_Estimate",
    "OneRace_Asian_Japanese_Percent",
    "OneRace_Asian_Korean_Estimate",
    "OneRace_Asian_Korean_Percent",
    "OneRace_Asian_Vietnamese_Estimate",
    "OneRace_Asian_Vietnamese_Percent",
    "OneRace_Asian_Other_Estimate",
    "OneRace_Asian_Other_Percent",
    "OneRace_NHOPI_Estimate",
    "OneRace_NHOPI_Percent",
    "OneRace_NHOPIN_Islander_Estimate",
    "OneRace_NHOPIN__Percent",
    "OneRace_NHOPIG_Guamanian_Estimate",
    "OneRace_NHOPIG_Guamanian_Percent",
    "OneRace_NHOPI_Pacific_Estimate",
    "OneRace_NHOPI_Pacific_Percent",
    "OneRace_NHOPIOP_Other_Estimate",
    "OneRace_NHOPIOP_Other_Percent",
    "OneRace_SomeOtherRace_Estimate",
    "OneRace_SomeOtherRace_Percent",
    "TwoRace_White_BlackAA_Estimate",
    "TwoRace_White_BlackAA_Percent",
    "TwoRace_White_AIAN_Estimate",
    "TwoRace_White_AIAN_Percent",
    "TwoRace_White_Asian_Estimate",
    "TwoRace_White_Asian_Percent",
    "TwoRace_BlackAA_AIAN_Estimate",
    "TwoRace_BlackAA_AIAN_Percent",
    "AloneComboRace_Estimate",
    "AloneComboRace_Estimate",
    "AloneComboRace_White_Estimate",
    "AloneComboRace_White_Percent",
    "AloneComboRace_BlackAA_Estimate",
    "AloneComboRace_BlackAA_Percent",
    "AloneComboRace_AIAN_Estimate",
    "AloneComboRace_AIAN_Percent",
    "AloneComboRace_Asian_Estimate",
    "AloneComboRace_Asian_Percent",
    "AloneComboRace_NHOPI_Estimate",
    "AloneComboRace_NHOPI_Percent",
    "AloneComboRace_Other_Estimate",
    "AloneComboRace_Other_Percent",
    "HispanicLatino_Estimate",
    "HispanicLatino_AnyRace_Estimate",
    "HispanicLatino_AnyRace_Percent",
    "HispanicLatino_Mexican_AnyRace_Estimate",
    "HispanicLatino_Mexican_AnyRace_Percent",
    "HispanicLatino_PuertoRican_AnyRace_Estimate",
    "HispanicLatino_PuertoRican_AnyRace_Percent",
    "HispanicLatino_Cuban_AnyRace_Estimate",
    "HispanicLatino_Cuban_AnyRace_Percent",
    "HispanicLatino_Other_AnyRace_Estimate",
    "HispanicLatino_Other_AnyRace_Percent",
    "NotHispanicLatino_Estimate",
    "NotHispanicLatino_Percent",
    "NotHispanicLatino_White_Estimate",
    "NotHispanicLatino_White_Percent",
    "NotHispanicLatino_BlackAA_Estimate",
    "NotHispanicLatino_BlackAA_Percent",
    "NotHispanicLatino_AIAN_Estimate",
    "NotHispanicLatino_AIAN_Percent",
    "NotHispanicLatino_Asian_Estimate",
    "NotHispanicLatino_Asian_Percent",
    "NotHispanicLatino_NHOPI_Estimate",
    "NotHispanicLatino_NHOPI_Percent",
    "NotHispanicLatino_AloneOther_Estimate",
    "NotHispanicLatino_AloneOther_Percent",
    "NotHispanicLatino_TwoMore_Estimate",
    "NotHispanicLatino_TwoMore_Percent",
    "NotHispanicLatino_TwoMore_IncludeOther_Estimate",
    "NotHispanicLatino_TwoMore_IncludeOther_Percent",
    "NotHispanicLatino_TwoMore_ExcludeOtherThree_Estimate",
    "NotHispanicLatino_TwoMore_ExcludeOtherThree_Percent",
    "HousingUnits_Estimate",
    "HousingUnits_Percent",
    "Vote_18andOver_Estimate",
    "Vote_18andOver_Percent",
    "Vote_Male_18andOver_Estimate",
    "Vote_Male_18andOver_Percent",
    "Vote_Female_18andOver_Estimate",
    "Vote_Female_18andOver_Percent"
)

acs_demohouse6  <-
  acs_demohouse5  %>%  
  set_names(updated_names)

#Cleaning up Zipcode to not include 'ZCTA5 ' in the observations
acs_demohouse7 <- acs_demohouse6
acs_demohouse7$Zipcode <- gsub("ZCTA5 ","",as.character(acs_demohouse7$Zipcode))

  view(acs_demohouse7)
  
#This is all the data cleaning I will perform on this data set at this time
  
  