/*This code creates the analysis, tables, and figures for 
Targets and Tactics: Testing for a Duality Within Al Qaeda's Network
by Shawn L. Ramirez and Arianna J. Robbins

All original data sources are described in the article. 
This code was run using Stata 14.
*/

use  "AQAdata2017.dta", clear

log using "AQAlog.txt", replace


******************** 
******************** 
* CODING TARGETS AND TACTICS
********************
******************** 

**** PART I. TACTICS

**************** A. KIDNAPPINGS
********
*This section codes kidnappings using two criteria:
gen hostinv = 0
*1. Include any case in which a hostage was involved as a kidnapping.
replace hostinv = 1 if !missing(hostkidoutcome)
*2. Include hijackings, barricade incidents, and abductions (clear cases of kidnappings): 
replace hostinv = 1 if attacktype1 == 5 |  attacktype1 == 6 |  attacktype1 == 4 | attacktype2 == 5 |  attacktype2 == 6 |  attacktype2 == 4 |  attacktype3 == 5 |  attacktype3 == 6 |  attacktype3 == 4 

*Summary statistics on these forms of kidnappings:
gen hijacking = 0
replace hijacking = 1 if attacktype1 == 4 |  attacktype2 == 4| attacktype3 == 4 
*15 hijackings

gen barricade = 0 
replace  barricade = 1 if attacktype1 == 5 |  attacktype2 == 5| attacktype3 == 5 
*21 barricade incidents

gen abduction = 0 
replace abduction = 1 if attacktype1 == 6 |  attacktype2 == 6| attacktype3 == 6 
*690 kidnappings, planned attacks taking people to secret locations



*This section codes the outcome of the kidnapping into two categories: released or executed. 

*This variable codes whether the hostage was released. This is coded as a 1 for released hostage, and a 0 otherwise. 
recode hostkidoutcome (2=1 "Hostage Released") (else=0 "Other Outcome"), generate(release)

*This variable codes whether the hostage was executed. This is coded as a 1 for an executed hostage, and a 0 otherwise.  
recode hostkidoutcome (4=1 "Hostage Killed") (else=0 "Other Outcome"), generate(kidnapkilled)


**************** B. SUICIDE ATTACKS
********
*Suicide is given by the suicide 0/1 variable
tab suicide
*711 suicide attacks, 5147 non-suicide attacks


**************** C. OTHER TACTICS
********
*1988 cases of armed or unarmed assault
gen assault = 0
replace assault = 1 if attacktype1 == 2 | attacktype2 == 2 | attacktype3 == 2 |  attacktype1 == 8 | attacktype2 == 8 | attacktype3 == 8
*440 cases of assassinations
gen assass = 0
replace assass = 1 if attacktype1 == 1 | attacktype2 == 1 | attacktype3 == 1 
*2946 cases of bomb/explosions
gen bombexp = 0
replace bombexp = 1 if attacktype1 == 3 | attacktype2 == 3 | attacktype3 == 3 
*266 cases of facility infrastructure attacks
gen infras = 0
replace infras = 1 if attacktype1 == 7 | attacktype2 == 7 | attacktype3 == 7 


**** PART II. TARGETS

**************** A. TARGETING THE WEST
********
gen wtarg=.
replace wtarg=1 if natlty1==5 
replace wtarg=1 if natlty1==21
replace wtarg=1 if natlty1==32
replace wtarg=1 if natlty1==38
replace wtarg=1 if natlty1==50
replace wtarg=1 if natlty1==54
replace wtarg=1 if natlty1==55
replace wtarg=1 if natlty1==64
replace wtarg=1 if natlty1==69
replace wtarg=1 if natlty1==75
replace wtarg=1 if natlty1==78
replace wtarg=1 if natlty1==90
replace wtarg=1 if natlty1==91
replace wtarg=1 if natlty1==98
replace wtarg=1 if natlty1==109
replace wtarg=1 if natlty1==115
replace wtarg=1 if natlty1==116
replace wtarg=1 if natlty1==142
replace wtarg=1 if natlty1==151
replace wtarg=1 if natlty1==161
replace wtarg=1 if natlty1==162
replace wtarg=1 if natlty1==166
replace wtarg=1 if natlty1==179
replace wtarg=1 if natlty1==180
replace wtarg=1 if natlty1==185
replace wtarg=1 if natlty1==209
replace wtarg=1 if natlty1==216
replace wtarg=1 if natlty1==217
replace wtarg=1 if natlty1==97 
replace wtarg=0 if wtarg==.

