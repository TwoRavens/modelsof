 /*************************************************************************************************/
  *                                                                                               *
  *   Do file to replicate tables and appendices in                                               *
  *   “Portfolio Similarity and International Development Aid,”                                   *
  *   Forthcoming in International Studies Quarterly                                              *
  *   Authors: Christina Schneider and Jennifer Tobin*/                                           *
  *   Date: April 22, 2016                                                                        *
  *                                                                                               *
 /**************************************************************************************************/

 set more off
 
 /*Change working directory*/
cd  "C:\Users\jlt58\Dropbox\Research\Multilateral Aid Policies\ML Aid\ISQ FINAL\ISQ Data\

/*open main analytic dataset*/
use "schneider_tobin_portfolio_similarity_isq3yr.dta", clear


/*Table 1: Portfolio Similarity and Contributions*/

/*main model (Table 1, Model 1)*/
 xtabond2 fin_contributions_per    portfolio_similarity_std quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period, gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*sectoral portfolio similarity(Table 1, Model 2)*/
 xtabond2 fin_contributions_per     sector_portf_sim_std quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period , gmm(sector_portf_sim_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*predicted portfolio similarity (Table 1, Model 2)*/
 xtabond2 fin_contributions_per  predicted_commit_std   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period                                      , gmm(predicted_commit_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal


/******************************************************************/
 
/* Appendix C: summary statistics*/
sum fin_contributions_per    portfolio_similarity quoda  majpow_num  multilateral_age member  multilateral_size regional  if fin_contributions_per~=. &    portfolio_similarity_std~=. & quoda~=. &  majpow_num~=. &  multilateral_age~=. & member~=. &  multilateral_size~=. & regional~=. 

/******************************************************************/

/*Appendix D1--missing data*/

/*multiple imputation (Appendix D-1 model 1)*/
use "schneider_tobin_isq_3year_multipleimputation.dta", clear
mi estimate: xtabond2 fin_contributions_per    portfolio_similarity_std quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period, gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal


/*return to main dataset*/
use "schneider_tobin_portfolio_similarity_isq3yr.dta", clear

/*portfolio similarity missing in more than 50 percent of cases (Appendix D-1 model 2)*/
 xtabond2 fin_contributions_per    portfolio_similarity_std quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period if threshold>.49, gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

 /*portfolio similarity missing in more than 25 percent of cases (Appendix D-1 model 3)*/
 xtabond2 fin_contributions_per    portfolio_similarity_std quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period if threshold>.25, gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*Exclude cold war (Appendix D-1 model 4)*/
xtabond2 fin_contributions_per    portfolio_similarity_std   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period if   three_yr_period>10, gmm(portfolio_similarity_std , laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*5-year average (Appendix D-1 model 5)*/
use "schneider_tobin_isq_5year.dta", clear
xtabond2  fin_contributions_per  portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size  regional i.period,  gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member   multilateral_size multilateral_age  i.period regional)  twostep small  robust orthogonal

/*Yearly data (Appendix D-1 model 6)*/
use "schneider_tobin_isq_1year.dta", clear
xtabond2 fin_contributions_per  portfolio_similarity_std quoda  majpow_num  multilateral_age member  multilateral_size regional  i.year, gmm(portfolio_similarity_std, laglimits(2 .)) iv(quoda majpow_num member multilateral_size multilateral_age regional )  twostep small robust orthogonal

/*return to main dataset*/
use "schneider_tobin_portfolio_similarity_isq3yr.dta", clear

/******************************************************************/

/*Appendix D2--model specification*/

/*contemporaneous fixed effects then random effects (Appendix D-2 models 1 & 2)*/
areg fin_contributions_per    portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period , absorb(govt_id)
reg fin_contributions_per    portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period , robust

/*fixed effects and random effects with policy similarity lag (Appendix D-2 models 3 & 4)*/
areg fin_contributions_per    portfolio_similarity_std_lag   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period , absorb(govt_id)
reg fin_contributions_per     portfolio_similarity_std_lag   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period , robust

/* SGMM with Policy Similarity Lag (Appendix D-2 model 5)*/
xtabond2 fin_contributions_per   portfolio_similarity_std_lag   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period                                      , gmm(portfolio_similarity_std_lag, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal


/******************************************************************/

/*Appendix D3: Changes to DV*/

/*log of DV (Appendix D-3 model 1)*/
xtabond2 aid_commitment_ln    portfolio_similarity_std   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period, gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*disbursements (as a percentage of total disbursements) (Appendix D-3 model 2)*/
xtabond2 aid_disbursement_pctml  portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period                                      , gmm(portfolio_similarity_std , laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*log of disbursements (Appendix D-3 model 3)*/ 
xtabond2 ln_aid_disbursement portfolio_similarity_std   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period                                      , gmm(portfolio_similarity_std , eq(level) laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional i.three_yr_period, eq(level))  twostep small robust orthogonal

/*DV transformed (Appendix D-3 model 4)*/
xtabond2 fin_contrib_per_trans_ln    portfolio_similarity_std   quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period                                      , gmm(portfolio_similarity_std , eq(level) laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional i.three_yr_period, eq(level))  twostep small robust orthogonal


/***************************************************************/
/*Appendix D-4 additional controls*/


/*Dummy variable for concessional lending (Appendix D-4 model 1)*/
xtabond2 fin_contributions_per    portfolio_similarity_std   quoda  majpow_num  multilateral_age member  multilateral_size regional concessional i.three_yr_period                                      , gmm(portfolio_similarity_std , laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional concessional)  twostep small robust orthogonal

/*Including government-level controls: Unemployment, GDP Growth,  Govt. Expenditure: unemployment_donor gdp_grow  gov_exp* (Appendix D-4 model 2)*/
xtabond2 fin_contributions_per    portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional unemployment_donor gdp_grow gov_exp i.three_yr_period                                      , gmm(portfolio_similarity_std , laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional unemployment_donor gdp_grow gov_exp )  twostep small robust orthogonal


/*Different control for effectiveness of IDOs (Appendix D-4 model 3)*/
xtabond2 fin_contributions_per    portfolio_similarity_std    easterly_std efficiency_ratio  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period                                      , gmm(portfolio_similarity_std , laglimits(2 .) ) iv( easterly_std efficiency_ratio majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal


/***************************************************/
/*Appendix D5: takers vs. shapers*/

/* Exclude large donors: US, Germany, France, Japan, UK  (Appendix D-5 model 1) */
xtabond2 fin_contributions_per    portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period if govt_name~="United States" & govt_name~="Japan" & govt_name~="France" & govt_name~="Germany", gmm(portfolio_similarity_std , laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*Exclude EU donors (Appendix D-5 model 2) */
xtabond2 fin_contributions_per    portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period  if govt_name~="Australia" & govt_name~="Canada" & govt_name~="Japan" & govt_name~="New Zealand" & govt_name~="Switzerland" & govt_name~="United States"  , gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

/*Exclude EU IDOs (Appendix D-5 model 3)*/
xtabond2 fin_contributions_per    portfolio_similarity_std  quoda  majpow_num  multilateral_age member  multilateral_size regional i.three_yr_period  if ido_name~="European Development Fund" & ido_name~="European Investment Bank" & ido_name~="European Union Development", gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age regional)  twostep small robust orthogonal

 
 /* Only Global IDOs (Appendix D-5 model 4)     */
xtabond2 fin_contributions_per    portfolio_similarity_std   quoda  majpow_num  multilateral_age member  multilateral_size  i.three_yr_period  if ido_name~="African Development Bank" &  ido_name~="African Development Fund" &  ido_name~="African Solidarity Fund" &  ido_name~="Asian Development Bank" &  ido_name~="Asian Development Fund" &  ido_name~="Caribbean Development Bank" &  ido_name~="Central American Bank for Economic Integration" &  ido_name~="European Development Fund" &  ido_name~="European Investment Bank" &  ido_name~="European Union Development" &  ido_name~="Inter-American Development Bank", gmm(portfolio_similarity_std, laglimits(2 .) ) iv(quoda majpow_num member multilateral_size multilateral_age)  twostep small robust orthogonal


/***************************************************/
/*first stage of predicted estimates--appendix D6*/
use "schneider_tobin_dataforpredictions_isq.dta", clear
areg commitment_ln2 gdppc2_ln  centered_gdppc2_sq_ln population2_ln centered_pop2_sq_ln exports_imports_ln polity2 agree3un colony ldist icrg_index net_multilat_oda_ln_n2 i.year,  absorb( pairid) robust



