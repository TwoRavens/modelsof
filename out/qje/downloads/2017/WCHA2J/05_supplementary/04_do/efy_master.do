*** set path 
global projectFolder "[path to supplementary folder]/05_supplementary" // <---- set location of supplementary materials folder

**** folder globals
do "$projectFolder/do/_path_Generic"

**** log file
capture log close
set more 1
log using "$logFolder/efy_master_stata.log", replace
 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//META SECTION
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	


/*

//Reminder on data file
//paper: identifies the paper
 //      = 1 if Dalbo_2005a; = 2 if Andreoni_1993a; = 3 if DeJong_1996a = 4; if Friedman_2012a; = 5 if Bereby_Meyer_2006a

 */

 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
 
//TABLE 1: Cooperation Rates and Mean Round to First Defection
use "$data/stata/efy_dat_meta_1.dta" , clear
gen coop_r1 = coop if round == 1
gen coop_rl = coop if round == length
keep if treat_match == 1 | treat_match == maxmatch
gen treat_match_mod = treat_match
replace treat_match_mod = 999 if treat_match == maxmatch
egen minm = min(maxmatch) if treat_match_mod == 999, by(paper)
egen maxm = max(maxmatch) if treat_match_mod == 999, by(paper)
collapse coop coop_r1 coop_rl first_defect minm maxm, by(paper treatment length g l treat_match_mod)
*table treat_match_mod treatment, c(mean coop)
bysort paper length: table g treat_match_mod, c(mean coop mean coop_r1 mean coop_rl mean first_defect)

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
	
// FIGURE 2 : Cooperation Rates: Round One (Circles) and Last Round (Triangles)

use "$data/stata/efy_dat_meta_1.dta" , clear
gen coop_r1 = coop if round == 1
gen coop_rl = coop if round == length
collapse coop_r1 coop_rl, by(paper treatment treat_match)

tw scatter coop_r1 treat_match if treatment == 1, connect(l) msymbol(o) lpattern(solid) ///
	|| scatter coop_r1 treat_match if treatment == 2, connect(l) msymbol(Oh) lpattern(dash) ///
	|| scatter coop_rl treat_match if treatment == 1, connect(l) msymbol(t) lpattern(solid) ///
	|| scatter coop_rl treat_match if treatment == 2, connect(l) msymbol(Th) lpattern(dash) ///
	xlabel(1(1)10) ylabel(0(0.2)1)  xtitle("Supergame") t1title("Horizon = 2") ytitle("Cooperation Rate") ///
	legend(off) ///
	graphregion(color(white)) bgcolor(white) scheme(s2mono) ///
	saving("$figFolder/foo.gph", replace)

