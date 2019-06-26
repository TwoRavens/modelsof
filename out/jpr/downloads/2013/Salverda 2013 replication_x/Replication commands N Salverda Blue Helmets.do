*** do-file for:
**Blue Helmets as Targets: 
**A Quantitative Analysis of Rebel Violence Against Peacekeepers, 1989-2003

**Nynke Salverda
**Department of Peace and Conflict Research, Uppsala University
**nynke.salverda@pcr.uu.se
**all regressions are carried out in stata 12.1




***table 1: Peacekeeping operations and violence against themtab pkod yesno**Figure 1, histograms:histogram d_fightcap, start(0) frequency ytitle(Frequency) xscale(range(0 2)) ///xlabel(, valuelabel alternate noticks) title(Distribution of Relative Fighting Capacity) legend(off) scheme(sj)graph save histo1, replacehistogram d_rebstrength, start(0) frequency ytitle(Frequency) xscale(range(0 4)) ///xlabel(,  valuelabel alternate noticks) title(Distribution of Relative strength) legend(off) scheme(sj)graph save histo2, replacegraph combine histo1.gph histo2.gph, iscale(1) xsize(9) **Table 2, descriptive statisticsfsum dv d_rebstrength duration logsize d_rebsup logbattle nonun ///, stats(n mean sd min max) uselabel **table 3 and 4, cross-tabulationstab dv d_rebstren, column chi2tab dv d_fightcap, column chi2***table 5, main resultseststo cleareststo: logit dv d_rebstrength duration logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_rebstrength duration sizexstr logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration logsize sizexfight d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)

esttab using table5.rtf, replace ///scalars( N "r2_p Pseudo R2" "Proportionate Reduction in Error" "aic AIC" "Area under ROC curve" ) ///noeqlines onecell se label nonumbers ///
mtitles("Model 1 (Relative Strength)" "Model 2 (Fighting Capacity)" "Model 3 (Interaction Rel Strength)" "Model 4 (Interaction Fight Cap)") ///title(Table 5: Determinants of Violence against Peacekeepers) /// star(* 0.05 ** 0.01 *** 0.001)  drop(peaceyear peaceyear2 peaceyear3) ///order(d_rebstrength d_fightcap) ///addnote("Reported are the robust standard errors. Data is clustered by peacekeeping operation. Peaceyears, peaceyears2 and peaceyears 3 were also included in the models, but not reported here. ")***predicted probabilitiesestsimp logit dv d_rebstrength duration logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)setx meansetx d_rebstrength 0simqi
setx d_rebstrength 1simqisetx d_rebstrength 2simqisetx d_rebstrength 3simqi setx d_rebstrength 4simqidrop b1-b10estsimp logit dv d_fightcap duration logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)setx meansetx d_fightcap 0simqisetx d_fightcap 1simqisetx d_fightcap 2simqi
**table six, robustness
eststo clear
eststo: logit dv d_rebstrength duration d_rebsup logsize  logbattle nonun incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration d_rebsup logbattle logsize nonun incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)
*standalone
eststo:logit dv d_rebstrength incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)

esttab using table6.rtf, replace ///
scalars( N "r2_p Pseudo R2" "Proportionate Reduction in Error" "aic AIC" "Area under ROC curve" ) ///
noeqlines se label nonumbers mtitles("Model 3" "Model 4" "Model 5" "Model 6") ///
title(Table 6: Robustness: Inclusion of Different Controls) modelwidth(0) varwidth(12) ///
onecell star(* 0.05 ** 0.01 *** 0.001)  drop(peaceyear peaceyear2 peaceyear3) ///
order(d_rebstrength d_fightcap logsizepko ) ///
addnote("Reported are the robust standard errors, clustered on peacekeeping operation. Peaceyears, peaceyears2 and peaceyears 3 were also included in the models, but not reported here. ")
**appendix, Figure I graph interaction effects. logit dv d_rebstrength duration sizexstr logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)grinter logsize , equation(dv) inter(sizexstr) nomean const02(d_rebstrength) title(Marginal Effect of UN troop size) ytitle(Marginal Effect of troop size (ln) ) xtitle(Relative Rebel Strength)graph save graph1, replacelogit dv d_fightcap duration logsize sizexfight d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)grinter logsize , equation(dv) inter(sizexfight) nomean const02(d_fightcap) title(Marginal Effect of UN troop size) ytitle(Marginal Effect of troop size (ln) ) xtitle(Relative Fighting capacity)graph save graph2, replacegraph combine graph1.gph graph2.gph, iscale(1) xsize(9) title(Interaction Effects)**Table B Appendix, type of peacekeeping operation

eststo clear
eststo: logit dv d_rebstrength duration pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_rebstrength duration typexstrength pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration typexfight pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
esttab using tableB.rtf, replace ///
scalars( N "r2_p Pseudo R2" "Proportionate Reduction in Error" "aic AIC" "Area under ROC curve" ) ///
noeqlines se label nonumbers mtitles("Model 3" "Model 4" "Model 5" "Model 6") ///
title(Table 6: Type of Peacekeeping Operation) modelwidth(0) varwidth(12) ///
onecell star(* 0.05 ** 0.01 *** 0.001)  drop(peaceyear peaceyear2 peaceyear3) ///
order(d_rebstrength d_fightcap pkotype typexstrength typexfight) ///
addnote("Reported are the robust standard errors, clustered on peacekeeping operation. Peaceyears, peaceyears2 and peaceyears 3 were also included in the models, but not reported here. ")




