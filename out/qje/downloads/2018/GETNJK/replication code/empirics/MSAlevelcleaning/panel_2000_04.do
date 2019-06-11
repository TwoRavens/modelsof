/*
Creates an MSA level panel with some key variables over 2000-2004 (for analysis looking at 01-03 recession).

Note: file paths will need to be adjusted.
*/

clear all
set more off

/*********HPI DATA CLEANING - CBSA*********/
use  input/hpi_dw_cbsa_201502.dta, clear  
// same as in 0_clean_hpi.do on CRISM side; code here applies to version of the data downloaded from Fed system's RADAR data warehouse. 

tostring as_of_mon_id, gen(temp) 
gen year = substr(temp,1,4)
gen month = substr(temp,5,2)
destring year month, replace 
gen datem = ym(year, month)
format datem %tm 

keep if tier_code==11
keep home_price_index datem cbsa_code 
rename home_price_index hpi
rename cbsa_code msa 

/*MSA code cleaning*/
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484  

keep if datem>=ym(2000,1) & datem<=ym(2004,12)

tempfile HPI_msa
save `HPI_msa'

/*********FRMrate - national*********/
freduse MORTG, clear
gen datem = mofd(daten)
format datem %tm 
rename MORTG FRM30rate
drop date daten

tsset datem
g FRMrate_change = FRM30rate-l.FRM30rate

keep if datem>=ym(2000,1) & datem<=ym(2004,12) 

tempfile FRM
save `FRM' 

/*************ANNUAL POPULATION - msa level************/
import excel using input/CBSA-EST2009-01.xls, cellrange(A4:O977) first clear
rename A msa
destring msa B, replace 
rename C msa_title 
replace msa = B if B!=. /*drop subsections within MSA, shows populations for MSA-subsections*/
drop B Estimatesbase Census 
drop if msa==. 
/*drop overarching MSA for large MD's*/
drop if inlist(msa, 14460, 16980, 19100, 19820, 31100, 33100, 35620, 37980, 41860, 42660, 47900) 
keep msa* July12000
rename July12000 pop2000
keep msa* pop* 

/*MSA code cleaning*/
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

tempfile pop
save `pop' 

/********* HMDA *********/
/* This assumes one has annual full HMDA files from the confidential HMDA data available, for 2000-2004

forval year= 2000(1)2003  { 
	use ${hmda}/`year'/full_clean.dta, clear
	keep appdate loanpurp action loanamt occupy income state msa
	destring income loanamt, replace force 
	g actyear=`year'
	tempfile yr`year'
	save `yr`year'', replace 
}

local year = 2004
	use ${hmda}/`year'/full_clean.dta, clear
	keep appdate loanpurp action loanamt occupy income state msa property // introduced in 2004
	destring income loanamt, replace force 
	g actyear=`year'
	tempfile yr`year'
	save `yr`year'', replace 

use `yr2000', clear 
append using `yr2001' 
append using `yr2002' 
append using `yr2003' 
append using `yr2004' 

drop if state==72 /*drop PR*/
keep if action==1 & loanamt<=3000 
keep if loanpurp>=1 & loanpurp<=3 & property!=3 // drop multifamily (loanpurp=4 in years up to 2003; property=3 from 2004 onwards

save "${project}/data/created/HMDA2000_2004", replace
*/

use "${project}/data/created/HMDA2000_2004", clear 

format appdate %td 
gen datem = mofd(appdate) 
//replace datem = datem+1 if day(appdate)>=25
gen year = year(dofm(datem))

keep if year >=2000 & year<2005
tostring state, gen(fips)
replace fips = "0"+fips if length(fips)==1
tempfile hmda 
save `hmda', replace 

***************************************************
/*MSA code cleaning*/
import excel "input/MSACodes_new_0117.xlsx", sheet("MSACodes_new_0117") firstrow clear
drop if substr(MSAgeo, length(MSAgeo)-2, length(MSAgeo))==" PR"
drop if I!=MSA00
drop I L
egen saiznr = rowmin(saiz saizfull) /* NECTA and Boston area issue*/
replace MSA03 = MSA03o if MSA03o<. 
keep MSA03 MSA00 
duplicates drop 
rename MSA03 msa 
replace msa=22520 if msa==22460 
replace msa=45640 if msa==30540 
replace msa=14600 if msa==42260 
replace msa=45104 if msa==42660 
replace msa=46940 if msa==42680 
replace msa=37764 if msa==21604 
replace msa=14460 if msa==40484

preserve 
	import excel using input/CBSA-EST2009-01.xls, cellrange(A4:O977) first clear
	rename A msa
	destring msa B, replace 
	rename C msa_title 
	replace msa = B if B!=. /*drop subsections within MSA, shows populations for MSA-subsections*/
	drop B Estimatesbase Census 
	drop if msa==. 
	/*drop overarching MSA for large MD's*/
	drop if inlist(msa, 14460, 16980, 19100, 19820, 31100, 33100, 35620, 37980, 41860, 42660, 47900) 
	keep msa* July12000
	rename July12000 pop2000
	keep msa* pop* 
	/*MSA code cleaning*/

	tempfile crosswalk
	save `crosswalk' 