**************** B. TARGETING THE HOME STATE
********
gen statetarg=.
replace statetarg=1 if targtype1==2|targtype1==3|targtype1==4|targtype1==7 & natlty1==ccodehome
replace statetarg=0 if statetarg==.

**************** C. TARGETING LOCAL CIVILIANS
gen civilian=.
replace civilian=0 if targtype1==2|targtype1==3|targtype1==4|targtype1==7|targtype1==17|targtype1==22 & natlty1==ccodehome
replace civilian=1 if civilian==.

*Summary statistics:
tab wtarg
*219 cases of targeting the West, 5639 cases of not
tab statetarg
*2934 cases of targeting the home state, 2924 cases of not
tab civilian
*2677 cases of targeting civilians in one's home state, 3181 of not


**** PART III. CREATE COUNTS, PROPORTIONS, AND STANDARDIZED VARIABLES TO USE IN THE PCA

**************** A. Create counts for each type of attack by group year 
********
*We want one coded per group year
by gname iyear, sort: gen nvals = _n == 1 
count if nvals == 1
*There are 180 group-year observations.

*This codes the total number of attacks for each group year
gen count=1
egen nattack = total(count==1), by (gname iyear)

*This codes the total number of suicide attacks for each group year
egen nsuicide = total(suicide==1), by (gname iyear)

*This codes the total number of kidnap-kill attacks for each group year
egen nkkill = total(kidnapkilled==1), by (gname iyear)

*This codes the total number of kidnap-release attacks for each group year
egen nrelease = total(release==1), by (gname iyear)

*This codes the total number of kidnappings per year
egen nkidnapped = total(hostinv==1), by (gname iyear)

*This codes the total number of anti-West attacks for each group year
egen nwtarg = total(wtarg==1), by (gname iyear)

*This codes the total number of anti-State attacks for each group year
egen nstarg = total(statetarg==1), by (gname iyear)

*This codes the total number of anti-civilian attacks for each group year
egen nctarg = total(civilian==1), by (gname iyear)

*This codes the total number of assault attacks for each group year
egen nassault = total(assault==1), by (gname iyear)

*This codes the total number of assass attacks for each group year
egen nassas = total(assass==1), by (gname iyear)

*This codes the total number of bombexp attacks for each group year
egen nbomb = total(bombexp==1), by (gname iyear)

*This codes the total number of infras attacks for each group year
egen ninfras = total(infras==1), by (gname iyear)

*This corrects the count for missing values by replacing them with a zero:
replace nattack = . if nvals == 0
replace nsuicide = . if nvals == 0
replace nkkill = . if nvals == 0
replace nrelease = . if nvals == 0
replace nwtarg = . if nvals == 0
replace nstarg = . if nvals == 0
replace nctarg = . if nvals == 0
replace nassault = . if nvals == 0
replace nassas = . if nvals == 0
replace nbomb = . if nvals == 0
replace ninfras = . if nvals == 0

**************** B. Create proportions of each type of attack by group year 
********
gen propkilled = nkkill/nkidnapped 
replace propkilled = 0 if nkidnapped==0 & nkkill==0 & nrelease==0 
gen proprelease = nrelease/nkidnapped 
replace proprelease = 0 if nkidnapped==0 & nkkill==0 & nrelease==0 
gen propsuicide = nsuicide/nattack if nvals == 1
gen propkidnap = nkidnapped/nattack if nvals == 1
gen propwtarg = nwtarg/nattack if nvals == 1
gen propstarg = nstarg/nattack if nvals == 1
gen propctarg = nctarg/nattack if nvals == 1
gen propassault = nassault/nattack if nvals == 1
gen propassas = nassas/nattack if nvals == 1
gen propbomb = nbomb/nattack if nvals == 1
gen propinfras = ninfras/nattack if nvals == 1


**************** C. Create Standardized variables of our main vairables of interest
********
egen stdpwtarg = std(propwtarg)
egen stdpstarg = std(propstarg)
egen stdpkill = std(propkilled)
egen stdprel = std(proprelease)
egen stdpsui = std(propsuicide)

sort gname iyear

