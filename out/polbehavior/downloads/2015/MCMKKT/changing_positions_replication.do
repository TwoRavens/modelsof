cd "C:\Users\ddoherty\Documents\Flip Flop\ReplicationArchive\tables\"
***************************************
***************************************
***************************************
********EXPERIMENT VARYING TIMING******
***************************************
***************************************
***************************************
use "..\study1.dta", clear

** DEMOGRAPHICS
*Party ID
rename generallyspeakingdoyouusuallythi pid_stem
rename wouldyoucallyourselfastrongdemoc pid_dstr
rename wouldyoucallyourselfastrongrepub pid_rstr
rename doyouthinkofyourselfasclosertoth pid_lean
egen pid=rmean(pid_dstr pid_rstr pid_lean)
label var pid "Party ID (-3=str. D; 3=str. R)"

*Age
rename whatistheyearofyourbirth yob
gen age=2013-yob
label var age "Age (in years)"
drop if age<18

*Education
rename whatisthehighestlevelofeducation educ
label var educ "Education (1=No HS; 6=post-grad)"

*Income
rename whatwasyourtotalfamilyincomein20 income
label var income "Income (1=<$10k; 14=$150k+; 15=refused)"
gen incomemis=(income==15)
replace incomemis=1 if income==.
replace income=15 if income==.
label var incomemis "Income Refused (1=yes)"

*Race
foreach i in white black hispanic asian nativeamerican mixed other{
rename `i'whatracialorethnic r_`i'
 replace r_`i'=0 if r_`i'==.
 replace r_`i'=1 if r_`i'!=0
 label var r_`i' "`i' = 1"
}
replace r_other=r_asian+r_nativeam+r_mixed+r_other
replace r_other=1 if r_other>1
replace r_white=0 if (r_black==1)| (r_hispanic==1)|(r_other==1)
replace r_black=0 if (r_hispanic==1)|(r_other==1)
replace r_hispanic=0 if (r_other==1)
replace r_other=1 if (r_white!=1)&(r_black!=1)&(r_hispanic!=1)

label var r_other "Other race / Skipped (1=yes)"
label var r_white "White (1=yes)"
label var r_black "Black (1=yes)"
label var r_hispanic "Hispanic (1=yes)"
drop r_asian r_nativeam r_mixed 

*Gender
rename whatisyourgender female
label var female "Female (1=yes)"

*Political Interest
recode howinterestedareyouinpoliticsand (1=3) (2=2) (3=1) (*=.), gen(polinterest)
label var polinterest "Interest in politics (1=not at all; 3=very interested)"

*Ideology
gen ideology=(wehearalotoftalkthesedaysaboutli-4)
label var ideology "Ideology (-3=v. liberal; 3=v. conservative)"

** Issue Positions
gen abortion=whenitcomestoabortion
label var abortion "Abortion Position (1=pro-choice)"
drop if abortion==.

*** Treatments **
****FLIP FLOP
tab flipflop, mis gen(trt_flip_)
gen treatment_assignment=trt_flip_1+trt_flip_2*2+trt_flip_3*4+trt_flip_4*8+trt_flip_5*16
rename trt_flip_1 flip_ctrl
rename trt_flip_2 flip_trt_to_life_recent
rename trt_flip_3 flip_trt_to_choice_recent
rename trt_flip_4 flip_trt_to_life_old
rename trt_flip_5 flip_trt_to_choice_old

gen trt_recent_flip=flip_trt_to_life_recent+flip_trt_to_choice_recent
gen trt_old_flip=flip_trt_to_life_old+flip_trt_to_choice_old

label var trt_recent_flip "Recent Change of Position (1=yes)"
label var trt_old_flip "Old Change of Position (1=yes)"

** Direct Policy Agreement Measures
tab abortion_position, gen(trt_abortion)
rename trt_abortion1 trt_pro_choice
drop trt_abortion*
gen trt_agree_abortion=trt_pro_choice==abortion

gen supp_ss_change=(thinkingaboutthesocialsecuritysy-2.5)/1.5
tab ss_position, gen(trt_ss_)
rename trt_ss_2 trt_supp_ss_change
drop trt_ss_*
gen trt_agree_ss=trt_supp_ss_change*supp_ss_change

gen supp_nuclear=(buildmorenuclearpowerplantsasawa-2.5)/1.5
tab nuclear_position, gen(trt_nuclear_)
rename trt_nuclear_2 trt_supp_nuclear
drop trt_nuclear_*
gen trt_agree_nuclear=trt_supp_nuclear*supp_nuclear

label var trt_agree_abortion "Agreement: Abortion (1=yes)"
label var trt_agree_ss "Agreement: Social Security (-1=str. disagree; 1=str. agree)"
label var trt_agree_nuclear "Agreement: Nuclear Plants (-1=str. disagree; 1=str. agree)"

