* 010515 - Tables for ABH Paper and Online Appendix
	* Focusing only on Distance from Chamber Median
		* NOMINATE
			* Non-formula grants
			* All grants
		* CVP with non-formula grants
	* Removing the committees from the baseline analyses	

* Preliminaries	
clear
set more off
cd "C:\Users\Dan Alexander\Dropbox\Work\Research\Current projects\Chris and Will\Electoral strategies and spending\figures_and_regressions\"

	* Generate local vectors of controls
	global X "majority pres any_chair any_rank leader first_term tenure close_congelec_dist winstate_margin_preselec_state"
	global X_nomaj "pres any_chair any_rank leader first_term tenure close_congelec_dist winstate_margin_preselec_state"
	global Y "mem_agricul mem_approps mem_armserv_natlsec mem_banking_finserv mem_budget mem_dc mem_educlab mem_engycom mem_fornaff_intlrel mem_govtops mem_homesec mem_hradmin mem_judicry mem_merchmar mem_natrlres mem_postoff_civserv mem_pubwork_transpo_infrast mem_rules mem_scitech mem_smallbus mem_stnds mem_vetaffrs mem_waysmeans"
	global Z "ln_income ln_popul"
	*global R "majority pres unigov any_chair any_rank leader mem_approps mem_rules mem_waysmeans first_term tenure close_congelec_dist winstate_margin_preselec_state"
	*global R_nomaj "pres unigov any_chair any_rank leader mem_approps mem_rules mem_waysmeans first_term tenure close_congelec_dist winstate_margin_preselec_state"
	*global R_nomaj_nounigov "pres any_chair any_rank leader mem_approps mem_rules mem_waysmeans first_term tenure close_congelec_dist winstate_margin_preselec_state"
	*global S "mem_agricul mem_armserv_natlsec mem_banking_finserv mem_budget mem_dc mem_educlab mem_engycom mem_fornaff_intlrel mem_govtops mem_homesec mem_hradmin mem_judicry mem_merchmar mem_natrlres mem_postoff_civserv mem_pubwork_transpo_infrast mem_scitech mem_smallbus mem_stnds mem_vetaffrs"
	*global T "ln_income ln_popul"
	*global C "majority pres unigov any_chair any_rank leader mem_approps mem_rules mem_waysmeans republican first_term tenure close_congelec_dist winstate_margin_preselec_state"
	*global D "majority pres unigov any_chair any_rank leader mem_approps mem_rules mem_waysmeans first_term tenure close_congelec_dist winstate_margin_preselec_state"
	global A "majority pres any_chair any_rank leader republican first_term tenure close_congelec_dist winstate_margin_preselec_state"
	global B "majority pres any_chair any_rank leader first_term tenure close_congelec_dist winstate_margin_preselec_state"
	
use ABH_full_county, clear	
	
	* Relabel some variables
	label variable abs_dist_nom "Absolute distance from median"
	label variable abs_rank_nom100 "Absolute rank from median (/100)"
	label variable abs_dist_cvp "Distance (CVP) from median"
	label variable abs_rank_cvp100 "Rank (CVP) from median (/100)"
	label variable abs_distsqrt_nom "Distance from median (sqrt)"
	label variable abs_distsq_nom "Distance from median (sq)"
	label variable ln_abs_dist_nom "Distance from median (ln)"
	label variable repubXabs_dist_nom "Distance x Republican"
	label variable demXabs_dist_nom "Distance x Democrat"	
	
	label variable any_chair "Committee chair" 
	label variable any_rank "Ranking minority member" 
	label variable leader "Party leader" 
	label variable mem_approps "Appropriations Committee" 
	label variable mem_waysmeans "Rules Committee" 
	label variable mem_waysmeans "Ways \& Means Committee" 
	label variable republican "Party" 
	label variable first_term "First term" 
	label variable tenure "Tenure (\# terms)" 
	label variable close_congelec_dist "Close election" 
	label variable winstate_margin_preselec_state "State presidential margin"
	
	label variable majXabs_dist_nom "Absolute distance x majority"
	label variable majXabs_dist_cvp "Abs distance x majority (CVP)"
	label variable unigov "Unified government"
	label variable majXunigov "Unif. gov't x majority"
	label variable abs_dist_nomXunigov "Unif. gov't x distance"
	label variable abs_dist_nomXmajXunigov "Unif. gov't x maj'ty x distance"
	label variable majXpolar_hou "Polar index x majority"
	label variable polar_houXabs_dist_nom "Polar index x distance"
	label variable majXpolar_houXabs_dist_nom "Polar index x maj'ty x distance"
	label variable abs_dist_cvpXunigov "Unif. gov't x distance (CVP)"
	label variable abs_dist_cvpXmajXunigov "Unif. gov't x maj'ty x distance (CVP)"

	label variable abs_dist_pty_nom "Distance from within party median"
	label variable abs_rank_pty_nom100 "Rank (/100) from w/in party median"
	label variable demXabs_dist_pty_nom "Distance from w/in Dem. party median"
	label variable repubXabs_dist_pty_nom "Distance from w/in Rep. party median"
	label variable majXabs_dist_pty_nom "Distance from w/in Maj. party median"
	label variable minXabs_dist_pty_nom "Distance from w/in Min. party median"

	label variable abs_dist_pty_nom_mean "Distance from within party mean"
	*label variable abs_dist_pty_cvp_mean "Distance from within party mean (CVP)"
	label variable majXabs_dist_pty_nom_mean "Abs dist pty mean x majority"
	label variable abs_dist_pty_nom_meanXunigov "Unif. gov't x abs dist pty mean"	
	
	label variable sectionI "Section I"
	label variable sectionII "Section II"
	label variable sectionIII "Maj on far side of median"
	label variable sectionIIIXabs_dist_nom "Maj far side of med X abs dist"
	label variable sectionIV "Section IV"
	label variable sectionV "Section V"
	
	label variable sectionI_cvp "Section I (CVP)"
	label variable sectionII_cvp "Section II (CVP)"
	label variable sectionIII_cvp "Section III (CVP)"
	label variable sectionIV_cvp "Section IV (CVP)"
	label variable sectionV_cvp "Section V (CVP)"
	
	label variable ln_income "Log income"
	label variable ln_popul "Log population"
	
