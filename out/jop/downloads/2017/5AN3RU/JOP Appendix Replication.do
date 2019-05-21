
/******************************************************************************

Replication Materials for Online Appendix Material for:

"The Changing Norms of Racial Political Rhetoric and the End of Racial Priming"

By Nicholas A. Valentino, Fabian G. Neuner, and L. Matthew Vandenbroek

The Journal of Politics 


Notes: 
Please see separate Do File for Replication for Manuscript Tables and Figures;
To output the Tables the package "estout" is required; Run "ssc install estout, replace" to install

******************************************************************************/

clear all
set more off 
cd "" // set working directory to where data sets are saved; 



// Table A5: Descriptive Statistics for Study 1

use study1.dta, replace
summarize hc101 provs01 affects01_in angry01_in obamaapp01 teaopp201_in teaopp201_in beckapp01_in palinapp01_in hc_index leader_index symrac01 rt_secs three_conditions

// Table A6: Descriptive Statistics for Study 2

use study2.dta, replace
summarize hc101 provs01 affects01_in obamajo0 teaopp201_in beck01_in hc_index leader_index symrac01 rt_secs if race==1


// Table A7: Descriptive Statistics for Study 3

use study3.dta, replace
summarize hc101 provisions1 affects01_in obamaapp01 palinapp01_in beckapp01_in teaopp01_in hc_index leader_index symrac01 rt_secs


// Table A8: Descriptive Statistics for Study 4

use study4.dta, replace
summarize support_aca01 support_unemployed01 support_poor01 support_pensions01 support_medicaid01 favor_Obama01 favor_Palin01_in favor_Romney01_in favor_Limbaugh01_in favor_TeaPartyAct01_in support_social_welfare01 leader_index symrac01 story_conflict01 story_insensitive01 angdis angry01 disgusted01



// Table A9: Models to Produce Figure 2 

use study1.dta, replace
reg hc_index c.symrac01##i.three_conditions

use study2.dta, replace
reg hc_index c.symrac01##i.three_conditions if race==1

use study3.dta, replace
reg hc_index c.symrac01##i.three_conditions

use study4.dta, replace
reg support_social_welfare01 c.symrac01##i.three_conditions 


// Table A10: Models to Produce Figure 3

use study1.dta, replace
reg leader_index c.symrac01##i.three_conditions

use study2.dta, replace
reg leader_index c.symrac01##i.three_conditions if race==1

use study3.dta, replace
reg leader_index c.symrac01##i.three_conditions 

use study4.dta, replace
reg leader_index c.symrac01##i.three_conditions


// Table A11: Full BIAT Results for Study 1 

use study1.dta, replace

reg hc101 c.rt_secs##i.three_conditions
est store A 
reg provs01 c.rt_secs##i.three_conditions  
est store B
reg affects01_in c.rt_secs##i.three_conditions  
est store C
reg angry01_in c.rt_secs##i.three_conditions 
est store D
reg obamaapp01 c.rt_secs##i.three_conditions
est store E
reg teaopp201_in c.rt_secs##i.three_conditions 
est store F
reg beckapp01_in c.rt_secs##i.three_conditions  
est store G
reg palinapp01_in c.rt_secs##i.three_conditions 
est store H 

esttab A B C D E F G H using "Table A11.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A11) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H


// For Tables A12-A14:
use study2.dta, replace

// Table A12: Full SR Results for Study 2  

reg hc101 c.symrac01##i.three_conditions if race==1
est store A
reg provs01 c.symrac01##i.three_conditions if race==1
est store B
reg affects01_in c.symrac01##i.three_conditions if race==1 
est store C
reg obamajo0 c.symrac01##i.three_conditions if race==1
est store D
reg teaopp201_in c.symrac01##i.three_conditions if race==1
est store E
reg beck01_in c.symrac01##i.three_conditions if race==1 
est store F

esttab A B C D E F using "Table A12.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A12) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F 


// Table A13: Full BIAT Results for Study 2 

reg hc101 c.rt_secs##i.three_conditions if race==1
est store A
reg provs01 c.rt_secs##i.three_conditions if race==1
est store B
reg affects01_in c.rt_secs##i.three_conditions if race==1 
est store C
reg obamajo0 c.rt_secs##i.three_conditions if race==1
est store D
reg teaopp201_in c.rt_secs##i.three_conditions if race==1
est store E
reg beck01_in c.rt_secs##i.three_conditions if race==1 
est store F

