**********************************************************
//////////////////////////////////////////////////////////
// Author: Matthew R. DiGiuseppe  
//
// Do File: ClayDiGiuseppe_Main
//
// Date: 03/19/15
//////////////////////////////////////////////////////////
**********************************************************



**********************************************************
//////////////////////////////////////////////////////////
//Table 1
//////////////////////////////////////////////////////////
**********************************************************


use ClayDigiuseppe_RepData, clear
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
set more off
xtset ccode year


// pooled sample
xtpcse physint physint1 iirating1 $rhs, p  
	est sto model1
// fixed effects
xtpcse physint physint1 iirating1 $rhs i.ccode, p 
	est sto model2

// IV regression 
ivregress 2sls physint physint1 $rhs (iirating =  r_externaldebt l.r_externaldebt), robust cl(ccode)
	est sto model3



**********************************************************
//////////////////////////////////////////////////////////
//Table 2
//////////////////////////////////////////////////////////
**********************************************************

global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
set more off
xtset ccode year
foreach var of varlist disap kill tort polpris{
gen `var'1=l.`var'
}

xtoprobit physint physint1 iirating1 $rhs, vce(robust) 
	est sto model4
	
xtoprobit kill kill1 iirating1 $rhs, vce(robust) 
	est sto model5

xtoprobit disap disap1  iirating1 $rhs, vce(robust)
	est sto model6
 
xtoprobit polpris polpris1 iirating1 $rhs, vce(robust) 
	est sto model7

xtoprobit tort tort1 iirating1 $rhs, vce(robust) 
	est sto model8



**********************************************************
//////////////////////////////////////////////////////////
//Table 3
//////////////////////////////////////////////////////////
**********************************************************

set more off
xtset ccode year


gen violent = riots + guerrilla_war + assassinations
gen iibanks = violent*iirating1
xtpcse physint physint1 iirating1 violent iibanks $rhs , p  
	est sto model8
xtpcse physint physint1 iirating1 violent iibanks $rhs i.ccode, p 
	est sto model9
	

xtset ccode year	
gen taxrevpc_pch = (taxrevpc-L.taxrevpc)/L.taxrevpc if taxrevpc!=.
gen taxrevshock = taxrevpc_pch 	 if taxrevpc!=.
	replace taxrevshock = 0 if 	taxrevpc_pch>0  & taxrevpc!=.
	replace taxrevshock =taxrevshock*-1	  if taxrevpc!=.
