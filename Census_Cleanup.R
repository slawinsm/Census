library(tidyverse)
library(readxl)
library(httr)
library(rlang)
library(dplyr)

#Resource: https://ivelasq.rbind.io/blog/tidying-census-data/
## OR go find R script in computer 

#Understanding which path directory R is looking at
getwd()

#Telling R where to look
setwd("~/Data/Making An Impact/Excel")

#Calling in data and viewing it
census_sheet1 <- read_excel("~/Data/Making An Impact/Excel/Education.xlsx", sheet = "Data")
# view(census_sheet1)

#Cleaning up rows
census_sheet2 <-
  read_excel("Education.xlsx", sheet = "Data", skip = 2)
#view(census_sheet2)

#Deleting columns with empty values
census_sheet3<- subset(census_sheet2, select = -c(2, 30, 58, 63))
#view(census_sheet3)

#Cleaning up columns. Manually create a vector of the column names and replace the old ones 
#See data dictionary for more information on data variables
updated_names <-
  c("Label",
    "Total_18_24", 
    "18_24.3", "18_24.4", "18_24.7", "18_24.9", 
    "Total_25_Older",
    "25_Older.1", "25_Older.2", "25_Older.4", "25_Older.6", "25_Older.8", "25_Older.9", "25_Older.11", "25_Older.5", "25_Older.10",
    "Total_25_34",
    "25_34.5", "25_34.10", 
    "Total_35_44",
    "35_44.5", "35_44.10",
    "Total_45_64",
    "45_64.5", "45_64.10",
    "Total_65_Older",
    "65_Older.5", "65_Older.10",
    "Total_White",
    "White.5", "White.10",
    "Total_WhiteNHL",
    "WhiteNHL.5", "WhiteNHL.10",
    "Total_Black",
    "Black.5", "Black.10",
    "Total_AmericanIndian",
    "AmericanIndian.5", "AmericanIndian.10",
    "Total_Asian",
    "Asian.5", "Asian.10",
    "Total_NativeHawaiian",
    "NativeHawaiianOther.5", "NativeHawaiianOther.10",
    "Total_OtherRace",
    "OtherRace.5", "OtherRace.10",
    "Total_TwoRace",
    "TwoRace.5", "TwoRace.10",
    "Total_HispanicLatino",
    "HispanicLatino.5", "HispanicLatino.10",
    "Poverty.3", "Poverty.4", "Poverty.7", "Poverty.10",
    "Total_Earnings",
    "Median.3", "Median.4", "Median.7", "Median.9", "Median.11")

  census_sheet4 <-
    census_sheet3 %>% 
    set_names(updated_names)
  view(census_sheet4) 
  #I cannot believe this worked!!

#Deleting column 1
census_sheet5<- subset(census_sheet4, select = -c(1))
#view(census_sheet3)

#Here, we are saying to get rid of empty rows. 
  #1 Method that the resource  specifies
  #census_sheet5 <-
  #  census_sheet4 %>% 
  #  slice(-1:-2) #specify all lines of code you want to remove
  
  #2 Method that I found on StackOverflow that cut down my lines of code
  library(janitor)
  census_sheet6 <- remove_empty(census_sheet5, which = c("rows")) #This still has M/F in the row (estimates an percents), and percents
  #view(census_sheet5)

#Create a new var for row labels
  #Example
  # x<-rep(c(1,2,3,4),times=5)
  # df1<-data.frame(x)
  # df1

  census_sheet6$Label_new <- 
    rep(c("Zipcode_Count_Estimate", 
    "Zipcode_Percent_Estimate",
    "Zipcode_MaleCount_Estimate", 
    "Zipcode_MalePercent_Estimate",
    "Zipcode_FemaleCount_Estimate", 
    "Zipcode_FemalePercent_Estimate"),times = 50)
  
  census_sheet6$ZIP <- 
    rep(c("33852","34266","34268","34269","33598",
          "33834","33865","34201","34202","34203",
          "34205","34207","34208","34209","34210",
          "34211","34212","34215","34216","34217",
          "34219","34221","34222","34228","34240",
          "34243","34251","34223","34224","34229",
          "34231","34232","34233","34234","34235",
          "34236","34237","34238","34239","34241",
          "34242","34275","34285","34286","34287",
          "34288","34289","34291","34292","34293"), 
          each = 6)
  
  #Make row labels unique
  census_sheet6$Label_new2 <- make.unique(census_sheet6$Label_new)

