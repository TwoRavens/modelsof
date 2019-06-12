*This file generates: 
*Figures 2, 3, 4.
*Table 1, A9.

log using aggregate.log, replace

use "..\data\data_agg_all.dta", clear

keep if percentile == 100

set matsize 4000

*initiate controls
global economy controlratio_unempl controlratio_ltunemployment controlratio_gdpperc controlratio_RDspend controlratio_materialdep controlratio_instate controlratio_interstate controlratio_socialcont
global demographic controlratio_highschool controlratio_senior controlratio_male controlratio_medianage controlratio_tertiaryedu controlratio_population  controlratio_fertility controlratio_mortality
global amenities controlratio_tourism  controlratio_HDD controlratio_CDD
global G Gratio_A1 Gratio_A2 Gratio_A3 Gratio_A4 Gratio_A9 controlratio_transport


*Table 1
eststo: cgmreg stockratio  i.origin_ccaa i.destination_ccaa i.year $G atr_dif300POST if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg stockratio  i.origin_ccaa i.destination_ccaa i.year $G $demographic $economy $amenities  atr_dif300POST  if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg stockratio  i.origin_ccaa i.destination_ccaa i.year $G $demographic $economy $amenities  income  atr_dif300POST if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg ratio_obs   i.origin_ccaa i.destination_ccaa i.year $G $demographic $economy $amenities atr_dif300POST if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg stockratio  i.origin_ccaa i.destination_ccaa i.year $G mtr_difPOST if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg stockratio  i.origin_ccaa i.destination_ccaa i.year $G $demographic $economy $amenities mtr_difPOST  if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg stockratio  i.origin_ccaa i.destination_ccaa i.year $G $demographic $economy  $amenities income  mtr_difPOST if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
eststo: cgmreg ratio_obs  i.origin_ccaa i.destination_ccaa i.year $G $demographic $economy  $amenities  mtr_difPOST if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
esttab using "Table_1", se(3) keep(atr_dif300POST mtr_difPOST)  order(atr_dif mtr_dif) replace csv star(* 0.10 ** 0.05 *** 0.01) 
eststo clear


/*
*This verifies the ratio elasticity is approximately equal to the stock elasticity, as discussed in the text
preserve
local name dA1_Servicios_Publicos_pc dA2_Actuaciones_de_p dA3_Produccion_de_Bienes_pc dA4_Actuaciones_de_Caracter_pc dA9_Actuaciones_de_Caracter_pc dest_transport dest_highschool dest_senior dest_male dest_medianage dest_tertiaryedu dest_population dest_fertility dest_mortality dest_unempl dest_ltunemployment dest_gdpperc dest_RDspend dest_materialdep dest_instate dest_interstate dest_socialcont dest_tourism dest_HDD dest_CDD 
foreach var of local name {
replace `var' = log(`var')
}


global controls dA1_Servicios_Publicos_pc dA2_Actuaciones_de_p dA3_Produccion_de_Bienes_pc dA4_Actuaciones_de_Caracter_pc dA9_Actuaciones_de_Caracter_pc dest_transport dest_highschool dest_senior dest_male dest_medianage dest_tertiaryedu dest_population dest_fertility dest_mortality dest_unempl dest_ltunemployment dest_gdpperc dest_RDspend dest_materialdep dest_instate dest_interstate dest_socialcont dest_tourism dest_HDD dest_CDD 

keep if origin_ccaa==destination_ccaa
gen logdest_obs = log(destination_obs_inpc)
gen logshare  = log(destination_obs_inpc/destination_obs)
gen logdestination_obs_inpc_churn =log(dest_obs_netofchurn)

ivreg2 logdest_obs i.destination_ccaa i.year  atr_dt300 $controls  if origin_ccaa==destination_ccaa , robust
ivreg2 logshare i.destination_ccaa i.year  atr_dt300 $controls if origin_ccaa==destination_ccaa , robust
ivreg2 logdestination_obs_inpc_churn  i.destination_ccaa i.year $controls  atr_dt300 if origin_ccaa==destination_ccaa , robust
restore
*/

set scheme s2mono


