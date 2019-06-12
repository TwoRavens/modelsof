

	// This do-file generates the following tables and figures in Gottlieb et al. (2018):
	// Table 3, Table A18, Figure 3
	// The do-file uses the following user-written commands: center, reghdfe, interflex

	clear
	set more off
	
	
	// Turn on/off these locals to produce the relevant tables
	loc table3=1
	loc tableA18=1
	
	// Turn on/off this local to export tables to .tex format
	loc export_table=0

	// Use panel data on number of admin units across Africa //
	use "Data\data_adminunits_africa", replace	
		 		 
	*Data prep
	recode e_democ (-88 -77 -66 =.)

	*Standardize all variables of interest
	center e_polity2,  standardize generate(x1)
	center v2x_polyarchy,  standardize generate(x2)
	center e_democ,  standardize generate(x3)
	center prez_MoV,  standardize generate(x4)
	corr x1-x4
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Table 3: Relationship between contestation and administrative unit proliferation //
	//////////////////////////////////////////////////////////////////////////////////////

	if `table3'==1 {
	
	gen y1 = number_unitsP
		
	foreach y in y1  {
	foreach x in x1 x2 x3 x4 {
	reghdfe `y' c.`x', abs(country_id) cl(country_id)
		estadd local election "N"
		estimate store `x'_`y'_m1 
	reghdfe `y' c.`x'##c.ethnic_fractionalization, abs(country_id) cl(country_id)
		estadd local election "N"
		estimate store `x'_`y'_m2 
	}
	}
	
	if `export_table'==1 {
	foreach y in y1 {
		# delimit ; 
		esttab  x1_`y'_m1 x1_`y'_m2 x2_`y'_m1 x2_`y'_m2 
				x3_`y'_m1 x3_`y'_m2 x4_`y'_m1 x4_`y'_m2
		using "Tables/Table3.tex", replace
	keep (x1 c.x1#c.ethnic_fractionalization x2 c.x2#c.ethnic_fractionalization
		  x3 c.x3#c.ethnic_fractionalization x4 c.x4#c.ethnic_fractionalization)
	order(x1 c.x1#c.ethnic_fractionalization x2 c.x2#c.ethnic_fractionalization
		  x3 c.x3#c.ethnic_fractionalization x4 c.x4#c.ethnic_fractionalization)
				cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
				starlevels(* .10 ** .05 *** .01) 					
				mgroups("\textbf{Polity2}" "\textbf{Polyarchy}" "\textbf{Democracy}" "\textbf{MoV}", pattern(1 0 1 0 1 0 1 0)
				span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
				varlabels(x1 "Polity2"
						  x2 "Polyarchy"
						  x3 "Democracy"
						  x4 "Margin of victory (MoV)"
						  c.x1#c.ethnic_fractionalization "Polity2*ELF"
						  c.x2#c.ethnic_fractionalization "Polyarchy2*ELF"
						  c.x3#c.ethnic_fractionalization "Democracy*ELF"
						  c.x4#c.ethnic_fractionalization "MoV*ELF")
				stats(N, labels("N" )
				fmt(0 0 0)) collabels(none)	label booktabs nonotes;
		#delimit cr		
		}	
	}		
	}
	/////////////////////////////////////////////////////////////////////////////////////
	// Table A.18: Contestation and administrative unit proliferation (election years) //
	/////////////////////////////////////////////////////////////////////////////////////		
	
	if `tableA18'==1 {
	
	estimates clear
	
	foreach y in y1  {
	foreach x in x1 x2 x3 x4 {		
	reghdfe `y' c.`x' if prez_election_year==1, abs(country_id) cl(country_id)
		estadd local election "Y"
		estimate store `x'_`y'_m1 
	reghdfe `y' c.`x'##c.ethnic_fractionalization if prez_election_year==1, abs(country_id) cl(country_id)
		estadd local election "Y"
		estimate store `x'_`y'_m2 
		}
		}
		
	if `export_table'==1 {
	foreach y in y1 {
	# delimit ; 
		esttab  x1_`y'_m1 x1_`y'_m2 x2_`y'_m1 x2_`y'_m2 
				x3_`y'_m1 x3_`y'_m2 x4_`y'_m1 x4_`y'_m2
		using "Tables/TableA18.tex", replace
	keep (x1 c.x1#c.ethnic_fractionalization x2 c.x2#c.ethnic_fractionalization
		  x3 c.x3#c.ethnic_fractionalization x4 c.x4#c.ethnic_fractionalization)
	order(x1 c.x1#c.ethnic_fractionalization x2 c.x2#c.ethnic_fractionalization
		  x3 c.x3#c.ethnic_fractionalization x4 c.x4#c.ethnic_fractionalization)
				cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
				starlevels(* .10 ** .05 *** .01) 					
				mgroups("\textbf{Polity2}" "\textbf{Polyarchy}" "\textbf{Democracy}" "\textbf{MoV}", pattern(1 0 1 0 1 0 1 0)
				span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
				varlabels(x1 "Polity2"
						  x2 "Polyarchy"
						  x3 "Democracy"
						  x4 "Margin of victory (MoV)"
						  c.x1#c.ethnic_fractionalization "Polity2*ELF"
						  c.x2#c.ethnic_fractionalization "Polyarchy2*ELF"
						  c.x3#c.ethnic_fractionalization "Democracy*ELF"
						  c.x4#c.ethnic_fractionalization "MoV*ELF")
				stats(election N, labels("Presidential Election year" "N" )
				fmt(0 0 0)) collabels(none)	label booktabs nonotes;
		#delimit cr		
		}	
	}
	}
	
	//////////////////////////////////////////////////////////////
	// Figure 3: Marginal effect of contestation on admin units //
	//////////////////////////////////////////////////////////////	

	interflex y1 x2 ethnic_fractionalization, fe(country_id) cluster(country_id) ylabel(admin units) dlabel(contestation) xlabel(Ethnic fractionalization) saving("Figures/Figure3.pdf")

	drop x1 x2 x3 x4 y1
	estimates clear
