***************************************************************************************************************************************************************************
* Replication analysis  
* Mustasilta, Katariina (2018) "Including chiefs, maintaining peace? Examining the effects of state - traditional governance interaction on civil peace in Sub-Saharan Africa"
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


**** Table III: Models 1-4 ****
logit onset2v414 concordant_TA peace_years peace_t2 peace_t3, cl(gwno)
eststo m1

logit onset2v414 concordant_TA polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo m2

logit onset2v414 IH IM SR peace_years peace_t2 peace_t3, cl(gwno)
eststo m3

logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo m4

esttab m1 m2 m3 m4 using tableIII.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber nogap title ("Models of intra-state conflict onset") mtitle("Model 1" "Model 2" "Model 3" "Model 4" ) star( + 0.1 *  0.05 ** 0.01 *** 0.001)

**** Predicted probabilities ****
estsimp logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
setx median
simqi, pr
setx IH 1
simqi
setx median
simqi, pr
setx dur_decay 1
simqi, pr
setx IH 1
simqi
setx median
setx Oil 1
simqi
setx median
setx nb_all_incidence 0
simqi, pr
drop b*


**** Figure 5. First difference estimate (y = 1) of key independent variables
* First difference refers to the change in the probability that y=1 when x changes from minimum to maximum value
estsimp logit onset2v414 IH IM SR polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
setx median
plotfds, discrete(IH IM SR Brit_colonyy Oil nb_all_incidence JHordinal_bin) continuous(rgdppcl_log dur_decay)  clevel(95) xline(0, lpattern(dash) lcolor(red)) scheme(s2color) ///
ylabel(1 `""Precolonial" "centralis.*""' 2`""Neighbour" "conflicts*""' 3 "Oil*" 4 `""Former British" "colony*""' 5 `""Symbolic" "recognition*""' 6 `""Institutional" "multiplicity*""' 7 `""Institutional" "hybridity*""' 8 `""Regime" "instablity"' 9 `""log GDP" "per capita""', labsize(small)) ///
title("") 
drop b*


**** Figure 6. Conditional effect of IH on conflict onset
quiet logit onset2v414 i.IH##c.dur_decay i.IM##c.dur_decay i.SR##c.dur_decay polityl politysq rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
margins, dydx(IH) at(dur_decay=(0(0.1)1)) vsquish
marginsplot, recast(line) recastci(rline) yline(0, lpattern(dash) lcolor(red)) scheme(s1mono) title("") ///
ytitle(Marginal effect on pr(conflict onset))


**** Table  IV. 
logit onset2v414 i.concordant_TA##i.Brit_colonyy polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo m5


logit onset2v414 i.TA_interaction##i.Brit_colonyy polityl politysq dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
eststo m6
esttab m5 m6 using TableIV.rtf,replace se aic obslast scalar(N_clust ll chi2 df_m r2_p)label nonumber title ("Models of intra-state conflict onset") mtitle("Model 1" "Model 2" "Model 3" ) star(*  0.10 ** 0.05 *** 0.01)



**** /// Figure 7. Interaction with Democratic binary variable

gen IHDEM = IH*Democracy
gen IMDEM = IM*Democracy
gen SRDEM = SR*Democracy


logit onset2v414 IH IM SR IHDEM IMDEM SRDEM Democracy dur_decay rgdppcl_log Oil pop_lag_log exclpop_lag ethfrac ethsq mountain nb_all_incidence_flag time_since_independ Brit_colonyy JHordinal_bin peace_years peace_t2 peace_t3, cl(gwno)
margins, dydx(IH) at (Democracy=(0(1)1)) vsquish
marginsplot, yline(0, lpattern(dash) lcolor(red)) title("") scheme(s1mono) ytitle(Marginal effect on pr(conflict onset))



