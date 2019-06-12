*********************************************************************

*Replication code for "Priorities for Preventive Action: Explaining Americans' Divergent Reactions to 100 Public Risks"
*Author: Jeffrey A. Friedman (jfriedm@gmail.com)
*Date: September 6, 2018

*********************************************************************

*Set the directory where you have placed the replication files:
cd xx

*The Readme file contains instructions for running this code. Please note that the code uses two Stata packages, <coefplot> and <survwgt>, that do not always come with Stata defaults.
*The remainder of this log file replicates all data and analysis found in the paper and supplement. 
*The figures will be saved in your directory; the analysis will be captured in a log file called "Results.log."
*The bootstrap analysis can take a long time to run; see below for instructions about excluding this from the replication commands.

*********************************************************************
*[1] Create data files
*********************************************************************

use Risk_Data_Base.dta, clear
do Risk_Code_Respondents.do
aorder
save Risk_Data_Respondents.dta
do Risk_Code_Rendering.do
aorder
save Risk_Data_Rendered.dta
do Risk_Code_Indices.do
aorder
save Risk_Data_Indices.dta, replace

use Risk_Data_Rendered.dta, clear
keep if module==1
do Risk_Code_Indices.do
aorder
save Risk_Data_Indices_Module1.dta, replace

use Risk_Data_Rendered.dta, clear
do Risk_Code_Mortality_Indivs.do
keep responseid pctcorr republican democrat female white college osint module
aorder
save Risk_Data_Mortality_Indivs.dta, replace

use Risk_Data_Rendered.dta, clear
do Risk_Code_Mortality_Risks.do
keep risk pctcorr violence environment health natural existential logdeath logdeath2 lexis loglexis loglexis2
aorder
save Risk_Data_Mortality_Risks.dta, replace

use Risk_Data_Rendered.dta, clear
do Risk_Code_Mortality_Pairs.do
keep risk versus rdeaths vdeaths correct logpropdeathdiff
aorder
save Risk_Data_Mortality_Pairs.dta, replace

use Risk_Data_Rendered.dta, clear
keep if republican==1
do Risk_Code_Indices.do
cumul harm, gen(harmpct)
cumul fairness, gen(fairnesspct)
cumul responsibility, gen(responsibilitypct)
cumul priorityt, gen(prioritytpct)
gen rep_harmrank=100*(1-harmpct)+1
gen rep_fairnessrank=100*(1-fairnesspct)+1
gen rep_responsibilityrank=100*(1-responsibilitypct)+1
gen rep_prioritytrank=100*(1-prioritytpct)+1
replace rep_harmrank=round(rep_harmrank)
replace rep_fairnessrank=round(rep_fairnessrank)
replace rep_responsibilityrank=round(rep_responsibilityrank)
replace rep_prioritytrank=round(rep_prioritytrank)
keep risk rep_harmrank rep_fairnessrank rep_responsibilityrank rep_prioritytrank
save Risk_Data_Indices_Republicans.dta, replace

use Risk_Data_Rendered.dta, clear
keep if democrat==1
do Risk_Code_Indices.do
cumul harm, gen(harmpct)
cumul fairness, gen(fairnesspct)
cumul responsibility, gen(responsibilitypct)
cumul priorityt, gen(prioritytpct)
gen dem_harmrank=100*(1-harmpct)+1
gen dem_fairnessrank=100*(1-fairnesspct)+1
gen dem_responsibilityrank=100*(1-responsibilitypct)+1
gen dem_prioritytrank=100*(1-prioritytpct)+1
keep risk dem_harmrank dem_fairnessrank dem_responsibilityrank dem_prioritytrank
replace dem_harmrank=round(dem_harmrank)
replace dem_fairnessrank=round(dem_fairnessrank)
replace dem_responsibilityrank=round(dem_responsibilityrank)
replace dem_prioritytrank=round(dem_prioritytrank)
merge using Risk_Data_Indices_Republicans.dta
aorder
drop _merge
save Risk_Data_Indices_ByParty.dta, replace
erase Risk_Data_Indices_Republicans.dta

use Risk_Data_Rendered.dta, clear
keep if white==1
do Risk_Code_Indices.do
cumul harm, gen(harmpct)
cumul fairness, gen(fairnesspct)
cumul responsibility, gen(responsibilitypct)
cumul priorityt, gen(prioritytpct)
gen w_harmrank=100*(1-harmpct)+1
gen w_fairnessrank=100*(1-fairnesspct)+1
gen w_responsibilityrank=100*(1-responsibilitypct)+1
gen w_prioritytrank=100*(1-prioritytpct)+1
keep risk w_harmrank w_fairnessrank w_responsibilityrank w_prioritytrank
replace w_harmrank=round(w_harmrank)
replace w_fairnessrank=round(w_fairnessrank)
replace w_responsibilityrank=round(w_responsibilityrank)
replace w_prioritytrank=round(w_prioritytrank)
save Risk_Data_Indices_Whites.dta, replace

use Risk_Data_Rendered.dta, clear
keep if white==0
do Risk_Code_Indices.do
cumul harm, gen(harmpct)
cumul fairness, gen(fairnesspct)
cumul responsibility, gen(responsibilitypct)
cumul priorityt, gen(prioritytpct)
gen nw_harmrank=100*(1-harmpct)+1
gen nw_fairnessrank=100*(1-fairnesspct)+1
gen nw_responsibilityrank=100*(1-responsibilitypct)+1
gen nw_prioritytrank=100*(1-prioritytpct)+1
keep risk nw_harmrank nw_fairnessrank nw_responsibilityrank nw_prioritytrank
replace nw_harmrank=round(nw_harmrank)
replace nw_fairnessrank=round(nw_fairnessrank)
replace nw_responsibilityrank=round(nw_responsibilityrank)
replace nw_prioritytrank=round(nw_prioritytrank)
append using Risk_Data_Indices_Whites.dta
aorder
save Risk_Data_Indices_ByRace.dta, replace
erase Risk_Data_Indices_Whites.dta

