
************************** REPLICATION CODE FOR:
************************** Smith, Amy Erica. "Talking It Out: Political Conversation and Knowledge Gaps in Unequal Urban Contexts"
************************** British Journal of Political Science
************************** If you have questions, please get in touch with me: amyericas@gmail.com.


********************************************** DATA AND DO FILE SET-UP **************************************************************************
* MODIFY THE FOLLOWING PATH AS NECESSARY FOR YOUR MACHINE
cd "C:\Users\aesmith2\Dropbox\Work\published\Articles and chapters\Smith 2015 BJPS\Final\analysis\"
use TalkingItOut_RepData_SmithBJPS.dta

capture program drop carryvalues
program carryvalues 
	args i
	replace `i' = l.`i' if `i' == .
	replace `i' = f.`i' if `i' == .
	replace `i' = l2.`i' if `i' == .
	replace `i' = f2.`i' if `i' == .
	replace `i' = l3.`i' if `i' == .
	replace `i' = f3.`i' if `i' == .
	replace `i' = l4.`i' if `i' == .
	replace `i' = f4.`i' if `i' == .
	replace `i' = l5.`i' if `i' == .
	replace `i' = f5.`i' if `i' == .
end

lab def wave 1 "April 2002" 2 "Jul 2002" 3 "Oct 2002" 4 "April 2004" 5 "Aug 2006" 6 "Oct 2006", modify
lab val wave wave
lab var wave "Survey Administration"
tab wave, g(wave)
sort id wave
g waveC = wave3 + wave6

**** DROP A FEW PEOPLE IN NEIGHBORHOODS WHERE THERE AREN'T ENOUGH PEOPLE TO DISTINGUISH THE IMPACT OF INDIVIDUAL & NEIGHBORHOOD CHARACTERISTICS
egen num_nbhd = count(bairroamob), by(bairroamob)
drop if num_nbhd <= 36


******************************************************* INDEPENDENT VARIABLES **************************************************************************

***** Political discussion 
recode v16c_converseworkorschool (4 = 0) (3 = .33) (2 = .67) (1 = 1) (8 9 = .) (10 = 0), g(converse_work)
recode v16e_conversefriends (4 = 0) (3 = .33) (2 = .67) (1 = 1) (8 9 10 = .), g(converse_friends)
recode v16g_conversefamily (4 = 0) (3 = .33) (2 = .67) (1 = 1) (8 9 10 = .), g(converse_fam)
alpha  converse_work converse_friends converse_fam 
egen converse = rowmean(converse_work converse_friends converse_fam)

**** Size of Social Network
egen snwsize = anycount(v74_disc1named v75_disc2named v76_disc3named), values(1)
replace snwsize = . if wave != 3 & wave != 5
replace snwsize = f.snwsize if wave == 2
replace snwsize = l.snwsize if wave == 6
tab snwsize wave
g snwsize_w2 = l3.snwsize if wave == 5
replace snwsize_w2 = l4.snwsize if wave == 6
replace snwsize_w2 = l.snwsize if wave == 3
replace snwsize_w2 = snwsize if wave == 2
corr snwsize_w2 snwsize if wave == 3

***** Media consumption
recode v7b1fq_ 7 = 6 
g tvfreq = v7b1fq_/6 if v7b1fq_ < 8
g paperfreq = v9b1fq_/7 if v9b1fq_ < 8
recode tvfreq paperfreq (. = 0)

***** Married/partner
recode s5a_maritalstatus (1 5 = 1) (2 3 4 8 9 = 0), g(haspartner)
carryvalues haspartner

***** Female
g female = s1_-1
carryvalues female

***** Age
replace age = l.age if age == . & wave != 4 & wave != 5
replace age = l.age+2 if age == . & (wave == 4 | wave == 5)
replace age = f.age if age == . & wave != 3 & wave != 4
replace age = f.age-2 if age == . & (wave == 3 | wave == 4)
replace age = l2.age if age == . & wave < 4
replace age = l2.age+2 if age == . & (wave == 4 | wave == 6)
replace age = l2.age+4 if age == . & wave == 5
replace age = f2.age if age == . & wave == 1
replace age = f2.age-2 if age == . & (wave == 2 | wave == 4)
replace age = f2.age-4 if age == . & wave == 3
replace age = l3.age+2 if age == . & wave == 4
replace age = l3.age+4 if age == . & (wave == 5 | wave == 6)
replace age = f3.age-2 if age == . & wave == 1
replace age = f3.age-4 if age == . & (wave == 2 | wave == 3)
replace age = l4.age+4 if age == . 
replace age = f4.age-4 if age == .
replace age = l5.age+4 if age == .
replace age = f5.age-4 if age == .
recode age (15/29 = 1) (30/49 = 2) (50/69 = 3) (70/105 = 4), g(agecohort)
lab def agecohort 1 "16-29" 2 "30-49" 3 "50-69" 4 "70+"
lab val agecohort agecohort
tab agecohort, g(age_)
rename age_1 age_15_29
rename age_2 age_30_49
rename age_3 age_50_69
rename age_4 age_70up
lab var age_15_29 "15-29"
lab var age_30_49 "30-49"
lab var age_50_69 "50-69"
lab var age_70up "70 and up"

