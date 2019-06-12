capture log close
clear
clear matrix
log using "MillerReplicate.log", replace

************************************************************************* 
************************************************************************* 
******* File to replicate models and calculate QIs from the paper ******* 
** "Economic Development, Violent Leader Removal, and Democratization" ** 
************************* (Miller, AJPS 2010) *************************** 
************************************************************************* 
* Paper authors: Berry, DeMeritt, Esarey                                * 
* Created on: 9 October 2013                                            * 
* Last edited on: 5 May 2015                                            * 
* Last edited by: JEE                                                   * 
************************************************************************* 
************************************************************************* 

*Call data and set seed 
clear 
clear matrix 
set mem 10000m 
set matsize 1000 
*use "/Users/jacqueline_hope/Dropbox/working/BDE II/replication/MillerAJPS10/DemDev_SI.dta", clear 
use DemDev_SI.dta, clear  
set seed 10312001 
set more off 

global yearlim "year >= 1875 & year<=2004" 
global ins_boix "loggdp gdp_grow_mod arch_irrpast5 arch_irrregion5 regiondem_ns newcountry nocolony Britcolony year d_decade9-d_decade21 d_region2-d_region8 boix_prevauth d_cubboix1-d_cubboix7 d_leaderage1-d_leaderage7 d_tenure1-d_tenure7" 
global dem_boix "gdp_grow_mod regiondem_ns newcountry nocolony Britcolony boix_prevauth year d_decade9-d_decade21 d_region2-d_region8 d_cubboix1-d_cubboix7 d_polity2-d_polity21" 
xtset ccode year 
version 10 

*Replicate Table 3, Model 2 [simple model with X, Z, X*Z] where DV=Democratic Transition 
logit fboixregime $dem_boix loggdp gdp_irreg5 irreg5 if boix_regime==0 & $yearlim, robust cluster(ccode) nolog 
sum loggdp irreg5 if e(sample)==1 

univar gdp_grow_mod regiondem_ns newcountry nocolony Britcolony boix_prevauth if e(sample)==1


***** QIs from model with simple (X, Z, X*Z) specification ***** 

***calculate QI (min-max SD) from interaction term X*Z  
quietly estsimp logit fboixregime $dem_boix loggdp gdp_irreg5 irreg5 if boix_regime==0 & $yearlim, robust cluster(ccode) nolog 
setx mean  

*Pr(Conflict | X=max, Z=1) 
setx  loggdp 11.34342 irreg5 1 gdp_irreg5 11.34342*1  
simqi, prval(1) genpr(pr11) 

*Pr(Conflict | X=min, Z=1) 
setx  loggdp  5.139029 irreg5 1 gdp_irreg5  5.139029*1  
simqi, prval(1) genpr(pr01) 

*Pr(Conflict | X=max, Z=0) 
setx  loggdp 11.34342 irreg5 0 gdp_irreg5 11.34342*0  
simqi, prval(1) genpr(pr10) 

*Pr(Conflict | X=min, Z=0) 
setx  loggdp  5.139029 irreg5 0 gdp_irreg5  5.139029*0  
simqi, prval(1) genpr(pr00) 

*First difference in Pr(Democratization) when Z (irregular turnover) =1 and X (econ development) ranges from min to max 
* (effect of increasing development in the presence of irregular turnover) 
gen fdz1=pr11-pr01 

*First difference in Pr(Democratization) when Z (irregular turnover) =0 and X (econ development) ranges from min to max 
* (effect of increasing development in the absence of irregular turnover) 
gen fdz0=pr10-pr00 

*Min-max second difference: Effect of irregular turnover on the effect of increasing econ development on Pr(democratization) 
gen sd=fdz1-fdz0 
sumqi fdz1 fdz0 sd 
* the values here are stored (by hand) in a distinct data set
* called millerfd.dta