gen treatment_assignment_full=treatment_assignment+10*trt_supp_ss_change+100*trt_supp_nuclear

**AGREEMENT X FLIPFLOP INTERACTIONS
foreach i in trt_recent_flip trt_old_flip {
local label : variable label `i'
gen `i'Xagree_ss=`i'*trt_agree_ss
gen `i'Xagree_nuclear=`i'*trt_agree_nuclear
gen `i'Xagree_abortion=`i'*trt_agree_abortion
label var `i'Xagree_nuclear "Agree on Nuclear Power x `label'"
label var `i'Xagree_ss "Agree on Soc. Security x `label'"
label var `i'Xagree_abortion "Agree on Abortion x `label'"
}


***** Candidate Evaluation*****
**Candidate Evaluations
rename ifyoulivedinrepresentativejonesd vote_for
rename basedonwhatyouknowaboutrepresent job_rating
rename howdoyoufeelaboutrepresentativej feel_person
label var vote_for "Likely to Vote for Candidate (1=very unlikely; 7=very likely)"
label var job_rating "Rate Job Representative is Doing (1=poor; 7=excellent)"
label var feel_person "How do you Feel About Candidate as a Person? (1=negative; 7=positive)"
gen trustworthy=doyouthinkmarkjonesishonestandtr 
gen tough_decisions=representativesmustoftenmakediff 
label var trustworthy "Honest and Trustworthy Enough? (1=yes)"
label var tough_decisions "Would do a good job making tough decisions about policy matters? (1=yes)"

**Set Sample
reg vote_for job_rating feel_person female r_black r_hispanic r_other educ income incomemis ideology age pid polinterest trt_agree* trustworthy tough_decisions nuclearpowerhowlikelydoyouthinki taxeshowlikelydoyouthinkitisthat socialsecurityhowlikelydoyouthin medicarehowlikelydoyouthinkitist foreignpolicyhowlikelydoyouthink environmentalpolicyhowlikelydoyo immigrationhowlikelydoyouthinkit abortionhowlikelydoyouthinkitist
keep if e(sample)

*cand summary 
factor vote_for job_rating feel_person trustworthy tough_decisions
rotate, factor(1)
predict cand_eval 
qui sum cand_eval
replace cand_eval=(cand_eval-r(mean))/r(sd)
label var cand_eval "Evaluation of Candidate (M=0; SD=1)"

*Likely Change measures
gen change_likely_abortion=abortionhowlikelydoyouthinkitist 
factor nuclearpowerhowlikelydoyouthinki taxeshowlikelydoyouthinkitisthat socialsecurityhowlikelydoyouthin medicarehowlikelydoyouthinkitist foreignpolicyhowlikelydoyouthink environmentalpolicyhowlikelydoyo immigrationhowlikelydoyouthinkit
rotate, factor(1)
predict change_scale 
qui sum change_scale 
replace change_scale=(change_scale-r(mean))/r(sd)
label var change_likely_abortion "Likely to Change Abortion Position? (1=Ext. Unlikely; 6=Ext. Likely)"
label var change_scale "Likely to Change (Mean of all non-abortion issues)? (1=Ext. Unlikely; 6=Ext. Likely)"

rename nuclearpowerhowlikelydoyouthinki change_likely_nuclear
rename socialsecurityhowlikelydoyouthin change_likely_ss

***********************************
************TABLE A1***************
***********************************
outsum vote_for job_rating feel_person trustworthy tough_decisions age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest using "table_a1", replace bracket

**balance test
mlogit treatment_assignment age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest 
foreach i in age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest {
test `i'
}


***FLIP x IDEOLOGY (to address potential concern that liberals and conservatives respond differently to FFs; See Discussion section of paper)
gen XXideoXtrt_old_flip=trt_old_flip*ideol
gen XXideoXtrt_recent_flip=trt_recent_flip*ideol

***********************************
************TABLE 1****************
***********************************
reg cand_eval trt_agree_* trt_old_flip trt_recent_flip age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg trt_agree_* trt_old_flip trt_recent_flip using "table_1", se bracket tdec(3) replace label
test trt_old_flip==trt_recent_flip
*compare FX of agreement and Change of Position
test trt_agree_abortion==-trt_recent_flip


***********************************
************TABLE 3****************
***********************************
reg change_likely_abortion trt_agree_* trt_old_flip trt_recent_flip age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg trt_agree_* trt_old_flip trt_recent_flip using "table_3", se bracket tdec(3) replace label
test trt_old_flip==trt_recent_flip
reg change_scale trt_agree_* trt_old_flip trt_recent_flip age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg trt_agree_* trt_old_flip trt_recent_flip using "table_3", se bracket tdec(3) append label
test trt_old_flip==trt_recent_flip

***********************************
************TABLE 4****************
***********************************
pwcorr  cand_eval change_likely_abortion, sig
pwcorr  cand_eval change_likely_abortion if trt_agree_abortion==0, sig
pwcorr  cand_eval change_likely_abortion if trt_agree_abortion==1, sig

foreach i in ss nuclear{
pwcorr  cand_eval change_likely_`i', sig
pwcorr  cand_eval change_likely_`i' if trt_agree_`i'<0, sig
pwcorr  cand_eval change_likely_`i' if trt_agree_`i'>0, sig
}

