cd "ADD PATH"
clear all
macro drop _all
log using CorrelatesOfMediaFreedom_Replication
*created on August 29, 2015 by JWW for Correlates of Media Freedom Replication
version 13.1
set linesize 80
set scheme s2color
use "CorrelatesOfMediaFreedom.dta", clear
*Preparing Variables
*oil should be logged, but because it has 0 values  I add .1 to it and then log it
generate oil1=oil+.1
generate Lnoil1=ln(oil1)
*log GDPpc
generate Lrgdpe_pc = ln(rgdpe_pc)
*clean executive constraints data
replace xconst=. if xconst==-88
replace xconst=. if xconst==-77
replace xconst=. if xconst== -66
*labeling variables
label variable ThreeMedia "Media Freedom"
label define ThreeMedia_lab 0 notfree 1 impfree 2 free
label values ThreeMedia ThreeMedia_lab
lab var ThreeMedia_tm1 "Past Media Freedom"
lab var xconst "Executive Constraints"
lab var civtot "Civil Conflict"
lab var inttot "International Conflict"
lab var Lrgdpe_pc "GDP/Capita (logged)"
lab var internet "Internet Penetration"
lab var Lnoil "Oil Reserves (logged)"

save "CorrelatesOfMediaFreedomReady.dta", replace

*To recreate the figures and tables in the order that they appear in the paper and appendix. 
*Figure 1 shows the distribution of different types of media systems across different regime types
kdensity polity2 if ThreeMedia==0, saving(NotFree5) 
kdensity polity2 if ThreeMedia==1, saving(ImpFree5)
kdensity polity2 if ThreeMedia==2, saving(Free5)
gr combine NotFree5.gph ImpFree5.gph Free5.gph
*this is the table included in the lower right corner of Figure 1
generate democracy=.
replace democracy= 1 if polity2>5 & polity2 !=.
replace democracy=0 if polity2<6 & polity2 !=.
tab ThreeMedia democracy, row

*Table 2 Data and Sources and in-sample summary statistics
drop if year<1950
drop if year>2011
sum ThreeMedia if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum xconst if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum polity2 if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum rgdpe_pc if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum civtot if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum inttot if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum internet if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 
sum oil if ThreeMedia_tm1 !=. & xconst !=. & polity2 !=.  & rgdpe_pc !=. & inttot !=. & civtot !=. 

*Table 3 
**********************creating models with fixed effects**********************
*for regional fixed effects
gen region=.
replace region=1 if ccode>1 & ccode<200
replace region=2 if ccode>165 & ccode<400
replace region=3 if ccode>400 & ccode<600
replace region=4 if ccode>599 & ccode<700
replace region=4 if ccode>699 & ccode<900
replace region=5 if ccode>899 & ccode<1000
tab region, gen(rgn_)
*for year fixed effects
tab year, gen(yr_)
*for Model 1 in Table 3
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc rgn_* yr_*, cluster(ccode) baseoutcome(0)
* for Model 2 in Table 3
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc internet Lnoil rgn_* yr_*, cluster(ccode) baseoutcome(0)
*********************For the Appendix**********************************************
*Figure A1 
twoway kdensity polity2 if ThreeMedia==0 || kdensity polity2 if ThreeMedia==1 || kdensity polity2 if ThreeMedia==2
*Table A2 (in sample Executive Constraints by Democracy/NonDemocracy)
tab democracy xconst if  ThreeMedia_tm1 !=.   & rgdpe_pc !=. & inttot !=. & civtot !=. 
*Table A3
pwcorr ThreeMedia xconst Lrgdpe_pc civtot inttot LitPercent internet Lnoil1 if ThreeMedia_tm1 !=. , sig 
*Table A4 
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc, cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc rgn_*, cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc  yr_*, cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc rgn_* yr_*, cluster(ccode) baseoutcome(0)
*Table A5
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc rgn_* yr_*, cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc LitPercent rgn_* yr_* , cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot   Lrgdpe_pc internet Lnoil1 rgn_* yr_*  , cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc LitPercent internet Lnoil1 rgn_* yr_* , cluster(ccode) baseoutcome(0)
*Table A6
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc  if polity2>5 & polity2!=., cluster(ccode) baseoutcome(0)
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc if polity2<6 & polity2!=., cluster(ccode) baseoutcome(0)
*Table A7
version 12.1
*need to install spost9_ado to run this. Have to uninstall spost13_ado first
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc  if polity2>5 & polity2!=., cluster(ccode) baseoutcome(0)
listcoef, pvalue(.05) percent help
*Table A8
*also requires version 12.1 and spost9
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc if polity2<6 & polity2!=., cluster(ccode) baseoutcome(0)
listcoef,  pvalue(.05) percent help

