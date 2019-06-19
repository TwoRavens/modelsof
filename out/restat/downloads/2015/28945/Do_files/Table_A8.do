*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file constructs Table A.8 of the appendix of Berman and Couttenier (2014)											  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
			*--------------------------------------------*
			*--------------------------------------------*
			*  	 TABLE A.8 - CRISES , TRADE AND GDP       *
			*--------------------------------------------*
			*--------------------------------------------*
*
*************
* A - TABLE *
*************

/* GRAVITY */
use "$Output_data\trade_crises_ijt", clear
/*without gdps */
eststo: xtreg lflow crisis 				 yeard* if acled1 == 1 | acled1 == 2 | ucdp == 1, fe ro 
distinct iso_o if e(sample)
distinct iso_d if e(sample)
tab year if e(sample)
/*with GDPs*/
eststo: xtreg lflow crisis lgdp_o lgdp_d yeard* if acled1 == 1 | acled2 == 1 | ucdp == 1, fe ro 
distinct iso_o if e(sample)
distinct iso_d if e(sample)
tab year if e(sample)
*
/* COUNTRY LEVEL */
use "$Output_data\trade_crises_it", clear
eststo: xtreg lexport_wb exposure_crisis yeard*  if acled1 == 1 | acled2 == 1 | ucdp == 1, fe ro
distinct iso3 if e(sample)
tab year if e(sample)
*
log using "Table_A8.log", replace
set linesize 250
esttab, mtitles keep(crisis lgdp_o lgdp_d exposure_crisis) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(crisis lgdp_o lgdp_d exposure_crisis) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