***********************************
************FIGURE 1***************
***********************************
gen sum_ff=trt_old_flip+trt_recent_flip*2
table sum_ff trt_agree_abortion, c(mean cand_eval freq)

***********************************
************FIGURE 4***************
***********************************
reg cand_eval trt_agree_* trt_old_flip trt_recent_flip age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
forvalues i=0(.01)1.01{
foreach m in recent old{
qui lincom `i'*trt_agree_abortion*0.75-(1-`i')*trt_agree_abortion*0.75+trt_`m'_flip
if "`m'"=="recent"{
matrix `m'=`i',r(estimate),r(estimate)+r(se)*1.96,r(estimate)-r(se)*1.96
}
else{
matrix `m'=r(estimate),r(estimate)+r(se)*1.96,r(estimate)-r(se)*1.96
}
}

if `i'==0{
matrix full=recent,old
}
else{
matrix full=full\recent,old
}
}
putexcel A1=matrix(full) using figure_4_data, replace

***********************************
************TABLE A2***************
***********************************
foreach i in vote_for job_rating feel_person trustworthy tough_decisions {
reg `i' trt_agree_* trt_old_flip trt_recent_flip age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
if "`i'"=="vote_for"{
outreg trt_agree_* trt_old_flip trt_recent_flip using "table_a2", se bracket tdec(3) replace label
}
else{
outreg trt_agree_* trt_old_flip trt_recent_flip using "table_a2", se bracket tdec(3) append label
}
}
***********************************
************TABLE A3***************
***********************************
reg cand_eval trt_agree_* trt_old_flip trt_recent_flip trt_old_flipXagree_abortion trt_recent_flipXagree_abortion age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
test trt_old_flipXagree_abortion trt_recent_flipXagree_abortion
outreg trt_agree_* trt_old_flip trt_recent_flip trt_old_flipXagree_abortion trt_recent_flipXagree_abortion using "table_a3", se bracket tdec(3) replace label adec(3) addstat("Joint Sig. of Interaction Terms (p-value)",r(p))

reg cand_eval trt_agree_* trt_old_flip trt_recent_flip trt_old_flipXagree_abortion trt_recent_flipXagree_abortion trt_old_flipXagree_ss trt_recent_flipXagree_ss trt_old_flipXagree_nuclear trt_recent_flipXagree_nuclear age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
test trt_old_flipXagree_abortion trt_recent_flipXagree_abortion trt_old_flipXagree_ss trt_recent_flipXagree_ss trt_old_flipXagree_nuclear trt_recent_flipXagree_nuclear
outreg trt_agree_* trt_old_flip trt_recent_flip trt_old_flipXagree_abortion trt_recent_flipXagree_abortion trt_old_flipXagree_ss trt_recent_flipXagree_ss trt_old_flipXagree_nuclear trt_recent_flipXagree_nuclear using "table_a3", se bracket tdec(3) append label adec(3) addstat("Joint Sig. of Interaction Terms (p-value)",r(p))

***********************************
************TABLE A7***************
***********************************
gen diverge=0
replace diverge=1 if (trt_old_flip==1 |trt_recent_flip==1) & trt_pro_choice==0 & trt_supp_ss_change==0 & trt_supp_nuclear==0
replace diverge=1 if (trt_old_flip==1 |trt_recent_flip==1) & trt_pro_choice==1 & trt_supp_ss_change==1 & trt_supp_nuclear==1
label var diverge "Change Positions to Ideologically Inconsistent (1=yes)"

gen consistent=0
replace consistent=1 if trt_pro_choice==1 & trt_supp_ss_change==0 & trt_supp_nuclear==0
replace consistent=1 if trt_pro_choice==0 & trt_supp_ss_change==1 & trt_supp_nuclear==1
label var consistent "Ideologically Consistent (1=yes)"
foreach i in trt_old_flip trt_recent_flip{
gen consistX`i'=consistent*`i'
}
label var consistXtrt_old_flip "Old Change of Position x Ideologically Consistent"
label var consistXtrt_recent_flip "Recent Change of Position x Ideologically Consistent"
reg cand_eval trt_agree_* trt_old_flip trt_recent_flip consist* age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg trt_agree_* trt_old_flip trt_recent_flip consist* using "table_a7", se bracket tdec(3) replace label
reg cand_eval trt_agree_* trt_old_flip trt_recent_flip diverge age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg trt_agree_* trt_old_flip trt_recent_flip diverge using "table_a7", se bracket tdec(3) append label


