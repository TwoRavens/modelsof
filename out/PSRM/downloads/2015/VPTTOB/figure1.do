version 10.1
	#delimit;
	clear;
	pause on;
	set more off;
	  quietly log;
	  local logon = r(status);
	  if "`logon'" == "on" {; log close; };
	log using figure1, text replace;

		
				/************************************************************************/
		/* 	Author:		Olga Chyzh/Mark Nieman					  		*/
		/*	Date:		February 14, 2013			   		  		*/
		/*      File:		figure1.do					  		*/
		/*	Purpose:	Gray Maps for the Spatial Tax paper	*/
		/*             With Fixed Effects                              */
		/*      Input File:		tax_estimates.dta				*/
		/*      Output File:	 figure1.log, map_data.dta, yhat_change_Turkey.eps, yhat_change_Turkey.gph		*/
		/************************************************************************/
		
	clear matrix;
	clear mata;
	set	matsize 800;
	program drop _all;
	set seed 3;
	
	clear;
	
clear;
save se_data_map1.dta, replace emptyok;

clear;
save coeff_draws_map1.dta, replace emptyok;
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



use coeff_draws_map1, clear;
set obs 500;
drawnorm b1-b162, mean(B) cov(V);
save coeff_draws_map1, replace;


forvalues num=1/100 {;
use coeff_draws_map1, clear;

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
di `num';
di `t';
append using se_data_map1.dta;
save se_data_map1.dta, replace;
save "sims/se_data_num`num'_t`t'", replace;
local h=`num'-1;
local d=`t'-1;
capture erase "sims/se_data_num`h'_t`d'.dta";
};

};


use se_data_map1.dta, clear;
collapse (mean) yhat_shock1 yhat1, by(t ccode);

xtset ccode t;

gen yhat_change=yhat_shock1-yhat1;
gen yhat_diff= yhat_change-L.yhat_change;

replace t=t-1;

save map_data.dta, replace;



	/************************************************/
	/* Convert the raw map data into Stata format. 	*/
	/************************************************/

clear;
shp2dta using "world\world", database(worlddb) coordinates(worldcoord) genid(ID) replace;

	/************************************************/
	/* Now open the data to be graphed and merge 	*/
	/* with the created identification database. 	*/
	/************************************************/

	use worlddb, clear;
rename NAME cname;
replace cname=trim(itrim(cname));
replace cname=lower(cname);
replace cname=proper(cname);
replace cname="Antigua & Barbuda" if cname=="Antigua And Barbuda ";
replace cname="Bosnia and Herzegovina " if cname=="Bosnia And Herzegovina";
replace cname="Democratic Republic of the Congo" if cname=="Congo, The Democratic Republic Of The";
replace cname="Ivory Coast" if cname=="Cote D'Ivoire";
replace cname="Federated States of Micronesia" if cname=="Micronesia, Federated States Of";
replace cname="North Korea" if cname=="Korea, Democratic People'S Republic Of";
replace cname="South Korea" if cname=="Korea, Republic Of";
replace cname="Laos" if cname=="Lao People'S Democratic Republic";
replace cname="Libya" if cname=="Libya, Arab Jamahiriy_";
replace cname="Macedonia" if cname=="Macedonia, The Former Yugoslav Republic";
replace cname="Moldova" if cname=="Moldova, Republic Of";
replace cname="Russia" if cname=="Russian Federation";
replace cname="Taiwan" if cname=="Taiwan, Province of China";
replace cname="United States of America" if cname=="United States";
replace cname="Sao Tome and Principe" if cname=="Sao Tome And Principe ";
replace cname="Trinidad and Tobago " if cname=="Trinidad And Tobago";
rename cname country;
do http://www.uky.edu/~clthyn2/replace_ccode_country.do;
drop if ccode==.;
drop if ccode==-999;
drop if ccode>999;

save  worlddb, replace;	

#delimit;
use map_data.dta, clear;


joinby ccode using worlddb.dta, _merge(_merge_country) unmatched(both);




/*Figure 1. Predicted Long_term Cumulative Changes in Tax Revenue, Resulting from a 1 s.d. Counterfactual Shock to Economic Development (decease in Agriculture) in Turkey.*/
#delimit;
spmap yhat_change using worldcoord if t==19, id(ID) 
	fcolor(Greys)	
	clmethod(custom)
	clbreaks( -.0001066 0  .0000269 .0117797 .0117799 )
	saving("tables/yhat_change_Turkey", replace)
	ysize(3) xsize(5)
	legend(placement(9))
	legt("Change in Tax Ratio")	
	ndfcolor(blue)
	legend(label (5 "Turkey") label(4 "Moderate") label(3 "Small") label(2 "Negative") label(1 "No Data"));
	
	graph export "tables/yhat_change_Turkey.eps", replace;

/*Delete unnecessary files to save disk space*/
erase se_data_map1.dta;
erase coeff_draws_map1.dta;
erase map_data.dta;
erase cont_st_W.dta;
erase riv_st_W.dta;
erase regsim_st_W.dta;
erase trade_st_W.dta;
erase io_ec_st_W.dta;
	

log close;