save, replace	
	
use ABH_full_district, clear	
	
	* Relabel some variables for the district-level analysis
	label variable abs_dist_nom "Absolute distance from median"
	label variable abs_rank_nom100 "Absolute rank from median (/100)"
	label variable abs_dist_cvp "Distance (CVP) from median"
	label variable abs_rank_cvp100 "Rank (CVP) from median (/100)"
	label variable abs_distsq_nom "Distance from median (sq)"
	label variable ln_abs_dist_nom "Distance from median (ln)"
	label variable repubXabs_dist_nom "Distance x Republican"
	label variable demXabs_dist_nom "Distance x Democrat"	
	
	label variable any_chair "Committee chair" 
	label variable any_rank "Ranking minority member" 
	label variable leader "Party leader" 
	label variable mem_approps "Appropriations Committee" 
	label variable mem_waysmeans "Rules Committee" 
	label variable mem_waysmeans "Ways \& Means Committee" 
	label variable republican "Party" 
	label variable first_term "First term" 
	label variable tenure "Tenure (\# terms)" 
	label variable close_congelec_dist "Close election" 
	label variable winstate_margin_preselec_state "State presidential margin"
	
	label variable majXabs_dist_nom "Absolute distance x majority"
	label variable majXabs_dist_cvp "Abs distance x majority (CVP)"
	label variable unigov "Unified government"
	label variable majXunigov "Unif. gov't x majority"
	label variable abs_dist_nomXunigov "Unif. gov't x distance"
	label variable abs_dist_nomXmajXunigov "Unif. gov't x maj'ty x distance"
	label variable abs_dist_cvpXunigov "Unif. gov't x distance (CVP)"
	label variable abs_dist_cvpXmajXunigov "Unif. gov't x maj'ty x distance (CVP)"

	label variable abs_dist_pty_nom "Distance from within party median"
	label variable abs_rank_pty_nom100 "Rank (/100) from w/in party median"
	label variable demXabs_dist_pty_nom "Dem. party distance from median"
	label variable repubXabs_dist_pty_nom "Rep. party distance from median"
	label variable majXabs_dist_pty_nom "Maj. party distance from median"
	label variable minXabs_dist_pty_nom "Min. party distance from median"

	label variable abs_dist_pty_nom_mean "Distance from within party mean"
	label variable majXabs_dist_pty_nom_mean "Abs dist pty mean x majority"
	label variable abs_dist_pty_nom_meanXunigov "Unif. gov't x abs dist pty mean"
	
	label variable sectionI "Section I"
	label variable sectionII "Section II"
	label variable sectionIII "Section III"
	label variable sectionIV "Section IV"
	label variable sectionV "Section V"
	
	label variable sectionI_cvp "Section I (CVP)"
	label variable sectionII_cvp "Section II (CVP)"
	label variable sectionIII_cvp "Section III (CVP)"
	label variable sectionIV_cvp "Section IV (CVP)"
	label variable sectionV_cvp "Section V (CVP)"
	
save, replace	

********************
* Tables for Paper *
********************

