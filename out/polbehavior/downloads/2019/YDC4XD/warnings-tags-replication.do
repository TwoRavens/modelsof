clear
set more off

*install required packages if not installed
capture ssc install estout
capture ssc install egenmore

*set path here
*cd ""

use "warnings-tags-replication.dta", clear

*Table 1
bysort cond: su purecontrol nocorr_cond disputed_cond false_cond warning 

*Table C1 (column 1)
tab educ
tab age
tab gender
tab trump_approve_binary
tab vote_choice


/*belief reshape*/

*belief reshape
rename draft_belief belief1
rename bee_belief belief2
rename chaf_belief belief3
rename protester_belief belief4
rename marines_belief belief5 
rename fbiagent_belief belief6 
rename real_civil_war_belief belief7
rename real_syria_belief belief8
rename real_gorsuch_belief belief9

*Table C2
forval i=1/9 {
tab belief`i'
}

reshape long belief,i(mid) j(dv)

gen nocorr=.
replace nocorr=(draft_nocorr==1) if dv==1
replace nocorr=(bee_nocorr==1) if dv==2
replace nocorr=(chaf_nocorr==1) if dv==3
replace nocorr=(protester_nocorr==1) if dv==4
replace nocorr=(marines_nocorr==1) if dv==5
replace nocorr=(fbiagent_nocorr==1) if dv==6

gen disputed=.
replace disputed=(draft_disputed==1) if dv==1
replace disputed=(bee_disputed==1) if dv==2
replace disputed=(chaf_disputed==1) if dv==3
replace disputed=(protester_disputed==1) if dv==4
replace disputed=(marines_disputed==1) if dv==5
replace disputed=(fbiagent_disputed==1) if dv==6

gen false=.
replace false=(draft_false==1) if dv==1
replace false=(bee_false==1) if dv==2
replace false=(chaf_false==1) if dv==3
replace false=(protester_false==1) if dv==4
replace false=(marines_false==1) if dv==5
replace false=(fbiagent_false==1) if dv==6

gen rowcond=.
replace rowcond=1 if nocorr==1
replace rowcond=2 if disputed==1
replace rowcond=3 if false==1

gen unflagged=((disputed_cond==1 & disputed==0) | (false_cond==1 & false==0))

label def rowcondlab 1 "Headline" 2 "Headline + 'disputed' tag" 3 "Headline + 'false' tag"
label val rowcond rowcondlab

label def warnlabel 0 "No warning" 1 "Warning"
label val warning warnlabel

*Figure 1 
cibar belief if dv<7 & purecontrol==0,  over1(rowcond) over2(warning) bargap(25) gap(150) barcolor(sand gs10 teal) ciopts(lcolor(black)) graphopts(legend(rows(1) keygap(1.5) rowgap(1.2) symxsize(10) size(*.75)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) yline(2 3, lstyle(yxline) lcolor(gray)) yline(1, lstyle(foreground)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ytitle("") ylabel(1 "Not at all accurate" 2 "Not very accurate" 3 "Somewhat accurate",angle(0) labsize(*.8)) yscale(r(1 3.1)))
graph export "belief-ci.pdf", replace

gen binarybelief=.
replace binarybelief=0 if belief<3
replace binarybelief=1 if belief>2 & belief<5

***********************
*WITH NO FLAG BASELINE*
***********************
reg belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store A1

*warning effect
lincom 1.warning /*warning effect relative to no correction */

*disputed versus false
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.false /*false effect with no warning*/
lincom 1.false-1.disputed /*false-disputed with no warning*/

*disputed effect with and without warning
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.disputed+1.disputed#1.warning /*disputed effect with warning*/
lincom 1.disputed#1.warning /*how effect of disputed flag changes given warning*/

*false effect with and without warning
lincom 1.false /*false effect with no warning*/
lincom 1.false+1.false#1.warning /*marginal effect of false given warning*/
lincom 1.false#1.warning /*how effect of false flag changes given warning*/

*Table 3
estout A1, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

reg belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0 & facebook_use<7, cluster(mid) robust
est store A1b

*effect size
esize twosample belief if disputed==0 & false==0 & purecontrol==0 & dv<7 & unflagged==0, by(warning) cohensd 
esize twosample belief if warning==0 & false==0 & purecontrol==0 & dv<7 & unflagged==0, by(disputed) cohensd 
esize twosample belief if disputed==0 & warning==0 & purecontrol==0 & dv<7 & unflagged==0, by(false) cohensd 

reg belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0 & faketerc==1, cluster(mid) robust
est store fake1
reg belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0 & faketerc==2, cluster(mid) robust
est store fake2
reg belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0 & faketerc==3, cluster(mid) robust
est store fake3
estout fake1 fake2 fake3, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

reg belief disputed##warning##faketerc false##warning##faketerc i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store fakeall

*Table C13
estout fakeall, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*accuracy, non-FB users excluded
estout A1b, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*mean belief percentages by condition
mean binarybelief if purecontrol==0 & dv<7 & unflagged==0 & disputed==1
mean binarybelief if purecontrol==0 & dv<7 & unflagged==0 & false==1
mean binarybelief if purecontrol==0 & dv<7 & unflagged==0 & nocorr==1

egen respondent_id=group(mid)
xtset respondent_id dv

*WITH NO FLAG BASELINE AND NON-FLAGGED CASES IN DISPUTED/FALSE CONDITIONS EXCLUDED
reg belief disputed##warning false##warning i.dv if purecontrol==0 & unflagged==0 & dv<7, cluster(mid) robust
est store A2

*respondent fixed effects omitted due to multicollinearity 
xtreg belief nocorr disputed##warning false##warning i.dv, cluster(mid) robust fe

*RANDOM EFFECTS
xtreg belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust re
est store A3

*PURE CONTROL BASELINE
reg belief nocorr disputed##warning false##warning i.dv if dv<7 & unflagged==0, cluster(mid) robust
est store A4

*ORDERED PROBIT
oprob belief disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store A5

*warning effect
lincom 1.warning /*warning effect relative to no correction*/

*disputed versus false
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.false /*false effect with no warning*/
lincom 1.false-1.disputed /*false-disputed with no warning*/

*disputed effect with and without warning
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.disputed+1.disputed#1.warning /*disputed effect with warning*/
lincom 1.disputed#1.warning /*how effect of disputed flag changes given warning*/

*false effect with and without warning
lincom 1.false /*false effect with no warning*/
lincom 1.false+1.false#1.warning /*marginal effect of false given warning*/
lincom 1.false#1.warning /*how effect of false flag changes given warning*/

*trump interactions

gen protrump=.
replace protrump=0 if dv==1 | dv==2 | dv==3
replace protrump=1 if dv==4 | dv==5 | dv==6

reg belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==0 & unflagged==0, cluster(mid) robust 
est store A

reg belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==0 & unflagged==0 & facebook_use<7, cluster(mid) robust 
est store Ab

*ORDERED PROBIT
oprob belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==0 & unflagged==0, cluster(mid) robust 
est store D

lincom 1.disputed /*marginal effect among trump disapprovers, no warning*/
lincom 1.disputed+1.disputed#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.disputed#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.false /*marginal effect among trump disapprovers, no warning*/
lincom 1.false+1.false#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.false#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.warning /*marginal effect among trump disapprovers, no flag*/
lincom 1.warning+1.warning#1.trump_approve_binary /*how it changes among trump approvers*/
lincom 1.warning#1.trump_approve_binary /*how it changes among trump approvers*/

reg belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==1 & unflagged==0, cluster(mid) robust 
est store B

reg belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==1 & unflagged==0 & facebook_use<7, cluster(mid) robust 
est store Bb

*ORDERED PROBIT
oprob belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==1 & unflagged==0, cluster(mid) robust 
est store E

*Table 4
estout A B, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Experimental effects on perceived accuracy of false headlines by article slant (Facebook users)
estout Ab Bb, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*fake news belief terciles
reg belief disputed##warning##faketerc false##warning##faketerc i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==0 & trump_approve_binary==0 & unflagged==0, cluster(mid) robust 
est store Afake1
reg belief disputed##warning##faketerc false##warning##faketerc i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==0 & trump_approve_binary==1 & unflagged==0, cluster(mid) robust 
est store Afake2
reg belief disputed##warning##faketerc false##warning##faketerc i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==1 & trump_approve_binary==0 & unflagged==0, cluster(mid) robust 
est store Bfake1
reg belief disputed##warning##faketerc false##warning##faketerc i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==1 & trump_approve_binary==1 & unflagged==0, cluster(mid) robust 
est store Bfake2

*Table C14
estout Afake1 Afake2 Bfake1 Bfake2, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C8: Ordered probit model of effects on perceived accuracy of false headlines by article slant
estout D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*with pure controls

reg belief nocorr##trump_approve_binary disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & protrump==0 & unflagged==0, cluster(mid) robust 
est store A
lincom 1.disputed /*marginal effect among trump disapprovers, no warning*/
lincom 1.disputed+1.disputed#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.disputed#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.false /*marginal effect among trump disapprovers, no warning*/
lincom 1.false+1.false#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.false#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.warning /*marginal effect among trump disapprovers, no flag*/
lincom 1.warning+1.warning#1.trump_approve_binary /*how it changes among trump approvers*/
lincom 1.warning#1.trump_approve_binary /*how it changes among trump approvers*/

reg belief nocorr##trump_approve_binary disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & protrump==1 & unflagged==0, cluster(mid) robust 
est store B

*Table C6: Perceived accuracy effects by article slant (includes pure controls)
estout A B, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

lincom 1.disputed /*marginal effect among trump disapprovers, no warning*/
lincom 1.disputed+1.disputed#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.disputed#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.false /*marginal effect among trump disapprovers, no warning*/
lincom 1.false+1.false#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.false#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.warning /*marginal effect among trump disapprovers, no flag*/
lincom 1.warning+1.warning#1.trump_approve_binary /*how it changes among trump approvers*/
lincom 1.warning#1.trump_approve_binary /*how it changes among trump approvers*/

label def applabel 0 "Trump disapprovers" 1 "Trump approvers"
label val trump_approve_binary applabel

*Figure 2a (with confidence intervals): Specific warning effects by political congeniality of false (anti-Trump) headlines
cibar belief if purecontrol==0 & warning==0 & protrump==0,  over1(rowcond) over2(trump_approve_binary) bargap(25) gap(150) barcolor(sand gs10 teal) ciopts(lcolor(black)) graphopts(legend(rows(1) keygap(1.5) rowgap(1.2) symxsize(10) size(*.75)) yline(2 3, lstyle(yxline) lcolor(gray)) yline(1, lstyle(foreground)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ytitle("") ylabel(1 "Not at all accurate" 2 "Not very accurate" 3 "Somewhat accurate",angle(0) labsize(*.8)) yscale(r(1 3.1)))
graph export "belief-anti-ci.pdf", replace

*Figure 2b (with confidence intervals): Specific warning effects by political congeniality of false (pro-Trump) headlines
cibar belief if purecontrol==0 & warning==0 & protrump==1,  over1(rowcond) over2(trump_approve_binary) bargap(25) gap(150) barcolor(sand gs10 teal) ciopts(lcolor(black)) graphopts(legend(rows(1) keygap(1.5) rowgap(1.2) symxsize(10) size(*.75)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) yline(2 3, lstyle(yxline) lcolor(gray)) yline(1, lstyle(foreground)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ytitle("") ylabel(1 "Not at all accurate" 2 "Not very accurate" 3 "Somewhat accurate",angle(0) labsize(*.8)) yscale(r(1 3.1)))
graph export "belief-pro-ci.pdf", replace

*trump interactions, excluding unflagged cases in disputed/false conditions
reg belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==0 & unflagged==0, cluster(mid) robust 
lincom 1.disputed /*marginal effect among trump disapprovers, no warning*/
lincom 1.disputed+1.disputed#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.disputed#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.false /*marginal effect among trump disapprovers, no warning*/
lincom 1.false+1.false#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.false#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.warning /*marginal effect among trump disapprovers, no flag*/
lincom 1.warning+1.warning#1.trump_approve_binary /*marginal effect among trump approvers*/
lincom 1.warning#1.trump_approve_binary /*how it changes among trump approvers*/

reg belief disputed##warning##trump_approve_binary false##warning##trump_approve_binary i.dv if trump_approve_binary!=. & purecontrol==0 & protrump==1 & unflagged==0, cluster(mid) robust 
lincom 1.disputed /*marginal effect among trump disapprovers, no warning*/
lincom 1.disputed+1.disputed#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.disputed#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.false /*marginal effect among trump disapprovers, no warning*/
lincom 1.false+1.false#1.trump_approve_binary /*marginal effect among trump approvers, no warning*/
lincom 1.false#1.trump_approve_binary /*how it changes among trump approvers, no warning*/

lincom 1.warning /*marginal effect among trump disapprovers, no flag*/
lincom 1.warning+1.warning#1.trump_approve_binary /*marginal effect among trump approvers*/
lincom 1.warning#1.trump_approve_binary /*how it changes among trump approvers*/

/*knowledge interaction by Trump approval and article slant, warning excluded*/
gen highknow=(polknow==4 | polknow==5)
reg belief disputed##highknow false##highknow i.dv if trump_approve_binary!=. & purecontrol==0 & warning==0 & protrump==0 & trump_approve_binary==0 & unflagged==0, cluster(mid) robust 
est store AW1
reg belief disputed##highknow false##highknow i.dv if trump_approve_binary!=. & purecontrol==0 & warning==0 & protrump==1 & trump_approve_binary==0 & unflagged==0, cluster(mid) robust 
est store AW2
reg belief disputed##highknow false##highknow i.dv if trump_approve_binary!=. & purecontrol==0 & warning==0 & protrump==1 & trump_approve_binary==1 & unflagged==0, cluster(mid) robust 
est store AW3
reg belief disputed##highknow false##highknow i.dv if trump_approve_binary!=. & purecontrol==0 & warning==0 & protrump==0 & trump_approve_binary==1 & unflagged==0, cluster(mid) robust 
est store AW4

*Table C16: Experimental effects on perceived accuracy by political knowledge
estout AW1 AW2 AW3 AW4, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*add exclusion for cases where they hadn't seen a flag yet
count

preserve
collapse (mean) disputed_cond false_cond, by(mid)
tab disputed_cond false_cond, missing
codebook mid
restore

forval i=1/9 {
drop if dv==`i' & disputed_cond==1 & before_disputed`i'==1
drop if dv==`i' & false_cond==1 & before_false`i'==1
}

