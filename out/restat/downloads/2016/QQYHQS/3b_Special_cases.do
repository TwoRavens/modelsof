** PAUSCHALBESTEUERTE: SET UP THE DATA **
// goal: set up a data set with only the expenditre based taxpayers
// all years (1971-2010)
// data accessed at the ESTV in Bern
// date: June 2015
// author: Isabel Martinez

* global ESTVpath "\\???\???\???\???\???\???"
* global mypath "$ESTVpath\Sinergia\Isabel_Martinez"

clear
cap clear matrix
cap log close
set more off
set memory 1g

version 11.1

* global macros for canton names
global cant1 "ZH"
global cant2 "BE"
global cant3 "LU"
global cant4 "UR"
global cant5 "SZ"
global cant6 "OW"
global cant7 "NW"
global cant8 "GL"
global cant9 "ZG"
global cant10 "FR"
global cant11 "SO"
global cant12 "BS"
global cant13 "BL"
global cant14 "SH"
global cant15 "AR"
global cant16 "AI"
global cant17 "SG"
global cant18 "GR"
global cant19 "AG"
global cant20 "TG"
global cant21 "TI"
global cant22 "VD"
global cant23 "VS"
global cant24 "NE"
global cant25 "GE"
global cant26 "JU"


* Loop over all 26 cantons
forvalues n=1(1)26 {
use snp_stacd snpsteink snpreink snpstbetr snpbercd snp_vpenr snp_ahvnr gdekannr using "$ESTVpath\Sinergia\VP_all_per_cant\NP_allperiods_`n'.dta", clear
// note: this includes all tax periods from VP 1973/74 onwards, i.e. incomes realized 1971/72

* Recode the periods as stored at the ESTV to convert them easily into years
foreach y in 1 2 3 4 5 6 7 8 9 10 {
replace snp_vpenr=`y'+36 if snp_vpenr==`y'
}
replace snp_vpenr=36 if snp_vpenr==35
replace snp_vpenr=35 if snp_vpenr==34
replace snp_vpenr=34 if snp_vpenr==33
replace snp_vpenr=33 if snp_vpenr==32

label define years 17 `"1973/74"', modify
label define years 18 `"1975/76"', modify
label define years 19 `"1977/78"', modify
label define years 20 `"1979/80"', modify
label define years 21 `"1981/82"', modify
label define years 22 `"1983/84"', modify
label define years 23 `"1985/86"', modify
label define years 24 `"1987/88"', modify
label define years 25 `"1989/90"', modify
label define years 26 `"1991/92"', modify
label define years 27 `"1993/94"', modify
label define years 28 `"1995/96"', modify
label define years 29 `"1995"', modify
label define years 30 `"1996"', modify
label define years 31 `"1997/98"', modify
label define years 32 `"1997"', modify
label define years 33 `"1998"', modify
label define years 34 `"1999/2000"', modify
label define years 35 `"1999"', modify
label define years 36 `"2000"', modify
label define years 37 `"2001"', modify
label define years 38 `"2002"', modify
label define years 39 `"2003"', modify
label define years 40 `"2004"', modify
label define years 41 `"2005"', modify
label define years 42 `"2006"', modify
label define years 43 `"2007"', modify
label define years 44 `"2008"', modify
label define years 45 `"2009"', modify
label define years 46 `"2010"', modify

label values snp_vpenr years


* Generate a proper years variable (year== year when income was realized)
// this generates a proper years variable, ie, year when income was realized
// note: make sure periods have been recoded first! 

gen year=.
replace year=2010 if snp_vpenr==46 
replace year=2009 if snp_vpenr==45 
replace year=2008 if snp_vpenr==44 
replace year=2007 if snp_vpenr==43 
replace year=2006 if snp_vpenr==42 
replace year=2005 if snp_vpenr==41 
replace year=2004 if snp_vpenr==40 
replace year=2003 if snp_vpenr==39 
replace year=2002 if snp_vpenr==38 
replace year=2001 if snp_vpenr==37 

replace year=2000 if snp_vpenr==36  & (gdekannr==1 | gdekannr==20 | gdekannr==12)
replace year=1999 if snp_vpenr==35  & (gdekannr==1 | gdekannr==20 | gdekannr==12)
replace year=1998 if snp_vpenr==33  & gdekannr==12 
replace year=1997 if snp_vpenr==32  & gdekannr==12
replace year=1996 if snp_vpenr==30  & gdekannr==12 
replace year=1995 if snp_vpenr==29  & gdekannr==12 
replace year=1997 if snp_vpenr==34  & gdekannr!=1 & gdekannr!=20 & gdekannr!=12 

replace year=1995 if snp_vpenr==31  
replace year=1993 if snp_vpenr==28
replace year=1991 if snp_vpenr==27
replace year=1989 if snp_vpenr==26
replace year=1987 if snp_vpenr==25
replace year=1985 if snp_vpenr==24
replace year=1983 if snp_vpenr==23
replace year=1981 if snp_vpenr==22
replace year=1979 if snp_vpenr==21
replace year=1977 if snp_vpenr==20
replace year=1975 if snp_vpenr==19
replace year=1973 if snp_vpenr==18
replace year=1971 if snp_vpenr==17  

label var year "year when income was realized"



* KEEP ONLY THE EXPENDITURE-BASED TAXED
keep if snp_stacd==3


* save a tempfile
tempfile `n'_top
save "``n'_top'"
}

* stack data together
use `1_top', clear

forvalues n=2(1)26 {
  append using "``n'_top'"
}  

sort year gdekannr

note: Individual data of the expenditure-based tax units (Pauschalbesteuerte)
save "$mypath\Pauschalbesteuerte\pauschalierte_71-2010.dta", replace

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

** AUSSCHEIDUNGEN: WO SATZBESTIMMEND != STEUERBAR: SET UP THE DATA **
// goal: set up a data set with only taxpayers whose rate-determining income != taxable income due to, e.g. income from abroad
// all years (1971-2010)
// date: July 2015
// author: Isabel Martinez


clear
cap clear matrix
cap log close
set more off
set memory 1g

version 11.1

* global macros for canton names
global cant1 "ZH"
global cant2 "BE"
global cant3 "LU"
global cant4 "UR"
global cant5 "SZ"
global cant6 "OW"
global cant7 "NW"
global cant8 "GL"
global cant9 "ZG"
global cant10 "FR"
global cant11 "SO"
global cant12 "BS"
global cant13 "BL"
global cant14 "SH"
global cant15 "AR"
global cant16 "AI"
global cant17 "SG"
global cant18 "GR"
global cant19 "AG"
global cant20 "TG"
global cant21 "TI"
global cant22 "VD"
global cant23 "VS"
global cant24 "NE"
global cant25 "GE"
global cant26 "JU"


* Loop over all 26 cantons
forvalues n=1(1)26 {
use snp_stacd snpsteink snpreink snpstbetr snpbercd snp_vpenr snp_ahvnr gdekannr using "$ESTVpath\Sinergia\VP_all_per_cant\NP_allperiods_`n'.dta", clear
// note: this includes all tax periods from VP 1973/74 onwards, i.e. incomes realized 1971/72

* Recode the periods as stored at the ESTV to convert them easily into years
foreach y in 1 2 3 4 5 6 7 8 9 10 {
replace snp_vpenr=`y'+36 if snp_vpenr==`y'
}
replace snp_vpenr=36 if snp_vpenr==35
replace snp_vpenr=35 if snp_vpenr==34
replace snp_vpenr=34 if snp_vpenr==33
replace snp_vpenr=33 if snp_vpenr==32

label define years 17 `"1973/74"', modify
label define years 18 `"1975/76"', modify
label define years 19 `"1977/78"', modify
label define years 20 `"1979/80"', modify
label define years 21 `"1981/82"', modify
label define years 22 `"1983/84"', modify
label define years 23 `"1985/86"', modify
label define years 24 `"1987/88"', modify
label define years 25 `"1989/90"', modify
label define years 26 `"1991/92"', modify
label define years 27 `"1993/94"', modify
label define years 28 `"1995/96"', modify
label define years 29 `"1995"', modify
label define years 30 `"1996"', modify
label define years 31 `"1997/98"', modify
label define years 32 `"1997"', modify
label define years 33 `"1998"', modify
label define years 34 `"1999/2000"', modify
label define years 35 `"1999"', modify
label define years 36 `"2000"', modify
label define years 37 `"2001"', modify
label define years 38 `"2002"', modify
label define years 39 `"2003"', modify
label define years 40 `"2004"', modify
label define years 41 `"2005"', modify
label define years 42 `"2006"', modify
label define years 43 `"2007"', modify
label define years 44 `"2008"', modify
label define years 45 `"2009"', modify
label define years 46 `"2010"', modify

label values snp_vpenr years


* Generate a proper years variable (year== year when income was realized)
// this generates a proper years variable, ie, year when income was realized
// note: make sure periods have been recoded first! 

gen year=.
replace year=2010 if snp_vpenr==46 
replace year=2009 if snp_vpenr==45 
replace year=2008 if snp_vpenr==44 
replace year=2007 if snp_vpenr==43 
replace year=2006 if snp_vpenr==42 
replace year=2005 if snp_vpenr==41 
replace year=2004 if snp_vpenr==40 
replace year=2003 if snp_vpenr==39 
replace year=2002 if snp_vpenr==38 
replace year=2001 if snp_vpenr==37 

replace year=2000 if snp_vpenr==36  & (gdekannr==1 | gdekannr==20 | gdekannr==12)
replace year=1999 if snp_vpenr==35  & (gdekannr==1 | gdekannr==20 | gdekannr==12)
replace year=1998 if snp_vpenr==33  & gdekannr==12 
replace year=1997 if snp_vpenr==32  & gdekannr==12
replace year=1996 if snp_vpenr==30  & gdekannr==12 
replace year=1995 if snp_vpenr==29  & gdekannr==12 
replace year=1997 if snp_vpenr==34  & gdekannr!=1 & gdekannr!=20 & gdekannr!=12 

replace year=1995 if snp_vpenr==31  
replace year=1993 if snp_vpenr==28
replace year=1991 if snp_vpenr==27
replace year=1989 if snp_vpenr==26
replace year=1987 if snp_vpenr==25
replace year=1985 if snp_vpenr==24
replace year=1983 if snp_vpenr==23
replace year=1981 if snp_vpenr==22
replace year=1979 if snp_vpenr==21
replace year=1977 if snp_vpenr==20
replace year=1975 if snp_vpenr==19
replace year=1973 if snp_vpenr==18
replace year=1971 if snp_vpenr==17  

label var year "year when income was realized"



* KEEP ONLY THE AUSSCHEIDUNGEN
keep if snp_stacd==4


* save a tempfile
tempfile `n'_top
save "``n'_top'"
}

* stack data together
use `1_top', clear

forvalues n=2(1)26 {
  append using "``n'_top'"
}  

sort year gdekannr

save "$mypath\Pauschalbesteuerte\ausscheidungen_71-2010.dta", replace

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

* EXTRACT THE THRESHOLDS TO BELONG TO A TOP GROUP*
clear 
cap clear matrix
set more off

use  "$thepath/4a_TopIncomeShares_CH_1981-2010.dta", clear
keep if cant==0
keep year ts90 ts95 ts99 ts995 ts999 ts9999
drop if ts90==.

reshape long ts, i(year) j(group) 
reshape wide ts, i(group) j(year)

gen _k = 1 if group==90
replace _k = 2 if group==95
replace _k = 3 if group==99
replace _k = 4 if group==995
replace _k = 5 if group==999
replace _k = 6 if group==9999

label define K 0 `"below top 10%"', modify
label define K 1 `"top 10%-top5%"', modify
label define K 2 `"top 5%-top1%"', modify
label define K 3 `"top 1%-top0.5%"', modify
label define K 4 `"top 0.5%-top0.1%"', modify
label define K 5 `"top 0.1%-top0.01%"', modify
label values _k K

tempfile ts_19812010
save "`ts_19812010'"

// also add the years 1971-80
// this dataset is generetad by do-file "topshares_1971-80.do"
use "$thepath/4c_TopIncomeShares_CH_1971-80.dta" , clear
keep year ts90 ts95 ts99 ts995 ts999 ts9999

reshape long ts, i(year) j(group) 
reshape wide ts, i(group) j(year)

gen _k = 1 if group==90
replace _k = 2 if group==95
replace _k = 3 if group==99
replace _k = 4 if group==995
replace _k = 5 if group==999
replace _k = 6 if group==9999

label define K 0 `"below top 10%"', modify
label define K 1 `"top 10%-top5%"', modify
label define K 2 `"top 5%-top1%"', modify
label define K 3 `"top 1%-top0.5%"', modify
label define K 4 `"top 0.5%-top0.1%"', modify
label define K 5 `"top 0.1%-top0.01%"', modify
label values _k K

merge 1:1 group using "`ts_19812010'", nogen

saveold "$thepath/thresholds_71-2010.dta", version(12) replace
*save "$mypath\Pauschalbesteuerte\thresholds_71-2010.dta", replace // this is the path @ ESTV


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

* ANALYZE THE EXPENDITURE-BASED (PAUSCHALBESTEUERTE)*
// task: assing them to a top group, then collapse the dataset and count them
// author: Isabel Martinez
// date: June 2015
clear 
cap clear matrix
set more off


use "$mypath\Pauschalbesteuerte\pauschalierte_71-2010.dta", clear


* Express the income values in CHF instead of in 100.- Sfr.
foreach var in snpsteink snpreink {
replace `var'=`var'*100
}
format snp_ahvnr %13.0g

* GENERATE PERCENTILE-INDICATOR
*add the CH top group thresholds per year, real values
sort snp_vpenr
gen _k=.
forvalues z=1/6 {
replace _k= `z' if _n==`z'
}
replace _k=_k-1

 merge m:1 _k using "$mypath\Pauschalbesteuerte\thresholds_71-2010.dta", nogenerate 

format snpreink snpstbetr %10.0g //to increase precision
recast double snpreink snpstbetr //to increase precision (before float, now double)

gen top=.
levelsof year, local(levels) 
foreach x of local levels { 
* generate the group indicator for gross income
xtile group`x'=snpreink if year==`x', cutpoints(ts`x')
replace top=group`x' if year==`x'
}

label define K 0 `"below top 10%"', modify
label define K 1 `"top 10%-top5%"', modify
label define K 2 `"top 5%-top1%"', modify
label define K 3 `"top 1%-top0.5%"', modify
label define K 4 `"top 0.5%-top0.1%"', modify
label define K 5 `"top 0.1%-top0.01%"', modify
label values _k K

label define T 1 `"below top 10%"', modify
label define T 2 `"top 10%-top5%"', modify
label define T 3 `"top 5%-top1%"', modify
label define T 4 `"top 1%-top0.5%"', modify
label define T 5 `"top 0.5%-top0.1%"', modify
label define T 6 `"top 0.1%-top0.01%"', modify
label define T 7 `"above top 0.01%"', modify
label values top T

sort year gdekannr

* RESULTS * RESULTS * RESULTS * RESULTS * RESULTS * RESULTS * RESULTS * RESULTS *

// how many Pauschalbesteuerte in each group over period 1971-2010?
	tabout top using "$mypath\Pauschalbesteuerte\total_pschbst_in_topgroups", replace  style(csv) format(0c)
// how many Pauschalbesteuerte in each group and year?
	tabout year top using "$mypath\Pauschalbesteuerte\total_pschbst_in_topgroups_per_yr", replace  style(csv) format(0c)
// how many Pauschalbesteuerte in each group and canton over period 1971-2010?
	tabout gdekannr top using "$mypath\Pauschalbesteuerte\total_pschbst_in_topgroups_per_cant", replace  style(csv) format(0c)

// collapse and save dataset
preserve
 collapse (count) N=snp_ahvnr , by(year top)

 drop if top==.
 reshape wide N, i(year) j(top)
 
 egen N0 = rowtotal(N1-N7)
 label var N0	"All taxpayers"
 label var N1	"Below top 10%"
 label var N2	"Top 10%-5%"
 label var N3	"Top 5%-1%"
 label var N4	"Top 1%-0.5%"
 label var N5	"Top 0.5%-0.1%"
 label var N6	"Top 0.1%-0.01%"
 label var N7	"Above top 0.01%"
			
 rename N0	exp_0
 rename N1	exp_1
 rename N2	exp_2
 rename N3	exp_3
 rename N4	exp_4
 rename N5	exp_5
 rename N6	exp_6
 rename N7	exp_7
 
 save "$mypath\Pauschalbesteuerte\pauschalbesteuerte_1971-2010_by_group", replace
restore

*************************************************************************************************************************************

* ANALYZE THE OTHER SPECIAL CASES (AUSSCHEIDUNGEN)*
// task: assing them to a top group, then collapse the dataset and count them
// author: Isabel Martinez
// date: June 2015

clear 
cap clear matrix
set more off


use "$mypath\Pauschalbesteuerte\ausscheidungen_71-2010.dta", clear

* Express the income values in CHF instead of in 100.- Sfr.
foreach var in snpsteink snpreink {
replace `var'=`var'*100
}
format snp_ahvnr %13.0g

