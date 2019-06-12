***THIS FILE MINIMIZES THE RMSE BETWEEN AVAILABILITY AND USAGE***

*last updated: 10-4-16

cd $datafolder

**----------------------------**
** MINIMIZE RMSE, FULL SAMPLE-**
**----------------------------**

	set more off
use "`temp_folder'int121999.dta", clear
forvalues Y=2000(1)2007{
	local data int12`Y'
	append using "`data'.dta"
}
forvalues Y=0(1)8{
	local data int060`Y'
	append using "`data'.dta"
}


drop if zip==.
gen year_month=year*100+month
drop year month


/**note several zip codes span multiple states, incl. 42223 (TN/KY) 57724 (MT/SD)  71749 (AR/LA) 72395 (TN/AR) 73949 (OK/TX) 
and are therefore recorded twice the information is simply replicated, so just keep one */
bysort zip year_month: gen n=_n
keep if n==1
drop n
reshape wide providers, i(zip) j(year_month)
rename zip zipcode

merge 1:1 zipcode using "zipcodedata2000.dta"
rename _merge zip_match

merge 1:1 zipcode using "zipcodedata2000_2.dta"
rename _merge zip_match2
drop totalpop totalhousing
**zips with missing info are mostly not inhabitated areas, drop
drop if zip_match==1

reshape long providers, i(zipcode) j(year_month)

replace providers=0 if providers==. & zip_match==2
replace providers=0 if providers==. & zip_match==3


replace providers=1 if providers==2

**merge time variant pop data from SOI/Census
gen year=floor(year_month/100)
merge m:1 zipcode year using "zipcode_income_pop_data.dta"
drop if _merge==2
drop _merge

gen frac_urban=urban/totalpop
replace frac_urban=0 if urban==.

keep totalpop zipcode providers totalland totalhousing frac_urban year_month state
drop if state=="PR"

gen urban=(frac_urban>0.5)
drop if totalpop==0
keep zipcode providers totalpop totalland totalhousing year_month urban


gen year=floor(year_month/100)
gen month=(year_month)-(year*100)
gen year_qtr=year+0.417 if month==6
replace year_qtr=year+0.916 if month==12

drop month

**attach usage rates from PEW (not available by urban.rural, that is why we used CPS before)**
append using "hsi_use_pew.dta"

rename broadband_pew hsi_home

reg hsi_home year_qtr if  year_qtr<=2001.25
predict hsi_00_01, xb

reg hsi_home year_qtr if year_qtr>2001 & year_qtr<2003
predict hsi_01_02, xb

reg hsi_home year_qtr if  year_qtr>=2002 & year_qtr<2004
predict hsi_02_03, xb

reg hsi_home year_qtr if year_qtr>2003& year_qtr<2005
predict hsi_03_04, xb

reg hsi_home year_qtr if  year_qtr>2004 & year_qtr<2006
predict hsi_04_05, xb

reg hsi_home year_qtr if  year_qtr>=2005 & year_qtr<2007
predict hsi_05_06, xb

reg hsi_home year_qtr if year_qtr>2006 & year_qtr<2008
predict hsi_06_07, xb

reg hsi_home year_qtr if  year_qtr>2007 & year_qtr<2009
predict hsi_07_08, xb

reg hsi_home year_qtr if  year_qtr>2008 & year_qtr<2010
predict hsi_08_09, xb

gen hsi_predict=.
replace hsi_predict=hsi_00_01 if year_qtr<=2001.25
replace hsi_predict=hsi_01_02 if year_qtr>2001.25 & year_qtr<=2002.167
replace hsi_predict=hsi_02_03 if year_qtr>2002.167 & year_qtr<=2003.167
replace hsi_predict=hsi_03_04 if year_qtr>2003.167 & year_qtr<=2004.25
replace hsi_predict=hsi_04_05 if year_qtr>2004.25 & year_qtr<=2005.167
replace hsi_predict=hsi_05_06 if year_qtr>2005.167 & year_qtr<=2006.167
replace hsi_predict=hsi_06_07 if year_qtr>2006.167 & year_qtr<=2007.167
replace hsi_predict=hsi_07_08 if year_qtr>2007.167 & year_qtr<=2008.25
replace hsi_predict=hsi_08_09 if year_qtr>2008.25 & year_qtr<=2009.25

 /* **look at interpolation, for reference
 graph twoway (connected hsi_home year_qtr)  (scatter hsi_predict year_qtr), ///
 title("Check Interpolation")
 */


**keep just years we have provider data
keep if providers!=.
set more off
gen providers_pop0=(providers/totalpop)
replace providers_pop0=(providers_pop0>=1)


forvalues n=100(100)4000{
gen providers_pop`n'=(providers/totalpop)*`n'
replace providers_pop`n'=(providers_pop`n'>=1)
}

set more off
gen providers_hh0=(providers/totalhousing)
replace providers_hh0=(providers_hh0>=1)


forvalues n=100(100)4000{
gen providers_hh`n'=(providers/totalhousing)*`n'
replace providers_hh`n'=(providers_hh`n'>=1)
}