recode s7a_ (1 = 1) (2/10 = 0), g(fixedjob)
carryvalues fixedjob 

sort id wave
g student = s7i_jobnoteap == 1 if wave == 1 | wave == 4 | wave == 5
replace student = 1 if l.student == . & s7i_jobnoteap == 1 & wave == 2 
replace student = 1 if l2.student == . & s7i_jobnoteap == 1 & wave == 3
replace student = 0 if student == . & l.student == . & s7i_jobnoteap > 1 & s7i_jobnoteap < . & wave == 2
replace student = 0 if student == . & l2.student == . & s7i_jobnoteap > 1 & s7i_jobnoteap < . & wave == 3
replace student = 0 if student == . & l.student == . & s7a_ < . & s7i_jobnoteap < . & wave == 2
replace student = 0 if student == . & l2.student == . & s7a_ < . & s7i_jobnoteap < . & wave == 3
carryvalues student 

g churchattendance = (4-s8b_)/3 if s8b_ < 5 
carryvalues churchattendance 

g income = s12_ if s12_ != 1 & s12_ != 8 & s12 != 9
replace income = l.income if wave == 5 & city == 2
carryvalues income 
g logincome = ln(income)
replace logincome = 0 if income == 0
summ logincome
g logincomer = (logincome - r(min))/(r(max)-r(min))

g juiz = city - 1

g educ = s6_ if s6_ < 18 
carryvalues educ 
recode s6_ (0/4 = 1) (5/8 = 2) (9/11 = 3) (12/16 = 4), g(educr)
lab def educr 1 "0-4 years schooling" 2 "5-8 years schooling" 3 "9-11 years" 4 "Post-Secondary"
lab val educr educr
tab1 educr, g(educr)
g educrr = educ/15

g apartment =  s9a_apartmentyesorno == 1 if  s9a_apartmentyesorno < .
carryvalues apartment 

recode s8a_ (2 5 = 1) (1 3 4 6/99 = 0), g(evangelical)
carryvalues evangelical 

g famnumadults = s13a_ if s13a_ != 108 & s13a_ != 109
carryvalues famnum 

recode v18_friendssource (3/9=3), g(friendsource)
lab def friendsource 1 "Neighborhood" 2 "Work" 3 "Other/Group", modify
lab val friendsource friendsource
nicelylabelleddummies friendsource, g(friendsource)

replace s11a_raceintrvwr = f3.s11a_raceintrvwr if wave == 1 & s11a_raceintrvwr == .
replace s11a_raceintrvwr = f4.s11a_raceintrvwr if wave == 1 & s11a_raceintrvwr == .
replace s11a_raceintrvwr = l.s11a_raceintrvwr if wave == 2 & s11a_raceintrvwr == .
replace s11a_raceintrvwr = l.s11a_raceintrvwr if wave == 3 & s11a_raceintrvwr == .
replace s11a_raceintrvwr = l2.s11a_raceintrvwr if wave == 3 & s11a_raceintrvwr == .
replace s11a_raceintrvwr = l.s11a_raceintrvwr if wave == 6
replace s11a_raceintrvwr = l2.s11a_raceintrvwr if wave == 6 & s11a_raceintrvwr == .
replace s11a_raceintrvwr = l3.s11a_raceintrvwr if wave == 6 & s11a_raceintrvwr == .
nicelylabelleddummies s11a_raceintrvwr if s11a_raceintrvwr < 6, g(race)

***************************************************** NEIGHBORHOOD-LEVEL **********************************************************************************
egen nbhdtag = tag(bairroamob)

******** NEIGHBORHOOD EDUCATION FROM THE IBGE: THIS HAS ALREADY BEEN ADDED INTO THE REPLICATION DATA SET
* NOTE: THE VARIABLE "ibgedata" IS AN INDICATOR FOR WHETHER IT'S ONE OF THE "REAL" IBGE NEIGHBORHOODS
summ nbhdeduc_ibge
g nbhdeduc_ibger = (nbhdeduc_ibge-r(min))/(r(max)-r(min))
egen nbhdeduc_ibgerr = cut(nbhdeduc_ibger), group(4)
replace nbhdeduc_ibgerr = nbhdeduc_ibgerr+1
lab def nbhdeduc_ibgerr 1 "Neighborhood Ed. Q1" 2 "Neighborhood Ed. Q2" 3 "Neighborhood Ed. Q3" 4 "Neighborhood Ed. Q4", modify 
lab val nbhdeduc_ibgerr nbhdeduc_ibgerr 
tab1 nbhdeduc_ibgerr, g(nbhdeduc_ibger)

