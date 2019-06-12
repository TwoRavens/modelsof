set more off
set matsize 1000

* Reformat Table 02

* Start with man send
use tables\Table2_mansenddyadmatches.dta
keep if subset =="all"
foreach var of varlist n_dyads_all n_men n_women pvalue_diff_nomiss mrate_mansend_nomiss mrate_nomiss {
	rename `var' ms_`var'
	}

keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss
		
* Join conditional reply analysis
joinby dv using tables\Table2_condlreplydyadmatches.dta
keep if subset =="all"
drop subset

foreach var of varlist n_cr_dyads_all n_men n_women pvalue_diff_nomiss mrate_nomiss {
	rename `var' cr_`var'
	}

keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss
	
* Join bothsend analysis
joinby dv using tables\Table2_bothsenddyadmatches.dta
keep if subset =="all"
drop subset

foreach var of varlist n_dyads_all n_men n_women pvalue_diff_nomiss mrate_bothsend_nomiss mrate_nomiss {
	rename `var' bs_`var'
	}
	
keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss bs_n_dyads_all bs_n_men bs_n_women bothsendrate bs_mrate_nomiss bs_mrate_bothsend_nomiss bs_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss bs_n_dyads_all bs_n_men bs_n_women bothsendrate bs_mrate_nomiss bs_mrate_bothsend_nomiss bs_pvalue_diff_nomiss

outsheet using tables\Table02_DescriptiveMatchRates.csv, comma replace
clear

* Reformat Table S07, Panel A

* Start with man send
use tables\Table2_mansenddyadmatches.dta
keep if subset =="lfltkids"
foreach var of varlist n_dyads_all n_men n_women pvalue_diff_nomiss mrate_mansend_nomiss mrate_nomiss {
	rename `var' ms_`var'
	}

keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss
		
* Join conditional reply analysis
joinby dv using tables\Table2_condlreplydyadmatches.dta
keep if subset =="lfltkids"
drop subset

foreach var of varlist n_cr_dyads_all n_men n_women pvalue_diff_nomiss mrate_nomiss {
	rename `var' cr_`var'
	}

keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss
	
* Join bothsend analysis
joinby dv using tables\Table2_bothsenddyadmatches.dta
keep if subset =="lfltkids"
drop subset

foreach var of varlist n_dyads_all n_men n_women pvalue_diff_nomiss mrate_bothsend_nomiss mrate_nomiss {
	rename `var' bs_`var'
	}
	
keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss bs_n_dyads_all bs_n_men bs_n_women bothsendrate bs_mrate_nomiss bs_mrate_bothsend_nomiss bs_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss bs_n_dyads_all bs_n_men bs_n_women bothsendrate bs_mrate_nomiss bs_mrate_bothsend_nomiss bs_pvalue_diff_nomiss

outsheet using tables\TableS07_A_DescriptiveMatchRates_LongTermWantKids.csv, comma replace

clear

* Reformat Table S07, Panel B

* Start with man send
use tables\Table2_mansenddyadmatches.dta
keep if subset =="domsg5"
foreach var of varlist n_dyads_all n_men n_women pvalue_diff_nomiss mrate_mansend_nomiss mrate_nomiss {
	rename `var' ms_`var'
	}

keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss
		
* Join conditional reply analysis
joinby dv using tables\Table2_condlreplydyadmatches.dta
keep if subset =="domsg5"
drop subset

foreach var of varlist n_cr_dyads_all n_men n_women pvalue_diff_nomiss mrate_nomiss {
	rename `var' cr_`var'
	}

keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss
	
* Join bothsend analysis
joinby dv using tables\Table2_bothsenddyadmatches.dta
keep if subset =="domsg5"
drop subset

foreach var of varlist n_dyads_all n_men n_women pvalue_diff_nomiss mrate_bothsend_nomiss mrate_nomiss {
	rename `var' bs_`var'
	}
	
keep dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss bs_n_dyads_all bs_n_men bs_n_women bothsendrate bs_mrate_nomiss bs_mrate_bothsend_nomiss bs_pvalue_diff_nomiss
order dv ms_n_dyads_all ms_n_men ms_n_women mansendrate ms_mrate_nomiss ms_mrate_mansend_nomiss ms_pvalue_diff_nomiss cr_n_cr_dyads_all cr_n_men cr_n_women crrate cr_mrate_nomiss mrate_cr_nomiss cr_pvalue_diff_nomiss bs_n_dyads_all bs_n_men bs_n_women bothsendrate bs_mrate_nomiss bs_mrate_bothsend_nomiss bs_pvalue_diff_nomiss

outsheet using tables\TableS07_B_DescriptiveMatchRates_DepthOfMessaging.csv, comma replace



