set more off
capture log close
capture clear all
*log using National_banks_crisis6.log, text replace
set memory 200m
set scheme s1color

/***!***!***!***!***!*** [National_banks_crisis.do ] ***!***!***!***!***!
*
* Project: National Banks  		
* Programmer:  Scott Fulford, edited by Felipe Schwartzman
*
* Date:    	 Jan 2018, edited from National_banks_crisis7_102113.do in Felipe's 
*             Dropbox folder accessed on 01/22/18
*
* Auditor:      
* Audit Date:   
*
* Purpose:      
* 1) * 1) Create figures showing 
	1. Scatter across states of gold production, gold imports, 
	   customs, and bank specie holdings
	2. Scatter in debt/assess from previous call date around 1896 election
	3. Scatter of change in deposits/assets at election and specie/assets before 1890
	4. Scatter of change in deposits/assets at election and (gold production +imports)

* 2) 
* 3)
* 		      
*
* Ouputs: 
*		
* Sources: 
National_bank_call_reports_states
all_bank_data.dta Created by National_banks_Compare_State_banks
NHGIS data for state controls created by National_banks_Load_NHGIS
*
***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***/


/***Define Global Directory ****/
//Change rootdir to where store files
	global ROOTDIR "F:/Dropbox/national banks peg/Replication_files"
	local PROGDIR  "$ROOTDIR"
	local INDIR  "$ROOTDIR/data"
	local OUTDIR  "$ROOTDIR/data"
/*******************************/



cd "`INDIR'"



/*LOAD INTEREST RATES FOR COMMERCIAL PAPER AND GOLD
National Monetary commission and Calomiris.
See Capital_flows.xlsx for full defintion
*/
 
insheet using Interest_rates.csv, clear
gen date = ym(year,month)
format date %tmCCYY!mnn
tsset date
label var gold_rate "Foreign exchange at New York on London"
label var com_paper "Two name choice commercial paper"
label var gold_diff "Gold premium"

sort year month
tempfile interest_rates
drop date
save `interest_rates', replace



/*LOAD GOLD IN TREASURY*/
/*See Capital_flows.xlsx for sources*/

insheet using Treasury_gold_monthly.csv, clear
drop if month =="TOTAL"
gen tempmonth = real(month)
drop month
rename tempmonth month
gen date = ym(year,month)

format date %tmCCYY!mnn
tsset date

replace netgoldintreasury = netgoldintreasury/1000000
label var netgoldintreasury "Gold in Treasury"


sort year month
tempfile treasurygold
drop date
save `treasurygold', replace



/*LOAD CUSTOM RECEIPTS*/
/*See Capital_flows.xlsx for sources*/
import excel "Capital_flows.xlsx", sheet("Customs") firstrow clear
keep if year ==1890
replace state = "CITY OF NEW YORK" if state == "NEW YORK" & district_port == "CITY OF NEW YORK"
//spelling mistake
replace state = "WEST VIRGINIA" if state == "WEST VIRGINA"

collapse (sum) receipts, by(state)
rename receipts customs
rename state location
tempfile customs_receipts
save `customs_receipts', replace



/*LOAD GOLD AND SILVER PRODUCTION*/
/*See Capital_flows.xlsx for sources*/
import excel "Capital_flows.xlsx", sheet("Gold_silver_production") firstrow clear

/*Average over all years in data. Only 1889 and 1890 to start with*/
collapse (mean) gold_produced silver_produced, by(state)
rename state location
replace location = "DAKOTA" if location == "SOUTH DAKOTA"
tempfile Gold_silver_production
save `Gold_silver_production', replace






/*LOAD GOLD IMPORTS*/
import excel "Capital_flows.xlsx", sheet("gold_imports") firstrow clear
/*Average over all years. Some states have more than one city so 
combine to state level first, than average over years*/
replace state = "CITY OF NEW YORK" if state == "NEW YORK" & city == "NEW YORK"

