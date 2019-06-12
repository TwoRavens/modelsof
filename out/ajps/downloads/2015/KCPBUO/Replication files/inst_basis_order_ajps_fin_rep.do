* inst_basis_order_ajps_fin_rep.do
* This do-file is the setup of the 2003 Podes dataset
* for the paper Institutional Basis of Order in the AJPS
* Yuhki Tajima
* Replication 
* Updated: 25 Sept 2012

***************
* BASIC SETUP *
***************

* WORKING DIRECTORY *
clear
set matsize 10000
cd "~/documents/working folder/dissertation/dissanalysis2/podes"
log using inst_basis_order_ajps_fin_rep.log, replace

**********************************
* MERGE CENSUS, PODES03, CROSSWALK *
**********************************

use podes03census_ajps_fin_rep

*********************************
* EXCLUDE ACEH (PROVINCEID=11)  *
*     AND PAPUA (PROVINCEID=94) *
*********************************

drop if prop==11
drop if prop==94

*************************************************************
* DROP OUTLIERS: THIS DOES NOT CHANGE RESULTS SIGNIFICANTLY *
*************************************************************

drop if povrateksvil>1
drop if npwperhh>.2


*************************
* PWEIGHTS USING PROBIT *
*************************

gen touse=!missing(horiz2, distkec, distpospol, dispuskes, dispkhelp, logvillpop, logdensvil, urban, flat, povrateksvil, fgtksvild, covyredvil, npwperhh, natdis, ethfractvil, ethfractsd, ethfractd, relfractvil, relfractsd, relfractd, ethclustsd, ethclustvd, relclustsd, relclustvd, wgcovegvil, wgcovegsd, wgcovegd, wgcovrgvil, wgcovrgsd, wgcovrgd, golkar1, pdip1, islam, javanese_off_java, natres, altitude, split_vil03, split_kab03)

xi: probit touse logvillpop logdensvil distkec urban flat i.prop
predict prob_touse
g probit_touse_wts03 = 1/prob_touse

* Replace weights from predictions that were dropped due to perfect prediction in Jakarta and Yogyajakarta regions
replace probit_touse_wts03 = 1 if prop==31 | prop==34

label var probit_touse_wts03 "Pweights 2003"


log close


*************************
* ANALYSIS OF 2003 DATA *
*************************

do inst_basis_order_tests03_ajps_fin.do






