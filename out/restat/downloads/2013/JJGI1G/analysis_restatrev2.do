!date

cap log close
clear
program drop _all
set linesize 155

*global fmartorell_home="/mnt/data/tsp/users/fmartorell/"
*cap do ${fmartorell_home}top_program
global d1="${col_remediation}program/program_paco/publication/"
do ${d1}do/top_program.do

set mem 1000m
*log using ${fmartorell_home}remediation/programs/analysis.log, replace

/* ------------------------------------------------------------------------------------------ 
Create variables for attendance in next semester 
--------------------------------------------------------------------------------------------- */

*use semester firstsem sr srvalid* jrvalid* altpid school tspyr using  ${fmartorell_home}/remediation/data/tasp_withde_outc_192, clear
use semester firstsem sr srvalid* jrvalid* altpid school tspyr using  ${d1}data/tasp_withde_outc_192, clear
forvalues y=193/200 {
 *qui append using  ${fmartorell_home}/remediation/data/tasp_withde_outc_`y', keep(semester firstsem sr srvalid* jrvalid* altpid school tspyr)
 qui append using  ${d1}data/tasp_withde_outc_`y', keep(semester firstsem sr srvalid* jrvalid* altpid school tspyr)
} 
*Create empty variable for sr sem 4 
forvalues y=0/6 {
 gen byte srvalidmatch_r1_`y'_4=0
}
gen attendnextsem=srvalidmatch_r1_0_2==1 | jrvalidmatch_r1_0_2==1 if firstsem==1
replace attendnextsem=srvalidmatch_r1_0_3==1 | jrvalidmatch_r1_0_3==1 | /// 
   jrvalidmatch_r1_0_4==1 | srvalidmatch_r1_1_1==1 | jrvalidmatch_r1_1_1==1 if firstsem==2
replace attendnextsem=jrvalidmatch_r1_0_4==1 | srvalidmatch_r1_1_1==1 | jrvalidmatch_r1_1_1==1 if firstsem==3
replace attendnextsem=srvalidmatch_r1_1_1==1 | jrvalidmatch_r1_1_1==1 if firstsem==4
tab attendnextsem sr, missing

gen attend_yr1to5=0
forvalues y=1/5 {
 foreach sr in sr jr {
  forvalues sem=1/3 {
   qui replace attend_yr1to5=attend_yr1to5==1 | (`sr'validmatch_r1_`y'_`sem'==1)
  }
 }
 replace attend_yr1to5=attend_yr1to5==1 | (jrvalidmatch_r1_`y'_4==1)
}
gen attendaftfsem=attend_yr1to5
foreach sr in sr jr {
 qui {
 replace attendaftfsem=1 if (`sr'validmatch_r1_0_2==1 | `sr'validmatch_r1_0_3==1 | `sr'validmatch_r1_0_4==1) & firstsem==1
 replace attendaftfsem=1 if (`sr'validmatch_r1_0_3==1 | `sr'validmatch_r1_0_4==1 | `sr'validmatch_r1_6_1==1) & firstsem==2
 replace attendaftfsem=1 if (`sr'validmatch_r1_0_4==1 | `sr'validmatch_r1_6_1==1 | `sr'validmatch_r1_6_2==1) & firstsem==3
 replace attendaftfsem=1 if (`sr'validmatch_r1_6_1==1 | `sr'validmatch_r1_6_2==1 | `sr'validmatch_r1_6_3==1) & firstsem==4
 }
}
tab attendaftfsem sr , missing
assert attendaftfsem==1 if attendnextsem==1
keep altpid school attendaftfsem attendnextsem tspyr
bysort altpid school tspyr: assert _N==1
*save ${fmartorell_home}remediation/data/attend_vars, replace
save ${d1}data/attend_vars, replace

/* ----------------------------------------------------------------------------------------------
Start main program here
----------------------------------------------------------------------------------------------- */

*use ${fmartorell_home}remediation/data/tasp192_200_withall, clear
use ${d1}data/tasp192_200_withall, clear
*keep if uniform()<.005
sort altpid school tspyr
*merge altpid school tspyr using ${fmartorell_home}remediation/data/attend_vars, unique nokeep 
merge altpid school tspyr using ${d1}data/attend_vars, unique nokeep 
assert _merge==3

