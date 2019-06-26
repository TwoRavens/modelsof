***************************************************************************************************************************************************************************
* Replication analysis - Appendix 
* Mustasilta, Katariina (2018) "Including chiefs, maintaining peace? Examining 
* the effects of state–traditional governance interaction on civil peace in Sub-Saharan Africa"
***************************************************************************************************************************************************************************

*use "../MustasiltaReplication.dta" 

* The analysis is performed using STATA 14. 

**** Generating disaggregated TA-state interaction categories
* IH = institutional hybridity, IM = institutional multiplicity
* SR = symbolic recognition, NR = exclusion/no recognition

gen IH=TA_interaction 
recode IH (0/2=0) (3=1)
gen IM=TA_interaction 
recode IM (0 1 3=0) (2=1)
gen SR=TA_interaction 
recode SR (0 2 3=0) (1=1)
gen NR=TA_interaction 
recode NR (1/3=0) (0=1)


*** Generating Pre-colonial centralisation binary variable
gen JHordinal_bin = JHordinal_y
replace JHordinal_bin = 0 if JHordinal_bin <= 1.46657
replace JHordinal_bin = 1 if JHordinal_bin > 1.46657

**** Relabelling variables
label variable IH "Institutional hybridity"
label variable IM "Institutional multiplicity"
label variable SR "Symbolic recognition"
label variable Inconsistent "Unconsolidated regime"
label variable Democracy "Democratic regime"
label variable rgdppcl_log "(log) GDP per capita"
label variable Oil "Oil dependency"
label variable dur_decay "Prox. regime instability"
label variable pop_lag_log "(log) Population size"
label variable ethfrac "Ethnic fractionalization"
label variable ethsq "Ethnic fractionalization sq."
label variable mountain "(log) Mountainous"
label variable nb_all_incidence "Neighbour conflict"
label variable exclpop "Ethnic exclusion"
label variable Brit_colonyy "Former British colony"
label variable time_since_independ "Time since independence"
label variable JHordinal_bin "Precolonial centralization"
label variable precol_sd "Precolonial heterogeneity"
label variable polityl "Polity score"
label variable politysq "Polity score squared"
label variable exclpop_lag "Share of ethnically excluded population"



**** 1 Descriptive statistics of the control variables 
sum polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3


