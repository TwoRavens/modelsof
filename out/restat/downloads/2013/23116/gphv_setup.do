/**************************************************************************
File name: gphv_setup.do
Hui Shan

This do file combines various data sources, cleans up the dataset, and save
it for analysis. The next step will be to demean all the variables
(gphv_demean.do) and to run the main regressions (gphv_main.do).
***************************************************************************/

capture log close
clear all
set mem 2000m
set matsize 10000
set maxvar 20000
set more off

*change this to wherever you save the ReadMe folder
cd /href/research4/m1hxs02/Gas_price/ReadMe

****************************
*Clean up the MCR variables
****************************

*read in aggregated data (all other variables starts in 1965Q1 but frm and spd start in 1971Q2 and commodity starts in 1974Q1.)
*note that PCE data are normalized to be 100 for the 2005 levels. 
infile year quarter pcegas pcexgas totstarts gdp tothu aggemp dpi frm spd heatcool pcexhc commodity pce var20q var8q using Data/gasprice_2009Q2.txt, clear
replace year = year+1900
replace year = year+100 if year<=1950
drop totstarts tothu spd var20q var8q
gen pcergp=pcegas/pcexgas*100
gen rcommodity=commodity/pce*100
gen rheatcool=heatcool/pcexhc*100
*generate annual change variables
sort year quarter
foreach var of varlist pcergp gdp aggemp dpi frm rcommodity rheatcool {
	by year: egen annual_`var'=mean(`var')
	drop `var'
	rename annual_`var' `var'
}
keep year pcergp gdp aggemp dpi frm rcommodity rheatcool
by year: keep if _n==1
gen eiargp=pcergp*231.4/100
drop if year==2009 | year<1974
foreach i of numlist 1/5 {
	gen drgp_ly`i'=log(pcergp[_n+1-`i'])-log(pcergp[_n-`i'])
	gen hrgp_ly`i'=(log(eiargp[_n+1-`i'])-log(eiargp[_n-`i']))*(eiargp[_n+1-`i']>=200)
	gen dgdp_ly`i'=log(gdp[_n+1-`i'])-log(gdp[_n-`i'])
	gen demp_ly`i'=log(aggemp[_n+1-`i'])-log(aggemp[_n-`i'])
	gen dinc_ly`i'=log(dpi[_n+1-`i'])-log(dpi[_n-`i'])
	gen dhcc_ly`i'=log(rheatcool[_n+1-`i'])-log(rheatcool[_n-`i'])
	gen dfrm_ly`i'=log(frm[_n+1-`i'])-log(frm[_n-`i'])
	gen dcom_ly`i'=log(rcommodity[_n+1-`i'])-log(rcommodity[_n-`i'])
}
gen drgp=log(pcergp[_n+1])-log(pcergp)
keep year eiargp drgp_ly* hrgp_ly* dgdp_ly* demp_ly* dinc_ly* dhcc_ly* dfrm_ly* dcom_ly* drgp
drop if dfrm_ly5==.
sort year
save temp_aggdata.dta, replace

****************************
*Clean up the HPI data
****************************

/*This is the LP HPI 3.0 which swiches from transaction weighted HPI to value
weighted HPI. Case Shiller HPI is value weighted. FHFA HPI is transaction
weighted. Note that now we only have 6103 zipcodes. The current data go from
1976.01 to 2009.09. Note that devvalz is the standard error on the HPI
estimates and hpvolz is the volatility of the HPI*/
use Data/hpzip.dta, clear
gen zipcode="Z"+string(zip)
gen year=int(hpdate)
gen month=round((hpdate-year)*100)
gen quarter=int((month-1)/3)+1
keep if quarter==4
sort zipcode year month
by zipcode year: egen hpi=mean(lphpiz)
by zipcode year: keep if _n==1
by zipcode: gen dhpy_zip=log(hpi[_n+1])-log(hpi[_n])
by zipcode: gen dhpy_zip4y=log(hpi[_n+1])-log(hpi[_n-3])
drop zip month quarter lphpiz hpvolz devvalz hpdate hpi
drop if dhpy_zip==.
sort zipcode year
save ziphpi.dta, replace

*******************************
*Clean up the 2000 Census Data
*******************************

*read in the ZCTA file where we have information on housing units and land area to calculate density
insheet using /href/data2/m1hxs02/Gas_price/May2009/ZCTA_zip.csv, comma name clear 
drop if units==0
gen zcta5=real(substr(stzip, 3, 7))
drop if zcta5==.
replace pop=subinstr(pop, "(part)", "", .)
gen temp=real(pop)
drop if temp==0
rename temp pop2000
gen landarea_km=landarea_meter/1000000
keep zcta5 pop2000 units landarea_km
gsort zcta5 -units
keep if zcta5~=zcta5[_n-1]
rename units units2000
rename landarea_km landarea2000
gen zipcode="Z"+string(zcta5)
gen density2000=log(units2000/landarea2000)
keep zipcode units2000 pop2000 density2000 landarea2000
sort zipcode
save density2000_zip.dta, replace

*read in census commute pattern data and measure the demand for gas
insheet using Data/traveltowork_2000_zip.csv, comma name clear
gen temp=real(zcta5)
drop if temp==.
gen zipcode="Z"+zcta5
drop zcta5 temp
foreach var of varlist travelworkers lt* gt* agg* totalworkers worker* {
	replace `var'=0 if `var'==.
}
gen m1_2000=(gt45lt60_oth+gt60_oth)/(lt30_oth+gt30lt45_oth+gt45lt60_oth+gt60_oth)
gen m2_2000=(agg30_oth+agg3045_oth+agg4560_oth+agg60_oth)/(lt30_oth+gt30lt45_oth+gt45lt60_oth+gt60_oth)
gen p2_2000=(agg30_pub+agg3045_pub+agg4560_pub+agg60_pub)/(lt30_pub+gt30lt45_pub+gt45lt60_pub+gt60_pub)
gen p3_2000=worker_pub/totalworkers
drop if m1==. | m2==. | p3==.

keep zipcode m1_2000 m2_2000 p2_2000 p3_2000
sort zipcode
merge 1:1 zipcode using density2000_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm2000_zip.dta, replace

*read in census zipcode level single family housing units data
insheet using Data/sngfamunits_2000_zip.csv, comma name clear
gen temp=real(zcta)
drop if temp==.
gen zipcode="Z"+zcta
drop zcta temp
foreach var of varlist units sngfam_detach sngfam_attach {
	replace `var'=0 if `var'==.
}
drop if units==0
gen sngfam2000=sngfam_detach+sngfam_attach
drop units sngfam_detach sngfam_attach
drop if sngfam2000==0
sort zipcode
merge 1:1 zipcode using comm2000_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm2000_zip.dta, replace

*read in census rural/urban data
insheet using Data/urbanrural_2000_zip.csv, comma name clear
gen temp=real(zcta5)
drop if temp==.
gen zipcode="Z"+zcta5
drop zcta5 temp
foreach var of varlist ruralunits urbanunits {
	replace `var'=0 if `var'==.
}
drop if totalunits==.
gen rural2000=(ruralunits/totalunits)
keep zipcode rural2000
sort zipcode
merge 1:1 zipcode using comm2000_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm2000_zip.dta, replace

*read in census demographic data
insheet using Data/census_demo.csv, comma name clear
gen temp=real(zcta)
drop if temp==.
gen zipcode="Z"+zcta
drop zcta temp
foreach var of varlist pop white black occ_units occ_own occ_rent {
	replace `var'=0 if `var'==.
}
drop if pop==0 | occ_units==0
gen white2000=(white/pop)
gen black2000=(black/pop)
gen tenure2000=(occ_own/occ_units)
rename income income2000
rename hv hv2000
keep zipcode white2000 black2000 tenure2000 income2000 hv2000
sort zipcode
merge 1:1 zipcode using comm2000_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm2000_zip.dta, replace

*read in number of rooms
insheet using Data/census2000_rooms.csv, comma name clear
gen temp=real(zcta)
drop if temp==.
gen zipcode="Z"+zcta
drop zcta temp
drop if h023001==.
gen avgrooms2000=h025001/h023001
keep zipcode avgrooms
sort zipcode
merge 1:1 zipcode using comm2000_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm2000_zip.dta, replace

*******************************
*Clean up the 1990 Census Data
*******************************

/*First get the commute time and single family units data.
Mike Mulhall helped extract the data from the 1990 census CD */
use Data/census_1990.dta, clear
drop if sac10==""
gen zipcode="Z"+string(real(sac1))
gen sngfam1990=h0200001+h0200002
drop if sngfam1990==0
drop h020*
gen travelworkers=p0490001+p0490002+p0490003+p0490004+p0490005+p0490006+p0490007+p0490008+p0490009+p0490010+p0490011+p0490012
drop if travelworkers==0
gen m1_1990=(p0500010+p0500011+p0500012)/travelworkers
drop p050*
gen m2_1990=p0510001/travelworkers
drop p051*
gen p3_1990=(p0490003+p0490004+p0490005+p0490006+p0490007+p0490008)/travelworkers
drop p049*
keep zipcode sngfam1990 m1_1990 m2_1990 p3_1990
sort zipcode
save comm1990_zip.dta, replace

/*Next get the average rooms to control for heating cooling costs.
Mike Mulhall helped extract the data from the 1990 census CD*/
use Data/census_1990_rooms.dta, clear
drop if sac10==""
gen zipcode="Z"+string(real(sac1))
gen totalunits=h0160001+h0160002+h0160003+h0160004+h0160005+h0160006+h0160007+h0160008+h0160009
gen avgrooms1990=h0170001/totalunits
drop if avgrooms1990==.
keep zipcode avgrooms1990
sort zipcode
merge 1:1 zipcode using comm1990_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm1990_zip.dta, replace

/*This is to get the density variable for each zipcode.
Unfortunately 1980 Census CD does not have units and area variables by zipcode.
I asked my RA Lindsay Relihan to download the 1990 data from the website
http://mcdc2.missouri.edu/websas/geocorr90.shtml suggested by Census staff.
(note that area is in square km) */
insheet using Data/density_census90_relihan.csv, comma name clear
drop if units==0
gsort zip -units
keep if zip~=zip[_n-1]
rename units units1990
rename area landarea1990
gen zipcode="Z"+string(zip)
drop zip
gen density1990=log(units1990/landarea1990)
keep zipcode units1990 landarea1990 density1990
sort zipcode
merge 1:1 zipcode using comm1990_zip.dta
keep if _m==3
drop _m
sort zipcode
save comm1990_zip.dta, replace

*******************************
*Clean up the 1980 Census Data
*******************************

use Data/census1980_zip.dta, clear
rename stfips stfips1980
rename medinc income1980
rename urbanrural1 units1980
rename sngfam_units sngfam1980
rename m1 m1_1980
rename m3 m3_1980
gen m2_1980=exp(m2)
rename p3 p3_1980
rename avgrooms avgrooms1980
rename rural rural1980
keep zipcode *1980
sort zipcode
save comm1980_zip.dta, replace

********************************************
*Clean up the zipcode to CBSA mapping file
********************************************

/*note that before, I had used Ron's data.
Here I use the LP zipcode to CBSA mapping file */
insheet using Data/CBSA_Zip_mapping.csv, comma name clear
drop if state=="PR"
gen zipcode="Z"+string(zip_code)
gen metro=(strmatch(cbsa_desc, "* Metropolitan *")==1)
tab metro
keep if metro==1
drop metro
rename cbsa_code cbsacode
rename cbsa_desc cbsaname
rename state_code stfips
rename fips_code cntyfips
keep zipcode cbsacode cbsaname stfips cntyfips
sort cbsacode
by cbsacode: gen zipcount=_N
sum zipcount if cbsacode~=cbsacode[_n-1], d

*********************************************************************
*Save a Balanced Panel from 1980 to 2009 using the 1980 Commute Time
*********************************************************************

sort zipcode
merge 1:1 zipcode using comm1980_zip.dta
keep if _m==3
drop _m
sort cbsacode zipcode
by cbsacode: gen temp=1 if zipcode~=zipcode[_n-1]
by cbsacode: egen totcount=sum(temp)
by cbsacode: egen temp1=max(m2_1980)
by cbsacode: egen temp2=min(m2_1980)
gen totdiffcomm1980=temp1-temp2
drop temp*
sort zipcode
save zip_to_cbsa.dta, replace

use ziphpi.dta, clear
merge m:1 zipcode using comm1980_zip.dta
keep if _m==3
drop _m
sort zipcode
merge m:1 zipcode using comm1990_zip.dta
keep if _m==3
drop _m
sort zipcode
merge m:1 zipcode using comm2000_zip.dta
keep if _m==3
drop _m
sort zipcode
merge m:1 zipcode using zip_to_cbsa.dta
keep if _m==3
drop _m
sort year
merge m:1 year using temp_aggdata.dta
keep if _m==3
drop _m

*more restrictions on zipcode to make sure the zipcode boundary did not change between 1980 and 2000.
drop if stfips1980~=stfips
gen ratiola=log(landarea2000/landarea1990)
drop if ratiola>1.5 | ratiola<-1
drop ratio*

gen density1980=log(units1980/landarea1990)
sort cbsacode zipcode year
by cbsacode: gen temp=1 if zipcode~=zipcode[_n-1]
by cbsacode: egen count=sum(temp)
drop if count==1
by cbsacode: egen temp1=max(m2_1980)
by cbsacode: egen temp2=min(m2_1980)
gen diffcomm1980=temp1-temp2
by cbsacode: egen sdcomm1980=sd(m2_1980)
drop temp*
drop if year<1980

sort cbsacode year
merge m:1 cbsacode year using Data/empincbymsa.dta
drop if _m==2

foreach i of numlist 1/5 {

	gen drgpy`i'_m24=drgp_ly`i'*(m2_1980>=24)
	gen dgdpy`i'_m24=dgdp_ly`i'*(m2_1980>=24)
	gen dempy`i'_m24=demp_ly`i'*(m2_1980>=24)
	gen dincy`i'_m24=dinc_ly`i'*(m2_1980>=24)
	gen dfrmy`i'_m24=dfrm_ly`i'*(m2_1980>=24)
	gen dcomy`i'_m24=dcom_ly`i'*(m2_1980>=24)

	gen drgpy`i'_dens=drgp_ly`i'*density1980
	gen dhccy`i'_rm=dhcc_ly`i'*log(avgrooms1980)
	
	gen mempy`i'_m24=dltotemp`i'*(m2_1980>=24)
	gen mincy`i'_m24=dlrincpc`i'*(m2_1980>=24)
}

log using Codes/gphv_setup.log, replace
**********************
*Summary Statistics
**********************

sort zipcode year
sum m2_1980 if zipcode~=zipcode[_n-1], d
sum dhpy_zip, d
scalar cpi1977=60.6
scalar cpi1978=65.2
scalar cpi1979=72.6
scalar cpi1980=82.4
scalar cpi1981=90.9
scalar cpi1982=96.5
scalar cpi1983=99.6
scalar cpi1984=103.9
scalar cpi1985=107.6
scalar cpi1986=109.6
scalar cpi1987=113.6
scalar cpi1988=118.3
scalar cpi1989=124.0
scalar cpi1990=130.7
scalar cpi1991=136.2
scalar cpi1992=140.3
scalar cpi1993=144.5
scalar cpi1994=148.2
scalar cpi1995=152.4
scalar cpi1996=156.9
scalar cpi1997=160.5
scalar cpi1998=163.0
scalar cpi1999=166.6
scalar cpi2000=172.2
scalar cpi2001=177.1
scalar cpi2002=179.9
scalar cpi2003=184.0
scalar cpi2004=188.9
scalar cpi2005=195.3
scalar cpi2006=201.6
scalar cpi2007=207.3
scalar cpi2008=215.3
gen rhpy_zip=.
foreach i of numlist 1980/2007 {
	local j=`i'+1
	replace rhpy_zip=dhpy_zip-log(cpi`j'/cpi`i') if year==`i'
}
sum dhpy_zip
sum rhpy_zip, d
gen rhpy_zip4y=.
foreach i of numlist 1980/2007 {
	local j=`i'+1
	local k=`i'-3
	replace rhpy_zip4y=dhpy_zip4y-log(cpi`j'/cpi`k') if year==`i'
}
sum dhpy_zip4y, d
sum rhpy_zip4y, d

sort year zipcode
sum drgp if year~=year[_n-1], d
codebook zipcode
codebook cbsacode
sort cbsacode zipcode year
sum count if cbsacode~=cbsacode[_n-1], d
sum landarea1990 if zipcode~=zipcode[_n-1], d
sum units1980 if zipcode~=zipcode[_n-1], d
sum m2_1980 if zipcode~=zipcode[_n-1], d

keep zipcode cbsacode cbsaname year dhpy_zip* rhpy*_zip* d*_m* d*_dens d*_rm m*_m* sngfam1980 income1980 m2_1980 p3_1980 m2_2000 p2_2000 density1980 stfips1980 count totcount diffcomm1980 totdiffcomm1980 rural1980 m3_1980 landarea1990 sdcomm1980 units1980 density2000
egen cbsatime=group(cbsacode year)
gen zip=real(substr(zipcode, 2, 6))
sort zip
capture drop _m
merge m:1 zip using Data/zip_to_place_1990.dta
drop if _m==2
drop _m hh1990 alloc_factor
sort place zipcode year
compress

save Data/zip19802009_panel.dta, replace

log close

****************************
*Erase temporary files
****************************

capture erase temp_aggdata.dta
capture erase ziphpi.dta
capture erase density2000_zip.dta
capture erase comm1980_zip.dta
capture erase comm1990_zip.dta
capture erase comm2000_zip.dta
capture erase zip_to_cbsa.dta

/*END OF THE DO FILE*/