count

preserve
collapse (mean) disputed_cond false_cond, by(mid)
tab disputed_cond false_cond, missing
codebook mid
restore

*not labeled in disputed/false conditions
reg belief nocorr_cond disputed_cond##warning false_cond##warning i.dv if disputed==0 & false==0 & dv<7, robust cluster(mid)
lincom 1.disputed_cond-nocorr_cond /*disputed condition assignment effect*/
lincom 1.false_cond-nocorr_cond /*false condition assignment effect*/

*no flag baseline
reg belief disputed_cond##warning false_cond##warning i.dv if disputed==0 & false==0 & dv<7 & purecontrol==0, robust cluster(mid)
est store A

lincom 1.disputed_cond /*disputed condition assignment effect*/
lincom 1.false_cond /*false condition assignment effect*/

reg belief disputed_cond##warning##faketerc false_cond##warning##faketerc i.dv if disputed==0 & false==0 & dv<7 & purecontrol==0, robust cluster(mid)
est store Aterc
lincom 1.warning+2.faketerc#1.warning
lincom 1.warning+3.faketerc#1.warning

reg belief disputed_cond##warning false_cond##warning i.dv if disputed==0 & false==0 & dv<7 & purecontrol==0 & facebook_use<7, robust cluster(mid)
est store Ac