*FIGURE 2 Binscatter
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum 
cap drop IV
reg stockratio i.destination_ccaa i.origin_ccaa i.year $G $demographic $economy $amenities  if id == statepair & destination_ccaa!=origin_ccaa
predict mig_resid if e(sample), r
reg atr_dif300POST  i.destination_ccaa i.origin_ccaa i.year  $G $demographic $economy $amenities  if id == statepair & destination_ccaa!=origin_ccaa
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid , colors(gray black) ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin) xscale(range(-.03 (.01) .03)) xlabel(-.03 (.01) .03) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) reportreg title(ATR regression with controls)
graph export "fig_2Aright.pdf", as(pdf) replace
  
  
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum 
cap drop IV
reg stockratio i.destination_ccaa i.origin_ccaa i.year $G if id == statepair & destination_ccaa!=origin_ccaa
predict mig_resid if e(sample), r
reg atr_dif300POST  i.destination_ccaa i.origin_ccaa i.year  $G  if id == statepair & destination_ccaa!=origin_ccaa
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid , colors(gray black) ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin)    xscale(range(-.03 (.005) .03)) xlabel(-.03 (.01) .03) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) reportreg title(ATR regression without controls)
graph export "fig_2Aleft.pdf", as(pdf) replace
  
  
  
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum 
cap drop IV
reg stockratio i.destination_ccaa i.origin_ccaa i.year $G $demographic $economy $amenities  if id == statepair & destination_ccaa!=origin_ccaa
predict mig_resid if e(sample), r
reg mtr_difPOST i.destination_ccaa i.origin_ccaa i.year  $G $demographic $economy $amenities  if id == statepair & destination_ccaa!=origin_ccaa
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid , colors(gray black) ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin) xscale(range(-.05 (.01) .05)) xlabel(-.05 (.01) .05) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) reportreg title(MTR regression with controls)
graph export "fig_2Bright.pdf", as(pdf) replace
  
    
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum 
cap drop IV
reg stockratio i.destination_ccaa i.origin_ccaa i.year $G  if id == statepair & destination_ccaa!=origin_ccaa
predict mig_resid if e(sample), r
reg mtr_difPOST i.destination_ccaa i.origin_ccaa i.year  $G  if id == statepair & destination_ccaa!=origin_ccaa
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid , colors(gray black) ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin) xscale(range(-.05 (.01) .05)) xlabel(-.05 (.01) .05) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) reportreg title(MTR regression without controls)
graph export "fig_2Bleft.pdf", as(pdf) replace
  
  
  
 

 
 
 
use "..\data\data_agg_all.dta", clear
keep if percentile == 100

*Prepare for event study

global economy controlratio_unempl controlratio_ltunemployment controlratio_gdpperc controlratio_RDspend controlratio_materialdep controlratio_instate controlratio_interstate controlratio_socialcont
global demographic controlratio_highschool controlratio_senior controlratio_male controlratio_medianage controlratio_tertiaryedu controlratio_population  controlratio_fertility controlratio_mortality
global amenities controlratio_tourism  controlratio_HDD controlratio_CDD
global G Gratio_A1 Gratio_A2 Gratio_A3 Gratio_A4 Gratio_A9 controlratio_transport


*CALCULATE A TREATMENT DIFFERENIAL, USE TOP MTR TO SEGMENT REGIONS RAISE VS LOWER
*This calculates it in PP rathr than log differentials
gen mtrdifpp_junk = mtr_dif_pp if year >=2014
by id, sort: egen difpp2014 = mean(mtrdifpp_junk)


*UP MEANS KEEP MORE IN REGION D
*This calculates the average log of the stock ratio in the two regions
*First by MTR
by year, sort: egen stockratiomeanup   = mean(stockratio) if  difpp2014>0&difpp2014!=.&destination_ccaa!=origin_ccaa


*Make figure 4A
set scheme s2mono

*Get to keep more in these places (means taxes went down)
twoway scatter stockratiomeanup year  || lfit stockratiomeanup year if year<2011, lpattern(solid) || lfit stockratiomeanup year if year>2010,  lpattern(solid) xline(2011) graphregion(color(white)) ytitle(log of population ratio for the top 1%) xtitle(year) title(regions decreasing taxes post-reform) legend(off)
graph export "fig_4A.pdf", as(pdf) replace






gen atrdif_junk = atr_dif300POST if year >=2014
by id, sort: egen atrdif2014 = max(atrdif_junk)




