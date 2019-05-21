clear

set more off


*************************************************************************
*  File-Name:       CapturingAirwaves_Replication_160901.do             *
*  Date:            160820                                              *
*  Author:          KGM                                                 *
*  Purpose:         Replication Capturing the Airwaves paper            *
*  Data Used:       CapturingAirwaves_Replication_160829.dta            *
*					CapturingAirwaves_ReplicationW1_160901.dta          *
*					merged_r4_data.dta                                  *
*  Output File:     CapturingAirwaves_Replication_160901.log            *
*************************************************************************

*************************************************************************
* call in dataset *
*************************************************************************

use "CapturingAirwaves_Replication_160829.dta"


*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
* Main Text                                                      *
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************


*************************************************************************
* Most Important ID mprobits: 1 is village, 2 is ethnic, 3 is africa, 4 is islam 5 is mali id *
*************************************************************************

mlogit ID_mostimp radiotigi [iweight=weight], baseoutcome(5) vce(cluster village)

mlogit ID_mostimp radiotigi##male [iweight=weight], baseoutcome(5) vce(cluster village)




*************************************************************************;
* probits and output for opinion variables *;
*************************************************************************;

probit yes_marry_tuareg radiotigi [iweight=weight], vce(cluster village)

probit yes_marry_tuareg radiotigi##male [iweight=weight], vce(cluster village)


probit holdoffelection radiotigi [iweight=weight], vce(cluster village)

probit holdoffelection radiotigi##male [iweight=weight], vce(cluster village)


probit approval radiotigi [iweight=weight], vce(cluster village)

probit approval radiotigi##male [iweight=weight], vce(cluster village)



*************************************************************************;
* test if treatment effect on women and men is different *;
*************************************************************************;
mlogit ID_mostimp radiotigi male radiomale [iweight=weight], baseoutcome(5) vce(cluster village)
test radiotigi = radiomale

probit yes_marry_tuareg radiotigi male radiomale [iweight=weight], vce(cluster village)
test radiotigi = radiomale

probit holdoffelection radiotigi male radiomale [iweight=weight], vce(cluster village)
test radiotigi = radiomale

probit approval radiotigi male radiomale [iweight=weight], vce(cluster village)
test radiotigi = radiomale


*************************************************************************;
*************************************************************************;
*************************************************************************;
* marginal effects graphs*;
*************************************************************************;
*************************************************************************;
*************************************************************************;



probit yes_marry_tuareg radiotigi [iweight=weight], vce(cluster village)
margins, dydx(radiotigi)  vsquish post
est store marry1
probit yes_marry_tuareg radiotigi##male [iweight=weight], vce(cluster village)
margins, dydx(radiotigi) at(male=(0(1)1)) vsquish post
est store marry2


probit holdoffelection radiotigi [iweight=weight], vce(cluster village)
margins, dydx(radiotigi)  vsquish post
est store holdoff1
probit holdoffelection radiotigi##male [iweight=weight], vce(cluster village)
margins, dydx(radiotigi) at(male=(0(1)1)) vsquish post
est store holdoff2


coefplot (marry1 \ marry2), bylabel(Allow Offspring to Marry Tuareg) || (holdoff1 \ holdoff2), levels(95 90) bylabel(Hold Off on Elections)  xline(0, lpattern(dot) lwidth(vthin) lcolor(black)) mlabel format(%12.2f) mlabposition(12) mlabgap(*2) groups(headroom radiotigi = "{bf: Main Model}" 1.radiotigi = "{bf: Interactive Model}")  ylabel(1 "Pooled" 3 "Women" 4 "Men") graphregion(color(white))



mlogit ID_mostimp radiotigi  [iweight=weight], baseoutcome(5) vce(cluster village)
est store id
margins, dydx(radiotigi) predict(outcome(1)) post
est store id1
est restore id
margins, dydx(radiotigi) predict(outcome(2)) post
est store id2
est restore id
margins, dydx(radiotigi) predict(outcome(3)) post
est store id3
est restore id
margins, dydx(radiotigi) predict(outcome(4)) post
est store id4
est restore id
margins, dydx(radiotigi) predict(outcome(5)) post
est store id5


mlogit ID_mostimp radiotigi##male  [iweight=weight], baseoutcome(5) vce(cluster village)
est store idhet
margins, dydx(radiotigi) at(male=(0(1)1)) predict(outcome(1)) post
est store id1het
est restore idhet
margins, dydx(radiotigi) at(male=(0(1)1)) predict(outcome(2)) post
est store id2het
est restore idhet
margins, dydx(radiotigi)at(male=(0(1)1))  predict(outcome(3)) post
est store id3het
est restore idhet
margins, dydx(radiotigi) at(male=(0(1)1)) predict(outcome(4)) post
est store id4het
est restore idhet
margins, dydx(radiotigi) at(male=(0(1)1)) predict(outcome(5)) post
est store id5het

