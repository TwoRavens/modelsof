
clear all

global dataDir "../1-datasets"

// Macros for background color
global bg "graphregion(color(white)) bgcolor(white)"
global st "subtitle(,bcolor(white))"
global lg "legend(region(lcolor(white)))"

global maxsim_own="max_phash_own"
global maxsim_oth="max_phash_oth"
global bstmaxsim_own="bst_max_phash_own"
global bstmaxsim_oth="bst_max_phash_oth"
global plcbstmaxsim="plc_bst_max_phash"
global batchsim="batchsim_p_intra"

global cutoffHi=0.7 // Threshold above which imitation occurs
global cutoffLo=0.3 // Threshold below which experimentation occurs

////////////////////////////////////////
// LOAD DATA, PREP ADD'L VARIABLES

use "$dataDir/dataset_main_phash.dta", clear

// Generate dropout variable
egen lastsuborder=max(suborder), ///
by(contestid playerid)
gen dropout=(suborder==lastsuborder)
label var dropout "Dropout"

// Create categories for originality
gen original=. // Initialize originality indicator
replace original=0 if $maxsim_own>$cutoffHi
replace original=1 if $maxsim_own<$cutoffLo
replace original=. if $maxsim_own==.
label define l_original 0 "Exploit" 1 "Explore"
label values original l_original

// Generate choice variable: 3-choice set
gen action=. // Initialize choice variable
replace action=1 if dropout==1
replace action=2 if dropout==0 & original==0
replace action=3 if dropout==0 & original==1
label define l_action 1 "Abandon" ///
2 "Exploit" 3 "Explore"
label values action l_action
gen explore=(action==2) if action!=.
label define l_explore ///
0 "Don't explore" 1 "Explore"
label values explore l_explore

// Generate best ratings on own
gen best_rating_own_5=(best_rating_own==5)
gen best_rating_own_4=(best_rating_own==4)
gen best_rating_own_3=(best_rating_own==3)
gen best_rating_own_2=(best_rating_own==2)
gen best_rating_own_1=(best_rating_own==1)

// Generate indicators for competition
gen c1=(obs_oth5s==1)
gen c2=(obs_oth5s==2)
gen c3=(obs_oth5s>3)

// Generate interaction terms
gen ia5c1=(best_rating_own_5)*c1
gen ia5c2=(best_rating_own_5)*c2
gen ia5c3=(best_rating_own_5)*c3

// Generate Pr(Win)
local cl5=exp(1.53)
local cl4=exp(-0.96)
local cl3=exp(-3.39)
local cl2=exp(-5.20)
local cl1=exp(-6.02)
local cl0=exp(-3.43)
gen prwin= ///
(obs_own5s*`cl5'+obs_own4s*`cl4'+ ///
obs_own3s*`cl3'+obs_own2s*`cl2'+ ///
obs_own1s*`cl1'+obs_own0s*`cl0')/ ///
(obs_own5s*`cl5'+obs_own4s*`cl4'+ ///
obs_own3s*`cl3'+obs_own2s*`cl2'+ ///
obs_own1s*`cl1'+obs_own0s*`cl0'+ ///
obs_oth5s*`cl5'+obs_oth4s*`cl4'+ ///
obs_oth3s*`cl3'+obs_oth2s*`cl2'+ ///
obs_oth1s*`cl1'+obs_oth0s*`cl0'+ ///
guaranteed)

// Generate controls
gen days_remaining=contest_length*(1-subtiming)
label var days_remaining "Days remaining"

// Specify controls
global ctrls="days_remaining own_prev oth_prev"

// Save to tempfile
tempfile base_data
save "`base_data'"

////////////////////////////////////////
// FIGURE 3

use "`base_data'", clear

forval a=1/3 {

  // Estimate choice model
  qui mlogit action prwin ///
  days_remaining subtiming, ///
  vce(robust) baseoutcome(1)

  // Predict probabilities (atmeans/asobserved)
  qui margins, at(prwin=(0(0.2)1) ///
  days_remaining=(0) subtiming=(1)) ///
  predict(outcome(`a')) post
  qui matrix b=r(b)
  qui matrix V=r(V)
  
  preserve
  
  quietly {

    clear

    set obs 6 // Start anew
    gen prwin=(_n-1)*0.2
    gen plotvar=.
    gen se=.
    gen cilb=.
    gen ciub=.

    replace plotvar=b[1,1] if _n==1
    replace plotvar=b[1,2] if _n==2
    replace plotvar=b[1,3] if _n==3
    replace plotvar=b[1,4] if _n==4
    replace plotvar=b[1,5] if _n==5
    replace plotvar=b[1,6] if _n==6

    replace se=sqrt(V[1,1]) if _n==1
    replace se=sqrt(V[2,2]) if _n==2
    replace se=sqrt(V[3,3]) if _n==3
    replace se=sqrt(V[4,4]) if _n==4
    replace se=sqrt(V[5,5]) if _n==5
    replace se=sqrt(V[6,6]) if _n==6

    replace cilb=plotvar+invnormal(0.025)*se
    replace ciub=plotvar+invnormal(0.975)*se
    
    if `a'==1 {
      serrbar plotvar se prwin, title("Panel C", color(black) size(huge)) ///
      subtitle("Abandon", color(black) size(vlarge)) scale(1.96) ///
      xtitle(" " "Win probability", size(vlarge)) ///
      xlabel(0(0.2)1.0,format(%9.1f) angle(horizontal)) xscale(reverse) ///
      ylabel(0(0.2)0.8,format(%9.1f) angle(horizontal)) yscale(range(0 0.8)) ///
      addplot(line plotvar prwin, lcolor(maroon) lpattern(dash)) legend(off) $bg ///
      saving("empiricalU_pt`a'.gph", replace)
    }
    else if `a'==2 {
      serrbar plotvar se prwin, title("Panel A", color(black) size(huge)) ///
      subtitle("Tweak", color(black) size(vlarge)) scale(1.96) ///
      xtitle(" " "Win probability", size(vlarge)) ///
      xlabel(0(0.2)1.0,format(%9.1f) angle(horizontal)) xscale(reverse) ///
      ylabel(0(0.2)0.8,format(%9.1f) angle(horizontal)) yscale(range(0 0.8)) ///
      addplot(line plotvar prwin, lcolor(maroon) lpattern(dash)) legend(off) $bg ///
      saving("empiricalU_pt`a'.gph", replace)
    }
    else if `a'==3 {
      serrbar plotvar se prwin, title("Panel B", color(black) size(huge)) ///
      subtitle("Original", color(black) size(vlarge)) scale(1.96) ///
      xtitle(" " "Win probability", size(vlarge)) ///
      xlabel(0(0.2)1.0,format(%9.1f) angle(horizontal)) xscale(reverse) ///
      ylabel(0(0.2)0.8,format(%9.1f) angle(horizontal)) yscale(range(0 0.8)) ///
      addplot(line plotvar prwin, lcolor(maroon) lpattern(dash)) legend(off) $bg ///
      saving("empiricalU_pt`a'.gph", replace)
    }
  
  }

  restore

}

// Combine graphs here
graph combine "empiricalU_pt2.gph" ///
"empiricalU_pt3.gph" "empiricalU_pt1.gph", ///
graphregion(color(white)) rows(1) ysize(2)
graph export "Figure_3.png", replace

// Remove graphing files
rm "empiricalU_pt1.gph"
rm "empiricalU_pt2.gph"
rm "empiricalU_pt3.gph"

graph drop _all