esttab A B C D E F using "TableA13.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A13) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F 

// Table A14: BIAT Index Results for Study 2  

reg hc_index c.rt_secs##i.three_conditions if race==1
est store A
reg leader_index c.rt_secs##i.three_conditions if race==1
est store B

esttab A B using "TableA14.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A14) replace
drop _est_A _est_B 

// For Tables A15-A17:
use study3.dta, replace

// Table A15: Full SR Results for Study 3 

reg hc101 c.symrac01##i.three_conditions
est store A
reg provisions1 c.symrac01##i.three_conditions
est store B
reg affects01_in c.symrac01##i.three_conditions
est store C
reg obamaapp01 c.symrac01##i.three_conditions
est store D
reg teaopp01_in c.symrac01##i.three_conditions
est store E
reg beckapp01_in c.symrac01##i.three_conditions
est store F
reg palinapp01_in c.symrac01##i.three_conditions
est store G

esttab A B C D E F G using "TableA15.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A15) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G 


// Table A16: Full BIAT Results for Study 3 

reg hc101 c.rt_secs##i.three_conditions
est store A
reg provisions1 c.rt_secs##i.three_conditions
est store B
reg affects01_in c.rt_secs##i.three_conditions
est store C
reg obamaapp01 c.rt_secs##i.three_conditions
est store D
reg teaopp01_in c.rt_secs##i.three_conditions
est store E
reg beckapp01_in c.rt_secs##i.three_conditions
est store F
reg palinapp01_in c.rt_secs##i.three_conditions
est store G

esttab A B C D E F G using "TableA16.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A16) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G


// Table A17: BIAT Index Results for Study 3 

reg hc_index c.rt_secs##i.three_conditions
est store A
reg leader_index c.rt_secs##i.three_conditions
est store B

esttab A B using "TableA17.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A17) replace
drop _est_A _est_B 


// For Tables A18-A20:
use study4.dta, replace

// Table A18: Full SR Results for Study 4 

reg support_aca01 c.symrac01##i.three_conditions 
est store A
reg support_unemployed01 c.symrac01##i.three_conditions
est store B
reg support_poor01 c.symrac01##i.three_conditions
est store C
reg support_pensions01 c.symrac01##i.three_conditions
est store D
reg support_medicaid01 c.symrac01##i.three_conditions
est store E
reg favor_Obama01 c.symrac01##i.three_conditions 
est store F
reg favor_Palin01_in c.symrac01##i.three_conditions 
est store G
reg favor_Romney01_in c.symrac01##i.three_conditions 
est store H
reg favor_Limbaugh01_in c.symrac01##i.three_conditions 
est store I
reg favor_TeaPartyAct01_in  c.symrac01##i.three_conditions 
est store J

esttab A B C D E F G H I J using "TableA18.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A18) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H _est_I _est_J


// Table A19: Index Results by SR Measurement Timing for Study 4 

reg support_social_welfare01  c.symrac01##i.implicit_distal
est store A
reg support_social_welfare01  c.symrac01##i.implicit_proximal
est store B
reg support_social_welfare01  c.symrac01##i.implicit_post
est store C
reg leader_index c.symrac01##i.implicit_distal
est store D
reg leader_index c.symrac01##i.implicit_proximal
est store E
reg leader_index c.symrac01##i.implicit_post
est store F

esttab A B C D E F using "TableA19.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A19) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F


// Table A20: Models to produce Figure 4 

reg story_insensitive01 i.explicit_implicit##c.symrac01
est store A
reg angdis i.explicit_implicit##c.symrac01
est store B
reg angry01 i.explicit_implicit##c.symrac01
est store C
reg disgusted01 i.explicit_implicit##c.symrac01
est store D

esttab A B C D using "TableA20.rtf", cells(b(star fmt(3)) se(par fmt(4))) title(Table A20) replace
drop _est_A _est_B _est_C _est_D 


// Figure A1: Replication of Figure 2 including Control Condition 

use study1.dta, replace
quietly reg hc_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s1hc_index_all) 

use study2.dta, replace
quietly reg hc_index c.symrac01##i.three_conditions if race==1
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s2hc_index_all) 

use study3.dta, replace
quietly reg hc_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s3hc_index_all) 