*Figure A2
* for impact of xconst in non-democracy
summ  Lrgdpe_pc  if polity2<6  & polity2!=.
summ ThreeMedia_tm1  if polity2<6  & polity2!=.
summ xconst  if polity2<6  & polity2!=.
summ civtot if polity2<6 & polity2!=.
summ inttot if polity2<6 & polity2!=.
set more off
estsimp mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc if polity2<6 & polity2!=., cluster(ccode) baseoutcome(0)



generate med_free_lo = .   // these are values that will define the lower and upper bounds 
generate med_free_hi = .   // for 95% confidence intervals
generate med_nfree_lo = .
generate med_nfree_hi = .
generate med_pfree_hi =.
generate med_pfree_lo =.
generate vectaxis = .      // The vectaxis will be the horizontal axis in our graphs of these estimates
recast float vectaxis  	   // This tells STATA that the vectaxis will get changed by the commands below
local a=1					// This is the starting value for the xconst variable 
local b=1							// b is a macro for observation number 
while `a' <= 7 {                            // This is the start of a long statement that will run sequentially until a=11
	setx xconst `a' ThreeMedia_tm1 mean civtot mean inttot mean Lrgdpe_pc mean // The "setx" command determines the values at which all the control variables 
				   // are set for the first predicted value "genpr(p1) " 
	simqi, prval(2) genpr(p2)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix that were 
	_pctile p2, p(2.5,97.5)      // Because we want 95% confidence intervals, we are selecting these values
	display `a'
	replace med_free_lo = r(r1) in `b'   // "plo" for "low probability the first percentile (2.5) from the "_pctile" command above 
	replace med_free_hi = r(r2) in `b'   // "phi" for "high probability" second percentile (97.5) from the "_pctile" command above 
	
                           // The "setx" command determines the values at which all the control variables 
				   // are set for the first predicted value "genpr(p1) " 
	simqi, prval(1) genpr(p1)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix that were 
	_pctile p1, p(2.5,97.5)      // Because we want 95% confidence intervals, we are selecting these values
	display `a'
	replace med_pfree_lo = r(r1) in `b'   // "plo" for "low probability the first percentile (2.5) from the "_pctile" command above 
	replace med_pfree_hi = r(r2) in `b'   // "phi" for "high probability" second percentile (97.5) from the "_pctile" command above 
	
	simqi, prval(0) genpr(p0)
	_pctile p0, p(2.5,97.5)
	display `a'
	replace med_nfree_lo = r(r1) in `b'
	replace med_nfree_hi =r(r2) in 	`b'
	
	replace vectaxis = `a' in `b'     // refers 
	drop p0
	drop p1
	drop p2
	local a = `a' + .1               // determining the interval over which a is calculated 
	local b=`b' + 1                 // this is a macro for the observation number for the quantities generated by the simulations
}
*****

sort vectaxis
twoway rcap med_free_lo med_free_hi vectaxis 
twoway rcap med_nfree_lo med_nfree_hi vectaxis 
twoway rcap med_pfree_lo med_pfree_hi vectaxis
twoway rcap med_free_lo med_free_hi vectaxis || rcap med_nfree_lo med_nfree_hi vectaxis || rcap med_pfree_lo med_pfree_hi vectaxis, name(graph1, replace)

