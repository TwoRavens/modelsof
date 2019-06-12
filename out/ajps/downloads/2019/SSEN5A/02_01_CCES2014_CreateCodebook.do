/*****************************
* Create Codebook Files
* Replication file for
* Hill, Seth J. and Gregory A. Huber. 2018. ``On The Meaning of Survey Reports of Roll Call `Votes','' American Journal of Political Science.
******************************/

set more off
* Datafiles created outside of replication archive

log using CCES2014codebook.smcl, replace smcl

di "The source for this datafile is data collected on various team modules in the 2014 CCES"
di "See text of paper for complete details and citations"

use RawData/HillHuberCCES2014.dta, clear


foreach var of varlist * {
	codebook `var', all
	if ("`var'" ~="V101" & "`var'"~="weight") {
		tab `var', missing
	}
}

log close

translate CCES2014codebook.smcl CCES2014codebook.pdf, trans(smcl2pdf) replace
!erase CCES2014codebook.smcl



