

	// This do-file generates the following tables and figures in Gottlieb et al. (2018):
	// Table 2, Appendix Tables A2, A3, A4, A6, A8-A9, A11, A12

	clear
	set more off
	
	// Turn on/off these locals to produce the relevant tables
	loc table2=1
	loc tableA2=1
	loc tableA3=1
	loc tableA4=1
	loc tabA6to9=1
	loc tableA11=1
	loc tableA12=1
	
	// Turn on/off this local to export tables to .tex format
	loc export_table=1
	
	use "Data\data_electoral_senegal"

	///////////////////////////////////////////////////////////////////////////
	// Table 2: Effect of CR Creation on Incumbent Vote Share (2007 to 2009) //
	///////////////////////////////////////////////////////////////////////////	
	
	if `table2'==1 {
		
	estimates clear
	
	eststo: areg wadediff_09_07 i.newCR_2008 i.oldCR_2008 l_pop_census_over18-l_a_building_cu wadeshare2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	preserve
	replace distance2002 = log(distance2002+1)
	gen CRdist = newCR_2008*distance2002
	eststo: areg wadediff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002 l_pop_census_over18-l_a_building_cu wadeshare2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 
	restore

	eststo: areg wadediff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002 l_pop_census_over18-l_a_building_cu wadeshare2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg wadediff_09_07 i.newCR_2008 i.oldCR_2008, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg wadediff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 
	restore

	eststo: areg wadediff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	*Export table
	if `export_table'==1 {
	#d;
	esttab using "Tables\Table2.tex", 
	b(3) se(3) ar(3) noomitted  
	keep(1.newCR_2008 distance2002 1.newCR_2008#c.distance2002 1.oldCR_2008#c.distance2002 wadeshare2007)
	order(1.newCR_2008 distance2002 1.newCR_2008#c.distance2002 1.oldCR_2008#c.distance2002 wadeshare2007) scalars("controls Controls")
	title("Effect of CR Creation on Incumbent Vote Share (2007 to 2009)" \label{table2}) style(tex) label replace;
	# delimit cr
	}
	
	}
	
	/////////////////////////////////////////////////////////////////////////////////
	// Table A2: Effect of Incumbent Vote Share (2000 to 2007) on Future CR Change //
	/////////////////////////////////////////////////////////////////////////////////	
	
	if `tableA2'==1 {
	
	estimates clear
	
	eststo: areg newCR_2008 c.wadediff_07_00 l_pop_census_over18-l_a_building_cu, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg newCR_2008 c.wadediff_07_00##c.distance2002 l_pop_census_over18-l_a_building_cu, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 
	restore

	eststo: areg newCR_2008 c.wadediff_07_00##c.distance2002 l_pop_census_over18-l_a_building_cu, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg newCR_2008 c.wadediff_07_00, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg newCR_2008 c.wadediff_07_00##c.distance2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 
	restore

	eststo: areg newCR_2008 c.wadediff_07_00##c.distance2002, absorb(CRCode) vce(cluster CRCode) 
	estadd local controls "No" 


	*Export table
	if `export_table'==1 {
	#d;
	esttab using "Tables\TableA2.tex", 
	b(3) se(3) ar(3) noomitted  
	keep(wadediff_07_00 distance2002 c.wadediff_07_00#c.distance2002)
	order(wadediff_07_00 distance2002 c.wadediff_07_00#c.distance2002) scalars("controls Controls")
	title("Effect of Incumbent Vote Share (2000 to 2007) on Future CR Change" \label{tableA2}) style(tex) label replace;
	# delimit cr
	}

	}
	
	
	///////////////////////////////////////////////////////////////////////////////////
	// Table A3: Effect of Future CR Creation on Incumbent Vote Share (2007 to 2009) //
	///////////////////////////////////////////////////////////////////////////////////	
	
	if `tableA3'==1 {
						
	estimates clear

	eststo: areg wadediff_09_07 i.newCR_2011 wadeshare2007 l_pop_census_over18-l_a_building_cu, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg wadediff_09_07 i.newCR_2011##c.distance2002 oldCR_2011#c.distance2002 wadeshare2007 l_pop_census_over18-l_a_building_cu, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 
	restore

	eststo: areg wadediff_09_07 i.newCR_2011##c.distance2002 oldCR_2011#c.distance2002 wadeshare2007 l_pop_census_over18-l_a_building_cu, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg wadediff_09_07 i.newCR_2011, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg wadediff_09_07 i.newCR_2011##c.distance2002 oldCR_2011#c.distance2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 
	restore

	eststo: areg wadediff_09_07 i.newCR_2011##c.distance2002 oldCR_2011#c.distance2002, absorb(CRCode) vce(cluster CRCode) 
	estadd local controls "No" 


	*Export table
	if `export_table'==1 {
	#d;
	esttab using "Tables\TableA3.tex", 
	b(3) se(3) ar(3) noomitted  
	keep(1.newCR_2011 distance2002 1.newCR_2011#c.distance2002 1.oldCR_2011#c.distance2002 wadeshare2007)
	order(1.newCR_2011 distance2002 1.newCR_2011#c.distance2002 1.oldCR_2011#c.distance2002 wadeshare2007) scalars("controls Controls")
	title("Effect of Future CR Creation on Incumbent Vote Share (2007 to 2009)" \label{tableA3}) style(tex) label replace;
	# delimit cr
	}
	
	}

	///////////////////////////////////////////////////////////////
	// Table A4: Effect of CR Creation on Turnout (2007 to 2009) //
	///////////////////////////////////////////////////////////////		
	
	if `tableA4'==1 {
						
	estimates clear	
	
	eststo: areg turndiff_09_07 i.newCR_2008 i.oldCR_2008 l_pop_census_over18-l_a_building_cu turnout2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg turndiff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002 l_pop_census_over18-l_a_building_cu turnout2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 
	restore

	eststo: areg turndiff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002 l_pop_census_over18-l_a_building_cu turnout2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg turndiff_09_07 i.newCR_2008 i.oldCR_2008, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg turndiff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 
	restore

	eststo: areg turndiff_09_07 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002, absorb(CRCode) vce(cluster CRCode) 
	estadd local controls "No" 

	*Export table
	if `export_table'==1 {
	#d;
	esttab using "Tables\TableA4.tex", 
	b(3) se(3) ar(3) noomitted  
	keep(1.newCR_2008 distance2002 1.newCR_2008#c.distance2002 1.oldCR_2008#c.distance2002 turnout2007)
	order(1.newCR_2008 distance2002 1.newCR_2008#c.distance2002 1.oldCR_2008#c.distance2002 turnout2007) scalars("controls Controls")
	title("Effect of CR Creation on Turnout (2007 to 2009)" \label{tableA4}) style(tex) label replace;
	# delimit cr
	}
	
	}		

	///////////////////////////////////////////
	// Table A6: Election Summary Statistics //
	///////////////////////////////////////////
	
	if `tabA6to9'==1 {
	
	estimates clear
	
	lab var wadediff_09_00 		"$\Delta$ Incumbent (2000-09)"
	lab var wadediff_07_00 		"$\Delta$ Incumbent (2000-07)"
	lab var wadediff_09_07 		"$\Delta$ Incumbent (2007-09)"
	lab var turndiff_09_00 		"$\Delta$ Turnout (2000-09)"
	lab var turndiff_07_00		"$\Delta$ Turnout (2000-07)"
	lab var pop_census_over18 	"Population (Over 18)"
	
	foreach var of varlist share_e_over18_Badiaran-share_r_over18_Tidjane {
		local newname = substr("`var'", 16, .)
		label var `var' "Share `newname'"
	}

	foreach var of varlist radio-building {
		gen share_`var' = `var'/pop_census_over18
		label var share_`var' "Share `var'"
		}

	estpost summarize newCR_2008 oldCR_2008 newCR_2011 oldCR_2011 distance2002 wadediff_09_00 wadediff_07_00 ///
		wadediff_09_07 turndiff_09_00 turndiff_07_00 wadeshare2000 wadeshare2007 turnout2000

	esttab using "Tables\TableA6.tex", cells("count mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") title("Elections Summary Statistics" \label{apptable1.1}) label noobs replace

	estpost summarize pop_census_over18 share_e_over18_Badiaran-share_r_over18_Tidjane 

	esttab using "Tables\TableA8.tex", cells("count mean(fmt(3)) sd(fmt(3)) min max(fmt(3))") title("Ethnicity Summary Statistics" \label{apptable1.2}) label noobs replace

	estpost summarize share_radio-share_building

	esttab using "Tables\TableA9.tex", cells("count mean(fmt(3)) sd(fmt(3)) min max(fmt(3))") title("Assets Summary Statistics" \label{apptable1.3}) label noobs replace

	}
	

	
	////////////////////////////////////////////
	// Table A11: Election Summary Statistics //
	////////////////////////////////////////////
	
	if `tableA11'==1 {
		
	estimates clear	
		
	drop if exprimes2_2002 != exprimes3_2002 & exprimes2_2002 != .

	eststo: areg wadediff_09_02 i.newCR_2008 i.oldCR_2008 l_pop_census_over18-l_a_building_cu wadeshare2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg wadediff_09_02 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002 l_pop_census_over18-l_a_building_cu wadeshare2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 
	restore

	eststo: areg wadediff_09_02 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002 l_pop_census_over18-l_a_building_cu wadeshare2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg wadediff_09_02 i.newCR_2008 i.oldCR_2008, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	preserve
	replace distance2002 = log(distance2002+1)
	eststo: areg wadediff_09_02 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 
	restore

	eststo: areg wadediff_09_02 i.newCR_2008##c.distance2002 i.oldCR_2008 i.oldCR_2008#c.distance2002, absorb(CRCode) vce(cluster CRCode) 
	estadd local controls "No" 
	
	*Export table
	if `export_table'==1 {
	#d;
	esttab using "Tables\TableA11.tex", 
	b(3) se(3) ar(3) noomitted  
	keep(1.newCR_2008 distance2002 1.newCR_2008#c.distance2002 1.oldCR_2008#c.distance2002 wadeshare2002)
	order(1.newCR_2008 distance2002 1.newCR_2008#c.distance2002 1.oldCR_2008#c.distance2002 wadeshare2002) scalars("controls Controls")
	title("Effect of CR Creation on Incumbent Vote Share (2002 to 2009)" \label{tableA11}) style(tex) label replace;
	# delimit cr
	}	
	
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Table A12: Effect of CR Creation on Incumbent Vote Share (Religious and Ethnic Distance) //
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	if `tableA12'==1 {
		
	estimates clear
	
	eststo: areg wadediff_09_07 i.newCR_2008 i.oldCR_2008 l_pop_census_over18-l_a_building_cu wadeshare2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg wadediff_09_07 i.newCR_2008##c.religion_distance i.oldCR_2008 i.oldCR_2008#c.religion_distance l_pop_census_over18-l_a_building_cu wadeshare2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg wadediff_09_07 i.newCR_2008##c.ethnic_distance i.oldCR_2008 i.oldCR_2008#c.ethnic_distance l_pop_census_over18-l_a_building_cu wadeshare2007, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "Yes" 

	eststo: areg wadediff_09_07 i.newCR_2008 i.oldCR_2008, absorb(CRCode) vce(cluster CRCode)
	estadd local controls "No" 

	eststo: areg wadediff_09_07 i.newCR_2008##c.religion_distance i.oldCR_2008 i.oldCR_2008#c.religion_distance, absorb(CRCode) vce(cluster CRCode) 
	estadd local controls "No" 

	eststo: areg wadediff_09_07 i.newCR_2008##c.ethnic_distance i.oldCR_2008 i.oldCR_2008#c.ethnic_distance, absorb(CRCode) vce(cluster CRCode) 
	estadd local controls "No" 


	*Export table
	if `export_table'==1 {
	#d;
	esttab using "Tables\TableA12.tex", 
	b(3) se(3) ar(3) noomitted  
	keep(1.newCR_2008 religion_distance 1.newCR_2008#c.religion_distance 1.oldCR_2008#c.religion_distance ethnic_distance 1.newCR_2008#c.ethnic_distance 1.oldCR_2008#c.ethnic_distance wadeshare2007)
	order(1.newCR_2008 religion_distance 1.newCR_2008#c.religion_distance 1.oldCR_2008#c.religion_distance ethnic_distance 1.newCR_2008#c.ethnic_distance 1.oldCR_2008#c.ethnic_distance wadeshare2007) scalars("controls Controls")
	title("Effect of CR Creation on Incumbent Vote Share (2002 to 2009)" \label{tableA12}) style(tex) label replace;
	# delimit cr
	}	
	
	}
	
	estimates clear


	
	
