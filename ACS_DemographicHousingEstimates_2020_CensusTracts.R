#Purpose:This script is used to clean the 2020 demographic and housing estimates census tract data, Data from Census' American Community Survey

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
library(stringr)

#Understanding which path directory R is looking at
getwd()

#Telling R where to look
setwd("C:/Users/slawinskimc/OneDrive - Florida Department of Health/Documents/Projects/Resource Map/Data/Demographic & Housing Estimates")

#Calling in data and viewing  it
CT_2020_1  <- read_xlsx("2020ACS_DemographicHousingEstimates_CensusTracts_WorkingCopy.xlsx", skip = 4)

#Renaming  column  variables
#Used  data  dictionary in Excel and vector_paste_vertical short cut to paste variables
updated_names  <-
  c(  "CensusTract",
      "Delete",
      "TotalPop_Estimate",
      "Male_Estimate",
      "Female_Estimate",
      "Male_SexRatio_Estimate",
      "Under5_Estimate",
      "5to9_Estimate",
      "10to14_Estimate",
      "15to19_Estimate",
      "20to24_Estimate",
      "25to34_Estimate",
      "35to44_Estimate",
      "45to54_Estimate",
      "55to59_Estimate",
      "60to64_Estimate",
      "65to74_Estimate",
      "75to84_Estimate",
      "85andOver_Estimate",
      "MedianAge_Estimate",
      "Under18_Estimate",
      "16andOver_Estimate",
      "18andOver_Estimate",
      "21andOver_Estimate",
      "62andOver_Estimate",
      "65andOver_Estimate",
      "Delete",
      "Male_18andOver_Estimate",
      "Female_18andOver_Estimate",
      "Male_18andOver_SexRatio_Estimate",
      "Delete",
      "Male_65andOver_Estimate",
      "Female_65andOver_Estimate",
      "Male_65andOver_SexRatio_Estimate",
      "Delete",
      "TotalRace_Estimate",
      "OneRace_Estimate",
      "TwoRace_Estimate",
      "Delete",
      "OneRace_White_Estimate",
      "OneRace_BlackAA_Estimate",
      "OneRace_AIAN_Estimate",
      "OneRace_AIAN_Cherokee_Estimate",
      "OneRace_AIAN_Chippewa_Estimate",
      "OneRace_AIAN_Navajo_Estimate",
      "OneRace_AIAN_Sioux_Estimate",
      "OneRace_Asian_Estimate",
      "OneRace_Asian_AsianIndian_Estimate",
      "OneRace_Asian_Chinese_Estimate",
      "OneRace_Asian_Filipino_Estimate",
      "OneRace_Asian_Japanese_Estimate",
      "OneRace_Asian_Korean_Estimate",
      "OneRace_Asian_Vietnamese_Estimate",
      "OneRace_Asian_Other_Estimate",
      "OneRace_NHOPI_Estimate",
      "OneRace_NHOPIN_NativeHawaiian_Estimate",
      "OneRace_NHOPIG_Chamorro_Estimate",
      "OneRace_NHOPI_Samoan_Estimate",
      "OneRace_NHOPIOP_Other_Estimate",
      "OneRace_SomeOtherRace_Estimate",
      "Delete",
      "TwoRace_White_BlackAA_Estimate",
      "TwoRace_White_AIAN_Estimate",
      "TwoRace_White_Asian_Estimate",
      "TwoRace_BlackAA_AIAN_Estimate",
      "Delete",
      "AloneComboRace_Estimate",
      "AloneComboRace_White_Estimate",
      "AloneComboRace_BlackAA_Estimate",
      "AloneComboRace_AIAN_Estimate",
      "AloneComboRace_Asian_Estimate",
      "AloneComboRace_NHOPI_Estimate",
      "AloneComboRace_Other_Estimate",
      "Delete",
      "HispanicLatino_Estimate",
      "HispanicLatino_AnyRace_Estimate",
      "HispanicLatino_Mexican_AnyRace_Estimate",
      "HispanicLatino_PuertoRican_AnyRace_Estimate",
      "HispanicLatino_Cuban_AnyRace_Estimate",
      "HispanicLatino_Other_AnyRace_Estimate",
      "NotHispanicLatino_Estimate",
      "NotHispanicLatino_White_Estimate",
      "NotHispanicLatino_BlackAA_Estimate",
      "NotHispanicLatino_AIAN_Estimate",
      "NotHispanicLatino_Asian_Estimate",
      "NotHispanicLatino_NHOPI_Estimate",
      "NotHispanicLatino_AloneOther_Estimate",
      "NotHispanicLatino_TwoMore_Estimate",
      "NotHispanicLatino_TwoMore_IncludeOther_Estimate",
      "NotHispanicLatino_TwoMore_ExcludeOtherThree_Estimate",
      "HousingUnits_Estimate",
      "Delete",
      "Vote_18andOver_Estimate",
      "Vote_Male_18andOver_Estimate",
      "Vote_Female_18andOver_Estimate")

CT_2020_2  <-
  CT_2020_1  %>%  
  set_names(updated_names)
    
#Subsetting  out  the  columns  with  no  data or duplicate data - see data dictionary 
CT_2020_3 <- subset(CT_2020_2, select = -c(2, 27, 31, 35, 39, 61, 66, 74, 92))

#Delete spaces 
CT_2020_4 <- 
  CT_2020_3 %>% 
  mutate(CensusTract = str_trim(CT_2020_3$CensusTract, side = "both"))

#Subsetting out rows
CT_2020_5 <- 
  subset(CT_2020_4, CT_2020_4$CensusTract != "Percent" & 
           CT_2020_4$CensusTract != "Percent Margin of Error" & 
           CT_2020_4$CensusTract != "Margin of Error")

#splitting CensusTract variable
CT_2020_6 <- CT_2020_5 
CT_2020_6[c('CT', 'County', 'State')] <- str_split_fixed(CT_2020_6$CensusTract, ',', 3)

#Exporting to Excel - It is just easier for me to quickly clean it up here
#In retrospect, I should have just turned the data from long to wide
#Setting working directory
setwd("C:/Users/slawinskimc/OneDrive - Florida Department of Health/Documents/GitHub/Census")
write_excel_csv(CT_2020_6, "2020ACS_DemographicHousingEstimates_CensusTracts_Working Copy2.csv")

#Getting rid of Census Tract rows
#CT_2020_5 <- CT_2020_5[ grep("Census", CT_2020_5$CensusTract, invert = TRUE) , ]

#Pulled out Census Tract and cleaned it up
#CT_2020_5.1 <- 
#  subset(CT_2020_4, CT_2020_4$CensusTract != "Percent" & 
#           CT_2020_4$CensusTract != "Percent Margin of Error" & 
#           CT_2020_4$CensusTract != "Margin of Error" &
#           CT_2020_4$CensusTract != "Estimate")

#CT_2020_5.2 <- 
#  CT_2020_5.1[1]

#CT_2020_5.2$CensusTract <- 
#  gsub("[a-zA-Z,]", "", CT_2020_5.2$CensusTract)  

#Merge with CT_2020_5 
#CT_2020_Merge <- cbind(CT_2020_5.2, CT_2020_5)

#Don't actually need the Census Tract = Estimate column
#CT_2020_final <- subset(CT_2020_Merge, select = -c(2))

#Setting working directory
setwd("C:/Users/slawinskimc/OneDrive - Florida Department of Health/Documents/GitHub/Census")

#Write to CSV file 
write_excel_csv(CT_2020_final, "2020ACS_DemographicHousingEstimates_CensusTracts_Clean.csv")

                               