drop _merge
sort altpid 

/*
merge altpid using ${fmartorell_home}/act_sat/data/act_sat_all, unique nokeep keep(satmath satverbal sumsat_new)
rename _merge sat_merge
*/
gen etest=admindate_y1<=1994 | (admindate_y1==1995 & admindate_m1<=8)



/* ----------------------------------------------------------------------------------------------
Create covariates and final outcome variables
----------------------------------------------------------------------------------------------- */


*Variables for dropping out after first semester 
gen byte inreport1=0
forvalues sem=1/4 {
 qui replace inreport1=1 if firstsem==`sem' & sr==0 & oldjrvalidmatch_r1_0_`sem'==1
 cap replace inreport1=1 if firstsem==`sem' & sr==1 & srvalidmatch_r1_0_`sem'==1
}
tab inreport1
forvalues sem=1/4 {
 cap replace inreport1=1 if firstsem==`sem' & oldjrvalidmatch_r1_0_`sem'==1 | srvalidmatch_r1_0_`sem'==1
}
tab inreport1
assert oldjrvalidmatch_r1_0_4==jrvalidmatch_r1_0_4


*Distance and tuition variables
gen byte distmiss=distance==.
gen byte distl25nm=distless25
replace distl25nm=0 if distl25nm==.
gen byte distm50nm=distmore50
replace distm50nm=0 if distm50nm==.

gen byte tutmiss=indist==.
gen indistnm=indist
replace indistnm=0 if indistnm==.

*% remediated variables
egen avgremed=mean(anydeved_2sem), by(school year)
cap drop tag
egen tag=tag(school year) if win1sem==1

gen highremed=.
gen lowremed=.
gen highremed_sch=.
gen lowremed_sch=.

forvalues year=192/200{
qui summ avgremed if win1sem==1 & sr==1 & year==`year', d
qui replace highremed=avgremed>r(p75) if sr==1 & win1sem==1 & year==`year'
qui replace lowremed=avgremed<r(p25) if sr==1 & win1sem==1 & year==`year'
qui summ avgremed if win1sem==1 & sr==0 & win1sem==1 & year==`year', d
qui replace highremed=avgremed>r(p75) if sr==0 & win1sem==1 & year==`year'
qui replace lowremed=avgremed<r(p25) if sr==0 & win1sem==1 & year==`year'

qui summ avgremed if win1sem==1 & sr==1 & year==`year' & tag==1, d
qui replace highremed_sch=avgremed>r(p75) if sr==1 & win1sem==1 & year==`year' 
qui replace lowremed_sc=avgremed<r(p25) if sr==1 & win1sem==1 & year==`year' 
qui summ avgremed if win1sem==1 & sr==0 & win1sem==1 & year==`year' & tag==1, d
qui replace highremed_sc=avgremed>r(p75) if sr==0 & win1sem==1 & year==`year' 
qui replace lowremed_sc=avgremed<r(p25) if sr==0 & win1sem==1 & year==`year'
}

summ highremed* lowremed* if sr==1 & win1sem==1 
summ highremed* lowremed* if sr==0 & win1sem==1 


gen byte white=ethnic_rep2==5
gen byte hisp=ethnic_rep2==4
gen byte black=ethnic_rep2==3
gen nonwhite=hisp==1 | black==1 /* not really nonwhite since NA and A not included */


gen byte startfall=firstsem==1

gen byte seekbac=objectiv==4

gen byte passwrit=rsc_writ>=0  

gen byte idis=indist
gen byte odis=1-indist
gen byte l25=distless25
gen byte m50=distmore50
replace odis=1 if sr==1  /* so that the program runs */
gen byte nw=nonwhite
gen byte pwrt=passwrit
gen byte ec=econ_dis

gen byte female=sex_rep2==0
gen byte male=sex_rep2==1

gen ltest=1-etest


