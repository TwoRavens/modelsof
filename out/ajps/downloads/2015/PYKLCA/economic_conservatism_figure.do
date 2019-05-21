version 11.0
log using "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism_figure.log", replace
#delimit ;

*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      economic_conservatism_figure.do                 *;
*       Date:           October 1, 2012                                 *;
*       Author:         MRG                                             *;
*       Purpose:      	Take economic_conservatism.dta and replicate    *;
*                       the results in Table 2.                         *;
* 	    Input File:     economic_conservatism.dta                       *;
*       Output File:    economic_conservatism_figure.log                *;
*       Data Output:    none                                            *;             
*       Previous file:  economic_conservatism.dta                       *;
*       Machine:        laptop                           				*;
*     ****************************************************************  *;
*     ****************************************************************  *;

set mem 400m;

use "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.dta", clear;

set more off;

sum;

desc;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Replicate Figure 1a                                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

gllamm inequality1 attend_religious_services income_level attendance_income_level 
        male highest_education age, i(id) link(ologit) adapt;
        
estimates store gllamm2;

*     ****************************************************************  *;
*       Figure 1a (top) -- odds ratio graph for religious participation *;
*       sity across income.                                             *;
*     ****************************************************************  *;

estimates restore gllamm2;

preserve;

set seed 10101;

drawnorm MG_b1-MG_b11, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost odds_hat0 lo0 hi0 using sim, replace;

noisily display "start";

local a=1;

while `a'<=3 {;

    {;
    
    generate x_betahat = MG_b1+MG_b3*(`a');
    
    gen odds0 = 100*(exp(x_betahat)-1);
    
    egen oddshat0=mean(odds);
    
    tempname odds_hat0 lo0 hi0;
    
    _pctile odds0, p(2.5, 97.5);
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);
    
    scalar `odds_hat0'=oddshat0;
    
    post mypost (`odds_hat0') (`lo0') (`hi0');
    
    };
    
    drop x_betahat odds0 oddshat0;
    local a=`a'+0.01;
    display "." _c;
    };
    
postclose mypost;

restore;

merge using sim;

summarize _merge;

drop _merge;

gen MV=((_n+99)/100);

replace  MV=. if _n>201;

graph twoway hist income_level, percent color(gs12) yaxis(2)
        ||   line odds_hat0 MV, clwidth(medium) clcolor(black) clpattern(solid)
        ||   line lo0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line hi0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
            xlabel(1 2 3, nogrid labsize(2)) 
            ylabel(-5 -4 -3 -2 -1 0 1 2 3 4 5, nogrid axis(1) labsize(2))
            ylabel(0 10 20 30 40, axis(2) nogrid labsize(2))
            yscale(noline alt)
            yscale(noline alt axis(2))
            xscale(noline)
            legend(off)
            yline(0, lcolor(black) lwidth(thin))
            xtitle("", size(2.5)  )
            ytitle("", axis(2) size(2.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));
                        
*     ****************************************************************  *;
*       Figure 1a (bottom) -- odds ratio graph for income across        *;
*       religious participation.                                        *;
*     ****************************************************************  *;
                       
drop  odds_hat0 lo0 hi0 MV;

estimates restore gllamm2;

preserve;

set seed 10101;

drawnorm MG_b1-MG_b11, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost odds_hat0 lo0 hi0 using sim, replace;

noisily display "start";

local a=1;

while `a'<=8 {;

    {;
    
    generate x_betahat = MG_b2+MG_b3*(`a');
    
    gen odds0 = 100*(exp(x_betahat)-1);
    
    egen oddshat0=mean(odds);
    
    tempname odds_hat0 lo0 hi0;
    
    _pctile odds0, p(2.5, 97.5);
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);
    
    scalar `odds_hat0'=oddshat0;
    
    post mypost (`odds_hat0') (`lo0') (`hi0');
    
    };
    
    drop x_betahat odds0 oddshat0;
    local a=`a'+0.01;
    display "." _c;
    };
    
postclose mypost;

restore;

merge using sim;

summarize _merge;

drop _merge;

gen MV=((_n+99)/100);

replace  MV=. if _n>701;

graph twoway hist attend_religious_services, percent color(gs12) yaxis(2)
        ||   line odds_hat0 MV, clwidth(medium) clcolor(black) clpattern(solid)
        ||   line lo0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line hi0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
            xlabel(1 2 3 4 5 6 7 8, nogrid labsize(2)) 
            ylabel(0 5 10 15 20 25 30 35 40 45, nogrid axis(1) labsize(2))
            ylabel(0 5 10 15 20 25, axis(2) nogrid labsize(2))
            yscale(noline alt)
            yscale(noline alt axis(2))
            xscale(noline)
            legend(off)
            yline(0, lcolor(black) lwidth(thin))
            xtitle("", size(2.5)  )
            ytitle("", axis(2) size(2.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));
            
