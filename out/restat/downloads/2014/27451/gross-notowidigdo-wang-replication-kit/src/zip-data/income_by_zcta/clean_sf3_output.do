#delim cr
set more off
*version 10
pause on
graph set ps logo off

*capture log close
*set linesize 80
*set logtype text
*log using XXX.log , replace

/* --------------------------------------

AUTHOR: Tal Gross

PURPOSE:  To clean the sf3 output.

DATE CREATED: Wed Mar 17 13:47:02 EDT 2010

NOTES:

CHANGELOG:

--------------------------------------- */

clear
estimates clear
set mem 50m

************************************************************
**  Bring in Data                                         **
************************************************************

insheet using census_sf3_output.csv , names clear comma
d, f

************************************************************
**  Label with Census Names                               **
************************************************************

label var zcta5 "Geographic Identifiers 2000  G59 ZCTA5 ZIP Code Tabulation Area (5 digit)"
label var h080001 "H Tables 2000 H080 Mortgage Status H080001  Total"
label var h080002 "H Tables 2000 H080 Mortgage Status H080002        Housing units with a mortgage, contract to purchase, or similar debt"
label var h080003 "H Tables 2000 H080 Mortgage Status H080003          With either a second mortgage or home equity loan, but not both"
label var h080004 "H Tables 2000 H080 Mortgage Status H080004            Second mortgage only"
label var h080005 "H Tables 2000 H080 Mortgage Status H080005            Home equity loan only"
label var h080006 "H Tables 2000 H080 Mortgage Status H080006          Both second mortgage and home equity loan"
label var h080007 "H Tables 2000 H080 Mortgage Status H080007          No second mortgage and no home equity loan"
label var h080008 "H Tables 2000 H080 Mortgage Status H080008        Housing units without a mortgage"
label var h076001 "H Tables 2000 H076 Median Value (Dollars) for Specified Owner-Occupied Housing Units H076001  Median value"
label var hct012001 "HCT Tables 2000 HCT012 Median Household Income in 1999 (Dollars) by Tenure HCT012001        Total"
label var hct012002 "HCT Tables 2000 HCT012 Median Household Income in 1999 (Dollars) by Tenure HCT012002        Owner occupied"
label var hct012003 "HCT Tables 2000 HCT012 Median Household Income in 1999 (Dollars) by Tenure HCT012003        Renter occupied"
label var p053001 "P Tables 2000 P053 Median Household Income in 1999 (Dollars) P053001  Median household income in 1999"
label var p052001 "P Tables 2000 P052 Household Income in 1999 P052001  Total"
label var p052002 "P Tables 2000 P052 Household Income in 1999 P052002        Less than $10,000"
label var p052003 "P Tables 2000 P052 Household Income in 1999 P052003        $10,000 to $14,999"
label var p052004 "P Tables 2000 P052 Household Income in 1999 P052004        $15,000 to $19,999"
label var p052005 "P Tables 2000 P052 Household Income in 1999 P052005        $20,000 to $24,999"
label var p052006 "P Tables 2000 P052 Household Income in 1999 P052006        $25,000 to $29,999"
label var p052007 "P Tables 2000 P052 Household Income in 1999 P052007        $30,000 to $34,999"
label var p052008 "P Tables 2000 P052 Household Income in 1999 P052008        $35,000 to $39,999"
label var p052009 "P Tables 2000 P052 Household Income in 1999 P052009        $40,000 to $44,999"
label var p052010 "P Tables 2000 P052 Household Income in 1999 P052010        $45,000 to $49,999"
label var p052011 "P Tables 2000 P052 Household Income in 1999 P052011        $50,000 to $59,999"
label var p052012 "P Tables 2000 P052 Household Income in 1999 P052012        $60,000 to $74,999"
label var p052013 "P Tables 2000 P052 Household Income in 1999 P052013        $75,000 to $99,999"
label var p052014 "P Tables 2000 P052 Household Income in 1999 P052014        $100,000 to $124,999"
label var p052015 "P Tables 2000 P052 Household Income in 1999 P052015        $125,000 to $149,999"
label var p052016 "P Tables 2000 P052 Household Income in 1999 P052016        $150,000 to $199,999"
label var p052017 "P Tables 2000 P052 Household Income in 1999 P052017        $200,000 or more"
label var p059001 "P Tables 2000 P059 Wage or Salary Income in 1999 for Households P059001  Total"
label var p059002 "P Tables 2000 P059 Wage or Salary Income in 1999 for Households P059002        With wage or salary income"
label var p059003 "P Tables 2000 P059 Wage or Salary Income in 1999 for Households P059003        No wage or salary income"
label var p060001 "P Tables 2000 P060 Self-Employment Income in 1999 for Households P060001  Total"
label var p060002 "P Tables 2000 P060 Self-Employment Income in 1999 for Households P060002        With self-employment income"
label var p060003 "P Tables 2000 P060 Self-Employment Income in 1999 for Households P060003        No self-employment income"
label var p073001 "P Tables 2000 P073 Aggregate Public Assistance Income in 1999 (Dollars) for Households P073001  Aggregate public assistance income in 1999"
label var p076001 "P Tables 2000 P076 Family Income in 1999 P076001  Total"
label var p076002 "P Tables 2000 P076 Family Income in 1999 P076002        Less than $10,000"
label var p076003 "P Tables 2000 P076 Family Income in 1999 P076003        $10,000 to $14,999"
label var p076004 "P Tables 2000 P076 Family Income in 1999 P076004        $15,000 to $19,999"
label var p076005 "P Tables 2000 P076 Family Income in 1999 P076005        $20,000 to $24,999"
label var p076006 "P Tables 2000 P076 Family Income in 1999 P076006        $25,000 to $29,999"
label var p076007 "P Tables 2000 P076 Family Income in 1999 P076007        $30,000 to $34,999"
label var p076008 "P Tables 2000 P076 Family Income in 1999 P076008        $35,000 to $39,999"
label var p076009 "P Tables 2000 P076 Family Income in 1999 P076009        $40,000 to $44,999"
label var p076010 "P Tables 2000 P076 Family Income in 1999 P076010        $45,000 to $49,999"
label var p076011 "P Tables 2000 P076 Family Income in 1999 P076011        $50,000 to $59,999"
label var p076012 "P Tables 2000 P076 Family Income in 1999 P076012        $60,000 to $74,999"
label var p076013 "P Tables 2000 P076 Family Income in 1999 P076013        $75,000 to $99,999"
label var p076014 "P Tables 2000 P076 Family Income in 1999 P076014        $100,000 to $124,999"
label var p076015 "P Tables 2000 P076 Family Income in 1999 P076015        $125,000 to $149,999"
label var p076016 "P Tables 2000 P076 Family Income in 1999 P076016        $150,000 to $199,999"
label var p076017 "P Tables 2000 P076 Family Income in 1999 P076017        $200,000 or more"
label var p077001 "P Tables 2000 P077 Median Family Income in 1999 (Dollars) P077001  Median family income in 1999"
label var p088001 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088001  Total"
label var p088002 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088002        Under .50"
label var p088003 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088003        50 to .74"
label var p088004 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088004        75 to .99"
label var p088005 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088005        1.00 to 1.24"
label var p088006 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088006        1.25 to 1.49"
label var p088007 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088007        1.50 to 1.74"
label var p088008 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088008        1.75 to 1.84"
label var p088009 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088009        1.85 to 1.99"
label var p088010 "P Tables 2000 P088 Ratio of Income in 1999 to Poverty Level P088010        2.00 and over"

