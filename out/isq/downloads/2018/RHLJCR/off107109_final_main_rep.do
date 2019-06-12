/*	
  Final results for "Exposure to Offshoring and the Politics of Trade 
  Liberalization: Debate and Votes on Free Trade Agreements in the U.S. House of
  Representatives, 2001-2006",  International studies quarterly 
  
 Results in main text
  
  Erica Owen (ericaowen@tamu.edu)    
  Last modified: 10-25-2016   */

* 

* Note: This .do file assumes that you have changed the working directory 


//0. Program setup
clear all
set more off
capture cd "your/directory/here"   
use "eowen_isq_rep.dta", clear

//1. Figure 1 
// Distribution of offshorability
hist pctoffshore, xtitle("Percent offshorable") name(fig1, replace)  


// 2. Main results
// Table 2

// Model 1

local iv pctoffshore
local iv2  pctcollege lnempexpsh lnempimpsh
loca controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust  
est sto m1
estat ic
estat class


// Model 2 (control previous contributions)

logit vote `iv' `iv2' `controls' prev_corp lnprev_labcont if ftavote==1, robust
est sto m2
estat ic
estat class

// Model 3 (No TPA vote)


logit vote `iv' `iv2' `controls' if session~=107 & ftavote==1, robust	
est sto m3
estat ic
estat class

// Model 4 
// All trade votes

logit vote `iv' `iv2' `controls' if nontrade==0, robust	
est sto m4
estat ic
estat class


// #5
// OLS percent free trade

reg pctft `iv' pctcollege lnempexpsh lnempimpsh rep unemp Wdummy MWdummy southdummy i.session, robust
est sto m5
estat ic



// 4. Table 3  
// Analysis by offshorable and low/high skill


local iv pctoff_lowed pctoff_highed
local iv2 pctcollege   lnempexpsh lnempimpsh
loca controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust  
est sto m1
estat ic
estat class


//5. Analysis of labor word mentions
// Tables 4 & 5 

local ivs pctoffshore pctcollege rep lnempexpsh lnempimpsh unemp
local region  MWdummy Wdummy southdummy i.voteid
local controls rep  committee_leader party_leader adaext ib2.sex2 black hispanic  i.session

heckman log_labspeech `ivs' `region' if eligible~=., select(`controls')  robust
est sto m1


reg log_labspeech `ivs' `region' if eligible~=. & e(sample), robust
est sto m2



 
// 6. Explantory power
// Figure 2


local controls rep unemp  Wdummy MWdummy southdummy i.voteid 

capture gen bic=.


// Factor only
logit vote pctcollege `controls' if ftavote==1, robust
estat ic
matrix r=r(S)
replace bic=r[1,6] in 1

// Factor+industry
quietly logit vote pctcollege lnempexpsh lnempimpsh `controls' if ftavote==1, robust
 estat ic
matrix r=r(S)
replace bic=r[1,6] in 2


// Factor+offshorability
quietly logit vote pctcollege pctoffshore  `controls' if ftavote==1, robust
 estat ic
matrix r=r(S)
replace bic=r[1,6] in 3


// Factor+offshorability+industry
quietly logit vote pctcollege pctoffshore lnempexpsh lnempimpsh `controls' if ftavote==1, robust
 estat ic
matrix r=r(S)
replace bic=r[1,6] in 4


capture gen mnum=1 in 1
replace mnum = 2 in 2
replace mnum = 3 in 3
replace mnum = 4 in 4

label define model 1 "Factor" 2 "Factor+industry" 3 "Factor+offshoring" 4 "Full model" , replace
label values mnum model


graph twoway ///
	(scatter mnum bic, msymbol(O) mcolor(gray)  msize(medlarge)), ///
	yscale(reverse) ///
	legend(off) ///
	ylabel(,grid glwidth(medthin) glcolor(gs12) valuelabel labsize(small)) ///
	title("") xlabel(,grid glwidth(medthin) glcolor(gs12) labsize(small)) ///
	ytitle("") xtitle("BIC") name(fig2, replace)
	
//End of do-file




