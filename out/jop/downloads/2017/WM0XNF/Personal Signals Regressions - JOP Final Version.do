clear
capture log close
cd "C:\Users\rmcmanus\Dropbox\3.2 US Signals of Support\Personal Signals Paper\Regressions" //Insert your own directory here.
use "MID Initiation Data - JOP Final Version.dta", clear
log using "Results.log", replace
set more off

// Summary Statistics //
tabstat initForceMID initMID initFatalMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for vis_us_b1 host_us_b1 words_us_b1_dum if pol_rel==1 & joiner_for!=1, statistics(mean sd median min max) column(statistics) format(%9.0g)


********************************** Results Section ********************************************

//// Table 1: Results for H1-H3 ////
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
eststo: probit initMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs peaceyrs_sq peaceyrs_cub year if pol_rel==1 & joiner!=1, cluster(dyadid)
eststo: probit initFatalMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_fat peaceyrs_fat_sq peaceyrs_fat_cub year if pol_rel==1 & joiner_fat!=1, cluster(dyadid)
eststo: probit initForceMID vis_us_b1 host_us_b1 words_us_b1_dum pact_us_b nukes_us_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=2 & ccodeb!=2, cluster(dyadid)
esttab using appendix.rtf, replace b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table 1: Main Results") mtitles("Violent MID" "Any MID" "Fatal MID" "Violent MID (US Signals Only)" )
eststo clear

//// Appendix Table A3: Additional individual major power regressions ////
eststo: probit initForceMID vis_uk_b1 pact_uk_b nukes_uk_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=200 & ccodeb!=200, cluster(dyadid)
eststo: probit initForceMID vis_fra_b1 pact_fra_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=220 & ccodeb!=220, cluster(dyadid)
eststo: probit initForceMID vis_rus_b1 pact_rus_b nukes_rus_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=365 & ccodeb!=365, cluster(dyadid)
eststo: probit initForceMID vis_chi_b1 pact_chi_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=710 & ccodeb!=710, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A3: Additional Individual Major Power Models") mtitles("UK" "France" "Russia" "China")
eststo clear

//// Table A4: Dropping Some Major Powers from the Main Visit Compilation Measure ////
gen majpowvisb1_nouk=(vis_us_b1==1 | vis_rus_b1==1 | vis_fra_b1==1 | vis_chi_b1==1)
replace majpowvisb1_nouk=. if vis_us_b1==. | vis_rus_b1==. | vis_fra_b1==. | vis_chi_b1==.
gen majpowvisb1_nofra=(vis_us_b1==1 | vis_rus_b1==1 | vis_uk_b1==1 | vis_chi_b1==1)
replace majpowvisb1_nofra=. if vis_us_b1==. | vis_rus_b1==. | vis_uk_b1==. | vis_chi_b1==.
gen majpowvisb1_nochi=(vis_us_b1==1 | vis_rus_b1==1 | vis_uk_b1==1 | vis_fra_b1==1)
replace majpowvisb1_nochi=. if vis_us_b1==. | vis_rus_b1==. | vis_uk_b1==. | vis_fra_b1==.
eststo: probit initForceMID majpowvisb1_nouk majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
eststo: probit initForceMID majpowvisb1_nofra majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
eststo: probit initForceMID majpowvisb1_nochi majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("A4: Dropping Some Major Powers from the Main Visit Compilation Measure") mtitles("Drop UK Visits" "Drop French Visits" "Drop Chinese Visits")
eststo clear

//// Additional analysis of Model 1 in Table 1 ////

* AIC, BIC, and Wald test
probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
test majpowvisb1 // Wald test
estat ic //for AIC and BIC comparison
probit initForceMID majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
estat ic //for AIC and BIC comparison of model without majpowvisb

* Average predicted probabilities for whole sample
probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
margins, at(majpowvisb1=(0 1))coeflegend post
test _b[1bn._at]=_b[2._at] //significance of difference between predicted probabilities

* Compare average marginal effects for every variable (Table A5)
probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
margins, dydx(*)

* Calculate marginal effects for each observation (Table A6)
probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
predictnl mar_eff = normalden(predict(xb))*_b[majpowvisb1]
preserve
drop if pol_rel==0 | joiner_for==1
drop if majpowvisb1==0
drop if mar_eff==.
gsort mar_eff
drop if _n>256 //identify top 1% most negative marginal effects
tab ccodeb
restore

* India example, assuming no visits
preserve
drop if pol_rel==0 | joiner_for==1
drop if majpowvisb1==.
probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
gen majpowvisb1_real=majpowvisb1
replace majpowvisb1=0
predict probMID
drop if ccodeb!=750
gen probnoMID=1-probMID
assert probnoMID>0
gen log_probnoMID=log(probnoMID) //roundabout way of multiplying with the collapse command
collapse (max) initForceMID majpowvisb1_real (sum) log_probnoMID, by(year)
gen probnoMID=exp(log_probnoMID) //probability India has no MIDs with anyone
gen probMID=1-probnoMID //probability India has at least one MID
restore

