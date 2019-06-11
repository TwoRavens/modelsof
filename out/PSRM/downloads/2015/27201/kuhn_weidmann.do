**************************************************************
** Replication Code for PSRM Article "Unequal We Fight: Between and Within Group Inequality and Ethnic Civil War"
** Last Updated: August 2014
** Patrick M Kuhn and Nils B Weidmann
** 
** Input: kuhn_weidmann.dta
**************************************************************

* Software: Stata 12.0 SE
* Set working directory to the location of kuhn_weidmann.dta

set more off

use "kuhn_weidmann.dta", clear

* create additional variables necessary for analysis
gen peaceyears2 = peaceyears^2 if !missing(peaceyears)
gen peaceyears3 = peaceyears^3 if !missing(peaceyears)
gen rbal2 = rbal^2 if !missing(rbal)


* Table 1, Model 1
logit onset lineq2gecon status_excl rbal rbal2 lgdppc excl_groups_count year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
predict yhat1

* Table 1, Model 2
clogit onset lineq2gecon status_excl rbal rbal2 lgdppc excl_groups_count year peaceyears peaceyears2 peaceyears3, robust group(cowcode)
predict yhat2

* Table 1, Model 3
logit onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
predict yhat3

* Table 1, Model 4
clogit onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust group(cowcode)
predict yhat4

* Interaction models
* Table 1, Model 5
logit onset c.gini1992_nourban20##i.status_excl lineq2gecon rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
predict yhat5
* Figure 2
margins, dydx(gini1992_nourban20) at(status_excl=(0 1)) noatlegend
marginsplot, x(status_excl) plotopts(connect(none)) yline(0) xscale(range(-0.25 1.25)) title("Average marginal effects of intra-group inequality") scheme(s2mono)

* Table 1, Model 6
logit onset c.gini1992_nourban20##c.lineq2gecon status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
predict yhat6
* Figure 3
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2))
marginsplot, x(lineq2gecon) recastci(rarea) yline(0) yscale(range(-0.005 0.06)) title("Average marginal effects of intra-group inequality") scheme(s2mono)

* Table 1, Model 7
logit onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
predict yhat7
* Figure 4, left
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(0) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) yline(0) yscale(range(-0.03 0.085)) yla(-0.04(0.02)0.08)  title("Average marginal effects of intra-group inequality (included groups)") scheme(s2mono)
* Figure 4, right
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(1) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) yline(0) yscale(range(-0.03 0.085)) yla(-0.04(0.02)0.08) title("Average marginal effects of intra-group inequality (excluded groups)") scheme(s2mono) 

* ROC analysis in Table 1 (AUC values)
* Model 1
rocreg onset yhat1
* Model 2
rocreg onset yhat2
* Model 3
rocreg onset yhat3
* Model 4
rocreg onset yhat4
* Model 5
rocreg onset yhat5
* Model 6
rocreg onset yhat6
* Model 7
rocreg onset yhat7

* Table 2: Altonji et al procedure unsing LP-Model (following Miguel et al. 2008, Nunn and Wantchekon 2011)

* Table 2, first line
regress onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3
gen sample = e(sample)
local alphafull = _b[gini1992_nourban20]
regress onset gini1992_nourban20 year peaceyears peaceyears2 peaceyears3 if sample==1
local alpharestr = _b[gini1992_nourban20]
display `alphafull' / ( `alpharestr' - `alphafull' )

* Table 2, second line
regress onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3
local alphafull = _b[gini1992_nourban20]
regress onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 year peaceyears peaceyears2 peaceyears3 if sample==1
local alpharestr = _b[gini1992_nourban20]
display `alphafull' / ( `alpharestr' - `alphafull' )

* Table 2, third line
regress onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3
local alphafull1 = _b[c.gini1992_nourban20#1.status_excl]
local alphafull2 = _b[c.gini1992_nourban20#c.lineq2gecon]
regress onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl year peaceyears peaceyears2 peaceyears3 if sample==1
local alpharestr1 = _b[c.gini1992_nourban20#1.status_excl]
local alpharestr2 = _b[c.gini1992_nourban20#c.lineq2gecon]
display `alphafull1' / ( `alpharestr1' - `alphafull1' )
display `alphafull2' / ( `alpharestr2' - `alphafull2' )

* Table 2, fourth line
regress onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3
local alphafull1 = _b[c.gini1992_nourban20#1.status_excl]
local alphafull2 = _b[c.gini1992_nourban20#c.lineq2gecon]
regress onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl rbal rbal2 year peaceyears peaceyears2 peaceyears3 if sample==1
local alpharestr1 = _b[c.gini1992_nourban20#1.status_excl]
local alpharestr2 = _b[c.gini1992_nourban20#c.lineq2gecon]
display `alphafull1' / ( `alpharestr1' - `alphafull1' )
display `alphafull2' / ( `alpharestr2' - `alphafull2' )


******************
* Robustness tests in Appendix
******************

* Regional dummies
tabulate region, gen(regiondummy)
* Table A.1, model A1
logit onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 excl_groups_count lgdppc year regiondummy2 regiondummy3 regiondummy4 regiondummy5 regiondummy6 peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
* Table A.1, model A2
logit onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl rbal rbal2 excl_groups_count lgdppc year regiondummy2 regiondummy3 regiondummy4 regiondummy5 regiondummy6 peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(0) regiondummy5=(0) regiondummy2=(0) regiondummy3=(0) regiondummy4=(0) regiondummy6=(0)) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (included groups)")
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(1) regiondummy5=(0) regiondummy2=(0) regiondummy3=(0) regiondummy4=(0) regiondummy6=(0)) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (excluded groups)")

* Controlling for group-level economic wealth per capita
* Table A.2, model A3
logit onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 grpgdppc excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
* Table A.2, model A4
logit onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl grpgdppc rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(0) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (included groups)")
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(1) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (excluded groups)")

* Oil exporters
gen oilexporter = 0 
replace oilexporter = 1 if oil_prod32_09 > 1000 
* Table A.3, model A5
logit onset gini1992_nourban20 lineq2gecon oilexporter status_excl rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
* Table A.3, model A6
logit onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl oilexporter rbal rbal2 excl_groups_count lgdppc year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(0) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (included groups)")
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(1) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (excluded groups)")

* State strength (Coup attempts)
xtset cowgroupid year, yearly // lag the coupattempt variable
gen coupattemptl1 = l.coupattempt
gen coupattemptl2 = l.coupattemptl1
gen coupattempt2years = max(coupattemptl1, coupattemptl2) if !missing(coupattemptl1, coupattemptl2)
* Table A.4, model A7
logit onset gini1992_nourban20 lineq2gecon status_excl rbal rbal2 excl_groups_count coupattempt2years year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
* Table A.4, model A8
logit onset c.gini1992_nourban20##c.lineq2gecon c.gini1992_nourban20##status_excl rbal rbal2 excl_groups_count coupattempt2years year peaceyears peaceyears2 peaceyears3, robust cluster(cowcode)
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(0) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (included groups)")
margins, dydx(gini1992_nourban20) at(lineq2gecon=(0(0.25)2) status_excl=(1) ) vsquish
marginsplot, x(lineq2gecon) recastci(rarea) title("Average marginal effects of intra-group inequality (excluded groups)")