gen byte maxnewhg=max(newhgjr,newhgsr)
forvalues i=1/4 {
 gen byte newhgsr`i'=(newhgsr>=`i')
 gen byte maxnewhg`i'=(maxnewhg>=`i')
}
gen byte newhgjr1=newhgjr>=1
gen byte newhgjr2=newhgjr>=2

gen byte oldtrandwn=jrcredit_ac>=15 if sr==1
gen byte oldtrandwn_gpa=jrcredit_ac_gpa>=15 if sr==1
rename oldtranup_gpa tranup_gpa

gen byte agefirstenr=(round((((tspyr-1+1800)*12+9)-(y_rep2*12+m_rep2))/12)) if firstsem==1
replace agefirstenr=(round((((tspyr+1800)*12+9)-(y_rep2*12+m_rep2))/12)) if firstsem!=1
gen byte nontradage=agefirstenr>=21 if agefirstenr<.
gen byte old=nontradage 

gen byte all=1

gen acadyr_nes=admindate_y1 if admindate_m1<=8
replace acadyr_nes=admindate_y1+1 if admindate_m1>=9
replace acadyr_nes=1991 if acadyr_nes<1991
tab acadyr_nes
forvalues y=1992/2000 {
 gen dacyr`y'=acadyr_nes==`y'
}

gen byte acadterm=1*inlist(admindate_m1,9,10,11,12)+2*inlist(admindate_m1,1,2,3,4,5)+3*inlist(admindate_m1,6,7,8)
gen byte diff=(tspyr+1800-acadyr_nes)*3+(firstsem-acadterm) 
gen byte delay2=diff>=2
gen byte delay1=diff>=2


replace rawmth=. if mscode!="S"
replace rawred=. if rscode!="S"

gen byte fgrmth_cndl=fgrademath if inlist(fgrademath,1,2,3,4,5)==1
count if fgrmth_cndl==.
replace fgrmth_cndl=5-fgrmth_cndl  /* so that A=4, B=3, etc */
gen byte attemptmath=fgrademath!=.

count if sem1sch!=orig_sch

gen rsc_hgh=max(rsc_math,rsc_read)

gen misecon=econ_dis==.
replace econ_dis=econ_dis>0
replace econ_dis=0 if misecon==1
summ econ_dis

forvalues y=192/199 {
 gen byte d`y'=tspyr==`y'
}

gen early=tspyr<=195
gen byte late=early==0

gen maxcredit_ac=max(srcredit_ac,jrcredit_ac)
gen sumcredit_ac=srcredit_ac+jrcredit_ac
gen maxcredit_gpa=max(srcredit_ac_gpa,jrcredit_ac_gpa)
gen sumcredit_gpa=srcredit_ac_gpa+jrcredit_ac_gpa

gen byte srjrgrwin4=srgrwin4==1 | jrgrwin4==1
gen byte srjrgrwin5=srgrwin5==1 | jrgrwin5==1
gen byte srjrgrwin6=srgrwin6==1 | jrgrwin6==1

global m="rsc_math"
global r="rsc_read"
global any="minscore"
global anyr="minscore"
global anym="minscore"


/* --------------------------------------------------------------------------------------------------
Sample selection
-------------------------------------------------------------------------------------------------- */
count

*Drop records where student not initially a freshman
gen freshman=initsrtype==1 if sr==1 & initsrtype<.
replace freshman=initjrtype==1 if sr==0 & initjrtype<.
tab freshman sr, missing
keep if freshman==1

*Drop observations with missing data
keep if ethnic_rep2!=. & sr!=. & nontradage!=. 

count

*Drop students who accoring to report2 are exempt from the TASP requirements
keep if notexempt==1

*Drop records that don't match to NES
tab nes_match sr, missing row col
keep if nes_match==1

*Drop students who didn't take the TASP win 1 semester of starting college
keep if win1sem==1
summ diff, detail

*Drop records where the math or reading score is not valid
keep if (rsc_math>=-130 & rsc_math<=80) & (rsc_read>=-130 & rsc_read<=80)


*Identify analysis samples