*     ****************************************************************  *;
*     ****************************************************************  *;
*       Replicate Figure 1b                                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

clear;
clear mata;
clear matrix;

use "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.dta", clear;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

xtreg gov_responsibility attend_religious_services income_level attendance_income_level
        male highest_education age, i(id) theta;

*     ****************************************************************  *;
*       Figure 1b (top) -- marginal effect plot for religious           *;
*       participation across income.                                    *;
*     ****************************************************************  *;

generate MV=((_n-1)/100);

replace  MV=. if _n>302;

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

replace MV=. if _n<101;

*     ****************************************************************  *;
*       Calculate the marginal effect of religious participation.       *;
*     ****************************************************************  *;

gen conbx=b1+b3*MV if _n<302;

*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect.          *;
*     ****************************************************************  *;

gen consx=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<302; 

*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*     ****************************************************************  *;

gen ax=1.96*consx;
 
gen upperx=conbx+ax;
 
gen lowerx=conbx-ax;

gen yline=0;

graph twoway hist income_level, percent color(gs12) yaxis(2) 
        ||   line conbx   MV, clpattern(solid) clwidth(medium) clcolor(blue) clcolor(black) yaxis(1)  
        ||   line upperx  MV, clpattern(dash) clwidth(thin) clcolor(black) 
        ||   line lowerx  MV, clpattern(dash) clwidth(thin) clcolor(black) 
        ||   line yline  MV,  clwidth(thin) clcolor(black) clpattern(solid) 
        ||   ,  
             xlabel(1 2 3, nogrid labsize(2))  
             ylabel(-0.02 -0.01 0 0.01 0.02 0.03, nogrid axis(1) labsize(2)) 
             ylabel(0 10 20 30 40,  axis(2) nogrid labsize(2)) 
             yscale(noline alt) 
             yscale(noline alt axis(2)) 
             xscale(noline) 
             legend(off) 
             yline(0, lcolor(black) lwidth(thin)) 
             xtitle("" , size(2.5)  ) 
             ytitle("", axis(2) size(2.5)) 
             xsca(titlegap(2)) 
             ysca(titlegap(2)) 
             scheme(s2mono) graphregion(fcolor(white));
                                     
drop conbx consx ax upperx lowerx MV;

*     ****************************************************************  *;
*       Figure 1b (bottom) -- marginal effect plot for income across    *;
*       religious participation.                                        *;
*     ****************************************************************  *;

clear;
clear mata;
clear matrix;

use "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.dta", clear;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

xtreg gov_responsibility income_level attend_religious_services attendance_income_level 
        male highest_education age,  i(id) theta;

generate MV=((_n-1)/100);

replace  MV=. if _n>802;

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

replace MV=. if _n<101;

*     ****************************************************************  *;
*       Calculate the marginal effect of income.                        *;
*     ****************************************************************  *;

gen conbx=b1+b3*MV if _n<802;

*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect.          *;
*     ****************************************************************  *;

gen consx=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<802; 

*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*     ****************************************************************  *;

gen ax=1.96*consx;
 
gen upperx=conbx+ax;
 
gen lowerx=conbx-ax;

gen yline=0;

graph twoway hist attend_religious_services, percent color(gs12) yaxis(2) 
        ||   line conbx   MV, clpattern(solid) clwidth(medium) clcolor(blue) clcolor(black) yaxis(1)  
        ||   line upperx  MV, clpattern(dash) clwidth(thin) clcolor(black) 
        ||   line lowerx  MV, clpattern(dash) clwidth(thin) clcolor(black) 
        ||   line yline  MV,  clwidth(thin) clcolor(black) clpattern(solid) 
        ||   ,  
             xlabel(1 2 3 4 5 6 7 8, nogrid labsize(2))  
             ylabel(0 0.1 0.2 0.3, nogrid axis(1) labsize(2)) 
             ylabel(0 5 10 15 20 25,  axis(2) nogrid labsize(2)) 
             yscale(noline alt) 
             yscale(noline alt axis(2)) 
             xscale(noline) 
             legend(off) 
             yline(0, lcolor(black) lwidth(thin)) 
             xtitle("" , size(2.5)  ) 
             ytitle("", axis(2) size(2.5)) 
             xsca(titlegap(2)) 
             ysca(titlegap(2)) 
             scheme(s2mono) graphregion(fcolor(white));
                         
