
clear all
clear matrix
set mem 2g
set matsize 7000
set maxvar 7000
set more off
capture cd C:\Users\Hunt\Documents\IDR\Analysis


/* GET INFLATION EXPECTATIONS */
use Data/OilFutures/Treasuries/TreasuriesData.dta, clear
* Data start in 2003 only. Observed inflation was ~2% for 1998-2002.
	* 2.38
sum EInf5 if Year==2004
	* 2.29
sum EInf5 if Year==2007



foreach year in 2001 2004 2007 {
use "Data/SCF/scf`year'.dta", clear
gen Year = `year'

gen IDRep = y1
gen ID = yy1
gen Weight = x42001


gen BoughtThisYear1 = (x7543==2&x7540==`year')|(x7543==1&(x2205==`year'|x2205==`year'+1))
gen BoughtThisYear2 = (x7542==2&x7539==`year')|(x7542==1&(x2305==`year'|x2305==`year'+1))
gen BoughtThisYear3 = (x7541==2&x7538==`year')|(x7541==1&(x2405==`year'|x2405==`year'+1))
gen BoughtThisYear4 = (x7153==2&x7154==`year')|(x7153==1&(x7152==`year'|x7152==`year'+1))

gen Age1 = `year'-x2205
gen Age2 = `year'-x2305
gen Age3 = `year'-x2405
gen Age4 = `year'-x7152

gen New1 = (x7543==1)
gen New2 = (x7542==1)
gen New3 = (x7541==1)
gen New4 = (x7153==1)

* Type
gen Type1 = x2203
gen Type2 = x2303
gen Type3 = x2403
gen Type4 = x7150

* Whether financed
gen Financed1 = (x2206==1)
gen Financed2 = (x2306==1)
gen Financed3 = (x2406==1)
gen Financed4 = (x7155==1)

* Interest rate
foreach q in 2219 2319 2419 7170 {
replace x`q' = . if x`q'==0
replace x`q' = 0 if x`q'==-1
}

gen r1 = x2219
gen r2 = x2319
gen r3 = x2419
gen r4 = x7170