gen byte allvalid=(rsc_math>=-130 & rsc_math<=80) & (rsc_read>=-130 & rsc_read<=80) & (rsc_writ>=-130 & rsc_writ<=80)
gen minscore=min(rsc_math,rsc_read)

gen byte anysample=allvalid==1 & rsc_writ>=0  
gen byte anymsample=anysample==1 & minscore==rsc_math
gen byte anyrsample=anysample==1 & minscore==rsc_read /* note: there will be some overlap between m and r */

gen byte msample=(rsc_math>=-130 & rsc_math<=80)
gen byte rsample=(rsc_read>=-130 & rsc_read<=80)
gen byte wsample=(rsc_writ>=-130 & rsc_writ<=80)


gen rsc_any=minscore

keep if (seekdeg_undec ==1 & sr==0) | (seekbac==1 & sr==1)
   *** See analysis_revision.do (revision for AEJ) for estimates that don't make this restriction ***
   *** Also, see this for tests that degree seeking endogenous, sr/jr endogenous ***

/*
/* --------------------------------------------------------------------------------
Generate probability of graduation conditional on X for validity test
---------------------------------------------------------------------------------- */
cap drop pass
foreach test in m r w any {
 cap drop x x2 x3 inter inter2 inter3 pass
 gen x=rsc_`test'
 gen x2=x*x
 gen x3=x*x*x
 gen pass=x>=0
 gen inter=pass*x
 gen inter2=pass*x2
 gen inter3=pass*x3
 if "`test'"=="m" { 
   local opp="rsc_r"
 }
 else if "`test'"=="r" | "`test'"=="w" {
   local opp="rsc_m"
 }
 else if "`test'"=="any" {
   local opp="rsc_h"
 }
 qui probit srjrgrwin6 `opp' $covs if `test'sample==1 & x>=-100 & sr==0
 qui predict gradhat_sr0_`test' if e(sample)==1
 qui probit srgrwin6 `opp' $covs if `test'sample==1 & x>=-100 & sr==1
 qui predict gradhat_sr1_`test' if e(sample)==1
}
*/

*save ${fmartorell_home}/tmp/tmp3, replace
save ${d1}tmp/tmp3, replace

*use ${fmartorell_home}/tmp/tmp3, clear 
use ${d1}tmp/tmp3, clear 
*keep if uniform()<.05

/* -----------------------------------------------------------------------------------------
Set globals with lists of variables
------------------------------------------------------------------------------------------- */

*variables to test validity
global val="startfall white nontradage rsc_math rsc_read rsc_hgh econ_dis misecon early delay1 delay2 distmiss distl25nm distm50nm indistnm"

*Variables to send through RD for sr colleges
global sr1list1="srsch_yr0 sumcredit_ac"
global sr1list2="maxnewhg1 maxnewhg2 maxnewhg3 maxnewhg4 trandwn srgrwin4 srgrwin5 srgrwin6"

*Variables to send through RD for jr colleges
global sr0list1="srsch_yr0 jrsch_yr0 sumcredit_ac"
global sr0list2="maxnewhg1 maxnewhg2 maxnewhg3 maxnewhg4 tranup srjrgrwin4-srjrgrwin6"

*Variables to send through RD for sr colleges
global sr1list1_sub="srsch_yr0  sumcredit_ac"
global sr1list2_sub="maxnewhg1 maxnewhg2 maxnewhg3 maxnewhg4 trandwn srgrwin4 srgrwin5 srgrwin6"

*Variables to send through RD for jr colleges
global sr0list1_sub="srsch_yr0 jrsch_yr0 sumcredit_ac"
global sr0list2_sub="maxnewhg1 maxnewhg2 maxnewhg3 maxnewhg4 tranup srjrgrwin4-srjrgrwin6"


*global sr0list="anydeved_2sem"

/*
global val="white" 

global sr1list1="anydeved_2sem"
global sr1list2="trandwn"

*Variables to send through RD for jr colleges
global sr0list1="anydeved_2sem"
global sr0list2="tranup"


global sr1list1_sub="anydeved_2sem"
global sr1list2_sub="trandwn"

*Variables to send through RD for jr colleges
global sr0list1_sub="anydeved_2sem"
global sr0list2_sub="tranup"
*/

*Covariates for all regressions
global covs="distmiss distl25nm distm50nm indistnm white hisp startfall nontradage d192-d199 econ_dis misecon dacyr1992-dacyr2000 delay2"

*List of subgroups
global sublist="male female l25 m50 nw ec old pwrt highremed lowremed etest ltest"
*global sublist="male"
d $sublist

/* ---------------------------------------------------------------------------------
Create variables for 2 endog regressors
----------------------------------------------------------------------------------- */

foreach test in m r {
 gen x_`test'=rsc_`test'
 gen x2_`test'=(x_`test')^2
 gen x3_`test'=(x_`test')^3
 gen pass_`test'=x_`test'>=0
 gen inter_`test'=x_`test'*pass_`test'
 gen inter2_`test'=x2_`test'*pass_`test'
 gen inter3_`test'=x3_`test'*pass_`test'
}

