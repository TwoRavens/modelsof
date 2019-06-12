*******************************************************************
******REPLICATION FILE: RACIAL ISOLATION DRIVES RACIAL VOTING******
**********************POLITICAL BEHAVIOR***************************
******************MELISSA SANDS, DANIEL DE KADT********************
*******************************************************************

******************************************
**********INDIVIDUAL ANALYSES*************
******************************************
**Set Working Dir & Call Data**
cd "C:/Users/ddeka/Dropbox/South_Africa_segregation/replication_archive/"
use "data/individual_data.dta", replace

keep white black coloured indian  year cat_b ward_id province vote vote_anc future_anc_vote white_pos vote_black_party vote_white_party white_friendly black_pos black_friendly white_white_iso wealth high_school prim_school married  sex age age_sq white_iso2011 white_frac2011 colored_frac2011 black_frac2011 white_frac1991 black_frac1991 colored_frac1991 log_popden2011 education2011 employment_broad2011 employment_narrow2011 formaldwell_proportion2011 log_income2011 log_pop2011 black_iso2011 white_frac2011 colored_frac2011 black_frac2011 white_frac1991 black_frac1991 colored_frac1991 log_popden2011 education2011 employment_broad2011 employment_narrow2011 formaldwell_proportion2011 log_income2011 log_pop2011

**Local Macros**
local indiv_covariates "wealth high_school prim_school married  sex age age_sq"
local ward_covariates "white_iso2011 white_frac2011 colored_frac2011 black_frac2011 white_frac1991 black_frac1991 colored_frac1991 log_popden2011 education2011 employment_broad2011 employment_narrow2011 formaldwell_proportion2011 log_income2011 log_pop2011"
local ward_covariates_bl "black_iso2011 white_frac2011 colored_frac2011 black_frac2011 white_frac1991 black_frac1991 colored_frac1991 log_popden2011 education2011 employment_broad2011 employment_narrow2011 formaldwell_proportion2011 log_income2011 log_pop2011"

******************************************
**************MAIN RESULTS****************
******************************************

******************************************
****************TABLE 3*******************
************INTERACTION MODELS************
******************************************
**White ISO :: Retro ANC Vote**
eststo: areg vote_anc white coloured indian white_white_iso white_iso2011 i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg vote_anc white coloured indian white_white_iso white_iso2011 `indiv_covariates' i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg vote_anc white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year if vote==1, cl(ward_id) a(cat_b)
**White ISO :: Future ANC Vote**
eststo: areg future_anc_vote white coloured indian white_white_iso white_iso2011 i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg future_anc_vote white coloured indian white_white_iso white_iso2011 `indiv_covariates'  i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg future_anc_vote white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year if vote==1, cl(ward_id) a(cat_b)
**White ISO :: Turnout**
eststo: areg vote white coloured indian white_white_iso white_iso2011 i.year , cl(ward_id) a(cat_b)
eststo: areg vote white coloured indian white_white_iso white_iso2011 `indiv_covariates' i.year , cl(ward_id) a(cat_b)
eststo: areg vote white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year , cl(ward_id) a(cat_b)
esttab using "results\individual_maineffects.tex", b(3) se(3) r2 label title(Individual Interaction Results for ANC Voting and Turnout \label{tab:indivmain}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white coloured indian white_iso2011 white_white_iso) replace star(* 0.10 ** 0.05 *** 0.01)
esttab using "results\individual_maineffects.csv", se  b( %10.0g)  se( %10.0g)  keep(white coloured indian white_iso2011 white_white_iso) nostar nopar nogaps nolines nonum nonotes noobs replace
eststo clear

******************************************
***************APPENDIX*******************
******************************************

******************************************
***************TABLE E.7******************
***********SUMMARY STATISTICS*************
******************************************
sutex vote_anc future_anc_vote vote coloured indian white wealth high_school prim_school married sex age age_sq, minmax

******************************************
***************TABLE F.8******************
************ALTERNATIVE DVs***************
******************************************
eststo: areg vote_black_party white coloured indian white_white_iso white_iso2011 i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg vote_black_party white coloured indian white_white_iso white_iso2011 `indiv_covariates' i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg vote_black_party white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year if vote==1, cl(ward_id) a(cat_b)

eststo: areg vote_white_party white coloured indian white_white_iso white_iso2011 i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg vote_white_party white coloured indian white_white_iso white_iso2011 `indiv_covariates' i.year if vote==1, cl(ward_id) a(cat_b)
eststo: areg vote_white_party white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year if vote==1, cl(ward_id) a(cat_b)
esttab using "results\individual_maineffects_recodings.tex", b(3) se(3) r2 label title(Individual Interaction Results with Alternative DV Codings \label{tab:indivmainrecoding}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white coloured indian white_iso2011 white_white_iso) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE G.9******************
********WHITES ONLY, RETRO ANC VOTE*******
******************************************
eststo: reg vote_anc white_iso2011 i.year if vote==1 & white==1, cl(ward_id) 
eststo: reg vote_anc white_iso2011 `indiv_covariates' i.year if vote==1 & white==1, cl(ward_id) 
eststo: reg vote_anc white_iso2011 `indiv_covariates' `ward_covariates' i.year if vote==1 & white==1, cl(ward_id) 

