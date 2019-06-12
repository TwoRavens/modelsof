clear
clear matrix
capture log close
set mem 400m
set matsize 400
set more off 

cd "G:\my files (research)\PROJECTS\BASIC NEEDS (FOOD)\data\"

* ******************************************************************** *                                                                 *
*   Purpose:  runs models for ISQ paper final version (April2010)
*   Takes in:      
* ******************************************************************** *

use "food_ISQ_final.dta", clear

********************* Table 1 
areg callead pfdigdp sfdigdp tfdigdp yrdum*, robust cluster(cow) absorb(cow) 
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp yrdum*, robust cluster(cow) absorb(cow) 
areg F.proteinpercap pfdigdp sfdigdp tfdigdp yrdum*, robust cluster(cow) absorb(cow) 
areg F.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp yrdum*, robust cluster(cow) absorb(cow) 


******************** Table 2 : Panel A
* age dependency
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp agedep yrdum*, robust cluster(cow) absorb(cow) 
* inflation
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp inflgdpdefl yrdum*, robust cluster(cow) absorb(cow) 
* total aid per GDP
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp aidpergdp yrdum*, robust cluster(cow) absorb(cow) 
* food aid per GDP
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp faidpergdp yrdum*, robust cluster(cow) absorb(cow) 
* civil conflict
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp civconf yrdum*, robust cluster(cow) absorb(cow) 
* economic crisis
areg callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp govspendgdp gdpcontract yrdum*, robust cluster(cow) absorb(cow) 

******************** Table 2 : Panel B
* age dependency
areg f.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp agedep yrdum*, robust cluster(cow) absorb(cow) 
* inflation
areg f.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp inflgdpdefl yrdum*, robust cluster(cow) absorb(cow) 
* total aid per GDP
areg f.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp aidpergdp yrdum*, robust cluster(cow) absorb(cow) 
* food aid per GDP
areg f.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp faidpergdp yrdum*, robust cluster(cow) absorb(cow) 
* civil conflict
areg f.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp civconf yrdum*, robust cluster(cow) absorb(cow) 
* economic crisis
areg f.proteinpercap pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp govspendgdp gdpcontract yrdum*, robust cluster(cow) absorb(cow) 

******************** Table 2 : Panel C
********* first differences
g protlead = f.proteinpercap
reg d.callead d.pfdigdp d.sfdigdp d.tfdigdp d.polity2 d.instablog d.lnconscgdp d.gdp_grow d.govspendgdp d.prime d.manexp  yrdum*,  robust 
reg d.protlead d.pfdigdp d.sfdigdp d.tfdigdp d.polity2 d.instablog d.lnconscgdp d.gdp_grow d.govspendgdp d.prime d.manexp  yrdum*, robust 

********* 3SLS
reg3 (callead pfdigdp sfdigdp tfdigdp polity2 instablog lnconscgdp gdp_grow govspendgdp yrdum* prime manexp) (f.pfdigdp calpercap polity2 lnconscgdp agva oil govspendgdp yrdum* instablog) (f.sfdigdp calpercap polity2 lnconscgdp manva govspendgdp yrdum* instablog) (f.tfdigdp calpercap polity2 lnconscgdp  serva govspendgdp yrdum* instablog)
reg3 (f.proteinpercap pfdigdp sfdigdp tfdigdp polity2 instablog lnconscgdp gdp_grow govspendgdp yrdum* prime manexp) (f.pfdigdp proteinpercap polity2 lnconscgdp agva oil govspendgdp yrdum* instablog) (f.sfdigdp proteinpercap polity2 lnconscgdp manva govspendgdp yrdum* instablog) (f.tfdigdp proteinpercap polity2 lnconscgdp serva govspendgdp yrdum* instablog)

********* 5-year averages
use "food_ISQ_final_5yravg.dta", clear 
regress callead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp, robust 
regress protlead pfdigdp sfdigdp tfdigdp prime manexp polity2 instablog lnconscgdp gdp_grow govspendgdp, robust 

******************** Table 2 : Panel D
use "food_ISQ_final_undernour.dta", clear
/*UN1*/ regress leadpercunderno pfdigdp sfdigdp tfdigdp lnconscgdp perip, robust 
/*UN2*/ regress leadchilduw2sd pfdigdp sfdigdp tfdigdp lnconscgdp, robust 
/*UN3*/ regress leadchildstunt2sd pfdigdp sfdigdp tfdigdp lnconscgdp, robust
/*UN4*/ regress leadchildwast2sd pfdigdp sfdigdp tfdigdp lnconscgdp, robust