sum taxrevpc_pch, det  
	gen taxrevshock_bi = (taxrevpc_pch < `r(p10)'  & !missing(taxrevpc)  ) 
	gen iirev = taxrevshock*iirating1  if taxrevpc!=.

set more off 
xtpcse physint physint1 iirating1 taxrevshock iirev $rhs , p  
	est sto model10

xtpcse physint physint1 iirating1 taxrevshock iirev $rhs i.ccode, p  
	est sto model11

		
**********************************************************
//////////////////////////////////////////////////////////
//Figure 1 
//////////////////////////////////////////////////////////
**********************************************************

est restore model1

sum  physint1 if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

set more off 
#delimit ; 
preserve; 
set seed 8675309;

drawnorm SN_b1-SN_b9, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;
postfile mypost	EYIIA_lo EYIIA_hi
				EYIIB_lo EYIIB_hi
				EYDMA_lo EYDMA_hi
				EYDMB_lo EYDMB_hi
				_t 	using sims, replace;
						
noisily display "start";

local lagIIA = `lagmean';
local lagIIB = `lagmean';
local lagDMA = `lagmean';
local lagDMB = `lagmean';

local a=0 ;
while `a' <= 10 { ;
{;			
scalar h_DEMOC			=4  		;		
scalar h_ii				=42.2  		;		
scalar h_durable 		= 26 	;
scalar h_atwar 			=0			;
scalar h_growth 		=0.023			;
scalar h_LNRGDP 		=8.58 	;
//scalar h_LNRGDP 		=7.30038	;


scalar h_lpop			=9.4 	;

		
		// iirating at 1 sd below mean  = 16.38088
			gen EYIIA = 	  SN_b1*`lagIIA' 
                            + SN_b2* 16.38088  
                            + SN_b3* h_DEMOC 
                            + SN_b4* h_durable 
                            + SN_b5* h_lpop
                            + SN_b6* h_LNRGDP
                            + SN_b7* h_growth
                            + SN_b8* h_atwar
                            + SN_b9*  1 ;
							
		// iirating at 1 sd below mean  = 67.60316
			gen EYIIB =       SN_b1*`lagIIB' 
                            + SN_b2* 67.60316   
                            + SN_b3* h_DEMOC 
                            + SN_b4* h_durable 
                            + SN_b5* h_lpop
                            + SN_b6* h_LNRGDP
                            + SN_b7* h_growth
                            + SN_b8* h_atwar
                            + SN_b9*  1 ;	
							
		// polity at min= -10					
			gen EYDMA = 	  SN_b1*`lagDMA' 
                            + SN_b2* h_ii   
                            + SN_b3* -10
                            + SN_b4* h_durable 
                            + SN_b5* h_lpop
                            + SN_b6* h_LNRGDP
                            + SN_b7* h_growth
                            + SN_b8* h_atwar
                            + SN_b9*  1 ;
							
		// polity at max = 10									
			gen EYDMB = 	  SN_b1*`lagDMB' 
                            + SN_b2* h_ii   
                            + SN_b3* 10
                            + SN_b4* h_durable 
                            + SN_b5* h_lpop
                            + SN_b6* h_LNRGDP
                            + SN_b7* h_growth
                            + SN_b8* h_atwar
                            + SN_b9*  1 ;															
							
			gen time = `a';
			egen _time = max(time);
			egen _lagIIA = mean(EYIIA);
			egen _lagIIB = mean(EYIIB);
			egen _lagDMA = mean(EYDMA);
			egen _lagDMB = mean(EYDMB);		
			
  tempname 	EYIIA_lo EYIIA_hi 
			EYIIB_lo EYIIB_hi
			EYDMA_lo EYDMA_hi 
			EYDMB_lo EYDMB_hi 
			_t ; 			
			
			 _pctile EYIIA, p(2.5,97.5) ;
			    scalar `EYIIA_lo' = r(r1);
				scalar `EYIIA_hi' = r(r2);  
			 _pctile EYIIB, p(2.5,97.5) ;
			    scalar `EYIIB_lo' = r(r1);
				scalar `EYIIB_hi' = r(r2); 
			 _pctile EYDMA, p(2.5,97.5) ;
			    scalar `EYDMA_lo' = r(r1);
				scalar `EYDMA_hi' = r(r2); 
			 _pctile EYDMB, p(2.5,97.5) ;
			    scalar `EYDMB_lo' = r(r1);
				scalar `EYDMB_hi' = r(r2); 				
			 scalar `_t'=_time;

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 
				(`EYIIB_lo') (`EYIIB_hi')
				(`EYDMA_lo') (`EYDMA_hi')
				(`EYDMB_lo') (`EYDMB_hi')
				(`_t');			
			
    };      
    
    
    local a=`a'+ 1;
	
	local list IIA IIB DMA DMB  ;
	foreach i of local list {;
		qui sum EY`i' , meanonly ;
		local lag`i' = `r(mean)';
		};


    drop EY* time _time _lag* ;

    display "." _c;
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' ;	
    
} ;
display "";

postclose mypost;

restore;

merge using sims;			
                               

#delimit ;
graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)
        ||  ,   
            xlabel(0 5 10, nogrid labsize(2)) 
            ylabel(,  nogrid labsize(2))
			xtitle(Years, size(3))
            ytitle("Predited CIRI", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend( order(1 "IIR 1 S.D. Above/Below" 3 "Polity Max/Min" ) );	
			
**********************************************************
//////////////////////////////////////////////////////////
//Figure 2
//////////////////////////////////////////////////////////
**********************************************************			
			
			
use ClayDigiuseppe_RepData, clear
global rhs polity2 durable  lpop lgdppc1 growth1  
set more off
xtset ccode year

foreach Y of varlist kill disap tort polpris { 	
	xtset ccode year
xtoprobit `Y' l.`Y' iirating1 polity2 durable  lpop lgdppc1 growth1 war_cumint,vce(robust)  

set more off 
#delimit ; 
preserve; 
set seed 8675309;

drawnorm SN_b1-SN_b11, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;
postfile mypost	pr0_hi pr0_lo
				pr1_hi pr1_lo
				pr2_hi pr2_lo
				_t 	using sims, replace;
						
noisily display "start";



local a=4 ;
while `a' <= 98 { ;
{;			
scalar h_DEMOC			=4  		;		
scalar h_ii				=42.2  		;		
scalar h_durable 		= 26 	;
scalar h_atwar 			=0			;
scalar h_growth 		=0.023			;
scalar h_LNRGDP 		=8.58 	;
scalar h_lpop			=9.4 	;

			gen xbA= 	  SN_b1* 1
                            + SN_b2* `a' 
                            + SN_b3* h_DEMOC 
                            + SN_b4* h_durable 
                            + SN_b5* h_lpop
                            + SN_b6* h_LNRGDP
                            + SN_b7* h_growth
                            + SN_b8* h_atwar;
																							
							
			gen ii = `a';		
			
			gen pr0`A' = normal(SN_b9 - xb`A' ) - 0;
			gen pr1`A' = normal(SN_b10 - xb`A' ) - normal(SN_b9 - xb`A');
			gen pr2`A' = 1 - normal(SN_b10 - xb`A');

			egen _ii = max(ii);

			
  tempname 		pr0_hi pr0_lo
				pr1_hi pr1_lo
				pr2_hi pr2_lo
				_t ; 			
			
			foreach num of numlist 0 1 2 {;
			 _pctile pr`num', p(2.5,97.5) ;
			    scalar `pr`num'_lo' = r(r1);
				scalar `pr`num'_hi' = r(r2);  
				}	;
				
			 scalar `_t'=_ii;

			
   post mypost 	(`pr0_hi') (`pr0_lo') 
				(`pr1_hi') (`pr1_lo')
				(`pr2_hi') (`pr2_lo')
				(`_t');			
			
    };      
    
    
    local a=`a'+ 2;

    drop  pr* _ii ii xbA   ;

    display "." _c;
    
} ;
display "";

postclose mypost;

restore;
merge using sims;			
drop _merge; 

#delimit cr
foreach var of varlist pr0_hi pr0_lo pr1_hi pr1_lo pr2_hi pr2_lo _t {
rename `var' `Y'`var'
}



}
			
gen X = kill_t				
label var kill "Killings"	
label var disap "Disappearances"
label var tort "Torture"
label var polpris "Pol. Imprisonment"	
foreach var of varlist  kill disap tort polpris {
local X : variable label `var'

#delimit ; 
graph twoway 	   rarea `var'pr2_lo `var'pr2_hi X,  color(gs7)  
				|| rarea `var'pr0_lo `var'pr0_hi X,  color(black)
				||  ,   
            xlabel(0 50 100, nogrid labsize(2)) 
            ylabel(,  nogrid labsize(2))
			xtitle("IIR", size(3))
            ytitle("Pr(Y=0 ) & Pr(Y=2) ", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend(off) 
			title(" `X' ", size(medium))
			name(`var', replace);	
			#delimit cr

}
graph combine disap kill polpris  tort 	, ycommon		scheme(s1mono)
	
				
			
**********************************************************
//////////////////////////////////////////////////////////
//Figure 3
//////////////////////////////////////////////////////////
**********************************************************		

use ClayDigiuseppe_RepData, clear
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
set more off
xtset ccode year


gen violent = riots + guerrilla_war + assassinations
gen iibanks = violent*iirating1


xtset ccode year	
gen taxrevpc_pch = (taxrevpc-L.taxrevpc)/L.taxrevpc if taxrevpc!=.
gen taxrevshock = taxrevpc_pch 	 if taxrevpc!=.
	replace taxrevshock = 0 if 	taxrevpc_pch>0  & taxrevpc!=.
	replace taxrevshock =taxrevshock*-1	  if taxrevpc!=.
sum taxrevpc_pch, det  
	gen taxrevshock_bi = (taxrevpc_pch < `r(p10)'  & !missing(taxrevpc)  ) 
	gen iirev = taxrevshock*iirating1  if taxrevpc!=.



xtpcse physint violent iirating1  iibanks physint1 $rhs i.ccode, p 
 est store violent 
 
 
xtpcse physint  taxrevshock iirating1  iirev physint1  $rhs i.ccode, p  
est store taxrev 

 
 
est restore violent 

#delimit ; 
matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;


generate MVZ= _n-1;

replace  MVZ=. if _n>100;

gen conbx=b1+b3*MVZ if _n<1501;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<1501;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;
gen yline=0;

#delimit ; 
graph twoway hist iirating1, width(0.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(0 25 50 75 100, nogrid labsize(2))
		     ylabel(, axis(1) nogrid labsize(2))
		     ylabel(, axis(2) nogrid labsize(2))
	         yscale(noline alt)
		     yscale(noline alt axis(2))	
             xscale(noline)
             legend(off)
             xtitle("Institutional Investor Rating" , size(2.5)  )
             ytitle("MFX" , axis(1) size(2.5))
             ytitle("Freq." , axis(2) size(2.5))
             xsca(titlegap(2))
             ysca(titlegap(2))
			 title(Violent Dissent,  size(medium))
			 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			 name(violentfe, replace);

			
drop  MVZ- yline;


#delimit ; 

est restore taxrev ;
matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;


generate MVZ= _n-1;

replace  MVZ=. if _n>100;

gen conbx=b1+b3*MVZ if _n<1501;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<1501;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;
gen yline=0;

#delimit ; 
graph twoway hist iirating1, width(0.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(0 25 50 75 100, nogrid labsize(2))
		     ylabel(, axis(1) nogrid labsize(2))
		     ylabel(, axis(2) nogrid labsize(2))
	         yscale(noline alt)
		     yscale(noline alt axis(2))	
             xscale(noline)
             legend(off)
             xtitle("Institutional Investor Rating" , size(2.5)  )
             ytitle("MFX" , axis(1) size(2.5))
             ytitle("Freq." , axis(2) size(2.5))
             xsca(titlegap(2))
             ysca(titlegap(2))
 			 title(Revenue Shock, size(medium))
			 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			 name(taxrevpc_pchfe, replace);

			
drop  MVZ- yline;

graph combine violentfe taxrevpc_pchfe, scheme(s1mono) ;
				
			
			