coefplot (id1 \ id1het), bylabel(Village) || (id2 \ id2het), bylabel(Ethnic) || (id3 \ id3het), bylabel(African) || (id4 \ id4het), levels(95 90) bylabel(Muslim) xline(0, lpattern(dot) lwidth(vthin) lcolor(black))   mlabel format(%12.2f) mlabposition(12) mlabgap(*2) ylabel(1 "Pooled" 3 "Women" 4 "Men") byopt(rows(1)) groups(headroom radiotigi = "{bf: Main Model}" 1.radiotigi = "{bf: Interactive Model}") 


*I subsequently beautified the graphs and saved as pdf





*************************************************************************;
*************************************************************************;
*************************************************************************;
* predicted values*;
*************************************************************************;
*************************************************************************;
*************************************************************************;


mlogit ID_mostimp radiotigi##male  [iweight=weight], baseoutcome(5) vce(cluster village)
margins radiotigi#male

probit yes_marry_tuareg radiotigi##male [iweight=weight], vce(cluster village)
margins radiotigi#male

probit holdoffelection radiotigi##male [iweight=weight], vce(cluster village)
margins radiotigi#male

*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
* Online Appendix                                                       *
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************


*************************************************************************
*************************************************************************
*************************************************************************
* Analysis of ORTM Broadcasting * 
*************************************************************************
*************************************************************************
*************************************************************************

*see separate files of data and counts

*************************************************************************
*************************************************************************
*************************************************************************
* Descriptive Statistics* 
*************************************************************************
*************************************************************************
*************************************************************************

*outcome variables by gender*
tab male ID_mostimp, row
tab male yes_marry_tuareg, row
tab male holdelection, row
tab male Q43 if Q43 <5, row

*Gender by Village - percentages male and female in each village*
tab village male, column

*Outcomes by Village - percentages male and female in each village*
tab village ID_mostimp, row
tab village yes_marry_tuareg, row
tab village holdelection, row
tab village approval, row

*Create bar graphs of DVs by Village indicating treatment*

graph hbar holdoffelection holdelection, over(village, relabel(1 "Village 1" 2 "Village 2" 3 "Village 3" 4 "Village 4" 5 "Village 5" 6 "Village 6" 7 "Village 7" 8 "Village 8" 9 "Village 9" 10 "Village 10")) over(radiovillage, relabel(1 "Flashlight" 2 "Radio")) stack nofill scheme(sj) graphregion(color(white)) ytitle("Percent") legend(label(1 "Hold Off Election") label(2 "Hold Election")) bar(1, color(green)) bar(2, color(gs14))

graph hbar yes_marry_tuareg no_marry_tuareg, over(village, relabel(1 "Village 1" 2 "Village 2" 3 "Village 3" 4 "Village 4" 5 "Village 5" 6 "Village 6" 7 "Village 7" 8 "Village 8" 9 "Village 9" 10 "Village 10")) over(radiovillage, relabel(1 "Flashlight" 2 "Radio")) stack nofill scheme(sj) graphregion(color(white)) ytitle("Percent") legend(label(1 "Marry Tuareg OK") label(2 "Marry Tuareg NOT OK")) bar(1, color(green)) bar(2, color(gs14))

graph hbar approval no_approval, over(village, relabel(1 "Village 1" 2 "Village 2" 3 "Village 3" 4 "Village 4" 5 "Village 5" 6 "Village 6" 7 "Village 7" 8 "Village 8" 9 "Village 9" 10 "Village 10")) over(radiovillage, relabel(1 "Flashlight" 2 "Radio")) stack nofill scheme(sj) graphregion(color(white)) ytitle("Percent") legend(label(1 "At Least a Lil' Satisfied") label(2 "Not at All Satisfied")) bar(1, color(green)) bar(2, color(gs14))

graph hbar IDnational IDethnic, over(village, relabel(1 "Village 1" 2 "Village 2" 3 "Village 3" 4 "Village 4" 5 "Village 5" 6 "Village 6" 7 "Village 7" 8 "Village 8" 9 "Village 9" 10 "Village 10")) over(radiovillage, relabel(1 "Flashlight" 2 "Radio")) stack nofill scheme(sj) graphregion(color(white)) ytitle("Percent") legend(label(1 "National ID") label(2 "Ethnic ID")) bar(1, color(green)) bar(2, color(gs14))

graph hbar IDnational IDethnic IDvillage IDafrica IDislam, over(village, relabel(1 "Village 1" 2 "Village 2" 3 "Village 3" 4 "Village 4" 5 "Village 5" 6 "Village 6" 7 "Village 7" 8 "Village 8" 9 "Village 9" 10 "Village 10")) over(radiovillage, relabel(1 "Flashlight" 2 "Radio")) stack nofill scheme(sj) graphregion(color(white)) ytitle("Percent") legend(label(1 "National ID") label(2 "Ethnic ID") label(3 "Village ID") label(4 "African ID") label(5 "Muslim ID")) bar(1, color(green)) bar(2, color(gs14))


