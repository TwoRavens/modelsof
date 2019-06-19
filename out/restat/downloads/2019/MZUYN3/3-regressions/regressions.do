
clear all

global dataDir "../1-datasets"

global maxsim_own="max_phash_own"
global maxsim_oth="max_phash_oth"
global bstmaxsim_own="bst_max_phash_own"
global bstmaxsim_oth="bst_max_phash_oth"
global plcbstmaxsim="plc_bst_max_phash"
global batchsim="batchsim_p_intra"

////////////////////////////////////////
// LOAD DATA, PREP ADD'L VARIABLES

use "$dataDir/dataset_main_phash.dta", clear

egen contplyrid=group(contestid playerid)
bysort contestid playerid (suborder): ///
  gen contplyrorder=_n
xtset contplyrid contplyrorder

// Generate best rating indicators
gen best_rating_own_5=(best_rating_own==5)
gen best_rating_own_4=(best_rating_own==4)
gen best_rating_own_3=(best_rating_own==3)
gen best_rating_own_2=(best_rating_own==2)
gen best_rating_own_1=(best_rating_own==1)
gen D_best_rating_own_5=D.best_rating_own_5
gen D_best_rating_own_4=D.best_rating_own_4
gen D_best_rating_own_3=D.best_rating_own_3
gen D_best_rating_own_2=D.best_rating_own_2
gen D_best_rating_own_1=D.best_rating_own_1
gen plc_best_rating_own_5=(best_rating_plc==5)
gen plc_best_rating_own_4=(best_rating_plc==4)
gen plc_best_rating_own_3=(best_rating_plc==3)
gen plc_best_rating_own_2=(best_rating_plc==2)
gen plc_best_rating_own_1=(best_rating_plc==1)
gen best_rating_oth_5=(best_rating_oth==5)
gen best_rating_oth_4=(best_rating_oth==4)
gen best_rating_oth_3=(best_rating_oth==3)
gen best_rating_oth_2=(best_rating_oth==2)
gen best_rating_oth_1=(best_rating_oth==1)

// Generate interaction terms
gen competitive1=(obs_oth5s>=1)
gen competitive2=(obs_oth5s>=2)
gen ia5c1=(best_rating_own==5)*competitive1
gen ia5c2=(best_rating_own==5)*competitive2
gen ia5p=(best_rating_own==5)*top_prize
gen D_ia5c1=D_best_rating_own_5*competitive1
gen D_ia5c2=D_best_rating_own_5*competitive2
gen D_ia5p=D_best_rating_own_5*top_prize
gen plc_ia5c1=(best_rating_plc==5)*competitive1
gen plc_ia5c2=(best_rating_plc==5)*competitive2
gen plc_ia5p=(best_rating_plc==5)*top_prize

// Generate controls
gen days_remaining=contest_length*(1-subtiming)
label var days_remaining "Days remaining"

// Specify controls
global ctrls="days_remaining own_prev oth_prev"

gen ones=1 // to avoid estout errors

// Save to tempfile
tempfile base_data
save "`base_data'"

////////////////////////////////////////
// TABLE 4

use "`base_data'", clear

// Dependent variable: bstmaxsim_own
gen DV=$bstmaxsim_own

// Loop over regressions
forval ctrl=0/1 {

  if `ctrl'==0 {
    local ctrls=""
    local est_ctrl="No"
  }
  else if `ctrl'==1 {
    local ctrls="$ctrls"
    local est_ctrl="Yes"
  }
  
  forval fe=0/3 {
  
    if inlist(`fe',0,2) {
      local prize="top_prize" // Control
    }
    else if inlist(`fe',1,3) {
      local prize="" // Subsumed by FEs
    }
    
    if `fe'==0 {
      local i=""
      local a="ones"
      local est_fe1="No"
      local est_fe2="No"
    }
    else if `fe'==1 {
      local i=""
      local a="contestid"
      local est_fe1="Yes"
      local est_fe2="No"
    }
    else if `fe'==2 {
      local i=""
      local a="playerid"
      local est_fe1="No"
      local est_fe2="Yes"
    }
    else if `fe'==3 {
      local i="i.contestid"
      local a="playerid"
      local est_fe1="Yes"
      local est_fe2="Yes"
    }
    
    eststo own_bst_ctrl`ctrl'_fe`fe': ///
    areg DV ia5c1 ia5p ///
    best_rating_own_5-best_rating_own_2 ///
    competitive1 `prize' subtiming `ctrls' `i' ///
    ones, absorb(`a') cluster(playerid)
    estadd local ctrl "`est_ctrl'"
    estadd local fe1 "`est_fe1'"
    estadd local fe2 "`est_fe2'"
  
  }

}

