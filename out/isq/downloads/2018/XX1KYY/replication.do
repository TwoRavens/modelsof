***
* Ratifiers vs Non ratifiers, Section 1 in the outline
***
use ratif_char.dta, clear
drop if ratifier==.

* Ratifier2 is the ratifier variable, updated to July 2011
gen ratifier2=ratifier
replace ratifier2=1 if ccode==580 | ccode==115 | ccode==155 | ccode==316 | ccode==771 | ccode==591 | ccode==359 | ccode==55 | ccode==616

***
* Table 1: Differences Between Ratifiers and Nonratifiers
***
*** Conflict History
* Battle Deaths 1990's
	bysort ratifier2: su sum3_9097
	reg sum3_9097 ratifier2
	ttest sum3_9097, by(ratifier2)
* Battle Deaths (strictly positive)
	bysort ratifier2: su sum3_9097 if sum3_9097!=0
	reg sum3_9097 ratifier2 if sum3_9097>0
	ttest sum3_9097 if sum3_9097>0, by(ratifier2)
* Exclude Afghanistan
	bysort ratifier2: su sum3_9097 if ccode!=700
		reg sum3_9097 ratifier2 if ccode!=700
* ICRG Political Risk
	bysort ratifier2: sum polrisk90s
	reg polrisk90s ratifier2
* WGI Political Violence
	bysort ratifier2: sum wgi_pv90s
	reg wgi_pv90s ratifier2
*** Institutions
* Polity2
	bysort ratifier2: sum polity2_90s
	reg polity2_90s ratifier2
* Polity2 nondemocracies
	bysort ratifier2: sum polity2_90s if dem_med_hi==0
	reg polity2_90s ratifier2 if dem_med_hi==0
* Executive Constraint
	gen xconstdum=.
	replace xconstdum=1 if xconst_90s>=3 & xconst_90!=.
	replace xconstdum=0 if xconst_90s<3 & xconst_90!=.
	bysort ratifier2: sum xconst_90s
	reg xconst_90s ratifier2
* WGI Rule of Law
	bysort ratifier2: sum wgi_rol90s
	reg wgi_rol90s ratifier2
* Judicial Independence
	bysort ratifier2: sum keithsum*
	reg keithsum* ratifier2

	
***
* Figure 1: Cumulative Number of Ratifications
***
clear
set more off
insheet using ratifdates.csv, comma clear
drop  ratificationdate
drop if ratif_year==.
sort ratif_year ratif_quarter
bysort ratif_year ratif_quarter: egen ratif_sum_xx=total(ratif_year!=.)
duplicates drop ratif_year ratif_quarter, force
drop country
bysort ratif_year: gen ratif_sum_yr_xx=sum(ratif_sum_xx)
bysort ratif_year: egen ratif_sum_yr=max(ratif_sum_yr_xx)
duplicates drop ratif_year, force
gen ratif_cum_yr=sum(ratif_sum_yr)
keep ratif_cum_yr ratif_year
twoway bar ratif_cum_yr ratif_year, ytitle("cumulative number of ratifiers") xtitle("year") title("Cumulative Number of ICC Ratifiers by Year, 1999-2011")
	
