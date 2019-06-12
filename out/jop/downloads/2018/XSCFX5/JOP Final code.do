local stick f
clear
clear mata
clear matrix
set mem 1g
set more off
use "`stick':\Stata\Barry\Final\TwoCityPanelStudy.dta", clear
capture log close
log using "`stick':\My Documents\Research\Paper Anand\JOP.log", text replace
xtset id wave

*GENERATE DVs
recode v43b_pidparty 1=2 3=3 4=1 28=. 29=. 99=. 2=15 5/27=15, gen(pid)
replace pid=0 if v43a_pidyesorno==2
label define pid 2 PMDB 3 PSDB 1 PT 0 Independent 15 "Other party"
label values pid pid

	*binary measures of PID
recode pid 1=1 .=. else=0, gen(pt)
recode pid 0=1 .=. else=0, gen(indep)
recode pid 2=1 .=. else=0, gen(pmdb)
recode pid 3=1 .=. else=0, gen(psdb)

bysort city wave: tab pid

*GENERATE IVs

	*ECONOMIC EVALUATIONS
		*retrospective, sociotropic
gen econpastbrazil=v5d_econpastbrazil
recode econpastbrazil 8=. 9=. 1=5 2=4 3=3 4=2 5=1

gen econpastego=v5a_econpastego 
recode econpastego 8=. 9=. 1=5 2=4 3=3 4=2 5=1

egen econevalstemp2=rmean(econpastbrazil econpastego)
impute econevalstemp econpastbrazil econpastego if respond==1, gen(econevals)

	*CANDIDATE TRAITS
		*we asked respondents to judge candidates' honesty, intelligence, compassion, and leadership.  
recode v59a_candshonestlula v57a_candsintelligentlula v58a_candsstrongleaderlula v60a_candscompassionlula (4=1) (3=2) (2=3) (1=4) (else=.)
factor v57a_candsintelligentlula v58a_candsstrongleaderlula v60a_candscompassionlula, pcf
predict lulatraitstemp 
impute lulatraitstemp v57a_candsintelligentlula v58a_candsstrongleaderlula v60a_candscompassionlula if respond==1, gen(lulatraits)

		*Pres approval of Lula
recode v81_lulagovpresapprove 8/99=. 1=5 2=4 3=3 4=2 5=1

		*index of Lula corruption
recode v79a_thermlulagovcorruption 18=. 19=.
recode v80a_lulagovvsfhccorruption 1=1 2=3 3=2 8=. 9=.

bysort wave: summ v59a_candshonestlula v79a_thermlulagovcorruption  v80a_lulagovvsfhccorruption 
bysort wave: ci v59a_candshonestlula v79a_thermlulagovcorruption  v80a_lulagovvsfhccorruption 

factor v59a_candshonestlula v79a_thermlulagovcorruption  v80a_lulagovvsfhccorruption , pcf
predict corruptperceivetemp
impute corruptperceivetemp v59a_candshonestlula v79a_thermlulagovcorruption  v80a_lulagovvsfhccorruption if wave>3 & respond==1, gen(corruptperceive)
summ corruptperceive
replace corruptperceive=-corruptperceive
			*For Figure 2
bysort wave: ci corruptperceive
bysort wave: ci econpastbrazil econpastego econevals v81_lulagovpresapprove lulatraits 

	*DISCUSSANT VOTE
		*numdisc is number of discussants that ego named (0 to 3)
gen numdisc = v74_disc1named+v75_disc2named+v76_disc3named
replace numdisc=. if respond==0
sort id wave
gen numdisclag = l.numdisc

		*creates dummies, 1 if (ACCORDING TO EGO) alter voted for Lula and 0 if alter did not vote for Lula (would be abstention or vote for another cand. or "don't know")  
recode v74c_disc1presvote (2=1) (else=0), gen(disc1lula)
recode v75c_disc2presvote (2=1) (else=0), gen(disc2lula)
recode v76c_disc3presvote (2=1) (else=0), gen(disc3lula)

recode v74c_disc1presvote (1=1) (4/16=1) (else=0), gen(disc1nonlula)
recode v75c_disc2presvote (1=1) (4/16=1) (else=0), gen(disc2nonlula)
recode v76c_disc3presvote (1=1) (4/16=1) (else=0), gen(disc3nonlula)
gen lulanumdisc=disc1lula+disc2lula+disc3lula
gen nonlulanumdisc=disc1nonlula+disc2nonlula+disc3nonlula
replace lulanumdisc=. if respond==0
replace nonlulanumdisc=. if respond==0
replace lulanumdisc=. if wave==1
replace nonlulanumdisc=. if wave==1
replace lulanumdisc=. if wave==4
replace nonlulanumdisc=. if wave==4
replace lulanumdisc=. if numdisclag==. & wave==3
replace lulanumdisc=. if numdisclag==. & wave==6
replace nonlulanumdisc=. if numdisclag==. & wave==3
replace nonlulanumdisc=. if numdisclag==. & wave==6

bysort wave: ci lulanumdisc nonlulanumdisc 

		*now governors, only for wave 3
recode v74dcs_disc1govvote  (4/5=1) (else=0), gen(disc1ptgov)
recode v75dcs_disc2govvote  (4/5=1) (else=0), gen(disc2ptgov)
recode v76dcs_disc3govvote  (4/5=1) (else=0), gen(disc3ptgov)

recode v74djf_disc1govvote  (2=1) (else=0), gen(disc1ptgovtemp)
recode v75djf_disc2govvote  (2=1) (else=0), gen(disc2ptgovtemp)
recode v76djf_disc3govvote  (2=1) (else=0), gen(disc3ptgovtemp)

replace disc1ptgov=disc1ptgovtemp if city==2
replace disc2ptgov=disc2ptgovtemp if city==2
replace disc3ptgov=disc3ptgovtemp if city==2

