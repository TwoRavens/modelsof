

*** This code was last run in Stata v. 12.  The data sets are saved in earlier Stata versions  (using "saveold") for compatability



cd H:\REStatPrepublication\

use Blanchard-MatschkeREStat2014Stata11.dta, clear


* Construct Interacted Political Economy Terms **

** Using just the Gawande - Bandyopadhay Indicator** 
gen USsales_int_org1  = USsales_ln*gb_org
gen goods_toUS_int_org1  = goods_toUS_pro_ln*gb_org
gen sales_local_nevertoUS_org1 =sales_local_nevertoUS_ln*gb_org


*****  Create Analogs to Matilde's Political economy Variables using measures of MNE sales dispersion (by ind-year)
gen theta1_iys = .5*avg_iysales + .5*sd_iysales
	summarize theta1_iys
	gen Mtheta1_iys=r(max)
	replace theta1_iys=theta1_iys/Mtheta1_iys

drop Mtheta*
summarize theta*


** Interact constructed MNE thetas with GB, per Bombardini 2008

	gen theta1_iys_gb = theta1_iys*gb_org

foreach type in true M{
	gen theta1_`type'_gb = theta1_`type'*gb_org
}


**** Interact the variants of theta with the four key variables -- 2 instruments, USsales, and goods to US
*** For all we include the GB interactions as in Bombardini (2008)  

   foreach type in iys {
		gen MBint`type'_gb_goods=theta1_`type'_gb*goods_toUS_pro_ln
		gen MBint`type'_gb_USsalees = theta1_`type'_gb*USsales_ln
		gen MBint`type'_gb_localnev = theta1_`type'_gb*sales_local_nevertoUS_ln
		gen MBint`type'_gb_svcnev = theta1_`type'_gb*svc_nevergoodstoUS_ln
}

  
foreach type in true M{
		gen MBint`type'_gb_goods=theta1_`type'_gb*goods_toUS_pro_ln
		gen MBint`type'_gb_USsalees = theta1_`type'_gb*USsales_ln
		gen MBint`type'_gb_localnev = theta1_`type'_gb*sales_local_nevertoUS_ln
		gen MBint`type'_gb_svcnev = theta1_`type'_gb*svc_nevergoodstoUS_ln
}





**
*	Create country and ci_pair indices


sort country
egen country_num=group(country)
gen ci_pair=country_num + (naic4*10000)





**********************************************
*
*	Summarize data;  Table (1)			
*
**********************************************


** Note that in the paper, Distance, cgdp, and US sales units are different (multiply by *1000)

local summarytabvars distance terrorist communist pop cgdp textile agriculture employees  payroll USsales  tot_ind_usimp mfn_ave_wt us_imp_pen ln_change_empl ln_change_us_imp_pen imp_tot  any_gsp c_curr_gspel gsp_inel i_curr_gspel  allpref_share gsp_share  el_gsp_hwt el_gsp  el_any_pref_hwt el_any_pref  goods_toUS goods_toUS_pro sales_local_nevertoUS svc_nevergoodstoUS any_mne ROW_FDI gb_org theta1_true theta1_M theta1_iys

* Our Sample (Used in Analysis -- has share data -- i.e. imp_tot>0)

summarize `summarytabvars' if inreg==1

** Compare baseline sample with the only gsp eligible subsample

summarize `summarytabvars' if inreg==1 & gsp_inel==0

** For online appendix listing of deJure (in)/eligible countries

tab country if gsp_inel==0
tab country if gsp_inel==1

**** Calculate Some Figures we mention in published and earlier versions of the text  ***************

summarize goods_toUS_pro if inreg==1 & goods_toUS_pro>0

summarize goods_toUS_pro if inreg==1 & gsp_inel==0 &goods_toUS_pro>0

summarize fcount* firm* if inreg==1 
summarize fcount* firm* if inreg==1 & gsp_inel!=1

