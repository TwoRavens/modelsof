**************
*** How Government Reactions to Violence Worsen Social Welfare: Evidence from Peru
*** Sexton, Wellhausen and Findley
*** October 2018
*** Replication code
***************

/* Datafiles description
- Budget data come from the World Bank's BOOST program. Raw data available: http://boost.worldbank.org/country/peru
- Violence data are coded from Peru's Defensoria del Pueblo. Reports are available: http://www.defensoria.gob.pe/blog/tag/reporte-de-conflictos-sociales/
The relevant incidents are 'acciondes de violencia subversiva' We include a dataset of extracted and coded incidents.
- Congressional debate data come from the Peru Congress's 'Diario de los Debates,' available:  
- Health information is sourced from USAID's Demographic and Health Survey (DHS): https://dhsprogram.com/data/available-datasets.cfm
- LAPOP survey data for Peru are available: https://www.vanderbilt.edu/lapop/raw-data.php
*/

** NOTE: The BRL command may be installed from: https://economics.byu.edu/frandsen/Pages/software.aspx
** In addition, the brl.ado file is included in this replication dataset
** Type 'personal' in Stata command line to locate personal ado directory
** Move brl.ado brl.hlp brl.pkg to that directory

/* Data accessed in this replication file:

swf-peru-ajps.dta
debate_attacks.dta
attacks_list.dta
hurdle.dta
swf-peru-ajps_forR.dta

*/

*** Created in STATA/MP version 13.1

clear all
set matsize 4000
set more off

** Change to appropriate working directory (e.g.)

cd "~/Downloads/"

** Check packages
capture ssc install ivreg2
capture ssc install ranktest

** Set scheme, temporarily
set scheme s1mono

********************
* Variable Labels 
********************

capture program label_var1
label var acute_under5_diarrhea_pc "Number of cases of acute diarrhea in under-5 children per capita"
label var acute_under5_respiratory_pc "Number of cases of acute respiratory illness in under-5 children per capita"
label var budget_mining "Number of mining conflict incidents during budget period"
label var non_budget_mining "Number of mining conflict incidents during non budget period"
label var non_mining "Number of non-mining, non-insurgent protest incidents"
label var enviro_b "Environment budget share (percent)"
label var culture_b "Culture budget share (percent)"
label var def_b "Defense budget share (percent)"
label var def_s "Defense spending share (percent)"
label var health_b "Health budget share (percent)"
label var health_s "Health spending share (percent)"
label var socialservice_b "Combined social services budget share (percent)"
label var socialservice_s "Combined social services spending share (percent)"
label var deptcode "Department Code"
label var deptname "Department Name"
label var execution "Department Government Budget Execution"
label var execution_nodef "Department Government Budget Execution (excluding defense)"
label var execution_nohealth "Department Government Budget Execution (excluding health)"
label var gk_budget "Number of soldiers killed by insurgents during budget period"
label var gk_budget2 "Dummy for soldiers killed by insurgents during budget period"
label var gk_prebudget "Number of soldiers killed by insurgents during pre-budget period"
label var gk_prebudget2 "Dummy for soldiers killed by insurgents during pre-budget period"
label var gk_december "Number of soldiers killed by insurgents during December"
label var health_usage_women "Share of women reporting usage of health facilities this year (LAPOP)"
label var health_usage_women_highinc "Share of women in top quartile of income reporting usage of health facilities this year (LAPOP)"
label var health_usage_women_lowinc "Share of women in bottom quartile income reporting usage of health facilities this year (LAPOP)"
label var health_usage_men "Share of men reporting usage of health facilities this year (LAPOP)"
label var health_facility_visit "Share of women reporting visit to health facilities this year (DHS)"
label var licensed_postnatal "Share of births reporting postnatal care by licensed professional (DHS)"
label var infant_mortality "Department infant mortality rate (WHO definition) using DHS data"
label var year "Year"
label var def_budget_mi "Multiply imputed defense budget"
label var def_spent_mi "Multiply imputed defense spending"
label var ln_pbi_pc "GDP per capita (log transformed)"
label var population "Population"
label var pop100k "Population (in 100k)"
label var pride "Share expressing national pride (LAPOP)"
label var problem_crime "Share reporting crime as a problem (LAPOP)"
label var problem_security "Share reporting security as a problem (LAPOP)"
label var problem_terrorism "Share reporting terrorism as a problem (LAPOP)"
label var inc_vote_change "Change in vote share for legislative incumbent party 2006 to 2011"
label var senderista "Department experienced any dissident attacks during time series"
label var distbudget "Department budget (Soles)"
label var high_def_bshare "Dummy for above median defense budget share"
label define yesno 0 "no"  1 "yes"
label values gk_budget2 yesno
label values gk_prebudget2 yesno
label values high_def_bshare yesno
label values senderista yesno
end