// Write results to table
esttab own_bst_ctrl0_fe0 own_bst_ctrl0_fe1 ///
own_bst_ctrl0_fe2 own_bst_ctrl0_fe3 own_bst_ctrl1_fe3 ///
using "Table_4.tex", replace ///
cells(b (star fmt(3)) se(par fmt(3) abs)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
stats(N r2 fe1 fe2 ctrl, fmt(%9.0f %9.2f %-3s %-3s %-3s) ///
labels("N" "\$R^2$" "Contest FEs" "Player FEs" "Other Controls")) ///
nomtitles eqlabels(none) collabels(,none) label ///
varlabels(best_rating_own_5 "Player's prior best rating==5" ///
  ia5c1 "$\quad$ * 1+ competing 5-stars" ///
  ia5p "$\quad$ * prize value (\\$100s)" ///
  best_rating_own_4 "Player's prior best rating==4" ///
  best_rating_own_3 "Player's prior best rating==3" ///
  best_rating_own_2 "Player's prior best rating==2" ///
  competitive1 "One or more competing 5-stars" ///
  top_prize "Prize value (\\$100s)" ///
  subtiming "Pct. of contest elapsed" _cons "Constant") ///
drop($ctrls 23* ones) substitute(_ \_ LatexMath \$) ///
order(best_rating_own_5 ia5c1 ia5p best_rating_own_4)

////////////////////////////////////////
// TABLE 5

use "`base_data'", clear

// Dependent variable: Delta(bstmaxsim_own)
gen DV=D.$bstmaxsim_own

// Loop over regressions
forval ctrl=0/1 {

  if `ctrl'==0 {
    local ctrls=""
    local est_ctrl="No"
  }
  else if `ctrl'==1 {
    local ctrls="$ctrls"
    local est_ctrl="Yes"
  }
  
  forval fe=0/3 {
  
    if inlist(`fe',0,2) {
      local prize="top_prize" // Control
    }
    else if inlist(`fe',1,3) {
      local prize="" // Subsumed by FEs
    }
    
    if `fe'==0 {
      local i=""
      local a="ones"
      local est_fe1="No"
      local est_fe2="No"
    }
    else if `fe'==1 {
      local i=""
      local a="contestid"
      local est_fe1="Yes"
      local est_fe2="No"
    }
    else if `fe'==2 {
      local i=""
      local a="playerid"
      local est_fe1="No"
      local est_fe2="Yes"
    }
    else if `fe'==3 {
      local i="i.contestid"
      local a="playerid"
      local est_fe1="Yes"
      local est_fe2="Yes"
    }
    
    eststo own_bst_fd_ctrl`ctrl'_fe`fe': ///
    areg DV D_ia5c1 D_ia5p ///
    D_best_rating_own_5-D_best_rating_own_2 ///
    competitive1 `prize' subtiming `ctrls' `i' ///
    ones, absorb(`a') cluster(playerid)
    estadd local ctrl "`est_ctrl'"
    estadd local fe1 "`est_fe1'"
    estadd local fe2 "`est_fe2'"
  
  }

}