***
* Figure 2: Distribution of Deaths in the 1990's by ratification
***
	twoway scatter ratifier2 sum3_9097 if sum3_9097>0, mlabel(cname) mlabs(vsmall) msize(vtiny) mlabangle(285) ytitle(ratifier2) xtitle("civil war deaths in the 1990s")
	hist sum3_9097 if ratifier2==1 & sum3_9097>0, percent w(1000) title(Ratifiers) xti("number of deaths")
	graph save bdeadhistb1.gph, replace
	hist sum3_9097 if ratifier2==0 & sum3_9097>0, percent w(1000) title(Non-ratifiers) xti("number of deaths")
	graph save bdeadhistb2.gph, replace
		local note "note("Note: Distribution of number of civil conflict battle deaths from 1990-1997.  The top pane is for ratifiers" "of the ICC and the bottom pane is for non-ratifiers, with two outliers (Tajikistan and Afghanistan) labeled.")"
	graph combine bdeadhistb1.gph bdeadhistb2.gph, `note' xcomm c(1) ycomm title("Distribution of Deaths in the 1990's, by ICC Ratification")


	
	
***
* Table 2 and Figures 4 and 5
***
clear
set more off
use "SD_BD_FL_EC9097_panel.dta"

* Replicating Model 1, generating dummy to check samples
stset quarter, failure(ratification) id(country) 
gen sdsamp=0
* Hazard ratios
stcox cw_90 dem_med_hi dem_med_hi_cw90 logmilper1 logpk corrected_regrat100 humrightstreat extrconflict_ongoing  const__amend__required_for_ratif icc_elected_officials ldrs  brit__leg__herit_1
replace sdsamp=1 if e(sample)
	est2vec replication, replace name(SDModel1HR) vars(cw_90 dem_med_hi dem_med_hi_cw90 dead9097 dem_dead9097 logmilper1 logpk corrected_regrat100 humrightstreat extrconflict_ongoing  const__amend__required_for_ratif icc_elected_officials ldrs  brit__leg__herit_1)
* Coefficients
stcox cw_90 dem_med_hi dem_med_hi_cw90 logmilper1 logpk corrected_regrat100 humrightstreat extrconflict_ongoing  const__amend__required_for_ratif icc_elected_officials ldrs  brit__leg__herit_1, nohr basehc(sdmodel1)
	est2vec replication2, replace name(SDModel1) addto(replication)
* (Figure 4) Plotting the hazard curves for SD's model 1
local leg "legend(label(1 "Nondemocracy, Civil War=0") label(2 "Democracy, Civil War=0") label(3 "Nondemocracy, Civil War=1") label(4 "Democracy, Civil War=1") label(5 "Nondemocracy, Civil War=2") label(6 "Democracy, Civil War=2")) lpattern(solid solid dash dash dot dot) lcolor(blue red blue red blue red)"
local at "at1(cw_90=0 dem_med_hi=0 dem_med_hi_cw90=0) at2(cw_90=0 dem_med_hi=1 dem_med_hi_cw90=0) at3(cw_90=1 dem_med_hi=0 dem_med_hi_cw90=0) at4(cw_90=1 dem_med_hi=1 dem_med_hi_cw90=1) at5(cw_90=2 dem_med_hi=0 dem_med_hi_cw90=0) at6(cw_90=2 dem_med_hi=1 dem_med_hi_cw90=2)"
local cap "sub("Simmons and Danner, Model 1") note("Weighted kernel density estimate of hazard curve from the Cox regression in Simmons and" "Danner's Model 1. Regime type is binary. Civil war equals 0,1, or 2 depending on the number of" "years of civil conflict experienced by that country during the 1990's.")"
stcurve, hazard `at' `leg' `cap' title("Effect of Regime Type and Civil War on Ratification Hazard") ytitle("smoothed hazard") xtitle("number of quarters")
	graph export "C:\Users\Stephen\Dropbox\ICC\Drafts\M1aHaz.eps", as(eps) preview(off) replace
* ISQ Version, no color, pre graph editor
local atndem "at1(cw_90=0 dem_med_hi=0 dem_med_hi_cw90=0) at2(cw_90=1 dem_med_hi=0 dem_med_hi_cw90=0) at3(cw_90=2 dem_med_hi=0 dem_med_hi_cw90=0)"
local legndem "legend(label(1 "Civil War=0") label(2 "Civil War=1") label(3 "Civil War=2"))"
stcurve, hazard `atndem' title("Non-democracies") ytitle("smoothed hazard") xtitle("number of quarters") lpattern(solid shortdash dot) lcolor(black black black) `legndem'
	graph save nondemSDm1.gph, replace
local atdem "at1(cw_90=0 dem_med_hi=1 dem_med_hi_cw90=0) at2(cw_90=1 dem_med_hi=1 dem_med_hi_cw90=1) at3(cw_90=2 dem_med_hi=1 dem_med_hi_cw90=2)"
local legdem "legend(label(1 "Civil War=0") label(2 "Civil War=1") label(3 "Civil War=2"))"
stcurve, hazard `atdem' title("Democracies") ytitle("smoothed hazard") xtitle("number of quarters") lpattern(solid shortdash dot) lcolor(black black black) legend(off)
	graph save demSDm1.gph, replace
local note "note("Weighted kernel density estimate of hazard curve from the Cox regression in Simmons and" "Danner's Model 1. Regime type is binary. Civil war equals 0,1, or 2 depending on the number of" "years of civil conflict experienced by that country during the 1990's.")"
	grc1leg nondemSDm1.gph demSDm1.gph, c(1) ycomm xcomm title("Fig 3. Effect of Regime Type and Conflict on Ratif. Hazard") sub("Simmons and Danner, Model 1") `note'
	
