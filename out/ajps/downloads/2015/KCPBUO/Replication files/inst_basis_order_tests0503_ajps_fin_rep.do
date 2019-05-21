log using inst_basis_order_tests0503_ajps_fin.log, replace

****************************************************************************************
* inst_basis_order_tests0503_ajps_fin.do
* This is the analysis of the 2005-6 Podes merged dataset which works with inst_basis_order and the dataset that
* is yielded by cleanpod0503_ajps_fin.do
* 
* Updated 21 September 2012
****************************************************************************************

*************************
* SET CONTROL VARIABLES *
*************************

* STANDARDIZED CONTROLS FOR 2003 DATA
local controls_z2 urban natres z2_logvillpop z2_logdensvil z2_povrateksvil z2_fgtksvild z2_covyredvil z2_npwperhh z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis javanese_off_java islam split_kab03 split_vil03
local controls_z2_pol urban natres z2_logvillpop z2_logdensvil z2_povrateksvil z2_fgtksvild z2_covyredvil z2_npwperhh z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis javanese_off_java islam split_kab03 split_vil03 golkar1 pdip1 
local controls_z2_rural natres z2_logvillpop z2_logdensvil z2_povrateksvil z2_fgtksvild z2_covyredvil z2_npwperhh z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis javanese_off_java islam split_kab03 split_vil03

* OLS controling for 2005 changes
local controls_05 natres_05 logvillpop_05 logdensvil_05 urban_05 povrateksvil_05 fgtksvild_05 covyredvil npwperhh_05 natdis_05 ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd javanese_off_java_05 islam_05 split_vil03 split_kab03 split_vil05 split_kab05 
local controls_pol_05 natres_05 logvillpop_05 logdensvil_05 urban_05 povrateksvil_05 fgtksvild_05 covyredvil npwperhh_05 natdis_05 ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd javanese_off_java_05 islam_05 split_vil03 split_kab03 split_vil05 split_kab05 golkar1_05 pdip1_05 golk1_to_no pdip1_to_no


*************************************************************************************************
*STANDARDIZE CONTINUOUS VARIABLES (DEMEAN AND DIVIDE BY 2 STANDARD DEVIATIONS) PER GELMAN (2007)*
*2 STANDARD DEVIATIONS ALLOWS COMPARISONS BETWEEN BINARY AND CONTINUOUS VARIABLE COEFFICIENTS   *
*************************************************************************************************

* MAIN SET OF CONTINUOUS CONTROLS (REVISIONS) WITHOUT CATEGORICAL VARS: flat urban natdis natres javanese_off_java islam 
local controls_cont_05 altitude logvillpop_05 logdensvil_05  povrateksvil_05 fgtksvild_05 covyredvil npwperhh_05 ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd

foreach var of varlist `controls_cont_05' distpospol_05 distkec_05 distpospol dispuskes dispkhelp distkec diff_dpp {
	egen z2_`var'=std(`var'), mean(0) std(2)
}

*STANDARDIZED MAIN SET OF CONTINUOUS CONTROLS AND NONSTANDARDIZED BINARY VARIABLES*
*DOES NOT INCLUDE THE FLAT AND Z2_ALTITUDE CONDITIONING VARIABLES, WHICH ARE TO BE ENTERED MANUALLY

local controls_z2_05 urban_05 natres_05 z2_logvillpop_05 z2_logdensvil_05 z2_povrateksvil_05 z2_fgtksvild_05 z2_covyredvil z2_npwperhh_05 z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis_05 javanese_off_java_05 islam_05 split_vil03 split_kab03 split_vil05 split_kab05
local controls_z2_pol_05 urban_05 natres_05 z2_logvillpop_05 z2_logdensvil_05 z2_povrateksvil_05 z2_fgtksvild_05 z2_covyredvil z2_npwperhh_05 z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis_05 javanese_off_java_05 islam_05 split_vil03 split_kab03 split_vil05 split_kab05 golkar1_05 pdip1_05 golk1_to_no pdip1_to_no
local controls_z2_rural_05 natres_05 z2_logvillpop_05 z2_logdensvil_05 z2_povrateksvil_05 z2_fgtksvild_05 z2_covyredvil z2_npwperhh_05 z2_ethfractvil z2_ethfractsd z2_ethfractd z2_relfractvil z2_relfractsd z2_relfractd z2_ethclustsd z2_ethclustvd z2_relclustsd z2_relclustvd z2_wgcovegvil z2_wgcovegsd z2_wgcovegd z2_wgcovrgvil z2_wgcovrgsd z2_wgcovrgd natdis_05 javanese_off_java_05 islam_05 split_vil03 split_kab03 split_vil05 split_kab05