d x_r
egen x_r_m=group(x_r x_m)

/* -----------------------------------------------------------------------
Run regressions
-------------------------------------------------------------------------- */

tempname main multiv
*postfile `main' str20 subsample str10 band str5 control sr str5 sample str5 est str50 outc beta se numobs using ${fmartorell_home}remediation/results/mainbeta, replace
*postfile `multiv' str20 subsample str10 band str5 control sr str5 sample str5 est str50 outc beta_m se_m beta_r se_r numobs using ${fmartorell_home}remediation/results/multivbeta, replace
postfile `main' str20 subsample str10 band str5 control sr str5 sample str5 est str50 outc beta se numobs using ${d1}results/mainbeta, replace
postfile `multiv' str20 subsample str10 band str5 control sr str5 sample str5 est str50 outc beta_m se_m beta_r se_r numobs using ${d1}results/multivbeta, replace

foreach subsample in all $sublist {

if "`subsample'"=="all" {
 global suff=""
}
else {
 global suff="_sub"
}
*disp "${sr0list1${suff}}"
foreach band in global narrow {
 local low=-100*("`band'"=="global") + -10*("`band'"=="narrow")
 local hi=80*("`band'"=="global") + 10*("`band'"=="narrow")
 if "`band'"=="narrow" {
   local polyn="x inter"
   local polyn2="x_r inter_r x_m inter_m"
 }
 else {
   local polyn="x x2 x3 inter inter2 inter3"
   local polyn_w="x inter"
   local polyn2="x_r x2_r x3_r inter_r inter2_r inter3_r x_m x2_m x3_m inter_m inter2_m inter3_m"
 }

  disp "`subsample' `band'"
 *Generate predicted graduation for validity tests
 if "`subsample'"=="all" {
 cap drop gradhat*
  

 foreach test in m r w any {
  cap drop x
  gen x=rsc_`test'
  if "`test'"=="m" { 
    local opp="rsc_r"
  }
  else if "`test'"=="r" | "`test'"=="w" {
    local opp="rsc_m"
  }
  else if "`test'"=="any" {
    local opp="rsc_h"
  }
  qui probit srjrgrwin6 `opp' $covs if `test'sample==1 & inrange(x,-100,80) & sr==0
  qui predict gradhat_sr0_`test' if e(sample)==1
  qui probit srgrwin6 `opp' $covs if `test'sample==1 & inrange(x,-100,80) & sr==1
  qui predict gradhat_sr1_`test' if e(sample)==1
 }
 }
 cap drop x
 
 
 foreach control in nc c {
  disp "`control'"
  *d x*
  forvalues sr=0/1 {
   cap drop x
   cap drop x2
   cap drop x3
   cap drop pass 
   cap drop inter inter2 inter3

   if "`band'"=="narrow" {
     local t="m r any"
   }
   else {
     local t="any m r w"
   }

   foreach sample in  `t'    {
    if "`sample'"=="w" {
       local tsuff="_w"
    }
    else {
       local tsuff=""
    }
    *disp "`polyn`tsuff''"
    cap drop covscore endog
    cap drop x x2 x3 pass inter inter2 inter3 
    if "`sample'"=="any" | "`sample'"=="anyr" | "`sample'"=="anym" {
     gen x=min(rsc_math,rsc_read)
     gen covscore=max(rsc_math,rsc_read)
     gen endog=anydeved_2sem
    }
    else if "`sample'"=="m" {
     gen x=rsc_math
     gen covscore=rsc_read
     gen endog=demath_2sem
    }
    else if "`sample'"=="r" {
     gen x=rsc_read
     gen covscore=rsc_math
     gen endog=deread_2sem
    }
    else if "`sample'"=="w" {
     gen x=rsc_writ
     gen covscore=rsc_math
     gen endog=dewrit_2sem
    }
    gen x2=x^2
    gen x3=x^3
    gen pass=x>=0
    gen inter=pass*x
    gen inter2=pass*x2
    gen inter3=pass*x3

    
    foreach est in rf iv {


     * SPECIFY LIST OF VARIABLES (ONLY INCLUDE VALIDITY WITH RF, NO CONTROL SPEC) *
     if "`est'"=="rf" & ("`subsample'"=="all") & "`control'"=="nc" {
      global extras="de*_*sem anydeved anydeved_2sem ${val} gradhat_sr`sr'_`sample'"
     }
     if "`est'"=="rf" & ("`subsample'"=="all") & "`control'"=="c" {
      global extras="de*_*sem anydeved anydeved_2sem"
     }
     if "`est'"=="rf" & ("`subsample'"!="all") {
       global extras="de*_*sem anydeved anydeved_2sem"
     }
     if "`est'"!="rf" | ("`subsample'"!="all") {
       global extras="de*_*sem anydeved anydeved_2sem"
     }
    
     foreach outc of varlist ${sr`sr'list1${suff}} ${sr`sr'list2${suff}} $extras {

	****** REGRESSIONS WITH NO CONTROLS *******
        if "`control'"=="nc" {
          if "`est'"=="rf" {
	    qui reg `outc' pass `polyn`tsuff''  if `sample'sample==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
          else if "`est'"=="iv" {
	    qui ivreg `outc' (endog=pass `polyn`tsuff'') `polyn`tsuff''  if `sample'sample==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
        }    /* CLOSE NO CONTROLS SPECIFICATION */

        ******* REGRESSIONS WITH CONTROLS *******
        else {
          if "`est'"=="rf" {
	    qui reg `outc' pass `polyn`tsuff'' covscore $covs if `sample'sample==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
          else if "`est'"=="iv" {
	    qui ivreg `outc' (endog=pass `polyn`tsuff'') `polyn`tsuff'' covscore $covs if `sample'sample==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
        }
	if "`est'"=="rf" {
	  local b=_b[pass]
	  local sterr=_se[pass]
	}
	else {
	  local b=_b[endog]
	  local sterr=_se[endog]
	}
	local n=e(N)
        post `main' ("`subsample'") ("`band'")  ("`control'") (`sr') ("`sample'") ("`est'") ("`outc'") (`b') (`sterr') (`n')

      }   /* CLOSE OUTCOME LIST */

    } /* CLOSE IV/RF LIST */

    global extras="de*_*sem anydeved anydeved_2sem ${val} gradhat_sr`sr'_`sample'"    
    if "`subsample'"=="all" & "`band'"=="global"  & "`control'"=="nc" & `sr'==0 {
     preserve
       collapse ${sr`sr'list1} ${sr`sr'list2} $extras (count) n=anydeved_2sem nfsem=sem1sch_fsem , by(x sr)
       gen sample="`sample'"
       *saveold ${fmartorell_home}/remediation/results/clps_main_`sample', replace
       saveold ${d1}results/clps_main_`sample', replace
   restore
     preserve 
       collapse ${sr`sr'list1} ${sr`sr'list2} $extras (count) n=anydeved_2sem nfsem=sem1sch_fsem , by(sr)
       gen sample="`sample'"
       *saveold ${fmartorell_home}/remediation/results/means_main_`sample', replace
       saveold ${d1}results/means_main_`sample', replace
     restore
     preserve
       collapse ${sr`sr'list1} ${sr`sr'list2} $extras (count) n=anydeved_2sem nfsem=sem1sch_fsem , by(sr pass)
       gen sample="`sample'"
       *saveold ${fmartorell_home}/remediation/results/meansbypass_main_`sample', replace
       saveold ${d1}results/meansbypass_main_`sample', replace
     restore
     preserve 
       collapse (sd) ${sr`sr'list1} ${sr`sr'list2} $extras, by(sr)
       gen sample="`sample'"
       *saveold ${fmartorell_home}/remediation/results/sd_main_`sample', replace
       saveold ${d1}results/sd_main_`sample', replace
     restore
     preserve
       collapse (sd) ${sr`sr'list1} ${sr`sr'list2} $extras, by(sr pass)
       gen sample="`sample'"
       *saveold ${fmartorell_home}/remediation/results/sdbypass_main_`sample', replace
       saveold ${d1}results/sdbypass_main_`sample', replace
     restore
    }

   } /* CLOSE SAMPLE LOOP */

      foreach outc of varlist ${sr`sr'list1${suff}} ${sr`sr'list2${suff}} {
	****** IV WITH MATH AND READING IN SAME REGRESSION *******
	if "`control'"=="nc" {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r)
	    mat v_r=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_m)
	    mat v_m=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r_m)
	    mat v_m_r=e(V)
	    mat v2way=v_r+v_m-v_m_r
	    mat varbetam=v2way["demath_2sem","demath_2sem"]
	    mat varbetar=v2way["deread_2sem","deread_2sem"]
	    local varbetam=varbetam[1,1]
	    local varbetar=varbetar[1,1]
	}    /* CLOSE NO CONTROLS SPECIFICATION */

	******* REGRESSIONS WITH CONTROLS *******
        else {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r)
	    mat v_r=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_m)
	    mat v_m=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r_m)
	    mat v_m_r=e(V)
	    mat v2way=v_r+v_m-v_m_r
	    mat varbetam=v2way["demath_2sem","demath_2sem"]
	    mat varbetar=v2way["deread_2sem","deread_2sem"]
	    local varbetam=varbetam[1,1]
	    local varbetar=varbetar[1,1]	
	}

	 local b_r=_b[deread_2sem]
	 local se_r=sqrt(`varbetar')
	 local b_m=_b[demath_2sem]
	 local se_m=sqrt(`varbetam')
         local n=e(N)

        post `multiv' ("`subsample'") ("`band'")  ("`control'") (`sr') ("twoendog") ("iv") ("`outc'") (`b_m') (`se_m') (`b_r') (`se_r') (`n')
      }

  }  /* CLOSE SR LOOP */ 
 
 }   /* CLOSE CONTROL/NC LOOP */
 
} /* CLOSE BAND LOOP */
!date
}  /* CLOSE SUBSAMPLE LOOP */

postclose `main' 
postclose `multiv'


*use ${fmartorell_home}remediation/results/means_main_any, clear
*append using ${fmartorell_home}remediation/results/sd_main_any
use ${d1}results/means_main_any, clear
append using ${d1}results/sd_main_any


foreach f in means sd meansbypass sdbypass {
 foreach test in m r w { 
   
   *append using ${fmartorell_home}remediation/results/`f'_main_`test'
   append using ${d1}results/`f'_main_`test'
 }
}
*saveold ${fmartorell_home}remediation/results/means_sd_main_all.dta, replace
saveold ${d1}results/means_sd_main_all.dta, replace

*use ${fmartorell_home}remediation/results/clps_main_any, clear
*append using ${fmartorell_home}remediation/results/clps_main_m.dta
*append using ${fmartorell_home}remediation/results/clps_main_r.dta
*append using ${fmartorell_home}remediation/results/clps_main_w.dta
*saveold ${fmartorell_home}remediation/results/clps_main_all, replace
use ${d1}results/clps_main_any, clear
append using ${d1}results/clps_main_m.dta
append using ${d1}results/clps_main_r.dta
append using ${d1}results/clps_main_w.dta
saveold ${d1}results/clps_main_all, replace

!date