eststo: areg vote_anc white_iso2011 i.year if vote==1 & white==1, cl(ward_id) a(province)
eststo: areg vote_anc white_iso2011 `indiv_covariates' i.year if vote==1 & white==1, cl(ward_id) a(province)
eststo: areg vote_anc white_iso2011 `indiv_covariates' `ward_covariates' i.year if vote==1 & white==1, cl(ward_id) a(province)

eststo: areg vote_anc white_iso2011 i.year if vote==1 & white==1, cl(ward_id) a(cat_b)
eststo: areg vote_anc white_iso2011 `indiv_covariates' i.year if vote==1 & white==1, cl(ward_id) a(cat_b)
eststo: areg vote_anc white_iso2011 `indiv_covariates' `ward_covariates' i.year if vote==1 & white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_retroANC.tex", b(3) se(3) r2 label title(White Only Results for Retrospective ANC Voting \label{tab:indivwhitesonlyancvoteretro}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE G.10*****************
********WHITES ONLY, FUTURE ANC VOTE******
******************************************
eststo: reg future_anc_vote white_iso2011 i.year if vote==1 & white==1, cl(ward_id) 
eststo: reg future_anc_vote white_iso2011 `indiv_covariates' i.year if vote==1 & white==1, cl(ward_id) 
eststo: reg future_anc_vote white_iso2011 `indiv_covariates' `ward_covariates' i.year if vote==1 & white==1, cl(ward_id) 

eststo: areg future_anc_vote white_iso2011 i.year if vote==1 & white==1, cl(ward_id) a(province)
eststo: areg future_anc_vote white_iso2011 `indiv_covariates' i.year if vote==1 & white==1, cl(ward_id) a(province)
eststo: areg future_anc_vote white_iso2011 `indiv_covariates' `ward_covariates' i.year if vote==1 & white==1, cl(ward_id) a(province)

eststo: areg future_anc_vote white_iso2011 i.year if vote==1 & white==1, cl(ward_id) a(cat_b)
eststo: areg future_anc_vote white_iso2011 `indiv_covariates' i.year if vote==1 & white==1, cl(ward_id) a(cat_b)
eststo: areg future_anc_vote white_iso2011 `indiv_covariates' `ward_covariates' i.year if vote==1 & white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_futureANC.tex", b(3) se(3) r2 label title(White Only Results for Prospective ANC Voting \label{tab:indivwhitesonlyancvoteprospective}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE G.11*****************
***********WHITES ONLY, TURNOUT***********
******************************************
eststo: reg vote white_iso2011 i.year if white==1, cl(ward_id) 
eststo: reg vote white_iso2011 `indiv_covariates' i.year if white==1, cl(ward_id) 
eststo: reg vote white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) 

eststo: areg vote white_iso2011 i.year if white==1, cl(ward_id) a(province)
eststo: areg vote white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(province)
eststo: areg vote white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) a(province)

eststo: areg vote white_iso2011 i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg vote white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg vote white_iso2011 `indiv_covariates' `ward_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_turnout.tex", b(3) se(3) r2 label title(White Only Results for Turnout \label{tab:indivwhitesonlyturnout}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE H.12*****************
***********RACIAL SENTIMENTS**************
******************************************
eststo: areg white_pos white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year , cl(ward_id) a(cat_b)
eststo: areg white_friendly white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year , cl(ward_id) a(cat_b)
eststo: areg black_pos white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year , cl(ward_id) a(cat_b)
eststo: areg black_friendly white coloured indian white_white_iso `indiv_covariates' `ward_covariates' i.year , cl(ward_id) a(cat_b)
esttab using "results\individual_maineffects_racialsentiment.tex", b(3) se(3) r2 label title(Individual Interaction Results for Measures of racial Sentiment \label{tab:indivracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white coloured indian white_iso2011 white_white_iso) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE H.13*****************
******WHITES ONLY, RACIAL SENTIMENTS******
******************************************
eststo: reg white_pos white_iso2011 i.year if white==1, cl(ward_id) 
eststo: reg white_pos white_iso2011 `indiv_covariates' i.year if white==1, cl(ward_id) 
eststo: reg white_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) 

eststo: areg white_pos white_iso2011 i.year if white==1, cl(ward_id) a(province)
eststo: areg white_pos white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(province)
eststo: areg white_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) a(province)

eststo: areg white_pos white_iso2011 i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg white_pos white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg white_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_whitepositive.tex", b(3) se(3) r2 label title(White Only Results for Feeling Positive Toward Whites \label{tab:indivwhitesonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

eststo: reg white_friendly white_iso2011 i.year if white==1, cl(ward_id) 
eststo: reg white_friendly white_iso2011 `indiv_covariates' i.year if white==1, cl(ward_id) 
eststo: reg white_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) 

