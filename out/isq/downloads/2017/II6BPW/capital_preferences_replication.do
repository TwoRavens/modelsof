use "C:\Users\Andrey\Desktop\dissertation\right wing\capital preferences replication.dta", clear

*** Table 1

*Economic Orthodoxy Parties
xtivreg2 econorthvote econorthlag unemp  inflation lgdppc   gdppcgrowth execp  (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep    ) ,   gmm fe robust cluste(ccode) 
xtivreg2 econorthvote econorthlag unemp  inflation lgdppc   gdppcgrowth execp gdpinc  (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep   ) ,   gmm fe robust cluste(ccode) 
xtivreg2 econorthvote econorthlag unemp  inflation lgdppc   gdppcgrowth execp gdpinc infinc  (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep  ) ,   gmm fe robust cluste(ccode) 

*Conservative Parties

xtivreg2 convote convotelag unemp  inflation lgdppc   gdppcgrowth execp   (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep    ), gmm fe robust cluste(ccode)  
xtivreg2 convote convotelag unemp  inflation lgdppc   gdppcgrowth execp gdpinc   (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep     ) , gmm fe robust cluste(ccode)  
xtivreg2 convote convotelag unemp  inflation lgdppc   gdppcgrowth execp gdpinc infinc   (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep    ), gmm fe robust cluste(ccode)  

*** Table 2

*Right-Wing parties

xtivreg2 econorthvote econorthlag L.unemp  D.unemp L.inflation D.inflation L.lgdppc D.lgdppc  L.gdppcgrowth D.gdppcgrowth /*
*/ L.execp  D.execp  (L.portgdp1 D.portgdp1  =     L.tbills L.mmr   L.monpol L.dep D.dep D.monpol D.tbills D.mmr    ) , gmm fe robust cluste(ccode) 

xtivreg2 econorthvote econorthlag  L.gdpinc D.gdpinc   L.unemp  D.unemp L.inflation D.inflation L.lgdppc D.lgdppc   L.gdppcgrowth D.gdppcgrowth /*
*/ L.execp  D.execp  (L.portgdp1 D.portgdp1  =   L.tbills L.mmr   L.monpol L.dep D.dep D.monpol D.tbills D.mmr    ) ,gmm fe robust cluste(ccode)  

xtivreg2 econorthvote econorthlag  L.gdpinc D.gdpinc L.infinc D.infinc   L.unemp  D.unemp L.inflation D.inflation L.lgdppc D.lgdppc   L.gdppcgrowth D.gdppcgrowth /*
*/ L.execp  D.execp  (L.portgdp1 D.portgdp1  =   L.tbills L.mmr   L.monpol L.dep D.dep D.monpol D.tbills D.mmr    ) ,gmm fe robust cluste(ccode)  

* Conservative Parties

xtivreg2 convote convotelag     L.unemp  D.unemp L.inflation D.inflation L.lgdppc D.lgdppc   L.gdppcgrowth D.gdppcgrowth /*
*/ L.execp  D.execp  (L.portgdp1 D.portgdp1  =   L.tbills L.mmr   L.monpol L.dep D.dep D.monpol D.tbills D.mmr   ) ,gmm fe robust cluste(ccode)  

xtivreg2 convote convotelag  L.gdpinc D.gdpinc   L.unemp  D.unemp L.inflation D.inflation L.lgdppc D.lgdppc   L.gdppcgrowth D.gdppcgrowth /*
*/ L.execp  D.execp  (L.portgdp1 D.portgdp1  =   L.tbills L.mmr   L.monpol L.dep D.dep D.monpol D.tbills D.mmr   ) ,gmm fe robust cluste(ccode) 

xtivreg2 convote convotelag  L.gdpinc D.gdpinc L.infinc D.infinc   L.unemp  D.unemp L.inflation D.inflation L.lgdppc D.lgdppc   L.gdppcgrowth D.gdppcgrowth /*
*/ L.execp  D.execp  (L.portgdp1 D.portgdp1  =   L.tbills L.mmr   L.monpol L.dep D.dep D.monpol D.tbills D.mmr   ) ,gmm fe robust cluste(ccode)  

*** Table 4 ***

xtreg logdiff L.logdiff  gdppcgrowth execp elec lgdppc L.portgdp1 , fe cluster(ccode) robust
xtreg logdiff L.logdiff  gdppcgrowth execp   elec   lgdppc L.portgdp1  inflation  , fe cluster(ccode) robust
xtreg logdiff L.logdiff  gdppcgrowth execp   elec  lgdppc L.portgdp1 inflation  elecp , fe cluster(ccode) robust
xtreg logdiff L.logdiff  gdppcgrowth execp   elec  lgdppc L.portgdp1 inflation  elecp spendlim  contlim,  fe cluster(ccode) robust
xtreg logdiff L.logdiff  gdppcgrowth execp   elec  lgdppc L.portgdp1 inflation  elecp uden spendlim  contlim, fe cluster(ccode) robust
xtreg logdiff L.logdiff  gdppcgrowth execp   elec  lgdppc L.portgdp1 inflation  elecp uden spendlim  contlim  pubfund,  cluster(ccode) robust

*** Table 5