// Write results to table
esttab own_bst_fd_ctrl0_fe0 own_bst_fd_ctrl0_fe1 ///
own_bst_fd_ctrl0_fe2 own_bst_fd_ctrl0_fe3 own_bst_fd_ctrl1_fe3 ///
using "Table_5.tex", replace ///
cells(b (star fmt(3)) se(par fmt(3) abs)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
stats(N r2 fe1 fe2 ctrl, fmt(%9.0f %9.2f %-3s %-3s %-3s) ///
labels("N" "\$R^2$" "Contest FEs" "Player FEs" "Other Controls")) ///
nomtitles eqlabels(none) collabels(,none) label ///
varlabels(D_best_rating_own_5 "$\Delta$(Player's best rating==5)" ///
  D_ia5c1 "$\quad$ * 1+ competing 5-stars" ///
  D_ia5p "$\quad$ * prize value (\\$100s)" ///
  D_best_rating_own_4 "$\Delta$(Player's best rating==4)" ///
  D_best_rating_own_3 "$\Delta$(Player's best rating==3)" ///
  D_best_rating_own_2 "$\Delta$(Player's best rating==2)" ///
  competitive1 "One or more competing 5-stars" ///
  top_prize "Prize value (\\$100s)" ///
  subtiming "Pct. of contest elapsed" _cons "Constant") ///
drop($ctrls 23* ones) substitute(_ \_ LatexMath \$) ///
order(D_best_rating_own_5 D_ia5c1 D_ia5p D_best_rating_own_4)

////////////////////////////////////////
// TABLE 6

use "`base_data'", clear

// Dependent variable: plcbstmaxsim
gen DV=$plcbstmaxsim

// Prepare controls
gen plc_bst_sim_5=plc_bst_sim*(best_rating_own==5)
gen plc_bst_sim_4=plc_bst_sim*(best_rating_own==4)
gen plc_bst_sim_3=plc_bst_sim*(best_rating_own==3)
gen plc_bst_sim_2=plc_bst_sim*(best_rating_own==2)
gen plc_bst_sim_1=plc_bst_sim*(best_rating_own==1)

// Loop over regressions
forval ctrl=1/1 {

  if `ctrl'==0 {
    local ctrls=""
    local est_ctrl="No"
  }
  else if `ctrl'==1 {
    local ctrls="$ctrls"
    local est_ctrl="Yes"
  }
  
  forval fe=3/3 {
  
    if inlist(`fe',0,2) {
      local prize="top_prize" // Control
    }
    else if inlist(`fe',1,3) {
      local prize="" // Subsumed by FEs
    }
    
    if `fe'==0 {
      local i=""
      local a="ones"
      local est_fe1="No"
      local est_fe2="No"
    }
    else if `fe'==1 {
      local i=""
      local a="contestid"
      local est_fe1="Yes"
      local est_fe2="No"
    }
    else if `fe'==2 {
      local i=""
      local a="playerid"
      local est_fe1="No"
      local est_fe2="Yes"
    }
    else if `fe'==3 {
      local i="i.contestid"
      local a="playerid"
      local est_fe1="Yes"
      local est_fe2="Yes"
    }
    
    // Naive placebo without proper controls
    eststo placebo_1_ctrl`ctrl'_fe`fe': ///
    areg DV plc_ia5c1 plc_ia5p ///
    plc_best_rating_own_5-plc_best_rating_own_2 ///
    competitive1 `prize' subtiming `ctrls' `i' ///
    ones, absorb(`a') cluster(playerid)
    estadd local ctrl "`est_ctrl'"
    estadd local fe1 "`est_fe1'"
    estadd local fe2 "`est_fe2'"
    
    // Controlling for placebo similarity to best already-rated design
    eststo placebo_2_ctrl`ctrl'_fe`fe': ///
    areg DV plc_ia5c1 plc_ia5p ///
    plc_best_rating_own_5-plc_best_rating_own_2 ///
    $bstmaxsim_own plc_bst_sim ///
    c.$bstmaxsim_own#c.plc_bst_sim ///
    competitive1 `prize' subtiming `ctrls' `i' ///
    ones, absorb(`a') cluster(playerid)
    estadd local ctrl "`est_ctrl'"
    estadd local fe1 "`est_fe1'"
    estadd local fe2 "`est_fe2'"
    
    // The same, but allowing heterogeneous effects by best rating
    eststo placebo_3_ctrl`ctrl'_fe`fe': ///
    areg DV plc_ia5c1 plc_ia5p ///
    plc_best_rating_own_5-plc_best_rating_own_2 ///
    $bstmaxsim_own plc_bst_sim_5-plc_bst_sim_2 ///
    c.$bstmaxsim_own#c.plc_bst_sim ///
    competitive1 `prize' subtiming `ctrls' `i' ///
    ones, absorb(`a') cluster(playerid)
    estadd local ctrl "`est_ctrl'"
    estadd local fe1 "`est_fe1'"
    estadd local fe2 "`est_fe2'"
    
    // Regressing with residual similarity to placebo on LHS
    eststo placebo_4_ctrl`ctrl'_fe`fe': ///
    areg unexpl_plc_bst_max_phash plc_ia5c1 plc_ia5p ///
    plc_best_rating_own_5-plc_best_rating_own_2 ///
    competitive1 `prize' subtiming `ctrls' `i' ///
    ones, absorb(`a') cluster(playerid)
    estadd local ctrl "`est_ctrl'"
    estadd local fe1 "`est_fe1'"
    estadd local fe2 "`est_fe2'"
    
  }

}

// Write results to table
esttab placebo_1_ctrl1_fe3 placebo_2_ctrl1_fe3 placebo_3_ctrl1_fe3 placebo_4_ctrl1_fe3 ///
using "Table_6.tex", replace ///
cells(b (star fmt(3)) se(par fmt(3) abs)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
stats(N r2 fe1 fe2 ctrl, fmt(%9.0f %9.2f %-3s %-3s %-3s) ///
labels("N" "\$R^2$" "Contest FEs" "Player FEs" "Other Controls")) ///
mgroups("Similarity to forthcoming" "Residual", ///
pattern(1 0 0 1) span prefix(\multicolumn{@span}{c}{) suffix(})) ///
nomtitles eqlabels(none) collabels(,none) label ///
varlabels( ///
  plc_best_rating_own_5 "Player's best forthcoming rating==5 $\quad\quad\quad\quad$" ///
  plc_ia5c1 "$\quad$ * 1+ competing 5-stars" ///
  plc_ia5p "$\quad$ * prize value (\\$100s)" ///
  plc_best_rating_own_4 "Player's best forthcoming rating==4" ///
  plc_best_rating_own_3 "Player's best forthcoming rating==3" ///
  plc_best_rating_own_2 "Player's best forthcoming rating==2" ///
  competitive1 "One or more competing 5-stars" ///
  subtiming "Pct. of contest elapsed" _cons "Constant") ///
drop($bstmaxsim_own plc_bst_sim* $ctrls 23* ones c.*) substitute(_ \_ LatexMath \$) ///
order(plc_best_rating_own_5 plc_ia5c1 plc_ia5p plc_best_rating_own_4)
