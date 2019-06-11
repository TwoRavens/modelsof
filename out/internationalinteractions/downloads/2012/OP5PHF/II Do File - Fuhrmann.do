*Replication file for:
*Fuhrmann, Matthew. 2012. "Splitting Atoms: Why Do Countries Build Nuclear Power Plants?" International Interactions (forthcoming).

********************************************************************************************************************************************
*Table 2: Determinants of Nuclear Power Plant Construction
********************************************************************************************************************************************
probit  prxbegin1 lngdp econgrow lnenergydep tmiprech chernobyl programsw supally sprival npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)
probit  prxbegin1 lngdp econgrow lnenergydep tmiprech chernobyl exploreprgm supally sprival npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)
probit  prxbegin1 lngdp econgrow lnenergydep tmiprech chernobyl nucaccalt5 programsw supally sprival npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)
probit  prxbegin1  lngdp econgrow lnenergydep tmiprech polity2Xtmiprech chernobyl polity2Xchernob  polity2 supally sprival programsw npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)
probit  prxbegin1  lngdp econgrow lnenergydep tmiprech usneighb tmiprechXus chernobyl sovneighb chernobylXsov  programsw supally sprival npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)
probit  prxbegin1  lngdp econgrow lnenergydep tmiprech npcommitdumXtmiprech chernobyl programsw supally sprival npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)
probit  prxbegin1  lngdp econgrow lnenergydep tmiprech npcommitdumXtmiprech tmiprechXus polity2Xtmiprech usneighb chernobyl chernobylXsov polity2Xchernob sovneighb polity2 supally sprival programsw npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode)

********************************************************************************************************************************************
*Figure 1: Marginal effect of nuclear accidents by polity (based on M1)
********************************************************************************************************************************************
#delimit;
probit  prxbegin1 chernobyl polity2 polity2Xchernob lngdp econgrow lnenergydep tmiprech polity2Xtmiprech  supally sprival programsw npt npcommitdum noprxbegin1yrs _spline1prxbegin1 _spline2prxbegin1 _spline3prxbegin1 , cluster(ccode);
preserve;
drawnorm MF_b1-MF_b18, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using "sim_polity.dta"  , replace;
            noisily display "start";          
           
local a=0; 
while `a' <= 20  {;

quietly display "got here";
quietly {;

scalar h_chernobyl=0;
scalar h_lnenergydep=4.25;
scalar h_lngdp=16.87;
scalar h_econgrow=3.89;
scalar h_tmiprech=0;
scalar h_polity2Xtmiprech=0;
scalar h_programsw=0;
scalar h_npt=1;
scalar h_supally=0;
scalar h_sprival=0;
scalar h_npcommitdum=0;
scalar h_noprxbegin1yrs=0;
scalar h__spline1prxbegin1=0;
scalar h__spline2prxbegin1=0;
scalar h__spline3prxbegin1=0;
scalar h_constant=1;

    generate x_betahat0 = MF_b1*h_chernobyl
                            + MF_b2*(`a')
                            + MF_b3*h_chernobyl*(`a')
					+ MF_b4*h_lngdp
                            + MF_b5*h_econgrow
                            + MF_b6*h_lnenergydep
                            + MF_b7*h_tmiprech
                            + MF_b8*h_polity2Xtmiprech
                            + MF_b9*h_programsw
                            + MF_b10*h_supally
                            + MF_b11*h_sprival
                            + MF_b12*h_npt
                            + MF_b13*h_npcommitdum
                            + MF_b14*h_noprxbegin1yrs
                            + MF_b15*h__spline1prxbegin1
                            + MF_b16*h__spline2prxbegin1
                            + MF_b17*h__spline3prxbegin1
                            + MF_b18*h_constant;
                              
    generate x_betahat1 = MF_b1*(h_chernobyl+1)
                            + MF_b2*(`a')
                            + MF_b3*(h_chernobyl+1)*(`a')
				    + MF_b4*h_lngdp
                            + MF_b5*h_econgrow
                            + MF_b6*h_lnenergydep
                            + MF_b7*h_tmiprech
                            + MF_b8*h_polity2Xtmiprech
                            + MF_b9*h_programsw
                            + MF_b10*h_supally
                            + MF_b11*h_sprival
                            + MF_b12*h_npt
                            + MF_b13*h_npcommitdum
                            + MF_b14*h_noprxbegin1yrs
                            + MF_b15*h__spline1prxbegin1
                            + MF_b16*h__spline2prxbegin1
                            + MF_b17*h__spline3prxbegin1
                            + MF_b18*h_constant;

  gen prob0=normal(x_betahat0);
    gen prob1=normal(x_betahat1);
    gen diff=prob1-prob0;
    
    egen probhat0=mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ;  

    _pctile prob0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(5,95);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(5,95);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
  
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi') ;
    };      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat ;
    local a=`a'+ 1 ;
    display "." _c;
    } ;
display "";
postclose mypost;
use "sim_polity.dta", clear;
gen MV = _n-1;
graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
            xlabel(0 2 4 6 8 10 12 14 16 18 20 , labsize(2)) 
            ylabel(-.16 -.14 -.12 -.1 -.08 -.06 -.04 -.02 0, labsize(2))
            yscale(noline)
            xscale(noline)

            
            legend(off)
            title(" ", size(3.1))
            subtitle(" " "" " ", size(3))
            xtitle(Polity Score, size(3.5)  )
            ytitle("Marginal Effect of Chernobyl", size(3.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));

clear;

