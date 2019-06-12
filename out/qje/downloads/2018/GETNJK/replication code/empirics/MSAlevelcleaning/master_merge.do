
/* This file merges together all the relevant series into one big MSA-month panel. 

To get the required input files, see below; in particular need to first run the code in CRISMcleaning.
*/ 

clear all


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

keep if datem>=ym(2004,1) 

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

keep if datem>=ym(2004,1) & datem<=ym(2013,7)

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
keep msa* July12009 July12008 July12007
rename July12009 pop2009 
rename July12008 pop2008 
rename July12007 pop2007

/*MSA code cleaning*/
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484  

tempfile pop
save `pop' 

/********* HMDA *********/

/* This assumes one has annual full HMDA files from the confidential HMDA data available, for 2002-2012
use ${hmda}/2003/full_clean.dta, clear 
keep actdate appdate loanpurp action loanamt occupy state msa
destring loanamt, force replace

append using ${hmda}/2002/full_clean.dta, keep(actdate appdate loanpurp action loanamt occupy income state msa) // no lien indicator prior to 2004

drop if loanpurp==4 // pre-2004, that was the designation for multifamily

forval year= 2004(1)2012  { 
	append using ${hmda}/`year'/full_clean.dta, keep(actdate appdate loanpurp action property loanamt occupy state msa)
}

drop if state==72  // drop PR

keep if action==1 & property!=3 & loanamt<=3000 // about 0.03% of loans have loanamt>3m
compress
save "hmda_orig_2002to2012.dta" */

use "hmda_orig_2002to2012.dta", clear

format appdate %td 
gen datem = mofd(appdate) 
replace datem = datem+1 if day(appdate)>=25 // realign application month to align with QE1 announcement, as described in Fig A5
gen year = year(dofm(datem))

keep if year >=2004 & year<2013

/*MSA code cleaning*/
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244  
replace msa=14460 if msa==40484  

replace msa = 37764 if msa == 21604 // 21604 becomes 37764 in Dec 2006 -- see http://www.ffiec.gov/geocode/help1.aspx 
replace msa = 42680 if msa == 46940 // similar change beginning in 2006 (http://www.ffiec.gov/hmda/pdf/06news.pdf)
 
gen refiamt = loanamt 
replace refiamt = 0 if loanpurp==1 

drop if datem>=ym(2013,1)

g refi_code = refiamt<. & refiamt>0
g loan_code = loanamt<. & loanamt>0

fcollapse (sum) hmda_total_loanvol=loanamt hmda_refi_loanvol = refiamt ///
	 (sum) hmda_count_loans=loan_code hmda_count_refi  = refi_code ///
	 (mean) hmda_mean_amt=loanamt ///
	 (median) hmda_med_amt=loanamt, by(msa datem) 
 
tabstat hmda_refi_loanvol if msa==99999 |msa==0 | msa==., by(datem) stat(sum)
	 
drop if msa >0&msa <10000 // old MSA codes, appear in 2004m1	  

drop if msa==99999 |msa==0 | msa==.

