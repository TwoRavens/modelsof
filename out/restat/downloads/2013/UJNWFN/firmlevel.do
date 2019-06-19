clear matrix
clear
set memory 200m
set matsize 800
set more off

use firmleveldata, clear



****Variable generation

ge logsize=log(asset)
ge logsales=log(sales)
ge logemploy=log(employ)
ge roa=profit/asset
ge ros=profit/sales
***Delete one big outlier in ROS which is greater than 100
replace ros=. if ros>100
ge profitpc=profit/employ
***Deleting two big outliers in profitpc which exceed 11.4 million
replace profitpc=. if profitpc>1149
ge familymr=ffirm2/management
***ffirm2 is the number of family members (including relatives) working in the management
***"management" is the size of the management team
replace familymr=. if familymr>1
ge mfsize=fsize/management
***fsize is the family size of the firm head

capture log using output_firmlevel, replace

***********Table 1: Descriptive statistics

****Firm and firm head information

su firmage asset sales employ roa ros profitpc csex cedu cage cshare1 ffirm2 mfsize


**********Table 9: OLS Results

xi: reg gemploy1 familymr logemploy firmage i.area i.industry, rob
xi: reg logsales familymr logsize logemploy firmage i.area i.industry, rob
xi: reg roa familymr logsize firmage i.area i.industry, rob
xi: reg ros familymr logsize firmage i.area i.industry, rob
xi: reg profitpc familymr logsize firmage i.area i.industry, rob

***IV results for footnote 26

xi: ivreg gemploy1 (familymr=mfsize) logemploy firmage i.area i.industry, rob 
xi: ivreg logsales (familymr=mfsize) logsize logemploy firmage i.area i.industry, rob 
xi: ivreg roa (familymr=mfsize) logsize firmage i.area i.industry, rob 
xi: ivreg ros (familymr=mfsize) logsize firmage i.area i.industry,rob 
xi: ivreg profitpc (familymr=mfsize) logsize firmage i.area i.industry, rob 



log close
translate output_firmlevel.smcl output_firmlevel.log, replace








