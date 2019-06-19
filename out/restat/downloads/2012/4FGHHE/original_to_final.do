
use "2004.2006_orig_data.dta"

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// SUMMARY of "ORIGINAL DATA"
//_______________________________________________________

sum measure resident
bysort measuremen: gen num_houses = _n
count if num_houses ==1
bysort resident: gen num_tenant = _n
count if num_tenant ==1

drop num_h num_t

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// TRIMMING
//_______________________________________________________

sum num_of
drop if num_of_day < 15 | num_of_day >35
// proportion dropped
display 37316/7939069 

sum  tran_read_dif 
drop if tran_read_dif>5 | tran_read_dif<-1
// proportion dropped
display 470122/7901753
 
sum adc
drop if adc<1
// proportion dropped
display 163160/7431631 


//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// CREATING and LABELING VARIABLES
//_______________________________________________________

// YEAR DUMMIES
tab billing_yr, gen(year)

//COUNTIES and CLUSTER VARS
//egen county_num = group(county)
//egen county_mo_yr = group(county month_id)
//egen county_billcy = group(county billing)
//egen county_billcy_mo_yr = group(county billing month_id)

// "Southern" GROUP in East
gen SE = county =="Clark" | county =="Dearborn" | county =="Floyd " | county =="Harrison"
// "Northern" GROUP in West
gen NW = county =="Daviess" | county =="Knox" | county =="Martin" | county =="Pike"
// "Southern" GROUP in West
gen SW = county =="Gibson" | county =="Posey" | county =="Warrick"
// "Northern" GROUP in East
gen NE = SE==0 & SW ==0 & NW ==0

gen regions = SW + NW*2 + NE*3 + SE*4

//Define OVERALL DST and nonDST periods
//2006 DST starts on April 2
//2006 DST ends on October 29
gen DSTperiod = 1
recode DSTperiod 1=0 if billing_mo==1
recode DSTperiod 1=0 if billing_mo==2
recode DSTperiod 1=0 if billing_mo==3
recode DSTperiod 1=0 if billing_mo==4
recode DSTperiod 1=0 if billing_mo==5 & billing==1
recode DSTperiod 1=0 if billing_mo==11
recode DSTperiod 0=1 if billing_mo==11 & billing==1
recode DSTperiod 1=0 if billing_mo==12

gen nonDSTperiod = 0
recode nonDSTperiod 0=1 if billing_mo==1
recode nonDSTperiod 0=1 if billing_mo==2
recode nonDSTperiod 0=1 if billing_mo==3
recode nonDSTperiod 0=1 if billing_mo==4 & billing==1
recode nonDSTperiod 0=1 if billing_mo==12
recode nonDSTperiod 1=0 if billing_mo==12 & billing==1

order resident acct_id rate_code measuremen zip5_num county billing month_id billing_mo billing_yr bill_num_days year1 year2 year3 read_date read_year read_day read_month read_dow tran_date_st tran_date tran_year tran_day tran_month tran_dow tran_read_dif date usage_amou num_of_day adc ln_adc cdd hdd precip acdd ahdd aprecip sunrise_av sunset_av adl gmt

label var resident        "Resident Number (premise+00+tenant)"
label var acct_id    "Duke Account Number "
label var rate_code "Duke Residential Rate Codes, all prices are the same across codes"
label var measuremen     "Meter Number"
label var zip5_num           "Zip 5-digit, Numeric"
label var county      "County (first name only)"
label var billing        "Cycle of Billing within month, 1 to 21 from early to late in the month" 
label var month_id 	"Identify Year and Month of Bill (12 per year)"
label var billing_mo          "Month of Billing Date"
label var billing_yr        "Year of Billing Date" 
label var bill_num_days       "Days between sequential billing dates" 
label var year1 		"0/1, Electricy use occurred in 2004"
label var year2 		"0/1, Electricy use occurred in 2005"
label var year3 		"0/1, Electricy use occurred in 2006"
label var read_date         "Date of Scheduled Meter Read (sequntial number)"
label var read_year        "Year of Scheduled Meter Read" 
label var read_day       "Day of Scheduled Meter Read"
label var read_dow       "Day of week, Scheduled Meter Read, 0 = Sun, 1 = Mon, etc"
label var read_month          "Month of Scheduled Meter Read"
label var tran_date_st         "Date of Transaction (string format)"
label var tran_year        "Year of Transaction" 
label var tran_month          "Month of Transaction"
label var tran_day       "Day of Transaction"
label var tran_dow       "Day of week, Transaction"
label var tran_date         "Date of Transaction (sequntial number)"
label var tran_read_dif         "Difference btn tran_date and read_date"

//Transaction date is the date the data are entered into computer not necessarily the day meter 
//is read. We adjust the transaction date accordingly: one day earlier for trans dow of Tues-Sun, 
//three days earler for a trans dow of Mon. We use this date only for appending average weather 
//data
label var date         "Adjusted Date of Transaction,-1 for Tu-Su tran_day, -3 for M tran_day"
label var usage_amou       "Amount Used, KwHr, Duke data"
label var num_of_day       "Number of Days, Duke data"
label var adc          "Average daily consumption = amount used / number of days"  
label var ln_adc 		"Natural log of average daily consumption"         
label var cdd            "Sum cooling degree days (CDD) for adjusted transaction period, base 65 F"
label var hdd             "Sum heating degree days (HDD) for adjusted transaction period, base 65 F"                 
label var precip       "Sum precipitation (PRECIP) for adjusted transaction period, inches"                    
label var acdd            "Average CDD, cdd/num_of_day, for adjusted transaction period, base 65 F"
label var ahdd             "Average HDD, hdd/num_of_day, for adjusted transaction period, base 65 F"                 
label var aprecip       "Average PRECIP, precip/num_of_day, for adjusted transaction period, inches"
label var sunrise_av   "Average sunrise time for adjusted transaction period, 24-hour clock"
label var sunset_av   "Average sunset time for adjusted transaction period, 24-hour clock"             
label var adl            "Average Day Length, sunset_av -sunrise_av, hours"
label var gmt            "Time zone, hours from Greenwich Mean Time"
//label var billing_date       "Scheduled Billing Date (string format)" 
label var SE 	"Southern GROUP in East"
label var NW 	"Northern GROUP in West"
label var SW 	"Southern GROUP in West"
label var NE 	"Northern GROUP in East"
label var regions "GROUPS by regions: 1-SW 2-NW 3-NE 4-SE"
label define regions 1 SW 2 NW 3 NE 4 SE
label var DSTperiod	"0/1, month and billing cycle fall FULLY within DST practice period" 
label var nonDSTperiod	"0/1, month and billing cycle fall FULLY outside DST practice period"
label var county_num	"Unique number for each county, 1 to 25"
label var county_mo_yr		"Unique number for each county by month_id, 1 to 900"		
label var county_billcy		"Unique number for each county by billing_cy, 1 to 399"
label var county_billcy_mo_yr		"Unique number for each county by billing_cy by month_id, 1 to 13267"
label var NZ_TZdif	"0/1, NW==1 and month_id>200610, changed time zones"
label var overalltreat		"0/1, NE*year3, the new DST policy affects the NE is 2006"
label var bill_time 	"1 = billing_cycle of 1 - 7, 2 = billing_cycle of 8 - 14, 3 = billing_cycle of 15 - 21"

save "2004.2006_TRM_days15-35.dta"