use study4.dta, replace
quietly reg support_social_welfare01 c.symrac01##i.three_conditions 
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s4socwelf_index_all) 

graph combine s1hc_index_all.gph s2hc_index_all.gph s3hc_index_all.gph s4socwelf_index_all.gph


// Figure A2: Replication of Figure 3 including Control Condition

use study1.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s1le_index_all)

use study2.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions if race==1
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s2le_index_all) 

use study3.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s3le_index_all)

use study4.dta, replace
quietly reg leader_index c.symrac01##i.three_conditions
quietly margins, at(symrac01=(0 .25 .5 .75 1) three_conditions=(0 1 2))
quietly marginsplot,  scheme(s1mono) saving(s4le_index_all) 

graph combine s1le_index_all.gph s2le_index_all.gph s3le_index_all.gph s4le_index_all.gph



// Figure A3: Examination of Raw Data (Studies 1 and 4)

use study1.dta, replace

twoway (scatter hc_index symrac01  if three_conditions==0, scheme(s1mono) legend(off)jitter(5))  /// 
		(scatter hc_index symrac01 if three_conditions==1, jitter(5)) /// 
		(scatter hc_index symrac01 if three_conditions==2, jitter(5)) /// 
		(lowess hc_index symrac01  if three_conditions==0, lwidth(thick)) /// 
		(lowess hc_index symrac01  if three_conditions==1, lwidth(thick)) /// 
		(lowess hc_index symrac01  if three_conditions==2, lwidth(thick)) /// 

twoway (scatter leader_index symrac01  if three_conditions==0, scheme(s1mono) legend(off) jitter(5)) /// 
		(scatter leader_index symrac01 if three_conditions==1, jitter(5)) /// 
		(scatter leader_index symrac01 if three_conditions==2, jitter(5)) /// 
		(lowess leader_index symrac01  if three_conditions==0, lwidth(thick)) /// 
		(lowess leader_index symrac01  if three_conditions==1, lwidth(thick)) /// 
		(lowess leader_index symrac01  if three_conditions==2, lwidth(thick)) 

use study4.dta, replace

twoway (scatter support_social_welfare01 symrac01  if three_conditions==0, scheme(s1mono) legend(off) jitter(5)) /// 
		(scatter support_social_welfare01 symrac01 if three_conditions==1, jitter(5)) /// 
		(scatter support_social_welfare01 symrac01 if three_conditions==2, jitter(5)) /// 
		(lowess support_social_welfare01 symrac01  if three_conditions==0, lwidth(thick)) /// 
		(lowess support_social_welfare01 symrac01  if three_conditions==1, lwidth(thick)) /// 
		(lowess support_social_welfare01 symrac01  if three_conditions==2, lwidth(thick)) 

twoway (scatter leader_index symrac01  if three_conditions==0, scheme(s1mono) legend(off) jitter(5)) /// 
		(scatter leader_index symrac01 if three_conditions==1, jitter(5)) /// 
		(scatter leader_index symrac01 if three_conditions==2, jitter(5)) /// 
		(lowess leader_index symrac01  if three_conditions==0, lwidth(thick)) /// 
		(lowess leader_index symrac01  if three_conditions==1, lwidth(thick)) /// 
		(lowess leader_index symrac01  if three_conditions==2, lwidth(thick)) 

* Note: To combine the 4 plots, save them manually and then use "graph combine"


// Table A24: Testing whether b4 = b5 (Study 1; Table 1)
use study1.dta, replace