******************************************************************************************************************************
*USE COMPOSITE OF LOWALT AND FLAT INTERACTING WITH DISTPOSPOL AS PROXY FOR EXOG VARIATION IN STATE PENETRATION VIA DISTPOSPOL*
******************************************************************************************************************************

*DETERMINE THE WEIGHTED MEAN OF ALTITUDE*
mean altitude [pw=probit_touse_wts0503]
mat mn=e(b)
local mean_alt=mn[1,1]

g lowalt=0
replace lowalt=altitude<`mean_alt'

g low_flat=0
replace low_flat=lowalt==1 & flat==1

*DETERMINE THE WEIGHTED PROPORTION OF VILLAGES BELOW 500M*
g below500=0
replace below500=1 if altitude<500
mean below500 [pw=probit_touse_wts0503]

*GENERATE INTERACTIVE VARIABLES (STANDARDIZED CONTINUOUS x NONSTANDARDIZED BINARY) PER GELMAN (2007)*

g z2_dppfl=z2_distpospol*flat
g z2_diff_dppfl=z2_diff_dpp*flat

*LOW & FLAT INTERACTIVE VARIABLES (STANDARDIZED CONTINUOUS X NONSTANDARDIZED BINARY)
g z2_dpplowfl=z2_distpospol*low_flat
g z2_diff_dpplowfl=z2_diff_dpp*low_flat

*********************
* TESTING THE MODEL *
*********************

xi: reg horiz2_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m1
xi: reg horiz2_05 z2_distpospol low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m2
xi: reg horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m3
xi: reg horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m4

xi: reg horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m5
test z2_distpospol + z2_dppfl=0
xi: reg horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m6
test z2_distpospol + z2_dpplowfl=0
xi: reg horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m7
test z2_distpospol + z2_dppfl=0
xi: reg horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store m8
test z2_distpospol + z2_dpplowfl=0

* Full Table
estout m1 m2 m3 m4 m5 m6 m7 m8 using ib_tests0503_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace

* Small Table
estout m1 m2 m3 m4 m5 m6 m7 m8 using ib_tests0503_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat ) replace

* TABLE WITH B AND SE ON SAME LINE *
estout m1 m2 m3 m4 m5 m6 m7 m8 using ib_tests0503_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace

*************************************
* TESTS THAT COMPARE 2003 WITH 2006 *
*************************************

svyset kabid05 [pw=probit_touse_wts0503]

xi: svy: reg horiz2 z2_distpospol flat z2_altitude `controls_z2' i.prop if touse0503==1
estimates store m103

xi: svy: reg horiz2_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop 
estimates store m1comp
suest m103 m1comp
test [m103]z2_distpospol=[m1comp]z2_distpospol

xi: svy: reg horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop
estimates store m3comp
suest m103 m3comp
test [m103]z2_distpospol=[m3comp]z2_distpospol

xi: svy: reg horiz2 z2_distpospol low_flat `controls_z2' i.prop if touse0503==1
estimates store m203

xi: svy: reg horiz2_05 z2_distpospol low_flat `controls_z2_05' i.prop
estimates store m2comp
suest m203 m2comp
test [m203]z2_distpospol=[m2comp]z2_distpospol

xi: svy: reg horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_05' i.prop
estimates store m4comp
suest m203 m4comp
test [m203]z2_distpospol=[m4comp]z2_distpospol

xi: svy: reg horiz2 z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop if touse0503==1
estimates store m303

xi: svy: reg horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop
estimates store m5comp
suest m303 m5comp
test [m303]z2_distpospol=[m5comp]z2_distpospol
test [m303]z2_dppfl=[m5comp]z2_dppfl
test [m303]z2_distpospol + [m303]z2_dppfl = [m5comp]z2_distpospol + [m5comp]z2_dppfl

