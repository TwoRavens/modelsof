*12345678901234567890123456789012345678901234567890123456789012345678901234567890
capture log close
log using "AklinUrpelainenPositive.log", replace
clear all
set more off

*	************************************************************************
* 	File-Name: 	AklinUrpelainenPositive_analysis.do
*	Log:		AklinUrpelainenPositive.log
*	Date:  		04/08/2012
*	Author: 	Micha‘l Aklin (NYU) & Johannes Urpelainen (Columbia)
*	Data Used:  AklinUrpelainenPositive_coded.dta
*	Purpose:   	Replication file for "Political Competition, Path 
*				Dependence & the Strategy of Sustainable Energy Transitions"
*				AJPS, forthcoming
*				Contains the main results as well as the Appendix analyses
*	************************************************************************


*	************************************************************************
* 	1. Run the coding do file
*	************************************************************************

*	Pick the directory in which you have saved the replication package
cd ""

*	* Run the coding do file
quiet do "AklinUrpelainenPositive_coding.do"


*	************************************************************************
* 	2. Summary statistics
*	************************************************************************


quiet reg drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share
estpost summarize drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr traditional_electricity_share income_growth gdpcapk kg ki openk if e(sample) == 1
esttab using "rrtable1.tex", replace cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs label booktabs ///
title(Summary Statistics\label{rrtable1})
eststo clear

*	************************************************************************
* 	3. Analysis
*		Table 2
*		Claims made in the main text
*	************************************************************************

*	************************************************************************
* 	Table 2
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year year_dummy*
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share year_dummy*
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth year_dummy*

esttab using "rrtable2.tex", replace r2 booktabs b(3) se(3) scalars("rmse $\hat{\sigma}$") label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") title(Explaining Growth of Renewable Energy Share\label{rrtable2}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) (4) and (6) estimated with year fixed effects.")
eststo clear





*	************************************************************************
* 	Claims made in the text
*	************************************************************************

*	* Correlation between two innovation variables = .9
cor renewpc renewepopc


*	************************************************************************
* 	4. Robustness checks (APPENDIX)
*	************************************************************************


*	************************************************************************
* 	A. Using the EU definition of patents
*	************************************************************************
eststo: xtpcse drenew_capacity_nh_share lrenewepopc oilcrude_price2007dollar_bp linnovationEU_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year
eststo: xtpcse drenew_capacity_nh_share lrenewepopc oilcrude_price2007dollar_bp linnovationEU_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy*
eststo: xtpcse drenew_capacity_nh_share lrenewepopc oilcrude_price2007dollar_bp linnovationEU_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth 
eststo: xtpcse drenew_capacity_nh_share lrenewepopc oilcrude_price2007dollar_bp linnovationEU_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy*

esttab using "rrtable3.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(EU Patents\label{rrtable3}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear

*	************************************************************************
* 	B. Using moving averages
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lrenewpc oil_3year_average linnovation_x_oil3 left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year
eststo: xtpcse drenew_capacity_nh_share lrenewpc oil_3year_average linnovation_x_oil3 left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy*
eststo: xtpcse drenew_capacity_nh_share lrenewpc oil_3year_average linnovation_x_oil3 left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth
eststo: xtpcse drenew_capacity_nh_share lrenewpc oil_3year_average linnovation_x_oil3 left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy*

esttab using "rrtable4.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Oil Moving Average\label{rrtable4}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	C. Generation instead of capacity
*	************************************************************************

eststo: xtpcse drenewableshare lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year
eststo: xtpcse drenewableshare lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy*
eststo: xtpcse drenewableshare lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth
eststo: xtpcse drenewableshare lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy*

