*****************************************************************************************
* Stata program 
* For Pakistan sectarian violence project
* Analysis file with table and figure code
*
* Original author: Gareth Nellis, Yale University (December, 2015)
* Final check and revision, September 2017
*****************************************************************************************

* Preliminaries
	clear all
	version 12.0
	set more off

* A global macro ("pathin") for the folder holding the datasets	
	global pathin "/Users/gareth/Dropbox/Pakistan_electoral_violence/Dataset construction/Analysis_datasets"

* A global macro ("pathout") for the destination folder for output
	global pathout "$pathout"


********************
* Main paper
********************

* Figure 1
use "$pathin/dalp_expert_evaluations.dta", clear
	hist d4bin, by(partyorder, col(2) note("")) discrete freq scheme(s1mono) xline() gap(0) xscale(range(-0.5 1.5))  barwidth(0.5) xlabel(0 1, valuelabel) ytitle("Frequency of Expert Response") xtitle("Majoritarian?", size(small)) name(g1, replace)
	hist d7_pakbin, by(partyorder, col(2) note("")) discrete freq scheme(s1mono) xline() gap(0) xscale(range(-0.5 1.5))  barwidth(0.5) xlabel(0 1, valuelabel) ytitle("") xtitle("Forcefully Combat Militancy?" , size(small)) name(g2, replace)
	hist dwbin, by(partyorder, col(2) note("")) discrete freq scheme(s1mono) xline() gap(0) xscale(range(-0.5 1.5))  barwidth(0.5) xlabel(0 1, valuelabel) ytitle("") xtitle("Left-Right Scale", size(small)) name(g3, replace)
	hist a8_3, by(partyorder, col(2) note("")) discrete freq scheme(s1mono) xline() gap(0) xscale(range(-0.5 1.5))  barwidth(0.5) xlabel(0 1, valuelabel) ytitle("") xtitle("Religious Organization Links?", size(small)) name(g4, replace)
		gr combine g1 g2 g3 g4, col(4)
			cd "$pathout"
			graph export "expert_coding.pdf", replace

* Figure 2
use "$pathin/mna_close_elections_final.dta", clear
	keep if rank==1
	
	gen province_name=""
	replace province_name="Punjab" if provn==1
	replace province_name="Sindh" if provn==2
	replace province_name="Balochistan" if provn==3
	replace province_name="NWFP" if provn==4
	replace province_name="Islamabad" if provn==6
	
	gen freq = 1
	label var freq "Number of close elections" 
	
	tab province_name
	
	graph bar (sum) freq, over(province, label(angle(45))) ytitle("Number of close elections") name(g1, replace) title("Number of close elections by province")
	graph bar (sum) freq, over(year, label(angle(45))) ytitle("Number of close elections") name(g2, replace) title("Number of close elections by year")
	graph combine g1 g2, ycommon
	cd "$pathout"
	graph export "external_validity.pdf", replace