reg belief disputed_cond##warning##trump_approve_binary false_cond##warning##trump_approve_binary i.dv if disputed==0 & false==0 & dv<7 & purecontrol==0, robust cluster(mid)
est store C

*ORDERED PROBIT
oprob belief disputed_cond##warning##trump_approve_binary false_cond##warning##trump_approve_binary i.dv if disputed==0 & false==0 & dv<7 & purecontrol==0, robust cluster(mid)
est store D

*real stories, pure control baseline
reg belief nocorr_cond disputed_cond##warning false_cond##warning i.dv if (dv==7 | dv==8 | dv==9), cluster(mid) robust
lincom 1.warning /*warning effect relative to no correction */
lincom 1.disputed-nocorr /*disputed effect with no warning*/
lincom 1.false-nocorr /*false effect with no warning*/
lincom 1.false-1.disputed /*false-disputed with no warning*/
lincom 1.disputed#1.warning /*how effect of disputed flag changes given warning*/
lincom 1.disputed-nocorr+1.disputed#1.warning /*marginal effect of disputed given warning*/
lincom 1.false#1.warning /*how effect of false flag changes given warning*/
lincom 1.false-nocorr+1.false#1.warning /*marginal effect of false given warning*/

*real stories, no flag baseline 
reg belief disputed_cond##warning false_cond##warning i.dv if (dv==7 | dv==8 | dv==9) & purecontrol==0, cluster(mid) robust
est store B

