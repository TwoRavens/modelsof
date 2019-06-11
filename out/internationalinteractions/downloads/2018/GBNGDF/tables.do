/*======================================================================================================

- This do-file replicates all statistical analyses reported in the paper and supporting appendix.

- To replicate the results, save the data-file of the same name into your working directory and run this do-file.

- This do-file requires 

ssc install estout

======================================================================================================*/

cd ""
global location ""
use tcoups, clear

	
// Table 1

global rank "Lmid_act Lmidhi Lcrisis Lrsh_war midhi_dur"
global X "prev_acoup lprio_civilwar ldemocracy_BX lag_lngdppc_full lag_growth_full  postcold "
global opt ", cl(cowcode)"

set more off
eststo clear
xtset cowcode year
foreach x of varlist Lmid_act Lmidhi Lcrisis Lrsh_war midhi_dur { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}
foreach x of varlist Lmid_act Lmidhi Lcrisis Lrsh_war midhi_dur { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}
esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) nodep b(2) se(2) order($rank)
	order($rank) 
	
// Table 2

global X "prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"
 
set more off
eststo clear
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) order(lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 


// Table 3

set more off
xtset cowcode year
eststo clear	
global X "Lmidhi Lrsh_war midhi_dur prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"
global opt ", cl(cowcode)"

xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 
	

// Table 4

global X "Lmidhi Lrsh_war midhi_dur prev_mcoup gwf_military lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold "

set more off
eststo clear
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit milcoup `x' $X mil_t*  $opt 
}

eststo: qui logit milcoup l1_terrrivalry l1_nonterrrivalry $X mil_t*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit milcoup `x' $X mil_t*  $opt 
}


esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) order(lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 

	
******************************
* supporting appendix
******************************

// Table A5
	
set more off
eststo clear
xtset cowcode year
foreach x of varlist lag_mid Lcrisis2 { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}
foreach x of varlist lag_mid Lcrisis2 { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}
esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) nodep b(2) se(2) order(lag_mid Lcrisis2)


	
// Table A6

global X "prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"

set more off
xtset cowcode year
eststo clear
eststo: qui logit any_coup Lmid_act Lmid_act_win Lmid_act_loss Lmid_act_other  $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lmidhi Lmidhi_win Lmidhi_loss Lmidhi_other  $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lcrisis Lcrisis_win Lcrisis_loss Lcrisis_other $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lrsh_war Lrsh_war_win Lrsh_war_loss Lrsh_war_other $X any_coup_yrs*  $opt 

eststo: qui logit succ_coup Lmid_act Lmid_act_win Lmid_act_loss Lmid_act_other $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lmidhi Lmidhi_win Lmidhi_loss Lmidhi_other $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lcrisis Lcrisis_win Lcrisis_loss Lcrisis_other  $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lrsh_war Lrsh_war_win Lrsh_war_loss Lrsh_war_other $X succ_coup_yrs*  $opt 

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) order(Lmid_act Lmid_act_win Lmid_act_loss Lmid_act_other Lmidhi Lmidhi_win Lmidhi_loss Lmidhi_other Lcrisis Lcrisis_win Lcrisis_loss Lcrisis_other Lrsh_war Lrsh_war_win Lrsh_war_loss Lrsh_war_other)


// Table A7
	
set more off
xtset cowcode year
eststo clear
eststo: qui logit any_coup Lmid_act Lmid_act_win $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lmid_act Lmid_act_loss  $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lmid_act Lmid_act_other $X any_coup_yrs*  $opt 

eststo: qui logit any_coup Lmidhi Lmidhi_win  $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lmidhi Lmidhi_loss $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lmidhi Lmidhi_other $X any_coup_yrs*  $opt 

eststo: qui logit any_coup Lcrisis Lcrisis_win $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lcrisis Lcrisis_loss $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lcrisis Lcrisis_other $X any_coup_yrs*  $opt 

eststo: qui logit any_coup Lrsh_war Lrsh_war_win $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lrsh_war Lrsh_war_loss $X any_coup_yrs*  $opt 
eststo: qui logit any_coup Lrsh_war Lrsh_war_other $X any_coup_yrs*  $opt 

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) order(Lmid_act Lmid_act_win Lmid_act_loss Lmid_act_other Lmidhi Lmidhi_win Lmidhi_loss Lmidhi_other Lcrisis Lcrisis_win Lcrisis_loss Lcrisis_other Lrsh_war Lrsh_war_win Lrsh_war_loss Lrsh_war_other)


// Table A8	

set more off
xtset cowcode year
eststo clear
eststo: qui logit succ_coup Lmid_act Lmid_act_win $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lmid_act Lmid_act_loss  $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lmid_act Lmid_act_other $X succ_coup_yrs*  $opt 

eststo: qui logit succ_coup Lmidhi Lmidhi_win  $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lmidhi Lmidhi_loss $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lmidhi Lmidhi_other $X succ_coup_yrs*  $opt 

eststo: qui logit succ_coup Lcrisis Lcrisis_win $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lcrisis Lcrisis_loss $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lcrisis Lcrisis_other $X succ_coup_yrs*  $opt 

eststo: qui logit succ_coup Lrsh_war Lrsh_war_win $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lrsh_war Lrsh_war_loss $X succ_coup_yrs*  $opt 
eststo: qui logit succ_coup Lrsh_war Lrsh_war_other $X succ_coup_yrs*  $opt 

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) order(Lmid_act Lmid_act_win Lmid_act_loss Lmid_act_other Lmidhi Lmidhi_win Lmidhi_loss Lmidhi_other Lcrisis Lcrisis_win Lcrisis_loss Lcrisis_other Lrsh_war Lrsh_war_win Lrsh_war_loss Lrsh_war_other)

