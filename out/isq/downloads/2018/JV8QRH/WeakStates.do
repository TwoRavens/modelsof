
/**************************************************************************
** 
** File name   : WeakStates.do
** Date        : February 16th, 2010
** Author      : Christina J. Schneider (cjschneider@ucsd.edu)
** Paper Title : Weak States and Institutionalized Bargaining Power in IOs
** Purpose     : Produce graphs & estimate the quantitative models
** Requires    : WeakStates_replication.dta, interact.ado
** Output      : WeakStates.log 
**
**************************************************************************/
version 10.0


#delimit ;
set more off;
cd "/Users/Christina/Dropbox/Work/Projects/2011/Weak States/analysis/replication package\";


use WeakStates_replication, replace;
log using WeakStates, replace;


***********
**Graphs***;
***********

#delimit ;
twoway (line ctot_pct year, sort) if country=="Greece"&year>1980,	xtitle("") ytitle("Budget Receipts (%)") legend(off) 
	scheme(s1mono) xlabel(1981(5)2006);
graph export "receipts_Greece.eps", replace;

twoway (line ctotnet year, sort) if country=="Greece"&year>1980, xtitle("") ytitle("Budget Receipts (Net)") 
	legend(off) scheme(s1mono) xlabel(1981(5)2006);
graph export "netreceipts_Greece.eps", replace;


***********
**Table 1**;
***********

#delimit ;

* FE Models with panel-corrected standard errors and panel-specific ar(1) process;

xtpcse ctot_pct conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion  employ_agriculture_ln sscouncil_pct 
	eusupport newmember  size population_ln id_*, correlation(psar1);

xtpcse ctotnet conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion  employ_agriculture_ln sscouncil_pct 
	eusupport   newmember size population_ln id_*, correlation(psar1);


***********
**Table 2**;
***********

#delimit ;

xtpcse ctot_pct conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion  employ_agriculture_ln sscouncil_pct ssconflict
	eusupport newmember  size population_ln id_*, correlation(psar1);

*10 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(2);
*25 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(3.5);
*50 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(5.7);
*75 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(11.7);
*90 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(13.4);


xtpcse ctotnet conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion  employ_agriculture_ln sscouncil_pct  ssconflict
	eusupport   newmember size population_ln id_*, correlation(psar1);

*10 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(2);
*25 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(3.5);
*50 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(5.7);
*75 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(11.7);
*90 percentile;
interact conflict_acc ssconflict, cond(sscouncil_pct) val(13.4);


***********
**Table 3**;
***********
#delimit ;

xtpcse ctot_pct conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion  employ_agriculture_ln sscouncil_pct 
	eusupport conflictsupport newmember  size population_ln id_*, correlation(psar1);

*10 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(14);
*25 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(29);
*50 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(48);
*75 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(64);
*90 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(73);


xtpcse ctotnet conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion  employ_agriculture_ln sscouncil_pct 
	eusupport conflictsupport   newmember size population_ln id_*, correlation(psar1);

*10 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(14);
*25 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(29);
*50 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(48);
*75 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(64);
*90 percentile;
interact conflict_acc conflictsupport, cond(eusupport) val(73);


***************;
***Appendix****;
***************;

#delimit ;

xtpcse ctot_pct conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion gdp_cohesion employ_agriculture_ln sscouncil_pct 
	eusupport newmember  size population_ln id_*, correlation(psar1);

interact gdppercap_eu100 gdp_cohesion, cond(cohesion) val(0);
interact gdppercap_eu100 gdp_cohesion, cond(cohesion) val(1);


xtpcse ctot_pct conflict_acc extraordinary conflict_new enlargement gdppercap_eu100 cohesion cohesion_population employ_agriculture_ln sscouncil_pct 
	eusupport newmember  size population_ln id_*, correlation(psar1);

interact cohesion cohesion_population, cond(population) val(14.124);
interact cohesion cohesion_population, cond(population) val(15.048);
interact cohesion cohesion_population, cond(population) val(16.116);
interact cohesion cohesion_population, cond(population) val(16.155);
interact cohesion cohesion_population, cond(population) val(17.468);


log close;
exit;

**Notes**
* Bulgaria and Rumania are included in the dataset (id 23&24) but dropped due to missing data in 2007;