recode v74dcs_disc1govvote  (1/3=1) (6/16=1)  (else=0), gen(disc1nonptgov)
recode v75dcs_disc2govvote  (1/3=1) (6/16=1)  (else=0), gen(disc2nonptgov)
recode v76dcs_disc3govvote  (1/3=1) (6/16=1)  (else=0), gen(disc3nonptgov)

recode v74djf_disc1govvote  (1=1) (3/16=1) (else=0), gen(disc1nonptgovtemp)
recode v75djf_disc2govvote  (1=1) (3/16=1) (else=0), gen(disc2nonptgovtemp)
recode v76djf_disc3govvote  (1=1) (3/16=1) (else=0), gen(disc3nonptgovtemp)

replace disc1nonptgov=disc1nonptgovtemp if city==2
replace disc2nonptgov=disc2nonptgovtemp if city==2
replace disc3nonptgov=disc3nonptgovtemp if city==2

gen ptnumdisc=disc1lula+disc2lula+disc3lula+disc1ptgov+disc2ptgov+disc3ptgov
gen nonptnumdisc=disc1nonlula+disc2nonlula+disc3nonlula+disc1nonptgov+disc2nonptgov+disc3nonptgov
replace ptnumdisc=. if respond==0
replace nonptnumdisc=. if respond==0
replace ptnumdisc=. if wave==1
replace nonptnumdisc=. if wave==1
replace ptnumdisc=. if wave==4
replace nonptnumdisc=. if wave==4
replace ptnumdisc=. if wave==5
replace nonptnumdisc=. if wave==5
replace ptnumdisc=. if wave==6
replace nonptnumdisc=. if wave==6
replace ptnumdisc=. if numdisclag==. & wave==3
replace nonptnumdisc=. if numdisclag==. & wave==3

	*ISSUE SPACES
recode v63a_issuespriv 8=. 9=. 1=5 2=4 3=3 4=2 5=1
recode v63b_issuesprivlula 8=. 9=. 1=5 2=4 3=3 4=2 5=1
recode v61a_candsideologylula 6/99=.
recode v50_ideo 6/9=.
recode v70b_issueslandreformlula 8/9=. 
recode v69b_issuessocialspendlula 8/9=.
recode v70a_issueslandreform 8/9=. 
recode v69a_issuessocialspend 8/9=.
egen self_in_issue_space_temp=rmean(v63a_issuespriv v70a_issueslandreform v69a_issuessocialspend)
impute self_in_issue_space_temp v63a_issuespriv v70a_issueslandreform v69a_issuessocialspend if respond==1, gen(self_in_issue_space)

		*shows Lula's moderation
bysort wave: summ v63b_issuesprivlula v70b_issueslandreformlula v69b_issuessocialspendlula  

		*going with means to keep on same scale as self
egen lula_in_issue_space_temp=rmean(v70b_issueslandreformlula v63b_issuesprivlula v69b_issuessocialspendlula )
		*replace lula_in_issue_space_temp=-(lula_in_issue_space_temp-6)
impute lula_in_issue_space_temp v70b_issueslandreformlula v63b_issuesprivlula v69b_issuessocialspendlula if respond==1, gen(lula_in_issue_space)
			*For Figure 2
bysort wave: ci lula_in_issue_space v61a_candsideologylula lulatraits self_in_issue_space econevals v81_lulagovpresapprove 


	*GEN THE AWARENESS VARIABLE.  Note its a little tricky because people answered a different number depending on which wave/s they were in
gen correct1=.
replace correct1=1 if s14acs_know1cargo==1 & city==1 & wave==1
		* Give half a point to people who said Ana Corso was a Fed. Dep. because she was a suplente for 8 months
replace correct1=.5 if s14acs_know1cargo==2 & city==1 & wave==1
replace correct1=1 if s14ajf_know1cargo==2 & city==2 & wave==1
replace correct1=1 if s14ajf_know1cargo==2 & city==2 & wave==5
replace correct1=1 if s14aW4cs_know1cargo==2 & city==1 & wave==4

gen correct2=.
replace correct2=1 if s14b_know2vicepres==2 & wave==1
replace correct2=1 if s14b_know2vicepres==2 & wave==3
replace correct2=1 if s14bW4_know2vicepres==4 & wave==4
replace correct2=1 if s14bW4_know2vicepres==4 & wave==5
replace correct2=1 if s14bW4_know2vicepres==4 & wave==6

gen correct3=.
replace correct3=1 if s14c_know3fhcparty==3 & wave==1
replace correct3=1 if s14c_know3fhcparty==3 & wave==3
replace correct3=1 if s14c_know3fhcparty==3 & wave==4
replace correct3=1 if s14c_know3fhcparty==3 & wave==6 & city==2

gen correct4=.
replace correct4=1 if s14d_know4mercosul==2 & wave==1
replace correct4=1 if s14d_know4mercosul==2 & wave==3
replace correct4=1 if s14d_know4mercosul==2 & wave==4
replace correct4=1 if s14d_know4mercosul==2 & wave==5
replace correct4=1 if s14d_know4mercosul==2 & wave==6

gen correct5=.
replace correct5=1 if s14ecs_know5senator==1 & city==1 & wave==1
replace correct5=1 if s14ecs_know5senator==1 & city==1 & wave==4
replace correct5=1 if s14ecs_know5senator==1 & city==1 & wave==5
replace correct5=1 if s14ecs_know5senator==1 & city==1 & wave==6
replace correct5=1 if s14ejf_know5senator==1 & city==2 & wave==1
replace correct5=1 if s14ejf_know5senator==1 & city==2 & wave==4
replace correct5=1 if s14ejf_know5senator==1 & city==2 & wave==5
replace correct5=1 if s14ejf_know5senator==1 & city==2 & wave==6

