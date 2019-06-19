*--------------------------------------------------------------------AA_MLS_DATA.DO---------------------------------------------------------------------------------
*This script compiles and formats MLS data for the city of Ann Arbor and calculates basic statistics such as the number of days elapsed between contract and closing dates.
*Sebastien Bradley
*9/5/13

clear all
capture cd "C:/Users/sjb355/Documents/Research/PropertyTaxes/Ann_Arbor/MLS"
capture log close
log using AA_MLS_data_results.txt, text replace
set more off


************************************************************RESIDENTIAL HOMES:
*IMPORT DATA AND MERGE FILES
foreach daterange in 010105-050306 050406-082106 082206-032107 032207-072907 073007-122007 122107-061508 061608-101808 101908-052809 052909-092009 092109-042010 042110-081510 081610-100610 {
	insheet using AA_res_sales_`daterange'.txt, names clear
	capture replace zipcode = substr(zipcode,1,5)
	capture destring zipcode, replace
	capture destring daysonmkt, replace
	capture destring totsqft, replace
	save tmp_AA_res_sales_`daterange'.dta, replace
}
use tmp_AA_res_sales_010105-050306.dta, clear
foreach daterange in 050406-082106 082206-032107 032207-072907 073007-122007 122107-061508 061608-101808 101908-052809 052909-092009 092109-042010 042110-081510 081610-100610 {
	append using tmp_AA_res_sales_`daterange'.dta
	erase tmp_AA_res_sales_`daterange'.dta
}
save AA_res_sales_MLS_data.dta, replace
erase tmp_AA_res_sales_010105-050306.dta


*REFORMAT DATES AND CALCULATE TIME ELAPSED BETWEEN CONTRACT SIGNATURES AND CLOSING
*use AA_res_sales_MLS_data.dta, clear
replace contsigndate = "05/19/2010" if ml==3002126
replace contsigndate = "06/07/2006" if ml==2607087
foreach d in contsigndate solddate listdate chngpricedate {
	gen tmp_`d' = date(`d',"MDY")
	format tmp_`d' %td
	drop `d'
	gen bcal_`d' = bofd("SaleCal",tmp_`d')
	format bcal_`d' %tbSaleCal
}
renpfix tmp_
gen daystoclosing = solddate-contsigndate
replace daystoclosing = . if daystoclosing<0
gen salemonth = month(solddate)
gen saleyear = year(solddate)
gen contmonth = month(contsigndate)
gen contyear = year(contsigndate)
tab salemonth saleyear
tab contmonth salemonth

rename stateequvalue sev
rename taxval tv
rename homestead pre
drop yrsev taxablevalyr

rename concession I_concession
rename v11 concession
destring concession, replace
replace concession = 0 if I_concession=="N"

renpfix v2 appliances
forvalues n = 2/4 {
	rename v3`n' basement`n'
	rename v4`n' flooring`n'
}
rename v39 fireplace2
rename v40 fireplace3
local i = 1
forvalues n = 6/9 {
	local i = `i'+1
	rename v4`n' garage`i'
}
rename v52 pool2
local i = 1
forvalues n = 7/9 {
	local i = `i'+1
	rename v5`n' style`i'
}
rename v68 heat2
rename v69 heat3

drop totsqft

save AA_res_sales_MLS_data.dta, replace



************************************************************CONDOS/CO-OPS:
*IMPORT DATA AND MERGE FILES:
foreach daterange in 010105-082206 082306-080807 080907-062608 062708-053009 053109-020110 020210-081610 081710-100610 {
	insheet using AA_condo_sales_`daterange'.txt, names clear	
	capture replace zipcode = substr(zipcode,1,5)
	capture destring zipcode, replace
	capture destring daysonmkt, replace
	capture destring totsqft, replace
	save tmp_AA_condo_sales_`daterange'.dta, replace
}
use tmp_AA_condo_sales_010105-082206.dta, clear
foreach daterange in 082306-080807 080907-062608 062708-053009 053109-020110 020210-081610 081710-100610 {
	append using tmp_AA_condo_sales_`daterange'.dta
	erase tmp_AA_condo_sales_`daterange'.dta
}
save AA_condo_sales_MLS_data.dta, replace
erase tmp_AA_condo_sales_010105-082206.dta


