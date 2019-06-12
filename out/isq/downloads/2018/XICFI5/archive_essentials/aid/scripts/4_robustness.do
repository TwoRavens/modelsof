** This script runs the models on the matched data
** Run in Stata 12.1

** I assume that the current working directory is the archive main directory

capture mkdir "aid/results"
log using "aid/results/4_aid models robustness.smcl", replace

set more off

** AID -- iccpr
cd "aid/madedata"

** Matching
  ** treaty members
    ** Original specification
    use "mahmatches_iccpraid_Ratifiers.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "mahmatches_iccpraid.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
    xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

** Without Matching
  ** treaty members
    ** Original specification
    use "iccprRatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1* if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
	reg aidpc012 treated l1* if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, re l(90)
	xtreg aidpc012 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, re l(90)
    xtreg aidpc123 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, fe l(90)
	xtreg aidpc012 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, fe l(90)
    xtreg aidpc123 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "iccprRatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)
	
  
** non-ratification episode data
  ** treaty members
    ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = iccprname2_treat3
	gen treat012 = iccprname2_treat==1 | iccprname2_treat2==1 | (iccprname2_treat[_n-1]==1 & iccprname2_treat3==1)
	gen treat123 = iccprname2_treat==1 | (iccprname2_treat[_n-1]==1 & iccprname2_treat3==1) | (iccprname2_treat[_n-2]==1 & iccprname2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls' if iccprname_1==1 & iccprname_2==0, re l(90)
	xtreg aidpc treat012 `ctrls' if iccprname_1==1 & iccprname_2==0, re l(90)
    xtreg aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls' if iccprname_1==1 & iccprname_2==0, fe l(90)
	xtreg aidpc treat012 `ctrls' if iccprname_1==1 & iccprname_2==0, fe l(90)
    xtreg aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls' if iccprname_1==1 & iccprname_2==0, cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA

	
  ** all
        ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = iccprname2_treat3
	gen treat012 = iccprname2_treat==1 | iccprname2_treat2==1 | (iccprname2_treat[_n-1]==1 & iccprname2_treat3==1)
	gen treat123 = iccprname2_treat==1 | (iccprname2_treat[_n-1]==1 & iccprname2_treat3==1) | (iccprname2_treat[_n-2]==1 & iccprname2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls', re l(90)
	xtreg aidpc treat012 `ctrls', re l(90)
    xtreg aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls', fe l(90)
	xtreg aidpc treat012 `ctrls', fe l(90)
    xtreg aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls', cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls', cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if iccprname_1==1 & iccprname_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA


********************************************************************************

** AID -- opt1

** Matching
  ** treaty members
    ** Original specification
    use "mahmatches_opt1aid_Ratifiers.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "mahmatches_opt1aid.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

** Without Matching
  ** treaty members
    ** Original specification
    use "opt1RatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1* if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
	reg aidpc012 treated l1* if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, re l(90)
	xtreg aidpc012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, re l(90)
    xtreg aidpc123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, fe l(90)
	xtreg aidpc012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, fe l(90)
    xtreg aidpc123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "opt1RatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

  
** non-ratification episode data
  ** treaty members
    ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = opt1name2_treat3
	gen treat012 = opt1name2_treat==1 | opt1name2_treat2==1 | (opt1name2_treat[_n-1]==1 & opt1name2_treat3==1)
	gen treat123 = opt1name2_treat==1 | (opt1name2_treat[_n-1]==1 & opt1name2_treat3==1) | (opt1name2_treat[_n-2]==1 & opt1name2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, re l(90)
	xtreg aidpc treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, re l(90)
    xtreg aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, fe l(90)
	xtreg aidpc treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, fe l(90)
    xtreg aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA

	
  ** all
        ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = opt1name2_treat3
	gen treat012 = opt1name2_treat==1 | opt1name2_treat2==1 | (opt1name2_treat[_n-1]==1 & opt1name2_treat3==1)
	gen treat123 = opt1name2_treat==1 | (opt1name2_treat[_n-1]==1 & opt1name2_treat3==1) | (opt1name2_treat[_n-2]==1 & opt1name2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls', re l(90)
	xtreg aidpc treat012 `ctrls', re l(90)
    xtreg aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls', fe l(90)
	xtreg aidpc treat012 `ctrls', fe l(90)
    xtreg aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls', cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls', cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if opt1name_1==1 & opt1name_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA
	
	
********************************************************************************

** AID -- cat

** Matching
  ** treaty members
    ** Original specification
    use "mahmatches_cataid_Ratifiers.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "mahmatches_cataid.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

** Without Matching
  ** treaty members
    ** Original specification
    use "catRatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1* if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
	reg aidpc012 treated l1* if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags' if catname_1==1 & catname_2==0, re l(90)
	xtreg aidpc012 treated l1* `lags' if catname_1==1 & catname_2==0, re l(90)
    xtreg aidpc123 treated l1* `lags' if catname_1==1 & catname_2==0, re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags' if catname_1==1 & catname_2==0, fe l(90)
	xtreg aidpc012 treated l1* `lags' if catname_1==1 & catname_2==0, fe l(90)
    xtreg aidpc123 treated l1* `lags' if catname_1==1 & catname_2==0, fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "catRatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

  
** non-ratification episode data
  ** treaty members
    ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = catname2_treat3
	gen treat012 = catname2_treat==1 | catname2_treat2==1 | (catname2_treat[_n-1]==1 & catname2_treat3==1)
	gen treat123 = catname2_treat==1 | (catname2_treat[_n-1]==1 & catname2_treat3==1) | (catname2_treat[_n-2]==1 & catname2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls' if catname_1==1 & catname_2==0, re l(90)
	xtreg aidpc treat012 `ctrls' if catname_1==1 & catname_2==0, re l(90)
    xtreg aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls' if catname_1==1 & catname_2==0, fe l(90)
	xtreg aidpc treat012 `ctrls' if catname_1==1 & catname_2==0, fe l(90)
    xtreg aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls' if catname_1==1 & catname_2==0, cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls' if catname_1==1 & catname_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls' if catname_1==1 & catname_2==0, cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA

	
  ** all
        ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = catname2_treat3
	gen treat012 = catname2_treat==1 | catname2_treat2==1 | (catname2_treat[_n-1]==1 & catname2_treat3==1)
	gen treat123 = catname2_treat==1 | (catname2_treat[_n-1]==1 & catname2_treat3==1) | (catname2_treat[_n-2]==1 & catname2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls', re l(90)
	xtreg aidpc treat012 `ctrls', re l(90)
    xtreg aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls', fe l(90)
	xtreg aidpc treat012 `ctrls', fe l(90)
    xtreg aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls', cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls', cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if catname_1==1 & catname_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA
	
********************************************************************************

** AID -- art22

** Matching
  ** treaty members
    ** Original specification
    use "mahmatches_art22aid_Ratifiers.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "mahmatches_art22aid.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
 *   tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)

** Without Matching
  ** treaty members
    ** Original specification
    use "art22RatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)

    ** L1 controls only
    reg aidpc012345 treated l1* if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
	reg aidpc012 treated l1* if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg aidpc123 treated l1* if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags' if art22name_1==1 & art22name_2==0, re l(90)
	xtreg aidpc012 treated l1* `lags' if art22name_1==1 & art22name_2==0, re l(90)
    xtreg aidpc123 treated l1* `lags' if art22name_1==1 & art22name_2==0, re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags' if art22name_1==1 & art22name_2==0, fe l(90)
	xtreg aidpc012 treated l1* `lags' if art22name_1==1 & art22name_2==0, fe l(90)
    xtreg aidpc123 treated l1* `lags' if art22name_1==1 & art22name_2==0, fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
	
	** one year outcome
    reg f1aidpc treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)

	
  ** all
    ** Original specification
    use "art22RatEpisodeDat.dta", clear
    xtset dyadid year

    local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
    reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg aidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** L1 controls only
	reg aidpc012345 treated l1*, cluster(dyadid) l(90)
	reg aidpc012 treated l1*, cluster(dyadid) l(90)
    reg aidpc123 treated l1*, cluster(dyadid) l(90)
   
    ** Random Effects
    xtreg aidpc012345 treated l1* `lags', re l(90)
	xtreg aidpc012 treated l1* `lags', re l(90)
    xtreg aidpc123 treated l1* `lags', re l(90)

    ** Fixed Effects
	xtreg aidpc012345 treated l1* `lags', fe l(90)
	xtreg aidpc012 treated l1* `lags', fe l(90)
    xtreg aidpc123 treated l1* `lags', fe l(90)

    **Tobit (for aid)
	tobit aidpc012345 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc012 treated l1* `lags', cluster(dyadid) ll(0) l(90)
    tobit aidpc123 treated l1* `lags', cluster(dyadid) ll(0) l(90)

    ** Logged outcome variable (for aid)
	gen lnaidpc012345 = ln(aidpc012345+1)
	gen lnaidpc012 = ln(aidpc012+1)
	gen lnaidpc123 = ln(aidpc123+1)
    reg lnaidpc012345 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc012 treated l1* `lags', cluster(dyadid) l(90)
    reg lnaidpc123 treated l1* `lags', cluster(dyadid) l(90)

    ** one year outcome
    reg f1aidpc treated l1* `lags', cluster(dyadid) l(90)
    reg f2aidpc treated l1* `lags', cluster(dyadid) l(90)


  
** non-ratification episode data
  ** treaty members
    ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = art22name2_treat3
	gen treat012 = art22name2_treat==1 | art22name2_treat2==1 | (art22name2_treat[_n-1]==1 & art22name2_treat3==1)
	gen treat123 = art22name2_treat==1 | (art22name2_treat[_n-1]==1 & art22name2_treat3==1) | (art22name2_treat[_n-2]==1 & art22name2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls' if art22name_1==1 & art22name_2==0, re l(90)
	xtreg aidpc treat012 `ctrls' if art22name_1==1 & art22name_2==0, re l(90)
    xtreg aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls' if art22name_1==1 & art22name_2==0, fe l(90)
	xtreg aidpc treat012 `ctrls' if art22name_1==1 & art22name_2==0, fe l(90)
    xtreg aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls' if art22name_1==1 & art22name_2==0, cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls' if art22name_1==1 & art22name_2==0, cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls' if art22name_1==1 & art22name_2==0, cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA

	
  ** all
        ** Original specification
    use "Aidtmp.dta", clear
    xtset dyadid year
	
	gen treat012345 = art22name2_treat3
	gen treat012 = art22name2_treat==1 | art22name2_treat2==1 | (art22name2_treat[_n-1]==1 & art22name2_treat3==1)
	gen treat123 = art22name2_treat==1 | (art22name2_treat[_n-1]==1 & art22name2_treat3==1) | (art22name2_treat[_n-2]==1 & art22name2_treat3==1)
	
	local ctrls l.aidpc physint polity2 lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
	
    reg aidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg aidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, cluster(dyadid) l(90)


    ** Random Effects
    xtreg aidpc treat012345 `ctrls', re l(90)
	xtreg aidpc treat012 `ctrls', re l(90)
    xtreg aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, re l(90)

    ** Fixed Effects
    xtreg aidpc treat012345 `ctrls', fe l(90)
	xtreg aidpc treat012 `ctrls', fe l(90)
    xtreg aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, fe l(90)
	
    **Tobit (for aid)
	tobit aidpc treat012345 `ctrls', cluster(dyadid) ll(0) l(90)
	tobit aidpc treat012 `ctrls', cluster(dyadid) ll(0) l(90)
    tobit aidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, cluster(dyadid) ll(0) l(90)
	
    ** Logged outcome variable (for aid)
	gen lnaidpc = ln(aidpc+1)
    reg lnaidpc treat012345 `ctrls', cluster(dyadid) l(90)
	reg lnaidpc treat012 `ctrls', cluster(dyadid) l(90)
    reg lnaidpc treat123 `ctrls' if art22name_1==1 & art22name_2[_n-1]==0, cluster(dyadid) l(90)

	** one year outcome
	 **NA
	 
************************************************************************************************
************************************************************************************************
	
cd "../.."

log close