collapse (sum) gold_imports, by(state year)
collapse (mean) gold_imports, by(state)
rename state location
tempfile gold_imports
save `gold_imports', replace









/*START USING NATIONAL BANK DATA*/
use  National_bank_call_reports_states, clear

//Comment out to run without excluding bonds in circulation
replace total_assets = total_assets - bonds_circulation_assets


/** Merge location labels*/
merge m:1 location using state_abbrev.dta
drop _merge

/*Add labels for some missing*/
replace state_abbrev = "CHICAGO" if location == "CITY OF CHICAGO"
replace state_abbrev = "ST LOUIS" if location == "CITY OF ST LOUIS"


/*There are many states with no gold use here. They typically have low 
specie/assets as well, but it is unclear how to include them*/

//Merge whether on eastern seaboard
preserve
import excel "Capital_flows.xlsx", sheet("Eastern_seaboard") firstrow clear
tempfile east_seaboard
save `east_seaboard', replace
restore
merge m:1 location using `east_seaboard'
tab location if _merge !=3
drop _merge


/*DEFINE AND LABEL VARIABLES*/

/*Note removing from assets the bonds used to secure notes,
If compare to liabilities must also take out notes*/



merge m:1 location using `Gold_silver_production'
drop _merge
merge m:1 location using `gold_imports'
drop _merge
merge m:1 location using `customs_receipts'
drop _merge
replace gold_produced = 0 if gold_produced == .
replace silver_produced =0 if silver_produced ==.
replace gold_imports = 0 if gold_imports==.
replace customs =0 if customs ==.

drop if location == "OTHER"

/*GENERATE INDICATORS OF GOLD USE/AVAILABILITY*/
gen r_gold_avg_assets = (gold_produced + gold_imports)/total_assets
gen r_gold_prod_assets = gold_produced/total_assets
gen r_gold_imp_assets = gold_imports/total_assets

gen ln_r_gold_prod_assets = ln(r_gold_prod_assets)
gen ln_r_gold_imp_assets = ln(r_gold_imp_assets)
gen ln_r_gold_avg_assets = ln(r_gold_avg_assets)

gen r_customs_assets = customs/total_assets
gen ln_r_customs_assets = ln(r_customs_assets)
gen r_gold = (customs + gold_produced + gold_imports)/total_assets
gen ln_r_gold = ln(r_gold)
gen r_loans_assets = loans_assets/total_assets
gen r_reserves_assets = reserves_assets/total_assets
gen r_usbonds_assets = us_bonds_assets/total_assets

//DEFINE RATIOS FROM BANK BALANECE SHEETS
gen r_specie_assets = specie_assets/total_assets

//Deposits/assets
gen r_deposits_assets = individual_deposits_liab/total_assets


gen r_assets_equity = total_assets/(capital_stock_liab+ surplus_fund_liab+ undivided_profits_liab+ dividends_unpaid_liab)
label var r_assets_equity "Ratio assets to equity"

gen leverage = (total_assets-(capital_stock_liab+ surplus_fund_liab+ undivided_profits_liab+ dividends_unpaid_liab)) /total_assets
label var leverage "National Bank Leverage" //Debt/assets


tsset  loc_no call_date_order



gen ddate = call_date-l.call_date

 
foreach var of varlist r_* leverage {
egen lntemp = mean(ln(`var')) if call_year<1890, by(loc_no)

egen temp = mean((`var')) if call_year<1890, by(loc_no)

egen lnb`var' = mean(lntemp), by(loc_no) //Before 1890 average of log

egen b`var' = mean(temp), by(loc_no) //Before 1890 average of log
	
gen ln`var' = ln(`var') //Log variable

gen Dln`var' = (ln(`var')-ln(l.`var')) //log differences

gen D`var' = (`var')-(l.`var') // differences

drop lntemp temp
}






/***** Make Figures ****/


