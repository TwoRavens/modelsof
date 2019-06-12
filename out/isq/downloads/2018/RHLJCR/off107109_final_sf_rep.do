/*	
  Replication data for "Exposure to Offshoring and the Politics of Trade 
  Liberalization: Debate and Votes on Free Trade Agreements in the U.S. House of
  Representatives, 2001-2006",  International studies quarterly 
  
  Replication for supplementary files
  
  Erica Owen (ericaowen@tamu.edu)    
  Last modified: 10-25-2016   */

* Note: This .do file assumes that you have changed the working directory 



//0. Program setup
clear all
set more off
capture cd "your/directory/here"   
use "eowen_isq_rep.dta", clear

// 1. Descriptive statistics
// Set estimation sample
local iv pctoffshore
local iv2  pctcollege lnempexpsh lnempimpsh
local controls rep unemp  Wdummy MWdummy southdummy i.voteid
logit vote `iv' `iv2' `controls' if ftavote==1, robust


local myvars pctoffshore pctcollege lnempexpsh lnempimpsh rep unemp  Wdummy ///
	MWdummy southdummy prev_bank prev_corp prev_labor
	
// Table 1. Summary of independent variables
sum `myvars' if e(sample)

// Table 2. Correlation table
pwcorr vote pct_labspeech `myvars' if e(sample), sig

// Figure 1. Correlation matrix for main IVs
preserve
collapse (mean)  pctoffshore pctcollege empexpsh empimpsh, by(abbr district) 
 graph matrix pctoffshore pctcollege empexpsh empimpsh, name(fig2, replace) half ///
 diagonal ("% Offshorable" "% College" "% Employed Exporting" "% Employed Importing")
restore 


// Table 3. Summary of labor words by agreement

bysort voteid: sum pct_labspeech if ftavote==1

// Figure 2. Map - Available upon request

// 2. Additional measures of industry intersts
// Table 4

// Model 1 (sectoral coalitions)
local iv pctoffshore
local iv2  pctcollege seccoal1
local controls rep unemp  Wdummy MWdummy southdummy i.voteid


logit vote `iv' `iv2' `controls' if ftavote==1, robust
estat ic
estat class

// Model 2 (Agricultural and manufacturing employment)
local iv2  pctcollege lnempman lnagemp
logit vote `iv' `iv2' `controls' if ftavote==1 , robust
estat ic
estat class





// 3. Controlling for population
// Table 5

// Model 1

local iv pctoffshore pop1000
local iv2  pctcollege lnempexpsh lnempimpsh
loca controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust  
est sto m1
estat ic
estat class


// Model 2 

local iv pctoffshore pop1000
local iv2  pctcollege lnempexpsh lnempimpsh
loca controls rep unemp prev_corp lnprev Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust
est sto m2
estat ic
estat class

// Model 3 
local iv pctoffshore pop1000
local iv2 pctcollege lnempexpsh lnempimpsh
local controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if session~=107 & ftavote==1, robust	
est sto m3
estat ic
estat class

// Model 4 

logit vote `iv' `iv2' `controls' if nontrade==0, robust	
est sto m4
estat ic
estat class


// Model 5
local iv pctoffshore pop1000
local iv2 pctcollege lnempexpsh lnempimpsh


reg pctft `iv' `iv2' rep unemp Wdummy MWdummy southdummy i.session, robust
est sto m5
estat ic




// 4. Individual vote analysis
// Figure 3


forvalues i=1(1)8{

local ind lnempexpsh lnempimpsh
local iv pctoffshore pctcollege 
loca controls rep unemp  Wdummy MWdummy southdummy 
quietly logit vote `iv'  `controls' if ftaid==`i', robust
est sto m`i'a
quietly logit vote `iv' `ind' `controls' if ftaid==`i', robust
est sto m`i'b
}



coefplot (m1a, msymbol(o) mcolor(red))  (m1b, msymbol(d) mcolor(blue)) ///
	(m2a, msymbol(o) mcolor(red)) (m2b, msymbol(d) mcolor(blue)) ///
	(m3a, msymbol(o) mcolor(red)) (m3b, msymbol(d) mcolor(blue)) ///
	(m4a, msymbol(o) mcolor(red)) (m4b, msymbol(d) mcolor(blue)) ///
	(m5a, msymbol(o) mcolor(red)) (m5b, msymbol(d) mcolor(blue)) ///
	(m6a, msymbol(o) mcolor(red)) (m6b, msymbol(d) mcolor(blue)) ///
	(m7a, msymbol(o) mcolor(red)) (m7b, msymbol(d) mcolor(blue)) ///
	(m8a, msymbol(o) mcolor(red)) (m8b, msymbol(d) mcolor(blue)),  ///
	keep(pctoffshore) level(90) xline(0) ///
	legend(label(2 "Offshoring") label(4 "Offshoring+industry") order(2 4) pos(6) row(1)) ///
	ylabel(.58 "TPA" .7 "Chile" .83 "Singapore" .95 "Australia" ///
	1.07 "Morocco" 1.18 "DR-CAFTA" 1.30 "Bahrain" 1.42 "Oman", labsize(small) ) ///
	name(fig1, replace)
	
// 5. Non-FTA votes
// Table 6

local iv pctoffshore
local iv2  pctcollege lnempexpsh lnempimpsh
loca controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==0 & nontrade==0, robust  
est sto m1
estat ic
estat class

logit vote `iv' `iv2' `controls' prev_corp lnprev  if ftavote==0 & nontrade==0, robust
est sto m2
estat ic
estat class

// 6. Additional interactions
// Table 7 

// Model 1
local iv2  c.pctoffshore##i.rep pctcollege lnempexpsh lnempimpsh
loca controls  unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust
est sto m1
estat ic
estat class

margins, dydx(pctoffshore) at(rep=(0(1)1)) level(90)
label define rep 0 "Dem./Ind." 1 "Rep."
label values rep rep
marginsplot, yline(0) name(f1a, replace) ytitle("Marginal effect of offshorability") ///
	xtitle("Partisanship") title("") ///
	note("Vertical lines represent 90% confidence interval")


// Model 2
local iv2  c.pctoffshore##c.unemp i.rep pctcollege lnempexpsh lnempimpsh
loca controls  unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust
est sto m2
estat ic
estat class

margins, dydx(pctoffshore) at(unemp=(0(4)20)) level(90)
marginsplot, yline(0) name(f1a, replace) ytitle("Marginal effect of offshorability") ///
	xtitle("Unemployment") title("") note("Vertical lines represent 90% confidence interval") 
margins, dydx(unemp) at(pctoffshore=(11(2)27)) level(90)	
marginsplot, yline(0) name(f1b, replace) ytitle("Marginal effect of unemployment") ///
	xtitle("Offshorability") title("") 

// 7. Offshorability and task routineness
// Table 9 

// Model 1
local iv pctoffshore n_pctrout
local iv2  pctcollege lnempexpsh lnempimpsh
loca controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust  
est sto m2
estat ic
estat class

// Model 2
local iv n_pctoffrout n_pctoffnr
local iv2  pctcollege lnempexpsh lnempimpsh
loca controls rep unemp  Wdummy MWdummy southdummy i.voteid

logit vote `iv' `iv2' `controls' if ftavote==1, robust  
est sto m3
estat ic
estat class