use Explanation_Data_Base.dta, clear
do Explanation_Code_Statements.do
keep rakewt rid fairness comparison female black democrat republican college primary_abnormality primary_control primary_foreign primary_inequity primary_irreversibility primary_malign primary_other primary_publicgoods primary_rights primary_scope primary_suffering multiple_abnormality multiple_control multiple_foreign multiple_inequity multiple_irreversibility multiple_malign multiple_other multiple_publicgoods multiple_rights multiple_scope multiple_suffering
aorder
save Explanation_Data_Statements.dta
use Explanation_Data_Base.dta, clear
do Explanation_Code_Writeins.do
aorder
save Explanation_Data_Writeins.dta, replace

use Risk_Data_Rendered.dta, clear
do Risk_Code_Bootstrap_Prep.do
aorder
save Risk_Data_Bootstrap_Base.dta, replace


//Bootstrap
*This process can take a long time (about 3.5 minutes per cycle in Stata 15/SE). The following code runs 1500 bootstrap cycles, batched in increments of 100 reps.
*The results of the bootstrap process presented in the paper are included with replication files, so that readers can replicate the relevant analyses even if they don't have time to run the bootstrap themselves. 
*If you run the bootstrap code yourself, the .do file will overwrite the existing "Bootstrap Results" contained with the replication data.
use Risk_Data_Bootstrap_Base.dta, clear
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results1.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results2.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results3.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results4.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results5.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results6.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results7.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results8.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results9.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results10.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results11.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results12.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results13.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results14.dta
do Risk_Code_Bootstrap.do
save Risk_Data_Bootstrap_Results15.dta
append using Risk_Data_Bootstrap_Results1.dta
append using Risk_Data_Bootstrap_Results2.dta
append using Risk_Data_Bootstrap_Results3.dta
append using Risk_Data_Bootstrap_Results4.dta
append using Risk_Data_Bootstrap_Results5.dta
append using Risk_Data_Bootstrap_Results6.dta
append using Risk_Data_Bootstrap_Results7.dta
append using Risk_Data_Bootstrap_Results8.dta
append using Risk_Data_Bootstrap_Results9.dta
append using Risk_Data_Bootstrap_Results10.dta
append using Risk_Data_Bootstrap_Results11.dta
append using Risk_Data_Bootstrap_Results12.dta
append using Risk_Data_Bootstrap_Results13.dta
append using Risk_Data_Bootstrap_Results14.dta
do Risk_Code_Bootstrap_Extract.do
save Risk_Data_Bootstrap_Results.dta, replace
erase Risk_Data_Bootstrap_Results1.dta
erase Risk_Data_Bootstrap_Results2.dta
erase Risk_Data_Bootstrap_Results3.dta
erase Risk_Data_Bootstrap_Results4.dta
erase Risk_Data_Bootstrap_Results5.dta
erase Risk_Data_Bootstrap_Results6.dta
erase Risk_Data_Bootstrap_Results7.dta
erase Risk_Data_Bootstrap_Results8.dta
erase Risk_Data_Bootstrap_Results9.dta
erase Risk_Data_Bootstrap_Results10.dta
erase Risk_Data_Bootstrap_Results11.dta
erase Risk_Data_Bootstrap_Results12.dta
erase Risk_Data_Bootstrap_Results13.dta
erase Risk_Data_Bootstrap_Results14.dta

log using Results.log, text replace
*********************************************************************
*[2] Analyses
*********************************************************************

//Correlation between Priority and Priority-Margin
use Risk_Data_Indices.dta, clear
correl priorityt prioritym


//FIGURE 2: PERCEIVED VS. ACTUAL MORTALITY
*Labels have to be added manually given their dense packing; however, the following command will place labels on the scatterplot in a haphazard manner: twoway fpfitci mortality logdeath || scatter mortality logdeath, msize(tiny) mlabel(risk) mlabsize(small) mcolor(black) xtitle(Actual 2015 mortality) ytitle(Perceived mortality (survey index)) leg(off)
use Risk_Data_Indices.dta, clear
twoway fpfitci mortality logdeath || scatter mortality logdeath, msize(tiny) mcolor(black) xtitle(Actual mortality) ytitle(Perceived mortality (survey index)) xlabel(0 "0" 2 "100" 4 "10,000" 6 "1 million") leg(off) 
graph save Figure_2.gph, replace

//correlational analysis of mortality data
use Risk_Data_Indices.dta, clear
*corr. between perceptions of mortality and actual (logged) mortality
correl mortality logdeath
*corr. between perceptions of mortality and answered respondents would have given under perfect information
correl mortality deathpct 

//FIGURE 3: HARM VS. MORTALITY
*Again you have to add the labels manually. To see the labels, add "mlabel(risk) mlabsize(tiny)" to the previous code.
use Risk_Data_Indices.dta, clear
twoway fpfitci harm mortality || scatter harm mortality, msize(vsmall) mcolor(black) xtitle(Perceived {it:Mortality}, size(medsmall)) ytitle(Perceived {it:Harm}, size(medsmall)) title("") leg(off)
graph save Figure_3.gph, replace
*corr. between Harm and Mortality
correl mortality harm

//FIGURE 4: RESPONSE ACCURACY
*a. individual-level
use Risk_Data_Mortality_Indivs.dta, clear
*descriptive statistics
sum pctcorrect
gen underhalf=cond(pctcorrect<.5,1,0)
sum underhalf
*Figure 4a
reg pctcorrect republican democrat osint college female white module, robust
est tab, b se stats(r2_a)
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) title("(a) by individual", size(medlarge)) xtitle("OLS coeffs. with 95% intervals" "(N=1,131 respondents)") ylabel(1 "Republican" 2 "Democrat" 3 "OSI" 4 "College" 5 "Female" 6 "White" 7 "Module", noticks) drop(_cons) grid(glcolor(white))
graph save Figure_4a.gph, replace
*Impact of OSI
sum osint //multiply this standard deviation by the regression coefficint in Figure 4a; then divide by .72.