/*FIGURE 5*/
foreach dateval in ///
13Dec1895 ///
28Feb1896 ///
07May1896 ///
14Jul1896 ///
06Oct1896 ///
17Dec1896 ///
09Mar1897 ///
14May1897 ///
///
{
	disp "`dateval'"
	correlate Dleverage lnbr_specie_assets if call_date == date("`dateval'","DMY") //  & abs(Dleverage)<.05
	local corrdisp: display %4.3f r(rho)
	reg Dleverage lnbr_specie_assets if call_date == date("`dateval'","DMY")  //& abs(Dleverage)<.05
	matrix B = e(b)
	local cons: display %4.3f B[1,2]
	local coeff: display %4.3f B[1,1]
	twoway (scatter Dleverage lnbr_specie_assets if abs(Dleverage)<.05 & east_seaboard, msymbol(O)  )  (scatter Dleverage lnbr_specie_assets if abs(Dleverage)<.05 & !east_seaboard, msymbol(s)  )  ///
	(lfit Dleverage lnbr_specie_assets if abs(Dleverage)<.05 ) ///
	if call_date == date("`dateval'","DMY"), xtitle("Log specie/assets before 1890" ) ytitle("Change in debt/assets") ///
	 title(`dateval') ///
	ttext(-.03 -2 "Correlation = `corrdisp'" "E[y|x] = `cons' + `coeff' x", placement(w)) ///
	legend(off) name(_`dateval', replace)
		
}
graph combine ///
_13Dec1895 ///
_28Feb1896 ///
_07May1896 ///
_14Jul1896 ///
_06Oct1896 ///
_17Dec1896 ///
_09Mar1897 ///
_14May1897 ///
, ycommon xcommon ///
/// title(Change in log debt/assets from previous call date) ///
/// subtitle(Dates surrounding Nov 1896 defeat of Bryan) ///
 cols(4) ysize(5) xsize(8) name(leverage1896) 
graph export "`OUTDIR'\Leverage_graphs_1896.pdf", as(pdf) name(leverage1896) font(times) replace 







/*FIGURE 4*/
foreach var in lnbr_specie_assets ln_r_gold {
	if "`var'" == "lnbr_specie_assets" {
		local varxtitle  "Log specie/assets before 1890"
		local filename delta_leverage_specie1896
		local xlocnote -2
	}
	if "`var'" == "ln_r_gold_avg_assets" {
		local varxtitle  "Log ((Gold Production + Gold Imports)/Bank Assets)"
		local filename delta_leverage_goldprod1896
		local xlocnote 5
	}
	if "`var'" == "ln_r_gold" {
		local varxtitle  "Log ((Customs + Gold Production + Gold Imports)/Bank Assets)"
		local filename delta_leverage_golduse1896
		local xlocnote 2
	}
	
	
	correlate Dleverage `var' if call_date == date("17dec1896","DMY") 
	local corrdisp: display %4.3f r(rho)
	reg Dleverage `var' if call_date == date("17dec1896","DMY") 
	matrix B = e(b)
	local cons: display %4.3f B[1,2]
	local coeff: display %4.3f B[1,1]
	twoway (scatter Dleverage `var' if east_seaboard , mlabel(state_abbrev) msymbol(O) )  (scatter Dleverage `var' if !east_seaboard , mlabel(state_abbrev) msymbol(s) ) ///
		(lfit Dleverage `var' ) if call_date == date("17dec1896","DMY"), /// 
		ytitle("Change in debt/assets around election") ///
		xtitle("`varxtitle'" ) legend(off) name(`filename', replace) ///
		ttext(-.02 `xlocnote' "Correlation = `corrdisp'" "E[y|x] = `cons' + `coeff' x", placement(w))
	graph export "`OUTDIR'\\`filename'.pdf", as(pdf) name(`filename') font(Times) replace
}


//Show change in deposits, reserves, loans, gold to assets
foreach yvar in Dr_deposits_assets Dr_reserves_assets Dr_loans_assets Dr_specie_assets {
	if "`yvar'" == "Dr_deposits_assets" {	
		local filename delta_deposits_specie1896
		local varytitle "Change in deposits/assets around election"
		local xlocnote -2
	}
	if "`yvar'" == "Dr_reserves_assets" {	
		local filename delta_reserves_specie1896
		local varytitle "Change in reserves/assets around election"
		local xlocnote -2
	}
	if "`yvar'" == "Dr_loans_assets" {	
		local filename delta_loans_specie1896
		local varytitle "Change in loans/assets around election"
		local xlocnote -3.5
	}
	if "`yvar'" == "Dr_specie_assets" {	
		local filename delta_specie_specie1896
		local varytitle "Change in specie/assets around election"
		local xlocnote -3.5
	}
	local varxtitle  "Log specie/assets before 1890"
	local var lnbr_specie_assets 
	correlate `yvar' `var' if call_date == date("17dec1896","DMY") 
	local corrdisp: display %4.3f r(rho)
	reg `yvar' `var' if call_date == date("17dec1896","DMY") 
	matrix B = e(b)
	local cons: display %4.3f B[1,2]
	local coeff: display %4.3f B[1,1]
	twoway (scatter `yvar' `var' if east_seaboard , mlabel(state_abbrev) msymbol(O) )  (scatter `yvar' `var' if !east_seaboard , mlabel(state_abbrev) msymbol(s) ) ///
		(lfit `yvar' `var' ) if call_date == date("17dec1896","DMY"), /// 
		ytitle("`varytitle'") ///
		xtitle("`varxtitle'" ) legend(off) name(`filename', replace) ///
		ttext(-.03 `xlocnote' "Correlation = `corrdisp'" "E[y|x] = `cons' + `coeff' x", placement(w))
	graph export "`OUTDIR'/`filename'.pdf", as(pdf) name(`filename') font(Times) replace
}




/******/	

	
//Run regressions
tempfile temp1
save `temp1', replace

//Merge in additional controls

//Load data entered from Comptroler of Currency report
import excel "`INDIR'/bankdata-hist_text/BANKDATA.xlsx", sheet("state") firstrow clear
capture drop D
replace state = trim(state)
gen location =  upper(state)
rename year call_year
drop state
replace call_year = 1888 if call_year ==1889 //Some entered from 1889

//Duplicate reserve cities from state


tempfile state_assets
save `state_assets', replace

use `temp1', clear
merge m:1 location call_year using `state_assets'
drop _merge

//Merge bank data created from National_banks_compare_state_banks.do
gen ST = state_abbrev


preserve
//Created by National_banks_Compare_State_banks
use all_bank_data, clear
keep if inlist(year, 1896, 1900,1901, 1907)

rename year call_year
keep f_state f_S_COIN ST call_year

tempfile all_bank_data
save `all_bank_data', replace
restore
merge m:1 ST call_year using `all_bank_data' 
drop _merge
replace f_state = S_TOTASS/(S_TOTASS+total_assets) if call_year == 1893 | call_year ==1888

//Apply average from state to reserve cities
gen temp_IL = f_state if location == "ILLINOIS"
egen fstate_IL = mean(temp_IL) , by(call_date)
replace f_state = fstate_IL if location =="CITY OF CHICAGO"

gen temp_MO = f_state if location == "MISSOURI"
egen fstate_MO = mean(temp_MO) , by(call_date)
replace f_state = fstate_MO if location =="CITY OF ST LOUIS"

gen temp_NY = f_state if location == "NEW YORK"
egen fstate_NY = mean(temp_NY) , by(call_date)
replace f_state = fstate_NY if location =="CITY OF NEW YORK"


drop temp_* fstate_*
gen ln_f_S_COIN = log(f_S_COIN)

//Merge population and agriculature data from NHGIS create by 
//national_banks_load_NHGIS.do
cd "`INDIR'"
gen state = location
merge m:1 state call_year using NHGIS_controls
/*** Put in values for reserve cities
Population: 
*/

local chicago1890	1099850
local chicago1900	1698575
local chicago1910	2185283

local stlouis1890	451770		
local stlouis1900	575238			
local stlouis1910	687029

local newyork1890	1515301	
local newyork1900	3437202
local newyork1910	4766883		

foreach thisyear in 1888 1893 1896 1900 1901 1907 {
foreach thisloc in chicago stlouis newyork {
	if "`thisloc'" == "chicago" {
		local thislocation "CITY OF CHICAGO"
	}
	if "`thisloc'" == "stlouis" {
		local thislocation "CITY OF ST LOUIS"
	}
	if "`thisloc'" == "newyork" {
		local thislocation "CITY OF NEW YORK"
	}
	if `thisyear' == 1888 {
		replace pop = ``thisloc'1890' ///
		if location == "`thislocation'" & call_year == 1888
	}
	if `thisyear' == 1893 {
		replace pop = (7/10)*``thisloc'1890'+(3/10)*``thisloc'1900' ///
		if location == "`thislocation'" & call_year == 1893
	}
	if `thisyear' == 1896 {
		replace pop = (4/10)*``thisloc'1890'+(6/10)*``thisloc'1900' ///
		if location == "`thislocation'" & call_year == 1896
	}
	if `thisyear' == 1900 {
		replace pop = ``thisloc'1900' ///
		if location == "`thislocation'" & call_year == 1900
	}
	if `thisyear' == 1901 {
		replace pop = (9/10)*``thisloc'1900'+(1/10)*``thisloc'1910' ///
		if location == "`thislocation'" & call_year == 1901
	}
	if `thisyear' == 1907 {
		replace pop = (3/10)*``thisloc'1900'+(6/10)*``thisloc'1910' ///
		if location == "`thislocation'" & call_year == 1907
	}
}
replace f_agric= 0 if call_year == `thisyear' & ///
	(location == "CITY OF CHICAGO" | /// 
	location == "CITY OF ST LOUIS" | ///
	location == "CITY OF NEW YORK")
replace f_citypop  = 1 if call_year == `thisyear' & ///
	(location == "CITY OF CHICAGO" | /// 
	location == "CITY OF ST LOUIS" | ///
	location == "CITY OF NEW YORK")



}