***************************************
***************************************
***************************************
********EXPERIMENT VARYING ISSUE*******
***************************************
***************************************
***************************************
cd "C:\Users\ddoherty\Documents\Flip Flop\ReplicationArchive\tables\"
use "..\study2.dta", clear

** DEMOGRAPHICS
*Party ID
rename generallyspeakingdoyouusuallythi pid_stem
rename wouldyoucallyourselfastrongdemoc pid_dstr
rename wouldyoucallyourselfastrongrepub pid_rstr
rename doyouthinkofyourselfasclosertoth pid_lean
egen pid=rmean(pid_dstr pid_rstr pid_lean)
label var pid "Party ID (-3=str. D; 3=str. R)"

*Age
rename whatistheyearofyourbirth yob
gen age=2014-yob
label var age "Age (in years)"
gen age2=(age*age)/100
label var age2 "Age-squared/100"
drop if age<18

*Education
rename whatisthehighestlevelofeducation educ
label var educ "Education (1=No HS; 6=post-grad)"

*Income
rename whatwasyourtotalfamilyincomein20 income
label var income "Income (1=<$10k; 14=$150k+; 15=refused)"
gen incomemis=(income==15)
replace incomemis=1 if income==.
replace income=15 if income==.
label var incomemis "Income Refused (1=yes)"

*Race
foreach i in white black hispanic asian nativeamerican mixed other{
rename `i'whatracialorethnic r_`i'
 replace r_`i'=0 if r_`i'==.
 replace r_`i'=1 if r_`i'!=0
 label var r_`i' "`i' = 1"
}
replace r_other=r_asian+r_nativeam+r_mixed+r_other
replace r_other=1 if r_other>1
replace r_white=0 if (r_black==1)| (r_hispanic==1)|(r_other==1)
replace r_black=0 if (r_hispanic==1)|(r_other==1)
replace r_hispanic=0 if (r_other==1)
replace r_other=1 if (r_white!=1)&(r_black!=1)&(r_hispanic!=1)

label var r_other "Other race / Skipped (1=yes)"
label var r_white "White (1=yes)"
label var r_black "Black (1=yes)"
label var r_hispanic "Hispanic (1=yes)"
drop r_asian r_nativeam r_mixed 

*Gender
rename whatisyourgender female
label var female "Female (1=yes)"

*Political Interest
recode howinterestedareyouinpoliticsand (1=3) (2=2) (3=1) (*=.), gen(polinterest)
label var polinterest "Interest in politics (1=not at all; 3=very interested)"

*Ideology
gen ideology=(wehearalotoftalkthesedaysaboutli-4)
label var ideology "Ideology (-3=v. liberal; 3=v. conservative)"

