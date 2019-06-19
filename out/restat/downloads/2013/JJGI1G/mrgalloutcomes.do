cap log close
clear
program drop _all

*cap do ${fmartorell_home}/top_program.do

*log using ${fmartorell_home}remediation/programs/mrgalloutcomes.log, replace
log using ${d1}log/mrgalloutcomes.log, replace


********
*Set the value for the number of acad yrs to go forward
********
global maxyr=6

forvalues y=192/202 {
 *!rm ${fmartorell_home}/remediation/data/tasp_withde_nongroutc_`y'.dta
 !rm ${d1}data/tasp_withde_nongroutc_`y'.dta
}

/* *******************************************************************************************
Set up the program to merge report 1 and report 2 to each year of data from the "tasp192_200_withde" file
********************************************************************************************* */


program define mrgrep


**********
*Load main dataset and initialize some variables
**********

disp " "
disp " "
disp "----------------------------------------------------------------------------------"
disp "Getting data for TSP Year=`1'"
disp "----------------------------------------------------------------------------------"
*use ${fmartorell_home}/remediation/data/tasp192_200_withde if tspyr==`1', clear
use ${d1}data/tasp192_200_withde if tspyr==`1', clear
drop gpa
rename sch orig_sch
rename sr orig_sr
label var orig_sr "SR/JR status from 1st report 2 rec"
cap drop gradmath


*Set variables for checking validity of match
qui gen m_rep2=month(bdate)
qui gen y_rep2=year(bdate)
gen byte missbdateorig=m_rep2==. | y_rep2==.
label var missbdateorig "Missing report 2 DOB"
drop bdate
rename sex sex_rep2
rename ethnic ethnic_rep2

*Initialize the outcome variables for report 1
gen byte srcredit=0
gen byte jrcredit=0
gen byte highgradejr=1
qui gen highgradejr_term=.
qui gen highgradejr_year=.
gen byte highgradesr=1
qui gen highgradesr_term=.
qui gen highgradesr_year=.
gen byte tempmax=0

*Initialize the outcome variables for report 2
gen byte srcredit_ac=0
gen byte srcredit_ac_gpa=0
gen byte jrcredit_ac=0
gen byte jrcredit_ac_gpa=0
gen byte srcredit_aftr_ac=0
gen byte srcredit_aftr_ac_gpa=0
gen byte jrcredit_aftr_ac=0
gen byte jrcredit_aftr_ac_gpa=0
gen byte srcredit_nosem5_ac=0
gen byte srcredit_nosem5_ac_gpa=0
gen byte jrcredit_nosem5_ac=0
gen byte jrcredit_nosem5_ac_gpa=0
gen byte passcollmath=0
qui gen byte fgrademath=.

*Initialize the outcome variables for report9
forvalues i=0/8 {
 gen byte assoc_`i'=0
 gen byte bac_`i'=0
}


foreach inst in sr jr {
 label var `inst'credit_ac "Acad credits attempted from rep 2"
 label var `inst'credit_ac_gpa "Acad crdts atmptd, only count if gpa>1"
 label var `inst'credit_aftr_ac "Ac crdts atmptd after term of max report 1 type"
 label var `inst'credit_aftr_ac_gpa "Ac crdts atd after max rep 1 type, gpa>1"
 label var `inst'credit_nosem5_ac "Ac crdts atmptd after term of max report 1 type"
 label var `inst'credit_nosem5_ac_gpa "Ac crdts atd after max rep 1 type, gpa>1"
}

sort altpid



/* ******************************************************************************************** 
Loop through report 1. Get total credits attempted and highest grade from report 1
Note: report 1 does not have information on credits completed.
Also, highest grade from report 1 won't be highest grade completed whenever student completes the term
in which they've enrolled! (for instance, a sophmore who does not graduate and never appears as a junior 
in report 1 will be misclassified if they finished their sophmore year)
*********************************************************************************************** */