*To see that 12% are suicide attacks and 13% are kidnappings as noted in the article:
count if (suicide==1)
count if (hostinv==1)
count if (suicide==0)



*********************
*********************
* VARIABLE CREATION DONE. START THE ANALYSIS.
*********************
*********************


*********************
**** PART I. Data and Model Specification section of article

* Table 1: We created this by hand during the research process.

* Table 2: Summary statistics by group listed here as proportions (reported as percentages in the article).
table gname, contents(mean propwtarg mean propstarg mean propkilled mean proprelease mean propsuicide) format(%5.2f)

* Table 3: Summary statistics for main variables used in the PCA.
sum propwtarg propstarg propsuicide propkilled proprelease 

* NOTE: To see that standardization makes no difference to the results:
*a. Summary statistics of main variables
sum propwtarg propstarg propsuicide propkilled proprelease 
*b. Summary statistics of main variables when standardized
sum stdpwtarg stdpstarg stdpsui stdpkill stdprel
*c. Run the PCA with proportions
pca propwtarg propstarg propsuicide propkilled proprelease 
*d. To see that standardization makes no difference:
pca stdpwtarg stdpstarg stdpsui stdpkill stdprel


*********************
**** PART II. Results section of article (Part 1 - PCA)

* Table 4: Principal Components of AQ terror
pca propwtarg propstarg propkilled proprelease propsuicide


** Generate affiliate positions:
predict comp1 comp2
label variable comp1 "Anti-West"
*reverse comp2 so that the - side is kidnapping, and + side is suicide attacks
gen revc2 = -1*comp2
label variable revc2 "Suicide"
*Generate each group's average position for targets and tactics
egen atarg = mean(comp1), by(groupid)
egen sdatarg = sd(comp1), by(groupid)
egen atac = mean(revc2), by(groupid)
egen sdatac = sd(revc2), by(groupid)


*********************
**** PART III. Results section of article (Part 2 - Plotting affiliate positions)

*Count the number of years for each group:
sort gname iyear
by gname iyear: generate n1 = _n
egen gyears = total(n1==1), by (gname)
*Generate confidence intervals using the standard error for the mean:
gen lbtarg=atarg-(1.96*(sdatarg/sqrt(gyears)))/sqrt(gyears)
gen ubtarg=atarg+(1.96*(sdatarg/sqrt(gyears)))/sqrt(gyears)
gen lbtac=atac-(1.96*(sdatac/sqrt(gyears)))/sqrt(gyears)
gen ubtac=atac+(1.96*(sdatac/sqrt(gyears)))/sqrt(gyears)
gen certaintyx = abs(ubtarg - lbtarg)
gen certaintyy = abs(ubtac	- lbtac)
replace  certaintyy = 0 if missing( certaintyy)
replace  certaintyx = 0 if missing( certaintyx)
gen xbounds= lbtarg if nvals == 1
replace xbounds= ubtarg if nvals == 0
gen ybounds= lbtac if nvals == 1
replace ybounds= ubtac if nvals == 0

*By group, where we are 95% confident that a group's targets and tactics places them within only one quadrant: 
gen qdefined = 0
replace qdefined = 1 if ubtarg<=0 & lbtarg<=0 & ubtac>=0 & lbtac>=0
replace qdefined = 1 if ubtarg<=0 & lbtarg<=0 & ubtac<=0 & lbtac<=0 
replace qdefined = 1 if ubtarg>=0 & lbtarg>=0 & ubtac<=0 & lbtac<=0 
replace qdefined = 1 if ubtarg>=0 & lbtarg>=0 & ubtac>=0 & lbtac>=0
replace qdefined = 1 if init=="ISI" 

gen varytargets = 0
replace  varytargets = 1 if (ubtarg>=0 & lbtarg<=0) 
gen varytactics = 0
replace varytactics = 1 if (ubtac>=0 & lbtac<=0) 
replace varytactics = 0 if init == "HUJI"  
replace varytargets = 1 if init == "HUJI"  