***TREATMENTS
gen cand_ss_pos=ss_pos=="support for"
gen cand_isis_pos=isis_pos=="supports"
gen cand_nuke_pos=nuke_pos=="support for"
gen cand_abort_pos=abort_pos=="supports"
foreach i in ss isis nuke abort{
recode cand_`i'_pos (1=1) (0=-1)
}

**position changes
gen no_ff=fflop_pt1==""

tab fflop_iss_wctrl, gen(ff_ctrl_)
rename ff_ctrl_1 ff_ctrl_nuke
rename ff_ctrl_2 ff_ctrl_abort
rename ff_ctrl_3 ff_ctrl_ss
rename ff_ctrl_4 ff_ctrl_isis

tab fflop_iss_1, gen(ff_)
forvalues i=1/4{
replace ff_`i'=0 if no_ff==1
}
foreach i in abort ss isis nuke {
gen treat_`i'=ff_ctrl_`i'
replace ff_ctrl_`i'=0 if no_ff==0
}
*capture randomized issue assignment for respondents assigned to no flip-flop condition (assignment not visable to respondents)
label var ff_ctrl_abort "Control: Abortion Position (1=yes)"
label var ff_ctrl_nuke "Control: Nuclear Plants Position  (1=yes)"
label var ff_ctrl_ss "Control: Social Security Position (1=yes)"
label var ff_ctrl_isis "Control: ISIS Position (1=yes)"

gen treatment_assignment=ff_1+2*ff_2+4*ff_3+8*ff_4
gen treatment_assignment_full=treatment_assignment+16*cand_ss_pos+32*cand_isis_pos+64*cand_nuke_pos+128*cand_abort_pos
rename ff_1 ff_abort
rename ff_2 ff_nuke
rename ff_3 ff_ss
rename ff_4 ff_isis
label var ff_abort "Abortion Change of Position (1=yes)"
label var ff_nuke "Nuclear Plants Change of Position (1=yes)"
label var ff_ss "Social Security Change of Position (1=yes)"
label var ff_isis "ISIS Change of Position (1=yes)"

** Issue importance
gen imp_abort=abortionregardlessofwhatyouthink
label var imp_abort "Importance: Abortion (M=0; SD=1)"
gen imp_ss=socialsecurityregardlessofwhatyo
label var imp_ss "Importance: Social Security (M=0; SD=1)"
gen imp_isis=dealingwiththeislamicstateiniraq
label var imp_isis "Importance: ISIS (M=0; SD=1)"
gen imp_nuke=constructionofnewnuclearpowerpla
label var imp_nuke "Importance: Nuclear Plants (M=0; SD=1)"
gen imp_medicaid=medicaidregardlessofwhatyouthink
label var imp_medicaid "Importance: Medicaid (M=0; SD=1)"
gen imp_envir=environmentalpolicyregardlessofw
label var imp_envir "Importance: Environment (M=0; SD=1)"
gen imp_ssex=samesexmarriageregardlessofwhaty
label var imp_ssex "Importance: Same Sex Marriage (M=0; SD=1)"
gen imp_defense=spendingonnationaldefenseregardl
label var imp_defense "Importance: Defense Spending (M=0; SD=1)"

** Issue Confidence
gen conf_abort=abortionhowconfidentareyouthatyo
label var conf_abort "Confidence: Abortion (M=0; SD=1)"
gen conf_ss=socialsecurityhowconfidentareyou
label var conf_ss "Confidence: Social Security (M=0; SD=1)"
gen conf_isis=v56
label var conf_isis "Confidence: ISIS (M=0; SD=1)"
gen conf_nuke=v58
label var conf_nuke "Confidence: Nuclear Plants (M=0; SD=1)"
gen conf_medicaid=medicaidhowconfidentareyouthatyo
label var conf_medicaid "Confidence: Medicaid (M=0; SD=1)"
gen conf_envir=environmentalpolicyhowconfidenta
label var conf_envir "Confidence: Environment (M=0; SD=1)"
gen conf_ssex=samesexmarriagehowconfidentareyo
label var conf_ssex "Confidence: Same Sex Marriage (M=0; SD=1)"
gen conf_defense=spendingonnationaldefensehowconf
label var conf_defense "Confidence: Defense Spending (M=0; SD=1)"

** Issue Positions
gen iss_abort=lawsthatensurethatwomenhaveacces
label var iss_abort "R's Abortion Position (-2=strongly oppose; 2=strongly support)"
gen iss_ss=increasingtheageatwhichpeoplebor
label var iss_ss "R's Social Security Position (-2=strongly oppose; 2=strongly support)"
gen iss_isis=sendingamericangroundtroopsintoi
label var iss_isis "R's ISIS Position (-2=strongly oppose; 2=strongly support)"
gen iss_nuke=issuingmorefederalpermitstoallow
label var iss_nuke "R's Nuclear Power Position (-2=strongly oppose; 2=strongly support)"
gen iss_medicaid=makinglowincomeadultswithoutchil
label var iss_medicaid "R's Medicaid Position (-2=strongly oppose; 2=strongly support)"
gen iss_fuel=increasingfuelefficiencystandard
label var iss_fuel "R's Fuel Efficiency Position (-2=strongly oppose; 2=strongly support)"
gen iss_ssex=legalizingsamesexmarriageinallst
label var iss_ssex "R's Same Sex Marriage Position (-2=strongly oppose; 2=strongly support)"
gen iss_defense=reducingspendingonnationaldefens
label var iss_defense "R's Defense Spending Position (-2=strongly oppose; 2=strongly support)"

**Candidate likely to change positions?
gen change_abort=abortionhowlikelydoyouthinkitist
label var change_abort "Likely to Change: Abortion (1=extremely unlikely; 6=extremely likely)"
gen change_ss=socialsecurityhowlikelydoyouthin
label var change_ss "Likely to Change: Social Security (1=extremely unlikely; 6=extremely likely)"
gen change_isis=v92
label var change_isis "Likely to Change: ISIS (1=extremely unlikely; 6=extremely likely)"
gen change_nuke=v93
label var change_nuke "Likely to Change: Nuclear Plants (1=extremely unlikely; 6=extremely likely)"
gen change_ss_d=medicaidhowlikelydoyouthinkitist
label var change_ss_d "Likely to Change: Medicaid (1=extremely unlikely; 6=extremely likely)"
gen change_nuke_d=environmentalpolicyhowlikelydoyo
label var change_nuke_d "Likely to Change: Environment (1=extremely unlikely; 6=extremely likely)"
gen change_abort_d=samesexmarriagehowlikelydoyouthi
label var change_abort_d "Likely to Change: Same Sex Marriage (1=extremely unlikely; 6=extremely likely)"
gen change_isis_d=spendingonnationaldefensehowlike
label var change_isis_d "Likely to Change: Defense (1=extremely unlikely; 6=extremely likely)"

*generate dummies to pull labels from
gen ss=0
label var ss "Social Security"
gen isis=0
label var isis "ISIS"
gen nuke=0
label var nuke "Nuclear Plants"
gen abort=0
label var abort "Abortion"

**Agreement measure
foreach i in ss isis nuke abort {
local label : variable label `i'
*att strength
gen str_`i'=abs(iss_`i')
label var str_`i' "Strength of Attitude: `label' (0-2)"
*agreement w/current candidate position
gen `i'_agree=(cand_`i'_pos*iss_`i')/2
label var `i'_agree "Agreement: `label' (-1=str. disagree; 1=str. agree)"
*agreement x flip flop on issue
gen ffXagree_`i'=`i'_agree*ff_`i'
label var ffXagree_`i' "`label': Agreement x Change of Position"
}

