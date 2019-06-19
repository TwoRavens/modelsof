! date

cap log close
clear
program drop _all
set linesize 155
set tracedepth 1


*global fmartorell_home="/mnt/data/tsp/users/fmartorell/"
*cap do ${fmartorell_home}top_program
global d1="${col_remediation}program/program_paco/publication/"
do ${d1}do/top_program.do

set mem 1000m
*log using ${fmartorell_home}remediation/programs/earnings_analysis.log, replace



*use ${fmartorell_home}remediation/data/taspearn_allyears, clear
use ${d1}data/taspearn_allyears, clear
*keep if uniform()<.01



/* ----------------------------------------------------------------------------------------------
Start main program here
----------------------------------------------------------------------------------------------- */

*use ${fmartorell_home}remediation/data/tasp192_200_withall, clear
*keep if uniform()<.005
sort altpid school tspyr
*merge altpid school tspyr using ${fmartorell_home}remediation/data/attend_vars, unique nokeep 
merge altpid school tspyr using ${d1}data/attend_vars, unique nokeep 
assert _merge==3    /* see analysis_restatrev2.do */

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

/*
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
*/

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

cap drop all
gen byte allearn=1

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

* ***** FOR YR 7 ANALYSIS, DROP FROM BEFORE TSPYR 198 SEM 1   **** *
tabstat earn_yr7, by(tspyr)
tabstat earn_yr7 if tspyr==198 & firstsem>1

replace earn_yr7=. if (tspyr>198 | (tspyr==198 & firstsem>1))


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


/* ---------------------------------------------------------------
Create additional earnings variables
------------------------------------------------------------------ */

forvalues yr=5/7 {
 gen byte posearn`yr'=(earn_yr`yr')>0 & earn_yr`yr'<.
 gen byte pern_nen`yr'=posearn`yr'==1 & enrolled`yr'==0
}
*For yr 7 need to set earnings var to .
replace posearn7=. if (tspyr>198 | (tspyr==198 & firstsem>1))
replace pern_nen7=. if (tspyr>198 | (tspyr==198 & firstsem>1))

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


/* -----------------------------------------------------------
Set globals
-----------------------------------------------------------  */



*sublist
global earnlist="allearn posearn5 pern_nen5 posearn6 pern_nen6 posearn7 pern_nen7"


*variables to test validity
global val="startfall white nontradage rsc_math rsc_read rsc_hgh econ_dis misecon early delay1 delay2"


*global sr0list="anydeved_2sem"

*Covariates for all regressions
global covs="distmiss distl25nm distm50nm indistnm white hisp startfall nontradage d192-d199 econ_dis misecon dacyr1992-dacyr2000 delay2"

*Subgroups
global sublist="male female early late idis odis l25 m50 nw ec old pwrt highremed lowremed etest ltest"
*global sublist=""

keep all x*_r x*_m pass_m pass_r inter*_r inter*_m white black hisp seekbac  de*_*sem anydeved anydeved_2sem rsc_math rsc_writ rsc_read win1sem /*
*/ before *grwin* newhg* tranup tranup_gpa seekdeg* startfall anysample-wsample nontradage minscore /*
*/ sr rawmth rawred srsch_yr0 sem1sch sem1sch_fsem fgrmth_cndl attemptmath passcollmath srcredit_ac /*
*/ numsems jrsch_yr0 sem1sch sem1sch_fsem fgrmth_cndl attemptmath passcollmath jrcredit_ac srcredit_ac /*
*/ econ_dis misecon d192-d199 early dacyr* delay1 delay2 rsc_hgh maxnewhg*  srcredit_ac maxcredit_ac /*
*/ allearn earn_yr* enrolled* ftenrolled* sumcredit_ac trandwn $sr1list1 $sr0list1 $sr1list2 $sr0list2 $covs $val $earnlist $sublist

qui d $sublist
qui d $earnlist
qui d $val
qui d $covs


