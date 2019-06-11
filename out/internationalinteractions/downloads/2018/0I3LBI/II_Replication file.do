*************************
*************************
**********REPLICATION FILE (For use in STATA)
**********Militarism and Dual-Conflict Capacity
**********Carla Martinez Machain (carlamm@ksu.edu) and Matthew Wilson (mhwilson1@wvu.edu)
**********October 2016
*************************
*************************

*****NOTE: The --parmest-- and --sutex-- modules are required to replicate output

*************************
*****Set-up
*************************

clear
set more off

*****NOTE: The following code must be modified to read in data from the appropriate location:
cd "C:\Users\mwilson\Dropbox\Research\Manuscripts\Papers Ready for Review\Machain_Militarism and Dual-conflict Capacity\Data\"
use "II_Dataset.dta", clear

	*****DATASET DESCRIPTION
	*****All data except for Geddes, Wright, and Frantz (2014) came from the Quality of Government Dataset (Teorell et al. 2011)
	*****For more information on the construction of the dataset, please contact the authors
	*
	*VARIABLE				DESCRIPTION/SOURCE
	*-----------------------------------------------------
	*ccode					Correlates of War country code 
	*year					Year
	*gwf_casename			Case name for autocratic regime spells (source: Geddes, Wright, and Frantz 2014)
	*gwf_military			Whether regime spell is a military dictatorship (source: Geddes, Wright, and Frantz 2014)
	*gwf_personal 			Whether regime spell is a personalist dictatorship (source: Geddes, Wright, and Frantz 2014)
	*internal				Whether there is an internal conflict in a country-year (source: UCDP/PRIO Armed Conflict Dataset, Gleditsch et al. 2002)
	*intpeace				Time since last internal conflict (manually created)
	*external				Whether there is an external conflict in a country-year (source: UCDP/PRIO Armed Conflict Dataset, Gleditsch et al. 2002)
	*extpeace				Time since last external conflict (manually created)
	*ucdp_type2				Levels of external armed conflict (source: UCDP/PRIO Armed Conflict Dataset, Gleditsch et al. 2002)
	*ucdp_type3				Levels of internal armed conflict (source: UCDP/PRIO Armed Conflict Dataset, Gleditsch et al. 2002)
	*interaction_dummy		gwf_military x internal (manually created)
	*interaction_ord		gwf_military x ucdp_type3 (manually created)
	*interaction_dummy_ext	gwf_military x ucdp_type2 (manually created)
	*fe_etfra				Ethnic fractionalization (source: Fearon 2003)
	*gle_gdp 				Gross Domestic Product per capita (source: Gleditsch, K. S. 2002)
	*gle_pop 				Population (in 1000's) (source: Gleditsch, K. S. 2002)
	*loggdp					ln(gle_gdp) (manually created)
	*logpop 				ln(gle_pop) (manually created)
	*ht_region				Region of the country (source: Teorell and Hadenius 2005) 	
	*region1				Eastern Europe and post-Soviet Union dummy (manually created)
	*region2 				Latin America dummy (manually created)
	*region3 				North Africa and the Middle East dummy (manually created)
	*region4 				Sub-Saharan Africa dummy (manually created)
	*region5 				Western Europe and North America dummy (manually created)
	*region6 				East Asia dummy (manually created)
	*region7 				South-East Asia dummy (manually created)
	*region8 				South Asia dummy (manually created)
	*region9 				Pacific dummy (manually created)
	*region10 				Caribbean dummy (manually created)
	*-----------------------------------------------------

*************************
*****Tabulations and Summary Statistics
*************************

**TABLE 2 IN THE APPENDIX: print summary statistics
preserve
keep ucdp_type2 ucdp_type3 gwf_military internal external intpeace extpeace logpop loggdp fe_etfra region* interaction_dummy interaction_ord
	la var ucdp_type2 "External Conflict"
	la var ucdp_type3 "Internal Conflict"
	la var gwf_military "Military Regime"
	la var intpeace "Internal Peace Years"
	la var extpeace "External Peace Years"
	la var internal "Internal Conflict"
	la var external "External Conflict"
	la var logpop "Population, logged"
	la var loggdp "GDP, logged"
	la var fe_etfra "Ethnic Fractionalization"
	la var interaction_dummy "Military Regime x Internal Conflict"
	la var interaction_ord "Military Regime x Internal Conflict"
	la var region1 "E.Europe & post-Soviet Union"
	la var region2 "L.America"
	la var region3 "N.Africa & M.East"
	la var region4 "S.S.Africa"
	la var region5 "W.Europe & N.America"
	la var region6 "E.Asia"
	la var region7 "S.E.Asia"
	la var region8 "S.Asia"
	la var region9 "Pacific"
	la var region10 "Caribbean"
sutex, minmax label
restore

**FIGURE 1: bar plot of percent of observations
egen mil_conflict=group(external internal) if gwf_mil==1, label
	tab mil_conflict, g(mil_conflict)
egen nonmil_conflict=group(external internal) if gwf_mil==0, label
	tab nonmil_conflict, g(nonmil_conflict)
graph bar (sum) mil_conflict2 mil_conflict3 mil_conflict4,graphregion(col(white)) ytitle("number of observations", size(large)) legend(region(col(white)) symx(4) label(1 "internal") label(2 "external") label(3 "internal and external") row(1)) bar(1, bcol(gs13)) bar(2, bcol(gs9)) bar(3, bcol(gs6)) title("military regimes", color(black) size(large)) ylab(, labsize(large)) blabel(total, format(%9.0f) size(medlarge) gap(0)) note("N=558", size(medium)) saving(gph1)
graph bar (sum) nonmil_conflict2 nonmil_conflict3 nonmil_conflict4,graphregion(col(white)) ytitle("", size(large)) legend(region(col(white)) symx(4) label(1 "internal") label(2 "external") label(3 "internal and external") row(1)) bar(1, bcol(gs13)) bar(2, bcol(gs9)) bar(3, bcol(gs6)) title("non-military regimes", color(black) size(large)) ylab(, labsize(large)) blabel(total, format(%9.0f) size(medlarge) gap(0))  note("N=3667", size(medium)) saving(gph2)
grc1leg gph1.gph gph2.gph, ycommon graphregion(col(white))
capture *graph export "Figures\conflicts_number.eps", as(eps) replace
	rm gph1.gph
	rm gph2.gph
egen milcount=sum(gwf_mil), by(year)
gen nonmil=(gwf_mil-1)*-1
egen nonmilcount=sum(nonmil), by(year)
		replace mil_conflict2=mil_conflict2/milcount
		replace mil_conflict3=mil_conflict3/milcount
		replace mil_conflict4=mil_conflict4/milcount
		replace nonmil_conflict2=nonmil_conflict2/nonmilcount
		replace nonmil_conflict3=nonmil_conflict3/nonmilcount
		replace nonmil_conflict4=nonmil_conflict4/nonmilcount
graph bar (sum) mil_conflict2 mil_conflict3 mil_conflict4,graphregion(col(white)) ytitle("percent of observations", size(large)) legend(region(col(white)) symx(4) label(1 "internal") label(2 "external") label(3 "internal and external") row(1)) bar(1, bcol(gs13)) bar(2, bcol(gs9)) bar(3, bcol(gs6)) title("military regimes", color(black) size(large)) ylab(, labsize(large)) blabel(total, format(%9.0f) size(medlarge) gap(0)) note("N=558", size(medium)) saving(gph1)
graph bar (sum) nonmil_conflict2 nonmil_conflict3 nonmil_conflict4,graphregion(col(white)) ytitle("", size(large)) legend(region(col(white)) symx(4) label(1 "internal") label(2 "external") label(3 "internal and external") row(1)) bar(1, bcol(gs13)) bar(2, bcol(gs9)) bar(3, bcol(gs6)) title("non-military regimes", color(black) size(large)) ylab(, labsize(large)) blabel(total, format(%9.0f) size(medlarge) gap(0)) note("N=3667", size(medium)) saving(gph2)
grc1leg gph1.gph gph2.gph, ycommon graphregion(col(white)) 
*graph export "Figures\conflicts_percent.eps", as(eps) replace
	rm gph1.gph
	rm gph2.gph
	
		drop mil_conflict* nonmil_conflict* milcount nonmil nonmilcount
	
*************************
*****Analysis
*************************

xtset ccode year

***FIGURE 3 IN THE APPENDIX: Military regimes are more likely to be involved in internal conflicts
**original model
	logit internal L.gwf_military L.internal L.intpeace
		parmest, label level(95) saving(original, replace)
**add in controls
	logit internal L.gwf_military L.internal L.intpeace L.logpop
		parmest, label level(95) saving(p1, replace)
	logit internal L.gwf_military L.internal L.intpeace L.loggdp
		parmest, label level(95) saving(p2, replace)
	logit internal L.gwf_military L.internal L.intpeace L.fe_etfra
		parmest, label level(95) saving(p3, replace)
	logit internal L.gwf_military L.internal L.intpeace i.ht_region
		parmest, label level(95) saving(p4, replace)
	logit internal L.gwf_military L.internal L.intpeace L.logpop L.loggdp L.fe_etfra i.ht_region
		parmest, label level(95) saving(p5, replace)
	logit internal L.gwf_military L.internal L.intpeace, cluster(ccode)
		parmest, label level(95) saving(p6, replace)
	logit internal L.gwf_military L.internal L.intpeace, cluster(year)
		parmest, label level(95) saving(p7, replace)
	logit internal L.gwf_military L.internal L.intpeace, cluster(gwf_casename)
		parmest, label level(95) saving(p8, replace)
	xtlogit internal L.gwf_military L.internal L.intpeace, fe
		parmest, label level(95) saving(p9, replace)
	xtlogit internal L.gwf_military L.internal L.intpeace, re
		parmest, label level(95) saving(p10, replace)
	xtlogit internal L.gwf_military L.internal L.intpeace L.logpop L.loggdp L.fe_etfra i.ht_region, fe
		parmest, label level(95) saving(p11, replace)
	xtlogit internal L.gwf_military L.internal L.intpeace L.logpop L.loggdp L.fe_etfra i.ht_region, re
		parmest, label level(95) saving(p12, replace)
**graph estimates
	save "II_Dataset.dta", replace
	use original.dta, clear
		set more off
	gen param=_n
	order param
	sort param
	drop if param!=1
	replace param=1 in 1
	drop eq label
	local vars parm estimate stderr z p min95 max95
	local i=1
	local n=7
	while `i'<=`n'{
	local p :  word `i' of `vars'
	rename `p' `p'_1
	local i=`i'+1
	}
	save original.dta, replace 
	local params original p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12
	local j=2
	local o=13
	while `j'<=`o'{
	local q : word `j' of `params'
	use `q'.dta, clear
	gen param=_n
	order param
	sort param
	drop if param!=1
	replace param=`j' in 1
	drop eq label
	local vars parm estimate stderr z p min95 max95
	local i=1
	local n=7
	while `i'<=`n'{
	local p :  word `i' of `vars'
	rename `p' `p'_1
	local i=`i'+1
	}
	save `q'.dta, replace
	use original.dta, clear
	merge 1:1 param using `q'.dta
	drop _merge
	save original.dta, replace
	rm `q'.dta
	local j=`j'+1
	}
	use "original.dta", clear
eclplot  estimate_ min95_ max95_ param, horiz estopts(mcol(gs3)) ciopts(col(gs5)) xline(0, lp(dash) lcol(gs7)) xtitle("estimate", color(black) size(medium))ytitle("", color(black) size(medium)) graphregion(col(white)) ylabel(1 "{it:original model}" 2"ln(population)" 3 "ln(GDPpc)" 4 "ethnic fractionalization" 5 "region" 6 "all controls" 7 "country-clustered s.e." 8 "year-clustered s.e." 9 "regime-clustered s.e." 10 "fixed effects" 11 "random effects" 12 "all controls & fixed effects" 13 "all controls & random effects") xlab(0(.25)1.25) title("Pr(internal conflict | military regime)", size(medlarge))
	*graph export "Figures/eclplot_milint.eps", as(eps) replace
	rm original.dta
	use "II_Dataset.dta", clear	

***FIGURE 4 IN THE APPENDIX: Military regimes are more likely to be involved in external conflicts
xtset ccode year
**original model
	logit external L.gwf_military L.external L.extpeace
		parmest, label level(95) saving(original, replace)
**add in controls
	logit external L.gwf_military L.external L.extpeace L.logpop
		parmest, label level(95) saving(p1, replace)
	logit external L.gwf_military L.external L.extpeace L.loggdp
		parmest, label level(95) saving(p2, replace)
	logit external L.gwf_military L.external L.extpeace L.fe_etfra
		parmest, label level(95) saving(p3, replace)
	logit external L.gwf_military L.external L.extpeace i.ht_region
		parmest, label level(95) saving(p4, replace)
	logit external L.gwf_military L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region
		parmest, label level(95) saving(p5, replace)
	logit external L.gwf_military L.external L.extpeace, cluster(ccode)
		parmest, label level(95) saving(p6, replace)
	logit external L.gwf_military L.external L.extpeace, cluster(year)
		parmest, label level(95) saving(p7, replace)
	logit external L.gwf_military L.external L.extpeace, cluster(gwf_casename)
		parmest, label level(95) saving(p8, replace)
	xtlogit external L.gwf_military L.external L.extpeace, fe
		parmest, label level(95) saving(p9, replace)
	xtlogit external L.gwf_military L.external L.extpeace, re
		parmest, label level(95) saving(p10, replace)
	xtlogit external L.gwf_military L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region, fe
		parmest, label level(95) saving(p11, replace)
	xtlogit external L.gwf_military L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region, re
		parmest, label level(95) saving(p12, replace)
**graph estimates
	save "II_Dataset.dta", replace
	use original.dta, clear
		set more off
	gen param=_n
	order param
	sort param
	drop if param!=1
	replace param=1 in 1
	drop eq label
	local vars parm estimate stderr z p min95 max95
	local i=1
	local n=7
	while `i'<=`n'{
	local p :  word `i' of `vars'
	rename `p' `p'_1
	local i=`i'+1
	}
	save original.dta, replace 
	local params original p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12
	local j=2
	local o=13
	while `j'<=`o'{
	local q : word `j' of `params'
	use `q'.dta, clear
	gen param=_n
	order param
	sort param
	drop if param!=1
	replace param=`j' in 1
	drop eq label
	local vars parm estimate stderr z p min95 max95
	local i=1
	local n=7
	while `i'<=`n'{
	local p :  word `i' of `vars'
	rename `p' `p'_1
	local i=`i'+1
	}
	save `q'.dta, replace
	use original.dta, clear
	merge 1:1 param using `q'.dta
	drop _merge
	save original.dta, replace
	rm `q'.dta
	local j=`j'+1
	}
	use "original.dta", clear
eclplot  estimate_ min95_ max95_ param, horiz estopts(mcol(gs3)) ciopts(col(gs5)) xline(0, lp(dash) lcol(gs7)) xtitle("estimate", color(black) size(medium))ytitle("", color(black) size(medium)) graphregion(col(white)) ylabel(1 "{it:original model}" 2"ln(population)" 3 "ln(GDPpc)" 4 "ethnic fractionalization" 5 "region" 6 "all controls" 7 "country-clustered s.e." 8 "year-clustered s.e." 9 "regime-clustered s.e." 10 "fixed effects" 11 "random effects" 12 "all controls & fixed effects" 13 "all controls & random effects") xlab(-1(.5)1.5) title("Pr(external conflict | military regime)", size(medlarge))
	*graph export "Figures/eclplot_milext.eps", as(eps) replace
	rm original.dta
	use "II_Dataset.dta", clear
	
***TABLE 1 AND FIGURE 2: Military regimes are less likely to be involved in external conflicts, given an internal conflict
**original model
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace 
		parmest, label level(95) saving(original, replace)
**add in controls
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace L.logpop
		parmest, label level(95) saving(p1, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace L.loggdp
		parmest, label level(95) saving(p2, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace L.fe_etfra
		parmest, label level(95) saving(p3, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace i.ht_region
		parmest, label level(95) saving(p4, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region
		parmest, label level(95) saving(p5, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace, cluster(ccode)
		parmest, label level(95) saving(p6, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace, cluster(year)
		parmest, label level(95) saving(p7, replace)
	logit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace, cluster(gwf_casename)
		parmest, label level(95) saving(p8, replace)
	xtlogit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace, fe
		parmest, label level(95) saving(p9, replace)
	xtlogit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace, re
		parmest, label level(95) saving(p10, replace)
	xtlogit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region, fe
		parmest, label level(95) saving(p11, replace)
	xtlogit external L.interaction_dummy L.gwf_military L.internal L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region, re
		parmest, label level(95) saving(p12, replace)
**graph estimates
	save "II_Dataset.dta", replace
	use original.dta, clear
		set more off
	gen param=_n
	order param
	sort param
	drop if param!=1
	replace param=1 in 1
	drop eq label
	local vars parm estimate stderr z p min95 max95
	local i=1
	local n=7
	while `i'<=`n'{
	local p :  word `i' of `vars'
	rename `p' `p'_1
	local i=`i'+1
	}
	save original.dta, replace 
	local params original p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12
	local j=2
	local o=13
	while `j'<=`o'{
	local q : word `j' of `params'
	use `q'.dta, clear
	gen param=_n
	order param
	sort param
	drop if param!=1
	replace param=`j' in 1
	drop eq label
	local vars parm estimate stderr z p min95 max95
	local i=1
	local n=7
	while `i'<=`n'{
	local p :  word `i' of `vars'
	rename `p' `p'_1
	local i=`i'+1
	}
	save `q'.dta, replace
	use original.dta, clear
	merge 1:1 param using `q'.dta
	drop _merge
	save original.dta, replace
	rm `q'.dta
	local j=`j'+1
	}
	use "original.dta", clear
eclplot  estimate_ min95_ max95_ param, horiz estopts(mcol(gs3)) ciopts(col(gs5)) xline(0, lp(dash) lcol(gs7)) xtitle("estimate", color(black) size(medium))ytitle("", color(black) size(medium)) graphregion(col(white)) ylabel(1 "{it:original model}" 2"ln(population)" 3 "ln(GDPpc)" 4 "ethnic fractionalization" 5 "region" 6 "all controls" 7 "country-clustered s.e." 8 "year-clustered s.e." 9 "regime-clustered s.e." 10 "fixed effects" 11 "random effects" 12 "all controls & fixed effects" 13 "all controls and random effects") title("Pr(external conflict |""military regime x internal conflict)", size(medlarge))
	*graph export "Figures/eclplot_milinteract.eps", as(eps) replace
	rm original.dta
	use "II_Dataset.dta", clear

	***NOTE: This is true whether we measure internal conflict as a dummy or control for the level of intensity
	**replace interaction 1 with interaction 2: the level of internal conflict that was ongoing
	*	logit external L.interaction_ord L.gwf_military L.ucdp_type3 L.external L.extpeace 
	*		parmest, label level(95) saving(original, replace)
	**add in controls
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace L.logpop
	*		parmest, label level(95) saving(p1, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace L.loggdp
	*		parmest, label level(95) saving(p2, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace L.fe_etfra
	*		parmest, label level(95) saving(p3, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace i.ht_region
	*		parmest, label level(95) saving(p4, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace L.logpop L.loggdp L.fe_etfra i.ht_region
	*		parmest, label level(95) saving(p5, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace, cluster(ccode)
	*		parmest, label level(95) saving(p6, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace, cluster(year)
	*		parmest, label level(95) saving(p7, replace)
	*	logit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace, cluster(gwf_casename)
	*		parmest, label level(95) saving(p8, replace)
	*	xtlogit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace, fe
	*		parmest, label level(95) saving(p9, replace)
	*	xtlogit external L.interaction_dummy L.gwf_military L.ucdp_type3 L.external L.extpeace, re
	*		parmest, label level(95) saving(p10, replace)
	**graph estimates
	*	save "II_Dataset.dta", replace
	*	use original.dta, clear
	*		set more off
	*	gen param=_n
	*	order param
	*	sort param
	*	drop if param!=1
	*	replace param=1 in 1
	*	drop eq label
	*	local vars parm estimate stderr z p min95 max95
	*	local i=1
	*	local n=7
	*	while `i'<=`n'{
	*	local p :  word `i' of `vars'
	*	rename `p' `p'_1
	*	local i=`i'+1
	*	}
	*	save original.dta, replace 
	*	local params original p1 p2 p3 p4 p5 p6 p7 p8 p9 p10
	*	local j=2
	*	local o=11
	*	while `j'<=`o'{
	*	local q : word `j' of `params'
	*	use `q'.dta, clear
	*	gen param=_n
	*	order param
	*	sort param
	*	drop if param!=1
	*	replace param=`j' in 1
	*	drop eq label
	*	local vars parm estimate stderr z p min95 max95
	*	local i=1
	*	local n=7
	*	while `i'<=`n'{
	*	local p :  word `i' of `vars'
	*	rename `p' `p'_1
	*	local i=`i'+1
	*	}
	*	save `q'.dta, replace
	*	use original.dta, clear
	*	merge 1:1 param using `q'.dta
	*	drop _merge
	*	save original.dta, replace
	*	rm `q'.dta
	*	local j=`j'+1
	*	}
	*	use "original.dta", clear
	*	eclplot  estimate_ min95_ max95_ param, horiz estopts(mcol(gs3)) ciopts(col(gs5)) xline(0, lp(dash) lcol(gs7)) xtitle("estimate", color(black) size(medium))ytitle("", color(black) size(medium)) graphregion(col(white)) ylabel(1 "{it:original}" 2"ln(population)" 3 "ln(GDPpc)" 4 "ethnic fractionalization" 5 "region" 6 "all controls" 7 "country-clustered s.e." 8 "year-clustered s.e." 9 "regime-clustered s.e." 10 "fixed effects" 11 "random effects")
	*	*graph export "Figures/eclplot_milinteract2.eps", as(eps) replace
	*	rm original.dta
	*	use "II_Dataset.dta", clear	

***TABLE 3 IN THE APPENDIX: We find similar results if we substitute another indicator of military dictatorship, although it is more tenuous 
tab chga_hinst, gen(chga)
rename chga5 chga_mil
drop chga1 chga2 chga3 chga4 chga6
gen chga_interaction_dummy=chga_mil*internal
gen chga_interaction_ord=chga_mil*ucdp_type3
gen chga_interaction_ext=chga_mil*external

logit internal L.chga_mil L.internal L.intpeace, or
logit external L.chga_mil L.external L.extpeace, or
logit external L.chga_mil L.internal L.external L.extpeace L.chga_interaction_dummy, or
logit external L.chga_mil L.ucdp_type3 L.external L.extpeace L.chga_interaction_ord, or
logit internal L.chga_mil L.external L.internal L.intpeace L.chga_interaction_ext, or

drop chga_mil chga_interaction*

***TABLE 4 IN THE APPENDIX: Military regimes are not less likely to be involved in internal conflicts, given external conflict
**original model
	logit internal L.gwf_military L.external L.interaction_dummy_ext L.internal L.intpeace, or

***TABLE 5 IN THE APPENDIX: We also find that personalist regimes exhibit different relationships
gen interaction_perint=gwf_personal*internal
gen interaction_perext=gwf_personal*external
logit external L.gwf_personal L.internal L.interaction_perint L.external L.extpeace 
logit internal L.gwf_personal L.internal L.interaction_perext L.external L.intpeace
drop interaction_per* 
	
***TABLE 6 IN THE APPENDIX: We do not find evidence that coups affect the likelihood of military regimes being involved in external conflicts
gen interaction_coupattempt=gwf_military*coup_attempt
gen interaction_coupsuccess=gwf_military*coup_success
logit external L.gwf_military L.coup_attempt L.interaction_coupattempt L.external L.extpeace 
logit external L.gwf_military L.coup_success L.interaction_coupsuccess L.external L.extpeace 
drop interaction_coup*

	*****Testing results using penalized-likelihood
	*****NOTE: The --firthlogit-- module is required to run the following code
	*	firthlogit internal lagmilitary laginternal lagintpeace, or
	*	firthlogit external lagmilitary lagexternal lagextpeace, or
	*	firthlogit internal laginteraction_dummy_ext lagmilitary lagexternal laginternal lagintpeace, or
	*	firthlogit external laginteraction_dummy lagmilitary laginternal lagexternal lagextpeace, or

save "II_Dataset.dta", replace
*************************
*************************
**********END OF DO FILE
