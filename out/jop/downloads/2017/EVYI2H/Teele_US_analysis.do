***********************************************************
*Replication file that analyzes the datasets for Teele, Dawn Langan. (2018?) "How the West Was Won: Competition, Mobilization, and Women’s Enfranchisement in the United States." Journal of Politics. 
**********************************************************


*cd "./Teele_replication" /*set your working directory*/ 
set more off
version 14.1

* install the following packages: 
*coefplot find it here:  /*http://repec.sowi.unibe.ch/files/wp1/jann-2013-coefplot.pdf*/ 
*ssc install sutex
*ssc install eststo
 
***********************
*Summary Statistics -- Table 1
***********************


use "US_master_session", clear
sutex passed_both nawsa_membpc comp_nyears_s comp_majsurplus* machine_peop comp_split comp_thirdfrac comp_runnertowinner* dt_property dt_sole dt_earnings dt_secretballot initiative_adopted dt_directprimary fraction_dry_counties  wctu_dues MFratio ,labels minmax file("./output/sumstats.tex")  replace digits(2)


***********************
*Regressions for Paper
***********************
use "US_master_session", clear


****Standard Model -- Table 2


eststo clear 

foreach var in  comp_nyears comp_majsurplus* comp_split comp_thirdfrac comp_runnertowinner* {

set more off

eststo: xtreg passed_both nawsa_membpc `var'  yearmin, fe robust cluster(scode1) 

}

eststo: xtreg passed_both nawsa_membpc machine_peo  yearmin totalpop , fe robust cluster(scode1) 
	  
*baseline
esttab using "./output/passed_both.csv", wrap   nomti  compress replace sca( r2) se title("Dependent Variable: Full Women's Suffrage bill passed both houses of state legislature" \label{Tab:logit}) addnotes("Table reports standard coefficients from panel logistic regressions." "Standard errors robust to heteroskedasticity, clustered at the state level, are in parentheses." "Number of states: 45, number of passages:  56. Interpretations are given in text." ) order(nawsa_membpc comp_nyears* comp_majsurplus* machine_share machine_pe* comp_split comp_thirdfrac comp_runnertowinner* decade* )  


*Predictive Margins describing coefficients at relative points as described in the results section of text. 

*machine people 
xtreg passed_both nawsa_membpc machine_people totalpop yearmin , fe robust cluster(scode1) 
eststo marg_machine_suff: margins, atmeans at(nawsa_membpc=(0 .34  0.96 ))  post 
coefplot, at

*Third frac
xtreg passed_both nawsa_membpc comp_thirdfrac  yearmin , fe robust cluster(scode1) 
eststo marg_comp_thirdfrac: margins, atmeans at(nawsa_membpc=(0 .34  0.96 ))  post /*.34 is mean and .96 is plus one sd */ 
coefplot marg_comp_thirdfrac, at 

*Majority Surplus
xtreg passed_both nawsa_membpc comp_majsurplus  yearmin , fe robust cluster(scode1) 
eststo marg_comp_majsurplus: margins, atmeans at(comp_majsurplus=(0 .267  .41))  post /*.267 is mean, .14 sd, so .41 is a sd above */ 
 coefplot marg_comp_majsurplus, at 
 
*third frac 
sum comp_thirdfrac
xtreg passed_both nawsa_membpc comp_thirdfrac  yearmin , fe robust cluster(scode1) 
eststo marg_comp_thirdfrac2: margins, atmeans at(comp_thirdfrac=(0 .03  .135 ))  post /*.03 is mean .1013 is sd. */ 
coefplot marg_comp_thirdfrac2, at 

*machine people 
sum machine_people
xtreg passed_both nawsa_membpc machine_people totalpop yearmin , fe robust cluster(scode1) 
eststo marg_machine_people: margins, atmeans at(machine_people=(0 9.66  26.23))  post /*9.66 is mean 26.23 is + sd. */
coefplot marg_machine_people, at  



*************************

****Interactive Model (for online appendix)

eststo clear 
foreach var of varlist comp_nyears_s comp_majsurplus* machine_share machine_per machine_peo comp_split comp_RepBoth comp_thirdfrac comp_runnertowinner* {

set more off
gen nX`var'=`var'*nawsa_membpc
*eststo: xtreg passed_both nawsa_membpc `var'  , fe robust cluster(scode1) 
eststo: xtreg passed_both nawsa_membpc nX`var' `var' , fe robust cluster(scode1) 

drop nX`var'

}
	  
*baseline
esttab using "./output/passed_both_intlnawsa.rtf", wrap   nomti label compress replace sca( chi2) se title("Dependent Variable: Full Women's Suffrage bill passed both houses of state legislature" \label{Tab:logit}) addnotes("Table reports standard coefficients from panel logistic regressions." "Standard errors robust to heteroskedasticity, clustered at the state level, are in parentheses." "Number of states: 45, number of passages:  56. Interpretations are given in text." ) order(nawsa comp_nyears_s* comp_majsurplus* machine_share machine_pe* comp_split comp_RepBoth comp_thirdfrac comp_runnertowinner* nX* ) nonotes 



***********************************************************************************
*Figures in Main Paper
************************************************************************************

*************
*Figure 2: NAWSA Membership
*************

use US_master_panel, clear

collapse (mean) nawsa_membpc (sum) nawsa_member, by(region1 year)
sort year

gen w = "w" 
gen ne = "n"
gen mw = "m"
gen s = "s"


*region1 label: (1 "Midwest") label(2 "Northeast") label(3 "South") label(4 "West")

#delimit ; 

twoway 
(connected nawsa_membpc year if region1==1, msize(small) mlab(mw) mlabpos(0.3) msym(none) lcolor(gs9) mcolor(gs9)) 
(connected nawsa_membpc year if region1==2, msize(small) mlab(ne) mlabpos(0.3) msym(none)  lcolor(gs12) mcolor(gs12)) 
(connected nawsa_membpc year if region1==3, msize(small) mlab(s) mlabpos(0.3) msym(none) lcolor(gs2) mcolor(gs2)) 
(connected nawsa_membpc year if region1==4, msize(small) mlab(w) mlabpos(0.3) msym(none) lcolor(gs5) mcolor(gs5) ) if year>=1890 , 

legend( ring(0) position(11) col(1) label(1 "Midwest") label(2 "Northeast") label(3 "South") label(4 "West") order(4 2 1 3) )
ytitle("members per thousand, averaged by region") scheme(s1mono) ; 

# delimit cr

graph export "./output/nawsa_membpc.pdf", replace 


*************
*Figure 3: Regional variation in Party Structure and Political Competition
*****************


 use US_master_panel.dta, clear
 keep if year>=1870 & year<1920

 la var comp_majsurplus "Majority Surplus"
la var comp_nyears_s "Longevity Ruling Party" 
la var machine_share "Frac. Machine City" 
la var machine_per "Frac. Pop. Machine" 
la var comp_thirdfrac "Frac. Third Party"
la var comp_runnertowinner "Runner-up to Winner" 
la var comp_samecontrol "Power Split Across Branches" 
 *keep variable name before collapse
foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }
collapse (mean) comp_nyears_sameparty comp_majsurplus machine_share machine_percentcitypop machine_people comp_split comp_thirdfrac comp_runnertowinner comp_samecontrol comp_majorityonly comp_supermajority comp_RepBoth comp_DemBoth comp_ThirdBoth, by(region1 decade) 

*attach saved labels after collapse
foreach v of var * {
 	label var `v' "`l`v''"
  }
  
  