gen correct6=.
replace correct6=1 if s14f_know6preschamber==3 & wave==1
replace correct6=1 if s14fW4_know6preschamber==2 & wave==4
replace correct6=1 if s14fW5_know6preschamber==4 & wave==5
replace correct6=1 if s14fW5_know6preschamber==4 & wave==6

gen correct7=.
replace correct7=1 if s14gcs_know7mayor==4 & wave==3 & city==1
replace correct7=1 if s14gcs_know7mayor==4 & wave==4 & city==1
replace correct7=1 if s14gcs_know7mayor==4 & wave==5 & city==1
replace correct7=1 if s14gcs_know7mayor==4 & wave==6 & city==1
replace correct7=1 if s14gjf_know7mayor==4 & wave==3 & city==2

gen correct8=.
replace correct8=1 if s14hcs_know8cargopauletti==3 & wave==5
replace correct8=1 if s14hcs_know8cargopauletti==3 & wave==6

gen correct9=.
replace correct9=1 if s14ics_know9simonparty==2 & city==1 & wave==5
replace correct9=1 if s14ics_know9simonparty==2 & city==1 & wave==6
replace correct9=1 if s14ijf_know9aecioparty==3 & city==2 & wave==5
replace correct9=1 if s14ijf_know9aecioparty==3 & city==2 & wave==6

egen aware=rsum(correct1-correct9)
replace aware=. if respond==0
summ aware if wave==1 & city==1
gen awarez=(aware-r(mean))/r(Var)^.5 if wave==1 & city==1
summ aware if wave==3 & city==1
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==3 & city==1
summ aware if wave==4 & city==1
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==4 & city==1
summ aware if wave==5 & city==1
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==5 & city==1
summ aware if wave==6 & city==1
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==6 & city==1

summ aware if wave==1 & city==2
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==1 & city==2
summ aware if wave==3 & city==2
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==3 & city==2
summ aware if wave==4 & city==2
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==4 & city==2
summ aware if wave==5 & city==2
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==5 & city==2
summ aware if wave==6 & city==2
replace awarez=(aware-r(mean))/r(Var)^.5 if wave==6 & city==2
drop correct*

		*Program to get neighbrohood aggregates without including main respondent
capture program drop getaggs
program define getaggs

while "`1'"~="" {
egen `1'sum=sum(`1') if respond==1, by(bairroamob wave)
gen `1'smnon=`1'sum-`1'
gen n`1'=0
replace n`1'=1 if `1'~=.
egen sumn`1'=sum(n`1') if respond==1, by(bairroamob wave)
gen `1'bairronomr=`1'smnon/(sumn`1'-1)
gen `1'bairroall=`1'sum/sumn`1' 
bysort bairroamob wave: egen `1'bairroallmean=max(`1'bairroall)
replace `1'bairronomr=`1'bairroallmean if `1'bairronomr==.
drop `1'sum n`1' sumn`1' `1'smnon `1'bairroall `1'bairroallmean
mac shift
}
end

	*SES AND OTHER DEMOGRAPHICS
replace s10_age=ln(s10_age)
mvdecode s6_education, mv(18)
mvdecode s6_education, mv(19)
mvdecode s12_income, mv(1)
mvdecode s12_income, mv(8)
mvdecode s12_income, mv(9)
replace s12_income=10000 if s12_income>10000 & s12_income~=.
gen lneduc=ln(s6_education)
gen lnincome=ln(s12_income+1)
getaggs lneduc lnincome
factor lnincome lneduc lnincomebairronomr
predict sestemp
impute sestemp lneduc lnincome lnincomebairronomr, gen(ses)

*-------------------------------------------------------------------------------------
*ATTRITION WEIGHTS FOR MODELLING
recode s7a_jobfixed 8=. 9=.
recode s13a_ 108=. 109=.
replace s13a_=ln(s13a_)
sort id wave
recode respond 1=0 0=1, gen(notrespond)

logit notrespond l.s13a_  l.s7a_jobfixed l.s1_sex l.ses l.awarez l.s10_age l.s15a_interviewagain l.s16c_intrvwrquestiontrust if wave==2 & l.respond==1
predict attriteweight2temp if wave==2, p
impute attriteweight2temp l.s13a_  l.s7a_jobfixed  l.s1_sex l.ses l.awarez l.s10_age l.s15a_interviewagain l.s16c_intrvwrquestiontrust if wave==2 & l.respond==1, gen(attriteweight2)
summ attriteweight2, det
	*truncating at 5th and 95th percentile to avoid outliers.
replace attriteweight2=r(p5) if attriteweight2<r(p5)
replace attriteweight2=r(p95) if attriteweight2>r(p95)
replace attriteweight2=. if wave~=2

logit notrespond l2.s13a_ l2.s7a_jobfixed l2.s1_sex l2.ses l2.awarez l2.city l2.s10_age l2.s15a_interviewagain l2.s16c_intrvwrquestiontrust if wave==3 & l2.respond==1
predict attriteweight3temp if wave==3, p
impute attriteweight3temp l2.s13a_ l2.s7a_jobfixed l2.s1_sex l2.ses l2.awarez l2.city l2.s10_age l2.s15a_interviewagain l2.s16c_intrvwrquestiontrust if wave==3 & l2.respond==1, gen(attriteweight3)
summ attriteweight3, det
replace attriteweight3=r(p5) if attriteweight3<r(p5)
replace attriteweight3=r(p95) if attriteweight3>r(p95)
replace attriteweight3=. if wave~=3

logit notrespond l3.s13a_ l3.s7a_jobfixed l3.s1_sex l3.ses l3.awarez l3.city l3.s10_age l3.s15a_interviewagain l3.s16c_intrvwrquestiontrust if wave==4 & l3.respond==1
predict attriteweight4temp if wave==4, p
impute attriteweight4temp l3.s13a_ l3.s7a_jobfixed l3.s1_sex l3.ses l3.awarez l3.city l3.s10_age l3.s15a_interviewagain l3.s16c_intrvwrquestiontrust if wave==4 & l3.respond==1, gen(attriteweight4)
summ attriteweight4, det
replace attriteweight4=r(p5) if attriteweight4<r(p5)
replace attriteweight4=r(p95) if attriteweight4>r(p95)
replace attriteweight4=. if wave~=4

