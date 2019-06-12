
****************

*Most coefficients in tables off by a little bit, some major errors (date entered instead of date fixed effects, missing certain dummies so that
*mean treatment effect is actually a dummy for a participant characteristic)

****************

*Paper's prep code (using file provided by Pascaline Dupas with baseline mark)

use student_test_data_withbaseline.dta, clear
drop _merge
gen etpteacher_tracking_lowstream=etpteacher*lowstream
gen sbm_tracking_lowstream=sbm*tracking*lowstream
foreach name in bottomhalf tophalf etpteacher  {
	gen `name'_tracking=`name'*tracking
	}
gen percentilesq=percentile*percentile
gen percentilecub=percentile^3
replace agetest=r2_age-1 if agetest==.

foreach X in litscore mathscoreraw totalscore letterscore wordscore sentscore spellscore additions_score substractions_score multiplications_score { 
	sum `X' if tracking==0 
	gen meancomp=r(mean) 
	gen sdcomp=r(sd) 
	gen stdR_`X'=(`X'-meancomp)/sdcomp 
	drop meancomp sdcomp
	}
save forpeerpapers, replace


*Table 2

use forpeerpapers, clear
gen girl_tracking=girl*tracking
foreach name in bottom second third top{
	gen `name'quarter_tracking=`name'quarter*tracking
	}
foreach var in stdR_totalscore {
	reg `var' tracking, cluster(schoolid)
	reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomhalf bottomhalf_tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomquarter bottomquarter_tracking secondquarter secondquarter_tracking topquarter topquarter_tracking girl percentile agetest etpteacher, cluster(schoolid)
	}
foreach var in stdR_mathscore stdR_litscore {
	reg `var' tracking bottomhalf bottomhalf_tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomquarter bottomquarter_tracking secondquarter secondquarter_tracking topquarter topquarter_tracking girl percentile agetest etpteacher, cluster(schoolid)
	}

foreach X in litscore mathscoreraw totalscore {
	sum r2_`X' if tracking==0 
	gen meancomp=r(mean) 
	gen sdcomp=r(sd) 
	gen stdR_r2_`X'=(r2_`X'-meancomp)/sdcomp 
	drop meancomp sdcomp
	}
foreach var in stdR_r2_totalscore {
	reg `var' tracking, cluster(schoolid)
	reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomhalf bottomhalf_tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomquarter bottomquarter_tracking secondquarter secondquarter_tracking topquarter topquarter_tracking girl percentile agetest etpteacher, cluster(schoolid)
	}
foreach var in stdR_r2_mathscore stdR_r2_litscore {
	reg `var' tracking bottomhalf bottomhalf_tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomquarter bottomquarter_tracking secondquarter secondquarter_tracking topquarter topquarter_tracking girl percentile agetest etpteacher, cluster(schoolid)
	}


*Table 3

use forpeerpapers, clear
gen topage=1 if agetest>9&agetest!=.
replace topage=0 if agetest<9
foreach X in totalscore { 
	sum r2_`X' if tracking==0 
	gen meancomp=r(mean) 
	gen sdcomp=r(sd) 
	gen stdR_r2_`X'=(r2_`X'-meancomp)/sdcomp 
	drop meancomp sdcomp
	}
gen cont=etpteacher