**** 2.1. Model without institutional hybridity
* Model 4 without institutional hybridity
logit onset2v414 IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store withoutih
esttab withoutih using withoutIH.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("Model without IH" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
lroc

* Likelihood ratio test to see whether the model with institutional hybridity does better than the model without it
quiet logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3
est store k1
quiet logit onset2v414 IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3
est store k2
lrtest k1 k2


**** 2.2. Different state-TA interaction subcategory model specifications
quiet logit onset2v414 IH IM polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store IHIM

quiet logit onset2v414 IM polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store IM

quiet logit onset2v414 IH polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store IH

quiet logit onset2v414 IM SR NR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store SRNRIM

quiet logit onset2v414 SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store SR

quiet logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo m4

quiet logit onset2v414 IM SR NR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo NRIMSR


esttab m4 IH IM SR SRNRIM IHIM using subcateogries.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("Model 4" "IH only" "IM only" "SR only" "IH excluded" "IH and IM") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


**** 2.4 Colonial history subsets
* Former British colonies
logit onset2v414 IH IM SR nb_all_incidence_flag peace_years peace_t2 peace_t3 ///
if Brit_colonyy!=0, cl(gwno)
eststo britcol1

logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log pop_lag_log exclpop_lag mountain nb_all_incidence_flag time_since_independ JHordinal_bin peace_years peace_t2 peace_t3 ///
if Brit_colonyy!=0, cl(gwno)
eststo britcol2

* Former French colonies
logit onset2v414 IH IM SR nb_all_incidence_flag peace_years peace_t2 peace_t3 ///
if Brit_colonyy==0, cl(gwno)
eststo nonbritcol1

logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log pop_lag_log exclpop_lag mountain nb_all_incidence_flag time_since_independ JHordinal_bin peace_years peace_t2 peace_t3 ///
if Brit_colonyy==0, cl(gwno)
eststo nonbritcol2

esttab britcol1 britcol2 nonbritcol1 nonbritcol2 using colhistory.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("British colonial history" "British colonial history" "Other than British col. history" "Other than British col. history") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


**** 2.5. Interacting the independent variable with democracy binary variable
logit onset2v414 i.concordant_TA##Democracy dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo dem1


gen IHDEM = IH*Democracy
gen IMDEM = IM*Democracy
gen SRDEM = SR*Democracy


logit onset2v414 IH IM SR IHDEM IMDEM SRDEM Democracy dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo dem2

esttab dem1 dem2 using deminteraction.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("Model 1" "Model 2") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


**** 2.6 Interaction with ethnic exclusion plus high levels of ethnic exclusion excluded
logit onset2v414 i.TA_interaction##c.exclpop_lag polityl politysq dur_decay rgdppcl_log Oil pop_lag_log ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo TAethnicexcl

codebook exclpop_lag
logit onset2v414 i.TA_interaction polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3 ///
if exclpop_lag <=.14, cl(gwno)
eststo excl14

esttab TAethnicexcl excl14 using ethnic_excl.rtf, ///
replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber title ("Models of intra-state conflict onset") mtitle("TA categories and ethnic exclusion" "Excluding ethnic exclusion if >0.14" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) nogap

**** 2.7 Dropping each country

foreach n of numlist 1/42 {
	quiet logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3 if country1 !=`n', cl(gwno)
	outreg2 using "dropcountries.xls", append
	}

**** 2.8 Skewed logit model
scobit onset2v414 concordant_TA polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store scobit1

scobit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store scobit2

esttab scobit1 scobit2  using scobit.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("scobit model 2" "scobit model 4") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


**** 2.9 Controlling for pre-colonial heterogeneity
logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin precol_sd peace_years peace_t2 peace_t3, cl(gwno)
est store precol_sd
esttab precol_sd using precolsd.rtf,replace se aic obslast scalar(N_clust) label nonumber title ("Models of intra-state conflict onset") mtitle("Including precolonial heterogeneity") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)



**** 2.10 Including all onsets after one peace-year
* use "../Mustasiltareplication_allyears.dta"
drop if incidencev414==1 & onset1v414==0 
logit onset1v414 concordant_TA polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store conf1
logit onset1v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
est store conf2
esttab conf1 conf2 using conf11.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("Model 1" "Model 2" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


**** 2.11 Including the stregnth of TA
label variable TA_STRENGTH "TA strength"
label variable TA_CORRUPTION "TA corruption"

logit onset2v414 concordant_TA TA_STRENGTH peace_years peace_t2 peace_t3, cl(gwno)
eststo ta_strength1

logit onset2v414 concordant_TA TA_STRENGTH polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo ta_strength2

logit onset2v414 IH IM SR TA_STRENGTH peace_years peace_t2 peace_t3, cl(gwno)
eststo ta_strength3

logit onset2v414 IH IM SR TA_STRENGTH polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo ta_strength4

esttab ta_strength1 ta_strength2 ta_strength3 ta_strength4 using ta_strength.rtf, ///
replace se aic obslast scalar(N_clust ll chi2 df_m r2_p) nogap label b(%9.3f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
title("TA strength included") ///
note("Traditional authority strength from Afrobarometer, round 4")


**** 2.12 Pre-teatment variables only
/// only pre-treatment variables
logit onset2v414 concordant_TA mountain ethfrac ethsq time_since_independ Brit_colonyy JHordinal_bin nb_all_incidence_flag pop_lag_log peace_years peace_t2 peace_t3, cl(gwno)
eststo pre_tre1

logit onset2v414 IH IM SR mountain ethfrac ethsq Brit_colonyy time_since_independ JHordinal_bin nb_all_incidence_flag pop_lag_log peace_years peace_t2 peace_t3, cl(gwno)
eststo pre_tre2

esttab pre_tre1 pre_tre2 using pre_tre.rtf, ///
replace se aic obslast scalar(N_clust ll chi2 df_m r2_p) nogap label b(%9.3f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
title("Pre-treatment models") ///
note("Pre-treatment models") 