restore
merge m:1 msa using `crosswalk'
keep if _m==3
drop _m 

bysort MSA00: egen maxpop = max(pop2000)

keep if maxpop==pop2000
drop maxpop pop msa_title

replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484
replace msa=22520 if msa==22460 
replace msa=24460 if msa==30540
replace msa=45104 if msa==42660 
replace msa=37764 if msa==21604 

rename msa msa03
rename MSA00 msa 
drop if msa==.

merge 1:1 msa using input/msa_pop99 // Stata version of https://www.census.gov/popest/data/metro/totals/1990s/tables/MA-99-03b.txt 

replace msa03 = 49340 if msa==2600
replace msa03 = 15764 if msa==4160
replace msa03 = 14460 if msa==6450 // see below 
drop if msa03==. // _m=2 -- CMSA with sub-divisions  

keep msa* pop99
egen x = sum(pop99), by(msa03)
replace pop99 = x
drop x

	*****************************************

merge 1:m msa using `hmda' 
 tab actyear _merge // in 2004 no matches because in that year we have the new codes already
 
tab msa if actyear <2004&_m<3 // 3 "old" MSAs don't have a match: 2600, 4160, 6450. These are all NECTAs.

replace msa03 = 49340 if msa==2600 // fitchburg-leominster belong to worcester -- http://www.mass.gov/hed/docs/dhcd/hd/lihtc/metrolst.pdf
replace msa03 = 15764 if msa==4160 // 4160 is Lawrence (http://www.mass.gov/hed/docs/dhcd/hd/lihtc/metrolst.pdf) which is in Essex county which belongs to Cambridge MD -- see http://en.wikipedia.org/wiki/Greater_Boston#Metropolitan_Statistical_Area
replace msa03 = 14460 if msa==6450 // Rochester-Portsmouth NH (http://www.census.gov/population/estimates/metro-city/cencty.txt) -- these are in Rockingham County-Strafford County MD
// note: there are no other old msa mapping into new msa 14460 
 
replace msa = msa03 if msa03<.

merge m:1 msa datem using `HPI_msa' , gen(merge_HPI)
merge m:1 datem using `FRM', gen(merge_FRM)
merge m:1 msa using `pop', gen(merge_POP)

gen hmda_msa = (loanamt!=.)
bysort msa:  egen xx        = max(hmda_msa) if actyear<2004
bysort msa:  egen hmda_msa2 = max(xx) 

         unique msa if hmda_msa2==. // 76 MSAs will be dropped
         unique msa if hmda_msa2<.  // 316 MSAs (of which 2 are 0 and 9999 so should be dropped)
 
drop if merge_HPI==2 | hmda_msa2==. | merge_POP==2


/*drops regions for which there is no geographic match to HPI, 
this represents 367541 observations with no state info in HMDA (state=="00") 
*/
drop if msa==99999 |msa==0 | msa==. | msa==9999  

gen refiamt = loanamt 
replace refiamt = 0 if loanpurp==1 

drop if datem>=ym(2005,1)

g refi_code = refiamt<. & refiamt>0
g loan_code = loanamt<. & loanamt>0

collapse (sum)  total_loanvol=loanamt refi_HI_loanvol = refiamt ///
	 (sum) count_loans=loan_code count_refi_HI = refi_code ///
	 (mean) hpi=home_price_index FRM30rate FRMrate_change pop2000 pop99 ///
	 (mean) mean_inc=income mean_amt=loanamt ///
	 (median) med_inc=income med_amt=loanamt, by(msa datem) fast

merge 1:m msa datem using input/unemp_SA, gen(_merge_UR) // 21420,  27460 don't have unempl rates because these are both micro areas (presumably got re-classified from metro to micro)

tab msa if _merge_UR ==1&_merge==3

keep if _merge==3 & _merge_UR==3
drop _merge*

tab datem // 312 MSAs left 

merge m:1 msa using "input/ACS_nummtgs_2000_byMSA.dta", keep(1 3) nogen
g ratio = (pop2000 / 276059)  / (pop99 / 273642) 
// if this is <1, means that have_mort_2000 is likely too low and the refi prop is too high. National totals from http://www.census.gov/popest/data/national/totals/1990s/tables/nat-total.txt (Nov to Nov)
replace have_mort_2000 = have_mort_2000 / ratio if datem<=m(2003m12) 

save output/monthly_panel_00_04.dta, replace  