* Figure 3
use "$pathin/final_dataset.dta", clear
	set more off
	preserve
		parmby "xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if police_stations_pc > police_stations_pc_median, cl(cluster_var)", lab saving(test1, replace) idn(1) ids(Unadjusted)
		parmby "xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if police_stations_pc <= police_stations_pc_median, cl(cluster_var)", lab saving(test2, replace) idn(2) ids(Unadjusted)
	
		drop _all
		append using test1 test2
		sencode parm, gen(parmid)
		keep if parmseq==1
		
		eclplot estimate min95 max95 idnum, ///
		  eplottype(scatter) rplottype(rcap) horizontal ///
		  estopts( msize(large) mcolor(black) sort ) ///
		  scheme(s1mono) ciopts( blcolor(black) msize(vlarge) ) ///
		  xline( 0, lpattern(shortdash) style(default) ) xtitle("Effect size") ytitle("") ///
		  yscale(range(0.5 2.5)) ylabel(1 "YES [225]" 2 "NO [212]", grid glcolor(gs13) labsize()) ///
		  xlabel(, grid glcolor(gs13) labsize()) title("(A)  DV: Any violence    Model: 2SLS", size(medium)) subtitle("Above median police-stations per voter?", size(medium)) name(g1, replace)  
	restore
	
	set more off
	preserve
		parmby "xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if police_stations_pc > police_stations_pc_median, cl(cluster_var)", lab saving(test3, replace) idn(1) ids(Unadjusted)
		parmby "xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if police_stations_pc <= police_stations_pc_median, cl(cluster_var)", lab saving(test4, replace) idn(2) ids(Unadjusted)
	
		drop _all
		append using test3 test4
		sencode parm, gen(parmid)
		keep if parmseq==1
		
		eclplot estimate min95 max95 idnum, ///
		  eplottype(scatter) rplottype(rcap) horizontal ///
		  estopts( msize(large) mcolor(black) sort ) ///
		  scheme(s1mono) ciopts( blcolor(black) msize(vlarge) ) ///
		  xline( 0, lpattern(shortdash) style(default) ) xtitle("Effect size") ytitle("") ///
		  yscale(range(0.5 2.5)) ylabel(1 "YES [225]" 2 "NO [212]", grid glcolor(gs13) labsize()) ///
		  xlabel(, grid glcolor(gs13) labsize()) title("(B)  DV: Event count (ln)    Model: 2SLS", size(medium)) subtitle("Above median police-stations per voter?", size(medium)) name(g2, replace)  
	restore
	
	preserve
		parmby "xi: reg any_violence secular_close_win_dummy i.province if no_secular_close_race==1 & police_stations_pc > police_stations_pc_median, cl(cluster_var)", lab saving(test5, replace) idn(1) ids(Unadjusted)	
		parmby "xi: reg any_violence secular_close_win_dummy i.province if no_secular_close_race==1 & police_stations_pc <= police_stations_pc_median, cl(cluster_var)", lab saving(test6, replace) idn(2) ids(Unadjusted)
	
		drop _all
		append using test5 test6
		sencode parm, gen(parmid)
		keep if parmseq==1
		
		eclplot estimate min95 max95 idnum, ///
		  eplottype(scatter) rplottype(rcap) horizontal ///
		  estopts( msize(large) mcolor(black) sort ) ///
		  scheme(s1mono) ciopts( blcolor(black) msize(vlarge) ) ///
		  xline( 0, lpattern(shortdash) style(default) ) xtitle("Effect size") ytitle("") ///
		  yscale(range(0.5 2.5)) ylabel(1 "YES [22]" 2 "NO [37]", grid glcolor(gs13) labsize()) ///
		  xlabel(, grid glcolor(gs13) labsize()) title("(C)  DV: Any violence    Model: Diff-in-means", size(medium)) subtitle("Above median police-stations per voter?", size(medium)) name(g3, replace)  
	restore

	preserve
		parmby "xi: reg ln_eventcount secular_close_win_dummy i.province if no_secular_close_race==1 & police_stations_pc > police_stations_pc_median, cl(cluster_var)", lab saving(test7, replace) idn(1) ids(Unadjusted)	
		parmby "xi: reg ln_eventcount secular_close_win_dummy i.province if no_secular_close_race==1 & police_stations_pc <= police_stations_pc_median, cl(cluster_var)", lab saving(test8, replace) idn(2) ids(Unadjusted)
	
		drop _all
		append using test7 test8
		sencode parm, gen(parmid)
		keep if parmseq==1
		
		eclplot estimate min95 max95 idnum, ///
		  eplottype(scatter) rplottype(rcap) horizontal ///
		  estopts( msize(large) mcolor(black) sort ) ///
		  scheme(s1mono) ciopts( blcolor(black) msize(vlarge) ) ///
		  xline( 0, lpattern(shortdash) style(default) ) xtitle("Effect size") ytitle("") ///
		  yscale(range(0.5 2.5)) ylabel(1 "YES [22]" 2 "NO [37]", grid glcolor(gs13) labsize()) ///
		  xlabel(, grid glcolor(gs13) labsize()) title("(D)  DV: Event count (ln)    Model: Diff-in-means", size(medium)) subtitle("Above median police-stations per voter?", size(medium)) name(g4, replace)  
	restore

	graph combine g1 g2 g3 g4
	cd "$pathout"
	graph export "capacity_mechanisms1.pdf", replace
	



* Table 1
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_lagged_violence secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_lagged_eventcount secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_lagged_killed secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_lagged_numberkilled secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_lagged_duration secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using rob_lagged_violence_ivls.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	


* Table 2
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	
		

* Table 3
use "$pathin/final_dataset.dta", clear
	xi: reg any_violence secular_close_win_dummy i.province if no_secular_close_race==1, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: reg ln_eventcount secular_close_win_dummy i.province if no_secular_close_race==1, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: reg any_killed secular_close_win_dummy i.province if no_secular_close_race==1, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: reg ln_numberkilled secular_close_win_dummy i.province if no_secular_close_race==1, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: reg ln_duration secular_close_win_dummy i.province if no_secular_close_race==1, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using diff_in_means.tex, ///
				replace order(secular_close_win_dummy) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	


