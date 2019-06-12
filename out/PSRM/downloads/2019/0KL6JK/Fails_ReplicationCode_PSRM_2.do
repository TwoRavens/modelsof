log using "Fails_PSRM_Log", replace

/*
Replication code for "Oil Income and the Personalization of Autocratic Politics"
Author: Matthew Fails
Email: 	fails@oakland.edu
PSRM manusctipt #PSRM-RN-2018-0133.R1
*/

/*
Note: code reflects post-acceptance changes to model reporting; Table 1 now 
reports only models from 1991-2010 sample; Models covering 1980-2010 
(originally reported in Table 1 Models 1-2 in conditionally accepted manuscript)
are now reported as Table 1A in Appendix/Supplemental Material
*/

clear

/*Please insert path where dataset ("PSRM_Personalism_Dataset") has been saved*/
cd c:\data

***************
**READ IN DATA
***************
use PSRM_Personalism_Dataset, clear

/*
Dataset defined as all observations with non-missing measures of 
'latent_personalism' in Geddes, Wright, and Frantz (2018; hereafter GWF) 
"Time Varying Measure of Personalism" dataset.
All vars with "gwf_" prefix are drawn from this dataset
*/

**declare data structure
tsset gwf_caseid year


***************
**VARIABLE CREATION / DATA MAINTENANCE
***************

gen lincome_new = ln(WBincome_new)
label var lincome_new "Log income per capita, newest WDI"

gen oil_new = ln(oil_gas_valuepop_2014+1)
label var oil_new "log of oil income per capita, newest Ross/Mahdavi data"

gen logdur = ln(gwf_leader_duration)
label var log "natural log of leader duration, GWF data"

gen popmad_adj = pop_maddison/1000000
label var popmad_adj "Population, Maddison, in millions"

gen lgdppc = ln(gdppc_wdi)
label var lgdppc "log of gdp per capita, Graham/WDI data"

label var tax "Tax Revenue as a share of GDP, IMF"
label var in_pctgdp "FDI inflow as share of GDP, newest WDI"

label var ccode "COWCODE"
label var country "Country name
label var oil_price_2000 "Oil price in constant 2000 USD, Ross/Mahdavi data"
label var pop_maddison "Population, Maddison estimates"
label var WBincome_new "Income per capita, newest WDI"
label var latent_personalism "GWF latent personalism measure, standardized"
label var pers_2pl "GWF latent personalism measure, unstandardized"

**************
**FIGURE 1
**************

*Generate measures for Figure 1
/*steps:
1) by regime, calculate average oil income per capita
2) by regime, generate "oil regime" dummy if the mean in step 1 is greater than 100
3) by year, calculate average levels of personalism for oil regimes ('avgpersO') and non-oil regimes ('avgpersNO')
*/
bysort gwf_caseid: egen oil_a2 = mean(oil_gas_valuepop_2014)
bysort gwf_caseid: gen oilstate2 = 1 if oil_a2>=100
bysort year: egen avgpersO = mean(latent_personalism) if oilstate2==1
bysort year: egen avgpersNO = mean(latent_personalism) if oilstate2!=1 & oil_gas_valuepop_2014!=.

*Figure 1 (requires scheme 'plotplain' installed)
graph twoway (line avgpersO year, clpattern(dash) xline(1991) xline(1980) xaxis(1 2) xla(1980 "Big Oil Change" 1991 "Cold War Ends", axis(1)) xtitle("", axis(1)) xscale(noline axis(1))  ytitle("Average Personalism Score") xtitle("Year", axis(2))) (line avgpersNO year, clpattern(shortdash) scheme(plotplain)) ///
(line oil_price_2000 year, ytitle("Price of Crude Oil, in constant USD", axis(2)) clpattern(solid) yaxis(2) note("Note: Oil regimes defined as those averaging more than $100 in per-capita oil income" "over the duration of the regime, using data from Ross and Mahdavi (2013).") ///
legend(order(1 "Oil Regimes" 2 "Non-Oil Regimes" 3 "Oil Price")))
graph save PersonalismFigure1, replace

***************
*START REGRESSION ANALYSIS
***************
tsset gwf_caseid year

*TABLE 1

