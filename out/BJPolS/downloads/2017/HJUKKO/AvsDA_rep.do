**********************************************************
//////////////////////////////////////////////////////////
// Author:	Matthew R. DiGiuseppe  
//
// Do File: AvsDA_rep
//
// Date: 	02/18/16
//
// Project:		Arms and Alliances 
//////////////////////////////////////////////////////////
**********************************************************





use AvsDA_replication, clear 

global NOREGIME  DEMOC defense lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL2 DEMOC LNdefense_MILEX_dem LNdefense_MILEX_nodem lnrivalmil atwar civilwar LNRGDP milcoor




**********************************************************
// Summary Stats (Table 1)
**********************************************************

xtpcse  LMILEX LMILEX1 $NOREGIME , het corr(psar)

 
gen m1sample = 1 if e(sample)==1

// Summary Stats (Table 1)

sum defense_dem defense_nodem
sum dem_defense_form nodem_defense_form
ttest dem_defense_form == nodem_defense_form


gen milgdp_all = MILGDP
gen milgdp_noally = MILGDP if atopally==0
gen milgdp_atop = MILGDP if atopally==1
gen milgdp_dem = MILGDP if defense_dem==1
gen milgdp_nodem = MILGDP if defense_nodem==1
gen milgdp_demonly = MILGDP if defense_dem==1 & defense_nodem==0
gen milgdp_nodemonly = MILGDP if defense_dem==0 & defense_nodem==1

label var milgdp_all "All states"
label var milgdp_noally "No defense pact"
label var milgdp_atop "Any defense pact"
label var milgdp_dem "Defense pact with democracy"
label var milgdp_nodem "Defense pact with non-democracy"
label var milgdp_demonly "Defense pact with democracy and no non-democratic defense pact"
label var milgdp_nodemonly "Defense pact with non-democracy and no democratic defense pact"

sutex2 milgdp_* if m1sample==1, varlabels 

estpost sum milgdp_* if m1sample==1
esttab using sumstats.tex, ///
	cells("mean(fmt(2)) count(fmt(0))") ///
	nomtitle nonumber  replace

	


**********************************************************
// T-tests (Table 1)
**********************************************************


ttest MILGDP ,by(atopally)

ttest MILGDP ,by(defense_dem)

capture drop cutpoint
gen cutpoint = 0 if defense_dem==0 & defense_nodem==1 
replace cutpoint = 1 if defense_dem==1 & defense_nodem==0
ttest MILGDP ,by(cutpoint)

**********************************************************
// Pre- Post-Formation Military Burden
**********************************************************


xtset ccode year 

gen MILGDP1 = l.MILGDP

gen LMILEX_5ma = (L4.LMILEX+ L3.LMILEX+ L2.LMILEX +  L.LMILEX + L5.LMILEX)/5
gen LMILEX_5fma = (F5.LMILEX+ F4.LMILEX+ F3.LMILEX +  F2.LMILEX + F.LMILEX)/5
gen MILGDP_5ma = (L4.MILGDP+ L3.MILGDP+ L2.MILGDP +  L.MILGDP + L5.MILGDP)/5
gen MILGDP_5fma = (F5.MILGDP+ F4.MILGDP+ F3.MILGDP +  F2.MILGDP + F.MILGDP)/5
//percentage of cases experiencing a increase/decrease
gen postally_ch = LMILEX_5fma- LMILEX1 


gen postally_dem = 1 if dem_defense_form==1 & postally_ch>0 & !missing(postally_ch)
	replace postally_dem = 0 if dem_defense_form==1 & postally_ch<0 & !missing(postally_ch)
gen postally_nodem = 1 if nodem_defense_form==1 & postally_ch>0 & !missing(postally_ch)
	replace postally_nodem = 0 if nodem_defense_form==1 & postally_ch<0 & !missing(postally_ch)
gen postally_all = 1 if defense_form==1 & postally_ch>0 & !missing(postally_ch)
	replace postally_all = 0 if defense_form==1 & postally_ch<0 & !missing(postally_ch)

gen postally_ch_bi = 1 if postally_ch>0	& !missing(postally_ch)
	replace postally_ch_bi=0 if postally_ch<=0	& !missing(postally_ch)
	
tab postally_all
tab postally_nodem
tab postally_dem 

tab postally_ch_bi
tab postally_ch_bi if defense_form!=1
	




**********************************************************
/// TABLE 2 : Main model using dichotmous defense alliance with democracy + non-democracy: 
**********************************************************
set more off 
xtset ccode year 
est clear 
xtpcse  LMILEX LMILEX1 $NOREGIME , p corr(psar)
	est store m0
