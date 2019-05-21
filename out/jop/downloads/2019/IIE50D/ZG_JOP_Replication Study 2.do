
********************************************************************************
** Replication data for														  **
** "Local Government Efficiency and Anti-Immigrant Violence"  				  **
** Authors: Conrad Ziller and Sara Wallace Goodman							  **
** forthcoming in The Journal of Politics									  **
** Date: January, 21, 2019													  **
**																			  **
** STUDY 2: LGE AND ANTI-IMMIGRANT VIOLENCE IN THE NETHERLANDS (2012-2015)    **
********************************************************************************


********************************************************************************
***CODEBOOK (+original variable names from shapefile / transformaitons)*********
********************************************************************************
//naam - name of municipality
//idx - municipality ID
//nuts2 - region ID
//time - time
//year - year
//vio - number of anti-immigrant violent crime
//lag_vio - lagged violence variable (generate lag_vio=l.vio)
//lge - LGE local government efficiency
//pop - number of residents (AANT_INW)
//popdens - population density (BEV_DICHTH)
//avinc - average income per municipality
//unemp - unemployment rate (WW_UIT_TOT/AANT_INW)
//nwimmi - proportion of non-Western immigrants (P_N_W_AL)
//crime - crime rate
//assoc - associations per capita
//left - electoral support left-wing parties (Socialistische Partij, 
//Partij van de Arbeid, and GroenLinks)
//right - electoral support radical right party (Partij voor de Vrijheid)


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

use ZG_JOP_study2.dta, clear

xtset idx time
sort idx time
set matsize 800

global predictors lge pop popdens avinc unemp nwimmi crime assoc 

   
********************************************************************************
***MAIN MODELS 6-10*************************************************************
********************************************************************************


***Models 6-8

//linear transformation 0-1
xtnbreg vio $predictors  i(4).time , fe
foreach var of varlist $predictors   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

nbreg vio  ib(3).time i.idx std2lge std2pop std2popdens    , cluster(nuts2)
 margins, dydx(*) post
 eststo M6
nbreg vio  ib(4).time i.idx std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi   , cluster(nuts2)
 margins, dydx(*) post
 eststo M7
nbreg vio  ib(2).time i.idx std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc  , cluster(nuts2)
 margins, dydx(*) post 
 eststo M8
 
 
***Model 9

