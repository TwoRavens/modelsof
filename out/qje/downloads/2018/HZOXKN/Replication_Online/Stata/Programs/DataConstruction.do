clear
clear mata
set memory 700m
set more off, perm


/* Directories */
local dirdata     "../Data_Orig/"
local dirworking  "../IntermediateFiles/"
local dirprograms "../Programs/"

/******************************************************************************/
/*                               LOADING DATA                                 */
/******************************************************************************/

/* 1. Fed target, retrieved from Fred website */

insheet using `dirdata'FedTarget.csv, clear

rename value FEDTAR
label variable FEDTAR "Fed target"

generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily
save `dirworking'FEDTAR, replace

/* 2. Nominal yields, 3-months, retrieved from Fed Board H.15
       http://www.federalreserve.gov/releases/h15/data.htm */

insheet using `dirdata'NominalYields3Months.csv, clear
drop in 1
rename v1 date
rename v2 NY3M
replace NY3M="" if NY3M=="ND"
destring NY3M, replace
tab NY3M if missing(NY3M)
label variable NY3M "3-month nominal yield"

generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily
save `dirworking'NY3M, replace

/* 3. Nominal yields, 6-months, retrieved from Fed Board H.15
      http://www.federalreserve.gov/releases/h15/data.htm   */

insheet using `dirdata'NominalYields6Months.csv, clear
drop in 1
rename v1 date
rename v2 NY6M
replace NY6M="" if NY6M=="ND"
destring NY6M, replace
tab NY6M if missing(NY6M)
label variable NY6M "6-month nominal yield"

generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily
save `dirworking'NY6M, replace

/* 4. Nominal yields, longer maturity = Gurkaynak, Sack, and Wright (JME 2007)
       data, www.federalreserve.gov/econresdata/researchdata.htm  */

insheet using `dirdata'NominalYields.csv, clear
keep v1 sveny* svenf* sven1f*

rename sveny01 NY1
label variable NY1 "Zero-coupon 1-year nominal yield"

rename sveny02 NY2
label variable NY2 "Zero-coupon 2-year nominal yield"

rename sveny03 NY3
label variable NY3 "Zero-coupon 3-year nominal yield"

rename sveny05 NY5
label variable NY5 "Zero-coupon 5-year nominal yield"

rename sveny10 NY10
label variable NY10 "Zero-coupon 10-year nominal yield"

rename svenf01 NF1
label variable NF1 "1-year nominal instantaneous forward rate"

rename svenf02 NF2
label variable NF2 "2-year nominal instantaneous forward rate"

rename svenf03 NF3
label variable NF3 "3-year nominal instantaneous forward rate"

rename svenf05 NF5
label variable NF5 "5-year nominal instantaneous forward rate"

rename svenf10 NF10
label variable NF10 "10-year nominal instantaneous forward rate"

drop sveny* svenf* sven1*

generate date_daily = date(v1,"YMD",2025)
drop v1
label variable date_daily "Date (daily)"
tsset date_daily
save `dirworking'NY, replace

/* 5. Real Yields = Gurkaynak, Sack, and Wright (AEJMacro 2010) data
      http://www.federalreserve.gov/pubs/feds/2008/200805/200805abs.html */

insheet using `dirdata'RealYields.csv, clear
** Keep maturities of 3, 5 and 10 years
keep v1 tipsy* tipsf* bkeveny*

rename tipsy02 RY2
label variable RY2 "Zero-coupon 2-year real yield (TIPS)"

rename tipsy03 RY3
label variable RY3 "Zero-coupon 3-year real yield (TIPS)"

rename tipsy05 RY5
label variable RY5 "Zero-coupon 5-year real yield (TIPS)"

rename tipsy10 RY10
label variable RY10 "Zero-coupon 10-year real yield (TIPS)"

rename tipsf02 RF2
label variable RF2 "2-year real instantaneous forward rate (TIPS)"

rename tipsf03 RF3
label variable RF3 "3-year real instantaneous forward rate (TIPS)"

rename tipsf05 RF5
label variable RF5 "5-year real instantaneous forward rate (TIPS)"

rename tipsf10 RF10
label variable RF10 "10-year real instantaneous forward rate (TIPS)"

/*temporarily rename bkeveny IY, to keep only 2 3 5 10 and delete all others*/
rename bkeveny02 IY2
label variable IY2 "2Y break even inflation"

rename bkeveny03 IY3
label variable IY3 "3Y break even inflation"

rename bkeveny05 IY5
label variable IY5 "5 year break even inflation"

rename bkeveny10 IY10
label variable IY10 "10 year break even inflation"

drop tipsy* tipsf* bkeveny*

*rename IY back to bkeveny
rename IY* bkeveny*

generate date_daily = date(v1,"YMD",2025)
drop v1
label variable date_daily "Date (daily)"
tsset date_daily
save `dirworking'RY, replace

/* 6. Eurodollar future, 1 month, retrieved from Fred (DED1) series */

insheet using `dirdata'EuroDollar1Month.csv, clear
drop in 1
rename v1 date1
rename v2 ED1M
replace ED1M="" if ED1M=="#N/A"
destring ED1M, replace
label variable ED1M "Eurodollar 1-month rate"

generate date_daily = date(date1,"YMD", 2025)
format date_daily %td
drop date1
label variable date_daily "Date (daily)"
tsset date_daily

* NOTE: ED1M is beginning-of-day value !
* Here we make it end-of-day
gen ED1Mend = ED1M[_n+1]
replace ED1M=ED1Mend
drop ED1Mend

save `dirworking'ED1M, replace

/* 7. Eurodollar Futures, retrived from IHS Global Insight */

insheet using `dirdata'EDFutures.csv, clear
drop in 1
forvalues k=2(1)12 {
replace v`k' = "" if v`k'=="#N/A"
destring v`k', replace
}
rename v1 date
rename v2 edfutexp2
rename v3 edfutbeg3
rename v4 edfutexp3
rename v5 edfutbeg4
rename v6 edfutexp4
rename v7 edfutbeg5
rename v8 edfutexp5
rename v9 edfutbeg6
rename v10 edfutexp6
rename v11 edfutbeg1
rename v12 edfutexp1

generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily

/* edfutbeg1 and edfutexp1 coincide except on expiration months
 (Mar, Jun, Sep, Dec) from the first of the month until the expiration date
 tab date if  edfutbeg1!= edfutexp1 & date_daily>td(01jan2000) & ///
                                        date_daily<td(31dec2001) */

save `dirworking'EDfutures, replace

/* 8. Eurodollar Futures, retrived from IHS Global Insight */

