/*****************************
* Create Codebook Files
* Replication file for
* Hill, Seth J. and Gregory A. Huber. 2018. ``On The Meaning of Survey Reports of Roll Call `Votes','' American Journal of Political Science.
******************************/

set more off
* Datafiles created outside of replication archive

log using SSIcodebook.smcl, replace smcl

di "The source for these datafiles is data collected on our SSI survey"
di "See text of paper for complete details and citations"

use RawData/HillHuberSSI.dta, clear


foreach var of varlist * {
	codebook `var', all
	if ("`var'" ~="V1" & "`var'"~="weight") {
		tab `var', missing
	}
}

log close

translate SSIcodebook.smcl SSIcodebook.pdf, trans(smcl2pdf) replace
!erase SSIcodebook.smcl



