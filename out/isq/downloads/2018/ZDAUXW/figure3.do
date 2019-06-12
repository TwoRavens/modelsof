cd "___YOUR_PATH_HERE___"
use post96_panel.dta, clear

#delimit ;

qui xtreg dckaopen crisis2 polity2 politycrisis cabalance lngdp_ppp2000 lngdppc_ppp2000 gov_fce growth_gdppc2000
  ln_inf privcred_gdp reserves_imports savings trade peg polity2 lckaopen counter if year>1996, fe;

generate MV=_n-11;

replace  MV=. if _n>22;

*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];


scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];

scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];

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
             ylabel(-1 -.5 0 .5 1, labsize(2.5))
             legend(col(1) order(1 2 3) label(1 "Marginal Effect of CRISIS") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 "90% Confidence Interval")
						  label(4 " ")
						  label(5 " "))
             yline(0, lcolor(black) lwidth(thin))   
             xtitle( POLITY, size(3)  )
		 title(PANEL A)
             xsca(titlegap(2))
             ysca(titlegap(2))
             ytitle("Marginal Effect of CRISIS", size(3))
             scheme(s2mono) graphregion(fcolor(white));

graph save figure3_polity.gph, replace;
drop  MV conb conse a upper lower upper2 lower2 a2;

#delimit ;

qui xtreg dckaopen crisis2 polconiii polconiiicrisis cabalance lngdp_ppp2000 lngdppc_ppp2000 gov_fce growth_gdppc2000
  ln_inf privcred_gdp reserves_imports savings trade peg polconiii polity2 lckaopen counter if year>1996, fe;

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
scalar b2=b[1,2];
scalar b3=b[1,3];


scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];

scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];

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
             ylabel(-1 -.5 0 .5 1, labsize(2.5))
             legend(col(1) order(1 2 3) label(1 "Marginal Effect of CRISIS") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 "90% Confidence Interval")
						  label(4 " ")
						  label(5 " "))
             yline(0, lcolor(black) lwidth(thin))   
             xtitle( POLCON, size(3)  )
             title(PANEL B)
		 xsca(titlegap(2))
             ysca(titlegap(2))
             scheme(s2mono) graphregion(fcolor(white));

graph save figure3_polcon.gph, replace;
drop  MV conb conse a upper lower upper2 lower2 a2;


graph combine figure3_polity.gph figure3_polcon.gph, scheme(s1mono);
graph save figure3, replace;
erase figure3_polcon.gph;
erase figure3_polity.gph;
