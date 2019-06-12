*Create state-level data from older censues

*State Unemployment Rates
global restrict year==1920|year==1930|year==1940

use if $restrict using "$censusfile", clear
	recode empstat (0 3 =.) (2=0)
	g unemp=1-empstat
	collapse unemp [weight=perwt], by(statefip year)
	
	reshape wide unemp, i(statefip) j(year)
	g unempchange=unemp1940-unemp1930
	rename statefip bpl
	save "stateunemp", replace
	
	
*Baseline Mean Reversion 	
global restrict year==1920

use if $restrict using "$censusfile", clear
	
	recode labforce (0=.) 
	replace labforce=labforce-1
	
	g inschool=school==2
	replace inschool=. if school==0|school>=9
	replace inschool=. if age>18
	
	recode occscore (0=.)	
	
	preserve
	collapse labforce inschool occscore [weight=perwt], by(statefip) 
	
	rename labforce baselabforce
	rename inschool baseschooling
	rename occscore baseihsinctot
	
	g basehsgrad=baseschooling
	g basecolgrad=baseschooling
	g baseemployed=baselabforce 
	g baseworked_50=baselabforce
	g baseworked_40=baselabforce
	g baseworked_27=baselabforce
	
	
	tempfile temp
	save `temp'
	
	restore
	
	collapse labforce inschool occscore [weight=perwt], by(statefip sex) 
	
	rename labforce baselabforce
	rename inschool baseschooling
	rename occscore baseihsinctot
	
	g basehsgrad=baseschooling
	g basecolgrad=baseschooling
	g baseemployed=baselabforce 
	g baseworked_50=baselabforce
	g baseworked_40=baselabforce
	g baseworked_27=baselabforce
	
	
	reshape wide base*, i(statefip) j(sex)
	
	foreach var in labforce schooling ihsinctot hsgrad colgrad employed worked_50 worked_40 worked_27 {
		rename base`var'2 base`var'female
		rename base`var'1 base`var'male
	}
	
	merge 1:1 statefip using `temp', nogenerate
	
	rename statefip bpl

		
	save "baseline_meanrev", replace
	

/***The following code is what was was used to generate the numbers in:
*recode_dblack.do
*recode_popgrowth.do
*recode_female1920s.do
*recode_black1920s.do
global restrict year==1920|year==1930|year==1940

use if $restrict using "$censusfile", clear
	gen black=(race==2) if race<.
	g count=1
	
	collapse (mean) black (sum) count [weight=perwt], by(year statefip) 
	
	bys year: egen total=sum(count)
	
	g shareofpop=count/total
	
	drop count total
	reshape wide black shareofpop, i(statefip) j(year)
	
	g dblack=black1940-black1920
	g popgrowth=shareofpop1940-shareofpop1920