/* -----------------------------------------------------------------------------------
Get Sample Means
------------------------------------------------------------------------------------- */


 gen x=min(rsc_math,rsc_read)

   *This code was originally on earnings_analysis2.do
forvalues yr=5/7 {
 forvalues sr=0/1 {
  foreach sub in allearn posearn`yr' pern_nen`yr' {
   qui summ earn_yr`yr' if anysample==1 & win1sem==1 & sr==`sr' & `sub'==1 & x>=-100
   local m_yr`yr'_`sub'_`sr'=r(mean)
   local s_yr`yr'_`sub'_`sr'=r(sd)
  }
 }
}


forvalues yr=5/7 {
 disp "Yr=`yr' ,"  %7.1f `m_yr`yr'_allearn_0' ","   %7.1f `m_yr`yr'_posearn`yr'_0'  "," ///
    %7.1f `m_yr`yr'_allearn_1'  ","  %7.1f `m_yr`yr'_posearn`yr'_1' 
 disp "Yr=`yr' ," "{" %7.1f `s_yr`yr'_allearn_0' "},"  "{" %7.1f `s_yr`yr'_posearn`yr'_0' "}," ///
   "{" %7.1f `s_yr`yr'_allearn_1' "},"  "{" %7.1f `s_yr`yr'_posearn`yr'_1' "}"
}


drop x


/* -------------------------------------------------------------------------------
Compute inverse mills ratio for selection correction models 
--------------------------------------------------------------------------------- */

gen r2=rsc_read^2
gen m2=rsc_math^2
gen passedmath=rsc_math>=0
gen passedread=rsc_read>=0

forvalues sr=0/1 { 

  foreach esample in posearn5 pern_nen5 posearn6 pern_nen6 posearn7 pern_nen7 {

  probit `esample' $covs rsc_math rsc_read r2 m2 passedmath passedread if sr==`sr' & win1sem==1   /*note year 7 vars mising  if 198(2) or later */

  qui predict phat
  qui predict xb, xb
  gen invmill_sr`sr'_`esample'=normalden(xb)/phat if e(sample)
  drop phat xb

  }
}

drop passedmath passedread

*save ${fmartorell_home}/tmp/tmp2, replace

*use ${fmartorell_home}/tmp/tmp2, clear

d x_r
egen x_r_m=group(x_r x_m)


/* -------------------------------------------------------------------------
Do the analysis
---------------------------------------------------------------------------- */

tempname main multiv
*postfile `main' str20 subsample str10 band str5 control sr str5 sample str20 earnsample str5 est str50 outc beta se numobs using ${fmartorell_home}remediation/results/revearnbeta, replace
*postfile `multiv' str20 subsample str10 band str5 control sr str5 sample str20 earnsample str5 est str50 outc beta_m se_m beta_r se_r numobs using ${fmartorell_home}remediation/results/multivearnbeta, replace
postfile `main' str20 subsample str10 band str5 control sr str5 sample str20 earnsample str5 est str50 outc beta se numobs using ${d1}results/revearnbeta, replace
postfile `multiv' str20 subsample str10 band str5 control sr str5 sample str20 earnsample str5 est str50 outc beta_m se_m beta_r se_r numobs using ${d1}results/multivearnbeta, replace

d $sublist 

