
forvalues b=2010/2013 {
	clear
	use DX1 DX2 svcdate patid using /disk/aging/mktscan/nongeo/data/100pct/ccaeo`b'
	rename DX1 dx1
	rename DX2 dx2
	keep dx* svcdate patid

	forvalues g=1/2 {
	gen h`g'=dx`g'=="96501" 
	}
	gen heroin_admit=max(h1,h2)
	keep if heroin==1
	gen month=month(svcdate)
	gen year1=year(svcdate)
	keep patid heroin month year1
	sort patid year1 month
	collapse (sum) heroin, by(patid year1 month)
	gen c=1
	sort year1 month
	collapse (sum) c, by(year1 month)
	rename c heroin_patients
	save outpatients_`b', replace
}


clear
use outpatients_2004

forvalues b=2005/2013 {
append using outpatients_`b'
}

save outpatients_all, replace
sort year1 month
outsheet using outpatients_all.csv, comma replace
list 
desc