foreach cat in girl cont topage {
	foreach half in bottomhalf tophalf {
		gen `cat'_`half'=`cat'*`half'
		gen `cat'_tracking_`half'=`cat'*`half'_tracking
		gen anti`cat'_tracking_`half'=(1-`cat')*`half'_tracking
		}
	reg stdR_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	reg stdR_r2_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	}
*The last regression (topage) is actually missing a dummy for topage, in other words need `cat', `cat'_bottomhalf and bottomhalf in each regression (implicitly missing `cat' in the agetest regression)
*However, this is what they ran
*This last regression cannot be analysed for no effect of treatment, because even if treatment effect = 0 the tracking dummies will
*pick up the effect of someone who is ~bottomhalf and of different `cat' (i.e. tophalf) in the coefficients for `cat'_tracking_tophalf and anti`cat'_tracking_tophalf even if no treatment effect
*In other words, the tracking coefficients are not the effect of treatment and cannot be so unless an additional regressor is added (= `cat' = topage)


*Table 4

use forpeerpapers, clear
keep if tracking==0
egen section=group(schoolid stream)

areg stdR_totalscore rMEANstream_std_baselinemark  std_mark girl agetest etpteacher, absorb(schoolid) cluster(section)
areg stdR_mathscore rMEANstream_std_baselinemark std_mark girl agetest etpteacher, absorb(schoolid) cluster(section)
areg stdR_litscore  rMEANstream_std_baselinemark std_mark girl agetest etpteacher, absorb(schoolid) cluster(section)
areg stdR_totalscore rMEANstream_std_baselinemark std_mark girl agetest etpteacher, absorb(schoolid) cluster(section), if std_mark>=-0.75&std_mark<=0.75
areg stdR_totalscore rMEANstream_std_baselinemark std_mark girl agetest etpteacher, absorb(schoolid) cluster(section), if std_mark<-0.275
areg stdR_totalscore rMEANstream_std_baselinemark std_mark girl agetest etpteacher, absorb(schoolid) cluster(section), if std_mark>0.75
*Note std_mark < -.275 above is an error in the do file code

*first stages
*These are not actually the first stages, as missing std_mark girl agetest variables, but this is what is in the do file and the results are reported in the table
xi: xtreg  rMEANstream_std_total  rMEANstream_std_baselinemark etpteacher,fe i(schoolid)
xi: xtreg  rMEANstream_std_math  rMEANstream_std_baselinemark etpteacher,fe i(schoolid)
xi: xtreg  rMEANstream_std_lit  rMEANstream_std_baselinemark etpteacher,fe i(schoolid)
xi: xtreg  rMEANstream_std_total  rMEANstream_std_baselinemark etpteacher,fe i(schoolid), if std_mark>=-0.75&std_mark<=0.25
xi: xtreg  rMEANstream_std_total  rMEANstream_std_baselinemark etpteacher,fe i(schoolid), if std_mark<-0.75
xi: xtreg  rMEANstream_std_total  rMEANstream_std_baselinemark etpteacher,fe i(schoolid), if std_mark>0.75
*Note that std_mark <= 0.25 above is an error in the do file code
   
*second-stage
xi: ivreg stdR_totalscore (rMEANstream_std_total= rMEANstream_std_baselinemark) std_mark etpteacher girl agetest i.schoolid, cluster(section) 
xi: ivreg stdR_mathscore (rMEANstream_std_math = rMEANstream_std_baselinemark) std_mark etpteacher girl agetest i.schoolid, cluster(section) 
xi: ivreg stdR_litscore ( rMEANstream_std_lit = rMEANstream_std_baselinemark) std_mark etpteacher girl agetest i.schoolid, cluster(section) 
xi: ivreg stdR_totalscore (rMEANstream_std_total = rMEANstream_std_baselinemark) std_mark etpteacher girl agetest i.schoolid, cluster(section), if std_mark>=-0.75&std_mark<=0.75
xi: ivreg stdR_totalscore (rMEANstream_std_total = rMEANstream_std_baselinemark) std_mark etpteacher girl agetest i.schoolid, cluster(section), if std_mark<-0.75
xi: ivreg stdR_totalscore (rMEANstream_std_total = rMEANstream_std_baselinemark) std_mark etpteacher girl agetest i.schoolid, cluster(section), if std_mark>0.75



  
*Table 5 - Nothing to randomize, tracking schools alone, in which students were assigned by test scores 

use forpeerpapers, clear
keep if tracking==1
reg stdR_totalscore bottomhalf percentile percentilesq percentilecu etpteacher girl agetest, cluster(schoolid) 

foreach subject in total {

*specification 1, no FE
	use forpeerpapers, clear
	keep if tracking==1
	reg stdR_`subject'score bottomhalf percentile percentilesq percentilecub etpteacher girl agetest, cluster(schoolid) 

* specification 4, no FE
	drop if stdR_`subject'score==.
	egen topkid=max(std_mark), by(schoolid bottomhalf)
	egen botkid=min(std_mark), by(schoolid bottomhalf)
	keep if (std_mark==topkid&bottomhalf==1)|(std_mark==botkid&bottomhalf==0)
	reg stdR_`subject'score bottomhalf etpteacher girl agetest  std_mark, cluster(schoolid) 

*specification 1, with FE
	use forpeerpapers, clear
	keep if tracking==1
	areg stdR_`subject'score bottomhalf percentile percentilesq percentilecub etpteacher girl agetest, absorb(schoolid)

* specification 4, with FE
	drop if stdR_`subject'score==.
	egen topkid=max(std_mark), by(schoolid bottomhalf)
	egen botkid=min(std_mark), by(schoolid bottomhalf)
	keep if (std_mark==topkid&bottomhalf==1)|(std_mark==botkid&bottomhalf==0)
	areg stdR_`subject'score bottomhalf etpteacher girl agetest std_mark, absorb(schoolid) 
	}

*specification 2

cap program drop rdquad
program define rdquad, eclass
	args score percentile percentilesq  bottomhalf etpteacher girl agetest
	gen bottom_percentile=`bottomhalf'*percentile
	gen bottom_percentilesq=`bottomhalf'*percentilesq
	reg `score' `percentile' `percentilesq'  bottom_percentile bottom_percentilesq `bottomhalf' `etpteacher' `girl' `agetest'
	gen pred_top=_b[_cons]+_b[`percentile']*50+_b[`percentilesq']*50*50
	gen pred_bot=_b[_cons]+_b[`percentile']*50+_b[`percentilesq']*50*50+_b[`bottomhalf']+_b[bottom_percentile]*50+_b[bottom_percentilesq]*50*50
	gen diff=pred_bot-pred_top
	ereturn scalar diff=diff
	drop pred_top pred_bot diff bottom_percentile*
end

cap program drop rdquadfe
program define rdquadfe, eclass
	args score percentile percentilesq  bottomhalf etpteacher  girl agetest schoolid
	gen bottom_percentile=`bottomhalf'*percentile
	gen bottom_percentilesq=`bottomhalf'*percentilesq
	xtreg `score' `percentile' `percentilesq'  bottom_percentile bottom_percentilesq `bottomhalf' `etpteacher' `girl' `agetest' , fe i(`schoolid')
	gen pred_top=_b[_cons]+_b[`percentile']*50+_b[`percentilesq']*50*50
	gen pred_bot=_b[_cons]+_b[`percentile']*50+_b[`percentilesq']*50*50+_b[`bottomhalf']+_b[bottom_percentile]*50+_b[bottom_percentilesq]*50*50
	gen diff=pred_bot-pred_top
	ereturn scalar diff=diff
	drop pred_top pred_bot diff bottom_percentile*
end

use forpeerpapers, clear
keep if tracking==1
bootstrap e(diff), reps(1000): rdquad  stdR_totalscore percentile percentilesq  bottomhalf etpteacher girl agetest , cluster(schoolid)
bootstrap e(diff), reps(1000): rdquadfe  stdR_totalscore percentile percentilesq bottomhalf etpteacher girl agetest schoolid


*specification 3

cap program drop lowrex
program def lowrex
	local ic=1
	gen `3'=.
	gen `4'=.
	gen `7'=.
	while `ic' <= $gsize {
		dis `ic'
		quietly {
			local xx=`6'[`ic']
			gen z=abs((`2'-`xx')/`5')
			gen kz=(15/16)*(1-z^2)^2 if z <= 1
			reg `1' `2' [pweight=kz] if kz ~= .
			replace `4'=_b[`2'] in `ic'
			replace `3'=_b[_cons]+_b[`2']*`xx' in `ic'
			reg `1' [pweight=kz] if kz ~= .
			replace `7'=_b[_cons] in `ic'
			drop z kz
			}
		local ic=`ic'+1
		}
end 


cap program drop RDfan
program define RDfan, eclass
	args stdR_totalscore tracking bottomhalf realpercentile band1 band2 
	preserve
	global band1 `band1'
	global band2 `band2'
	gen stdR_totalscore_top=`stdR_totalscore' if `tracking'==1&`bottomhalf'==0
	gen stdR_totalscore_bot=`stdR_totalscore' if `tracking'==1&`bottomhalf'==1
	global xmin_top=1
	global xmax_top=50
	global xmin_bot=51
	global xmax_bot=99
	global gsize=100
	global st_top=($xmax_top-$xmin_top)/($gsize-1)
	global st_bot=($xmax_bot-$xmin_bot)/($gsize-1)
	gen xgrid_top=$xmin_top+(_n-1)*$st_top in 1/$gsize
	gen xgrid_bot=$xmin_bot+(_n-1)*$st_bot in 1/$gsize
	sort xgrid_bot
	lowrex stdR_totalscore_bot `realpercentile' pred_bot${band1} dsmth `band1' xgrid_top mean
	drop dsmth mean
	sort xgrid_top
	lowrex stdR_totalscore_top `realpercentile' pred_top${band1} dsmth `band1' xgrid_bot mean
	drop dsmth mean
	sort xgrid_bot
	lowrex stdR_totalscore_bot `realpercentile' pred_bot${band2} dsmth `band2' xgrid_top mean
	drop dsmth mean
	sort xgrid_top
	lowrex stdR_totalscore_top `realpercentile' pred_top${band2} dsmth `band2' xgrid_bot mean
	drop dsmth mean
	sort xgrid_top xgrid_bot
	keep in 1/100
	local gap${band1}=pred_bot${band1}[99]-pred_top${band1}[2]
	local gap${band2}=pred_bot${band2}[99]-pred_top${band2}[2]
	ereturn scalar Fangap${band1}=`gap${band1}'
	ereturn scalar Fangap${band2}=`gap${band2}'
	drop xgrid_top xgrid_bot stdR_totalscore_* pred*
	restore
end

*Original code above: drop xgrid_top xgrid_bot std_totalscore* pred* (fails in execution)

use forpeerpapers, clear
keep if tracking==1
bootstrap e(Fangap4) e(Fangap5), reps(100): RDfan stdR_totalscore tracking bottomhalf realpercentile 4 5


*Panels B & C
*First stage regressions are actually not the same sample as the ivregs
foreach subject in total {
* specification 1, no FE;
	use forpeerpapers, clear
	keep if tracking==1
	reg  rMEANstream_std_`subject' bottomhalf percentile percentilesq percentilecub etpteacher girl agetest, cluster(schoolid)
	reg stdR_`subject'score  rMEANstream_std_`subject' percentile percentilesq percentilecub etpteacher girl agetest (bottomhalf percentile percentilesq percentilecub etpteacher girl agetest ), cluster(schoolid) 

* specification 4, no FE; 
	drop if stdR_`subject'score==.
	egen topkid=max(std_mark), by(schoolid bottomhalf)
	egen botkid=min(std_mark), by(schoolid bottomhalf)
	keep if (std_mark==topkid&bottomhalf==1)|(std_mark==botkid&bottomhalf==0)
	reg  rMEANstream_std_`subject' bottomhalf  etpteacher girl agetest, cluster(schoolid)
	reg stdR_`subject'score  rMEANstream_std_`subject' etpteacher girl agetest (bottomhalf  etpteacher girl agetest ), cluster(schoolid) 

* specification 1, with FE;
	use forpeerpapers, clear
	keep if tracking==1

	xtreg  rMEANstream_std_`subject' bottomhalf percentile percentilesq percentilecub etpteacher girl agetest, fe i(schoolid) cluster(schoolid)
	xi: ivreg stdR_`subject'score  percentile percentilesq percentilecub etpteacher girl agetest ( rMEANstream_std_`subject'=bottomhalf) i.schoolid, cluster(schoolid)

* specification 4, with FE;
	drop if stdR_`subject'score==.
	egen topkid=max(std_mark), by(schoolid bottomhalf)
	egen botkid=min(std_mark), by(schoolid bottomhalf)
	keep if (std_mark==topkid&bottomhalf==1)|(std_mark==botkid&bottomhalf==0)
	xtreg  rMEANstream_std_`subject' bottomhalf  etpteacher girl agetest, fe i(schoolid) cluster(schoolid)
	xi: ivreg stdR_`subject'score etpteacher girl agetest ( rMEANstream_std_`subject'=bottomhalf) i.schoolid, cluster(schoolid)
}