* GENERATE PERCENTILE-INDICATOR

*add the CH top group thresholds per year, real values
sort snp_vpenr
gen _k=.
forvalues z=1/6 {
replace _k= `z' if _n==`z'
}
replace _k=_k-1

merge m:1 _k using "$mypath\Pauschalbesteuerte\thresholds_71-2010.dta", nogenerate 
format snpreink snpstbetr %10.0g //to increase precision
recast double snpreink snpstbetr //to increase precision (before float, now double)

gen top=.
levelsof year, local(levels) 
foreach x of local levels { 
* generate the group indicator for gross income
display "year `x'"
xtile group`x'=snpreink if year==`x', cutpoints(ts`x')
replace top=group`x' if year==`x'
}

label define K 0 `"below top 10%"', modify
label define K 1 `"top 10%-top5%"', modify
label define K 2 `"top 5%-top1%"', modify
label define K 3 `"top 1%-top0.5%"', modify
label define K 4 `"top 0.5%-top0.1%"', modify
label define K 5 `"top 0.1%-top0.01%"', modify
label values _k K

label define T 1 `"below top 10%"', modify
label define T 2 `"top 10%-top5%"', modify
label define T 3 `"top 5%-top1%"', modify
label define T 4 `"top 1%-top0.5%"', modify
label define T 5 `"top 0.5%-top0.1%"', modify
label define T 6 `"top 0.1%-top0.01%"', modify
label define T 7 `"above top 0.01%"', modify
label values top T

sort year gdekannr



* RESULTS * RESULTS * RESULTS * RESULTS * RESULTS * RESULTS * RESULTS * RESULTS *

// how many Ausscheidungen in each group over period 1971-2010?
	tabout top using "$mypath\Pauschalbesteuerte\total_aussch_in_topgroups", replace  style(csv) format(0c)
// how many Ausscheidungen in each group and year?
	tabout year top using "$mypath\Pauschalbesteuerte\total_aussch_in_topgroups_per_yr", replace  style(csv) format(0c)
// how many Ausscheidungen in each group and canton over period 1971-2010?
	tabout gdekannr top using "$mypath\Pauschalbesteuerte\total_aussch_in_topgroups_per_cant", replace  style(csv) format(0c)

// collapse and save dataset
preserve
 collapse (count) N=snp_ahvnr , by(year top)

 drop if top==.
 reshape wide N, i(year) j(top)
 
 egen N0 = rowtotal(N1-N7)
 label var N0	"All taxpayers"
 label var N1	"Below top 10%"
 label var N2	"Top 10%-5%"
 label var N3	"Top 5%-1%"
 label var N4	"Top 1%-0.5%"
 label var N5	"Top 0.5%-0.1%"
 label var N6	"Top 0.1%-0.01%"
 label var N7	"Above top 0.01%"
			
 rename N0	spe_0
 rename N1	spe_1
 rename N2	spe_2
 rename N3	spe_3
 rename N4	spe_4
 rename N5	spe_5
 rename N6	spe_6
 rename N7	spe_7
 
 save "$mypath\Pauschalbesteuerte\ausscheidungen_1971-2010_by_group", replace
restore

*************************************************************************************************************************************

* COMBINE PAUSCHALIERTE AND AUSSCHEIDUNGEN TO MAKE ONE TABLE *
// date: July 14 2015
// author: Isabel Martinez

clear 
cap clear matrix
set more off

version 14.0

use "$thepath/results/special_cases/ausscheidungen_1971-2010_by_group", clear

merge 1:1 year using "$thepath/results/special_cases/pauschalbesteuerte_1971-2010_by_group"
drop _merge

// genereate the combined total of special case taxpayers
forval n=0/7 {
egen N`n'=rowtotal(exp_`n' spe_`n')
}
 label var N0	"All taxpayers"
 label var N1	"Below top 10%"
 label var N2	"Top 10%-5%"
 label var N3	"Top 5%-1%"
 label var N4	"Top 1%-0.5%"
 label var N5	"Top 0.5%-0.1%"
 label var N6	"Top 0.1%-0.01%"
 label var N7	"Above top 0.01%"
 
// generate number above top 0.1%
foreach group in spe_ exp_ N {
gen `group'8 = `group'6+`group'7
label var `group'8 "Above top 0.1%"
}
 