* SD Model with Continuous Measure of Civil War Dead
* Cleaning up the names, generating variables
replace bdead_best_3=0 if bdead_best_3==.
gen deadtvc=bdead_best_3
gen dem_deadtvc=dem_med_hi*deadtvc
replace sum3_9097=0 if sum3_9097==.
bysort ccode: egen dead9097=max(sum3_9097)
gen dem_dead9097 = dem_med_hi*dead9097

* SD Model 1 Using Deaths in the 1990's, continuous
stcox dead9097 dem_med_hi dem_dead9097 logmilper1 logpk corrected_regrat100 humrightstreat extrconflict_ongoing  const__amend__required_for_ratif icc_elected_officials ldrs  brit__leg__herit_1 if sdsamp==1, nohr basehc(basehccont1)
		est2vec continuous, replace name(FullSample) addto(replication)
	* This will plot curves for nondemocracies and democracies
	local lp1 "lpattern(solid solid solid solid dash) lcolor(blue*.2 blue*.4 blue*.6 blue*.8 blue*1)"
	stcurve, hazard at1(dead9097=0 dem_med_hi=0 dem_dead9097=0) at2(dead9097=500 dem_med_hi=0 dem_dead9097=0) at3(dead9097=1000 dem_med_hi=0 dem_dead9097=0) at4(dead9097=2000 dem_med_hi=0 dem_dead9097=0) at5(dead9097=10000 dem_med_hi=0 dem_dead9097=0) legend(label(1 "0") label(2 "500") label(3 "1,000") label(4 "2,000") label(5 "10,000") title("Number of Deaths")) title("Nondemocracies") xtitle("number of quarters") ytitle("smoothed hazard for ratification") `lp1'
	graph save contdeath1a.gph, replace
	local lp2 "lpattern(solid solid solid solid dash dot) lcolor(red*.2 red*.4 red*.6 red*.8 red*1 red*1)"
	stcurve, hazard at1(dead9097=0 dem_med_hi=1 dem_dead9097=0) at2(dead9097=500 dem_med_hi=1 dem_dead9097=500) at3(dead9097=1000 dem_med_hi=1 dem_dead9097=1000) at4(dead9097=2000 dem_med_hi=1 dem_dead9097=2000) at5(dead9097=10000 dem_med_hi=1 dem_dead9097=10000) at6(dead9097=50000 dem_med_hi=1 dem_dead9097=50000) legend(label(1 "0") label(2 "500") label(3 "1,000") label(4 "2,000") label(5 "10,000") label(6 "50,000") title("Number of Deaths")) title("Democracies") xtitle("number of quarters") ytitle("smoothed hazard for ratification") `lp2'
	graph save contdeath2a.gph, replace
	local cap "note("Each line represents the weighted kernel density estimate of the hazard curve for a particular number of" "battle deaths by regime type.  These curves use the results from Model 3, with the full sample of countries.")"
	graph combine contdeath1a.gph contdeath2a.gph, ycomm title("Effect of Civil War Deaths on Ratification Hazard") `cap'
		
* This makes the same plot in black and white for ISQ submission
	local lp1 "lpattern(solid solid solid solid dash) lcolor(black*.2 black*.4 black*.6 black*.8 black*1)"
	stcurve, hazard at1(dead9097=0 dem_med_hi=0 dem_dead9097=0) at2(dead9097=500 dem_med_hi=0 dem_dead9097=0) at3(dead9097=1000 dem_med_hi=0 dem_dead9097=0) at4(dead9097=2000 dem_med_hi=0 dem_dead9097=0) at5(dead9097=10000 dem_med_hi=0 dem_dead9097=0) legend(label(1 "0") label(2 "500") label(3 "1,000") label(4 "2,000") label(5 "10,000") title("Number of Deaths")) title("Nondemocracies") xtitle("number of quarters") ytitle("smoothed hazard for ratification") `lp1'
	graph save contdeath1a_isq.gph, replace
	local lp2 "lpattern(solid solid solid solid dash dot) lcolor(black*.2 black*.4 black*.6 black*.8 black*1 black*1)"
	stcurve, hazard at1(dead9097=0 dem_med_hi=1 dem_dead9097=0) at2(dead9097=500 dem_med_hi=1 dem_dead9097=500) at3(dead9097=1000 dem_med_hi=1 dem_dead9097=1000) at4(dead9097=2000 dem_med_hi=1 dem_dead9097=2000) at5(dead9097=10000 dem_med_hi=1 dem_dead9097=10000) at6(dead9097=50000 dem_med_hi=1 dem_dead9097=50000) legend(label(1 "0") label(2 "500") label(3 "1,000") label(4 "2,000") label(5 "10,000") label(6 "50,000") title("Number of Deaths")) title("Democracies") xtitle("number of quarters") ytitle("smoothed hazard for ratification") `lp2'
	graph save contdeath2a_isq.gph, replace
	local cap "note("Each line represents the weighted kernel density estimate of the hazard curve for a particular number of" "battle deaths by regime type.  These curves use the results from Model 3, with the full sample of countries.")"
	graph combine contdeath1a_isq.gph contdeath2a_isq.gph, ycomm title("Effect of Civil War Deaths on Ratification Hazard") `cap'