gen pos = . 
replace pos = 3
replace pos = 2 if init == "Al-Mansoorian" | init == "JI" | init =="TTP" | init =="AQSA" | init =="Taliban" | init =="AQY" | init == "AQAP" | init == "IMU"
replace pos = 7 if init == "Ansar al-Islam" | init == "LEJ"  | init == "ISI" | init == "Al-Shabaab" | init =="AQIM"
replace pos = 10 if init == "Al Jihad" 
replace pos = 8 if init == "GSPC" | init=="LET"
replace pos = 4 if init == "Abu Sayyaf" | init == "Haqqani" | init == "HUM"
replace pos = 2 if init == "HUJI" | init == "HUA" 
replace pos = 7 if init == "AQI" | init == "JEM" | init == "TJ"
replace pos = 9 if init == "Al-Nusrah"

****CREATE FIGURE 1

*Figure 1: Quadrant defined affiliates
*These 15 groups show low variance in their targets and tactics in ONE BIG GRAPH.
forvalues i = 1/25 {
	local graphs `graphs' (scatter atac xbounds if group == `i' & qdefined==1, connect(l) lcolor(gs11) msymbol(p) mcolor(gs11)) ///
						  (scatter ybounds atarg if group == `i'  & qdefined==1, connect(l) lcolor(gs11) msymbol(p) mcolor(gs11)) ///						 
						  (scatter atac atarg if group == `i'  & qdefined==1, mlabel(init) mcolor(ebblue) msize(small) mlabvpos(pos) mlabang(0) mlabcolor(gs2)) 
	}
graph twoway `graphs', yline(0, lp(dot)) xline(0, lp(dot)) xtitle("Targets") ytitle("Tactics") ///
    ylabel(-1 "Kidnap" -.5 0 .5 1 1.5 2 "Suicide",angle(0)) ///
	xlabel(-1.5 "State" -1 0 1 2 "West" ) scheme(s1color) ///
	legend(order(1 "95% limits" 3 "Avg. PCA Position")) 

*This saves that graph: 
graph export "scoreplot quaddef.pdf", replace


**** CREATE FIGURE 2

*NOTE THAT YOU MUST RUN EACH OF THESE GRAPHS SEPARATELY TO AVOID THE AUTOMATIC OVERLAY.

*Figure 2: Combining the graphs of the Quadrant defined affiliates and affilaites that shift their targets or tactics or both:
***Run this first.
forvalues i = 1/25 {
	local graphs `graphs' (scatter atac xbounds if group == `i' & qdefined==1, connect(l) lcolor(gs11) msymbol(p) mcolor(gs11)) ///
						  (scatter ybounds atarg if group == `i'  & qdefined==1, connect(l) lcolor(gs11) msymbol(p) mcolor(gs11)) ///						 
						  (scatter atac atarg if group == `i'  & qdefined==1, mcolor(ebblue) msize(small) mlabvpos(pos) mlabang(0) mlabcolor(gs2)) 
	}
graph twoway `graphs', yline(0, lp(dot)) xline(0, lp(dot)) xtitle("Targets") ytitle("Tactics") ///
    ylabel(-3 "Kidnap" -2 -1 0 1 2 "Suicide",angle(0)) ///
	xlabel(-2 "State" -1 0 1 2 3 "West" ) legend(off) scheme(s1color) title("Quadrant-Confined") text(-3 1.5 "Note: Labels suppressed.") name(varynonenl, replace) 

***Run this second.	
*These 3 groups vary their tactics
forvalues i = 1/25 {
	local graphs `graphs' (scatter atac xbounds if group == `i' &  varytactics==1 & varytargets==0 & qdefined==0, connect(l) lcolor(red) msymbol(p) mcolor(gs11)) ///
						  (scatter ybounds atarg if group == `i'  &  varytactics==1  &  varytargets==0 & qdefined==0, connect(l) lcolor(red) msymbol(p) mcolor(gs11)) ///						 
						  (scatter atac atarg if group == `i'  & varytactics==1  & varytargets==0 & qdefined==0, mlabel(init) mcolor(red) msize(small) mlabvpos(pos) mlabang(0) mlabcolor(gs2)) 
						  }