insheet using `dirdata'fedfutures.csv, clear
rename v1 date
drop in 1
forvalues k=2(1)15 {
replace v`k' = "" if v`k'=="#N/A"
destring v`k', replace
}
rename v2 fedfutbeg2
rename v3 fedfutexp2
rename v4 fedfutbeg3
rename v5 fedfutexp3
rename v6 fedfutbeg4
rename v7 fedfutexp4
rename v8 fedfutbeg5
rename v9 fedfutexp5
rename v10 fedfutbeg6
rename v11 fedfutexp6
rename v12 fedfutbeg7
rename v13 fedfutexp7
rename v14 fedfutbeg1
rename v15 fedfutexp1

generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily

 tab date if  fedfutbeg1!= fedfutexp2
*6 dates on which fedfutbeg1!= fedfutexp2
*These are 30oct1998 31dec1999 28apr2000 31jul2000 31dec2004  20mar2007
*20mar2007 is day before FOMC date. Others are further from FOMC dates.
list fedfutexp1 fedfutbeg1 fedfutexp2 fedfutbeg2 fedfutexp3 fedfutbeg3 fedfutexp4 if date>td(18mar2007) & date<td(23mar2007)
* 21mar2007 is an FOMC date. It looks like the fedfutexp2 and fedfutexp3
* have an error in them. We replace them with fedfutbeg1 and fedfutbeg2
replace fedfutexp2 = fedfutbeg1 if date==td(20mar2007)
replace fedfutexp3 = fedfutbeg2 if date==td(20mar2007)
list fedfutexp1 fedfutbeg1 fedfutexp2 fedfutbeg2 fedfutexp3 fedfutbeg3 fedfutexp4 if date>td(18mar2007) & date<td(23mar2007)

save `dirworking'Fedfutures, replace

/* 9. FOMC meetings */

insheet using `dirdata'FOMCmeetings.csv, clear
generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily

rename fomcmeeting FOMC
label variable FOMC "FOMC Meeting date"
label variable unscheduled "FOMC meeting that got unscheduled"
label variable twodays "the FOMC meeting started the day before"
rename  weirdoct87confcall turmoil
label variable turmoil "Planned roll over meetings due to extremely volatile conditions"
label variable minutes "1: Minutes were released"
label variable isconfcall "1: FOMC Conference Call;  0: FOMC Meeting"
label variable statement "1: A statement was released this day and it is on the Fed website, 0:no"
label variable pressconference "1: Fed Chair held post-meeting press conference"
save `dirworking'FOMC, replace

/* 10. Lustig et al. Inflation Swap Data */

insheet using `dirdata'InflSwaps.csv, clear
gen date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily

*temporarily rename usswit to InflSwap, to keep only 2 3 5 10&Y and delete all the others
rename usswit2 InflSwap2
label variable InflSwap2 "2Y Zero-coupon inflation swap"

rename usswit3 InflSwap3
label variable InflSwap3 "3Y Zero-coupon inflation swap"

rename usswit5 InflSwap5
label variable InflSwap5 "5Y Zero-coupon inflation swap"

rename usswit10 InflSwap10
label variable InflSwap10 "10Y Zero-coupon inflation swap"

drop usswit*

*rename InflSwap back to usswit
rename InflSwap* usswit*

save `dirworking'InflSwap, replace

/* 11. S&P 500 stock price index, retrieved from yahoo finance*/
* http://finance.yahoo.com/q/hp?s=%5EGSPC&a=00&b=3&c=1984&d=01&e=11&f=2015&g=d

insheet using `dirdata'SP500.csv, clear

generate date_daily = date(date,"YMD", 2012)
format date_daily %td
keep  date_daily close volume

rename close sp500price
rename volume sp500volume
label variable sp500price "S&P500 closing price"
label variable sp500volume "S&P500 volume"

gen lsp500 = 100*log(sp500price)
label variable lsp500 "100* log price of S&P500"

tsset date_daily
sort date_daily

save `dirworking'sp500, replace


/* 12. S&P 500 stock price index volatility */
* http://finance.yahoo.com/q/hp?s=%5EVIX+Historical+Prices

insheet using `dirdata'VIX.csv, clear

generate date_daily = date(date,"YMD", 2013)
format date_daily %td
keep  date_daily close

rename close VIX
label variable VIX "S&P vix closing price"

gen lvix = 100*log(VIX)
label variable lvix "100* log price of S&P500"

tsset date_daily
sort date_daily

save `dirworking'VIX, replace

