*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A34 of the web appendix of Berman and Couttenier (2014)								  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
cd "$Results"
*						*--------------------------------------------*
						*--------------------------------------------*
						*    			TABLE A34     				 *    
						*--------------------------------------------*
						*--------------------------------------------*
*
use "$Output_data\FAO_hs4", clear
*
forvalues x=1(1)3{
	g dtrade_l`x' = l`x'.dtrade
}
*
eststo: reg   dtrade dtrade_l1 						yeard*, ro
eststo: reg   dtrade dtrade_l1  dtrade_l2 			yeard*, ro
eststo: reg   dtrade dtrade_l1  dtrade_l2 dtrade_l3 yeard* Itrend*, ro
*
eststo: reg   dtrade dtrade_l1 						yeard* Itrend*, ro
eststo: reg   dtrade dtrade_l1  dtrade_l2 			yeard* Itrend*, ro
eststo: reg   dtrade dtrade_l1  dtrade_l2 dtrade_l3 yeard* Itrend*, ro
*
log using "$Results\Table_A34.log", replace
set linesize 250
esttab, mtitles keep(dtrade*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(dtrade*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
						
