
********************************************************************************
** Replication data for														  **
** "Local Government Efficiency and Anti-Immigrant Violence"  				  **
** Authors: Conrad Ziller and Sara Wallace Goodman							  **
** forthcoming in The Journal of Politics									  **
** Date: January, 21, 2019													  **
**																			  **
** STUDY 1: LGE AND ANTI-REFUGEE VIOLENCE IN GERMANY (2015)                   **
********************************************************************************


********************************************************************************
***CODEBOOK 														   *********
********************************************************************************
//kname - name of district/city
//kkziff - district ID
//region - region ID
//land - Bundesland
//time - time
//year - year
//vio - number of anti-refugee attacks in 2015
//lag_vio - lagged violence variable (generate lag_vio=l.vio)
//lge - LGE local government efficiency
//pop - number of residents 
//popdens - population density 
//unemp - unemployment rate 
//nonnat - proportion of non-nationals
//crime - crime rate
//assoc - membership in associations (aggregated)
//volunt - volunteering (aggregated)
//trust - social trust(aggregated)
//gpdpc - GDP/capita
//vio2014 - anti-refugee attacks in 2014
//right - electoral support radical right parties (Alternative für Deutschland, 
//Die Rechte, NPD, pro Deutschland, pro NRW, and Die Republikaner)
//left - electoral support left-wing parties  (SPD, Linke)


//For variables used to build the efficiency scores, see below


**Required ados (if net install is interrupted, try again or "findit teradialbc")

ssc install estout, replace
net install "http://www.stata-journal.com/software/sj16-3/st0444.pkg", replace
ssc install kdens.pkg, replace
ssc install moremata, replace

********************************************************************************
***ANALYSIS*********************************************************************
********************************************************************************

***Loading data

use ZG_JOP_study1.dta, clear

set matsize 800


global predictors lge pop popdens gdppc unemp refugees nonnat crime assoc left right



********************************************************************************
***FIGURE 2*********************************************************************
********************************************************************************

preserve
pwcorr vio lge
reg vio lge , beta
tw sc vio lge    || fpfit vio lge || lfit  vio lge ///
, ytitle(Anti-refugee attacks) xtitle(Local government efficiency)  
restore


********************************************************************************
***MAIN MODELS 1-5**************************************************************
********************************************************************************


***//Models 1-5

