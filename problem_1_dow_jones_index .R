rm(list=ls())
#Loading the Libraries


library('ineq')
library("dplyr")
library(corrplot)
library(readr)
library(dplyr)
library(lubridate)
library(sqldf)


#Input Data
setwd("C:/Users/ahmad/Desktop/Data Science role GBT")
Stock_Data <- read.csv("problem_1_dow_jones_index .csv",header=TRUE)
str(Stock_Data)
Stock_Data$date<-as.factor(Stock_Data$date)
Stock_Data$date <- as.Date(Stock_Data$date,"%d-%m-%Y")
Stock_Data$week<-week(Stock_Data$date)

#Converting Char to int for open column
Stock_Data$open = as.numeric(gsub("\\$", "", Stock_Data$open))

str(Stock_Data)


#Calculating the Percentage increase or decrease
Stock_Gwroth<-sqldf("select stock,week,date,Open_price,Case WHEN week='01' then 0 else (Open_price -lag(Open_price) over (ORDER BY stock, week))*100/lag(Open_price) over (ORDER BY stock, week)     end as Percentage_increase from (SELECT  stock, week,date,open as Open_price FROM Stock_Data  ) ")
str(Stock_Gwroth)


#Stock Average Gain/Loss in Decending Order
Stock_Summary<-sqldf("select stock,AVG(Percentage_increase) from Stock_Gwroth group by stock order by AVG(Percentage_increase) DESC ")
Stock_Summary

