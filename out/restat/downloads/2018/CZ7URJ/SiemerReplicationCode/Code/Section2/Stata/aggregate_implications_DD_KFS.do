
clear
set more off


cd "yourresultpath"
log using table10_small, replace
use "yourpath2\0709all.dta"


merge m:1 sic using "Data\Stata\EFD_low_and_high.dta"
keep if _merge==1 | _merge==3
drop _merge 

gen employment_2007=initial_emp_firm
gen employment_2009=mean_emp_firm



gen naics2=floor(naics3/10)
merge m:1 naics2 using "Data\Stata\Kauffman_DA_2004_2006.dta"
drop _merge




gen small_Kaufman_high=small*Kaufman_high
gen large_Kaufman_high=large*Kaufman_high
gen young_Kaufman_high=young*Kaufman_high
gen old_Kaufman_high=old*Kaufman_high
drop if missing(Kaufman_high)


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


areg growthrate small smallhigh    large largehigh medium , absorb(state_industry) vce(cluster state_fips)


predict ghat,xb

gen employment_2009_hat=(1+0.5*ghat)/(1-0.5*ghat)*employment_2007 

gen employment_2007_small=employment_2007*small 


save temp, replace
foreach small_shock in 0.073 0.113 {

*plug in estimate coefficient 
disp(`small_shock')
scalar DD_estimate=`small_shock' /* put in the DD estimate (or DDD) estimate */

gen g_counterfactual=ghat
replace g_counterfactual=ghat+DD_estimate if small==1 & high==1

/* note that this growthrate by definition can not be larger than 2, thus need to impose that */ 

replace g_counterfactual=2 if g_counterfactual>2 
replace g_counterfactual=-2 if g_counterfactual<-2 


gen employment_2009_counterfactual=(1+0.5*g_counterfactual)/(1-0.5*g_counterfactual)*employment_2007 


collapse (sum) employment_2009_hat employment_2009_counterfactual employment_2007  employment_2007_small


gen DD_estimate=-`small_shock'
gen employment_loss_explained=employment_2009_counterfactual-employment_2009_hat
keep DD_estimate employment_loss_explained 


export excel using "C:\Users\siemer_m\Documents\Results_new\Aggregate\aggregate_impact_DD_KFS.xlsx", firstrow(variables) sheet(`small_shock') sheetreplace


}
log close