************ NEIGHBORHOOD EDUCATION BASED ON SURVEY AGGREGATES
egen nbhdeduc = mean(educ), by(bairroamob)
summ nbhdeduc
replace nbhdeduc = (nbhdeduc - r(min))/(r(max) - r(min))

************ NEIGHBORHOOD INCOME
egen nbhdincome = mean(logincomer), by(bairroamob)

**** DIVERSITY OF SES IN NBHD
egen meaneduc = mean(educ), by(id)
egen std_nbhdeduc = sd(meaneduc), by(bairroamob)

***** IMPUTE NEIGHBORHOOD EDUCATION FOR THOSE NEIGHBORHOODS THAT WEREN'T REPORTED IN THE IBGE (2000 CENSUS)
egen nbhdapt = mean(apartment), by(bairroamob)
egen nbhdchurch = mean(churchattendance), by(bairroamob)
preserve
	collapse nbhdeduc_ibge nbhdeduc nbhdincome juiz std_nbhdeduc nbhdapt nbhdchurch ibgedata, by(bairroamob)
	reg nbhdeduc_ibge nbhdeduc nbhdincome juiz std_nbhdeduc nbhdapt nbhdchurch if ibgedata == 1
	** R-squared of .92; this model doesn't include IBGE income, since that also can't be trusted
restore
reg nbhdeduc_ibge nbhdeduc nbhdincome juiz std_nbhdeduc nbhdapt nbhdchurch if ibgedata == 1
predict nbhdeduc_imp
* CHECK IMPUTED MEASURE
tab nbhdeduc_imp nbhdeduc_ibge if ibgedata == 0
corr nbhdeduc_imp nbhdeduc_ibge if ibgedata == 1 // r = .96
corr nbhdeduc_imp nbhdeduc_ibge if ibgedata == 0 // r = .55
corr nbhdeduc_imp nbhdeduc_ibge // r = .92
* REPLACE THE IMPUTED MEASURE WITH THE REAL IBGE MEASURE IF THE NEIGHBORHOOD HAS IBGE DATA
replace nbhdeduc_imp = nbhdeduc_ibge if ibgedata == 1
summ nbhdeduc_imp
g nbhdeduc_impr = (nbhdeduc_imp - r(min))/(r(max)-r(min))
egen nbhdeduc_imprr = cut(nbhdeduc_imp), group(4)
replace nbhdeduc_imprr = nbhdeduc_imprr+1
lab val nbhdeduc_imprr nbhdeduc
tab1 nbhdeduc_imprr, g(nbhdeduc_impr)

******************* INTERACTIONS BETWEEN CONVERSATION AND RESOURCES 
g converseXeduc = converse*educrr
g converseXnbhdeduc = converse*nbhdeduc_ibger
g converseXnbhdeducimp = converse*nbhdeduc_impr

***************************************************** CODING KNOWLEDGE **********************************************************************************

********************************** CIVICS QUIZ QUESTIONS
*** NOTE THAT IN WAVE 2 KNOWLEDGE QUESTIONS WERE ASKED *ONLY* OF NEW INTERVIEWEES
*** KNOWING THE PARTY OF FHC: PRESENT IN WAVES 1, 2, 3, 4 (WAVE 6 ONLY IN JF)
g know3 = (s14c_know3fhcparty == 3)
replace know3 = . if s14c_know3fhcparty == .
replace know3 = . if wave == 5 | wave == 6
*** WAVES 1, 2, 3, 4, 5, 6
g know4 = (s14d_know4mercosul == 2)
replace know4 = . if s14d_know4mercosul == .
*** WAVES 1, 2, 4, 5, 6
g know5 = (s14ecs_know5senator == 1 | s14ejf_know5senator == 1)
replace know5 = . if s14ecs_know5senator == . & s14ejf_know5senator == .
replace know5 = . if wave == 3
**** WAVES 1, 2, 4, 5, 6
g know6 = (s14f_know6preschamber == 3 | s14fW4_know6preschamber == 2 | s14fW5_know6preschamber == 4)
replace know6 = . if wave < 3 & s14f_know6preschamber == . 
replace know6 = . if wave == 3
replace know6 = . if wave == 4 & s14fW4_know6preschamber == . 
replace know6 = . if (wave == 5 | wave == 6) & s14fW5_know6preschamber == .
**** SUMMARY MEASURES
g know_w13 = (know3+know4)/2 if wave == 1 | wave == 3
g know_w456 = (know4+know5+know6)/3 if wave == 4 | wave == 5 | wave == 6
g know_group = know_w13 
replace know_group = know_w456 if wave > 3

