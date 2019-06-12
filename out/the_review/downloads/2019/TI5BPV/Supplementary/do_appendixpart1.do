**************************************************************************************************
******APPENDIX DO FILE FOR "OFFICE-SELLING, CORRUPTION AND LONG-TERM DEVELOPMENT IN PERU"*********
******BY JENNY GUARDADO, GEORGETOWN UNIVERSITY, jennyguardado@gmail.com***************************
******PART 1     *********************************************************************************
**************************************************************************************************
**************************************************************************************************

capture log close
clear 
cd  "C:\Users\jenny\Dropbox\Replication Office-selling\Supplementary"

log using app_part1, replace

***************************************************************************
*****Figure A.3 
***************************************************************************

use main_part1, clear

collapse (mean) rprice1, by(year)

gen lrprice1 = log(rprice1)

#delimit
twoway (line lrprice1 year, sort)(lowess lrprice1 year, sort) 
if year>=1670 & year<=1751;
#delimit cr


***************************************************************************
*****Table A.2 Descriptive Statistics
***************************************************************************

*PANEL A

use main_part1, clear

# delimit ;
sutex lrprice1 rprice1 appointed noble orden military 
cumwar war yearfromwar twowars 
year gov_reb totalc	alcabala	tributonew	mining, minmax;
# delimit cr



*PANEL B

use main_part2_2, clear

# delimit ;
keep provincia meanprice minpriceh rep50	lreparto2
bishop pop54	lpop54	ind54	lind54	mita	mine	econactivity2	
wage	lwage	
pop1827	grossinc1827	pcinc1827	
anyreb_pre	govreb_pre	alltax_pre	
anyreb_post	govreb_post	alltax_post;
# delimit cr

# delimit ;
duplicates drop meanprice minpriceh rep50	lreparto2
bishop pop54	lpop54	ind54	lind54	mita	mine	econactivity2	
wage	lwage	
pop1827	grossinc1827	pcinc1827	
anyreb_pre	govreb_pre	alltax_pre	
anyreb_post	govreb_post	alltax_post, force;
#delimit cr

keep if meanprice!=. & minpriceh!=.

# delimit ;
sutex rep50	lreparto2
bishop pop54	lpop54	ind54	lind54	mita	mine	econactivity2	
wage	lwage	
pop1827	grossinc1827	pcinc1827	
anyreb_pre	govreb_pre	alltax_pre	
anyreb_post	govreb_post	alltax_post, minmax;
# delimit cr


*PANEL C

use main_part2_2, clear

keep if meanprice!=. & minpriceh!=.

gen lpop1572 = log(pop1572)

# delimit ;
keep shindig80	shindig	shnonlit
pop1572	lpop1572	ltrib_rate	logtributario	
shpriest	shcorreg	shcaciq	shencom	
perctribut	percviejos	percmuchachos	percmujeres;
# delimit cr


# delimit ;
sutex shindig80	shindig	shnonlit
pop1572	lpop1572	ltrib_rate	logtributario	
shpriest	shcorreg	shcaciq	shencom
perctribut	percviejos	percmuchachos	percmujeres, minmax;
# delimit cr


*PANEL D

use main_part2_2, clear

keep if meanprice!=. & minpriceh!=.

# delimit;
keep provincia meanprice	minpriceh soldpc	meanpriceh firstpriceh;
# delimit cr

duplicates drop

# delimit;
sutex meanprice	minpriceh soldpc	meanpriceh firstpriceh, minmax;
# delimit cr

*PANEL E

use spain_timeseries, clear


# delimit;
sutex lrevenue	gdp_pc	lspend_crown	conversion_vellon	eggprice_silver, minmax;
# delimit cr

*PANEL F

use peru_timeseries, clear

# delimit;
sutex 	lsilver1 lsilver2 avgprice_index, nobs minmax;
# delimit cr


*PANEL G

use main_part2_1, clear

keep if meanprice & minpriceh!=.

# delimit;
sutex lhhequiv lhhequivlm schoolyears adults	infants	kids	age 	male	
QUE	peasant_id	localborn
trust_jne	trust_onpe	
trust_distrit	trust_munic	trust_government	
trust_police	trust_army	trust_judic	
trust_paper	trust_radtv , minmax;
# delimit cr

*PANEL H and I

use main_part2_2, clear

keep if meanprice & minpriceh!=.

# delimit;
sutex toilethouse	mud	border 
lpop90
suitindex distlima	ldistlima	z	lz	centerxgd	centerygd
cases83	guerrilla83	authority83, minmax;
# delimit cr


