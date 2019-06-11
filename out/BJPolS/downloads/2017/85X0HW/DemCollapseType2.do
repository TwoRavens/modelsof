capture log close
clear
clear mata
clear matrix
set mem 500m
set more off
graph drop _all
cd "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencydemization\demstability\bjpspublishedversion\replicationfiles\"

#delimit ;


*	************************************************************************ *;
* 	File-Name: TransDemCollapseRevised.do									 *;
*	Date:  04/07/17															 *;
*	Author: 	James Hollyer                                                *;
*	Purpose:   Replication file for robustness tests of replationship between*;
*	transparency and autocratic reversion, expanding the DD definition of    *;
*	democracy to omitt the type2 criterion.								 	 *;
*	************************************************************************ *;

use "Type2Reversions.dta";

sort DemocID year;
stset year, id(DemocID) fail(fail==1) origin(start_dem);

replace rgdpch=rgdpch/1000;

gen trans_growth=transparencyindex * grgdpch;
gen parl_sys=1 if regime==0;
replace parl_sys=0 if parl_sys==.;
gen mixed_sys=1 if regime==1;
replace mixed_sys=0 if mixed_sys==.;

gen lag_transparency = transparencyindex[_n-1] if DemocID==DemocID[_n-1];
gen lag_growth = grgdpch[_n-1] if DemocID == DemocID[_n-1];
gen lag_trans_growth = trans_growth[_n-1] if DemocID==DemocID[_n-1];
gen lag_GDP = rgdpch[_n-1] if DemocID==DemocID[_n-1];
gen lag_open = openk[_n-1] if DemocID==DemocID[_n-1];
gen lag_parl = parl_sys[_n-1] if DemocID==DemocID[_n-1];
gen lag_mixed = mixed_sys[_n-1] if DemocID==DemocID[_n-1];

*Conditional Gap Time Model;

stsplit, at(failures);
gen lag_parl_t = lag_parl * _t;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;

*The model passes the proportional hazards test.;

estimates store Type21;

stcox lag_transparency lag_growth lag_trans_growth, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Type22;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(num_transitions) cluster(DemocID);

estimates store Type23;

stcox lag_transparency lag_growth lag_trans_growth, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Type24;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open  
lag_mixed prior_transition, nohr cluster(DemocID);

estimates store Type25;

stcox lag_transparency lag_growth lag_trans_growth prior_transition, 
nohr cluster(DemocID);

estimates store Type26;

*	************************************************************************ *;
*	The following generates Table 1 in the Appendix.					     *;
*	************************************************************************ *;

*estout Type21 Type22  Type23 Type24 Type25 Type26 
using "demcollapse_type2.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;