logit notrespond l4.s13a_ l4.s7a_jobfixed l4.s1_sex l4.ses l4.awarez l4.city l4.s10_age l4.s15a_interviewagain l4.s16c_intrvwrquestiontrust if wave==5 & l4.respond==1
predict attriteweight5temp if wave==5, p
impute attriteweight5temp l4.s13a_ l4.s7a_jobfixed l4.s1_sex l4.ses l4.awarez l4.city l4.s10_age l4.s15a_interviewagain l4.s16c_intrvwrquestiontrust if wave==5 & l4.respond==1, gen(attriteweight5)
summ attriteweight5, det
replace attriteweight5=r(p5) if attriteweight5<r(p5)
replace attriteweight5=r(p95) if attriteweight5>r(p95)
replace attriteweight5=. if wave~=5

logit notrespond l5.s13a_ l5.s7a_jobfixed l5.s1_sex l5.ses l5.awarez l5.city l5.s10_age l5.s15a_interviewagain l5.s16c_intrvwrquestiontrust if wave==6 & l5.respond==1
predict attriteweight6temp if wave==6, p
impute attriteweight6temp l5.s13a_ l5.s7a_jobfixed l5.s1_sex l5.ses l5.awarez l5.city l5.s10_age l5.s15a_interviewagain l5.s16c_intrvwrquestiontrust if wave==6 & l5.respond==1, gen(attriteweight6)
summ attriteweight6, det
replace attriteweight6=r(p5) if attriteweight6<r(p5)
replace attriteweight6=r(p95) if attriteweight6>r(p95)
replace attriteweight6=. if wave~=6

egen attriteweight=rowmax(attriteweight2 attriteweight3 attriteweight4 attriteweight5 attriteweight6)

cd "`stick':\My Documents\Research\Paper Anand\Imputes\"
*-------------------------------------------------------------------------------------
*TRANSITION TABLES: For Tables 1 and 2 and Figure 3
preserve
keep id wave respond city pid pt indep pmdb psdb ses attriteweight
reshape wide respond city pid pt indep pmdb psdb ses attriteweight, i(id) j(wave)
tab pid3 pid1 if city1==1, col
tab pid4 pid3 if city1==1, col
tab pid5 pid4 if city1==1, col
tab pid6 pid5 if city1==1, col

tab pid3 pid1 if city1==2, col
tab pid4 pid3 if city1==2, col
tab pid5 pid4 if city1==2, col
tab pid6 pid5 if city1==2, col

tab pid4 pid1 if city1==1, col
tab pid6 pid4 if city1==1, col
tab pid5 pid1 if city1==1, col
tab pid6 pid1 if city1==1, col
tab pid5 pid3 if city1==1, col
tab pid6 pid3 if city1==1, col

tab pid4 pid1 if city1==2, col
tab pid6 pid4 if city1==2, col
tab pid5 pid1 if city1==2, col
tab pid6 pid1 if city1==2, col
tab pid5 pid3 if city1==2, col
tab pid6 pid3 if city1==2, col

tab pid5 pid4 if city1==1, col
tab pid6 pid4 if city1==1, col

tab pid5 pid4 if city1==2, col
tab pid6 pid4 if city1==2, col

tab pid5 pid4, col
tab pid6 pid4, col

	*now with attrition weights
tab pid3 pid1 if city1==1 [aweight=attriteweight3], col row
tab pid4 pid3 if city1==1 [aweight=attriteweight4], col row
tab pid5 pid4 if city1==1 [aweight=attriteweight5], col row
tab pid6 pid5 if city1==1 [aweight=attriteweight6], col row

tab pid3 pid1 if city1==2 [aweight=attriteweight3], col row
tab pid4 pid3 if city1==2 [aweight=attriteweight4], col row
tab pid5 pid4 if city1==2 [aweight=attriteweight5], col row
tab pid6 pid5 if city1==2 [aweight=attriteweight6], col row

tab pid4 pid1 if city1==1 [aweight=attriteweight4], cel
tab pid6 pid4 if city1==1 [aweight=attriteweight6], cel
tab pid5 pid1 if city1==1 [aweight=attriteweight5], cel
tab pid6 pid1 if city1==1 [aweight=attriteweight6], cel
tab pid5 pid3 if city1==1 [aweight=attriteweight5], cel
tab pid6 pid3 if city1==1 [aweight=attriteweight6], cel

tab pid4 pid1 if city1==2 [aweight=attriteweight4], cel
tab pid6 pid4 if city1==2 [aweight=attriteweight6], cel
tab pid5 pid1 if city1==2 [aweight=attriteweight5], cel
tab pid6 pid1 if city1==2 [aweight=attriteweight6], cel
tab pid5 pid3 if city1==2 [aweight=attriteweight5], cel
tab pid6 pid3 if city1==2 [aweight=attriteweight6], cel

restore

*REGRESSIONS: For Table 3

sort id wave
recode pt 1=0 0=1, gen(nonpt)

*Wave 1 to 3
*create vars for transitions model
gen awarez_pt=awarez*l2.pt
gen awarez_nonpt=awarez*l2.nonpt
gen awarez_pt_l2=l2.awarez*l2.pt
gen awarez_nonpt_l2=l2.awarez*l2.nonpt

gen self_in_issue_space_pt=self_in_issue_space*l2.pt
gen self_in_issue_space_nonpt=self_in_issue_space*l2.nonpt
gen self_in_issue_space_pt_l2=l2.self_in_issue_space*l2.pt
gen self_in_issue_space_nonpt_l2=l2.self_in_issue_space*l2.nonpt

