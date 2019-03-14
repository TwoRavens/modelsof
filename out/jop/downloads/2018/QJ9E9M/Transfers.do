

	// This do-file generates the following tables and figures in Gottlieb et al. (2018):
	// Figure 2, Appendix Table A10, Appendix Figure A1

	clear
	set more off
	
	// Turn on/off these locals to produce the relevant tables
	loc tableA10=1
	loc figure2=1
	loc figureA1=1
	
	//////////////////////////////////////////////////////////////////
	// Table A10: Effect of CR Split on Per Capita Transfers to CRs //
	//////////////////////////////////////////////////////////////////	
	
	if `tableA10'==1 {

	use "Data\data_transfers_senegal", clear
		
	estimates clear 
	replace transferstot=transferstot/1000000
	
	gen rump=(status=="Rump")
	gen new=(status=="Child")
	
	gen splitXrump=split*rump
	gen splitXnew=split*new
	lab var splitXrump "CR Split*Rump"
	lab var splitXnew "CR Split*New"
	
	foreach v of varlist transferspc ltransferspc {
	
	eststo: xi: reg `v' split i.year, clus(original2002cr)
	sum `v' if e(sample) ==1
	estadd local ymean = string(r(mean), "%9.3f")	
	estadd local clusters = string(e(N_clust), "%9.0f")		
	
	eststo: xi: reg `v' splitXrump splitXnew i.year, clus(original2002cr)
	sum `v' if e(sample) ==1
	estadd local ymean = string(r(mean), "%9.3f")	
	estadd local clusters = string(e(N_clust), "%9.0f")			
	
	}
		
	*Esttab
	# d;
	esttab using "Tables\TableA10.tex", keep(split splitXrump splitXnew) booktabs
	replace br se label star(* 0.1 ** 0.05 *** 0.01) obslast  compress  b(%9.3f) se(%9.3f) r2(%9.2f) nonotes
	scalars("ymean Mean") mgroups("Total Transfers" "Per Capita Transfers", pattern(1 0 1 0)		
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}) )	mtitles("Levels" "Levels" "Log" "Log")
	addnotes("\footnotesize{Note: * p$<$0.1, ** p$<$0.05, *** p$<$0.01.}"
			"\footnotesize{\phantom{Note: } Standard errors clustered by 2002 CR.}" 
			"\footnotesize{\phantom{Note: } All specifications include 2002 CR fixed effects and year fixed effects.}" 
			"\footnotesize{\phantom{Note: } Transfers are in million FCFA in column (1).}" );					
	# d cr		
	
	}	
	
	///////////////////////////////////////////////////////////////////////////////
	// Figure 2: Effect of CR Splits on Per-capita Transfers (levels), 2007-2014 //
	///////////////////////////////////////////////////////////////////////////////	

	if `figure2'==1 {

	use "Data\data_transfers_senegal", clear
	
	replace year=year-.06 if year==2009 & status=="Child"
	replace year=year+.06 if year==2009 & status=="Rump"
	replace year=year-.12 if year==2010 & status=="Rump"
	replace year=year+.12 if year==2010 & status=="No Split"	
	collapse (mean) transferspc, by(status year)
		
	#d;
	twoway (scatter transferspc year if status=="Rump", 
	graphregion(color(white)) mcolor(blue) msymbol(triangle)
	ytitle("Transfers per capita (FCFA, levels)") xtitle("Year") legend(label (1 "Rump") label (2 "New")  label (3 "No Split") rows(1))  ) 
			(scatter transferspc year if status=="Child", mcolor(green) msymbol(square))
			(scatter transferspc year if status=="Unsplit", mcolor(orange) msymbol(diamond));
	#d cr
	graph export "Figures\Figure2.pdf", replace	
	
	}

	////////////////////////////////////////////////////////////////////////////////
	// Figure A1: Effect of CR Splits on Per-capita Transfers (levels), 2007-2014 //
	////////////////////////////////////////////////////////////////////////////////		
	
	if `figureA1'==1 {

	use "Data\data_transfers_senegal", clear	
	
	replace year=year-.06 if year==2009 & status=="Child"
	replace year=year+.06 if year==2009 & status=="Rump"
	replace year=year-.12 if year==2010 & status=="Rump"
	replace year=year+.12 if year==2010 & status=="No Split"	
	
	collapse (mean) ltransferspc, by(status year)

	#d;
	twoway (scatter ltransferspc year if status=="Rump", 
	graphregion(color(white)) mcolor(blue) msymbol(triangle)
	ytitle("Transfers per capita (FCFA, logs)") xtitle("Year") legend(label (1 "Rump") label (2 "New")  label (3 "No Split") rows(1))  ) 
			(scatter ltransferspc year if status=="Child", mcolor(green) msymbol(square))
			(scatter ltransferspc year if status=="Unsplit", mcolor(orange) msymbol(diamond));
	#d cr
	graph export "Figures\FigureA1.pdf", replace	

	}

	