*warning effect
lincom 1.warning /*warning effect relative to no correction */

*disputed versus false
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.false /*false effect with no warning*/
lincom 1.false-1.disputed /*false-disputed with no warning*/

*disputed effect with and without warning
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.disputed+1.disputed#1.warning /*disputed effect with warning*/
lincom 1.disputed#1.warning /*how effect of disputed flag changes given warning*/

*false effect with and without warning
lincom 1.false /*false effect with no warning*/
lincom 1.false+1.false#1.warning /*marginal effect of false given warning*/
lincom 1.false#1.warning /*how effect of false flag changes given warning*/

reg belief disputed_cond##warning false_cond##warning i.dv if (dv==7 | dv==8 | dv==9) & purecontrol==0 & facebook_use<7, cluster(mid) robust
est store Bc

*ORDERED PROBIT
oprob belief disputed_cond##warning##trump_approve_binary false_cond##warning##trump_approve_binary i.dv if (dv==7 | dv==8 | dv==9) & purecontrol==0, cluster(mid) robust
est store E

*Table 5: Experimental tests for spillover effects on perceived accuracy
estout A B, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*fake news terciles
reg belief disputed_cond##warning##faketerc false_cond##warning##faketerc i.dv if (dv==7 | dv==8 | dv==9) & purecontrol==0, cluster(mid) robust
est store Bterc
lincom 1.warning+2.faketerc#1.warning
lincom 1.warning+3.faketerc#1.warning

