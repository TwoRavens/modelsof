clear

/* ***************************************************************
This program extracts observations from the stacked report 2 dataset,
and gets info on DE in the first and second semesters 
***************************************************************** */

set more off
cap log close
program drop _all

*run ${fmartorell_home}top_program.do

*global HOMEDIR="${fmartorell_home}"
global HOMEDIR="${d1}"

set mem 650m

*log using ${fmartorell_home}remediation/programs/get_sample_de2.log, replace
log using ${d1}log/get_sample_de2.log, replace

/*
/* ***************************************************************************
Create small datasets from report 2 with info on DE
NOTE: THESE ARE CREATED IN PROCESS_REPORT1_REPORT2.DO
**************************************************************************** */

forvalues year=198/201 {
 forvalues sem=1/5 {
  cap confirm file ${report2}/d2sr`year'_`sem'.dta

  if _rc==0 { 
  use ${report2}/d2sr`year'_`sem'.dta, clear
  keep altpid school *prov
  bysort altpid school: keep if _n==1
  foreach test in math read writ {
   gen `test'de=inrange(`test'prov,1,4)
  }
  gen byte anysubde=mathde+readde+writde
  keep altpid school mathde readde writde anysubde
  bysort altpid school: assert _N==1
  qui compress
  save ${HOMEDIR}tmp/report2_`year'_`sem'.dta, replace
  }
 
 }
}
*/



/* ***************************************************************************
Now extract records from main report 2 dataset, merge TASP scores and merge on DE info
**************************************************************************** */

*Variables to select from NES data
global taspvar="admindate_y1 admindate_m1 admindate_d1 pass_sec11 pass_sec21 pass_sec31 scalescore_sec11 scalescore_sec21 scalescore_sec31"
program drop _all
*Program to do merging
program define mrgde
  qui merge altpid school using ${HOMEDIR}tmp/report2_`1'_`2'.dta, nokeep unique sort keep(mathde writde readde anysubde)
  foreach test in math read writ {
   qui replace de`test'_2sem=1 if `test'de==1 & inrange(firstsem,`3',`4') & semester!=5
  }
  qui replace anydeved_2sem=1 if anysubde>=1 & anysubde<. & inrange(firstsem,`3',`4') & semester!=5
  drop _merge
  drop mathde-anysubde
end


*delete old dataset
*!rm ${HOMEDIR}remediation/data/tasp192_200_withde.dta
!rm ${HOMEDIR}data/tasp192_200_withde.dta

