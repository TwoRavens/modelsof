log using inst_basis_order_tests03_ajps_fin_rep.log, replace
****************************************************************************************************************
* inst_basis_order_tests03_ajps_fin_rep.do
* This is the revised analysis of the 2003 Podes merged dataset which works with inst_basis_order and the dataset that
* is yielded by cleanpod03_ib_ajps_fin_rep.do
* Yuhki Tajima
* Updated 19 Sept 2012
* Replication
****************************************************************************************************************
*************************
* SET CONTROL VARIABLES *
*************************

* MAIN SET OF CONTROLS (REVISIONS)*
local controls natres logvillpop logdensvil urban povrateksvil fgtksvild covyredvil npwperhh natdis ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd javanese_off_java islam split_kab03 split_vil03

*************************************************************************************************
*STANDARDIZE CONTINUOUS VARIABLES (DEMEAN AND DIVIDE BY 2 STANDARD DEVIATIONS) PER GELMAN (2007)*
*2 STANDARD DEVIATIONS ALLOWS COMPARISONS BETWEEN BINARY AND CONTINUOUS VARIABLE COEFFICIENTS   *
*************************************************************************************************

* MAIN SET OF CONTINUOUS CONTROLS (REVISIONS) WITHOUT CATEGORICAL VARS: flat urban natdis natres javanese_off_java islam 
local controls_cont altitude logvillpop logdensvil  povrateksvil fgtksvild covyredvil npwperhh ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd

foreach var of varlist `controls_cont' distpospol dispuskes dispkhelp distkec {
	egen z2_`var'=std(`var'), mean(0) std(2)
}

*STANDARDIZED MAIN SET OF CONTINUOUS CONTROLS AND NONSTANDARDIZED BINARY VARIABLES*
*DOES NOT INCLUDE THE FLAT AND Z2_ALTITUDE CONDITIONING VARIABLES, WHICH ARE TO BE ENTERED MANUALLY
local controls_z2 urban natres z2_logvillpop z2_logdensvil z2_povrateksvil z2_fgtksvild z2_covyredvil z2_npwperhh z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis javanese_off_java islam split_kab03 split_vil03

*GENERATE INTERACTIVE VARIABLES (STANDARDIZED CONTINUOUS x NONSTANDARDIZED BINARY) PER GELMAN (2007)*
g z2_dppfl=z2_distpospol*flat
g z2_dpkfl=z2_dispuskes*flat
g z2_dpkhfl=z2_dispkhelp*flat


******************************************************************************************************************************
*USE COMPOSITE OF LOWALT AND FLAT INTERACTING WITH DISTPOSPOL AS PROXY FOR EXOG VARIATION IN STATE PENETRATION VIA DISTPOSPOL*
******************************************************************************************************************************

*DETERMINE THE WEIGHTED MEAN OF ALTITUDE*
mean altitude [pw=probit_touse_wts03]
mat mn=e(b)
local mean_alt=mn[1,1]

g lowalt=0
replace lowalt=altitude<`mean_alt'

g low_flat=0
replace low_flat=lowalt==1 & flat==1

*DETERMINE THE WEIGHTED PROPORTION OF VILLAGES BELOW 500M*
g below500=0
replace below500=1 if altitude<500
mean below500 [pw=probit_touse_wts03]

*LOW & FLAT INTERACTIVE VARIABLES (STANDARDIZED CONTINUOUS X NONSTANDARDIZED BINARY)
g z2_dpplowfl=z2_distpospol*low_flat
g z2_dpklowfl=z2_dispuskes*low_flat
g z2_dpkhlowfl=z2_dispkhelp*low_flat

***************************
* FIRST STAGE ALL VILLAGES*
***************************

********************************************************************
* FIRST STAGE OF NON-INTERACTIVE AND DPP X FLAT INTERACTION MODELS *
********************************************************************

* JUST IDENTIFIED NON-INTERACTIVE MODEL
xi: reg z2_distpospol z2_dispuskes flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f1

* OVER-IDENTIFIED NON-INTERACTIVE MODEL
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f2

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: reg z2_distpospol z2_dispuskes z2_dpkfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f3a
xi: reg z2_dppfl z2_dispuskes z2_dpkfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f3b

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: reg z2_dppfl z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl flat z2_altitude `controls_rev_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f4a
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f4b

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X LOW & FLAT
xi: reg z2_distpospol z2_dispuskes z2_dpklowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f5a
xi: reg z2_dpplowfl z2_dispuskes z2_dpklowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f5b

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X LOW & FLAT W/O Z2_ALTITUDE 
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f6a
xi: reg z2_dpplowfl z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store f6b


* Full Table
estout f1 f2 f3a f3b f4a f4b f5a f5b f6a f6b using ib_firststage03_rep.xls, cells(b(star fmt(2) ) se(par(( )) fmt(2))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout f1 f2 f3a f3b f4a f4b f5a f5b f6a f6b using ib_firststage03_rep_small.xls, cells(b(star fmt(2) ) se(par(( )) fmt(2))) keep(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl) replace

* TABLE WITH B AND SE ON SAME LINE *
estout f1 f2 f3a f3b f4a f4b f5a f5b f6a f6b using ib_firststage03_rep_side.xls, cells("b(fmt(2) ) se(star par(( )) fmt(2))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl flat z2_altitude low_flat `controls_z2') replace


******************************************************************************************
* FIRST STAGE OF NON-INTERACTIVE AND DPP X FLAT INTERACTION MODELS W/ POLITICAL CONTROLS *
******************************************************************************************


* JUST IDENTIFIED NON-INTERACTIVE MODEL
xi: reg z2_distpospol z2_dispuskes flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp1

* OVER-IDENTIFIED NON-INTERACTIVE MODEL
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp2

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: reg z2_distpospol z2_dispuskes z2_dpkfl flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp3a
xi: reg z2_dppfl z2_dispuskes z2_dpkfl flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp3b

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: reg z2_dppfl z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl flat z2_altitude `controls_rev_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp4a
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp4b

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X LOW_FLAT
xi: reg z2_distpospol z2_dispuskes z2_dpklowfl low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp5a
xi: reg z2_dpplowfl z2_dispuskes z2_dpklowfl low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp5b

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X LOW_FLAT
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp6a
xi: reg z2_dpplowfl z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store fp6b


* Full Table
estout fp1 fp2 fp3a fp3b fp4a fp4b fp5a fp5b fp6a fp6b using ib_firststage03p_rep.xls, cells(b(star fmt(2) ) se(par(( )) fmt(2))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout fp1 fp2 fp3a fp3b fp4a fp4b fp5a fp5b fp6a fp6b using ib_firststage03p_rep_small.xls, cells(b(star fmt(2) ) se(par(( )) fmt(2))) keep(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl) replace

* TABLE WITH B AND SE ON SAME LINE *
estout fp1 fp2 fp3a fp3b fp4a fp4b fp5a fp5b fp6a fp6b using ib_firststage03p_rep_side.xls, cells("b(fmt(2) ) se(star par(( )) fmt(2))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl z2_dpklowfl z2_dpkhlowfl flat z2_altitude low_flat `controls_z2') replace


***********************************
* TESTING THE MODEL: ALL VILLAGES *
***********************************

************
*OLS MODELS*
************

* DISTANCE TO POLICE POST (OLS): USING FLAT AND Z2_ALTITUDE
xi: reg horiz2 z2_distpospol flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store m1

* DISTANCE TO POLICE POST AND DPP X FLAT (OLS): FLAT AND Z2_ALTITUDE
xi: reg horiz2 z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store m2

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* DISTANCE TO POLICE POST AND DPP X LOW & FLAT (OLS): LOW_FLAT INSTEAD OF FLAT OR Z2_ALTITUDE
xi: reg horiz2 z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store m3

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0
	
*************
* IV MODELS *
*************

* JUST IDENTIFIED NON-INTERACTIVE MODEL
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store m4

**************************************************************************************************
* SENSITIVITY ANALYSIS OF THE EXCLUSION RESTRICTION ON THE JUST IDENTIFIED NON-INTERACTIVE MODEL *
* PERFORM UNION OF CONFIDENCE INTERVAL PROCEDURE FROM CONLEY, HANSEN, ROSSI 2008	

	* gamma=0.00054 and confidence level 0.95
	xi: uci2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], inst(z2_dispuskes) g1min(-.00059) g1max(.00059) grid(2) level(.95) cluster(kabid03) robust

	* gamma=0.00073 and confidence level 0.9
	xi: uci2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03],  inst(z2_dispuskes) g1min(-.00078) g1max(.00078) grid(2) level(.9) cluster(kabid03) robust 