******************************* ISSUE KNOWLEDGE
recode v63b_ (4 5 = 1) (1 2 3 8 9 = 0), g(issue1)
recode v70b_ (1 2 = 1) (3/9=0), g(issue2)
recode issue1 (.=0) if issue2 != .
recode issue2 (.=0) if issue1 != .
g issueknowledge = issue1 + issue2

******************************** Candidate mentions variables 
egen candsmentionedall = anycount(v22b1_prescandsknowciro v22b2_prescandsknowlula v22b3_prescandsknowroseana v22b4_prescandsknowserra ///
	v22b5_prescandsknowgaro v22b6_prescandsknowitamar v22b7_prescandsknowzemaria v22b8_prescandsknowpimenta  v22b10_prescandsknowalckmin ///
	v22b11_prescandsknowbuarque v22b12_prescandsknowheloisa v22b13_prescandsknoweymael v22b14_prescandsknowbivar), values(1)
replace candsmentionedall = . if respond != 1 | wave == 4
tab candsmentionedall wave, mi

******************************* INTERVIEWER RATINGS OF KNOWLEDGE AND COOPERATIVENESS
g interviewerknowledge = (5-s16b_intrvwrquestionknowledge)/4
recode s16a_ (10 15 25 = .)
g interviewercooperate = (5-s16a_)/4



********************************************** ANALYSIS *******************************************************************************************

********************************************** FIGURES AND TABLES *********************************************************************************