********************
* Manuscript Tables
********************

use swf-peru-ajps, clear
tsset deptcode year
label_var1

* Table 1: Unexpected budget-period soldier fatalities decrease total social services and health sector budget shares/spending, and increase defense budget shares/spending.

eststo clear
foreach y in socialservice_b socialservice_s health_b health_s{
xtreg `y' cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc execution_nohealth i.year, fe vce(cl deptcode)
eststo
}

foreach y in def_b def_s {
xtreg `y' cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc execution_nodef i.year, fe vce(cl deptcode)
eststo
}

esttab using "table1.tex", keep(L.gk_budget cL.gk_budget#cL.gk_prebudget2 L.gk_prebudget2 ///
  ln_pbi_pc execution_nodef execution_nohealth) cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_g Departments")  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 2: Budget-period soldier fatalities increase the likelihood of congressional debate on fatalities and defense spending.

use debate_attacks, clear

label var ln_numberkilled "Log number of goverment fatalities"
label var CasualtiesfromSL "Casualities from Sendero mentioned in debate"
label var Fundingformilitary "Funding for military mentioned in debate"
label var id "Unique id for incident"
label var After "Is date of debate after the incident"
label define yesno 0 "no"  1 "yes"
label values CasualtiesfromSL yesno
label values Fundingformilitary yesno
label values After yesno

eststo clear
reg CasualtiesfromSL After , vce(cl id)
eststo
margins, at(After=(0 1))
reg Fundingformilitary After , vce(cl id)
eststo
margins, at(After=(0 1))
***
reg CasualtiesfromSL c.After##c.numberkilled , vce(cl id)
eststo
margins, dydx(After) at(numberkilled=(1 2 5 10))
reg Fundingformilitary c.After##c.numberkilled , vce(cl id)
eststo
margins, dydx(After) at(numberkilled=(1 2 5 10))


