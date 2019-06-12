* This file runs the analysis discussed in "Theory, Data, and Deterrence:  A Response to Kenwick, Vasquez, and Powers"
* Brett Ashley Leeds and Jesse C. Johnson
* 8/16/15

**********************************
*** Code for Empirical Results ***
**********************************

set more off
cd "directory_name"
use "LeedsJohnsonJOPrep.dta", clear

* We replicate the JL FPA results (Table A1 and Figure A1)

	estsimp probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 

	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(2.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==1
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency color(gray 8) ||hist nodef, frequency color(black) legend(order(1 "Target with Defense Pact" 2 "Target without Defense Pact")) ysc(on) xlabel(0 .0005 .001) xtitle("Probability of Dispute Initiation") ylabel(0 20 40 60) ytitle(Frequency) scheme(s1mono) 
	capture drop b1-b12 nodef def def_change

* We replicate the Figure 1A KVP model (Table A2 Column 1)

use "KVPJOPrep.dta", clear
	
	cem jdem(#0) pchaloff(#0) pchalneu(#0) contig(#0) ccode1_maj(#0) ccode2_maj(#0) rivalry_bef(#0) disputes_before (#0) ptargoff(#0) ptargneu(#0), tr(longitudinal_treatment)

	logit anydispaft longitudinal_treatment [iweight=cem_weights]

* We estimate the KVP model without matching (Table A2 Column 2)

	logit anydispaft longitudinal_treatment pchaloff pchalneu ptargoff ptargneu contig ccode1_maj ccode2_maj jdem rivalry_bef disputes_before
		
* We estimate the JL model with several different mataching strategies (Tables A3-6 & Figure A2)

* Code for the matching procedure is included below 

use "LeedsJohnsonJOPrep.dta", clear

* 1
	
	probit dispute ptargdef [iweight=cem_weights_1]
	estsimp probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 [iweight=cem_weights_1]
	
	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(2.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==1
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency color(gray 8) ||hist nodef, frequency color(black) legend(order(1 "Target with Defense Pact" 2 "Target without Defense Pact")) ysc(on) xlabel(0 .0005 .001 .0015 .002 .0025 .003) xtitle("Probability of Dispute Initiation") ylabel(0 20 40 60) ytitle(Frequency) scheme(s1mono) 
	capture drop b1-b12 nodef def def_change
	
* 2
		
	probit dispute ptargdef [iweight=cem_weights_2]
	estsimp probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 [iweight=cem_weights_2]

	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(2.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==1
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency color(gray 8) ||hist nodef, frequency color(black) legend(off) ysc(on) xlabel(0 .0005 .001 .0015 .002 .0025 .003) xtitle("Probability of Dispute Initiation") ylabel(0 20 40 60) ytitle(Frequency) scheme(s1mono) 
	capture drop b1-b12 nodef def def_change
	
* 3

	probit dispute ptargdef [iweight=cem_weights_3]
	estsimp probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 [iweight=cem_weights_3]

	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(2.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==1
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency color(gray 8) ||hist nodef, frequency color(black) legend(off) ysc(on) xlabel(0 .0005 .001 .0015 .002 .0025 .003) xtitle("Probability of Dispute Initiation") ylabel(0 20 40 60) ytitle(Frequency) scheme(s1mono) 
	capture drop b1-b12 nodef def def_change
	
* 4

	probit dispute ptargdef [iweight=cem_weights_4]
	estsimp probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 [iweight=cem_weights_4]

	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(2.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==1
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency color(gray 8) ||hist nodef, frequency color(black) legend(off) ysc(on) xlabel(0 .0005 .001 .0015 .002 .0025 .003) xtitle("Probability of Dispute Initiation") ylabel(0 20 40 60) ytitle(Frequency) scheme(s1mono) 
	capture drop b1-b12 nodef def def_change
	
* We estimate the JL model using the KVP control variables (Table A7 & Figure A3)

	estsimp probit dispute ptargdef pchaloff pchalneu ptargoff ptargneu contig c_majpow t_majpow jdem rivalyears midcount  

	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(2.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==1
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(2.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency color(gray 8) ||hist nodef, frequency color(black) legend(order(1 "Target with Defense Pact" 2 "Target without Defense Pact")) ysc(on) xlabel(0 .0005 .001) xtitle("Probability of Dispute Initiation") ylabel(0 20 40 60) ytitle(Frequency) scheme(s1mono) 
	capture drop b1-b12 nodef def def_change
	
exit

************************************
*** Code for Matching Procedures ***
************************************

set more off
use "LeedsJohnsonJOPrep.dta", clear
capture drop cem_strata_1 cem_matched_1 cem_weights_1 cem_strata_2 cem_matched_2 cem_weights_2 cem_strata_3 cem_matched_3 cem_weights_3 cem_strata_4 cem_matched_4 cem_weights_4

* We match using informed bins for the continuous variables and excact on dichotomous variables (Table A3a)

	cem  pchalally(#0) pchaloff(#0) pchalneu(#0) ln_distance(4 6 8) capprop(.02 .1 .3  .5 .7 .9 .98) jdem(#0) s_un_glo(.4 .63 .79 .92 .97) peaceyrs(1 3 9 22 39 74), tr(ptargdef) 

	rename cem_strata cem_strata_1
	rename cem_matched cem_matched_1
	rename cem_weights cem_weights_1

* We match using the default binning algorithm and excact on dichotomous variables (Table A4a)

	cem  pchalally(#0) pchaloff(#0) pchalneu(#0) ln_distance capprop jdem(#0) s_un_glo peaceyrs, tr(ptargdef) 

	rename cem_strata cem_strata_2
	rename cem_matched cem_matched_2
	rename cem_weights cem_weights_2
	
* We match using equally spaced bins for the continuous variables and excact on dichotomous variables (Table A5a)

	cem  pchalally(#0) pchaloff(#0) pchalneu(#0) ln_distance(#20) capprop(#10) jdem(#0) s_un_glo(#20) peaceyrs(#20), tr(ptargdef) 

	rename cem_strata cem_strata_3
	rename cem_matched cem_matched_3
	rename cem_weights cem_weights_3
	
* We match using smaller equally spaced bins for the continuous variables and excact on dichotomous variables (Table A6a)

	cem  pchalally(#0) pchaloff(#0) pchalneu(#0) ln_distance(#40) capprop(#20) jdem(#0) s_un_glo(#40) peaceyrs(#40), tr(ptargdef) 

	rename cem_strata cem_strata_4
	rename cem_matched cem_matched_4
	rename cem_weights cem_weights_4
	
exit