*******************************
*Figure A3
*to generate gdp marginal effect on ThreeMedia in democracies
*Must first clear from previous figure
use "CorrelatesOfMediaFreedomReady.dta", clear
*to generate gdp marginal effect on ThreeMedia in democracies
*first need to get range for gdp 
summ  Lrgdpe_pc  if polity2>5  & polity2!=.
summ ThreeMedia_tm1  if polity2>5  & polity2!=.
summ xconst  if polity2>5  & polity2!=.
summ civtot if polity2>5 & polity2!=.
summ inttot if polity2>5 & polity2!=.
*	setx Lrgdpe_pc `a'   ThreeMedia_tm1 1.4 xconst 6.6 civtot .4 inttot  .06  // The "setx" command determines the values at which all the control variables 

set more off
estsimp mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc if polity2>5 & polity2!=., cluster(ccode) baseoutcome(0)



generate med_free_lo = .   // these are values that will define the lower and upper bounds 
generate med_free_hi = .   // for 95% confidence intervals
generate med_nfree_lo = .
generate med_nfree_hi = .
generate med_pfree_hi =.
generate med_pfree_lo =.
generate vectaxis = .      // The vectaxis will be the horizontal axis in our graphs of these estimates
recast float vectaxis  	   // This tells STATA that the vectaxis will get changed by the commands below
local a=6						// This is the starting value for the gdp variable 
local b=1							// b is a macro for observation number 
while `a' <= 12 {                            // This is the start of a long statement that will run sequentially until a=12
setx Lrgdpe_pc `a'   ThreeMedia_tm1 mean xconst mean civtot mean inttot  mean  // The "setx" command determines the values at which all the control variables 				   // are set for the first predicted value "genpr(p1) " 
	simqi, prval(2) genpr(p2)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix that were 
	_pctile p2, p(2.5,97.5)      // Because we want 95% confidence intervals, we are selecting these values
	display `a'
	replace med_free_lo = r(r1) in `b'   // "plo" for "low probability the first percentile (2.5) from the "_pctile" command above 
	replace med_free_hi = r(r2) in `b'   // "phi" for "high probability" second percentile (97.5) from the "_pctile" command above 
	
                           // The "setx" command determines the values at which all the control variables 
				   // are set for the first predicted value "genpr(p1) " 
	simqi, prval(1) genpr(p1)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix that were 
	_pctile p1, p(2.5,97.5)      // Because we want 95% confidence intervals, we are selecting these values
	display `a'
	replace med_pfree_lo = r(r1) in `b'   // "plo" for "low probability the first percentile (2.5) from the "_pctile" command above 
	replace med_pfree_hi = r(r2) in `b'   // "phi" for "high probability" second percentile (97.5) from the "_pctile" command above 
	
	simqi, prval(0) genpr(p0)
	_pctile p0, p(2.5,97.5)
	display `a'
	replace med_nfree_lo = r(r1) in `b'
	replace med_nfree_hi =r(r2) in 	`b'
	
	replace vectaxis = `a' in `b'     // refers 
	drop p0
	drop p1
	drop p2
	local a = `a' + .1               // determining the interval over which a is calculated 
	local b=`b' + 1                 // this is a macro for the observation number for the quantities generated by the simulations
}
*****

sort vectaxis
twoway rcap med_free_lo med_free_hi vectaxis 
twoway rcap med_nfree_lo med_nfree_hi vectaxis 
twoway rcap med_pfree_lo med_pfree_hi vectaxis
twoway rcap med_free_lo med_free_hi vectaxis || rcap med_nfree_lo med_nfree_hi vectaxis || rcap med_pfree_lo med_pfree_hi vectaxis, name(graph1, replace)

*Tables A9 and A10
***************This is how to create a classification table aka confusion matrix ***************************
version 9
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc if polity2<6 & polity2!=., cluster(ccode) baseoutcome(0)
epcp
mlogit ThreeMedia ThreeMedia_tm1 xconst civtot  inttot  Lrgdpe_pc if polity2>5 & polity2!=.,  baseoutcome(0)
epcp

*****************************Comparison Between Freedom House Data and Global Media Freedom Data
*Table A4
clear 
version 13.1
set linesize 80
set scheme s2color
clear all
macro drop _all
import delimited using  "Global_Media_Freedom_Data.csv", clear
*collapse GMFD into 3 categories (collapsing the two "not free" categories) in order to compare to FH
gen gmf=.
replace gmf=0 if mediascore==3 | mediascore==4
replace gmf=1 if mediascore==2
replace gmf=2 if mediascore==1
tab gmf mediascore
sort ccode year
joinby ccode year using FreedomHouseMergeReady, unmatch(both)
pwcorr gmf FHStatus if year>1978 & year<1993, sig
pwcorr gmf FHStatus if year>1992 & year<1997, sig
pwcorr gmf FHScore if year>1992 & year<1997, sig
pwcorr gmf FHStatus if year>1996 & year<2001, sig
pwcorr gmf FHScore if year>1996 & year<2001, sig
pwcorr gmf FHStatus if year==2001
pwcorr gmf FHScore if year==2001
pwcorr gmf FHStatus if year>2000 & year<2013, sig
pwcorr gmf FHScore if year>2000 & year<2013, sig
pwcorr gmf FHStatus
log close 
exit
