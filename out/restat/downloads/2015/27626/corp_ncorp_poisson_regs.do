#delimit;
clear;
version 13.1;
pause on;
program drop _all;
set more off;
capture log close;

/*INSERT FOLDER PATH*/
cd /;




use citations_panel_rltd_patentcites.dta, clear;

xtqmlp nbcites_ncorp_it treat treatXrltd_cited_in_patent i.age i.yr if shldrs==2, fe i(id) cluster(case_code);
distinct case_code if e(sample);
estadd scalar nbcases=r(ndistinct);
distinct pmid if e(sample);
estadd scalar nbsource=r(ndistinct);
estimates save estimates/patent_cites/poisson_rltd_cited_ncorp_cites.ster, replace;

xtqmlp nbcites_corp_it treat treatXrltd_cited_in_patent i.age i.yr if shldrs==2, fe i(id) cluster(case_code);
distinct case_code if e(sample);
estadd scalar nbcases=r(ndistinct);
distinct pmid if e(sample);
estadd scalar nbsource=r(ndistinct);
estimates save estimates/patent_cites/poisson_rltd_cited_corp_cites.ster, replace;


xtqmlp nbcites_ncorp_it treat  i.age i.yr if shldrs==2, fe i(id) cluster(case_code);
distinct case_code if e(sample);
estadd scalar nbcases=r(ndistinct);
distinct pmid if e(sample);
estadd scalar nbsource=r(ndistinct);
estimates save estimates/patent_cites/poisson_rltd_ncorp_cites.ster, replace;

xtqmlp nbcites_corp_it treat  i.age i.yr if shldrs==2, fe i(id) cluster(case_code);
distinct case_code if e(sample);
estadd scalar nbcases=r(ndistinct);
distinct pmid if e(sample);
estadd scalar nbsource=r(ndistinct);
estimates save estimates/patent_cites/poisson_rltd_corp_cites.ster, replace;



set emptycells drop;
	set matsize 1000;
	estimates drop _all;
	
	estimates use  estimates/patent_cites/poisson_rltd_cited_ncorp_cites.ster;
	eststo;
	estimates use  estimates/patent_cites/poisson_rltd_cited_corp_cites.ster;
	eststo;
	estimates use  estimates/patent_cites/poisson_rltd_ncorp_cites.ster;
	eststo;
	estimates use  estimates/patent_cites/poisson_rltd_corp_cites.ster;
	eststo;	
	
	esttab *, keep(treat treatXrltd_cited_in_patent) varwidth(25) nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(† 0.10 * 0.05 ** 0.01) compress scalars("nbcases Nb. of Retraction Cases" "nbsource Nb. of Source Articles" "N_g Nb. of Related/Control Articles" "N Nb. of Article-Year Obs." "ll Log Likelihood") sfmt(%10.0fc %10.0fc %10.0fc %10.0fc) mlabels("(1)" "(2)" "(4)" "(4)") eqlabels(none);
	
	esttab * using tables/poisson_corp_ncorp_patentcited.rtf, keep(treat treatXrltd_cited_in_patent) varwidth(25) nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(† 0.10 * 0.05 ** 0.01) compress scalars("nbcases Nb. of Retraction Cases" "nbsource Nb. of Source Articles" "N_g Nb. of Related/Control Articles" "N Nb. of Article-Year Obs." "ll Log Likelihood")sfmt(%10.0fc %10.0fc %10.0fc %10.0fc) mlabels("(1)" "(2)" "(4)" "(4)") eqlabels(none) replace;
	