sort decade 

gen w = "w" 
gen ne = "n"
gen mw = "m"
gen s = "s"



local a "./output" 
set more off 
*
foreach var in comp_nyears_sameparty comp_majsurplus machine_peo comp_split comp_thirdfrac comp_runnertowinner comp_samecontrol comp_majorityonly comp_supermajority comp_RepBoth comp_DemBoth comp_ThirdBoth  {

local lbvar : variable label `var' 

#delimit ; 
twoway 
(connected `var' decade if region1==1, mlabsize(huge) mlab(mw) mlabpos(0) msym(none) lcolor(gs9) mcolor(gs9) lwidth(thick) ) 
(connected `var' decade if region1==2, mlabsize(huge) msize(vhuge) mlab(ne) mlabpos(0) msym(none)  lcolor(gs2) mcolor(gs2) lwidth(thick) ) 
(connected `var' decade if region1==3, mlabsize(huge) msize(vhuge) mlab(s) mlabpos(0) msym(none) lcolor(gs12) mcolor(gs12) lwidth(thick) ) 
(connected `var' decade if region1==4, mlabsize(huge) msize(vhuge) mlab(w) mlabpos(0) msym(none) lcolor(red) mcolor(gs5) lwidth(thick)  ) , 

legend( ring(0) position(11) col(1) label(1 "Midwest") label(2 "Northeast") label(3 "South") label(4 "West") order(4 2 1 3 ) )
ytitle("mean") xtitle("") subtitle("`lbvar'",size(huge)) scheme(s1mono) xlabel( 1865 "1870s" 1875 "1880s" 1885 "1890s"  1895 "1900s" 1905 "1910s" 1915 "1920s", tlwidth(vhuge) labsize(large)) name(`var', replace)  legend(off) ylabel(, labsize(large)) ; 
# delimit cr

graph export "`a'/decade`var'.pdf", replace 

} 




*************
*Figure 4: Raw Data Plots of interaction effects following Hainmueller et al. (2016)
*Some of these charts appear only in the online appendix. 
*****************
****************************************
*Raw Data Graphs for Continuous Competition Variables. 
****************************************
use "US_master_session", clear


*Terciles of mobilization 
sum nawsa_membpc, detail
_pctile nawsa_membpc,  p(33 66 99)
return list 
gen NLMH=. 
replace NLMH = 0 if nawsa_membpc<=`r(r1)' 
replace NLMH = 1 if  nawsa_membpc>`r(r1)' & nawsa_membpc<=`r(r2)' 
replace NLMH = 2 if  nawsa_membpc>`r(r2)' & nawsa_membpc<=`r(r3)' 
label define NLMH 0 "Mobilization Low" 1 "Mobilization Medium" 2 "Mobilization High"
label values NLMH NLMH

 *

foreach var in  comp_nyears comp_runnertowinner comp_majsurplus { 
	
		local lb_var : variable label `var'
		ren `var' d
		ren nawsa_membpc x
		ren passed_both y

		sum d, detail
		_pctile d, p(10(10)99)
		*gen competition bins
		egen bins=cut(d), at(`r(r1)' `r(r2)' `r(r3)' `r(r4)' `r(r5)' `r(r6)' `r(r7)' `r(r8)' `r(r9)')
		egen bin_it_up = mean(y), by(NLMH bins )
		
	
		label define title 0 "Suffrage Support" 1 "" 2 ""
		
				
	forval n=0/2 {
			egen nobs_`n'=count(bins) if NLMH==`n', by(bins)
			local f`n': label NLMH `n'
			count if NLMH== `n'
			local N=`r(N)'
			sum d if NLMH== `n'
			local avX =round(`r(mean)',.01)
			sum y if NLMH==`n'
			local avY=round(`r(mean)',.01)
			
			local t`n': label title `n'
			
			sum d
			local rm=`r(min)'
			local rma=`r(max)'
			
			gen wsize=nobs_`n'/bins

			*  mlabsize(huge) mlabsize(small) mlabel(nobs_`n')
			# delimit  ;
			twoway 	(scatter bin_it_up bins if NLMH == `n' [w=nobs_`n'],  msize(small)  msym(oh)  mcolor(sand))
					(lowess y d if NLMH == `n' ,  lcolor(green) lpattern(line) lwidth(thick) ) 
					(lfit y d  if NLMH == `n', lcolor(gs4) lwidth(thick)) , 
					legend(off) xtitle("") yscale(range(0 .5)) xscale(range(`rm' `rma')) ylab(0(.10).5) ytitle("`t`n''", size(vhuge))  subtitle("`f`n'', n=`N'", size(huge)) name(g`n', replace) scheme(tufte)   text( `avY' `avX' "+", color(red)) ;
					
			graph export "./output/raw_`var'_tercile`n'.pdf", replace ;
			
			# delimit cr
			drop wsize

				}  
				
				

ren d `var' 
ren x nawsa_membpc 
ren y passed_both 
drop bin*
drop nobs*
	label drop title
 
}

**************************
* Machine variable and third frac. (also for the interaction effects) 


use "US_master_session", clear
sum nawsa_membpc, detail
_pctile nawsa_membpc,  p(33 66 99)
return list 
gen NLMH=. 
replace NLMH = 0 if nawsa_membpc<=`r(r1)' 
replace NLMH = 1 if  nawsa_membpc>`r(r1)' & nawsa_membpc<=`r(r2)' 
replace NLMH = 2 if  nawsa_membpc>`r(r2)' & nawsa_membpc<=`r(r3)' 
label define NLMH 0 "Mobilization Low" 1 "Mobilization Medium" 2 "Mobilization High"
label values NLMH NLMH

*For the code to run for comp_thirdfrac it NEEDS _pctile d, p(60(10)99) because SO many zeroes. 
*Terciles of mobilization 

***these very skewed variables need different bins  Note that if comp_thirdfrac is in the loop need to use the differet percentile bins because of how skeweed the data is. 
*comp_thirdfrac
foreach var in  machine_peo machine_share machine_percent  { 
		local lb_var : variable label `var'
		ren `var' d
		ren nawsa_membpc x
		ren passed_both y

		sum d, detail
		_pctile d , p(51(10)99)  /*all other variables */ 
		*_pctile d , p(60(10)99)   /*if `var'==comp_thirdfrac */ 
		return list
		*gen competition bins
		egen bins=cut(d), at(`r(r1)' `r(r2)' `r(r3)' `r(r4)' `r(r5)' `r(r6)')
		egen bin_it_up = mean(y), by(bins NLMH)
		
		label define title 0 "Suffrage Support" 1 "" 2 ""
				
	forval n=0/2 {
			egen nobs_`n'=count(bins) if NLMH==`n', by(bins)
			local f`n': label NLMH `n'
			count if NLMH== `n'
			local N=`r(N)'
			sum d if NLMH== `n'
			local avX =round(`r(mean)',.01)
			sum y if NLMH==`n'
			local avY=round(`r(mean)',.01)
			local t`n': label title `n'
			
			# delimit  
			twoway 	(scatter bin_it_up bins if NLMH == `n' [w=nobs_`n'],  msize(small)  msym(oh)  mcolor(sand))
					(lowess y d if NLMH == `n' ,  lcolor(green) lpattern(line) lwidth(thick) ) 
					(lfit y d  if NLMH == `n', lcolor(gs12) lwidth(thick) ) , 
					legend(off) xtitle("") yscale(range(.0 .5)) xsca(range(0(.34) 1)) ylab(0(.10).5) ytitle("`t`n''", size(vhuge))  subtitle("`f`n''", size(huge)) name(g`n', replace) scheme(tufte)  text( `avY' `avX' "+", color(red)) ;
			
			graph export "./output/raw_`var'`n'.pdf", replace ;
			# delimit cr
				} 			

ren d `var' 
ren x nawsa_membpc 
ren y passed_both 
drop bin*
drop nobs*
label drop title

}
*/ 


*Raw data plots for binary variables have their own needs in terms of the bin cut points. 
use "US_master_session", clear

egen bins2 = cut(nawsa_membpc), at(0 0.0325 .15 .44 .8 )
_pctile nawsa_membpc, p(10(10)99)

foreach var in comp_split { 
local lb_var : variable label `var'
label values `var' NO 
local f0: label `var' 0
di "`f0'"
local f1: label `var' 1
di "`f1'"

*rename variables 
	ren `var' d
	*replace d=1-d /*so now 1="NO super majority" and 0="Super Majority" */ 
	ren nawsa_membpc x
	ren passed_both y

	egen bin_it_up = mean(y), by(bins d) /*take the average share of passed_both by percentiles of mobilization and binary outcomes the explanatory variable. */  

	egen nobs_0=count(bins) if d==0, by(bins)
	egen nobs_1=count(bins) if d==1, by(bins)
	
*conditioning graphs on x<1 because that is where the 90th percentile of the distribution is and it is highly skewed. 
	
*first do the 1 case.

			count if d== 1
			local N=`r(N)'
			sum x if d== 1
			local avX =round(`r(mean)',.01)
			sum y if d== 1
			local avY=round(`r(mean)',.01)
			_pctile x, p(10(10)99)
*return list 
*,  mlab(nobs_1) msym(oh) mlabsize(huge) msize(huge) mcolor(red)
#delimit;
twoway 
	(scatter bin_it_up bins if d == 1  & x<1 [w=nobs_1],  msize(small)  msym(oh)  mcolor(sand))
	(lowess y x  if d == 1 & x<1, lcolor(green) lwidth(thick) lpattern(line) )
	(lfit y x  if d == 1 & x<1, lcolor(gs12)  lwidth(thick) ),
	subtitle("YES, n=`N'", size(huge))
	xtitle("") yscale(range(.0 .5)) xsca(range(0(.34) 1)) ylab(0(.10).5) ytitle("Suffrage Support", size(huge)) xline(.33, lcolor(gs12)) xlab(`r(r1)' "p10"  `r(r3)' "p30" `r(r4)'  "p50"  `r(r6)'  "p70"  `r(r9)' "p90", alt) legend(off) scheme(tufte) text( `avY' `avX' "+", color(red))
	name(g1, replace) ; 
	
	# delimit cr
graph export "./output/raw_`var'0.pdf", replace
	
	

*return list 
*now do the 0 case. 
			count if d== 0
			local N=`r(N)'
			sum x if d== 0
			local avX =round(`r(mean)',.01)
			sum y if d== 0
			local avY=round(`r(mean)',.01) 
			_pctile x, p(10(10)99)
#delimit;
twoway 
	(scatter bin_it_up bins if d == 0 & x<1 [w=nobs_0],  msize(small)  msym(oh)  mcolor(sand))
	(lowess y x  if d == 0 & x<1, lcolor(green) lwidth(thick)  lpattern(line) )
	(lfit y x  if d == 0 & x<1, lcolor(gs12)  lwidth(thick) ), 
		 xtitle("") yscale(range(.0 .5)) xsca(range(0(.34) 1)) ylab(0(.10).5) ytitle("") xline(.33, lcolor(gs12))   xlab(`r(r1)' "p10"  `r(r3)' "p30" `r(r4)'  "p50"  `r(r6)'  "p70"  `r(r9)' "p90", alt )   subtitle("NO, n=`N'", size(huge)) legend(off) 
		name(g0, replace)  scheme(tufte)  text( `avY' `avX' "+", color(red)) ;
# delimit cr
graph export "./output/raw_`var'1.pdf", replace

ren d `var' 
ren x nawsa_membpc 
ren y passed_both 
drop nobs*
drop bin_it_up

}











****************************************************
*Figure 4: Alternative Explanation graphs
****************************************************
 use US_master, clear
 label define region1 1 "MW" 2 "NE" 3 "S" 4 "W" 
 label values region1 region1 
  
 
 *keep variable name before collapse
foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }
 
 collapse (mean) dt_secretballot dt_directprimary initiative_adopted dt_property dt_earnings dt_sole, by(region1)
 
 
*attach saved labels after collapse
foreach v of var * {
 	label var `v' "`l`v''"
  }
  


 
 *round(`var',.1)
 
foreach var of varlist dt_property dt_sole dt_earnings dt_secretballot initiative_adopted dt_directprimary  {

local lbvar : variable label  `var'

sum `var'
local amin = round(`r(min)',1)-5
local amax = round(`r(max)',1)+5

graph bar `var', over(region1) name("`var'", replace) subtitle("`lbvar'") nodraw ytitle("") ylab(1860 "1860" 1880 "1880" 1900 "1900" 1920 "1920" ) exclude0 blabel(bar,  format(%9.0f) )
}

graph combine dt_property dt_sole dt_earnings dt_secretballot initiative_adopted dt_directprimary
graph display, scheme(s1mono)
graph export "./output/bargraphCulture.pdf", replace


use US_master_panel, clear
 label define region1 1 "MW" 2 "NE" 3 "S" 4 "W" 
 label values region1 region1 
 
 la var fraction_dry "Fraction Counties Dry"
 la var wctu_dues "WCTU Dues"
 
 foreach var of varlist fraction_dry_counties wctu_dues {
 
 sum `var'
local amin = round(`r(min)',.1)
local amax = round(`r(max)',.1)
local lbvar : variable label  `var'
graph bar `var', over(region1) name("`var'", replace) subtitle(`lbvar')  nodraw ytitle("")  

}
replace MFratio=MFratio-1
graph bar MFratio, over(region1) name(MFratio,replace) ytitle("") subtitle("Men per 100 Women")

graph combine dt_property dt_sole dt_earnings dt_secretballot initiative_adopted dt_directprimary fraction_dry_counties  wctu_dues MFratio

graph display, scheme(tufte)
graph export "./output/bargraphCulture.pdf", replace





***********************
*Alternative Hypotheses
***********************
use "US_master_session", clear
sort scode yearmin
*

la var comp_split "Power Split" 

**Note: the following must be run separately for the machine_people regression. you must add "totalpop" to the regressions. 

foreach var of varlist comp_nyears comp_majsurplus* comp_split comp_thirdfrac comp_runnertowinner  { 

di "`var'" 

estimates clear

foreach EV in d_dt_property d_dt_sole d_dt_earnings d_dt_secretballot d_initiative_adopted d_dt_directprimary fraction_dry_counties  wctu_dues MFratio   {

di "`EV'" 

set more off
local lb_`EV' : variable label `EV' 

ren `EV' alternative

eststo baseline: xtreg passed_both `var' nawsa_membpc yearmin  i.scode1 , robust cluster(scode1) 

eststo `EV': xtreg passed_both `var' nawsa_membpc alternative yearmin i.scode1 , robust cluster(scode1) 


*eststo `EV'_solo: xtreg passed_both  alternative i.scode1 , robust cluster(scode) 


ren alternative `EV'
}

# delimit ; 
coefplot baseline, bylabel("Baseline")  ||
d_dt_property , bylabel("Property Rights") ||
d_dt_sole , bylabel("Sole Trader Laws") ||
d_dt_earnings , bylabel("Earnings Laws") ||
d_dt_secretballot, bylabel("Secret Ballot") ||
d_initiative_adopted,  bylabel("Initiative Rights") ||
d_dt_directprimary, bylabel("Direct Primary") ||
fraction_dry_counties, bylabel("Frac. Dry Counties") ||
wctu_dues, bylabel("WCTU dues") || 
MFratio, bylabel("Men per 100 Women") ||

, keep(`var' nawsa_membpc alternative ) xline(0)  legend(off) 
scheme(tufte) xlabel(0, add) bycoefs byopts(xrescale rows(1)) 
levels(99 95)  ciopts(lwidth(*1 *2)) 
mfcolor(white)  mlabel format(%9.02f) msymbol(s) mlabposition(12) 
coeflabel(nawsa_membpc ="Mobilization" alternative="Control Variable") 
yscale(alt) name(alternative`var', replace)  
;

# delimit cr

graph export "./output/alternative`var'.pdf", replace 

# delimit ;
coefplot baseline, bylabel("Baseline")  ||
d_dt_property , bylabel("Property Rights") ||
d_dt_sole , bylabel("Sole Trader Laws") ||
d_dt_earnings , bylabel("Earnings Laws") ||
d_dt_secretballot, bylabel("Secret Ballot") ||
d_initiative_adopted,  bylabel("Initiative Rights") ||
d_dt_directprimary, bylabel("Direct Primary") ||
fraction_dry_counties, bylabel("Frac. Dry Counties") ||
wctu_dues, bylabel("WCTU dues") || 
MFratio, bylabel("Men per 100 Women") ||
, keep(alternative ) xline(0)  legend(off) xline(0)  legend(off) scheme(tufte) xlabel(0, add) bycoefs byopts(xrescale rows(1)) levels(99 95)  ciopts(lwidth(*1 *2)) mfcolor(white) msymbol(s) mlabel format(%9.02f) mlabposition(12) coeflabel(nawsa_membpc ="Mobilization" alternative="Control Variable")    ;

# delimit cr
graph export "./output/solo`var'.pdf", replace 

}	  






*********************************
**ADDITIONAL code that generates a few figures and footnotes from the paper. 
*********************************


*For data set description 
use "US_master_session", clear
g distance=yearmax-yearmin +1
tab distance
*65 percent of the observations are 2-year, but the cumulatieve 1-2 year is 98 percent. 
drop distance

use "US_master_session", clear
sort scode yearmin
keep if yearmin>=1893 & yearmax<1921
drop if yearmin>fr_full
*589 observations (session-years) total in the dataset


*Basic Info on Legislative Composition referenced in the paper 

*Just look at only plurality same and different by region. 
tab region1 comp_onlyplurality_same 
list scode yearmin passed_both hou* if comp_onlyplurality_same==1  /*Nebraska 1893 Republicans*/ 

/*only 1 case in the midwest (out of 589 sessions I have data for)  where the same party was the largest but didn't have a majority. */  


tab region1 comp_onlyplurality_different
list scode yearmin passed_both if comp_onlyplurality_different==1 /* NC 1895 and 1897, NV 1901, IL 1913 > Presidential! */ 
/* there are 4 cases total (out of 589 sessions I have data for) where there were different largest parties, neither of which had a majority. 1 in the midwest, 2 in the South, and 1 in the West. */ 


tab region1 comp_split
list scode yearmin passed_both if comp_split==1 
/* There are 44 cases where the largest party in each legislature has a majority, but a different party has the majority. CA 1893 --> Passed Both. A bunch from DE. KS 1893 --> passed both. A bunch of MO. A bunch of MT. A bunch of NV -> passed both in 1911. */ 

/* In the 589 legislative sessions that I analyze from 1893-1920, there are two points to make about the unification of power and majority rule. Generally speaking, power was unified across legislative branches and majorities ruled. Even when power was split, parties had majorities. On the first point, a single party was the largest in both houses in 540 legislative sessions (92 percent). There is only one case where a single party held both houses without a majority in either chamber -- Nebraska 1890, Republican. On the second point, when different parties ruled the various houses, they too stood in separate majorities. There are 48 cases where the largest party differed across the legislatures. In four cases, neither had a majority: North Carolina in 1895 and 1897, Nevada in 1901, and Illinois in 1913. Incidentally, Illinois extended the presidential suffrage in 1913. In the remaining 44 cases where power was split across the legislatures, the distinct parties held majorities in their own domains. Of these, a few are repeat offnders: Delaware (4 times), Kansas (3), Missouri (4), Montana (4), and Nevada (3). Three of these split majority legislatures -- California, 1893, Kansas 1893, and Nevada 1911 -- passed a suffrage bill in both houses. */ 





