/* Count leased vehicles also */
* Mark leased as vehicles 5 and 6
* Assume that all leases are for new vehicles.
gen BoughtThisYear5 = 1 if x2101==1 &( x2104==`year'|x2104==`year'+1)
gen BoughtThisYear6 = 1 if x2101==1 &( x2111==`year'|x2111==`year'+1)

gen New5=1 if BoughtThisYear5==1
gen New6=1 if BoughtThisYear6==1


/* Collapse and reshape */
keep Weight New? Age? Type? BoughtThisYear? r? Financed? ID Year
collapse (mean) Year Weight New? Financed? BoughtThisYear? Age? Type? r?, by(ID)

reshape long  BoughtThisYear Financed New r Age Type, i(ID) j(VehicleNumber)

keep if BoughtThisYear==1
gen Leased=cond(VehicleNumber>=5,1,0)
replace Financed = 0 if Leased == 1
gen UsedxAge = (New==0)*Age

save Data/SCF/SCF`year'Prepped.dta,replace

}


use Data/SCF/SCF2001Prepped.dta,clear
append using Data/SCF/SCF2004Prepped.dta
append using Data/SCF/SCF2007Prepped.dta

** Adjust r for inflation expectations
	* Approximation:
	*replace r = r-200 if Year==2001
	*replace r = r-238 if Year==2004
	*replace r = r-229 if Year==2007

replace r = (1+r/10000)/(1.02)-1 if Year==2001
replace r = (1+r/10000)/(1.0238)-1 if Year==2004
replace r = (1+r/10000)/(1.0229)-1 if Year==2007
replace r = r*10000

xi i.Year*i.New, pre(_Y)

save Data/SCF/SCF.dta,replace

/* Analysis */
reg Financed [aw=Weight] if Leased==0
reg Financed New [aw=Weight] if Leased==0
reg Financed _Y* [aw=Weight] if Leased==0

reg r [aw=Weight]
reg r New [aw=Weight] 
reg r _Y* [aw=Weight]

* Results do not vary by age
reg r Age New [aw=Weight]

* Test whether results vary by type
replace Type = round(Type)
xi i.Type, pre(_T) noomit
reg r _T* New [aw=Weight], robust nocons
reg r _TType_4 New [aw=Weight], robust 
	* SUVs are statistically lower than the average vehicle by 0.64 percentage points, i.e. less than one percentage point. So not a major issue.


** Summarize results for table
* Percent of vehicles
sum Leased [fw=round(Weight)] if Leased==1 & New==1
sum Financed [fw=round(Weight)] if Financed==1 & New==1
sum Financed [fw=round(Weight)] if Financed==0&Leased==0 & New==1

sum Leased [fw=round(Weight)] if Leased==1 & New==0
sum Financed [fw=round(Weight)] if Financed==1 & New==0
sum Financed [fw=round(Weight)] if Financed==0&Leased==0 & New==0

* r
sum r [aw=Weight] if New==1
sum r [aw=Weight] if New==0


/*
** Get average r across population of vehicles
gen Totalr = r
replace Totalr = 6 if Leased==1
replace Totalr = 5.75 if Financed==0

reg Totalr [aw=Weight] 
*/



*******************************
*******************************
/* JDPA DATA */
/* Used */
foreach data in power powerused {
insheet using Data/JDPower/jd`data'.txt, names clear
gen Year = substr(close_month_yyyy_mm,1,4)
gen Month = substr(close_month_yyyy_mm,6,2)
destring Year Month, replace force
keep if Year<2008|(Year==2008&Month<=3)

destring finance_apr lease_apr, replace force
gen nomr = cond(finance_apr!=.,finance_apr,lease_apr)

sort Year Month
merge Year Month using Data/OilFutures/Treasuries/TreasuriesData.dta, nokeep keep(EInf5)
drop _merge
replace EInf5 = 2 if EInf5==.
	* Approximation:
	*gen r = nomr - EInf5
gen r = ((1+nomr/100)/(1+EInf5/100)-1)*100
gen N = 1

* Note that this does vary some by year
* collapse (sum) N (mean) r [fweight=transaction_count], by(Year transaction_type)
collapse (sum) N (mean) r [fweight=transaction_count], by(transaction_type)
save Data/JDPower/JD`data'_r.dta,replace
}


******************************
******************************
/* CHECKING INTEREST RATE FROM G.19 FEDERAL RESERVE SURVEY */
/* Get nominal interest rates from G.19 */
* http://www.federalreserve.gov/releases/g19/hist/cc_hist_tc.txt.
infix str month 1-3 Yr 5-6 Bankr 12-16 Financer 71-75 using Data\SCF\cc_hist_tc.txt, clear

gen Year = 1900+Yr if Yr>20
replace Year = 2000+Yr if Yr<20

gen Month = .
replace Month = 1 if month=="Jan"
replace Month = 2 if month=="Feb"
replace Month = 3 if month=="Mar"
replace Month = 4 if month=="Apr"
replace Month = 5 if month=="May"
replace Month = 6 if month=="Jun"
replace Month = 7 if month=="Jul"
replace Month = 8 if month=="Aug"
replace Month = 9 if month=="Sep"
replace Month = 10 if month=="Oct"
replace Month = 11 if month=="Nov"
replace Month = 12 if month=="Dec"

keep if (Year<2008|(Year==2008&Month<=3))&Year>=1999

keep Year Month Bankr Financer
order Year Month Bankr Financer
sort Year Month
save Data/SCF/G19.dta, replace

merge Year Month using Data/OilFutures/Treasuries/TreasuriesData.dta, keep(EInf5)
drop _merge
	* As with oil futures:
	* Use 2% expected inflation for years before 2003. This is roughly consistent with actual observed inflation over the period 1998-2002.
replace EInf5 = 2 if EInf5 == . & Year <=2003

foreach r in Bankr Financer {
	replace `r' = ((1+`r'/100)/(1+EInf5/100) -1)*100
}


sum *r 