*omit year before reform
gen dum6b = 0
gen dum5b = 0
gen dum4b = 0
gen dum3b = 0
gen dum2b = 0
gen dum0 = 0 
gen dum1 = 0
gen dum2 = 0
gen dum3 = 0
replace dum6b = 1*atrdif2014 if year ==2005
replace dum5b = 1*atrdif2014 if year ==2006
replace dum4b = 1*atrdif2014 if year ==2007
replace dum3b = 1*atrdif2014 if year ==2008
replace dum2b = 1*atrdif2014 if year ==2009
replace dum0 = 1*atrdif2014  if year ==2011
replace dum1 = 1*atrdif2014  if year ==2012
replace dum2 = 1*atrdif2014  if year ==2013
replace dum3 = 1*atrdif2014  if year ==2014

*fig 4B
cgmreg stockratio dum* i.destination_ccaa i.origin_ccaa  i.year  $G $demographic $economy $amenities   if origin_ccaa!=destination_ccaa &id == statepair, cluster(statepair origin_year destination_year) 
outreg2 dum* using "eventstudy", dta replace label sidew nopar  noast
preserve
use "eventstudy_dta", clear
rename v1 Texp
rename v2 coef
rename v3 se
gen Texp2=substr(Texp,1,3)
drop if Texp2!="dum"
drop Texp2
gen Texp2=substr(Texp,4,length(Texp))
drop Texp
destring coef, replace
destring se, replace
gen Texp3 = substr(Texp2,1,1)
destring Texp3, replace
replace Texp3 = -Texp3 if length(Texp2)==2
gen ul =(coef+1.645*se)
gen ll = (coef-1.645*se)