forvalues year=192/200 {
 cap log close
 *log using ${fmartorell_home}remediation/programs/get_sample_de2.log, append
 log using ${d1}log/get_sample_de2.log, append
 disp "----------------------------------------------------------------"
 disp "Merging for tspyr= `year'"
 disp "----------------------------------------------------------------"
 local yrp1=`year'+1


 *** Select on tspyr
 *qui use ${HOMEDIR}remediation/data/first_tasp_stack if tspyr==`year', clear
 qui use ${HOMEDIR}data/first_tasp_stack if tspyr==`year', clear
 cap drop *2 *3 unused*
 foreach test in math read writ {
  qui replace init`test'=old`test' if (tspyr==198 & semester>1) | (tspyr<192)
 }
 drop old*


 *** Merge on initial test score
 *qui merge altpid using ${HOMEDIR}remediation/data/tasp_uniquessn, nokeep uniqusing keep($taspvar) _merge(match)
 qui merge altpid using ${HOMEDIR}data/tasp_uniquessn, nokeep uniqusing keep($taspvar) _merge(match)
 qui replace match=(match==3)
 gen byte nes_match=match
 qui summ match
 disp "% of records in tspyr=`tspyr' merging to TASP data: " r(mean)

 *rescale test score
 qui gen rsc_math=scalescore_sec21-230 if (admindate_y1==1995 & admindate_m1>=9) | admindate_y1>1995
 qui replace rsc_math=scalescore_sec21-220 if (admindate_y1==1995 & admindate_m1<9) | admindate_y1<1995

 qui gen rsc_read=scalescore_sec11-230 if (admindate_y1==1995 & admindate_m1>=9) | admindate_y1>1995
 qui replace rsc_read=scalescore_sec11-220 if (admindate_y1==1995 & admindate_m1<9) | admindate_y1<1995

 qui gen rsc_writ=scalescore_sec31-220 /* writing always 220 */
 drop scalescore_sec*1

 *** Create variables based on test timing
 local yp1=`year'+1800+1
 local ym1=`year'+1800-1
 local y=`year'+1800
 
 qui {
  *Dummy for initially testing BEFORE first semester
  *MIGHT WANT TO COME BACK TO THIS!! EXCLUDE IF TEST TAKEN A LONG TIME AGO
  gen byte before=(admindate_y1==`ym1' & admindate_m1<=9) | admindate_y1<`ym1' if firstsem==1
  replace before=(admindate_y1<=`ym1') | (admindate_y1==`y' & admindate_m1==1) if firstsem==2
  replace before=(admindate_y1<=`ym1') | (admindate_y1==`y' & admindate_m1<=6) if firstsem==3
  replace before=(admindate_y1<=`ym1') | (admindate_y1==`y' & admindate_m1<=7) if firstsem==4

  *Dummy for initially testing WITHIN one semester of first semester
  gen win1sem=(admindate_y1<=`ym1') | (admindate_y1==`y' & admindate_m1==1) if firstsem==1
  replace win1sem=(admindate_y1<=`ym1') | (admindate_y1==`y' & admindate_m1<=9) if firstsem==2
  replace win1sem=(admindate_y1<=`y') | (admindate_y1==`yp1' & admindate_m1==1) if inrange(firstsem,3,4)
 }


 *** Get DE information ***
 
 *First, DE in first semester
 foreach test in math read writ {
   qui gen byte de`test'_fsem=inrange(`test'prov,1,4)
   qui gen byte de`test'_2sem=de`test'_fsem
  }
 *Initialize DE in first or 2nd semester variables
 qui gen byte anydeved=(demath_fsem+deread_fsem+dewrit_fsem)>0
 qui gen byte anydeved_2sem=anydeved

 *Now merge information from other report 2's (Note: not semester 5, which reflects entire acad yr)
  cap drop _merge


  mrgde `year' 2 1 1  /* spring semester for students starting in fall */

  mrgde `year' 3 2 2  /* summer 1 for students starting in spring */

  mrgde `year' 4 3 3  /* summer 2 for students starting in summer 1 */

  mrgde `yrp1' 1 2 4  /* following fall for all students except those starting in fall */

  mrgde `yrp1' 2 3 4  /* following spring for students starting in summer 1 or 2 */

  /* cap confirm file ${HOMEDIR}remediation/data/tasp192_200_withde.dta
  if _rc==0 {
   qui append using ${HOMEDIR}remediation/data/tasp192_200_withde.dta
  }
  save ${HOMEDIR}remediation/data/tasp192_200_withde.dta, replace */
  assert anydeved_2sem==1 if demath_2sem==1 | deread_2sem==1 | dewrit_2sem==1
  assert anydeved_2sem==0 if demath_2sem==0 & deread_2sem==0 & dewrit_2sem==0
  *save $HOMEDIR/tmp/mrgtemp_`year', replace
  save ${HOMEDIR}tmp/mrgtemp_`year', replace


} /* close year loop */

cap log close
*log using ${fmartorell_home}remediation/programs/get_sample_de2_end.log, replace
log using ${d1}log/get_sample_de2_end.log, replace


*use $HOMEDIR/tmp/mrgtemp_192, clear
use ${HOMEDIR}tmp/mrgtemp_192, clear
forvalues year=193/200 {
 disp "Stacking `year'"
 *append using $HOMEDIR/tmp/mrgtemp_`year'
 append using $HOMEDIR/tmp/mrgtemp_`year'
}

*rename tspyr year
gen year=tspyr
gen orig_semester=semester
replace semester=2 if semester==5 /* so to merge with schooltype datset, which is based on report 1 */
sort school tspyr semester
*sort school year

*merge school tspyr semester using ${fmartorell_home}tmp/schooltype.dta, uniqusing nokeep keep(sr)
merge school tspyr semester using ${d1}tmp/schooltype.dta, uniqusing nokeep keep(sr)
tab tspyr _merge

*now revert back to original semester variable
drop semester
rename orig_semester semester

gen byte one=1
gen byte notexempt=1-inrange(teststat,4,.)

*set before and win1sem to 0 if not at least one valid score
gen byte valid=(rsc_math>=-130 & rsc_math<=80) | (rsc_read>=-130 & rsc_read<=80) | (rsc_writ>=-130 & rsc_writ<=80)
replace before=0 if valid==0
replace win1sem=0 if valid==0
tabstat one notexempt if sr==1, by(tspyr) stat(sum) 
tabstat one notexempt if sr==0, by(tspyr) stat(sum) 

tabstat match before win1sem if notexempt==1 & sr==1, by(tspyr) stat(sum)
tabstat match before win1sem if notexempt==1 & sr==0, by(tspyr) stat(sum)

*within 10 math scale points
tabstat notexempt win1sem if notexempt==1 & sr==1 & rsc_math>=-10 & rsc_math<=10, by(tspyr) stat(sum)
tabstat notexempt win1sem if notexempt==1 & sr==0 & rsc_math>=-10 & rsc_math<=10, by(tspyr) stat(sum)

drop one
*keep if notexempt==1
compress
  *save ${HOMEDIR}remediation/data/tasp192_200_withde.dta, replace
  save ${HOMEDIR}data/tasp192_200_withde.dta, replace
cap log close
*log using ${fmartorell_home}remediation/programs/get_sample_de2_end.log, append
log using ${d1}log/get_sample_de2_end.log, append

tab tspyr firstsem, missing
summ rsc_math
tab pass_sec11, missing

forvalues year=192/200 {
 *!rm $HOMEDIR/tmp/mrgtemp_`year'.dta
 !rm ${HOMEDIR}tmp/mrgtemp_`year'.dta
}

/* 
*** For avg DE, drop exempt
keep if notexempt==1

gen white=ethnic==5
keep de*_*sem before win1sem rsc_* admindate_y1 admindate_m1 tspyr white
foreach test in read math writ   {
 egen avg`test'de_bef=mean(de`test'_fsem) if before==1, by(rsc_`test')
 egen avg`test'de_bef2=mean(de`test'_2sem) if before==1, by(rsc_`test')
 

 egen avg`test'de_win=mean(de`test'_fsem) if win1sem==1, by(rsc_`test')
 egen avg`test'de_win2=mean(de`test'_2sem) if win1sem==1, by(rsc_`test')
 egen n`test'_win2=count(de`test'_2sem) if win1sem==1, by(rsc_`test')
 egen avgwhite_`test'=mean(white) if win1sem==1, by(rsc_`test')
 egen tag`test'=tag(rsc_`test') if win1sem==1
}
keep if tagread==1 | tagmath==1 | tagwrit==1
keep avg* n*_win2  rsc_*

outsheet using ${HOMEDIR}remediation/data/collapsed2, replace
save ${HOMEDIR}remediation/data/collapsed2, replace
*/

log close