summarize fcount* firm* if inreg==1 & any_mne>0
summarize fcount* firm* if inreg==1 & gsp_inel!=1 & any_mne>0




saveold Fullpanel.dta, replace










*******************************************************************
*			DEMEANING DATA FOR			  *
*		PANEL (FE) Model, demeaning c, i, y by hand       	  
*  Note that standard errors will need to be corrected with demeaned 
*  Do this two times -- once each for the full data set, and once again for the 
*	GSP only reduced runs.
*******************************************************************


drop firm*

drop fcount*  

local identifiers  "naic4 country year ccode"
local depvars  "gsp_share  allpref_share el_gsp_hwt  el_any_pref_hwt  el_gsp  el_any_pref"
local control_vars_tolag  "establishments_ln employees_ln payroll_ln USsales_ln USsales_ln_sq imp_tot_ln ROW_FDI_ln mfn_ave_wt_ln tot_ind_usimp_ln us_imp_pen cgdp_ln pop_ln  USsales_int_org1 "  
local mne_vars_tolag "goods_toUS_ln goods_toUS_pro_ln goods_us_rep_ln svc_nevergoodstoUS_ln svc_ln sales_local_ln sales_local_nevertoUS_ln sales_oth_un_neverUS_ln sales_onlyrow_ln  goods_toUS_int_org1 sales_local_nevertoUS_org1 MBintiys_gb_goods MBintiys_gb_USsalees MBintiys_gb_localnev MBintiys_gb_svcnev MBinttrue_gb_goods MBinttrue_gb_USsalees MBinttrue_gb_localnev MBinttrue_gb_svcnev MBintM_gb_goods MBintM_gb_USsalees MBintM_gb_localnev MBintM_gb_svcnev  any_mne "
local control_vars_contemp  "gb_org distance_ln terrorist communist  c_curr_gspel  i_curr_gspel  gsp_inel textile agriculture ln_change_empl ln_change_us_imp_pen" 

***************************
* Introduce lags (One year)
* Note that RHS vars not lagged are: indicators for currently eligible, etc. and log changes in empl, imp pen, etc. (the log change already implicitly includes a lag, of course!)
**************************

 
foreach var of varlist  `control_vars_tolag' `mne_vars_tolag' {
	bysort country naic4 (year): gen lag`var'= `var'[_n-1]  
	}
	
	
* Replace all concurrent variable names with 1 year lags 

foreach var of varlist `control_vars_tolag' `mne_vars_tolag'{
	replace `var'=lag`var' 	
	drop lag`var'
}
	

* Now demean by country, then by industry.  (We add back in the pop mean; don't need to of course)  Do this for all variables.*/



*******************************************************************************
*		IMPORTANT NOTE						*
* Be careful to demean only relative to the actual sample USED in the analysis*
*   Run this code twice: 
* 		For Fulllagged demeaned:  keep if inreg==1 
***		For smalllaggeddemeaned: keep if inreg==1 & gsp_inel==0
****
**************************************************************



keep if inreg==1  &gsp_inel==0


foreach var of varlist `depvars' `mne_vars_tolag'  `control_vars_tolag' `control_vars_contemp' y_* {
	sort country naic4 year
	by country, sort: egen cm_`var'= mean(`var')
	sort naic4 country year
	by naic4, sort:  egen im_`var'=mean(`var') 
	egen pm_`var'=mean(`var')
	
	gen D`var'= `var'-im_`var'-cm_`var'+ 2*pm_`var'
	drop cm_`var' im_`var' pm_`var' 
	}
	



****************** Make Nice Labels for Demeaned Variables  *********************

label var Dterrorist "Terrorist"
label var Dcommunist "Communist"
label var Dtextile "Textile"
label var Dagriculture "Agriculture"
label var Dus_imp_pen "U.S. import penetration"
label var Dln_change_empl "Log change U.S. employees"
label var Dln_change_us_imp_pen "Log change U.S. import pen."
label var Dallpref_share "All pref share"
label var Dgsp_share "GSP share"
label var Del_gsp_hwt "Elig. GSP (hwt)
label var Del_gsp "Elig. GSP"
label var Del_any_pref_hwt "Elig. any pref. (hwt)"
label var Del_any_pref "Elig. any pref."