use ABH_full_county, clear
drop fullcntysamp
drop cntysamp


	* Population, Absolute distance, and Outlays statistics (for in-text discussion and Table 1)
	xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year, fe i(cmfe) cluster(fips_state)
	gen fullcntysamp = 0
	replace fullcntysamp = 1 if e(sample)==1
	count if fullcntysamp==0
	sum popul_bea if fullcntysamp==1
	
	xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if dist_num==1, fe i(cmfe) cluster(fips_state)
	gen cntysamp = 0
	replace cntysamp = 1 if e(sample)==1
	label variable cntysamp "Obs. used in cnty analysis"
	count if cntysamp==1
	sum popul_bea if cntysamp==1
	save, replace

		* % of counties
		di 71199/81555
		
		* % of population
		di (71199*41347)/(81555*84270)
		
	xtsum abs_dist_nom if cntysamp==1, i(cmfe)
	xtsum abs_dist_nom if cntysamp==1 & majority==1, i(cmfe)
	xtsum abs_dist_nom if cntysamp==1 & majority==0, i(cmfe)
	
	xtsum abs_rank_nom100 if cntysamp==1, i(cmfe)
	
	xtsum amount3GG if cntysamp==1, i(cmfe)
	xtsum amount3GG if cntysamp==1 & majority==1, i(cmfe)
	xtsum amount3GG if cntysamp==1 & majority==0, i(cmfe)
	
		* Effect on outlays and outlays per capita, using mean outlays and mean population along with estimate from model 2 (baseline model)
		di -.608*.118
		di -.072*9300000
		di 670,000/41347
		
		di -.120*.681
		
	* Figure 1 created by taking median of DW-NOMINATE data, without restrictions, as distance to the median is calculated without additional restrictions placed on the data
	
	* Basic Specifications: Distance & Rank
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
		* F-test on additional committee dummies
		test $Y
	eststo: xi: xtreg ln_amount3GG abs_rank_nom100 $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_nom100 $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_nom100 $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-noform-vsrank.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom abs_rank_nom100 $X $Z _cons) ///
		order(abs_dist_nom abs_rank_nom100 $X $Z _cons) ///
		varlabels(_cons "Constant", elist(_cons "\addlinespace Committee dummies & No & No & Yes & No & No & Yes \\")) ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
	* Majority Party Interactions
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X_nomaj $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majXabs_dist_nom $X $Z i.year if dist_num==1 & ln_amountGG>=0, fe i(cmfe) cluster(fips_state)
	
	local min = _b[_cons] + _b[abs_dist_nom]*0.503
	di `min'
	di 14.839-.660*.503
	local maj = _b[_cons] + _b[majority] + _b[majXabs_dist_nom]*0.190 + _b[abs_dist_nom]*0.190
	di `maj'
	twoway function y = _b[_cons] + _b[abs_dist_nom]*x, range(0 1) lcolor(black) lpattern(-) droplines(.503) yline(`min', lcolor(black) lpattern(-)) || ///
	function y = _b[_cons] + _b[majority] + _b[majXabs_dist_nom]*x + _b[abs_dist_nom]*x, lcolor(black) droplines(.189) yline(`maj', lcolor(black))  ///
	ytitle(Log Outlays) xtitle(Distance to Median) legend(off)
	
	estout using "cnty-dist1-noform-MAJ.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom majority majXabs_dist_nom $X_nomaj $Z _cons) ///
		order(abs_dist_nom majority majXabs_dist_nom $X_nomaj $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace

	* Robustness & Placebo
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	gen noform_samp = e(sample)==1
	eststo: xi: xtreg ln_amountGG abs_dist_nom $X $Z i.year if dist_num==1 & ln_amountGG>=0 & noform_samp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount6GG abs_dist_nom $X $Z i.year if dist_num==1 & ln_amount6GG>=0 & noform_samp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amountDR abs_dist_nom $X $Z i.year if dist_num==1 & ln_amountDR>=0 & noform_samp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-RP.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		mgroups("Robustness" "Placebo", pattern(1 0 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		keep(abs_dist_nom $X $Z _cons) ///
		order(abs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1) No Formula" "(2) All Grants" "(3) Formula Only" "(4) Dis. \& Ret.") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace

		
***********************
* Tables for Appendix *
***********************		
		
	* Summary Statistics
	label variable ln_amountDR "Log retirement and disability (all)"
	label variable tenure "Tenure (# terms)" 
	sutex2 abs_dist_nom abs_rank_nom100 majXabs_dist_nom abs_distsq_nom abs_distsqrt_nom ln_abs_dist_nom repubXabs_dist_nom demXabs_dist_nom abs_dist_pty_nom_mean pun_score unigov polar_hou abs_dist_cvp abs_rank_cvp100 sectionIII $X $Z ln_amount3GG ln_amountGG ln_amount6GG ln_amountDR if cntysamp==1, saving(sum_stats_county.tex) replace minmax tabular varlabels
	label variable tenure "Tenure (\# terms)" 
	
	* Experimenting with Fixed Effects
	estimates clear
	eststo: xi: reg ln_amount3GG abs_dist_nom $A $Z i.year if cntysamp==1, cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $A $Z i.year if cntysamp==1, fe i(cfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(mfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	
	estout using "cnty-dist1-noform-FE.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom $A $Z _cons) ///
		order(abs_dist_nom $A $Z _cons) ///
		varlabels(_cons "Constant", elist(_cons "\addlinespace Fixed Effects & None & County & Member & Cnty-Member \\")) ///
		mlabels("(1)" "(2)" "(3)" "(4)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace

	* Variations on Absolute Distance
	estimates clear	
	eststo: xi: xtreg ln_amount3GG abs_dist_nom abs_distsq_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom abs_distsqrt_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG ln_abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG ln_abs_dist_nom abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom repubXabs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG repubXabs_dist_nom demXabs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-noform-fnform.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom abs_distsq_nom abs_distsqrt_nom ln_abs_dist_nom repubXabs_dist_nom demXabs_dist_nom $X  $Z _cons) ///
		order(abs_dist_nom abs_distsq_nom abs_distsqrt_nom ln_abs_dist_nom repubXabs_dist_nom demXabs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
	* Spline Analysis	
	estimates clear
	gen abs_dist_nom_spline = 0
	foreach k in .1 .3 .5 .7 0.9 1.1 {
		drop abs_dist_nom_spline*
		mkspline abs_dist_nom_spline1 `k' abs_dist_nom_spline2 = abs_dist_nom
		label variable abs_dist_nom_spline1 "Distance from median - spline 1 "
		label variable abs_dist_nom_spline2 "Distance from median - spline 2"
		eststo: xi: xtreg ln_amount3GG abs_dist_nom_spline* $X $Z i.year if dist_num==1 & ln_amountGG>=0, fe i(cmfe) cluster(fips_state)
	}
	break
	
	estout using "cnty-dist1-noform-spline.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		mgroups("0.1" "0.3" "0.5" "0.7" "0.9" "1.1", pattern(1 1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		keep(abs_dist_nom_spline1 abs_dist_nom_spline2 $X $Z _cons) ///
		order(abs_dist_nom_spline1 abs_dist_nom_spline2 $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
	* Distance from Party Mean
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_pty_nom_mean $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_pty_nom_mean $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_pty_nom_mean $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_pty_nom_mean abs_dist_nom $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_pty_nom_mean abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_pty_nom_mean abs_dist_nom $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-noform-wptymean.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom abs_dist_pty_nom_mean $X $Z _cons) ///
		order(abs_dist_nom abs_dist_pty_nom_mean $X $Z _cons) ///
		varlabels(_cons "Constant", elist(_cons "\addlinespace Committee dummies & No & No & Yes & No & No & Yes \\")) ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
			
	* Party Unity
	estimates clear
	eststo: xi: xtreg ln_amount3GG pun_score $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG pun_score majXpun_score $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG pun_score abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG pun_score majXpun_score abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-pun-noform.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(pun_score majXpun_score abs_dist_nom $X $Z _cons) ///
		order(pun_score majXpun_score abs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace

	* CVP - Basic Specifications
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_cvp $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_cvp $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_cvp $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_cvp100 $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_cvp100 $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_cvp100 $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-noform-vsrank-cvp.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_cvp abs_rank_cvp100 $X $Z _cons) ///
		order(abs_dist_cvp abs_rank_cvp100 $X $Z _cons) ///
		varlabels(_cons "Constant", elist(_cons "\addlinespace Committee dummies & No & No & Yes & No & No & Yes \\")) ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
	* Unified Government
	estimates clear
	eststo: xi: xtreg ln_amount3GG unigov majXunigov $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG unigov majXunigov abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG unigov majXunigov abs_dist_nom abs_dist_nomXunigov $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG unigov majXunigov abs_dist_nom abs_dist_nomXunigov majXabs_dist_nom abs_dist_nomXmajXunigov $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
		
	estout using "cnty-dist1-noform-unigov.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(unigov majXunigov abs_dist_nom abs_dist_nomXunigov majXabs_dist_nom abs_dist_nomXmajXunigov $X $Z _cons) ///
		order(unigov majXunigov abs_dist_nom abs_dist_nomXunigov majXabs_dist_nom abs_dist_nomXmajXunigov $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace
	
	* Polarization
	estimates clear
	eststo: xi: xtreg ln_amount3GG polar_hou majXpolar_hou $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG polar_hou majXpolar_hou abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG polar_hou majXpolar_hou abs_dist_nom polar_houXabs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG polar_hou majXpolar_hou abs_dist_nom polar_houXabs_dist_nom majXabs_dist_nom majXpolar_houXabs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
		
	estout using "cnty-dist1-noform-polar_hou.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(majXpolar_hou abs_dist_nom polar_houXabs_dist_nom majXabs_dist_nom majXpolar_houXabs_dist_nom $X $Z _cons) ///
		order(majXpolar_hou abs_dist_nom polar_houXabs_dist_nom majXabs_dist_nom majXpolar_houXabs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace
	
	* Size of Majority Party (excluding from the paper)
	estimates clear
	eststo: xi: xtreg ln_amount3GG house_maj_size majXhouse_maj_size $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG house_maj_size majXhouse_maj_size abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG house_maj_size majXhouse_maj_size abs_dist_nom abs_dist_nomXhouse_maj_size $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG house_maj_size majXhouse_maj_size abs_dist_nom abs_dist_nomXhouse_maj_size majXabs_dist_nomXhouse_maj_size $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
		
	estout using "cnty-dist1-noform-majsize.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(house_maj_size majXhouse_maj_size abs_dist_nom abs_dist_nomXhouse_maj_size majXabs_dist_nomXhouse_maj_size $X $Z _cons) ///
		order(house_maj_size majXhouse_maj_size abs_dist_nom abs_dist_nomXhouse_maj_size majXabs_dist_nomXhouse_maj_size $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace
		
	* Majority on Far Side of the Median
	estimates clear
	eststo: xi: xtreg ln_amount3GG sectionIII $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG sectionIII abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG sectionIII sectionIIIXabs_dist_nom abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG sectionIII sectionIIIXabs_dist_nom abs_dist_nom majXabs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
		
	estout using "cnty-dist1-noform-secIII.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(sectionIII sectionIIIXabs_dist_nom abs_dist_nom majXabs_dist_nom $X $Z _cons) ///
		order(sectionIII sectionIIIXabs_dist_nom abs_dist_nom majXabs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)") ///
		prehead("\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}") replace
			
	* All Grants - Basic Specifications
	estimates clear
	eststo: xi: xtreg ln_amountGG abs_dist_nom $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amountGG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amountGG abs_dist_nom $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amountGG abs_rank_nom100 $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amountGG abs_rank_nom100 $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amountGG abs_rank_nom100 $X $Y $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)

	estout using "cnty-dist1-allgrt-vsrank.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom abs_rank_nom100 $X $Z _cons) ///
		order(abs_dist_nom abs_rank_nom100 $X $Z _cons) ///
		varlabels(_cons "Constant", elist(_cons "\addlinespace Committee dummies & No & No & Yes & No & No & Yes \\")) ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace

	* Percentiles of Ongoing Sample
	estimates clear
	xtile quartile_ln_popul = ln_popul, nq(4)
	gen first_quart = quartile_ln_popul==1
	label variable first_quart "First Quartile"
	gen second_quart = quartile_ln_popul==2
	label variable second_quart "Second Quartile"
	gen third_quart = quartile_ln_popul==3
	label variable third_quart "Third Quartile"
	gen fourth_quart = quartile_ln_popul==4
	label variable fourth_quart "Fourth Quartile"
	gen abs_dist_nomXfirst_quart = abs_dist_nom*first_quart
	label variable abs_dist_nomXfirst_quart "Absolute distance from median x first population quartile"
	gen abs_dist_nomXsecond_quart = abs_dist_nom*second_quart
	label variable abs_dist_nomXsecond_quart "Absolute distance from median x second population quartile"
	gen abs_dist_nomXthird_quart = abs_dist_nom*third_quart
	label variable abs_dist_nomXthird_quart "Absolute distance from median x third population quartile"
	gen abs_dist_nomXfourth_quart = abs_dist_nom*fourth_quart
	label variable abs_dist_nomXfourth_quart "Absolute distance from median x fourth population quartile"
	
	/*eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if ln_amount3GG>=0 & quartile_ln_popul==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if ln_amount3GG>=0 & quartile_ln_popul==2, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if ln_amount3GG>=0 & quartile_ln_popul==3, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if ln_amount3GG>=0 & quartile_ln_popul==4, fe i(cmfe) cluster(fips_state)	
	*/
	
	*eststo: xi: xtreg ln_amount3GG abs_dist_nom abs_dist_nomXfirst_quart abs_dist_nomXsecond_quart abs_dist_nomXthird_quart abs_dist_nomXfourth_quart $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	*eststo: xi: xtreg ln_amount3GG abs_dist_nom abs_dist_nomXfirst_quart abs_dist_nomXsecond_quart abs_dist_nomXthird_quart abs_dist_nomXfourth_quart first_quart second_quart third_quart fourth_quart $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nomXfirst_quart abs_dist_nomXsecond_quart abs_dist_nomXthird_quart abs_dist_nomXfourth_quart $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nomXfirst_quart abs_dist_nomXsecond_quart abs_dist_nomXthird_quart abs_dist_nomXfourth_quart second_quart third_quart fourth_quart $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	
	
	* OUTPUT
	estout using "cnty-popul-quartiles.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nomXfirst_quart abs_dist_nomXsecond_quart abs_dist_nomXthird_quart abs_dist_nomXfourth_quart second_quart third_quart fourth_quart $X $Z _cons) ///
		order(abs_dist_nomXfirst_quart abs_dist_nomXsecond_quart abs_dist_nomXthird_quart abs_dist_nomXfourth_quart second_quart third_quart fourth_quart $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
	sum ln_popul if quartile_ln_popul==1
	sum ln_popul if quartile_ln_popul==2
	sum ln_popul if quartile_ln_popul==3
	sum ln_popul if quartile_ln_popul==4	

	* Adding redistricting to counties
	estimates clear
	gen redistrict1 = year<=1992
	gen redistrict2 = year>1992 & year<=2002
	gen redistrict3 = year>2002
	egen cmfe_new = group(cmfe redistrict1 redistrict2 redistrict3)	

	eststo: xi: xtreg ln_amount3GG abs_dist_nom $Z i.year if cntysamp==1, fe i(cmfe_new) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if cntysamp==1, fe i(cmfe_new) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Y $Z i.year if cntysamp==1, fe i(cmfe_new) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_nom100 $Z i.year if cntysamp==1, fe i(cmfe_new) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_nom100 $X $Z i.year if cntysamp==1, fe i(cmfe_new) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_rank_nom100 $X $Y $Z i.year if cntysamp==1, fe i(cmfe_new) cluster(fips_state)
	
	* OUTPUT	
	estout using "cnty-10yr_redist.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom abs_rank_nom100 $X $Z _cons) ///
		order(abs_dist_nom abs_rank_nom100 $X $Z _cons) ///
		varlabels(_cons "Constant", elist(_cons "\addlinespace Committee dummies & No & No & Yes & No & No & Yes \\")) ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace	
	
	* Slow roll out of variables to see what drives the big increase in 
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_nom i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majority i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majority pres i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majority pres any_chair any_rank leader i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majority pres any_chair any_rank leader first_term tenure i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majority pres any_chair any_rank leader first_term tenure close_congelec_dist winstate_margin_preselec_state i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)	
	eststo: xi: xtreg ln_amount3GG abs_dist_nom majority pres any_chair any_rank leader first_term tenure close_congelec_dist winstate_margin_preselec_state $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)	

	* OUTPUT
	estout using "cnty-slow-roll.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom $X $Z _cons) ///
		order(abs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace

	* Accounting for the Senate
	estimates clear
	set more off
	cd "C:\Users\Dan Alexander\Dropbox\Work\Research\Current projects\Chris and Will\Vote Buying with Redistributive Outlays\Data Files\Ideology\"
	use "NOMINATE\HANDSL01112D20_BSSE.dta", clear
	
	drop if cong<=97
	keep if cd==0
	drop if state==99
	* Don't want to deal with third parties here
	drop if party!= 100 & party!=200 
	
	sort state cong
	bysort state cong: gen sen = [_n]
	keep state cong party sen
	reshape wide party, i(state cong) j(sen)
	* Don't want to deal with split terms here
	drop if party3!=.
	drop party3
	drop party4
	gen num_repub_sen = 2 if party1==200 & party2==200
	replace num_repub_sen = 1 if (party1==100 & party2==200) | (party1==200 & party2==100) | (party1==200 & party2==.)
	replace num_repub_sen = 0 if party1==100 & party2==100
	label variable num_repub_sen "Number Republican senators"
	gen num_dem_sen = 2 if party1==100 & party2==100
	replace num_dem_sen = 1 if (party1==100 & party2==200) | (party1==200 & party2==100) | (party1==100 & party2==.)
	replace num_dem_sen = 0 if party1==200 & party2==200
	label variable num_dem_sen "Number Democrat senators"
	tempfile senators
	save `senators'
	
	cd "C:\Users\Dan Alexander\Dropbox\Work\Research\Current projects\Chris and Will\Electoral strategies and spending\figures_and_regressions\"
	use ABH_full_county, clear
	merge m:1 state cong using `senators'
	
	gen share_sen_party = num_repub_sen if republican==1
	replace share_sen_party = num_dem_sen if democrat==1
	label variable share_sen_party "Senators from state in own party (0,1,2)"
	gen share_sen_maj_party = republican==senate_maj_party
	label variable share_sen_maj_party "Same party as Senate majority (0,1)"
	gen sen_share_pres_party = num_repub_sen if pres_party==1
	replace sen_share_pres_party = num_dem_sen if pres_party==0
	label variable sen_share_pres_party "Senators from state in president's party (0,1,2)"
	
	*bysort state year: egen total_state_amount3GG = total(amount3GG)
	*gen state_spend_other_cntys = total_state_amount3GG - amount3GG
	*bysort state cd year: egen total_dist_amount3GG = total(amount3GG)
	*gen state_spend_other_cntys = total_state_amount3GG - total_dist_amount3GG
	bysort state year: egen total_state_amount3GG = total(amount3GG/popul_bea)
	gen state_spend_other_cntys = total_state_amount3GG - amount3GG/popul_bea
	gen ln_state_spend_other_cntys = ln(state_spend_other_cntys)
	label variable ln_state_spend_other_cntys "Log per capita spending in state's other counties"
	gen abs_dist_nomXln_state_spend = abs_dist_nom*ln_state_spend_other_cntys
	label variable abs_dist_nomXln_state_spend "Abs dist x other county spending"
	
	eststo: xi: xtreg ln_amount3GG abs_dist_nom share_sen_party share_sen_maj_party sen_share_pres_party $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom ln_state_spend_other_cntys $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom share_sen_party share_sen_maj_party sen_share_pres_party ln_state_spend_other_cntys $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	*eststo: xi: xtreg ln_amount3GG abs_dist_nom share_sen_party share_sen_maj_party sen_share_pres_party ln_state_spend_other_cntys abs_dist_nomXln_state_spend $X $Z i.year if cntysamp==1, fe i(cmfe) cluster(fips_state)
	
	estout using "senate_effects.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom share_sen_party share_sen_maj_party sen_share_pres_party ln_state_spend_other_cntys $X $Z _cons) ///
		order(abs_dist_nom share_sen_party share_sen_maj_party sen_share_pres_party ln_state_spend_other_cntys $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1)" "(2)" "(3)") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace

	* Run with each as its own entry
	use ABH_full_county_mod, clear
		* Have to relabel some variables
	label variable abs_dist_nom "Absolute distance from median"
	label variable abs_rank_nom100 "Absolute rank from median (/100)"
	label variable abs_dist_cvp "Distance (CVP) from median"
	label variable abs_rank_cvp100 "Rank (CVP) from median (/100)"
	label variable abs_distsqrt_nom "Distance from median (sqrt)"
	label variable abs_distsq_nom "Distance from median (sq)"
	label variable ln_abs_dist_nom "Distance from median (ln)"
	label variable repubXabs_dist_nom "Distance x Republican"
	label variable demXabs_dist_nom "Distance x Democrat"	
	
	label variable any_chair "Committee chair" 
	label variable any_rank "Ranking minority member" 
	label variable leader "Party leader" 
	label variable mem_approps "Appropriations Committee" 
	label variable mem_waysmeans "Rules Committee" 
	label variable mem_waysmeans "Ways \& Means Committee" 
	label variable republican "Party" 
	label variable first_term "First term" 
	label variable tenure "Tenure (\# terms)" 
	label variable close_congelec_dist "Close election" 
	label variable winstate_margin_preselec_state "State presidential margin"
	
	label variable majXabs_dist_nom "Absolute distance x majority"
	label variable majXabs_dist_cvp "Abs distance x majority (CVP)"
	label variable unigov "Unified government"
	label variable majXunigov "Unif. gov't x majority"
	label variable abs_dist_nomXunigov "Unif. gov't x distance"
	label variable abs_dist_nomXmajXunigov "Unif. gov't x maj'ty x distance"
	label variable majXpolar_hou "Polar index x majority"
	label variable polar_houXabs_dist_nom "Polar index x distance"
	label variable majXpolar_houXabs_dist_nom "Polar index x maj'ty x distance"
	label variable abs_dist_cvpXunigov "Unif. gov't x distance (CVP)"
	label variable abs_dist_cvpXmajXunigov "Unif. gov't x maj'ty x distance (CVP)"

	label variable abs_dist_pty_nom "Distance from within party median"
	label variable abs_rank_pty_nom100 "Rank (/100) from w/in party median"
	label variable demXabs_dist_pty_nom "Distance from w/in Dem. party median"
	label variable repubXabs_dist_pty_nom "Distance from w/in Rep. party median"
	label variable majXabs_dist_pty_nom "Distance from w/in Maj. party median"
	label variable minXabs_dist_pty_nom "Distance from w/in Min. party median"

	label variable abs_dist_pty_nom_mean "Distance from within party mean"
	*label variable abs_dist_pty_cvp_mean "Distance from within party mean (CVP)"
	label variable majXabs_dist_pty_nom_mean "Abs dist pty mean x majority"
	label variable abs_dist_pty_nom_meanXunigov "Unif. gov't x abs dist pty mean"	
	
	label variable sectionI "Section I"
	label variable sectionII "Section II"
	label variable sectionIII "Maj on far side of median"
	label variable sectionIIIXabs_dist_nom "Maj far side of med X abs dist"
	label variable sectionIV "Section IV"
	label variable sectionV "Section V"
	
	label variable sectionI_cvp "Section I (CVP)"
	label variable sectionII_cvp "Section II (CVP)"
	label variable sectionIII_cvp "Section III (CVP)"
	label variable sectionIV_cvp "Section IV (CVP)"
	label variable sectionV_cvp "Section V (CVP)"
	
	label variable ln_income "Log income"
	label variable ln_popul "Log population"
	
save, replace	
	
	drop *_0*
	
	merge m:1 st_cnty_fips year using ABH_full_county, keepusing(fullcntysamp)
	
	estimates clear
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if fullcntysamp==1, fe i(cmfe) cluster(fips_state)
	
	* Run with the min distance from the median (need new FE)
	bysort year st_cnty_fips: egen min_abs_dist_nom = min(abs_dist_nom)
	gen min_dist_cnty = 1 if abs_dist_nom==min_abs_dist_nom
	egen cmfe_new = group(id_icpsr st_cnty_fips)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if fullcntysamp==1 & min_dist_cnty==1, fe i(cmfe_new) cluster(fips_state)
	
	* Run with the max distance from the median (need new FE)
	bysort year st_cnty_fips: egen max_abs_dist_nom = max(abs_dist_nom)
	gen max_dist_cnty = 1 if abs_dist_nom==max_abs_dist_nom
	egen cmfe_new2 = group(id_icpsr st_cnty_fips)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if fullcntysamp==1 & max_dist_cnty==1, fe i(cmfe_new2) cluster(fips_state)
	
	* Run with the district with the max coverage of the county (need new FE)
	recast float alloc_factor, force
	bysort year st_cnty_fips: egen max_alloc_factor = max(alloc_factor)
	gen max_cover_cnty = 1 if alloc_factor==max_alloc_factor
	egen cmfe_new3 = group(id_icpsr st_cnty_fips)
	eststo: xi: xtreg ln_amount3GG abs_dist_nom $X $Z i.year if fullcntysamp==1 & max_cover_cnty==1, fe i(cmfe_new3) cluster(fips_state)
	
	
	* OUTPUT
	estout using "cnty-urban-included.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		keep(abs_dist_nom $X $Z _cons) ///
		order(abs_dist_nom $X $Z _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1) All" "(2) Min dist" "(3) Max dist" "(4) Max share") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	

* District-Level
	use ABH_full_county, clear
	
	sort year fips_state dist
	quietly by year fips_state dist:  gen dup = cond(_N==1,0,_n)
	tab dup
	sort dup
	drop if dup>1
	drop dup
	tempfile county
	save `county'
		
	* Load District Data
	use ABH_full_district, clear
	drop if congress==.
	merge 1:1 year fips_state dist using `county', keep(master match) keepusing(cntysamp)
	drop _merge
	save, replace
	set more off
	
	drop *_0*

	* District: No formula
	estimates clear
	eststo: xi: xtreg ln_grants_nf abs_dist_nom $B i.year if  redist!=1, fe i(dmfe) cluster(fips_state)
		* Generate variable for observations used in county sample
		gen distsamp = 0
		replace distsamp = 1 if e(sample)==1
		label variable distsamp "Obs. used in dist analysis"
		save, replace
	eststo: xi: xtreg ln_grants_nf abs_dist_nom $B i.year if  redist100!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_nom $B i.year if  redist80!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_nom $B i.year if  redist!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_nom $B i.year if  redist100!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_nom $B i.year if  redist80!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
 
	estout using "district-dist1-noform-mfe.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		mgroups("Full Sample" "County-Analysis Sample Only", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		keep(abs_dist_nom $B _cons) ///
		order(abs_dist_nom $B _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1) CQ" "(2) 100\%" "(3) 80\%" "(4) CQ" "(5) 100\%" "(6) 80\%") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace

	* Summary Statistics
	label variable tenure "Tenure (# terms)" 
	sutex2 abs_dist_nom $B ln_grants_nf ln_grants_all if distsamp==1, saving(sum_stats_dist.tex) replace minmax tabular varlabels
	label variable tenure "Tenure (\# terms)" 	
	
	* District: All grants
	estimates clear
	eststo: xi: xtreg ln_grants_all abs_dist_nom $B i.year if  redist!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_all abs_dist_nom $B i.year if  redist100!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_all abs_dist_nom $B i.year if  redist80!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_all abs_dist_nom $B i.year if  redist!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_all abs_dist_nom $B i.year if  redist100!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_all abs_dist_nom $B i.year if  redist80!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
 
	estout using "district-dist1-allgrt-mfe.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		mgroups("Full Sample" "County-Analysis Sample Only", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		keep(abs_dist_nom $B _cons) ///
		order(abs_dist_nom $B _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1) CQ" "(2) 100\%" "(3) 80\%" "(4) CQ" "(5) 100\%" "(6) 80\%") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
	* District: CVP
	estimates clear
	eststo: xi: xtreg ln_grants_nf abs_dist_cvp $B i.year if  redist!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_cvp $B i.year if  redist100!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_cvp $B i.year if  redist80!=1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_cvp $B i.year if  redist!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_cvp $B i.year if  redist100!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
	eststo: xi: xtreg ln_grants_nf abs_dist_cvp $B i.year if  redist80!=1 & cntysamp==1, fe i(dmfe) cluster(fips_state)
 
	estout using "district-dist1-noform-mfe-cvp.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2_a N, fmt(%9.3f %9.0f) labels("Adj. \$R^2\$" "N")) ///
		collabels(none) style(tex) starlevels(* .10 ** .05 *** .01) label ///
		mgroups("Full Sample" "County-Analysis Sample Only", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		keep(abs_dist_cvp $B _cons) ///
		order(abs_dist_cvp $B _cons) ///
		varlabels(_cons "Constant") ///
		mlabels("(1) CQ" "(2) 100\%" "(3) 80\%" "(4) CQ" "(5) 100\%" "(6) 80\%") ///
		prehead("\resizebox{\textwidth}{!}{" "\begin{tabular}{{l}*{@M}{c}}" "\hline") ///
		posthead(\hline) prefoot(\hline) ///
		postfoot("\hline" "\end{tabular}" "}") replace
	