//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors   right left   i(4).time , fe
foreach var of varlist $predictors  right left {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

nbreg vio  ib(4).time i.idx std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc  std2right std2left, cluster(nuts2) diff
 margins, dydx(*) post 
 eststo M9



***Model 10

//group means
xtnbreg vio $predictors lag_vio i(4).time   , fe
foreach var of varlist $predictors lag_vio {
egen m_`var'=mean(`var') if e(sample), by(idx)
}

//initial values
xtnbreg vio $predictors  i(4).time   , fe
foreach var of varlist vio $predictors {
sort idx time
bys idx: gen ini_`var'=`var'[1] if e(sample)
}

//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors lag_vio  i(4).time   , fe
foreach var of varlist $predictors lag_vio  {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}


xtnbreg vio  ib(4).time std2lge std2pop std2popdens std2avinc std2unemp ///
std2nwimmi std2crime std2assoc   std2lag_vio       ///
m_lge m_pop m_popdens m_avinc m_unemp m_crime m_assoc ///
ini_lge ini_pop ini_popdens ini_avinc ini_unemp ini_crime ini_assoc ini_vio , re 
 margins, dydx(*) post  predict(nu0)
 eststo M10




********************************************************************************
***ROBUSTNESS CHECKS************************************************************
********************************************************************************

***//Controls only (Table B2, Models B1-B5)


//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors  i(4).time , fe
foreach var of varlist $predictors   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

nbreg vio  ib(4).time i.idx  std2pop std2popdens    , cluster(nuts2)
 margins, dydx(*) post
 eststo MB1
nbreg vio  ib(4).time i.idx  std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi   , cluster(nuts2)
 margins, dydx(*) post
 eststo MB2
nbreg vio  ib(4).time i.idx  std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc  , cluster(nuts2)
 margins, dydx(*) post 
 eststo MB3
 
//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors   right left , fe
foreach var of varlist $predictors  right left {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

nbreg vio  ib(4).time i.idx  std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc  std2right std2left, cluster(nuts2) diff
 margins, dydx(*) post 
 eststo MB4

//group means
drop m_*
xtnbreg vio $predictors lag_vio i(4).time   , fe
foreach var of varlist $predictors lag_vio {
egen m_`var'=mean(`var') if e(sample), by(idx)
}

//initial value
drop ini_*
xtnbreg vio $predictors  i(4).time   , fe
foreach var of varlist vio $predictors {
sort idx time
bys idx: gen ini_`var'=`var'[1] if e(sample)
}

//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors   i(4).time   , fe
foreach var of varlist $predictors lag_vio  {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}


xtnbreg vio  ib(4).time  std2pop std2popdens std2avinc std2unemp ///
std2nwimmi std2crime std2assoc   std2lag_vio       ///
m_lge m_pop m_popdens m_avinc m_unemp m_crime m_assoc ///
ini_lge ini_pop ini_popdens ini_avinc ini_unemp ini_crime ini_assoc ini_vio , re 
 margins, dydx(*) post  predict(nu0)
 eststo MB5
 
 
 
***//Total spending (Table B3, Model B6)

gen total_2pc=total_2/AANT_INW
//linear transformation 0-1
xtnbreg vio $predictors  i.time  total_2pc , fe
drop sx* std2*
foreach var of varlist $predictors total_2pc {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

nbreg vio  ib(4).time i.idx std2total_2pc std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc 
 margins, dydx(*) post 
 eststo MB6
 
 
  
**//Zero inflated neg binominal models

//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors  i(4).time   , fe
foreach var of varlist $predictors   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

zinb vio  ib(4).time i.idx  std2lge std2pop std2popdens    , cluster(nuts2) inflate(nwimmi)
 margins, dydx(*) post
 eststo MB7
zinb vio  ib(4).time i.idx std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi   , cluster(nuts2) inflate(nwimmi)
 margins, dydx(*) post
 eststo MB8
zinb vio  ib(4).time i.idx std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc  , cluster(nuts2) inflate(nwimmi) diff
 margins, dydx(*) post 
 eststo MB9
 
//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors     i(4).time right left , fe
foreach var of varlist $predictors  right left {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

zinb vio  ib(4).time i.idx std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc  std2right std2left, cluster(nuts2) inflate(nwimmi)
 margins, dydx(*) post 
 eststo MB10


 
  
 
**//Controlling municipality intercepts and slopes

//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors  i(4).time   , fe
foreach var of varlist $predictors   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

nbreg vio  ib(16).idx ib(16).idx#c.time time  std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc   , cluster(nuts2) iterate(25) diff
margins, dydx(std2lge std2pop std2popdens   std2avinc std2unemp ///
std2nwimmi std2crime std2assoc) post  
 eststo MB11 
  

 
**//Generalized Method of Moments (GMM) 

//linear transformation 0-1
drop sx* std2*
xtnbreg vio $predictors  i(4).time   , fe
foreach var of varlist $predictors   {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

gmm (vio - exp({xb: L.vio ib(4).time std2lge std2pop std2popdens std2avinc std2unemp ///
std2nwimmi std2crime std2assoc}+{b0})), instruments(L.vio ib(4).time std2lge std2pop std2popdens std2avinc std2unemp ///
std2nwimmi std2crime std2assoc) onestep vce(cluster idx)     
 eststo MB12

  
  
********************************************************************************
***CREATING TABLES**************************************************************
********************************************************************************  


**//Generating variables for labeling procedure
drop sx* std2*
xtnbreg vio $predictors   i(4).time   , fe
foreach var of varlist $predictors lag_vio left right {
sum `var'   if e(sample)
gen sx`var'=(`var'-r(min))  if e(sample) 
sum sx`var'  if e(sample)
gen std2`var'=sx`var'/r(max) if e(sample)
}

 

**//Labeling procedure
           
label variable std2pop "Number of residents"
label variable vio "No. anti-immigrant violent acts"
label variable lag_vio "Violent acts t-1"
label variable std2lge "LGE"
label variable std2nwimmi "Prop. non-Western immigrants"
label variable std2popdens "Population density"
label variable std2unemp "Unemployment rate"
label variable std2crime "Crime rate"
label variable std2avinc "Av. income"
label variable std2assoc  "Associations per capita"
label variable std2right "Radical right party support"
label variable std2left "Left-wing party support"
 
**//Creating tables 
esttab  M6 M7 M8 M9 M10 using table_2.rtf, b(3)  star(* 0.05 ** 0.01)  drop(*.idx m_* ini_*  *.time)  se replace label   wide stats(N) 
esttab  MB1 MB2 MB3 MB4 MB5 using table_B2.rtf, b(3)  star(* 0.05 ** 0.01)  drop(*.idx m_* ini_*  *.time)  se replace label   wide stats(N)
esttab  MB6 using table_B3.rtf, b(3)  star(* 0.05 ** 0.01)  drop(*.idx *.time)  se replace label   wide stats(N) 
esttab  MB7 MB8 MB9 MB10 using table_B4.rtf, b(3)  star(* 0.05 ** 0.01)  drop(*.idx *.time nwimmi)  se replace label   wide stats(N) 
esttab   MB11    using table_B5.rtf, b(3)  star(* 0.05 ** 0.01)     se replace label   wide stat(N) 
esttab   MB12    using table_B6.rtf, b(3)  star(* 0.05 ** 0.01)     se replace label   wide stat(N) 	
	
**//Descriptives

sum vio  std2lge std2pop std2popdens   std2avinc std2unemp std2nwimmi std2crime std2assoc  std2right std2left std2lag_vio ///
lge pop popdens   avinc unemp nwimmi crime assoc   right  left  lag_vio


 
/*
********************************************************************************
***DATA ENVELOPMENT ANALYSIS****************************************************
********************************************************************************


**codebook

//total_2 - Total spending per municipality and year
//AF_TREINST - Av. distance next train station
//AO_UIT_TOT - People receiving unemployment benefits
//WWB_UITTOT - People receiving welfare payments
//AF_ONDBAS - Av. distance primary school
//AF_ONDVRT - Av. distance secondary school
//AF_ARTSPR - Av. distance physicians
//OPP_LAND - Populated area
//AANTAL_HH - Number of households
//P_65_EO_JR - Share of people older than 65

 
gen welfare = AO_UIT_TOT+WWB_UITTOT
gen P_65_EO_JR_r=P_65_EO_JR/100*AANT_INW
gen P_00_14_JR_r=P_00_14_JR/100*AANT_INW

preserve		
	keep  naam year AF_TREINST AF_KDV AF_ONDBAS AF_ONDVRT AF_ARTSPR  total_2 total_1 P_00_14_JR P_65_EO_JR OPP_LAND WWB_UITTOT AANTAL_HH P_65_EO_JR_r P_00_14_JR_r AO_UIT_TOT welfare OPP_WATER
	reshape wide   AF_TREINST AF_KDV AF_ONDBAS AF_ONDVRT AF_ARTSPR  total_2  total_1  P_00_14_JR P_65_EO_JR OPP_LAND WWB_UITTOT AANTAL_HH P_65_EO_JR_r P_00_14_JR_r AO_UIT_TOT welfare OPP_WATER, i(naam) j(year)
	
	foreach var of varlist AF_TREINST* AF_KDV* AF_ONDBAS* AF_ONDVRT* AF_ARTSPR* {
	egen std`var'= std(`var')
	gen i`var'= std`var'*-1
	sum i`var'    
	gen r_`var'=i`var'+abs(r(min))+0.1  
	}


	teradialbc  total_212 =     r_AF_TREINST12  r_AF_ONDBAS12 r_AF_ONDVRT12 r_AF_ARTSPR12         OPP_LAND12  welfare12   AANTAL_HH12  P_65_EO_JR_r12  , base(input) tename(effi12x) rts(vrs) smoothed   reps(2000) bias(bias12)
	gen lge12=effi12x-bias12
	teradialbc  total_213 =     r_AF_TREINST13  r_AF_ONDBAS13 r_AF_ONDVRT13 r_AF_ARTSPR13          OPP_LAND13  welfare13   AANTAL_HH13  P_65_EO_JR_r13  , base(input) tename(effi13x) rts(vrs)  smoothed  reps(2000) bias(bias13)
	gen lge13=effi13x-bias13 
	teradialbc  total_214 =     r_AF_TREINST14  r_AF_ONDBAS14 r_AF_ONDVRT14 r_AF_ARTSPR14          OPP_LAND14  welfare14   AANTAL_HH14  P_65_EO_JR_r14  , base(input) tename(effi14x) rts(vrs)  smoothed   reps(2000) bias(bias14)
	gen lge14=effi14x-bias14
	teradialbc  total_215 =     r_AF_TREINST15  r_AF_ONDBAS15 r_AF_ONDVRT15 r_AF_ARTSPR15          OPP_LAND15  welfare15   AANTAL_HH15   P_65_EO_JR_r15 , base(input) tename(effi15x) rts(vrs)  smoothed reps(2000) bias(bias15)
	gen lge15=effi15x-bias15
	

	keep lge* naam 
	reshape long lge, i(naam) j(year)
	save lge_nl.dta, replace
restore

drop lge
merge 1:1 naam year using lge_nl.dta
drop _merge
 
*/ 

 