label var Dany_mne "Any MNE"

label var Ddistance_ln "(ln) Distance to U.S. (th.km)"
label var Dpop_ln "(ln) Population (b.)"
label var Dcgdp_ln "(ln) Per capita GDP (th.USD)"
label var Demployees_ln "(ln) U.S. employees (m.)"
label var Dpayroll_ln "(ln) U.S. payroll (m.USD)"
label var DUSsales_ln "(ln) U.S. domestic sales (b.USD)"
label var DUSsales_ln_sq "sq((ln)) U.S. domestic sales (b.USD)"
label var Dtot_ind_usimp_ln "(ln) U.S. total imports (b.USD)"
label var Dmfn_ave_wt_ln "(ln) MFN ad-valorem eqv. (wt.)"
label var Dimp_tot_ln "(ln) C-i-y exports to U.S. (b.USD)"
label var Dgoods_toUS_ln "(ln) MNE sales to U.S. (b.USD)"
label var Dgoods_toUS_pro_ln "(ln) MNE sales to U.S. prorated by ownership (b.USD)"
label var Dsales_local_nevertoUS_ln "(ln) MNE local sales (b.USD) by only firms not selling goods to US"
label var DROW_FDI_ln "(ln) Rest of world MNE sales (b.USD)"
label var Dsvc_nevergoodstoUS_ln "(ln) MNE service sales (b.USD) by only firms not selling goods to US"

	
saveold Fulllaggeddemeaned.dta, replace




****  Note, You MUST rerun the code above (as noted earlier) to create smalllaggeddemeaned.dta for the reduced sample.




local logFEcontrols "DUSsales_ln DUSsales_ln_sq Dimp_tot_ln Dtot_ind_usimp_ln DROW_FDI_ln Dmfn_ave_wt_ln Dcgdp_ln Dln_change_empl Dus_imp_pen Dln_change_us_imp_pen  Destablishments_ln Dpop_ln Demployees_ln Dpayroll_ln"
local logFEmodelvars "DROW_FDI_ln Dmfn_ave_wt_ln DUSsales_ln DUSsales_ln_sq Dimp_tot_ln Dtot_ind_usimp_ln"
local logFEfdivar "Dgoods_toUS_pro_ln"
local logFEinstruments "Dsales_local_nevertoUS_ln Dsvc_nevergoodstoUS_ln"
local FEyshares "Dallpref_share Dgsp_share"
local FEally "Dallpref_share Dgsp_share Del_any_pref_hwt Del_gsp_hwt Del_any_pref Del_gsp"






*************************************************
*  Regression Results:  Using full sample (demeaned)
*************************************************


* (Baseline) Table 1, Column 1

		ivreg2 Dallpref_share  `logFEcontrols'  Dy_*  (`logFEfdivar'= `logFEinstruments'), cluster(country_num) first 

		
	* Robustness (footnote 42) to just identified and LIML
		ivreg2 Dallpref_share  `logFEcontrols' Dy_* (`logFEfdivar'=Dsales_local_nevertoUS_ln), robust first
		ivreg2 Dallpref_share  `logFEcontrols'  Dy_*  (`logFEfdivar'= `logFEinstruments'), liml cluster(country_num) first
		
	* Robustness (footnote 21) to exclusion of additional controls		
		ivreg2 Dallpref_share                Dy_*  (`logFEfdivar'= `logFEinstruments'),  cluster(country_num) first
		ivreg2 Dallpref_share `logFEmodelvars'  Dy_*  (`logFEfdivar'= `logFEinstruments'), cluster(country_num) first
		
	*Robustness to alternative instrument (footnote 25): MNE sales to row (rather than local)
		ivreg2 Dallpref_share  `logFEcontrols'  Dy_*  (`logFEfdivar'=   Dsales_onlyrow_ln Dsvc_nevergoodstoUS_ln ), cluster(country_num) first 

	

