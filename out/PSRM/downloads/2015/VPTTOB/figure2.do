version 10.1
	#delimit;
	clear;
	pause on;
	set more off;
	  quietly log;
	  local logon = r(status);
	  if "`logon'" == "on" {; log close; };
	log using figure2, text replace;

		/************************************************************************/
		/* 	Author:		Olga Chyzh/Mark Nieman					  		*/
		/*	Date:		June 8, 2014			   		  		*/
		/*  Prev. File:		tax_se04.do					  		*/
		/*	Purpose:	Substantive Effects for the Spatial Tax paper	*/
		/*             With Fixed Effects, Confidence Intervals                             */
		/*					Shock to Turkey's Agriculture, effect on Greece*/
		/*      Input File:		tax_estimates.dta				*/
		/*      Output Files:	figure2.log, Greece_diff_dollars.eps, Greece_diff_dollars.gph,  "sims/se_data_num*_t*.dta"*/
		/************************************************************************/
		
	clear matrix;
	clear mata;
	set seed 24241;
	set	matsize 11000;
	program drop _all;
	
	
clear;
save se_data.dta, replace emptyok;

clear;
save coeff_draws.dta, replace emptyok;
	#delimit;

	tempfile temp temp1;

/*Make a global of the number of betas - number of rhos and sigma*/
global n_betas = 156;

use tax_estimates.dta, clear;


keep b_fe*;

aorder;
keep if b_fe1!=.;
mkmat b_fe*, matrix(B);


use tax_estimates.dta, clear;
keep V_fe*;
keep if V_fe1!=.;
mkmat   V_fe*, matrix(V);



/*Fixed Part of the Data*/
use tax_estimates.dta, clear;
drop if ccode==.;

egen max_year=max(year), by(ccode); 

keep if year==max_year;
preserve;
keep ccode open debt inflation  agri oda log_gdpenl ethfrac relfrac lag_taxratio 
cwar federal nwstate instab oil1 pres_dem monarch milit party_aut pers_aut other oilprice2009barrel;


/*Get the number of countries to use in making the identity matrix later*/

sum ccode;
local N=r(N);
save `temp', replace;


/*Preparing the spatial part of the data*/

use tax_estimates.dta, clear;
drop if ccode1==. | ccode2==.;
save `temp1', replace;

/*Using temp to get the same set of countries in the monadic and dyadic data*/
use `temp', clear;
rename ccode ccode1;
keep ccode1;
merge 1:m ccode1 using `temp1', gen(_merge_temp1);
drop if _merge_temp1==2;
drop _merge_temp1;
save `temp1', replace;

use `temp', clear;
rename ccode ccode2;
keep ccode2;
merge 1:m ccode2 using `temp1', gen(_merge_temp2);
drop if _merge_temp2==2;
save `temp1', replace;

collapse (mean) cont_st  riv_st regsim_st trade_st io_ec_st , by(ccode1 ccode2) cw;

save `temp1', replace;



/*Making Matrices*/
#delimit;
foreach var in  cont_st riv_st regsim_st trade_st io_ec_st  {;
use `temp1', clear;
sort ccode1 ccode2;
keep ccode1 ccode2 `var';
drop if ccode1 ==. | ccode2==.;

reshape wide `var', i(ccode1) j(ccode2);
recode `var'* (.=0);
mkmat `var'*, matrix(`var'_W);
save `var'_W, replace;
};



/*Making an Identiity Matrix*/
use `temp', clear;
matrix  I = I(`N');

/*Creating Over-time effects*/
use `temp', clear;
gen agri1=agri;
replace agri1=agri1-.08 if ccode==640;

expand 20;
bysort ccode: gen t=_n;
gen cons=1;

/*Re-generate country dummies*/ 
tabulate ccode, gen(country);
gen lag_taxratio_shock=lag_taxratio;
gen lag_taxratio_actual=lag_taxratio; 
save `temp', replace;



use coeff_draws, clear;
set obs 500;
drawnorm b1-b162, mean(B) cov(V);
save coeff_draws, replace;

#delimit;
forvalues num=1/100 {;
use coeff_draws, clear;

keep if _n==`num';
mkmat b1-b$n_betas, matrix(beta);

/*Save Rhos */
local Rho1=b157;
local Rho2=b158;
local Rho3=b159;
local Rho4=b160;
local Rho5=b161;
matrix inv=inv(I-(`Rho1'*cont_st_W)-(`Rho2'*riv_st_W)-(`Rho3'*regsim_st_W)-(`Rho4'*trade_st_W)-(`Rho5'*io_ec_st_W));

use `temp', clear;
sort ccode;
keep if t==1;
mkmat lag_taxratio, matrix(Y);
mkmat lag_taxratio, matrix(Y_shock);

forvalues t=1/20 {;
use `temp', clear;
sort ccode;
keep if t==`t'; 
svmat Y, names(yhat);
svmat Y_shock, names(yhat_shock);
replace lag_taxratio=yhat1;
replace lag_taxratio_shock=yhat_shock1;
drop yhat1 yhat_shock1;
mkmat  open cwar debt inflation  agri oda federal log_gdpenl ethfrac relfrac nwstate instab oil1 
pres_dem monarch milit party_aut pers_aut other oilprice2009barrel lag_taxratio 
country1-country37 country39-country104 country106-country116 country118-country137 cons, matrix(X);
mkmat  open cwar debt inflation  agri1 oda federal log_gdpenl ethfrac relfrac nwstate instab oil1 
pres_dem monarch milit party_aut pers_aut other oilprice2009barrel lag_taxratio_shock 
country1-country37 country39-country104 country106-country116 country118-country137 cons, matrix(X1);
matrix Xbeta=beta*X';
matrix Xbeta1=beta*X1';
matrix Y=((Xbeta)*inv)';
matrix Y_shock=((Xbeta1)*inv)';
svmat Y, names(yhat);
svmat Y_shock, names(yhat_shock);
gen num=`num';
keep if ccode==350;
di `num';
di `t';
append using se_data.dta;
save se_data, replace;
save "sims/se_data_num`num'_t`t'", replace;
};

};

#delimit;
use se_data, clear;

xtset num t;

gen yhat_change=yhat_shock1-yhat1;
gen yhat_diff= yhat_change-L.yhat_change;


collapse (mean) yhat_diff (p5) yhat_diff_lo=yhat_diff (p95) yhat_diff_hi=yhat_diff, by(t);

replace t=t-1;


 
/*Figure 2. Spatio-Temporal Effects on Tax Ratio in Greece from a 1 sd Counterfactual Shock to Economic Development (decrease in Agriculture) in Turkey.*/
 
twoway line  yhat_diff  yhat_diff_lo  yhat_diff_hi t, scheme(s1mono) 
ylabel(.000021 "2.5" 0.000042 "5" 0.000063 "7.5" 0.000084 "10") ytitle("Tax Ratio," "Increase From Previous Year, $US (in millions)")  xscale(range(2 20)) xticks(2(2)20)
 lcolor(black dkgray dkgray) lpattern(salid dash dash) saving("tables/Greece_diff_dollars", replace) legend(off) note("Note: Dashed lines represent 90% Confidence Interval.");
  #delimit;
 graph export "tables/Greece_diff_dollars.eps", replace;
 
 /*Delete unnecessary files to save disk space*/
 erase se_data.dta;
 erase coeff_draws.dta;
 erase cont_st_W.dta;
erase riv_st_W.dta;
erase regsim_st_W.dta;
erase trade_st_W.dta;
erase io_ec_st_W.dta;


log close;
 
 