**************************************************************************************************

* OVER-IDENTIFIED NON-INTERACTIVE MODEL
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store m5

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dppfl=z2_dispuskes z2_dpkfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store m6

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dppfl=z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store m7

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X LOW & FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dpklowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store m8

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X LOW_FLAT 
xi: ivreg2 horiz2 (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store m9

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

* Full Table
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 using ib_tests03_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 using ib_tests03_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 using ib_tests03_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

**********************************
*OLS MODELS W/ POLITICAL CONTROLS*
**********************************


* DISTANCE TO POLICE POST (OLS): USING FLAT AND Z2_ALTITUDE
xi: reg horiz2 z2_distpospol flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store mp1

* DISTANCE TO POLICE POST AND DPP X FLAT (OLS): FLAT AND Z2_ALTITUDE
xi: reg horiz2 z2_distpospol z2_dppfl flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store mp2

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* DISTANCE TO POLICE POST AND DPP X LOW & FLAT (OLS): LOW_FLAT INSTEAD OF FLAT OR Z2_ALTITUDE
xi: reg horiz2 z2_distpospol z2_dpplowfl low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store mp3

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

***********************************
* IV MODELS W/ POLITICAL CONTROLS *
***********************************

* JUST IDENTIFIED NON-INTERACTIVE MODEL
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store mp4

* OVER-IDENTIFIED NON-INTERACTIVE MODEL
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store mp5

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dppfl=z2_dispuskes z2_dpkfl) flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store mp6

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dppfl=z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl) flat z2_altitude `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store mp7

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X LOW & FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dpklowfl) low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store mp8

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X LOW_FLAT 
xi: ivreg2 horiz2 (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl) low_flat `controls_z2' golkar1 pdip1 i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store mp9

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

* Full Table
estout mp1 mp2 mp3 mp4 mp5 mp6 mp7 mp8 mp9 using ib_tests03p_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout mp1 mp2 mp3 mp4 mp5 mp6 mp7 mp8 mp9 using ib_tests03p_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout mp1 mp2 mp3 mp4 mp5 mp6 mp7 mp8 mp9 using ib_tests03p_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace


***********************************
* TESTING THE MODEL: RURAL VILLAGES *
***********************************

************
*OLS MODELS*
************

* DISTANCE TO POLICE POST (OLS): USING FLAT AND Z2_ALTITUDE
xi: reg horiz2 z2_distpospol flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, cluster(kabid03)
estimates store mr1

* DISTANCE TO POLICE POST AND DPP X FLAT (OLS): FLAT AND Z2_ALTITUDE
xi: reg horiz2 z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, cluster(kabid03)
estimates store mr2

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* DISTANCE TO POLICE POST AND DPP X LOW & FLAT (OLS): LOW_FLAT INSTEAD OF FLAT OR Z2_ALTITUDE
xi: reg horiz2 z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, cluster(kabid03)
estimates store mr3

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0
	
*************
* IV MODELS *
*************

* JUST IDENTIFIED NON-INTERACTIVE MODEL
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, first cluster(kabid03)
estimates store mr4

