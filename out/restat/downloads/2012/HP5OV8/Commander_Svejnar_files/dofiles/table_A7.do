#delimit;

/* use of the consolidated database with panel dummy */
use  "$data/final_data.dta", clear;
drop if owner_new4==1;

log using "$logs/tableA7.txt", text replace


/* TFP calculation */

egen sctr = group(branch country);

foreach var in mat pers nrg{;
	replace cost_`var' = . if cost_mat + cost_pers + cost_nrg > cost;
	gen `var'_share = cost_`var'/cost;
	egen `var'_shr = mean(`var'_share) if year == 2005, by(sctr);
	egen x = max(`var'_shr), by(sctr);
	replace `var'_shr = x if year == 2002;
	drop x;
	};

egen cap_share = rowtotal(mat_share pers_share nrg_share);
egen cap_shr = rowtotal(mat_shr pers_shr nrg_shr);
replace cap_share =. if cap_share == 0;
replace cap_share = 1 - cap_share;
replace cap_shr =. if cap_shr == 0;
replace cap_shr = 1 - cap_shr;
/*
gen cost_shr = pers_shr + cap_shr;
replace pers_shr = pers_shr/cost_shr;
replace cap_shr = cap_shr/cost_shr;
*/

gen logCU = log(Q2_3cap_utl);

gen tfp = logS - pers_shr*logE - cap_shr*logA - logCU;
gen tfp2 = logV - pers_shr*logE - cap_shr*logA;

rename Q2_3TOT_empR employR;
rename Q2_3perm_full_empR employR_ft;
rename Q2_3part_tm_empR employR_pt;
rename Q3ft_wrk_catRqC labskillR;
rename Q3edu_lbrRqD labuniR;
rename Q2_3ft_wrk_catqC labskill;
rename Q2_3edu_lbrqD labuni;

/* Variables */
local variables "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5
	exp_prc_sales constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK
	constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15 labunsec age labunsec_age
	employR_ft employR_pt employR labskill labuni labskillR labuniR perfqH perfqI  perfqJ_winsor  perfqG  perfqW_winsor
	branch year country prod2DIG sizeb regmac labunsec2 citytown materials
	tfp* logS logE logM logA logCU logExp pers_shr* mat_shr* cap_shr* cost_* *_share owner";

keep `variables';


/* programs */
run "$dofiles/tests.ado";
run "$dofiles/robust_hausman.ado";



/* For models */

local model1 "owner_new1 owner_new2 owner_new5";
local model2 "owner_new1 owner_new2 owner_new5 numcomp3";

local dummies "i.year i.country i.branch";


egen clstr = group(country prod2DIG sizeb year);

local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO
	constrqP constrqC constrqALL15";

egen obs = count(year), by(country prod2DIG sizeb year);
foreach var of local variables2 {;
   cap drop BI_`var';
   egen m =mean(`var'), by(country prod2DIG sizeb year);
   gen BI_`var' = (m*obs - `var')/(obs - 1);
   drop m;
  };

local constraints = "BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM  BI_constrqN BI_constrqP";


/* OLS */
gen x = 1;

foreach var in `constraints' {;
replace x = 0 if `var' ==.;
};

keep if x == 1;

xi: regress tfp `model2' `constraints' BI_constrqALL15, robust cluster(clstr);
outreg2 `model2' `constraints' BI_constrqALL15 using tables/tableA7, replace bdec(3) se bracket label;

foreach var in `constraints' BI_constrqALL15{;
	xi: regress tfp `model2' `var', robust cluster(clstr); 
		outreg2 `model2' `var' using tables/tableA7, append bdec(3) se bracket label;
	};

xi: regress tfp `model2' `constraints', robust cluster(clstr);
outreg2 `model2' `constraints' using tables/tableA7, append bdec(3) se bracket label;

/* with dummies */

xi: regress tfp `model2' `constraints' BI_constrqALL15 `dummies', robust cluster(clstr);
outreg2 `model2' `constraints' BI_constrqALL15 using tables/tableA7A, replace bdec(3) se bracket label;

foreach var in `constraints' BI_constrqALL15{;
	xi: regress tfp `model2' `var' `dummies', robust cluster(clstr); 
		outreg2 `model2' `var' using tables/tableA7A, append bdec(3) se bracket label;
	};

xi: regress tfp `model2' `constraints' `dummies', robust cluster(clstr);
outreg2 `model2' `constraints' using tables/tableA7A, append bdec(3) se bracket label;


log close