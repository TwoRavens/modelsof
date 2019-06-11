********************************************************************************************
* Not so Harmless After All: The Fixed-Effects Model 
* Political Analysis
* Thomas Pluemper and Vera E. Troeger
*
* Replication files:
* Simulations and final outputs
* tables 1,2, 3a,3b,4a,4b, 
* online appendix, tables A1 - A9
*
*******************************************************************
cd C:\Vera\TP\FEVD\textbook\finalreplication\PA\R2\seed  /* change working directory here once!*/
set seed 12345
*******************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*Experiment 1: ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.2
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.2
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.2
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.2
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.2
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.2
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.2
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.2
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.2
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx02_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.2
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx02_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx02_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.5
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.5
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.5
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.5
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.5
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.5
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.5
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.5
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.5
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx05_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.5
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx05_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx05_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.8
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.8
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0, wx = 0.8
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.8
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.8
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.2, wx = 0.8
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.8
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.8
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*ommitted correlated within variance in DGP
*******************************************************************
*******************************************************************
*ux = 0.5, wx = 0.8
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_wx08_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0.8
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	
	

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_wx08_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_wx08_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*Experiment 2: common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.2
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.2
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.2
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*common ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ct_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	
	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	gen w=mw+dw
	gen x=mx+dx
	
	tsset csvar date
	
	replace w=w+0.1*date
	replace x=x+0.1*date

	tsset csvar date
	xi i.date

	gen y=x+w+u+e

	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ct_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ct_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*Experiment 3: unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.5 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 10
	local obs 200
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.5 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 30
	local obs 600
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*unit specific ommitted trend in DGP
*******************************************************************
*******************************************************************
*ux = 0.5 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	
************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_ust_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 50
	local obs 1000
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	local rhoew 0
	local rhoex 0
	local rhowx 0
	
	matrix D = (1, `rhoew', `rhoex' \ `rhoew', 1, `rhowx' \ `rhoex', `rhowx', 1)
	tempvar w_ x_ mw_ mx_ dw dx wt xt mwt mxt dw1 dx1
	drawnorm e `w_' `x_', corr(D) n(`obs') sds(1,1,1) 
	bysort csvar: egen  `mw_'=mean(`w_')
	bysort csvar: egen  `mx_'=mean(`x_')

	gen dw=`w_'-`mw_'
	gen dx=`x_'-`mx_'
	
	tsset csvar date
	
	gen `xt' = dx if s1>=0.7
	gen `wt' = dw if s1>=0.7
	replace `wt'=dw+0.1*date if s1<=0.3
	replace `wt'=dw-0.1*date if s1>0.3 & s1<0.7
	replace `xt'=dx+0.1*date if s1<=0.3
	replace `xt'=dx-0.1*date if s1>0.3 & s1<0.7
	
	bysort csvar: egen `mwt'=mean(`wt')
	bysort csvar: egen `mxt'=mean(`xt')
	gen `dw1'=`wt'-`mwt'
	gen `dx1'=`xt'-`mxt'
	
	gen w=mw+`dw1'
	gen x=mx+`dx1'
	
	tsset csvar date
	xi i.date

	gen y=x+w+u+e
	
	xtset csvar date

	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_ust_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_ust_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)-1
	egen rmsex_olsadl=mean(sqrt((bx_olsadl-1)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)
	egen rmselx_olsadl=mean(sqrt((blx_olsadl)*(blx_olsadl)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)-1
	egen rmsex_feadl=mean(sqrt((bx_feadl-1)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)
	egen rmselx_feadl=mean(sqrt((blx_feadl)*(blx_feadl)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*Experiment 4: Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 11
	local obs 220
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 31
	local obs 620
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 51
	local obs 1020
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 11
	local obs 220
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 31
	local obs 620
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 51
	local obs 1020
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************

*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 11
	local obs 220
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 31
	local obs 620
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_lx_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 51
	local obs 1020
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e
	
	
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_lx_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_lx_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************
*******************************************************************
*******************************************************************
*******************************************************************
*Experiment 5: heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux00_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 11
	local obs 220
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux00_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux00_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux00_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 31
	local obs 620
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux00_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux00_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux00_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 51
	local obs 1020
	
	local rhoumw 0
	local rhoumx 0
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux00_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux00_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux02_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 11
	local obs 220
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux02_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux02_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux02_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 31
	local obs 620
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux02_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux02_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.2 
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux02_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 51
	local obs 1020
	
	local rhoumw 0
	local rhoumx 0.2
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux02_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux02_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************

*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=10
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux05_2010_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 11
	local obs 220
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux05_2010_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux05_2010_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=30
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux05_2030_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 31
	local obs 620
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux05_2030_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux05_2030_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*******************************************************************
*heterogneous Lagx in DGP
*******************************************************************
*******************************************************************
*ux = 0.5
**********************************************************************
* T=50
*********************************************************************************
*********************************************************************************	

************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fe_ovb1
	program fe_ovb1
	version 10.0

	tempname FEOVB1
	
	postfile `FEOVB1' b_ols se_ols bx_olsldv sex_olsldv by_olsldv sey_olsldv b_pw se_pw b_olsyfe se_olsyfe bx_olsldvyfe sex_olsldvyfe by_olsldvyfe sey_olsldvyfe bx_olsadl sex_olsadl blx_olsadl selx_olsadl by_olsadl sey_olsadl b_fe se_fe bx_feldv sex_feldv by_feldv sey_feldv b_ab se_ab b_fepw se_fepw b_feyfe se_feyfe bx_feldvyfe sex_feldvyfe by_feldvyfe sey_feldvyfe b_abyfe se_abyfe bx_feadl sex_feadl blx_feadl selx_feadl by_feadl sey_feadl chi2_hausman_nd chi2_hausman_ldv chi2_hausman_pw chi2_hausman_yfe chi2_hausman_ldvyfe chi2_hausman_adl using ovb_uslx_ux05_2050_all.dta, replace
	
	qui {	

	forvalues i = 1/500 {

	drop _all
	local N 20
	local T 51
	local obs 1020
	
	local rhoumw 0
	local rhoumx 0.5
	local rhomwmx 0

	set obs `N'
	gen csvar = _n
	
	matrix C = (1, `rhoumw', `rhoumx' \ `rhoumw', 1, `rhomwmx' \ `rhoumx', `rhomwmx', 1)
	drawnorm u mw mx, corr(C) n(`N') sds(1,1,1)
	gen s1=uniform()
	expand `T'
	sort csvar
	by csvar: gen date = _n

	tempvar x_ mx_ dx
	drawnorm `x_' e
	bysort csvar: egen  `mx_'=mean(`x_')
	gen dx=`x_'-`mx_'
	gen x=mx+dx
	tsset csvar date
	xi i.date

	gen y=l.x+u+e if s1<=0.3
	replace y=l2.x+u+e if s1>0.3 & s1<0.7
	replace y=l3.x+u+e if s1>=0.7
	
	sort date csvar
	drop in 1/20
	replace date=date-1
	
	xtset csvar date
	
	capture {
	reg y x
	scalar b_ols = _b[x]
	scalar se_ols = _se[x]
	reg y l.y x
	scalar bx_olsldv = _b[x]
	scalar sex_olsldv = _se[x]
	scalar by_olsldv = _b[l.y]
	scalar sey_olsldv = _se[l.y]
	prais y x
	scalar b_pw = _b[x]
	scalar se_pw = _se[x]
	reg y x _I*
	scalar b_olsyfe = _b[x]
	scalar se_olsyfe = _se[x]
	reg y l.y x _I*
	scalar bx_olsldvyfe = _b[x]
	scalar sex_olsldvyfe = _se[x]
	scalar by_olsldvyfe = _b[l.y]
	scalar sey_olsldvyfe = _se[l.y]
	reg y l.y x l.x 
	scalar bx_olsadl = _b[x]
	scalar sex_olsadl = _se[x]
	scalar blx_olsadl = _b[l.x]
	scalar selx_olsadl = _se[l.x]
	scalar by_olsadl = _b[l.y]
	scalar sey_olsadl = _se[l.y]
		
	xtreg y x, fe
	est store fe
	scalar b_fe = _b[x]
	scalar se_fe = _se[x]
	xtreg y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_nd = r(chi2)
	xtreg y l.y x, fe
	est store fe
	scalar bx_feldv = _b[x]
	scalar sex_feldv = _se[x]
	scalar by_feldv = _b[l.y]
	scalar sey_feldv = _se[l.y]
	xtreg y l.y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldv = r(chi2)
	xtabond y x
	scalar b_ab = _b[x]
	scalar se_ab = _se[x]
	xtregar y x, fe
	est store fe
	scalar b_fepw = _b[x]
	scalar se_fepw = _se[x]
	xtregar y x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_pw = r(chi2)
	xtreg y x _I*, fe
	est store fe
	scalar b_feyfe = _b[x]
	scalar se_feyfe = _se[x]
	xtreg y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_yfe = r(chi2)
	xtreg y l.y x _I*, fe
	est store fe
	scalar bx_feldvyfe = _b[x]
	scalar sex_feldvyfe = _se[x]
	scalar by_feldvyfe = _b[l.y]
	scalar sey_feldvyfe = _se[l.y]
	xtreg y l.y x _I*, re
	est store re
	hausman fe re	
	scalar chi2_hausman_ldvyfe = r(chi2)
	xtabond y x _I*
	scalar b_abyfe = _b[x]
	scalar se_abyfe = _se[x]
	xtreg y l.y x l.x, fe
	est store fe
	scalar bx_feadl = _b[x]
	scalar sex_feadl = _se[x]
	scalar blx_feadl = _b[l.x]
	scalar selx_feadl = _se[l.x]
	scalar by_feadl = _b[l.y]
	scalar sey_feadl = _se[l.y]
	xtreg y l.y x l.x, re
	est store re
	hausman fe re	
	scalar chi2_hausman_adl = r(chi2)
	}
	
	post `FEOVB1' (b_ols) (se_ols) (bx_olsldv) (sex_olsldv) (by_olsldv) (sey_olsldv) (b_pw) (se_pw) (b_olsyfe) (se_olsyfe) (bx_olsldvyfe) (sex_olsldvyfe) (by_olsldvyfe) (sey_olsldvyfe) (bx_olsadl) (sex_olsadl) (blx_olsadl) (selx_olsadl) (by_olsadl) (sey_olsadl) (b_fe) (se_fe) (bx_feldv) (sex_feldv) (by_feldv) (sey_feldv) (b_ab) (se_ab) (b_fepw) (se_fepw) (b_feyfe) (se_feyfe) (bx_feldvyfe) (sex_feldvyfe) (by_feldvyfe) (sey_feldvyfe) (b_abyfe) (se_abyfe) (bx_feadl) (sex_feadl) (blx_feadl) (selx_feadl) (by_feadl) (sey_feadl) (chi2_hausman_nd) (chi2_hausman_ldv) (chi2_hausman_pw) (chi2_hausman_yfe) (chi2_hausman_ldvyfe) (chi2_hausman_adl)

		}
	
	}

	postclose `FEOVB1'

	end

	fe_ovb1
	
	clear
	
*	results

	use ovb_uslx_ux05_2050_all.dta
	
	tempname r1

	postfile `r1' bias_ols rmse_ols c_ols biasx_olsldv rmsex_olsldv biasy_olsldv rmsey_olsldv c_olsldv bias_pw rmse_pw c_pw bias_olsyfe rmse_olsyfe c_olsyfe biasx_olsldvyfe rmsex_olsldvyfe biasy_olsldvyfe rmsey_olsldvyfe c_olsldvyfe biasx_olsadl rmsex_olsadl biaslx_olsadl rmselx_olsadl biasy_olsadl rmsey_olsadl c_olsadl bias_fe rmse_fe c_fe biasx_feldv rmsex_feldv biasy_feldv rmsey_feldv c_feldv bias_ab rmse_ab c_ab bias_fepw rmse_fepw c_fepw bias_feyfe rmse_feyfe c_feyfe biasx_feldvyfe rmsex_feldvyfe biasy_feldvyfe rmsey_feldvyfe c_feldvyfe bias_abyfe rmse_abyfe c_abyfe biasx_feadl rmsex_feadl biaslx_feadl rmselx_feadl biasy_feadl rmsey_feadl c_feadl hm95_nd hm95_ldv hm95_pw hm95_yfe hm95_ldvyfe hm95_adl using rovb_uslx_ux05_2050_all.dta, replace

	sum b_ols
	scalar bias_ols=r(mean)-1
	egen rmse_ols=mean(sqrt((b_ols-1)^2))
	scalar rmse_ols=rmse_ols
	sum b_ols
	scalar sd_b_ols=r(sd)
	sum se_ols
	scalar mean_se_ols=r(mean)
	scalar c_ols=mean_se_ols/sd_b_ols
	
	sum bx_olsldv
	scalar biasx_olsldv=r(mean)-1
	egen rmsex_olsldv=mean(sqrt((bx_olsldv-1)^2))
	scalar rmsex_olsldv=rmsex_olsldv
	sum bx_olsldv
	scalar sd_bx_olsldv=r(sd)
	sum sex_olsldv
	scalar mean_sex_olsldv=r(mean)
	scalar c_olsldv=mean_sex_olsldv/sd_bx_olsldv
	sum by_olsldv
	scalar biasy_olsldv=r(mean)
	egen rmsey_olsldv=mean(sqrt((by_olsldv)*(by_olsldv)))
	scalar rmsey_olsldv=rmsey_olsldv
	
	sum b_pw
	scalar bias_pw=r(mean)-1
	egen rmse_pw=mean(sqrt((b_pw-1)^2))
	scalar rmse_pw=rmse_pw
	sum b_pw
	scalar sd_b_pw=r(sd)
	sum se_pw
	scalar mean_se_pw=r(mean)
	scalar c_pw=mean_se_pw/sd_b_pw
	
	sum b_olsyfe
	scalar bias_olsyfe=r(mean)-1
	egen rmse_olsyfe=mean(sqrt((b_olsyfe-1)^2))
	scalar rmse_olsyfe=rmse_olsyfe
	sum b_olsyfe
	scalar sd_b_olsyfe=r(sd)
	sum se_olsyfe
	scalar mean_se_olsyfe=r(mean)
	scalar c_olsyfe=mean_se_olsyfe/sd_b_olsyfe
	
	sum bx_olsldvyfe
	scalar biasx_olsldvyfe=r(mean)-1
	egen rmsex_olsldvyfe=mean(sqrt((bx_olsldvyfe-1)^2))
	scalar rmsex_olsldvyfe=rmsex_olsldvyfe
	sum bx_olsldvyfe
	scalar sd_bx_olsldvyfe=r(sd)
	sum sex_olsldvyfe
	scalar mean_sex_olsldvyfe=r(mean)
	scalar c_olsldvyfe=mean_sex_olsldvyfe/sd_bx_olsldvyfe
	sum by_olsldvyfe
	scalar biasy_olsldvyfe=r(mean)
	egen rmsey_olsldvyfe=mean(sqrt((by_olsldvyfe)*(by_olsldvyfe)))
	scalar rmsey_olsldvyfe=rmsey_olsldvyfe
	
	sum bx_olsadl
	scalar biasx_olsadl=r(mean)
	egen rmsex_olsadl=mean(sqrt((bx_olsadl)^2))
	scalar rmsex_olsadl=rmsex_olsadl
	sum bx_olsadl
	scalar sd_bx_olsadl=r(sd)
	sum sex_olsadl
	scalar mean_sex_olsadl=r(mean)
	scalar c_olsadl=mean_sex_olsadl/sd_bx_olsadl
	sum blx_olsadl
	scalar biaslx_olsadl=r(mean)-1
	egen rmselx_olsadl=mean(sqrt((blx_olsadl-1)*(blx_olsadl-1)))
	scalar rmselx_olsadl=rmselx_olsadl
	sum by_olsadl
	scalar biasy_olsadl=r(mean)
	egen rmsey_olsadl=mean(sqrt((by_olsadl)*(by_olsadl)))
	scalar rmsey_olsadl=rmsey_olsadl
	
	sum b_fe
	scalar bias_fe=r(mean)-1
	egen rmse_fe=mean(sqrt((b_fe-1)^2))
	scalar rmse_fe=rmse_fe
	sum b_fe
	scalar sd_b_fe=r(sd)
	sum se_fe
	scalar mean_se_fe=r(mean)
	scalar c_fe=mean_se_fe/sd_b_fe
	
	sum bx_feldv
	scalar biasx_feldv=r(mean)-1
	egen rmsex_feldv=mean(sqrt((bx_feldv-1)^2))
	scalar rmsex_feldv=rmsex_feldv
	sum bx_feldv
	scalar sd_bx_feldv=r(sd)
	sum sex_feldv
	scalar mean_sex_feldv=r(mean)
	scalar c_feldv=mean_sex_feldv/sd_bx_feldv
	sum by_feldv
	scalar biasy_feldv=r(mean)
	egen rmsey_feldv=mean(sqrt((by_feldv)*(by_feldv)))
	scalar rmsey_feldv=rmsey_feldv
	
	sum b_ab
	scalar bias_ab=r(mean)-1
	egen rmse_ab=mean(sqrt((b_ab-1)^2))
	scalar rmse_ab=rmse_ab
	sum b_ab
	scalar sd_b_ab=r(sd)
	sum se_ab
	scalar mean_se_ab=r(mean)
	scalar c_ab=mean_se_ab/sd_b_ab
	
	sum b_fepw
	scalar bias_fepw=r(mean)-1
	egen rmse_fepw=mean(sqrt((b_fepw-1)^2))
	scalar rmse_fepw=rmse_fepw
	sum b_fepw
	scalar sd_b_fepw=r(sd)
	sum se_fepw
	scalar mean_se_fepw=r(mean)
	scalar c_fepw=mean_se_fepw/sd_b_fepw
	
	sum b_feyfe
	scalar bias_feyfe=r(mean)-1
	egen rmse_feyfe=mean(sqrt((b_feyfe-1)^2))
	scalar rmse_feyfe=rmse_feyfe
	sum b_feyfe
	scalar sd_b_feyfe=r(sd)
	sum se_feyfe
	scalar mean_se_feyfe=r(mean)
	scalar c_feyfe=mean_se_feyfe/sd_b_feyfe
	
	sum bx_feldvyfe
	scalar biasx_feldvyfe=r(mean)-1
	egen rmsex_feldvyfe=mean(sqrt((bx_feldvyfe-1)^2))
	scalar rmsex_feldvyfe=rmsex_feldvyfe
	sum bx_feldvyfe
	scalar sd_bx_feldvyfe=r(sd)
	sum sex_feldvyfe
	scalar mean_sex_feldvyfe=r(mean)
	scalar c_feldvyfe=mean_sex_feldvyfe/sd_bx_feldvyfe
	sum by_feldvyfe
	scalar biasy_feldvyfe=r(mean)
	egen rmsey_feldvyfe=mean(sqrt((by_feldvyfe)*(by_feldvyfe)))
	scalar rmsey_feldvyfe=rmsey_feldvyfe
	
	sum b_abyfe
	scalar bias_abyfe=r(mean)-1
	egen rmse_abyfe=mean(sqrt((b_abyfe-1)^2))
	scalar rmse_abyfe=rmse_abyfe
	sum b_abyfe
	scalar sd_b_abyfe=r(sd)
	sum se_abyfe
	scalar mean_se_abyfe=r(mean)
	scalar c_abyfe=mean_se_abyfe/sd_b_abyfe
	
	sum bx_feadl
	scalar biasx_feadl=r(mean)
	egen rmsex_feadl=mean(sqrt((bx_feadl)^2))
	scalar rmsex_feadl=rmsex_feadl
	sum bx_feadl
	scalar sd_bx_feadl=r(sd)
	sum sex_feadl
	scalar mean_sex_feadl=r(mean)
	scalar c_feadl=mean_sex_feadl/sd_bx_feadl
	sum blx_feadl
	scalar biaslx_feadl=r(mean)-1
	egen rmselx_feadl=mean(sqrt((blx_feadl-1)*(blx_feadl-1)))
	scalar rmselx_feadl=rmselx_feadl
	sum by_feadl
	scalar biasy_feadl=r(mean)
	egen rmsey_feadl=mean(sqrt((by_feadl)*(by_feadl)))
	scalar rmsey_feadl=rmsey_feadl
	
	tempvar h95_nd sum_h95_nd h95_ldv sum_h95_ldv h95_pw sum_h95_pw h95_yfe sum_h95_yfe h95_ldvyfe sum_h95_ldvyfe h95_adl sum_h95_adl
	gen `h95_nd'=0
	replace `h95_nd'=1 if chi2_hausman_nd>=3.84 | chi2_hausman_nd<=(-3.84) 
	egen `sum_h95_nd'=sum(`h95_nd')
    scalar sum_h95_nd=`sum_h95_nd'
	scalar hm95_nd=sum_h95_nd/500
	gen `h95_ldv'=0
	replace `h95_ldv'=1 if chi2_hausman_ldv>=3.84 | chi2_hausman_ldv<=(-3.84) 
	egen `sum_h95_ldv'=sum(`h95_ldv')
    scalar sum_h95_ldv=`sum_h95_ldv'
	scalar hm95_ldv=sum_h95_ldv/500
	gen `h95_pw'=0
	replace `h95_pw'=1 if chi2_hausman_pw>=3.84 | chi2_hausman_pw<=(-3.84) 
	egen `sum_h95_pw'=sum(`h95_pw')
    scalar sum_h95_pw=`sum_h95_pw'
	scalar hm95_pw=sum_h95_pw/500
	gen `h95_yfe'=0
	replace `h95_yfe'=1 if chi2_hausman_yfe>=3.84 | chi2_hausman_yfe<=(-3.84) 
	egen `sum_h95_yfe'=sum(`h95_yfe')
    scalar sum_h95_yfe=`sum_h95_yfe'
	scalar hm95_yfe=sum_h95_yfe/500
	gen `h95_ldvyfe'=0
	replace `h95_ldvyfe'=1 if chi2_hausman_ldvyfe>=3.84 | chi2_hausman_ldvyfe<=(-3.84) 
	egen `sum_h95_ldvyfe'=sum(`h95_ldvyfe')
    scalar sum_h95_ldvyfe=`sum_h95_ldvyfe'
	scalar hm95_ldvyfe=sum_h95_ldvyfe/500
	gen `h95_adl'=0
	replace `h95_adl'=1 if chi2_hausman_adl>=3.84 | chi2_hausman_adl<=(-3.84) 
	egen `sum_h95_adl'=sum(`h95_adl')
    scalar sum_h95_adl=`sum_h95_adl'
	scalar hm95_adl=sum_h95_adl/500
	
	post `r1' (bias_ols) (rmse_ols) (c_ols) (biasx_olsldv) (rmsex_olsldv) (biasy_olsldv) (rmsey_olsldv) (c_olsldv) (bias_pw) (rmse_pw) (c_pw) (bias_olsyfe) (rmse_olsyfe) (c_olsyfe) (biasx_olsldvyfe) (rmsex_olsldvyfe) (biasy_olsldvyfe) (rmsey_olsldvyfe) (c_olsldvyfe) (biasx_olsadl) (rmsex_olsadl) (biaslx_olsadl) (rmselx_olsadl) (biasy_olsadl) (rmsey_olsadl) (c_olsadl) (bias_fe) (rmse_fe) (c_fe) (biasx_feldv) (rmsex_feldv) (biasy_feldv) (rmsey_feldv) (c_feldv) (bias_ab) (rmse_ab) (c_ab) (bias_fepw) (rmse_fepw) (c_fepw) (bias_feyfe) (rmse_feyfe) (c_feyfe) (biasx_feldvyfe) (rmsex_feldvyfe) (biasy_feldvyfe) (rmsey_feldvyfe) (c_feldvyfe) (bias_abyfe) (rmse_abyfe) (c_abyfe) (biasx_feadl) (rmsex_feadl) (biaslx_feadl) (rmselx_feadl) (biasy_feadl) (rmsey_feadl) (c_feadl) (hm95_nd) (hm95_ldv) (hm95_pw) (hm95_yfe) (hm95_ldvyfe) (hm95_adl)

	postclose `r1'
	clear
	
*****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************
* append results and generate descriptive variables
************************************************************************************************

clear
use rovb_wx02_ux00_2010_all.dta, clear
save results_mc_pa_final, replace
append using rovb_wx02_ux00_2030_all.dta
append using rovb_wx02_ux00_2050_all.dta
append using rovb_wx02_ux02_2010_all.dta
append using rovb_wx02_ux02_2030_all.dta
append using rovb_wx02_ux02_2050_all.dta
append using rovb_wx02_ux05_2010_all.dta
append using rovb_wx02_ux05_2030_all.dta
append using rovb_wx02_ux05_2050_all.dta
append using rovb_wx05_ux00_2010_all.dta
append using rovb_wx05_ux00_2030_all.dta
append using rovb_wx05_ux00_2050_all.dta
append using rovb_wx05_ux02_2010_all.dta
append using rovb_wx05_ux02_2030_all.dta
append using rovb_wx05_ux02_2050_all.dta
append using rovb_wx05_ux05_2010_all.dta
append using rovb_wx05_ux05_2030_all.dta
append using rovb_wx05_ux05_2050_all.dta
append using rovb_wx08_ux00_2010_all.dta
append using rovb_wx08_ux00_2030_all.dta
append using rovb_wx08_ux00_2050_all.dta
append using rovb_wx08_ux02_2010_all.dta
append using rovb_wx08_ux02_2030_all.dta
append using rovb_wx08_ux02_2050_all.dta
append using rovb_wx08_ux05_2010_all.dta
append using rovb_wx08_ux05_2030_all.dta
append using rovb_wx08_ux05_2050_all.dta

append using rovb_ct_ux00_2010_all.dta
append using rovb_ct_ux00_2030_all.dta
append using rovb_ct_ux00_2050_all.dta
append using rovb_ct_ux02_2010_all.dta
append using rovb_ct_ux02_2030_all.dta
append using rovb_ct_ux02_2050_all.dta
append using rovb_ct_ux05_2010_all.dta
append using rovb_ct_ux05_2030_all.dta
append using rovb_ct_ux05_2050_all.dta

append using rovb_ust_ux00_2010_all.dta
append using rovb_ust_ux00_2030_all.dta
append using rovb_ust_ux00_2050_all.dta
append using rovb_ust_ux02_2010_all.dta
append using rovb_ust_ux02_2030_all.dta
append using rovb_ust_ux02_2050_all.dta
append using rovb_ust_ux05_2010_all.dta
append using rovb_ust_ux05_2030_all.dta
append using rovb_ust_ux05_2050_all.dta

append using rovb_lx_ux00_2010_all.dta
append using rovb_lx_ux00_2030_all.dta
append using rovb_lx_ux00_2050_all.dta
append using rovb_lx_ux02_2010_all.dta
append using rovb_lx_ux02_2030_all.dta
append using rovb_lx_ux02_2050_all.dta
append using rovb_lx_ux05_2010_all.dta
append using rovb_lx_ux05_2030_all.dta
append using rovb_lx_ux05_2050_all.dta

append using rovb_uslx_ux00_2010_all.dta
append using rovb_uslx_ux00_2030_all.dta
append using rovb_uslx_ux00_2050_all.dta
append using rovb_uslx_ux02_2010_all.dta
append using rovb_uslx_ux02_2030_all.dta
append using rovb_uslx_ux02_2050_all.dta
append using rovb_uslx_ux05_2010_all.dta
append using rovb_uslx_ux05_2030_all.dta
append using rovb_uslx_ux05_2050_all.dta
save results_mc_pa_final, replace
generate exp = 1 in 1
replace exp = 1 in 2
replace exp = 1 in 3
replace exp = 1 in 4
replace exp = 1 in 5
replace exp = 1 in 6
replace exp = 1 in 7
replace exp = 1 in 8
replace exp = 1 in 9
replace exp = 1 in 10
replace exp = 1 in 11
replace exp = 1 in 12
replace exp = 1 in 13
replace exp = 1 in 14
replace exp = 1 in 15
replace exp = 1 in 16
replace exp = 1 in 17
replace exp = 1 in 18
replace exp = 1 in 19
replace exp = 1 in 20
replace exp = 1 in 21
replace exp = 1 in 22
replace exp = 1 in 23
replace exp = 1 in 24
replace exp = 1 in 25
replace exp = 1 in 26
replace exp = 1 in 27
replace exp = 2 in 28
replace exp = 2 in 29
replace exp = 2 in 30
replace exp = 2 in 31
replace exp = 2 in 32
replace exp = 2 in 33
replace exp = 2 in 34
replace exp = 2 in 35
replace exp = 2 in 36
replace exp = 3 in 37
replace exp = 3 in 38
replace exp = 3 in 39
replace exp = 3 in 40
replace exp = 3 in 41
replace exp = 3 in 42
replace exp = 3 in 43
replace exp = 3 in 44
replace exp = 3 in 45
replace exp = 4 in 46
replace exp = 4 in 47
replace exp = 4 in 48
replace exp = 4 in 49
replace exp = 4 in 50
replace exp = 4 in 51
replace exp = 4 in 52
replace exp = 4 in 53
replace exp = 4 in 54
replace exp = 5 in 55
replace exp = 5 in 56
replace exp = 5 in 57
replace exp = 5 in 58
replace exp = 5 in 59
replace exp = 5 in 60
replace exp = 5 in 61
replace exp = 5 in 62
replace exp = 5 in 63
generate T = 10 in 1
replace T = 30 in 2
replace T = 50 in 3
replace T = 10 in 4
replace T = 30 in 5
replace T = 50 in 6
replace T = 10 in 7
replace T = 30 in 8
replace T = 50 in 9
replace T = 10 in 10
replace T = 30 in 11
replace T = 50 in 12
replace T = 10 in 13
replace T = 30 in 14
replace T = 50 in 15
replace T = 10 in 16
replace T = 30 in 17
replace T = 50 in 18
replace T = 10 in 19
replace T = 30 in 20
replace T = 50 in 21
replace T = 10 in 22
replace T = 30 in 23
replace T = 50 in 24
replace T = 10 in 25
replace T = 30 in 26
replace T = 50 in 27
replace T = 10 in 28
replace T = 30 in 29
replace T = 50 in 30
replace T = 10 in 31
replace T = 30 in 32
replace T = 50 in 33
replace T = 10 in 34
replace T = 30 in 35
replace T = 50 in 36
replace T = 10 in 37
replace T = 30 in 38
replace T = 50 in 39
replace T = 10 in 40
replace T = 30 in 41
replace T = 50 in 42
replace T = 10 in 43
replace T = 30 in 44
replace T = 50 in 45
replace T = 10 in 46
replace T = 30 in 47
replace T = 50 in 48
replace T = 10 in 49
replace T = 30 in 50
replace T = 50 in 51
replace T = 10 in 52
replace T = 30 in 53
replace T = 50 in 54
replace T = 10 in 55
replace T = 30 in 56
replace T = 50 in 57
replace T = 10 in 58
replace T = 30 in 59
replace T = 50 in 60
replace T = 10 in 61
replace T = 30 in 62
replace T = 50 in 63
generate corrxu = .
replace corrxu = 0 in 1
replace corrxu = 0 in 2
replace corrxu = 0 in 3
replace corrxu = 2 in 4
replace corrxu = 2 in 5
replace corrxu = 2 in 6
replace corrxu = 5 in 7
replace corrxu = 5 in 8
replace corrxu = 5 in 9
replace corrxu = 0 in 10
replace corrxu = 0 in 11
replace corrxu = 0 in 12
replace corrxu = 2 in 13
replace corrxu = 2 in 14
replace corrxu = 2 in 15
replace corrxu = 5 in 16
replace corrxu = 5 in 17
replace corrxu = 5 in 18
replace corrxu = 0 in 19
replace corrxu = 0 in 20
replace corrxu = 0 in 21
replace corrxu = 2 in 22
replace corrxu = 2 in 23
replace corrxu = 2 in 24
replace corrxu = 5 in 25
replace corrxu = 5 in 26
replace corrxu = 5 in 27
replace corrxu = 0 in 28
replace corrxu = 0 in 29
replace corrxu = 0 in 30
replace corrxu = 2 in 31
replace corrxu = 2 in 32
replace corrxu = 2 in 33
replace corrxu = 5 in 34
replace corrxu = 5 in 35
replace corrxu = 5 in 36
replace corrxu = 0 in 37
replace corrxu = 0 in 38
replace corrxu = 0 in 39
replace corrxu = 2 in 40
replace corrxu = 2 in 41
replace corrxu = 2 in 42
replace corrxu = 5 in 43
replace corrxu = 5 in 44
replace corrxu = 5 in 45
replace corrxu = 0 in 46
replace corrxu = 0 in 47
replace corrxu = 0 in 48
replace corrxu = 2 in 49
replace corrxu = 2 in 50
replace corrxu = 2 in 51
replace corrxu = 5 in 52
replace corrxu = 5 in 53
replace corrxu = 5 in 54
replace corrxu = 0 in 55
replace corrxu = 0 in 56
replace corrxu = 0 in 57
replace corrxu = 2 in 58
replace corrxu = 2 in 59
replace corrxu = 2 in 60
replace corrxu = 5 in 61
replace corrxu = 5 in 62
replace corrxu = 5 in 63
generat corrxw = 0
replace corrxw = 2 in 1/9
replace corrxw = 5 in 10/18
replace corrxw = 8 in 19/27
save results_mc_pa_final, replace

foreach var of varlist bias* {
replace `var' = abs(`var')
}