reg hc_index c.symrac01##i.three_conditions
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01]
reg leader_index c.symrac01##i.three_conditions
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg hc101 c.symrac01##i.three_conditions
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg provs01 c.symrac01##i.three_conditions  
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01]  
reg affects01_in c.symrac01##i.three_conditions  
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg angry01_in c.symrac01##i.three_conditions
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg obamaapp01 c.symrac01##i.three_conditions
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg teaopp201_in c.symrac01##i.three_conditions
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg beckapp01_in c.symrac01##i.three_conditions  
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 
reg palinapp01_in c.symrac01##i.three_conditions 
test _b[1.three_conditions#c.symrac01] = _b[2.three_conditions#c.symrac01] 


// Table A25: Replication with Stereotype Measures (Study 3)

use study3.dta, replace

reg hc_index c.lazy_blk01##i.three_conditions 
est store A 
reg hc_index c.viol_blk01##i.three_conditions 
est store B 
reg leader_index c.lazy_blk01##i.three_conditions 
est store C 
reg leader_index c.viol_blk01##i.three_conditions 
est store D 

esttab A B C D using "TableA25.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A25) replace
drop _est_A _est_B _est_C _est_D

// For Tables A26-A30:
use study1.dta, replace
 

// Table A26: Replication of Table 1 with Ideology (Study 1) 

reg hc101 c.libcon01##i.three_conditions
est store A 
reg provs01 c.libcon01##i.three_conditions  
est store B
reg affects01_in c.libcon01##i.three_conditions  
est store C
reg angry01_in c.libcon01##i.three_conditions
est store D
reg obamaapp01 c.libcon01##i.three_conditions
est store E
reg teaopp201_in c.libcon01##i.three_conditions
est store F
reg beckapp01_in c.libcon01##i.three_conditions  
est store G
reg palinapp01_in c.libcon01##i.three_conditions 
est store H 

esttab A B C D E F G H using "TableA26.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A26) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H

// Table A27: Replication of Table 1 with Egalitarianism (Study 1)

reg hc101 c.egal01##i.three_conditions
est store A 
reg provs01 c.egal01##i.three_conditions  
est store B
reg affects01_in c.egal01##i.three_conditions  
est store C
reg angry01_in c.egal01##i.three_conditions
est store D
reg obamaapp01 c.egal01##i.three_conditions
est store E
reg teaopp201_in c.egal01##i.three_conditions
est store F
reg beckapp01_in c.egal01##i.three_conditions  
est store G
reg palinapp01_in c.egal01##i.three_conditions 
est store H 

esttab A B C D E F G H using "TableA27.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A27) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H

// Table A28: Replication of Table 1 with Control Condition as Baseline (Study 1)

reg hc101 c.symrac01##ib2.three_conditions
est store A 
reg provs01 c.symrac01##ib2.three_conditions  
est store B
reg affects01_in c.symrac01##ib2.three_conditions  
est store C
reg angry01_in c.symrac01##ib2.three_conditions
est store D
reg obamaapp01 c.symrac01##ib2.three_conditions
est store E
reg teaopp201_in c.symrac01##ib2.three_conditions
est store F
reg beckapp01_in c.symrac01##ib2.three_conditions  
est store G
reg palinapp01_in c.symrac01##ib2.three_conditions 
est store H 

esttab A B C D E F G H using "TableA28.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A28) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H


// Table A29: Replication of Table 1 with South Interaction (Study 1)

reg hc101 c.symrac01##i.three_conditions##i.south
est store A 
reg provs01 c.symrac01##i.three_conditions##i.south  
est store B
reg affects01_in c.symrac01##i.three_conditions##i.south  
est store C
reg angry01_in c.symrac01##i.three_conditions##i.south 
est store D
reg obamaapp01 c.symrac01##i.three_conditions##i.south
est store E
reg teaopp201_in c.symrac01##i.three_conditions##i.south 
est store F
reg beckapp01_in c.symrac01##i.three_conditions##i.south  
est store G
reg palinapp01_in c.symrac01##i.three_conditions##i.south 
est store H 

esttab A B C D E F G H using "TableA29.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A29) replace
drop _est_A _est_B _est_C _est_D _est_E _est_F _est_G _est_H

// Table A30: Replication by South / Non-South (Study 1) 

reg hc_index c.symrac01##i.three_conditions if south==1 
est store A
reg leader_index c.symrac01##i.three_conditions if south==1 
est store B
reg hc_index c.symrac01##i.three_conditions if south==0 
est store C
reg leader_index c.symrac01##i.three_conditions if south==0
est store D 

esttab A B C D using "TableA30.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A30) replace
drop _est_A _est_B _est_C _est_D


// Table A31: Replication by South / Non-South (Study 4)

use study4.dta, replace

reg support_social_welfare01 c.symrac01##i.three_conditions if south==1
est store A
reg leader_index c.symrac01##i.three_conditions if south==1 
est store B
reg support_social_welfare01 c.symrac01##i.three_conditions if south==0 
est store C
reg leader_index c.symrac01##i.three_conditions if south==0 
est store D

esttab A B C D using "TableA31.rtf", cells(b(star fmt(2)) se(par fmt(2))) title(Table A31) replace
drop _est_A _est_B _est_C _est_D


*******************************************************************************