local max=`1'+$maxyr
local maxm1=$maxyr-1
drop _merge match
forvalues y=`1'/`max' {
 local relyr=`y'-`1'
 forvalues term=1/4 {
  disp "Merging report 1 `y' `term'"
  ******* Junior colleges ******
  *cap confirm file ${fmartorell_home}data/highered/report1jc`y'_`term'.dta
  cap confirm file ${d1}data/highered/report1jc`y'_`term'.dta
  if _rc==0 {

   *Merge dataset and identify matched records
   qui merge altpid using ${d1}data/highered/report1jc`y'_`term', ///
      uniqusing nokeep keep(altpid sex type bdate totcredit ethnic)
   gen match=_merge==3 & ((`y'==tspyr & `term'>=firstsem) | ///
    (`y'>tspyr & ((`y'<=tspyr+`maxm1') | ((`y'==tspyr+$maxyr) & `term'<firstsem))))

   qui gen validmatch=match==1 & (((year(bdate)==y_rep2)+(month(bdate)==m_rep2)==2)+(sex==sex_rep2)+(ethnic==ethnic_rep2)>=2) 
 
   *** Update report 2 birthdate information if it is missing !!! ***
   qui replace y_rep2=year(bdate) if validmatch==1 & y_rep2==.
   qui replace m_rep2=month(bdate) if validmatch==1 & m_rep2==.

   *** Update outcome variables  ***

   *Credits
   qui replace totcredit=0 if totcredit==.
   qui replace jrcredit=jrcredit+totcredit if validmatch==1


   *Highest grade from report 1 (note: this won't be total years completed if they finish the year they've enrolled in!)
   qui replace tempmax=max(highgradejr,type) if inlist(type,1,2,4)==1 & validmatch==1
   qui replace highgradejr_term=`term' if tempmax>highgradejr
   qui replace highgradejr_year=`y' if tempmax>highgradejr
   qui replace highgradejr=tempmax if tempmax>highgradejr
   qui replace tempmax=0

   if `y'==`1' & `term'==1 {
    *summ validmatch if match==1
   }
   foreach var of varlist type totcredit  {
    rename `var' jr`var'_`relyr'_`term'
   }
   rename validmatch jrvalidmatch_r1_`relyr'_`term'

   drop _merge sex bdate /* jrtype_`relyr'_`term' jrtotcredit_`relyr'_`term' jrvalidmatch_r1_`relyr'_`term' */ ethnic  match
   
   cap drop devcredit acadcredit
   sort altpid
  }  /* close JC file exists */

  ******* Senior colleges ******
  * cap confirm file ${fmartorell_home}data/highered/report1sr`y'_`term'.dta
  cap confirm file ${d1}data/highered/report1sr`y'_`term'.dta
  if _rc==0 {

   *Merge dataset and identify matched records
   qui merge altpid using ${d1}data/highered/report1sr`y'_`term', ///
       uniqusing nokeep keep(altpid sex type bdate totcredit ethnic)
   gen match=_merge==3 & ((`y'==tspyr & `term'>=firstsem) | ///
    (`y'>tspyr & ((`y'<=tspyr+`maxm1') | ((`y'==tspyr+$maxyr) & `term'<firstsem))))

   qui gen validmatch=match==1 & (((year(bdate)==y_rep2)+(month(bdate)==m_rep2)==2)+(sex==sex_rep2)+(ethnic==ethnic_rep2)>=2) 

   
   ***** Update outcome variables  *****

   *Credits
   qui replace totcredit=0 if totcredit==.
   qui replace srcredit=srcredit+totcredit if validmatch==1

   *Highest grade from report 1 (note: this won't be total years completed if they finish the year they've enrolled in!)
   qui replace tempmax=max(highgradesr,type) if inlist(type,1,2,3,4,5)==1 & validmatch==1
   qui replace highgradesr_term=`term' if tempmax>highgradesr
   qui replace highgradesr_year=`y' if tempmax>highgradesr
   qui replace highgradesr=tempmax if tempmax>highgradesr
   qui replace tempmax=0

   *summ validmatch if match==1
   foreach var of varlist type totcredit  {
    rename `var' sr`var'_`relyr'_`term'
   }
   rename validmatch srvalidmatch_r1_`relyr'_`term'

   drop _merge sex bdate /* srtype_`relyr'_`term' srtotcredit_`relyr'_`term' srvalidmatch_r1_`relyr'_`term' */ ethnic  match
   cap drop devcredit acadcredit
   sort altpid
  }  /* close SR file exists */


 } /* close term loop */
}  /* close year loop */


 /* ******************************************************************************************** 
Loop through report 2.
*********************************************************************************************** */
forvalues y=`1'/`max' {
 local relyr=`y'-`1'
 forvalues term=1/5 {
  disp "Merging Report 2: `y' `term'"
  local term2=`term'*(`term'<5)+1*(`term'==5)  /* for full-year report 2, treat as fall. if they did coursework in spring or summer, obs window will be somewhat longer...may want to revisit this */
  *cap confirm file ${fmartorell_home}tmp/report2_`y'_`term'_unique.dta
  cap confirm file ${d1}tmp/report2_`y'_`term'_unique.dta
  if _rc==0 {

   *Merge dataset and identify matched records
   qui merge altpid using ${d1}tmp/report2_`y'_`term'_unique.dta, ///
    uniqusing nokeep keep(altpid sch gpa sr sex bdate ethnic gradmath)
    *Include matches where firstsem>1 and term=5 (so don't use term2 in first line!)
   gen match=_merge==3 & ((`y'==tspyr & (`term'>=firstsem)) | ///
    (`y'>tspyr & ((`y'<=tspyr+`maxm1') | ((`y'==tspyr+$maxyr) & `term2'<firstsem))))

   qui gen validmatch=match==1 & (((year(bdate)==y_rep2)+(month(bdate)==m_rep2)==2)+(sex==sex_rep2)+(ethnic==ethnic_rep2)>=2) 

   
   *** Update outcome variables  ***

   qui {
   replace sch=0 if sch==.
   gen gradeavg=gpa/sch
   replace gradeavg=-1 if gradeavg==.

   replace srcredit_ac=srcredit_ac+sch if validmatch==1 & sr==1
   replace srcredit_ac_gpa=srcredit_ac_gpa+sch if validmatch==1 & sr==1 & gradeavg>1
   replace jrcredit_ac=jrcredit_ac+sch if validmatch==1 & sr==0
   replace jrcredit_ac_gpa=jrcredit_ac_gpa+sch if validmatch==1 & sr==0 & gradeavg>1

   replace srcredit_aftr_ac=srcredit_aftr_ac+sch if validmatch==1 & sr==1 & (`y'>highgradesr_year | (`y'==highgradesr_year & `term'>=highgradesr_term))
   replace srcredit_aftr_ac_gpa=srcredit_aftr_ac_gpa+sch if validmatch==1 & sr==1 & gradeavg>1 & (`y'>highgradesr_year | (`y'==highgradesr_year & `term'>=highgradesr_term))
   replace jrcredit_aftr_ac=jrcredit_aftr_ac+sch if validmatch==1 & sr==0 & (`y'>highgradejr_year | (`y'==highgradejr_year & `term'>=highgradejr_term))
   replace jrcredit_aftr_ac_gpa=jrcredit_aftr_ac_gpa+sch if validmatch==1 & sr==0 & gradeavg>1 & (`y'>highgradejr_year | (`y'==highgradejr_year & `term'>=highgradejr_term))

   if `term'<5 | (`y'<`max') {
   replace srcredit_nosem5_ac=srcredit_nosem5_ac+sch if validmatch==1 & sr==1 & (`y'>highgradesr_year | (`y'==highgradesr_year & `term'>=highgradesr_term))
   replace srcredit_nosem5_ac_gpa=srcredit_nosem5_ac_gpa+sch if validmatch==1 & sr==1 & gradeavg>1 & (`y'>highgradesr_year | (`y'==highgradesr_year & `term'>=highgradesr_term))
   replace jrcredit_nosem5_ac=jrcredit_nosem5_ac+sch if validmatch==1 & sr==0 & (`y'>highgradejr_year | (`y'==highgradejr_year & `term'>=highgradejr_term))
   replace jrcredit_nosem5_ac_gpa=jrcredit_nosem5_ac_gpa+sch if validmatch==1 & sr==0 & gradeavg>1 & (`y'>highgradejr_year | (`y'==highgradejr_year & `term'>=highgradejr_term))
   }
   
   
   if `y'<204 {
     replace passcollmath=1 if validmatch==1 & inlist(gradmath,1,2,3,4,6)==1
     replace fgrademath=gradmath if inlist(gradmath,1,2,3,4,5,6,7)==1 & validmatch==1 & fgrademath==.  /* for the first time they took course */
   }
   else if `y'>=204 {
		/* note: could include "0" since that denotes past, but i keep it this way to be consistent with past */
     replace passcollmath=1 if validmatch==1 & inlist(gradmath,1,2,3,4,6)==1   
		/* note starting in 204 (1) F/No Credit collapsed into category 5, cat 7=not attempted this semester */
     replace fgrademath=gradmath if inlist(gradmath,1,2,3,4,5,6)==1 & validmatch==1 & fgrademath==. /* for the first time they took course */
   }
   assert fgrademath!=. if passcollmath==1
   }

   

   foreach var of varlist sch gpa sr gradmath {
    rename `var' `var'_`relyr'_`term'
   }
   rename validmatch validmatch_r2_`relyr'_`term'

   drop _merge sex bdate  ethnic  match /* validmatch_r2_`relyr'_`term' sch_`relyr'_`term' gpa_`relyr'_`term'  sr_`relyr'_`term' */ gradeavg   
   
   sort altpid 

   } /*  close file exists condition */
 } /* close term loop */
}  /* close year loop */


 /* ******************************************************************************************** 
Loop through report 9
*********************************************************************************************** */
local max=`1'+8
 forvalues y=`1'/`max' {
 local relyr=`y'-`1'
 
 *cap confirm file "${fmartorell_home}data/highered/report9jr`y'.dta"
 cap confirm file "${d1}data/highered/report9jr`y'.dta"
 if _rc==0 {
   qui merge altpid using  "${d1}data/highered/report9jr`y'.dta", ///
     nokeep uniqusing keep(bthday ethnic_t associate sex)
     qui gen validmatch=_merge==3 & (((year(bthday)==y_rep2)+(month(bthday)==m_rep2)==2)+(sex==sex_rep2)+(ethnic_t==ethnic_rep2)>=2) 

     qui replace assoc_`relyr'=1 if validmatch==1 & associate==1
     rename validmatch validmatch_r9_jr_`relyr'
   drop bthday ethnic_t associate _merge sex
   
   sort altpid
 }
 
 *cap confirm file "${fmartorell_home}data/highered/report9sr`y'.dta"
 cap confirm file "${d1}data/highered/report9sr`y'.dta"
 if _rc==0 {
   qui merge altpid using  "${d1}data/highered/report9sr`y'.dta", ///
     nokeep uniqusing keep(bthday ethnic_t sex associate baccalaureate)
     qui gen validmatch=_merge==3 & (((year(bthday)==y_rep2)+(month(bthday)==m_rep2)==2)+(sex==sex_rep2)+(ethnic_t==ethnic_rep2)>=2) 
     summ validmatch if _merge==3

     qui replace bac_`relyr'=1 if validmatch==1 & baccalaureate==1
     qui replace assoc_`relyr'=1 if validmatch==1 & associate==1
     rename validmatch validmatch_r9_sr_`relyr' 
   drop bthday ethnic_t associate _merge baccalaureate sex
   sort altpid
 }
}

 /* ******************************************************************************************** 
Merge TAAS 
*********************************************************************************************** */
*merge altpid using ${fmartorell_home}data/taas_with_score, nokeep uniqusing keep(bmo bda byr ethnic *scode rawred rawmth  sex admin taasyear)
merge altpid using ${d1}data/taas_with_score, nokeep uniqusing keep(bmo bda byr ethnic *scode rawred rawmth  sex admin taasyear)
qui gen taasmatch=_merge==3 & (((byr==y_rep2)+(bmo==m_rep2)==2)+(sex==sex_rep2)+(ethnic==ethnic_rep2)>=2) 
drop _merge byr bmo sex ethnic 
qui compress

***** Some checks *****
rename orig_sr sr
gen jr=sr==0 if sr!=.
foreach type in sr jr {
 foreach var of varlist `type'credit_ac { 
 summ `var' if `var'>0 & `type'==1, detail
 }
}

tab highgradesr if sr==1
tab highgradejr if jr==1

tabstat srcredit_ac if sr==1, by(highgradesr)
tabstat jrcredit_ac if jr==1, by(highgradejr)

**** Save the dataset *****
*save ${fmartorell_home}/remediation/data/tasp_withde_outc_`1', replace
save ${d1}data/tasp_withde_outc_`1', replace

end





*****************
* Run program for all years
*****************


forvalues y=192/200 {
 mrgrep `y'
}

log close