* (Political Economy) Table 3, columns 1-5 in order:

	ivreg2  Dallpref_share DUSsales_int_org1 `logFEcontrols'  Dy_* (`logFEfdivar'=`logFEinstruments'), cluster(country_num) first
	ivreg2  Dallpref_share DUSsales_int_org1 `logFEcontrols'  Dy_* (`logFEfdivar' Dgoods_toUS_int_org1=`logFEinstruments' Dsales_local_nevertoUS_org1), robust first
	ivreg2  Dallpref_share DUSsales_int_org1 `logFEcontrols'  Dy_* (`logFEfdivar' Dgoods_toUS_int_org1=`logFEinstruments' Dsales_local_nevertoUS_org1), cluster(country_num) first
	ivreg2  Dallpref_share DMBinttrue_gb_USsalees `logFEcontrols'  Dy_* (DMBinttrue_gb_goods `logFEfdivar'=`logFEinstruments' DMBinttrue_gb_localnev ), robust first
	ivreg2  Dallpref_share DMBintM_gb_USsalees 	`logFEcontrols'  Dy_* (DMBintiys_gb_goods `logFEfdivar'=`logFEinstruments' DMBintiys_gb_localnev), robust first


* (Mechanism/Falsification) Table 4, columns  2-5 in order.  (Column 1 is the baseline from above)

	ivreg2  Dallpref_share  `logFEcontrols'  Dy_* ( Dgoods_us_rep_ln =`logFEinstruments'), cluster(country_num) first
	ivreg2  Dallpref_share  `logFEcontrols' Dy_* (Dsales_oth_un_neverUS_ln=`logFEinstruments'), cluster(country_num) first
	ivreg2  Dallpref_share  `logFEcontrols' Dy_*  Dsales_oth_un_neverUS_ln (Dgoods_toUS_pro_ln =`logFEinstruments'), cluster(country_num) first
	ivreg2  Dallpref_share  (Dsales_local_nevertoUS_ln=  Dsales_oth_un_neverUS_ln Dsvc_nevergoodstoUS_ln)   `logFEcontrols' Dy_*, cluster(country_num) first

	* Robustness to instrumenting for both MNE variables (footnote 53) 	
		ivreg2  Dallpref_share  `logFEcontrols' Dy_*  (Dsales_oth_un_neverUS_ln Dgoods_toUS_pro_ln =`logFEinstruments'), cluster(country_num) first

	
* Alternative Specifications (Table 5) 