foreach subsample in all $sublist {
*set trace on
foreach band in global narrow {
 local low=-100*("`band'"=="global") + -10*("`band'"=="narrow")
 local hi=80*("`band'"=="global") + 10*("`band'"=="narrow")
 if "`band'"=="narrow" {
   local polyn="x inter"
   local polyn2="x_r inter_r x_m inter_m"
 }
 else {
   local polyn="x x2 x3 inter inter2 inter3"
   local polyn2="x_r x2_r x3_r inter_r inter2_r inter3_r x_m x2_m x3_m inter_m inter2_m inter3_m"
 }

 
 foreach control in nc c {
  disp "  `control'"
  *d x*
  forvalues sr=0/1 {
   cap drop x
   cap drop x2
   cap drop x3
   cap drop pass 
   cap drop inter inter2 inter3
   qui d wsample

   foreach sample in any m r  w   {
    disp "`subsample' `band' `sample'"
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

    foreach earnsamp in allearn posearn5 pern_nen5 posearn6 pern_nen6 posearn7 pern_nen7 {

    
    foreach est in rf iv {

     if "`earnsamp'"=="allearn" {
      global sr1list1="anydeved_2sem posearn5 posearn6 posearn7 pern_nen5 pern_nen6 pern_nen7 earn_yr5 earn_yr6 earn_yr7"
     }
     else if "`earnsamp'"=="posearn5" | "`earnsamp'"=="pern_nen5" {
      global sr1list1="demath_2sem deread_2sem anydeved_2sem earn_yr5"
     }
     else if "`earnsamp'"=="posearn6" | "`earnsamp'"=="pern_nen6" {
      global sr1list1="demath_2sem deread_2sem anydeved_2sem earn_yr6"
     }
     else if "`earnsamp'"=="posearn7" | "`earnsamp'"=="pern_nen7" {
      global sr1list1="demath_2sem deread_2sem anydeved_2sem earn_yr7"
     }

    
     foreach outc of varlist ${sr1list1}  {

	****** REGRESSIONS WITH NO CONTROLS *******
        if "`control'"=="nc" {
          if "`est'"=="rf" {
	    qui reg `outc' pass `polyn'  if `sample'sample==1 & win==1 & sr==`sr' & `earnsamp'==1 & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
          else if "`est'"=="iv" {
	    qui ivreg `outc' (endog=pass `polyn') `polyn'  if `sample'sample==1 & win==1 & sr==`sr' & `earnsamp'==1 & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
        }    /* CLOSE NO CONTROLS SPECIFICATION */

        ******* REGRESSIONS WITH CONTROLS *******
        else {
          if "`est'"=="rf" {
	    qui reg `outc' pass `polyn' covscore $covs if `sample'sample==1 & win==1 & sr==`sr' & `earnsamp'==1 & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
          else if "`est'"=="iv" {
	    qui ivreg `outc' (endog=pass `polyn') `polyn' covscore $covs if `sample'sample==1 & win==1 & sr==`sr' & `earnsamp'==1 & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
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
        post `main' ("`subsample'") ("`band'")  ("`control'") (`sr') ("`sample'") ("`earnsamp'") ("`est'") ("`outc'") (`b') (`sterr') (`n')

        ********** REGRESSIONS CONTROLLING FOR INV MILLS RATIO *******
        if "`control'"=="c" & "`earnsamp'"!="allearn" & substr("`outc'",1,4)=="earn" {
          if "`est'"=="rf" {
	    qui reg `outc' pass `polyn' covscore $covs invmill_sr`sr'_`earnsamp' if `sample'sample==1 & win==1 & sr==`sr' & `earnsamp'==1 & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
          }
          else if "`est'"=="iv" {
	    qui ivreg `outc' (endog=pass `polyn') `polyn' covscore $covs invmill_sr`sr'_`earnsamp' if `sample'sample==1 & win==1 & sr==`sr' & `earnsamp'==1 & `subsample'==1 & inrange(x,`low',`hi'), cluster(x)
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
        post `main' ("`subsample'") ("`band'")  ("c_sel") (`sr') ("`sample'") ("`earnsamp'") ("`est'") ("`outc'") (`b') (`sterr') (`n')
	
	
	}





      }   /* CLOSE OUTCOME LIST */

    } /* CLOSE IV/RF LIST */
   
    if "`subsample'"=="all" & "`band'"=="global"  & "`control'"=="nc" & `sr'==0 {
     preserve
       collapse ${sr1list1} (count) n=anydeved_2sem if `earnsamp'==1, by(x sr)
       gen sample="`sample'"
       gen earnsample="`earnsamp'"
       *save ${fmartorell_home}/remediation/results/clps_earn_`sample'_`earnsamp', replace
       save ${d1}results/clps_earn_`sample'_`earnsamp', replace

     restore
     preserve 
       collapse ${sr1list1}  (count) n=anydeved_2sem if `earnsamp'==1, by(sr)
       gen sample="`sample'"
       gen earnsample="`earnsamp'"
       gen str stat="mean"
       *save ${fmartorell_home}/remediation/results/means_earn_`sample'_`earnsamp', replace
       save ${d1}results/means_earn_`sample'_`earnsamp', replace
     restore
     preserve
       collapse (sd) ${sr1list1}  (count) n=anydeved_2sem if `earnsamp'==1, by(sr)
       gen sample="`sample'"
       gen earnsample="`earnsamp'"
       gen str stat="sd"
       *save ${fmartorell_home}/remediation/results/sd_earn_`sample'_`earnsamp', replace
       save ${d1}results/sd_earn_`sample'_`earnsamp', replace
	 restore
    }

    } /* CLOSE EARNINGS SAMPLE LOOP */

   } /* CLOSE SAMPLE LOOP */
*/
      ***** MULTIPLE ENDOG REGRESSOR MODELS ******
      foreach esample in allearn posearn5 pern_nen5 posearn6 pern_nen6 posearn7 pern_nen7 {
        global sr1list1=""
        if "`esample'"=="allearn" {
          global sr1list1="posearn5 posearn6 posearn7 pern_nen5 pern_nen6 pern_nen7 earn_yr5 earn_yr6 earn_yr7"
        }
        else if "`esample'"=="posearn5" | "`esample'"=="pern_nen5" {
          global sr1list1="earn_yr5"
        }
        else if "`esample'"=="posearn6" | "`esample'"=="pern_nen6" {
          global sr1list1="earn_yr6"
        }
        else if "`esample'"=="posearn7" | "`esample'"=="pern_nen7" {
          global sr1list1="earn_yr7"
        }
        

      foreach outc of varlist ${sr1list1}  {
	/* 
	****** IV WITH MATH AND READING IN SAME REGRESSION *******
        if "`control'"=="nc" {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), cluster(x)
        }    /* CLOSE NO CONTROLS SPECIFICATION */

        ******* REGRESSIONS WITH CONTROLS *******
        else {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), cluster(x)
        }  
	*/ 

	****** IV WITH MATH AND READING IN SAME REGRESSION *******
	if "`control'"=="nc" {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r)
	    mat v_r=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_m)
	    mat v_m=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r_m)
	    mat v_m_r=e(V)
	    mat v2way=v_r+v_m-v_m_r
	    mat varbetam=v2way["demath_2sem","demath_2sem"]
	    mat varbetar=v2way["deread_2sem","deread_2sem"]
	    local varbetam=varbetam[1,1]
	    local varbetar=varbetar[1,1]
	}    /* CLOSE NO CONTROLS SPECIFICATION */

	******* REGRESSIONS WITH CONTROLS *******
        else {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r)
	    mat v_r=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_m)
	    mat v_m=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r_m)
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

            post `multiv' ("`subsample'") ("`band'")  ("`control'") (`sr') ("twoendog") ("`esample'") ("iv") ("`outc'") (`b_m') (`se_m') (`b_r') (`se_r') (`n')


        if "`control'"=="c" & "`esample'"!="allearn" & substr("`outc'",1,4)=="earn" {
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs invmill_sr`sr'_`esample' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r)
	    mat v_r=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs  invmill_sr`sr'_`esample' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_m)
	    mat v_m=e(V)
	    qui ivreg `outc' (demath_2sem deread_2sem=pass_r pass_m `polyn2') `polyn2' /* covscore */ $covs invmill_sr`sr'_`esample' if `esample'==1 & win==1 & sr==`sr' & `subsample'==1 & inrange(x_r,`low',`hi') & inrange(x_m,`low',`hi'), robust cluster(x_r_m)
	    mat v_m_r=e(V)
	    mat v2way=v_r+v_m-v_m_r
	    mat varbetam=v2way["demath_2sem","demath_2sem"]
	    mat varbetar=v2way["deread_2sem","deread_2sem"]
	    local varbetam=varbetam[1,1]
	    local varbetar=varbetar[1,1]	

	 local b_r=_b[deread_2sem]
	 local se_r=sqrt(`varbetar')
	 local b_m=_b[demath_2sem]
	 local se_m=sqrt(`varbetam')
         local n=e(N)

         post `multiv' ("`subsample'") ("`band'")  ("c_sel") (`sr') ("twoendog") ("`esample'") ("iv") ("`outc'") (`b_m') (`se_m') (`b_r') (`se_r') (`n')
	}




      }
      } /* CLOSE MULTIV LOOP */

  }  /* CLOSE SR LOOP */ 
 
 }   /* CLOSE CONTROL/NC LOOP */

} /* CLOSE BAND LOOP */

}  /* CLOSE SUBSAMPLE LOOP */

postclose `multiv'
postclose `main'

*use ${fmartorell_home}remediation/results/clps_earn_any_allearn.dta, clear
*append using ${fmartorell_home}remediation/results/clps_earn_m_allearn.dta
*append using ${fmartorell_home}remediation/results/clps_earn_r_allearn.dta
*append using ${fmartorell_home}remediation/results/clps_earn_w_allearn.dta
use ${d1}results/clps_earn_any_allearn.dta, clear
append using ${d1}results/clps_earn_m_allearn.dta
append using ${d1}results/clps_earn_r_allearn.dta
append using ${d1}results/clps_earn_w_allearn.dta

foreach s in posearn pern_nen {
 forvalues y=5/7 {
   foreach test in m r w any {
    *append using ${fmartorell_home}remediation/results/clps_earn_`test'_`s'`y' 
    append using ${d1}results/clps_earn_`test'_`s'`y' 
   }
 }
}
*save ${fmartorell_home}remediation/results/clps_earn_all, replace
save ${d1}results/clps_earn_all.dta, replace
sum 

*use ${fmartorell_home}remediation/results/means_earn_any_allearn, clear
*append using ${fmartorell_home}remediation/results/means_earn_m_allearn
*append using ${fmartorell_home}remediation/results/means_earn_r_allearn
*append using ${fmartorell_home}remediation/results/means_earn_w_allearn
use ${d1}results/means_earn_any_allearn, clear
append using ${d1}results/means_earn_m_allearn
append using ${d1}results/means_earn_r_allearn
append using ${d1}results/means_earn_w_allearn


* append using ${fmartorell_home}remediation/results/sd_earn_any_allearn
* append using ${fmartorell_home}remediation/results/sd_earn_m_allearn
* append using ${fmartorell_home}remediation/results/sd_earn_r_allearn
* append using ${fmartorell_home}remediation/results/sd_earn_w_allearn
append using ${d1}results/sd_earn_any_allearn
append using ${d1}results/sd_earn_m_allearn
append using ${d1}results/sd_earn_r_allearn
append using ${d1}results/sd_earn_w_allearn


foreach s in posearn pern_nen {
 forvalues y=5/7 {
   foreach test in m r w any {
      *append using ${fmartorell_home}remediation/results/means_earn_`test'_`s'`y'
      *append using ${fmartorell_home}remediation/results/sd_earn_`test'_`s'`y'
      append using ${d1}results/means_earn_`test'_`s'`y'
      append using ${d1}results/sd_earn_`test'_`s'`y'
   } 
  }
}
*save ${fmartorell_home}remediation/results/means_earn_all, replace
save ${d1}results/means_earn_all, replace

use "${d1}results/clps_earn_all.dta", clear   /* File created in earnings_analysis_restatrev2.do */

 foreach var of varlist demath_2sem deread_2sem anydeved_2sem posearn5 posearn6 posearn7 pern_nen5 pern_nen6 pern_nen7 earn_yr5 earn_yr6 earn_yr7 {
  replace `var'=. if n<5 | n==.
 }
replace n=. if n==. | n<5
saveold "${d1}results/clps_earn_all_size.dta", replace 

!date