xtreg logdiff L.logdiff D.elec L.elec   D.gdppcgrowth L.gdppcgrowth D.execp L.execp D.lgdppc L.lgdppc D.portgdp1 l.portgdp1 , fe  cluster(ccode) robust
xtreg logdiff L.logdiff D.elec L.elec   D.gdppcgrowth L.gdppcgrowth D.execp L.execp D.lgdppc L.lgdppc D.portgdp1 l.portgdp1 L.inflation D.inflation,fe  cluster(ccode) robust
xtreg logdiff L.logdiff D.elec L.elec   D.gdppcgrowth L.gdppcgrowth D.execp L.execp D.lgdppc L.lgdppc D.portgdp1 l.portgdp1 L.inflation D.inflation D.elecp L.elecp,fe  cluster(ccode) robust
xtreg logdiff L.logdiff D.elec L.elec   D.gdppcgrowth L.gdppcgrowth D.execp L.execp D.lgdppc L.lgdppc D.portgdp1 l.portgdp1 L.inflation D.inflation D.elecp L.elecp D.spendlim L.spendlim D.contlim L.contlim, fe cluster(ccode) robust
xtreg logdiff L.logdiff D.elec L.elec   D.gdppcgrowth L.gdppcgrowth D.execp L.execp D.lgdppc L.lgdppc D.portgdp1 l.portgdp1 L.inflation D.inflation D.elecp L.elecp D.uden L.uden D.spendlim L.spendlim D.contlim L.contlim, fe cluster(ccode) robust
xtreg logdiff L.logdiff D.elec L.elec   D.gdppcgrowth L.gdppcgrowth D.execp L.execp D.lgdppc L.lgdppc D.portgdp1 l.portgdp1 L.inflation D.inflation D.elecp L.elecp D.uden L.uden D.spendlim L.spendlim D.contlim L.contlim D.pubfund L.pubfund , cluster(ccode) robust


*** Table 6

* Economic Orthodoxy


xtivreg2 econorthvote econorthlag unemp  inflation lgdppc  gdppcgrowth execp logdiff (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep ) , fe robust cluste(ccode)  small
xtivreg2 econorthvote econorthlag unemp  inflation lgdppc   gdppcgrowth execp logdiff gdpinc (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep ) ,  fe robust cluste(ccode) small
xtivreg2 econorthvote econorthlag unemp  inflation lgdppc   gdppcgrowth execp logdiff gdpinc infinc  (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep ) ,  fe robust cluste(ccode)  small

*** Conservative Parties

xtivreg2 convote convotelag unemp  inflation lgdppc   gdppcgrowth execp logdiff (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep    ) ,  fe robust cluste(ccode)  small
xtivreg2 convote convotelag unemp  inflation lgdppc   gdppcgrowth execp logdiff gdpinc (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep      ) ,  fe robust cluste(ccode) small
xtivreg2 convote convotelag unemp  inflation lgdppc   gdppcgrowth execp  logdiff gdpinc infinc  (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep     ) ,  fe robust cluste(ccode)  small

*****************
*Figures 
*****************

*Figure 2

xtreg logdiff L.logdiff  gdppcgrowth execp elec lgdppc L.portgdp1 , fe cluster(ccode) robust

graph dot (mean)  logdiff if e(sample), over(statenme) legend(off) ///
 marker(2, mcolor(gs7) msymbol(smcircle)) marker(3, mcolor(gs7) msymbol(smcircle))  graphregion(fcolor(gs15))


*Figure 1
xtivreg2 econorthvote econorthlag unemp  inflation lgdppc   gdppcgrowth execp  (L.portgdp1  =    L.tbills L.mmr  L.monpol L.dep    ) ,   gmm fe robust cluste(ccode) 

	#delimit ;
	preserve;
drawnorm MG_b1-MG_b8, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using sim , replace;
            noisily display "start";
            
local a=-13.87 ;
while `a' <= 15.27 { ;

    {;

		scalar h_X= 1.78;
		
		
scalar h_C2=.0355;
scalar h_C3=7.9284;
scalar h_C4=11.535;
scalar h_C5= 9.61 ;
scalar h_C6=2.38 ;
scalar h_C7=1;
scalar h_C8=1;



	
scalar h_constant=1;

    generate x_betahat0 = MG_b1*`a'
                            + MG_b2*h_C2
                            + MG_b3*h_C3
							+ MG_b4*h_C4
							+ MG_b5*h_C5
							+ MG_b6*h_C6
							+ MG_b7*h_C7
							+ MG_b7*h_C8
							;
                            
    
    generate x_betahat1 = MG_b1*(`a'+h_X)
                            + MG_b2* h_C2
                            + MG_b3*h_C3
							+ MG_b4*h_C4
							+ MG_b5*h_C5
							+ MG_b6*h_C6
							+ MG_b7*h_C7
							+ MG_b7*h_C8

							;
                            
    gen prob0= x_betahat0;
    gen prob1=x_betahat1;
    gen diff=prob1-prob0;
	
	
    egen probhat0=mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ;  

    _pctile prob0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(2.5,97.5);
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
    local a=`a'+ .1 ;
    noisily display "." _c;
    } ;

 display "";

postclose mypost;

use sim, clear;

gen MV = _n-1;
replace MV = MV/10;
replace MV = MV - 14;

sum diff_hat;
sum diff_lo;
sum diff_hi;
replace prob_hat0 = prob_hat0;
replace lo0 = lo0;
replace hi0 = hi0;

graph twoway (line prob_hat0 MV, clwidth(medium) clcolor(blue) clcolor(black))
         
        (line lo0  MV, clpattern(dash) clwidth(thin) clcolor(black))
          (line hi0  MV, clpattern(dash) clwidth(thin) clcolor(black)) 
         ,   
            yline(0, lp(dot) lc(gs8))
            xtitle("% GDP Portfolio Investment", size(3.5)  )
            ytitle("Vote Share", size(3.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
			xlabel(-15[3]15)
			legend(order(1 "Predicted Vote Share" 2 "95% Confidence Interval") size(small) rows(2))
            scheme(s2mono)  graphregion(fcolor(gs15));