* Table 4
use "$pathin/final_dataset.dta", clear
	xi: reg any_lagged_killed secular_close_race, cl(cluster_var)
	est store r1
	estadd local clusterFE "N"
	estadd local provinceXyearFE "N"
	
	xi: reg any_lagged_killed secular_close_race i.cluster_var, cl(cluster_var)
	est store r2
	estadd local clusterFE "Y"
	estadd local provinceXyearFE "N"
	
	xi: reg any_lagged_killed secular_close_race i.cluster_var i.province_year, cl(cluster_var)
	est store r3
	estadd local clusterFE "Y"
	estadd local provinceXyearFE "Y"
	
	xi: nbreg lagged_eventcount secular_close_race, cl(cluster_var)
	est store r4
	estadd local clusterFE "N"
	estadd local provinceXyearFE "N"
	
	xi: nbreg lagged_eventcount secular_close_race i.cluster_var, cl(cluster_var)
	est store r5
	estadd local clusterFE "Y"
	estadd local provinceXyearFE "N"
	
	xi: nbreg lagged_eventcount secular_close_race  i.cluster_var i.province_year, cl(cluster_var)
	est store r6
	estadd local clusterFE "Y"
	estadd local provinceXyearFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 r6 using closeelections_violence.tex, ///
				replace order(secular_close_race) ///
				drop(_cons _Icluster_v_* _Iprovince__*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(clusterFE provinceXyearFE N, fmt(%9.0fc %9.0fc %9.0fc %9.0fc) ///
				label("Cluster FEs" "Province-Year FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \toprule") ///
				posthead("\textit{Dependent variable:} & \multicolumn{3}{c}{Any event} & \multicolumn{3}{c}{Event count}  \\ \cmidrule(rl){2-4} \cmidrule(rl){5-7} \textit{Model:} & \multicolumn{3}{c}{OLS} & \multicolumn{3}{c}{Negative binomial} \\ \cmidrule(rl){1-7} ")	


* Table 5
use "$pathin/final_dataset.dta", clear
	xi: reg secular_vote_prop_current interaction any_event_6m_neg1 prop_secular_incumbent_tmin1 i.cluster_var if (year !=1988), cl(cluster_var)
	est store r1
	estadd local clusterFE "Y"
	estadd local provinceyrFE "N"

	xi: reg secular_vote_prop_current interaction2 ln_eventcount_6m_neg1_placebo prop_secular_incumbent_tmin1 i.cluster_var if (year !=1988), cl(cluster_var)
	est store r2
	estadd local clusterFE "Y"
	estadd local provinceyrFE "N"
	
	xi: reg secular_vote_prop_current interaction any_event_6m_neg1 prop_secular_incumbent_tmin1 i.cluster_var i.province_year if (year !=1988), cl(cluster_var)
	est store r3
	estadd local clusterFE "Y"
	estadd local provinceyrFE "Y"


	xi: reg secular_vote_prop_current interaction2 ln_eventcount_6m_neg1_placebo prop_secular_incumbent_tmin1 i.cluster_var i.province_year if (year !=1988), cl(cluster_var)
	est store r4
	estadd local clusterFE "Y"
	estadd local provinceyrFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 using electoral_incentives.tex, ///
				replace order(interaction interaction2) ///
				drop(_cons _Icluster_v_* _Iprovince__*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(clusterFE provinceyrFE N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Cluster FEs" "Province-Year FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{5}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{4}{c}{Secular-Party Vote Share (t)}  \\ \cmidrule(rl){1-5} ")	


* Table 6
use "$pathin/mna_close_elections_final.dta", clear
	eststo secular_party_NO: quietly estpost summarize ///
	    sect feudal first_election elections_won_previously elections_cont_previously cab_after_elec cabinet_position swiched_btw_sec_nonsec if secular_party == 0
	eststo secular_party_YES: quietly estpost summarize ///
	    sect feudal first_election elections_won_previously elections_cont_previously cab_after_elec cabinet_position swiched_btw_sec_nonsec if secular_party == 1
	eststo diff: quietly estpost ttest ///
	    sect feudal first_election elections_won_previously elections_cont_previously cab_after_elec cabinet_position swiched_btw_sec_nonsec, by(secular_party) unequal
	
				cd "$pathout"
				esttab secular_party_NO secular_party_YES diff using pol_characteristics.tex, ///
				cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) se(pattern(0 0 1) par fmt(2))") ///
				nomti label nonum stats(N, fmt(%9.0fc) label("\textit{N}")) replace star(* 0.10 ** 0.05 *** 0.01)  se booktabs eqlabels(none) ///
				collabels(none) nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \toprule") ///
				posthead("\textit{} & \multicolumn{4}{c}{\textit{Candidate Party Type}"}  \\ "\textit{} & \multicolumn{2}{c}{Non-Secular} & \multicolumn{2}{c}{Secular} & \multicolumn{2}{c}{Difference of Means}  \\ \cmidrule(rl){2-3} \cmidrule(rl){4-5} \cmidrule(rl){6-7}  & \multicolumn{1}{c}{[A]}  & \multicolumn{1}{c}{SD[A]} & \multicolumn{1}{c}{[B]}  & \multicolumn{1}{c}{SD[B]} & \multicolumn{1}{c}{[A]-[B]} & \multicolumn{1}{c}{SE([B]-[A])} \\ \cmidrule(rl){1-7} ")	
	

********************
* Supplementary appendix
********************

* Figure A1
use "$pathin/polityIV.dta", clear
	line polity year if year>1980, by(muslim_majority, note("")) scheme(s1mono) caption("")
	cd "$pathout"
	graph export "polityiv.pdf", replace


* Figure A2
use "$pathin/final_dataset.dta", clear
	la var year "Election cycle"
	collapse (sum) eventcount, by(year)
	graph bar eventcount, over(year) ytitle(Number of violent events)
	cd "$pathout"
	graph export "violence_by_year.pdf", replace


* Figure A3
use "$pathin/mccrary.dta", clear
	hist secular_mov, bin(30) xtitle(Secular party margin of victory/loss (against non-secular party))
	cd "$pathout"
	graph export "mov_histogram.pdf", replace


* Figure A4
* Requires ado file, available at, http://eml.berkeley.edu/~jmccrary/DCdensity/DCdensity.ado
* Credit to Eric Meyersson: adapted his code from the article "Islamic Rule and the Empowerment of the Poor and Pious"
use "$pathin/mccrary.dta", clear
		DCdensity secular_mov, breakpoint(0) generate(Xj Yj r0 fhat se_fhat)  nograph
		keep Z Yj Xj r0 fhat se_fhat
	
		gen fu=fhat+1.96*se_fhat
		gen fl=fhat-1.96*se_fhat
	
		global rvX "Xj>-1 & Xj<1"
		global rvR "r0>-1 & r0<1"
		global gr "gray"
		
		local theta2: display %5.3f r(theta)
		local tse: display %5.3f r(se)
	
	twoway scatter Yj Xj if $rvX, msymbol()   color($gr) ///
		|| line fhat r0 if r0>0 & $rvR, lcolor(black) lwidth(medthick) ///
			|| line fhat r0 if r0<0 & $rvR, lcolor(black) lwidth(medthick) ///
				|| line fu r0 if r0<0 & $rvR, lwidth(vthin) lpattern(longdash) lcolor($gr) ///
					|| line fu r0 if r0>0 & $rvR, lwidth(vthin) lpattern(longdash) lcolor($gr) ///
						|| line fl r0 if r0<0 & $rvR, lwidth(vthin) lpattern(longdash) lcolor($gr) ///
							|| line fl r0 if r0>0 & $rvR, lwidth(vthin) lpattern(longdash) lcolor($gr) ///
								 legend(off) ylabel(0(0.5)2.5, nogrid) xline(0, lwidth(vthin) lpattern(shortdash) lcolor(gs8)) ///
									plotregion(lpattern(solid) lcolor(gs4)) ///
										xscale(lcolor(none)) yscale(lcolor(none)) ///
											graphregion(color(white) lcolor(white) lwidth(thick)) saving(grDCall.gph, replace) ///
													note("Discontinuity Estimate = `theta2', Standard Error =  `tse'") ///
														xtitle("Secular party margin of victory/loss") ytitle("Density")
		cd "$pathout"
		graph export "mccrary_test.pdf", replace
	

* Table A1
use "$pathin/final_dataset.dta", clear
	xi: reg secular_win secular_close_win secular_close_race i.province, cl(cluster_var)
 	/* test secular_close_win  RUN THIS COMMAND TO OBTAIN FIRST-STAGE F-STAT */
	est store r1
	estadd local Fstat "53.91"
	estadd local provinceFE "Y"


				cd "$pathout"
				esttab r1 using first_stage.tex, ///
				replace order(secular_close_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(Fstat provinceFE N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("F-stat. on Prop. secularist close win" "Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{2}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Prop. secular win} \\  \cmidrule(rl){1-2} ")	



* Table A2
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls area secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"

	xi: ivregress 2sls pacca_pct secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"

	xi: ivregress 2sls electricity_pct secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"

	xi: ivregress 2sls gas_pct secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"

	xi: ivregress 2sls lit_t secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

	xi: ivregress 2sls lit_f secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r6
	estadd local provinceFE "Y"

	xi: ivregress 2sls pri_sch_pc secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r7
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 r6 r7 using census_balance1.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{8}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Area} & \multicolumn{1}{c}{Pacca} & \multicolumn{1}{c}{Electricity} & \multicolumn{1}{c}{Gas} & \multicolumn{1}{c}{Total literacy} & \multicolumn{1}{c}{Female literacy}  & \multicolumn{1}{c}{Primary schools} \\  & \multicolumn{1}{c}{} & \multicolumn{1}{c}{Prop. HHs} & \multicolumn{1}{c}{(Prop. HHs)} & \multicolumn{1}{c}{(Prop. HHs)} & \multicolumn{1}{c}{(Prop.)} & \multicolumn{1}{c}{(Prop.)} & \multicolumn{1}{c}{(Per capita)} \\ \cmidrule(rl){1-8} ")	

* Table A3
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls lagged_rice_area secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls lagged_rice_productivity secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls lagged_wheat_area secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls lagged_wheat_productivity secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
		
				cd "$pathout"
				esttab r1 r2 r3 r4 using ag_balance.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{5}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Rice area} & \multicolumn{1}{c}{Rice yield} & \multicolumn{1}{c}{Wheat area} & \multicolumn{1}{c}{Wheat yield} \\ \cmidrule(rl){1-5} ")	

* Table A4
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls regist_ooos secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"

	xi: ivregress 2sls police_stations_pc secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"

	xi: ivregress 2sls princely_state secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 using other_balance.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{4}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Total registered voters (000s)} & \multicolumn{1}{c}{Police stations per 100,000} & \multicolumn{1}{c}{Princely state pre-1947} \\ \cmidrule(rl){1-4} ")	

* Table A5
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls prop_secular_incumbent_tmin1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"

	xi: ivregress 2sls prop_secular_incumbent_tmin1 secular_close_race (secular_win = secular_close_win) i.province if year !=1988, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"

	xi: ivregress 2sls secularvotes_t_min1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls turnout_tmin1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"

	xi: ivregress 2sls lagged_margin_victory secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using rob_lagged_rhs_ivls.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{\% Secular-held} & \multicolumn{1}{c}{\% Secular-held} & \multicolumn{1}{c}{Secular-party} & \multicolumn{1}{c}{Turnout} & \multicolumn{1}{c}{Margin} \\  & \multicolumn{1}{c}{} & \multicolumn{1}{c}{(excl. 1977)} & \multicolumn{1}{c}{voteshare} & \multicolumn{1}{c}{} & \multicolumn{1}{c}{of victory} \\  \cmidrule(rl){1-6} ")	


* Table A6
use "$pathin/final_dataset.dta", clear
	la var secular_close_race "Prop. secularist close race (3 percent)" 
	la var secular_close_win "Prop. secularist close win (3 percent)"

	global census_vars "pacca_pct electricity_pct gas_pct pri_sch_pc lit_t lit_f"
	global nonrel_vars "any_eventcount_non_rel_ethnic eventcount_non_rel_ethnic any_eventcount_non_rel_pubserv eventcount_non_rel_pubservices murder motor_vehicle_theft"
	global align_vars "aligned_win aligned_close_race aligned_close_win"

	global other_vars "regist area_gis princely_state"
	global ag_vars "lagged_rice_area lagged_rice_productivity lagged_wheat_area lagged_wheat_productivity"
	global lagged_ivs "prop_secular_incumbent_tmin1 secularvotes_t_min1 lagged_margin_victory turnout_tmin1"
	global dvs "any_violence eventcount any_killed numberkilled duration"
	global rhs3pct "secular_win secular_close_win secular_close_race"
	global rhs_other "secular_win secular_close_race_2pct secular_close_win_2pct secular_close_race_2p5pct secular_close_win_2p5pct secular_close_race secular_close_win secular_close_race_3p5pct secular_close_win_3p5pct secular_close_race_4pct secular_close_win_4pct"
	global mechanisms "police_stations_pc"
				
				estpost tabstat $dvs $mechanisms $lagged_ivs $census_vars $ag_vars $other_vars $nonrel_vars $rhs_other $align_vars, statistics(mean sd count min max) columns(statistics)
				eststo A
				cd "$pathout"
				esttab A using summ.tex, cells("mean(fmt(2)) sd min max count(fmt(0))") noobs replace bookt compress label nodepvar nonumber nomti ///
				collabels("{Mean}" "{Std. Dev.}" "{Min}" "{Max}" "{N}") ///
				refcat(any_violence "\rule{0pt}{4ex}\emph{Dependent Variables}" police_stations_pc "\rule{0pt}{4ex}\emph{Capacity Mechanisms}" prop_secular_incumbent_tmin1 "\rule{0pt}{4ex}\emph{Lagged Independent Variables}" pacca_pct "\rule{0pt}{4ex}\emph{Census Variables}" lagged_rice_area "\rule{0pt}{4ex}\emph{Agricultural Variables}" regist "\rule{0pt}{4ex}\emph{Other Characteristics}" any_eventcount_non_rel_ethnic  "\rule{0pt}{4ex}\emph{Non-Religious Dependent Variables}" secular_win "\rule{0pt}{4ex}\emph{Right-Hand-Side Variables (Alternative Bandwidths)}" aligned_win "\rule{0pt}{4ex}\emph{Alignment Analysis Variables}", nolabel)

* Table A7
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race_2pct (secular_win = secular_close_win_2pct) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race_2pct (secular_win = secular_close_win_2pct) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race_2pct (secular_win = secular_close_win_2pct) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race_2pct (secular_win = secular_close_win_2pct) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race_2pct (secular_win = secular_close_win_2pct) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using rob_bandwidth_2pct.tex, ///
				replace order(secular_win secular_close_race_2pct) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A8
use "$pathin/final_dataset.dta", clear	
	xi: ivregress 2sls any_violence secular_close_race_2p5pct (secular_win = secular_close_win_2p5pct) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race_2p5pct (secular_win = secular_close_win_2p5pct) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race_2p5pct (secular_win = secular_close_win_2p5pct) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race_2p5pct (secular_win = secular_close_win_2p5pct) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race_2p5pct (secular_win = secular_close_win_2p5pct) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using rob_bandwidth_2p5pct.tex, ///
				replace order(secular_win secular_close_race_2p5pct) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A9
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race_3p5pct (secular_win = secular_close_win_3p5pct) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race_3p5pct (secular_win = secular_close_win_3p5pct) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race_3p5pct (secular_win = secular_close_win_3p5pct) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race_3p5pct (secular_win = secular_close_win_3p5pct) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race_3p5pct (secular_win = secular_close_win_3p5pct) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using rob_bandwidth_3p5pct.tex, ///
				replace order(secular_win secular_close_race_3p5pct) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A10
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race_4pct (secular_win = secular_close_win_4pct) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race_4pct (secular_win = secular_close_win_4pct) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race_4pct (secular_win = secular_close_win_4pct) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race_4pct (secular_win = secular_close_win_4pct) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race_4pct (secular_win = secular_close_win_4pct) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using rob_bandwidth_4pct.tex, ///
				replace order(secular_win secular_close_race_4pct) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	
				
* Table A11
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if year!=1988, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if year!=1988, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if year!=1988, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if year!=1988, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if year!=1988, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min1988.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A12
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if year!=1990, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if year!=1990, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if year!=1990, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if year!=1990, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if year!=1990, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min1990.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A13
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if year!=1993, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if year!=1993, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if year!=1993, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if year!=1993, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if year!=1993, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min1993.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A14
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if year!=1997, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if year!=1997, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if year!=1997, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if year!=1997, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if year!=1997, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min1997.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A15
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if year!=2002, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if year!=2002, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if year!=2002, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if year!=2002, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if year!=2002, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min2002.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A16
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if year!=2008, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if year!=2008, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if year!=2008, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if year!=2008, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if year!=2008, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min2008.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A17
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if karachi_balochistan !=1, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if karachi_balochistan !=1, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if karachi_balochistan !=1, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if karachi_balochistan !=1, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if karachi_balochistan !=1, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min_karachi_bal.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	
 
* Table A18
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province if province !="Punjab", cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province if province !="Punjab", cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province if province !="Punjab", cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province if province !="Punjab", cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province if province !="Punjab", cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_min_punjab.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A19
use "$pathin/final_dataset.dta", clear
	xi: probit any_violence secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: nbreg eventcount secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: probit any_killed secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: nbreg numberkilled secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: nbreg duration secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_reducedform_negbin.tex, ///
				replace order(secular_close_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\ \textit{Model:}  & \multicolumn{1}{c}{(Probit)} & \multicolumn{1}{c}{(NegBin)} & \multicolumn{1}{c}{(Probit)} & \multicolumn{1}{c}{(NegBin)} & \multicolumn{1}{c}{(NegBin)} \\ \cmidrule(rl){1-6} ")	

* Table A20
use "$pathin/final_dataset.dta", clear
	xi: logit any_violence secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: poisson eventcount secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: logit any_killed secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: poisson numberkilled secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: poisson duration secular_close_win secular_close_race i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_reducedform_poisson.tex, ///
				replace order(secular_close_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\ \textit{Model:}  & \multicolumn{1}{c}{(Logit)} & \multicolumn{1}{c}{(Poisson)} & \multicolumn{1}{c}{(Logit)} & \multicolumn{1}{c}{(Poisson)} & \multicolumn{1}{c}{(Poisson)} \\ \cmidrule(rl){1-6} ")	

* Table A21
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win), cl(cluster_var)
	est store r1
	estadd local provinceFE "N"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win), cl(cluster_var)
	est store r2
	estadd local provinceFE "N"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win), cl(cluster_var)
	est store r3
	estadd local provinceFE "N"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win), cl(cluster_var)
	est store r4
	estadd local provinceFE "N"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win), cl(cluster_var)
	est store r5
	estadd local provinceFE "N"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_noFE.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	
 