esttab using "rrtable5.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Energy Generation as Dep. Var.\label{rrtable5}) ///
addnote("Dependent Variable: $\Delta$ Renewable Generation (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear

*	************************************************************************
* 	D. Using data from 1995 to 2009
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year if year >= 1995
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy* if year >= 1995
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth if year >= 1995
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy* if year >= 1995

esttab using "rrtable6.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Post $1995$ Data\label{rrtable6}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear

*	************************************************************************
* 	E. With traditional OECD members only
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year if flag_oecd == 0
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy* if flag_oecd == 0
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth if flag_oecd == 0
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy* if flag_oecd == 0

esttab using "rrtable7.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Traditional OECD Members\label{rrtable7}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear



*	************************************************************************
* 	F. Clustering standard errors on time
*		Notice that Panel-Corrected Standard errors are not usable with
*		clusters. 
*	************************************************************************

eststo: reg drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year, cluster(year)
eststo: reg drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy*, cluster(year)
eststo: reg drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth, cluster(year)
eststo: reg drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy*, cluster(year)

esttab using "rrtable8.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Clustered Standard Errors\label{rrtable8}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with clustered standard errors (by year)." "Models (2) and (4) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	H. With AR(1) process
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year, correlation(ar1)
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy*, correlation(ar1)
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth, correlation(ar1)
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy*, correlation(ar1)

esttab using "rrtable10.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(AR(1)\label{rrtable10}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors and an AR(1)." "Models (2) and (4) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	I. Taming outliers using logs: log Innovation
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lnlrenewpc oilcrude_price2007dollar_bp lnlinnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year, pairwise
eststo: xtpcse drenew_capacity_nh_share lnlrenewpc oilcrude_price2007dollar_bp lnlinnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth , pairwise

esttab using "rrtable11.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model") title(Log (Innovation)\label{rrtable11}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors.")
eststo clear

*	************************************************************************
* 	J. Taming outliers using logs: log renewable capacity
*	************************************************************************

eststo: xtpcse dlnrenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year, pairwise
eststo: xtpcse dlnrenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth, pairwise

esttab using "rrtable12.tex", replace r2 booktabs b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model") title(Log (Dependent Variable)\label{rrtable12}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro) (log)." "All models estimated with panel-corrected standard errors.")
eststo clear


*	************************************************************************
* 	K. Using proxies for innovation (renewpc): employment in high tech
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lemployment_hightech_pc oilcrude_price2007dollar_bp lemphtpc_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share, pairwise
eststo: xtpcse drenew_capacity_nh_share lemployment_hightech_pc oilcrude_price2007dollar_bp lemphtpc_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth, pairwise

esttab using "rrtable14.tex", replace r2 booktabs b(3) se(3) scalars("rmse $\hat{\sigma}$") label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model") title(High Tech Employment\label{rrtable14}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors.")
eststo clear


*	************************************************************************
* 	L. Using high tech employment as an instrument for innovation
*	************************************************************************

eststo: ivregress 2sls drenew_capacity_nh_share oilcrude_price2007dollar_bp left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year (lrenewpc linnovation_x_oil = lemployment_hightech_pc lemphtpc_x_oil), first
eststo: ivregress 2sls drenew_capacity_nh_share oilcrude_price2007dollar_bp left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year year_dummy* (lrenewpc linnovation_x_oil = lemployment_hightech_pc lemphtpc_x_oil), first
eststo: ivregress 2sls drenew_capacity_nh_share oilcrude_price2007dollar_bp left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth (lrenewpc linnovation_x_oil = lemployment_hightech_pc lemphtpc_x_oil), first
eststo: ivregress 2sls drenew_capacity_nh_share oilcrude_price2007dollar_bp left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr gdpcapk kg ki openk year traditional_electricity_share income_growth year_dummy* (lrenewpc linnovation_x_oil = lemployment_hightech_pc lemphtpc_x_oil), first

esttab using "rrtable15.tex", replace r2 booktabs b(3) se(3) scalars("rmse $\hat{\sigma}$") label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(High Tech Employment: 2-SLS\label{rrtable15}) ///
addnote("2-stage least squares estimate; innovation is instrumented by high tech employment." "Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	M. Showing the link between policies and outcomes
*	************************************************************************

eststo: xtreg drenew_capacity_nh_share lmeanfeedin_urpelainen, fe
eststo: xtreg drenew_capacity_nh_share lmeanfeedin_urpelainen year_dummy*, fe
eststo: xtreg drenew_capacity_nh_share lmeanfeedin_urpelainen rgdpl kg ki openk income_growth renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share , fe
eststo: xtreg drenew_capacity_nh_share lmeanfeedin_urpelainen rgdpl kg ki openk income_growth renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share year_dummy*, fe

esttab using "rrtable16.tex", replace r2 booktabs b(3) se(3) scalars("rmse $\hat{\sigma}$") label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Feed-in Policies and Renewable Capcity\label{rrtable16}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with country fixed effects." "Models (2) and (4) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	N. Using country FE
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share country_dummy*
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share country_dummy* year_dummy*
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth country_dummy*
eststo: xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth country_dummy* year_dummy*

esttab using "rrtable17.tex", replace r2 booktabs b(3) se(3) label scalars("rmse $\hat{\sigma}$") star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Country FE\label{rrtable17}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) and (4) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	O. With traditional energy
*	************************************************************************

eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year year_dummy*
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year trad_electricityshare_cap_3y
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year trad_electricityshare_cap_3y year_dummy*
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year trad_electricityshare_cap_3y gdpcapk kg ki openk income_growth
eststo: xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year trad_electricityshare_cap_3y gdpcapk kg ki openk income_growth year_dummy*

esttab using "rrtable18.tex", replace r2 booktabs b(3) se(3) scalars("rmse $\hat{\sigma}$") label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Traditional Energy Share: 3 Year Moving Average\label{rrtable18}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) (4) and (6) estimated with year fixed effects.")
eststo clear


*	************************************************************************
* 	P. First stage of the 2-SLS: positive reinforcement on high tech
*		employment
*	************************************************************************

eststo: reg lrenewpc lemployment_hightech_pc 
eststo: reg lrenewpc lemployment_hightech_pc year_dummy*

esttab using "rrtable2.tex", replace r2 booktabs b(3) se(3) scalars("rmse $\hat{\sigma}$") label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model") title(Explaining Growth of Renewable Energy Share\label{rrtable2}) ///
addnote("Dependent Variable: $\Delta$ Renewable Capacity (excluding hydro)." "All models estimated with panel-corrected standard errors." "Models (2) (4) and (6) estimated with year fixed effects.")
eststo clear



*	************************************************************************
* 	6. Graphs
*	************************************************************************


*	************************************************************************
* 	A. Summary Graphs
*	************************************************************************

*	* Graph 1
graph twoway (line renewableshare year if country_aklin =="France", legend(lab(1 "France")) lpattern(dash) clcolor(black)) ///
			(line renewableshare year if country_aklin == "Germany", legend(lab(2 "Germany")) clcolor(black))	///
			, title("Share of Renewable Energy", size(4)) 	///
			graphregion(fcolor(white)) 		///
			ytitle("Share of Renewables in Energy Generation (non-hydro)", size(3.5))  ///
			saving(graph1, replace)
graph export "graph1.pdf", replace

*	* Graph 2
graph twoway (line nuclearshare year if country_aklin =="France", legend(lab(1 "France")) lpattern(dash) clcolor(black)) ///
			(line nuclearshare year if country_aklin == "Germany", legend(lab(2 "Germany")) clcolor(black))	///
			, title("Nuclear Power Share", size(4)) graphregion(fcolor(white)) ytitle("Nuclear Power Share of Electricity Generation", size(3.5)) saving(graph2, replace)
graph export "graph2.pdf", replace

*	* Graph 1 and 2 merged 
graph combine graph1.gph graph2.gph, ycommon 
graph export "graph1_2.pdf", replace


*	************************************************************************
* 	B. Marginal Effects. Based on Brambor et al (2006)'s code.
*	************************************************************************

*	************************************************************************
* 	i. Simulation for Model (3)
*	************************************************************************

xtset ccode year

*	1. Running Model (1)
xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share

*	2. Generating the range of the modifying variable (here oil price, from 0 to 100)
generate MV=((_n-1))
replace  MV=. if _n>100

*	3. Capturing the matrices (coefficient and VC matrix) to get the estimates
matrix b=e(b)
matrix V=e(V)
 
*	4. Getting the coefficient of interest
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