*************************************************************************
*************************************************************************
*************************************************************************
* Power Calculation Graphs* 
*************************************************************************
*************************************************************************
*************************************************************************

*calculated using: https://egap.shinyapps.io/Power_Calculator/

*************************************************************************
*************************************************************************
*************************************************************************
* Additional Analysis and Robustness Checks* 
*************************************************************************
*************************************************************************
*************************************************************************

*************************************************************************
* wild cluster bootstrapped SEs tabular results and marginal effects *
*************************************************************************

* hold election  *
cgmlogit holdoffelection radiotigi [iweight=weight], cluster(village)
margins, dydx(radiotigi)  vsquish post
est store holdoff1


cgmlogit holdoffelection radiotigi male radiomale [iweight=weight], cluster(village)
margins, dydx(radiotigi) at(male=(0(1)1)) vsquish post
est store holdoff2



* Tuareg Marry  *
cgmlogit yes_marry_tuareg radiotigi [iweight=weight], cluster(village)
margins, dydx(radiotigi)  vsquish post
est store marry1

cgmlogit yes_marry_tuareg radiotigi male radiomale [iweight=weight], cluster(village)
margins, dydx(radiotigi) at(male=(0(1)1)) vsquish post
est store marry2


* Most Important ID  *
* NOTE: no multinomial probit package for cgm, so dichotomized to use logit *

cgmlogit ethnicID radiotigi [iweight=weight],  cluster(village)
margins, dydx(radiotigi)  vsquish post
est store ethnic1

cgmlogit ethnicID radiotigi male radiomale [iweight=weight],  cluster(village)
margins, dydx(radiotigi) at(male=(0(1)1)) vsquish post
est store ethnic2



* approval*
cgmlogit approval radiotigi [iweight=weight], cluster(village)

cgmlogit approval radiotigi male radiomale [iweight=weight], cluster(village)



* graph margins output*
coefplot (ethnic1 \ ethnic2), bylabel(Ethnic Identity (versus National) More Important) || (marry1 \ marry2), bylabel(Allow Offspring to Marry Tuareg) || (holdoff1 \ holdoff2), levels(95 90) bylabel(Hold Off on Elections)  xline(0, lpattern(dot) lwidth(vthin) lcolor(black)) mlabel format(%12.2f) mlabposition(12) mlabgap(*2) groups(headroom radiotigi = "{bf: Main Model}" 1.radiotigi = "{bf: Interactive Model}")  ylabel(1 "Pooled" 3 "Women" 4 "Men") graphregion(color(white))


*************************************************************************
* robustness putschist approval IDK *
*************************************************************************


mprobit approvaltricot radiotigi [iweight=weight], baseoutcome(2) vce(cluster village)

mprobit approvaltricot radiotigi##male [iweight=weight], baseoutcome(2) vce(cluster village)




*************************************************************************
* Attrition* 
*************************************************************************

*endline respondents*
tab radiotigi male, cell

clear 
* call in baseline dataset to calculate attrition and do balance checks *

use "CapturingAirwaves_ReplicationW1_160901.dta"
tab radiotigi
tab radiotigi male, cell

*************************************************************************
* Balance Checks* 
*************************************************************************
prtest male, by(radiotigi)
prtest religiousschool, by(radiotigi)
ttest traveloutside, by(radiotigi)
prtest radio_have, by(radiotigi)
prtest know_limits, by(radiotigi)
prtest know_vote, by(radiotigi)
prtest attendmeeting, by(radiotigi)
prtest contactchief, by(radiotigi)
prtest tuareg_female_ingroup, by(radiotigi)
prtest tuareg_male_ingroup, by(radiotigi)
prtest likenews, by(radiotigi)

clear

*************************************************************************
* Afrobarometer data* 
*************************************************************************

use "merged_r4_data.dta"

*contextualization of research site development level

*drop south africa
drop if country == 16

*rural africa
tab EA_SVC_A urbrur if EA_SVC_A !=9 & EA_SVC_A !=-1, column 
tab EA_SVC_B urbrur if EA_SVC_B !=9 & EA_SVC_B !=-1, column 
tab EA_ROAD urbrur if EA_ROAD !=9 & EA_ROAD !=-1, column 
tab Q92A urbrur if Q92A ==0 | Q92A ==1, column 
tab Q92B urbrur if Q92B ==0 | Q92B ==1, column 



*rural Mali and Mali as a whole
tab EA_SVC_A urbrur if EA_SVC_A !=9 & EA_SVC_A !=-1 & country==11, column 
tab EA_SVC_B urbrur if EA_SVC_B !=9 & EA_SVC_B !=-1  & country==11, column 
tab EA_ROAD urbrur if EA_ROAD !=9 & EA_ROAD !=-1  & country==11, column 
tab Q92A urbrur if Q92A ==0 | Q92A ==1  & country==11, column 
tab Q92B urbrur if Q92B ==0 | Q92B ==1  & country==11, column 


*see R code for graph of media consumption in mali by gender and urbanity, and media consumption map Africa 

log close