* Table A22
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province i.year, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	estadd local yearFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province i.year, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	estadd local yearFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province i.year, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	estadd local yearFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province i.year, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	estadd local yearFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province i.year, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
	estadd local yearFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_yearFE.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_* _Iyear_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE yearFE N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Province FEs" "Election-year FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A23
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.cluster_var, cl(cluster_var)
	est store r1
	estadd local clusterFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.cluster_var, cl(cluster_var)
	est store r2
	estadd local clusterFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.cluster_var, cl(cluster_var)
	est store r3
	estadd local clusterFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.cluster_var, cl(cluster_var)
	est store r4
	estadd local clusterFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.cluster_var, cl(cluster_var)
	est store r5
	estadd local clusterFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_clusterFE.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Icluster_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(clusterFE N, fmt(%9.0fc %9.0fc) ///
				label("Cluster-district FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A24
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) i.province year, cl(cluster_var)
	est store r1
	estadd local linearTT "Y"
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) i.province year, cl(cluster_var)
	est store r2
	estadd local linearTT "Y"
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) i.province year, cl(cluster_var)
	est store r3
	estadd local linearTT "Y"
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) i.province year, cl(cluster_var)
	est store r4
	estadd local linearTT "Y"
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) i.province year, cl(cluster_var)
	est store r5
	estadd local linearTT "Y"
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_linear_tt.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_* year) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(linearTT provinceFE N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Linear time trend" "Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	
		
* Table A25
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	estadd local margins "Linear"
	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	estadd local margins "Linear"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	estadd local margins "Linear"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	estadd local margins "Linear"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
	estadd local margins "Linear"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_cf_margins1.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_* byseat_sec_mov*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE margins N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Province FEs" "Secular margins controls" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A26
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	estadd local margins "Square"

	
	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	estadd local margins "Square"

	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	estadd local margins "Square"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	estadd local margins "Square"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
	estadd local margins "Square"
	
					
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_cf_margins2.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_* byseat_sec_mov*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE margins N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Province FEs" "Secular margins controls" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A27
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 byseat_sec_movCUB1-byseat_sec_movCUB20 i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	estadd local margins "Cubic"

	xi: ivregress 2sls ln_eventcount secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 byseat_sec_movCUB1-byseat_sec_movCUB20 i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	estadd local margins "Cubic"
	
	xi: ivregress 2sls any_killed secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 byseat_sec_movCUB1-byseat_sec_movCUB20 i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	estadd local margins "Cubic"
	
	xi: ivregress 2sls ln_numberkilled secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 byseat_sec_movCUB1-byseat_sec_movCUB20 i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	estadd local margins "Cubic"
	
	xi: ivregress 2sls ln_duration secular_close_race (secular_win = secular_close_win) byseat_sec_mov1-byseat_sec_mov20 byseat_sec_movSQ1-byseat_sec_movSQ20 byseat_sec_movCUB1-byseat_sec_movCUB20 i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
	estadd local margins "Cubic"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using main_ivls_cf_margins3.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_* byseat_sec_mov*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE margins N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Province FEs" "Secular margins controls" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A28
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence_inclusion secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_inclusion secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"

	xi: ivregress 2sls any_violence_robust2 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_robust2 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"

	xi: ivregress 2sls any_violence_robust3 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_robust3 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r6
	estadd local provinceFE "Y"

	xi: ivregress 2sls any_violence_robust4 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r7
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_robust4 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r8
	estadd local provinceFE "Y"

	xi: ivregress 2sls any_violence_robust5 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r9
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_robust5 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r10
	estadd local provinceFE "Y"

	xi: ivregress 2sls any_violence_robust6 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r11
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_robust6 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r12
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 using bfrs_pruning.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{13}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{2}{c}{(1)} & \multicolumn{2}{c}{(2)} & \multicolumn{2}{c}{(3)} & \multicolumn{2}{c}{(4)} & \multicolumn{2}{c}{(5)} & \multicolumn{2}{c}{(6)}  \\ \cmidrule(rl){2-3} \cmidrule(rl){4-5}  \cmidrule(rl){4-5}  \cmidrule(rl){6-7}  \cmidrule(rl){8-9}  \cmidrule(rl){10-11}  \cmidrule(rl){12-13} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Count (ln)} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Count (ln)} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Count (ln)} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Count (ln)} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Count (ln)} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Count (ln)} \\ \cmidrule(rl){1-13} ")	