gen ln_pop = log(pop)
drop _merge
/*
replace pop1896 = (4/10)*1099850+(6/10)*1698575 ///
	if location == "CITY OF CHICAGO" & call_year == 1896
replace pop1896 = (4/10)*451770+(6/10)*575238 ///
	if location == "CITY OF ST LOUIS" & call_year == 1896
replace pop1896 = (4/10)*1515301+(6/10)*3437202 ///
	if location == "CITY OF NEW YORK" & call_year == 1896
*/




//Lagged election
sort loc_no call_date_order 
tempvar L_leverage_election
gen `L_leverage_election' = L5.leverage if call_date == date("17dec1896","DMY")
egen L_leverage_election1896 = mean(`L_leverage_election'), by(location)


tempvar Dleverage_election
gen `Dleverage_election' = Dleverage if call_date == date("17dec1896","DMY")
egen Dleverage_election1896 = mean(`Dleverage_election'), by(location)

foreach thisvar in lnbr_specie_assets f_state r_reserves_assets ln_pop f_citypop f_agric {
	tempvar `thisvar'temp
	gen ``thisvar'temp' = `thisvar' if call_date == date("17dec1896","DMY")
	egen `thisvar'1896 = mean(``thisvar'temp'), by(location)
}

gen Delection = 1 if call_date == date("17dec1896","DMY")
replace Delection = 0 if Delection==.	

gen tmpPanic1907 = Dlnr_assets_equity if year(call_date)==1907 & month(call_date)==12
egen Panic1907 = mean(tmpPanic1907), by(location)

gen tmpTRoosevelt = Dlnr_assets_equity if year(call_date)==1901 & month(call_date)==9
egen TRoosevelt = mean(tmpTRoosevelt), by(location)


gen tmpelection1900 = Dlnr_assets_equity if year(call_date)==1900 & month(call_date)==12
egen election1900 = mean(tmpelection1900), by(location)


gen tmpelection1888 = Dlnr_assets_equity if year(call_date)==1888 & month(call_date)==12
egen election1888 = mean(tmpelection1888), by(location)


gen tmpcommodity = Dlnr_assets_equity if year(call_date)==1888 & month(call_date)==10
egen commodity = mean(tmpcommodity), by(location)

gen tmprec1893 = Dlnr_assets_equity if year(call_date)==1893 & month(call_date)==10
egen rec1893 = mean(tmprec1893), by(location)

drop tmp*

/*
foreach thisvar in lnbr_specie_assets f_state r_reserves_assets {
	tempvar `thisvar'1907
	gen ``thisvar'1907' = `thisvar' if year(call_date)==1907 & month(call_date)==12
	egen `thisvar'1907 = mean(``thisvar'1907'), by(location)
	tempvar `thisvar'1900
	gen ``thisvar'1900' = `thisvar' if year(call_date)==1900 & month(call_date)==12
	egen `thisvar'1900 = mean(``thisvar'1907'), by(location)

}
*/
//Calculate for economic significance
sum lnbr_specie_assets  if call_date == date("17dec1896","DMY"), det


//Put in outreg
// Order: lnbr_specie_assets lnr_gold IV, with controls, all other dates

cd "`OUTDIR'"
reg Dleverage_election1896 lnbr_specie_assets  if call_date == date("17dec1896","DMY"), robust
outreg2 using Dleverage_gold, auto(3) replace nocons excel
reg Dleverage_election1896 r_gold  if call_date == date("17dec1896","DMY"), robust
outreg2 using Dleverage_gold ,auto(3) nocons excel
ivregress 2sls Dleverage_election1896 (lnbr_specie_assets = r_gold) if call_date == date("17dec1896","DMY"), robust
outreg2 using Dleverage_gold, auto(3) ctitle(IV) nocons excel
reg Dleverage_election1896 lnbr_specie_assets f_state r_reserves_assets ln_pop f_citypop f_agric east_seaboard if call_date == date("17dec1896","DMY"), robust 
outreg2  using Dleverage_gold, auto(3) ctitle(controls1896)  nocons excel
reg Dleverage_election1896 Dlnr_assets_equity  f_state r_reserves_assets ln_pop f_citypop f_agric  ///
	 f_state1896 r_reserves_assets1896 ln_pop1896 f_citypop1896 f_agric1896 east_seaboard ///
	  if year(call_date)==1900 & month(call_date)==12, robust 
outreg2  using Dleverage_gold, auto(3) ctitle(controls1900)  nocons excel
reg Dleverage_election1896 Dlnr_assets_equity  f_state r_reserves_assets ln_pop f_citypop f_agric  ///
	 f_state1896 r_reserves_assets1896 ln_pop1896 f_citypop1896 f_agric1896 east_seaboard ///
	 if year(call_date)==1907 & month(call_date)==12, robust 
outreg2  using Dleverage_gold, auto(3) ctitle(controls1907)  nocons excel

//Loop over other dates, 
foreach thisdate in ///
 "year(call_date)==1901 & month(call_date)==9" /// Roosevelt becomes president
 "year(call_date)==1907 & month(call_date)==12" /// 1907 Panic
 "year(call_date)==1900 & month(call_date)==12" /// Election 1900 
 "year(call_date)==1888 & month(call_date)==12" /// 1888 Election
 "year(call_date)==1888 & month(call_date)==10" /// Commodity shock
 "year(call_date)==1893 & month(call_date)==10" /// Recession 1893
  {
	reg Dleverage_election1896 Dlnr_assets_equity   f_state r_reserves_assets ln_pop f_citypop f_agric  ///
	 f_state1896 r_reserves_assets1896 ln_pop1896 f_citypop1896 f_agric1896 east_seaboard ///
	 if `thisdate', robust
	outreg2 using Dleverage_gold , auto(3) ctitle(controls)  nocons excel

}

foreach thisdate in ///
 "year(call_date)==1901 & month(call_date)==9" /// Roosevelt becomes president
 "year(call_date)==1907 & month(call_date)==12" /// 1907 Panic
 "year(call_date)==1900 & month(call_date)==12" /// Election 1900 
 "year(call_date)==1888 & month(call_date)==12" /// 1888 Election
 "year(call_date)==1888 & month(call_date)==10" /// Commodity shock
 "year(call_date)==1893 & month(call_date)==10" /// Recession 1893
  {
	reg Dleverage_election1896 Dlnr_assets_equity  if `thisdate', robust
	outreg2 using Dleverage_gold , auto(3) ctitle(nocontrols)  nocons excel

}

//With lagged leverage

foreach thisdate in ///
 "year(call_date)==1901 & month(call_date)==9" /// Roosevelt becomes president
 "year(call_date)==1907 & month(call_date)==12" /// 1907 Panic
 "year(call_date)==1900 & month(call_date)==12" /// Election 1900 
 "year(call_date)==1888 & month(call_date)==12" /// 1888 Election
 "year(call_date)==1888 & month(call_date)==10" /// Commodity shock
 "year(call_date)==1893 & month(call_date)==10" /// Recession 1893
  {
	reg Dleverage_election1896 Dlnr_assets_equity   f_state r_reserves_assets ln_pop f_citypop f_agric  L5.leverage ///
	 f_state1896 r_reserves_assets1896 ln_pop1896 f_citypop1896 f_agric1896 L_leverage_election1896 east_seaboard ///
	 if `thisdate', robust
	outreg2 using Dleverage_gold , auto(3) ctitle(controls)  nocons excel

}


exit

//Rank rank correlations of control variables and bank variables

//Old code to put in matrix rather than outreg

foreach var of varlist lnbr_specie_assets lnr_gold ln_f_S_COIN Panic1907 TRoosevelt election1900 election1888 commodity rec1893 {

reg Dleverage `var' if Delection==1, robust

scalar b`var' = _b[`var']
scalar ci`var'_u = _b[`var'] + _se[`var']*invttail(e(df_r),.025)
scalar ci`var'_l = _b[`var'] - _se[`var']*invttail(e(df_r),.025)
scalar se`var' = _se[`var']

