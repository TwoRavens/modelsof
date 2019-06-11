**********************************************************
//////////////////////////////////////////////////////////
// Author: Matthew R. DiGiuseppe  
//
// Do File: ClayDiGiuseppe_Appendix
//
// Date: 03/19/15
//////////////////////////////////////////////////////////
**********************************************************



**********************************************************
// Table 2A : Non-OECD States
**********************************************************
use ClayDigiuseppe_RepData, clear
set more off
xtset ccode year
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 

// without OECD states. 
label var physint1 "LDV"
	// pooled sample
	xtpcse physint physint1 iirating1 $rhs if oecd==0, p  
	// fixed effects
	xtpcse physint physint1 iirating1 $rhs i.ccode if oecd==0, p 
	//2SLS
	ivregress 2sls physint physint1 $rhs (iirating1 =  r_externaldebt r_domesticdebt) if oecd==0, robust



**********************************************************
// Table 3A : Multinomial Logit Models of Change 
**********************************************************
use ClayDigiuseppe_RepData, clear
set more off
xtset ccode year
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
	
foreach var of varlist physint disap kill tort polpris {
	gen `var'_change = `var'-l.`var'
	gen `var'_ch= 0 if `var'_change<=-1
	replace `var'_ch= 1 if `var'_change==0
	replace `var'_ch= 2 if `var'_change>=1	
	drop `var'_change
	cap gen `var'1  = l.`var'
	}
	
mlogit physint_ch physint1 iirating1 $rhs , robust cl(ccode)
mlogit kill_ch kill1 iirating1 $rhs , robust cl(ccode)
mlogit disap_ch disap1 iirating1 $rhs, robust cl(ccode)
mlogit polpris_ch polpris1 iirating1 $rhs , robust cl(ccode)
mlogit tort_ch tort1 iirating1 $rhs, robust cl(ccode)


**********************************************************
// Figure 1A : Multinomial Logit Models of Change 
**********************************************************
gen X = (_n-1) if _n<102 
foreach var of varlist physint {

qui estsimp mlogit physint_ch  iirating1 $rhs physint1 , robust genname(BBB) sims(10000) 


local X : variable label `var'

gen `var'_p0l = . 
gen `var'_p0h = . 
gen `var'_p2l = . 
gen `var'_p2h = . 	
		
forvalues i = 0(5)100 {
setx mean 
setx polity2 p50 war_cumint p50 durable p50 
setx physint1 p50
setx iirating1 `i'
simqi, prval(0) genpr(PR0) 
			_pctile PR0, p(2.5,97.5)
				replace `var'_p0l=r(r1) if X==`i'
				replace `var'_p0h=r(r2) if X==`i'
simqi, prval(2) genpr(PR2) 				
			_pctile PR2, p(2.5,97.5)
				replace `var'_p2l=(r(r1)) if X==`i'
				replace `var'_p2h=(r(r2)) if X==`i'
	drop PR0 PR2 
	}	
	
	drop BBB*
	