***************************************************************************
*****Table A.3  Office Prices and Quartile Measures 
*****of Repartimiento in War versus Peace
***************************************************************************

use main_part1, clear

drop if lreparto2==. 
drop rep50

sum lreparto2, det
gen rep25 = 0 
replace rep25 = 1 if lreparto2<r(p25) 
tab rep25

sum lreparto2, det
gen rep50 = 0 
replace rep50 = 1 if lreparto2>=r(p25) & lreparto2<r(p50)
tab rep50 

sum lreparto2, det
gen rep75 = 0 
replace rep75 = 1 if lreparto2>=r(p50) & lreparto2<r(p75)
tab rep75

sum lreparto2, det
gen rep100 = 0 
replace rep100 = 1 if lreparto2>=r(p75)
tab rep100

gen int1 = rep50*cumwar
gen int2 = rep75*cumwar
gen int3 = rep100*cumwar


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA3, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA3, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA3, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr



***************************************************************************
*****Table A.4 Office Prices and Repartimiento in 
*****War versus Peace: Only Succession Wars
***************************************************************************

*PANEL A

use main_part1, clear

gen int1 = rep50*twowars


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA4A, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* obyear1-obyear5  gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA4A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* obyear1-obyear5  gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA4A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*PANEL B

use main_part1, clear

gen war2 = 0
replace war2 = 1 if twowars>0

gen int1 = rep50*war2


#delimit ;
xtreg lrprice1 int* obyear1-obyear5  i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA4B, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5  gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA4B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5  gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA4B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


***************************************************************************
*****Figure A.5 Robustness to outliers
***************************************************************************

use main_part1, clear

gen int1 = rep50*cumwar

qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe

keep if e(sample) 

set more off
encode provincia, gen(codprov)

	# delimit; 
	forvalues i=1(1)44 {; 
	qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima" 
	& codprov!=`i' & codprov!=`i+1' & codprov!=`i+2', fe;
	outreg2 using tab_figA5, excel append tstat nolabel less(1); 
	}; 
	#delimit cr


***************************************************************************
*****Figure A.6 Difference in share of non-nobles over time
***************************************************************************

use main_part1, clear

keep if appointed==0

gen tot =1 

gen nonnoble = 0
replace nonnoble = 1 if noble ==0
tab nonnoble

gen hnonoble = nonnoble if rep50==1
gen lnonoble = nonnoble if rep50==0	
	
collapse (sum) tot hnonoble lnonoble, by(year)

gen shhnonoble = hnonoble/tot
gen shlnonoble = lnonoble/tot

bys year: gen difnonobles = shhnonoble - shlnonoble

#delimit;
twoway (line difnonobles year, yaxis(2)) (scatter shhnonoble year, sort)(scatter shlnonoble year, sort);
#delimit cr


***************************************************************************
*****Table A.5 -- Including flexible time trends
***************************************************************************

*COLUMN 1

use main_part1, clear

gen int1 = rep50*cumwar

qui xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe

keep if e(sample)

tab provcode, gen(pdum)

xtset

*44 provinces

forvalues x=1(1) 44 {
gen trend`x'=0
replace trend`x'=pdum`x'*time
}

forvalues x=1(1) 44 {
gen trendsq`x'=0
replace trendsq`x'=pdum`x'*time*time
}

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 trend1-trend43 trendsq1-trendsq43 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  table_A5, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*COLUMN 2

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 trend1-trend43 trendsq1-trendsq43 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  table_A5, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar
qui xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe
keep if e(sample)

tab provcode, gen(pdum)

xtset

*48 provinces in model

forvalues x=1(1) 48 {
gen trend`x'=0
replace trend`x'=pdum`x'*time
}

forvalues x=1(1) 48 {
gen trendsq`x'=0
replace trendsq`x'=pdum`x'*time*time
}

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 trend1-trend47 trendsq1-trendsq47 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  table_A5, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


***************************************************************************
*****Table A.6: Pre and Post Office-Selling (1752)
***************************************************************************

use main_part1.dta, clear

*PANEL A

 local replace replace
 foreach var of varlist noble orden military  { 
 xi: xtreg `var' appointed obyear1-obyear5  gov_reb i.year, fe
 sum `var' if e(sample)
 local mean = r(mean)
 outreg2 using tabA6A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Provinces", e(N_g), "Mean DV", `mean')
 local replace
 }

 
