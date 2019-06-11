
* This is the replication file for "The Impact of Context on the Ability of Leaders to Signal Resolve" by Roseanne McManus.
* TO RUN THE FINAL COMMANDS IN THIS FILE, IT IS NECESSARY TO INSTALL THE USER-WRITTEN STATA COMMANDS "ESTOUT" AND "GOLOGIT2"

clear all
capture log close
set more off
log using "Statement Context Paper.log", replace
use "Statement Context Data.dta", clear


* Table 1
sum national if year<2008, d
sum press if year <2008, d
sum press_script if year<2008, d
sum press_unscript if year<2008, d
sum narrow if year<2008, d
sum campaign if year<2008, d


* Tables 2, Models 1-3
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, replace se(3) b(3) star(* 0.1 ** 0.05 *** 0.01) //This is the main Table 2.
esttab using output.rtf, append se(5) b(5) star(* 0.1 ** 0.05 *** 0.01) //This is the same table with more digits. I just used this command to get the coefficients and SEs for the year squared and cubed variables because they start with so many zeros.
eststo clear

* Table 3, Models 4-6
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append se(3) b(3) star(* 0.1 ** 0.05 *** 0.01) //This is the main Table 3.
esttab using output.rtf, append se(5) b(5) star(* 0.1 ** 0.05 *** 0.01) //This is the same table with more digits. I just used this command to get the coefficients and SEs for the year squared and cubed variables because they start with so many zeros.
eststo clear

* Figure 1
margins, dydx(nationalandscriptpress allbutnationalandscriptpress) predict(outcome(3)) level(90)
marginsplot


* Model 7 in Table 4
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc cincperc demb year_cen year_sq year_cub, vce(robust)

* Figure 2
gen pipe="|"
gen rug=-.025
margins, dydx(stat3w30d) at(elig_elec_2yr_perc=(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1)) predict(outcome(3)) level(95) noatlegend
  marginsplot, recast(line) recastci(rline) addplot (scatter rug elig_elec_2yr_perc, ms(none) mlabel(pipe) mlabpos(0)) legend(off)

* Robustness check mentioned in footnote 16.
oprobit ordoutcome c.stat3w30d##c.elig_elec_yr_perc cincperc demb year_cen year_sq year_cub, vce(robust)

* Model 8 in Table 4
gen allButNatPerc=allbutnational/stat3w30d
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub, vce(robust)

* Figure 3
replace rug=-1
margins, dydx(national) at(allButNatPerc=(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1)) predict(outcome(3)) level(95)
 marginsplot, recast(line) recastci(rline) addplot (scatter rug allButNatPerc, ms(none) mlabel(pipe) mlabpos(0)) legend(off)

* Model 9 in Table 4
gen allButPSPerc=allbutpress_script/stat3w30d
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub, vce(robust)

* Figure 4
replace rug=-0.7
margins, dydx(press_script) at(allButPSPerc=(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1)) predict(outcome(3)) level(95)
 marginsplot, recast(line) recastci(rline) addplot (scatter rug allButPSPerc, ms(none) mlabel(pipe) mlabpos(0)) legend(off)

esttab using output.rtf, append se(3) b(3) star(* 0.1 ** 0.05 *** 0.01) //The command that actually generates Table 4.
eststo clear


* Appendix Predicted Probability Table
//This is mentioned in footnote 18 in the main text.
oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub, vce(robust)
margins, at(nationalandscriptpress=.5 allbutnationalandscriptpress=.5) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=.75 allbutnationalandscriptpress=.25) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=.9 allbutnationalandscriptpress=.1) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=.99 allbutnationalandscriptpress=.01) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=1 allbutnationalandscriptpress=0) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=2.5 allbutnationalandscriptpress=2.5) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=4 allbutnationalandscriptpress=1) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=4.5 allbutnationalandscriptpress=.5) predict(outcome(3)) level(95) noatlegend
margins, at(nationalandscriptpress=5 allbutnationalandscriptpress=0) predict(outcome(3)) level(95) noatlegend


* VALIDITY CHECKS

* Matching on level of statements (mentioned in robustness section of text)
gen winout=(ordoutcome==3)
gen somehighprofile=(national>0 | press_script> 0)
teffects nnmatch (winout stat3w30d) (somehighprofile) if stat3w30d!=0

/* The next portion of the do file shows the appendix tables.
Every model in the paper has two appendix tables.
The first table for each model shows: "Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs"
The second table for each model shows: "Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure"
Then there are several other tables at the end that show the one test for different models. These are the tests adding more controls, adding presidential dummies, and using gologit2.
The reason these tests are grouped differently is just that their output is so long. Grouping them together means that I only need a few long tables. 

Note that the Table numbers here should correspond, but the model numbers will not because esttab automatically starts with number 1.*/

* Appendix Table A6
preserve
drop if year>2000 //Because not all matching variable available after this year.
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(nationalover0) showbreaks
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 1 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A7
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome national1w allbutnational1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome national10w allbutnational10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 1 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear

* Appendix Table A8
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(pressover0) showbreaks
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 2 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A9
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome press1w allbutpress1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome press10w allbutpress10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 2 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A10
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(press_scriptover0) showbreaks
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 3 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A11
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome press_script1w press_unscript1w allbutpress1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome press_script10w press_unscript10w allbutpress10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 3 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A12
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(narrowover0) showbreaks
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 4 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A13
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome narrow1w allbutnarrow1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome narrow10w allbutnarrow10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 4 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A14
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(campaignover0) showbreaks
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 5 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A15
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome campaign1w allbutcampaign1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome campaign10w allbutcampaign10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 5 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A16
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(nationalandscriptpressover0) showbreaks
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 6 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A17
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome nationalandscriptpress1w allbutnationalandscriptpress1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome nationalandscriptpress10w allbutnationalandscriptpress10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 6 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear

* Appendix Table A18
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(totalstatovermedian) showbreaks
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome c.stat3w30d##c.elig_elec_2yr_perc  cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc  cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc  cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc  cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc  cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 7 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A19
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome c.stat1w30d##c.elig_elec_2yr_perc cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome c.stat10w30d##c.elig_elec_2yr_perc  cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 7 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A20
gen allButNatPerc1w=allbutnational1w/stat1w30d
gen allButNatPerc10w=allbutnational10w/stat10w30d
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(nationalover0) showbreaks
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 8 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

* Appendix Table A21
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome c.national1w##c.allButNatPerc1w allbutnational1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome c.national10w##c.allButNatPerc10w allbutnational10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 8 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A22
gen allButPSPerc1w=allbutpress_script1w/stat1w30d
gen allButPSPerc10w=allbutpress_script10w/stat10w30d
preserve
drop if year>2000
cem cincperc demb (.5) defense_atop (.5) sideaa (.5) pres(2.5 4.5 6.5 7.5 9.5 10.5), tr(press_scriptover0) showbreaks
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub [iweight=cem_weights], vce(robust)
drop cem_weights
restore
reg ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub
predict d, cooksd
gsort -d
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub if _n>10, vce(robust)
drop d
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub if dispnum!=3058 & dispnum!=3636 & dispnum!=3901 & dispnum!=3957 & dispnum!=4273 & dispnum!=4283, vce(robust)
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub if duration>1, vce(robust)
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub if revterritory ==1 | revregime ==1 | revpolicy ==1 | revother==1, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 9 Robustness Checks, Part 1) mtitles("Matched Sample" "Drop Most Influential Obs." "Drop MIDs Won by Force" "Drop 1-Day MIDs" "Drop Non-Revisionist MIDs") nonum
eststo clear

*Appendix Table A23
preserve
set seed 924785
gen randomorder=runiform()
sort randomorder
duplicates drop dispnum, force
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub, vce(robust)
restore
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub if overlap==0, vce(robust)
eststo: oprobit ordoutcome c.press_script1w##c.allButPSPerc1w press_unscript1w allbutpress1w cincperc demb year_cen year_sq year_cub, vce(robust)
eststo: oprobit ordoutcome c.press_script10w##c.allButPSPerc10w press_unscript10w allbutpress10w cincperc demb year_cen year_sq year_cub, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Model 9 Robustness Checks, Part 2) mtitles("Retain 1 Dyad Per MID" "Drop Overlapping MIDs" "1-Weight Dictionary" "10-Weight Dictionary" "Dummy Statement Measure") nonum
eststo clear


* Appendix Table A24
eststo: oprobit ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Models 1-5 with More Controls)
eststo clear

* Appendix Table A25
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome c.national##c.allButNatPerc  allbutnational cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub hostleva hostlevb sanctions coldwar sideaa defense_atop rus nkr chn cub irq lib irn, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Models 6-9 with More Controls)
eststo clear

* Appendix Table A26
eststo: oprobit ordoutcome national allbutnational cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome press allbutpress cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome press_script press_unscript allbutpress cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome narrow allbutnarrow cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome campaign allbutcampaign cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Models 1-5 with President Dummies)
eststo clear

* Appendix Table A27
eststo: oprobit ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome c.stat3w30d##c.elig_elec_2yr_perc cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome c.national##c.allButNatPerc allbutnational cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
eststo: oprobit ordoutcome c.press_script##c.allButPSPerc press_unscript allbutpress cincperc demb kennedy johnson nixon ford carter reagan bush1 clinton bush2, vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Models 6-9 with President Dummies)
eststo clear

* Appendix Table A28
eststo: gologit2 ordoutcome national allbutnational cincperc demb year_cen year_sq year_cub, autofit vce(robust)
eststo: gologit2 ordoutcome press allbutpress cincperc demb year_cen year_sq year_cub, autofit vce(robust)
eststo: gologit2 ordoutcome press_script press_unscript allbutpress cincperc demb year_cen year_sq year_cub, autofit vce(robust)
eststo: gologit2 ordoutcome narrow allbutnarrow cincperc demb year_cen year_sq year_cub, autofit vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Generalized Ordered Logit Versions of Models 1-4)
eststo clear

* Appendix Table A29
eststo: gologit2 ordoutcome campaign allbutcampaign cincperc demb year_cen year_sq year_cub, autofit vce(robust)
eststo: gologit2 ordoutcome nationalandscriptpress allbutnationalandscriptpress cincperc demb year_cen year_sq year_cub, autofit vce(robust)
gen stat3w30dXelig_elec_2yr_perc=stat3w30d*elig_elec_2yr_perc
gen nationalXallButNatPerc=national*allButNatPerc
gen press_scriptXallButPSPerc=press_script*allButPSPerc
eststo: gologit2 ordoutcome stat3w30d elig_elec_2yr_perc stat3w30dXelig_elec_2yr_perc cincperc demb year_cen year_sq year_cub, vce(robust)
gologit2 ordoutcome national allButNatPerc nationalXallButNatPerc allbutnational cincperc demb year_cen year_sq year_cub, autofit vce(robust)
// I do not show the results of this model because it does not converge properly. The command produces a warning message.
eststo: gologit2 ordoutcome press_script allButPSPerc press_scriptXallButPSPerc press_unscript allbutpress cincperc demb year_cen year_sq year_cub, autofit vce(robust)
esttab using output.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title(Generalized Ordered Logit Versions of Models 5-7 and 9)
eststo clear


log close