**************************************************************************************************
* SENSITIVITY ANALYSIS OF THE EXCLUSION RESTRICTION ON THE JUST IDENTIFIED NON-INTERACTIVE MODEL *
* PERFORM UNION OF CONFIDENCE INTERVAL PROCEDURE FROM CONLEY, HANSEN, ROSSI 2008	

	* gamma=0.00054 and confidence level 0.95
	xi: uci2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, inst(z2_dispuskes) g1min(-.00054) g1max(.00054) grid(2) level(.95) cluster(kabid03) robust

	* gamma=0.00073 and confidence level 0.9
	xi: uci2 horiz2 (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0,  inst(z2_dispuskes) g1min(-.00073) g1max(.00073) grid(2) level(.9) cluster(kabid03) robust 
**************************************************************************************************

* OVER-IDENTIFIED NON-INTERACTIVE MODEL
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, first cluster(kabid03)
estimates store mr5

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dppfl=z2_dispuskes z2_dpkfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, first cluster(kabid03)
estimates store mr6

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dppfl=z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, first cluster(kabid03)
estimates store mr7

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dppfl x flat=0  
	test z2_distpospol+z2_dppfl=0

* JUST IDENTIFIED INTERACTIVE MODEL: DPP X LOW & FLAT
xi: ivreg2 horiz2 (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dpklowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, first cluster(kabid03)
estimates store mr8

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

* OVER-IDENTIFIED INTERACTIVE MODEL: DPP X LOW_FLAT 
xi: ivreg2 horiz2 (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03] if urban==0, first cluster(kabid03)
estimates store mr9

	* SIGNIFICANCE OF MARGINAL EFFECT OF INTERACTIVE VARIABLES                                
	* Test if distpospol decreases horiz2.  H0: b_distpospol + b_dpplowfl x low_flat=0  
	test z2_distpospol+z2_dpplowfl=0

* Full Table
estout mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 mr9 using ib_testsr03_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 mr9 using ib_testsr03_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 mr9 using ib_testsr03_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace


******************************************************************************
* TEST CLAIM THAT COMMUNITY CAPACITY SHOULD BE HIGHER FARTHER FROM THE STATE *
******************************************************************************

xi: reg tot_hansip z2_distpospol flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store cc1

xi: reg tot_hansip z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
test z2_distpospol+z2_dppfl=0
estimates store cc2

xi: reg tot_hansip z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
test z2_distpospol+z2_dpplowfl=0
estimates store cc3

xi: ivreg2 tot_hansip (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] , first cluster(kabid03)
estimates store cc4

xi: ivreg2 tot_hansip (z2_distpospol z2_dppfl=z2_dispuskes z2_dpkfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
test z2_distpospol+z2_dppfl=0
estimates store cc5

xi: ivreg2 tot_hansip (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dpklowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
test z2_distpospol+z2_dpplowfl=0
estimates store cc6

xi: ivreg2 tot_hansip (z2_distpospol=z2_dispuskes z2_dispkhelp) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
estimates store cc7

xi: ivreg2 tot_hansip (z2_distpospol z2_dppfl=z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
test z2_distpospol+z2_dppfl=0
estimates store cc8

xi: ivreg2 tot_hansip (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03], first cluster(kabid03)
test z2_distpospol+z2_dpplowfl=0
estimates store cc9

* Full Table
estout cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 using ib_testscc03_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 using ib_testscc03_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 using ib_testscc03_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace




***********************************************************************************************
* TEST CLAIM THAT NON-STATE RESPONSES TO CONFLICT SHOULD BE GREATER FARTHER FROM POLICE POSTS *
***********************************************************************************************

**************************
* NON-INTERACTIVE MODELS *
**************************

xi: reg non_sf_res z2_distpospol flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, cluster(kabid03)
estimates store ns1

***************************
* FLAT-INTERACTIVE MODELS *
***************************

xi: reg non_sf_res z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, cluster(kabid03)
test z2_distpospol+z2_dppfl=0
estimates store ns2

*******************************
* LOW_FLAT-INTERACTIVE MODELS *
*******************************
xi: reg non_sf_res z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, cluster(kabid03)
test z2_distpospol+z2_dpplowfl=0
estimates store ns3

********************************************
* JUST IDENTIFIED - NON-INTERACTIVE MODELS *
********************************************

xi: ivreg2 non_sf_res (z2_distpospol=z2_dispuskes) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, first cluster(kabid03)
estimates store ns4


*********************************************
* JUST IDENTIFIED - FLAT-INTERACTIVE MODELS *
*********************************************

xi: ivreg2 non_sf_res (z2_distpospol z2_dppfl=z2_dispuskes z2_dpkfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, first cluster(kabid03)
test z2_distpospol+z2_dppfl=0
estimates store ns5


*************************************************
* JUST IDENTIFIED - LOW_FLAT-INTERACTIVE MODELS *
*************************************************

xi: ivreg2 non_sf_res (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dpklowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, first cluster(kabid03)
test z2_distpospol+z2_dpplowfl=0
estimates store ns6


********************************************
* OVER IDENTIFIED - NON-INTERACTIVE MODELS *
********************************************

xi: ivreg2 non_sf_res (z2_distpospol=z2_dispuskes z2_dispkhelp) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, first cluster(kabid03)
estimates store ns7

*********************************************
* OVER IDENTIFIED - FLAT-INTERACTIVE MODELS *
*********************************************

xi: ivreg2 non_sf_res (z2_distpospol z2_dppfl=z2_dispuskes z2_dispkhelp z2_dpkfl z2_dpkhfl) flat z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, first cluster(kabid03)
test z2_distpospol+z2_dppfl=0
estimates store ns8

*************************************************
* OVER IDENTIFIED - LOW_FLAT-INTERACTIVE MODELS *
*************************************************

xi: ivreg2 non_sf_res (z2_distpospol z2_dpplowfl=z2_dispuskes z2_dispkhelp z2_dpklowfl z2_dpkhlowfl) low_flat `controls_z2' i.prop [pw=probit_touse_wts03] if horiz2==1, first cluster(kabid03)
test z2_distpospol+z2_dpplowfl=0
estimates store ns9


* Full Table
estout ns1 ns2 ns3 ns4 ns5 ns6 ns7 ns8 ns9 using ib_testsns03_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout ns1 ns2 ns3 ns4 ns5 ns6 ns7 ns8 ns9 using ib_testsns03_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout ns1 ns2 ns3 ns4 ns5 ns6 ns7 ns8 ns9 using ib_testsns03_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS IV IV IV IV IV IV, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace


*************************************************************
*HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE *
*************************************************************

g dpp_alt=distpospol*altitude
g dpk_alt=dispuskes*altitude
g dpkh_alt=dispkhelp*altitude

*Make Heterogeneous Marginal Effects CI Graph over Altitude*
local max_alt=3000
local interval=50
local num_vals=`max_alt'/`interval'+1
matrix dpp_alt_me=J(`num_vals',1,.)
matrix colnames dpp_alt_me = alt 
matrix dpp_alt_me[1,1]=[0]
forvalues i=2/`num_vals' {
	matrix dpp_alt_me[`i',1]=[(`i'-1)*`interval']
}
svmat dpp_alt_me, names(col)


* HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE IN FLAT & NON-FLAT VILLAGES *

xi: ivreg2 horiz2 (distpospol dpp_alt=dispuskes dispkhelp dpk_alt dpkh_alt) altitude flat `controls' i.prop [pw=probit_touse_wts03], first cluster(kabid03) 
estimates store he1
test distpospol + dpp_alt=0

g dhoriz2dx=_b[distpospol]+_b[dpp_alt]*alt
matrix varcov=get(VCE)
g cov_dpp_dppalt=varcov[2,1]
g vardh2dx=(_se[distpospol]^2)+(alt^2)*(_se[dpp_alt]^2)+2*alt*cov_dpp_dppalt
g sedh2dx=sqrt(vardh2dx)
g LBdh2dx=dhoriz2dx-invttail(e(df_m),.025)*sedh2dx
g UBdh2dx=dhoriz2dx+invttail(e(df_m),.025)*sedh2dx

twoway rarea LBdh2dx UBdh2dx alt, sort color(gs14)  || line dhoriz2dx alt, color(black) xtick(0(500)3000) legend(off) ytitle("dCV/dDP") xtitle("Altitude (m)") title("All villages (2001)") saving(me_dpp_alt, replace)
graph export me_dpp_alt.tif, replace

* HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE IN FLAT VILLAGES *

xi: ivreg2 horiz2 (distpospol dpp_alt=dispuskes dispkhelp dpk_alt dpkh_alt) altitude `controls' i.prop [pw=probit_touse_wts03] if flat==1, first cluster(kabid03) 
estimates store he2
test distpospol + dpp_alt=0

g dhoriz2dx_fl=_b[distpospol]+_b[dpp_alt]*alt
matrix varcov=get(VCE)
g cov_dpp_dppalt_fl=varcov[2,1]
g vardh2dx_fl=(_se[distpospol]^2)+(alt^2)*(_se[dpp_alt]^2)+2*alt*cov_dpp_dppalt_fl
g sedh2dx_fl=sqrt(vardh2dx_fl)
g LBdh2dx_fl=dhoriz2dx_fl-invttail(e(df_m),.025)*sedh2dx_fl
g UBdh2dx_fl=dhoriz2dx_fl+invttail(e(df_m),.025)*sedh2dx_fl

twoway rarea LBdh2dx_fl UBdh2dx_fl alt, sort color(gs14)  || line dhoriz2dx_fl alt, color(black) xtick(0(500)3000) legend(off) ytitle("dCV/dDP") xtitle("Altitude (m)") title("Flat Villages (2001)") saving(me_dpp_alt_fl, replace)
graph export me_dpp_alt_fl.tif, replace


* HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE IN FLAT VILLAGES *

xi: ivreg2 horiz2 (distpospol dpp_alt=dispuskes dispkhelp dpk_alt dpkh_alt) altitude `controls' i.prop [pw=probit_touse_wts03] if flat==0, first cluster(kabid03) 
estimates store he3
test distpospol + dpp_alt=0

g dhoriz2dx_nofl=_b[distpospol]+_b[dpp_alt]*alt
matrix varcov=get(VCE)
g cov_dpp_dppalt_nofl=varcov[2,1]
g vardh2dx_nofl=(_se[distpospol]^2)+(alt^2)*(_se[dpp_alt]^2)+2*alt*cov_dpp_dppalt_nofl
g sedh2dx_nofl=sqrt(vardh2dx_nofl)
g LBdh2dx_nofl=dhoriz2dx_nofl-invttail(e(df_m),.025)*sedh2dx_nofl
g UBdh2dx_nofl=dhoriz2dx_nofl+invttail(e(df_m),.025)*sedh2dx_nofl

twoway rarea LBdh2dx_nofl UBdh2dx_nofl alt, sort color(gs14)  || line dhoriz2dx_nofl alt, color(black) xtick(0(500)3000) legend(off) ytitle("dCV/dDP") xtitle("Altitude (m)") title("Hilly Villages (2001)") saving(me_dpp_alt_nfl, replace)
graph export me_dpp_alt_nfl.tif, replace

graph combine me_dpp_alt.gph me_dpp_alt_fl.gph me_dpp_alt_nfl.gph, xcommon saving(me_dpp_alt_comb, replace)

*************************
* HETEROGENEOUS EFFECTS *
*************************


* MAKE HETEROGENEOUS MARGINAL EFFECTS CI GRAPH OF DISTPOSPOL OVER ETHFRACTVIL IN LOW_FLAT AND NON-LOW_FLAT VILLAGES

local max_efv=1
local interval_efv=.02
local num_val_efv=`max_efv'/`interval_efv'+1
matrix dpp_efv_me=J(`num_val_efv',1,.)
matrix colnames dpp_efv_me = efv 
matrix dpp_efv_me[1,1]=[0]
forvalues i=2/`num_val_efv' {
	matrix dpp_efv_me[`i',1]=[(`i'-1)*`interval_efv']
}
svmat dpp_efv_me, names(col)

g dpp_efv=distpospol*ethfractvil
g dpk_efv=dispuskes*ethfractvil
g dpkh_efv=dispkhelp*ethfractvil

*LOW_FLAT AND NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_efv=dispuskes dispkhelp dpk_efv dpkh_efv) flat altitude `controls' i.prop [pw=probit_touse_wts03], first cluster(kabid03) 
estimates store he4
test distpospol + dpp_efv=0

g dhoriz2dxefv=_b[distpospol]+_b[dpp_efv]*efv
matrix varcov=get(VCE)
g cov_dpp_dppefv=varcov[2,1]
g vardh2dxefv=(_se[distpospol]^2)+(efv^2)*(_se[dpp_efv]^2)+2*efv*cov_dpp_dppefv
g sedh2dxefv=sqrt(vardh2dxefv)
g LBdh2dxefv=dhoriz2dxefv-invttail(e(df_m),.025)*sedh2dxefv
g UBdh2dxefv=dhoriz2dxefv+invttail(e(df_m),.025)*sedh2dxefv

twoway rarea LBdh2dxefv UBdh2dxefv efv, sort color(gs14)  || line dhoriz2dxefv efv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Ethnic Fractionalization of Village") title("All Villages (2001)") saving(me_dpp_efv, replace)
graph export me_dpp_efv.tif, replace

*LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_efv=dispuskes dispkhelp dpk_efv dpkh_efv) `controls' i.prop [pw=probit_touse_wts03] if low_flat==1, first cluster(kabid03) 
estimates store he5
test distpospol + dpp_efv=0

g dhoriz2dxefv_lf=_b[distpospol]+_b[dpp_efv]*efv
matrix varcov=get(VCE)
g cov_dpp_dppefv_lf=varcov[2,1]
g vardh2dxefv_lf=(_se[distpospol]^2)+(efv^2)*(_se[dpp_efv]^2)+2*efv*cov_dpp_dppefv_lf
g sedh2dxefv_lf=sqrt(vardh2dxefv_lf)
g LBdh2dxefv_lf=dhoriz2dxefv_lf-invttail(e(df_m),.025)*sedh2dxefv_lf
g UBdh2dxefv_lf=dhoriz2dxefv_lf+invttail(e(df_m),.025)*sedh2dxefv_lf

twoway rarea LBdh2dxefv_lf UBdh2dxefv_lf efv, sort color(gs14)  || line dhoriz2dxefv_lf efv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Ethnic Fractionalization of Village") title("Flat Villages" "Below Mean Altitude (2001)") saving(me_dpp_efv_lf, replace)
graph export me_dpp_efv_lf.tif, replace

*NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_efv=dispuskes dispkhelp dpk_efv dpkh_efv) `controls' i.prop [pw=probit_touse_wts03] if low_flat==0, first cluster(kabid03) 
estimates store he6
test distpospol + dpp_efv=0

g dhoriz2dxefv_nlf=_b[distpospol]+_b[dpp_efv]*efv
matrix varcov=get(VCE)
g cov_dpp_dppefv_nlf=varcov[2,1]
g vardh2dxefv_nlf=(_se[distpospol]^2)+(efv^2)*(_se[dpp_efv]^2)+2*efv*cov_dpp_dppefv_nlf
g sedh2dxefv_nlf=sqrt(vardh2dxefv_nlf)
g LBdh2dxefv_nlf=dhoriz2dxefv_nlf-invttail(e(df_m),.025)*sedh2dxefv_nlf
g UBdh2dxefv_nlf=dhoriz2dxefv_nlf+invttail(e(df_m),.025)*sedh2dxefv_nlf

twoway rarea LBdh2dxefv_nlf UBdh2dxefv_nlf efv, sort color(gs14)  || line dhoriz2dxefv_nlf efv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Ethnic Fractionalization of Village") title("Villages that are Hilly or" "Above Mean Altitude (2001)") saving(me_dpp_efv_nlf, replace)
graph export me_dpp_efv_nlf.tif, replace

graph combine me_dpp_efv.gph me_dpp_efv_lf.gph me_dpp_efv_nlf.gph, xcommon saving(me_dpp_efv_comb, replace)
graph combine me_dpp_efv_lf.gph me_dpp_efv_nlf.gph, xcommon saving(me_dpp_efv_comb2, replace)


* MAKE HETEROGENEOUS MARGINAL EFFECTS CI GRAPH OF DISTPOSPOL OVER RELFRACTVIL IN LOW_FLAT AND NON-LOW_FLAT VILLAGES

local max_rfv=1
local interval_rfv=.02
local num_val_rfv=`max_rfv'/`interval_rfv'+1
matrix dpp_rfv_me=J(`num_val_rfv',1,.)
matrix colnames dpp_rfv_me = rfv 
matrix dpp_rfv_me[1,1]=[0]
forvalues i=2/`num_val_rfv' {
	matrix dpp_rfv_me[`i',1]=[(`i'-1)*`interval_rfv']
}
svmat dpp_rfv_me, names(col)

g dpp_rfv=distpospol*relfractvil
g dpk_rfv=dispuskes*relfractvil
g dpkh_rfv=dispkhelp*relfractvil

*LOW_FLAT AND NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_rfv=dispuskes dispkhelp dpk_rfv dpkh_rfv)  flat altitude  `controls' i.prop [pw=probit_touse_wts03], first cluster(kabid03) 
estimates store he7
test distpospol + dpp_rfv=0

g dhoriz2dxrfv=_b[distpospol]+_b[dpp_rfv]*rfv
matrix varcov=get(VCE)
g cov_dpp_dpprfv=varcov[2,1]
g vardh2dxrfv=(_se[distpospol]^2)+(rfv^2)*(_se[dpp_rfv]^2)+2*rfv*cov_dpp_dpprfv
g sedh2dxrfv=sqrt(vardh2dxrfv)
g LBdh2dxrfv=dhoriz2dxrfv-invttail(e(df_m),.025)*sedh2dxrfv
g UBdh2dxrfv=dhoriz2dxrfv+invttail(e(df_m),.025)*sedh2dxrfv

twoway rarea LBdh2dxrfv UBdh2dxrfv rfv, sort color(gs14)  || line dhoriz2dxrfv rfv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Religious Fractionalization of Village") title("All Villages (2001)") saving(me_dpp_rfv, replace)
graph export me_dpp_rfv.tif, replace

*LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_rfv=dispuskes dispkhelp dpk_rfv dpkh_rfv) `controls' i.prop [pw=probit_touse_wts03] if low_flat==1, first cluster(kabid03) 
estimates store he8
test distpospol + dpp_rfv=0

g dhoriz2dxrfv_lf=_b[distpospol]+_b[dpp_rfv]*rfv
matrix varcov=get(VCE)
g cov_dpp_dpprfv_lf=varcov[2,1]
g vardh2dxrfv_lf=(_se[distpospol]^2)+(rfv^2)*(_se[dpp_rfv]^2)+2*rfv*cov_dpp_dpprfv_lf
g sedh2dxrfv_lf=sqrt(vardh2dxrfv_lf)
g LBdh2dxrfv_lf=dhoriz2dxrfv_lf-invttail(e(df_m),.025)*sedh2dxrfv_lf
g UBdh2dxrfv_lf=dhoriz2dxrfv_lf+invttail(e(df_m),.025)*sedh2dxrfv_lf

twoway rarea LBdh2dxrfv_lf UBdh2dxrfv_lf rfv, sort color(gs14)  || line dhoriz2dxrfv_lf rfv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Religious Fractionalization of Village") title("Flat Villages" "Below Mean Altitude (2001)") saving(me_dpp_rfv_lf, replace)
graph export me_dpp_rfv_lf.tif, replace

*NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_rfv=dispuskes dispkhelp dpk_rfv dpkh_rfv) `controls' i.prop [pw=probit_touse_wts03] if low_flat==0, first cluster(kabid03) 
estimates store he9
test distpospol + dpp_rfv=0

g dhoriz2dxrfv_nlf=_b[distpospol]+_b[dpp_rfv]*rfv
matrix varcov=get(VCE)
g cov_dpp_dpprfv_nlf=varcov[2,1]
g vardh2dxrfv_nlf=(_se[distpospol]^2)+(rfv^2)*(_se[dpp_rfv]^2)+2*rfv*cov_dpp_dpprfv_nlf
g sedh2dxrfv_nlf=sqrt(vardh2dxrfv_nlf)
g LBdh2dxrfv_nlf=dhoriz2dxrfv_nlf-invttail(e(df_m),.025)*sedh2dxrfv_nlf
g UBdh2dxrfv_nlf=dhoriz2dxrfv_nlf+invttail(e(df_m),.025)*sedh2dxrfv_nlf

twoway rarea LBdh2dxrfv_nlf UBdh2dxrfv_nlf rfv, sort color(gs14)  || line dhoriz2dxrfv_nlf rfv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Religious Fractionalization of Village") title("Villages that are Hilly or" "Above Mean Altitude (2001)") saving(me_dpp_rfv_nlf, replace)
graph export me_dpp_rfv_nlf.tif, replace

graph combine me_dpp_rfv.gph me_dpp_rfv_lf.gph me_dpp_rfv_nlf.gph, xcommon saving(me_dpp_rfv_comb, replace)
graph combine me_dpp_rfv_lf.gph me_dpp_rfv_nlf.gph, xcommon saving(me_dpp_rfv_comb2, replace)


* MAKE HETEROGENEOUS MARGINAL EFFECTS CI GRAPH OF DISTPOSPOL OVER POVRATEKSVIL IN LOW_FLAT AND NON-LOW_FLAT VILLAGES

local max_prv=1
local interval_prv=.02
local num_val_prv=`max_prv'/`interval_prv'+1
matrix dpp_prv_me=J(`num_val_prv',1,.)
matrix colnames dpp_prv_me = prv 
matrix dpp_prv_me[1,1]=[0]
forvalues i=2/`num_val_prv' {
	matrix dpp_prv_me[`i',1]=[(`i'-1)*`interval_prv']
}
svmat dpp_prv_me, names(col)

g dpp_prv=distpospol*povrateksvil
g dpk_prv=dispuskes*povrateksvil
g dpkh_prv=dispkhelp*povrateksvil

*HETEROGENEOUS EFFECTS IN LOW_FLAT AND NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_prv=dispuskes dispkhelp dpk_prv dpkh_prv) flat altitude `controls' i.prop [pw=probit_touse_wts03], first cluster(kabid03) 
estimates store he10
test distpospol + dpp_prv = 0

g dhoriz2dxprv=_b[distpospol]+_b[dpp_prv]*prv
matrix varcov=get(VCE)
g cov_dpp_dppprv=varcov[2,1]
g vardh2dxprv=(_se[distpospol]^2)+(prv^2)*(_se[dpp_prv]^2)+2*prv*cov_dpp_dppprv
g sedh2dxprv=sqrt(vardh2dxprv)
g LBdh2dxprv=dhoriz2dxprv-invttail(e(df_m),.025)*sedh2dxprv
g UBdh2dxprv=dhoriz2dxprv+invttail(e(df_m),.025)*sedh2dxprv

twoway rarea LBdh2dxprv UBdh2dxprv prv, sort color(gs14)  || line dhoriz2dxprv prv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Poverty Rate of Village") title("All Villages (2001)") saving(me_dpp_prv, replace)
graph export me_dpp_prv.tif, replace

*LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_prv=dispuskes dispkhelp dpk_prv dpkh_prv) `controls' i.prop [pw=probit_touse_wts03] if low_flat==1, first cluster(kabid03) 
estimates store he11
test distpospol + dpp_prv = 0

g dhoriz2dxprv_lf=_b[distpospol]+_b[dpp_prv]*prv
matrix varcov=get(VCE)
g cov_dpp_dppprv_lf=varcov[2,1]
g vardh2dxprv_lf=(_se[distpospol]^2)+(prv^2)*(_se[dpp_prv]^2)+2*prv*cov_dpp_dppprv_lf
g sedh2dxprv_lf=sqrt(vardh2dxprv_lf)
g LBdh2dxprv_lf=dhoriz2dxprv_lf-invttail(e(df_m),.025)*sedh2dxprv_lf
g UBdh2dxprv_lf=dhoriz2dxprv_lf+invttail(e(df_m),.025)*sedh2dxprv_lf

twoway rarea LBdh2dxprv_lf UBdh2dxprv_lf prv, sort color(gs14)  || line dhoriz2dxprv_lf prv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Poverty Rate of Village") title("Flat Villages Below" "Mean Altitude (2001)") saving(me_dpp_prv_lf, replace)
graph export me_dpp_prv_lf.tif, replace

*NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_prv=dispuskes dispkhelp dpk_prv dpkh_prv) `controls' i.prop [pw=probit_touse_wts03] if low_flat==0, first cluster(kabid03) 
estimates store he12
test distpospol + dpp_prv = 0

g dhoriz2dxprv_nlf=_b[distpospol]+_b[dpp_prv]*prv
matrix varcov=get(VCE)
g cov_dpp_dppprv_nlf=varcov[2,1]
g vardh2dxprv_nlf=(_se[distpospol]^2)+(prv^2)*(_se[dpp_prv]^2)+2*prv*cov_dpp_dppprv_nlf
g sedh2dxprv_nlf=sqrt(vardh2dxprv_nlf)
g LBdh2dxprv_nlf=dhoriz2dxprv_nlf-invttail(e(df_m),.025)*sedh2dxprv_nlf
g UBdh2dxprv_nlf=dhoriz2dxprv_nlf+invttail(e(df_m),.025)*sedh2dxprv_nlf

twoway rarea LBdh2dxprv_nlf UBdh2dxprv_nlf prv, sort color(gs14)  || line dhoriz2dxprv_nlf prv, color(black) xtick(0(.1)1) legend(off) ytitle("dCV/dDP") xtitle("Poverty Rate of Village") title("Villages that are Hilly or" "Above Mean Altitude (2001)") saving(me_dpp_prv_nlf, replace)
graph export me_dpp_prv_nlf.tif, replace

graph combine me_dpp_prv.gph me_dpp_prv_lf.gph me_dpp_prv_nlf.gph, xcommon saving(me_dpp_prv_comb, replace)
graph combine me_dpp_prv_lf.gph me_dpp_prv_nlf.gph, xcommon saving(me_dpp_prv_comb2, replace)


*LOOK AT THE HETEROGENEOUS EFFECTS OVER INEQUALITY

* MAKE HETEROGENEOUS MARGINAL EFFECTS CI GRAPH OF DISTPOSPOL OVER POVRATEKSVIL IN LOW_FLAT AND NON-LOW_FLAT VILLAGES

local max_cye=.5
local interval_cye=.01
local num_val_cye=`max_cye'/`interval_cye'+1
matrix dpp_cye_me=J(`num_val_cye',1,.)
matrix colnames dpp_cye_me = cye 
matrix dpp_cye_me[1,1]=[0]
forvalues i=2/`num_val_cye' {
	matrix dpp_cye_me[`i',1]=[(`i'-1)*`interval_cye']
}
svmat dpp_cye_me, names(col)

g dpp_cye=distpospol*covyredvil
g dpk_cye=dispuskes*covyredvil
g dpkh_cye=dispkhelp*covyredvil

*HETEROGENEOUS EFFECTS IN LOW_FLAT AND NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_cye=dispuskes dispkhelp dpk_cye dpkh_cye) flat altitude `controls' i.prop [pw=probit_touse_wts03], first cluster(kabid03) 
estimates store he13
test distpospol + dpp_cye = 0

g dhoriz2dxcye=_b[distpospol]+_b[dpp_cye]*cye
matrix varcov=get(VCE)
g cov_dpp_dppcye=varcov[2,1]
g vardh2dxcye=(_se[distpospol]^2)+(cye^2)*(_se[dpp_cye]^2)+2*cye*cov_dpp_dppcye
g sedh2dxcye=sqrt(vardh2dxcye)
g LBdh2dxcye=dhoriz2dxcye-invttail(e(df_m),.025)*sedh2dxcye
g UBdh2dxcye=dhoriz2dxcye+invttail(e(df_m),.025)*sedh2dxcye

twoway rarea LBdh2dxcye UBdh2dxcye cye, sort color(gs14)  || line dhoriz2dxcye cye, color(black) xtick(0(.05).5) legend(off) ytitle("dCV/dDP") xtitle("Village Inequality") title("All Villages (2001)") saving(me_dpp_cye, replace)
graph export me_dpp_cye.tif, replace

*LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_cye=dispuskes dispkhelp dpk_cye dpkh_cye) `controls' i.prop [pw=probit_touse_wts03] if low_flat==1, first cluster(kabid03) 
estimates store he14
test distpospol + dpp_cye = 0

