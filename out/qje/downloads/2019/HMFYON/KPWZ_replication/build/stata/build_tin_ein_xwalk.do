*******************************************************************************
*******************************************************************************
* CREATE TIN-EIN XWALK
*******************************************************************************
*******************************************************************************
		/*
		*******************************************************************************
		* 1. Bring in Data
		*******************************************************************************
		foreach form in "f1120" "f1120s" "f1065" {
		use  $dtadir/patent_eins_`form'.dta, clear
		keep unmasked_tin tin year
		g form="`form'"
		tempfile data_`form'
		sort tin year
		save `data_`form''
		}

		clear

		*******************************************************************************
		* 2. Append and check for duplicates
		*******************************************************************************
		foreach form in "f1120" "f1120s" "f1065" {
		append using `data_`form''
		}

		drop form
		duplicates drop

		sort tin year
		save $dtadir/tin_ein_xwalk.dta, replace
		*/

insheet using $rawdir/tin_ein_xwalk.csv, clear
duplicates drop
compress
*destring tin, replace force
*destring unmasked_tin, replace force
drop if tin==.
drop if unmasked_tin==.

egen tag=tag(tin)
*2K/74M=0
tab tag
drop ig tag==0
drop tag


sort tin
save $dtadir/tin_ein_xwalk.dta, replace

