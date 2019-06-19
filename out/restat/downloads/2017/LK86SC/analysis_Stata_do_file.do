

cd "~/your working directory/"

use data_off_the_charts.dta

***keep only prospects with 0 lowert outcomes for main analysis:
keep if low==0



********************************************************************************************
***Section 3.1: Descriptive results
********************************************************************************************

***create summary measures at the individual and country levels:
sort subject_global loss
by subject_global loss: egen mean_apremium = mean(apremium)

sort country loss
by country loss: egen country_apremium = mean(mean_apremium)


***create figures 2a and 2b (nonparametric summary results by country for gains and losses):
gen high_p=.
gen low_p=.

forvalues i=1(1)16 {
ci apremium if equiv_nr==`i'
replace low_p = r(lb) if equiv_nr == `i'
replace high_p = r(ub)  if equiv_nr == `i'
}

gen high_cg=.
gen low_cg=.

forvalues i=1(1)30 {
ci mean_apremium if country==`i' & loss==0
replace low_cg = r(lb) if country == `i' & loss==0
replace high_cg = r(ub)  if country == `i' & loss==0
}

forvalues i=1(1)30 {
ci mean_apremium if country==`i' & loss==1
replace low_cg = r(lb) if country == `i' & loss==1
replace high_cg = r(ub)  if country == `i' & loss==1
}

graph tw (bar country_apremium country if subject==1 & loss==0, color(eltgreen) ylabel(.02(0.02)0.14)/*
*/xlabel(1 "Australia" 2 "Belgium" 3 "Brazil" 4 "Cambodia" 5 "Chile" 6 "China" 7 "Colombia" 8 "Costa Rica" 9 "Czech Republic" 10 "Ethiopia" 11 "France" 12 "Germany" 13 "Guatemala" 14 "India" 15 "Japan" 16 "Kyrgyzstan" 17 "Malaysia" 18 "Nicaragua" 19 "Nigeria" 20 "Peru" 21 "Poland" 22 "Russia" 23 "Saudi Arabia" 24 "South Africa" 25 "Spain" 26 "Thailand" 27 "Tunisia" 28 "UK" 29 "USA" 30 "Vietnam", angle(45)))/*
*/(rcap high_cg low_cg country if subject==1  & loss==0, lcolor(green))/*
*/(function y=0, lcolor(red) lwidth(thick) range(0 31))/*
*/, legend(ring(0) position(7) row(1) order(2 "95% CI")) xtitle("") ytitle("average ambiguity premium per country, gains")
graph export graph_aa_country_gains.png, as(eps) preview(off) replace


graph tw (bar country_apremium country if subject==1 & loss==1, color(eltgreen) ylabel(-.14(0.02)0.02)/*
*/xlabel(1 "Australia" 2 "Belgium" 3 "Brazil" 4 "Cambodia" 5 "Chile" 6 "China" 7 "Colombia" 8 "Costa Rica" 9 "Czech Republic" 10 "Ethiopia" 11 "France" 12 "Germany" 13 "Guatemala" 14 "India" 15 "Japan" 16 "Kyrgyzstan" 17 "Malaysia" 18 "Nicaragua" 19 "Nigeria" 20 "Peru" 21 "Poland" 22 "Russia" 23 "Saudi Arabia" 24 "South Africa" 25 "Spain" 26 "Thailand" 27 "Tunisia" 28 "UK" 29 "USA" 30 "Vietnam", angle(45)))/*
*/(rcap high_cg low_cg country if subject==1  & loss==1, lcolor(green))/*
*/(function y=0, lcolor(red) lwidth(thick) range(0 31))/*
*/, legend(ring(0) position(5) row(1) order(2 "95% CI")) xtitle("") ytitle("average ambiguity premium per country, losses")
graph export graph_aa_country_losses.png, as(eps) preview(off) replace



***create figure 3 (ambiguity aversion by probability):
sort loss probability
by loss probability: egen prob_apremium = mean(apremium) if low==0

gen category = .
replace category=1 if loss==0 & probability==0.125
replace category=2 if loss==1 & probability==0.125

replace category=4 if loss==0 & probability==0.25
replace category=5 if loss==1 & probability==0.25

replace category=7 if loss==0 & probability==0.375
replace category=8 if loss==1 & probability==0.375

replace category=10 if loss==0 & probability==0.625
replace category=11 if loss==1 & probability==0.625

replace category=13 if loss==0 & probability==0.75
replace category=14 if loss==1 & probability==0.75

replace category=16 if loss==0 & probability==0.875
replace category=17 if loss==1 & probability==0.875

graph tw (bar prob_apremium category if loss==0 & low==0 & subject==1,/*
*/xlabel(1.5 "0.125" 4.5 "0.250" 7.5 "0.375" 10.5 "0.625" 13.5 "0.750" 16.5 "0.875") ylabel(-0.08(0.02).14) color(eltgreen))/*
*/(bar prob_apremium category if loss==1 & low==0 & subject==1, color(olive))/*
*/(rcap high_p low_p category if low==0 & subject==1, lcolor(green))/*
*/(function y=0, lcolor(red) lwidth(thick) range(0 18))/*
*/, legend(order(1 "ambiguity aversion for gains" 2 "ambiguity seeking for losses" 3 "95% CI") ring(0) position(11) row(3) size(small))  xtitle("probability") ytitle("normalised ambiguity premium")
graph export graph_aa_probability.png, as(eps) preview(off) replace



********************************************************************************************
***Section 3.2: Ambiguity aversion and a-insesitivity by country
********************************************************************************************

gen prob_cent = probability - 0.5


***obtain random intercepts and random slopes for gains
mixed apremium prob_cent || country: prob_cent || subject_global: if gain==1, robust

predict prob_slope_g intercept_g_c intercept_g_s, reffects

gen int_gain = _b[_cons] + intercept_g_c
gen coeff_prob = _b[prob_cent] + prob_slope_g



***obtain random intercepts and random slopes for losses
mixed apremium prob_cent || country: prob_cent || subject_global: if loss==1, robust

predict prob_slope_l intercept_l_c intercept_l_s, reffects

gen int_loss = _b[_cons] + intercept_l_c
gen coeff_prob_l = _b[prob_cent] + prob_slope_l


***Figure 4a: scatter plot of intercepts

gen pos1 = 12
replace pos1 = 7 if country_name == "Saudi Arabia"
replace pos1 = 12 if country_name == "Brazil"
replace pos1 = 6 if country_name == "Tunisia"
replace pos1 = 3 if country_name == "Germany"
replace pos1 = 4 if country_name == "Costa Rica"
replace pos1 = 6 if country_name == "UK"
replace pos1 = 1 if country_name == "Kyrgyzstan"
replace pos1 = 1 if country_name == "Colombia"
replace pos1 = 6 if country_name == "Japan"
replace pos1 = 6 if country_name == "China"
replace pos1 = 10 if country_name == "USA"
replace pos1 = 7 if country_name == "Spain"
replace pos1 = 5 if country_name == "Russia"
replace pos1 = 4 if country_name == "Poland"
replace pos1 = 12 if country_name == "Guatemala"
replace pos1 = 6 if country_name == "South Africa"
replace pos1 = 5 if country_name == "Vietnam"

*without Cambodia
tw (scatter int_gain int_loss if subject==5 & equiv_nr==1 & country_name!="Cambodia", mlabel(country_code) mlabv(pos1) mlabcolor(black) mcolor(blue) msize(medium))/*
*/ (lfit int_gain int_loss if subject==5 & equiv_nr==1 & country_name!="Cambodia", lcolor(green) lwidth(normal))/*
*/ (function y = -x, range(-0.05 0) lcolor(black) lpattern(-) lwidth(thin) xline(0, lwidth(vthin)) yline(0, lwidth(vthin)))/*
*/, legend(ring(0) position(7) row(2) order(2 "fitted line" 3 "45¡ line")) xtitle("ambiguity seeking, losses") ytitle("ambiguity aversion, gains") xlabel(-0.05(0.02)0.005) ylabel(0(0.02)0.12)
graph export scatter_intercepts_redux.png, as(eps) preview(off) replace

spearman int_gain int_loss if subject==5 & equiv_nr==3
spearman int_gain int_loss if subject==5 & equiv_nr==1 & country_name!="Cambodia"


***Figure 4b: random slopes probability (a-insensitivity)

gen pos2 = 12
replace pos2 = 3 if country_name == "Colombia"
replace pos2 = 5 if country_name == "Australia"
replace pos2 = 6 if country_name == "Brazil"
replace pos2 = 5 if country_name == "Chile"
replace pos2 = 5 if country_name == "Guatemala"
replace pos2 = 3 if country_name == "Germany"
replace pos2 = 6 if country_name == "South Africa"
replace pos2 = 3 if country_name == "Ethiopia"

tw (scatter coeff_prob coeff_prob_l if subject==1 & equiv_nr==1 & country_name!="Cambodia", mlabel(country_code) mlabv(pos2) mlabcolor(black) mcolor(blue) msize(medium))/*
*/ (lfit coeff_prob coeff_prob_l  if subject==1 & equiv_nr==1 & country_name!="Cambodia", lcolor(green) lwidth(normal))/*
*/ (function y = x, range(-0.05 .25) lcolor(black) lpattern(-) lwidth(thin) xline(0, lwidth(vthin)) yline(0, lwidth(vthin)))/*
*/, legend(off) xtitle("a-insensitivity, losses") ytitle("a-insensitivity, gains") xlabel(-0.05(0.05)0.25) ylabel(0(0.05)0.3)
graph export "/Users/nando/Dropbox/Ambiguity around the world/paper/graph_scatter_slopes.eps", as(eps) preview(off) replace


spearman coeff_prob coeff_prob_l if subject==3 & equiv_nr==3
spearman coeff_prob coeff_prob_l if subject==3 & equiv_nr==3 & country_name!="Cambodia"



********************************************************************************************
***Section 3.3: Explaining residual variance (within-subjects)
********************************************************************************************

gen over_05 = 0
replace over_05 = 1 if probability >0.5

***regressions and model tests for gains
mixed apremium || country: || subject_global: if gain==1, robust
estimates store premia0_g


mixed apremium probability || country: || subject_global: if gain==1, robust
estimates store premia1_g


mixed apremium probability over_05 || country: || subject_global: if gain==1, robust
estimates store premia2_g

lrtest premia2_g premia1_g, force


mixed apremium probability over_05 || country: || subject_global: probability over_05 if gain==1, robust
estimates store premia3_g

lrtest premia3_g premia2_g, force



***regressions and model tests for losses:

mixed apremium || country: || subject_global: if loss==1, robust
estimates store premia0_l


mixed apremium probability || country: || subject_global: if loss==1, robust
estimates store premia1_l


mixed apremium probability over_05 || country: || subject_global: if loss==1, robust
estimates store premia2_l

lrtest premia2_l premia1_l, force


mixed apremium probability over_05 || country: || subject_global: probability over_05 if loss==1, robust
estimates store premia3_l

lrtest premia3_l premia2_l, force


***create table 2:
esttab premia0_g premia1_g premia2_g premia3_g  premia0_l premia1_l premia2_l premia3_l using table_within_gainloss.tex, replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label nogaps nodepvars /*
*/ scalars(N N_clust ll) transform(ln*: exp(@)^2 exp(@)^2 at*: tanh(@) (1-tanh(@)^2))




********************************************************************************************
***Section 3.4: Explaining individual variance
********************************************************************************************

gen female_prob = female*probability
gen female_loss = female*loss
gen age_prob = age_z*probability
gen age_loss = age_z*loss
gen gpa_prob = gpa_z*probability
gen gpa_loss = gpa_z*loss
gen math_prob = math*probability
gen math_loss = math*loss
gen natural_prob = natural*probability
gen natural_loss = natural*loss
gen medicine_prob = medicine*probability
gen medicine_loss = medicine*loss
gen social_prob = social*probability
gen social_loss = social*loss
gen humanities_prob = humanities*probability
gen humanities_loss = humanities*loss
gen arts_prob = arts*probability
gen arts_loss = arts*loss
gen other_prob = other*probability
gen other_loss = other*loss
gen power_prob = power_norm*probability
gen ind_prob = individualism_norm*probability
gen avoid_prob = avoidance_norm*probability
gen masc_prob = masculinity_norm*probability
gen power_loss = power_norm*loss
gen ind_loss = individualism_norm*loss
gen avoid_loss = avoidance_norm*loss
gen masc_loss = masculinity_norm*loss


local within "probability over_05"
mixed apremium `within' || country: || subject_global: if gain==1, robust
estimates store ind0_g

local within "probability over_05"
mixed apremium `within' || country: || subject_global: if loss==1, robust
estimates store ind0_l


local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local within "probability over_05"
mixed apremium `bio' `study' `within' || country: || subject_global: if gain==1, robust
estimates store ind1_g

local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local within "probability over_05"
mixed apremium `bio' `study' `within' || country: || subject_global: if loss==1, robust
estimates store ind1_l

lrtest ind1_g ind0_g, force
lrtest ind1_l ind0_l, force


local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local Hofstede "power_norm individualism_norm avoidance_norm masculinity_norm"
local within "prob_cent over_05"
mixed apremium `bio' `study' `Hofstede' `within' || country: || subject_global: if gain==1, robust
estimates store ind2_g


local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local Hofstede "power_norm individualism_norm avoidance_norm masculinity_norm"
local within "probability over_05"
mixed apremium `bio' `study' `Hofstede' `within' || country: || subject_global: if loss==1, robust
estimates store ind2_l

lrtest ind2_g ind1_g, force
lrtest ind2_l ind1_l, force

lrtest ind2_g ind0_g, force
lrtest ind2_l ind0_l, force


local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local Hofstede "power_norm individualism_norm avoidance_norm masculinity_norm"
local crossed_bio "female_prob age_prob"
local crossed_study "gpa_prob math_prob natural_prob medicine_prob social_prob humanities_prob arts_prob other_prob"
local crossed_Hofstede "power_prob avoid_prob ind_prob masc_prob"
local within "prob_cent  over_05"
mixed apremium `bio' `study' `Hofstede' `crossed_bio' `crossed_study' `crossed_Hofstede' `within' || country: || subject_global: if gain==1, robust
estimates store ind3_g

local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local Hofstede "power_norm individualism_norm avoidance_norm masculinity_norm"
local crossed_bio "female_prob age_prob"
local crossed_study "gpa_prob math_prob natural_prob medicine_prob social_prob humanities_prob arts_prob other_prob"
local crossed_Hofstede "power_prob avoid_prob ind_prob masc_prob"
local within "prob_cent  over_05"
mixed apremium `bio' `study' `Hofstede' `crossed_bio' `crossed_study' `crossed_Hofstede' `within' || country: || subject_global: if loss==1, robust
estimates store ind3_l


lrtest ind3_g ind2_g, force
lrtest ind3_l ind2_l, force


local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local Hofstede "power_norm individualism_norm avoidance_norm masculinity_norm"
local crossed_bio "female_prob age_prob"
local crossed_study "gpa_prob math_prob natural_prob medicine_prob social_prob humanities_prob arts_prob other_prob"
local crossed_Hofstede "power_prob avoid_prob ind_prob masc_prob"
local within "prob_cent  over_05"
mixed apremium `bio' `study' `Hofstede' `crossed_bio' `crossed_study' `crossed_Hofstede' `within' || country: age_z math humanities arts || subject_global: if gain==1, robust
estimates store ind4_g

local bio "female age_z"
local study "gpa_z math natural medicine social humanities arts study_other"
local Hofstede "power_norm individualism_norm avoidance_norm masculinity_norm"
local crossed_bio "female_prob age_prob"
local crossed_study "gpa_prob math_prob natural_prob medicine_prob social_prob humanities_prob arts_prob other_prob"
local crossed_Hofstede "power_prob avoid_prob ind_prob masc_prob"
local within "prob_cent  over_05"
mixed apremium `bio' `study' `Hofstede' `crossed_bio' `crossed_study' `crossed_Hofstede' `within' || country:  age_z social humanities arts || subject_global: if loss==1, robust
estimates store ind4_l

lrtest ind4_g ind3_g, force
lrtest ind4_l ind3_l, force


***export table 3:
esttab ind1_g ind2_g ind3_g ind4_g ind1_l ind2_l ind3_l ind4_l using table_individual.tex, replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) extracol(5) label nogaps nodepvars /*
*/ scalars(N N_clust ll) transform(ln*: exp(@)^2 exp(@)^2 at*: tanh(@) (1-tanh(@)^2))



********************************************************************************************
***Section 3.5: Explaining country-level variance
********************************************************************************************

gen private=0
replace private=1 if Brazil==1 | Tunisia==1 | Malaysia==1 | Saudi==1

egen gini_z = std(gini)
gen log_GDP_PPP = ln(gdp_PPP_2011)

gen latitude_60 = distance_equator/60

egen pdiv_z = std(pdiv)
egen pdiv_sqr_z = std(pdiv_sqr)

gen prob_GDP = prob_cent*log_GDP_PPP


***regressions--these may take a while
local within "prob_cent  over_05"
local bio "female age_z gpa_z"
mixed apremium `bio' `within' || country: || subject_global: if gain==1, robust
estimates store macro0_g

local within "prob_cent over_05"
local bio "female age_z gpa_z"
mixed apremium `bio' `within' || country: || subject_global: if loss==1, robust
estimates store macro0_l


local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private"
local institutions "democ legor_uk legor_so legor_ge"
mixed apremium  `macro' `institutions' `bio' `within' || country: || subject_global: if gain==1, robust
estimates store macro1_g

local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private"
local institutions "democ legor_uk legor_so legor_ge"
mixed apremium  `macro' `institutions' `bio' `within' || country: || subject_global: if loss==1, robust
estimates store macro1_l

lrtest macro1_g macro0_g, force
lrtest macro1_l macro0_l, force


local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private opec"
local institutions "democ legor_uk legor_so legor_ge"
local genetic "pdiv_z pdiv_sqr_z"
local geo "latitude_60"
mixed apremium `macro' `institutions' `genetic' `geo'   `bio' `within' || country: || subject_global: if gain==1, robust
estimates store macro2_g


local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private opec"
local institutions "democ legor_uk legor_so legor_ge"
local genetic "pdiv_z pdiv_sqr_z"
local geo "latitude_60"
mixed apremium `macro' `institutions' `genetic' `geo'   `bio' `within' || country: || subject_global: if loss==1, robust
estimates store macro2_l

lrtest macro2_g macro1_g, force
lrtest macro2_l macro1_l, force

lrtest macro2_g macro0_g, force
lrtest macro2_l macro0_l, force


local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private opec"
local institutions "democ legor_uk legor_so legor_ge"
local genetic "pdiv_z pdiv_sqr_z"
local geo "latitude_60"
mixed apremium `macro' `institutions' `genetic' `geo' `bio' `within' prob_GDP || country: prob_cent || subject_global: if gain==1, robust
estimates store macro3_g


local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private opec"
local institutions "democ legor_uk legor_so legor_ge"
local genetic "pdiv_z pdiv_sqr_z"
local geo "latitude_60"
mixed apremium `macro' `institutions' `genetic' `geo' `bio' `within' prob_GDP || country: prob_cent || subject_global: if loss==1, robust
estimates store macro3_l

lrtest macro3_g macro2_g, force
lrtest macro3_l macro2_l, force

lrtest macro3_g macro0_g, force
lrtest macro3_l macro0_l, force



local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private opec"
local institutions "democ legor_uk legor_so legor_ge"
local genetic "pdiv_z pdiv_sqr_z"
local geo "latitude_60"
mixed apremium `macro' `institutions' `genetic' `geo' `bio' `within' prob_GDP || country: `within' || subject_global: if loss==1, robust
estimates store macro3_lbis

lrtest macro3_l macro3_lbis, force


local within "prob_cent  over_05"
local bio "female age_z gpa_z"
local macro "log_GDP_PPP gini_z private opec"
local institutions "democ legor_uk legor_so legor_ge"
local genetic "pdiv_z pdiv_sqr_z"
local geo "latitude_60"
mixed apremium `macro' `institutions' `genetic' `geo' `bio' `within' prob_GDP || country: `within' || subject_global: if gain==1, robust
estimates store macro3_gbis

lrtest macro3_g macro3_gbis, force

***create table 4:
esttab macro0_g macro1_g macro2_g macro3_g macro0_l macro1_l macro2_l macro3_lbis using table_macro.tex, replace b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) extracol(5) label nogaps nodepvars /*
*/ scalars(N N_clust ll) transform(ln*: exp(@)^2 exp(@)^2 at*: tanh(@) (1-tanh(@)^2))