#delimit ; 
graph twoway 	   rarea `var'_p2l `var'_p2h X,  color(gs7)  
				|| rarea `var'_p0l `var'_p0h X,  color(black)
				||  ,   
            xlabel(0 50 100, nogrid labsize(2)) 
            ylabel(,  nogrid labsize(2))
			xtitle("IIR", size(3))
            ytitle("Pr(Y=0 ) & Pr(Y=2) ", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend(off)
			title(" `X' ")
			name(`var', replace);	
			#delimit cr
}


**********************************************************
// Figure 2A : Multinomial Logit Models of Change 
**********************************************************
foreach var of varlist  kill disap tort polpris {

	gen ldv=l.`var'
qui estsimp mlogit `var'_ch  iirating1 $rhs ldv , robust genname(BBB) sims(10000) 

local X : variable label `var'

gen `var'_p0l = . 
gen `var'_p0h = . 
gen `var'_p2l = . 
gen `var'_p2h = . 	
		
forvalues i = 0(5)100 {
setx mean 
setx polity2 p50 war_cumint 0 durable p50 
setx ldv 1
setx iirating1 `i'
simqi, prval(0) genpr(PR0) 
			_pctile PR0, p(2.5,97.5)
				replace `var'_p0l=r(r1) if X==`i'
				replace `var'_p0h=r(r2) if X==`i'
simqi, prval(2) genpr(PR2) 				
			_pctile PR2, p(2.5,97.5)
				replace `var'_p2l=(r(r1)) if X==`i'
				replace `var'_p2h=(r(r2)) if X==`i'
	drop PR0 PR2 
	}	
	
	drop ldv BBB*
	}
	//

label var kill "Killings"	
label var disap "Disappearances"
label var tort "Torture"
label var polpris "Pol. Prisonment"

foreach var of varlist  kill disap tort polpris {
local X : variable label `var'

#delimit ; 
graph twoway 	   rarea `var'_p2l `var'_p2h X,  color(gs7)  
				|| rarea `var'_p0l `var'_p0h X,  color(black)
				||  ,   
            xlabel(0 50 100, nogrid labsize(2)) 
            ylabel(,  nogrid labsize(2))
			xtitle("II Rating", size(3))
            ytitle("Pr(Y=Neg. Ch.) & Pr(Y=Pos. Ch.) ", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend(off)
			title(" `X' ")
			name(`var', replace);	
			#delimit cr

}
graph combine disap kill polpris  tort 



**********************************************************
// Table 4A : Confouding Variables (both Pooled and Fixed Effects)
**********************************************************
use ClayDigiuseppe_RepData, clear
set more off
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtset ccode year


	eststo clear
//  state capacity 
	 xtpcse physint physint1 iirating1 $rhs rpc2, p  
	 xtpcse physint physint1 iirating1 $rhs rpc2 i.ccode, p  

//  domestic discontent 
	 xtpcse physint physint1 iirating1 $rhs l.conflict_banks_wght, p  
	 xtpcse physint physint1 iirating1 $rhs l.conflict_banks_wght i.ccode, p  
	
////  Oil Rents? 		
	 xtpcse physint physint1 iirating1 $rhs oil_gas_rentpop, p  
	 xtpcse physint physint1 iirating1 $rhs oil_gas_rentpop i.ccode, p  		
		
//  trade/gdp 		
	gen lntrade = ln(tradeofgdp)
	 xtpcse physint physint1 iirating1 $rhs lntrade, p  
	 xtpcse physint physint1 iirating1 $rhs lntrade i.ccode, p  		
		
//  WBIMF programs 
	 xtpcse physint physint1 iirating1 $rhs wbimfimplement wbimfnumberyearsunder8104, p  
	 xtpcse physint physint1 iirating1 $rhs wbimfimplement wbimfnumberyearsunder8104 i.ccode, p  		
		
// Contract Intensive Money (Mousseau & Mousseau) 		
	 xtpcse physint physint1 iirating1 $rhs CIE , p  
	 xtpcse physint physint1 iirating1 $rhs CIE i.ccode, p  

		
	
**********************************************************
// Table 5A : Employing the S&P Credit Rating 
**********************************************************	
use ClayDigiuseppe_RepData, clear
set more off
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtset ccode year

// pooled sample
xtpcse physint physint1 sprat_1 $rhs, p  
// no oecd
xtpcse physint physint1 sprat_1 $rhs if oecd!=1, p  
// fixed effects
xtpcse physint physint1 sprat_1 $rhs i.ccode, p 
// IV regression 
ivregress 2sls physint physint1 $rhs (sprat_1 =  r_externaldebt r_domesticdebt), robust


**********************************************************
// Table 6A : The Conditional Impact of Violent Dissent of Budget Surplus/Deficit 
**********************************************************	
use ClayDigiuseppe_RepData, clear
set more off
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtset ccode year

	gen violent  = guerrilla_war+assassinations+riots
	gen iibanks = violent*iirating1	
	xtpcse  gc_bal_cash_gd_zs l.gc_bal_cash_gd_zs polity2 lpop lgdppc  violent iirating1 iibanks , p 
	
	
**********************************************************
// Figure 3A : The Conditional Impact of Violent Dissent of Budget Surplus/Deficit 
**********************************************************		
	grinter violent, inter(iibanks) const02(iirating1 ) clevel(95) yline(0) nomean scheme(s1mono) xtitle(IIR) ///
	ytitle(Marginal Effect  ) 
	
	
	
**********************************************************
// Table 7A :Conditional Efects of Violent Dissent and Rev. Shocks in 1 Model
**********************************************************		

use ClayDigiuseppe_RepData, clear
set more off
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtset ccode year
cap gen violent = riots + guerrilla_war + assassinations
cap gen iibanks = violent*iirating1
cap gen taxrevpc_pch = (taxrevpc-L.taxrevpc)/L.taxrevpc if taxrevpc!=.

// negative tax revenue shock (measured as percentage and inverted)
cap gen taxrevshock = taxrevpc_pch 	 if taxrevpc!=.
	cap replace taxrevshock = 0 if 	taxrevpc_pch>0  & taxrevpc!=.
	cap replace taxrevshock =taxrevshock*-1	  if taxrevpc!=.
	
//Binary indicator of shock 
sum taxrevpc_pch, det  
cap gen taxrevshock_bi = (taxrevpc_pch < `r(p10)'  & !missing(taxrevpc)  ) 
cap gen iirev = taxrevshock*iirating1  if taxrevpc!=.
cap gen revbanks = 	taxrevshock*violent
cap gen revbanksii = taxrevshock*violent*iirating1


xtpcse physint physint1 iirating1 taxrevshock iirev violent iibanks revbanks revbanksii $rhs  , p  	

**********************************************************
// Figure 4A 
**********************************************************	

mat list e(b)
estat sum 
set more off 
#delimit ; 
preserve; 
set seed 8675309;
drawnorm SN_b1-SN_b15, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost	Rev_lo Rev_hi 
				V_lo V_hi
				_iir
			 	using sims, replace;
noisily display "start";
scalar h_revshock	=0  		;		
scalar h_violent	=1.094869   ;		
local a=0 ;
while `a' <= 100 { ;
{;			

			gen XBbase = 	  SN_b2* `a'  
                            + SN_b3* (h_revshock)
                            + SN_b4* `a' * (h_revshock)
                            + SN_b5* (h_violent)
                            + SN_b6* `a'* (h_violent)
                            + SN_b7* (h_violent) * (h_revshock)
                            + SN_b8* (h_violent) * (h_revshock) * `a'
                            + SN_b9*  1 ;				
				
			gen XBv = 	  	  SN_b2* `a'  
                            + SN_b3* (h_revshock)
                            + SN_b4* `a' * (h_revshock)
                            + SN_b5* (h_violent+1)
                            + SN_b6* `a'* (h_violent+1)
                            + SN_b7* (h_violent+1) * (h_revshock)
                            + SN_b8* (h_violent+1) * (h_revshock) * `a'
                            + SN_b9*  1 ;			
	
			gen XBrev = 	  SN_b2* `a'  
                            + SN_b3* (h_revshock+1)
                            + SN_b4* `a' * (h_revshock+1)
                            + SN_b5* (h_violent)
                            + SN_b6* `a'* (h_violent)
                            + SN_b7* (h_violent) * (h_revshock+1)
                            + SN_b8* (h_violent) * (h_revshock+1) * `a'
                            + SN_b9*  1 ;				
						
		gen MFXv = XBv-XBbase;
		gen MFXrev = XBrev-XBbase;
		gen IIR = `a';
		
		tempname	Rev_lo Rev_hi 
					V_lo V_hi
					_iir; 
		
			_pctile MFXrev, p(2.5,97.5) ;
			    scalar `Rev_lo' = r(r1);
				scalar `Rev_hi' = r(r2);  

			_pctile MFXv, p(2.5,97.5) ;
			    scalar `V_lo' = r(r1);
				scalar `V_hi' = r(r2);  
				
			scalar `_iir'=IIR;
		
   post mypost 	(`Rev_lo') (`Rev_hi') 
				(`V_lo') (`V_hi')
				(`_iir') ;						
				
				
    };      
    
    
    local a=`a'+ 1;				
				
	    drop XB* IIR MFX*  ;
			    display "." _c;
} ;
display "";

postclose mypost;
restore;
cap drop _merge;
merge using sims;	
gen yline=0;
#delimit ; 
twoway (rarea Rev_lo Rev_hi _iir)(line yline _iir) , 
       scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
		xtitle(IIR, size(3)) legend(off)
        ytitle("Marginal Effect of a Revenue Shock", size(3))
		title("Revenue Shock")
		name(rev, replace);		
twoway (rarea V_lo V_hi _iir) (line yline _iir) , 
       scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
		xtitle(IIR, size(3))  legend(off)
        ytitle("Marginal Effect of Violent Dissent", size(3))
		title("Violent Dissent")
		name(violent, replace);		
#delimit ; 		
graph combine violent rev , 	       
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));


	
**********************************************************
// Table 8A: Ommitting the LDV
**********************************************************	
use ClayDigiuseppe_RepData, clear
set more off
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtset ccode year
	
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtpcse physint  iirating1 $rhs, p  
xtpcse physint  iirating1 $rhs i.ccode , p 
	
	
	
**********************************************************
// Table 9A: Latent HR Variable 
**********************************************************		
use ClayDigiuseppe_RepData, clear
set more off
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 
xtset ccode year

xtpcse latentmean  iirating1 $rhs , p  	corr(psar)	
xtpcse latentmean  iirating1 $rhs i.ccode, p	corr(psar)		
	
	

**********************************************************
// Figure 5A: Conditional effects of democracy and development on shocks and threats 
**********************************************************
use ClayDigiuseppe_RepData, clear
set more off
xtset ccode year
global rhs polity2 durable  lpop lgdppc1 growth1 war_cumint 

gen violent = riots + guerrilla_war + assassinations
gen demviolent = 	polity2* violent 	
gen devviolent =	lgdppc1*violent 
xtpcse physint physint1 iirating1 violent demviolent $rhs , p  
grinter violent, inter(demviolent) const02(polity2 ) clevel(95) yline(0) name(demviolent, replace) ///
	nomean  scheme(s1mono)  ytitle(Marginal Effect) xtitle(Polity)  

xtpcse physint physint1 iirating1 violent devviolent $rhs , p  
grinter violent, inter(devviolent) const02(lgdppc1 ) clevel(95) yline(0) name(devviolent, replace) ///
	nomean  scheme(s1mono)  ytitle(Marginal Effect) xtitle("ln(GDPPC)")  

graph combine demviolent devviolent, scheme(s1mono)	title("Marginal Effect of Violent Dissent on Physical Integrity Rights") ///
		name(dissent, replace)

// change in tax revenue per capita 
xtset ccode year	
gen taxrevpc_pch = (taxrevpc-L.taxrevpc)/L.taxrevpc if taxrevpc!=.

// negative tax revenue shock (measured as percentage and inverted)
gen taxrevshock = taxrevpc_pch 	 if taxrevpc!=.
	replace taxrevshock = 0 if 	taxrevpc_pch>0  & taxrevpc!=.
	replace taxrevshock =taxrevshock*-1	  if taxrevpc!=.
	
//Binary indicator of shock 
 sum taxrevpc_pch, det  
	gen taxrevshock_bi = (taxrevpc_pch < `r(p10)'  & !missing(taxrevpc)  ) 
	
gen demschk = 	polity2* taxrevshock 	
gen devschk =	lgdppc1* taxrevshock 	
	
set more off 
xtpcse physint physint1 iirating1 taxrevshock demschk $rhs , p  
grinter taxrevshock, inter(demschk) const02(polity2 ) clevel(95) yline(0) ///
	name(demschk, replace)  nomean  scheme(s1mono) ytitle(Marginal Effect) xtitle(Polity)
	
xtpcse physint physint1 iirating1 taxrevshock devschk $rhs i.ccode, p  
grinter taxrevshock, inter(devschk) const02(lgdppc1 ) clevel(95) yline(0) ///
	name(devschk, replace)  nomean  scheme(s1mono)  ytitle(Marginal Effect) xtitle("ln(GDPPC)")
		
graph combine demschk devschk, scheme(s1mono) title("Marginal Effect of Revenue Shocks on Physical Integrity Rights") ///
		name(shock, replace)		

graph combine dissent shock, scheme(s1mono) cols(1)	
	

