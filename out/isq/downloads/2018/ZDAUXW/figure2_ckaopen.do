cd "___YOUR_PATH_HERE___"
use 5_year.dta

cd "___YOUR_PATH_HERE___\supplement"

#delimit ;

qui xtivreg2 dckaopen_5 cabalance_5 lngdp_ppp2000_5 lngdppc_ppp2000_5 gov_fce_5 growth_gdppc2000_5 
  ln_inf_5 privcred_gdp_5 reserves_imports_5 savings_5 trade_5 peg_5 polity2_5 lckaopen_5 counter 
  (lcrisis_5 politycrisis_5 = listar_5 polityistar_5 distar_5), fe liml;


generate MV=_n - 11;

replace  MV=. if _n>22;

*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b1=b[1,1]; 
scalar b2=b[1,14]; 
scalar b3=b[1,2];


scalar varb1=V[1,1]; 
scalar varb2=V[14,14]; 
scalar varb3=V[2,2];

scalar covb1b3=V[1,2]; 
scalar covb2b3=V[2,2];

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;

*     ****************************************************************  *;
*       Calculate the marginal effect of X on Y for all MV values of    *;
*       the modifying variable Z.                                       *;
*     ****************************************************************  *;

gen conb=b1+b3*MV if _n<22;


*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect of X on Y *;
*       for all MV values of the modifying variable Z.                  *;
*     ****************************************************************  *;

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<22; 


*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*       Specify the significance of the confidence interval.            *;
*     ****************************************************************  *;

gen a=1.96*conse;
gen a2=1.64*conse;
 
gen upper=conb+a;
gen upper2=conb+a2;

gen lower=conb-a;
gen lower2=conb-a2;

*     ****************************************************************  *;
*       Graph the marginal effect of X on Y across the desired range of *;
*       the modifying variable Z.  Show the confidence interval.        *;
*     ****************************************************************  *;

graph twoway line conb   MV, lwidth(medium) lcolor(black)
        ||   line upper  MV, lpattern(dash) lwidth(thin) lcolor(black)
	  ||   line upper2 MV, lpattern(shortdash) lwidth(thin) lcolor(black)
        ||   line lower  MV, lpattern(dash) lwidth(thin) lcolor(black)
	  ||   line lower2 MV, lpattern(shortdash) lwidth(thin) lcolor(black)
        ||   ,   
             xlabel(-10 -5 0 5 10, labsize(2.5)) 
             ylabel(-5 -2.5 0 2.5 5,   labsize(2.5))
             legend(col(1) order(1 2 3) label(1 "Marginal Effect of CRISIS") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 "90% Confidence Interval")
						  label(4 " ")
						  label(5 " "))
             yline(0, lcolor(black) lwidth(thin))   
             xtitle( POLITY2, size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
             ytitle("Marginal Effect of CRISIS", size(3))
             scheme(s2mono) graphregion(fcolor(white));

graph save figure2_polity.gph, replace;
drop  MV conb conse a upper lower upper2 lower2 a2;

qui xtivreg2 dckaopen_5 cabalance_5 lngdp_ppp2000_5 lngdppc_ppp2000_5 gov_fce_5 growth_gdppc2000_5 
  ln_inf_5 privcred_gdp_5 reserves_imports_5 savings_5 trade_5 peg_5 polconiii_5 polity2_5 lckaopen_5 counter 
  (lcrisis_5 polconiiicrisis_5 = listar_5 polconiiiistar_5 distar_5), fe liml;

generate MV=(_n-1)/100;

replace  MV=. if _n>70;

*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b1=b[1,1]; 
scalar b2=b[1,14];
scalar b3=b[1,2];


scalar varb1=V[1,1]; 
scalar varb2=V[14,14]; 
scalar varb3=V[2,2];

scalar covb1b3=V[1,2]; 
scalar covb2b3=V[2,2];

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;

*     ****************************************************************  *;
*       Calculate the marginal effect of X on Y for all MV values of    *;
*       the modifying variable Z.                                       *;
*     ****************************************************************  *;

gen conb=b1+b3*MV if _n<70;


*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect of X on Y *;
*       for all MV values of the modifying variable Z.                  *;
*     ****************************************************************  *;

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<70; 


*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*       Specify the significance of the confidence interval.            *;
*     ****************************************************************  *;

gen a=1.96*conse;
gen a2=1.64*conse;
 
gen upper=conb+a;
gen upper2=conb+a2;

gen lower=conb-a;
gen lower2=conb-a2;

*     ****************************************************************  *;
*       Graph the marginal effect of X on Y across the desired range of *;
*       the modifying variable Z.  Show the confidence interval.        *;
*     ****************************************************************  *;

graph twoway line conb   MV, lwidth(medium) lcolor(black)
        ||   line upper  MV, lpattern(dash) lwidth(thin) lcolor(black)
	  ||   line upper2 MV, lpattern(shortdash) lwidth(thin) lcolor(black)
        ||   line lower  MV, lpattern(dash) lwidth(thin) lcolor(black)
	  ||   line lower2 MV, lpattern(shortdash) lwidth(thin) lcolor(black)
        ||   ,   
             xlabel(0 .1 .2 .3 .4 .5 .6 .7, labsize(2.5)) 
             ylabel(-5 -2.5 0 2.5 5,   labsize(2.5))
             legend(col(1) order(1 2 3) label(1 "Marginal Effect of CRISIS") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 "90% Confidence Interval")
						  label(4 " ")
						  label(5 " "))
             yline(0, lcolor(black) lwidth(thin))   
             xtitle(POLCON, size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
             scheme(s2mono) graphregion(fcolor(white));

graph save figure2_polcon.gph, replace;
drop  MV conb conse a upper lower upper2 lower2 a2;

graph combine figure2_polity.gph figure2_polcon.gph, scheme(s1mono);
graph save figure2_ckaopen, replace;
erase figure2_polity.gph;
erase figure2_polcon.gph;