gen ptnumdisc_pt=ptnumdisc*l2.pt
gen ptnumdisc_nonpt=ptnumdisc*l2.nonpt
gen ptnumdisc_pt_l=l.ptnumdisc*l2.pt
gen ptnumdisc_nonpt_l=l.ptnumdisc*l2.nonpt

gen nonptnumdisc_pt=nonptnumdisc*l2.pt
gen nonptnumdisc_nonpt=nonptnumdisc*l2.nonpt
gen nonptnumdisc_pt_l=l.nonptnumdisc*l2.pt
gen nonptnumdisc_nonpt_l=l.nonptnumdisc*l2.nonpt

gen ses_pt_l2=l2.ses*l2.pt
gen ses_nonpt_l2=l2.ses*l2.nonpt

gen s10_age_pt_l2=l2.s10_age*l2.pt
gen s10_age_nonpt_l2=l2.s10_age*l2.nonpt

gen city_pt=city*l2.pt
gen city_nonpt=city*l2.nonpt

gen lulatraits_pt=lulatraits*l2.pt
gen lulatraits_nonpt=lulatraits*l2.nonpt
gen lulatraits_pt_l2=l2.lulatraits*l2.pt
gen lulatraits_nonpt_l2=l2.lulatraits*l2.nonpt

gen lula_in_issue_space_pt=lula_in_issue_space*l2.pt
gen lula_in_issue_space_nonpt=lula_in_issue_space*l2.nonpt
gen lula_in_issue_space_pt_l2=l2.lula_in_issue_space*l2.pt
gen lula_in_issue_space_nonpt_l2=l2.lula_in_issue_space*l2.nonpt

gen econevals_pt=econevals*l2.pt
gen econevals_nonpt=econevals*l2.nonpt
gen econevals_pt_l2=l2.econevals*l2.pt
gen econevals_nonpt_l2=l2.econevals*l2.nonpt

gen l2pt=l2.pt

sort id wave

	*Multiple imputation
preserve
keep if wave==3 & pt~=. & l2pt~=. 
ice pt self_in_issue_space_pt self_in_issue_space_pt_l2 ptnumdisc_pt ptnumdisc_pt_l nonptnumdisc_pt nonptnumdisc_pt_l awarez_pt awarez_pt_l2 ses_pt_l2 s10_age_pt_l2  lula_in_issue_space_pt lula_in_issue_space_pt_l2 lulatraits_pt lulatraits_pt_l2 econevals_pt econevals_pt_l2  city_pt self_in_issue_space_nonpt self_in_issue_space_nonpt_l2 ptnumdisc_nonpt ptnumdisc_nonpt_l nonptnumdisc_nonpt nonptnumdisc_nonpt_l awarez_nonpt awarez_nonpt_l2 ses_nonpt_l2 s10_age_nonpt_l2 lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l2 lulatraits_nonpt lulatraits_nonpt_l2 econevals_nonpt econevals_nonpt_l2  city_nonpt l2pt attriteweight3, m(5) saving(wave3imputes, replace) seed(811345)
use "`stick':\My Documents\Research\Paper Anand\Imputes\wave3imputes.dta", clear
		*Model 1
mim: probit pt lula_in_issue_space_pt lula_in_issue_space_pt_l2 self_in_issue_space_pt self_in_issue_space_pt_l2 lulatraits_pt lulatraits_pt_l2 econevals_pt econevals_pt_l2 city_pt lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l2 self_in_issue_space_nonpt self_in_issue_space_nonpt_l2 lulatraits_nonpt lulatraits_nonpt_l2 econevals_nonpt econevals_nonpt_l2 city_nonpt l2pt [pweight=attriteweight3]
		*Model 5
mim: probit pt ptnumdisc_pt ptnumdisc_pt_l nonptnumdisc_pt nonptnumdisc_pt_l ses_pt_l2 s10_age_pt_l2 awarez_pt city_pt ptnumdisc_nonpt ptnumdisc_nonpt_l nonptnumdisc_nonpt nonptnumdisc_nonpt_l ses_nonpt_l2 s10_age_nonpt_l2 awarez_pt_l2 city_nonpt l2pt [pweight=attriteweight3]

		*Estimate predicted probs
estsimp probit pt lula_in_issue_space_pt lula_in_issue_space_pt_l2 self_in_issue_space_pt self_in_issue_space_pt_l2 lulatraits_pt lulatraits_pt_l2 econevals_pt econevals_pt_l2 city_pt lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l2 self_in_issue_space_nonpt self_in_issue_space_nonpt_l2 lulatraits_nonpt lulatraits_nonpt_l2 econevals_nonpt econevals_nonpt_l2 city_nonpt l2pt if _mj==1

setx lula_in_issue_space_pt 1 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 1 self_in_issue_space_pt_l2 1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 2 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 1 self_in_issue_space_pt_l2 1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 3 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 1 self_in_issue_space_pt_l2 1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 4 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 1 self_in_issue_space_pt_l2 1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 5 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 1 self_in_issue_space_pt_l2 1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr

setx lula_in_issue_space_pt 1 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2 self_in_issue_space_pt_l2 2 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 2 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2 self_in_issue_space_pt_l2 2 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 3 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2 self_in_issue_space_pt_l2 2 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 4 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2 self_in_issue_space_pt_l2 2 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 5 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2 self_in_issue_space_pt_l2 2 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr

setx lula_in_issue_space_pt 1 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 3 self_in_issue_space_pt_l2 3 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 2 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 3 self_in_issue_space_pt_l2 3 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 3 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 3 self_in_issue_space_pt_l2 3 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 4 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 3 self_in_issue_space_pt_l2 3 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 5 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 3 self_in_issue_space_pt_l2 3 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr

setx lula_in_issue_space_pt 1 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 4 self_in_issue_space_pt_l2 4 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 2 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 4 self_in_issue_space_pt_l2 4 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 3 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 4 self_in_issue_space_pt_l2 4 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 4 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 4 self_in_issue_space_pt_l2 4 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 5 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 4 self_in_issue_space_pt_l2 4 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr

setx lula_in_issue_space_pt 1 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 5 self_in_issue_space_pt_l2 5 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 2 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 5 self_in_issue_space_pt_l2 5 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 3 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 5 self_in_issue_space_pt_l2 5 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 4 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 5 self_in_issue_space_pt_l2 5 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 5 lula_in_issue_space_pt_l2 1 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 5 self_in_issue_space_pt_l2 5 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr

	*statement about effect of lulatraits
setx lula_in_issue_space_pt 0 lula_in_issue_space_pt_l2 0 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 0 econevals_pt_l2 0 self_in_issue_space_pt 0 self_in_issue_space_pt_l2 0 city_pt 0 lula_in_issue_space_nonpt 1.7 lula_in_issue_space_nonpt_l2 1.7 lulatraits_nonpt -.1 lulatraits_nonpt_l2 -.1 econevals_nonpt 2.5 econevals_nonpt_l2 2.5 self_in_issue_space_nonpt 2.1 self_in_issue_space_nonpt_l2 2.1 city_nonpt 1.5 l2pt 0
simqi, pr
setx lula_in_issue_space_pt 0 lula_in_issue_space_pt_l2 0 lulatraits_pt 0 lulatraits_pt_l2 0 econevals_pt 0 econevals_pt_l2 0 self_in_issue_space_pt 0 self_in_issue_space_pt_l2 0 city_pt 0 lula_in_issue_space_nonpt 1.7 lula_in_issue_space_nonpt_l2 1.7 lulatraits_nonpt .2 lulatraits_nonpt_l2 -.1 econevals_nonpt 2.5 econevals_nonpt_l2 2.5 self_in_issue_space_nonpt 2.1 self_in_issue_space_nonpt_l2 2.1 city_nonpt 1.5 l2pt 0
simqi, pr

setx lula_in_issue_space_pt 1.7 lula_in_issue_space_pt_l2 1.7 lulatraits_pt -.1 lulatraits_pt_l2 -.1 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2.1 self_in_issue_space_pt_l2 2.1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr
setx lula_in_issue_space_pt 1.7 lula_in_issue_space_pt_l2 1.7 lulatraits_pt .2 lulatraits_pt_l2 -.1 econevals_pt 2.5 econevals_pt_l2 2.5 self_in_issue_space_pt 2.1 self_in_issue_space_pt_l2 2.1 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l2 0 lulatraits_nonpt 0 lulatraits_nonpt_l2 0 econevals_nonpt 0 econevals_nonpt_l2 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l2 0 city_nonpt 0 l2pt 1
simqi, pr

restore


*Wave 3 to 4
*create vars for transitions model
drop awarez_pt - econevals_nonpt_l2
sort id wave
gen awarez_pt=awarez*l.pt
gen awarez_nonpt=awarez*l.nonpt
gen awarez_pt_l=l.awarez*l.pt
gen awarez_nonpt_l=l.awarez*l.nonpt

gen self_in_issue_space_pt=self_in_issue_space*l.pt
gen self_in_issue_space_nonpt=self_in_issue_space*l.nonpt
gen self_in_issue_space_pt_l=l.self_in_issue_space*l.pt
gen self_in_issue_space_nonpt_l=l.self_in_issue_space*l.nonpt

gen ses_pt_l2=l2.ses*l.pt
gen ses_nonpt_l2=l2.ses*l.nonpt

gen s10_age_pt_l=l.s10_age*l.pt
gen s10_age_nonpt_l=l.s10_age*l.nonpt

gen city_pt=city*l.pt
gen city_nonpt=city*l.nonpt

gen lulatraits_pt=lulatraits*l.pt
gen lulatraits_nonpt=lulatraits*l.nonpt
gen lulatraits_pt_l=l.lulatraits*l.pt
gen lulatraits_nonpt_l=l.lulatraits*l.nonpt

gen lula_in_issue_space_pt=lula_in_issue_space*l.pt
gen lula_in_issue_space_nonpt=lula_in_issue_space*l.nonpt
gen lula_in_issue_space_pt_l=l.lula_in_issue_space*l.pt
gen lula_in_issue_space_nonpt_l=l.lula_in_issue_space*l.nonpt

gen econevals_pt=econevals*l.pt
gen econevals_nonpt=econevals*l.nonpt
gen econevals_pt_l=l.econevals*l.pt
gen econevals_nonpt_l=l.econevals*l.nonpt

gen l1pt=l.pt

	*Multiple imputation
preserve
keep if wave==4 & pt~=. & l1pt~=. 
ice pt self_in_issue_space_pt self_in_issue_space_pt_l awarez_pt awarez_pt_l ses_pt_l2 s10_age_pt_l city_pt self_in_issue_space_nonpt self_in_issue_space_nonpt_l awarez_nonpt awarez_nonpt_l ses_nonpt_l2 s10_age_nonpt_l lula_in_issue_space_pt lula_in_issue_space_pt_l lulatraits_pt lulatraits_pt_l econevals_pt econevals_pt_l lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l lulatraits_nonpt lulatraits_nonpt_l econevals_nonpt econevals_nonpt_l  l1pt attriteweight4, m(5) saving(wave4imputes, replace) seed(62812)
use "`stick':\My Documents\Research\Paper Anand\Imputes\wave4imputes.dta", clear
		*Model 2
mim: probit pt lula_in_issue_space_pt lula_in_issue_space_pt_l self_in_issue_space_pt self_in_issue_space_pt_l lulatraits_pt lulatraits_pt_l econevals_pt econevals_pt_l city_pt  lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l self_in_issue_space_nonpt self_in_issue_space_nonpt_l lulatraits_nonpt lulatraits_nonpt_l econevals_nonpt econevals_nonpt_l city_nonpt l1pt [pweight=attriteweight4]
		*Model 6