***footnote 9: all pairwise tests for ambiguity and gains
forvalues i=1/30{
forvalues j=1/30{
if `i'<`j'{
ttest apremium if gain==1 & country==`i' | country==`j', by(country)
scalar test = r(p)
gen sigag`i'`j' = .
replace sigag`i'`j' = 1 if test<=0.05
replace sigag`i'`j' = 0 if test>0.05
}
}
}

egen sigtestag = rowmean(sigag130-sigag2930)
egen countag = anycount(sigag130-sigag2930), values(1)
sum sigtestag countag
*88% significantly diff
drop sigag*


***all pairwise tests for ambiguity and losses:
forvalues i=1/30{
forvalues j=1/30{
if `i'<`j'{
ttest apremium if loss==1 & country==`i' | country==`j', by(country)
scalar test = r(p)
gen sigal`i'`j' = .
replace sigal`i'`j' = 1 if test<=0.05
replace sigal`i'`j' = 0 if test>0.05
}
}
}

egen sigtestal = rowmean(sigal130-sigal2930)
egen countal = anycount(sigal130-sigal2930), values(1)
sum sigtestal countal
*89% significantly diff
drop sigal*


***same for risk
sort subject_global loss
by subject_global loss: egen mean_riskpremium = mean(ce_r)


***all pairwise tests for risk and gains:
forvalues i=1/30{
forvalues j=1/30{
if `i'<`j'{
ttest mean_riskpremium if gain==1 & country==`i' | country==`j', by(country)
scalar test = r(p)
gen sigrg`i'`j' = .
replace sigrg`i'`j' = 1 if test<=0.05
replace sigrg`i'`j' = 0 if test>0.05
}
}
}

egen sigtestrg = rowmean(sigrg130-sigrg2930)
egen countrg = anycount(sigrg130-sigrg2930), values(1)
sum sigtestrg countrg
*72% significantly diff
drop sigrg*


***all pairwise tests for risk and losses:
forvalues i=1/30{
forvalues j=1/30{
if `i'<`j'{
ttest mean_riskpremium if loss==1 & country==`i' | country==`j', by(country)
scalar test = r(p)
gen sigrl`i'`j' = .
replace sigrl`i'`j' = 1 if test<=0.05
replace sigrl`i'`j' = 0 if test>0.05
}
}
}

egen sigtestrl = rowmean(sigrl130-sigrl2930)
egen countrl = anycount(sigrl130-sigrl2930), values(1)
sum sigtestrl countrl
*75% significantly diff
drop sigrl*