eststo: areg white_friendly white_iso2011 i.year if white==1, cl(ward_id) a(province)
eststo: areg white_friendly white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(province)
eststo: areg white_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) a(province)

eststo: areg white_friendly white_iso2011 i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg white_friendly white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg white_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_whitefriendly.tex", b(3) se(3) r2 label title(White Only Results for Feeling Friendly Toward Whites \label{tab:indivwhitesonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

eststo: reg black_pos white_iso2011 i.year if white==1, cl(ward_id) 
eststo: reg black_pos white_iso2011 `indiv_covariates' i.year if white==1, cl(ward_id) 
eststo: reg black_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) 

eststo: areg black_pos white_iso2011 i.year if white==1, cl(ward_id) a(province)
eststo: areg black_pos white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(province)
eststo: areg black_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) a(province)

eststo: areg black_pos white_iso2011 i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg black_pos white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg black_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_blackpositive.tex", b(3) se(3) r2 label title(White Only Results for Feeling Positive Toward Blacks \label{tab:indivwhitesonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

eststo: reg black_friendly white_iso2011 i.year if white==1, cl(ward_id) 
eststo: reg black_friendly white_iso2011 `indiv_covariates' i.year if white==1, cl(ward_id) 
eststo: reg black_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) 

eststo: areg black_friendly white_iso2011 i.year if white==1, cl(ward_id) a(province)
eststo: areg black_friendly white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(province)
eststo: areg black_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if white==1, cl(ward_id) a(province)

eststo: areg black_friendly white_iso2011 i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg black_friendly white_iso2011 `indiv_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
eststo: areg black_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if  white==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_whiteonly_blackfriendly.tex", b(3) se(3) r2 label title(White Only Results for Feeling Friendly Toward Blacks \label{tab:indivwhitesonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE H.13*****************
******BLACKS ONLY, RACIAL SENTIMENTS******
******************************************
eststo: reg white_pos white_iso2011 i.year if black==1, cl(ward_id) 
eststo: reg white_pos white_iso2011 `indiv_covariates' i.year if black==1, cl(ward_id) 
eststo: reg white_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) 

eststo: areg white_pos white_iso2011 i.year if black==1, cl(ward_id) a(province)
eststo: areg white_pos white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(province)
eststo: areg white_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) a(province)

eststo: areg white_pos white_iso2011 i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg white_pos white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg white_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_blackonly_whitepositive.tex", b(3) se(3) r2 label title(Black Only Results for Feeling Positive Toward Whites \label{tab:indivblacksonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

eststo: reg white_friendly white_iso2011 i.year if black==1, cl(ward_id) 
eststo: reg white_friendly white_iso2011 `indiv_covariates' i.year if black==1, cl(ward_id) 
eststo: reg white_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) 

eststo: areg white_friendly white_iso2011 i.year if black==1, cl(ward_id) a(province)
eststo: areg white_friendly white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(province)
eststo: areg white_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) a(province)

eststo: areg white_friendly white_iso2011 i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg white_friendly white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg white_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_blackonly_whitefriendly.tex", b(3) se(3) r2 label title(Black Only Results for Feeling Friendly Toward Whites \label{tab:indivblacksonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

eststo: reg black_pos white_iso2011 i.year if black==1, cl(ward_id) 
eststo: reg black_pos white_iso2011 `indiv_covariates' i.year if black==1, cl(ward_id) 
eststo: reg black_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) 

eststo: areg black_pos white_iso2011 i.year if black==1, cl(ward_id) a(province)
eststo: areg black_pos white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(province)
eststo: areg black_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) a(province)

eststo: areg black_pos white_iso2011 i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg black_pos white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg black_pos white_iso2011 `indiv_covariates' `ward_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_blackonly_blackpositive.tex", b(3) se(3) r2 label title(Black Only Results for Feeling Positive Toward Blacks \label{tab:indivblacksonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

eststo: reg black_friendly white_iso2011 i.year if black==1, cl(ward_id) 
eststo: reg black_friendly white_iso2011 `indiv_covariates' i.year if black==1, cl(ward_id) 
eststo: reg black_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) 

eststo: areg black_friendly white_iso2011 i.year if black==1, cl(ward_id) a(province)
eststo: areg black_friendly white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(province)
eststo: areg black_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if black==1, cl(ward_id) a(province)

eststo: areg black_friendly white_iso2011 i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg black_friendly white_iso2011 `indiv_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
eststo: areg black_friendly white_iso2011 `indiv_covariates' `ward_covariates' i.year if  black==1, cl(ward_id) a(cat_b)
esttab using "results\individual_nointeraction_blackonly_blackfriendly.tex", b(3) se(3) r2 label title(Black Only Results for Feeling Friendly Toward Blacks \label{tab:indivblacksonlyracialsentiment}) addnote("Standard errors clustered by municipality-year in parentheses") keep(white_iso2011) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear
