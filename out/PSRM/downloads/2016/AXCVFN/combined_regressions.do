**Stata 13; uses spost13 for PP, plots.
**Second Difference requires CLARIFY .ado files.

**regression in Table 4, PP plot in Fig 2, and "Second Difference" in fn 25.

local path="C:\docs\psrm15_regreps"
use "`path'\main.dta",clear



*----------------------------------------Table 4--------------------------------

logit __1binary c.jws_grade_zmean c.mqpetcomp bin_conflict bin_uncon bin_intrev ///
bin_civlib uspet lctamici lodiss if jid !="blkm", cluster(jid) nolog


*----------------------Figure 2 plot (and associated regressions)---------------

*basic ivs
local mbaseivs c.jws_grade_zmean c.jws_grade_zmean#c.jws_complexity ///
c.jws_grade_zmean#c.mqpetcomp c.jws_complexity c.mqpetcomp


*saturated ivs
local msativs jws_us_appellant jws_us_appellee jws_sg_argue_applt ///
jws_sg_argue_applee jws_dcprac_notus_applt jws_dcprac_notus_appellee ///
jws_lawprof_applt jws_lawprof_applee jws_clerk_applt jws_clerk_applee ///
jws_elite_law_applt jws_elite_law_applee c.jws_prev_exp_dif_log 

*fix some covariates for pp:
local mvals  jws_us_appellant=0 jws_us_appellee=0 jws_sg_argue_applt=0 ///
jws_sg_argue_applee=0 jws_lawprof_applt=0 jws_lawprof_applee=0 ///
jws_clerk_applt=0 jws_clerk_applee=0 jws_elite_law_applt=0 jws_elite_law_applee=0 ///
c.jws_prev_exp_dif_log=0 


*full model, conference vote:
logit __2bin `mbaseivs' `msativs' if jid !="blkm",cluster(jid) nolog


mgen, at(c.jws_grade_zmean=(-4.5(1)4.5) jws_complexity=-.02 mqpetcomp=-.017 ///
jws_dcprac_notus_applt=1 jws_dcprac_notus_appellee=1 `mvals') level(95) noatlegend ///
stub(cv)

		
*full model, report vote:
logit __bin `mbaseivs' `msativs' if jws_justice !="blkm",cluster(jws_justice) nolog
*gen tv2=e(sample)
*margins, at(c.jws_grade_zmean=(-4.5(1)4.5) jws_complexity=-.02 mqpetcomp=-.017 ///
*jws_dcprac_notus_applt=1 jws_dcprac_notus_appellee=1 `mvals') level(95) noatlegend 

mgen, at(c.jws_grade_zmean=(-4.5(1)4.5) jws_complexity=-.02 mqpetcomp=-.017 ///
jws_dcprac_notus_applt=1 jws_dcprac_notus_appellee=1 `mvals') level(95) noatlegend ///
stub(rv)


**graph
twoway (rarea rvul1 rvll1 rvjws_grade_zmean, lcolor(gs15) graphregion(color(white)) fcolor(gs15)) ///
(rarea cvul1 cvll1 cvjws_grade_zmean,lcolor(gs14) fcolor(gs14)) ///
(connected cvpr1 cvjws_grade_zmean, lcolor(black) msymbol(point) clpattern(dash) mcolor(black)) ///
(connected rvpr1 rvjws_grade_zmean, lcolor(black) msymbol(point) clpattern(solid) mcolor(black))  , ///
ytitle(P(Vote to Reverse)) xtitle(Appellant Advantage in Oral Argument Grade) ///
legend(order(3 "Conference Merits Vote" 4  "Final, Report Vote")) ///
title(Conference and Report Voting as a Function of Oral Argument Grade, size(medsmall))


graph save "`path'\fig2.gph", replace
graph export "`path'\fig2.png", replace



*----------------------------second difference------------------------------

**setup:
*duplicate each observation in dataset
expand 2, gen(voteisreport)
*used as : voteisreport=1 if justice_vote is report vote...
* and =0 if justice_vote is conference vote.  
gen justice_vote=.
replace justice_vote=__2binary if voteisreport==0
replace justice_vote=__binary if voteisreport==1
gen justice_id=""
replace justice_id=jid if voteisreport==0
replace justice_id=jws_justice if voteisreport==1


**generate interactions: "old" stata notation
set seed 13115 //date
*quietly{
gen gXc=jws_grade_zmean*jws_complexity
gen gXmq=jws_grade_zmean*mqpetcomp
gen vrXg=voteisreport*jws_grade_zmean

*basic ivs
local mbaseivs jws_grade_zmean gXc ///
gXmq jws_complexity mqpetcomp


*saturated ivs
local msativs jws_us_appellant jws_us_appellee jws_sg_argue_applt ///
jws_sg_argue_applee jws_dcprac_notus_applt jws_dcprac_notus_appellee ///
jws_lawprof_applt jws_lawprof_applee jws_clerk_applt jws_clerk_applee ///
jws_elite_law_applt jws_elite_law_applee jws_prev_exp_dif_log 


foreach v of local mbaseivs{
gen vrX`v'=voteisreport*`v'
}
foreach v of local msativs{
gen vrX`v'=voteisreport*`v'
}




*the advantage of including the extended ivs is that since the logit model
*used here (with vr interacted with all terms) avoids making undesirable
*assumptions about w/er the effects of variables are constant across votes.

*extended IVs:
local mextivs  vrXgXc vrXgXmq vrXjws_complexity vrXmqpetcomp ///
vrXjws_us_appellant vrXjws_us_appellee vrXjws_sg_argue_applt ///
vrXjws_sg_argue_applee vrXjws_dcprac_notus_applt vrXjws_dcprac_notus_appellee ///
vrXjws_lawprof_applt vrXjws_lawprof_applee vrXjws_clerk_applt vrXjws_clerk_applee ///
vrXjws_elite_law_applt vrXjws_elite_law_applee vrXjws_prev_exp_dif_log  
*note  vrXjws_grade_zmean not needed b/c vrXg already exists



estsimp logit justice_vote voteisreport vrXg ///
`mbaseivs' `msativs' `mextivs' if jws_justice !="blkm" 

setx jws_us_appellant 0 jws_us_appellee 0 jws_sg_argue_applt 0 ///
jws_sg_argue_applee 0 jws_lawprof_applt 0 jws_lawprof_applee 0 ///
jws_clerk_applt 0 jws_clerk_applee 0 jws_elite_law_applt 0 jws_elite_law_applee 0 ///
jws_prev_exp_dif_log 0 jws_complexity -.02 mqpetcomp -.017 ///
jws_dcprac_notus_applt 1 jws_dcprac_notus_appellee 1
*}



//min grade, conf vote:
setx vrXjws_us_appellant 0 vrXjws_us_appellee 0 vrXjws_sg_argue_applt 0 ///
vrXjws_sg_argue_applee 0 vrXjws_lawprof_applt 0 vrXjws_lawprof_applee 0 ///
vrXjws_clerk_applt 0 vrXjws_clerk_applee 0 vrXjws_elite_law_applt 0 vrXjws_elite_law_applee 0 ///
vrXjws_prev_exp_dif_log 0 vrXjws_complexity 0 vrXmqpetcomp 0 ///
vrXjws_dcprac_notus_applt 0 vrXjws_dcprac_notus_appellee 0

setx jws_grade_zmean -4.5 gXc .09 gXmq .0765 vrXg 0 vrXgXc 0 vrXgXmq 0

simqi, prval(1) genpr(pr00)

//max grade, conf vote:
setx jws_grade_zmean 4.5 gXc -.09 gXmq -.0765 vrXg 0 vrXgXc 0 vrXgXmq 0
simqi, prval(1) genpr(pr10)

//min grade, report vote:
setx vrXjws_us_appellant 0 vrXjws_us_appellee 0 vrXjws_sg_argue_applt 0 ///
vrXjws_sg_argue_applee 0 vrXjws_lawprof_applt 0 vrXjws_lawprof_applee 0 ///
vrXjws_clerk_applt 0 vrXjws_clerk_applee 0 vrXjws_elite_law_applt 0 vrXjws_elite_law_applee 0 ///
vrXjws_prev_exp_dif_log 0 vrXjws_complexity -.02 mqpetcomp -.017 ///
vrXjws_dcprac_notus_applt 1 vrXjws_dcprac_notus_appellee 1

setx jws_grade_zmean -4.5 gXc .09 gXmq .0765 vrXg -4.5 vrXgXc .09 vrXgXmq .0765 

simqi, prval(1) genpr(pr01)


//max grade, report vote: 
setx jws_grade_zmean 4.5 gXc -.09 gXmq -.0765 vrXg 4.5 vrXgXc -.09 vrXgXmq -.0765

simqi, prval(1) genpr(pr11)

*(11-01) - (10-00)

gen t1=pr11-pr01
gen t2=pr10-pr00
gen seconddif=t1-t2

sumqi t1 t2 seconddif

clear