unique msa // 386 MSAs in HMDA
groups msa , select(20) order(l) 
/* 5 of them not there in all months:
- 16020,31740,31860 only get introduced in Nov 2008 (http://www.ffiec.gov/geocode/help1.aspx). Drop these b/c would overstate increase in lending.
- 29420 and 37380 got introduced in Dec 2006 (same link). Keep but set everything to missing for earlier months
*/
drop if msa==16020 | msa==31740 | msa==31860 /*become msa's in 2009 */
foreach x of varlist hmda* {
replace `x' = . if datem<m(2006m12) & inlist(msa,29420,37380)
}
	 
merge 1:1 msa datem using `HPI_msa' , gen(merge_HPI) // unmerged HPIs: micro areas
merge m:1 datem using `FRM', gen(merge_FRM) // 2 months prior to 2004
merge m:1 msa using `pop', gen(merge_POP) // 31920 and 48220 have no population info, but they are micros

merge 1:1 msa datem using input/unemp_SA, gen(merge_UR) // prepared in prelim_code/unemp_SA.do 

tab merge_UR if merge_HPI==3

groups datem if merge_HPI==3&merge_FRM==3&merge_POP==3&merge_UR==3, select(20) order(l) // 381 MSAs; in 2004, 29420 and 37380 do not exist yet

keep if merge_HPI==3&merge_FRM==3&merge_POP==3&merge_UR==3

drop merge*

save temp/master.tmp, replace 

/********* AUTO REGISTRATION DATA CLEANING - ZIP TO MSA **********/
use ../CRISMcleaning/input/zipTOmsadiv.dta
tempfile msa
save `msa' 

use input/ZMpolkautosales_20130812, clear  // Polk data, obtained via Booth / Amir Sufi

drop if inlist(zipcode,74153,74117) // from data provider: "These are where a large rental car company registers all of its cars, so recommend excluding those."

tostring zipcode, gen(prop_zip)
replace prop_zip = "0"+prop_zip if length(prop_zip)==4
replace prop_zip = "00"+prop_zip if length(prop_zip)==3
replace prop_zip = "000"+prop_zip if length(prop_zip)==2
replace prop_zip = "0000"+prop_zip if length(prop_zip)==1

merge m:1 prop_zip using `msa'  

rename month datem 
fcollapse (sum) autosales, by(msa datem) 

keep if datem>=ym(2004,1) & datem<ym(2013,1)
drop if datem==.

merge 1:1 msa datem using temp/master.tmp

/*there are 381 possible MSA's and 586 micropolitan statistical areas. Drop the micros*/
drop if _m==1
drop _m
save temp/master.tmp, replace



/*MSA Names*/
merge m:1 msa using "input/msa_names", gen(name_merge) 

// ACS number of households and mortgages:
merge m:1 msa using "input/ACS_nummtgs_byMSA.dta"
drop if _m==2
drop _m
merge m:1 msa using "input/ACS_nummtgs_2000_byMSA.dta"
drop if _m==2
drop _m

// other demographics (from ACS):
merge m:1 msa using "input/demographics_byMSA.dta"
drop if _m==2
drop _m

save temp/master.tmp, replace


// CCP balances (prepared in prelim_code/FMs_CES_HELOCs_by_MSA.do):
use input/fm_bal_fullccp.dta, keep(1 3) nogen
merge 1:1 msa dateq using input/ces_bal_fullccp.dta, keep(1 3) nogen
merge 1:1 msa dateq using input/heloc_bal_fullccp.dta, keep(1 3) nogen

g housing_bal_fullccp = fm_bal_fullccp + ces_bal_fullccp + heloc_bal_fullccp

merge 1:1 msa datem using temp/master.tmp
format datem %tm
egen x = max(_m), by(msa)
keep if x==3
drop x _m

// interpolate
foreach x of varlist fm_bal housing_bal heloc_bal *fullccp {
xtset msa datem
replace `x' =. if `x' ==0
ipolate `x' datem, gen(x) by(msa)
replace `x' =x if `x'==. & x<.
drop x
}


save temp/master.tmp, replace


// CRISM: refi propensities & cashout shares -- NEED TO FIRST RUN THE CODE IN CRISMcleaning

use ../CRISMcleaning/output/msa_refi_panel.dta, clear 
cap drop _m
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484
rename msano msa

cap drop  *incg* *jumbo*
cap drop frm_refi refi_old_bal_frm refi_new_bal_frm l_frm_num_out l_frm_bal_out  *arm*
drop as_of_mon_id_datem  

merge 1:1 msa datem using temp/master.tmp

tab _m if datem==m(2008m12) [aw=l_bal_out] // 91.75% of balances are in MSAs 

drop if _m==1
drop _m

save temp/master.tmp, replace


// CLTV distributions
use ../CRISMcleaning/temp/msa200811_ltvs_zip.dta, clear 

cap g datem=m(2008m11)
renvars CLTV_avg_200811, subst(200811 200701) // just for append

append using ../CRISMcleaning/temp/msa200701_ltvs_zip.dta
replace datem=m(2007m1) if datem==.
keep msa datem pct*0_aw CLTV_avg CLTV_p50 
renvars CLTV_avg CLTV_p50, subst(_200701)

rename msano msa

replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

merge 1:1 msa datem using temp/master.tmp, keep(2 3) nogen

// Various other information such as jumbo shares etc.:
save temp/master.tmp, replace

foreach x in arm_share_msa_panel fico_msa_panel investor_msa_panel jumbo_msa_panel loan_age_msa_panel orig_ltv_msa_panel ///
 rates_msa_panel seconds_share_msa_panel prin_bal_msa_panel {
use "../CRISMcleaning/output/`x'.dta", clear
di "`x'"
de, full
rename msano msa
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

merge 1:1 msa datem using temp/master.tmp, keep(2 3) nogen
save temp/master.tmp, replace
}



// IRS income (see prelim_code/irs_clean.do for how it is built)
use input/msa_year_income_all, clear
drop a00*
rename n1 nr_irsret
reshape wide nr_irsret avg_*, i(msa) j(year)
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484


merge 1:m msa using temp/master.tmp, keep(2 3) nogen

// labels
do master_labels.do

drop *_merge

replace dateq = qofd(dofm(datem))
format dateq %tq
format datem %tm

save output/master.dta, replace
rm temp/master.tmp