// Table A9

global opt ", cl(cowcode)"
global X "prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"

set more off
xtset cowcode year
eststo clear
foreach x of varlist l1_kgdrival l1_hadispute { 
eststo: qui logit any_coup `x' Lmidhi Lrsh_war midhi_dur $X any_coup_yrs* $opt 
}

foreach x of varlist l1_kgdrival l1_hadispute { 
eststo: qui logit succ_coup `x' Lmidhi Lrsh_war midhi_dur $X succ_coup_yrs* $opt 
}
esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(l1_kgdrival l1_hadispute) 


	
// Table A10

global X "prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"

set more off
xtset cowcode year
eststo clear
eststo: qui logit any_coup Lmid_fat $X any_coup_yrs*  $opt 
eststo: qui logit succ_coup Lmid_fat $X succ_coup_yrs*  $opt 
esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) 


// Table A11

global white "defstal_end19181_5 clashwargrex_ongoingB"

set more off
xtset cowcode year
eststo clear
eststo: qui logit any_coup $white $X any_coup_yrs*  $opt 
eststo: qui logit succ_coup $white $X succ_coup_yrs*  $opt
eststo: qui logit milcoup $white $X mil_t*  $opt 
esttab , star(+ 0.10 * 0.05 ** 0.01)  label
	
	

// Table A12

global X "Lmidhi Lrsh_war midhi_dur lmilex_per lnmilper_MC prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"

eststo clear  
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 


// Table A13
	
global X "Lmidhi Lrsh_war midhi_dur gwf_military prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"
  
set more off
eststo clear	
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 


// Table A14

global X "Lmidhi Lrsh_war midhi_dur mgini_intx mgini_intx_sq prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"
  
set more off
eststo clear	
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 


// Table A15

global X "Lmidhi Lrsh_war midhi_dur prev_acoup"

set more off
eststo clear	
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 

// Table A16

set more off
xtset cowcode year
eststo clear	
global X "Lmidhi Lrsh_war midhi_dur prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"
global opt ", fe"

xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui xtlogit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui xtlogit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui xtlogit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui xtlogit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui xtlogit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui xtlogit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 

	
// Table A17

global opt "|| cowcode:, vce(cl cowcode)"
global X "prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"

set more off
xtset cowcode year
eststo clear
foreach x of varlist lag_relationship l1_geocomp l1_strival  l1_tclaim { 
eststo: qui melogit any_coup `x' Lmidhi Lrsh_war midhi_dur $X any_coup_yrs* $opt 
}
eststo: qui melogit any_coup l1_terrrivalry l1_nonterrrivalry Lmidhi Lrsh_war midhi_dur $X any_coup_yrs* $opt 

foreach x of varlist l1_geocomp l1_strival l1_tclaim { 
eststo: qui melogit succ_coup `x' Lmidhi Lrsh_war midhi_dur succ_coup_yrs* $X $opt 
}

eststo: qui melogit succ_coup l1_terrrivalry l1_nonterrrivalry Lmidhi Lrsh_war midhi_dur $X succ_coup_yrs* $opt 

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) order($rank)
	

// Table A18

global X "prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold"
global opt "if l.everacoup==1, cl(cowcode)"

set more off
eststo clear	
xtset cowcode year
foreach x of varlist lag_relationship l1_geocomp l1_strival { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

eststo: qui logit any_coup l1_terrrivalry l1_nonterrrivalry $X any_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit any_coup `x' $X any_coup_yrs*  $opt 
}

foreach x of varlist lag_relationship l1_geocomp l1_strival  { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

eststo: qui logit succ_coup l1_terrrivalry l1_nonterrrivalry $X succ_coup_yrs*  $opt 

foreach x of varlist l1_tclaim { 
eststo: qui logit succ_coup `x' $X succ_coup_yrs*  $opt 
}

esttab , star(+ 0.10 * 0.05 ** 0.01)  label noomitted stats(country N ll, fmt(2 0 2) labels("country" "N" "Log-Likelihood")) ///
order(Lmidhi Lrsh_war midhi_dur lag_relationship l1_geocomp l1_strival l1_terrrivalry l1_nonterrrivalry l1_tclaim) 


// figure 1: substantive impact

set more off
global X "i.Lmidhi i.Lrsh_war midhi_dur prev_acoup lprio_civilwar ldemocracy_BX  lag_lngdppc_full lag_growth_full  postcold any_coup_yrs*"
global opt ", cl(cowcode)"

qui logit any_coup c.lag_relationship $X $opt 
parmest, saving("results/sub1.dta", replace) bmat(r(b)) vmat(r(V))

qui logit any_coup c.l1_geocomp $X $opt 
qui margins, at(l1_geocomp = (.1(.1)1.1))
parmest, saving("results/sub2.dta", replace) bmat(r(b)) vmat(r(V))


qui logit any_coup i.l1_strival $X $opt
qui margins, at(l1_strival = (0 1))
parmest, saving("results/sub3.dta", replace) bmat(r(b)) vmat(r(V))

qui logit any_coup i.l1_tclaim $X $opt
qui margins, at(l1_tclaim=(0 1))
parmest, saving("results/sub4.dta", replace) bmat(r(b)) vmat(r(V))
 