/* 13-20. Risk Neutral Returns from Monch et al. Paper */
insheet using `dirdata'moench_nominalriskneutral.csv, clear
foreach num of numlist 1(1)11 {
	label variable n`num'y_neut "nominal risk neutral yield from Monch et al."
}
foreach num of numlist 1(1)10 {
	local nump1 = `num'+1
	gen n`num'f_neut = `nump1'*n`nump1'y_neut - `num'*n`num'y_neut
	label variable n`num'f_neut "nominal risk neutral one-year forward from Monch et al."
}
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
tsset date_daily
sort date_daily
drop date
save `dirworking'nominalriskneutral, replace

insheet using `dirdata'moench_realriskneutral.csv, clear
foreach num of numlist 2(1)11 {
	label variable r`num'y_neut "real risk neutral yield from Monch et al."
}
foreach num of numlist 2(1)10 {
	local nump1 = `num'+1
	gen r`num'f_neut = `nump1'*r`nump1'y_neut - `num'*r`num'y_neut
	label variable r`num'f_neut "real risk neutral one-year forward from Monch et al."
}
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
tsset date_daily
sort date_daily
drop date
save `dirworking'realriskneutral, replace

insheet using `dirdata'moench_nominalpremium.csv, clear
foreach num of numlist 1(1)11 {
	label variable n`num'y_prem "nominal yield premium from Monch et al."
}
foreach num of numlist 1(1)10 {
	local nump1 = `num'+1
	gen n`num'f_prem = `nump1'*n`nump1'y_prem - `num'*n`num'y_prem
	label variable n`num'f_prem "nominal one-year forward premium from Monch et al."
}
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
tsset date_daily
sort date_daily
drop date
save `dirworking'nominalpremium, replace

insheet using `dirdata'moench_realpremium.csv, clear
foreach num of numlist 2(1)11 {
	label variable r`num'y_prem "real yield premium from Monch et al."
}
foreach num of numlist 2(1)10 {
	local nump1 = `num'+1
	gen r`num'f_prem = `nump1'*r`nump1'y_prem - `num'*r`num'y_prem
	label variable r`num'f_prem "real one-year forward premium from Monch et al."
}
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
tsset date_daily
sort date_daily
drop date
save `dirworking'realpremium, replace

insheet using `dirdata'moench_nominalliquidity.csv, clear
foreach num of numlist 1(1)11 {
	label variable n`num'y_liq "nominal liquidity yield from Monch et al."
}
foreach num of numlist 1(1)10 {
	local nump1 = `num'+1
	gen n`num'f_liq = `nump1'*n`nump1'y_liq - `num'*n`num'y_liq
	label variable n`num'f_liq "nominal liquidity one-year forward from Monch et al."
}
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
tsset date_daily
sort date_daily
drop date
save `dirworking'nominalliquidity, replace

insheet using `dirdata'moench_realliquidity.csv, clear
foreach num of numlist 2(1)11 {
	label variable r`num'y_liq "real liquidity yield from Monch et al."
}
foreach num of numlist 2(1)10 {
	local nump1 = `num'+1
	gen r`num'f_liq = `nump1'*r`nump1'y_liq - `num'*r`num'y_liq
	label variable r`num'f_liq "real liquidity one-year forward from Monch et al."
}
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
tsset date_daily
sort date_daily
drop date
save `dirworking'realliquidity, replace


/* 21. Risk Neutral Returns from Kim and Wright */
insheet using `dirdata'feds200533.csv, clear
drop if missing(v2)
drop if _n==1
gen year = v1
gen month = v2
gen day = v3
gen date = month+"/"+day+"/"+year
generate date_daily = date(date,"MDY", 2013)
format date_daily %td
drop year month day date
local l
foreach num of numlist 1 2 3 5 10 {
	local l=`num'+3
	rename v`l' n`num'f_kw
	destring(n`num'f_kw), replace
	label variable n`num'f_kw "Kim and Wright's forward"

	local l=`num'+13
	rename v`l' n`num'f_prem_kw
	destring(n`num'f_prem_kw), replace
	label variable n`num'f_prem_kw "Kim and Wright's risk premium on the forward"

	generate n`num'f_neut_kw = n`num'f_kw - n`num'f_prem_kw
	label variable n`num'f_neut_kw "Kim and Wright's risk neutral forward"

	local l= `num'+23
	rename v`l' n`num'y_kw
	destring(n`num'y_kw), replace
	label variable n`num'y_kw "Kim and Wright's yield"

	local l=`num'+33
	rename v`l' n`num'y_prem_kw
	destring(n`num'y_prem_kw), replace
	label variable n`num'y_prem_kw "Kim and Wright's risk premium on yield"

	generate n`num'y_neut_kw = n`num'y_kw - n`num'y_prem_kw
	label variable n`num'y_neut_kw "Kim and Wright's risk-neutral yield"
	}

drop v*
order date
sort date
save `dirworking'kimwright, replace

/* 22. Gurkanyak et al. (2005) dataset */ 

*Note: This is a dataset we constructed by copying and pasting from the tables in "Do Actions speak louder..." GSS 2005 (appendix)
*daywin, widewin and tightwin are intraday surprises for the target factor
*target and path are the target and path factors based on daily data

insheet using `dirdata'DoActionsSpeakData_fullsmpl.csv, clear
generate date_daily = date(date,"MDY", 2025)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily
drop tbd*
replace isintermeeting = 0 if missing( isintermeeting)
replace orelease= 0 if missing(  orelease)
replace fomcstatt = 0 if missing(fomcstatt)

replace daywin=daywin/100
replace widewin = widewin/100
replace tightwin = tightwin/100
replace tgtfactor = tgtfactor/100
replace pathfactor = pathfactor/100

foreach varb in  tightwin widewin daywin isintermeeting orelease tgtfactor pathfactor fomcstatt{
	label variable `varb' "From the GSS05 paper appendix"
}

save `dirworking'GSSAppendix, replace

/* 23. Additional intraday data sent to us by Gurkanyak */

insheet using `dirdata'tight-Gurkaynakdata.csv, clear
generate date_daily = date(date,"MDY", 2012)
format date_daily %td
drop date
label variable date_daily "Date (daily)"
tsset date_daily
order date

foreach varb in  mp1 mp2 mp3 ff1 ff2 ff3 ff4 ff5 ff6 ed1 ed2 ed3 ed4 ed5 ed6 ed7 ed8 onrun3m onrun6m onrun2 onrun5 onrun10 onrun30 tips5 tips10 sp500 nasdaq wilshire sp500fut euro yen {
	label variable `varb' "From Gurkanyak's updated dataset"
}

* 5/1/2016: added Gurkaynak's series for SP500 to final talbe, so give it a better name (=to see if intraday SP series gives different results than the daily series we used)
rename sp500 Dsp500gurkaynak
label variable Dsp500gurkaynak "S&P500 Gurkaynak intraday series"

save `dirworking'Gdata, replace

/******************************************************************************/
/*                           MERGE ALL INPUTS                                 */
/******************************************************************************/

use `dirworking'FEDTAR, clear

foreach varm in NY3M NY6M NY RY FOMC ED1M EDfutures Fedfutures InflSwap ///
                sp500 VIX nominalriskneutral realriskneutral nominalpremium ///
                realpremium nominalliquidity realliquidity kimwright {
    merge 1:1 date_daily using "`dirworking'`varm'.dta", nogen
}
drop if date<mdy(01,01,1984)
* Note: GSSappendix, Gdata and intraday data added below

* A few merge checks
* tab _merge5 _merge2
* tab date_daily unscheduled if _merge5==1 & _merge2==0
* 3 FOMC days with no reported nom. yields
	* 07feb2009 (unscheduled, no statement), 09may2010 (unscheduled), 25apr2012 (out of some samples)
cap drop  _merge*

* Clean dataset from non-market days
quietly generate byte notmiss = NY1 < . & NY2 < . & NY3 < . & NY5 < . & NY10 < .
keep if notmiss == 1
drop notmiss

* Checking for missing values of 1M Eurodollar rate
tab date if missing(ED1M)
	* 12 missing EURODOLLAR values
	* 24dec1986 24dec1997 10sep2001* 13sep2001*** 24mar2005** 03feb2006*
	* 21dec2007* 01apr2010* 20aug2010* 24aug2010* 03sep2010* 06oct2010*
	* notes *<->no FOMC meeting within 3 days
		   **<-> no FOMC meeting within 2days
		   ***<-> date of an unscheduled FOMC conference call

* Adding zeros for non-FOMC days to FOMC date variables
replace FOMC 		= 0 if missing(FOMC)
replace statement 	= 0 if missing(statement) & date>=mdy(01,01,1999)
replace twodays 	= 0 if missing(twodays)
replace isconfcall  = 0 if missing(isconfcall)
replace unscheduled = 0 if missing(unscheduled)
replace turmoil  	= 0 if missing(turmoil)

* Define time variables
gen day    		= day(date)
gen month  		= month(date)
gen year   		= year(date)
gen dayofweek   = dow(date)
order date_daily date day month year dayofweek
gen seqdate = _n
label variable seqdate "Index in the sequence of market days"
tsset seqdate

save `dirworking'RAWDATA, replace

/******************************************************************************/
/*                         CREATING FIRST DIFFERENCES                         */
/******************************************************************************/

use `dirworking'RAWDATA, clear

* Create first difference of Fed target
gen DTAR = D.FEDTAR
label variable DTAR "Market-day change in FEDTAR"
gen TAR_CHANGE = cond(DTAR!=0,1,0,.)
label variable TAR_CHANGE "=1 if change in FEDTAR"
tab TAR_CHANGE FOMC
tab date if TAR_CHANGE==1 & FOMC==0
tab TAR_CHANGE FOMC if date<td(1/1/1993)
tab date if TAR_CHANGE==1 & FOMC==1 & date<td(1/1/1993)
tab TAR_CHANGE FOMC if date>td(31/12/1992)
tab date if TAR_CHANGE==1 & date>td(31/12/1990) & date<td(1/1/1992)
	* BEFORE 92: lots of mismatch between date on which the target changed and reported FOMC meetings
	* AFTER 92: perfect correspondence
tab date if date>td(31/12/1992) & TAR_CHANGE==1 & FOMC==0
	* Changed in Target rate always occured the day of a FOMC gathering

* Create daily and two-day changes for key variables
foreach varb in NY3M NY6M NY1 NY2 NY3 NY5 NY10 NF1 NF2 NF3 NF5 NF10 ///
RY2 RY3 RY5 RY10 RF2 RF3 RF5 RF10 ED1M sp500price sp500volume lsp500 VIX lvix ///
n1y_neut n2y_neut n3y_neut n5y_neut n10y_neut ///
n1f_neut n2f_neut n3f_neut n5f_neut n10f_neut ///
r2y_neut r3y_neut r5y_neut r10y_neut ///
r2f_neut r3f_neut r5f_neut r10f_neut ///
n1y_prem n2y_prem n3y_prem n5y_prem n10y_prem ///
n1f_prem n2f_prem n3f_prem n5f_prem n10f_prem ///
r2y_prem r3y_prem r5y_prem r10y_prem ///
r2f_prem r3f_prem r5f_prem r10f_prem ///
n1y_liq n2y_liq n3y_liq n5y_liq n10y_liq ///
n1f_liq n2f_liq n3f_liq n5f_liq n10f_liq ///
r2y_liq r3y_liq r5y_liq r10y_liq ///
r2f_liq r3f_liq r5f_liq r10f_liq ///
n1f_kw n2f_kw n3f_kw n5f_kw n10f_kw ///
n1f_prem_kw n2f_prem_kw n3f_prem_kw n5f_prem_kw n10f_prem_kw ///
n1f_neut_kw n2f_neut_kw n3f_neut_kw n5f_neut_kw n10f_neut_kw ///
n1y_kw n2y_kw n3y_kw n5y_kw n10y_kw ///
n1y_prem_kw n2y_prem_kw n3y_prem_kw n5y_prem_kw n10y_prem_kw ///
n1y_neut_kw n2y_neut_kw n3y_neut_kw n5y_neut_kw n10y_neut_kw {
	local label : variable label `varb'
	gen D`varb' = d.`varb'
    label variable D`varb' `"Change in `label''"'
	gen D2`varb' = s2.`varb'
    label variable D2`varb' `"2-day change in `label''"'
}

* Create daily changes for inflation swaps
foreach varb of numlist 2 3 5 10{
	gen Dusswit`varb' = d.usswit`varb'
	local label : variable label usswit`varb'
	label variable Dusswit`varb' `"Change in `label''"'

}

* Create daily changes for break even inflation
foreach varb of numlist 2 3 5 10 {
	gen Dbkeveny`varb' = d.bkeveny`varb'
	local label : variable label bkeveny`varb'
	label variable Dbkeveny`varb' `"Change in `label''"'
	}

* Generate alternative real rates based on inflation swaps
gen DRY2_2 = DNY2 - Dusswit2
label variable DRY2_2 "alternative 2Y real rates based on inflation swaps"
gen DRY3_2 = DNY3 - Dusswit3
label variable DRY3_2 "alternative 3Y real rates based on inflation swaps"
gen DRY5_2 = DNY5 - Dusswit5
label variable DRY5_2 "alternative 5Y real rates based on inflation swaps"
gen DRY10_2 = DNY10 - Dusswit10
label variable DRY10_2 "alternative 10Y real rates based on inflation swaps"

* Define breakeven Inflation Variables
gen DIF2 = DNF2 - DRF2
label variable DIF2 "2Y inflation, constructed using NF - RF"
gen DIF3 = DNF3 - DRF3
label variable DIF3 "3Y inflation, constructed using NF - RF"
gen DIF5 = DNF5 - DRF5
label variable DIF5 "5Y inflation, constructed using NF - RF"
gen DIF10 = DNF10 - DRF10
label variable DIF10 "10Y inflation, constructed using NF - RF"

* Creating first difference for Eurodollar futures
* (and first redefine edfuture as expected Eurodollar rate on the expiration day = 100 MINUS the price)
*First : the 2nd beginning nearby is missing; I can however back it up from the other series:
gen edfutbeg2 = cond(edfutexp3==edfutbeg3,edfutexp2,edfutexp3,.)
forvalues n = 1/6{
	replace  edfutbeg`n' = 100- edfutbeg`n'
	gen dedfutbeg`n' = d.edfutbeg`n'
	label variable dedfutbeg`n' "3-m Eurodollar - `n' BEGINNING FUTURE NEARBY - source IMM"
	replace  edfutexp`n'=100- edfutexp`n'
	gen dedfutexp`n' = d.edfutexp`n'
	label variable dedfutexp`n' "3-m Eurodollar - `n' EXPIRATION FUTURE NEARBY - source IMM"
}
*Rename dedfutbeg2 to remind us that edfutbeg2 was created by us since edfutbeg2 was missing in original source
rename dedfutbeg2 dedfutbeg2_m
*Corrections for switching dates
*Create first of quarter variable
gen fstofq = 1     if day==1 & (month==3 | month==6 | month==9 | month==12)
replace fstofq = 1 if day==2 & month[_n-1]==month-1 & (month==3 | month==6 | month==9 | month==12)
replace fstofq = 1 if day==3 & month[_n-1]==month-1 & (month==3 | month==6 | month==9 | month==12)
replace fstofq = 1 if day==4 & month[_n-1]==month-1 & (month==3 | month==6 | month==9 | month==12)
replace fstofq = 0 if missing(fstofq)
gen fstofq_check = cond(edfutexp2==edfutbeg1 & edfutexp2[_n+1]==edfutbeg1[_n+1] & edfutexp2[_n+2]==edfutbeg1[_n+2] & edfutexp2[_n+5]==edfutbeg1[_n+5] & edfutexp1[_n-1]==edfutbeg1[_n-1] & (month==3 | month==6 | month==9 | month==12),1,0,.)
tab fstofq fstofq_check
drop fstofq_check
*Create last of quarter variable
gen lstofq = cond(edfutexp1==edfutbeg1 & edfutexp1[_n+1]==edfutbeg1[_n+1] & edfutexp1[_n+2]==edfutbeg1[_n+2] & edfutexp1[_n+5]==edfutbeg1[_n+5] & edfutexp2[_n-1]==edfutbeg1[_n-1] & edfutexp2[_n-2]==edfutbeg1[_n-2] & edfutexp2[_n-5]==edfutbeg1[_n-5] & (month==3 | month==6 | month==9 | month==12),1,0,.)
tab year month if lstofq==1
tab date if year==2003 & lstofq==1
tab date if year==2007 & lstofq==1
replace lstofq = 0 if lstofq[_n-1] == 1
*Correction itself
replace dedfutbeg1= edfutbeg1-edfutbeg2[_n-1] if fstofq ==1
replace dedfutbeg2= edfutbeg2-edfutbeg3[_n-1] if fstofq ==1
replace dedfutbeg3= edfutbeg3-edfutbeg4[_n-1] if fstofq ==1
replace dedfutbeg4= edfutbeg4-edfutbeg5[_n-1] if fstofq ==1
replace dedfutbeg5= edfutbeg5-edfutbeg6[_n-1] if fstofq ==1
replace dedfutexp1= edfutexp1-edfutexp2[_n-1] if lstofq ==1
replace dedfutexp2= edfutexp2-edfutexp3[_n-1] if lstofq ==1
replace dedfutexp3= edfutexp3-edfutexp4[_n-1] if lstofq ==1
replace dedfutexp4= edfutexp4-edfutexp5[_n-1] if lstofq ==1
replace dedfutexp5= edfutexp5-edfutexp6[_n-1] if lstofq ==1
*Drop non-difference variables
* actually kept: for testing uncorrelated with shocks
*forvalues n = 1/6{
*	drop edfutbeg`n' edfutexp`n'
*}
drop fstofq lstofq


* Creating first difference for FED futures
* (and redefine fedfuture as MONTHLY AVERAGE OF the Effective FEDERAL FUNDS RATE= 100 - the price)
forvalues n = 1/6{
	replace fedfutbeg`n' = 100-fedfutbeg`n'
	gen dfedfutbeg`n' = d.fedfutbeg`n'
	label variable dfedfutbeg`n' "FED 30-DAY INTEREST RATE: `n' BEGINNING FUTURE NEARBY - Source: CBOT"

	replace fedfutexp`n' = 100-fedfutexp`n'
	gen dfedfutexp`n' = d.fedfutexp`n'
	label variable dfedfutexp`n' "FED 30-DAY INTEREST RATE: `n' EXPIRATION FUTURE NEARBY - Source: CBOT"
}
*Create first day of the month variable
gen 	fstofm = 1 if day==1
replace fstofm = 1 if day==2 & month[_n-1]==month-1 | month[_n-1]==month+11
replace fstofm = 1 if day==3 & month[_n-1]==month-1 | month[_n-1]==month+11
replace fstofm = 1 if day==4 & month[_n-1]==month-1 | month[_n-1]==month+11
replace fstofm = 1 if day==5 & month[_n-1]==month-1 | month[_n-1]==month+11
replace fstofm = 1 if day==6 & month[_n-1]==month-1 | month[_n-1]==month+11
replace fstofm = 0 if missing(fstofm)
tab year if fstofm==1
*Corrections for first day of month
replace dfedfutexp1 = fedfutexp1-fedfutexp2[_n-1] if fstofm==1
replace dfedfutexp2 = fedfutexp2-fedfutexp3[_n-1] if fstofm==1
replace dfedfutexp3 = fedfutexp3-fedfutexp4[_n-1] if fstofm==1
replace dfedfutexp4 = fedfutexp4-fedfutexp5[_n-1] if fstofm==1
replace dfedfutexp5 = fedfutexp5-fedfutexp6[_n-1] if fstofm==1
replace dfedfutexp6 = fedfutexp6-fedfutexp7[_n-1] if fstofm==1
replace dfedfutbeg1 = fedfutbeg1-fedfutbeg2[_n-1] if fstofm==1
replace dfedfutbeg2 = fedfutbeg2-fedfutbeg3[_n-1] if fstofm==1
replace dfedfutbeg3 = fedfutbeg3-fedfutbeg4[_n-1] if fstofm==1
replace dfedfutbeg4 = fedfutbeg4-fedfutbeg5[_n-1] if fstofm==1
replace dfedfutbeg5 = fedfutbeg5-fedfutbeg6[_n-1] if fstofm==1
drop dfedfutbeg6
*Drop non-difference variables
* actually kept: for testing uncorrelated with shocks
*forvalues n = 1/7{
*	drop fedfutbeg`n' fedfutexp`n'
*}
drop fstofm

/******************************************************************************/
/* Importing Gurkaynak's data and defining FOMC dates                         */
/* (Note :joinby is just an alternative to merge; could have used merge)      */
/******************************************************************************/

joinby date_daily using `dirworking'Gdata, _merge(mG) unmatched(both)
drop mG
* Create variable with Gurkaynak et al. FOMC dates
gen FOMCcheck=cond(!missing(mp1),1,cond(date>=mdy(01,01,1990),0,.),.)
label variable FOMCcheck "FOMC meeting dates reported by Gurkanyak for the period 01/01/1990-06/25/2008"

joinby date_daily using `dirworking'GSSAppendix, _merge(mGSS) unmatched(both)
drop mGSS
* Create variable with Gurkaynak et al. FOMC dates
gen FOMCcheck0=cond(!missing(daywin),1,cond(date>=mdy(01,01,1990),0,.),.)
tab FOMCcheck0 FOMCcheck
list date_daily if FOMCcheck==1 & FOMCcheck0==0
* one date mismatch when both series available: 17 sept 2001
drop FOMCcheck0

* Correction for 18dec1990, and 15oct1998 (use the next day values)
* This is because Gurkaynak et al. use the next day for these dates
* One possible reason is that markets may not have realized Fed action
* until next day. News paper accounts support this for first date. There
* is more ambiguity regarding second date.
* See Matthieu's notes from July 26, 2012 on this (last page)
* In any case, these are both outside of our sample period.
foreach varb in NY3M NY6M NY1 NY2 NY3 NY5 NY10 NF1 NF2 NF3 NF5 NF10 RY2 RY3 RY5 RY10 RF2 RF3 RF5 RF10 ED1M sp500price sp500volume lsp500 VIX lvix{
	replace D`varb' = f.D`varb' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
}

rename dedfutbeg2_m dedfutbeg2
forvalues n = 1/5{
	replace  dedfutexp`n' = f.dedfutexp`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
	replace  dedfutbeg`n' = f.dedfutbeg`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
	replace  dfedfutexp`n' = f.dfedfutexp`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
	replace  dfedfutbeg`n' = f.dfedfutbeg`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
}

forvalues n = 6/6{
	replace  dedfutexp`n' = f.dedfutexp`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
	replace  dedfutbeg`n' = f.dedfutbeg`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
	replace  dfedfutexp`n' = f.dfedfutexp`n' if date==mdy(12,18,1990) |  date==mdy(10,15,1998)
}
rename dedfutbeg2 dedfutbeg2_m

* Checking consistency FOMC and FOMCcheck; restricting to relevant estimation sample
* 2000-2014
tab FOMC FOMCcheck if date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
list date_daily if FOMC==0 & FOMCcheck==1 & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
tab isconfcall if date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
list date_daily if isconfcall & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
tab statement if FOMC==1 & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
list date_daily if statement==0 & FOMC==1 & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
tab unscheduled if date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
list date_daily if unscheduled & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
* 20 dates in FOMC but not FOMCcheck,
* = 6 are confcall + 14 unscheduled
* = 17 without statements + 3 day mismatch
* 5 dates in FOMCcheck but not in FOMC
* = 3 of them are one-day mismatch 16-17aug2007|10-11mar2008|7-8oct2008 (all 3 are unscheduled)
* = 2 of them are annnouncement QE1 and unconventional MP 25nov2008|01dec2008

* First, we correct one-day mismatch in FOMC, opting for Gurkaynak's dates
foreach var in FOMC unscheduled statement {
replace `var'=1 if date_daily==mdy(8,17,2007)|date_daily==mdy(3,11,2008)|date_daily==mdy(10,8,2008)
replace `var'=0 if date_daily==mdy(8,16,2007)|date_daily==mdy(3,10,2008)|date_daily==mdy(10,7,2008)
}
* Second, we keep only dates with statement (we drop them completely so that they do not end up in control group)
drop if statement==0 & FOMC==1 & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
* Third, we drop the 2 QE1 and unconventional MP dates (we drop them completely so that they do not end up in control group)
drop if date_daily==mdy(11,25,2008)|date_daily==mdy(12,1,2008)
* Checking FOMC and FOMCcheck now match:
tab FOMC FOMCcheck if date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)
* Checking all FOMC dates have a statement:
tab statement if FOMC==1 & date_daily>=mdy(1,1,2000) & date_daily <=mdy(4,30,2014)

* 1995-2000
tab FOMC FOMCcheck if date_daily>=mdy(2,1,1995) & date_daily <mdy(1,1,2000)
list date_daily if FOMC==1 & FOMCcheck==0 & date_daily>=mdy(2,1,1995) & date_daily <mdy(1,1,2000)
list date_daily if FOMC==1 & minutes==0 & date_daily>=mdy(2,1,1995) & date_daily <mdy(1,1,2000)
replace statement=1 if minutes==1 & date_daily>=mdy(2,1,1995) & date_daily <mdy(1,1,2000)
drop if statement==0 & FOMC==1 & date_daily>=mdy(2,1,1995) & date_daily <mdy(1,1,2000)
tab FOMC FOMCcheck if date_daily>=mdy(2,1,1995) & date_daily <mdy(1,1,2000)

* 1990-1995
tab FOMC FOMCcheck if date_daily>=mdy(1,1,1990) & date_daily <mdy(2,1,1995)
tab statement if FOMC==1 & date_daily>=mdy(1,1,1990) & date_daily <mdy(2,1,1995)

* Define FOMCused; it is basically FOMC, but with all dates before 1995 set to 0;
gen FOMCused=FOMC
replace FOMCused=0 if date<mdy(02,01,1995)
replace isconfcall=0 if date<mdy(02,1,1995)
drop FOMC FOMCcheck
label variable FOMCused "FOMC meeting date"
* Define unscheduled_all as unscheduled or isconfcall
gen unscheduled_all=1 if unscheduled==1 | isconfcall==1
replace unscheduled_all=0 if unscheduled_all==.
label variable unscheduled_all "Unscheduled meeting or Conference call"

*The purpose of the following lines is to consruct a variable "nextmeeting2" that equals the number of business between the current date and the next FOMC meeting.
*A preliminary step is to exclude the unscheduled meetings, the conference calls and the intermeetings from the list of FOMC meetings in FOMCused
gen regularmeeting = 1 if FOMCused==1 & unscheduled!=1 & isconfcall != 1 & isintermeeting!=1
gsort -date
gen nextmeeting2 = regularmeeting
replace nextmeeting2 = nextmeeting2[_n-1]+1 if missing(nextmeeting2) &  !missing(nextmeeting2[_n-1])
replace nextmeeting2 = nextmeeting2-1
replace nextmeeting2 = nextmeeting2[_n-1]+1 if nextmeeting2==0
label variable nextmeeting2 "the number of business days between the current date and the next FOMC meeting."
sort date

* End sample to the last FOMC meeting in the data
drop if date>mdy(04,30,2014)

/******************************************************************************/
/*                           Define dffr1 and dffr2                           */
/******************************************************************************/

* Define dffr1
*Create variable with # of days in current month
gen nmonth = 31 if month== 1 | month==3 | month==5 | month==7 | month==8 | month==10 | month== 12
replace nmonth = 30 if month== 4 | month==6 | month==9 | month==11
gen yearbiss = year-4*floor(year/4)
replace nmonth = 28 if month==2 & yearbiss!=0
replace nmonth = 29 if month==2 & yearbiss==0
gen adjustment = nmonth/(nmonth-day)
*Correction for the meetings that occur at the end of month
gen next7 = cond((nmonth-day)<8,1,0,.) if !missing(day)
gen adfedfutexp1 = dfedfutexp1*adjustment
*Correction for the meetings that occur at the end of month
gen dffr1 = adfedfutexp1 if next7 ==0
replace dffr1 = dfedfutexp2 if next7==1
label variable dffr1 "Fed fund rate surprise change - daily data - (Using our data)"
drop yearbiss adfedfutexp1

*NOTES:
*Correction for the first day of months:
	* Made when importing FedFuture (see above)
*Correction for 18dec1990, and 15oct1998 (use the next day values)
	* Made in the last adjustements before saving the master
* Create change in fed funds rate future for month of next meeting
* See Socks_Factors_Regs_07_16 for a more elaborate version of this
* bit of code with lots of checks
* The next three lines represent different cases with respect to how many months
* in the future the next FOMC meeting is.
* nextmeeting2 is the number of obervations until the next scheduled meeting

* Define dffr2
*Modifications introduced by Emi below change the definition of nextmeeting2emi for days on which there is no FOMC meeting
gen nextmeeting2emi = nextmeeting2
replace nextmeeting2emi = 32 if FOMCused!=1 & nextmeeting2~=.
label variable nextmeeting2emi "modificatino of nextmeeting2 for days on which there is no FOMC meeting"
gen     dffr2 = (dfedfutexp2-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1)*adjustment[_n+nextmeeting2emi] if (month[_n+nextmeeting2emi]-month[_n]==1 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==11 & year[_n+nextmeeting2emi]-year[_n]==1)
replace dffr2 = (dfedfutexp3-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1)*adjustment[_n+nextmeeting2emi] if (month[_n+nextmeeting2emi]-month[_n]==2 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==10 & year[_n+nextmeeting2emi]-year[_n]==1)
replace dffr2 = (dfedfutexp4-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1)*adjustment[_n+nextmeeting2emi] if (month[_n+nextmeeting2emi]-month[_n]==3 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==9  & year[_n+nextmeeting2emi]-year[_n]==1)
* These next three lines make an adjustment for caes where meeting
* happens close to end of the month.
replace dffr2 = dfedfutexp3 if next7[_n+nextmeeting2emi] & ((month[_n+nextmeeting2emi]-month[_n]==1 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==11 & year[_n+nextmeeting2emi]-year[_n]==1))
replace dffr2 = dfedfutexp4 if next7[_n+nextmeeting2emi] & ((month[_n+nextmeeting2emi]-month[_n]==2 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==10 & year[_n+nextmeeting2emi]-year[_n]==1))
replace dffr2 = dfedfutexp5 if next7[_n+nextmeeting2emi] & ((month[_n+nextmeeting2emi]-month[_n]==3 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]== 9 & year[_n+nextmeeting2emi]-year[_n]==1))
* Next two lines pertain to the cases when there are two meetings in the same month
* This only occurs when the current meeting is an unscheduled meeting and the next
* meeting is a scheduled meeting.
* Matthieu extended GSS formulas for scaling for this case.
* This is never used in our analysis since we only use scheduled meetings.
replace dffr2 = (dfedfutexp1-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1)*adjustment[_n+nextmeeting2emi] if month[_n+nextmeeting2emi]-month[_n]==0
replace dffr2 = dfedfutexp1 if next7[_n+nextmeeting2emi] & month[_n+nextmeeting2emi]-month[_n]==0
label variable dffr2 "Shock to FFR expectations  (Using our data)"

* Get rid of all eurofutures differences now that we have dffr1 and dffr2!
drop dedfutexp* dfedfutbeg*

/******************************************************************************/
/*               Importing intraday data from CME and CBOT                    */
/******************************************************************************/

*Have to merge one-by-one because there are tick data on non-business days (due to construction, refer to sas readme the issue on the first day after holidy), those days have _merge=2
*merge tick
sort date_daily
merge 1:1 date_daily using `dirworking'euro_tick
drop if _merge ==2
drop _merge

merge 1:1 date_daily using `dirworking'fedfund_tick
drop if _merge==2
drop _merge

*merge tick_early
sort date_daily
merge 1:1 date_daily using `dirworking'euro_tick_early
drop if _merge ==2
drop _merge

merge 1:1 date_daily using `dirworking'fedfund_tick_early
drop if _merge==2
drop _merge

*merge tick_wide
sort date_daily
merge 1:1 date_daily using `dirworking'euro_tick_wide
drop if _merge ==2
drop _merge

merge 1:1 date_daily using `dirworking'fedfund_tick_wide
drop if _merge==2
drop _merge

*merge tick_wide_early
sort date_daily
merge 1:1 date_daily using `dirworking'euro_tick_wide_early
drop if _merge ==2
drop _merge

merge 1:1 date_daily using `dirworking'fedfund_tick_wide_early
drop if _merge==2
drop _merge

foreach num of numlist 1(1)5 {
	rename dfedfund_tick`num' dffr`num'_tick
	label variable dffr`num'_tick "tick ffr`num' tight window difference"
	rename dfedfund_tick_early`num' dffr`num'_tick_early
	label variable dffr`num'_tick_early "tick ffr`num' tight early window difference"
	rename dfedfund_tick_wide`num' dffr`num'_tick_wide
	label variable dffr`num'_tick_wide "tick ffr`num' wide window difference"
	rename dfedfund_tick_wide_early`num' dffr`num'_tick_wide_early
	label variable dffr`num'_tick_wide_early "tick ffr`num' wide early window difference"
}

foreach num of numlist 1(1)8 {
	rename deuro_tick`num' ded`num'_tick
	label variable ded`num'_tick "tick ed`num' tight window difference"
	rename deuro_tick_early`num' ded`num'_tick_early
	label variable ded`num'_tick_early "tick ed`num' tight early window difference"
	rename deuro_tick_wide`num' ded`num'_tick_wide
	label variable ded`num'_tick_wide "tick ed`num' tight wide window difference"
	rename deuro_tick_wide_early`num' ded`num'_tick_wide_early
	label variable ded`num'_tick_wide_early "tick ed`num' tight wide early window difference"
}

foreach num of numlist 1(1)6 {
	rename ff`num' dffr`num'_gss
}

foreach num of numlist 1(1)8 {
	rename ed`num' ded`num'_gss
}

foreach num of numlist 1(1)3 {
	rename mp`num' mp`num'_gss
}

* If there are still missing values in the tick data, that means there was
* no trading on that day. We set all missing obs to 0.
foreach num of numlist 1(1)5 {
	replace dffr`num'_tick=0 if dffr`num'_tick==. & year>=1995
	replace dffr`num'_tick_early=0 if dffr`num'_tick_early==. & year>=1995
	replace dffr`num'_tick_wide=0 if dffr`num'_tick_wide==. & year>=1995
	replace dffr`num'_tick_wide_early=0 if dffr`num'_tick_wide_early==. & year>=1995
}
foreach num of numlist 1(1)8 {
	replace ded`num'_tick=0 if ded`num'_tick==. & year>=1995
	replace ded`num'_tick_early=0 if ded`num'_tick_early==. & year>=1995
	replace ded`num'_tick_wide=0 if ded`num'_tick_wide==. & year>=1995
	replace ded`num'_tick_wide_early=0 if ded`num'_tick_wide_early==. & year>=1995
}

* Complete the tick series with Gurkaynak's data
*We complete all tick series (tick, tick_wide, tick_early, tick_wide,early)
*NB: GSS data only available on FOMC days
*There are also 3 specific dates for which we replace our tick data by Gurkaynak's
*8/10/2007, 8/17/2007, and 10/8/2008
foreach n of numlist 1(1)5 {
replace dffr`n'_tick = dffr`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
replace dffr`n'_tick_early = dffr`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
replace dffr`n'_tick_wide = dffr`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
replace dffr`n'_tick_wide_early = dffr`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
}
foreach n of numlist 1(1)8 {
replace ded`n'_tick = ded`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
replace ded`n'_tick_early = ded`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
replace ded`n'_tick_wide = ded`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
replace ded`n'_tick_wide_early = ded`n'_gss if date>mdy(01,01,2013)|date==mdy(8,10,2007)|date==mdy(8,17,2007)|date==mdy(10,8,2008)
}

/******************************************************************************/
/*                 Create dffr1 and dffr2 for tick data                       */
/******************************************************************************/

foreach varv in _tick _tick_early _tick_wide _tick_wide_early{
	gen dffr1`varv'_scaled = dffr1`varv'*adjustment if next7==0
	replace dffr1`varv'_scaled = dffr2`varv' if next7 == 1
	label variable dffr1`varv'_scaled "Fed fund rate surprise change - from our tick by ffr1`varv' data (Scaled)"

	gen dffr2`varv'_scaled = (dffr2`varv'-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1`varv'_scaled)*adjustment[_n+nextmeeting2emi] if (month[_n+nextmeeting2emi]-month[_n]==1 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==11 & year[_n+nextmeeting2emi]-year[_n]==1)
	replace dffr2`varv'_scaled = (dffr3`varv'-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1`varv'_scaled)*adjustment[_n+nextmeeting2emi] if (month[_n+nextmeeting2emi]-month[_n]==2 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==10 & year[_n+nextmeeting2emi]-year[_n]==1)
	replace dffr2`varv'_scaled = (dffr4`varv'-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1`varv'_scaled)*adjustment[_n+nextmeeting2emi] if (month[_n+nextmeeting2emi]-month[_n]==3 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==9  & year[_n+nextmeeting2emi]-year[_n]==1)
	* These next three lines make an adjustment for caes where meeting
	* happens close to end of the month.
	replace dffr2`varv'_scaled = dffr3`varv' if next7[_n+nextmeeting2emi] & ((month[_n+nextmeeting2emi]-month[_n]==1 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==11 & year[_n+nextmeeting2emi]-year[_n]==1))
	replace dffr2`varv'_scaled = dffr4`varv' if next7[_n+nextmeeting2emi] & ((month[_n+nextmeeting2emi]-month[_n]==2 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]==10 & year[_n+nextmeeting2emi]-year[_n]==1))
	replace dffr2`varv'_scaled = dffr5`varv' if next7[_n+nextmeeting2emi] & ((month[_n+nextmeeting2emi]-month[_n]==3 & year[_n+nextmeeting2emi]==year[_n]) | (month[_n]-month[_n+nextmeeting2emi]== 9 & year[_n+nextmeeting2emi]-year[_n]==1))
	* Next two lines pertain to the cases when there are two meetings in the same month
	* This only occurs when the current meeting is an unscheduled meeting and the next
	* meeting is a scheduled meeting.
	* Matthieu extended GSS formulas for scaling for this case.
	* This is never used in our analysis since we only use scheduled meetings.
	replace dffr2`varv'_scaled = (dffr1`varv'-day[_n+nextmeeting2emi]/nmonth[_n+nextmeeting2emi]*dffr1`varv'_scaled)*adjustment[_n+nextmeeting2emi] if month[_n+nextmeeting2emi]-month[_n]==0
	replace dffr2`varv'_scaled = dffr1`varv' if next7[_n+nextmeeting2emi] & month[_n+nextmeeting2emi]-month[_n]==0
	label variable dffr2`varv'_scaled "Fed fund rate surprise change - from our tick by ffr2`varv' data (Scaled)"
	}

