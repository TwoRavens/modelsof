/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do


log using output/log_persuasion.txt, replace text



include code/set_globals.do


local runs = 1000


local spec1 "vote_share_dem lag_vote_share_dem cmag_prez_dem_base cmag_prez_rep_base cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_pair_year)"
local spec2 "vote_share_rep lag_vote_share_rep cmag_prez_dem_base cmag_prez_rep_base cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_pair_year)"
local spec3 "vote_share_ptydf lag_vote_share_ptydf cmag_prez_dem_base cmag_prez_rep_base cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_pair_year)"


use input/sample_countypairs, clear

reghdfe `spec1'
local eff_dem = _b[cmag_prez_dem_base]


reghdfe `spec2'
local eff_rep = _b[cmag_prez_rep_base]


reghdfe `spec3'
local beta_rep = -_b[cmag_prez_rep_base]
local beta_dem = _b[cmag_prez_dem_base]



use input/sample_allcounties, clear
keep if year==2008


gen y0dem=vote_share_dem - `eff_dem'*cmag_prez_dem_base
gen y0rep=vote_share_rep - `eff_rep'*cmag_prez_rep_base




sum vote_share_dem vote_share_rep y0dem y0rep cmag_prez_dem_base cmag_prez_rep_base 

sum y0rep [w=tot_pop_vote]
local Y0REP=r(mean) 

sum y0dem  [w=tot_pop_vote]
local Y0DEM=r(mean)

sum vote_share_rep  [w=tot_pop_vote]
local YREP=r(mean)

sum vote_share_dem  [w=tot_pop_vote]
local YDEM=r(mean)

sum cmag_prez_dem_base  [w=tot_pop_vote]
local ADSDEM=r(mean)

sum cmag_prez_rep_base  [w=tot_pop_vote]
local ADSREP=r(mean)


local frep0 = 100/(100-`Y0REP')*`beta_rep'/10*(`ADSREP'*10)
di "pers rate rep (zero - all): `frep0'"  
di 100-`Y0REP'
di `beta_rep'/10
di `ADSREP'*10

local fdem0 = 100/(100-`Y0DEM')*`beta_dem'/10*(`ADSDEM'*10)
di "pers rate dem (zero - all):  `fdem0'"  
di 100-`Y0DEM'
di `beta_dem'/10
di `ADSDEM'*10


local frepd1 = 100/(100-`YREP')*`beta_rep'/10
di "pers rate rep (d1, curr equ):  `frepd1'"  
di 100-`YREP'
di `beta_rep'/10


local fdemd1 = 100/(100-`YDEM')*`beta_dem'/10
di "pers rate dem (d1, curr equ): `fdemd1' "  
di 100-`YDEM'
di `beta_dem'/10



di (206*10^6)*(1-`Y0DEM'/100)*`fdem0'/100 + (206*10^6)*(1-`Y0REP'/100)*`frep0'/100

di (206*10^6)*(1-`YDEM'/100)*`fdemd1'/100*((`ADSDEM'*10)-(`ADSREP'*10))



*** bootstrap SE
tempfile boot
quietly {
    
    postfile persSE prate_dem_all prate_rep_all prate_dem_1 prate_rep1 using `boot'


    	forvalues q=1(1)`runs' {
    	    
    	    if `q'==1 {
                nois di""
                nois di "Boostrapping persuasion rates"
                nois di ""
                nois _dots 0, title(bootstrap replicates) reps(`runs')
            }
    	    nois _dots `q' 0
    	    
    	    
    	    use input/sample_countypairs, clear
    	
    	    bsample , cluster(state) idcluster(newstate)
    	    
    	    egen dummy = group(newstate state_pair_year)
    	    replace state_pair_year = dummy
    	
    	
    	    reghdfe `spec1'
    	    local eff_dem = _b[cmag_prez_dem_base]
    	
    	    reghdfe `spec2'
    	    local eff_rep = _b[cmag_prez_rep_base]
    	
    	
    	    reghdfe `spec3'
    	    local beta_rep = -_b[cmag_prez_rep_base]
    	    local beta_dem = _b[cmag_prez_dem_base]
    	
    	
    	
    	    use input/sample_allcounties, clear
    	    keep if year==2008
    	
    	    gen y0dem=vote_share_dem - `eff_dem'*cmag_prez_dem_base
    	    gen y0rep=vote_share_rep - `eff_rep'*cmag_prez_rep_base
    	
    	    sum y0rep [w=tot_pop_vote]
    	    local Y0REP=r(mean)

    	    sum y0dem  [w=tot_pop_vote]
    	    local Y0DEM=r(mean)

    	    sum vote_share_rep  [w=tot_pop_vote]
    	    local YREP=r(mean)

    	    sum vote_share_dem  [w=tot_pop_vote]
    	    local YDEM=r(mean)
    	
    	    local rep_zero_all = 100/(100-`Y0REP')*`beta_rep'/10*(`ADSREP'*10)
    	    local dem_zero_all = 100/(100-`Y0DEM')*`beta_dem'/10*(`ADSDEM'*10)
    	    local rep_1 = 100/(100-`YREP')*`beta_rep'/10
    	    local dem_1 = 100/(100-`YDEM')*`beta_dem'/10
    	
    	    post persSE (`dem_zero_all') (`rep_zero_all') (`dem_1') (`rep_1')

    	}
    	
    postclose persSE

}



use `boot', clear
sum *



log close