save results_mc_absbias_pa_final, replace

*****************************************************************************************************************
***********************************************************************************************************************
*generate figures*
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table 1: overall bias
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
tabstat bias*, stats(mean min max) save
tabstatmat A
matrix TAB=A'
xml_tab TAB, replace save(bias_overall.xls)
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* experiment 1: correlated within variance in DGP
***********************************************************************************************************************
***********************************************************************************************************************
* table 2
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************
* experiment 2a: common trend in DGP
***********************************************************************************************************************
* Table 3a
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************
* experiment 2b: unit specific trend in DGP
***********************************************************************************************************************
* table 3b
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************
* experiment 3a: x one period lagged in DGP
***********************************************************************************************************************
* table 4a
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************
* experiment 3b: unitspecific lag in x in DGP
***********************************************************************************************************************
* table 4b
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************
* table A1
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A2
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_nd T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_nd0.pdf, replace
twoway (area hm95_nd T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_nd2.pdf, replace
twoway (area hm95_nd T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_ols T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_nd5.pdf, replace

twoway (area hm95_ldv T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldv0x.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldv2x.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldv T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldv T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_ab T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldv5x.pdf, replace

twoway (area hm95_pw T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_pw0.pdf, replace
twoway (area hm95_pw T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_pw2.pdf, replace
twoway (area hm95_pw T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_pw T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_fepw T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_pw5.pdf, replace

twoway (area hm95_yfe T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_yfe0.pdf, replace
twoway (area hm95_yfe T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_yfe2.pdf, replace
twoway (area hm95_yfe T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line bias_olsyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line bias_feyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_yfe5.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldvyfe0x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldvyfe2x.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasx_olsldvyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feldvyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)) (line bias_abyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dot)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldvyfe5x.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1))  (line biaslx_olsadl T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_adl0xlx.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_adl2xlx.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biaslx_olsadl T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(solid) yaxis(2)) (line biaslx_feadl T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(gs7) lwidth(medthick) lpattern(dash)) (line biasx_olsadl T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasx_feadl T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_adl5xlx.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A3
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_ldv T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==2 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==2 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw2_adl5y.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A4
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
twoway (area hm95_ldv T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==5 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==5 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw5_adl5y.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A5
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_ldv T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==8 & exp==1, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==8 & exp==1, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export corrxw8_adl5y.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A6
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==2, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==0 & exp==2, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ct_adl5y.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A7
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==3, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==0 & exp==3, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export ust_adl5y.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A8
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.4, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==4, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==0 & exp==4, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export lx_adl5y.pdf, replace

**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
* table A9
***********************************************************************************************************************
**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
twoway (area hm95_ldv T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldv0y.pdf, replace
twoway (area hm95_ldv T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldv2y.pdf, replace
twoway (area hm95_ldv T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldv T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldv T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldv5y.pdf, replace

twoway (area hm95_ldvyfe T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldvyfe0y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldvyfe2y.pdf, replace
twoway (area hm95_ldvyfe T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsldvyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feldvyfe T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1.2, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_ldvyfe5y.pdf, replace

twoway (area hm95_adl T if corrxu==0 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==0 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_adl0y.pdf, replace
twoway (area hm95_adl T if corrxu==2 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==2 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_adl2y.pdf, replace
twoway (area hm95_adl T if corrxu==5 & corrxw==0 & exp==5, sort fcolor(gs14) lcolor(gs14) lwidth(medthick) lpattern(solid) yaxis(1)) (line biasy_olsadl T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(solid) yaxis(2)) (line biasy_feadl T if corrxu==5 & corrxw==0 & exp==5, sort lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(bias, axis(2)) ytitle(prob rejecting H0, axis(1)) ylabel(0(0.1)1, axis(1)) ylabel(0(0.1)1, axis(2)) xtitle(T) legend(off) scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(zero)) graphregion(margin(zero))
graph export uslx_adl5y.pdf, replace


