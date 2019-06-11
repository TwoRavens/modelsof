********************************************************************************************************************
********************************************************************************************************************
* Replication File and Data
* Title:   Which Grievances Make People Support Violence against the State? Survey Evidence from the Niger Delta
* Number:  GINI-2016-1124.R1
* Journal: International Interactions
* Author:  Carlo Koos
*
* Note: - The graphics were produced with the scheme "plotplain": type "ssc install blindschemes, replace all" to
*         to install this scheme
*       - The graphics have been refined with the macro "marginsplot.grec" which is part of the zip-folder. Copy
*         "marginsplot.grec" into the same folder as the do-file and the dta-file
*       - Specify the working directory below
********************************************************************************************************************
********************************************************************************************************************
clear
* set working directory to location of data file
* cd "<YOUR WORKING DIRECTORY>"
cd "D:\Users\user\Desktop\test"
use IntInt_Koos_WhichGrievances // this is the data file

********************************************************************************************************************
* SET GLOBAL VARS
********************************************************************************************************************
global DV antistate_likert  
global control1 age  female employed education  
global FE OkrikaLGA GokanaLGA // these are dummies used to control for each location, Ogba is the base category

********************************************************************************************************************
* CHECK MULTICOLLINEARITY
********************************************************************************************************************
collin oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 
* multicoll no problem, VIFs very low (max. 1.23)

********************************************************************************************************************
* DESCRIPTIVE PLOTS
* Figures 1 and 2 are maps which were produced with qGIS for which there is no script available
* Figure 3: Outcome variable "Support of anti-state violence"
********************************************************************************************************************
graph bar, over(antistate_likert) missing blabel(total, format(%3.1f)) ///
  title("How right is violence against the government if peaceful demands are continually being ignored?") ///
  note(, size(small)) scheme(plotplain) scale(.8)
graph export plot_antistate.png, replace width(5000)

********************************************************************************************************************
* DESCRIPTIVE PLOTS
* Figure 4: Main explanatory variables combined in one plot
********************************************************************************************************************

*oil_revnues
graph bar, over(oil_revenues) missing blabel(total, format(%3.1f)) ///
  title("(a) H1: How fair is the share of oil revenues that" "your community receives from the state government?") ///
  note(, size(small)) scheme(plotplain) scale(.8)
graph save plot_2.gph, replace

*ethnic discrimination
graph bar, over(ethnic_discrimination) missing blabel(total, format(%3.1f)) ///
  title("(b) H2: How often has your ethnic group been treated badly" "by the federal government since the last elections in 2011?") ///
  note(, size(small)) scheme(plotplain) scale(.8)
graph save plot_3.gph, replace

*livelihood_destruction
graph bar, over(livelihood_dest) missing blabel(total, format(%3.1f)) ///
  title("(c) H3: Index variable 'Livelihood destruction'") ///
  note("Higher x-values represent higher perception of livelihood destruction", size(small)) scheme(plotplain) scale(.8)
graph save plot_4.gph, replace

*basic services
graph bar, over(basic_services) missing blabel(total, format(%3.1f)) ///
  title("(d) H4: Index variable 'Basic services'") ///
  note("Higher x-values represent higher satisfaction with access to basic services", size(small)) scheme(plotplain) scale(.8)
graph save plot_5.gph, replace

*combine plots
graph combine plot_2.gph plot_4.gph plot_3.gph plot_5.gph, ycommon r(3) c(2) colfirst iscale(.7) ///
 subtitle("", size(small)) scheme(plotplain)
graph export combined_descplots.png, replace width(5000)

********************************************************************************************************************
********************************************************************************************************************
* STATISTICAL ANALYSIS
* TEST ASSUMPTIONS FOR ORDERED LOGIT MODEL: parallel lines/proportional odds assumption
********************************************************************************************************************
********************************************************************************************************************
omodel logit $DV oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE
* significant p-value suggests violation of the assmptions
ologit $DV oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE, cluster(location)
brant, detail
* The Brant test shows a significant test statistic which suggests that the parallel regression assumption has been violated
* Therefore a standard ordered logit model is not appropriate. 
* Richard Williams (2006) provides a Generalized Ordered Logit Model for Ordinal Dependent Variables which relaxes these assumptions,
* but uses the information about the order of the responses in the outcome variable. This model is therefore preferential to a 
* multinomial logit model in which the ordering of responses would be lost.

********************************************************************************************************************
* STATISTICAL ANALYSIS
* Table 1: Grievances and Support for Violence (Partial Proportional Odds Model)
********************************************************************************************************************
global model gologit2 // set model for subsequent estimations
       
eststo clear
eststo: $model $DV oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE, link(logit) cluster(location) gamma(gamma1) autofit(.1) 
estout gamma1