*Model 1 - Baseline specification, post-Cold War
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur i.year if year>1991, fe robust
est store m1
*identify top 10% threshold of oil production for robustness analysis
centile oil_new if e(sample), centile(90)
*Model 2 - Baseline speficication, post-Cold War, exclude top 10% of oil_new obs
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur i.year if year>1991 & oil_new<8.120672, fe robust
est store m2
*Model 3 - Extra controls, post-Cold War
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991, fe robust
est store m3
*identify top 10% threshold of oil production for robustness analysis
centile oil_new if e(sample), centile(90)
*Model 4 - Extra controls, post-Cold War, exclude top 10% of oil_new obs
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991 & oil_new<8.347798, fe robust
est store m2

esttab m* using m1.csv, cells(b(star  fmt(%9.3f)) se(par fmt(%9.3f))) stats(N) style(tab) replace label starlevels(* 0.10 ** 0.05 *** 0.01)


**FIGURE 2 - ESTIMATES OF PARAMETERS OF INTEREST FROM MODELS 2-4
/*Stages of analysis:
1) Define an IQR increase in each relevant variable
2) Esimate, by model, the change in expected value of the DV per an IQR increase in each relevant variable, all other covariates held to mean values
3) Combine these estimates into a single plot
*/
 
*Model 2
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur i.year if year>1991 & oil_new<8.120672, fe robust
centile oil_new logdur gwf_firstldr if e(sample), centile(25 75)

margins, at(l2.oil_new=(0,5.025)) atmeans level(90) contrast(at effects) post
estimates store margins_1

xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur i.year if year>1991 & oil_new<8.120672, fe robust
margins, at(l.logdur=(1.609,2.833)) atmeans level(90) contrast(at effects) post
estimates store margins_2

xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur i.year if year>1991 & oil_new<8.120672, fe robust
margins, at(l.gwf_firstldr=(0,1)) atmeans level(90) contrast(at effects) post
estimates store margins_3

*Model 3
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991, fe robust
centile oil_new logdur gwf_firstldr if e(sample), centile(25 75)

margins, at(l2.oil_new=(0,5.025)) atmeans level(90) contrast(at effects) post
estimates store margins_4

xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991, fe robust
margins, at(l.logdur=(1.609,2.890)) atmeans level(90) contrast(at effects) post
estimates store margins_5

xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991, fe robust
margins, at(l.gwf_firstldr=(0,1)) atmeans level(90) contrast(at effects) post
estimates store margins_6

*Model 4
xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991 & oil_new<8.347798, fe robust
centile oil_new logdur gwf_firstldr if e(sample), centile(25 75)

margins, at(l2.oil_new=(0,5.546)) atmeans level(90) contrast(at effects) post
estimates store margins_7

xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991 & oil_new<8.347798, fe robust
margins, at(l.logdur=(1.609,2.833)) atmeans level(90) contrast(at effects) post
estimates store margins_8

xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l2.in_pctgdp l2.tax i.year if year>1991 & oil_new<8.347798, fe robust
margins, at(l.gwf_firstldr=(0,1)) atmeans level(90) contrast(at effects) post
estimates store margins_9

*Code to combine these marginal effects into Figure 2
coefplot ///
(margins_1, label("{bf:Oil Income,}{it: model 2}") m(O) offset(0.3)) ///
(margins_4, label("{it:model 3}") m(O) offset(0.275)) ///
(margins_7, label("{it:model 4}") m(O) offset(0.25)) ///
(margins_2, label("{bf:Leader Duration,}{it: model 2}") m(S) offset(0.025)) ///
(margins_5, label("{it:model 3}") m(S) offset(0)) ///
(margins_8, label("{it:model 4}") m(S) offset(-0.025)) ///
(margins_3, label("{bf:New Leader,}{it: model 2}") m(T) offset(-0.25)) ///
(margins_6, label("{it:model 3}") m(T) offset(-0.275)) ///
(margins_9, label("{it:model 4}") m(T) offset(-0.30)) ///
,scheme(plotplain) xline(0) level(90) xtitle(Marginal Effect per IQR increase) ///
ytitle("Explanatory Variables") ///
ylabel(.) note("Note: Estimates are expressed as 90% confidence intervals of the change in" "the expected value of the dependent variable per interquartile range increase" "in the explantory variables. Predicted values calculated while holding" "all other explanatory variables at mean values.")
graph save PersonalismFigure2, replace

