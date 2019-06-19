/* THIS FILE RUNS THE MAIN REGRESSIONS FOR THE 2ND PAPER */

#delimit ;
set more 1;
log using "/volumes/ddisk/math/soviet/Table_2.log", replace;


use "/volumes/ddisk/math/ams/clean_ams_data_author_year.dta", replace;

generate good=.;
replace good=1 if year>=1970 & year<=1989;
egen n70=sum(good*papers), by(unique);
drop if n70==0;

merge unique using "/volumes/ddisk/math/ams/international/soviet_universe.dta";
drop _merge;

keep if soviet==1;
drop if emigre==1;

drop country;
rename modal_country country;

keep if year>=1982 & year<=2008;

sort unique;
merge unique using /volumes/ddisk/math/soviet/shocks_and_instruments.dta;
drop _merge;

drop if shock_idea_space==.;

generate publish=(papers>0);
summ publish papers ;


generate inter_shock1=post1992*shock_idea_space;
generate inter_pexp1=post1992*shock_geographic_space;
generate inter_paut1=post1992*shock_coauthor_space;
replace inter_paut1=0 if inter_paut1==.;

areg publish inter_shock1 post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);
areg publish  inter_pexp1  post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);
areg publish inter_paut1 post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);
areg publish inter_shock1 inter_pexp1 inter_paut1 post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);

areg papers inter_shock1 post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);
areg papers  inter_pexp1  post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);
areg papers inter_paut1 post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);
areg papers inter_shock1 inter_pexp inter_paut1 post1992 exper* dyear* , 
	absorb(unique) robust cluster(unique);


log close;