* (in case I want the legend back, here's the code)
* legend(label(1 "Round 1, g=1.17, l=0.83") label(2 "Round 1, g=0.83, l=1.17") label(3 "Last Round g=1.17, l=0.83") label(4 "Last Round, g=0.83, l=1.17") ring(0) pos(2) size(small) rows(4)) ///

tw scatter coop_r1 treat_match if treatment == 3, connect(l) msymbol(o) lpattern(solid) ///
	|| scatter coop_r1 treat_match if treatment == 4, connect(l) msymbol(Oh) lpattern(dash) ///
	|| scatter coop_rl treat_match if treatment == 3, connect(l) msymbol(t) lpattern(solid) ///
	|| scatter coop_rl treat_match if treatment == 4, connect(l) msymbol(Th) lpattern(dash) ///
	xlabel(1(1)10) ylabel(0(0.2)1)  xtitle("Supergame") t1title("Horizon = 4") ytitle("Cooperation Rate") ///
	legend(off) ///
	graphregion(color(white)) bgcolor(white) scheme(s2mono) ///
	saving("$figFolder/bar.gph", replace)

tw scatter coop_r1 treat_match if treatment == 5, connect(l) msymbol(o) lpattern(solid) ///
	|| scatter coop_r1 treat_match if treatment == 6, connect(l) msymbol(Oh) lpattern(dash) ///
	|| scatter coop_r1 treat_match if treatment == 7, connect(l) msymbol(oh) lpattern(dot) ///
	|| scatter coop_r1 treat_match if treatment == 8, connect(l) msymbol(O) lpattern(longdash) ///
	|| scatter coop_rl treat_match if treatment == 5, connect(l) msymbol(t) lpattern(solid) ///
	|| scatter coop_rl treat_match if treatment == 6, connect(l) msymbol(Th) lpattern(dash) ///
	|| scatter coop_rl treat_match if treatment == 7, connect(l) msymbol(T) lpattern(dot) ///
	|| scatter coop_rl treat_match if treatment == 8, connect(l) msymbol(th) lpattern(longdash) ///
	xlabel(1(1)8) ylabel(0(0.2)1)  xtitle("Supergame") t1title("Horizon = 8") ytitle("Cooperation Rate") ///
	legend(off) ///
	graphregion(color(white)) bgcolor(white) scheme(s2mono) ///
	saving("$figFolder/baz.gph", replace)

tw scatter coop_r1 treat_match if treatment == 9, connect(l) msymbol(o) lpattern(solid) ///
	|| scatter coop_r1 treat_match if treatment == 10, connect(l) msymbol(Oh) lpattern(dash) ///
	|| scatter coop_r1 treat_match if treatment == 11, connect(l) msymbol(oh) lpattern(dot) ///
	|| scatter coop_rl treat_match if treatment == 9, connect(l) msymbol(t) lpattern(solid) ///
	|| scatter coop_rl treat_match if treatment == 10, connect(l) msymbol(Th) lpattern(dash) ///
	|| scatter coop_rl treat_match if treatment == 11, connect(l) msymbol(T) lpattern(dot) ///
	xlabel(1(3)20) ylabel(0(0.2)1)  xtitle("Supergame") t1title("Horizon = 10") ytitle("Cooperation Rate") ///
	legend(off) ///
	graphregion(color(white)) bgcolor(white) scheme(s2mono) ///
	saving("$figFolder/qux.gph", replace)

graph combine "$figFolder/foo.gph" "$figFolder/bar.gph" "$figFolder/baz.gph" "$figFolder/qux.gph", ///
	ycommon row(2) ///
	graphregion(color(white)) scheme(s2mono) ///
	note("H = 2 and H = 4: solid g = 0.83, dash g = 1.17" "H = 8: solid g = 0.67, dash g = 1.33, dot g = 2, long dash g = 4" "H = 10: solid g = 0.44, dash g = 1.67, dot g = 2.33") ///
	saving("$figFolder/quux.gph", replace)

* these lines I took out because the Caption has a title
*	title("Cooperation Rate in:") ///
*	subtitle("Round 1 (circles) and Last Round (triangles)") ///

graph export "$figFolder/meta_coop_r1_and_rl.eps", replace
graph export "$figFolder/fig/meta_coop_r1_and_rl.pdf", replace

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE 2: Marginal Effects of Random-Effects Probit Regression of the Probability of Cooperating in Round One

// See TABLE A3 in the ONLINE APPENDIX.

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

// Currently Footnote 20


// R^2 for DETERMINANTS OF ROUND 1 COOPERATION
use "$data/stata/efy_dat_meta_1.dta" , clear
gen sizebad = l / (length - 1 + l - g)
replace sizebad = 1 if sizebad > 1


keep if round == 1
bysort id treatment (treat_match): gen ocoop_r1_m1 = ocoop[_n-1]	/* this keeps track of the round 1 choice of the opponent in the previous match of the current treatment */
gen treat_match2 = treat_match * (length == 2)
gen treat_match4 = treat_match * (length == 4)
gen treat_match8 = treat_match * (length == 8)
gen treat_match10 = treat_match * (length == 10)


*** FIRST ROUND
* random effects probit with session clusters
xtreg coop g l length treat_match2-treat_match10 ocoop_r1_m1 coop_first, i(id) cluster(paper)
xtreg coop g l length sizebad treat_match2-treat_match10 ocoop_r1_m1 coop_first, i(id) cluster(paper)
xtreg coop sizebad treat_match2-treat_match10 ocoop_r1_m1 coop_first, i(id) cluster(paper)


 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//EXPERIMENT 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	


//Reminder
*D4 is treatment 0
*D8 is treatment 1
*E4 is treatment 10
*E8 is treatment 11


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE 3: Cooperation Rates: Early Supergames (1–15) vs Late Supergames (16–30)


*1st round coop rate
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round == 1
gen secondhalf = 0
replace secondhalf = 1  if match > 15
table secondhalf treatment, c(mean coop)
table secondhalf, c(mean coop)

*Mean coop rate
use "$data/stata/efy_dat_exp_1.dta", replace
gen secondhalf = 0
replace secondhalf = 1  if match > 15
table secondhalf treatment, c(mean coop)
table secondhalf, c(mean coop)

*Last round
use "$data/stata/efy_dat_exp_1.dta", replace
gen secondhalf = 0
keep if round == length
replace secondhalf = 1  if match > 15
table secondhalf treatment, c(mean coop)
table secondhalf, c(mean coop)

*Now checking if differences are significant
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen secondhalf = 0
replace secondhalf = 1  if match > 15
gen foo = treatment
drop treatment
gen treatment = 1*treat_1 + 2*treat_2 + 3*treat_3 + 4*treat_4

gen treat_f2 = (treat_2 ==1 & secondhalf ==0)
gen treat_f3 = (treat_3 ==1 & secondhalf ==0)
gen treat_f4 = (treat_4 ==1 & secondhalf ==0)
gen treat_s1 = (treat_1 ==1 & secondhalf ==1)
gen treat_s2 = (treat_2 ==1 & secondhalf ==1)
gen treat_s3 = (treat_3 ==1 & secondhalf ==1)
gen treat_s4 = (treat_4 ==1 & secondhalf ==1)

*all rounds
meprobit coop treat_f2 treat_f3 treat_f4 treat_s1 treat_s2 treat_s3 treat_s4 || id : , vce(cluster session) intpoints(12)
test treat_s1 == 0
test treat_s2 == treat_f2
test treat_s3 == treat_f3
test treat_s4 == treat_f4

meprobit coop secondhalf || id : , vce(cluster session) intpoints(12)
test secondhalf

*first round
meprobit coop treat_f2 treat_f3 treat_f4 treat_s1 treat_s2 treat_s3 treat_s4 if round ==1 || id : , vce(cluster session) intpoints(12)
test treat_s1 == 0
test treat_s2 == treat_f2
test treat_s3 == treat_f3
test treat_s4 == treat_f4

meprobit coop secondhalf if round ==1 || id : , vce(cluster session) intpoints(12)
test secondhalf

*last round
meprobit coop treat_f2 treat_f3 treat_f4 treat_s1 treat_s2 treat_s3 treat_s4 if round ==length || id : , vce(cluster session) intpoints(12)
test treat_s1 == 0
test treat_s2 == treat_f2
test treat_s3 == treat_f3
test treat_s4 == treat_f4

meprobit coop secondhalf if round ==length || id : , vce(cluster session) intpoints(12)
test secondhalf

*fdef
xtreg first_defect treat_f2 treat_f3 treat_f4 treat_s1 treat_s2 treat_s3 treat_s4, i(id) cluster(session)
test treat_s1 == 0
test treat_s2 == treat_f2
test treat_s3 == treat_f3
test treat_s4 == treat_f4

xtreg first_defect secondhalf, i(id) cluster(session)

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Table 4: Cooperation Rate for All Rounds in Supergames 1, 2, 8, 20 and 30

use "$data/stata/efy_dat_exp_1.dta", replace
gen treat_m2_1 = (treat_1 ==1 & match ==2)
gen treat_m8_1 = (treat_1 ==1 & match ==8)
gen treat_m20_1 = (treat_1 ==1 & match ==20)
gen treat_m30_1 = (treat_1 ==1 & match ==30)

gen treat_m1_2 = (treat_2 ==1 & match ==1)
gen treat_m2_2 = (treat_2 ==1 & match ==2)
gen treat_m8_2 = (treat_2 ==1 & match ==8)
gen treat_m20_2 = (treat_2 ==1 & match ==20)
gen treat_m30_2 = (treat_2 ==1 & match ==30)

gen treat_m1_3 = (treat_3 ==1 & match ==1)
gen treat_m2_3 = (treat_3 ==1 & match ==2)
gen treat_m8_3 = (treat_3 ==1 & match ==8)
gen treat_m20_3 = (treat_3 ==1 & match ==20)
gen treat_m30_3 = (treat_3 ==1 & match ==30)

gen treat_m1_4 = (treat_4 ==1 & match ==1)
gen treat_m2_4 = (treat_4 ==1 & match ==2)
gen treat_m8_4 = (treat_4 ==1 & match ==8)
gen treat_m20_4 = (treat_4 ==1 & match ==20)
gen treat_m30_4 = (treat_4 ==1 & match ==30)

keep if match ==1 | match ==2 | match ==8 | match ==20 | match ==30

meprobit coop treat_m2_1 treat_m8_1 treat_m20_1 treat_m30_1 treat_m1_2 treat_m2_2 treat_m8_2 treat_m20_2 treat_m30_2 treat_m1_3 treat_m2_3 treat_m8_3 treat_m20_3 treat_m30_3 treat_m1_4 treat_m2_4 treat_m8_4 treat_m20_4 treat_m30_4 || id : , vce(cluster session) intpoints(12)

test treat_m2_1 == 0
test treat_m8_1 == 0
test treat_m20_1 == 0
test treat_m30_1 == 0

test treat_m2_2 == treat_m1_2
test treat_m8_2 == treat_m1_2
test treat_m20_2 == treat_m1_2
test treat_m30_2 == treat_m1_2

test treat_m2_3 == treat_m1_3
test treat_m8_3 == treat_m1_3
test treat_m20_3 == treat_m1_3
test treat_m30_3 == treat_m1_3

test treat_m2_4 == treat_m1_4
test treat_m8_4 == treat_m1_4
test treat_m20_4 == treat_m1_4
test treat_m30_4 == treat_m1_4


test treat_m30_4 == treat_m8_4 


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 4: Cooperation Rate by Round Separated in Groups of Five Supergames



clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen subsample = 1 if match <=5 
replace subsample = 2 if match >2 & match <=17
replace subsample = 3 if match >25 & match <=30
keep if length ==4

collapse (mean) coop_round_avg=coop , by(treatment subsample round)
replace	coop_round_avg = 100*coop_round_avg // convert to percentage
format coop_round_avg `fmtint' // format percentages as integers for graph

* graph
twoway ( connected coop_round_avg round if subsample ==1, sort lstyle(p1) lpattern(shortdash) mstyle(p1) msymbol(oh)) ///
	|| ( connected coop_round_avg round if subsample ==2, sort lstyle(p2) lpattern(longdash) mstyle(p2) msymbol(th)) ///
	|| ( connected coop_round_avg round if subsample ==3, sort lstyle(p3) lpattern(solid) mstyle(p3) msymbol(d)) ///
	, ytitle("Cooperation Rate") yscale(range(0 100)) ylabel(0(20)100) ///
	xtitle("Round") xlabel(1(1)4) ///
	legend( order(1 2 3) label(1 "SG: 1-5") label(2 "SG: 13-17") label(3 "SG: 26-30") cols(3) ) /// 
	graphregion(color(white)) bgcolor(white) scheme(s2mono)  ///
	by(treatment, ///
		note( ///
			"Note: SG stands for supergame." ///
			) ///
	t1title("") graphregion(color(white)) plotregion(fcolor(white))) ///
saving("$figFolder/coop_round_subsample_mono4" , replace)

graph export "$figFolder/coop_round_subsample_mono4.eps", replace
graph export "$figFolder/coop_round_subsample_mono4.pdf", replace

clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen subsample = 1 if match <=5 
replace subsample = 2 if match >2 & match <=17
replace subsample = 3 if match >25 & match <=30
keep if length ==8

collapse (mean) coop_round_avg=coop , by(treatment subsample round)
replace	coop_round_avg = 100*coop_round_avg // convert to percentage
format coop_round_avg `fmtint' // format percentages as integers for graph

* graph
twoway ( connected coop_round_avg round if subsample ==1, sort lstyle(p1) lpattern(shortdash) mstyle(p1) msymbol(oh)) ///
	|| ( connected coop_round_avg round if subsample ==2, sort lstyle(p2) lpattern(longdash) mstyle(p2) msymbol(th)) ///
	|| ( connected coop_round_avg round if subsample ==3, sort lstyle(p3) lpattern(solid) mstyle(p3) msymbol(d)) ///
	, ytitle("Cooperation Rate") yscale(range(0 100)) ylabel(0(20)100) ///
	xtitle("Round") xlabel(2(2)8) ///
	graphregion(color(white)) bgcolor(white) scheme(s2mono)  ///
	by(treatment, ///
		note( ///
			"" ///
			) ///
	t1title("") legend(off) graphregion(color(white)) plotregion(fcolor(white))) 	///
saving("$figFolder/coop_round_subsample_mono8" , replace)

graph export "$figFolder/coop_round_subsample_mono8.eps", replace
graph export "$figFolder/coop_round_subsample_mono8.pdf", replace

graph combine "$figFolder/coop_round_subsample_mono8" "$figFolder/coop_round_subsample_mono4", row(2) graphregion(color(white))  saving("$figFolder\xx", replace)
graph export "$figFolder/coop_round_subsample_mono.eps", replace
graph export "$figFolder/coop_round_subsample_mono.pdf", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 5: Average Cooperation Rates in the First Round
clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round ==1
collapse (mean) av_coop = coop , by(stage_game horizon match)
replace av_coop = 100*av_coop


twoway ( connected av_coop match if horizon ==0 , sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected av_coop match if horizon ==1 , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Average Initial Cooperation Rate") yscale(range(0 100)) ylabel(0(20)100) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(5(5)30) ///
	legend( order(1 2) label(1 "4 Rounds") label(2 "8 Rounds") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono)  ///
	by( stage_game, note("") ///
	t1title("") graphregion(color(white)) plotregion(fcolor(white))) ///
	saving("$figFolder/exp_avinicoop_match_mono" , replace)
graph export "$figFolder/exp_avinicoop_match_mono.eps", replace
graph export "$figFolder/exp_avinicoop_match_mono.pdf", replace

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////

//Footnote 29
clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round ==1 & (treat_2 ==1 | treat_3 ==1)

bysort match: probit coop treat_2, cluster(session)




//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 6: Cooperation Rate by Round
 
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen foo = 0 
replace foo = 1 if round ==1
replace foo = 3 if round ==length
replace foo = 2 if round == length -1
replace foo = 4 if round == length -2
replace foo = 1 if round ==1
drop if foo ==0
keep if treatment ==11 //11 is for E8

collapse coop, by(foo match)

tw line coop match if foo == 1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop match if foo ==3, connect(l) msymbol(Oh) lpattern(dash) ///
 || line coop match if foo ==2, connect(l) msymbol(X) lpattern(longdash_dot) ///
 || line coop match if foo ==4, connect(l) msymbol(X) lpattern(dash_dot) ///
 xlabel(0(5)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 Round 1) lab(2 Last Round) lab(3 Last Round -1) lab(4 Last Round -2)  size(small) rows(2)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") subtitle("Treatment E8") ///
   saving("$figFolder/coop_byround_e8", replace) 
   

graph export "$figFolder/coop_byround_e8.eps" , as(eps) preview(off) replace
graph export "$figFolder/coop_byround_e8.pdf", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 7: Evolution of Threshold Strategies


 //MEAN TIME TO LAST COOPERATION
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen mlength = length
gen foo = (coop == 0 & coop_m1 == 1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
gen baz1 = foo * round
gen baz2 = baz1
replace baz2 = mlength +1 if baz1 ==0
egen fdef = min(baz2), by(id session match treatment)
drop foo baz1 baz2
gen baz1 = 0
replace baz1 = 1 if (coop ==1)
gen baz2 = round*baz1
egen gdef = max(baz2), by(id session match treatment)
replace gdef = gdef +1 

keep if treatment ==11

collapse fdef gdef, by(match treatment)

tw line gdef match, connect(l) lpattern(solid)  ylabel(3(1)7) ///
|| line fdef match , connect(l) lpattern(dash) ///
 xtitle("Supergame")  ///
ytitle("Round") graphregion(color(white)) plotregion(fcolor(white)) ///
 legend(lab(1 "Last cooperation +1") lab(2 "First defection") rows(2) ring(0) pos(5)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono)  ///
 t1title("") subtitle("") ///
 saving("$figFolder/lastcoop_e8", replace) 

 graph export "$figFolder/lastcoop_e8.eps", replace
 graph export "$figFolder/lastcoop_e8.pdf", replace


* THRESHOLD PLAY
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen mcoop = coop *ocoop
gen foo = (mcoop == 0 & coop_m1 == 1 & ocoop_m1 ==1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
replace foo = 1 if round ==1 & ocoop ==0
gen baz1 = foo * round
replace baz1 = length +1 if baz1 ==0
egen mfdef = min(baz1), by(id session match)
gen deviation =0
replace deviation =1 if (round >mfdef & coop ==1)
egen totdev = sum(deviation), by(id session match)
gen perfectthres = 0
replace perfectthres = 1 if totdev ==0
keep if round ==1
collapse perfectthres, by(match treatment)
keep if treatment ==11

tw line perfectthres match, connect(l) lpattern(solid)  ylabel(0.5(0.1)1) ///
 xtitle("Supergame")  ///
ytitle("Share") graphregion(color(white)) plotregion(fcolor(white)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono)  ///
  legend(on lab(1 "Play consistent with" "threshold strategies") ring(0) pos(5)) ///
 t1title("") subtitle("") ///
 saving("$figFolder/evothrese8", replace) 


graph combine  "$figFolder/lastcoop_e8" "$figFolderevothrese8", graphregion(color(white)) title("Treatment E8")  saving("$figFolder\e8_2", replace)
graph export "$figFolder/exp:e8_2.eps", replace
graph export "$figFolder/exp:e8_2.pdf", replace

tw line perfectthres match, connect(l) lpattern(solid)  ylabel(0.5(0.1)1) ///
 xtitle("Supergame")  ///
ytitle("Share") graphregion(color(white)) plotregion(fcolor(white)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono)  ///
 title("Play consistent with threshold strategies") subtitle("E8") ///
 saving("$figFolder/evothrese8", replace) 

graph export "$figFolder/exp_e8_totdev.eps", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 8: (Left Panel) Mean Round to First Defection: All Pairs Versus Those That Cooperated in Round One; (Right Panel) Probability of Breakdown in Cooperation


*fdef conditional on couples that cooperated in round 1
clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round ==1
gen mcoop = coop*ocoop
keep if treatment ==11 //11 is for E8
egen mcooprate = mean(mcoop), by(match)
collapse first_defect, by(match mcoop mcooprate)
reshape wide first_defect, i(match mcooprate) j(mcoop)
gen fdeftotal = (1-mcooprate)*first_defect0 + (mcooprate)*first_defect1

twoway ( connected fdeftotal match, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected first_defect1 match , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Round") yscale(range(2 8)) ylabel(2(1)8) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(1(5)30) title("First defection") ///
	legend( order(1 2) label(1 "All") label(2 "Round 1 = (C,C)") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono) ////
		saving("$figFolder/exp_condfdef" , replace)

graph export "$figFolder/exp:condfdef.eps", as(eps) preview(off) replace
graph export "$figFolder/exp:condfdef.pdf", replace

*breakdown
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen fdef = first_defect
keep if round ==1
keep if treatment ==11 //11 is for E8
gen mcat = 3
replace mcat =2 if match <21
replace mcat = 1 if match <11 
gen mcoop = coop*ocoop
*keep if mcoop ==1
egen bd = sum(round), by(mcat fdef treatment)
egen ts = sum(round), by(mcat treatment)
gen pbreakdown = bd/ts
collapse pbreakdown, by(mcat fdef treatment)
*drop if fdef ==9
twoway (connected pbreakdown fdef if mcat ==1, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
  || ( connected pbreakdown fdef if mcat ==2, sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh)  ) ///
  || ( connected pbreakdown fdef if mcat ==3, sort lstyle(p5) lpattern(longdash_dot) mstyle(p5) msymbol(sh) ) ///
   ,xlabel(1(1)9) ylabel(0(0.1)0.4) ytitle("Probability") xtitle(Round) ///
   legend(lab(1 SG:1-10) lab(2 SG:11-20) lab(3 SG:21-30)  size(2.1) rows(1)) ///
    bgcolor(white)  scheme(s2mono) graphregion(color(white)) title("Breakdown of cooperation") ///
    plotregion(fcolo(white)) ///
    saving("$figFolder/exp_bd8", replace)

graph export "$figFolder/exp:bd_e8.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:bd_e8.pdf", replace

graph combine "$figFolder/exp_condfdef" "$figFolder/exp_bd8", graphregion(color(white)) title("Treatment E8")  note("Note: SG stands for supergame.")  saving("$figFolder\e8", replace)
graph export "$figFolder/exp:e8.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:e8.pdf", replace



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 9: Cooperation Rates in Selected Rounds Across Supergames


clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen foo = 0 
replace foo = 1 if round ==1
replace foo = 3 if round ==length
replace foo = 2 if round == length -1
replace foo = 4 if round == length -2
replace foo = 1 if round ==1
drop if foo ==0
collapse coop, by(foo match treatment)

drop if treatment ==11

tw line coop match if foo == 1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop match if foo ==3, connect(l) msymbol(Oh) lpattern(dash) ///
 || line coop match if foo ==2, connect(l) msymbol(X) lpattern(longdash_dot) ///
 || line coop match if foo ==4, connect(l) msymbol(X) lpattern(dash_dot) ///
 xlabel(0(10)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 "Round 1") lab(2 "Last Round") lab(3 "Last Round -1") lab(4 "Last Round -2")  size(small) rows(1)) ///
 by(treatment, note("") row(1) graphregion(color(white)) bgcolor(white)  plotregion(fcolor(white))) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") ///
   saving("$figFolder/coop_byround_all", replace) 
   

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE 10: Evolution of First Defection Versus Last Cooperation Across Supergames


clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen mlength = length
gen foo = (coop == 0 & coop_m1 == 1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
gen baz1 = foo * round
gen baz2 = baz1
replace baz2 = mlength +1 if baz1 ==0
egen fdef = min(baz2), by(id session match treatment)
drop foo baz1 baz2
gen baz1 = 0
replace baz1 = 1 if (coop ==1)
gen baz2 = round*baz1
egen gdef = max(baz2), by(id session match treatment)
replace gdef = gdef +1 
collapse fdef gdef, by(treatment match)
drop if treatment ==11

tw line gdef match, connect(l) lpattern(solid)  ylabel(0(1)6) ///
|| line fdef match , connect(l) lpattern(dash) ///
 xtitle("Supergame")  ///
ytitle("Round") graphregion(color(white)) plotregion(fcolor(white)) ///
 legend(lab(1 "Last cooperation +1") lab(2 "First defection") rows(1)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(treatment, note("") row(1) graphregion(color(white)) bgcolor(white)  plotregion(fcolor(white))) ///
 t1title("")  ///
 saving("$figFolder/lastcoop_all", replace) 

 graph export "$figFolder/lastcoop_all.eps", replace
 graph export "$figFolder/lastcoop_all.pdf", replace

 
 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Footnote 34


use "$data/stata/efy_dat_meta_1.dta" , clear
gen meta = 1
append using "$data/stata/efy_dat_exp_1.dta"
* replace vars
replace meta = 0 if meta == .
replace paper = 6 if paper == .
replace treat_match = match if meta == 0
* generate new var
gen mcoop = coop *ocoop
gen foo = (mcoop == 0 & coop_m1 == 1 & ocoop_m1 ==1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
replace foo = 1 if round ==1 & ocoop ==0
gen baz1 = foo * round
replace baz1 = length +1 if baz1 ==0
egen mfdef = min(baz1), by(id session match)
gen deviation =0
replace deviation =1 if (round >mfdef & coop ==1)
egen totdev = sum(deviation), by(id session match)
gen p_thresh = 0
replace p_thresh = 1 if totdev ==0
* drop data
drop if length == 2
keep if round == 1

* just H
probit p_thresh length if treat_match == 1, cluster(paper)
* g, l, and H
probit p_thresh g l length if treat_match == 1, cluster(paper)
* just in the meta
probit p_thresh length if treat_match == 1 & meta == 1, cluster(paper)
* just in our study
probit p_thresh length if treat_match == 1 & meta == 0, cluster(session)




//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE 5: Consistency of Play with Threshold Strategies
 
 // See TABLE A5 in the Online Appendix for the Meta section


 
 
 
 
 

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//LEARNING SECTION
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure 11: Average Cooperation: Simulation Versus Experimental Data for Each Round In E8

*Simulation data
clear
infile coop using "$learning/results/simul_4_Nov2016.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen simul = 1
gen match = floor(period/8) +1
replace match = floor(period/8) if r==8
drop period
save "$learning/results/simul_4_Nov2016.dat", replace

*Actual data
clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==4
keep match round subject coop
gen r  = round
drop round
gen simul = 0
*append simulated data
append using "$learning/results/simul_4_Nov2016.dat"
gen round =r


collapse coop, by(round match simul)

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) ytitle("Cooperation Rate")  xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("Treatment E8") row(2)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul4_long.pdf", replace
graph export "$learning/results/graphs/new/simul4_long.eps", replace

graph export "$figFolder/simul4_long.pdf", replace
graph export "$figFolder/simul4_long.eps", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Footnote 50

*The goal is to establish that cooperation is declining in the last 50 supergames of the simulations for all rounds where coop > 0.2



clear
use "$learning/results/simul_4_Nov2016.dat"
keep if match >950
regress coop match if r ==1
regress coop match if r ==2
regress coop match if r ==3
regress coop match if r ==4
regress coop match if r ==5
regress coop match if r ==6
regress coop match if r ==7
regress coop match if r ==8

keep if match ==1000



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure 12: Long term Evolution of Aggregate Cooperation


*Simulation data
clear
infile coop using "$learning/results/simul_4_wd8eumatrix_Aug2015_1000.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen simul = 2
gen match = floor(period/8) +1
replace match = floor(period/8) if r==8
drop period
save "$learning/results/simul_4_with2eu.dat", replace

*Simulation data
clear
infile coop using "$learning/results/simul_4_wd8estimates_Aug2015_1000.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen simul = 3
gen match = floor(period/8) +1
replace match = floor(period/8) if r==8
drop period
save "$learning/results/simul_4_with2par.dat", replace

* *Simulation data

clear
use "$learning/results/simul_4_Nov2016.dat"
replace simul = 0
*append simulated data
append using "$learning/results/simul_4_with2eu.dat"
append using "$learning/results/simul_4_with2par.dat"
append using "$learning/results/simul_2_Nov2016.dat"

gen round =r


collapse coop, by(match simul)

tw line coop m if simul ==0, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==1, connect(l) msymbol(Oh) lpattern(solid) ///
  || line coop m if simul ==2, connect(l) msymbol(Oh) lpattern(longdash) ///
    || line coop m if simul ==3, connect(l) msymbol(Oh) lpattern(shortdash) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) xtitle("Supergame") ytitle("Cooperation Rate") ///
 legend(lab(1 E8 ) lab(2 D8) lab(3 CF1) lab(4 CF2) row(1)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) subtitle("")  ///
 note("E8 (solid line above) corresponds to simulations with E8 learning estimates and stage game parameters." "D8 (solid line below) corresponds to simulations with D8 learning estimates and stage game parameters." "CF1 (dashed line below) corresponds to simulations with E8 learning estimates and D8 stage game parameters." "CF2 (dashed line above) corresponds to simulations with D8 learning estimates and E8 stage game parameters.", size(vsmall))  ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul_cf_long.pdf", replace
graph export "$learning/results/graphs/new/simul_cf_long.eps", replace

graph export "$figFolder/simul_cf_long.pdf", replace
graph export "$figFolder/simul_cf_long.eps", replace


tw line coop m if simul ==0, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==1, connect(l) msymbol(Oh) lpattern(longdash) ///
  || line coop m if simul ==2, connect(l) msymbol(Oh) lpattern(shortdash) /// 
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) xtitle("Supergame") ytitle("Cooperation Rate") ///
 legend(lab(1 E8 ) lab(2 D8) lab(3 CF1) lab(4 CF2) row(1)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) subtitle("")  ///
 note("E8 corresponds to simulations with E8 learning estimates and stage game parameters." "D8  corresponds to simulations with D8 learning estimates and stage game parameters." "CF1 corresponds to simulations with E8 learning estimates and D8 stage game parameters.", size(vsmall))  ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul_cf_long_wocf2.pdf", replace
graph export "$learning/results/graphs/new/simul_cf_long_wocf2.eps", replace

graph export "$figFolder/simul_cf_long_wocf2.pdf", replace
graph export "$figFolder/simul_cf_long_wocf2.eps", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//LEARNING ONLINE APPENDIX
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Table A14: Summary statistics
//Table A16: Summary statistics

//Needs to be fixed

clear
infile treatment id lambda delta sigma decay beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9 beta10 beta11 tll ad using "$learning/results/estimates_all.txt", clear
drop if ad ==1
gen str = beta1 +beta2 +beta3 +beta4 +beta5 + beta6 + beta7 + beta8 + beta9 + beta10 + beta11
gen nbeta1 = beta1/str
gen nbeta2 = beta2/str
gen nbeta3 = beta3/str
gen nbeta4 = beta4/str
gen nbeta5 = beta5/str
gen nbeta6 = beta6/str
gen nbeta7 = beta7/str
gen nbeta8 = beta8/str
gen nbeta9 = beta9/str
gen nbeta10 = beta10/str
gen nbeta11 = beta11/str
gen ll = tll
drop beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9 beta10 beta11 ad ll
summarize if treatment ==4
summarize if treatment ==3
summarize if treatment ==2
summarize if treatment ==1



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A7: Average Cooperation: Simulation Versus Experimental data

* Short horizon treatments

clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==2
keep match round subject coop
gen r  = round
drop round
gen simul = 0
*append simulated data
append using "$learning/results/simul_2_Nov2016.dat"
gen round =r


collapse coop, by(match simul)
drop if match >30

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xlabel(0(10)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D8") ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/Agg_simul2.pdf", replace
graph export "$learning/results/graphs/new/Agg_simul2.eps", replace

* Short horizon treatments

clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==3
keep match round subject coop
gen r  = round
drop round
gen simul = 0
*append simulated data
append using "$learning/results/simul_3_Nov2016.dat"
gen round =r


collapse coop, by(match simul)
drop if match >30

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xlabel(0(10)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D4") ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/Agg_simul3.pdf", replace
graph export "$learning/results/graphs/new/Agg_simul3.eps", replace





//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A8: Mean round to first defection by supergame: simulation versus experimental data



* Long horizon treatments

*SIMULATION 
clear
infile fdef using "$learning/results/simulfdef_4_Nov2016.txt", clear
*drop ocoop
gen match = _n
gen simul = 1


*drop if match>30
save "$learning/results/simul_fdef_4.dat", replace



*ACTUAL DATA
clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==4
*keep match round subject coop
gen simul = 0
gen foo = (coop == 0 & coop_m1 == 1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
gen baz1 = foo * round
gen baz2 = baz1
replace baz2 = mlength +1 if baz1 ==0
egen fdef = min(baz2), by(id session match treatment)
drop foo baz1 baz2
keep fdef match simul

*append simulated data
append using "$learning/results/simul_fdef_4.dat"


collapse fdef, by(match simul)
drop if match >30

tw line fdef m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line fdef m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xlabel(0(10)30) ylabel(0(2)8) ytitle("Round") xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
title("") graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("E8") ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/Fdef_simul4.pdf", replace
graph export "$learning/results/graphs/new/Fdef_simul4.eps", replace

graph export "$figFolder/Fdef_simul4.pdf", replace
graph export "$figFolder/Fdef_simul4.eps", replace

* Short horizon treatments
*SIMULATION 
clear
infile fdef using "$learning/results/simulfdef_1_Nov2016.txt", clear
*drop ocoop
gen match = _n
gen simul = 1


*drop if match>30
save "$learning/results/simul_fdef_1.dat", replace



*ACTUAL DATA
clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==1
*keep match round subject coop
gen simul = 0
gen foo = (coop == 0 & coop_m1 == 1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
gen baz1 = foo * round
gen baz2 = baz1
replace baz2 = mlength +1 if baz1 ==0
egen fdef = min(baz2), by(id session match treatment)
drop foo baz1 baz2
keep fdef match simul

*append simulated data
append using "$learning/results/simul_fdef_1.dat"


collapse fdef, by(match simul)
drop if match >30

tw line fdef m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line fdef m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xlabel(0(10)30) ylabel(0(1)4) ytitle("Round") xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
title("") graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("E4") ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/Fdef_simul1.pdf", replace
graph export "$learning/results/graphs/new/Fdef_simul1.eps", replace

graph export "$figFolder/Fdef_simul1.pdf", replace
graph export "$figFolder/Fdef_simul1.eps", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A9: Long term evolution of mean round of first defection by supergame

*Fdef
clear
use "$learning/results/simul_fdef_1.dat"
gen treatment =1
append using "$learning/results/simul_fdef_2.dat"
replace treatment =2 if treatment ==.
append using "$learning/results/simul_fdef_3.dat"
replace treatment =3 if treatment ==.
append using "$learning/results/simul_fdef_4.dat"
replace treatment =4 if treatment ==.

collapse fdef, by(match treatment)

tw line fdef m if treatment ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line fdef m if treatment ==3, connect(l) msymbol(Oh) lpattern(dash) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(1(1)4) ytitle("Simulated first defection")  xtitle("Supergame")  ///
 legend(lab(1 E4) lab(2 D4)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("Short horizon treatments")  ///
 saving("$learning/results/graphs/foo.gph", replace)
 
 *Now save it
graph export "$learning/results/graphs/new/Fdef_simul_short.pdf", replace
graph export "$learning/results/graphs/new/Fdef_simul_short.eps", replace

graph export "$figFolder/Fdef_simul_short.pdf", replace
graph export "$figFolder/Fdef_simul_short.eps", replace

 
 tw line fdef m if treatment ==4, connect(l) msymbol(o) lpattern(solid) ///
 || line fdef m if treatment ==2, connect(l) msymbol(Oh) lpattern(dash) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(1(1)8) ytitle("Simulated first defection")  xtitle("Supergame")  ///
 legend(lab(1 E8) lab(2 D8)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("Long horizon treatments")  ///
 saving("$learning/results/graphs/foo.gph", replace)
 
  *Now save it
graph export "$learning/results/graphs/new/Fdef_simul_long.pdf", replace
graph export "$learning/results/graphs/new/Fdef_simul_long.eps", replace

graph export "$figFolder/Fdef_simul_long.pdf", replace
graph export "$figFolder/Fdef_simul_long.eps", replace



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A10: Average cooperation rate by supergame: simulation versus experimental data for each round in the short horizon treatments

* First long horizon with log scale

*SIMULATION 
clear
infile coop using "$learning/results/simul_3_Nov2016.txt", clear
gen period = _n
gen r = mod(period, 4)
replace r = 4 if r ==0
gen simul = 1
gen match = floor(period/4) +1
replace match = floor(period/4) if r==4
drop period
save "$learning/results/simul_3_Nov2016.dat", replace


*ACTUAL DATA
clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==3
keep match round subject coop
gen r  = round
drop round
gen simul = 0
*append simulated data
append using "$learning/results/simul_3_Nov2016.dat"
gen round =r


collapse coop, by(round match simul)

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) ytitle("Cooperation Rate")  xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D4") row(1)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul3_long.pdf", replace
graph export "$learning/results/graphs/new/simul3_long.eps", replace

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) ytitle("Cooperation Rate")  xtitle("Supergame") ///
 legend(lab(1 Simulation)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D4") row(1)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul3_long_woexp.pdf", replace
graph export "$learning/results/graphs/new/simul3_long_woexp.eps", replace

* Now graph short horizon

drop if match>30

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xlabel(0(10)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D4") row(1)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul3.pdf", replace
graph export "$learning/results/graphs/new/simul3.eps", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A11: Long term evolution of cooperation rate for each round of the short horizon treatments
//See code for Figure A10.

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A12: Average cooperation rate by supergame: simulation versus experimental data for each round in D8

*SIMULATION 
clear
infile coop using "$learning/results/simul_2_Nov2016.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen simul = 1
gen match = floor(period/8) +1
replace match = floor(period/8) if r==8
drop period
save "$learning/results/simul_2_Nov2016.dat", replace

*ACTUAL DATA
clear
use "$data/stata/dat_exp_sy1.dta"
keep if treatment ==2
keep match round subject coop
gen r  = round
drop round
gen simul = 0
*append simulated data
append using "$learning/results/simul_2_Nov2016.dat"
gen round =r


collapse coop, by(round match simul)

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) ytitle("Cooperation Rate")  xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D8") row(2)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul2_long.pdf", replace
graph export "$learning/results/graphs/new/simul2_long.eps", replace

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 xscale(log) xlabel(1 30 100 1000) ylabel(0(0.2)1) ytitle("Cooperation Rate")  xtitle("Supergame") ///
 legend(lab(1 Simulation)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D8") row(2)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul2_long_woexp.pdf", replace
graph export "$learning/results/graphs/new/simul2_long_woexp.eps", replace

* Now graph short horizon

drop if match>30

tw line coop m if simul ==1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==0, connect(l) msymbol(Oh) lpattern(dash) ///
 xlabel(0(10)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 Simulation) lab(2 Experiment)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("D8") row(2)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul2.pdf", replace
graph export "$learning/results/graphs/new/simul2.eps", replace

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

// Figure A13: Long Term Evolution of Aggregate cooperation In Each Round In E8
//See code for Figure 11.

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A14: Long term evolution of cooperation rate for each round of D8
//See code for Figure A12.



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A15: Cumulative Distribution of Cooperation Against an AD type In E8 (Su- pergames 250-300)


clear
infile treatment id lambda delta sigma decay beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9 beta10 beta11 tll avgcoop coop1 sortind using "$learning/results/est4_sorted_sy.txt", clear
keep avgcoop
cumul avgcoop, gen(cum)
sort cum
line cum avgcoop, ylab(, grid) ///
xtitle("Cooperation Rate") ytitle("Probability") ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 subtitle("") ///
saving("$figFolder/foo.gph", replace)


graph export "$figFolder/simul_cooptypes_e8.eps", replace
graph export "$figFolder/simul_cooptypes_e8.pdf", replace



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A16: Long term Evolution of Aggregate Cooperation For Each Round In E8 By Subset


*SIMULATION 
clear
infile coop using "$learning/results/simul_4_ss80_Aug2015.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen match = floor(period/8) +1
replace match = floor(period/8) if r==8
drop period
gen simul = 80
save "$learning/results/simul80.dat", replace

*SIMULATION 
clear
infile coop using "$learning/results/simul_4_ss60_Aug2015.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen match = floor(period/8) +1
replace match = floor(period/8) if r==8
drop period
gen simul = 60
save "$learning/results/simul60.dat", replace


clear
use "$learning/results/simul_4_Nov2016.dat"
replace simul =100
*append 
drop if match>300
append using "$learning/results/simul80.dat"
append using "$learning/results/simul60.dat"
gen round =r


collapse coop, by(round match simul)
*drop if match >30

tw lowess coop m if simul ==100, connect(l) msymbol(o) lpattern(solid) ///
 || lowess coop m if simul ==80, connect(l) msymbol(Oh) lpattern(dash) ///
 || lowess coop m if simul ==60, connect(l) msymbol(Oh) lpattern(dash_dot) ///
 xlabel(0(100)300) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 All subjects) lab(2 Subset: 80%) lab(3 Subset: 60%) row(1)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 by(round, title("") graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("E8") note("Graphy by round") note("Stata command lowess used to smooth data") row(2)) ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/subset/simul_4_subsets_300_lt.pdf", replace
graph export "$learning/results/graphs/new/subset/simul_4_subsets_300_lt.eps", replace


collapse coop, by(match simul)

tw line coop m if simul ==100, connect(l) msymbol(o) lpattern(solid) ///
 || line coop m if simul ==80, connect(l) msymbol(Oh) lpattern(dash) ///
 || line coop m if simul ==60, connect(l) msymbol(Oh) lpattern(dash_dot) ///
 xlabel(0(100)300) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 All subjects) lab(2 Subset: 80%) lab(3 Subset: 60%) row(1)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
subtitle("E8") note("Graphy by round") note("Stata command lowess used to smooth data")  ///
 saving("$learning/results/graphs/foo.gph", replace)

 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A17: Long term Evolution of Aggregate Cooperation
//See code for Figure 12.


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A18: Frequency and Expected Payoff of Each Strategy

clear
infile payoff using "$learning/results/simul_2_expstr.txt", clear
gen period = _n
gen str = mod(period, 11)
replace str = 11 if str ==0
gen match = floor(period/11) +1
replace match = floor(period/11) if str==11
drop period
save "$learning/results/str_simul_2.dat", replace


clear
infile struse using "$learning/results/simul_2_struse.txt", clear
gen period = _n
gen str = mod(period, 11)
replace str = 11 if str ==0
gen match = floor(period/11) +1
replace match = floor(period/11) if str==11
drop period
save "$learning/results/struse_simul_2.dat", replace


clear 
use "$learning/results/struse_simul_4.dat"
append using "$learning/results/str_simul_4.dat"
egen epayoff = max(payoff), by(match str)
drop payoff 
drop if struse == .
keep if match == 1

twoway bar struse str, yaxis(1) ylabel(0.1(0.1)0.5, axis(1)) ytitle("Frequency", axis(1)) fintensity(inten30) lwidth(thick) lcolor(white) ///
 || line epayoff str , connect(l) msymbol(o) lpattern(solid) sort yaxis(2) ylabel(320(20)400, axis(2)) ///
 ytitle("Payoff", axis(2)) xtitle("Strategy") ///
 legend(lab(1 "Frequency of Strategy Choice") lab(2 "Expected Payoff" ) row(1)) ///
 xlabel(1 "Th 1" 2 "Th 2" 3 "Th 3"  4 "Th 4" 5 "Th 5" 6 "Th 6" 7 "Th 7" 8 "Th 8" 9 "Th 9" 10 "TFT" 11 "STFT",  grid gmax) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) title("E8") subtitle("Supergame 1") 
*Now save it
graph export "$learning/results/graphs/new/simul_4_expstr_m1.pdf", replace
graph export "$learning/results/graphs/new/simul_4_expstr_m1.eps", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//Figure A19: Effects of constraining decline in implementation noise

*SIMULATION 
clear
infile coop using "$learning/results/simul_4_RobustnesswithMinEnoise.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen simul = 1
gen foo =  mod(period, 8000)
replace foo = 8000 if r ==0
gen match = floor(foo/8) +1
replace match = floor(foo/8) if r==8
replace match = 1000 if match ==0
gen baz = floor(period/8000)
replace baz = floor(period/8000) -1 if mod(period, 8000) ==0
gen minenoise = baz*0.005
drop period foo baz
gen treatment =4
save "$learning/results/simul_4_r_qje.dat", replace

clear
infile coop using "$learning/results/simul_1_RobustnesswithMinEnoise.txt", clear
gen period = _n
gen r = mod(period, 4)
replace r = 4 if r ==0
gen simul = 1
gen foo =  mod(period, 4000)
replace foo = 4000 if r ==0
gen match = floor(foo/4) +1
replace match = floor(foo/4) if r==4
replace match = 1000 if match ==0
gen baz = floor(period/4000)
replace baz = floor(period/4000) -1 if mod(period, 4000) ==0
gen minenoise = baz*0.005
drop period foo baz
gen treatment =1
save "$learning/results/simul_1_r_qje.dat", replace

clear
infile coop using "$learning/results/simul_3_RobustnesswithMinEnoise.txt", clear
gen period = _n
gen r = mod(period, 4)
replace r = 4 if r ==0
gen simul = 1
gen foo =  mod(period, 4000)
replace foo = 4000 if r ==0
gen match = floor(foo/4) +1
replace match = floor(foo/4) if r==4
replace match = 1000 if match ==0
gen baz = floor(period/4000)
replace baz = floor(period/4000) -1 if mod(period, 4000) ==0
gen minenoise = baz*0.005
drop period foo baz
gen treatment =3
save "$learning/results/simul_3_r_qje.dat", replace

clear
infile coop using "$learning/results/simul_2_RobustnesswithMinEnoise.txt", clear
gen period = _n
gen r = mod(period, 8)
replace r = 8 if r ==0
gen simul = 1
gen foo =  mod(period, 8000)
replace foo = 8000 if r ==0
gen match = floor(foo/8) +1
replace match = floor(foo/8) if r==8
replace match = 1000 if match ==0
gen baz = floor(period/8000)
replace baz = floor(period/8000) -1 if mod(period, 8000) ==0
gen minenoise = baz*0.005
drop period foo baz
gen treatment =2
save "$learning/results/simul_2_r_qje.dat", replace



clear
use "$learning/results/simul_4_r_qje.dat"
append using "$learning/results/simul_1_r_qje.dat"
append using "$learning/results/simul_2_r_qje.dat"
append using "$learning/results/simul_3_r_qje.dat"
keep if match ==1000
collapse coop, by(minenoise treatment)

                                                                    
tw lowess coop minenoise if treatment ==1, connect(l) msymbol(o) lpattern(solid) ///
 || lowess coop minenoise if treatment ==2, connect(l) msymbol(o) lpattern(dash)  ///
  || lowess coop minenoise if treatment ==3, connect(l) msymbol(o) lpattern(dash_dot)  ///
  || lowess coop minenoise if treatment ==4, connect(l) msymbol(o) lpattern(longdash) ///
 xlabel(0(0.1)0.5) ylabel(0(0.2)1) ytitle("Cooperation Rate at Supergame 1000") xtitle("Minimal Implementation Noise") ///
 legend(lab(1 E4) lab(2 D8) lab(3 D4) lab(4 E8) row(1)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) subtitle("") note("") note("Stata command lowess used to smooth data")  ///
 saving("$learning/results/graphs/foo.gph", replace)
	
*Now save it
graph export "$learning/results/graphs/new/simul_minimalnoise_qje.pdf", replace
graph export "$learning/results/graphs/new/simul_minimalnoise_qje_lt.eps", replace

*Now save it
graph export "$figFolder/simul_minimalnoise_qje.pdf", replace
graph export "$figFolder/simul_minimalnoise_qje_lt.eps", replace

 

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//META ONLINE APPENDIX	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE A1: Summary of Experiments and Sessions Included in the Meta-Study
use "$data/stata/efy_dat_meta_1.dta" , clear
bysort paper length g l: count if (round ==1 & treat_match ==1)
bysort paper length g l: tab match treat_match
keep if paper ==1
bysort length g l: tab maxmatch 



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE A2: Marginal Effects of Correlated Random-Effects Regressions for the Standard Perspective

**** load data
use "$data/stata/efy_dat_meta_1.dta" , clear
xtset id period // set data as panel

**** set local for significance stars in regression tables
local sigstars `"star(* 0.1 ** 0.05 *** 0.01)"'


** preserve data, generate cooperation variables and collapse to single observation per subjectID-supergame
preserve
gen byte coop_r1 = coop if round == 1
gen byte coop_rl = coop if round == length
gen byte ocoop_r1 = ocoop if round == 1
egen coop_avg = mean(coop), by(id match)

collapse (firstnm) coop_r1 (firstnm) coop_rl (firstnm) coop_avg (firstnm) first_defect ///
			(firstnm) treat_match /// 
			(firstnm) treatment (firstnm) g (firstnm) l (firstnm) length ///
			(firstnm) coop_first (firstnm) ocoop_r1 ///
			, by(paper session id match)
sort paper session id match		
			
** generate some additional variables
bysort id treatment (treat_match): gen byte ocoop_r1_m1 = ocoop_r1[_n-1]
gen int treat_match2 = treat_match * (length == 2)
gen int long treat_match4 = treat_match * (length == 4)
gen int treat_match8 = treat_match * (length == 8)
gen int treat_match10 = treat_match * (length == 10)

** relabel variables
label variable g "$ g $ "
label variable l "$ l $ "
label variable length "Horizon"
label variable treat_match "Supergame"
label variable treat_match2 "Supergame $\times \left\{ H = 2 \right\}$"
label variable treat_match4 "Supergame $\times \left\{ H = 4 \right\}$"
label variable treat_match8 "Supergame $\times \left\{ H = 8 \right\}$"
label variable treat_match10 "Supergame $\times \left\{ H = 10 \right\}$"
label variable coop_first "Initial Coop. in Supergame 1"
label variable ocoop_r1_m1 "Other Initial Coop. in Supergame - 1"

** set integration points for probit estimations
local intpointsOptionXtprobit "intpoints(12)" 
local intpointsOptionMEprobit "intpoints(12)" 

** set prediction options margin commands for random effects models
local predictTypeXtprobit "pu0" 
local predictTypeMEprobit "mu" 
local predictTypeMixed "xb" 
	
**** run meprobit/xtprobit and mixed/xtreg regressions

	
	** probability of cooperative action choice
	foreach dvar in r1 rl avg {
		
		meprobit coop_`dvar' g l length treat_match2-treat_match10 coop_first || id : , vce(cluster paper) `intpointsOptionMEprobit' 
		margins if e(sample) , predict(`predictTypeMEprobit') dydx(_all) post
		estimates store meta_c`dvar'_mep_paper
	}
	
	** mean round to first defection
	
	mixed first_defect g l length treat_match2-treat_match10 coop_first || id : , vce(cluster paper) 
	margins if e(sample) , predict(xb) dydx(_all) post
	estimates store meta_mfd_me_paper
	

* for tex document
    esttab meta_cr1_mep_paper meta_crl_mep_paper meta_cavg_mep_paper meta_mfd_me_paper ///
	using "$tableFolder/regtable_standardPerspective_sigTests_sy" ///
	, b(%10.2f) `sigstars' se(%10.3f) ///
	noobs label nomtitles nonumbers eql("") /// drop(*b.* *o.*)
	nolines nonotes nogaps wide booktabs  fragment replace /// coeflabels()		
	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

// FIGURE A1 IN ONLINE APPENDIX: Normalized Game Parameters

use "$data/stata/efy_dat_meta_1.dta" , clear
collapse length, by(paper g l)
set obs 15
replace paper = 6 if _n == 10
replace paper = 7 if _n == 11
replace paper = 8 if _n == 12
replace paper = 8 if _n == 13
replace paper = 8 if _n == 14
replace paper = 8 if _n == 15
replace g = 1.7 if paper == 6
replace l = 1.2 if paper == 6
replace g = 0.3333333333 if paper == 7
replace l = 0.8333333333 if paper == 7
replace g = 3 if _n == 12 | _n == 13
replace l = 2.833333333 if _n == 12 | _n == 13
replace g = 1 if _n == 14 | _n == 15
replace l = 1.416666666 if _n == 14 | _n == 15
*coding 12 as D4, 13 as D8, 14 as E4 and 15 as E8
*it looks like it was unnecessary to code the different horizons separately

* generate data for area
gen areax = paper -1 if paper < 7 // creates x variable 0-4
gen areay = areax + 1 // generates g = l + 1 line (for 2R > T+S equiv. 2 > (1+g)-l equiv. g < l+1)
gen areay2 = areay - 2 // generates 1+g-l > 0 line (for T+S >2P equiv. 2 > (1+g)-l equiv. g < l+1)
replace areay =4 if areay >4 // cap y axis at 4
replace areay2 =0 if areay2 <0 // cap y axis at 0

twoway rarea areay areay2 areax if paper <7, color(gs15) lwidth(none) ///
 || scatter g l if paper == 1, msymbol(Dh) lpattern(solid) msize(large) mcolor(gs7) ///
 || scatter g l if paper == 2, msymbol(O) lpattern(dash) msize(large) ///
 || scatter g l if paper == 3, msymbol(T) lpattern(dot) msize(large) mcolor(gs7) ///
 || scatter g l if paper == 4, msymbol(Th) lpattern(longdash_dot) msize(large)  mcolor(gs7) ///
  || scatter g l if paper == 5,  msymbol(D) lpattern(dash_dot) msize(large) mcolor(gs7) ///
    ||scatter g l if paper == 6, msymbol(d) lpattern("") msize(large) mcolor(gs7) ///
    ||scatter g l if paper == 7, msymbol(o) lpattern("") msize(large) mcolor(gs7) ///
    ||scatter g l if paper == 8, msymbol(S) lpattern("") msize(large) mcolor(gs3) ///
     xlabel(0(1) 5) ylabel(0(1)4) xtitle("Loss parameter ({it:l})")ytitle("Gain parameter ({it:g})") ///
     legend(lab(2 DB2005) lab(3 AM1993) lab(4 CDFR1996) lab(5 FO2012) lab(6 BMR2006) lab(7 SS1986) lab(8 HN2001) lab(9 EFY) order(2 3 4 5 6 7 8 9) ring(0) pos(5)) ///
      graphregion(color(white)) bgcolor(white) scheme(s2mono) ///
       title("Finitely repeated PD experiments") subtitle("Normalized payoffs") ///
       note("Shaded region indicates 2> 1+g-l >0, which ensures 2R> T+S > 2P." "Solid markers indicate between-subject design. " "Parameters used in this paper are added here as a reference and are marked as EFY.") ///
       saving("$figFolder/meta_gl_all" , replace)
       graph export "$figFolder/meta_gl_all.eps", replace
       graph export "$figFolder/meta_gl_all.pdf", replace
	   

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	 

// TABLE A3: Marginal Effects of Correlated Random-Effects Probit Regression of the Prob- ability of Cooperating in Round One

use "$data/stata/efy_dat_meta_1.dta" , clear
gen sizebad = l / (length - 1 + l - g)
replace sizebad = 1 if sizebad > 1


keep if round == 1
bysort id treatment (treat_match): gen ocoop_r1_m1 = ocoop[_n-1]	/* this keeps track of the round 1 choice of the opponent in the previous match of the current treatment */
gen treat_match2 = treat_match * (length == 2)
gen treat_match4 = treat_match * (length == 4)
gen treat_match8 = treat_match * (length == 8)
gen treat_match10 = treat_match * (length == 10)



meprobit coop g l length treat_match2-treat_match10 ocoop_r1_m1 coop_first || id : , vce(cluster paper) intpoints(12)
margins, dydx(_all) post
estimates store coop_first_meta_pbt_spec1

meprobit coop g l length sizebad treat_match2-treat_match10 ocoop_r1_m1 coop_first || id : , vce(cluster paper)
margins, dydx(_all) post
estimates store coop_first_meta_pbt_spec3



esttab coop_first_meta_pbt_spec1 coop_first_meta_pbt_spec3 ///
	using "$tableFolder/tab_reg_coop_first_meta_pbt_sy" ///
	, b(%10.2f) `sigstars' se(%10.3f) margin discrete("") ///
	order(g l length sizebad treat_match2 treat_match4 treat_match8 treat_match10 ocoop_r1_m1 coop_first) ///
	noobs nodep label nomtitles nonumbers eql("") nolines nonotes nogaps booktabs wide fragment replace

	   
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
	   
	   
// FIGURE A2: Comparison of the Size of the Basin of Attraction for AD and the Horizon

use "$data/stata/efy_dat_meta_1.dta" , clear
collapse paper, by(length g l)
set obs 17
replace paper = 6 if _n == 12
replace paper = 7 if _n == 13
replace paper = 8 if _n == 14
replace paper = 8 if _n == 15
replace paper = 8 if _n == 16
replace paper = 8 if _n == 17
replace g = 1.7 if paper == 6
replace l = 1.2 if paper == 6
replace g = 0.3333333333 if paper == 7
replace l = 0.8333333333 if paper == 7
replace g = 3 if _n == 14 | _n == 15
replace l = 2.833333333 if _n == 14 | _n == 15
replace g = 1 if _n == 16 | _n == 17
replace l = 1.416666666 if _n == 16 | _n == 17
replace length = 10 if paper ==7
replace length = 8 if paper == 8
replace length = 4  if _n == 14 | _n == 16
replace length = 8  if _n == 15 | _n == 17
gen sizebad = l/[(length - 1) + l - g]
*coding 14 as D4, 15 as D8, 16 as E4 and 17 as E8


twoway scatter sizebad length if paper == 1, msymbol(Dh) lpattern(solid) msize(large) mcolor(gs7) ///
 || scatter sizebad length  if paper == 2, msymbol(O) lpattern(dash) msize(large) ///
 || scatter sizebad length  if paper == 3, msymbol(T) lpattern(dot) msize(large) mcolor(gs7) ///
 || scatter sizebad length  if paper == 4, msymbol(Th) lpattern(longdash_dot) msize(large)  mcolor(gs7) ///
 || scatter sizebad length  if paper == 5,  msymbol(D) lpattern(dash_dot) msize(large) mcolor(gs7) ///
 || scatter sizebad length  if paper == 6, msymbol(d) lpattern("") msize(large) mcolor(gs7) ///
 || scatter sizebad length  if paper == 7, msymbol(o) lpattern("") msize(large) mcolor(gs7) ///
 || scatter sizebad length  if paper == 8, msymbol(S) lpattern("") msize(large) mcolor(gs3) ///
 || lfit sizebad length if paper ~=8, lpattern(solid) ///
     xlabel(1(1) 10) ylabel(0(0.4)1.2) xtitle("Horizon")ytitle("Size of basin of attraction for AD") ///
     legend(lab(1 DB2005) lab(2 AM1993) lab(3 CDFR1996) lab(4 FO2012) lab(5 BMR2006) lab(6 SS1986) lab(7 HN2001) lab(8 EFY) order(1 2 3 4 5 6 7 8) ring(0) pos(2)) ///
      graphregion(color(white)) bgcolor(white) scheme(s2mono) ///
       title("") subtitle("") ///
       note("Solid markers indicate between-subject design. " "Parameters used in this paper are added here as a reference and are marked as EYF." "Line shows predicted values given horizon for fit not including EFY values. ") ///
       saving("$figFolder/meta_gl_all" , replace)
       graph export "$figFolder/meta_sbad_all.eps", replace
       graph export "$figFolder/meta_sbad_all.pdf", replace
	   
	


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

 
// TABLE A4: Marginal Effects of Correlated Random-Effects Probit Regression of the Prob- ability of Cooperating in Round One
    
use "$data/stata/efy_dat_meta_1.dta" , clear

keep if round == 1
bysort id treatment (treat_match): gen ocoop_r1_m1 = ocoop[_n-1]	/* this keeps track of the round 1 choice of the opponent in the previous match of the current treatment */
gen sizebad = l / (length - 1 + l - g)
replace sizebad = 1 if sizebad > 1


egen param = group(length g l)
* to label dummies in regression output
table param, c(mean g mean l mean length)



gen treat_match_1 = treat_match * (param == 1)
gen treat_match_2 = treat_match * (param == 2)
gen treat_match_3 = treat_match * (param == 3)
gen treat_match_4 = treat_match * (param == 4)
gen treat_match_5 = treat_match * (param == 5)
gen treat_match_6 = treat_match * (param == 6)
gen treat_match_7 = treat_match * (param == 7)
gen treat_match_8 = treat_match * (param == 8)
gen treat_match_9 = treat_match * (param == 9)
gen treat_match_10 = treat_match * (param == 10)
gen treat_match_11 = treat_match * (param == 11)

** relabel variables
label variable g "$ g $ "
label variable l "$ l $ "
label variable length "Horizon"
label variable treat_match_1 "Supergame $\times \textbf{1} \left\{ g = 0.83,\,\, \ell = 1.17,\,\,  H = 2 \right\}$ "
label variable treat_match_2 "Supergame $\times \textbf{1}\left\{ g = 1.17,\,\, \ell = 0.83,\,\,  H = 2 \right\}$"
label variable treat_match_3 "Supergame $\times \textbf{1} \left\{ g = 0.83,\,\, \ell = 1.17,\,\,  H = 4 \right\}$"
label variable treat_match_4 "Supergame $\times \textbf{1} \left\{ g = 1.17,\,\, \ell = 0.83,\,\,  H = 4 \right\}$"
label variable treat_match_5 "Supergame $\times \textbf{1} \left\{ g = 0.67,\,\, \ell = 0.67,\,\,  H = 8 \right\}$ "
label variable treat_match_6 "Supergame $\times \textbf{1} \left\{ g = 1.33,\,\, \ell = 0.67,\,\,  H = 8 \right\}$"
label variable treat_match_7 "Supergame $\times \textbf{1} \left\{ g = 2,\,\, \ell = 4,\,\,  H = 8 \right\}$ "
label variable treat_match_8 "Supergame $\times \textbf{1} \left\{ g = 4,\,\, \ell = 4,\,\,  H = 8 \right\}$"
label variable treat_match_9 "Supergame $\times \textbf{1} \left\{ g = 0.44,\,\, \ell = 0.78,\,\,  H = 10 \right\} $"
label variable treat_match_10 "Supergame $\times \textbf{1} \left\{ g = 1.67,\,\, \ell = 1.33,\,\,  H = 10 \right\} $"
label variable treat_match_11 "Supergame $\times \textbf{1} \left\{ g = 2.33,\,\, \ell = 2.33,\,\,  H = 10 \right\} $" 

label variable coop_first "Initial Coop. in Supergame 1"
label variable ocoop_r1_m1 "Other Initial Coop. in Supergame - 1"


* random effects probit with clusterig on the paper level
**THIS IS THE ONE IN THE APPENDIX RIGHT NOW
meprobit coop g l length treat_match_1-treat_match_11 ocoop_r1_m1 coop_first || id : , vce(cluster paper) intpoints(12)
margins, dydx(_all) post
estimates store coop_first_meta_pbt_spec1
meprobit coop g l length sizebad treat_match_1-treat_match_11 ocoop_r1_m1 coop_first || id : , vce(cluster paper) intpoints(12)
margins, dydx(_all) post
estimates store coop_first_meta_pbt_spec3

* Table from above regressions
* for tex document
esttab coop_first_meta_pbt_spec1 coop_first_meta_pbt_spec3 ///
	using "$tableFolder/tab_reg_coop_first_meta_app_sy" ///
	, b(%10.2f) `sigstars' se(%10.3f) margin discrete("") ///
	order(g l length sizebad treat_match2 treat_match4 treat_match8 treat_match10 ocoop_r1_m1 coop_first) ///
	noobs nodep label nomtitles nonumbers eql("") nolines nonotes nogaps booktabs wide fragment replace

	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE A3: Evolution of Cooperation by Round and First Defection	 
	 

//GOING BACK TO AM1993
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==2
gen mlength = length
gen foo = (coop == 0 & coop_m1 == 1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
gen baz1 = foo * round
gen baz2 = baz1
replace baz2 = mlength +1 if baz1 ==0
egen fdef = min(baz2), by(id session match)
drop foo baz1 baz2
gen baz1 = 0
replace baz1 = 1 if (coop ==1)
gen baz2 = round*baz1
egen gdef = max(baz2), by(id session match treatment)
replace gdef = gdef +1 
collapse fdef gdef, by(match)

tw line gdef match, connect(l) lpattern(solid)  ylabel(0(2)10) ///
|| line fdef match , connect(l) lpattern(dash) ///
 xtitle("Supergame")  ///
ytitle("Round") graphregion(color(white)) plotregion(fcolor(white)) ///
 legend(lab(1 "Last cooperation +1") lab(2 "First defection") rows(2)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") subtitle("") ///
 saving("$figFolder/lastcoop_am", replace) 



//UNRAVELLING IN AM1993
 
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==2
gen foo = 0 
replace foo = 1 if round ==1
replace foo = 3 if round ==length
replace foo = 2 if round == length -1
replace foo = 4 if round == length -2
replace foo = 1 if round ==1
drop if foo ==0
*keep if treatment ==11 //11 is for E8

collapse coop, by(foo match)

tw line coop match if foo == 1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop match if foo ==3, connect(l) msymbol(Oh) lpattern(dash) ///
 || line coop match if foo ==2, connect(l) msymbol(X) lpattern(longdash_dot) ///
 || line coop match if foo ==4, connect(l) msymbol(X) lpattern(dash_dot) ///
 xlabel(0(5)20) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 "Round 1") lab(2 "Last Round") lab(3 "Last Round -1") lab(4 "Last Round -2")  size(small) rows(2)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") subtitle("") ///
   saving("$figFolder/coop_byround_am", replace) 
   

graph export "$figFolder/exp:coopbyroundam.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:coopbyroundam.pdf", replace

graph combine  "$figFolder/coop_byround_am" "$figFolder/lastcoop_am", graphregion(color(white)) title("AM1993")  saving("$figFolder\brm", replace)
graph export "$figFolder/meta:am.eps", replace
graph export "$figFolder/meta:am.pdf", replace



//GOING BACK TO BMR2006
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==5
gen mlength = length
gen foo = (coop == 0 & coop_m1 == 1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
gen baz1 = foo * round
gen baz2 = baz1
replace baz2 = mlength +1 if baz1 ==0
egen fdef = min(baz2), by(id session match)
drop foo baz1 baz2
gen baz1 = 0
replace baz1 = 1 if (coop ==1)
gen baz2 = round*baz1
egen gdef = max(baz2), by(id session match treatment)
replace gdef = gdef +1 
collapse fdef gdef, by(match)

tw line gdef match, connect(l) lpattern(solid)  ylabel(0(2)10) ///
|| line fdef match , connect(l) lpattern(dash) ///
 xtitle("Supergame")  ///
ytitle("Round") graphregion(color(white)) plotregion(fcolor(white)) ///
 legend(lab(1 "Last cooperation +1") lab(2 "First defection") rows(2)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") subtitle("") ///
 saving("$figFolder/lastcoop_brm", replace) 



//UNRAVELLING IN BRM2006
 
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==5
gen foo = 0 
replace foo = 1 if round ==1
replace foo = 3 if round ==length
replace foo = 2 if round == length -1
replace foo = 4 if round == length -2
replace foo = 1 if round ==1
drop if foo ==0
*keep if treatment ==11 //11 is for E8

collapse coop, by(foo match)

tw line coop match if foo == 1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop match if foo ==3, connect(l) msymbol(Oh) lpattern(dash) ///
 || line coop match if foo ==2, connect(l) msymbol(X) lpattern(longdash_dot) ///
 || line coop match if foo ==4, connect(l) msymbol(X) lpattern(dash_dot) ///
 xlabel(0(5)20) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 "Round 1") lab(2 "Last Round") lab(3 "Last Round -1") lab(4 "Last Round -2")  size(small) rows(2)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") subtitle("") ///
   saving("$figFolder/coop_byround_brm", replace) 
   

graph export "$figFolder/exp:coopbyround_brm.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:coopbyround_brm.pdf", replace

graph combine  "$figFolder/coop_byround_brm" "$figFolder/lastcoop_brm", graphregion(color(white)) title("BMR2006")  saving("$figFolder\brm", replace)
graph export "$figFolder/meta:brm.eps", replace
graph export "$figFolder/meta:brm.pdf", replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////		
	   
//FIGURE A4: (LHS) Mean round to first defection: all pairs versus those that cooperated in round 1; (RHS) Probability of breakdown in cooperation   

// BMR2006
 
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==5
keep if round ==1
gen mcoop = coop*ocoop
egen mcooprate = mean(mcoop), by(match)
collapse first_defect, by(match mcoop mcooprate)
reshape wide first_defect, i(match mcooprate) j(mcoop)
gen fdeftotal = (1-mcooprate)*first_defect0 + (mcooprate)*first_defect1

twoway ( connected fdeftotal match, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected first_defect1 match , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Round") yscale(range(2 10)) ylabel(2(2)10) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(0(5)20) title("First defection") ///
	legend( order(1 2) label(1 "All") label(2 "Round 1 = (C,C)") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono) ////
		saving("$figFolder/exp_condfdef" , replace)

*breakdown
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==5
keep if round ==1
gen fdef = first_defect
keep if round ==1
gen mcat = 3
replace mcat =2 if match <11
gen mcoop = coop*ocoop
*keep if mcoop ==1
egen bd = sum(round), by(mcat fdef treatment)
egen ts = sum(round), by(mcat treatment)
gen pbreakdown = bd/ts
collapse pbreakdown, by(mcat fdef treatment)
*drop if fdef ==9
twoway ( connected pbreakdown fdef if mcat ==2, sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh)  ) ///
  || ( connected pbreakdown fdef if mcat ==3, sort lstyle(p5) lpattern(longdash_dot) mstyle(p5) msymbol(sh) ) ///
   ,xlabel(1(1)11) ylabel(0(0.1)0.4) ytitle("Probability") xtitle(Round) ///
   legend(lab(1 SG:1-10) lab(2 SG:11-20)  size(small) rows(1)) ///
    bgcolor(white)  scheme(s2mono) graphregion(color(white)) title("Breakdown of cooperation")  ///
    plotregion(fcolo(white)) ///
    saving("$figFolder/exp_bd8", replace)
   
graph combine "$figFolder/exp_condfdef" "$figFolder/exp_bd8", graphregion(color(white)) title("BMR2006") note("Note: SG stands for supergame.") saving("$figFolder\d8", replace)
graph export "$figFolder/meta:brm2006.eps" , as(eps) preview(off) replace
graph export "$figFolder/meta:brm2006.pdf", replace


// AM1993
 
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==2
keep if round ==1
gen mcoop = coop*ocoop
egen mcooprate = mean(mcoop), by(match)
collapse first_defect, by(match mcoop mcooprate)
reshape wide first_defect, i(match mcooprate) j(mcoop)
gen fdeftotal = (1-mcooprate)*first_defect0 + (mcooprate)*first_defect1
replace fdeftotal = first_defect0 if mcooprate ==0

twoway ( connected fdeftotal match, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected first_defect1 match , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Round") yscale(range(0 10)) ylabel(2(2)10) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(0(5)20) title("First defection") ///
	legend( order(1 2) label(1 "All") label(2 "Round 1 = (C,C)") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono) ////
		saving("$figFolder/exp_condfdef" , replace)

*breakdown
clear
use "$data/stata/efy_dat_meta_1.dta" , clear
keep if paper ==2
keep if round ==1
gen fdef = first_defect
keep if round ==1
gen mcat = 3
replace mcat =2 if match <11
gen mcoop = coop*ocoop
*keep if mcoop ==1
egen bd = sum(round), by(mcat fdef treatment)
egen ts = sum(round), by(mcat treatment)
gen pbreakdown = bd/ts
collapse pbreakdown, by(mcat fdef treatment)
*drop if fdef ==9
twoway ( connected pbreakdown fdef if mcat ==2, sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh)  ) ///
  || ( connected pbreakdown fdef if mcat ==3, sort lstyle(p5) lpattern(longdash_dot) mstyle(p5) msymbol(sh) ) ///
   ,xlabel(1(1)11) ylabel(0(0.1)0.4) ytitle("Probability") xtitle(Round) ///
   legend(lab(1 SG:1-10) lab(2 SG:11-20)  size(small) rows(1)) ///
    bgcolor(white)  scheme(s2mono) graphregion(color(white)) title("Breakdown of cooperation")  ///
    plotregion(fcolo(white)) ///
    saving("$figFolder/exp_bd8", replace)
   
graph combine "$figFolder/exp_condfdef" "$figFolder/exp_bd8", graphregion(color(white)) title("AM1993") note("Note: SG stands for supergame.") saving("$figFolder\d8", replace)
graph export "$figFolder/meta:am1993.eps" , as(eps) preview(off) replace
graph export "$figFolder/meta:am1993.pdf", replace
	 
	 
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
	   
// TABLE A5: Consistency of Play with Threshold Strategies

use "$data/stata/efy_dat_meta_1.dta" , clear
drop if treat_match > 1 & treat_match ~= maxmatch
gen treat_match_mod = treat_match
replace treat_match_mod = 999 if treat_match == maxmatch
gen mcoop = coop *ocoop
gen foo = (mcoop == 0 & coop_m1 == 1 & ocoop_m1 ==1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
replace foo = 1 if round ==1 & ocoop ==0
gen baz1 = foo * round
replace baz1 = length +1 if baz1 ==0
egen mfdef = min(baz1), by(id session match)
gen deviation =0
replace deviation =1 if (round >mfdef & coop ==1)
egen totdev = sum(deviation), by(id session match)
gen perfectthres = 0
replace perfectthres = 1 if totdev ==0
keep if round ==1
keep if length>2

*collapse perfectthres, by(paper treat_match_mod g l)
gen displaygl = round(g, 0.01)*10000 +l/10
table treat_match_mod displaygl if paper == 1, c(mean perfectthres)
table treat_match_mod displaygl if paper == 2, c(mean perfectthres)
table treat_match_mod displaygl if paper == 3, c(mean perfectthres)
table treat_match_mod displaygl if paper == 4, c(mean perfectthres)
table treat_match_mod displaygl if paper == 5, c(mean perfectthres)

*report all
table treat_match_mod, c(mean perfectthres)

*report all
table treatment, c(mean displaygl)

gen dummy_last = 0
replace dummy_last = 1 if treat_match_mod == 999

gen treat_f4 = (treatment ==4 & dummy_last ==0)
gen treat_f5 = (treatment ==5  & dummy_last ==0)
gen treat_f6 = (treatment ==6  & dummy_last ==0)
gen treat_f7 = (treatment ==7   & dummy_last ==0)
gen treat_f8 = (treatment ==8   & dummy_last ==0)
gen treat_f9 = (treatment ==9   & dummy_last ==0)
gen treat_f10 = (treatment ==10 & dummy_last ==0)
gen treat_f11 = (treatment ==11  & dummy_last ==0)

gen treat_s3 = (treatment ==3 & dummy_last ==1)
gen treat_s4 = (treatment ==4 & dummy_last ==1)
gen treat_s5 = (treatment ==5  & dummy_last ==1)
gen treat_s6 = (treatment ==6  & dummy_last ==1)
gen treat_s7 = (treatment ==7   & dummy_last ==1)
gen treat_s8 = (treatment ==8   & dummy_last ==1)
gen treat_s9 = (treatment ==9   & dummy_last ==1)
gen treat_s10 = (treatment ==10 & dummy_last ==1)
gen treat_s11 = (treatment ==11  & dummy_last ==1)


meprobit perfectthres treat_f4 treat_f5 treat_f6 treat_f7 treat_f8 treat_f9 treat_f10 treat_f11 treat_s3 treat_s4 treat_s5 treat_s6 treat_s7 treat_s8 treat_s9 treat_s10 treat_s11 || id : , vce(cluster paper) intpoints(12)
test treat_s3 ==0 
test treat_s4 ==treat_f4
test treat_s5 ==treat_f5
test treat_s6 ==treat_f6
test treat_s7 ==treat_f7
test treat_s8 ==treat_f8
test treat_s9 ==treat_f9
test treat_s10 ==treat_f10
test treat_s11 ==treat_f11

meprobit perfectthres dummy_last || id : , vce(cluster paper) intpoints(12)


//ADD also information from the EFY experiment

         
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen mcoop = coop *ocoop
gen foo = (mcoop == 0 & coop_m1 == 1 & ocoop_m1 ==1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
replace foo = 1 if round ==1 & ocoop ==0
gen baz1 = foo * round
replace baz1 = length +1 if baz1 ==0
egen mfdef = min(baz1), by(id session match)
gen deviation =0
replace deviation =1 if (round >mfdef & coop ==1)
egen totdev = sum(deviation), by(id session match)
gen perfectthres = 0
replace perfectthres = 1 if totdev ==0
keep if round ==1
keep if match == 1 | lastmatch == 1
*collapse perfectthres lastmatch, by(match treatment)

table treatment lastmatch, c(mean perfectthres)
table lastmatch, c(mean perfectthres)


gen treat_f2 = (treat_2 ==1 & lastmatch ==0)
gen treat_f3 = (treat_3 ==1 & lastmatch ==0)
gen treat_f4 = (treat_4 ==1 & lastmatch ==0)
gen treat_l1 = (treat_1 ==1 & lastmatch ==1)
gen treat_l2 = (treat_2 ==1 & lastmatch ==1)
gen treat_l3 = (treat_3 ==1 & lastmatch ==1)
gen treat_l4 = (treat_4 ==1 & lastmatch ==1)


meprobit perfectthres treat_f2 treat_f3 treat_f4 treat_l1 treat_l2 treat_l3 treat_l4 || id : , vce(cluster session) intpoints(12)
test treat_l1 ==0 
test treat_l2 ==treat_f2
test treat_l3 ==treat_f3  
test treat_l4 ==treat_f4    

meprobit perfectthres lastmatch || id : , vce(cluster session)  intpoints(12)
	   
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//EXPERIMENT ONLINE APPENDIX	
//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE A6: Session Characteristics

use "$data/stata/efy_dat_exp_1.dta", replace
* gerenate a subject average payoff for the end of the session
keep if lastmatch ==1 & round ==length

** creates table with earnings summary statistics
table horizon, by(stage_game) c(count id mean totalprofit min totalprofit max totalprofit mean totalprofit) replace


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE A7: Cooperation Rates and Mean Round to First Defection

clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if match ==1 | match ==30
table treatment, by(match) c(mean coop) replace

clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if match ==1 | match ==30
keep if round ==1
table treatment, by(match) c(mean coop) replace

clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if match ==1 | match ==30
keep if round ==length
table treatment, by(match) c(mean coop) replace

clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if match ==1 | match ==30
keep if round ==1
table treatment, by(match) c(mean first_defect) replace



//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//TABLE A8: Pair-Wise Comparison of Measures of Cooperation Across Treatments.

clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen secondhalf = 0
replace secondhalf = 1  if match > 15
gen foo = treatment
drop treatment
gen treatment = 1*treat_1 + 2*treat_2 + 3*treat_3 + 4*treat_4

gen treat_f2 = (treat_2 ==1 & secondhalf ==0)
gen treat_f3 = (treat_3 ==1 & secondhalf ==0)
gen treat_f4 = (treat_4 ==1 & secondhalf ==0)
gen treat_s1 = (treat_1 ==1 & secondhalf ==1)
gen treat_s2 = (treat_2 ==1 & secondhalf ==1)
gen treat_s3 = (treat_3 ==1 & secondhalf ==1)
gen treat_s4 = (treat_4 ==1 & secondhalf ==1)


*all rounds
meprobit coop treat_f2 treat_f3 treat_f4 if secondhalf ==0 || id : , vce(cluster session) intpoints(12)

test treat_f2 == 0
test treat_f3 == 0
test treat_f4 == 0
test treat_f2 == treat_f3
test treat_f2 == treat_f4
test treat_f3 == treat_f4


meprobit coop treat_s2 treat_s3 treat_s4 if secondhalf ==1 || id : , vce(cluster session) intpoints(12)

test treat_s2 == 0
test treat_s3 == 0
test treat_s4 == 0
test treat_s2 == treat_s3
test treat_s2 == treat_s4
test treat_s3 == treat_s4



*round 1
meprobit coop treat_f2 treat_f3 treat_f4 if round ==1 & secondhalf ==0 || id : , vce(cluster session) intpoints(12)

test treat_f2 == 0
test treat_f3 == 0
test treat_f4 == 0
test treat_f2 == treat_f3
test treat_f2 == treat_f4
test treat_f3 == treat_f4


meprobit coop treat_s2 treat_s3 treat_s4 if round ==1 & secondhalf ==1 || id : , vce(cluster session) intpoints(12)

test treat_s2 == 0
test treat_s3 == 0
test treat_s4 == 0
test treat_s2 == treat_s3
test treat_s2 == treat_s4
test treat_s3 == treat_s4


*fdef
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen fdef = first_defect
gen secondhalf = 0
replace secondhalf = 1  if match > 15
gen foo = treatment
drop treatment
gen treatment = 1*treat_1 + 2*treat_2 + 3*treat_3 + 4*treat_4

gen treat_f2 = (treat_2 ==1 & secondhalf ==0)
gen treat_f3 = (treat_3 ==1 & secondhalf ==0)
gen treat_f4 = (treat_4 ==1 & secondhalf ==0)
gen treat_s1 = (treat_1 ==1 & secondhalf ==1)
gen treat_s2 = (treat_2 ==1 & secondhalf ==1)
gen treat_s3 = (treat_3 ==1 & secondhalf ==1)
gen treat_s4 = (treat_4 ==1 & secondhalf ==1)

xtreg fdef treat_f2 treat_f3 treat_f4 if round ==1 & secondhalf ==0, i(id) cluster(session)
test treat_f2 == 0
test treat_f3 == 0
test treat_f4 == 0
test treat_f2 == treat_f3
test treat_f2 == treat_f4
test treat_f3 == treat_f4

xtreg fdef treat_s2 treat_s3 treat_s4 if round ==1 & secondhalf ==1, i(id) cluster(session)
test treat_s2 == 0
test treat_s3 == 0
test treat_s4 == 0
test treat_s2 == treat_s3
test treat_s2 == treat_s4
test treat_s3 == treat_s4


//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE A5: Cooperation Rate by Round

clear
use "$data/stata/efy_dat_exp_1.dta", replace

keep if treatment ==11 //11 is for E8

collapse coop, by(round match)

tw line coop match if round == 1, connect(l) msymbol(o) lpattern(solid) ///
 || line coop match if round ==2, connect(l) msymbol(Oh) lpattern(dash) ///
 || line coop match if round ==3, connect(l) msymbol(X) lpattern(longdash_dot) ///
 || line coop match if round ==4, connect(l) msymbol(X) lpattern(dot) ///
 || line coop match if round ==5, connect(l) msymbol(X) lpattern(dash_dot) ///
 || line coop match if round ==6, connect(l) msymbol(X) lpattern(shortdash) ///
 || line coop match if round ==7, connect(l) msymbol(X) lpattern(longdash) ///
 || line coop match if round ==8, connect(l) msymbol(X) lpattern(shortdash_dot) ///
 xlabel(0(5)30) ylabel(0(0.2)1) ytitle("Cooperation Rate") xtitle("Supergame") ///
 legend(lab(1 Round 1) lab(2 Round 2) lab(3 Round 3) lab(4 Round 4) lab(5 Round 5) lab(6 Round 6) lab(7 Round 7) lab(8 Round 8) size(small) rows(2)) ///
 graphregion(color(white)) bgcolor(white) scheme(s2mono) plotregion(fcolor(white)) ///
 title("") subtitle("Treatment E8") ///
   saving("$figFolder/coop_byround_e8", replace) 
   

graph export "$figFolder/coop_byround_e8_allrounds.eps" , as(eps) preview(off) replace
graph export "$figFolder/coop_byround_e8_allrounds.pdf", replace

//////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////	

//FIGURE A6: (LHS) Mean round to first defection: all pairs versus those that cooperated in round 1; (RHS) Probability of breakdown in cooperation



*fdef conditional on couples that cooperated in round 1
clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round ==1
gen mcoop = coop*ocoop
keep if treatment ==1 //1 is for D8
egen mcooprate = mean(mcoop), by(match)
collapse first_defect, by(match mcoop mcooprate)
reshape wide first_defect, i(match mcooprate) j(mcoop)
gen fdeftotal = (1-mcooprate)*first_defect0 + (mcooprate)*first_defect1

twoway ( connected fdeftotal match, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected first_defect1 match , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Round") yscale(range(2 8)) ylabel(2(1)8) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(1(5)30) title("First defection") ///
	legend( order(1 2) label(1 "All") label(2 "Round 1 = (C,C)") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono) ////
		saving("$figFolder/exp_condfdef" , replace)

*breakdown
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen fdef = first_defect
keep if round ==1
keep if treatment ==1 //1 is for D8
gen mcat = 3
replace mcat =2 if match <21
replace mcat = 1 if match <11 
gen mcoop = coop*ocoop
*keep if mcoop ==1
egen bd = sum(round), by(mcat fdef treatment)
egen ts = sum(round), by(mcat treatment)
gen pbreakdown = bd/ts
collapse pbreakdown, by(mcat fdef treatment)
*drop if fdef ==9
twoway (connected pbreakdown fdef if mcat ==1, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
  || ( connected pbreakdown fdef if mcat ==2, sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh)  ) ///
  || ( connected pbreakdown fdef if mcat ==3, sort lstyle(p5) lpattern(longdash_dot) mstyle(p5) msymbol(sh) ) ///
   ,xlabel(1(1)9) ylabel(0(0.1)0.4) ytitle("Probability") xtitle(Round) ///
   legend(lab(1 SG:1-10) lab(2 SG:11-20) lab(3 SG:21-30)  size(2.1) rows(1)) ///
    bgcolor(white)  scheme(s2mono) graphregion(color(white)) title("Breakdown of cooperation")  ///
    plotregion(fcolo(white)) ///
    saving("$figFolder/exp_bd8", replace)
   
graph combine "$figFolder/exp_condfdef" "$figFolder/exp_bd8", graphregion(color(white)) title("Treatment D8") note("Note: SG stands for supergame.") saving("$figFolder\d8", replace)
graph export "$figFolder/exp:d8.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:d8.pdf", replace




***********D4
clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round ==1
gen mcoop = coop*ocoop
keep if treatment ==0 //0 is for D4
egen mcooprate = mean(mcoop), by(match)
collapse first_defect, by(match mcoop mcooprate)
reshape wide first_defect, i(match mcooprate) j(mcoop)
gen fdeftotal = (1-mcooprate)*first_defect0 + (mcooprate)*first_defect1

twoway ( connected fdeftotal match, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected first_defect1 match , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Round") yscale(range(1 5)) ylabel(1(1)5) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(1(5)30) title("First defection") ///
	legend( order(1 2) label(1 "All") label(2 "Round 1 = (C,C)") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono) ////
		saving("$figFolder/exp_condfdef" , replace)


*breakdown
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen fdef = first_defect
keep if round ==1
keep if treatment ==0 //0 is for D4
gen mcat = 3
replace mcat =2 if match <21
replace mcat = 1 if match <11 
gen mcoop = coop*ocoop
*keep if mcoop ==1
egen bd = sum(round), by(mcat fdef treatment)
egen ts = sum(round), by(mcat treatment)
gen pbreakdown = bd/ts
collapse pbreakdown, by(mcat fdef treatment)
*drop if fdef ==9
twoway (connected pbreakdown fdef if mcat ==1, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
  || ( connected pbreakdown fdef if mcat ==2, sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh)  ) ///
  || ( connected pbreakdown fdef if mcat ==3, sort lstyle(p5) lpattern(longdash_dot) mstyle(p5) msymbol(sh) ) ///
   ,xlabel(1(1)5) ylabel(0(0.2)0.8) ytitle("Probability") xtitle(Round) ///
   legend(lab(1 SG:1-10) lab(2 SG:11-20) lab(3 SG:21-30)  size(2.1) rows(1)) ///
    bgcolor(white)  scheme(s2mono) graphregion(color(white)) title("Breakdown of cooperation")  ///
    plotregion(fcolo(white)) ///
    saving("$figFolder/exp_bd", replace)

graph combine "$figFolder/exp_condfdef" "$figFolder/exp_bd", graphregion(color(white)) title("Treatment D4") note("Note: SG stands for supergame.")  saving("$figFolder\d8", replace)
graph export "$figFolder/exp:d4.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:d4.pdf", replace


***********E4
clear
use "$data/stata/efy_dat_exp_1.dta", replace
keep if round ==1
gen mcoop = coop*ocoop
keep if treatment ==10 //0 is for D4
egen mcooprate = mean(mcoop), by(match)
collapse first_defect, by(match mcoop mcooprate)
reshape wide first_defect, i(match mcooprate) j(mcoop)
gen fdeftotal = (1-mcooprate)*first_defect0 + (mcooprate)*first_defect1

twoway ( connected fdeftotal match, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
	|| ( connected first_defect1 match , sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh) ) ///
	, ytitle("Round") yscale(range(1 5)) ylabel(1(1)5) ///
	xtitle("Supergame") xscale( range(0 20) ) xlabel(1(5)30) title("First defection") ///
	legend( order(1 2) label(1 "All") label(2 "Round 1 = (C,C)") cols(2) ) /// 
		graphregion(color(white)) bgcolor(white) scheme(s2mono) ////
		saving("$figFolder/exp_condfdef" , replace)


*breakdown
clear
use "$data/stata/efy_dat_exp_1.dta", replace
gen fdef = first_defect
keep if round ==1
keep if treatment ==10 //0 is for D4
gen mcat = 3
replace mcat =2 if match <21
replace mcat = 1 if match <11 
gen mcoop = coop*ocoop
*keep if mcoop ==1
egen bd = sum(round), by(mcat fdef treatment)
egen ts = sum(round), by(mcat treatment)
gen pbreakdown = bd/ts
collapse pbreakdown, by(mcat fdef treatment)
*drop if fdef ==9
twoway (connected pbreakdown fdef if mcat ==1, sort lstyle(p2) lpattern(solid) mstyle(p2) msymbol(o) ) ///
  || ( connected pbreakdown fdef if mcat ==2, sort lstyle(p5) lpattern(shortdash) mstyle(p5) msymbol(sh)  ) ///
  || ( connected pbreakdown fdef if mcat ==3, sort lstyle(p5) lpattern(longdash_dot) mstyle(p5) msymbol(sh) ) ///
   ,xlabel(1(1)5) ylabel(0(0.2)0.8) ytitle("Probability") xtitle(Round) ///
   legend(lab(1 SG:1-10) lab(2 SG:11-20) lab(3 SG:21-30)  size(2.1) rows(1)) ///
    bgcolor(white)  scheme(s2mono) graphregion(color(white)) title("Breakdown of cooperation")  ///
    plotregion(fcolo(white)) ///
    saving("$figFolder/exp_bd", replace)

graph combine "$figFolder/exp_condfdef" "$figFolder/exp_bd", graphregion(color(white)) title("Treatment E4") note("Note: SG stands for supergame.") saving("$figFolder\d8", replace)
graph export "$figFolder/exp:e4.eps" , as(eps) preview(off) replace
graph export "$figFolder/exp:e4.pdf", replace



log close
  

      