***************
**ONLINE APPENDIX/SUPPLEMENTAL ANALYSES
***************

*TABLE 1A, MODELS 1 AND 2 / MAIN RESULTS, RE-ESTIMATED IN SAMPLE COVERING 1980-2010
*Model 1 - Baseline specification, post1980
xtreg pers_2pl l2.oil_new l2.lgdppc l.popmad_adj l.gwf_firstldr l.logdur i.year if year>=1980, fe robust
est store m1
*identify top 10% threshold of oil production for robustness analysis
centile oil_new if e(sample), centile(90)
*Model 2 - Baseline specification, post 1980, exclude top 10% of oil_new obs
xtreg pers_2pl l2.oil_new l2.lgdppc l.popmad_adj l.gwf_firstldr l.logdur i.year if year>=1980 & oil_new<7.848155, fe robust
est store m2
esttab m* using m1.csv, cells(b(star  fmt(%9.3f)) se(par fmt(%9.3f))) stats(N) style(tab) replace label starlevels(* 0.10 ** 0.05 *** 0.01)


*TABLE 2A, MODELS 3 AND 4 / CLUSTER STANDARD ERRORS ON COUNTRY
tsset ccode year
*First identify top 10% of producers for Model 2 robustness
qui: xtreg pers_2pl l2.oil_new l2.lincome_new l.gwf_firstldr l.logdur l.popmad_adj i.year if year>=1991, fe
centile oil_new if e(sample), centile(90)
*Model 3
xtreg pers_2pl l2.oil_new l2.lincome_new l.gwf_firstldr l.logdur l.popmad_adj i.year l2.in_pctgdp l2.tax if year>=1991, fe
est store r3
*Model 4
xtreg pers_2pl l2.oil_new l2.lincome_new l.gwf_firstldr l.logdur l.popmad_adj i.year l2.in_pctgdp l2.tax if year>=1991 & oil_new<=8.09, fe
est store r4

*TABLE 2A, MODELS 5 AND 6 / CLUSTER STANDARD ERRORS ON LEADER
tsset gwf_leaderid year
*First identify top 10% of producers for Model 4 robustness
qui: xtreg pers_2pl l2.oil_new l2.lincome_new l.logdur l.popmad_adj i.year if year>=1991, fe
centile oil_new if e(sample), centile(90)
*Model 5
xtreg pers_2pl l2.oil_new l2.lincome_new l.logdur l.popmad_adj i.year l2.in_pctgdp l2.tax if year>=1991, fe
est store r5
*Model 6
xtreg pers_2pl l2.oil_new l2.lincome_new l.logdur l.popmad_adj i.year l2.in_pctgdp l2.tax if year>=1991 & oil_new<=8.11, fe
est store r6

esttab r* using r1.csv, cells(b(star  fmt(%9.3f)) se(par fmt(%9.3f))) stats(N) style(tab) replace label starlevels(* 0.10 ** 0.05 *** 0.01)


*TABLE 3A / INCORORATING UNCERTAINTY IN THE LATENT DEPENDENT VARIABLE
/*
See replication code and data in R
R script "Fails_ReplicationCode_PSRM_Appendix_TableA3.R"
Data files "AppModel7.csv" and "AppModel8.csv"
*/


*TABLE 4A / SUMMARY DESCRIPTIVE STATISTICS
tsset gwf_caseid year
*Full sample
qui: xtreg pers_2pl l2.oil_new l2.lgdppc l.popmad_adj l.gwf_firstldr l.logdur i.year if year>=1980, fe robust 
sum pers_2pl l2.oil_new l2.lgdppc l.popmad_adj l.gwf_firstldr l.logdur if e(sample)
*Post Cold War sample
qui: xtreg pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur i.year if year>1991, fe robust
sum pers_2pl l2.oil_new l2.lincome_new l.popmad_adj l.gwf_firstldr l.logdur l.in_pctgdp l.tax if e(sample)


****************
****************
log close
translate Fails_PSRM_Log.smcl Fails_PSRM_Log_PDF.pdf, replace