forvalues n=1(1)40{
gen providers_sqmi`n'=(providers/totalland)*`n'
replace providers_sqmi`n'=(providers_sqmi`n'>=1)
}


drop hsi_home

rename hsi_predict hsi_home
collapse providers_pop* providers_sqmi* providers_hh*  hsi_home [pw=totalpop], by(year_month)

**construct mean squared error various measures and usage
egen mse_pop0 =total(abs(providers_pop0-hsi_home)) 
egen mse_hh0 =total(abs(providers_hh0-hsi_home)) 


forvalues n=100(100)4000{
egen mse_pop`n' =total(abs(providers_pop`n'-hsi_home)) 
}

forvalues n=100(100)4000{
egen mse_hh`n' =total(abs(providers_hh`n'-hsi_home)) 
}

forvalues n=1(1)40{
egen mse_sqmi`n' =total(abs(providers_sqmi`n'-hsi_home))
}


keep mse* 
gen n=_n
keep if n==1

reshape long mse_sqmi mse_pop mse_hh, i(n) j(var)

*generate RMSE
gen rmse_sqmi=sqrt(mse_sqmi)
gen rmse_pop=sqrt(mse_pop)
gen rmse_hh=sqrt(mse_hh)


*minimize RMSE
egen min_sqmi=min(rmse_sqmi)
egen min_pop=min(rmse_pop)
egen min_hh=min(rmse_hh)

gen min_rmse_sqmi=var if min_sqmi==rmse_sqmi
gen min_rmse_pop=var if min_pop==rmse_pop
gen min_rmse_hh=var if min_hh==rmse_hh


**SUMMARIZE BEST FIT**
sum min_rmse_sqmi min_sqmi	
sum min_rmse_pop min_pop
sum min_rmse_hh min_hh

 
**1 BEST FIT IS 2200 pop (rmse=0.702)***
**2 BEST FIT IS 900 hh (rmse=0.824)***
**3 BEST FIT IS 1 Sq.Mi (rmse=1.372)***

**NOW TEST OF EACH OF THESE IN URBAN RURAL SUBSAMPLES ANALYSIS TO SEE IF URBAN/RURAL CUTS PERFROMS BETTER

**----------------------------------------------**
**MINIMIZE RMSE, SEPERATELY FOR URBAN RURAL**
**--------------------------------------------**


	set more off
use "int121999.dta", clear
forvalues Y=2000(1)2007{
	local data int12`Y'
	append using "`data'.dta"
}
forvalues Y=0(1)8{
	local data int060`Y'
	append using "`data'.dta"
}


drop if zip==.
gen year_month=year*100+month
drop year month


/**note several zip codes span multiple states, incl. 42223 (TN/KY) 57724 (MT/SD)  71749 (AR/LA) 72395 (TN/AR) 73949 (OK/TX) 
and are therefore recorded twice the information is simply replicated, so just keep one */
bysort zip year_month: gen n=_n
keep if n==1
drop n
reshape wide providers, i(zip) j(year_month)
rename zip zipcode

merge 1:1 zipcode using "zipcodedata2000.dta"
rename _merge zip_match

merge 1:1 zipcode using "zipcodedata2000_2.dta"
rename _merge zip_match2

**we could use these or time-variant versions from soi data
drop totalpop totalhousing

**zips with missing info are mainly not inhabitated areas, drop
drop if zip_match==1

reshape long providers, i(zipcode) j(year_month)

replace providers=0 if providers==. & zip_match==2
replace providers=0 if providers==. & zip_match==3
replace providers=1 if providers==2


**merge in time variant population based on census 2000 and SOI data

gen year=floor(year_month/100)
merge m:1 zipcode year using "zipcode_income_pop_data.dta"
drop if _merge==2
drop _merge


gen frac_urban=urban/totalpop
replace frac_urban=0 if urban==.

keep totalpop zipcode providers totalland totalhousing totalpop frac_urban year_month state
drop if state=="PR"

gen urban=(frac_urban>0.5)
drop if totalpop==0
keep zipcode providers urban totalpop totalhousing totalland year_month


gen year=floor(year_month/100)
gen month=(year_month)-(year*100)
gen year_qtr=year+0.417 if month==6
replace year_qtr=year+0.916 if month==12
/*replace year_qtr=year+0.167 if month==3
replace year_qtr=year+0.250 if month==4
replace year_qtr=year+0.333 if month==5
replace year_qtr=year+0.583 if month==8
replace year_qtr=year+0.666 if month==9*/

drop month
gen msadweller=(urban==1)

**append CPS usage rates by lives in MSA (this is not available in PEW data)
append using "hsi_use_byurban.dta"


**first, interpolate/extrapolate missing data points 
reg hsi_home year_qtr if msadweller==0 & year<=2001
predict hsi_rural_00_01, xb

reg hsi_home year_qtr if msadweller==1 & year<=2001
predict hsi_urban_00_01, xb

reg hsi_home year_qtr if msadweller==0 & year>=2001 & year<=2003
predict hsi_rural_01_03, xb