graph twoway `graphs', yline(0, lp(dot)) xline(0, lp(dot)) xtitle("Targets") ytitle("Tactics") ///
    ylabel(-3 "Kidnap" -2 -1 0 1 2 "Suicide", angle(0)) ///
	xlabel(-2 "State" -1 0 1 2 3 "West" ) legend(off) scheme(s1color) title("Tactic Variation")	name(varytac, replace) 

***Run this third.
*These 3 groups vary their targets
forvalues i = 1/25 {
	local graphs `graphs' (scatter atac xbounds if group == `i' &  varytactics==0 & varytargets==1 & qdefined==0, connect(l) lcolor(blue) msymbol(p)  mcolor(gs11)) ///
						  (scatter ybounds atarg if group == `i'  &   varytactics==0 & varytargets==1& qdefined==0, connect(l) lcolor(blue) msymbol(p) mcolor(gs11)) ///						 
						  (scatter atac atarg if group == `i'  &   varytactics==0 & varytargets==1 & qdefined==0, mlabel(init) mcolor(blue) msize(small) mlabvpos(pos) mlabang(0) mlabcolor(gs2)) 
						  }
graph twoway `graphs', yline(0, lp(dot)) xline(0, lp(dot)) xtitle("Targets") ytitle("Tactics") ///
    ylabel(-3 "Kidnap" -2 -1 0 1 2 "Suicide", angle(0)) ///
	xlabel(-2 "State" -1 0 1 2 3 "West" ) legend(off) scheme(s1color)  title("Target Variation") name(varytarg, replace) 

***Run this fourth.
*These 4 groups vary both
forvalues i = 1/25 {
	local graphs `graphs' (scatter atac xbounds if group == `i' &   varytactics==1 & varytargets==1& qdefined==0, connect(l) lcolor(green) msymbol(p)  mcolor(gs11)) ///
						  (scatter ybounds atarg if group == `i'  &    varytactics==1 & varytargets==1& qdefined==0, connect(l) lcolor(green) msymbol(p) mcolor(gs11)) ///						 
						  (scatter atac atarg if group == `i'  &    varytactics==1 & varytargets==1 & qdefined==0, mlabel(init) mcolor(green) msize(small) mlabvpos(pos) mlabang(0) mlabcolor(gs2))						  
	}
