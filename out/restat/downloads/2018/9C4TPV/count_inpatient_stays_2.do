* count the # of oxy scripts per month
clear
set more off


forvalues b=2004/2013 {
	clear
	use dx* admdate patid using /disk/aging/mktscan/nongeo/data/100pct/ccaei`b'

	forvalues g=1/14 {
		gen h`g'=dx`g'=="96501" 
	}
	gen heroin_admit=max(h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14)
	keep if heroin==1
	gen month=month(admdate)
	gen year1=`b'
	keep month year1 patid
	save inpatient_stays_`b', replace
	clear
}

clear
use inpatient_stays_2004

forvalues b=2005/2013 {
	append using inpatient_stays_`b'
}

save inpatient_stays_all, replace
desc