* Row 1, column 2 (includes robustness for unweighted eligibility variable (footnote 27) 

foreach yvar in Del_any_pref_hwt Del_any_pref {
		 ivreg2 `yvar'  `logFEcontrols' Dy_* (`logFEfdivar'= `logFEinstruments') if inreg==1, robust first
		 ivreg2 `yvar'  `logFEcontrols' Dy_* (`logFEfdivar'= `logFEinstruments') if inreg==1, cluster(country_num) first
}
* Row 3, columns 1 and 2 (Panel OLS) 
 
 foreach yvar in Dallpref_share Del_any_pref_hwt{
		reg `yvar' `logFEfdivar' `logFEcontrols' Dy_*, robust 
		reg `yvar' `logFEfdivar' `logFEcontrols' Dy_*, cluster(country_num)
}	

* Row 4, columns 1-4 (Pooled OLS) 

local logcontrols "USsales_ln USsales_ln_sq imp_tot_ln tot_ind_usimp_ln ROW_FDI_ln mfn_ave_wt_ln cgdp_ln ln_change_empl us_imp_pen ln_change_us_imp_pen  establishments_ln pop_ln employees_ln payroll_ln"
local logpooledcontrols  "distance_ln agriculture textile"
 
 *columns 1-2 
 foreach yvar in allpref_share el_any_pref_hwt {
		reg `yvar'  goods_toUS_pro_ln `logcontrols' `logpooledcontrols' y_* if inreg==1, robust
		cgmreg `yvar'  goods_toUS_pro_ln `logcontrols' `logpooledcontrols' y_* if inreg==1, cluster(country naic4)
}
* columns 3-4
 foreach yvar in gsp_share el_gsp_hwt{
		*Now remove the rich countries
		reg `yvar'  goods_toUS_pro_ln `logcontrols' `logpooledcontrols' y_* if inreg==1 & gsp_inel==0, robust
		cgmreg `yvar'  goods_toUS_pro_ln `logcontrols' `logpooledcontrols' y_* if inreg==1 & gsp_inel==0, cluster(country naic4)
}
*	



	
*************************************************
*  Regression Results:  Using REDUCED sample (demeaned)
*************************************************

use smalllaggeddemeaned.dta, clear

* Table 1, Columns 2-3 

		ivreg2 Dallpref_share  `logFEcontrols'  Dy_*  (`logFEfdivar'= `logFEinstruments'), cluster(country_num) first 
		ivreg2 Dgsp_share  	`logFEcontrols'  Dy_*  (`logFEfdivar'= `logFEinstruments'), cluster(country_num) first 

* Table 5, Row 1, column 2 (includes robustness for unweighted eligibility variable (footnote 27) 

foreach yvar in Del_gsp_hwt Del_gsp {
		 ivreg2 `yvar'  `logFEcontrols' Dy_* (`logFEfdivar'= `logFEinstruments') , robust first
		 ivreg2 `yvar'  `logFEcontrols' Dy_* (`logFEfdivar'= `logFEinstruments'), cluster(country_num) first
}
* Table 5, Row 3, cols 3-4 (Panel OLS)
foreach yvar in Dgsp_share Del_gsp_hwt{
		reg `yvar' `logFEfdivar' `logFEcontrols' Dy_*, robust 
		reg `yvar' `logFEfdivar' `logFEcontrols' Dy_*, cluster(country_num)
}	
*


	
	
*********************
*   IV Tobit, two-step (by necessity), with C, I, Y FEs and only controls directly indicated by theory (see early WP version for the model)
*********************

use fulllaggeddemeaned, clear


* generate industry and country dummies (already have year dummies)
xi, prefix(_ind) i.naic4
xi, prefix(_C) i.country


local logcontrols "USsales_ln imp_tot_ln tot_ind_usimp_ln ROW_FDI_ln mfn_ave_wt_ln cgdp_ln ln_change_empl us_imp_pen ln_change_us_imp_pen  establishments_ln pop_ln employees_ln payroll_ln"
local logfdivar "goods_toUS_pro_ln"
local logmodelcontrols "ROW_FDI_ln mfn_ave_wt_ln USsales_ln USsales_ln_sq imp_tot_ln tot_ind_usimp_ln"

* Table 1, column (4) and Table 5 row 2, cols 1-2
foreach yvar in allpref_share el_any_pref_hwt{
		ivtobit `yvar'  `logmodelcontrols' y_* _C* _ind* (`logfdivar' = sales_local_nevertoUS_ln), twostep ll(0) ul(1) first
}		


*  Table 1, cols 5-6 and Table 5, row 2, col 3; Now the REDUCED Sample with c, i, y FEs.
foreach yvar in allpref_share gsp_share{
		ivtobit `yvar'  `logmodelcontrols' y_* _C* _ind* (`logfdivar' = sales_local_nevertoUS_ln) if gsp_inel==0, twostep ll(0) ul(1) first
}

* Table 5, row 2, col 4
		ivtobit el_gsp_hwt  `logmodelcontrols' y_* _C* _ind* (`logfdivar' = sales_local_nevertoUS_ln) if gsp_inel==0, twostep ll(0) ul(1) first




		
		
		
		
