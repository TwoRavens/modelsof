
#delimit;
clear all;
version 13.1;
pause on;
program drop _all;
capture log close;
set more off;

/*INSERT FOLDER PATH*/
cd /;

use rtrct_authors_culpables.dta, clear;
tabstat first_perp last_perp middle_perp, stat(sum) by(shldrs) ;
	
	estimates drop _all;
	estpost tabstat first_perp last_perp middle_perp, stat(sum) by(shldrs);
		esttab, cells("first_perp last_perp  middle_perp") noobs nomtitle nonumber;
		esttab using tables/perp_positions_freqs.rtf,  cells("first_perp last_perp  middle_perp") noobs nomtitle nonumber replace;
	




use multi_level_dataset_005_field_vars.dta, clear;
drop if ovrlp_anypos==1;
merge m:1 srce_pmid using perps_by_pmid.dta, keep(match master);
drop _merge;
replace perp_dummy=0 if perp_dummy==.;
bysort srce_pmid: keep if _n==1;
tabstat perp_dummy, by(shldrs) stat(count  sum mean);
estimates drop _all;
		estpost tabstat perp_dummy, by(shldrs) stat(count  sum mean);
		esttab, cells("count sum mean") noobs nomtitle nonumber;
		esttab using tables/perps_by_shldrs.rtf, cells("count sum mean") sfmt(%10.0fc %10.0fc %10.0fc %10.0fc) noobs nomtitle nonumber replace;

/*main analysis dataset: merge on the perp info by srce pmid then only keep absent shoulder subsample*/
use multi_level_dataset_005_field_vars.dta, clear;
/*drop the related papers overlapping authors because we usually should*/
drop if ovrlp_anypos==1;
merge m:1 srce_pmid using perps_by_pmid.dta, keep(match master);
drop _merge;
/*keep only absent shoulders retractions*/
keep if shldrs==2;
replace perp_dummy=0 if perp_dummy==.;


gen treatXfirst_perp=treat*first_perp;
gen treatXmiddle_perp=treat*middle_perp;
gen treatXlast_perp=treat*last_perp;
gen treatXperp_dummy=treat*perp_dummy;


label var treat "After Retraction";
label var treatXperp_dummy "After Retraction × Culpable Author";
label var treatXfirst_perp "After Retraction × Culpable Author is First Author";
label var treatXmiddle_perp "After Retraction × Culpable Author is a Middle Author";
label var treatXlast_perp "After Retraction × Culpable Author is Last Author";


/*regs for subset with a perp dummy*/

xtqmlp nbcites_it treat i.age i.yr if perp_dummy==1, fe i(id) cluster(case_code);
distinct case_code if e(sample);
estadd scalar nbcases=r(ndistinct);
distinct srce_pmid if e(sample);
estadd scalar nbsource=r(ndistinct);
estimates save estimates/poisson_main_subset_wperp.ster, replace;	


xtqmlp nbcites_it treat treatXfirst_perp treatXlast_perp i.age i.yr if perp_dummy==1, fe i(id) cluster(case_code);
distinct case_code if e(sample);
estadd scalar nbcases=r(ndistinct);
distinct srce_pmid if e(sample);
estadd scalar nbsource=r(ndistinct);
estimates save estimates/poisson_perpFX_perptype_subset_wperp.ster, replace;	





set emptycells drop;
set matsize 1000;
estimates drop _all;

estimates use estimates/poisson_main_subset_wperp.ster;
eststo;
estimates use  estimates/poisson_perpFX_perptype_subset_wperp.ster;
eststo;



esttab *, keep(treat treatXfirst_perp  treatXlast_perp) varwidth(25) nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(† 0.10 * 0.05 ** 0.01) compress scalars("nbcases Nb. of Retraction Cases" "nbsource Nb. of Source Articles" "N_g Nb. of Related/Control Articles" "N Nb. of Article-Year Obs." "ll Log Likelihood")  sfmt(%10.0fc %10.0fc %10.0fc %10.0fc) mlabels("(1)" "(2)") eqlabels(none);

esttab * using tables/perp_effects_regs.rtf, keep(treat treatXfirst_perp treatXlast_perp) varwidth(25) nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(† 0.10 * 0.05 ** 0.01) compress scalars("nbcases Nb. of Retraction Cases" "nbsource Nb. of Source Articles" "N_g Nb. of Related/Control Articles" "N Nb. of Article-Year Obs." "ll Log Likelihood")  sfmt(%10.0fc %10.0fc %10.0fc %10.0fc) mlabels("(1)" "(2)") eqlabels(none) replace;