*Table 6
*Says includes test date dummies, but actually just enters test date
*In these regressions use full 140 school sample data (no longer restrict to 121 school sample)
*Not possible to examine randomization distributrion because "lowstream" regressor is tracking * lowstream, but no lowstream for nontracking schools (i.e. teachers were not assigned to a lowstream/highstream section)

use teacher_pres_data, replace
global indepvar5="tracking lowstream  yrstaught female bungoma visitno realdate"
xi: reg pres ${indepvar5}, cluster(schoolid)
xi: reg inclass ${indepvar5}, cluster(schoolid)
xi: reg pres ${indepvar5}, cluster(schoolid), if etpteacher==0
xi: reg inclass ${indepvar5}, cluster(schoolid), if etpteacher==0
xi: reg pres ${indepvar5}, cluster(schoolid), if etpteacher==1
xi: reg inclass ${indepvar5}, cluster(schoolid), if etpteacher==1

use student_pres_data, clear
gen etpteacher_tracking=etpteacher*tracking
gen bottomhalf_tracking=bottomhalf*tracking
global indepvar1="tracking bottomhalf_tracking bottomhalf girl etpteacher etpteacher_tracking bungoma realdate"
xi: reg pres ${indepvar1}, cluster(schoolid)


*Table 7

use forpeerpapers, clear
drop if attrition==1
egen diff1_score=rsum(a1_correct a2_correct)
egen diff2_score=rsum(a3_correct a4_correct a5_correct)
replace diff2_score=diff2_score/9*6
egen diff3_score=rsum(a6_correct a7_correct)
reg diff1_score  bottomhalf tracking bottomhalf_tracking  agetest girl, cluster(schoolid)
foreach var in diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24  {
	reg `var' bottomhalf tracking bottomhalf_tracking  agetest girl , cluster(schoolid)
	}



*****************************************
*****************************************

*Randomization analysis

*Begin by getting treatment vector (randomization was done across full 140 school sample, although only 121 schools used in some tables)

*File provided by Pascaline Dupas that allows me to calculate strata
use ETPSampling, clear
keep if sampleETP=="T"
keep kcpe enrol1 district schoolid
egen Strata = group(kcpe enrol1 district), label
sort schoolid 
keep Strata schoolid
save aa, replace

use teacher_pres_data, clear
collapse (mean) tracking, by(schoolid)
merge schoolid using aa
tab _m
drop _m
tab Strata tracking
sort Strata tracking schoolid
mkmat Strata tracking schoolid, matrix(Y)
global N = 140

sort schoolid tracking
save Strata, replace


****************************


*Part 1: Tables 2 & 3 (assignment of tracking or nontracking status at school level)

use forpeerpapers, clear
foreach name in bottom second top {
	gen `name'quarter_tracking=`name'quarter*tracking
	}