xtpcse  LMILEX LMILEX1 $MODEL , p corr(psar)
	est store m1
xtpcse  LMILEX LMILEX1 $MODEL i.ccode , p corr(psar)
	est store m_cFE	
xtpcse  LMILEX LMILEX1 $MODEL i.year , het corr(psar)
	est store m_yFE
ivregress 2sls  LMILEX  $MODEL (LMILEX1 = L(1/2).(LNRGDP lnrivalmil)), vce(robust) first
	est store m2
est table m*, drop(i.ccode i.year) star stats(N)
	
	
// IV model robust to year and ccode FE	(noted in manuscript) 
qui ivregress 2sls  LMILEX  $MODEL (LMILEX1 = L(1/2).(LNRGDP lnrivalmil)) i.year, vce(robust) first
		eststo R1
qui ivregress 2sls  LMILEX  $MODEL (LMILEX1 = L(1/2).(LNRGDP lnrivalmil)) i.ccode, vce(robust) first
	eststo R2
	

**********************************************************
/// TABLE 3 : Robustness - Controlling for possible "pre alliance buildup" & Major Power/Minor Power 
**********************************************************	
set more off 
xtset ccode year 
xtpcse  LMILEX LMILEX1 $MODEL nato warsaw, p corr(psar)
	est store m_nato
xtpcse  LMILEX LMILEX1 $MODEL USdefense USSRdefense, p corr(psar)
	est store m_US	
xtpcse  LMILEX LMILEX1 $MODEL  defense_MP , p corr(psar)
	est store m_mp 	
xtpcse  LMILEX LMILEX1 $MODEL multilateral , p corr(psar)
	est store m_multi 	
xtpcse  LMILEX LMILEX1 $MODEL2 , p corr(psar)
	est store m_agg
xtpcse  LMILEX LMILEX1 $MODEL predemalliance prenondemalliance, p corr(psar)
	est store m_pre
xtpcse  LMILEX LMILEX1 $MODEL polity_neighbor_weight , p corr(psar)
	est store m_neigh
	
	
// This model noted in footnote and presented in R&R memo
// Central IVs created excluding NATO & Warsaw from dem/non-dem alliance variable construction.
xtpcse  LMILEX LMILEX1 DEMOC dem_NONNATO nondem_NONNATO lnrivalmil atwar civilwar LNRGDP milcoor , p corr(psar)
	est store m_nato2	
	
est tab m_nato  m_US m_mp m_multi m_agg m_pre m_neigh, star stats(N)





**********************************************************
///  Table 4 
**********************************************************	


global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor
xtset ccode year  
	#delimit ; 		
	set more off;
	cmp setup; 
cmp	(LMILEX=LMILEX1 DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor defense_dem defense_nodem )
	(defense_dem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  )
	(defense_nodem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  ),
	ind( $cmp_cont $cmp_probit $cmp_probit ) robust ;	
est store cmp_2; 
#delimit cr

	
**********************************************************
// LTE Figures: 
**********************************************************
	
set more off
local list m1 m_LDV
foreach E of numlist 1 2  {
est restore m`E'
sum  LMILEX1 if e(sample)
local lagmean = `r(mean)'
di "LMILEX1 mean =" `lagmean'

foreach var of varlist  DEMOC milcoor {
sum `var' if e(sample), det
local p50_`var' = `r(p50)'
}

foreach var of varlist  LNRGDP lnrivalmil DEMOC milcoor{
sum `var' if e(sample), det
local m_`var' = `r(mean)'
}

set more off 
#delimit ; 
preserve; 
set seed 8675309;
drawnorm SN_b1-SN_b10, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost	EY00_lo EY00_hi
				EY10_lo EY10_hi
				EY01_lo EY01_hi
				EY11_lo EY11_hi
				_t 	using sims, replace;
						
noisily display "start";

local lag00 = `lagmean';
local lag10 = `lagmean';
local lag01 = `lagmean';
local lag11 = `lagmean';

