***********************************************************************
* inst_basis_order0503_ajps_fin_rep.do
* This do-file is the main do-file for the 2005-6 PODES analysis
* for the paper Institutional Basis of Order. Replication.
* Updated: 21 September 2012
***********************************************************************


***************
* BASIC SETUP *
***************

* WORKING DIRECTORY *
clear
set matsize 10000
cd "~/documents/working folder/dissertation/dissanalysis2/podes"

log using ib_0503_ajps_fin_rep.log, replace

**********************************
* MERGE CENSUS, PODES03, CROSSWALK *
**********************************

*do cleanpod0503_ajps_rev


use podes0503census_ajps_fin_rep

*********************************
* EXCLUDE ACEH (PROVINCEID=11)  *
*     AND PAPUA (PROVINCEID=94) *
*********************************

drop if prop==11
drop if prop==94

*****************
* DROP OUTLIERS *
*****************

drop if povrateksvil_05>1
drop if npwperhh_05>.2

**********************************************************
* CREATE PWEIGHTS FOR 2003 USING PODES05 AND CENSUS DATA *
**********************************************************

*************************
* PWEIGHTS USING PROBIT *
*************************

gen touse0503=!missing(horiz2_05, distkec_05, distpospol_05, logvillpop_05, logdensvil_05, urban_05, flat_05, povrateksvil_05, fgtksvild_05, covyredvil, npwperhh_05, natdis_05, golkar1_05, pdip1_05, islam_05, javanese_off_java_05, natres_05, split_vil05, split_kab05, distkec, distpospol, dispuskes, dispkhelp, logvillpop, logdensvil, urban, flat, povrateksvil, fgtksvild, covyredvil, npwperhh, natdis, ethfractvil, ethfractsd, ethfractd, relfractvil, relfractsd, relfractd, ethclustsd, ethclustvd, relclustsd, relclustvd, wgcovegvil, wgcovegsd, wgcovegd, wgcovrgvil, wgcovrgsd, wgcovrgd, golkar1, pdip1, islam, javanese_off_java, natres, altitude, split_kab03, split_vil03, golk1_to_no, pdip1_to_no)
xi: probit touse0503 logvillpop_05 logdensvil_05 distkec_05 urban_05 flat_05 i.prop
predict prob_touse0503
g probit_touse_wts0503 = 1/prob_touse0503
* Replace weights from predictions that were dropped due to perfect prediction in a given province
replace probit_touse_wts0503 = 1 if prop==31

*************************
* ANALYSIS OF 2005 DATA *
*************************

do inst_basis_order_tests0503_ajps.do


log close