drop conbx consx ax upperx lowerx MV;

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Replicate Figure 1c                                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

clear;
clear mata;
clear matrix;

use "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.dta", clear;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

xtlogit free_market attend_religious_services income_level attendance_income_level 
        male highest_education age,  i(id) quad(30);

*     ****************************************************************  *;
*       Figure 1c (top) -- odds ratio plot for religious participation  *;
*       across income.                                                  *;
*     ****************************************************************  *;

preserve;

set seed 10101;

drawnorm MG_b1-MG_b8, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost odds_hat0 lo0 hi0 using sim, replace;

noisily display "start";

local a=1;

while `a'<=3 {;

    {;
    
    generate x_betahat = MG_b1+MG_b3*(`a');
   
    gen odds0 = 100*(exp(x_betahat)-1);
    
    egen oddshat0=mean(odds);
    
    tempname odds_hat0 lo0 hi0;
    
    _pctile odds0, p(2.5, 97.5);
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);
    
    scalar `odds_hat0'=oddshat0;
    
    post mypost (`odds_hat0') (`lo0') (`hi0');
    
    };
    
    drop x_betahat odds0 oddshat0;
    local a=`a'+0.01;
    display "." _c;
    };
    
postclose mypost;

restore;

merge using sim;

summarize _merge;

drop _merge;

gen MV=((_n+99)/100);

replace  MV=. if _n>201;

graph twoway hist income_level, percent color(gs12) yaxis(2)
        ||   line odds_hat0 MV, clwidth(medium) clcolor(black) clpattern(solid)
        ||   line lo0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line hi0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
            xlabel(1 2 3, nogrid labsize(2)) 
            ylabel(-4 -2 0 2 4 6 8 10 12, nogrid axis(1) labsize(2))
            ylabel(0 10 20 30 40, axis(2) nogrid labsize(2))
            yscale(noline alt)
            yscale(noline alt axis(2))
            xscale(noline)
            legend(off)
            yline(0, lcolor(black) lwidth(thin))
            xtitle("", size(2.5)  )
            ytitle("", axis(2) size(2.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));
                       
*     ****************************************************************  *;
*       Figure 1c (bottom) -- odds ratio plot for income across         *;
*       religious participation.                                        *;
*     ****************************************************************  *;

clear;
clear mata;
clear matrix;

use "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.dta", clear;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

xtlogit free_market income_level attend_religious_services attendance_income_level male highest_education age,  i(id) quad(30);

preserve;

set seed 10101;

drawnorm MG_b1-MG_b8, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost odds_hat0 lo0 hi0 using sim, replace;

noisily display "start";

local a=1;

while `a'<=8 {;

    {;
    
    generate x_betahat = MG_b1+MG_b3*(`a');
    
    gen odds0 = 100*(exp(x_betahat)-1);
    
    egen oddshat0=mean(odds);
    
    tempname odds_hat0 lo0 hi0;
    
    _pctile odds0, p(2.5, 97.5);
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);
    
    scalar `odds_hat0'=oddshat0;
    
    post mypost (`odds_hat0') (`lo0') (`hi0');
    
    };
    
    drop x_betahat odds0 oddshat0;
    local a=`a'+0.01;
    display "." _c;
    };
    
postclose mypost;

restore;

merge using sim;

summarize _merge;

drop _merge;

gen MV=((_n+99)/100);

replace  MV=. if _n>701;

graph twoway hist attend_religious_services, percent color(gs12) yaxis(2)
        ||   line odds_hat0 MV, clwidth(medium) clcolor(black) clpattern(solid)
        ||   line lo0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line hi0  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
            xlabel(1 2 3 4 5 6 7 8, nogrid labsize(2)) 
            ylabel(-15 -10 -5 0 5 10 15 20 25 30 35, nogrid axis(1) labsize(2))
            ylabel(0 5 10 15 20 25, axis(2) nogrid labsize(2))
            yscale(noline alt)
            yscale(noline alt axis(2))
            xscale(noline)
            legend(off)
            yline(0, lcolor(black) lwidth(thin))
            xtitle("", size(2.5)  )
            ytitle("", axis(2) size(2.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));
            
*     ****************************************************************  *; 
*     ****************************************************************  *;
*       The End                                                         *;
*     ****************************************************************  *; 
*     ****************************************************************  *;