xi: svy: reg horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop 
estimates store m7comp
suest m303 m7comp
test [m303]z2_distpospol=[m7comp]z2_distpospol
test [m303]z2_dppfl=[m7comp]z2_dppfl
test [m303]z2_distpospol + [m303]z2_dppfl = [m7comp]z2_distpospol + [m7comp]z2_dppfl

xi: svy: reg horiz2 z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop if touse0503==1
estimates store m403

xi: svy: reg horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop 
estimates store m6comp
suest m403 m6comp
test [m403]z2_distpospol=[m6comp]z2_distpospol
test [m403]z2_dpplowfl=[m6comp]z2_dpplowfl
test [m403]z2_distpospol + [m403]z2_dpplowfl = [m6comp]z2_distpospol + [m6comp]z2_dpplowfl

xi: svy: reg horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_05' i.prop
estimates store m8comp
suest m403 m8comp
test [m403]z2_distpospol=[m8comp]z2_distpospol
test [m403]z2_dpplowfl=[m8comp]z2_dpplowfl
test [m403]z2_distpospol + [m403]z2_dpplowfl = [m8comp]z2_distpospol + [m8comp]z2_dpplowfl




*********************************************
* TESTING THE MODEL WITH POLITICAL CONTROLS *
*********************************************


xi: reg horiz2_05 z2_distpospol flat z2_altitude `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp1
xi: reg horiz2_05 z2_distpospol low_flat `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp2
xi: reg horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp3
xi: reg horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp4

xi: reg horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp5
test z2_distpospol + z2_dppfl=0
xi: reg horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp6
test z2_distpospol + z2_dpplowfl=0
xi: reg horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp7
test z2_distpospol + z2_dppfl=0
xi: reg horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_pol_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store mp8
test z2_distpospol + z2_dpplowfl=0


* Full Table
estout mp1 mp2 mp3 mp4 mp5 mp6 mp7 mp8 using ib_tests0503p_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace

* Small Table
estout mp1 mp2 mp3 mp4 mp5 mp6 mp7 mp8 using ib_tests0503p_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat ) replace

* TABLE WITH B AND SE ON SAME LINE *
estout mp1 mp2 mp3 mp4 mp5 mp6 mp7 mp8 using ib_tests0503p_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace


***********************************************************
* TESTS THAT COMPARE 2003 WITH 2006 W/ POLITICAL CONTROLS *
***********************************************************

xi: svy: reg horiz2 z2_distpospol flat z2_altitude `controls_z2_pol' i.prop if touse0503==1
estimates store mp103

xi: svy: reg horiz2_05 z2_distpospol flat z2_altitude `controls_z2_pol_05' i.prop 
estimates store mp1comp
suest mp103 mp1comp
test [mp103]z2_distpospol=[mp1comp]z2_distpospol

xi: svy: reg horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_pol_05' i.prop
estimates store mp3comp
suest mp103 mp3comp
test [mp103]z2_distpospol=[mp3comp]z2_distpospol

xi: svy: reg horiz2 z2_distpospol low_flat `controls_z2_pol_05' i.prop if touse0503==1
estimates store mp203

xi: svy: reg horiz2_05 z2_distpospol low_flat `controls_z2_pol_05' i.prop
estimates store mp2comp
suest mp203 mp2comp
test [mp203]z2_distpospol=[mp2comp]z2_distpospol

xi: svy: reg horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_pol_05' i.prop
estimates store mp4comp
suest mp203 mp4comp
test [mp203]z2_distpospol=[mp4comp]z2_distpospol

xi: svy: reg horiz2 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_pol_05' i.prop if touse0503==1
estimates store mp303

xi: svy: reg horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_pol_05' i.prop
estimates store mp5comp
suest mp303 mp5comp
test [mp303]z2_distpospol=[mp5comp]z2_distpospol
test [mp303]z2_dppfl=[mp5comp]z2_dppfl
test [mp303]z2_distpospol + [mp303]z2_dppfl = [mp5comp]z2_distpospol + [mp5comp]z2_dppfl

