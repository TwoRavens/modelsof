
** Annual datasets for slected cohorts: 1992-1999.
** Individuals are recorded by Jan. 1 and can migrate/die so any one 
** cohort can change size every yr.
forval t = 2008/2015{
		use pnr foed_dag* using "E:\Data\rawdata\703788\bef`t'", clear
		ge cohort = year(foed_dag)
		keep if inrange(cohort,1992,1999)
		ge aar = `t'
		
	save "$data\minwage_data01_bef`t'_cohort1992_1999.dta", replace
}

** Dataset with all relevant individuals identifiers
use "$data\minwage_data01_bef2008_cohort1992_1999.dta", clear
	
	forval t = 2009/2015{
		append using "$data\minwage_data01_bef`t'_cohort1992_1999.dta"
	}		
	collapse (min) foed_dag2008 (min) foed_dag2009 (min) foed_dag2010 ///
			 (min) foed_dag2011 (min) foed_dag2012 (min) foed_dag2013 ///
			 (min) foed_dag2014 (min) foed_dag2015 (min) cohort, by(pnr)
	
	ge foed_dag = foed_dag2008
	forval t = 2009/2015{
		replace foed_dag = foed_dag`t' if foed_dag == .
	}
	drop foed_dag2*

save "$data\minwage_data01_pnr_key_cohort1992_1999.dta", replace