* Table A29
use "$pathin/final_dataset.dta", clear

xi: ivregress 2sls gtb_any_violence secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
			est store r1
			estadd local provinceFE "Y"

xi: ivregress 2sls ln_gtb_eventcount secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
			est store r2
			estadd local provinceFE "Y"

xi: ivregress 2sls gtb_any_violence secular_close_race (secular_win = secular_close_win), cl(cluster_var)
			est store r3
			estadd local provinceFE "N"
			
xi: ivregress 2sls ln_gtb_eventcount secular_close_race (secular_win = secular_close_win), cl(cluster_var)
			est store r4
			estadd local provinceFE "N"

xi: probit gtb_any_violence secular_close_win secular_close_race i.province, cl(cluster_var)
			est store r5
			estadd local provinceFE "Y"
			
xi: nbreg gtb_eventcount secular_close_win secular_close_race i.province, cl(cluster_var)
			est store r6
			estadd local provinceFE "Y"

xi: probit gtb_any_violence secular_close_win secular_close_race, cl(cluster_var)
			est store r7
			estadd local provinceFE "N"
			
xi: nbreg gtb_eventcount secular_close_win secular_close_race, cl(cluster_var)
			est store r8
			estadd local provinceFE "Y"
				
			cd "$pathout"
			esttab r1 r2 r3 r4 r5 r6 r7 r8 using gtb_binary_dv.tex, ///
			replace order(secular_win secular_close_race) ///
			drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
			star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
			label eqlabels(none) nonum wrap varwidth(40) ///
			stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
			label("Province FEs" "\textit{N}")) ///
			note("") ///
			nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{9}{c}} \toprule") ///
			posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count}  \\   & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} \\	\cmidrule(rl){2-5} \cmidrule(rl){6-6} \cmidrule(rl){7-7} \cmidrule(rl){8-8} \cmidrule(rl){9-9} Model:  & \multicolumn{4}{c}{2SLS} & \multicolumn{1}{c}{Probit RF} & \multicolumn{1}{c}{NegBin RF} & \multicolumn{1}{c}{Probit RF} & \multicolumn{1}{c}{NegBin RF} \\ \cmidrule(rl){1-9} ")
			