******* FIGURE 1. CANDIDATE MENTIONS AND ISSUE PLACEMENT BY NEIGHBORHOOD EDUCATION
preserve
drop if ibgedata == 0
collapse (mean) candsmentionedall (semean) se_candsmentionedall=candsmentionedall, by(wave nbhdeduc_imprr)
g ub = candsmentionedall + 1.96*se_candsmentionedall
g lb = candsmentionedall - 1.96*se_candsmentionedall
graph twoway (line candsmentionedall wave if nbhdeduc_imprr == 1, lwidth(thick) lcolor(black)) ///
	(line candsmentionedall wave if nbhdeduc_imprr == 2, lcolor(gs10) lwidth(thick))  ///
	(line candsmentionedall wave if nbhdeduc_imprr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line candsmentionedall wave if nbhdeduc_imprr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 1, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 2, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 3, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 4, color(black)), ///
	title("Number of Candidates Named", color(black) size(medsmall)) ytitle("") xtitle("") xlabel(1/6, nolabel notick) xscale(range(1 6.25)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	legend(off) xsize(2.5) ysize(2) saving(know_cands, replace)
restore
preserve
drop if ibgedata == 0
collapse (mean) issueknowledge (semean) se_issueknowledge=issueknowledge, by(wave nbhdeduc_imprr)
g ub = issueknowledge + 1.96*se_issueknowledge
g lb = issueknowledge - 1.96*se_issueknowledge
graph twoway (line issueknowledge wave if nbhdeduc_imprr == 1, lwidth(thick) lcolor(black)) ///
	(line issueknowledge wave if nbhdeduc_imprr == 2, lcolor(gs10) lwidth(thick))  ///
	(line issueknowledge wave if nbhdeduc_imprr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line issueknowledge wave if nbhdeduc_imprr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 1, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 2, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 3, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 4, color(black)), ///
	title("Candidate Issue Knowledge", color(black) size(medsmall)) ytitle("") xtitle("") xlabel(1/6, nolabel notick) xscale(range(1 6.25)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	legend(off) xsize(2.5) ysize(2) saving(know_issues, replace)
restore
preserve
drop if ibgedata == 0
collapse (mean) know_w456 know_w13 know_group (semean) se_know_group=know_group, by(wave nbhdeduc_imprr)
g ub = know_group + 1.96*se_know_group
g lb = know_group - 1.96*se_know_group
graph twoway (line know_w13 wave if nbhdeduc_imprr == 1, lwidth(thick) lcolor(black)) ///
	(line know_w13 wave if nbhdeduc_imprr == 2, lcolor(gs10) lwidth(thick))  ///
	(line know_w13 wave if nbhdeduc_imprr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line know_w13 wave if nbhdeduc_imprr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(line know_w456 wave if nbhdeduc_imprr == 1, lwidth(thick) lcolor(black)) ///
	(line know_w456 wave if nbhdeduc_imprr == 2, lcolor(gs10) lwidth(thick))  ///
	(line know_w456 wave if nbhdeduc_imprr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line know_w456 wave if nbhdeduc_imprr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 1, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 2, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 3, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 4, color(black)), ///
	title("Mean Office-Holder Knowledge", color(black) size(medsmall)) ytitle("") xtitle("") xlabel(1/6, valuelabel) xscale(range(1 6.25)) ///
	graphregion(fcolor(white) lcolor(white)) plotregion(lcolor(white)) ///
	legend(order (1 "Neighborhood Ed. Q1" 2 "Neighborhood Ed. Q2" 3 "Neighborhood Ed. Q3" 4 "Neighborhood Ed. Q4") col(1) size(small)) ///
	xsize(2.5) fysize(52) saving(know_civ, replace)
restore
preserve
drop if ibgedata == 0
collapse (mean) interviewerknowledge (semean) se_interviewerknowledge=interviewerknowledge, by(wave nbhdeduc_imprr)
g ub = interviewerknowledge + 1.96*se_interviewerknowledge
g lb = interviewerknowledge - 1.96*se_interviewerknowledge
graph twoway (line interviewerknowledge wave if nbhdeduc_imprr == 1, lwidth(thick) lcolor(black)) ///
	(line interviewerknowledge wave if nbhdeduc_imprr == 2, lcolor(gs10) lwidth(thick))  ///
	(line interviewerknowledge wave if nbhdeduc_imprr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line interviewerknowledge wave if nbhdeduc_imprr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 1, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 2, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 3, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 4, color(black)), ///
	title("Interviewer-Rated General Knowledge", color(black) size(medsmall)) ytitle("") xtitle("") xlabel(1/6, valuelabel ) xscale(range(1 6.25)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	legend(order (1 "Neighborhood Ed. Q1" 2 "Neighborhood Ed. Q2" 3 "Neighborhood Ed. Q3" 4 "Neighborhood Ed. Q4") col(1) size(small)) ///
	xsize(2.5) fysize(52) saving(know_int, replace)
restore
graph combine know_cands.gph know_issues.gph know_civ.gph know_int.gph, imargin(0 0) graphregion(fcolor(white) lcolor(white)) cols(2) xcommon ysize(4.5)


***** Figure 2. DESCRIPTIVE STATS ON CONVERSATION, BY SETTING AND EDUCATION
preserve
drop if ibgedata == 0
collapse (mean) converse (semean) se_converse=converse, by(wave nbhdeduc_imprr)
g ub = converse + 1.96*se_converse
g lb = converse - 1.96*se_converse
graph twoway (line converse wave if nbhdeduc_imprr == 1, lwidth(thick) lcolor(black) xsize(3) ///
	legend(cols(1) label (1 "Neighborhood Ed. Q1") label (2 "Neighborhood Ed. Q2") ///
	label (3 "Neighborhood Ed. Q3") label (4 "Neighborhood Ed. Q4") size(med))) ///
	(line converse wave if nbhdeduc_imprr == 2, lcolor(gs10) lwidth(thick))  ///
	(line converse wave if nbhdeduc_imprr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line converse wave if nbhdeduc_imprr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 1, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 2, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 3, color(black)) ///
	(rcap ub lb wave if nbhdeduc_imprr == 4, color(black)), ///
	xlabel(1/6, valuelabel labsize(med)) xscale(range(1 6.25)) ytitle("") xtitle("") ///
	note("") title("By Neighborhood Education", size(large) color(black)) ///
	legend(order (1 "Neighborhood Ed. Q1" 2 "Neighborhood Ed. Q2" 3 "Neighborhood Ed. Q3" 4 "Neighborhood Ed. Q4") col(1)) ///
	graphregion(fcolor(white) lcolor(white)) legend(pos(6)) ysize(2) saving(conv_by_nbhd, replace)
restore
* BY PERSONAL EDUCATION
preserve
drop if educr == .
collapse (mean) converse (semean) se_converse=converse, by(wave educr)
g ub = converse + 1.96*se_converse
g lb = converse - 1.96*se_converse
graph twoway (line converse wave if educr == 1, lwidth(thick) lcolor(black) xsize(3) ///
	legend(cols(1) label (1 "Primary") label (2 "Middle") ///
	label (3 "Secondary") label (4 "Higher") size(med))) ///
	(line converse wave if educr == 2, lcolor(gs10) lwidth(thick))  ///
	(line converse wave if educr == 3, lwidth(thick) lcolor(black) lpattern(dash))  ///
	(line converse wave if educr == 4, lcolor(gs10) lwidth(thick) lpattern(dash)) ///
	(rcap ub lb wave if educr == 1, color(black)) ///
	(rcap ub lb wave if educr == 2, color(black)) ///
	(rcap ub lb wave if educr == 3, color(black)) ///
	(rcap ub lb wave if educr == 4, color(black)), ///
	xlabel(1/6.5, valuelabel labsize(med)) ylabel(, nolabel notick) xscale(range(1 6.25)) ytitle("")  xtitle("") ///
	note("") title("By Personal Education", size(large) color(black)) ///
	legend(order (1 "Primary" 2 "Middle" 3 "Secondary" 4 "Higher") col(1)) ///
	graphregion(fcolor(white) lcolor(white)) legend(pos(6)) ysize(2)  saving(conv_by_ed, replace)
restore
graph combine conv_by_nbhd.gph conv_by_ed.gph, imargin(0 0) ycommon graphregion(fcolor(white) lcolor(none)) ///
	title("Mean Level of Political Conversation", size(medlarge) color(black)) xsize(7) 

*************** TABLE 1. NON-NESTED MULTILEVEL MODEL OF CANDIDATE MENTIONS
global controls2 educrr tvfreq paperfreq logincomer race2 race3 race4 race5 ///
	female age_30_49 age_50_69 age_70up fixedjob student churchattendance juiz apartment interviewercooperate
eststo clear
xtmixed candsmentionedall converse nbhdeduc_impr converseXeduc waveC $controls2 ///
	|| _all: R.wave || _all: R.bairroamob
eststo
xtmixed issueknowledge converse nbhdeduc_impr converseXeduc waveC $controls2 ///
	|| _all: R.wave || _all: R.bairroamob 
eststo
xtmixed know_group converse nbhdeduc_impr converseXeduc waveC $controls2 ///
	|| _all: R.wave || _all: R.bairroamob 
eststo
xtmixed interviewerknowledge converse nbhdeduc_impr converseXeduc waveC $controls2 ///
	|| _all: R.wave || _all: R.bairroamob 
eststo
esttab, b(3) se(3) nogaps nopar wide star(* .05) compress

****** FIGURE 3: CANDIDATE MENTION MODELS: INTERACTIONS WITH PERSONAL EDUCATION
****** COEFFICIENTS
preserve
rename candsmentionedall kcand
rename issueknowledge kiss
rename interviewerknowledge kint
rename know_group kgen
* modify the following path as necessary for your machine
cd "C:\Users\aesmith2\Dropbox\Work\published\Articles and chapters\Smith 2015 BJPS\Final\analysis\coefficients\"
foreach i in kcand kiss kint {
	xtmixed `i' converse nbhdeduc_impr converseXnbhdeducimp waveC $controls2 || _all: R.wave || _all: R.bairroamob 
	estimates store `i'results
	foreach j in 0 .2 .4 .6 .8 1 {
			estimates restore `i'results
			lincomest converse+`j'*converseXnbhdeducimp
			parmest, label format(estimate min95 max95 p %8.3f p %8.1e) saving(`i'_nbed`j'.dta, replace) idstr(`i'_nbhdeduc`j')
		} 
}
xtmixed kgen converse nbhdeduc_impr converseXnbhdeducimp waveC $controls2 || _all: R.wave || _all: R.bairroamob 
estimates store kgenresults
foreach j in 0 .2 .4 .6 .8 1 {
		estimates restore kgenresults
		lincomest converse+`j'*converseXnbhdeduc
		parmest, label format(estimate min95 max95 p %8.3f p %8.1e) saving(kgen_nbed`j'.dta, replace) idstr(kgen_nbhdeduc`j')
} 
restore
****** FIGURE
preserve
* modify the following path as necessary for your machine
cd "C:\Users\aesmith2\Dropbox\Work\published\Articles and chapters\Smith 2015 BJPS\Final\analysis\coefficients\"
clear
foreach i in kcand kiss kgen kint {
	foreach j in 0 .2 .4 .6 .8 1 {
		append using `i'_nbed`j'.dta
	}
}
egen nbhdeduc = seq(), from(1) to(6) block(1)
lab def nbhdeduc 1 "Lowest" 2 "" 3 "" 4 "" 5 "" 6 "Highest"
lab val nbhdeduc nbhdeduc 
lab var nbhdeduc "Neighborhood Education"
egen kntype = seq(), from(1) to(4) block(6)
lab def kntype 1 "Candidate Mentions" 2 "Issue Knowledge" 3 "Office-Holder Knowledge" 4 "General Knowledge Rating" 
lab val kntype kntype
graph twoway line estimate nbhdeduc,  lcolor(black)  || ///
	line min95 nbhdeduc, lpattern(dash) lcolor(black) || ///
	line max95 nbhdeduc, lpattern(dash)  lcolor(black) ///
	by(kntype, cols(2) imargin(medium) legend(off) yrescale graphregion(fcolor(white)) ///
	note("Coefficients from non-nested multilevel models interacting conversation with neighborhood" "education.", span)) ///
	xlab(1(2.5)6, valuelabel angle(horizontal)) ylab(#2, format(%4.1f)) yscale(range(0)) yline(0, lcolor(black)) ///
	ytit("Marginal Impact of Political Conversation on" "Knowledge, by Neighborhood Education") ///
	xtit("Neighborhood Education") ///
	plotregion(ifcolor(white) fcolor(white))
*** NOTE: YOU NEED TO ADJUST THE Y-AXES MANUALLY
restore

***** FIGURE 4. SOCIAL NETWORKS AND NEIGHBORHOODS
preserve
lab def nbhdeduc_imprrr 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4"
lab val nbhdeduc_imprr nbhdeduc_imprrr
graph bar friendsource1 friendsource2 friendsource3 if wave == 5, over(nbhdeduc_imprr) stack percent ///
	bar(1, lcolor(black) fcolor(gs16)) bar(2, lcolor(black) fcolor(gs10)) bar(3, lcolor(black) fcolor(gs6)) ///
	graphregion(fcolor(white)) ytitle("Percent Saying Most Friends Are From...") ///
	title("Neighborhood Education", pos(6) ring(3) color(black) size(medium)) ///
	legend(label(1 "Neighborhood") label(2 "Work") label(3 "Other/Group"))
restore


************************************************** APPENDIX AND IN-TEXT DISCUSSION ******************************************************************
**** IN-TEXT DISCUSSION: COUNT RESPONSE PATTERN AND ATTRITION
sort id wave
egen uniqueid = tag(id)
egen numwaves = total(respond), by(id)
replace numwaves = . if uniqueid == 0
tab numwaves 
tab responsepattern2 uniqueid

****TABLE A1. SAMPLE CHARACTERISTICS
preserve
drop if uniqueid == 0
recode educ (0=0) (1/3=1) (4/7=2) (8=3) (9/11=4) (12 13=5) (14 15=6) if age>24, g(educ_group)
tab1 female agecohort s11a_raceintrvwr educ_group
tabstat numwaves, by(female)
tabstat numwaves, by(agecohort)
tabstat numwaves, by(s11a_)
tabstat numwaves, by(educ_group)
restore

*****TABLE A2. DESCRIPTIVE STATISTICS: CONVERSATION AND POLITICAL KNOWLEDGE 
tabstat converse candsmentionedall issueknowledge know_group interviewerknowledge, by(wave) statistics(mean sd)
foreach i in 1 2 3 4 5 6 {
	pwcorr candsmentionedall issueknowledge know_group interviewerknowledge if wave == `i'
}
*****TABLE A3. DESCRIPTIVE STATISTICS IN HIGH EDUCATION NEIGHBORHOODS
tabstat converse candsmentionedall issueknowledge know_group interviewerknowledge if nbhdeduc_ibgerr == 4, by(wave) statistics(mean sd)
foreach i in 1 2 3 4 5 6 {
	pwcorr candsmentionedall issueknowledge know_group interviewerknowledge if wave == `i' & nbhdeduc_ibgerr == 4
}

****TABLE A4. NON-NESTED MULTILEVEL MODEL OF CONVERSATION
global controls1 educrr tvfreq paperfreq logincomer race2 race3 race4 race5 ///
	female age_30_49 age_50_69 age_70up fixedjob student churchattendance juiz apartment 
eststo clear
xtmixed converse nbhdeduc_impr waveC $controls1 || _all: R.wave || _all: R.bairroamob
eststo
esttab, b(3) se(3) nogaps nopar star(+ .10 * .05 ** .01 *** .001)

converse nbhdeduc_impr converseXeduc waveC $controls2 ///
	|| _all: R.wave || _all: R.bairroamob

****** TABLE A5: LAGGING ALL VARIABLES, PER REVIEWER 1'S REQUEST
*** CANDS MENTIONED MODEL (REQUIRES DROPPING WAVE 4)
preserve
drop if wave == 4
recode wave (5=4) (6=5)
sort id wave
eststo clear
reg candsmentionedall converse l.converse converseXeduc l.converseXeduc tvfreq l.tvfreq paperfreq l.paperfreq interviewercooperate l.interviewercooperate ///
	educrr logincomer female age_30_49 age_50_69 age_70up fixedjob student churchattendance juiz apartment race2 race3 race4 race5 ///
	l.candsmentionedall , vce(cluster id) 
eststo
esttab, b(3) se(3) nogaps nopar star(* .05) label wide
restore
*** OTHER THREE MODELS
* OFFICE-HOLDER KNOWLEDGE MODEL DROPS WAVES 1-3
eststo clear
sort id wave
reg issueknowledge converse l.converse converseXeduc l.converseXeduc tvfreq l.tvfreq paperfreq l.paperfreq interviewercooperate l.interviewercooperate ///
	educrr logincomer female age_30_49 age_50_69 age_70up fixedjob student churchattendance juiz apartment race2 race3 race4 race5 ///
	l.issueknowledge, vce(cluster id)
eststo
reg know_group converse l.converse converseXeduc l.converseXeduc tvfreq l.tvfreq paperfreq l.paperfreq interviewercooperate l.interviewercooperate ///
	educrr logincomer female age_30_49 age_50_69 age_70up fixedjob student churchattendance juiz apartment race2 race3 race4 race5 ///
	l.know_group if wave > 3, vce(cluster id)
eststo
reg interviewerknowledge converse l.converse converseXeduc l.converseXeduc tvfreq l.tvfreq paperfreq l.paperfreq interviewercooperate l.interviewercooperate ///
	educrr logincomer female age_30_49 age_50_69 age_70up fixedjob student churchattendance juiz apartment race2 race3 race4 race5 ///
	l.interviewerknowledge, vce(cluster id)
eststo
esttab, b(3) se(3) nogaps nopar star(* .05) label wide


*************** TABLE A6. NON-NESTED MULTILEVEL MODELS: INTERACTIONS WITH *NEIGHBORHOOD* EDUCATION (THE TABLES FOR FIGURE 4)
global controls2 educrr tvfreq paperfreq logincomer race2 race3 race4 race5 ///
	female age_30_49 age_50_69 age_70up interviewercooperate fixedjob student churchattendance juiz apartment 
eststo clear
xtmixed candsmentionedall nbhdeduc_impr waveC converse converseXnbhdeducimp $controls2 || _all: R.wave || _all: R.bairroamob
eststo
xtmixed issueknowledge nbhdeduc_impr waveC converse converseXnbhdeducimp $controls2 || _all: R.wave || _all: R.bairroamob
eststo
xtmixed know_group nbhdeduc_impr waveC converse converseXnbhdeducimp $controls2 || _all: R.wave || _all: R.bairroamob
eststo
xtmixed interviewerknowledge nbhdeduc_impr waveC converse converseXnbhdeducimp $controls2 || _all: R.wave || _all: R.bairroamob
eststo
esttab, b(3) se(3) nogaps nopar wide star(* .05)


*************** TABLE A7. NON-NESTED MULTILEVEL MODELS: INTERACTIONS WITH NEIGHBORHOOD EDUCATION, USING NON-IMPUTED MEASURE
global controls2 educrr tvfreq paperfreq logincomer race2 race3 race4 race5 ///
	female age_30_49 age_50_69 age_70up interviewercooperate fixedjob student churchattendance juiz apartment 
eststo clear
xtmixed candsmentionedall nbhdeduc_ibger waveC converse converseXnbhdeduc $controls2 || _all: R.wave || _all: R.bairroamob
eststo
xtmixed issueknowledge nbhdeduc_ibger waveC converse converseXnbhdeduc $controls2 || _all: R.wave || _all: R.bairroamob
eststo
xtmixed know_group nbhdeduc_ibger waveC converse converseXnbhdeduc $controls2 || _all: R.wave || _all: R.bairroamob
eststo
xtmixed interviewerknowledge nbhdeduc_ibger waveC converse converseXnbhdeduc $controls2 || _all: R.wave || _all: R.bairroamob
eststo
esttab, b(3) se(3) nogaps nopar wide star(* .05)

********** TABLE A8: Instrumental Variables Model: The Mutual Impacts of Political Knowledge and Political Conversation
preserve
replace know_group = l.know_group if wave == 2
eststo clear
xtivreg2 candsmentionedall tvfreq paperfreq educ age_30_49 age_50_69 age_70up interviewercooperate wave5 ///
	(converse = snwsize fixedjob churchattend evang race1 ///
	famnum educ tvfreq paperfreq ) if wave == 2 | wave == 5,fe first
eststo
xtivreg2 issueknowledge tvfreq paperfreq educ age_30_49 age_50_69 age_70up interviewercooperate wave5 ///
	(converse = snwsize fixedjob churchattend evang race1 ///
	famnum educ tvfreq paperfreq ) if wave == 2 | wave == 5,fe first
eststo
xtivreg2 know_group tvfreq paperfreq educ age_30_49 age_50_69 age_70up interviewercooperate wave5 ///
	(converse = snwsize fixedjob churchattend evang race1 ///
	famnum educ tvfreq paperfreq ) if wave == 2 | wave == 5,fe first
eststo
xtivreg2 interviewerknowledge tvfreq paperfreq educ age_30_49 age_50_69 age_70up interviewercooperate wave5 ///
	(converse = snwsize fixedjob churchattend evang race1 ///
	famnum educ tvfreq paperfreq ) if wave == 2 | wave == 5,fe first
eststo
esttab, b(3) se(3) nogaps nopar star(* .05)
restore