esttab gamma1 using gologit.rtf, b(3) se(3) aic bic label replace unstack star(* 0.10 ** 0.05 *** 0.01) drop(_cons*) ///
  onecell compress nogaps ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Dependent variable: support for anti-state violence (Coding: 0=very wrong, 1=wrong, 2=neither right, nor wrong, 3=right, 4=very right)" ///
  "Standard errors clustered by location in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")

********************************************************************************************************************
* PREDICTED PROBABILITIES / SUBSTANTIVE EFFECTS
* Figure 5: Predicted Probabilities
********************************************************************************************************************
margins, predict(outcome(4)) at(oil_revenues=(0(1)4) female=(0) employed=(0) GokanaLGA=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a)") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save 1.gph, replace

margins, predict(outcome(4)) at(ethnic_discrimination=(0(1)1) female=(0) employed=(0) GokanaLGA=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b)") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save 2.gph, replace

margins, predict(outcome(4)) at(livelihood_dest=(0(1)4) female=(0) employed=(0) GokanaLGA=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c)") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save 3.gph, replace

margins, predict(outcome(4)) at(basic_services=(0(1)8) female=(0) employed=(0) GokanaLGA=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (d)") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save 4.gph, replace

margins, predict(outcome(4)) at(violence=(0(1)3) female=(0) employed=(0) GokanaLGA=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (e)") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save 5.gph, replace

margins, predict(outcome(4)) at(assets=(0(1)12) female=(0) employed=(0) GokanaLGA=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (f)") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save 6.gph, replace

graph combine 1.gph 3.gph 5.gph 2.gph 4.gph 6.gph, ycommon r(3) c(2) colfirst iscale(0.5) scheme(plotplain)
graph export combined_probabilities.png, replace width(4000) height(3000)

********************************************************************************************************************
********************************************************************************************************************
* 
* ONLINE APPENDIX
*
********************************************************************************************************************
********************************************************************************************************************

********************************************************************************************************************
* DESCRIPTIVE SUMMARY STATISTICS
* Table A1 (online appendix)
********************************************************************************************************************
eststo clear
estpost summarize $DV oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1
esttab using descriptive.rtf, replace cells("mean sd min max count") noobs label ///
  title("Table A1: Summary Statistics") onecell compress
eststo clear

********************************************************************************************************************
* ROBUSTNESS CHECKS
* Table A2: Determinants of missing values in the outcome variable 'Support for anti-state violence'
********************************************************************************************************************
gen miss_outcome=0
replace miss_outcome=1 if antistate_likert==.
label var miss_outcome "Missing outcome"
eststo clear 

eststo: logit miss_outcome oil_revenues ethnic_discrimination livelihood_dest basic_services                              , cluster(location) 
eststo: logit miss_outcome oil_revenues ethnic_discrimination                                violence assets $control1 $FE, cluster(location)
eststo: logit miss_outcome                                    livelihood_dest basic_services violence assets $control1 $FE, cluster(location)
eststo: logit miss_outcome oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE, cluster(location)

estimates store miss_outcome

esttab using miss_outcome.rtf, beta(3) se(3) aic bic label title("Table A2: Determinants of missing values in outcome variable 'Support for anti-state violence'") ///
  mtitle("H1-H4 only" "Collective grievances" "Individual grievances" "Full model") ///
  onecell compress nogaps replace drop(_cons) star(* 0.10 ** 0.05 *** 0.01) ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Dependent variable: Missing values in outcome variable (0=nonmissing, 1=missing). 15 (2.7%) out of 548 observations have a missing value in the outcome variable. Standard errors clustered by location in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")
eststo clear

********************************************************************************************************************
* ROBUSTNESS CHECKS
* Table A3: Main Analysis with Disaggregated Violence Variables (Partial Proportional Odds Model)
********************************************************************************************************************
eststo clear
eststo: gologit2 $DV oil_revenues ethnic_discrimination livelihood_dest basic_services violence_friends_attacked violence_friends_killed violence_personal_attack assets $control1 $FE, link(logit) cluster(location) gamma(gamma2) autofit(.1) 
estout gamma2

esttab gamma2 using violence_dis.rtf, b(3) se(3) aic bic label replace unstack star(* 0.10 ** 0.05 *** 0.01) drop(_cons*) ///
  onecell compress nogaps ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence_friends_attacked violence_friends_killed violence_personal_attack assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Dependent variable: support for anti-state violence (Coding: 0=very wrong, 1=wrong, 2=neither right, nor wrong, 3=right, 4=very right)" ///
  "Standard errors clustered by location in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")
eststo clear

********************************************************************************************************************
* ROBUSTNESS CHECKS
* Table A4: Main Analysis with Dummy Outcome (Logit Model)
********************************************************************************************************************
eststo clear
eststo: logit antistate_d1 oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE, cluster(location) 
eststo: logit antistate_d2 oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE, cluster(location) 
eststo: logit antistate_d3 oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 $FE, cluster(location) 

esttab using logit_3.rtf, b(3) se(3) aic bic label replace unstack star(* 0.10 ** 0.05 *** 0.01) drop(_cons*) ///
  onecell compress nogaps ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Outcome variable: Support for Anti-State Violence." ///
    "In model (1) the dummy outcome variable is coded as follows: categories 'very right' and 'right' are coded as '1', all other as '0'" ///
	"In model (2) the dummy outcome variable is coded as follows: categories 'very right' and 'right' are coded as '1', 'neither right, nor wrong' as missing and all other as '0'" ///
	"In model (3) the dummy outcome variable is coded as follows: categories 'very right', 'right' and 'neither right, nor wrong' are coded as '1', all other as '0'" ///
	"Standard errors clustered by location in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")
eststo clear

********************************************************************************************************************
* DESCRIPTIVE PLOTS
* Figure A1: Ethnic Composition of Sample
********************************************************************************************************************
graph bar, over(ethnicity) missing blabel(total, format(%3.1f)) ///
  title("") note(" ", size(small)) scheme(plotplain) scale(.8)
graph export ethnic_composition.png, replace width(5000)

********************************************************************************************************************
* PREDICTED PROBABILITIES / SUBSTANTIVE EFFECTS BY LOCATION
* Figures A2, A3, A4
********************************************************************************************************************
global model_pl gologit2
global DV_pl antistate_likert3

* First calculate the predicated probabilities by location and afterwards combine these
* Ogba model
eststo clear
eststo: $model_pl $DV_pl oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 if location==1, link(logit) gamma force autofit(.1)

esttab using gologit_Ogba.rtf, b(3) se(3) aic bic label replace unstack star(* 0.10 ** 0.05 *** 0.01) drop(_cons) ///
  onecell compress nogaps ///
  mtitle("W vs. NRNW, R" "W, NRNW vs. R") ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Dependent variable: support for anti-state violence. Standard errors in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")

margins, predict(outcome(3)) at(oil_revenues=(0(1)4) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a) Ogba-Egbema-Ndoni") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Ogba1.gph, replace

margins, predict(outcome(3)) at(ethnic_discrimination=(0(1)1) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a) Ogba-Egbema-Ndoni") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Ogba2.gph, replace

margins, predict(outcome(3)) at(livelihood_dest=(0(1)4) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a) Ogba-Egbema-Ndoni") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Ogba3.gph, replace

margins, predict(outcome(3)) at(basic_services=(0(1)8) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a) Ogba-Egbema-Ndoni") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Ogba4.gph, replace

margins, predict(outcome(3)) at(violence=(0(1)3) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a) Ogba-Egbema-Ndoni") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Ogba5.gph, replace

margins, predict(outcome(3)) at(assets=(0(1)12) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (a) Ogba-Egbema-Ndoni") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Ogba6.gph, replace

graph combine Ogba1.gph Ogba3.gph Ogba5.gph Ogba2.gph Ogba4.gph Ogba6.gph, ycommon r(3) c(2) colfirst iscale(0.5) ///
 subtitle(" ", size(small)) scheme(plotplain)
graph export Ogba_combined_probabilities.png, replace width(5000)

* Okrika model
eststo clear
eststo: $model_pl $DV_pl oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 if location==2, link(logit) gamma force autofit(.1)

esttab using gologit_Okrika.rtf, b(3) se(3) aic bic label replace unstack star(* 0.10 ** 0.05 *** 0.01) drop(_cons) ///
  onecell compress nogaps ///
  mtitle("W vs. NRNW, R" "W, NRNW vs. R") ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Dependent variable: support for anti-state violence. Standard errors in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")

margins, predict(outcome(3)) at(oil_revenues=(0(1)4) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b) Okrika") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Okrika1.gph, replace

margins, predict(outcome(3)) at(ethnic_discrimination=(0(1)1) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b) Okrika") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Okrika2.gph, replace

margins, predict(outcome(3)) at(livelihood_dest=(0(1)4) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b) Okrika") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Okrika3.gph, replace

margins, predict(outcome(3)) at(basic_services=(0(1)8) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b) Okrika") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Okrika4.gph, replace

margins, predict(outcome(3)) at(violence=(0(1)3) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b) Okrika") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Okrika5.gph, replace

margins, predict(outcome(3)) at(assets=(0(1)12) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (b) Okrika") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Okrika6.gph, replace

graph combine Okrika1.gph Okrika3.gph Okrika5.gph Okrika2.gph Okrika4.gph Okrika6.gph, ycommon r(3) c(2) colfirst iscale(0.5)  ///
 title(" ", size(small)) scheme(plotplain)
graph export Okrika_combined_probabilities.png, replace width(5000)

*Gokana model
eststo clear
eststo: $model_pl $DV_pl oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets $control1 if location==3, link(logit) gamma force autofit(.1)

esttab using gologit_Okrika.rtf, b(3) se(3) aic bic label replace unstack star(* 0.10 ** 0.05 *** 0.01) drop(_cons) ///
  onecell compress nogaps ///
  mtitle("W vs. NRNW, R" "W, NRNW vs. R") ///
  order(oil_revenues ethnic_discrimination livelihood_dest basic_services violence assets  $control1 $FE) ///
  nodepvars nonotes addnotes("Dependent variable: support for anti-state violence. Standard errors in parentheses." "* p < 0.10, ** p < 0.05, *** p < 0.01")

margins, predict(outcome(3)) at(oil_revenues=(0(1)4) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c) Gokana") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Gokana1.gph, replace

margins, predict(outcome(3)) at(ethnic_discrimination=(0(1)1) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c) Gokana") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Gokana2.gph, replace

margins, predict(outcome(3)) at(livelihood_dest=(0(1)4) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c) Gokana") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Gokana3.gph, replace

margins, predict(outcome(3)) at(basic_services=(0(1)8) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c) Gokana") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Gokana4.gph, replace

margins, predict(outcome(3)) at(violence=(0(1)3) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c) Gokana") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Gokana5.gph, replace

margins, predict(outcome(3)) at(assets=(0(1)12) female=(0) employed=(0)) atmeans 
marginsplot, recast(line) recastci(rarea) scheme(plotplain) allxlabels level(90) title("               (c) Gokana") ytitle("Pr(Anti-state violence='very right')") play(marginsplot)
graph save Gokana6.gph, replace

graph combine Gokana1.gph Gokana3.gph Gokana5.gph Gokana2.gph Gokana4.gph Gokana6.gph, ycommon r(3) c(2) colfirst iscale(0.5) ///
 title(" ", size(small)) scheme(plotplain)
graph export Gokana_combined_probabilities.png, replace width(4000)

********************************************************************************************************************
* PREDICTED PROBABILITIES / SUBSTANTIVE EFFECTS BY LOCATION
********************************************************************************************************************

* Figure A2: Predicted Probabilities for Oil Revenues per Location
graph combine Ogba1.gph Okrika1.gph Gokana1.gph, ycommon r(3) c(1) colfirst iscale(0.5) ///
 subtitle(" ", size(small)) scheme(plotplain)
graph export oilrevenues_combined_probabilities.png, replace width(4000)

* Figure A3: Predicted Probabilities for Livelihood Destruction per Location
graph combine Ogba3.gph Okrika3.gph Gokana3.gph, ycommon r(3) c(1) colfirst iscale(0.5) ///
 subtitle(" ", size(small)) scheme(plotplain)
graph export livelihood_combined_probabilities.png, replace width(4000)

* Figure A5: Predicted Probabilities for Violence per Location
graph combine Ogba5.gph Okrika5.gph Gokana5.gph, ycommon r(3) c(1) colfirst iscale(0.5) ///
 subtitle(" ", size(small)) scheme(plotplain)
graph export violence_combined_probabilities.png, replace width(4000)

********************************************************************************************************************
* Figure A5: Variable “Ethnic Discrimination” by Ethnic Group
********************************************************************************************************************
graph bar if ethnicity==1, over(ethnic_discrimination) missing blabel(total, format(%3,1f)) scheme(plotplain) scale(.8) ///
  title("(a) Ogoni")  
graph save ogoni_disc.gph, replace

graph bar if ethnicity==2, over(ethnic_discrimination) missing blabel(total, format(%3,1f)) scheme(plotplain) scale(.8) ///
  title("(b) Ijaw")  
graph save ijaw_disc.gph, replace

graph bar if ethnicity==3, over(ethnic_discrimination) missing blabel(total, format(%3,1f)) scheme(plotplain) scale(.8) ///
  title("(c) Igbo")  
graph save igbo_disc.gph, replace

graph combine ogoni_disc.gph ijaw_disc.gph igbo_disc.gph, ycommon r(3) c(1) colfirst iscale(.7) ///
 subtitle("", size(small)) scheme(plotplain)
graph export combined_discrimination.png, replace width(5000)

********************************************************************************************************************
* END OF FILE
********************************************************************************************************************
