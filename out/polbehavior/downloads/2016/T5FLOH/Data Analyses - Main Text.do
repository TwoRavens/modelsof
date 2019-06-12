******************************************************
************** Data Analyses: Main Text 
************** The following do file provides the code
************** for the three figures provided in-text. 
************** The data cleaning files must be run first. 
************** Analyess are provied by Figure,
************** with both datasets represented. 
**************************************
**************************************
**************************************




**************Figure 1: Mean Ratings by Condition; Difference Between Conditions************
	
*Study 1
	*Analyses 
		eststo clear
		regress eval i.incon_acc4
		margins incon_acc4, post
		estimates store MEAN
		eststo: regress eval i.incon_acc4
		margins, dydx(*) post
		estimates store CON
		eststo: regress eval ib2.incon_acc4
		margins, dydx(*) post
		estimates store NOJ
		esttab using Study1_GlobalEval.rtf, onecell label ar2 se star(+ 0.10 * 0.05 ** 0.05) addnotes(Results from OLS Regression. DV is scaled such that M = 0, SD =1.)
		eststo clear

	*Sub-graph
		coefplot MEAN, bylabel(Group Means) || CON, bylabel(Diff. from Consistent Candidate) || NOJ, bylabel(Diff from Repositioned No Just. Candidate) || , ///
			mlab mlabpos(12) format(%9.2g) mlabsize(small) ///
			coeflabel(1.incon_acc4="Consistent" 2.incon_acc4=`""Repositioned" "No Just.""' ///
			3.incon_acc4=`""Repositioned" "Soc. Fairness""' 4.incon_acc4=`""Repositioned" "Comp. of Ends""', labsize(small)) ///
			xline(0, lpattern(dash)) scheme(s1mono) byopts(cols(1) title(Study 1)) level(95 90)
			*save graph to combine with Study 2*
			

*Study 2.
	*Analyses
		eststo clear
		regress eval i.condition1 i.cond_party
		margins condition1, post
		estimates store MEAN
		eststo: regress eval i.condition1 i.cond_party
		margins, dydx(condition1) post
		estimates store CON
		eststo: regress eval ib3.condition1 i.cond_party
		margins, dydx(condition1) post
		estimates store NOJ
		esttab using Study2_GlobalEval.rtf, onecell label ar2 se star(+ 0.10 * 0.05 ** 0.05) addnotes(Results from OLS Regression. DV is scaled such that M = 0, SD =1.)
		eststo clear
	*Subgraph
		coefplot MEAN, bylabel(Group Means) || CON, bylabel(Diff. from Baseline Rep.) || NOJ, bylabel(Diff from Repositioned No Just. Rep) || , ///
			mlab mlabpos(2) format(%9.2g) mlabsize(small) ///
			coeflabel(1.condition1="Baseline" 2.condition1="Consistent" 3.condition1=`""Repositioned" "No Just.""' ///
				4.condition1=`""Repositioned" "New Info""' 5.condition1=`""Repositioned" "P. Fairness""', labsize(vsmall) ) ///
			xline(0, lpattern(dash)) scheme(s1mono) byopts(cols(1) title(Study 2)) level(95 90)
		*graph save
				
*Figure 1
	*figure 1 was created via graph combine using the previous two graphs
	*graph combine "graph 1" "graph 2", scheme(s1mono) cols(2)
				

**************Figure 2: Persuasion************

**Note: these analyses just use data from Study 1***
	
	*Analyses
		set more off
		drop _est_*	
		eststo clear
		eststo: regress dream_reverse1 i.pos2
		margins pos2, post
		estimates store ALL

		eststo: regress dream_reverse1 i.pos2 if ideology_3 == 1
		margins pos2, post
		estimates store LIB

		eststo: regress dream_reverse1 i.pos2 if ideology_3 == 2
		margins pos2, post
		estimates store MOD 

		eststo: regress dream_reverse1 i.pos2 if ideology_3 == 3
		margins pos2, post
		estimates store CON	 
		esttab using Study1__Persuasion.rtf, onecell ar2 se star(+ 0.10 * 0.05 ** 0.01)  
		eststo clear
	*Figure
		coefplot ALL, bylabel(All Respondents) || LIB, bylabel(Liberals) || MOD, bylabel(Moderates) || CON, bylabel(Conservatives) || , ///	
				mlab mlabpos(2) format(%9.2g) mlabsize(vsmall) level(95) xline(0, lpattern(dash)) ///
				coeflabel(1.pos2="Consistent Candidate" 2.pos2="Support to Oppose" 3.pos2="Oppose to Support" 4.pos2="Support to Oppose" 5.pos2="Oppose to Support", labsize(small)) ///
				headings(2.pos2="{bf:Soc. Fairness}" 4.pos2="{bf:Comp. of Ends}", labsize(small)) scheme(s1mono) ///
				byopts(title(Dream Act Attitudes by Justification Provision))


**************Figure 3: Motive Attributions************

*Study 1
	*Analyses
		drop _est_*
		eststo clear
		eststo: regress polmotives_f ib2.incon_acc4
		margins incon_acc4, post
		estimates store POL_ALL
					
		eststo: regress helpmotives_f ib2.incon_acc4
		margins incon_acc4, post
		estimates store HEL_ALL
		esttab using MOTIVES_S1.rtf, ar2 se onecell label star(+ 0.10 * 0.05 ** 0.01)
		eststo clear
	
	*Subgraph*
			
		coefplot (POL_ALL), bylabel(Political Motives)) || (HEL_ALL, symbol(T)), bylabel(Representation Motives) || , 	mlab mlabpos(2) mlabsize(small) format(%9.2g) xline(0, lpattern(dash)) ///
			byopts(title(Study 1: Motive Attributions)) scheme(s1mono) 	///
			coeflabel(1.incon_acc4="Consistent" 2.incon_acc4=`""Repositioned" "No Just.""' ///
			3.incon_acc4=`""Repositioned" "Soc. Fairness""' 4.incon_acc4=`""Repositioned" "Comp. of Ends""', labsize(medsmall)) xlabel(-.4(0.2)0.4)
			*save graph*

*Study 2
	*Analyses
		drop _est_*
		eststo clear
		eststo: regress political_motives i.condition1
		margins condition1, post
		estimates store POL_ALL
		
		eststo: regress representation_motives i.condition1
		margins condition1, post
		estimates store REP_ALL
	
		eststo: regress policy_motives i.condition1
		margins condition1, post
		estimates store POLICY_ALL
		esttab using S2_MOTIVES.rtf, ar2 se onecell label star(+ 0.10 * 0.05 ** 0.01)
		eststo clear
	*Figure
		coefplot POL_ALL , bylabel("Political" "Motives") || (REP_ALL, symbol(T)),  bylabel("Representation" "Motives")  || (POLICY_ALL, symbol(S)), bylabel("Policy" "Motives") ||, ///
			bycoefs mlab mlabpos(2) mlabsize(small) format(%9.2g) xline(0, lpattern(dash)) ///
			byopts(title(Study 2: Motive Attributions))  scheme(s1mono) ///
			coeflabel(4.condition1=`""Condition:" "New Info""' 5.condition1=`""Condition:" "P. Fairness""')
			
		*Graph save*
		
	*Figure 3
		*created through graph combine
		* graph combine  "Study 1 - Motives.gph"  "Study 2 - Motives.gph", scheme(s1mono) rows(2)