* Table A30
use "$pathin/final_dataset.dta", clear
	gen collapsevar=1
	collapse (sum) no_secular_close_race_2pct (sum)  no_secular_close_race_2p5pct (sum)  no_secular_close_race_3p5pct (sum)  no_secular_close_race_4pct (sum)  no_secular_close_race, by(collapsevar)
	drop collapsevar

	la var no_secular_close_race_2pct "2.0 percent"
	la var no_secular_close_race_2p5pct "2.5 percent"
	la var no_secular_close_race "3.0 percent"
	la var no_secular_close_race_3p5pct "3.5 percent"
	la var no_secular_close_race_4pct "4.0 percent"

	set more off
	estpost tabstat no_secular_close_race_2pct no_secular_close_race_2p5pct no_secular_close_race no_secular_close_race_3p5pct no_secular_close_race_4pct, statistics(mean) columns(statistics)
	eststo A
	cd "$pathout"
	esttab A using no_close_elections.tex, cells("mean(fmt(0))") noobs replace bookt compress label nodepvar nonumber nomti ///
	collabels("{Count}") 



* Table A31
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence_t_plus1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount_t_plus1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed_t_plus1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled_t_plus1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration_t_plus1 secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"
				
				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using violence_t_plus1.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{T+1 (Binary)} & \multicolumn{1}{c}{T+1 (Ln)} & \multicolumn{1}{c}{T+1 (Binary)} & \multicolumn{1}{c}{T+1 (Ln)} & \multicolumn{1}{c}{T+1 (Ln)} \\ \cmidrule(rl){1-6} ")	
		
