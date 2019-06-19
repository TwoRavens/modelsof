#delimit ;
set more 1;
log using "/volumes/ddisk/math/soviet/Tables_3_and_4.log", replace;


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

generate inst_shock1=post1992*instrument_idea_space;
generate inst_pexp1=post1992*instrument_geographic_space;
generate inst_paut1=post1992*instrument_coauthor_space;
replace inst_paut1=0 if inst_paut1==.;

xtivreg2 publish post1992 exper* dyear* 
	(inter_shock1 =
	inst_shock1) , 
	fe i(unique) first cluster(unique);
xtivreg2 publish post1992 exper* dyear* 
	(inter_pexp1 =
	inst_pexp1) , 
	fe i(unique) first cluster(unique);
xtivreg2 publish post1992 exper* dyear* 
	(inter_paut1 =
	inst_paut1) , 
	fe i(unique) first cluster(unique);
xtivreg2 publish post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) first cluster(unique);

xtivreg2 papers post1992 exper* dyear* 
	(inter_shock1 =
	inst_shock1) , 
	fe i(unique) first cluster(unique);
xtivreg2 papers post1992 exper* dyear* 
	(inter_pexp1 =
	inst_pexp1) , 
	fe i(unique) first cluster(unique);
xtivreg2 papers post1992 exper* dyear* 
	(inter_paut1 =
	inst_paut1) , 
	fe i(unique) first cluster(unique);
xtivreg2 papers post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) first cluster(unique);


*****************;

*MERGING IN DATA THAT HAS DEPENDENT VARIABLES "TOP JOURNALS" AND "COAUTHOR SHARE";
*REGRESSIONS IN COLUMNS 5 AND 6 OF TABLE 4;
*REGRESSIONS WILL BE RUN USING TWO SPECIFICATIONS;
*MISSING WILL BE TREATED AS MISSING OR SET TO ZERO;


sort unique year;
merge unique year using /volumes/ddisk/math/soviet/hard_outcome_variables.dta;
drop _merge;

rename author_share_papers share_of_papers;

generate top_publish=(top_papers>0);
replace top_publish=. if top_papers==.;

xtivreg2 top_publish post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) cluster(unique);
xtivreg2 top_papers post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) cluster(unique);
xtivreg2 share_of_papers post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) cluster(unique);

replace share_of_papers=0 if share_of_papers==.;
replace top_publish=0 if top_publish==.;
replace top_papers=0 if top_papers==.;

xtivreg2 top_publish post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) cluster(unique);
xtivreg2 top_papers post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) cluster(unique);
xtivreg2 share_of_papers post1992 exper* dyear* 
	(inter_shock1 inter_pexp1 inter_paut1=
	inst_shock1 inst_pexp1 inst_paut1) , 
	fe i(unique) cluster(unique);


log close;