mim: probit pt awarez_pt_l ses_pt_l2 s10_age_pt_l city_pt awarez_nonpt_l ses_nonpt_l2 s10_age_nonpt_l city_nonpt  l1pt [pweight=attriteweight4]
restore

*Wave 4 to 5
*create vars for transitions model
drop ses_pt_l2 ses_nonpt_l2 
gen ses_pt_l=l.ses*l.pt
gen ses_nonpt_l=l.ses*l.nonpt
sort id wave
gen v81_lulagovpresapprove_pt=v81_lulagovpresapprove*l.pt
gen v81_lulagovpresapprove_nonpt=v81_lulagovpresapprove*l.nonpt
gen v81_lulagovpresapprove_pt_l=l.v81_lulagovpresapprove*l.pt
gen v81_lulagovpresapprove_nonpt_l=l.v81_lulagovpresapprove*l.nonpt

gen corruptperceive_pt=corruptperceive*l.pt
gen corruptperceive_nonpt=corruptperceive*l.nonpt
gen corruptperceive_pt_l=l.corruptperceive*l.pt
gen corruptperceive_nonpt_l=l.corruptperceive*l.nonpt

	*Now with multiple imputation
preserve
keep if wave==5 & pt~=. & l1pt~=. 
ice pt self_in_issue_space_pt self_in_issue_space_pt_l awarez_pt awarez_pt_l ses_pt_l s10_age_pt_l city_pt self_in_issue_space_nonpt self_in_issue_space_nonpt_l awarez_nonpt awarez_nonpt_l ses_nonpt_l s10_age_nonpt_l city_nonpt  lula_in_issue_space_pt lula_in_issue_space_pt_l corruptperceive_pt corruptperceive_pt_l v81_lulagovpresapprove_pt v81_lulagovpresapprove_pt_l lulatraits_pt lulatraits_pt_l econevals_pt econevals_pt_l lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l corruptperceive_nonpt corruptperceive_nonpt_l v81_lulagovpresapprove_nonpt v81_lulagovpresapprove_nonpt_l lulatraits_nonpt lulatraits_nonpt_l econevals_nonpt econevals_nonpt_l l1pt attriteweight5, m(5) saving(wave5imputes, replace) seed(28123)
use "`stick':\My Documents\Research\Paper Anand\Imputes\wave5imputes.dta", clear
		*Model 3
mim: probit pt lula_in_issue_space_pt lula_in_issue_space_pt_l corruptperceive_pt corruptperceive_pt_l self_in_issue_space_pt self_in_issue_space_pt_l lulatraits_pt lulatraits_pt_l v81_lulagovpresapprove_pt v81_lulagovpresapprove_pt_l econevals_pt econevals_pt_l city_pt  lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l corruptperceive_nonpt corruptperceive_nonpt_l self_in_issue_space_nonpt self_in_issue_space_nonpt_l lulatraits_nonpt lulatraits_nonpt_l v81_lulagovpresapprove_nonpt v81_lulagovpresapprove_nonpt_l econevals_nonpt econevals_nonpt_l city_nonpt l1pt [pweight=attriteweight5]
		*Model 7
mim: probit pt awarez_pt_l ses_pt_l s10_age_pt_l city_pt awarez_nonpt_l ses_nonpt_l s10_age_nonpt_l city_nonpt l1pt [pweight=attriteweight5]

	*statement about effect of mensalao
estsimp probit pt lula_in_issue_space_pt lula_in_issue_space_pt_l corruptperceive_pt corruptperceive_pt_l self_in_issue_space_pt self_in_issue_space_pt_l lulatraits_pt lulatraits_pt_l v81_lulagovpresapprove_pt v81_lulagovpresapprove_pt_l econevals_pt econevals_pt_l city_pt  lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l corruptperceive_nonpt corruptperceive_nonpt_l self_in_issue_space_nonpt self_in_issue_space_nonpt_l v81_lulagovpresapprove_nonpt v81_lulagovpresapprove_nonpt_l lulatraits_nonpt lulatraits_nonpt_l econevals_nonpt econevals_nonpt_l city_nonpt l1pt if _mj==1

setx lula_in_issue_space_pt 2.4 lula_in_issue_space_pt_l 2.4 corruptperceive_pt -.4477 corruptperceive_pt_l -.4477 self_in_issue_space_pt 2.61 self_in_issue_space_pt_l 2.61 lulatraits_pt -.1349 lulatraits_pt_l -.1349 v81_lulagovpresapprove_pt 3.09 v81_lulagovpresapprove_pt_l 3.09 econevals_pt 2.728 econevals_pt_l 2.728 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l 0 corruptperceive_nonpt 0 corruptperceive_nonpt_l 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l 0 lulatraits_nonpt 0 lulatraits_nonpt_l 0 v81_lulagovpresapprove_nonpt 0 v81_lulagovpresapprove_nonpt_l 0 econevals_nonpt 0 econevals_nonpt_l 0 city_nonpt 0 l1pt 1 
simqi, pr
setx lula_in_issue_space_pt 2.4 lula_in_issue_space_pt_l 2.4 corruptperceive_pt .3979 corruptperceive_pt_l -.4477 self_in_issue_space_pt 2.61 self_in_issue_space_pt_l 2.61 lulatraits_pt -.1349 lulatraits_pt_l -.1349 v81_lulagovpresapprove_pt 3.09 v81_lulagovpresapprove_pt_l 3.09 econevals_pt 2.728 econevals_pt_l 2.728 city_pt 1.5 lula_in_issue_space_nonpt 0 lula_in_issue_space_nonpt_l 0 corruptperceive_nonpt 0 corruptperceive_nonpt_l 0 self_in_issue_space_nonpt 0 self_in_issue_space_nonpt_l 0 lulatraits_nonpt 0 lulatraits_nonpt_l 0 v81_lulagovpresapprove_nonpt 0 v81_lulagovpresapprove_nonpt_l 0 econevals_nonpt 0 econevals_nonpt_l 0 city_nonpt 0 l1pt 1 
simqi, pr