foreach X in litscore mathscoreraw totalscore {
	sum r2_`X' if tracking==0 
	gen stdR_r2_`X'=(r2_`X'-r(mean))/r(sd)
	}
gen topage=1 if agetest>9&agetest!=.
replace topage=0 if agetest<9
gen cont=etpteacher
foreach cat in girl cont {
	foreach half in bottomhalf tophalf {
		gen `cat'_`half'=`cat'*`half'
		gen `cat'_tracking_`half'=`cat'*`half'_tracking
		gen anti`cat'_tracking_`half'=(1-`cat')*`half'_tracking
		}
	}

*Table 2 (reordered a bit to fit in fewer loops)
foreach var in stdR_totalscore stdR_r2_totalscore {
	reg `var' tracking, cluster(schoolid)
	reg `var' tracking girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}

foreach var in stdR_mathscore stdR_litscore stdR_r2_mathscore stdR_r2_litscore {
	reg `var' tracking bottomhalf_tracking bottomhalf girl percentile agetest etpteacher, cluster(schoolid)
	reg `var' tracking bottomquarter_tracking secondquarter_tracking topquarter_tracking bottomquarter secondquarter topquarter girl percentile agetest etpteacher, cluster(schoolid)
	}

*Table 3
foreach cat in girl cont {
	reg stdR_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	reg stdR_r2_totalscore `cat'_tracking_bottomhalf anti`cat'_tracking_bottomhalf  `cat'_tracking_tophalf anti`cat'_tracking_tophalf bottomhalf `cat'_bottomhalf percentile girl agetest etpteacher, cluster(schoolid)
	}