* SD Model 1 Using Deaths in the 1990's, continuous, excluding Afghanistan
stcox dead9097 dem_med_hi dem_dead9097 logmilper1 logpk corrected_regrat100 humrightstreat extrconflict_ongoing  const__amend__required_for_ratif icc_elected_officials ldrs  brit__leg__herit_1 if sdsamp==1 & ccode!=700, nohr basehc(basehccont2)
		est2vec continuous2, replace name(ExcludingAfghanistan) addto(replication)
*			est2tex replication, preserve path("C:\Users\Stephen\Documents\My Dropbox\ICC\Drafts\") mark(stars) fancy replace levels(90 95 99)leadzero
	* This will plot curves for nondemocracies and democracies
	* codebook dead9097 if dem_med_hi==0 & dead9097!=0 & ratification==1	
	local lp1 "lpattern(solid solid solid solid dash) lcolor(blue*.2 blue*.4 blue*.6 blue*.8 blue*1)"
	stcurve, hazard at1(dead9097=0 dem_med_hi=0 dem_dead9097=0) at2(dead9097=500 dem_med_hi=0 dem_dead9097=0) at3(dead9097=1000 dem_med_hi=0 dem_dead9097=0) at4(dead9097=2000 dem_med_hi=0 dem_dead9097=0) at5(dead9097=10000 dem_med_hi=0 dem_dead9097=0) legend(label(1 "0") label(2 "500") label(3 "1,000") label(4 "2,000") label(5 "10,000") title("Number of Deaths")) title("Nondemocracies (Excl. Afghanistan)") xtitle("number of quarters") ytitle("smoothed hazard for ratification") `lp1'
	graph save contdeath1b.gph, replace
	local lp2 "lpattern(solid solid solid solid solid dash) lcolor(red*.2 red*.4 red*.6 red*.8 red*1 red*1)"
	stcurve, hazard at1(dead9097=0 dem_med_hi=1 dem_dead9097=0) at2(dead9097=500 dem_med_hi=1 dem_dead9097=500) at3(dead9097=1000 dem_med_hi=1 dem_dead9097=1000) at4(dead9097=2000 dem_med_hi=1 dem_dead9097=2000) at5(dead9097=10000 dem_med_hi=1 dem_dead9097=10000) at6(dead9097=50000 dem_med_hi=1 dem_dead9097=50000) legend(label(1 "0") label(2 "500") label(3 "1,000") label(4 "2,000") label(5 "10,000") label(6 "50,000") title("Number of Deaths")) title("Democracies (Excl. Afghanistan)") xtitle("number of quarters") ytitle("smoothed hazard for ratification") `lp2'
	graph save contdeath2b.gph, replace
	graph combine contdeath1b.gph contdeath2b.gph, ycomm title("Effect of Civil War Deaths on Ratification Hazard") 

