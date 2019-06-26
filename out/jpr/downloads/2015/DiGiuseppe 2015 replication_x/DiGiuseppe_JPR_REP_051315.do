**********************************************************
//////////////////////////////////////////////////////////
// Author:	Matthew R. DiGiuseppe  
//
// Do File: DiGiuseppe_JPR_REP_051315
//
// Date: 	5/13/15 
//////////////////////////////////////////////////////////
**********************************************************




use DiGiJprRep, clear 

set more off 
**********************************************************
//////////////////////////////////////////////////////////
// Table I: Additive Models 
//////////////////////////////////////////////////////////
**********************************************************


global rhs lnrival1 polity21  lngdpB1  intra extra inter   
global regions fl_western fl_eeurop fl_america fl_ssafrica fl_asia


set more off
est clear
eststo: xtpcse milexcons milexcons1  rating1 $rhs , p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs if oecd==0, p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs $regions, p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs _Iyear_*, het 	corr(psar1)
eststo: xtabond2 milexcons milexcons1  rating1 polity21  lngdpB1  lnrival1 intra extra inter , ///
	gmm(milexcons1 rating1 lngdpB1   , lag(2 2))	///
	iv(polity21  lnrival1 intra extra inter ) noconst 	robust 

//Calculate the Significance of LTE for models 1-5: 

forvalues i = 1/4{
est restore est`i'
qui local B = `e(n_cf)'
set more off 
preserve 
set seed 8675309
drawnorm SN_b1-SN_b`B', n(10000) means(e(b)) cov(e(V)) clear
qui gen _LTE_`i' = SN_b2 / (1-SN_b1)
qui sum _LTE_`i', det
	local mean = r(mean)
_pctile  _LTE_`i', p(1, 99)	
	local lo = r(r1)
	local hi = r(r2)
	di "est`i' LTE = " `mean' ", 99% C.I. = [" `lo' ", " `hi' "]" 
	restore 
	}
//
	
est restore est5	
set more off 
preserve 
set seed 8675309
drawnorm SN_b1-SN_b8, n(10000) means(e(b)) cov(e(V)) clear
qui gen _LTE_5 = SN_b2 / (1-SN_b1)
qui sum _LTE_5, det
	local mean = r(mean)
qui _pctile  _LTE_5, p(1, 99)	
	local lo = r(r1)
	local hi = r(r2)
	di "est`i' LTE = " `mean' ", 99% C.I. = [" `lo' ", " `hi' "]" 
	restore 		

	