// delete observations for years 1996-2000 (incl.) as for these years many cantons' tax data is missing
foreach var in spe_1 spe_2 spe_3 spe_4 spe_5 spe_6 spe_7 spe_8 spe_0 exp_1 exp_2 exp_3 exp_4 exp_5 exp_6 exp_7 exp_8 exp_0 N0 N1 N2 N3 N4 N5 N6 N7 N8 {
replace `var'=. if year>1995 & year<2001
}

// merge the total tax units
preserve
use  "$thepath/4a_TopIncomeShares_CH_1981-2010.dta", clear
keep if cant==0
keep year total_taxunits tu_total
tempfile tot_8110
save "`tot_8110'"

use "$thepath/4c_TopIncomeShares_CH_1971-80.dta" , clear
keep year total_taxunits tu_total
append using "`tot_8110'"

tempfile total_taxunits
save "`total_taxunits'"
restore

merge m:1 year using "`total_taxunits'"
drop if _merge==2
drop _merge
label var tu_total "Total taxunits in tax statistics"
label var total_taxunits "Total taxunits in the country"



// generate share of of each special type among top income groups
order year exp_* spe_* N*
foreach var in exp_0 spe_0 N0 {
gen share_`var' = `var'/ total_taxunits
 label var share_`var' "All taxpayers"
 }

foreach var in exp_1 spe_1 N1 {
gen share_`var' = `var'/ (total_taxunits*0.9)
 label var share_`var' "Below top 10%"
}

foreach var in exp_2 spe_2 N2 {
gen share_`var' = `var'/ (total_taxunits*0.05)
 label var share_`var' "Top 10%-5%"
}
 
foreach var in exp_3 spe_3 N3 {
gen share_`var' = `var'/ (total_taxunits*0.04)
 label var share_`var' "Top 5%-1%"
 }

foreach var in exp_4 spe_4 N4 {
gen share_`var' = `var'/ (total_taxunits*0.005)
 label var share_`var' "Top 1%-0.5%"
}

foreach var in exp_5 spe_5 N5 {
gen share_`var' = `var'/ (total_taxunits*0.004)
 label var share_`var' "Top 0.5%-0.1%"
}

foreach var in exp_6 spe_6 N6 {
gen share_`var' = `var'/ (total_taxunits*0.0009)
 label var share_`var' "Top 0.1%-0.01%"
}

foreach var in exp_7 spe_7 N7 {
gen share_`var' = `var'/ (total_taxunits*0.0001)
 label var share_`var' "Above top 0.01%"
}

foreach var in exp_8 spe_8 N8 {
gen share_`var' = `var'/ (total_taxunits*0.001)
 label var share_`var' "Above top 0.1%"
}



keep year exp_0 spe_0 N0 share_* total_taxunits 
order year share_* exp_0 spe_0 N0 total_taxunits 


* save a file for Figure 7 in the paper
saveold "$thepath/results/special_cases/total_pschbst+aussch_1971-2010_by_group.dta", version(12) replace 

preserve
keep year share_exp_8 share_spe_8 share_N8
rename share_exp_8 P999_1
rename share_spe_8 P999_2
rename share_N8 P999_3

reshape long P999_, i(year) j(gr)
gen group = "Expenditure-based tax units" if gr==1
replace group = "Other special cases" if gr==2
replace group = "Total: expenditure-based tax units and other special cases" if gr==3

bys gr: ipolate P999_ year, generate (P999_ipol) 

saveold "$thepath/results/figures/fig7.dta", version(12) replace 
restore



* make table for appendix
preserve
// drop the years that are missing
drop if year>1995 & year<2000
replace total_taxunits=. if year==2000
replace year=. if year==2000

// multiply by 100
foreach var in share_exp_0 share_spe_0 share_N0 share_exp_1 share_spe_1 share_N1 share_exp_2 share_spe_2 share_N2 share_exp_3 share_spe_3 share_N3 share_exp_4 share_spe_4 share_N4 share_exp_5 share_spe_5 share_N5 share_exp_6 share_spe_6 share_N6 share_exp_7 share_spe_7 share_N7 share_exp_8 share_spe_8 share_N8 {
replace `var' = `var' * 100
format `var' %4.2f
}

// export to excel
export excel using "$thepath/results/special_cases/Online_Appendix_Table6.xlsx", firstrow(varlabels) cell(A2) replace

// format excel table
putexcel set "$thepath/results/special_cases/Online_Appendix_Table6.xlsx", modify
putexcel B1:D1 = "All taxpayers", merge  hcenter
putexcel E1:G1 = "Below top 10%", merge  hcenter
putexcel H1:J1 = "Top 10%-5%", merge  hcenter
putexcel K1:M1 = "Top 5%-1%", merge  hcenter
putexcel N1:P1 = "Top 1%-0.5%", merge  hcenter
putexcel Q1:S1 = "Top 0.5%-0.1%", merge  hcenter
putexcel T1:V1 = "Top 0.1%-0.01%", merge  hcenter
putexcel W1:Y1 = "Above top 0.01%", merge  hcenter
putexcel Z1:AB1 = "Above top 0.1%", merge  hcenter
putexcel AC1:AE1 = "Total no. of special taxpayers", merge  hcenter
putexcel AF1 = "Total taxunits in Switzerland",  hcenter
putexcel AF2 = "(including non-filers)",  hcenter

foreach cell in B2 E2 H2 K2 N2 Q2 T2 W2 Z2 AC2 {
putexcel `cell'= "exp", hcenter
}

foreach cell in C2 F2 I2 L2 O2 R2 U2 X2 AA2 AD2 {
putexcel `cell'= "spec", hcenter
}

foreach cell in D2 G2 J2 M2 P2 S2 V2 Y2 AB2 AE2 {
putexcel `cell'= "spec", hcenter
}

putexcel A2 = "year"

// table notes:
putexcel A30 = "Note: Share of special tax units in the whole population and among different income groups"
putexcel A31 = "Years 2001 and 2002 underestimate the number and share of special cases, as in these years data from the cantons VD, VS, and TI are missing in the underlying federal income tax data"
putexcel A32 = "exp: Expenditure-based tax units"
putexcel A33 = "spec: Tax units with taxable income below rate-determining income due to, e.g., international income allocation"
putexcel A33 = "Data Source: Individual federal income tax data, ESTV Bern, own calculations"
restore