xi: svy: reg horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_pol_05' i.prop 
estimates store mp7comp
suest mp303 mp7comp
test [mp303]z2_distpospol=[mp7comp]z2_distpospol
test [mp303]z2_dppfl=[mp7comp]z2_dppfl
test [mp303]z2_distpospol + [mp303]z2_dppfl = [mp7comp]z2_distpospol + [mp7comp]z2_dppfl

xi: svy: reg horiz2 z2_distpospol z2_dpplowfl low_flat `controls_z2_pol_05' i.prop if touse0503==1
estimates store mp403

xi: svy: reg horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_pol_05' i.prop 
estimates store mp6comp
suest mp403 mp6comp
test [mp403]z2_distpospol=[mp6comp]z2_distpospol
test [mp403]z2_dpplowfl=[mp6comp]z2_dpplowfl
test [mp403]z2_distpospol + [mp403]z2_dpplowfl = [mp6comp]z2_distpospol + [mp6comp]z2_dpplowfl

xi: svy: reg horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_pol_05' i.prop
estimates store mp8comp
suest mp403 mp8comp
test [mp403]z2_distpospol=[mp8comp]z2_distpospol
test [mp403]z2_dpplowfl=[mp8comp]z2_dpplowfl
test [mp403]z2_distpospol + [mp403]z2_dpplowfl = [mp8comp]z2_distpospol + [mp8comp]z2_dpplowfl


**********************************
* TESTING THE MODEL - RURAL ONLY *
**********************************

xi: reg horiz2_05 z2_distpospol flat z2_altitude `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr1
xi: reg horiz2_05 z2_distpospol low_flat `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr2
xi: reg horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr3
xi: reg horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr4

xi: reg horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr5
test z2_distpospol + z2_dppfl=0
xi: reg horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr6
test z2_distpospol + z2_dpplowfl=0
xi: reg horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr7
test z2_distpospol + z2_dppfl=0
xi: reg horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_rural_05' i.prop [pw=probit_touse_wts0503] if urban_05==0, cluster(kabid05)
estimates store mr8
test z2_distpospol + z2_dpplowfl=0

* Full Table
estout mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 using ib_tests0503r_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace

* Small Table
estout mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 using ib_tests0503r_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat ) replace

* TABLE WITH B AND SE ON SAME LINE *
estout mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 using ib_tests0503r_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace

**************************************************
* TESTS THAT COMPARE 2003 WITH 2006 - RURAL ONLY *
**************************************************


xi: svy: reg horiz2 z2_distpospol flat z2_altitude `controls_z2_rural' i.prop if touse0503==1 & urban==0
estimates store mr103

xi: svy: reg horiz2_05 z2_distpospol flat z2_altitude `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr1comp
suest mr103 mr1comp
test [mr103]z2_distpospol=[mr1comp]z2_distpospol

xi: svy: reg horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr3comp
suest mr103 mr3comp
test [mr103]z2_distpospol=[mr3comp]z2_distpospol

xi: svy: reg horiz2 z2_distpospol low_flat `controls_z2_rural' i.prop if touse0503==1 & urban==0
estimates store mr203

xi: svy: reg horiz2_05 z2_distpospol low_flat `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr2comp
suest mr203 mr2comp
test [mr203]z2_distpospol=[mr2comp]z2_distpospol

xi: svy: reg horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr4comp
suest mr203 mr4comp
test [mr203]z2_distpospol=[mr4comp]z2_distpospol

xi: svy: reg horiz2 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_rural' i.prop if touse0503==1 & urban==0
estimates store mr303

xi: svy: reg horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr5comp
suest mr303 mr5comp
test [mr303]z2_distpospol=[mr5comp]z2_distpospol
test [mr303]z2_dppfl=[mr5comp]z2_dppfl
test [mr303]z2_distpospol + [mr303]z2_dppfl = [mr5comp]z2_distpospol + [mr5comp]z2_dppfl

xi: svy: reg horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr7comp
suest mr303 mr7comp
test [mr303]z2_distpospol=[mr7comp]z2_distpospol
test [mr303]z2_dppfl=[mr7comp]z2_dppfl
test [mr303]z2_distpospol + [mr303]z2_dppfl = [mr7comp]z2_distpospol + [mr7comp]z2_dppfl

xi: svy: reg horiz2 z2_distpospol z2_dpplowfl low_flat `controls_z2_rural' i.prop if touse0503==1 & urban==0
estimates store mr403

