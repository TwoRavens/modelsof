*GENERAL INFO
	* Project: Political Competition and Public Goods Provision
	* Created by: Jessica Gottlieb
	* Date created: December 2016
	* Updated: July 20, 2017
	* Updated by: Katrina Kosec
* DO FILE INFO
	* This .do file analyzes the data from pre-election politician interviews (Nov. 2016) 

* HOUSEKEEPING
	clear
	set more off
********************************************************************************

*Construct variables

use pre-election_merged.dta, clear

generate maire=0
replace maire=1 if post=="Maire" | post=="MAIRE" | post=="Mairie" | post=="TETE DE LISTE"

generate ADEMA=0 
replace ADEMA=1 if party=="ADEMA" | party=="ADEMA "
generate URD=0 
replace URD=1 if party=="URD" | party=="URD "

capture tab cercle_int, gen(cercleFE)
tab region_int, gen(regionFE)

*Label variables

label var anderson4_2008 "Public Goods Index 2008"
label var pop_dif "Difference in Logged Population (2009-1998)"
label var paved_2008 "Percent of Local Roads Paved 2008"
label var electr_2008 "Level of Electrification 2008"
label var log1998pop "Logged Population (1998)"
label var seats_HHI_2009 "Competition, HHI (2009)"
label var seats_margin_2009 "Competition, Margin (2009)"
label var maire "Dummy - Politican is the Mayor"
label var dm_urban "Dummy - Urban Commune"
label var pavedroads08 "Kilometers of Paved Roads (2008)"
label var electricity08 "Number of Sources of National Electricity (2008)"
label var proj_2008 "NGO/Development Projects (2008)"
label var seats_HHI_2009 "HHI (2009)"
label var seats_margin_2009 "Margin of victory (2009)"

*Create macros

global controls1 pop_dif pavedroads08 electricity08   
global controls2 pop_dif pavedroads_dif electricity_dif



****************
***FIGURE A.1***
****************

label variable maire "Mayor"
label define maire 0 "Councilor" 1 "Mayor"
label values maire maire
generate constituents_budget1=personal_expenditure
label define constituents_budget1 1 "Nothing" 2 "<10 USD" 3 "10-20 USD" 4 "20-40 USD" 5 "40-100 USD" 6 ">100 USD"
label values constituents_budget1 constituents_budget1
catplot constituents_budget1 maire, recast(bar) var1opts(label(angle(45) labsize(*.8))) scheme(s1mono)
graph export "../../Graphs/distribution_private_transfers.pdf", replace



****************
***FIGURE A.2***
****************

generate campaign_costparty_usd=party_expenditure/500
label variable campaign_costparty_usd "Campaign spending in USD"
histogram campaign_costparty_usd if campaign_costparty_usd<10000, fraction by(maire) scheme(s1mono)
graph export "../../Graphs/distribution_campaign_spending.pdf", replace

pwcorr campaign_costparty_usd constituents_budget1 seats_margin_2009_dif seats_margin_2009 seats_HHI_2009_dif seats_HHI_2009 anderson4_dif anderson4_2008 anderson4_2013, sig



*************
***TABLE 3***
*************

oprobit constituents_budget1 seats_HHI_2009 log1998pop electricity08 pavedroads08 proj_2008 regionFE* maire, vce(cluster cercle_str)

oprobit constituents_budget1 seats_HHI_2009 regionFE* if e(sample)==1, vce(cluster cercle_str)
estimates store model1
oprobit constituents_budget1 seats_HHI_2009 log1998pop electricity08 pavedroads08 proj_2008 regionFE* maire, vce(cluster cercle_str)
estimates store model2
oprobit constituents_budget1 seats_margin_2009 regionFE* if e(sample)==1, vce(cluster cercle_str)
estimates store model3
oprobit constituents_budget1 seats_margin_2009 log1998pop electricity08 pavedroads08 proj_2008 regionFE* maire, vce(cluster cercle_str)
estimates store model4
esttab model1 model2 model3 model4 ///
	using "../../Tables/competition_transfers_level.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Political Competition (2009) on Monthly Constituent Spending during 2009-2016 \label{tab:competition_transfers_level})  ///
	varlabels (_cons Constant) keep(seats_HHI_2009 seats_margin_2009 log1998pop electricity08 pavedroads08 proj_2008 maire) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles nodepvars eqlabels(none) ///
	order(seats_HHI_2009 seats_margin_2009) ///
	addnote("Ordered probit models with region fixed effects and standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