*	5. Getting the variance of interest (remember: these are the variance, while
*		the regression table shows the s.e. (i.e. the root of the variance)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

*	6. Getting the covariance
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

*	7. Listing the coefficients/variance/covariance to check that everything corresponds
*		to the regression output
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*	8. Estimating the marginal effect
gen conb=b1+b3*MV if _n<100

*	9. Estimating the standard error of the marginal effect
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<100

*	10. Generating the confidence interval for 95%
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

*	11. Graphing
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||,  yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Positive Reinf.") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of Pos. Reinf.", size(4)) subtitle(" " "Dependent Variable: Renewable Share (First Diff.)" " ", size(3)) xtitle( "Oil Prices", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Positive Reinforcement", size(3)) scheme(s2mono) graphregion(fcolor(white)) saving(graph3, replace)
graph export "graph3.pdf", replace as(pdf)

*	12. Dropping the newly created variables
drop MV conb conse a upper lower


*	************************************************************************
* 	ii. Simulation for Model (4), oil and innovation inversed
*	************************************************************************

xtset ccode year

*	1. Running Model (1)
xtpcse drenew_capacity_nh_share oilcrude_price2007dollar_bp lrenewpc linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share


*	2. Generating the range of the modifying variable (here innovations; now,
*		innovation goes to 10, but the vast majority is at 1 and below - 
*		the variable is innovation per 1m people). Hence, I bound it at 1.
generate MV=((_n-1)/10)
replace  MV=. if _n>30

*	3. Capturing the matrices (coefficient and VC matrix) to get the estimates
matrix b=e(b)
matrix V=e(V)
 
*	4. Getting the coefficient of interest
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

*	5. Getting the variance of interest (remember: these are the variance, while
*		the regression table shows the s.e. (i.e. the root of the variance)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

*	6. Getting the covariance
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

*	7. Listing the coefficients/variance/covariance to check that everything corresponds
*		to the regression output
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*	8. Estimating the marginal effect
gen conb=b1+b3*MV if _n<30

*	9. Estimating the standard error of the marginal effect
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<30

*	10. Generating the confidence interval for 95%
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

*	11. Graphing
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||,  yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Intern. Shocks") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of Intern. Shocks (Oil Prices)", size(4)) subtitle(" " "Dependent Variable: Renewable Share (First Diff.)" " ", size(3)) xtitle( "Positive Reinforcement (Innovations per m.)", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of International Shock (Oil Prices)", size(3)) scheme(s2mono) graphregion(fcolor(white))  saving(graph4, replace)
graph export "graph4.pdf", replace as(pdf)

*	12. Dropping the newly created variables
drop MV conb conse a upper lower

*	* Combining graph 3 and 4
graph combine graph3.gph graph4.gph	///
	, title("Marginal Effect of Oil and Positive Reinf. on Renewables", size(4)) ///
	scheme(s2mono) graphregion(fcolor(white))
graph export "graph3_4.pdf", replace


*	************************************************************************
* 	C. Employment and Patents
*	************************************************************************

*	Positive reinforcement and the number of high tech enterprise
twoway (scatter lnrenewpc employment_hightech_pc, ylabel(minmax) ylabel(0[1]3))	///
		(lfitci lnrenewpc employment_hightech_pc)	///
		, ytitle("Patents per capita (log)", axis(1))	///
		xtitle("Share of Employment in High Tech Sector")	///
		legend(label(1 "Observation"))	///
		title("High Tech Employment Share and Patents per Capita", size(4))	/// 
		scheme(s2mono) graphregion(fcolor(white))	///
		note("See manuscript for data sources. Data available for EU and neighboring countries.")
graph export "rrgraph1.pdf", replace as(pdf)

pwcorr lnrenewpc employment_hightech_pc, sig

*	************************************************************************
*	D. Positive reinforcement and the number of high tech enterprise
*	************************************************************************

twoway (scatter lnrenewpc hightech_nbr_enterprise)	///
		(lfitci lnrenewpc hightech_nbr_enterprise)	///
		, ytitle("Total Patents (log)", axis(1))	///
		xtitle("Number of Firms in High Tech Sector")	///
		legend(label(1 "Observation"))	///
		title("High Tech Firms and Patents", size(4))	/// 
		scheme(s2mono) graphregion(fcolor(white))	///
		note("See manuscript for data sources. Data available for EU.")
graph export "rrgraph2.pdf", replace as(pdf)

pwcorr lnrenewpc hightech_nbr_enterprise, sig

*	************************************************************************
*	E. Policies and renewable energy growth
*	************************************************************************

*	Graph
twoway (scatter drenew_capacity_nh_share l.meanfeedin_urpelainen if drenew_capacity_nh_share != . & l.meanfeedin_urpelainen != .) ///
		(lfitci drenew_capacity_nh_share l.meanfeedin_urpelainen if drenew_capacity_nh_share != . & l.meanfeedin_urpelainen != .)	///
		, ytitle("Change in Renewable Capacity", axis(1))	///
		xtitle("Feed-in Tariff (yearly average)")	///
		legend(label(1 "Observation"))	///
		title("Feed-In Tariffs and Renewable Energy Capcity Growth", size(4))	/// 
		scheme(s2mono) graphregion(fcolor(white))	///
		note("y-axis: yearly change in renewable energy capacity between t and t-1." "x-axis: average feed-in tariffs per country-year at t-1. See manuscript for data sources.")
graph export "rrgraph3.pdf", replace as(pdf)

*	Correlation
pwcorr drenew_capacity_nh_share l.meanfeedin_urpelainen, sig




capture log close