xi: svy: reg horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr6comp
suest mr403 mr6comp
test [mr403]z2_distpospol=[mr6comp]z2_distpospol
test [mr403]z2_dpplowfl=[mr6comp]z2_dpplowfl
test [mr403]z2_distpospol + [mr403]z2_dpplowfl = [mr6comp]z2_distpospol + [mr6comp]z2_dpplowfl

xi: svy: reg horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_rural_05' i.prop if urban_05==0
estimates store mr8comp
suest mr403 mr8comp
test [mr403]z2_distpospol=[mr8comp]z2_distpospol
test [mr403]z2_dpplowfl=[mr8comp]z2_dpplowfl
test [mr403]z2_distpospol + [mr403]z2_dpplowfl = [mr8comp]z2_distpospol + [mr8comp]z2_dpplowfl



******************************************************************************
* TEST CLAIM THAT COMMUNITY CAPACITY SHOULD BE HIGHER FARTHER FROM THE STATE *
******************************************************************************

xi: reg tot_hansip_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store cc1a

xi: reg tot_hansip_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store cc1b

xi: reg tot_hansip_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
test z2_distpospol+z2_dppfl=0
estimates store cc2a

xi: reg tot_hansip_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
test z2_distpospol + z2_dppfl=0
estimates store cc2b

xi: reg tot_hansip_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
test z2_distpospol + z2_dpplowfl=0
estimates store cc3a

xi: reg tot_hansip_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
test z2_distpospol + z2_dpplowfl=0
estimates store cc3b

* Full Table
estout cc1a cc1b cc2a cc2b cc3a cc3b using ib_testscc05_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS , depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout cc1a cc1b cc2a cc2b cc3a cc3b using ib_testscc05_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS , depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout cc1a cc1b cc2a cc2b cc3a cc3b using ib_testscc05_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS , depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace


*************************************
* TESTS THAT COMPARE 2003 WITH 2006 *
*************************************

svyset kabid05 [pw=probit_touse_wts0503]