g dhoriz2dxcye_lf=_b[distpospol]+_b[dpp_cye]*cye
matrix varcov=get(VCE)
g cov_dpp_dppcye_lf=varcov[2,1]
g vardh2dxcye_lf=(_se[distpospol]^2)+(cye^2)*(_se[dpp_cye]^2)+2*cye*cov_dpp_dppcye_lf
g sedh2dxcye_lf=sqrt(vardh2dxcye_lf)
g LBdh2dxcye_lf=dhoriz2dxcye_lf-invttail(e(df_m),.025)*sedh2dxcye_lf
g UBdh2dxcye_lf=dhoriz2dxcye_lf+invttail(e(df_m),.025)*sedh2dxcye_lf

twoway rarea LBdh2dxcye_lf UBdh2dxcye_lf cye, sort color(gs14)  || line dhoriz2dxcye_lf cye, color(black) xtick(0(.05).5) legend(off) ytitle("dCV/dDP") xtitle("Village Inequality") title("Flat Villages Below" "Mean Altitude (2001)") saving(me_dpp_cye_lf, replace)
graph export me_dpp_cye_lf.tif, replace

*NON-LOW_FLAT VILLAGES

xi: ivreg2 horiz2 (distpospol dpp_cye=dispuskes dispkhelp dpk_cye dpkh_cye) `controls' i.prop [pw=probit_touse_wts03] if low_flat==0, first cluster(kabid03) 
estimates store he15
test distpospol + dpp_cye = 0

g dhoriz2dxcye_nlf=_b[distpospol]+_b[dpp_cye]*cye
matrix varcov=get(VCE)
g cov_dpp_dppcye_nlf=varcov[2,1]
g vardh2dxcye_nlf=(_se[distpospol]^2)+(cye^2)*(_se[dpp_cye]^2)+2*cye*cov_dpp_dppcye_nlf
g sedh2dxcye_nlf=sqrt(vardh2dxcye_nlf)
g LBdh2dxcye_nlf=dhoriz2dxcye_nlf-invttail(e(df_m),.025)*sedh2dxcye_nlf
g UBdh2dxcye_nlf=dhoriz2dxcye_nlf+invttail(e(df_m),.025)*sedh2dxcye_nlf

twoway rarea LBdh2dxcye_nlf UBdh2dxcye_nlf cye, sort color(gs14)  || line dhoriz2dxcye_nlf cye, color(black) xtick(0(.05).5) legend(off) ytitle("dCV/dDP") xtitle("Village Inequality") title("Villages that are Hilly or" "Above Mean Altitude (2001)") saving(me_dpp_cye_nlf, replace)
graph export me_dpp_cye_nlf.tif, replace

graph combine me_dpp_cye.gph me_dpp_cye_lf.gph me_dpp_cye_nlf.gph, xcommon saving(me_dpp_cye_comb, replace)
graph combine me_dpp_cye_lf.gph me_dpp_cye_nlf.gph, xcommon saving(me_dpp_cye_comb2, replace)

graph combine me_dpp_efv.gph me_dpp_rfv.gph me_dpp_prv.gph me_dpp_cye.gph , saving(me_dpp03_hecomb, replace)
graph export me_dpp03_hecomb.tif, replace

* Full Table
estout he1 he2 he3 he4 he5 he6 he7 he8 he9 he10 he11 he12 he13 he14 he15 using ib_hetests03_rep.xls, cells(b(star fmt(5) ) se(par(( )) fmt(5))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) numbers order(distpospol `controls') replace

