version 11.2
set more off
#delimit ;

*     **************************************************************************************  *;
*  Simulation for Table 2,Model 1  - Political Participation=0, Regime Age=2                          *;
*     **************************************************************************************  *;

xtpcse milgdp parcomp2mod lnage  bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997  & demcgx == 0, corr(ar1) pairwise;

preserve;
set seed 10101;

drawnorm JC_b1-JC_b9, n(1000) means(e(b)) cov(e(V)) clear;
save simulated_betas, replace;
restore;
merge using simulated_betas;
summarize _merge;

drop _merge;

scalar h_v1 = 1;

scalar h_v2 = 0.693147;

scalar h_v3 = 0.0020237;

scalar h_v4 = 0.0097748;

scalar h_v5 = 0.0149608;

scalar h_v6 = 0.0610798;

scalar h_v7 = 47600000;

scalar h_v8 = 3062.357;

scalar h_con = 1;

generate x_betahat1 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_con;

sum x_betahat1;

centile x_betahat1, centile(2.5 97.5);

*****Increase Political Participation to 5********;

scalar h_v1 = 5;

generate x_betahat2 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_con;

centile x_betahat2, centile(2.5 97.5);

generate diff1 = x_betahat2-x_betahat1;

sum x_betahat1 x_betahat2 diff1;

centile x_betahat1 x_betahat2 diff1, centile(2.5 97.5);


****Increase Regime Age to 20********;

scalar h_v1 = 1;

scalar h_v2 = 2.99573;

generate x_betahat3 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_con;

centile x_betahat3, centile(2.5 97.5);

generate diff2 = x_betahat3- x_betahat1;

sum x_betahat1 x_betahat3 diff2;

centile x_betahat1 x_betahat3 diff2, centile(2.5 97.5);

drop JC_b1 JC_b2 JC_b3 JC_b4 JC_b5 JC_b6 JC_b7 JC_b8 JC_b9  x_betahat1 x_betahat2 x_betahat3  diff1 diff2;



end do-file