xi: svy: reg tot_hansip z2_distpospol flat z2_altitude `controls_z2' i.prop if touse0503==1
estimates store cc103

xi: svy: reg tot_hansip_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop 
estimates store cc1a05
suest cc103 cc1a05
test [cc103]z2_distpospol=[cc1a05]z2_distpospol

xi: svy: reg tot_hansip_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop
estimates store cc1b05
suest cc103 cc1b05
test [cc103]z2_distpospol=[cc1b05]z2_distpospol

xi: svy: reg tot_hansip z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop if touse0503==1
estimates store cc203

xi: svy: reg tot_hansip_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop
estimates store cc2a05
suest cc203 cc2a05
test [cc203]z2_distpospol=[cc2a05]z2_distpospol
test [cc203]z2_dppfl=[cc2a05]z2_dppfl
test [cc203]z2_distpospol + [cc203]z2_dppfl = [cc2a05]z2_distpospol + [cc2a05]z2_dppfl

xi: svy: reg tot_hansip_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop 
estimates store cc2b05
suest cc203 cc2b05
test [cc203]z2_distpospol=[cc2b05]z2_distpospol
test [cc203]z2_dppfl=[cc2b05]z2_dppfl
test [cc203]z2_distpospol + [cc203]z2_dppfl = [cc2b05]z2_distpospol + [cc2b05]z2_dppfl

xi: svy: reg tot_hansip z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop if touse0503==1
estimates store cc303

xi: svy: reg tot_hansip_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop 
estimates store cc3a05
suest cc303 cc3a05
test [cc303]z2_distpospol=[cc3a05]z2_distpospol
test [cc303]z2_dpplowfl=[cc3a05]z2_dpplowfl
test [cc303]z2_distpospol + [cc303]z2_dpplowfl = [cc3a05]z2_distpospol + [cc3a05]z2_dpplowfl

xi: svy: reg tot_hansip_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_05' i.prop
estimates store cc3b05
suest cc303 cc3b05
test [cc303]z2_distpospol=[cc3b05]z2_distpospol
test [cc303]z2_dpplowfl=[cc3b05]z2_dpplowfl
test [cc303]z2_distpospol + [cc303]z2_dpplowfl = [cc3b05]z2_distpospol + [cc3b05]z2_dpplowfl


***********************************************************************************************
* TEST CLAIM THAT NON-STATE RESPONSES TO CONFLICT SHOULD BE GREATER FARTHER FROM POLICE POSTS *
***********************************************************************************************

**************************
* NON-INTERACTIVE MODELS *
**************************

xi: reg non_sf_res_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503] if horiz2_05==1, cluster(kabid05)
estimates store ns1a

xi: reg non_sf_res_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503] if horiz2_05==1, cluster(kabid05)
estimates store ns1b

***************************
* FLAT-INTERACTIVE MODELS *
***************************

xi: reg non_sf_res_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503] if horiz2_05==1, cluster(kabid05)
test z2_distpospol+z2_dppfl=0
estimates store ns2a

xi: reg non_sf_res_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503] if horiz2_05==1, cluster(kabid05)
test z2_distpospol+z2_dppfl=0
estimates store ns2b

*******************************
* LOW_FLAT-INTERACTIVE MODELS *
*******************************

xi: reg non_sf_res_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503] if horiz2_05==1, cluster(kabid05)
test z2_distpospol+z2_dpplowfl=0
estimates store ns3a

xi: reg non_sf_res_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503] if horiz2_05==1, cluster(kabid05)
test z2_distpospol+z2_dpplowfl=0
estimates store ns3b

* Full Table
estout ns1a ns1b ns2a ns2b ns3a ns3b using ib_testsns05_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace

* Small Table
estout ns1a ns1b ns2a ns2b ns3a ns3b  using ib_testsns05_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat) replace

* TABLE WITH B AND SE ON SAME LINE *
estout ns1a ns1b ns2a ns2b ns3a ns3b using ib_testsns05_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS, depvars) numbers order(z2_distpospol z2_dppfl z2_dpplowfl flat z2_altitude low_flat `controls_z2') replace


*************************************
* TESTS THAT COMPARE 2003 WITH 2006 *
*************************************

svyset kabid05 [pw=probit_touse_wts0503]

xi: svy: reg non_sf_res z2_distpospol flat z2_altitude `controls_z2' i.prop if touse0503==1
estimates store ns103

xi: svy: reg non_sf_res_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop 
estimates store ns1a05
suest ns103 ns1a05
test [ns103]z2_distpospol=[ns1a05]z2_distpospol

xi: svy: reg non_sf_res_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop
estimates store ns1b05
suest ns103 ns1b05
test [ns103]z2_distpospol=[ns1b05]z2_distpospol

xi: svy: reg non_sf_res z2_distpospol z2_dppfl flat z2_altitude `controls_z2' i.prop if touse0503==1
estimates store ns203

xi: svy: reg non_sf_res_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop
estimates store ns2a05
suest ns203 ns2a05
test [ns203]z2_distpospol=[ns2a05]z2_distpospol
test [ns203]z2_dppfl=[ns2a05]z2_dppfl
test [ns203]z2_distpospol + [ns203]z2_dppfl = [ns2a05]z2_distpospol + [ns2a05]z2_dppfl

xi: svy: reg non_sf_res_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop 
estimates store ns2b05
suest ns203 ns2b05
test [ns203]z2_distpospol=[ns2b05]z2_distpospol
test [ns203]z2_dppfl=[ns2b05]z2_dppfl
test [ns203]z2_distpospol + [ns203]z2_dppfl = [ns2b05]z2_distpospol + [ns2b05]z2_dppfl

