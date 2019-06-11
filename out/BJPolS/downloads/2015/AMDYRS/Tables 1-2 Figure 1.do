#delimit;

set more off;

*     ****************************************************************  *;
*      Tables 1&2, Figure 1 for Conrad(2015),                           *;
*	   "How Democratic Alliances Solve the Power Parity Problem"		*;
*     ****************************************************************  *;


*Table 2*;

prob MID  powerparity FINALalliesmin2 interaction2 atopally jntd6 majdyad contig150 peaceyrs p2 p3, robust;

hetprob MID  powerparity FINALalliesmin2 interaction2 atopally jntd6 majdyad contig150 peaceyrs p2 p3, het(powerparity FINALalliesmin2 interaction2) vce(robust);

*Table 1*;
sum cap_1 cap_2 alliescap1 alliescap2 powerparity FINALalliesmin2 if e(sample), d;

*Figure 1*;

preserve;
set seed 10101;
drawnorm JC_b1-JC_b14, n(1000) means(e(b)) cov(e(V)) clear;


postutil clear;
postfile temp prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 diff_hat diff_lo diff_hi
            using sim , replace;
            noisily display "start";
            
                              




local FINALalliesmin2-10 ;
while `FINALalliesmin2' <= 10 { ;

    {;

scalar h_v1 = 1;
scalar h_v2 = -10;
scalar h_v3 = -5;
scalar h_v4 = 0;
scalar h_v5 = 0;
scalar h_v6 = 0;
scalar h_v7 = 0;
scalar h_v8 = 31.1938;
scalar h_v9 = 1933.45;
scalar h_v10 = 174252;
scalar h_con = 1;
scalar h_v12 = 1;
scalar h_v13 = -10;
scalar h_v14 = -5; 









	generate x_betahat1 =   JC_b1*0.5
                            + JC_b2*(`FINALalliesmin2')
                            + JC_b3*0.5*(`FINALalliesmin2')
                            + JC_b4*h_v4
                            + JC_b5*h_v5
							+ JC_b6*h_v6
							+ JC_b7*h_v7
							+ JC_b8*h_v8
							+ JC_b9*h_v9
							+ JC_b10*h_v10
							+ JC_b11*h_con;
							
	generate x_betahat2 =   JC_b1*1
                            + JC_b2*(`FINALalliesmin2')
                            + JC_b3*1*(`FINALalliesmin2')
                            + JC_b4*h_v4
                            + JC_b5*h_v5
							+ JC_b6*h_v6
							+ JC_b7*h_v7
							+ JC_b8*h_v8
							+ JC_b9*h_v9
							+ JC_b10*h_v10
							+ JC_b11*h_con;
    
	gen  x_betahatadj1 = x_betahat1/
						exp(JC_b12*0.5
						+JC_b13*(`FINALalliesmin2')
						+JC_b14*0.5*(`FINALalliesmin2'));

	gen  x_betahatadj2 = x_betahat2/
						exp(JC_b12*1
						+JC_b13*(`FINALalliesmin2')
						+JC_b14*1*(`FINALalliesmin2'));
    
	
	

    generate prob1 = normal(x_betahatadj1);
	generate prob2 = normal(x_betahatadj2);
	gen diff=((prob1-prob2)/prob2)*100;





    
  	egen probhat1=mean(prob1);
    egen probhat2=mean(prob2);
	egen diffhat= mean(diff);
    
	
    
    tempname prob_hat1 lo1 hi1  prob_hat2 lo2 hi2 diff_hat diff_lo diff_hi;

    
	_pctile prob1, p(2.5,97.5) ;
    scalar `lo1' = r(r1);
    scalar `hi1' = r(r2);  
	
	_pctile prob2, p(2.5,97.5) ;
    scalar `lo2' = r(r1);
    scalar `hi2' = r(r2);  
	
	_pctile diff, p(2.5,97.5) ;
    scalar `diff_lo' = r(r1);
    scalar `diff_hi' = r(r2);  
    
      	
	scalar `prob_hat1'=probhat1;
	scalar `prob_hat2'=probhat2;
    scalar `diff_hat'=diffhat;
      
    post temp (`prob_hat1') (`lo1') (`hi1') (`prob_hat2') (`lo2') (`hi2') 
                (`diff_hat') (`diff_lo') (`diff_hi') ;
				
    };      
    drop x_betahat1 x_betahat2 x_betahatadj1 x_betahatadj2 prob1 prob2 diff probhat1 probhat2 diffhat;
    local FINALalliesmin2=`FINALalliesmin2' + 1;
    display "." _c;
    } ;

display "";

postclose temp;

                              

use sim, clear;

gen MV = _n-11;
graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
		 ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
		 ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
		 || ,
		    xlabel(, labsize(3)) 
            ylabel(, labsize(3))
            yscale(noline)
            xscale(noline)
			legend(col(1) order(1 2)  	label(1 "First Difference (Power Preponderance to Power Parity)") 
										label(2 "95% Confidence Interval"))
		    yline(0)
			xtitle("Minimum Polity Score of Target State's Allies", size(3.5)  )
            ytitle("Percent Change in Probability of MID Initiation" "By Challenger", size(3.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));



log close;

exit;