* Small Table
estout he1 he2 he3 he4 he5 he6 he7 he8 he9 he10 he11 he12 he13 he14 he15 using ib_hetests03_rep_small.xls, cells(b(star fmt(5) ) se(par(( )) fmt(5))) keep(distpospol _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) numbers order(distpospol ) replace

* TABLE WITH B AND SE ON SAME LINE *
estout he1 he2 he3 he4 he5 he6 he7 he8 he9 he10 he11 he12 he13 he14 he15 using ib_hetests03_rep_side.xls, cells("b(fmt(5) ) se(star par(( )) fmt(5))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) numbers order(distpospol `controls') replace


***************************************************************************
*SEPARATE FLAT AND NON-FLAT SAMPLES AND USE IVPROBIT				   	  *
*COMPARE WITH 2SLS FOR SEPARATED SAMPLES TO ENSURE SIMILAR STANDARD ERRORS*
*THEN ASSESS PREDICTIVE CAPABILITY OF THE MODEL PER WARD ET AL (2010)	  *
***************************************************************************

**************************************************************************************************************
* COMPARE 2SLS MODELS WITH IVPROBIT (MLE) TO SEE IF HETEROSKEDASTICITY AFFECTS STANDARD ERRORS SIGNIFICANTLY *
* BECAUSE MLE DOES NOT CONVERGE FOR INTERACTIVE TERMS, SEPARATE SAMPLE INTO FLAT AND LOW_FLAT AREAS:         *
**************************************************************************************************************

* JUST IDENTIFIED 2SLS MODEL (FLAT & NON-FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store c1a

* JUST IDENTIFIED IVPROBIT MODEL, MLE (FLAT & NON-FLAT)
xi: ivprobit horiz2 z2_altitude `controls_z2' i.prop (z2_distpospol=z2_dispuskes) [pw=probit_touse_wts03], cluster(kabid03)
estimates store c1b

* OVER-IDENTIFIED 2SLS MODEL (FLAT & NON-FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) z2_altitude `controls_z2' i.prop [pw=probit_touse_wts03], cluster(kabid03)
estimates store c2a

* OVER-IDENTIFIED IVPROBIT MODEL, MLE (FLAT & NON-FLAT)
xi: ivprobit horiz2 z2_altitude `controls_z2' i.prop (z2_distpospol=z2_dispuskes z2_dispkhelp) [pw=probit_touse_wts03], cluster(kabid03)
estimates store c2b

* JUST IDENTIFIED 2SLS MODEL (FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) z2_altitude `controls_z2' i.prop if flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c3a

* JUST IDENTIFIED IVPROBIT MODEL, MLE (FLAT)
xi: ivprobit horiz2 z2_altitude `controls_z2' i.prop (z2_distpospol=z2_dispuskes) if flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c3b

* OVER-IDENTIFIED 2SLS MODEL (FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) z2_altitude `controls_z2' i.prop if flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c4a

* OVER-IDENTIFIED IVPROBIT MODEL, MLE (FLAT)
xi: ivprobit horiz2 z2_altitude `controls_z2' i.prop (z2_distpospol=z2_dispuskes z2_dispkhelp) if flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c4b

* JUST IDENTIFIED 2SLS MODEL (LOW_FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) `controls_z2' i.prop if low_flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c5a

* JUST IDENTIFIED IVPROBIT MODEL (LOW_FLAT)
xi: ivprobit horiz2 `controls_z2' i.prop (z2_distpospol=z2_dispuskes) if low_flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c5b

* OVER-IDENTIFIED 2SLS MODEL (LOW_FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) `controls_z2' i.prop if low_flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c6a

* OVER-IDENTIFIED IVPROBIT MODEL, MLE (LOW_FLAT)
xi: ivprobit horiz2 `controls_z2' i.prop (z2_distpospol=z2_dispuskes z2_dispkhelp) if low_flat==1 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c6b

* JUST IDENTIFIED 2SLS MODEL (NON-FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) z2_altitude `controls_z2' i.prop if flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c7a

* JUST IDENTIFIED IVPROBIT MODEL, MLE (NON-FLAT)
xi: ivprobit horiz2 z2_altitude `controls_z2' i.prop (z2_distpospol=z2_dispuskes) if flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c7b

* OVER-IDENTIFIED 2SLS MODEL (NON-FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) z2_altitude `controls_z2' i.prop if flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c8a

* OVER-IDENTIFIED IVPROBIT MODEL, MLE (NON-FLAT)
xi: ivprobit horiz2 z2_altitude `controls_z2' i.prop (z2_distpospol=z2_dispuskes z2_dispkhelp) if flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c8b

* JUST IDENTIFIED 2SLS MODEL (NON-LOW_FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes) `controls_z2' i.prop if low_flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c9a

* JUST IDENTIFIED IVPROBIT MODEL (NON-LOW_FLAT)
xi: ivprobit horiz2 `controls_z2' i.prop (z2_distpospol=z2_dispuskes) if low_flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c9b

* OVER-IDENTIFIED 2SLS MODEL (NON-LOW_FLAT)
xi: ivreg2 horiz2 (z2_distpospol=z2_dispuskes z2_dispkhelp) `controls_z2' i.prop if low_flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c10a

* OVER-IDENTIFIED IVPROBIT MODEL, MLE (NON-LOW_FLAT)
xi: ivprobit horiz2 `controls_z2' i.prop (z2_distpospol=z2_dispuskes z2_dispkhelp) if low_flat==0 [pw=probit_touse_wts03], cluster(kabid03)
estimates store c10b

* Full Table
estout c1a c1b c2a c2b c3a c3b c4a c4b c5a c5b c6a c6b c7a c7b c8a c8b c9a c9b c10a c10b using ib_comptests03_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP , depvars) numbers order(z2_distpospol `controls_z2') replace

* Small Table
estout c1a c1b c2a c2b c3a c3b c4a c4b c5a c5b c6a c6b c7a c7b c8a c8b c9a c9b c10a c10b using ib_comptests03_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP, depvars) numbers order(z2_distpospol ) replace

* TABLE WITH B AND SE ON SAME LINE *
estout c1a c1b c2a c2b c3a c3b c4a c4b c5a c5b c6a c6b c7a c7b c8a c8b c9a c9b c10a c10b using ib_comptests03_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP 2SLS IVP, depvars) numbers order(z2_distpospol `controls_z2') replace



****************************************************************************************************
*CALCULATE PREDICTIVE POWER OF IVPROBIT MODEL USING ROC APPROACH OF WARD, GREENHILL, & BAKKE (2010)*
*THE COMPARISON OF THE PREDICTIVE POWER OF ENDOGENOUS VARIABLE WITH OTHER COVARIATES IS IMPERFECT. * 
*ALTHOUGH IT IS IMPERFECT, WE CAN USE THE PREDICTED VALUES OF DISTPOSPOL TO COMPARE RELATIVE       *
*PREDICTIVE VALUES OF DISTPOSPOL TO THE COVARIATES. THE PREDICTED VALUES LOSE SOME OF THE VARIATION*
*OF THE ACTUAL VALUES, SO IT MAY NOT BE THE BEST MEASURE OF THE TRUE PREDICTIVE VALUE OF DISTPOSPOL*
*RATHER, BECAUSE IT IS THE LOCAL AVERAGE TREATMENT EFFECT OF DISTPOSPOL ON HORIZ2, IT DOES NOT     *
*ACCOUNT FOR THE VARIATION IN DISTPOSPOL THAT IS NOT RESPONSIVE TO THE INSTRUMENTS.                * 
****************************************************************************************************


*ESTIMATE FIRST STAGE & GENERATE PREDICTIONS FOR ENDOGENOUS VARIABLE DPP_HAT*
xi: reg z2_distpospol z2_dispuskes z2_dispkhelp `controls_z2' i.prop [pw=probit_touse_wts03] if low_flat==1, cluster(kabid03)
predict z2_dpp_hat

*THE PREDICTIVE POWER USING THE OBSERVED VALUES OF DISTPOSPOL 
*SHOULD BE HIGHER THAN THE PREDICTIVE POWER OF THE MODEL USING THE PREDICTED VALUES (DPP_HAT), WHICH MAY IMPLY THAT THE PREDICTIVE POWER
*OF DPP_HAT IS AN UNDERESTIMATE OF THE ACTUAL PREDICTIVE POWER OF THE MODEL OR THAT THE ENDOGENOUS VARIATION MAY ALSO BE REDUCED
*THIS MAY THEREFORE NOT BE A USEFUL COMPARISON
xi: probit horiz2 z2_distpospol `controls_z2' i.prop [pw=probit_touse_wts03] if low_flat==1, cluster(kabid03)
predict_power main_lfh_dpp, thr(.01) 
local pp_main_realdpp=r(pred_power)
di `pp_main_realdpp'

*ESTIMATE SECOND STAGE PROBIT USING PREDICTED VALUES OF DPP (NOTE: NEWEY'S TWO-STEP WITHOUT PROPER STANDARD ERRORS; COEFFICIENTS & PREDICTIONS WILL BE SAME*
xi: probit horiz2 z2_dpp_hat `controls_z2' i.prop [pw=probit_touse_wts03] if low_flat==1, cluster(kabid03)
predict_power main_lfh, thr(.01) graph
local pp_main=r(pred_power)
g pp_main=`pp_main'


*ESTABLISH PREDICTIVE POWER OF EACH VAR IN 2ND STAGE PROBIT MODEL 
*LOOK AT PREDICTIVE POWER OF EACH VARIABLE COMPARING PP OF MAIN MODEL W/ MODEL WITHOUT EACH VARIABLE

g str20 var_name=""
g pp_remainder=.
local sec_stage_vars z2_dpp_hat `controls_z2'
local ind=0
foreach var of local sec_stage_vars {
	local temp_vars : list sec_stage_vars - var
	xi: probit horiz2 `temp_vars' i.prop [pw=probit_touse_wts03] if low_flat==1, cluster(kabid03) 
	predict_power no_`var', thr(.01)
	local pp_rem=r(pred_power)
	local ind=`ind'+1
	replace var_name="`var'" in `ind'
	replace pp_remainder=`pp_rem' in `ind'
}
g diff_pp=pp_main-pp_remainder

*SAVE ROC ANALYSIS OUTPUTS IN SEPARATE .DTA FILE 

preserve
keep var_name pp_main pp_remainder diff_pp 
keep in 1/`ind'
save ROC_low_flat, replace	
restore


log close
