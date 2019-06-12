
use "d:/users/andrey/dropbox/data/investing in violence/replication.dta", clear

ivprobit coup agereg csum unrest milreg  milper1 gdppc3 gdppcgrowth    milexp3 coupyears  t t2 t3 (lnfdi3= mwlgdp agrprop larea) if democracy<1 , cluster(ccode) robust first
	
	
	#delimit ;
	preserve;
drawnorm MG_b1-MG_b32, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using sim , replace;
            noisily display "start";

local a=-10 ;
while `a' <= 6{ ;

    {;

		scalar h_X= 1.8;
scalar h_C2=0;
scalar h_C3=16;
scalar h_C4=4.6;
scalar h_C5= 0 ;
scalar h_C6=2.99 ;
scalar h_C7=6.49 ;
scalar h_C8=1.63;
scalar h_C9=.24 ;
scalar h_C10=16;
scalar h_C11=9;
scalar h_C12=100;
scalar h_C13=720;
scalar h_constant=1;
	
	
	
scalar h_constant=1;

    generate x_betahat0 = MG_b1*`a'
                            + MG_b2*h_C2
                            + MG_b3*h_C3
							+ MG_b4*h_C4
							+ MG_b5*h_C5
							+ MG_b6*h_C6
							+ MG_b7*h_C7
							+ MG_b8*h_C8
							+ MG_b9*h_C9
							+ MG_b10*h_C10
							+ MG_b11*h_C11
							+ MG_b12*h_C12
                            + MG_b13*h_C13
							+ MG_b14*h_constant
							;
                            
    
    generate x_betahat1 = MG_b1*(`a'+h_X)
                            + MG_b2* h_C2
                            + MG_b3*h_C3
							+ MG_b4*h_C4
							+ MG_b5*h_C5
							+ MG_b6*h_C6
							+ MG_b7*h_C7
							+ MG_b8*h_C8
							+ MG_b9*h_C9
							+ MG_b10*h_C10
							+ MG_b11*h_C11
							+ MG_b12*h_C12
                            + MG_b13*h_C13
							+ MG_b14*h_constant							
							;
                            
    gen prob0= normal(x_betahat0);
    gen prob1=normal(x_betahat1);
    gen diff=prob1-prob0;
    
    egen probhat0=mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ;  

    _pctile prob0, p(2.5,97.5) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(2.5,97.5);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(2.5,97.5);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  

   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi') ;
    };      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat ;
    local a=`a'+ .1 ;
    noisily display "." _c;
    } ;

 display "";

postclose mypost;
                                
restore;
merge using sim;

gen MV = _n-100;
replace MV = MV/10;
gen MV1 = exp(MV);

sum diff_hat;
sum diff_lo;
sum diff_hi;

gen where=.001;
egen tag = tag(lnfdi3);

graph twoway (hist lnfdi3 if lnfdi3>-5 & lnfdi3 <6, percent yscale(alt axis(1)) color(gs14) ylab(,nogrid))
		(line prob_hat0 MV if MV<6 & MV>-5,sort clpattern(solid) yaxis(2) yscale(alt axis(2)) clwidth(medium) clcolor(black))
        (line lo0  MV if MV<6 & MV>-5,sort yaxis(2) yscale(alt axis(2)) clpattern(dash) clwidth(thin) clcolor(black))
        (line hi0  MV if MV<6 & MV>-5,sort yaxis(2) yscale(alt axis(2)) clpattern(dash) clwidth(thin) clcolor(black))

         ,   
            yline(0, lstyle(grid) lc(gs12) axis(2))
            xtitle("FDI Inflows (%GDP, logged)", size(3.5)  )
            ytitle("Predicted Probability", size(3.5) axis(2))
			ytitle("Percentage of Observations", size(3.5) axis(1))
            xsca(titlegap(2))
            ysca(titlegap(2))
			ysize(10.6)
			xsize(10)
			xlab(-5(1)5)
			legend(order(2 "Predicted Probability" 4 "95% Confidence Interval") size(small) rows(2))
            scheme(s2mono) graphregion(fcolor(white));