*REFORMAT DATES AND CALCULATE TIME ELAPSED BETWEEN CONTRACT SIGNATURES AND CLOSING
*use AA_condo_sales_MLS_data.dta, clear
replace contsigndate = "10/27/2005" if ml==2512518
replace contsigndate = "05/07/2008" if ml==2715582
replace contsigndate = "10/31/2007" if ml==2711141
foreach d in contsigndate solddate listdate chngpricedate {
	gen tmp_`d' = date(`d',"MDY")
	format tmp_`d' %td
	drop `d'
	gen bcal_`d' = bofd("SaleCal",tmp_`d')
	format bcal_`d' %tbSaleCal
}
renpfix tmp_
gen daystoclosing = solddate-contsigndate
replace daystoclosing = . if daystoclosing<0
gen salemonth = month(solddate)
gen saleyear = year(solddate)
gen contmonth = month(contsigndate)
gen contyear = year(contsigndate)
tab salemonth saleyear
tab contmonth salemonth

rename stateequvalue sev
rename taxval tv
*rename homestead pre
gen pre = 100										/*Technically, condo file is missing PRE data so assume homestead status.*/
													/*This yields a lower bound for TV uncapping tax change (and not change around May 15.*/
drop yrsev taxablevalyr
gen I_coop = (tv==0 & sev==0) if tv~=. & sev~=.

rename concession I_concession
rename v26 concession
destring concession, replace
replace concession = 0 if I_concession=="N"

forvalues n = 0/7 {
	rename v1`n' appliances`=`n'+2'
}
forvalues n = 0/2 {
	rename v2`n' basement`=`n'+2'
}
rename v34 fireplace2
rename v35 fireplace3
forvalues n = 7/9 {
	rename v3`n' flooring`=`n'-5'
}
forvalues n = 1/4 {
	rename v4`n' garage`=`n'+1'
}
rename v46 heat2
rename v47 heat3
rename v54 pool2

rename totsqft sqft

gen I_condo = 1
save AA_condo_sales_MLS_data.dta, replace



*MERGE RESIDENTIAL HOME AND CONDO SALES DATA
use AA_res_sales_MLS_data.dta, clear
append using AA_condo_sales_MLS_data.dta
replace I_condo = 0 if I_condo==.
replace assofeeperyear = assofeepermo*12 if I_condo==1 & assofeeperyear==.
drop assofeepermo


*RE-FORMAT PRICE AND TAX DATA
*Convert prices to 1000s of dollars
foreach p in listprice origlistprice soldprice previouslistprice concession assofeeperyear sev tv {
	if substr("`p'",length("`p'")-4,5)=="price" {
		replace `p' = subinstr(`p',",","",.)
		destring `p', replace
	}
	replace `p' = `p'/1000
}


*CALCULATE TAX CHANGE DUE TO TV UNCAPPING AND FAILURE TO OBTAIN PRE
*First define annual millage rates (2005-2010 homestead and non-):
local mills_pre = "46.7755 46.1895 46.0373 45.6097 45.1876 45.4283"
local mills_nonpre = "59.2397 59.1823 59.2835 59.2935 58.7369 58.8939"

gen mills_pre = .
gen mills_nonpre = .
foreach h in pre nonpre {
  local y = "2005"				/*First year of tax rate data*/
  foreach t in `mills_`h'' {
		replace mills_`h' = `t' if saleyear==`y'
		local y = `y'+1
  }
}
gen mills = mills_pre*pre/100 + mills_nonpre*(100-pre)/100

gen d_tax_uncap = (sev-tv)*mills_pre/1000		/*Absent information on new homebuyer PRE status, assume primary residence*/
replace d_tax_uncap = . if d_tax_uncap<0
replace d_tax_uncap = 0 if tv==0				/*e.g. co-ops for which TV is not recorded*/
gen d_tax_pre = 0
replace d_tax_pre = tv*(mills_nonpre-mills_pre)/1000*(365-doy(td(15may2005)))/365 if pre==0	/*Measures tax cost of PRE exemption ineligibility - only relevant if homebuyer did not qualify*/


save AA_sales_MLS_data.dta, replace



*FLAG/LABEL LISTING BROKERS AND COMPUTE ANNUAL MARKET SHARE MEASURES TO CAPTURE "EXPERIENCE"
insheet using Numeric_Firm_Roster_Oct2013.txt, clear tab names
keep broker brokername
sort broker
merge 1:m broker using AA_sales_MLS_data.dta, keep(match using) nogen
*tab brokername saleyear
replace brokername = "Keller Williams" if regexm(lower(brokername),"keller williams")
replace brokername = "Edward Surovell" if regexm(lower(brokername),"howard hanna")				/*Ed Surovell Realtors was acquired by Howard Hanna in Oct. 2012*/
gen I_Reinhart = (regexm(lower(brokername),"reinhart")) if broker~=.

gen tmp = 1 if brokername~=""
sort saleyear brokername
by saleyear brokername: egen brokerlistings = total(tmp) if brokername~=""
by saleyear: egen ann_listings = total(tmp) if brokername~=""
gen brokershare = brokerlistings/ann_listings*100
sort brokername saleyear
by brokername: egen tot_brokerlistings = total(tmp) if brokername~=""
egen tot_listings = total(tmp) if brokername~=""
gen avg_brokershare = tot_brokerlistings/tot_listings*100
drop tmp* *listings

order ml-listprice I_condo I_coop *price *date days* sev tv pre d_tax* *broker* I_Reinhart, first
sort contsigndate solddate listdate soldprice
save AA_sales_MLS_data.dta, replace


log close


/**/