**********************************************
***	Pairwise fixed effects (Table 6)
*****************************************************


** Full Data Set (Table 6, columns 1-2)

use Fullpanel.dta, clear

local loginstruments "sales_local_nevertoUS_ln svc_nevergoodstoUS_ln"
local yshares  allpref_share gsp_share

xi, prefix(_ind) i.naic4
xi, prefix(_C) i.country


keep `logfdivar' `loginstruments' `yshares' _C* _ind* y* country naic4 year inreg gsp_inel

** First Lag RHS by One year

local lagvars  `logfdivar' `loginstruments'
 
foreach var of varlist `lagvars' {
	bysort country naic4 (year): gen lag`var'= `var'[_n-1]  
	}
	
	
* Replace all concurrent variable names with 1 year lags 

foreach var of varlist `lagvars'{
	replace `var'=lag`var' 	
	drop lag`var'
}
	
keep if inreg==1 

foreach var of varlist `logfdivar' `yshares' y_* _ind* _C* `loginstruments'{
	sort country naic4 year
	egen pm_`var'=mean(`var')

	by naic4 country, sort:	egen icm_`var'=mean(`var')
	by naic4 year, sort:	egen iym_`var'=mean(`var')
	by country year, sort:	egen cym_`var'=mean(`var')
	
 	gen DIY`var'=`var'-iym_`var' +pm_`var'
	gen DCY`var'=`var'-cym_`var' +pm_`var'
	drop icm_`var' iym_`var' cym_`var'  pm_`var' 
}
* Table 6, col 1

	ivreg2 DIYallpref_share DIY_C* (DIYgoods_toUS_pro_ln=DIYsales_local_nevertoUS_ln DIYsvc_nevergoodstoUS_ln), gmm2s robust first

** Table 6, col 2

	 ivreg2 DCYallpref_share DCY_ind* (DCYgoods_toUS_pro_ln=DCYsales_local_nevertoUS_ln DCYsvc_nevergoodstoUS_ln), gmm2s robust first

***********************
** Now for the Reduced data set.  (Table 6, columns 3-4)

use Fullpanel.dta, clear

local loginstruments "sales_local_nevertoUS_ln svc_nevergoodstoUS_ln"
local yshares  allpref_share gsp_share

xi, prefix(_ind) i.naic4
xi, prefix(_C) i.country


keep `logfdivar' `loginstruments' `yshares' _C* _ind* y* country naic4 year inreg gsp_inel

** First Lag RHS by One year

local lagvars  `logfdivar' `loginstruments'
 
foreach var of varlist `lagvars' {
	bysort country naic4 (year): gen lag`var'= `var'[_n-1]  
	}
	
	
* Replace all concurrent variable names with 1 year lags 

foreach var of varlist `lagvars'{
	replace `var'=lag`var' 	
	drop lag`var'
}
	
keep if inreg==1 & gsp_inel==0

foreach var of varlist `logfdivar' `yshares' y_* _ind* _C* `loginstruments'{
	sort country naic4 year
	egen pm_`var'=mean(`var')

	by naic4 country, sort:	egen icm_`var'=mean(`var')
	by naic4 year, sort:	egen iym_`var'=mean(`var')
	by country year, sort:	egen cym_`var'=mean(`var')
	
 	gen DIY`var'=`var'-iym_`var' +pm_`var'
	gen DCY`var'=`var'-cym_`var' +pm_`var'
	drop icm_`var' iym_`var' cym_`var'  pm_`var' 
}
* Table 6, col 1

	ivreg2 DIYgsp_share DIY_C* (DIYgoods_toUS_pro_ln=DIYsales_local_nevertoUS_ln DIYsvc_nevergoodstoUS_ln), gmm2s robust first

** Table 6, col 2

	 ivreg2 DCYgsp_share DCY_ind* (DCYgoods_toUS_pro_ln=DCYsales_local_nevertoUS_ln DCYsvc_nevergoodstoUS_ln), gmm2s robust first

	 