**********************************************************
//////////////////////////////////////////////////////////
// Figure 1 
//////////////////////////////////////////////////////////
**********************************************************
est restore est1
sum  milexcons1 if e(sample), det
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
while `a' <= 20 { ;
{;			
scalar h_DEMOC			=6 		;		
scalar h_ii				=42.9  		;		
scalar h_lnrival 		= -10.83134   	;
scalar h_LNRGDP 		=24.98198 	;


scalar h_lpop			=9.4 	;

		
		// iirating at 1 sd below mean  = 17.16956
			gen EYIIA = 	  SN_b1*`lagIIA' 
                            + SN_b2* 4.05
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b9*  1 ;
							
		// iirating at 1 sd below mean  = 68.4037
			gen EYIIB =       SN_b1*`lagIIB' 
                            + SN_b2* 98.4   
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b9*  1 ;
							
		// polity at min= -10					
			gen EYDMA =       SN_b1*`lagDMA' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* -10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b9*  1 ;
							
							
		// polity at max = 10									
			gen EYDMB =       SN_b1*`lagDMB' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* 10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
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
            xlabel(0 5 10 15 20, nogrid labsize(2)) 
            ylabel(,  nogrid labsize(2))
			xtitle(Years, size(3))
            ytitle("ln(Military Expenditure)", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) legend(off)
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend( order(1 "IIR Max/Min" 3 "Polity Max/Min" ) );	
			
				
	
	

**********************************************************
//////////////////////////////////////////////////////////
// Table II: Interactive Models
//////////////////////////////////////////////////////////
**********************************************************
use DiGiJprRep, clear 

set more off		
xtpcse milexcons milexcons1  rating1 Xrival $rhs , p 	corr(psar1)
est store all
xtpcse milexcons milexcons1  rating1 Xrival $rhs if oecd==0, p 	corr(psar1)
est store nonOECD
xtpcse milexcons milexcons1  rating1 Xrival $rhs $regions, p 	corr(psar1)
est store region
xtpcse milexcons milexcons1  rating1 Xrival $rhs i.year, het 	corr(psar1)
est store years
xtabond2 milexcons milexcons1  rating1 Xrival lnrival1 polity21  lngdpB1   intra extra inter , gmm(milexcons1  lngdpB1  , lag(2 2)) iv(polity21   intra extra inter rating1 Xrival lnrival1)  robust 
est store gmm


**********************************************************
//////////////////////////////////////////////////////////
// Figure 2
//////////////////////////////////////////////////////////
**********************************************************	
#delimit ;
est restore all;
	
matrix b=e(b);
matrix V=e(V);
scalar b1=b[1,4];
scalar b3=b[1,3];
scalar varb1=V[4,4];
scalar varb3=V[3,3];
scalar covb1b3=V[4,3];
scalar list b1 b3 varb1 varb3 covb1b3;
range MVZ 4.05 98.4 1000;
gen conbx=b1+b3*MVZ;
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) ;
gen ax=1.96*consx;
gen upperx=conbx+ax;
gen lowerx=conbx-ax;
gen where=-0.045;
gen pipe = "|";
egen tag_rating = tag(rating1);
gen yline=0;


#delimit ;

graph twoway hist rating1, width(1.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(0 50 100, nogrid labsize(2))
		     ylabel(, axis(1) nogrid labsize(2))
		     ylabel(, axis(2) nogrid labsize(2))
	         yscale(noline alt)
		     yscale(noline alt axis(2))	
             xscale(noline)
             legend(off)
             xtitle("IIR" , size(2.5)  )
             ytitle("Marginal effect" , axis(1) size(2.5))
             ytitle("% of obs." , axis(2) size(2.5))
             xsca(titlegap(2))
             ysca(titlegap(2))
			 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			 name(all, replace);
 drop MVZ- yline;

 

		
********************************************************************************************************************
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 												APPENDIX														  //	  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
********************************************************************************************************************
use DiGiJprRep, clear 



**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A2
//////////////////////////////////////////////////////////
**********************************************************	
global rhsgdppc  lnrival1 polity21  lngdpB1  intra extra inter  

// Additive
est clear
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 $rhsgdppc , p 	corr(psar1)
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 $rhsgdppc if oecd==0, p 	corr(psar1)
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 $rhsgdppc $regions, p 	corr(psar1)
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 $rhsgdppc i.year, het 	corr(psar1)
eststo: xtabond2 lmilexgdp l.lmilexgdp   rating1 polity21  lngdpB1 lnrival1 intra extra inter , ///
	gmm(l.lmilexgdp   lngdpB1  , lag(2 2))	///
	iv(rating1 polity21  lnrival1 intra extra inter ) noconst 	robust 

	

**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A3
//////////////////////////////////////////////////////////
**********************************************************		

	est clear
	set more off
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 Xrival $rhsgdppc , p 	corr(psar1)
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 Xrival $rhsgdppc if oecd==0, p 	corr(psar1)
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 Xrival $rhsgdppc $regions, p 	corr(psar1)
eststo: xtpcse lmilexgdp l.lmilexgdp  rating1 Xrival $rhsgdppc i.year, het 	corr(psar1)	
eststo: xtabond2 lmilexgdp l.lmilexgdp   rating1 polity21  lngdpB1  lnrival1 Xrival intra extra inter , ///
	gmm(l.lmilexgdp   lngdpB1  , lag(2 2))	///
	iv(rating1 polity21  lnrival1 Xrival intra extra inter ) noconst 	robust 	
	



**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A4
//////////////////////////////////////////////////////////
**********************************************************	
est clear
eststo: xtpcse milexcons milexcons1  rating1 $rhs lnallycinc, p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs rpc2l , p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs lnaid, p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs lnoil, p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 $rhs debtgni1 , p 	corr(psar1)




**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A5
//////////////////////////////////////////////////////////
**********************************************************

	
est clear 	
xtpcse milexcons milexcons1  lspinvest $rhs if year>1990, p corr(psar)
est sto m1

gen Xrival2 = 	lspinvest*lnrival1
xtpcse milexcons milexcons1  lspinvest Xrival2 $rhs if year>1990, p corr(psar)
est sto m2

xtpcse milexcons milexcons1  lnspread10 $rhs if ccode!=2 , p corr(psar)
est sto m3
gen Xrival3 = 	lnspread10*lnrival1
xtpcse milexcons milexcons1  lnspread10 Xrival3 $rhs if ccode!=2 , p corr(psar)
est sto m4 



est restore m2
#delimit ; 
matrix b=e(b);
matrix V=e(V);
scalar b1=b[1,4];
scalar b3=b[1,3];
scalar varb1=V[4,4];
scalar varb3=V[3,3];
scalar covb1b3=V[4,3];
scalar list b1 b3 varb1 varb3 covb1b3;

gen _SP = _n-1 if _n<3;

gen _mean = b1+b3*_SP;
gen _hi = _mean+(1.96*(sqrt(varb1+varb3*(_SP^2)+2*covb1b3*_SP)));
gen _lo = _mean-(1.96*(sqrt(varb1+varb3*(_SP^2)+2*covb1b3*_SP)));
 cap label var _SP "S&P Rating";
 cap label define SNP 0 "Not S&P Invest. Grade" 1 "S&P Invest. Grade";
 cap label values _SP SNP;


 #delimit ;

cap gen yline=0;
twoway 
(rcap _lo _hi _SP if _SP==1, color(black) sort )
(rcap _lo _hi _SP if _SP==0, color(black) sort )
(line yline _SP, lcolor(black) lpattern(dash)), 
xlabel(minmax, valuelabel)  legend(off)
plotregion(margin(20 20 5 5)) ytitle(Marginal Effect of ln(Rival Cap.), size(3)) 
scheme(s1manual) name(_SP, replace) xtitle(, size(zero))
note("Capped bars lines give 95% confidence interval.") ;
#delimit cr
		
		

		est restore m4
 #delimit ;
grinter lnrival1 ,inter(Xrival3) const02(lnspread1)  nomean 
	name(_bond, replace) yline(0) 
	scheme(s1manual) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 				
	ytitle(Marginal Effect of ln(Rival Cap.), size(3)) ;
	
	#delimit cr

		
graph combine _SP _bond, 		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))


		
**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A6
//////////////////////////////////////////////////////////
**********************************************************
		
		
est clear 
eststo: xtpcse d.milexcons milexcons1  d.(iirating lnrivalcinc polity2 lngdpB  ) ///
  l.(iirating lnrivalcinc polity2  lngdpB  intra extra inter) , het
eststo: xtpcse d.milexcons milexcons1  d.(iirating lnrivalcinc polity2 lngdpB  ) ///
  l.(iirating lnrivalcinc polity2  lngdpB  intra extra inter) if oecd==0, het
eststo: xtpcse d.milexcons milexcons1  d.(iirating lnrivalcinc polity2 lngdpB   ) ///
  l.(iirating lnrivalcinc polity2  lngdpB  intra extra inter) i.region, het
eststo: xtpcse d.milexcons milexcons1  d.(iirating lnrivalcinc polity2 lngdpB  ) ///
  l.(iirating lnrivalcinc polity2  lngdpB  intra extra inter) i.year, het
  
  
**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A7 
//////////////////////////////////////////////////////////
**********************************************************

est clear 
eststo: ivregress 2sls 	LMILEX  PN6 LNRGDP LNFOES LNFRIENDS DEMOC (LMILEX1= PN61 PN62 LNRGDP1 LNRGDP2 ) if year>=1950 &  year<=2000,  vce(robust)
eststo: ivregress 2sls 	LMILEX rating1 PN6 LNRGDP LNFOES LNFRIENDS DEMOC (LMILEX1=PN61 PN62 LNRGDP1 LNRGDP2  ) if year>=1950 &  year<=2000,  vce(robust)



**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A8
//////////////////////////////////////////////////////////
**********************************************************

est clear
eststo: xtpcse milgdp pol2_fw bdthpct cwdthpct srivalcap allycap gdp emppop	if year >= 1950 & year <= 1997 , p corr(psar)	
eststo: xtpcse milgdp rating1 pol2_fw bdthpct cwdthpct srivalcap allycap gdp emppop	if year >= 1950 & year <= 1997 , p corr(psar)


**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Table A9
//////////////////////////////////////////////////////////
**********************************************************
  est clear 
eststo: xtpcse milexcons milexcons1  rating1 $rhs i.ccode, p 	corr(psar1)
eststo: xtpcse milexcons milexcons1  rating1 Xrival $rhs i.ccode , p 	corr(psar1)






**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Figure A1
//////////////////////////////////////////////////////////
**********************************************************		
	

**********************************************************
// FIGURE :  LONG TERM EFFFECTS OF LINEAR MODEL (no OECD)
**********************************************************
use DiGiJprRep, clear 
global rhs lnrival1 polity21  lngdpB1  intra extra inter   
xtpcse milexcons milexcons1  rating1 $rhs if oecd==0, p 	corr(psar1)


sum  milexcons1 if e(sample), det
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
while `a' <= 20 { ;
{;			
scalar h_DEMOC			=6 		;		
scalar h_ii				=42.9  		;		
scalar h_lnrival 		= -10.83134   	;
scalar h_lpop 			=9.437673			;
scalar h_LNRGDP 		=24.98198 	;


scalar h_lpop			=9.4 	;

		
		// iirating at 1 sd below mean  = 17.16956
			gen EYIIA = 	  SN_b1*`lagIIA' 
                            + SN_b2* 4.05
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b9*  1 ;
							
		// iirating at 1 sd below mean  = 68.4037
			gen EYIIB =       SN_b1*`lagIIB' 
                            + SN_b2* 98.4   
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b9*  1 ;
							
		// polity at min= -10					
			gen EYDMA =       SN_b1*`lagDMA' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* -10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b9*  1 ;
							
							
		// polity at max = 10									
			gen EYDMB =       SN_b1*`lagDMB' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* 10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
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
            ytitle("ln(Military Expenditure)", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend( off ) title(Non-OECD Sample, size(medium)) name(LTEmodel2, replace);	
			

#delimit cr 	


**********************************************************
// FIGURE :  LONG TERM EFFFECTS OF LINEAR MODEL (regions fixed effects )
**********************************************************
use DiGiJprRep, clear 
global rhs lnrival1 polity21  lngdpB1  intra extra inter  
global regions fl_western fl_eeurop fl_america fl_ssafrica fl_asia
xtpcse milexcons milexcons1  rating1 $rhs fl_western fl_eeurop fl_america fl_ssafrica fl_asia, p 	corr(psar1)


sum  milexcons1 if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

set more off 
#delimit ; 
preserve; 
set seed 8675309;

drawnorm SN_b1-SN_b14, n(10000) means(e(b)) cov(e(V)) clear;

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
while `a' <= 20 { ;
{;			
scalar h_DEMOC			=6 		;		
scalar h_ii				=42.9  		;		
scalar h_lnrival 		= -10.83134   	;
scalar h_lpop 			=9.437673			;
scalar h_LNRGDP 		=24.98198 	;


scalar h_lpop			=9.4 	;

		
		// iirating at 1 sd below mean  = 17.16956
			gen EYIIA = 	  SN_b1*`lagIIA' 
                            + SN_b2* 4.05
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b14*  1 ;
							
		// iirating at 1 sd below mean  = 68.4037
			gen EYIIB =       SN_b1*`lagIIB' 
                            + SN_b2* 98.4   
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b14*  1 ;
							
		// polity at min= -10					
			gen EYDMA =       SN_b1*`lagDMA' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* -10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b14*  1 ;
							
							
		// polity at max = 10									
			gen EYDMB =       SN_b1*`lagDMB' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* 10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b14*  1 ;
							
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
            ytitle("ln(Military Expenditure)", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend( off ) title(Region FE, size(medium)) name(LTEmodel3, replace);	
			

#delimit cr	
	

**********************************************************
// FIGURE :  LONG TERM EFFFECTS OF LINEAR MODEL (yearly fixed effects )
**********************************************************
use DiGiJprRep, clear 
global rhs lnrival1 polity21  lngdpB1  intra extra inter  
global regions fl_western fl_eeurop fl_america fl_ssafrica fl_asia
xtpcse milexcons milexcons1  rating1 $rhs _Iyear_*, het 	corr(psar1)


sum  milexcons1 if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

set more off 
#delimit ; 
preserve; 
set seed 8675309;

drawnorm SN_b1-SN_b35, n(10000) means(e(b)) cov(e(V)) clear;

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
while `a' <= 20 { ;
{;			
scalar h_DEMOC			=6 		;		
scalar h_ii				=42.9  		;		
scalar h_lnrival 		= -10.83134   	;
scalar h_lpop 			=9.437673			;
scalar h_LNRGDP 		=24.98198 	;


scalar h_lpop			=9.4 	;

		
		// iirating at 1 sd below mean  = 17.16956
			gen EYIIA = 	  SN_b1*`lagIIA' 
                            + SN_b2* 4.05
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b35*  1 ;
							
		// iirating at 1 sd below mean  = 68.4037
			gen EYIIB =       SN_b1*`lagIIB' 
                            + SN_b2* 98.4   
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b35*  1 ;
							
		// polity at min= -10					
			gen EYDMA =       SN_b1*`lagDMA' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* -10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b35*  1 ;
							
							
		// polity at max = 10									
			gen EYDMB =       SN_b1*`lagDMB' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* 10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0
                            + SN_b35*  1 ;
							
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
            ytitle("ln(Military Expenditure)", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend( off ) title(Year FE, size(medium)) name(LTEmodel4, replace);	
#delimit cr
			


**********************************************************
// FIGURE :  LONG TERM EFFFECTS OF LINEAR MODEL (GMM Model )
**********************************************************
use DiGiJprRep, clear 
xtabond2 milexcons milexcons1  rating1 lnrival1 polity21  lngdpB1   intra extra inter , ///
	gmm(milexcons1 rating1 lngdpB1   , lag(2 2))	///
	iv(polity21  lnrival1 intra extra inter ) noconst 	robust 

sum  milexcons1 if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

set more off 
#delimit ; 
preserve; 
set seed 8675309;

drawnorm SN_b1-SN_b8, n(10000) means(e(b)) cov(e(V)) clear;

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
while `a' <= 20 { ;
{;			
scalar h_DEMOC			=6 		;		
scalar h_ii				=42.9  		;		
scalar h_lnrival 		= -10.83134   	;
scalar h_lpop 			=9.437673			;
scalar h_LNRGDP 		=24.98198 	;


scalar h_lpop			=9.4 	;

		
		// iirating at 1 sd below mean  = 17.16956
			gen EYIIA = 	  SN_b1*`lagIIA' 
                            + SN_b2* 4.05
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0 ;
							
		// iirating at 1 sd below mean  = 68.4037
			gen EYIIB =       SN_b1*`lagIIB' 
                            + SN_b2* 98.4   
                            + SN_b3* h_lnrival  
                            + SN_b4* h_DEMOC 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0 ;
							
		// polity at min= -10					
			gen EYDMA =       SN_b1*`lagDMA' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* -10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0 ;
							
							
		// polity at max = 10									
			gen EYDMB =       SN_b1*`lagDMB' 
                            + SN_b2* h_ii   
                            + SN_b3* h_lnrival  
                            + SN_b4* 10 
                            + SN_b5* h_LNRGDP
                            + SN_b6* 0
                            + SN_b7* 0
                            + SN_b8* 0 ;
							
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
            ytitle("ln(Military Expenditure)", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend( off ) title(GMM, size(medium))  name(LTEmodel5, replace);	
			
#delimit ;
graph combine LTEmodel2 LTEmodel3 LTEmodel4 LTEmodel5, 
		            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		title(LTE of IIR and Democracy on ln(Mil. Exp.), size(medium))
		caption("Note: Capped bars indicate the Min/Max levels of IIR x-capped bars indicate Min/Max levels of Polity", size(small));	
	
	
**********************************************************
//////////////////////////////////////////////////////////
// Appendix: Figure A2
//////////////////////////////////////////////////////////
**********************************************************	
use DiGiJprRep, clear 

set more off		
xtpcse milexcons milexcons1  rating1 Xrival $rhs if oecd==0, p 	corr(psar1)
est store nonOECD
xtpcse milexcons milexcons1  rating1 Xrival $rhs $regions, p 	corr(psar1)
est store region
xtpcse milexcons milexcons1  rating1 Xrival $rhs i.year, het 	corr(psar1)
est store years
xtabond2 milexcons milexcons1  rating1 Xrival lnrival1 polity21  lngdpB1   intra extra inter , gmm(milexcons1  lngdpB1  , lag(2 2)) iv(polity21   intra extra inter rating1 Xrival lnrival1)  robust noconst
est store gmm	
	
set more off 
#delimit ;
	
local list 	 nonOECD  region years gmm;
foreach X of local list	{;
est restore `X';


if "`X'" == "nonOECD" {;
	local title "Non-OECD";
	};
if "`X'" == "region" {;
	local title "Region FE";
	};
if "`X'" == "years" {;
	local title "Year FE";
	};
if "`X'" == "gmm" {;
	local title "GMM";
	};
	
	matrix b=e(b);
matrix V=e(V);
scalar b1=b[1,4];
scalar b3=b[1,3];
scalar varb1=V[4,4];
scalar varb3=V[3,3];
scalar covb1b3=V[4,3];
scalar list b1 b3 varb1 varb3 covb1b3;
range MVZ 4.05 98.4 1000;
gen conbx=b1+b3*MVZ ;
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) ;
gen ax=1.96*consx;
gen upperx=conbx+ax;
gen lowerx=conbx-ax;

gen where=-0.045;
gen pipe = "|";
egen tag_rating = tag(rating1);
gen yline=0;


#delimit ;

graph twoway hist rating1, width(1.5) percent color(gs14) yaxis(2)
	    ||   line conbx   MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
        ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)
	    ||   ,
             xlabel(0 50 100, nogrid labsize(2))
		     ylabel(, axis(1) nogrid labsize(2))
		     ylabel(, axis(2) nogrid labsize(2))
	         yscale(noline alt)
		     yscale(noline alt axis(2))	
             xscale(noline)
             legend(off)
             title("`title'", size(3.5))
             xtitle("IIR" , size(2.5)  )
             ytitle("Marginal effect" , axis(1) size(2.5))
             ytitle("% of obs." , axis(2) size(2.5))
             xsca(titlegap(2))
             ysca(titlegap(2))
			 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			 name(`X', replace);
 drop MVZ- yline;
 };
 
graph combine nonOECD  region years gmm, cols(2) scheme(s2mono)  graphregion(fcolor(white) ilcolor(white) lcolor(white))	

	