* Table A32
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_eventcount_non_rel_ethnic secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount_non_rel_ethnic secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"

	xi: ivregress 2sls any_eventcount_non_rel_pubserv secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_eventcount_non_rel_pubserv secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_murder secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

	xi: ivregress 2sls ln_motor_vehicle_theft secular_close_race (secular_win = secular_close_win) i.province, cl(cluster_var)
	est store r6
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 r6 using non_rel_violence.tex, ///
				replace order(secular_win secular_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Ethnic} & \multicolumn{1}{c}{Ethnic} & \multicolumn{1}{c}{Pub. Services} & \multicolumn{1}{c}{Pub. Services} & \multicolumn{1}{c}{Murder} & \multicolumn{1}{c}{Vehicle Theft} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln count)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln count)} & \multicolumn{1}{c}{(Ln count)} & \multicolumn{1}{c}{(Ln count)} \\ \cmidrule(rl){1-7} ")	

* Table A33
use "$pathin/final_dataset.dta", clear
	xi: ivregress 2sls any_violence aligned_close_race (aligned_win = aligned_close_win) i.province, cl(cluster_var)
	est store r1
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_eventcount aligned_close_race (aligned_win = aligned_close_win) i.province, cl(cluster_var)
	est store r2
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls any_killed aligned_close_race (aligned_win = aligned_close_win) i.province, cl(cluster_var)
	est store r3
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_numberkilled aligned_close_race (aligned_win = aligned_close_win) i.province, cl(cluster_var)
	est store r4
	estadd local provinceFE "Y"
	
	xi: ivregress 2sls ln_duration aligned_close_race (aligned_win = aligned_close_win) i.province, cl(cluster_var)
	est store r5
	estadd local provinceFE "Y"

				cd "$pathout"
				esttab r1 r2 r3 r4 r5 using alignment_analysis.tex, ///
				replace order(aligned_win aligned_close_race) ///
				drop(_cons _Iprovince_*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(provinceFE N, fmt(%9.0fc %9.0fc) ///
				label("Province FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{6}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event} & \multicolumn{1}{c}{Event count} & \multicolumn{1}{c}{Any killed} & \multicolumn{1}{c}{Number killed} & \multicolumn{1}{c}{Number days} \\  & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Binary)} & \multicolumn{1}{c}{(Ln)} & \multicolumn{1}{c}{(Ln)} \\ \cmidrule(rl){1-6} ")	

* Table A34
use "$pathin/final_dataset.dta", clear
	xi: reg any_violence secular_win i.cluster_var, cl(cluster_var)
	est store r1
	estadd local clusterFE "Y"
	estadd local provinceyrFE "N"

	xi: reg ln_eventcount secular_win i.cluster_var, cl(cluster_var)
	est store r2
	estadd local clusterFE "Y"
	estadd local provinceyrFE "N"
	
	xi: reg any_violence secular_win i.cluster_var i.province_year, cl(cluster_var)
	est store r3
	estadd local clusterFE "Y"
	estadd local provinceyrFE "Y"

	xi: reg ln_eventcount secular_win i.cluster_var i.province_year, cl(cluster_var)
	est store r4
	estadd local clusterFE "Y"
	estadd local provinceyrFE "Y"
	
				cd "$pathout"
				esttab r1 r2 r3 r4 using ols_results.tex, ///
				replace order(secular_win) ///
				drop(_cons _Icluster_v_* _Iprovince__*) cells(b(star fmt(3)) se(par([ ]) fmt(3))) collabels(none) ///
				star(* 0.10 ** 0.05 *** 0.01) se booktabs ///
				label eqlabels(none) nonum wrap varwidth(40) ///
				stats(clusterFE provinceyrFE N, fmt(%9.0fc %9.0fc %9.0fc) ///
				label("Cluster FEs" "Province-Year FEs" "\textit{N}")) ///
				note("") ///
				nomti prehead("{\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{5}{c}} \toprule") ///
				posthead("Dependent variable: & \multicolumn{1}{c}{Any event (binary)}  & \multicolumn{1}{c}{Event count (ln)}  & \multicolumn{1}{c}{Any event (binary)}  & \multicolumn{1}{c}{Event count (ln)}   \\ \cmidrule(rl){1-5} ")	