local new = _N +1
        set obs `new'
replace Texp3 = -1 if Texp3==.
replace coef = 0 if coef ==.
sort Texp3
drop Texp2
rename Texp3 Texp2
local left -4
local right 3
set scheme s2mono
twoway (connected  coef Texp2 if Texp2>=`left' & Texp2<=-1, msymbol(O) color(black))  (connected coef Texp2 if Texp2>=0 & Texp2<=`right', msymbol(O) color(black)) (line  ul Texp2 if Texp2>=`left' & Texp2<0, lpattern(dash) color(gray) )  (line  ul Texp2 if Texp2>=0 & Texp2<=`right', lpattern(dash) color(gray)) (line  ll Texp2  if Texp2<0 & Texp2>=`left', lpattern(dash) color(gray))  (line  ll Texp2  if Texp2>=0 & Texp2<=`right', lpattern(dash) color(gray)), xline(0) yline(0) title(formal event study coefficients) ytitle(coefficient: log of population ratio for the top 1%) xtitle(years since reform) legend(off) graphregion(color(white))
graph export "fig_4B.pdf", as(pdf) replace
restore

shell erase eventstudy*

gen yearssincetreat = 0 if year ==2011
replace yearssincetreat = 1 if year ==2012
replace yearssincetreat = 2 if year ==2013
replace yearssincetreat = 3 if year ==2014
replace yearssincetreat = -1 if year ==2010
replace yearssincetreat = -2 if year ==2009
replace yearssincetreat = -3 if year ==2008
replace yearssincetreat = -4 if year ==2007
replace yearssincetreat = -5 if year ==2006
replace yearssincetreat = -6 if year ==2005

*This calculates ATR in PP 
gen atr_dif300_pp = (1-dest_atr_state300/100)-(1-origin_atr_state300/100)
gen atrdifpp_junk = atr_dif300_pp if year >=2014
by id, sort: egen atrdifpp2014 = mean(atrdifpp_junk)
gen sign = 1 if atrdifpp2014> 0
replace sign = 0 if atrdifpp2014 == 0
replace sign = -1 if atrdifpp2014<0
gen posttreatbin  = 0 
replace posttreatbin = 1*sign if year >2010

*Table A9
eststo: cgmreg stockratio posttreatbin i.destination_ccaa i.origin_ccaa  i.year $G $demographic $economy $amenities if id== statepair &  origin_ccaa!=destination_ccaa, cluster(statepair origin_year destination_year) 
eststo: cgmreg stockratio posttreatbin i.destination_ccaa i.origin_ccaa i.year i.origin_ccaa#c.yearssincetreat i.destination_ccaa#c.yearssincetreat  $G $demographic $economy $amenities if id== statepair &  origin_ccaa!=destination_ccaa, cluster(statepair origin_year destination_year) 

esttab using "tab_A9", se(3) keep(posttreat posttreatbin)  order(posttreat posttreatbin) replace csv  star(* 0.10 ** 0.05 *** 0.01) 
eststo clear


***************
*Heterogeneity by income and placebo test
***************
use "..\data\data_agg_all.dta", clear

keep if percentile == 100


global economy controlratio_unempl controlratio_ltunemployment controlratio_gdpperc controlratio_RDspend controlratio_materialdep controlratio_instate controlratio_interstate controlratio_socialcont
global demographic controlratio_highschool controlratio_senior controlratio_male controlratio_medianage controlratio_tertiaryedu controlratio_population  controlratio_fertility controlratio_mortality
global amenities controlratio_tourism  controlratio_HDD controlratio_CDD
global G Gratio_A1 Gratio_A2 Gratio_A3 Gratio_A4 Gratio_A9 controlratio_transport





****Figure 3A
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum
cap drop IV 
reg wpop95 i.destination_ccaa i.origin_ccaa i.year $G $demographic $economy $amenities   if id == statepair &destination_ccaa!= origin_ccaa
predict mig_resid if e(sample), r
reg atr_dif300POST i.destination_ccaa i.origin_ccaa i.year  $G $demographic $economy $amenities   if id == statepair & destination_ccaa!=origin_ccaa
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid if id == statepair &destination_ccaa!= origin_ccaa  , colors(gray black)  title(top 5% (excluding top 1%)) ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin) n(25) reportreg noadd xscale(range(-.03 (.01) .03)) xlabel(-.03 (.01) .03) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) 
graph export "fig_3Aleft.pdf", as(pdf) replace


 
*Figure 3A 
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum 
cap drop IV
reg wpop5 i.destination_ccaa i.origin_ccaa i.year $G $demographic $economy $amenities   if id == statepair &destination_ccaa!= origin_ccaa
predict mig_resid if e(sample), r
reg atr_dif300POST  i.destination_ccaa i.origin_ccaa i.year  $G $demographic $economy $amenities   if id == statepair & destination_ccaa!=origin_ccaa
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid if id == statepair &destination_ccaa!= origin_ccaa  , colors(gray black)  title(top 10% (excluding top 5%)) ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin) n(25) reportreg noadd xscale(range(-.03 (.01) .03)) xlabel(-.03 (.01) .03) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) 
graph export "fig_3Aright.pdf", as(pdf) replace


 


use "..\data\data_agg_all.dta", clear

keep if percentile == 100


global economy controlratio_unempl controlratio_ltunemployment controlratio_gdpperc controlratio_RDspend controlratio_materialdep controlratio_instate controlratio_interstate controlratio_socialcont
global demographic controlratio_highschool controlratio_senior controlratio_male controlratio_medianage controlratio_tertiaryedu controlratio_population  controlratio_fertility controlratio_mortality
global amenities controlratio_tourism  controlratio_HDD controlratio_CDD
global G Gratio_A1 Gratio_A2 Gratio_A3 Gratio_A4 Gratio_A9 controlratio_transport




*Push the post tax reform rates back to the prereform era
tab year
replace year = year - 5
keep origin_ccaa destination_ccaa year atr_dif300POST mtr_difPOST  $G 
save "..\data\junk\lagtaxstocl.dta", replace

use "..\data\data_agg_all.dta", clear
keep if percentile ==100
drop atr_dif300POST mtr_difPOST  $G 
merge 1:1 origin_ccaa destination_ccaa year using "..\data\junk\lagtaxstocl.dta"


*Figure 3B
cap drop mig_resid*
cap drop mtr_resid*
cap drop obsnum 
cap drop IV
reg stockratio  i.destination_ccaa i.origin_ccaa i.year $G $demographic $economy $amenities   if id == statepair & origin_ccaa!= destination_ccaa &year<=2009
predict mig_resid if e(sample), r
reg atr_dif300POST i.destination_ccaa i.origin_ccaa i.year $G $demographic $economy $amenities   if id == statepair & destination_ccaa!=origin_ccaa &year<=2009 
predict mtr_resid if e(sample), r
binscatter mig_resid mtr_resid if year<=2009  , colors(gray black)   ytitle(log destination population relative to origin population) xtitle(log net of tax rate in destination minus log net of tax rate in origin) xscale(range(-.03 (.01) .03)) xlabel(-.03 (.01) .03) yscale(range(-.05 (.01) .05)) ylabel(-.05 (.01) .05) reportreg title(pre-reform test) n(25)
 graph export "fig_3B.pdf", as(pdf) replace

 cd "..\data\junk\"
 shell erase *.dta
 
 
  log close