*Table C15
estout Aterc Bterc, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C12
estout Ac Bc, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C9: Ordered probit model of spillover effects of warnings on perceived accuracy
estout D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*testing warning effect on true versus false headlines

replace disputed=0 if disputed==.
replace false=0 if false==.

gen true = (dv>6 & dv<10)
reg belief disputed_cond##warning##true false_cond##warning##true i.dv if disputed==0 & false==0 & purecontrol==0, cluster(mid) robust
lincom 1.warning+1.warning#1.true

label def truelabel 0 "False" 1 "True"
label val true truelabel

*Figure 3
cibar belief if purecontrol==0 & disputed_cond==0 & false_cond==0,  over1(warning) over2(true) bargap(25) gap(150) barcolor(sand gs15 teal) ciopts(lcolor(black)) graphopts(legend(rows(1)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) yline(2 3, lstyle(yxline) lcolor(gray)) yline(1, lstyle(foreground)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ytitle("") ylabel(1 "Not at all accurate" 2 "Not very accurate" 3 "Somewhat accurate",angle(0) labsize(*.8)) yscale(r(1 3.1)))
graph export "belief-label-true-ci.pdf", replace


/*like reshape*/

use "warnings-tags-replication.dta", clear

*like reshape
rename draft_like like1
rename bee_like like2
rename chaf_like like3
rename protester_like like4
rename marines_like like5 
rename fbiagent_like like6 

reshape long like,i(mid) j(dv)

gen nocorr=.
replace nocorr=(draft_nocorr==1) if dv==1
replace nocorr=(bee_nocorr==1) if dv==2
replace nocorr=(chaf_nocorr==1) if dv==3
replace nocorr=(protester_nocorr==1) if dv==4
replace nocorr=(marines_nocorr==1) if dv==5
replace nocorr=(fbiagent_nocorr==1) if dv==6

gen disputed=.
replace disputed=(draft_disputed==1) if dv==1
replace disputed=(bee_disputed==1) if dv==2
replace disputed=(chaf_disputed==1) if dv==3
replace disputed=(protester_disputed==1) if dv==4
replace disputed=(marines_disputed==1) if dv==5
replace disputed=(fbiagent_disputed==1) if dv==6

gen false=.
replace false=(draft_false==1) if dv==1
replace false=(bee_false==1) if dv==2
replace false=(chaf_false==1) if dv==3
replace false=(protester_false==1) if dv==4
replace false=(marines_false==1) if dv==5
replace false=(fbiagent_false==1) if dv==6

gen unflagged=((disputed_cond==1 & disputed==0) | (false_cond==1 & false==0))

*fake headlines only
reg like disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store B1

lincom 1.warning /*warning effect relative to no correction */
lincom 1.disputed /*disputed effect with no warning*/
lincom 1.false /*false effect with no warning*/
lincom 1.false-1.disputed /*not preregistered*/

egen respondent_id=group(mid)
xtset respondent_id dv

*WITH NO FLAG BASELINE AND NON-FLAGGED CASES IN DISPUTED/FALSE CONDITIONS EXCLUDED
reg like disputed##warning false##warning i.dv if purecontrol==0 & unflagged==0 & dv<7, cluster(mid) robust
est store B2

*RANDOM EFFECTS
xtreg like disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust re
est store B3

*ORDERED PROBIT
oprob like disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store B5


*share reshape (no pure control baseline - they don't see headline)

use "warnings-tags-replication.dta", clear

*share reshape
rename draft_share share1
rename bee_share share2
rename chaf_share share3
rename protester_share share4
rename marines_share share5 
rename fbiagent_share share6 

reshape long share,i(mid) j(dv)

gen nocorr=.
replace nocorr=(draft_nocorr==1) if dv==1
replace nocorr=(bee_nocorr==1) if dv==2
replace nocorr=(chaf_nocorr==1) if dv==3
replace nocorr=(protester_nocorr==1) if dv==4
replace nocorr=(marines_nocorr==1) if dv==5
replace nocorr=(fbiagent_nocorr==1) if dv==6

gen disputed=.
replace disputed=(draft_disputed==1) if dv==1
replace disputed=(bee_disputed==1) if dv==2
replace disputed=(chaf_disputed==1) if dv==3
replace disputed=(protester_disputed==1) if dv==4
replace disputed=(marines_disputed==1) if dv==5
replace disputed=(fbiagent_disputed==1) if dv==6

gen false=.
replace false=(draft_false==1) if dv==1
replace false=(bee_false==1) if dv==2
replace false=(chaf_false==1) if dv==3
replace false=(protester_false==1) if dv==4
replace false=(marines_false==1) if dv==5
replace false=(fbiagent_false==1) if dv==6

gen unflagged=((disputed_cond==1 & disputed==0) | (false_cond==1 & false==0))

reg share disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store C1

egen respondent_id=group(mid)
xtset respondent_id dv

*WITH NO FLAG BASELINE AND NON-FLAGGED CASES IN DISPUTED/FALSE CONDITIONS EXCLUDED
reg share disputed##warning false##warning i.dv if purecontrol==0 & unflagged==0 & dv<7, cluster(mid) robust
est store C2

*RANDOM EFFECTS
xtreg share disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust re
est store C3

*ORDERED PROBIT
oprob share disputed##warning false##warning i.dv if purecontrol==0 & dv<7 & unflagged==0, cluster(mid) robust
est store C5

*NO PURE CONTROL BASELINE - THEY DON'T SEE HEADLINE

*Table B1: Experimental effects on social endorsements of false headlines
estout B1 C1, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C3: Excludes responses to unflagged false headlines in "Disputed"/"Rated false" conditions
estout A2 B2 C2, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C4: Accuracy and social endorsement effects models (random effects)
estout A3 B3 C3, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C5: Accuracy model (includes pure controls)
estout A4, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*Table C7: Ordered probit model of accuracy and social endorsement effects
estout A5 B5 C5, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01)