* India example, with true visit values
preserve
drop if pol_rel==0 | joiner_for==1
drop if majpowvisb1==.
probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
predict probMID
drop if ccodeb!=750
gen probnoMID=1-probMID
assert probnoMID>0
gen log_probnoMID=log(probnoMID) //roundabout way of multiplying with the collapse command
collapse (max) initForceMID majpowvisb1 (sum) log_probnoMID, by(year)
gen probnoMID=exp(log_probnoMID) //probability India has no MIDs with anyone
gen probMID=1-probnoMID //probability India has at least one MID
restore

//// Table 2: Results of H4 - H5 and Figure 1 ////
eststo: probit initForceMID majpowvisb1##majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
margins, at(majpowvisb1=0 majpowpactb=0) at(majpowvisb1=0 majpowpactb=1) at(majpowvisb1=1 majpowpactb=0) at(majpowvisb1=1 majpowpactb=1)
marginsplot, recast(bar)
graph save Graph "VisPact.gph", replace

eststo: probit initForceMID vis_us_b1##words_us_b1_dum host_us_b1 pact_us_b nukes_us_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=2 & ccodeb!=2, cluster(dyadid)
margins, at(vis_us_b1=0 words_us_b1_dum=0) at(vis_us_b1=0 words_us_b1_dum=1) at(vis_us_b1=1 words_us_b1_dum=0) at(vis_us_b1=1 words_us_b1_dum=1)
marginsplot, recast(bar)
graph save Graph "VisWords.gph", replace

gr combine VisPact.gph VisWords.gph
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table 2: Results for Hypotheses 4-5") mtitles("Testing H4" "Testing H5")
eststo clear


*************************************** Robustness Section *******************************************************

//// Table A8: Breaking down visits ////
eststo: probit initForceMID majpowvisb5_same majpowvisb5_dif majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
eststo: probit initForceMID majpowvisb1_dem majpowvisb1_aut majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
test majpowvisb1_dem=majpowvisb1_aut
eststo: probit initForceMID majpowvisb1_mil majpowvisb1_civ majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
test majpowvisb1_mil=majpowvisb1_civ
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A8: Breaking Down Visits Variable")
eststo clear

//// Table A9: Controlling for Affinity ////
egen majpow_maxs=rowmax(affinity_us_b affinity_uk_b affinity_fra_b affinity_rus_b affinity_chi_b)
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb majpow_maxs landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
eststo: probit initForceMID vis_us_b1 host_us_b1 words_us_b1_dum pact_us_b nukes_us_b affinity_us_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=2 & ccodeb!=2, cluster(dyadid)
eststo: probit initForceMID vis_rus_b1 pact_rus_b nukes_rus_b affinity_rus_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=365 & ccodeb!=365, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A9: Controlling for Affinity") mtitles("All Major Powers" "US" "Russia")
eststo clear

//// Table A10: More Controls and Ways of Addressing Treatment Selection Concerns ////

* Control for GDP, diplomatic ties, and region
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year realgdpb dip_repbi i.region if pol_rel==1 & joiner_for!=1, cluster(dyadid)

* Dyadic fixed effects
preserve
xtset dirdyadid
eststo: xtlogit initForceMID majpowvisb1 majpowpactb majpownukesb cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, fe
restore

* Control for signals to side A
eststo: probit initForceMID majpowvisb1##majpowvisa majpowpactb majpowpacta majpownukesb majpownukesa landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=2 & ccodea!=365 & ccodea!=710, cluster(dyadid)
margins, at(majpowvisb1=0 majpowvisa=0) at(majpowvisb1=0 majpowvisa=1) at(majpowvisb1=1 majpowvisa=0) at(majpowvisb1=1 majpowvisa=1)

* Coarsened exact matching
_pctile majpow_maxs, nq(20)
return list
_pctile cincb, nq(20)
return list
preserve
drop if pol_rel==0 | joiner_for==1 | majpow_maxs==. | majpowvisb1==.
cem region (1.5 2.5 3.5 4.5) min_peaceyrsb (.5 1.5 2.5) cincb (.000345 .000758 .002000 .006397 .0113343 0.0193840) demb (.5) majpowpactb (.5) majpow_maxs (0.83823531 0.8876404 0.9180327 0.954887), tr(majpowvisb1) showbreaks
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 [iweight=cem_weights], cluster(dyadid)
restore
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A10: More Controls and Ways of Addressing Treatment Selection Concerns") mtitles("Prestige Controls" "Fixed Effects" "Control for Signals to Side A" "Matched Sample")
eststo clear