reg hsi_home year_qtr if msadweller==1 & year>=2001 & year<=2003
predict hsi_urban_01_03, xb

reg hsi_home year_qtr if msadweller==0 & year>=2003 & year<=2007
predict hsi_rural_03_07, xb

reg hsi_home year_qtr if msadweller==1 & year>=2003 & year<=2007
predict hsi_urban_03_07, xb

reg hsi_home year_qtr if msadweller==0 & year>=2007 & year<=2009
predict hsi_rural_07_09, xb

reg hsi_home year_qtr if msadweller==1 & year>=2007 & year<=2009
predict hsi_urban_07_09, xb


gen hsi_rural=.
gen hsi_urban=.

foreach n in rural urban {
replace hsi_`n'=hsi_`n'_00_01 if year_qtr<2001.664
replace hsi_`n'=hsi_`n'_01_03 if year_qtr>2001.664 & year_qtr<2003.75
replace hsi_`n'=hsi_`n'_03_07 if year_qtr>2003.75 & year_qtr<2007.75
replace hsi_`n'=hsi_`n'_07_09 if year_qtr>2007.75 
}


/**plot interpolation, for reference
graph twoway (connected hsi_home year_qtr if msadweller==1)  (connected hsi_home year_qtr if msadweller==0) (scatter hsi_urban year_qtr)  (scatter hsi_rural year_qtr), ///
 title("Check Interpolation")*/


**keep just years we have provider data
keep if providers!=.
set more off

gen providers_pop0=(providers/totalpop)
replace providers_pop0=(providers_pop0>=1)

gen providers_hh0=(providers/totalhousing)
replace providers_hh0=(providers_hh0>=1)


forvalues n=100(100)4000{
gen providers_pop`n'=(providers/totalpop)*`n'
replace providers_pop`n'=(providers_pop`n'>=1)
}

forvalues n=100(100)4000{
gen providers_hh`n'=(providers/totalhousing)*`n'
replace providers_hh`n'=(providers_hh`n'>=1)
}

forvalues n=1(1)40{
gen providers_sqmi`n'=(providers/totalland)*`n'
replace providers_sqmi`n'=(providers_sqmi`n'>=1)
}

replace hsi_home=hsi_urban if urban==1
replace hsi_home=hsi_rural if urban==0


collapse providers_pop* providers_hh* providers_sqmi* hsi_home [pw=totalpop], by(year_month urban)

sort urban
by urban: egen mse_pop0 =total(abs(providers_pop0-hsi_home)) 
by urban: egen mse_hh0 =total(abs(providers_hh0-hsi_home)) 

forvalues n=100(100)4000{
by urban: egen mse_pop`n' =total(abs(providers_pop`n'-hsi_home)) 
}
forvalues n=100(100)4000{
by urban: egen mse_hh`n' =total(abs(providers_hh`n'-hsi_home)) 
}
forvalues n=1(1)40{
by urban: egen mse_sqmi`n' =total(abs(providers_sqmi`n'-hsi_home))
}

by urban: gen n=_n
keep if n==1

keep mse* urban 
reshape long mse_sqmi mse_pop mse_hh, i(urban) j(n)

**create RMSE
gen rmse_sqmi=sqrt(mse_sqmi)
gen rmse_pop=sqrt(mse_pop)
gen rmse_hh=sqrt(mse_hh)

**minimize RMSE
by urban: egen min_hh=min(rmse_hh)
by urban: egen min_sqmi=min(rmse_sqmi)
by urban: egen min_pop=min(rmse_pop)

gen min_rmse_sqmi=n if min_sqmi==rmse_sqmi
gen min_rmse_pop=n if min_pop==rmse_pop
gen min_rmse_hh=n if min_hh==rmse_hh


**SUMMARIZE BEST FIT MEASURES**
sum min_rmse_sqmi min_sqmi if urban==0
sum min_rmse_sqmi min_sqmi if urban==1
sum min_rmse_pop min_pop if urban==0
sum min_rmse_pop min_pop if urban==1
sum min_rmse_hh min_hh if urban==0
sum min_rmse_hh min_hh if urban==1


**BEST FIT FOR URBAN if 2700 POP, for RURAL is 12 Sq Mi**
**NOW COMPARE TO BEST FIT OPTION FROM FULL SAMPLE - 2200 pop**

**for appendix tables, need RMSEs for various alternative definitions:

sum rmse_pop if urban==1 & n==2700
sum rmse_sqmi if urban==0 & n==12

**best fit overall
sum rmse_pop if urban==1 & n==2200
sum rmse_pop if urban==0 & n==2200 

*also, compare with using same type for both samples
sum rmse_pop if urban==1 & n==2700
sum rmse_pop if urban==0 & n==2700
 
sum rmse_sqmi if urban==1 & n==12
sum rmse_sqmi if urban==0 & n==12


*compare with numerous robustness checks
foreach n in 2000 2500 2700 3000 {
sum rmse_pop if urban==1 & n==`n'
}

foreach n in 10 12 15 {
sum rmse_sqmi if urban==1 & n==`n'
}