setx lula_in_issue_space_pt 0 lula_in_issue_space_pt_l 0 corruptperceive_pt 0 corruptperceive_pt_l 0 self_in_issue_space_pt 0 self_in_issue_space_pt_l 0 lulatraits_pt 0 lulatraits_pt_l 0 v81_lulagovpresapprove_pt 0 v81_lulagovpresapprove_pt_l 0 econevals_pt 0 econevals_pt_l 0 city_pt 0 lula_in_issue_space_nonpt 2.4 lula_in_issue_space_nonpt_l 2.4 corruptperceive_nonpt -.4477  corruptperceive_nonpt_l -.4477 self_in_issue_space_nonpt 2.61 self_in_issue_space_nonpt_l 2.61 lulatraits_nonpt -.1349 lulatraits_nonpt_l -.1349 v81_lulagovpresapprove_nonpt 3.09 v81_lulagovpresapprove_nonpt_l 3.09 econevals_nonpt 2.728 econevals_nonpt_l 2.728 city_nonpt 1.5 l1pt 0 
simqi, pr
setx lula_in_issue_space_pt 0 lula_in_issue_space_pt_l 0 corruptperceive_pt 0 corruptperceive_pt_l 0 self_in_issue_space_pt 0 self_in_issue_space_pt_l 0 lulatraits_pt 0 lulatraits_pt_l 0 v81_lulagovpresapprove_pt 0 v81_lulagovpresapprove_pt_l 0 econevals_pt 0 econevals_pt_l 0 city_pt 0 lula_in_issue_space_nonpt 2.4 lula_in_issue_space_nonpt_l 2.4 corruptperceive_nonpt .3979 corruptperceive_nonpt_l -.4477 self_in_issue_space_nonpt 2.61 self_in_issue_space_nonpt_l 2.61 lulatraits_nonpt -.1349 lulatraits_nonpt_l -.1349 v81_lulagovpresapprove_nonpt 3.09 v81_lulagovpresapprove_nonpt_l 3.09 econevals_nonpt 2.728 econevals_nonpt_l 2.728 city_nonpt 1.5 l1pt 0
simqi, pr

restore

*Wave 5 to 6
*create vars for transitions model
sort id wave
gen lulanumdisc_pt=lulanumdisc*l.pt
gen lulanumdisc_nonpt=lulanumdisc*l.nonpt
gen lulanumdisc_pt_l=l.lulanumdisc*l.pt
gen lulanumdisc_nonpt_l=l.lulanumdisc*l.nonpt

gen nonlulanumdisc_pt=nonlulanumdisc*l.pt
gen nonlulanumdisc_nonpt=nonlulanumdisc*l.nonpt
gen nonlulanumdisc_pt_l=l.nonlulanumdisc*l.pt
gen nonlulanumdisc_nonpt_l=l.nonlulanumdisc*l.nonpt

	*Multiple imputation
preserve
keep if wave==6 & pt~=. & l1pt~=. 
ice pt self_in_issue_space_pt self_in_issue_space_pt_l awarez_pt awarez_pt_l lulanumdisc_pt lulanumdisc_pt_l nonlulanumdisc_pt nonlulanumdisc_pt_l ses_pt_l s10_age_pt_l city_pt self_in_issue_space_nonpt self_in_issue_space_nonpt_l awarez_nonpt awarez_nonpt_l lulanumdisc_nonpt lulanumdisc_nonpt_l nonlulanumdisc_nonpt nonlulanumdisc_nonpt_l ses_nonpt_l s10_age_nonpt_l city_nonpt lula_in_issue_space_pt lula_in_issue_space_pt_l corruptperceive_pt corruptperceive_pt_l v81_lulagovpresapprove_pt v81_lulagovpresapprove_pt_l lulatraits_pt lulatraits_pt_l econevals_pt econevals_pt_l lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l corruptperceive_nonpt corruptperceive_nonpt_l v81_lulagovpresapprove_nonpt v81_lulagovpresapprove_nonpt_l lulatraits_nonpt lulatraits_nonpt_l econevals_nonpt econevals_nonpt_l l1pt attriteweight6, m(5) saving(wave6imputes, replace) seed(212221)
use "`stick':\My Documents\Research\Paper Anand\Imputes\wave6imputes.dta", clear
		*Model 4 
mim: probit pt lula_in_issue_space_pt lula_in_issue_space_pt_l corruptperceive_pt corruptperceive_pt_l self_in_issue_space_pt self_in_issue_space_pt_l lulatraits_pt lulatraits_pt_l v81_lulagovpresapprove_pt v81_lulagovpresapprove_pt_l econevals_pt econevals_pt_l city_pt  lula_in_issue_space_nonpt lula_in_issue_space_nonpt_l corruptperceive_nonpt corruptperceive_nonpt_l self_in_issue_space_nonpt self_in_issue_space_nonpt_l lulatraits_nonpt lulatraits_nonpt_l v81_lulagovpresapprove_nonpt v81_lulagovpresapprove_nonpt_l econevals_nonpt econevals_nonpt_l city_nonpt l1pt [pweight=attriteweight6]
		*Model 8
mim: probit pt lulanumdisc_pt lulanumdisc_pt_l nonlulanumdisc_pt nonlulanumdisc_pt_l awarez_pt_l ses_pt_l s10_age_pt_l city_pt lulanumdisc_nonpt lulanumdisc_nonpt_l nonlulanumdisc_nonpt nonlulanumdisc_nonpt_l awarez_nonpt_l ses_nonpt_l s10_age_nonpt_l city_nonpt l1pt [pweight=attriteweight6]

restore

log close