//// Table A11: Evidence that Average Tourism is a Good Instrument ////
tsset dirdyadid year
replace tourism_appeal=tourism_appeal/1000
eststo: probit majpowvisb1 l.tourism_appeal l.majpowpactb l.majpownukesb l.cincb l.demb l.min_peaceyrsb l.year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
eststo: probit initForceMID tourism_appeal majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A11: Separate Regressions Showing Average Tourism is a Good Instrument") mtitles("Predicting Visits" "Predicting MID Initiation")
eststo clear

//// Table A12: Bivariate probit ////
eststo: biprobit (majpowvisb1 = l.tourism_appeal l.majpowpactb l.majpownukesb l.cincb l.demb l.min_peaceyrsb l.year) (initForceMID = majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year) if pol_rel==1 & joiner_for!=1, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A12: Bivariate Probit")
eststo clear

//// Table A13: Different Dependent Variable and Types of Visits ////
eststo: probit mct majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1, cluster(dyadid)
eststo: probit initForceMID vis_us_b1_nosum host_us_b1 words_us_b1_dum pact_us_b nukes_us_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=2 & ccodeb!=2, cluster(dyadid)
eststo: probit initForceMID vis_us_b1_dur host_us_b1 words_us_b1_dum pact_us_b nukes_us_b landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & ccodea!=2 & ccodeb!=2, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A13: Different Dependent Variable and Types of Visits")  mtitles("MCT DV" "Dropping Summits" "Capturing Duration")
eststo clear

//// Table A14: Different Samples ////

* All dyads, instead of just politically relevant ones.
eststo: relogit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if joiner_for!=1, cluster(dyadid)

* Only dyads with recent MID
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if joiner_for!=1 & pol_rel==1 & recentMID==1, cluster(dyadid)

* Split by Cold War
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if joiner_for!=1 & pol_rel==1 & year<1990, cluster(dyadid)
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if joiner_for!=1 & pol_rel==1 & year>1989, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("A14: Different Samples") mtitles("All Dyads" "Dyads with Recent MID" "Cold War" "Post-Cold War")
eststo clear




****************************** Checks Not Mentioned in Paper ******************************************


* Include joiner MIDs
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1, cluster(dyadid)

* Drop target-initiator MID years and ongoing MID years
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1 & targinitdy==0 & ongoing==0, cluster(dyadid)

* Drop Britain and France as potential targets
preserve
drop if ccodeb==200 | ccodeb==220
eststo: probit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if joiner_for!=1 & pol_rel==1, cluster(dyadid)
restore

* Rare events logit
eststo: relogit initForceMID majpowvisb1 majpowpactb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if joiner_for!=1 & pol_rel==1, cluster(dyadid)

* ATOP
eststo: probit initForceMID majpowvisb1 majpowpactatopb majpownukesb landcontig distance cinca cincb cincperc dema demb jointdem peaceyrs_for peaceyrs_for_sq peaceyrs_for_cub year if pol_rel==1 & joiner_for!=1, cluster(dyadid)
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A16: Tests Not Mentioned in Paper") mtitles("Include Joiners" "Drop Ongoing MID & Target-Initiator Dyads" "Drop Britain and France as Potential Targets" "Rare Events Logit" "ATOP Measure")
eststo clear



***********************  MID Intervention ***************************************

use "MID Intervention Data - JOP Final Version.dta", clear
drop if orig_target==0
drop if ccodeb==2 | ccodeb==365 | ccodeb==710

//// Table A15: MID Intervention Regressions ////
eststo: probit us_join vis_us_b5 words_us_b5_dum host_us_b5 pact_us_b affinity_us_b cincb cinca_total hostlev polityb if sidea_us!=1, cluster(dispnum3) 
eststo: probit uk_join vis_uk_b5 pact_uk_b affinity_uk_b cincb cinca_total hostlev polityb if sidea_uk!=1, cluster(dispnum3) 
eststo: probit fra_join vis_fra_b5 pact_fra_b affinity_fra_b cincb cinca_total hostlev polityb if sidea_fra!=1, cluster(dispnum3) 
eststo: probit rus_join vis_rus_b5 pact_rus_b affinity_rus_b cincb cinca_total hostlev polityb if sidea_rus!=1, cluster(dispnum3) 
eststo: probit chi_join vis_chi_b5 affinity_chi_b cincb cinca_total hostlev polityb if sidea_chi!=1, cluster(dispnum3) 
esttab using appendix.rtf, append b(3) se(3) lines star(* .10 ** .05 *** .01) nocon compress label title("Table A15: MID Intervention Regressions") mtitles("US" "UK" "France" "Russia" "China")
eststo clear

log close

