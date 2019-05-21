* REPLICATION FILE FOR MAIN ANALYSIS 
* KRISTIN KANTHAK AND JONATHAN WOON 
* "WOMEN DON'T RUN? ELECTION AVERSION AND CANDIDATE ENTRY"
* AMERICAN JOURNAL OF POLITICAL SCIENCE 
* JULY 8, 2014

cd "/Users/woon/Research/WORKING/WDR/AJPS-FINAL"

* FIGURE 3: VOLUNTEERS
use wdr2-game, clear
gen subid = 100*session + subject
ren volunteer choice_vol
ren run choice_run
keep subid treat choice_vol choice_run female
reshape long choice_, i(subid) j(part, str)
replace treat = "VCB" if part=="vol" & (treat=="TruthCB" | treat=="ChatCB")
replace treat = "VNO" if part=="vol" & (treat=="TruthNO" | treat=="ChatNO")
ren choice_ choice 
collapse (mean) pctchoice=choice (sd) sdchoice=choice (count) n=choice, by(treat female)
replace pctchoice = pctchoice*100
replace sdchoice = sdchoice*100
gen hic = pctchoice + invttail(n-1,0.025)*(sdchoice / sqrt(n))
gen loc = pctchoice - invttail(n-1,0.025)*(sdchoice / sqrt(n))
gen part = 2 if treat=="VCB" | treat=="VNO"
replace part = 3 if !(treat=="VCB" | treat=="VNO")
gen gentreat = 1 if treat=="VCB" & female==0
replace gentreat = 2 if treat=="VCB" & female==1
replace gentreat = 4 if treat=="VNO" & female==0
replace gentreat = 5 if treat=="VNO" & female==1
twoway (bar pctchoice gentreat if female==0, lcolor(black)) ///
 (bar pctchoice gentreat if female==1, lcolor(black)) ///
 (rcap hic loc gentreat, lcolor(gs7)) if part==2, ///
 scheme(s2mono) legend(order(1 "Men" 2 "Women")) ///
 xlabel(1.5 "Volunteer, Cost (VCB)" 4.5 "Volunteer, No Cost (VNO)", noticks) ///
 ytitle("Pct Volunteers") xtitle("") ylabel(0(25)100) xscale(range(0 6))

 * FIGURE 4: CANDIDATES
replace gentreat = 1 if treat=="ChatCB" & female==0
replace gentreat = 2 if treat=="ChatCB" & female==1
replace gentreat = 4 if treat=="ChatNO" & female==0
replace gentreat = 5 if treat=="ChatNO" & female==1
replace gentreat = 7 if treat=="TruthCB" & female==0
replace gentreat = 8 if treat=="TruthCB" & female==1
replace gentreat = 10 if treat=="TruthNO" & female==0
replace gentreat = 11 if treat=="TruthNO" & female==1
twoway (bar pctchoice gentreat if female==0, lcolor(black)) ///
 (bar pctchoice gentreat if female==1, lcolor(black)) ///
 (rcap hic loc gentreat, lcolor(gs7)) if part==3, ///
 scheme(s2mono) legend(order(1 "Men" 2 "Women")) ///
 xlabel(1.5 "Chat, Cost" 4.5 "Chat, No Cost" 7.5 "Truth, Cost" 10.5 "Truth, No Cost", noticks) ///
 ytitle("Pct Candidates") xtitle("") ylabel(0(25)100)

* GENDER DIFFERENCES BY TREATMENT
use wdr2-game, clear
tab volunteer sex if cost==0, chi2 col
tab volunteer sex if cost==1, chi2 col
tab run sex if treat=="ChatNO", chi2 col
tab run sex if treat=="ChatCB", chi2 col
tab run sex if treat=="TruthNO", chi2 col
tab run sex if treat=="TruthCB", chi2 col

* FIGURE 5: TASK PERFORMANCE
ttest spiecerate, by(sex)
ksmirnov spiecerate, by(sex)
twoway (kdensity spiece if female==0, n(30)) (kdensity spiece if female==1, n(30)), scheme(s2mono) legend(order(1 "Men" 2 "Women")) ytitle(Density) xtitle("Performance (Part 1)")

* TABLE 1: BELIEFS
* BELIEFS ABOUT OTHERS' ABILITIES
ttest guess1, by(sex)
ttest guess2, by(sex)
ttest guess3, by(sex)
ttest guess4, by(sex)
ttest avg_group, by(sex)
* BELIEFS ABOUT VOLUNTEERING (BY COST)
ttest numvols if cost==0, by(sex)
ttest avg_vol if cost==0, by(sex)
ttest numvols if cost==1, by(sex)
ttest avg_vol if cost==1, by(sex)
* BELIEFS ABOUT CANDIDATES (BY TREATMENT)
ttest numcands if treat=="ChatCB", by(sex)
ttest avg_cand if treat=="ChatCB", by(sex)
ttest numcands if treat=="ChatNO", by(sex)
ttest avg_cand if treat=="ChatNO", by(sex)
ttest numcands if treat=="TruthCB", by(sex)
ttest avg_cand if treat=="TruthCB", by(sex)
ttest numcands if treat=="TruthNO", by(sex)
ttest avg_cand if treat=="TruthNO", by(sex)
* ACTUAL SCORES, ETC COMPARE TO BELIEFS
tabstat score1 score2 score3 score4, stat(mean sd)
gen trueavg = (score1+score2+score3+score4)/4
gen truevol = vol1+vol2+vol3+vol4
gen trueavgvol = (vol1*score1+vol2*score2+vol3*score3+vol4*score4)/truevol if truevol>0
tabstat truevol trueavgvol, by(cost) stat(mean sd)
gen truecand = cand1+cand2+cand3+cand4
gen trueavgcand = (cand1*score1+cand2*score2+cand3*score3+cand4*score4)/truecand if truecand>0
tabstat truecand trueavgvol, by(treat) stat(mean sd)

