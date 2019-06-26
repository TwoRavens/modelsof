*DO FILE TO GENERATE FIGURES FROM 
*“INTERNATIONAL LAW, MILITARY EFFECTIVENESS, AND PUBLIC SUPPORT FOR DRONE STRIKES"


version 13

set scheme s1mono


*Specify relevant directory where replication files are stored



*FIGURE 1. SUPPORT FOR DRONE STRIKES, BY TREATMENT CONDITION
use "drones_fig1.dta", clear

*Multiply support values by 100 so that reported as numerical values rather than percentages
replace support = support*100

*Create numerical values for groups so that can more easily define and separate in figure
gen group2 = group
replace group2 = group + 1 if frame=="lawsov"
replace group2 = group + 5 if frame=="lawciv"
replace group2 = group + 9 if frame=="effect"

*Graph command
twoway (bar support group2 if group==1, color(gs3)) ///
	(bar support group2 if group==2, color(gs12)) ///
	(bar support group2 if group==3, color(gs8)), ///
	legend(order (1 "UN (con)" 2 "NGO/HRW (con)" 3 "Govt/Joint Chiefs (pro)")) ///
	xlabel(3 "Sovereignty" 7 "Civilians" 11 "Effectiveness") xtitle("Issue frame") ///
	ytitle("Percent change in approval" "for drone strikes" "(experimental condition - control)") ylabel(-10(2)10, grid) ///
	yline(0) ///
	title("Figure 1. Support for drone strikes, by treatment condition", size(medsmall) position(11)) ///
	note("Values represent the first difference in the percent of respondents approving of" ///
	"drones strikes (answering either 'Approve strongly' or 'Approve somewhat') for each" ///
	"issue frame-source treatment condition relative to the baseline control group.")



*FIGURE 2. CREDIBILITY OF SOURCE, BY TREATMENT CONDITION
use "drones_fig2.dta", clear

*Multiply support values by 100 so that reported as numerical values rather than percentages
replace support = support*100

*Create numerical values for groups so that can more easily define and separate in figure
gen group2 = group
replace group2 = group + 1 if frame=="lawsov"
replace group2 = group + 5 if frame=="lawciv"
replace group2 = group + 9 if frame=="effect"

*Graph command
twoway (bar support group2 if group==1, color(gs3)) ///
	(bar support group2 if group==2, color(gs12)) ///
	(bar support group2 if group==3, color(gs8)), ///
	legend(order (1 "UN (con) " 2 "NGO/HRW (con)" 3 "Govt/Joint Chiefs (pro)")) ///
	xlabel(3 "Sovereignty" 7 "Civilians" 11 "Effectiveness") xtitle("Issue frame") ///
	ytitle("Percent believing source" "is credible") ylabel(0(10)80, grid) ///
	title("Figure 2. Credibility of source, by issue frame", size(medsmall) position(11)) ///
	note("Values represent the percent of respondents believing the relevant source is credible" ///
	"(answered either 'Very credible' or 'Somewhat credible'), separated by each issue frame.")


	
*FIGURE 3. CIVILIAN DEATHS, POTENTIAL MEDIATORS, AND SUPPORT FOR DRONE STRIKES
use "drones_fig3.dta", clear

*Get range of values
sum firstdiff lowerci upperci

*Create numerical values for groups so that can more easily define and separate in figure
gen group2 = group
recode group2 (2=3) (3=5) (4=7)

twoway ///
	(scatter firstdiff group2 if group>0, msymbol(O) mlcolor(black) msize(medlarge) mfcolor(black)) ///
	(rcap lowerci upperci group2  if group>0, lcolor(black)), ///
	yscale(range (-0.2 0.2)) ylabel(-0.2(0.05)0.2, grid) ///
	xscale(range (0 8)) ///
	yline(0, lcolor(black)) ///
	ytitle("First difference" "(civilian treatment - control)") ///
	xtitle("Mediator") ///
	legend(off) ///
	scheme(s1mono) ///
	ylabel(, grid) ///
	xlabel(1 "Morally wrong" 3 "US image" 5 "Recruit militants" 7 "Special forces")	///
	title("Figure 3. Civilian deaths, potential mediators, and support for drone strikes", ///
	size(medium) position(11)) ///
	note("Values represent first differences between the civilian deaths treatment and control group" ///
	"for each of the potential mediator outcomes. All outcomes were rescaled to range between 0 and 1." ///
	"Vertical lines indicate 95% confidence intervals.")