esttab using "table2.tex", keep(After numberkilled c.After#c.numberkilled) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N (sessions)" "N_clust Fatal attacks" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


* Table 3: Soldier fatalities indirectly increase infant mortality.

use swf-peru-ajps, clear
tsset deptcode year
label_var1

eststo clear
foreach y in socialservice_b socialservice_s health_b health_s {
ivregress 2sls F.infant_mortality i.year i.deptcode L.gk_prebudget ln_pbi_pc  execution_nohealth (`y' = L.gk_budget), vce( cl deptcode) 
eststo
}

esttab using "table3.tex", keep(socialservice_b socialservice_s health_b health_s) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 
  
*** Table 3: First stage F-test

foreach y in socialservice_b socialservice_s health_b health_s{
qui xtreg `y' L.gk_budget L.gk_prebudget ln_pbi_pc  execution_nohealth , fe  vce( cl deptcode)
di "First stage F statistic for `y': `e(F)'"
}  
  
* Table 4: Soldier fatalities in the previous year's budget period reduce women's usage of local general and postnatal health services.

eststo clear
xtreg health_facility_visit cL.gk_budget cL.gk_prebudget ln_pbi_pc execution_nohealth    i.year, fe vce(cl deptcode)
eststo
xtreg licensed_postnatal cL.gk_budget cL.gk_prebudget ln_pbi_pc execution_nohealth    i.year, fe vce(cl deptcode)
eststo

esttab using "table4.tex", keep(L.gk_budget L.gk_prebudget ln_pbi_pc execution_nohealth) ///
  cells(b(star fmt(3)) se(par fmt(3))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 5: Reductions in women's usage of local general and postnatal health services increase infant mortality in t+1.

eststo clear
ivregress 2sls F.infant_mortality i.year i.deptcode cL.gk_prebudget ln_pbi_pc execution    (licensed_postnatal = L.gk_budget), vce( cl deptcode) 
eststo
ivregress 2sls F.infant_mortality i.year i.deptcode cL.gk_prebudget ln_pbi_pc execution   (health_facility_visit = L.gk_budget ), vce( cl deptcode) 
eststo

esttab using "table5.tex", keep(licensed_postnatal health_facility_visit) ///
  cells(b(star fmt(0)) se(par fmt(0))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

  
*** First stage F-test

foreach y in licensed_postnatal health_facility_visit{
qui reg `y' L.gk_budget L.gk_prebudget  ,   vce( cl deptcode)
di "First stage F statistic for `y': `e(F)'"
}  

  
* Table 6: Survey evidence suggests that soldier fatalities do not affect citizens' perceptions of security.

eststo clear
xtreg problem_security cL.gk_budget cL.gk_prebudget2 ln_pbi_pc   i.year, fe vce(cl deptcode)
eststo
xtreg problem_terrorism cL.gk_budget cL.gk_prebudget2 ln_pbi_pc   i.year, fe vce(cl deptcode)
eststo
xtreg problem_crime cL.gk_budget cL.gk_prebudget2 ln_pbi_pc   i.year, fe vce(cl deptcode)
eststo

esttab using "table6.tex", keep(L.gk_budget) ///
  cells(b(star fmt(3)) se(par fmt(3))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

  
********************
* Appendix
********************


* Table 1: Summary Statistics
sum infant_mortality socialservice_b health_b def_b socialservice_s health_s def_s  ///
health_usage_women health_facility_visit licensed_postnatal problem_security problem_terrorism problem_crime
sum gk_budget gk_prebudget gk_december if year<2011
 
* Figure 1: Average number of dissident attacks that kill soldiers, by month

use attacks_list,clear

collapse (sum) numgovkilled, by(year month)
tsset month year
tsfill, full
replace numgovkilled=0 if missing(numgovkilled)
gen gov_killed_event=(numgovkilled>0)
sort year month
bysort month: egen mean_govkilled=mean(numgovkilled)
bysort month: egen mean_govkilled2=mean(gov_killed_event)

twoway  (lpolyci numgovkilled month) (scatter mean_govkilled month) , legend(off) xlabel(1(1)12) ///
 xtitle("                                                                             Budget Period ")	  xline (8.5 11.5) ///
 ytitle("Average Number of Soldier Deaths")
 graph export "events_month.pdf",replace

* Table 2: Robustness: Biased-reduced Linearization

use swf-peru-ajps, clear
tsset deptcode year
label_var1

forvalues i=2007/2011{
gen yr`i'=(year==`i')
}
forvalues i=1/26{
 gen dpt`i'=(deptcode==`i')
}
gen L_gk_budget=L.gk_budget
gen L_gk_prebudget2=L.gk_prebudget2
gen interaction=(L_gk_budget*L_gk_prebudget2)

eststo clear
brl def_b L_gk_budget L_gk_prebudget2 interaction ln_pbi_pc  yr2008-yr2010 dpt1-dpt7 dpt9-dpt20 dpt22-dpt25 execution  , cluster(deptcode)
eststo
brl health_b L_gk_budget L_gk_prebudget2 interaction ln_pbi_pc  yr2008-yr2010 dpt1-dpt7 dpt9-dpt20 dpt22-dpt25 execution  , cluster(deptcode)
eststo


esttab using "Appendix_table2.tex", keep(L_gk_budget L_gk_prebudget2 interaction ln_pbi_pc execution) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 



* Table 3: Non-parametric combination of results (R file)

** See "SWF-NPC-implmentation.R"

* Table 4: Robustness: LDV

eststo clear
xtreg def_b cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc L.def_b execution_nodef  i.year , fe vce(cl deptcode)
eststo
xtreg health_b cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc L.health_b execution_nohealth i.year , fe vce(cl deptcode)
eststo

esttab using "Appendix_table4.tex", keep(L.gk_budget cL.gk_budget#cL.gk_prebudget2  ln_pbi_pc execution_nodef execution_nohealth) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


* Table 5: Robustness: First differences

eststo clear
xtreg D.def_b cLD.gk_budget##cL.gk_prebudget2 ln_pbi_pc execution_nodef i.year    ,  vce(cl deptcode)
eststo
xtreg D.health_b cLD.gk_budget##cL.gk_prebudget2 ln_pbi_pc execution_nohealth i.year   ,  vce(cl deptcode)
eststo


esttab using "Appendix_table5.tex", drop(*.year _cons) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


* Table 6: Accounting for mining-sector violence does not change results

eststo clear
xtreg health_b cL.gk_budget##cL.gk_prebudget2 L.budget_mining cL.non_budget_mining L.non_mining ln_pbi_pc execution  i.year, fe vce(cl deptcode)
eststo
xtreg def_b cL.gk_budget##cL.gk_prebudget2 L.budget_mining cL.non_budget_mining L.non_mining ln_pbi_pc execution  i.year, fe vce(cl deptcode)
eststo

esttab using "Appendix_table6.tex", keep(L.gk_budget cL.gk_budget#cL.gk_prebudget2 L.gk_prebudget2 ln_pbi_pc L.budget_mining L.non_budget_mining execution ) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Figure 2: Treatment effects with a treatment dummy with varying cutpoints

gen killeddummy_0=(gk_budget>0) if !missing(gk_budget)
gen killeddummy_1=(gk_budget>1) if !missing(gk_budget)
gen killeddummy_2=(gk_budget>2) if !missing(gk_budget)
gen killeddummy_3=(gk_budget>3) if !missing(gk_budget)
gen killeddummy_4=(gk_budget>4) if !missing(gk_budget)
gen killeddummy_5=(gk_budget>5) if !missing(gk_budget)
gen killeddummy_6=(gk_budget>6) if !missing(gk_budget)


xtreg health_b L.killeddummy_0 i.year, fe vce(cl deptcode)
xtreg health_b L.killeddummy_1 i.year, fe vce(cl deptcode)
xtreg health_b L.killeddummy_2 i.year, fe vce(cl deptcode)
xtreg health_b L.killeddummy_3 i.year, fe vce(cl deptcode)
xtreg health_b L.killeddummy_4 i.year, fe vce(cl deptcode)
xtreg health_b L.killeddummy_5 i.year, fe vce(cl deptcode)
xtreg health_b L.killeddummy_6 i.year, fe vce(cl deptcode)

*** Treatment effects exported to hurdle.dta

use hurdle,clear

gen u=coef+se
gen l=coef-se

twoway rcap u l band  || ///
    scatter coef band ///
    , legend(off) ///
     xtitle("Treatment=1 for X or greater fatalities") ///
    yline(0, lc(black)) ytitle("Treatment effect on Health Budget Share")
 graph export "hurdle1.pdf",replace

* Table 7: Soldiers killed during budget period and defense share

use swf-peru-ajps, clear
tsset deptcode year
label_var1

replace def_budget_mi=(def_budget_mi/1000000)
replace def_spent_mi=(def_spent_mi/1000000)

replace def_budget_mi=. if def_budget_mi==0

gen Ldef_budget=L.def_budget_mi
gen L2def_budget=L2.def_budget_mi
gen Ldef_spent=L.def_spent_mi
gen L2def_spent=L2.def_spent_mi

mi set wide
mi register imputed def_budget_mi
mi impute pmm def_budget_mi Ldef_budget L2def_budget distbudget if year>2007, add(20) knn(1)  rseed(2232) force
eststo clear
sort deptcode year
gen treatment= L.gk_budget
mi estimate, post dots:  xtreg def_budget_mi c.treatment##high_def_bshare   i.year , fe vce(cl deptcode) 
eststo


esttab using "Appendix_table7.tex", keep( treatment 1.high_def_bshare#c.treatment 1.high_def_bshare ) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


*  Table 8: No effects of budgeting on child morbidity

use swf-peru-ajps, clear
tsset deptcode year
label_var1

eststo clear
ivreg2 F.acute_under5_diarrhea_pc i.year i.deptcode cL.gk_prebudget ln_pbi_pc  execution_nohealth   (health_b = L.gk_budget  ), cluster( deptcode) 
eststo
ivreg2 F.acute_under5_diarrhea_pc i.year i.deptcode cL.gk_prebudget ln_pbi_pc  execution_nohealth   (enviro_b = L.gk_budget  ), cluster( deptcode)
eststo
ivreg2 F.acute_under5_diarrhea_pc i.year i.deptcode cL.gk_prebudget ln_pbi_pc  execution_nohealth   (culture_b = L.gk_budget  ), cluster( deptcode)
eststo
ivreg2 F.acute_under5_respiratory_pc  i.year i.deptcode cL.gk_prebudget ln_pbi_pc  execution_nohealth   (health_b = L.gk_budget  ), cluster( deptcode) 
eststo
ivreg2 F.acute_under5_respiratory_pc i.year i.deptcode cL.gk_prebudget ln_pbi_pc  execution_nohealth   (enviro_b = L.gk_budget  ), cluster( deptcode) 
eststo 
ivreg2 F.acute_under5_respiratory_pc i.year i.deptcode cL.gk_prebudget ln_pbi_pc  execution_nohealth   (culture_b = L.gk_budget  ), cluster( deptcode) 
eststo

esttab using "Appendix_table8.tex", keep( health_b enviro_b culture_b) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 



* Table 9: Departments with soldier fatalities are poorer but otherwise similar

use swf-peru-ajps, clear
tsset deptcode year
label_var1

collapse senderista  ln_pbi_pc pop100k  infant_mortality def_b health_b , by(deptcode)

eststo clear
foreach y in ln_pbi_pc pop100k def_b health_b  infant_mortality {
reg `y'  senderista, robust
eststo 
}


esttab using "Appendix_table9.tex",  keep(senderista) cells(b(star fmt(2)) se(par fmt(2))) stats(N, labels(N) fmt(0)) starlevel(* .05 ** .01 *** .001) replace tex nolz label noabb wrap varwidth(50) mtitles



* Table 10: Soldier fatalities in the budget period reduce other social services sector budget shares.

use swf-peru-ajps, clear
tsset deptcode year
label_var1

eststo clear
xtreg enviro_b cL.gk_budget cL.gk_prebudget2 ln_pbi_pc execution_nohealth  i.year, fe  vce(cl deptcode)
eststo
xtreg culture_b cL.gk_budget cL.gk_prebudget2 ln_pbi_pc execution_nohealth  i.year, fe  vce(cl deptcode)
eststo

esttab using "Appendix_table10.tex", keep( L.gk_budget L.gk_prebudget2 ln_pbi_pc  execution_nohealth) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


* Table 11: Model 1 (year fixed effects): LaGrange Multiplier Autocorrelation Test

eststo clear
reg health_b cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc  i.year,  vce(cl deptcode)
eststo

predict residuals0, residuals

reg residuals0 cL.gk_budget##cL.gk_prebudget2  L.residuals0

scalar N=e(N)
scalar R2=e(r2)
scalar NR2= N*R2 
scalar list N  R2  NR2 

scalar chi15=invchi2(1, .95) 
scalar list chi15 NR2

eststo clear
reg def_b cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc i.year,  vce(cl deptcode)
eststo

predict residuals, residuals

reg residuals cL.gk_budget##cL.gk_prebudget2  L.residuals

scalar N=e(N)
scalar R2=e(r2)
scalar NR2= N*R2 
scalar list N  R2  NR2 

scalar chi15=invchi2(1, .95) 
scalar list chi15 NR2

* Table 12: Model 2 (year and department fixed effects): LaGrange Multiplier Autocorrelation Test

eststo clear

reg health_b cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc i.deptcode i.year, vce(cl deptcode)
eststo

predict residuals1, residuals

reg residuals1 cL.gk_budget##cL.gk_prebudget2  L.residuals1

scalar N=e(N)
scalar R2=e(r2) 
scalar NR2= N*R2 
scalar list N  R2  NR2 

scalar chi15=invchi2(1, .95) 
scalar list chi15 NR2

eststo clear
reg def_b cL.gk_budget##cL.gk_prebudget2 ln_pbi_pc  i.deptcode i.year,  vce(cl deptcode)
eststo

predict residuals2, residuals

reg residuals2 cL.gk_budget##cL.gk_prebudget2   L.residuals2

scalar N=e(N)
scalar R2=e(r2)
scalar NR2= N*R2 
scalar list N  R2  NR2 

scalar chi15=invchi2(1, .95) 
scalar list chi15 NR2


* Table 13: Only recent soldier fatalities reduce incumbent party vote share

eststo clear
reg inc_vote_change gk_budget gk_prebudget ln_pbi_pc, vce(cl deptcode)
eststo
reg inc_vote_change health_b ln_pbi_pc, vce(cl deptcode)
eststo
reg inc_vote_change gk_budget gk_prebudget health_b ln_pbi_pc, vce(cl deptcode)
eststo

esttab using "Appendix_table13.tex", keep(gk_budget gk_prebudget health_b ln_pbi_pc) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 14: Soldier fatalities increase national pride, briefly

eststo clear
xtreg pride gk_budget gk_prebudget ln_pbi_pc i.year, fe vce(cl deptcode)
eststo

esttab using "Appendix_table14.tex", keep(gk_budget gk_prebudget ln_pbi_pc) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 15: Soldier fatalities in budget period hurt poor women's health access, in particular

eststo clear
xtreg health_usage_women_highinc L.gk_budget i.year, fe vce(cl deptcode)
eststo
xtreg health_usage_women_lowinc L.gk_budget i.year, fe vce(cl deptcode)
eststo

esttab using "Appendix_table15.tex", keep(L.gk_budget ) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 16: Placebo: Soldier fatalities in December (after budget period) have no effect on health budget share or women's health facility visits

eststo clear
xtreg health_b   L.gk_budget L.gk_december cL.gk_prebudget ln_pbi_pc    i.year , fe vce(cl deptcode)
eststo
xtreg health_facility_visit   L.gk_budget L.gk_december cL.gk_prebudget ln_pbi_pc    i.year , fe vce(cl deptcode)
eststo

esttab using "Appendix_table16.tex", keep(L.gk_budget L.gk_december L.gk_prebudget ln_pbi_pc ) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 17: Placebo: Health budget does not affect last year's infant mortality

eststo clear
ivregress 2sls L.infant_mortality i.year i.deptcode  (health_b = L.gk_budget ), vce( cl deptcode) 
eststo
ivregress 2sls L.infant_mortality i.year i.deptcode  (health_s = L.gk_budget ), vce( cl deptcode) 
eststo

esttab using "Appendix_table17.tex", keep(health_b health_s) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 

* Table 18: First stage estimates

eststo clear
foreach y in socialservice_b socialservice_s health_b health_s{
 xtreg `y' L.gk_budget L.gk_prebudget ln_pbi_pc  execution_nohealth , fe  vce( cl deptcode)
 di "First stage F statistic for `y': `e(F)'"
eststo
}  

esttab using "Appendix_table18.tex", keep(L.gk_budget) ///
  cells(b(star fmt(2)) se(par fmt(2))) ///
  scalars("N N" "N_clust Departments" "F F-stat" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


* Table 19: Disaggregating health access effects by gender

eststo clear
xtreg health_usage_women cL.gk_budget cL.gk_prebudget2 ln_pbi_pc execution i.year, fe  vce(cl deptcode)
eststo
xtreg health_usage_men cL.gk_budget cL.gk_prebudget2 ln_pbi_pc execution i.year, fe  vce(cl deptcode)
eststo

esttab using "Appendix_table19.tex", keep(L.gk_budget ) ///
  cells(b(star fmt(3)) se(par fmt(3))) ///
  scalars("N N" "N_clust Departments" )  starlevel(* .05 ** .01 *** .001) replace tex nolz label noobs noabb wrap varwidth(50) 