svmat double Y
save DatDDK1, replace


************************

*Part 2:  Random assignment to sections in non-tracking schools

*Table 4


*My prep code for Table 4 - will need this to recalculate rMEAN after each randomization

*First, get sample for Table 4

use forpeerpapers, clear
keep if tracking==0
drop if std_mark == .
sort schoolid
drop if schoolid == schoolid[_n-1]
keep schoolid
sort schoolid
save abc, replace

*Using file provided by Pascaline Dupas with the extra observations used to calculate rMEAN

use etptests_all, clear
bys schoolid: egen markcount=count(baselinemark)
drop if markcount==0
drop if etpschool==0
keep if baseline==1
keep if tracking == 0
keep if stream!=""
sort schoolid
merge schoolid using abc
keep if _m == 3
keep baselinemark schoolid pupilid stream etpteacher

gen RR =.
gen baselinemarki = baselinemark

bysort schoolid:  gen NN = _n
quietly sum NN
global NN = r(max)
forvalues i = 1/$NN {
	quietly replace baselinemarki=. if NN==`i'
	quietly egen A`i'=mean(baselinemarki), by(schoolid)
	quietly egen B`i'=sd(baselinemarki), by(schoolid)
	quietly gen C`i'=(baselinemarki-A`i')/B`i'
	quietly replace baselinemarki=baselinemark if NN==`i'
	}