xi: svy: reg non_sf_res z2_distpospol z2_dpplowfl low_flat `controls_z2' i.prop if touse0503==1
estimates store ns303

xi: svy: reg non_sf_res_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop 
estimates store ns3a05
suest ns303 ns3a05
test [ns303]z2_distpospol=[ns3a05]z2_distpospol
test [ns303]z2_dpplowfl=[ns3a05]z2_dpplowfl
test [ns303]z2_distpospol + [ns303]z2_dpplowfl = [ns3a05]z2_distpospol + [ns3a05]z2_dpplowfl

xi: svy: reg non_sf_res_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_05' i.prop
estimates store ns3b05
suest ns303 ns3b05
test [ns303]z2_distpospol=[ns3b05]z2_distpospol
test [ns303]z2_dpplowfl=[ns3b05]z2_dpplowfl
test [ns303]z2_distpospol + [ns303]z2_dpplowfl = [ns3b05]z2_distpospol + [ns3b05]z2_dpplowfl




*************************************************************
*HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE *
*************************************************************

*local controls_rev_noflat altitude urban natres logvillpop logdensvil povrateksvil fgtksvild covyredvil npwperhh ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd natdis javanese_off_java islam 
g dpp_alt=distpospol*altitude
g dpk_alt=dispuskes*altitude
g dpkh_alt=dispkhelp*altitude
*xi: ivreg2 horiz2 (distpospol dpp_alt=dispuskes dispkhelp dpk_alt dpkh_alt) `controls_rev_z2_noflat' i.prop [pw=probit_touse_wts03] if flat==1, first cluster(kabid03) 

*Make Heterogeneous Marginal Effects CI Graph over Altitude*
local max_alt=3000
local interval=50
local num_vals=`max_alt'/`interval'+1
matrix dpp_alt_me=J(`num_vals',1,.)
matrix colnames dpp_alt_me = alt 
*dhoriz2dx LBdhoriz2dx UBdhoriz2dx 
matrix dpp_alt_me[1,1]=[0]
forvalues i=2/`num_vals' {
	matrix dpp_alt_me[`i',1]=[(`i'-1)*`interval']
}
svmat dpp_alt_me, names(col)


* HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE IN FLAT & NON-FLAT VILLAGES *

xi: reg horiz2_05 distpospol dpp_alt altitude flat `controls_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05) 
g dhoriz2dx_05=_b[distpospol]+_b[dpp_alt]*alt
matrix varcov=get(VCE)
g cov_dpp_dppalt_05=varcov[2,1]
g vardh2dx_05=(_se[distpospol]^2)+(alt^2)*(_se[dpp_alt]^2)+2*alt*cov_dpp_dppalt_05
g sedh2dx_05=sqrt(vardh2dx_05)
g LBdh2dx_05=dhoriz2dx_05-invttail(e(df_m),.025)*sedh2dx_05
g UBdh2dx_05=dhoriz2dx_05+invttail(e(df_m),.025)*sedh2dx_05

twoway rarea LBdh2dx_05 UBdh2dx_05 alt, sort color(gs14)  || line dhoriz2dx_05 alt, color(black) xtick(0(500)3000) legend(off) ytitle("dCV/dDP") xtitle("Altitude (m)") title("All Villages (2004)") saving(me_dpp_alt_05, replace)
graph export me_dpp_alt_05.tif, replace

* HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE IN FLAT VILLAGES *

xi: reg horiz2_05 distpospol dpp_alt altitude `controls_05' i.prop [pw=probit_touse_wts0503] if flat==1, cluster(kabid05) 

g dhoriz2dx_fl_05=_b[distpospol]+_b[dpp_alt]*alt
matrix varcov=get(VCE)
g cov_dpp_dppalt_fl_05=varcov[2,1]
g vardh2dx_fl_05=(_se[distpospol]^2)+(alt^2)*(_se[dpp_alt]^2)+2*alt*cov_dpp_dppalt_fl_05
g sedh2dx_fl_05=sqrt(vardh2dx_fl_05)
g LBdh2dx_fl_05=dhoriz2dx_fl_05-invttail(e(df_m),.025)*sedh2dx_fl_05
g UBdh2dx_fl_05=dhoriz2dx_fl_05+invttail(e(df_m),.025)*sedh2dx_fl_05

twoway rarea LBdh2dx_fl_05 UBdh2dx_fl_05 alt, sort color(gs14)  || line dhoriz2dx_fl_05 alt, color(black) xtick(0(500)3000) legend(off) ytitle("dCV/dDP") xtitle("Altitude (m)") title("Flat Villages (2004)") saving(me_dpp_alt_fl_05, replace)
graph export me_dpp_alt_fl_05.tif, replace

