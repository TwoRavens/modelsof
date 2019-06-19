clear

*do ${fmartorell_home}/top_program

set mem 1000m

*log using ${fmartorell_home}remediation/programs/get_first_report3.log, replace 
log using ${d1}log/get_first_report3.log, replace 

*!rm ${fmartorell_home}remediation/data/first_tasp_stack.dta
!rm ${d1}data/first_tasp_stack.dta

/********************************************
This program stacks all first-time students in report 2
and gets the first record from these
************************************************* */
/*
global highered="${hb_data}HigherEd"
global higheredjr="${nh_data}HigherEd/Report1/Junior"
local path "${nh_data}HigherEd/Report1/Junior"
global HOMEDIR="${fmartorell_home}"
global report2="${hb_data}HigherEd/report2/senior/better_trans_by_BBucks"
*/


forvalues year = 190/203 {
	forvalues sem = 1/5 {
	
	*Check that the file exists
	cap confirm file "${report2}/d2sr`year'_`sem'.dta"
	if _rc==0 {
            local lowercase_d=1
	    local uppercase_d=0
	    local exist=1
	}
         else {
	  cap confirm file "${report2}/D2sr`year'_`sem'.dta"
          if _rc==0 {
		local uppercase_d=1
		local lowercase_d=0
		local exist=1
	  }
	  else {
	   disp "NO DATA FOR YEAR=`year' SEM=`sem'	
	   local exist=0	
	  } 
	 } /* close uppercase filename exists condition */
	

	if `exist'==1 {
	 disp "Fraction kept in Year=`year' Semester=`sem':"
	 if `uppercase_d'==1 {
		qui use "${report2}/D2sr`year'_`sem'.dta", clear
	 }
	 if `lowercase_d'==1 {
		qui use "${report2}/d2sr`year'_`sem'.dta", clear
	 }	
 
	 gen int tspyr=`year'

	 *Clean duplicate records
	 gen byte obs=_n  /* to keep sort order the same: note, these files are virtually duplicate free */
	 sort altpid school obs
	 by altpid school: keep if _n==1
	 qui count
	 local totaln=r(N)

	 *** Keep first-time students  *** 
	 
	 *Semester 1: keep if year is previous year
	  if `sem'==1 {
	   qui keep if firstsem==1 & ((fyear==(`year'-100-1)) | (fyear==(`year'+1800-1)))
	   qui count
	   local frackept=r(N)/`totaln'
	   disp %4.2f `frackept'
	  }
	 *Semester 2-4: keep if year is current year
	  if `sem'>1 & `sem'<5 {
	   qui keep if firstsem==`sem' & ((fyear==(`year'-100)) | (fyear==(`year'+1800)))
	   qui count
	   local frackept=r(N)/`totaln'
	   disp "    " %4.2f `frackept'
	  }
	 *Semester 5: rule will depend on whether firstsem is 1 or 2-4
	  if `sem'==5 {
	   qui keep if (firstsem==1 & ((fyear==(`year'-100-1)) | (fyear==(`year'+1800-1)))) | (firstsem>1 & firstsem<. & ((fyear==(`year'-100)) | (fyear==(`year'+1800))))
	   qui count
	   local frackept=r(N)/`totaln'
	   disp "        " %4.2f `frackept'
	  }
	 *save ${fmartorell_home}tmp/tmprep2_`year'_`sem', replace
	 save ${d1}tmp/tmprep2_`year'_`sem', replace
	 /*
	 *If not first file, stack to existing data
	 if `sem'!=2 | `year'>190 {
	  qui append using ${fmartorell_home}/remediation/data/first_tasp_stack
	 }
	 qui save ${fmrtorell_home}remediation/data/first_tasp_stack, replace
	 */

	}  /* Close File exists condition */
     cap log close
     *qui log using ${fmartorell_home}remediation/programs/get_first_report3.log, append
	 qui log using ${d1}log/get_first_report3.log, append


 } /* close semester loop */
} /* close year loop */

     cap log close
     *qui log using ${fmartorell_home}remediation/programs/get_first_report3.log, append
     qui log using ${d1}log/get_first_report3.log, append
	 

*use ${fmartorell_home}tmp/tmprep2_190_2
*qui append using ${fmartorell_home}tmp/tmprep2_190_3
*qui append using ${fmartorell_home}tmp/tmprep2_190_4
use ${d1}tmp/tmprep2_190_2
qui append using ${d1}tmp/tmprep2_190_3
qui append using ${d1}tmp/tmprep2_190_4
qui compress

forvalues year = 191/203 {
	forvalues sem = 1/5 {
	 cap log close
	 *qui log using ${fmartorell_home}remediation/programs/get_first_report3.log, append
	 qui log using ${d1}log/get_first_report3.log, append
	 disp "Stacking `year' `sem'"
         *cap append using ${fmartorell_home}tmp/tmprep2_`year'_`sem'
		 cap append using ${d1}tmp/tmprep2_`year'_`sem'
	}
}

     cap log close 
     *qui log using ${fmartorell_home}remediation/programs/get_first_report3.log, append
	 qui log using ${d1}log/get_first_report3.log, append

bysort altpid school tspyr firstsem semester: assert _N==1
by altpid school: gen num=_N
by altpid school: gen first=_n==1
tab tspyr num if first==1

keep if first==1

tab tspyr firstsem

*save ${fmartorell_home}remediation/data/first_tasp_stack, replace
save ${d1}data/first_tasp_stack, replace
clear

log close

forvalues year = 191/203 {
	forvalues sem = 1/5 {
	 *cap rm ${fmartorell_home}tmp/tmprep2_`year'_`sem'.dta
	 cap rm ${d1}tmp/tmprep2_`year'_`sem'.dta
	}
}

