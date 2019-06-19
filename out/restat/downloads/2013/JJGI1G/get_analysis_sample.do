cap log close
clear
program drop _all

*cap do ${fmartorell_home}top_program

set mem 1000m

log using ${d1}log/get_analysis_sample.log, replace



/* ----------------------------------------------------------------------------------------
First, extract the records from tspyr 190 and 191 (just ssn school, semester, ethnic, sex, bdate)
These records will be stacked with the "main" dataset to see if any recs in 192 or 193 have
matching records from 190 or 191 (these will be dropped as not being from first TSP record)
----------------------------------------------------------------------------------------- */

use altpid school sex ethnic bdate semester firstsem tspyr using ${d1}data/first_tasp_stack if tspyr<=191, clear
qui gen m_rep2=month(bdate)
qui gen y_rep2=year(bdate)
drop bdate
rename sex sex_rep2
rename ethnic ethnic_rep2
qui compress
save ${d1}tmp/temp, replace


/* ----------------------------------------------------------------------------------------
Next, create outcome variables, and stack datasets with limited set of variables that will
be used in the analysis
----------------------------------------------------------------------------------------- */
forvalues tspyr=192/200 {
cap log close
cap log using ${d1}log/get_analysis_sample.log, append
disp "Stacking tspyr=" `tspyr'

use ${d1}data/tasp_withde_outc_`tspyr', clear

*Drop all of the semester/year variables, and other unnecessary variables

cap drop first birthdat tempmax update pstudpid junk

*Drop the variables
cap drop newhg*
cap drop hgsr_* hgjr_*
cap drop tranup*

qui {
***********
*Years of college completed based on enrollment info from rep 1 and also acad. credits from report 2
***********

gen byte newhgsr=highgradesr-1+(srcredit_aftr_ac>=30) if highgradesr>1
replace newhgsr=(srcredit_ac>=30) if highgradesr==1 /* for those who never enrolled beyond fresh yr */
replace newhgsr=4 if highgradesr==5  /* treat bac degrees as completing 4 yrs of college */
gen byte newhgsr_gpa=highgradesr-1+(srcredit_aftr_ac_gpa>=30) if highgradesr>1
replace newhgsr_gpa=(srcredit_ac_gpa>=30) if highgradesr==1
replace newhgsr_gpa=4 if highgradesr==5


gen byte newhgjr=highgradejr-1+(jrcredit_aftr_ac>=30)
replace newhgjr=(jrcredit_ac>=30) if highgradejr==1
replace newhgjr=2 if highgradejr==4
gen byte newhgjr_gpa=highgradejr-1+(jrcredit_aftr_ac_gpa>=30)
replace newhgjr_gpa=(jrcredit_ac_gpa>=30) if highgradejr==1
replace newhgjr_gpa=2.5 if highgradejr==4

gen byte newhgsr15=highgradesr-1+(srcredit_aftr_ac>=15) if highgradesr>1
replace newhgsr15=(srcredit_ac>=15) if highgradesr==1 /* for those who never enrolled beyond fresh yr */
replace newhgsr15=4 if highgradesr==5  /* treat bac degrees as completing 4 yrs of college */
gen byte newhgsr15_gpa=highgradesr-1+(srcredit_aftr_ac_gpa>=15) if highgradesr>1
replace newhgsr15_gpa=(srcredit_ac_gpa>=15) if highgradesr==1
replace newhgsr15_gpa=4 if highgradesr==5


gen byte newhgjr15=highgradejr-1+(jrcredit_aftr_ac>=15)
replace newhgjr15=(jrcredit_ac>=15) if highgradejr==1
replace newhgjr15=2 if highgradejr==4
gen byte newhgjr15_gpa=highgradejr-1+(jrcredit_aftr_ac_gpa>=15)
replace newhgjr15_gpa=(jrcredit_ac_gpa>=15) if highgradejr==1
replace newhgjr15_gpa=2.5 if highgradejr==4

gen hgsr_sch=1*(srcredit_ac>=30 & srcredit_ac<60)+2*(srcredit_ac>=60 & srcredit_ac<90) /*
 */ + 3*(srcredit_ac>=90 & srcredit_ac<120) + 4*(srcredit_ac>=120 & srcredit_ac<.)
gen hgsr_sch_gpa=1*(srcredit_ac_gpa>=30 & srcredit_ac_gpa<60)+2*(srcredit_ac_gpa>=60 & srcredit_ac_gpa<90) /*
 */ + 3*(srcredit_ac_gpa>=90 & srcredit_ac_gpa<120) + 4*(srcredit_ac_gpa>=120 & srcredit_ac_gpa<.)
gen hgjr_sch=1*(jrcredit_ac>=30 & jrcredit_ac<60)+2*(jrcredit_ac>=60 & jrcredit_ac<.)
gen hgjr_sch_gpa=1*(jrcredit_ac_gpa>=30 & jrcredit_ac_gpa<60)+2*(jrcredit_ac_gpa>=60 & jrcredit_ac_gpa<.)

***********
* SCH in each year
***********

*Credit hours in each year: note, only do this for first semester since it's hard to know how to compute "first year" SCH if
*semester=5 and firstsem>1
forvalues i=0/4 { 
 qui gen srsch_yr`i'=0 if firstsem==1
 qui replace srsch_yr`i'=sch_0_1 if sr_0_1==1 & validmatch_r2_0_1==1 & firstsem==1
 forvalues sem=2/4 {
  cap replace srsch_yr`i'=srsch_yr`i'+sch_`i'_`sem' if sr_`i'_`sem'==1 & validmatch_r2_`i'_`sem'==1
 }
 cap replace srsch_yr`i'=srsch_yr`i'+sch_`i'_5 if sr_`i'_5==1 & validmatch_r2_`i'_5==1
}

qui gen sem1sch=sch_0_1 if /* validmatch_r2_0_1==1 & */ semester==1
forvalues i=2/4 {
 cap replace sem1sch=sch_0_`i' if /* validmatch_r2_0_`i'==1 & */ semester==`i'
}
cap replace sem1sch=sch_0_5 if /* validmatch_r2_0_5==1 & */ semester==5
gen sem1sch_fsem=sem1sch if firstsem==1
assert sem1sch!=.     /* Note: restricting to validmatch has a tiny # of missings due to processed rep. 2 files having different record */

forvalues i=0/2 { 
 qui gen jrsch_yr`i'=0 if firstsem==1
 qui replace jrsch_yr`i'=sch_0_1 if sr_0_1==0 & validmatch_r2_0_1==1 & firstsem==1
 forvalues sem=2/4 {
  cap replace jrsch_yr`i'=jrsch_yr`i'+sch_`i'_`sem' if sr_`i'_`sem'==0 & validmatch_r2_`i'_`sem'==1
 }
 cap replace jrsch_yr`i'=jrsch_yr`i'+sch_`i'_5 if sr_`i'_5==0 & validmatch_r2_`i'_5==1
}
	*** Note: some observations will have 0 sch in yr0, but >0 sem1sch due to sr_`i'_`sem' condition ***

*********
*Number of semesters enrolled
*********
gen numsems=0
forvalues y=0/5 {
 forvalues sem=1/3 {
  *gen credits_`y'_`sem'=(max(jrtotcredit_`y'_`sem'*jrvalidmatch_r1_`y'_`sem',srtotcredit_`y'_`sem'*srvalidmatch_r1_`y'_`sem'))*((`y'==0 & `sem'>=firstsem) | (`y'>0 & `y'<5) | (`y'==5 & `sem'<firstsem))
  replace numsems=numsems+(max(jrtotcredit_`y'_`sem'*jrvalidmatch_r1_`y'_`sem',srtotcredit_`y'_`sem'*srvalidmatch_r1_`y'_`sem')>3) /* 
       */	if (`y'==0 & `sem'>=firstsem) | (`y'>0 & `y'<5) | (`y'==5 & `sem'<firstsem)
 }
 replace numsems=numsems+((jrtotcredit_`y'_4*jrvalidmatch_r1_`y'_4)>3)
  *gen credits_`y'_4=(jrtotcredit_`y'_4*jrvalidmatch_r1_`y'_4)*((`y'==0 & 4>=firstsem) | (`y'>0 & `y'<5) | (`y'==5 & 4<firstsem))

}


*******
*Transfer up
*******



gen byte oldtranup=srcredit_ac>=15 if jr==1
gen byte oldtranup_gpa=srcredit_ac_gpa>=15 if jr==1

*NOTE: for 
if `tspyr'==200 {
 forvalues sem=1/4 {
  gen byte jrtotcredit_6_`sem'=0
  gen byte jrvalidmatch_r1_6_`sem'=0
  gen byte srtotcredit_6_`sem'=0
  gen byte srvalidmatch_r1_6_`sem'=0
 }
}
forvalues i=0/6 {
 forvalues sem=1/4 {
  gen byte oldjrtotcredit_`i'_`sem'=jrtotcredit_`i'_`sem'
  gen byte oldjrvalidmatch_r1_`i'_`sem'=jrvalidmatch_r1_`i'_`sem'
 }
}
forvalues i=0/6 {
 qui replace jrtotcredit_`i'_3=jrtotcredit_`i'_3+jrtotcredit_`i'_4
 qui replace jrvalidmatch_r1_`i'_3=jrvalidmatch_r1_`i'_3==1 | jrvalidmatch_r1_`i'_4==1
}
gen byte tranup=0 if sr==0
forvalues i=0/6 {
 forvalues sem=1/3 {
 qui replace tranup=(srtotcredit_`i'_`sem'>jrtotcredit_`i'_`sem' & srtotcredit_`i'_`sem'>3) if sr==0 & (srvalidmatch_r1_`i'_`sem'==1 | jrvalidmatch_r1_`i'_`sem'==1)  & ((`i'==0 & `sem'>=firstsem) | /*
  */ (`i'>0 & `i'<6) | (`i'==6 & `sem'<firstsem))
 }
}
gen byte trandwn=0 if sr==1
forvalues i=0/6 {
 forvalues sem=1/3 {
 qui replace trandwn=(jrtotcredit_`i'_`sem'>srtotcredit_`i'_`sem' & jrtotcredit_`i'_`sem'>3) if sr==1 & (jrvalidmatch_r1_`i'_`sem'==1 | srvalidmatch_r1_`i'_`sem'==1) & ((`i'==0 & `sem'>=firstsem) | /*
  */ (`i'>0 & `i'<6) | (`i'==6 & `sem'<firstsem))
 }
}

*********
*Graduation variables
*********
*For tspyr=200, there is no validmatch_r9_*_6 variable
cap gen byte validmatch_r9_sr_6=0
cap gen byte validmatch_r9_jr_6=0

gen byte srgrwin1=bac_0*(validmatch_r9_sr_0==1) if firstsem==1
replace srgrwin1=((bac_1*(validmatch_r9_sr_1==1)+bac_0*(validmatch_r9_sr_0==1))>0) if firstsem>1
gen byte jrgrwin1=assoc_0*(validmatch_r9_jr_0==1) if firstsem==1
replace jrgrwin1=((assoc_1*(validmatch_r9_jr_1==1)+assoc_0*(validmatch_r9_jr_0==1))>0) if firstsem>1

forvalues i=2/6 {
 local im1=`i'-1
 qui {
  gen byte srgrwin`i'=(srgrwin`im1'==1) | (bac_`im1'==1 & validmatch_r9_sr_`im1'==1) if firstsem==1
  replace srgrwin`i'=(srgrwin`im1'==1) | ((bac_`i'*(validmatch_r9_sr_`i'==1)+bac_`im1'*(validmatch_r9_sr_`im1'==1))>0) if firstsem>1
  gen byte jrgrwin`i'=(jrgrwin`im1'==1) | (assoc_`im1'==1 & validmatch_r9_jr_`im1'==1) if firstsem==1
  replace jrgrwin`i'=(jrgrwin`im1'==1) | ((assoc_`i'*(validmatch_r9_jr_`i'==1)+assoc_`im1'*(validmatch_r9_jr_`im1'==1))>0) if firstsem>1
 }
}

************
*Graduation intention (possibly endogenous to whether 
************
gen byte seekdegree=inlist(objectiv,3,4)==1
gen byte seekdeg_undec=inlist(objectiv,3,4,5)==1

************
*Get initial type
************
gen initsrtype=.
gen initjrtype=.
forvalues i=1/3 {
 qui replace initsrtype=srtype_0_`i' if firstsem==`i'
 qui replace initjrtype=jrtype_0_`i' if firstsem==`i'
}
qui replace initjrtype=jrtype_0_4 if firstsem==4
}

*************************
* Select keep variables, stack all of the years of data together
*************************
keep sr school altpid firstsem fyear objectiv teststat- ethnic_rep2 /* 
*/ tspyr mathsems- writscor frectasp fgrade flex taspexem- gr1read num admindate_y1-jrcredit_nosem5_ac_gpa /*
*/ srvalidmatch_r1_0_* jrvalidmatch_r1_0_* newhgsr-jrgrwin6 assoc_5-bac_8 seekdeg* orig_sch initsrtype initjrtype /*
*/ *scode rawred rawmth admin taasyear srsch_yr* jrsch_yr* sem1sch sem1sch_fsem numsems passcollmath fgrademath oldtranup oldtranup_gpa trandwn
confirm var tranup 

qui compress
/* if `tspyr'>192 {
 qui append using ${fmartorell_home}remediation/data/tasp192_200_withall
}
qui compress
save ${fmartorell_home}remediation/data/tasp192_200_withall, replace
*/
save ${d1}tmp/anlsmp_`tspyr', replace
}

cap log close
log using ${d1}log/get_analysis_sample.log, append

/* ----------------------------------------------------------------------------------------
Now get the first student record in the report 2 files (so if someone transfers schools, we get 
the first record)
----------------------------------------------------------------------------------------- */

use ${d1}tmp/anlsmp_192, clear
forvalues year=193/200 {
 disp "Stack `year'"
 append using ${d1}tmp/anlsmp_`year'
}

*stack the 190 and 191 records
append using ${d1}tmp/temp
cap log close
log using ${d1}log/get_analysis_sample.log, append

bysort altpid tspyr firstsem seekdegree orig_sch sr school: assert _N==1

bysort altpid: gen numrecs=_N
egen tag=tag(altpid) if tspyr>=192
tab numrecs if tag==1 & tspyr>=192

*sort where first record is the based on time
gsort altpid tspyr firstsem -seekdegree  -orig_sch  sr school
by altpid: gen byte frstrec_time=_n==1
tab numrecs sr if frstrec_time==1 & tspyr>=192
tab numrecs seekdegree if frstrec_time==1 & tspyr>=192

*sort where degree seeking takes precedence over time
gsort altpid -seekdeg_undec tspyr firstsem  -orig_sch  sr school
by altpid: gen byte  frstrec_degsk=_n==1
tab numrecs sr if frstrec_degsk==1 & tspyr>=192
tab numrecs seekdegree if frstrec_degsk==1 & tspyr>=192


gen byte frstrecagree=frstrec_time==frstrec_degsk if (frstrec_time==1 | frstrec_degsk==1)
egen sumagree=sum(frstrecagree), by(altpid)
assert sumagree<2

tab sumagree if numrecs>1 & tag==1 & tspyr>=192

drop if tspyr<192
keep if frstrec_time==1

/* ----------------------------------------------------------------------------------------
Merge HS variables
----------------------------------------------------------------------------------------- */
sort altpid
cap drop _merge
merge altpid using ${d1}data/uniqenroll, unique nokeep keep(ethnic sex bthday lep econ_dis atrisk title1 gifted)
tab _merge
gen hsmatch=_merge==3 & ((ethnic_rep2==ethnic)+ (sex==sex_rep2)+((year(bthday)==y_rep2)+(month(bthday)==m_rep2)))>=2
drop _merge
drop sex ethnic bthday 
* save the intermediate data that will be used by Isaac's two do files below. 
save ${d1}data/tasp192_200_withall_tmp.dta, replace 

/* ----------------------------------------------------------------------------------------------
Get the datasets Isaac created and prepare data to merge with "main" data file
----------------------------------------------------------------------------------------------- */

* note: Isaac's original datasets had some variables from an earlier version of the main dataset that were later changed. ///
/// But, when Isaacs's datasets were merged to creat the main dataset, the variables in question were not used.
do ${d1}do/distance_subgroup.do
do ${d1}do/tuitionsubgroup_041807.do
 
cap log close
cap log using ${d1}log/get_analysis_sample.log, append
 
/* Tuition status: from Isaac's program tuitionsubgroup_041807.do */
use altpid tutstat sr using ${d1}data/new/tasp_jr_tuition_192_200.dta, clear
gen byte indist=tutstat==1 if tutstat!=.
summ indist
bysort altpid: assert _N==1
assert sr==0
drop sr
save ${d1}data/tutstat, replace

/* Distance: from Isaac's program distance_subgroup.do */
use altpid distance campus vm_dist using ${d1}data/new/tasp192_200_withall_isaac.dta, clear
*Create distance flags (the variables on the file are always non-missing. Here set them to=. 
*if distance variable=. (NOTE: distance only computed for HS open in 1998 or later!!)
gen byte distless25=distance<=25 if distance<.
gen byte distmore25=1-distless25
gen byte distmore50=distance>=50 if distance<.
bysort altpid: assert _N==1
save ${d1}data/distance, replace




/* Now Merge the data together */
* load the datasets tasp192_200_withall.dta
use ${d1}data/tasp192_200_withall_tmp.dta, clear 
cap drop _merge
sort altpid
merge altpid using ${d1}data/distance, unique
assert _merge==3
drop _merge
sort altpid

cap drop _merge
merge altpid using  ${d1}data/tutstat, unique
assert _merge==3 if sr==0
replace indist=1 if sr==1
drop _merge


*Saving dataset
save ${d1}data/tasp192_200_withall, replace

forvalues year=192/200 {
!rm ${d1}tmp/anlsmp_`year'.dta
}




log close 