* HETEROGENEOUS MARGINAL EFFECTS OF DISTPOSPOL OVER ALTITUDE IN FLAT VILLAGES *

xi: reg horiz2_05 distpospol dpp_alt altitude `controls_05' i.prop [pw=probit_touse_wts0503] if flat==0, cluster(kabid05) 
g dhoriz2dx_nofl_05=_b[distpospol]+_b[dpp_alt]*alt
matrix varcov=get(VCE)
g cov_dpp_dppalt_nofl_05=varcov[2,1]
g vardh2dx_nofl_05=(_se[distpospol]^2)+(alt^2)*(_se[dpp_alt]^2)+2*alt*cov_dpp_dppalt_nofl_05
g sedh2dx_nofl_05=sqrt(vardh2dx_nofl_05)
g LBdh2dx_nofl_05=dhoriz2dx_nofl_05-invttail(e(df_m),.025)*sedh2dx_nofl_05
g UBdh2dx_nofl_05=dhoriz2dx_nofl_05+invttail(e(df_m),.025)*sedh2dx_nofl_05

twoway rarea LBdh2dx_nofl_05 UBdh2dx_nofl_05 alt, sort color(gs14)  || line dhoriz2dx_nofl_05 alt, color(black) xtick(0(500)3000) legend(off) ytitle("dCV/dDP") xtitle("Altitude (m)") title("Hilly Villages (2004)") saving(me_dpp_alt_nfl_05, replace)
graph export me_dpp_alt_nfl_05.tif, replace

graph combine me_dpp_alt_05.gph me_dpp_alt_fl_05.gph me_dpp_alt_nfl_05.gph, xcommon saving(me_dpp_alt_comb_05, replace)

graph combine me_dpp_alt_fl.gph me_dpp_alt_nfl.gph me_dpp_alt_fl_05.gph me_dpp_alt_nfl_05.gph, xcommon saving(me_dpp_alt_comb_allfl, replace)
graph export me_dpp_alt_comb_allfl.tif, replace

graph combine me_dpp_alt.gph me_dpp_alt_05.gph, xcommon saving(me_dpp_alt_comb_all, replace)



********************************
* ROBUST TO HETEROSKEDASTICITY *
********************************


xi: probit horiz2_05 z2_distpospol flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c1
xi: probit horiz2_05 z2_distpospol low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c2
xi: probit horiz2_05 z2_distpospol z2_diff_dpp flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c3
xi: probit horiz2_05 z2_distpospol z2_diff_dpp low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c4

xi: probit horiz2_05 z2_distpospol z2_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c5
xi: probit horiz2_05 z2_distpospol z2_dpplowfl low_flat `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c6
xi: probit horiz2_05 z2_distpospol z2_dppfl z2_diff_dpp z2_diff_dppfl flat z2_altitude `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c7
xi: probit horiz2_05 z2_distpospol z2_dpplowfl z2_diff_dpp z2_diff_dpplowfl low_flat  `controls_z2_05' i.prop [pw=probit_touse_wts0503], cluster(kabid05)
estimates store c8


* Full Table
estout c1 c2 c3 c4 c5 c6 c7 c8 using ib_comptests0503_rep.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace

* Small Table
estout c1 c2 c3 c4 c5 c6 c7 c8 using ib_comptests0503_rep_small.xls, cells(b(star fmt(4) ) se(par(( )) fmt(4))) keep(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat _cons) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat ) replace

* TABLE WITH B AND SE ON SAME LINE *
estout c1 c2 c3 c4 c5 c6 c7 c8 using ib_comptests0503_rep_side.xls, cells("b(fmt(4) ) se(star par(( )) fmt(4))") drop(_Iprop_* ) starlevels(* 0.10 ** 0.05 *** 0.01) legend varlabels(_cons Constant) stats(r2 N, fmt(3 0 1) label(R-squared N)) mlabels(OLS OLS OLS OLS OLS OLS OLS OLS) numbers order(z2_distpospol z2_dppfl z2_dpplowfl z2_diff_dpp z2_diff_dppfl z2_diff_dpplowfl flat z2_altitude low_flat `controls_z2_05') replace



log close