*b. risk-level
use Risk_Data_Mortality_Risks.dta, clear
*descriptive statistics
sum pctcorrect
*Figure 4b
reg pctcorrect violence environment health natural existential logdeath logdeath2, robust
est tab, b se stats(r2_a)
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) title("(b) by risk", size(medlarge)) xtitle("OLS coeffs. with 95% intervals" "(N=100 risks)") ylabel(1 `""Violent" "Risks""' 2 `""Environmental""Risks""' 3 `""Health""Risks""' 4 `""Natural" "Disasters""' 5 `""Existential""Risks""' 6 "Log Mortality" 7 "Log Mortality{sup:2}", noticks) drop(_cons) grid(glcolor(white))
graph save Figure_4b.gph, replace

//FIGURE 5: VARIATION IN RISK PRIORITIES
use Risk_Data_Indices.dta, clear
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential, robust 
est tab, b se stats(r2_a)
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("OLS coefficients with 95% intervals""(N=100 risks)") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("") grid(glcolor(white))
graph save Figure_5.gph, replace

//FIGURE 6: COMPARISON OF HARM VS. HARM/FAIRNESS/RESPONSIBILITY
*a. Priority vs. Harm
use Risk_Data_Indices.dta, clear
reg priorityt harm, robust
est tab, b se stats(r2_a)
twoway fpfitci priorityt harm || scatter priorityt harm, title("(a)", size(medsmall)) msize(tiny) xsize(4) ysize(4) leg(off) xtitle("Perceptions of {it:Harm}"" ") ytitle(Priority for Public Spending) mcolor(black) plotregion(lwidth(none))
*In order to check the terrorism label, add the following to this command: "mlabel(risk) mlabsize(tiny)"
graph save Figure_6a.gph, replace

*b Priority vs. Harm/Fairness/Responsibility
use Risk_Data_Indices.dta, clear
reg priorityt harm fairness responsibility, robust
est tab, b se stats(r2_a)
predict prioritypredict
twoway fpfitci priorityt prioritypredict || scatter priorityt prioritypredict, title("(b)", size(medsmall)) msize(tiny) xsize(4) ysize(4) leg(off) xtitle("Predicted {it:Priority}" "based on {it:Harm}, {it:Fairness}, & {it:Responsibility}") ytitle(Priority for Public Spending) mcolor(black) plotregion(lwidth(none))
*In order to check the terrorism label, add the following to this command: "mlabel(risk) mlabsize(tiny)"
graph save Figure_6b.gph, replace

//Rankings of climate change and lethal force used by police
use Risk_Data_Indices_ByParty.dta, clear
sum dem_responsibility if risk=="Climate change"
sum rep_responsibility if risk=="Climate change"
sum dem_priorityt if risk=="Climate change"
sum rep_priorityt if risk=="Climate change"
use Risk_Data_Indices_ByRace.dta
sum w_fairness if risk=="Lethal force used by police"
sum nw_fairness if risk=="Lethal force used by police"
sum w_priorityt if risk=="Lethal force used by police"
sum nw_priorityt if risk=="Lethal force used by police"

//Average rankings gap between political parties
use Risk_Data_Indices_ByParty.dta, clear
gen prioritytgap=abs(rep_priorityt-dem_priorityt)
gen harmgap=abs(rep_harm-dem_harm)
gen fairnessgap=abs(rep_fairness-dem_fairness)
gen responsibilitygap=abs(rep_responsibility-dem_responsibility)
sum harmgap fairnessgap responsibilitygap prioritytgap

//If you want to analyze polarization in the data more generally, it is much easier to run the following commands to generate the index(i,j,k) values. 
*This will allow you to run simple t-tests from the data, as opposed to reprocessing the data for all comparisons in the manner above.
use Risk_Data_Bootstrap_Base.dta, clear
do Risk_Code_IndexIJK.do
save Risk_Data_IndexIJK.dta, replace


//FIGURE 7. BOOTSTRAP RESULTS
*a. No interactions
use Risk_Data_Bootstrap_Results.dta, clear
twoway (dot mean index if index>0 & index<13, ysize(5) xsize(2.5) yscale(range(.67 12.33)) msize(small) ylabel(1 "{it:Harm}{sub:i,j}" 2 "{it:Fairness}{sub:i,j}" 3 "{it:Responsibility}{sub:i,j}" 4 "{it:Long-term growth}{sub:i,j}" 5 "{it:Disaster potential}{sub:i,j}" 6 "{it:Worry}{sub:i,j}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Constant", noticks angle(0)) horizontal title("(a) no interactions", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>0 & index<13, horizontal msize(0) lcolor(black) ysc(reverse))
graph save Figure_7a.gph, replace

*b. Party interactions, plotted in two panels
use Risk_Data_Bootstrap_Results.dta, clear
twoway (dot mean index if index>60 & index<73, ysize(5) xsize(2.5)  yscale(range(60.67 72.33)) msize(small) ylabel(61 "{it:Harm}{sub:i,j}" 62 "{it:Fairness}{sub:i,j}" 63 "{it:Responsibility}{sub:i,j}" 64 "{it:Long-term growth}{sub:i,j}" 65 "{it:Disaster potential}{sub:i,j}" 66 "{it:Worry}{sub:i,j}" 67 "Violent Risks" 68 "Environmental Risks" 69 "Health Risks" 70 "Natural Disasters" 71 "Existential Risks" 72 "Constant", noticks angle(0)) horizontal title("(b) with party interactions", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>60 & index<73, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_7b1.gph, replace
twoway (dot mean index if index>72 & index<85,  ysize(5) xsize(2.5) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2")  yscale(range(72.67 84.33)) msize(small) ylabel(73 "Rep*{it:Harm}{sub:i,j}" 74 "Dem*{it:Harm}{sub:i,j}" 75 "Rep*{it:Fairness}{sub:i,j}" 76 "Dem*{it:Fairness}{sub:i,j}" 77 "Rep*{it:Responsibility}{sub:i,j}" 78 "Dem*{it:Responsibility}{sub:i,j}" 79 "Rep*{it:Long-term growth}{sub:i,j}" 80 "Dem*{it:Long-term growth}{sub:i,j}" 81 "Rep*{it:Disaster potential}{sub:i,j}" 82 "Dem*{it:Disaster potential}{sub:i,j}" 83 "Rep*{it:Worry}{sub:i,j}" 84 "Dem*{it:Worry}{sub:i,j}", noticks angle(0)) horizontal title("(b) with party interactions", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>72 & index<85, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_7b2.gph, replace

*p-value on Rep*Fairness
use Risk_Data_Bootstrap_Results.dta, clear
sum p if index==75


*********************************************************************
*[3] Supplementary analyses
*********************************************************************

//TABLE S1. RISK INDICES
use Risk_Data_Indices.dta, clear
sort risk
*Priority
cumul priorityt, gen(prioritytrank)
replace prioritytrank=100-prioritytrank*100+1
list risk prioritytrank priorityt, table
*Priority-Margin
cumul prioritym, gen(prioritymrank)
replace prioritymrank=100-prioritymrank*100+1
list risk prioritymrank prioritym, table
*Harm
cumul harm, gen(harmrank)
replace harmrank=100-harmrank*100+1
list risk harmrank harm, table
*Mortality
cumul mortality, gen(mortalityrank)
replace mortalityrank=100-mortalityrank*100+1
list risk mortalityrank mortality, table
*Fairness
cumul fairness, gen(fairnessrank)
replace fairnessrank=100-fairnessrank*100+1
list risk fairnessrank fairness, table
*Responsibility
cumul responsibility, gen(responsibilityrank)
replace responsibilityrank=100-responsibilityrank*100+1
list risk responsibilityrank responsibility, table
*Disaster potential
cumul disaster, gen(disasterrank)
replace disasterrank=100-disasterrank*100+1
list risk disasterrank disaster, table
*Long-term growth
cumul longterm, gen(longtermrank)
replace longtermrank=100-longtermrank*100+1
list risk longtermrank longterm, table
*Worry
cumul worry, gen(worryrank)
replace worryrank=100-worryrank*100+1
list risk worryrank worry, table

//TABLE S2. RISK RANKINGS
*Priority
sort prioritytrank
list risk priorityt, table
*Priority-margin
sort prioritymrank
list risk prioritym, table
*Harm
sort harmrank
list risk harm, table
*Perceived Mortality
sort mortalityrank
list risk mortality, table
*Actual mortality
gen mortalityinverse=1-deathpct
sort mortalityinverse
list risk mortalityinverse, table
*Fairness
sort fairnessrank
list risk fairness, table
*Responsibility
sort responsibilityrank
list risk responsibility, table
*Disaster potential
sort disasterrank
list risk disaster, table
*Long-term growh
sort longtermrank
list risk longterm, table
*Worry
sort worryrank
list risk worry, table

//Table S3: DEMOGRAPHICS
use Risk_Data_Respondents.dta, clear
tab gender
tab party
tab race
tab age
tab education
tab income
tab division

*Median survey completion time
use Risk_Data_Respondents.dta, clear
sum duration, d

//TABLES S4-S7: NUMERIC REPLICATIONS OF AIRPLANE PLOTS
*For Tables S4-S6, use the code shown in the "Analyses" section above. Note that each table number (e.g., "Table S4a") lines up with the relevant Figure (e.g., "Figure 4a") in the paper.
*Table S7a:
use Risk_Data_Bootstrap_Results.dta, clear
sort index
list variable mean sd lobound hibound p if index<13, table
*Table S7b
use Risk_Data_Bootstrap_Results.dta, clear
sort index
list variable mean sd lobound hibound p if index>60 & index<85, table


//FIGURE S3: MORTALITY AND RESPONSE ACCURACY
*a. by risk
use Risk_Data_Mortality_Risks.dta, clear
twoway fpfitci pctcorrect logdeath || scatter pctcorrect logdeath, msize(small) mcolor(black) msymbol(o) xsize(3.5) ysize(3.5) title("(a) by risk", size(medium)) xtitle("Actual mortality") ytitle("Proportion of correct answers""in comparing mortality") xlabel(0 "0" 2 "100" 4 "10,000" 6 "1 million") leg(off)
graph save Figure_S3a_accuracy.gph, replace

*b. by pair
use Risk_Data_Mortality_Pairs.dta, clear
twoway fpfitci correct logpropdeathdiff || scatter correct logpropdeathdiff, xsize(3.5) ysize(3.5) jitter(10) msize(vtiny) mcolor(gs4) msymbol(o) title("(b) by pair", size(medium)) xtitle("Actual mortality ratio") ytitle("Proportion of correct answers""in comparing mortality") xlabel(0 "1:1" 2 "100:1" 4 "10,000:1" 6 "1 million:1") leg(off)
graph save Figure_S3b_accuracy.gph, replace


//FIGURE S4: MEDIA MENTIONS AND RESPONSE ACCURACY
use Risk_Data_Mortality_Risks.dta, clear
reg pctcorrect violence environment health natural existential logdeath logdeath2 loglexis loglexis2, robust
est tab, b se stats(r2_a)
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("OLS coeffs. with 95% intervals" "(N=100 risks)") ylabel(1 `""Violent" "Risks""' 2 `""Environmental""Risks""' 3 `""Health""Risks""' 4 `""Natural" "Disasters""' 5 `""Existential""Risks""' 6 "Log Mortality" 7 "Log Mortality{sup:2}" 8 `""Log Media" "Mentions""' 9 `""Log Media" "Mentions{sup:2}""', noticks) drop(_cons) grid(glcolor(white))
graph save Figure_S4_media.gph, replace
*Point estimate reported for solar flares
sum pctcorrect if risk=="Solar flares"

//FIGURE S5: MEDIA MENTIONS AND RESPONSE ACCURACY
use Risk_Data_Mortality_Risks.dta, clear
twoway fpfitci pctcorrect loglexis || scatter pctcorrect loglexis, msize(small) mcolor(black) msymbol(o) xsize(4.5) ysize(3.5) title("") xtitle("Media mentions (Lexis-Nexis)") ytitle("Proportion of correct answers""in comparing mortality") xlabel(2 "100" 3 "1,000" 4 "10,000") leg(off)
graph save Figure_S5_media.gph, replace
*Specific data points mentioned in the text
sum pctcorrect if risk=="Terrorism"
sum pctcorrect if risk=="Homicides"
sum pctcorrect if risk=="Alcohol use"
sum pctcorrect if risk=="Cancer"
*Top decile of risks on media mentions
cumul loglexis, gen(lexispct)
sum pctcorrect if lexispct>.9
*Correlation between media mentions and mortality
correl loglexis logdeath

//FIGURE S6: ADDITIONAL SPECIFICATIONS OF RISK-LEVEL PRIORITY ANALYSIS
*a. Standardized indices
use Risk_Data_Indices.dta, clear
quietly egen n_priorityt=std(priorityt)
quietly egen n_harm=std(harm)
quietly egen n_fairness=std(fairness)
quietly egen n_responsibility=std(responsibility)
quietly egen n_longterm=std(longterm)
quietly egen n_disaster=std(disaster)
quietly egen n_worry=std(worry)
reg n_priorityt n_harm n_fairness n_responsibility n_longterm n_disaster n_worry violence environment health natural existential loglexis, robust 
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.9 "-.9" -.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Media Mentions (log)" 13 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(a) Standardized indices", size(medium)) grid(glcolor(white))
graph save Figure_S6a.gph, replace

*b. Indices as percentiles
use Risk_Data_Indices.dta, clear
quietly cumul priorityt, gen(pct_priorityt)
quietly cumul harm, gen(pct_harm)
quietly cumul fairness, gen(pct_fairness)
quietly cumul responsibility, gen(pct_responsibility)
quietly cumul longterm, gen(pct_longterm)
quietly cumul disaster, gen(pct_disaster)
quietly cumul worry, gen(pct_worry)
reg pct_priorityt pct_harm pct_fairness pct_responsibility pct_longterm pct_disaster pct_worry violence environment health natural existential loglexis, robust 
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.9 "-.9" -.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Media Mentions (log)" 13 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(b) Indices as percentiles", size(medium)) grid(glcolor(white))
graph save Figure_S6b.gph, replace

*c. Replacing Harm with Mortality
use Risk_Data_Indices.dta, clear
reg priorityt mortality fairness responsibility longterm disaster worry violence environment health natural existential loglexis, robust 
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.9 "-.9" -.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Mortality}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Media Mentions (log)" 13 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(c) Replacing {it:Harm} w/{it:Mortality}", size(medium)) grid(glcolor(white))
graph save Figure_S6c.gph, replace

*d. Module 1 data only
use Risk_Data_Indices_Module1.dta, clear
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential loglexis, robust 
coefplot, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.9 "-.9" -.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Media Mentions (log)" 13 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(d) Module 1 data only", size(medium)) grid(glcolor(white))
graph save Figure_S6d.gph, replace


//FIGURE S7. REPLICATING FIGURE 5 BASED ON SUBSETS OF RESPONDENTS
*a. By party
use Risk_Data_Rendered.dta, clear
keep if republican==1
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential, robust 
estimates store results_republicans

use Risk_Data_Rendered.dta, clear
keep if democrat==1
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential, robust 
estimates store results_democrats

use Risk_Data_Rendered.dta, clear
keep if independent==1
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential, robust 
estimates store results_independents

coefplot results_republicans results_democrats results_independents, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Media Mentions (log)" 12 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(a) by party", size(medium)) grid(glcolor(white))
graph save Figure_S7a.gph, replace

*b. By gender and race
use Risk_Data_Rendered.dta, clear
keep if gender=="Female"
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_female

use Risk_Data_Rendered.dta, clear
keep if gender=="Male"
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_male

use Risk_Data_Rendered.dta, clear
keep if white==1
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_white

use Risk_Data_Rendered.dta, clear
keep if white==0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_nonwhite

coefplot results_female results_male results_white results_nonwhite, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(b) by gender and race", size(medium)) grid(glcolor(white))
graph save Figure_S7b.gph, replace

*c. By education
use Risk_Data_Rendered.dta, clear
keep if college==1
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_college

use Risk_Data_Rendered.dta, clear
keep if college==0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_nocollege

use Risk_Data_Rendered.dta, clear
egen n_osint=std(osint)
keep if n_osint>0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_hiosint

use Risk_Data_Rendered.dta, clear
egen n_osint=std(osint)
keep if n_osint<0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_loosint

coefplot results_college results_nocollege results_hiosint results_loosint, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(c) by education", size(medium)) grid(glcolor(white))
graph save Figure_S7c.gph, replace

*d. By ideology
use Risk_Data_Rendered.dta, clear
egen n_grid=std(grid)
keep if n_grid>0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_higrid

use Risk_Data_Rendered.dta, clear
egen n_grid=std(grid)
keep if n_grid<0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_logrid

use Risk_Data_Rendered.dta, clear
egen n_group=std(group)
keep if n_group>0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_higroup

use Risk_Data_Rendered.dta, clear
egen n_group=std(group)
keep if n_group<0
quietly do Risk_Code_Indices.do
reg priorityt harm fairness responsibility longterm disaster worry violence environment health natural existential , robust 
estimates store results_logroup

coefplot results_higrid results_logrid results_higroup results_logroup, horizontal xline(0) yscale(reverse) recast(scatter) xtitle("") xlabel(-.6 "-.6" -.3 "-.3" 0 "0" .3 ".3" .6 ".6") ylabel(1 "{it:Harm}" 2 "{it:Fairness}" 3 "{it:Responsibility}" 4 "{it:Long-term growth}" 5 "{it:Disaster potential}" 6 "{it:Worry}" 7 "Violent Risks" 8 "Environmental Risks" 9 "Health Risks" 10 "Natural Disasters" 11 "Existential Risks" 12 "Constant", noticks) xline(0) xscale(range(0(.2).6)) title("(d) by ideology", size(medium)) grid(glcolor(white))
graph save Figure_S7d.gph, replace


//FIGURE S8: ADDITIONAL ANALYSES OF BOOTSTRAP RESULTS
*a. By gender and race
use Risk_Data_Bootstrap_Results.dta, clear
twoway (dot mean index if index>108 & index<133,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2")  yscale(range(108.67 132.33)) ylabel(109 "{it:Harm}{sub:i,j}" 110 "{it:Fairness}{sub:i,j}" 111 "{it:Responsibility}{sub:i,j}" 112 "{it:Long-term growth}{sub:i,j}" 113 "{it:Disaster potential}{sub:i,j}" 114 "{it:Worry}{sub:i,j}" 115 "Violent Risks" 116 "Environmental Risks" 117 "Health Risks" 118 "Natural Disasters" 119 "Existential Risks" 120 "Constant" 121 "Female*{it:Harm}{sub:i,j}" 122 "White*{it:Harm}{sub:i,j}" 123 "Female*{it:Fairness}{sub:i,j}" 124 "White*{it:Fairness}{sub:i,j}" 125 "Female*{it:Responsibility}{sub:i,j}" 126 "White*{it:Responsibility}{sub:i,j}" 127 "Female*{it:Long-term growth}{sub:i,j}" 128 "White*{it:Long-term growth}{sub:i,j}" 129 "Female*{it:Disaster potential}{sub:i,j}" 130 "White*{it:Disaster potential}{sub:i,j}" 131 "Female*{it:Worry}{sub:i,j}" 132 "White*{it:Worry}{sub:i,j}", noticks angle(0)) horizontal title("(a) with interactions" "for gender and race", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>108 & index<133, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8a.gph, replace

*b. By education
use Risk_Data_Bootstrap_Results.dta, clear
twoway (dot mean index if index>84 & index<109,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2")  yscale(range(84.67 108.33)) ylabel(85 "{it:Harm}{sub:i,j}" 86 "{it:Fairness}{sub:i,j}" 87 "{it:Responsibility}{sub:i,j}" 88 "{it:Long-term growth}{sub:i,j}" 89 "{it:Disaster potential}{sub:i,j}" 90 "{it:Worry}{sub:i,j}" 91 "Violent Risks" 92 "Environmental Risks" 93 "Health Risks" 94 "Natural Disasters" 95 "Existential Risks" 96 "Constant" 97 "College*{it:Harm}{sub:i,j}" 98 "HiOSI*{it:Harm}{sub:i,j}" 99 "College*{it:Fairness}{sub:i,j}" 100 "HiOSI*{it:Fairness}{sub:i,j}" 101 "College*{it:Responsibility}{sub:i,j}" 102 "HiOSI*{it:Responsibility}{sub:i,j}" 103 "College*{it:Long-term growth}{sub:i,j}" 104 "HiOSI*{it:Long-term growth}{sub:i,j}" 105 "College*{it:Disaster potential}{sub:i,j}" 106 "HiOSI*{it:Disaster potential}{sub:i,j}" 107 "College*{it:Worry}{sub:i,j}" 108 "HiOSI*{it:Worry}{sub:i,j}", noticks angle(0)) horizontal title("(b) with interactions" "for education and OSI", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>84 & index<109, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8b.gph, replace

*c. By ideology
use Risk_Data_Bootstrap_Results.dta, clear
twoway (dot mean index if index>132 & index<157,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2") yscale(range(132.67 156.33)) ylabel(133 "{it:Harm}{sub:i,j}" 134 "{it:Fairness}{sub:i,j}" 135 "{it:Responsibility}{sub:i,j}" 136 "{it:Long-term growth}{sub:i,j}" 137 "{it:Disaster potential}{sub:i,j}" 138 "{it:Worry}{sub:i,j}" 139 "Violent Risks" 140 "Environmental Risks" 141 "Health Risks" 142 "Natural Disasters" 143 "Existential Risks" 144 "Constant" 145 "HiGrid*{it:Harm}{sub:i,j}" 146 "HiGroup*{it:Harm}{sub:i,j}" 147 "HiGrid*{it:Fairness}{sub:i,j}" 148 "HiGroup*{it:Fairness}{sub:i,j}" 149 "HiGrid*{it:Responsibility}{sub:i,j}" 150 "HiGroup*{it:Responsibility}{sub:i,j}" 151 "HiGrid*{it:Long-term growth}{sub:i,j}" 152 "HiGroup*{it:Long-term growth}{sub:i,j}" 153 "HiGrid*{it:Disaster potential}{sub:i,j}" 154 "HiGroup*{it:Disaster potential}{sub:i,j}" 155 "HiGrid*{it:Worry}{sub:i,j}" 156 "HiGroup*{it:Worry}{sub:i,j}", noticks angle(0)) horizontal title("(c) with interactions" "for grid/group ideology", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>132 & index<157, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8c.gph, replace

*d. All interactions 
use Risk_Data_Bootstrap_Results.dta, clear
twoway (dot mean index if index>12 & index<25,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2") yscale(range(12.67 24.33)) ylabel(13 "{it:Harm}{sub:i,j}" 14 "{it:Fairness}{sub:i,j}" 15 "{it:Responsibility}{sub:i,j}" 16 "{it:Long-term growth}{sub:i,j}" 17 "{it:Disaster potential}{sub:i,j}" 18 "{it:Worry}{sub:i,j}" 19 "Violent Risks" 20 "Environmental Risks" 21 "Health Risks" 22 "Natural Disasters" 23 "Existential Risks" 24 "Constant", noticks angle(0)) horizontal title("(d) all interactions included", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>12 & index<25, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8d1.gph, replace

twoway (dot mean index if index>24 & index<37,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2") yscale(range(24.67 36.33)) ylabel(25 "Rep*{it:Harm}{sub:i,j}" 26 "Dem*{it:Harm}{sub:i,j}" 27 "College*{it:Harm}{sub:i,j}" 28 "HiOSI*{it:Harm}{sub:i,j}" 29 "Female*{it:Harm}{sub:i,j}" 30 "White*{it:Harm}{sub:i,j}" 31 "Rep*{it:Fairness}{sub:i,j}" 32 "Dem*{it:Fairness}{sub:i,j}" 33 "College*{it:Fairness}{sub:i,j}" 34 "HiOSI*{it:Fairness}{sub:i,j}" 35 "Female*{it:Fairness}{sub:i,j}" 36 "White*{it:Fairness}{sub:i,j}", noticks angle(0)) horizontal title("(d) all interactions included", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>24 & index<37, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8d2.gph, replace

twoway (dot mean index if index>36 & index<49,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2") yscale(range(36.67 48.33)) ylabel(37 "Rep*{it:Responsibility}{sub:i,j}" 38 "Dem*{it:Responsibility}{sub:i,j}" 39 "College*{it:Responsibility}{sub:i,j}" 40 "HiOSI*{it:Responsibility}{sub:i,j}" 41 "Female*{it:Responsibility}{sub:i,j}" 42 "White*{it:Responsibility}{sub:i,j}" 43 `""Rep*{it:Long-term}" "{it:growth}{sub:i,j}""' 44 `""Dem*{it:Long-term}" "{it:growth}{sub:i,j}""' 45 `""College*{it:Long-term}" "{it:growth}{sub:i,j}""' 46 `""HiOSI*{it:Long-term}" "{it:growth}{sub:i,j}""' 47 `""Female*{it:Long-term}" "{it:growth}{sub:i,j}""' 48 `""White*{it:Long-term}" "{it:growth}{sub:i,j}""', noticks angle(0)) horizontal title("(d) all interactions included", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>36 & index<49, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8d3.gph, replace

twoway (dot mean index if index>48 & index<61,  ysize(7) xsize(2.75) msize(small) xscale(range(-3 2)) xlabel(-3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2") yscale(range(48.67 60.33)) ylabel(49 `""Rep*{it:Disaster}" "{it:potential}{sub:i,j}""' 50 `""Dem*{it:Disaster}" "{it:potential}{sub:i,j}""' 51 `""College*{it:Disaster}" "{it:potential}{sub:i,j}""' 52 `""HiOSI*{it:Disaster}" "{it:potential}{sub:i,j}""' 53 `""Female*{it:Disaster}" "{it:potential}{sub:i,j}""' 54 `""White*{it:Disaster}" "{it:potential}{sub:i,j}""' 55 "Rep*{it:Worry}{sub:i,j}" 56 "Dem*{it:Worry}{sub:i,j}" 57 "College*{it:Worry}{sub:i,j}" 58 "HiOSI*{it:Worry}{sub:i,j}" 59 "Female*{it:Worry}{sub:i,j}" 60 "White*{it:Worry}{sub:i,j}", noticks angle(0)) horizontal title("(d) all interactions included", size(medlarge)) leg(off) mcolor(black) dcolor(black) ndots(0) plotregion(lwidth(none)) ytitle("") xline(0, lwidth(medium)) ysc(reverse)) || (rcap hibound lobound index if index>48 & index<61, horizontal msize(0) lwidth(thin) lcolor(black) ysc(reverse))
graph save Figure_S8d4.gph, replace

//TABLE S8. CORRELATIONS AMONG INDICES
use Risk_Data_Indices.dta, clear
correl priorityt prioritym harm mortality fairness responsibility disaster longterm worry


//TABLE S9. CORRELATIONS BETWEEN INDICES AND MORTALITY/MEDIA MENTIONS
use Risk_Data_Indices.dta, clear
correl logdeath priorityt prioritym harm mortality fairness responsibility disaster longterm worry
correl loglexis priorityt prioritym harm mortality fairness responsibility disaster longterm worry


//TABLE S10. EXPLANATIONS FOR JUDGMENTS OF FAIRNESS AND RESPONSIBILITY
use Explanation_Data_Statements.dta, clear
svyset [pw=rakewt], strata(rid)

*Start with survey demographics
sum female black democrat republican college

svy: mean primary_control, over(fairness)
test [primary_control]1=[primary_control]0

svy: mean primary_scope, over(fairness)
test [primary_scope]1=[primary_scope]0

svy: mean primary_foreign, over(fairness)
test [primary_foreign]1=[primary_foreign]0

svy: mean primary_inequity, over(fairness)
test [primary_inequity]1=[primary_inequity]0

svy: mean primary_irreversibility, over(fairness)
test [primary_irreversibility]1=[primary_irreversibility]0

svy: mean primary_malign, over(fairness)
test [primary_malign]1=[primary_malign]0

svy: mean primary_abnormality, over(fairness)
test [primary_abnormality]1=[primary_abnormality]0

svy: mean primary_publicgoods, over(fairness)
test [primary_publicgoods]1=[primary_publicgoods]0

svy: mean primary_rights, over(fairness)
test [primary_rights]1=[primary_rights]0

svy: mean primary_suffering, over(fairness)
test [primary_suffering]1=[primary_suffering]0

svy: mean primary_other, over(fairness)
test [primary_other]1=[primary_other]0

svy: mean multiple_control, over(fairness)
test [multiple_control]1=[multiple_control]0

svy: mean multiple_scope, over(fairness)
test [multiple_scope]1=[multiple_scope]0

svy: mean multiple_foreign, over(fairness)
test [multiple_foreign]1=[multiple_foreign]0

svy: mean multiple_inequity, over(fairness)
test [multiple_inequity]1=[multiple_inequity]0

svy: mean multiple_irreversibility, over(fairness)
test [multiple_irreversibility]1=[multiple_irreversibility]0

svy: mean multiple_malign, over(fairness)
test [multiple_malign]1=[multiple_malign]0

svy: mean multiple_abnormality, over(fairness)
test [multiple_abnormality]1=[multiple_abnormality]0

svy: mean multiple_publicgoods, over(fairness)
test [multiple_publicgoods]1=[multiple_publicgoods]0

svy: mean multiple_rights, over(fairness)
test [multiple_rights]1=[multiple_rights]0

svy: mean multiple_suffering, over(fairness)
test [multiple_suffering]1=[multiple_suffering]0

svy: mean multiple_other, over(fairness)
test [multiple_other]1=[multiple_other]0


// examine the write-ins - you have to look through this manually
use Explanation_Data_Writeins.dta, clear


// check differences in party. 
use Explanation_Data_Statements.dta, clear
svyset [pw=rakewt], strata(rid)

svy: mean primary_control if republican==1 | democrat==1, over(republican)
test [primary_control]1=[primary_control]0

svy: mean primary_scope if republican==1 | democrat==1, over(republican)
test [primary_scope]1=[primary_scope]0

svy: mean primary_foreign if republican==1 | democrat==1, over(republican)
test [primary_foreign]1=[primary_foreign]0

svy: mean primary_inequity if republican==1 | democrat==1, over(republican)
test [primary_inequity]1=[primary_inequity]0

svy: mean primary_irreversibility if republican==1 | democrat==1, over(republican)
test [primary_irreversibility]1=[primary_irreversibility]0

svy: mean primary_malign if republican==1 | democrat==1, over(republican)
test [primary_malign]1=[primary_malign]0

svy: mean primary_abnormality if republican==1 | democrat==1, over(republican)
test [primary_abnormality]1=[primary_abnormality]0

svy: mean primary_publicgoods if republican==1 | democrat==1, over(republican)
test [primary_publicgoods]1=[primary_publicgoods]0

svy: mean primary_rights if republican==1 | democrat==1, over(republican)
test [primary_rights]1=[primary_rights]0

svy: mean primary_suffering if republican==1 | democrat==1, over(republican)
test [primary_suffering]1=[primary_suffering]0

svy: mean primary_other if republican==1 | democrat==1, over(republican)
test [primary_other]1=[primary_other]0


// check differences in gender

svy: mean primary_control, over(female)
test [primary_control]1=[primary_control]0

svy: mean primary_scope, over(female)
test [primary_scope]1=[primary_scope]0

svy: mean primary_foreign, over(female)
test [primary_foreign]1=[primary_foreign]0

svy: mean primary_inequity, over(female)
test [primary_inequity]1=[primary_inequity]0

svy: mean primary_irreversibility, over(female)
test [primary_irreversibility]1=[primary_irreversibility]0

svy: mean primary_malign, over(female)
test [primary_malign]1=[primary_malign]0

svy: mean primary_abnormality, over(female)
test [primary_abnormality]1=[primary_abnormality]0

svy: mean primary_publicgoods, over(female)
test [primary_publicgoods]1=[primary_publicgoods]0

svy: mean primary_rights, over(female)
test [primary_rights]1=[primary_rights]0

svy: mean primary_suffering, over(female)
test [primary_suffering]1=[primary_suffering]0

svy: mean primary_other, over(female)
test [primary_other]1=[primary_other]0


// drop the last four responses from each survey

keep if comparison<5

svy: mean primary_control, over(fairness)
test [primary_control]1=[primary_control]0

svy: mean primary_scope, over(fairness)
test [primary_scope]1=[primary_scope]0

svy: mean primary_foreign, over(fairness)
test [primary_foreign]1=[primary_foreign]0

svy: mean primary_inequity, over(fairness)
test [primary_inequity]1=[primary_inequity]0

svy: mean primary_irreversibility, over(fairness)
test [primary_irreversibility]1=[primary_irreversibility]0

svy: mean primary_malign, over(fairness)
test [primary_malign]1=[primary_malign]0

svy: mean primary_abnormality, over(fairness)
test [primary_abnormality]1=[primary_abnormality]0

svy: mean primary_publicgoods, over(fairness)
test [primary_publicgoods]1=[primary_publicgoods]0

svy: mean primary_rights, over(fairness)
test [primary_rights]1=[primary_rights]0

svy: mean primary_suffering, over(fairness)
test [primary_suffering]1=[primary_suffering]0

svy: mean primary_other, over(fairness)
test [primary_other]1=[primary_other]0

svy: mean multiple_control, over(fairness)
test [multiple_control]1=[multiple_control]0

svy: mean multiple_scope, over(fairness)
test [multiple_scope]1=[multiple_scope]0

svy: mean multiple_foreign, over(fairness)
test [multiple_foreign]1=[multiple_foreign]0

svy: mean multiple_inequity, over(fairness)
test [multiple_inequity]1=[multiple_inequity]0

svy: mean multiple_irreversibility, over(fairness)
test [multiple_irreversibility]1=[multiple_irreversibility]0

svy: mean multiple_malign, over(fairness)
test [multiple_malign]1=[multiple_malign]0

svy: mean multiple_abnormality, over(fairness)
test [multiple_abnormality]1=[multiple_abnormality]0

svy: mean multiple_publicgoods, over(fairness)
test [multiple_publicgoods]1=[multiple_publicgoods]0

svy: mean multiple_rights, over(fairness)
test [multiple_rights]1=[multiple_rights]0

svy: mean multiple_suffering, over(fairness)
test [multiple_suffering]1=[multiple_suffering]0

svy: mean multiple_other, over(fairness)
test [multiple_other]1=[multiple_other]0

//TABLE S11. MEDIA MENTIONS
use Risk_Data_Indices.dta, clear
sort risk
list risk lexis, table

*********************************************************************
log close