* FIGURE 6: LOTTERY CHOICES (RISK AVERSION)
tabstat gamble*, by(sex) stat(mean N)
prtest gamble1, by(sex)
prtest gamble2, by(sex)
prtest gamble3, by(sex)
prtest gamble4, by(sex)
prtest gamble5, by(sex)
prtest gamble6, by(sex)
prtest gamble7, by(sex)
prtest gamble8, by(sex)
prtest gamble9, by(sex)
ttest nsafe, by(sex)
gen subid = 100*session + subject
keep subid female gamble1-gamble9 nsafe
reshape long gamble, i(subid) j(choice)
collapse (mean) pctsafe=gamble (sd) sdsafe=gamble (count) nsafe=gamble, by(female choice)
twoway (connected pctsafe choice if female==0, sort) (connected pctsafe choice if female==1, sort lpattern(longdash)), ytitle(Pct Safe Choices) ytitle(, margin(medsmall)) ylabel(0(.25)1) xtitle(Lottery (x)) xlabel(1(1)9) legend(on order(1 "Men" 2 "Women")) scheme(s2mono)

* TABLE 2: PROBIT REGRESSIONS
* NOTE: SCORE IS MEAN ADJUSTED SO THAT THE INTERCEPTS ARE MEANINGFUL WHEN THERE ARE INTERACTIONS
use wdr2-game, clear
egen avg_all = mean(spiece)
gen score = spiece - avg_all
ren volunteer choice_vol
ren run choice_run
gen subid = 100*session + 10*group + id
reshape long choice_, i(subid) j(part, str)
ren choice_ choice
gen nwilling = numcands if part=="run"
replace nwilling = numvols if part=="vol"
gen avg_other = avg_group if (part=="run" & numcands==0) | (part=="vol" & numvols==0)
replace avg_other = avg_cand if part=="run" & numcands>0
replace avg_other = avg_vol if part=="vol" & numvols>0
gen vcb = (treat=="ChatCB" | treat=="TruthCB") & part=="vol"
gen vno = (treat=="ChatNO" | treat=="TruthNO") & part=="vol"
gen ccb = treat=="ChatCB" & part=="run"
gen cno = treat=="ChatNO" & part=="run"
gen tcb = treat=="TruthCB" & part=="run"
gen tno = treat=="TruthNO" & part=="run"
gen s_vcb = score*vcb
gen s_vno = score*vno
gen s_ccb = score*ccb
gen s_cno = score*cno
gen s_tcb = score*tcb
gen s_tno = score*tno
probit choice score vcb ccb cno tcb tno if female==0, cluster(subid)
est sto m1
probit choice score vcb ccb cno tcb tno if female==1, cluster(subid)
est sto f1
probit choice score vcb ccb cno tcb tno nsafe nwilling avg_other if female==0, cluster(subid)
est sto m2
probit choice score vcb ccb cno tcb tno nsafe nwilling avg_other if female==1, cluster(subid)
est sto f2
probit choice score vcb ccb cno tcb tno nsafe nwilling avg_other s_vcb s_ccb s_cno s_tcb s_tno if female==0, cluster(subid)
est sto m3
probit choice score vcb ccb cno tcb tno nsafe nwilling avg_other s_vcb s_ccb s_cno s_tcb s_tno if female==1, cluster(subid)
est sto f3
est table m1 m2 m3 f1 f2 f3, b(%3.2f) se(%3.2f) stat(ll N)
est table m1 m2 m3 f1 f2 f3, b(%3.2f) star stat(ll N)

* TABLE 3: MESSAGES
tempfile tmpmessages
use wdr2-messages, clear
keep if use==1
ren owner id
ren t message
keep treat session group id message numeric vague highclaim pt1claim pt2claim
sort treat session group id
save `tmpmessages'
use wdr2-game, clear
merge 1:1 treat session group id using `tmpmessages', assert(match master)
gen str msgtype = "Numeric" if numeric==1 & vague==0
replace msgtype = "Vague" if numeric==0 & vague==1
replace msgtype = "Other" if numeric==0 & vague==0
gen minexag = highclaim - max(spiecerate,svolunteer)
recode minexag -1=0
tab msgtype female if treat=="ChatCB", col chi2
tab msgtype female if treat=="ChatNO", col chi2
tab minexag female if treat=="ChatCB", col chi2
tab minexag female if treat=="ChatNO", col chi2
gen exag = minexag>0 & run==1 & numeric==1
tab exag female if treat=="ChatCB", col chi2
tab exag female if treat=="ChatNO", col chi2
ttest minexag if treat=="ChatCB" & numeric & minexag>0, by(female)
ttest minexag if treat=="ChatNO" & numeric & minexag>0, by(female)