forvalues i = 1/$NN {
	quietly egen ra=mean(C`i'),by(schoolid stream)
	quietly replace RR=ra if NN==`i'
	drop ra
	}
drop A* B*
sort pupilid etpteacher
save ForTable4, replace

***********************

*Table 4

use forpeerpapers, clear
keep if tracking==0
egen section=group(schoolid stream)
drop if std_mark == .
*most of these in sections for which no info, 27 in sections with info, but rMEANstream was calculated without them
sort pupilid etpteacher
merge pupilid etpteacher using ForTable4
tab _m
sum RR rMEANstream_std_baselinemark if rMEANstream_std_baselinemark ~= .
drop _m
quietly sum NN
global NN = r(max)

foreach var in stdR_totalscore stdR_mathscore stdR_litscore {
	areg `var' rMEANstream_std_baselinemark etpteacher std_mark girl agetest, absorb(schoolid) cluster(section)
	}

foreach spec in "std_mark>=-0.75&std_mark<=0.75" "std_mark<-0.275" "std_mark>0.75" {
	areg stdR_totalscore rMEANstream_std_baselinemark etpteacher std_mark girl agetest if `spec', absorb(schoolid) cluster(section)
	}

*intent to treat on ivregs reproduces other regressions

save DatDDK2, replace


***********************************


*Part 3:  Table 7

use forpeerpapers, clear
drop if attrition==1
egen diff1_score=rsum(a1_correct a2_correct)
egen diff2_score=rsum(a3_correct a4_correct a5_correct)
replace diff2_score=diff2_score/9*6
egen diff3_score=rsum(a6_correct a7_correct)

foreach var in diff1_score diff2_score diff3_score letterscore24  wordscore spellscore24  sentscore24 {
	reg `var' bottomhalf tracking bottomhalf_tracking agetest girl , cluster(schoolid)
	}

svmat double Y
save DatDDK3, replace

use teacher_pres_data, clear
collapse (mean) tracking, by(schoolid)
keep schoolid
gen N = _n
save SampleDDK, replace























