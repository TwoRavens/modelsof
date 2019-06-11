version 11.12
set more off
#delimit ;


g GTDpolitylag=GTDDomesticlag*p_polity2lagrecode;


oprobit LoTMilitaryRecode GTDDomesticlag p_polity2lagrecode GTDpolitylag gdppclag poplag civilwarlag ucdp_type2lag catlag RstrctAccess dissentlag, robust cluster (ccodecow) nolog;

preserve;
drawnorm JC_b1-JC_b15, n(10000) means(e(b)) cov(e(V)) clear;


postutil clear;
postfile temp prob_hat5a lo5a hi5a prob_hat5b lo5b hi5b diff_hat5 diff_lo5 diff_hi5
            using sim , replace;
            noisily display "start";
            
                              

local p_polity2lagrecode=0 ;
while `p_polity2lagrecode' <= 20 { ;

    {;

scalar h_1=0;
scalar h_4=6807.79;
scalar h_5=27218.7;
scalar h_6=0;
scalar h_7=0;
scalar h_8=1;
scalar h_9=0;
scalar h_10=0;


	generate x_betahat4a = JC_b15-(JC_b1*h_1
                            + JC_b2*(`p_polity2lagrecode')
                            + JC_b3*h_1*(`p_polity2lagrecode')
                            + JC_b4*h_4
                            + JC_b5*h_5
                            + JC_b6*h_6
							+ JC_b7*h_7
							+ JC_b8*h_8
							+ JC_b9*h_9
							+ JC_b10*h_10);
    
    
    generate x_betahat4b = JC_b15-(JC_b1*(h_1+20)
                            + JC_b2*(`p_polity2lagrecode')
                            + JC_b3*(h_1+20)*(`p_polity2lagrecode')
                            + JC_b4*h_4
                            + JC_b5*h_5
                            + JC_b6*h_6
							+ JC_b7*h_7
							+ JC_b8*h_8
							+ JC_b9*h_9
							+ JC_b10*h_10);

    
	
	gen prob5a=1-normal(x_betahat4a);
    gen prob5b=1-normal(x_betahat4b);
    gen diff5=prob5b-prob5a;
    
  	egen probhat5a=mean(prob5a);
    egen probhat5b=mean(prob5b);
    egen diffhat5=mean(diff5);
	
    
    tempname prob_hat5a lo5a hi5a prob_hat5b lo5b hi5b diff_hat5 diff_lo5 diff_hi5;  

    
	_pctile prob5a, p(2.5,97.5) ;
    scalar `lo5a' = r(r1);
    scalar `hi5a' = r(r2);  
    
    _pctile prob5b, p(2.5,97.5);
    scalar `lo5b'= r(r1);
    scalar `hi5b'= r(r2);  
    
    _pctile diff5, p(2.5,97.5);
    scalar `diff_lo5'= r(r1);
    scalar `diff_hi5'= r(r2);  
	
    	
	scalar `prob_hat5a'=probhat5a;
    scalar `prob_hat5b'=probhat5b;
    scalar `diff_hat5'=diffhat5;
    
    post temp (`prob_hat5a') (`lo5a') (`hi5a') (`prob_hat5b') (`lo5a') (`hi5b') 
                (`diff_hat5') (`diff_lo5') (`diff_hi5') ;
				
    };      
    drop x_betahat4a x_betahat4b prob5a prob5b diff5 probhat5a probhat5b diffhat5;
    local p_polity2lagrecode=`p_polity2lagrecode' + 1 ;
    display "." _c;
    } ;

display "";

postclose temp;

                              

use sim, clear;

gen MV = _n-1;

graph twoway line diff_hat5 MV, clwidth(medium) clcolor(blue) 
        ||   line diff_lo5  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line diff_hi5  MV, clpattern(dash) clwidth(thin) clcolor(black)
      	||  ,
            xlabel(, labsize(3)) 
            ylabel(, labsize(3))
            yscale(noline)
            xscale(noline)
			legend(col(1) order(1 2)  label(1 "Marginal Effect of Increasing Attacks from 0 to 20") 
                                      label(2 "95% Confidence Interval") 
                                      label(3 " "))
            yline(0)
            title("Marginal Effect of Increase in Domestic Attacks (0 to 20 Attacks)" "on the Probability of Systemic Military Torture", size(4))
            subtitle(" " "At Varying Levels of Democracy" " ", size(3))
            xtitle("Level of Democracy", size(3.5)  )
            ytitle("Marginal Effect of Domestic Attacks", size(3.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));



exit; 
