

	// This do-file generates the following tables and figures in Gottlieb et al. (2018):
	// Table 1, Appendix Tables A1, A5, A7, and A13 through A17

	clear
	set more off
	
	// Turn on/off these locals to produce the relevant tables
	loc table1=1
	loc tableA1=1
	loc tableA5=1
	loc tableA7=1
	loc tableA13=1
	loc tableA14=1
	loc tableA15=1
	loc tableA16=1
	loc tableA17=1
	
	// Turn on/off this local to export tables to .tex format
	loc export_table=1
	
	use "Data\data_villages_senegal"
	
	///////////////////////////////////////////////////////////////////////////////
	// Table 1: Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups //
	///////////////////////////////////////////////////////////////////////////////	
	
	if `table1'==1 {

	estimates clear
	
	eststo: reg newCR dum_mouride_tpp dum_tpp_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg localgoods2009 dum_mouride_tpp dum_tpp_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg nationalgoods2009 dum_mouride_tpp dum_tpp_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg newCR dum_mouride_tpp dum_tpp_mouride l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg localgoods2009 dum_mouride_tpp dum_tpp_mouride localgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg nationalgoods2009 dum_mouride_tpp dum_tpp_mouride nationalgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	
	if `export_table'==1 {
	esttab using "Tables\Table1.tex", keep(dum_mouride_tpp dum_tpp_mouride localgoods2000 nationalgoods2000) ///
	b(3) se(3) ar(3) noomitted title("Effect of All Groups" \label{Table1}) scalars("controls Controls") style(tex) label replace
	}
	est clear
	}

	
	/////////////////////////////////////////////////////
	// Table A1: Share of Total Villages with Majority //
	/////////////////////////////////////////////////////		
	
	if `tableA1'==1 {
	
	preserve
	gen dum_nontpp_nonmouride=1-dum_mouride_tpp-dum_tpp_mouride
	
	foreach var of varlist dum_se_over18_Diola - dum_sr_over18_OtherM dum_mouride_tpp dum_tpp_mouride dum_nontpp_nonmouride{

		egen mean_`var' = mean(`var')
		egen mean_newCR_`var' = mean(`var') if newCR == 1
		egen mean_oldCR_`var' = mean(`var') if oldCR == 1
		
	}

	summ mean_*	
	restore
	}
	
	//////////////////////////////////////////////////
	// Table A5: Villages and CRs affected by split //
	//////////////////////////////////////////////////		
	
	if `tableA5'==1 {
	
	tab villchange2008
	tab villchange2010
	tab villchange2011
	
	sum villchange*
	
	preserve
	collapse (max) villchange*, by(RegionName RegionCode DepartmentName DepartmentName CRName CRCode)
	tab villchange2008
	tab villchange2010
	tab villchange2011
	restore
	
	preserve
	gen population=exp(l_pop_census_over18)
	egen totalpopulation_08=total(population) if villchange2008==1
	sum totalpopulation_08
	egen totalpopulation_10=total(population) if villchange2010==1
	sum totalpopulation_10
	egen totalpopulation_11=total(population) if villchange2011==1
	sum totalpopulation_11
	restore
	}	
	
	/////////////////////////////////////////////////
	// Table A7: Public goods - Summary Statistics //
	/////////////////////////////////////////////////		
	
	if `tableA7'==1 {
	
	preserve
		
	gen delta_localgoods=localgoods2009-localgoods2000
	lab var delta_localgoods "$\Delta$ Local Goods"
	gen delta_nationalgoods=nationalgoods2009-nationalgoods2000
	lab var delta_nationalgoods "$\Delta$ National Goods"
	gen population=exp(l_pop_census_over18)	
	lab var population "Village population (over 18)"
	lab var l_pop_census_over18 "Log population (over 18)"	
		
	estpost summarize newCR oldCR distance2002 ///
	localgoods2000 localgoods2009 delta_localgoods nationalgoods2000 nationalgoods2009 delta_nationalgoods population l_pop_census_over18 wealth_index religion_distance ethnic_distance

	esttab using "Tables\TableA7.tex", cells("count mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") title("Public Goods Summary Statistics" \label{apptable1.1}) label noobs replace	
	
	restore
	}
	
	//////////////////////////////////////////////////////
	// Table A13: Share of Total Villages with Majority //
	//////////////////////////////////////////////////////		
	
	if `tableA13'==1 {
	
	preserve
	collapse herf_eth_pre herf_rel_pre, by(CRCode)
	summ herf_eth_pre herf_rel_pre
	restore

	preserve
	collapse herf_eth_newCR herf_rel_newCR, by(xcap2008 ycap2008)
	summ herf_eth_newCR herf_rel_newCR
	restore


	preserve
	collapse herf_eth_oldCR herf_rel_oldCR, by(CRCode)
	summ herf_eth_oldCR herf_rel_oldCR
	restore

	ttest herf_eth_newCR = herf_eth_pre
	ttest herf_eth_oldCR = herf_eth_pre

	ttest herf_rel_newCR = herf_rel_pre
	ttest herf_rel_oldCR = herf_rel_pre
	
	}
	
	////////////////////////////////////////////////////////////////////
	// Table A14: Effect of Non-Political Factors on Future CR Change //
	////////////////////////////////////////////////////////////////////	

	if `tableA14'==1 {
	
	estimates clear
	
	gen good = .
	lab var distance2002 "Distance"
	
	foreach var of varlist localgoods2000 nationalgoods2000 wealth_index l_pop_census_over18 religion_distance ethnic_distance {

		replace good = `var'
		
		eststo: areg newCR `var', absorb(CRCode) vce(cluster CRCode)
		estadd local controls "No"
		preserve
		replace distance2002 = log(distance2002+1)
		eststo: areg newCR c.`var'##c.distance2002, absorb(CRCode) vce(cluster CRCode)
		estadd local controls "No"
		restore
		eststo: areg newCR c.`var'##c.distance2002, absorb(CRCode) vce(cluster CRCode)
		estadd local controls "No"


	}

	esttab est1 est2 est3 est4 est5 est6 using "Tables\TableA14a.tex", b(3) se(3) ar(3) order(distance2002) title("Effect of Non-Political Factors on Future CR Change" \label{tableA14a}) scalars("controls Controls") style(tex) label replace
	esttab est7 est8 est9 est10 est11 est12 using "Tables\TableA14b.tex", b(3) se(3) ar(3) order(distance2002) title("Effect of Non-Political Factors on Future CR Change" \label{tableA14b}) scalars("controls Controls") style(tex) label replace
	esttab est13 est14 est15 est16 est17 est18 using "Tables\TableA14c.tex", b(3) se(3) ar(3) order(distance2002) title("Effect of Non-Political Factors on Future CR Change" \label{tableA14c}) scalars("controls Controls") style(tex) label replace
	est clear
	drop good
	}	
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// Table A15: Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups (Excluding Mbacke)//
	///////////////////////////////////////////////////////////////////////////////////////////////////		
	
	if `tableA15'==1 {
	
	estimates clear
	
	eststo: reg newCR dum_mouride_tpp dum_tpp_mouride if DepartmentName!="MBACKE", vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg localgoods2009 dum_mouride_tpp dum_tpp_mouride if DepartmentName!="MBACKE", vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg nationalgoods2009 dum_mouride_tpp dum_tpp_mouride if DepartmentName!="MBACKE", vce(cluster CRCode)
	estadd local controls "No" 

	eststo: reg newCR dum_mouride_tpp dum_tpp_mouride l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu if DepartmentName!="MBACKE", vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg localgoods2009 dum_mouride_tpp dum_tpp_mouride localgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu if DepartmentName!="MBACKE", vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg nationalgoods2009 dum_mouride_tpp dum_tpp_mouride nationalgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu if DepartmentName!="MBACKE", vce(cluster CRCode)
	estadd local controls "Yes" 
	
	if `export_table'==1 {	
	esttab est1 est2 est3 est4 est5 est6 using "Tables\TableA15.tex", ///
	b(3) se(3) ar(3) noomitted drop(l_*) title("Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups (Excluding Mbacke)" \label{tableA15}) ///
	style(tex) label replace
	est clear
	}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Table A16: Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups (Alternative Definitions)//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	if `tableA16'==1 {
		
	estimates clear	
		
	eststo: reg newCR dum_mouride_tp1 dum_tp1_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg localgoods2009 dum_mouride_tp1 dum_tp1_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg nationalgoods2009 dum_mouride_tp1 dum_tp1_mouride, vce(cluster CRCode)
	estadd local controls "No" 

	eststo: reg newCR dum_mouride_tp1 dum_tp1_mouride l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg localgoods2009 dum_mouride_tp1 dum_tp1_mouride localgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg nationalgoods2009 dum_mouride_tp1 dum_tp1_mouride nationalgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 

	if `export_table'==1 {	
	esttab est1 est2 est3 est4 est5 est6 using "Tables\TableA16a.tex", ///
	b(3) se(3) ar(3) noomitted drop(l_*) title("Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups (Alternative Definitions)" \label{tableA16a}) ///
	style(tex) label replace
	est clear
	}	
		
	estimates clear
		
	eststo: reg newCR dum_mouride_tp2 dum_tp2_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg localgoods2009 dum_mouride_tp2 dum_tp2_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg nationalgoods2009 dum_mouride_tp2 dum_tp2_mouride, vce(cluster CRCode)
	estadd local controls "No" 

	eststo: reg newCR dum_mouride_tp2 dum_tp2_mouride l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg localgoods2009 dum_mouride_tp2 dum_tp2_mouride localgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg nationalgoods2009 dum_mouride_tp2 dum_tp2_mouride nationalgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 

	if `export_table'==1 {	
	esttab est1 est2 est3 est4 est5 est6 using "Tables\TableA16b.tex", ///
	b(3) se(3) ar(3) noomitted drop(l_*) title("Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups (Alternative Definitions)" \label{tableA16a}) ///
	style(tex) label replace
	est clear
	}	
	
	}
			
		
	///////////////////////////////////////////////////////////////////////////////
	// Table A17: Electoral Targeting of Mouride and Toucouleur/Peul/Pulaar Groups //
	///////////////////////////////////////////////////////////////////////////////	

	if `tableA17'==1 {
		
	forvalues cutoff = 6/8 {
		
	estimates clear
	
	preserve

	foreach var of varlist mouride_tpp tpp_mouride {
		
		drop dum_`var' 
		gen dum_`var' = 0
		replace dum_`var' = 1 if share_`var' > 0.`cutoff' & share_`var' != .
		local x: var label `var'
		label var dum_`var' "`x'"

	}	
		
		
	eststo: reg newCR dum_mouride_tpp dum_tpp_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg localgoods2009 dum_mouride_tpp dum_tpp_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg nationalgoods2009 dum_mouride_tpp dum_tpp_mouride, vce(cluster CRCode)
	estadd local controls "No" 
	eststo: reg newCR dum_mouride_tpp dum_tpp_mouride l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg localgoods2009 dum_mouride_tpp dum_tpp_mouride localgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	eststo: reg nationalgoods2009 dum_mouride_tpp dum_tpp_mouride nationalgoods2000 l_pop_census_over18 l_a_radio-l_a_building l_a_radio_sq-l_a_building_cu, vce(cluster CRCode)
	estadd local controls "Yes" 
	
	if `export_table'==1 {
	esttab est1 est2 est3 est4 est5 est6 using "Tables\TableA17_cutoff`cutoff'0.tex", b(3) se(3) ar(3) noomitted drop(l_*) title("Targeting of Mouride and Toucouleur/Peul/Pulaar Groups (Cutoff = 0.`cutoff')" \label{tableA17_c`cutoff'0}) style(tex) label replace
	est clear
	}

	restore

	}
	}

	