*PANEL B

use data_tableA8, clear

gen ofsell = 0
replace ofsell = 1 if year<=1752

gen int1 = rep50*ofsell


 local replace replace
 foreach var of varlist noble orden military  { 
 xi: xtreg `var' int* obyear1-obyear5  gov_reb i.year, fe
 sum `var' if e(sample)
 local mean = r(mean)
 outreg2 using tabA6B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni adds("Provinces", e(N_g), "Mean DV", `mean')
 local replace
 }
 

***************************************************************************
*****Table A.7: Time-series correlation between European wars
*****and Peruvian audiencia outcome
***************************************************************************

use peru_timeseries, clear

	local replace replace
	foreach var of varlist lsilver1 lsilver2 avgprice_index { 
	reg `var' cumwar year
	outreg2 cumwar using tabA7A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni 
	local replace
	}
	

	local replace replace
	foreach var of varlist lsilver1 lsilver2 avgprice_index { 
	reg `var' war year
	outreg2 cumwar using tabA7B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni
	local replace
	}
	
	
***************************************************************************
*****Table A.8: Time-series correlation between European wars
*****and Spanish economic outcomes
***************************************************************************

use spain_timeseries, clear


	local replace replace
	foreach var of varlist lrevenue gdp_pc lspend_crown conversion_vellon eggprice_silver { 
	reg `var' cumwar year
	outreg2 cumwar using tabA8A.tex, `replace' pvalue bdec(3) tdec(3) nocons noni 
	local replace
	}
	

	local replace replace
	foreach var of varlist lrevenue gdp_pc lspend_crown conversion_vellon eggprice_silver  { 
	reg `var' war year
	outreg2 cumwar using tabA8B.tex, `replace' pvalue bdec(3) tdec(3) nocons noni
	local replace
	}
	
	



***************************************************************************
*****Table A.9: Including Wages (compensation differentials)
***************************************************************************

use main_part1, clear

*obtaining approximate total wages for a standard five year term
gen fivewage = wage*5
gen lfivewage = log(fivewage)

gen int1 = rep50*cumwar
gen int2 = lfivewage*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA9, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA9, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA9, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


***************************************************************************
*****Table A.10: Including forced labor, mining and indigenous population
***************************************************************************

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = mita*cumwar
gen int3 = mine*cumwar
gen int4 = lpop54*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA10, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA10, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA10, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

***************************************************************************
*****Table A.11: Including suitability and market presence
***************************************************************************

use main_part1, clear

*PANEL A

gen int1 = econactivity2*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11A, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*PANEL B

use main_part1, clear

gen int1 = suitindex*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11B, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

*PANEL C

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = econactivity2*cumwar
gen int3 = suitindex*cumwar


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11C, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11C, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA11C, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


***************************************************************************
*****Table A.12 Controlling for Tax Revenue (at the caja level) 
***************************************************************************

use main_part1, clear


*PANEL A - SALES TAXES

gen int1 = rep50*cumwar 

#delimit ;
xtreg lrprice1 int* alcabala obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12A, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* alcabala gov_reb obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* alcabala obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*PANEL B - HEAD TAXES

#delimit ;
xtreg lrprice1 int* tributonew obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12B, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* tributonew gov_reb obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* tributonew obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*PANEL C - MINE TAXES

#delimit ;
xtreg lrprice1 int* mining obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12C, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* mining gov_reb obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12C, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* mining obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12C, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*PANEL D - ALL TAXES

#delimit ;
xtreg lrprice1 int* mining totalc alcabala tributonew obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12D, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* mining totalc alcabala tributonew  gov_reb obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12D, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg lrprice1 int* mining totalc alcabala tributonew  gov_reb obyear1-obyear5 i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA12D, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


***************************************************************************
*****Table A.13 Appoint versus Sell
***************************************************************************

*PANEL A

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
xtreg appoint int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA13A, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg appoint int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA13A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

#delimit ;
xtreg appoint int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA13A, tex append pvalue bdec(3) tdec(3) nocons noni
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*PANEL B

use main_part1, clear

gen int1 = rep50*war

#delimit ;
xtreg appoint int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA13B, tex replace pvalue bdec(3) tdec(3) nocons  noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg appoint int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA13B, tex append pvalue bdec(3) tdec(3) nocons  noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


#delimit ;
xtreg appoint int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tabA13B, tex append pvalue bdec(3) tdec(3) nocons  noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

log close