************************************************************
**  Clean our Key Variables                               **
************************************************************

sum hct012001 hct012002 hct012003
rename hct012001 median_fam_income_all
rename hct012002 median_fam_income_owners
rename hct012003 median_fam_income_renters

sum h080001 h080002 h080003 h080004 h080005 h080006 h080007 h080008 
gen share_with_mortgage = 1 - (h080008 / h080001 )
sum share_with_mortgage

gen share_faminc_l10k = p052002 / p052001 
gen share_faminc_10k_15k = p052003 / p052001 
gen share_faminc_15k_20k = p052004 / p052001 
gen share_faminc_20k_25k = p052005 / p052001 
gen share_faminc_25k_30k = p052006 / p052001 
gen share_faminc_30k_35k = p052007 / p052001 
gen share_faminc_35k_40k = p052008 / p052001 
gen share_faminc_40k_45k = p052009 / p052001 
gen share_faminc_45k_50k = p052010 / p052001 
gen share_faminc_50k_60k = p052011 / p052001 
gen share_faminc_60k_75k = p052012 / p052001 
gen share_faminc_75k_100k = p052013 / p052001 
gen share_faminc_100k_125k = p052014 / p052001 
gen share_faminc_125k_150k = p052015 / p052001 
gen share_faminc_150k_200k = p052016 / p052001 
gen share_faminc_g200k = p052017 / p052001 
sum share_faminc*

sum p088001 p088002 p088003 p088004 p088005 p088006 p088007 p088008 p088009 p088010
gen share_inctopovline_u5 =  p088002 / p088001 
gen share_inctopovline_5to75 =  p088003 / p088001 
gen share_inctopovline_75to100 =  p088004 / p088001 
gen share_inctopovline_100to125 =  p088005 / p088001 
gen share_inctopovline_125to150 =  p088006 / p088001 
gen share_inctopovline_150to175 =  p088007 / p088001 
gen share_inctopovline_175to185 =  p088008 / p088001 
gen share_inctopovline_185to200 =  p088009 / p088001 
gen share_inctopovline_o200 =  p088010 / p088001 
sum share_inctopovline_*

************************************************************
**  Save & Close                                          **
************************************************************

compress
label data "Income by Zip Code from the 2000 Census sf3 files"
save zipcode-income-2000-sf3.dta , replace

*log close
exit


