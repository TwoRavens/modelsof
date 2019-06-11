*##========================================================================##*
*## Paper: "Making comprehensible speeches when your constituents need it" ##*
*## Journal: Research & Politics										   ##*			
*## Authors: Nick Lin (University of Mannheim) 							   ##*	 
*## 		 Moritz Osnabrügge (Bocconi University)						   ##*
*## Date: July 22, 2018													   ##*
*##========================================================================##*

set more off

*## Read Speech Data
clear all
cd "$wd1"
use "Lin_Osnabruegge_RAP_data.dta"
set matsize 2000


*## Figure 1: Plot the distibution of DVs
set scheme s1mono
preserve 
	keep scorefre
	rename scorefre score
	gen type = "FRE Score"
	tempfile scorefre
	save "`scorefre'"
restore 

preserve
	keep scorelixr
	rename scorelixr score
	gen type = "Reversed LIX Score"
	append using "`scorefre'"
	
	hist score, bin(55) percent normal by(type, note("") legend(off)) xtitle("Speech Comprehensibility") ytitle("Proportion") 
	graph export "Fig1_Distribution.pdf", replace
restore 


*##Table 1: Summary statistics

sutex scorefre scorelixr unemployment hochschulreife nongermanpop senioryr leader highjob phd age female migration length_terms, minmax


*## Table 2: Multi-level Models in the manuscript 
	
global ctrl0 unemployment hochschulreife nongermanpop
global ctrl1 unemployment hochschulreife nongermanpop senioryr leader highjob phd age female migration length_terms
	
xtmixed scorefre $ctrl0, || speakerid: 
est store m1
	
xtmixed scorefre $ctrl1, || speakerid:
est store m2
	
xtmixed scorelixr $ctrl0, || speakerid:
est store m3
	
xtmixed scorelixr $ctrl1, || speakerid: 
est store m4
	
esttab m1 m2 m3 m4, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted transform(ln*: exp(@) exp(@)) /*
	*/ keep(unemployment hochschulreife nongermanpop senioryr leader highjob phd age female migration length_terms _cons) /*
	*/ coeflabels(hochschulreife "District Education Level" unemployment "Unemployment Rate" nongermanpop "Population with Migration Background"/*
	*/ leader "Party Leader" highjob "High Job" phd "Ph.D. degree" age "Age" female "Female MPs" senioryr "Seniority (in years)" migration "MPs with Migration Background" /*
	*/ length_terms "Speech Length" _cons "Constant") /*
	*/ eqlabels("" "Random effect - MP" "Random effect - Residual", none)	

	
*## Table A1: Multi-level Models with subs-samples (in the Online Appendix)
	
global ctrl0 unemployment hochschulreife nongermanpop 
global ctrl1 unemployment hochschulreife nongermanpop senioryr leader highjob phd age female migration length_terms

*List 1
xtmixed scorefre $ctrl0 if elected_constituent == 0, || speakerid: 
est store m1

*List 2
xtmixed scorefre $ctrl1 if elected_constituent == 0, || speakerid:
est store m2

*Constituency 1
xtmixed scorefre $ctrl0 if elected_constituent == 1, || speakerid:
est store m3
	
*Constituency 2
xtmixed scorefre $ctrl1 if elected_constituent == 1, || speakerid: 
est store m4
	
esttab m1 m2 m3 m4, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted transform(ln*: exp(@) exp(@)) /*
	*/ keep(unemployment hochschulreife nongermanpop senioryr leader phd age female migration length_terms _cons) /*
	*/ coeflabels(hochschulreife "District Education Level" unemployment "Unemployment Rate" nongermanpop "Population with Migration Background"/*
	*/ leader "Party Leader" highjob "High Job" phd "Ph.D. degree" age "Age" female "Female MPs" senioryr "Seniority (in years)" migration "MPs with Migration Background" /*
	*/ length_terms "Speech Length" _cons "Constant") /*
	*/ eqlabels("" "Random effect - MP" "Random effect - Residual", none)	
	
	
*## Table A2: Robustness Check with Party Fixed-effects (in the Online Appendix)

global ctrl0 unemployment hochschulreife nongermanpop i.party
global ctrl1 unemployment hochschulreife nongermanpop senioryr highjob leader phd age female migration length_terms i.party
	
xtmixed scorefre $ctrl0, || speakerid: 
est store m1
	
xtmixed scorefre $ctrl1, || speakerid:
est store m2
	
xtmixed scorelixr $ctrl0, || speakerid:
est store m3
	
xtmixed scorelixr $ctrl1, || speakerid: 
est store m4

esttab m1 m2 m3 m4, b(%10.3f) se scalars (N ll) star(+ 0.10 * 0.05 ** 0.01) noomitted transform(ln*: exp(@) exp(@)) /*
	*/ keep(unemployment hochschulreife nongermanpop senioryr leader phd age female migration length_terms 2.party 3.party 4.party 5.party 6.party _cons) /*
	*/ order(unemployment hochschulreife nongermanpop senioryr leader phd age female migration length_terms 2.party 3.party 4.party 5.party 6.party _cons) /*
	*/ coeflabels(hochschulreife "District Education Level" unemployment "Unemployment Rate" nongermanpop "Population with Migration Background"/*
	*/ leader "Party Leader" highjob "High Job" phd "Ph.D. degree" age "Age" female "Female MPs" senioryr "Seniority (in years)" migration "MPs with Migration Background" /*
	*/ length_terms "Speech Length" 2.party "FDP" 3.party "Green" 4.party "die Linke" 5.party "SPD" 6.party "Independents" _cons "Constant") /*
	*/ eqlabels("" "Random effect - MP" "Random effect - Residual", none)	
	
