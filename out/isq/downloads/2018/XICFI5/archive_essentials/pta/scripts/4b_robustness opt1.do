

log using "pta/results/5_opt1 pta models robustness.smcl", replace
cd "pta/madedata"

set more off

** PTA -- opt1

** Matching
  ** treaty members
    ** Original specification
	pwd
    use "mahmatches_opt1pta_Ratifiers.dta", clear
    xtset dyadid year

	local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
     l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new ///
     l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
     l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08 ///
     l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
     l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g  

    capture noisily  logit pta012345 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1* `lags', cluster(dyadid) l(90) iter(200)
	
    ** L1 controls only
    capture noisily  logit pta012345 treated l1*, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1*, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1*, cluster(dyadid) l(90) iter(200)
   
    ** Random Effects
    capture noisily  xtlogit pta012345 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags', re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit pta012345 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags', fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1nohs_rat2_onset2 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit f2nohs_rat2_onset2 treated l1* `lags', cluster(dyadid) l(90) iter(200)
	
  ** all
    ** Original specification
    use "mahmatches_opt1pta.dta", clear
    xtset dyadid year

    capture noisily  logit pta012345 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1* `lags', cluster(dyadid) l(90) iter(200)
	
    ** L1 controls only
    capture noisily  logit pta012345 treated l1*, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1*, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1*, cluster(dyadid) l(90) iter(200)
   
    ** Random Effects
    capture noisily  xtlogit pta012345 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags', re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit pta012345 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags', fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1nohs_rat2_onset2 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit f2nohs_rat2_onset2 treated l1* `lags', cluster(dyadid) l(90) iter(200)

	
** Without Matching
  ** treaty members
    ** Original specification
    use "opt1RatEpisodeDat.dta", clear
	
	capture noisily  logit pta012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
	
    ** L1 controls only
	capture noisily  logit pta012345 treated l1* if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1* if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1* if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
	
    ** Random Effects
    capture noisily  xtlogit pta012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, re l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, re l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit pta012345 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, fe l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, fe l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1nohs_rat2_onset2 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit f2nohs_rat2_onset2 treated l1* `lags' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
	
  ** all
    ** Original specification
    use "mahmatches_opt1pta.dta", clear
    xtset dyadid year

    capture noisily  logit pta012345 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1* `lags', cluster(dyadid) l(90) iter(200)
	
    ** L1 controls only
    capture noisily  logit pta012345 treated l1*, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta012 treated l1*, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta123 treated l1*, cluster(dyadid) l(90) iter(200)
   
    ** Random Effects
    capture noisily  xtlogit pta012345 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags', re l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags', re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit pta012345 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit pta012 treated l1* `lags', fe l(90) iter(200)
    capture noisily  xtlogit pta123 treated l1* `lags', fe l(90) iter(200)

    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    capture noisily  logit f1nohs_rat2_onset2 treated l1* `lags', cluster(dyadid) l(90) iter(200)
    capture noisily  logit f2nohs_rat2_onset2 treated l1* `lags', cluster(dyadid) l(90) iter(200)

	
** non-ratification episode data
  ** treaty members
    ** Original specification
    use "tmPTAs.dta", clear
	duplicates tag dyadid year, gen(dup)
	drop if dup>0
	drop dup
    xtset dyadid year
	
	gen pta = nohs_rat2_onset2
	
	gen treat012345 = opt1name2_treat3
	gen treat012 = opt1name2_treat==1 | opt1name2_treat2==1 | (opt1name2_treat[_n-1]==1 & opt1name2_treat3==1)
	gen treat123 = opt1name2_treat==1 | (opt1name2_treat[_n-1]==1 & opt1name2_treat3==1) | (opt1name2_treat[_n-2]==1 & opt1name2_treat3==1)
	
	*local ctrls physint polity2_04 polconiiiA  ptadum_new llntradenew llnGDP_gled08 ldGDP_gled08V2 larmconflict latopally fmrcol_new lcontig_new lndistance lheg_new pcw89 llnGDPratio_g onsetperc2 lnewgatt i.region nohs2_ptaonsp1_r2 nohs2_ptaonsp2_r2 nohs2_ptaonsp3_r2
    local ctrls physint polity2_04 polconiiiA  ptadum_new llntradenew llnGDP_gled08 ldGDP_gled08V2 larmconflict latopally fmrcol_new lcontig_new lndistance lheg_new pcw89 llnGDPratio_g onsetperc2 lnewgatt

    capture noisily  logit pta treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta treat123 `ctrls' if opt1name_1==1 & opt1name_2==0, cluster(dyadid) l(90) iter(200)
	
    ** L1 controls only
    ** NA
   
    ** Random Effects
    capture noisily  xtlogit pta treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, re l(90) iter(200)
    capture noisily  xtlogit pta treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, re l(90) iter(200)
    capture noisily  xtlogit pta treat123 `ctrls' if opt1name_1==1 & opt1name_2==0, re l(90) iter(200)
	
    ** Fixed Effects
    capture noisily  xtlogit pta treat012345 `ctrls' if opt1name_1==1 & opt1name_2==0, fe l(90) iter(200)
    capture noisily  xtlogit pta treat012 `ctrls' if opt1name_1==1 & opt1name_2==0, fe l(90) iter(200)
    capture noisily  xtlogit pta treat123 `ctrls' if opt1name_1==1 & opt1name_2==0, fe l(90) iter(200)
	
    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    ** NA
	
  ** all
    ** Original specification
    capture noisily  logit pta treat012345 `ctrls', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta treat012 `ctrls', cluster(dyadid) l(90) iter(200)
    capture noisily  logit pta treat123 `ctrls', cluster(dyadid) l(90) iter(200) 
	
    ** L1 controls only
    ** NA
   
    ** Random Effects
    capture noisily  xtlogit pta treat012345 `ctrls', re l(90) iter(200)
    capture noisily  xtlogit pta treat012 `ctrls', re l(90) iter(200)
    capture noisily  xtlogit pta treat123 `ctrls', re l(90) iter(200)

	
    ** Fixed Effects
    capture noisily  xtlogit pta treat012345 `ctrls', fe l(90) iter(200)
    capture noisily  xtlogit pta treat012 `ctrls', fe l(90) iter(200)
    capture noisily  xtlogit pta treat123 `ctrls', fe l(90) iter(200)

	
    **Tobit (for aid)
	**NA

    ** Logged outcome variable (for aid)
	**NA
	
	** one year outcome
    ** NA
	
*****************************************************************************
cd "../.."

log close