local a=0 ;
while `a' <= 20 { ;
{;			
scalar h_DEMOC		=`m_DEMOC'  		;
//scalar h_DEMOC			=7  		;
scalar h_defense_dem 	=0			;
scalar h_defense_nodem 	=0			;			
scalar h_rivalcap 		= `m_lnrivalmil' 	;
scalar h_atwar 			=0			;
scalar h_civilwar 		=0			;
scalar h_LNRGDP 		=`m_LNRGDP' 	;
scalar h_milcoor		=`m_milcoor'  	;
		
			gen EY00 = 		  SN_b1*`lag00' 
                            + SN_b2* h_DEMOC   
                            + SN_b3* 0 
                            + SN_b4* 0  
                            + SN_b5* h_rivalcap
                            + SN_b6* h_atwar
                            + SN_b7* h_civilwar
                            + SN_b8* h_LNRGDP
                            + SN_b9* h_milcoor
							+ SN_b10* 1 ;

			gen EY10 = 		  SN_b1*`lag10' 
                            + SN_b2* h_DEMOC   
                            + SN_b3* 1 
                            + SN_b4* 0  
                            + SN_b5* h_rivalcap
                            + SN_b6* h_atwar
                            + SN_b7* h_civilwar
                            + SN_b8* h_LNRGDP
                            + SN_b9* h_milcoor
							+ SN_b10* 1 ;
							
							
			gen EY01 = 		  SN_b1*`lag01' 
                            + SN_b2* h_DEMOC   
                            + SN_b3* 0
                            + SN_b4* 1  
                            + SN_b5* h_rivalcap
                            + SN_b6* h_atwar
                            + SN_b7* h_civilwar
                            + SN_b8* h_LNRGDP
                            + SN_b9* h_milcoor
							+ SN_b10* 1 ;
							
			gen EY11 = 		  SN_b1*`lag11' 
                            + SN_b2* h_DEMOC   
                            + SN_b3* 1
                            + SN_b4* 1  
                            + SN_b5* h_rivalcap
                            + SN_b6* h_atwar
                            + SN_b7* h_civilwar
                            + SN_b8* h_LNRGDP
                            + SN_b9* h_milcoor
							+ SN_b10* 1 ;															
							
			gen time = `a';
			egen _time = max(time);
			egen _lag00 = mean(EY00);
			egen _lag10 = mean(EY10);
			egen _lag01 = mean(EY01);
			egen _lag11 = mean(EY11);		
			
  tempname 	EY00_lo EY00_hi 
			EY10_lo EY10_hi
			EY01_lo EY01_hi 
			EY11_lo EY11_hi 
			_t ; 			
			
			 _pctile EY00, p(2.5,97.5) ;
			    scalar `EY00_lo' = r(r1);
				scalar `EY00_hi' = r(r2);  
			 _pctile EY10, p(2.5,97.5) ;
			    scalar `EY10_lo' = r(r1);
				scalar `EY10_hi' = r(r2); 
			 _pctile EY01, p(2.5,97.5) ;
			    scalar `EY01_lo' = r(r1);
				scalar `EY01_hi' = r(r2); 
			 _pctile EY11, p(2.5,97.5) ;
			    scalar `EY11_lo' = r(r1);
				scalar `EY11_hi' = r(r2); 				
			 scalar `_t'=_time;

			
   post mypost 	(`EY00_lo') (`EY00_hi') 
				(`EY10_lo') (`EY10_hi')
				(`EY01_lo') (`EY01_hi')
				(`EY11_lo') (`EY11_hi')
				(`_t');			
			
    };      
    
    
    local a=`a'+ 1;
	
	local list 00 01 10 11 ;
	foreach i of local list {;
		qui sum EY`i' , meanonly ;
		local lag`i' = `r(mean)';
		};


    drop EY* time _time _lag* ;

    display "." _c;
	display "lag00 =" `lag00' "lag10=" `lag10' ;	
    
} ;
display "";
postclose mypost;
restore;
merge using sims;			                                
#delimit ;
graph twoway rcap EY10_lo EY10_hi _t, clwidth(medium) color(gs8) 
        ||   rcap EY00_lo EY00_hi _t, clwidth(medium) color(black) lpattern(tight_dot)
        ||   rcap EY01_lo EY01_hi _t, clwidth(medium) color(black) lpattern(vshortdash)
        ||  ,   
            xlabel(0 5 10 15 20, nogrid labsize(2)) 
            ylabel(,  nogrid labsize(2))
			xtitle(Years, size(3))
            ytitle("Log of Mil. Spending", size(3))
		    xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
			legend(off) name(m`E', replace);	
#delimit cr			
		
drop EY00_lo- _merge		
	}	

graph display m1	
	graph save m1 "Document/LTE1m1.gph", replace	
graph display m2
	graph save m2 "Document/LTE1m2.gph", replace
		


		
		
		
		
**********************************************************		
**********************************************************
// APPENDIX
**********************************************************
**********************************************************

use AvsDA_replication, clear 


global NOREGIME  DEMOC defense lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL2 DEMOC LNdefense_MILEX_dem LNdefense_MILEX_nodem lnrivalmil atwar civilwar LNRGDP milcoor



**********************************************************
/// TABLE A.1
**********************************************************	
	
set more off 
est clear 
xtset ccode year
xtpcse  LMILEX LMILEX1 $MODEL2 , p corr(psar)
	est store m1
		
	
xtpcse  LMILEX LMILEX1 $MODEL2 i.ccode , p corr(psar)
	est store m_cFE

	
xtpcse  LMILEX LMILEX1 $MODEL2 i.year , het corr(psar)
	est store m_yFE
ivregress 2sls  LMILEX  $MODEL2 (LMILEX1 = L(1/2).(LNRGDP lnrivalmil)), vce(robust) first
	est store m_iv

xtpcse  LMILEX LMILEX1 LNdefense_MILEXnoNATO_dem LNdefense_MILEX_nodem lnNATOmil lnrivalmil atwar civilwar LNRGDP milcoor  , p corr(psar)	
	est store m_nato
	
xtpcse  LMILEX LMILEX1 LNdefense_MILEXnoUS_dem LNdefense_MILEX_nodem lnUSmil lnrivalmil atwar civilwar LNRGDP milcoor  , p corr(psar)	
	est store m_us

est table m*, drop(i.ccode i.year) star
	



**********************************************************
/// TABLE A.2
**********************************************************	
global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor

est clear 
set more off 
xtset ccode year 
xtpcse  LMILGDP l.LMILGDP $MODEL , p corr(psar)
	est store m1
xtpcse  LMILGDP l.LMILGDP $MODEL i.ccode , p corr(psar)
	est store m_cFE	
xtpcse  LMILGDP l.LMILGDP $MODEL i.year , het corr(psar)
	est store m_yFE
ivregress 2sls  LMILGDP   $MODEL (l.LMILGDP = L(1/2).(LNRGDP lnrivalmil)), vce(robust) first
	est store m_LDV
	
// Noteable controls (NATO, US ally, USSR ally, peacetime coordination )
xtpcse  LMILGDP l.LMILGDP $MODEL nato warsaw , p corr(psar)
	est store m_nato
xtpcse LMILGDP l.LMILGDP $MODEL USdefense USSRdefense , p corr(psar)
	est store m_USally

	
est table m*, drop(i.ccode i.year) star


	
**********************************************************
/// TABLE A.3
**********************************************************	

est clear 
	#delimit ; 		
	set more off;
cmp	(LMILGDP=l.LMILGDP DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor defense_dem defense_nodem )
	(defense_dem = l.LMILGDP DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  )
	(defense_nodem = l.LMILGDP DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  ),
	ind( $cmp_cont $cmp_probit $cmp_probit ) robust ;	
est store cmp_2; 


**********************************************************
/// TABLE A.4
**********************************************************	


 est clear 

	#delimit ; 		
	set more off;
cmp	(LMILEX=LMILEX1 DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor defense_dem defense_nodem i.year )
	(defense_dem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  )
	(defense_nodem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  ),
	ind( $cmp_cont $cmp_probit $cmp_probit ) robust ;	
est store cmp_A1; 
 
	#delimit ; 		
	set more off;
cmp	(LMILEX=LMILEX1 DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor defense_dem defense_nodem nato   )
	(defense_dem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  )
	(defense_nodem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  ),
	ind( $cmp_cont $cmp_probit $cmp_probit ) robust ;	
est store cmp_A2; 

	#delimit ; 		
	set more off;
cmp	(LMILEX=LMILEX1 DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor defense_dem defense_nodem  USdefense USSRdefense  )
	(defense_dem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  )
	(defense_nodem = LMILEX DEMOC  lnrivalmil atwar  LNRGDP  defense_dem1 defense_nodem1  ),
	ind( $cmp_cont $cmp_probit $cmp_probit ) robust ;	
est store cmp_A3; 


  est table _all, drop( i.year) star


 	
**********************************************************
/// TABLE A.5
**********************************************************

// create cubic polynomials to aid convergence. 

btscs defense_nodem1 year ccode , gen(ndyrs)
gen ndyrs2 = ndyrs^2
gen ndyrs3 = ndyrs^3

btscs defense_dem1 year ccode , gen(dyrs)
gen dyrs2 = dyrs^2
gen dyrs3 = dyrs^3

label var dyrs " $ \mbox{Time since last ally}_{Dem} $"
label var dyrs2 " $ \mbox{Time since last ally}^2_{Dem} $"
label var dyrs3 " $ \mbox{Time since last ally}^3_{Dem} $"

label var ndyrs " $ \mbox{Time since last ally}_{NonDem} $"
label var ndyrs2 " $ \mbox{Time since last ally}^2_{NonDem} $"
label var ndyrs3 " $ \mbox{Time since last ally}^3_{NonDem} $"


// Democratic Alliance Formation 
cap drop  I_LMILEX I_defense_dem

_est clear 
cdsimeq (LMILEX LMILEX1 DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor   ) ///
(defense_dem   DEMOC  lnrivalmil atwar  LNRGDP  dyrs dyrs2 dyrs3   ),  est
	
	_estimates unhold model_1
	est store m1
	_estimates unhold model_2
	est store m2
	
	drop  I_LMILEX I_defense_*


	// Non-Democratic Alliance Formation 
cdsimeq (LMILEX LMILEX1 DEMOC  lnrivalmil  atwar civilwar LNRGDP  milcoor   ) ///
(defense_nodem  DEMOC  lnrivalmil atwar  LNRGDP    ndyrs ndyrs2 ndyrs3  ), estimates_hold	

	_estimates unhold model_1
	est store m3
	_estimates unhold model_2
	est store m4
	


**********************************************************
/// TABLE A.6
**********************************************************	

global NOREGIME  DEMOC defense threatenv atwar civilwar LNRGDP milcoor
global MODEL DEMOC defense_dem defense_nodem threatenv atwar civilwar LNRGDP milcoor

xtset ccode year
set more off 
est clear 
xtpcse  LMILEX LMILEX1 $NOREGIME , p corr(psar)
//	est store m0
xtpcse  LMILEX LMILEX1 $MODEL , p corr(psar)
	est store m1
xtpcse  LMILEX LMILEX1 $MODEL i.ccode , p corr(psar)
	est store m_cFE	
xtpcse  LMILEX LMILEX1 $MODEL i.year , het corr(psar)
	est store m_yFE
ivregress 2sls  LMILEX  $MODEL (LMILEX1 = L(1/2).(LNRGDP threatenv)), vce(robust) first
	est store m_LDV

	
est table m*, drop(i.ccode i.year) star stats(N)




**********************************************************
/// TABLE A.7
**********************************************************	
xtpcse  LMILEX LMILEX1 DEMOC dem_NONNATO nondem_NONNATO lnrivalmil atwar civilwar LNRGDP milcoor , p corr(psar)
	est store m_nato2	
		
	
	
	
**********************************************************
/// TABLE A.8
**********************************************************		

preserve 

gen time5yr = 1 if year<=1955
local y1 = 1955 
forval i = 2(1)11{
replace time5yr = `i' if year>`y1' & year<=(`y1'+5)
local  y1 = `y1'+ 5
}
//


collapse (max) defense_dem defense_nodem atwar civilwar DEMOC milcoor ///
		 (mean) lnrivalmil LNRGDP LMILEX LMILEX1 ///
		 , by(ccode time5yr)

xtset ccode time5yr



global NOREGIME  DEMOC defense lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor 



global NOREGIME  DEMOC defense lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor 
est clear 
xtpcse  LMILEX  $MODEL , p corr(ar)
	est store m_5y1

xtpcse  LMILEX l.LMILEX $MODEL , p corr(ar)
	est store m_5y2
		
		
restore 		


**********************************************************
/// TABLE A.9
**********************************************************	
global NOREGIME_P  DEMOC atopally lnrivalmil atwar civilwar LNRGDP milcoor 
global MODEL DEMOC defense_dem defense_nodem lnrivalmil atwar civilwar LNRGDP milcoor 
global POOL DEMOC atopally_dem atopally_nodem lnrivalmil atwar civilwar LNRGDP milcoor 



set more off 
est clear 
xtset ccode year 
xtpcse  LMILEX LMILEX1 $NOREGIME_P , p corr(psar)
	est store m0
xtpcse  LMILEX LMILEX1 $POOL , p corr(psar)
	est store m1
xtpcse  LMILEX LMILEX1 $POOL i.ccode , p corr(psar)
	est store m_cFE	
xtpcse  LMILEX LMILEX1 $POOL i.year , het corr(psar)
	est store m_yFE
ivregress 2sls  LMILEX  $POOL (LMILEX1 = L(1/2).(LNRGDP lnrivalmil)), vce(robust) first
	est store m2
	

est table m*, drop(i.ccode i.year) star stats(N)