****** Figure S-16 *******  
use millerfd.dta, clear
graph twoway scatter prch var1, msymbol(o) mcolor(black) ||      rcap cihi cilo var1, lcolor(black) lwidth(medium) ||      , xlabel(0 "Without Violent Leader Removal" 1 "With Violent Leader Removal", labsize(3)) ylabel(0(.05).35 ,   labsize(2.5)) yline(0, lcolor(gs8)) yscale(noline) xscale(noline noextend)legend(size(small) col(2) order(1 2) label(1 "Effect of Economic Development") label(2 "95% Confidence Interval") label(3 " ")) subtitle(" " "" " ", size(3)) xtitle(, size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) xtitle("") ytitle("First Difference in Pr(Democratize)", size(3)) scheme(s2mono) graphregion(fcolor(white)) aspectratio(1) 

graph export me_democ.pdf, replace 














*Call data and set seed 
clear 
clear matrix 
set mem 10000m 
set matsize 1000 
*use "/Users/jacqueline_hope/Dropbox/working/BDE II/replication/MillerAJPS10/DemDev_SI.dta", clear 
use DemDev_SI.dta, clear  
set seed 10312001 
set more off 

global yearlim "year >= 1875 & year<=2004" 
global ins_boix "loggdp gdp_grow_mod arch_irrpast5 arch_irrregion5 regiondem_ns newcountry nocolony Britcolony year d_decade9-d_decade21 d_region2-d_region8 boix_prevauth d_cubboix1-d_cubboix7 d_leaderage1-d_leaderage7 d_tenure1-d_tenure7" 
global dem_boix "gdp_grow_mod regiondem_ns newcountry nocolony Britcolony boix_prevauth year d_decade9-d_decade21 d_region2-d_region8 d_cubboix1-d_cubboix7 d_polity2-d_polity21" 
xtset ccode year 
version 10 

*Replicate Table 3, Model 2 [simple model with X, Z, X*Z] where DV=Democratic Transition 
logit fboixregime $dem_boix loggdp gdp_irreg5 irreg5 if boix_regime==0 & $yearlim, nolog 
sum loggdp irreg5 if e(sample)==1 

univar gdp_grow_mod regiondem_ns newcountry nocolony Britcolony boix_prevauth if e(sample)==1


***** QIs from model with simple (X, Z, X*Z) specification ***** 

***calculate QI (min-max SD) from interaction term X*Z  
quietly estsimp logit fboixregime $dem_boix loggdp gdp_irreg5 irreg5 if boix_regime==0 & $yearlim, nolog 
setx mean  

*Pr(Conflict | X=max, Z=1) 
setx  loggdp 11.34342 irreg5 1 gdp_irreg5 11.34342*1  
simqi, prval(1) genpr(pr11) 

*Pr(Conflict | X=min, Z=1) 
setx  loggdp  5.139029 irreg5 1 gdp_irreg5  5.139029*1  
simqi, prval(1) genpr(pr01) 

*Pr(Conflict | X=max, Z=0) 
setx  loggdp 11.34342 irreg5 0 gdp_irreg5 11.34342*0  
simqi, prval(1) genpr(pr10) 

*Pr(Conflict | X=min, Z=0) 
setx  loggdp  5.139029 irreg5 0 gdp_irreg5  5.139029*0  
simqi, prval(1) genpr(pr00) 

*First difference in Pr(Democratization) when Z (irregular turnover) =1 and X (econ development) ranges from min to max 
* (effect of increasing development in the presence of irregular turnover) 
gen fdz1=pr11-pr01 

*First difference in Pr(Democratization) when Z (irregular turnover) =0 and X (econ development) ranges from min to max 
* (effect of increasing development in the absence of irregular turnover) 
gen fdz0=pr10-pr00 

*Min-max second difference: Effect of irregular turnover on the effect of increasing econ development on Pr(democratization) 
gen sd=fdz1-fdz0 
sumqi fdz1 fdz0 sd 

log close 

