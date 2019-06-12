
clear
set more off

clear 

cd "youroutputpath"
log using table4, replace

use "yourpath/0409.dta"



merge m:1 sic using "Data\Stata\EFD_low_and_high.dta"
keep if _merge==1 | _merge==3
drop _merge 


/* create a number of variables and interactions */ 
gen growthrate=growthrate_0709
drop state_fips
gen state_fips=floor(fips/1000)
gen double state_industry=state_fips*100+sic2
gen county_industry=fips*100+sic2
gen naics4=floor(naics/100)
gen double county_naics4=fips*10000+naics4
gen double county_naics3=fips*10000+naics3
gen double state_naics4=state_fips*10000+naics4
gen double state_naics3=state_fips*10000+naics3


gen younghigh_alt=young_alt*high
gen smallhigh=small*high
gen largehigh=large*high
gen large_50=0
replace large_50=1 if small==0
gen large_50high=large_50*high
gen large_50younghigh=large_50*young*high
gen large_50young=large_50*young
gen mediumhigh=medium*high
gen youngsmall=young*small
gen youngsmall_alt=young_alt*small
gen youngsmallhigh= young*small*high
gen youngsmallhigh_alt= young_alt*small*high
gen largeyoung=large*young
gen mediumyoung=medium*young
gen largeyounghigh=largeyoung*high
gen mediumyounghigh=mediumyoung*high
gen largeyoung_alt=large*young_alt
gen mediumyoung_alt=medium*young_alt
gen largeyounghigh_alt=largeyoung_alt*high
gen mediumyounghigh_alt=mediumyoung_alt*high
gen medium_duygan_bump=0
replace medium_duygan_bump=1 if small_duygan_bump==0 & large==0
gen medium_duygan_bumphigh=medium_duygan_bump*high
gen medium_duygan_bumpyoung=medium_duygan_bump*young
gen medium_duygan_bumpyounghigh=medium_duygan_bump*young*high
gen youngsmall_duygan_bump=small_duygan_bump*young
gen youngsmall_duygan_bumphigh=youngsmall_duygan_bump*high
gen large_duygan_bumpyounghigh=large_duygan_bump*young*high
gen large_duygan_bumpyoung=large_duygan_bump*young

  
  
gen old=0
replace old=1 if young==0
gen oldhigh=old*high

gen old_alt=0
replace old_alt=1 if young_alt==0
gen oldhigh_alt=old_alt*high


/*
  inter_recsmall=recession0709*small;
    highinterrecsmall=ext_dep_high*inter_recsmall;
    highsmall=small*ext_dep_high;
    highrec=ext_dep_high*recession0709;
    high_state=ext_dep_high*state_fips;
    high_sic2=ext_dep_high*sic2;

    if year-min_setup_year<7 then young=1;
    if year-min_setup_year>=7 then young=0;

    if year-min_setup_year<5 then young_alt=1;
    if year-min_setup_year>=5 then young_alt=0;

    youngsmall=young*small;
    youngsmallhigh=young*small*ext_dep_high;
    youngsmallrecession=young*small*recession0709;
    youngsmallrecessionhigh=young*small*highrec;
    younghigh=young*ext_dep_high;
    youngrec=young*recession0709;
    younghighrecession=young*highrec;

    large=(initial_emp_firm>500);
    if year=2009 then recession0709=1;

    largerec=large*recession0709;
    largehigh=large*ext_dep_high;
    largehighrecession=large*highrec;
*/



gen large_rec = large*recession0709
gen large_rec_high =large_rec*high
gen large_rec = large*recession0709
gen large_rec_high =large_rec*high
gen small_rec =small*recession0709
gen small_rec_high=small_rec*high
gen large_50_rec=large_50*recession0709
gen large_50_rec_high =large_50_rec*high
gen medium_rec =medium*recession0709
gen medium_rec_high=medium_rec*high
gen recession0709high=recession0709*high


gen young_rec =young*recession0709
gen old_rec =old*recession0709
gen youngsmallrec =youngsmall*recession0709
gen young_rec_high =young_rec*high
gen old_rec_high =old_rec*high
gen youngsmallrechigh=youngsmallrec*high

gen small_duygan_bump_rec =small_duygan_bump*recession0709
gen small_duygan_bumphigh_rec= small_duygan_bumphigh*recession0709
gen large_duygan_bump_rec =large_duygan_bump*recession0709
gen large_duygan_bumphigh_rec=large_duygan_bumphigh*recession0709


gen medium_duygan_bump_rec =medium_duygan_bump*recession0709
gen medium_duygan_bumphigh_rec=medium_duygan_bumphigh*recession0709

gen youngsmall_duygan_bump_rec=youngsmall_duygan_bump*recession0709
gen youngsmall_duygan_bumphigh_rec=youngsmall_duygan_bumphigh*recession0709


gen state_industry_year=state_industry*10+recession0709


forval i=4 {
capture erase table`i'.tex
capture erase table`i'.txt
capture erase table`i'.xml
capture erase table`i'.rtf
capture erase table`i'.doc
capture erase table`i'.xls

}

/* Whole Sample table 3 and 4 */ 
local varreg "small smallhigh recession0709 recession0709high   small_rec   large_rec small_rec_high  large_rec_high large largehigh medium medium_rec medium_rec_high"
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table4, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_rec_high-large_rec_high=0


local varreg "young younghigh recession0709 recession0709high   old oldhigh young_rec old_rec young_rec_high old_rec_high "
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table4, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test young_rec_high-old_rec_high=0




local varreg "young younghigh recession0709 recession0709high   old oldhigh young_rec old_rec young_rec_high old_rec_high small smallhigh recession0709 recession0709high   small_rec   large_rec small_rec_high  large_rec_high large largehigh medium medium_rec medium_rec_high"
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table4, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test young_rec_high-old_rec_high=0



local varreg "small smallhigh  recession0709 recession0709high  small_rec  large_rec small_rec_high large_rec_high large largehigh young younghigh old oldhigh young_rec old_rec young_rec_high old_rec_high youngsmall youngsmallhigh youngsmallrec youngsmallrechigh  medium medium_rec  medium_rec_high"
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table4, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel



log close 