*Importance and Confidence correlations
foreach i in abort ss isis nuke {
corr imp_`i' conf_`i' str_`i'
}

**Candidate Evaluations
rename ifyoulivedinrepresentativejonesd vote_for
rename basedonwhatyouknowaboutrepresent job_rating
rename howdoyoufeelaboutrepresentativej feel_person
label var vote_for "Likely to Vote for Candidate (1=very unlikely; 7=very likely)"
label var job_rating "Rate Job Representative is Doing (1=poor; 7=excellent)"
label var feel_person "How do you Feel About Candidate as a Person? (1=negative; 7=positive)"
gen trustworthy=doyouthinkrepresentativejonesish
gen tough_decisions=representativesintheushousemusto
label var trustworthy "Honest and Trustworthy Enough? (1=yes)"
label var tough_decisions "Would do a good job making tough decisions about policy matters? (1=yes)"

**Set Sample
reg vote_for job_rating feel_person trustworthy tough_decisions ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffX* conf_ss conf_isis conf_nuke conf_abort imp_ss imp_isis imp_nuke imp_abort  age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest change_*, r
keep if e(sample)

**balance test
//mlogit treatment_assignment_full age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest 
mlogit treatment_assignment age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest 
foreach i in age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest {
test `i'
}


*cand summary 
factor vote_for job_rating feel_person trustworthy tough_decisions
rotate, factor(1)
predict cand_eval 
qui sum cand_eval
replace cand_eval=(cand_eval-r(mean))/r(sd)
label var cand_eval "Evaluation of Candidate (M=0; SD=1)"

*likely change measure
factor change_*_d
rotate, factor(1)
predict likelychange
qui sum likelychange
replace likelychange=(likelychange-r(mean))/r(sd)
label var likelychange "Likely to Change: Four additional issues (M=0; SD=1)"

****Importance and Confidence interactions for analysis collapsing across issues (Table A5)
gen SUM_agree=.
label var SUM_agree "Agreement on Policy (-1=str. disagree; 1=str. agree)"
gen SUM_ff=.
label var SUM_ff "Change of Position (1=yes)"
gen SUM_ffXconf=.
label var SUM_ffXconf "Confidence x Change of Position"
gen SUM_ffXimp=.
label var SUM_ffXimp "Importance x Change of Position"
gen SUM_conf=.
label var SUM_conf "Confidence (M=0; SD=1)"
gen SUM_imp=.
label var SUM_imp "Importance (M=0; SD=1)"
gen X_SUM_change=.
label var X_SUM_change "Likely Change on Issue (1-6)"

foreach i in ss isis nuke abort {
replace SUM_agree=`i'_agree if treat_`i'==1
replace SUM_ff=ff_`i' if treat_`i'==1
replace SUM_conf=conf_`i' if treat_`i'==1
replace SUM_imp=imp_`i' if treat_`i'==1
replace X_SUM_change=change_`i' if treat_`i'==1
}
qui sum SUM_conf
replace SUM_conf=(SUM_conf-r(mean))/r(sd)
qui sum SUM_imp
replace SUM_imp=(SUM_imp-r(mean))/r(sd)

replace SUM_ffXconf=SUM_conf*SUM_ff
replace SUM_ffXimp=SUM_imp*SUM_ff

*Demographics Position Change Interactions
foreach i in age female r_black r_hispanic r_other educ income incomemis polinterest {
local label : variable label `i'
gen XX_`i'_ff=`i'*SUM_ff
label var XX_`i'_ff "`label' x Change of Position"
}

***********************************
************FIGURE 2***************
***********************************
ci imp_ss imp_isis imp_nuke imp_abort, sep(0)
ci conf_ss conf_isis conf_nuke conf_abort, sep(0)