scalar r`var' = e(r2)
scalar n`var' = e(N)

}



ivregress 2sls Dleverage (lnbr_specie_assets = lnr_gold) if Delection ==1, robust

scalar blnbr_specie_assetsiv = _b[lnbr_specie_assets]
scalar cilnbr_specie_assetsiv_u = _b[lnbr_specie_assets] - _se[lnbr_specie_assets]*invnormal(.025)
scalar cilnbr_specie_assetsiv_l = _b[lnbr_specie_assets] + _se[lnbr_specie_assets]*invnormal(.025)
scalar selnbr_specie_assetsiv =  _se[lnbr_specie_assets]

scalar rlnbr_specie_assetsiv = e(r2)
scalar nlnbr_specie_assetsiv = e(N)



mat def Table = J(16,9,.)

mat def Table[1,1] = blnbr_specie_assets
mat def Table[2,1] = selnbr_specie_assets
mat def Table[15,1] = rlnbr_specie_assets
mat def Table[16,1] = nlnbr_specie_assets


mat def Table[3,2] = blnr_gold
mat def Table[4,2] = selnr_gold
mat def Table[15,2] = rlnr_gold
mat def Table[16,2] = nlnr_gold


mat def Table[1,3] = blnbr_specie_assetsiv
mat def Table[2,3] = selnbr_specie_assetsiv
mat def Table[15,3] = rlnbr_specie_assetsiv
mat def Table[16,3] = nlnbr_specie_assetsiv


local j = 1

foreach var of varlist ln_f_S_COIN Panic1907 TRoosevelt election1900 election1888 commodity{

mat def Table[2*(`j'-1)+5,3+`j'] = b`var'
mat def Table[2*(`j'-1)+6,3+`j'] = se`var'
mat def Table[15,3+`j'] = r`var'
mat def Table[16,3+`j'] = n`var'

local j = `j'+1

}



exit

//Prepare series for factor analysis

gen total_equity = capital_stock_liab+ surplus_fund_liab+ undivided_profits_liab+ dividends_unpaid_liab

gen lev = (total_assets-total_equity)/total_assets

gen dlev = lev - l.lev

keep dlev call_date loc*


gen year = year(call_date)
gen month = month(call_date)



drop loc_no
egen loc_no = group(location)

drop location


reshape wide dlev, i(call_date) j(loc_no)

drop if _n==1

foreach var of varlist dlev*{

count if `var' == . & year(call_date)>=1880

if r(N)>0{
drop `var'
}

}