//linear transformation 0-1
nbreg   vio  $predictors  vio2014 i.land2 
foreach var of varlist  $predictors vio2014 {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

nbreg  vio std2lge std2pop std2popdens i.land2, cluster(region)
 margins, dydx(*)    post
 eststo M1
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo M2
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo M3
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo M4
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left std2vio2014 i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo M5

 

********************************************************************************
***ROBUSTNESS CHECKS************************************************************
********************************************************************************

***//Controls only (Table A3, Models A1-A5)
 
//linear transformation 0-1
drop sx* std2*
nbreg   vio  $predictors  vio2014 i.land2 
foreach var of varlist  $predictors vio2014 {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

nbreg  vio std2pop std2popdens i.land2, cluster(region)
 margins, dydx(*)    post
 eststo MA1
nbreg  vio std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA2
nbreg  vio std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA3
nbreg  vio std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA4
nbreg  vio std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left std2vio2014 i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA5 


***//Models using Expenditures in LGE Score Computation (Table A4, M6-M10)

//linear transformation 0-1
drop sx* std2*
nbreg   vio  lge_exp pop popdens gdppc unemp refugees nonnat crime assoc left right  vio2014 i.land2 
foreach var of varlist  $predictors lge_exp vio2014 {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

nbreg  vio std2lge_exp std2pop std2popdens i.land2, cluster(region)
 margins, dydx(*)    post
 eststo MA6
nbreg  vio std2lge_exp std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA7
nbreg  vio std2lge_exp std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA8
nbreg  vio std2lge_exp std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA9
nbreg  vio std2lge_exp std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left std2vio2014 i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA10

 
***//Without two outliers (Table A5, Models A11-A15)

//linear transformation 0-1
drop sx* std2*
nbreg   vio  $predictors  vio2014 i.land2 if kkziff!=14612 & kkziff!=14628
foreach var of varlist  $predictors vio2014 {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

nbreg  vio std2lge std2pop std2popdens i.land2, cluster(region)
 margins, dydx(*)    post
 eststo MA11
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA12
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA13
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA14
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left std2vio2014 i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA15

 
 
***//Expenditures as predictor (Table A6, Models A16-A20)

gen exppc=ausg_br2014_2/pop


//linear transformation 0-1
drop sx* std2*
nbreg  vio  exppc pop popdens gdppc unemp refugees nonnat crime assoc left right  vio2014 i.land2
foreach var of varlist  vio  exppc pop popdens gdppc unemp refugees nonnat crime assoc left right  vio2014   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

nbreg  vio std2exppc std2pop std2popdens i.land2, cluster(region)
 margins, dydx(*)    post
 eststo MA16
nbreg  vio std2exppc std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA17
nbreg  vio std2exppc std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA18
nbreg  vio std2exppc std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA19
nbreg  vio std2exppc std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left std2vio2014 i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA20



***//Refugees as Outcome (Table A7)

//linear transformation 0-1
drop sx* std2*
nbreg   vio  $predictors  vio2014 i.land2 
foreach var of varlist  $predictors vio2014 {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

reg  std2refugees std2lge std2pop std2popdens std2gdppc std2unemp  ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) 
 eststo MA21


***//Additional social capital indicators (Table A8) 
 
//linear transformation 0-1
drop sx* std2*
nbreg   vio  $predictors  vio2014 i.land2 trust volunt
foreach var of varlist  $predictors vio2014 trust volunt {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2trust std2volunt i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA22
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2trust std2volunt std2right std2left i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA23
nbreg  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2trust std2volunt std2right std2left std2vio2014 i.land2, cluster(region) 
 margins, dydx(*)    post
 eststo MA24

 
***//Zero inflated models (Table A9)

//linear transformation 0-1
drop sx* std2*
nbreg   vio  $predictors  vio2014 i.land2 
foreach var of varlist  $predictors vio2014 {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
* 	

zinb  vio std2lge std2pop std2popdens i.land2, cluster(region) inflate(refugees)
 margins, dydx(*)    post
 eststo MA25
zinb  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat i.land2, cluster(region) inflate(refugees)
 margins, dydx(*)    post
 eststo MA26
zinb  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc i.land2, cluster(region) inflate(refugees)
 margins, dydx(*)    post
 eststo MA27
zinb  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left i.land2, cluster(region) inflate(refugees)
 margins, dydx(*)    post
 eststo MA28
zinb  vio std2lge std2pop std2popdens std2gdppc std2unemp std2refugees ///
std2nonnat std2crime std2assoc std2right std2left std2vio2014 i.land2, cluster(region) inflate(refugees)
 margins, dydx(*)    post
 eststo MA29

 


********************************************************************************
***CREATING TABLES**************************************************************
********************************************************************************  


**//Generating variables for labeling procedure
drop sx* std2*
nbreg   vio  $predictors  vio2014 i.land2 volunt trust lge_exp exppc
foreach var of varlist  $predictors vio2014 volunt trust lge_exp exppc {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}



label variable std2vio2014 "Number of attacks 2014 (lagged DV)"
label variable std2assoc "Members in nonprofit associations"
label variable std2volunt "Regional volunteering"
label variable std2trust "Regional social trust"
label variable std2pop "Number of residents"
label variable vio "No. attacks refugees"
label variable std2lge "LGE"
label variable std2refugees "Refugees in 2015"
label variable std2nonnat "Proportion of non-nationals"
label variable std2popdens "Population density"
label variable std2unemp "Unemployment rate"
label variable std2right "Radical right support"
label variable std2gdppc "GDP per capita"
label variable std2left "Social democrats/Left party support"
label variable std2crime "Crime rate"
label variable std2lge_exp "LGE based on expenditures"
label variable std2exppc "Expenditures/capita"


 esttab  M1 M2 M3 M4 M5 using Tab1.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 
 esttab  MA1 MA2 MA3 MA4 MA5 using TabA3.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 
 esttab  MA6  MA7 MA8 MA9 MA10 using TabA4.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 
 esttab  MA11  MA12 MA13 MA14 MA15 using TabA5.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 
 esttab  MA16 MA17 MA18 MA19 MA20 using TabA6.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 
  
 esttab   MA21  using TabA7.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 
 esttab  MA22   MA23 MA24  using TabA8.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N)
 esttab  MA25 MA26  MA27 MA28 MA29 using TabA9.rtf, b(3)  star(* 0.05 ** 0.01)    se replace label drop(*.land2) wide stat(N) 

 
 
//Table A1
drop sx* std2*
nbreg vio vio2014 right left volunt trust lge pop popdens gdppc unemp nonnat crime assoc   refugees
foreach var of varlist  $predictors vio2014 volunt trust   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
 
sum vio vio2014 right left volunt trust lge pop popdens gdppc unemp nonnat crime assoc  refugees ///
vio std2vio2014 std2right std2left std2volunt std2trust std2lge std2pop std2popdens std2gdppc ///
std2unemp std2nonnat std2crime std2assoc std2refugees if e(sample)


//Table A2
drop sx* std2*
nbreg vio vio2014 right left volunt trust lge_exp pop popdens gdppc unemp nonnat crime assoc   refugees
foreach var of varlist  $predictors vio2014 lge_exp volunt trust   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}
 
sum vio vio2014 right left volunt trust lge_exp pop popdens gdppc unemp nonnat crime assoc  refugees ///
vio std2vio2014 std2right std2left std2volunt std2trust std2lge_exp std2pop std2popdens std2gdppc ///
std2unemp std2nonnat std2crime std2assoc std2refugees if e(sample)

  
  
/*
********************************************************************************
***DATA ENVELOPMENT ANALYSIS****************************************************
********************************************************************************


**codebook

//ausg_br2014_2 - Expenditures in 2014
//tax_13r - Tax returns per district in 2013
//dis_ov - Av. distance public transport
//sgb2q_2014_r - People receiving welfare payments (SGBII)
//dis_gs - Av. distance primary school
//dis_ss - Av. distance secondary school
//dis_ha2 - Av. distance physicians
//siedl2014_r - Populated area
//geshaushalt - Number of households
//age65_13r - Share of people older than 65
 
foreach var of varlist   dis_ov dis_gs dis_ss  dis_ha2 {
egen std`var'= std(`var')
gen i`var'= std`var'*-1
 sum i`var'    
gen r_`var'=i`var'+abs(r(min))+0.1  
}
* 	
  
    drop lge lge_exp

    teradialbc  tax_13r =   r_dis_ov  r_dis_gs r_dis_ss r_dis_ha2 geshaushalt siedl2014_r    sgb2q_2014_r  age65_13r , base(input) tename(effix1) rts(vrs)   reps(2000) bias(beffix1) 
	gen lge=effix1-beffix1

    teradialbc  ausg_br2014_2 =   r_dis_ov  r_dis_gs r_dis_ss r_dis_ha2 geshaushalt  siedl2014_r   sgb2q_2014_r  age65_13r , base(input) tename(effix2) rts(vrs)   reps(2000) bias(beffix2) 
	gen lge_exp=effix2-beffix2

 
*/ 	 
 
 
 