* In principle, dffr1_tick_scaled and mp1_gss (idem for 2) should match; do they?
list date_daily dffr1_tick_scaled mp1_gss if FOMCused==1
list date_daily dffr2_tick_scaled mp2_gss if FOMCused==1

drop  nmonth adjustment next7 nextmeeting2emi

save `dirworking'complete, replace

/******************************************************************************/
/*                        Restrict to data that we use                        */
/******************************************************************************/

drop if date<mdy(02,01,1995)

order date_daily day month year dayofweek seqdate ///
FOMCused isconfcall unscheduled unscheduled_all ///
dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 ///
dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide ///
NY1 NY2 NY3 NY5 NY10 NF2 NF3 NF5 NF10 RY2 RY3 RY5 RY10 RF2 RF3 RF5 RF10 ///
DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DNF1 DNF2 DNF3 DNF5 DNF10 DRY2 DRY3 DRY5 DRY10 DRF2 DRF3 DRF5 DRF10 DIF2 DIF3 DIF5 DIF10 ///
Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 ///
Dusswit2 Dusswit3 Dusswit5 Dusswit10 ///
DRY2_2 DRY3_2 DRY5_2 DRY10_2 ///
Dlsp500 Dsp500gurkaynak Dlvix ///
Dn1y_neut Dn2y_neut Dn3y_neut Dn5y_neut Dn10y_neut Dr2y_neut Dr3y_neut Dr5y_neut Dr10y_neut ///
Dn1y_prem Dn2y_prem Dn3y_prem Dn5y_prem Dn10y_prem Dr2y_prem Dr3y_prem Dr5y_prem Dr10y_prem ///
Dn1y_liq Dn2y_liq Dn3y_liq Dn5y_liq Dn10y_liq Dr2y_liq Dr3y_liq Dr5y_liq Dr10y_liq ///
Dn1f_neut Dn2f_neut Dn3f_neut Dn5f_neut Dn10f_neut Dr2f_neut Dr3f_neut Dr5f_neut Dr10f_neut ///
Dn1f_prem Dn2f_prem Dn3f_prem Dn5f_prem Dn10f_prem Dr2f_prem Dr3f_prem Dr5f_prem Dr10f_prem ///
Dn1f_liq Dn2f_liq Dn3f_liq Dn5f_liq Dn10f_liq Dr2f_liq Dr3f_liq Dr5f_liq Dr10f_liq ///
Dn1y_kw Dn2y_kw Dn3y_kw Dn5y_kw Dn10y_kw ///
Dn1y_neut_kw Dn2y_neut_kw Dn3y_neut_kw Dn5y_neut_kw Dn10y_neut_kw ///
Dn1y_prem_kw Dn2y_prem_kw Dn3y_prem_kw Dn5y_prem_kw Dn10y_prem_kw ///
Dn1f_kw Dn2f_kw Dn3f_kw Dn5f_kw Dn10f_kw ///
Dn1f_neut_kw Dn2f_neut_kw Dn3f_neut_kw Dn5f_neut_kw Dn10f_neut_kw ///
Dn1f_prem Dn2f_prem_kw Dn3f_prem_kw Dn5f_prem_kw Dn10f_prem_kw ///
edfutbeg1 edfutbeg2 edfutbeg3 edfutbeg4 edfutbeg5 edfutbeg6 ///
edfutexp1 edfutexp2 edfutexp3 edfutexp4 edfutexp5 edfutexp6 ///
fedfutexp1 fedfutexp2 fedfutexp3 fedfutexp4 fedfutexp5 fedfutexp6 ///
fedfutbeg1 fedfutbeg2 fedfutbeg3 fedfutbeg4 fedfutbeg5 fedfutbeg6 ///

keep date_daily day month year dayofweek seqdate ///
FOMCused isconfcall unscheduled unscheduled_all ///
dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 ///
dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide ///
NY1 NY2 NY3 NY5 NY10 NF2 NF3 NF5 NF10 RY2 RY3 RY5 RY10 RF2 RF3 RF5 RF10 ///
DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DNF1 DNF2 DNF3 DNF5 DNF10 DRY2 DRY3 DRY5 DRY10 DRF2 DRF3 DRF5 DRF10 DIF2 DIF3 DIF5 DIF10 ///
Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 ///
Dusswit2 Dusswit3 Dusswit5 Dusswit10 ///
DRY2_2 DRY3_2 DRY5_2 DRY10_2 ///
Dlsp500 Dsp500gurkaynak Dlvix ///
Dn1y_neut Dn2y_neut Dn3y_neut Dn5y_neut Dn10y_neut Dr2y_neut Dr3y_neut Dr5y_neut Dr10y_neut ///
Dn1y_prem Dn2y_prem Dn3y_prem Dn5y_prem Dn10y_prem Dr2y_prem Dr3y_prem Dr5y_prem Dr10y_prem ///
Dn1y_liq Dn2y_liq Dn3y_liq Dn5y_liq Dn10y_liq Dr2y_liq Dr3y_liq Dr5y_liq Dr10y_liq ///
Dn1f_neut Dn2f_neut Dn3f_neut Dn5f_neut Dn10f_neut Dr2f_neut Dr3f_neut Dr5f_neut Dr10f_neut ///
Dn1f_prem Dn2f_prem Dn3f_prem Dn5f_prem Dn10f_prem Dr2f_prem Dr3f_prem Dr5f_prem Dr10f_prem ///
Dn1f_liq Dn2f_liq Dn3f_liq Dn5f_liq Dn10f_liq Dr2f_liq Dr3f_liq Dr5f_liq Dr10f_liq ///
Dn1y_kw Dn2y_kw Dn3y_kw Dn5y_kw Dn10y_kw ///
Dn1y_neut_kw Dn2y_neut_kw Dn3y_neut_kw Dn5y_neut_kw Dn10y_neut_kw ///
Dn1y_prem_kw Dn2y_prem_kw Dn3y_prem_kw Dn5y_prem_kw Dn10y_prem_kw ///
Dn1f_kw Dn2f_kw Dn3f_kw Dn5f_kw Dn10f_kw ///
Dn1f_neut_kw Dn2f_neut_kw Dn3f_neut_kw Dn5f_neut_kw Dn10f_neut_kw ///
Dn1f_prem Dn2f_prem_kw Dn3f_prem_kw Dn5f_prem_kw Dn10f_prem_kw ///
edfutbeg1 edfutbeg2 edfutbeg3 edfutbeg4 edfutbeg5 edfutbeg6 ///
edfutexp1 edfutexp2 edfutexp3 edfutexp4 edfutexp5 edfutexp6 ///
fedfutexp1 fedfutexp2 fedfutexp3 fedfutexp4 fedfutexp5 fedfutexp6 ///
fedfutbeg1 fedfutbeg2 fedfutbeg3 fedfutbeg4 fedfutbeg5 fedfutbeg6 ///

save `dirworking'master, replace

outsheet using `dirworking'master.csv, comma replace