****Importance and Confidence interactions for Table 2
**standardize confidence and importance interactions to have mean of 0; SD=1
foreach i of var conf_* imp_*{
qui sum `i'
replace `i'=(`i'-r(mean))/r(sd)
}
*individual confidence/importance interactions
foreach i in ss isis nuke abort{
local label : variable label `i'
*confidence x flip flop on issue
gen ffXconf_`i'=conf_`i'*ff_`i'
label var ffXconf_`i' "`label': Confidence x Change of Position"
*importance x flip flop on issue
gen ffXimp_`i'=imp_`i'*ff_`i'
label var ffXimp_`i' "`label': Importance x Change of Position"
}


***********************************
************TABLE A1***************
***********************************
outsum vote_for job_rating feel_person trustworthy tough_decisions age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest using "table_a1", append bracket


***********************************
************TABLE 2****************
***********************************
reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort using "table_2", se bracket tdec(3) replace label 
foreach i in ss isis nuke abort{
test `i'_agree*2=-ff_`i'
}

reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffXconf_* ffXimp_* conf_ss conf_isis conf_nuke conf_abort imp_ss imp_isis imp_nuke imp_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
test ffXconf_ss ffXconf_isis ffXconf_nuke ffXconf_abort
local conf=r(p)
test ffXimp_ss ffXimp_isis ffXimp_nuke ffXimp_abort
local imp=r(p)
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffXconf_* ffXimp_* conf_ss conf_isis conf_nuke conf_abort imp_ss imp_isis imp_nuke imp_abort using "table_2", se bracket tdec(3) append label adec(3) addstat("Joint Sig. of Confidence Interaction Terms (p-value)",`conf',"Joint Sig. of Importance Interaction Terms (p-value)",`imp')

*SEPARATE MODELS for Importance and Confidence interactions. Substantively similar findings.
reg cand_eval SUM_agree SUM_ff SUM_ffXconf SUM_conf SUM_imp age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
reg cand_eval SUM_agree SUM_ff SUM_ffXimp SUM_conf SUM_imp age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r

***********************************
************TABLE 3****************
***********************************
foreach i in ss isis nuke abort {
reg change_`i' ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort using "table_3", se bracket tdec(3) append label 
test ff_`i'==ff_ss
test ff_`i'==ff_isis
test ff_`i'==ff_nuke
test ff_`i'==ff_abort
}
reg likelychange ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort using "table_3", se bracket tdec(3) append label 


***********************************
************TABLE 4****************
***********************************
foreach i in abort ss nuke isis {
pwcorr  cand_eval change_`i', sig
pwcorr  cand_eval change_`i' if `i'_agree>0, sig
pwcorr  cand_eval change_`i' if `i'_agree<0, sig
}



***********************************
************FIGURE 3***************
***********************************
*collapse agree/disagree
recode ss_agree isis_agree nuke_agree abort_agree (-1/-.4=0) (.4/1=1) (*=.), gen(col_ss_agree col_isis_agree col_nuke_agree col_abort_agree)
*means by agree x change of position
foreach i in ss isis nuke abort{
table ff_`i' col_`i'_agree, c(mean cand_eval)
}
*footnote on comparision of switched, but agree, v no change and disagree
foreach i in ss isis nuke abort{
gen Xcol_`i'=col_`i'_agree*ff_`i'
}
foreach i in ss isis nuke abort{
qui reg cand_eval col_`i'_agree ff_`i' Xcol_`i', r
lincom col_`i'_agree+ff_`i'+Xcol_`i'
}

***********************************
************FIGURE 5***************
***********************************
reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
forvalues i=0(.01).81{
foreach m in ss isis nuke abort{
qui lincom `i'*`m'_agree*1.5-(.8-`i')*`m'_agree*1.5+ff_`m'
if "`m'"=="ss"{
matrix `m'=`i'/.8,r(estimate),r(estimate)+r(se)*1.96,r(estimate)-r(se)*1.96
}
else{
matrix `m'=r(estimate),r(estimate)+r(se)*1.96,r(estimate)-r(se)*1.96
}
}
if `i'==0{
matrix full=ss,isis,nuke,abort
}
else{
matrix full=full\ss,isis,nuke,abort
}
}
putexcel A1=matrix(full) using figure_5_data, replace


*footnote illustration about strength of preferences
reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
lincom .4*abort_agree*1.5-(.4)*abort_agree*1.5+ff_abort
lincom .4*abort_agree*2-(.4)*abort_agree*1+ff_abort


***********************************
************TABLE A3***************
***********************************
reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffXagree* age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r 
test ffXagree_ss ffXagree_isis ffXagree_nuke ffXagree_abort 
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffXagree* using "table_a3", se bracket tdec(3) append label adec(3) addstat("Joint Sig. of Interaction Terms (p-value)",r(p))

***********************************
************TABLE A4***************
***********************************
foreach i in vote_for job_rating feel_person trustworthy tough_decisions {
reg `i' ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
if "`i'"=="vote_for"{
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort using "table_a4", se bracket tdec(3) replace label 
}
else{
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort using "table_a4", se bracket tdec(3) append label 
}
/*
reg `i' ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffXagree* age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r 
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort ffXagree* using "cand_evals_indiv", se bracket tdec(3) append label 
*/
}