graph twoway `graphs', yline(0, lp(dot)) xline(0, lp(dot)) xtitle("Targets") ytitle("Tactics") ///
    ylabel(-3 "Kidnap" -2 -1 0 1 2 "Suicide", angle(0)) ///
	xlabel(-2 "State" -1 0 1 2 3 "West" ) legend(off) scheme(s1color) title("Variation in Both") name(varytt, replace) 
	
***Run this fifth.
graph combine varytt varytac varytarg varynonenl, xcommon ycommon scheme(s1color) 

*This saves all the graphs as a single figure:
graph export "scoreplot quadvary.pdf", replace



*********************
**** PART IV. Results section of article (Part 3 - Movement over time)


* Generate graphs for each affiliate's targets and tactics over time
gen year = real(iyear)
sort groupid year

set graphics off
twoway (scatter comp1 year if groupid == 1 & nvals == 1, title("Abu Sayyaf") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 1 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g1, replace))

twoway (scatter comp1 year if groupid == 2 & nvals == 1, title("Al Jihad") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1988 (8) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 2 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g2, replace))
	
twoway (scatter comp1 year if groupid == 3 & nvals == 1, title("Al Mansoorian") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 3 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g3, replace))
	
twoway (scatter comp1 year if groupid == 4 & nvals == 1, title("Al Nusrah") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 4 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g4, replace))

twoway (scatter comp1 year if groupid == 5 & nvals == 1, title("AQI") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 5 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g5, replace))

twoway (scatter comp1 year if groupid == 6 & nvals == 1, title("AQSA") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 6 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g6, replace))

twoway (scatter comp1 year if groupid == 7 & nvals == 1, title("AQY") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 7 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g7, replace))

twoway (scatter comp1 year if groupid == 8 & nvals == 1, title("AQAP") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 8 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g8, replace))

twoway (scatter comp1 year if groupid == 9 & nvals == 1, title("AQIM") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 9 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g9, replace))

twoway (scatter comp1 year if groupid == 10 & nvals == 1, title("Al Shabaab") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 10 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g10, replace))

twoway (scatter comp1 year if groupid == 11 & nvals == 1, title("Ansar al-Islam") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 11 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g11, replace))
	
twoway (scatter comp1 year if groupid == 12 & nvals == 1, title("Haqqani") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 12 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g12, replace))

twoway (scatter comp1 year if groupid == 13 & nvals == 1, title("HUM") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 13 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g13, replace))
	
twoway (scatter comp1 year if groupid == 14 & nvals == 1, title("HUA") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 14 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g14, replace))

twoway (scatter comp1 year if groupid == 15 & nvals == 1, title("HUJI") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 15 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g15, replace))

twoway (scatter comp1 year if groupid == 16 & nvals == 1, title("IMU") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 16 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g16, replace))

twoway (scatter comp1 year if groupid == 17 & nvals == 1, title("ISI") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 17 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g17, replace))
	
twoway (scatter comp1 year if groupid == 18 & nvals == 1, title("JEM") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 18 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g18, replace))

twoway (scatter comp1 year if groupid == 19 & nvals == 1, title("JI") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 19 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g19, replace))

twoway (scatter comp1 year if groupid == 20 & nvals == 1, title("LEJ") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 20 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g20, replace))

twoway (scatter comp1 year if groupid == 21 & nvals == 1, title("LET") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 21 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g21, replace))

twoway (scatter comp1 year if groupid == 22 & nvals == 1, title("GSPC") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 22 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g22, replace))

twoway (scatter comp1 year if groupid == 23 & nvals == 1, title("Taliban") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 23 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g23, replace))

twoway (scatter comp1 year if groupid == 24 & nvals == 1, title("TJ") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 24 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g24, replace))

twoway (scatter comp1 year if groupid == 25 & nvals == 1, title("TTP") yline(0, lp(dot)) yaxis(1) ytick(-4 (2) 4, axis(1)) ///
	xlabel(1998 (5) 2012) xtitle("Year") legend(off) ylabel(-4 "State" -2 0 2 4 "West", ///
	axis(1) angle(0)) ytitle("")  msymbol(p) connect(l) lpattern(solid) lwidth(thick) lcolor(navy) scheme(s1color) ) ///
	(scatter revc2 year if groupid == 25 & nvals==1,  yaxis(2) ///
	ytitle("", axis(2))ytick(-4 (2) 4, axis(2)) ylabel(-4 "Kidnap" -2 0 2 4 "Suicide", axis(2) angle(0)) ///
	msymbol(p) connect(l) lpattern(dash) lwidth(thick) lcolor(gs9) name(g25, replace))

graph rename g1	abusay, replace
graph rename g2 aljih, replace
graph rename g3 almans, replace
graph rename g4 alnus, replace
graph rename g5 aqi, replace
graph rename g6 aqsa, replace
graph rename g7 aqy, replace
graph rename g8 aqap, replace
graph rename g9 aqim, replace
graph rename g10 alshab, replace
graph rename g11 ansar, replace
graph rename g12 haq, replace
graph rename g13 hum, replace
graph rename g14 hua, replace
graph rename g15 huji, replace
graph rename g16 imu, replace
graph rename g17 isi, replace
graph rename g18 jem, replace
graph rename g19 ji, replace
graph rename g20 lej, replace
graph rename g21 let, replace
graph rename g22 gspc, replace
graph rename g23 talib, replace
graph rename g24 tj, replace
graph rename g25 ttp, replace

set graphics on

**Create Figure 3: Affiliate Targets and Tactics Over Time
* Graphs are arranged by row:
*1. anti west and suicide or mix/kidnapping...
*2. anti state... and kidnapping...
*3. target state use suicide tactics
*4. related group that are perhaps trending toward civil war
*5. groups that exist as mere blips
graph combine ji haq aqy aqsa aqap  ///
alshab let ttp gspc aqim ///
almans ansar aljih lej jem ///
tj aqi isi talib abusay ///
huji hum hua imu alnus, t1title("Target and Tactic Variation Over Time") scheme(s1color)  imargin(zero)
graph export "over time all.pdf", replace




*********************
*********************
*********************
* APPENDIX 
*********************
*********************
*********************


** Verification that the standardized PCA analysis will yield the same substantive interpretation

* Table 5: Summary statistics of standardized variables
sum stdpwtarg stdpstarg stdpkill stdprel stdpsui

* Table 6: PCA with standardized variables gives the same results
pca stdpwtarg stdpstarg stdpkill stdprel stdpsui
 

** PCA with all tactics and all targets included

* Table 7: Summary stats for alternative specification (all targets and tactics)
sum propwtarg propstarg propkill proprel propsui propassault propassas propbomb propinfras

* Table 8: PCA results with  alternative specification (all targets and tactics)
pca propwtarg propstarg propsuicide propkidnap propassault propassas propbomb propinfras


log close