#Creating the male/female variables now because I literally cannot visualize how to do this next part haha
  census_sheet6$Male <- 1
  census_sheet6$Female <- 1
  
#Moving vars to beginning of data frame
  census_sheet6 <- census_sheet6 %>% 
    relocate(66, .before=1) #Just specify which columns you want to relocate from and where to
  view(census_sheet6)

#Deleting percent rows
  census_sheet7 <- census_sheet6[ !(census_sheet6$Label_new %in% c("Zipcode_Percent_Estimate", "Zipcode_MalePercent_Estimate", "Zipcode_FemalePercent_Estimate")), ]

#NEXT STEPS HERE:  
##What if you subset the male/female observations out like how brian does with the HNHU data, clean it, then bring them back in?  
  #Subsetting on MASKSSN = Nzc3Nzc3Nzc3 
  # hos_ssn_Nzc3 <- subset(hos_ed, MASKSSN=="Nzc3Nzc3Nzc3") #34 observations
  # hos_ssn <- subset(hos_ed, MASKSSN!="Nzc3Nzc3Nzc3") #854 observations
  
##Or he summed rows by doing this 
  # hos_ssn_Nzc3_3$oth_tot <- rowSums(hos_ssn_Nzc3_3[,c("oth1", "oth2", "oth3", "oth4", "oth5", "oth6", "oth7",
  #                                                     "oth8", "oth9", "oth10", "oth11", "oth12", "oth13", "oth14", "oth15",
  #                                                     "oth16", "oth17", "oth18", "oth19", "oth20", "oth21", "oth22", "oth23",
  #                                                     "oth24", "oth25", "oth26", "oth27", "oth28", "oth29", "oth30")])
  
  #Need a Total Population by ALL age groups so I have specific data for Male/Female to pull from
  # Age_Vector <- c(Total_18_24, Total_25_Older, Total_35_45, Total_65_Older)
  # Race_Vector
  
  #Example 1 (not working):census_sheet6$Male <- ifelse(Label_new = "Zipcode_MaleCount_Estimate")
  #Example 2: https://stackoverflow.com/questions/26932315/how-to-move-information-in-some-rows-in-r-to-columns
   # library(reshape2)
    # indx <- df$v1=='data'
    # res <- cbind(df[indx,],dcast(df[!indx,],v1~v2, value.var='v3'))[,-4]
    # row.names(res) <- NULL
    # colnames(res)[4:6] <- paste('info', colnames(res)[4:6], sep="_")
    # res
              
   # #install.packages("reshape2")
   #  library(reshape2)
   #  indx <- census_sheet6$Label_new=='Zipcode_MaleCount_Estimate'
   #  res <- cbind(census_sheet6[indx,],dcast(census_sheet6[!indx,],v1~v2, value.var='v3'))[,-4]
   #  row.names(res) <- NULL
   #  colnames(res)[4:6] <- paste('info', colnames(res)[4:6], sep="_")
   #  res
    
#Delete rows of data only after moving total/male/female counts
  #census_sheet6_deletes <- census_sheet6[-c("Zipcode_Percent_Estimate", "Zipcode_MalePercent_Estimate"), "Zipcode_FemalePercent_Estimate"] 

  #Add Sex and Zip column vars.
  #census_sheet2$ZIP <- NA
  #census_sheet2$Male <- NA
  #census_sheet2$Female <-NA
  #View(census_sheet2)  #Should now have 3 new columns at the end.

##To Do:
#I need to figure out how to turn Male/Female Total Population by zip into a column var