foreach i in vote_for job_rating feel_person trustworthy tough_decisions {
qui reg `i' ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
test ff_abort==ff_ss
}

***********************************
************TABLE A5***************
***********************************
reg cand_eval SUM* age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg using "table_a5", se bracket tdec(3) replace label 
reg cand_eval SUM* age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest XX*, r
outreg using "table_a5", se bracket tdec(3) append label 

***********************************
************TABLE A6***************
***********************************
sureg (change_ss ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_ss_d ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_isis ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_isis_d ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_nuke ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_nuke_d ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_abort ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest) (change_abort_d ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest)
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort using "table_a6", se bracket tdec(3) replace label 
//Domain-relevant treatment largest effect within domain?
foreach m in ss isis nuke abort{
local p=0
local p_d=0
foreach i in ss isis nuke abort{
qui test [change_`m']ff_`m'==[change_`m']ff_`i'
if r(p)>`p' & r(p)!=.{
local p=r(p)/2
}
qui test [change_`m'_d]ff_`m'==[change_`m'_d]ff_`i'
if r(p)>`p_d' & r(p)!=.{
local p_d=r(p)/2
}
}
disp "`m'" `p'
disp "`m'" `p_d'
}

//Domain-relevant treatment largest for domain-relevant outcome?
foreach m in ss isis nuke abort{
local p=0
local p_d=0
foreach i in ss isis nuke abort ss_d isis_d nuke_d abort_d{
if "`i'"!="`m'"{
qui test [change_`m']ff_`m'==[change_`i']ff_`m'
if r(p)>`p' & r(p)!=.{
local p=r(p)/2
}
qui test [change_`m'_d]ff_`m'==[change_`i']ff_`m'
if r(p)>`p_d' & r(p)!=.{
local p_d=r(p)/2
}
}
}
disp "`m'" `p'
disp "`m'" `p_d'
}


***********************************
************TABLE A7***************
***********************************
gen diverge=0
replace diverge=1 if ff_abort==1 & cand_abort_pos==-1 & cand_ss_pos==-1 & cand_nuke_pos==-1 & cand_isis_pos==-1
replace diverge=1 if ff_abort==1 & cand_abort_pos==1 & cand_ss_pos==1 & cand_nuke_pos==1 & cand_isis_pos==1
replace diverge=1 if ff_ss==1 &  cand_abort_pos==1 & cand_ss_pos==1 & cand_nuke_pos==-1 & cand_isis_pos==-1
replace diverge=1 if ff_ss==1 & cand_abort_pos==-1 & cand_ss_pos==-1 & cand_nuke_pos==1 & cand_isis_pos==1
replace diverge=1 if ff_nuke==1 &  cand_abort_pos==1 & cand_ss_pos==-1 & cand_nuke_pos==1 & cand_isis_pos==-1
replace diverge=1 if ff_nuke==1 & cand_abort_pos==-1 & cand_ss_pos==1 & cand_nuke_pos==-1 & cand_isis_pos==1
replace diverge=1 if ff_isis==1 &  cand_abort_pos==1 & cand_ss_pos==-1 & cand_nuke_pos==-1 & cand_isis_pos==1
replace diverge=1 if ff_isis==1 & cand_abort_pos==-1 & cand_ss_pos==1 & cand_nuke_pos==1 & cand_isis_pos==-1
label var diverge "Change Positions to Ideologically Inconsistent (1=yes)"

gen consistent=0
replace consistent=1 if cand_abort_pos==1 & cand_ss_pos==-1 & cand_nuke_pos==-1 & cand_isis_pos==-1
replace consistent=1 if cand_abort_pos==-1 & cand_ss_pos==1 & cand_nuke_pos==1 & cand_isis_pos==1
label var consistent "Ideologically Consistent (1=yes)"
foreach i in ff_ss ff_nuke ff_isis ff_abort {
gen consistX`i'=consistent*`i'
}
label var consistXff_ss "Social Security Change of Position x Ideologically Consistent"
label var consistXff_isis "ISIS Change of Position x Ideologically Consistent"
label var consistXff_nuke "Nuclear Plants Change of Position x Ideologically Consistent"
label var consistXff_abort "Abortion Change of Position x Ideologically Consistent"
reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort consist* age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort consist* using "table_a7", se bracket tdec(3) append label
reg cand_eval ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort diverge age female r_black r_hispanic r_other educ income incomemis ideology pid polinterest, r
outreg ss_agree isis_agree nuke_agree abort_agree ff_ss ff_isis ff_nuke ff_abort diverge using "table_a7", se bracket tdec(3) append label

