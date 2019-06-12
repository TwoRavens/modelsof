*This file replicates the analysis in "Roving Bandits? The Geographical Evolution of African Armed Conflicts"


use intra_diffuse_final, clear
xtset dyad_unique year


*1.1
glm czo_prp l_rebmuchweak l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results, alpha(.01, .05, .1) replace
margins, atmeans at(l_rebmuchweak=(0 1)) 
marginsplot, recast(scatter) level(95) xscale(range(-0.5 1.5)) xtitle(Relative Rebel Strength) ytitle(Predicted Proportion Overlap of Conflict Zone) title("") note("Note: Predicted values with 95% confidence intervals") plot1opts(mcolor(gs6) msize(vlarge)) ci1opts(lcolor(gs6) lpattern(dash) lwidth(thick)) scheme(s1color)
graph save "graph-rebweak.gph", replace
graph export "graph-rebweak.pdf", replace
margins, atmeans at(l_external_type_x_B=(0 1)) 
marginsplot, recast(scatter) level(95) xscale(range(-0.5 1.5)) xtitle(External Military Support) ytitle(Predicted Proportion Overlap of Conflict Zone) title("") note("Note: Predicted values with 95% confidence intervals") plot1opts(mcolor(gs6) msize(vlarge)) ci1opts(lcolor(gs6) lpattern(dash) lwidth(thick)) scheme(s1color) 
graph save "graph-extmil.gph", replace
graph export "graph-extmil.pdf", replace
margins, atmeans at(claim1=(0 1)) 
marginsplot, recast(scatter) level(95) xscale(range(-0.5 1.5)) xtitle(Rebel Group Ethnic Claim) ytitle(Predicted Proportion Overlap of Conflict Zone) title("") title("") note("Note: Predicted values with 95% confidence intervals") plot1opts(mcolor(gs6) msize(vlarge)) ci1opts(lcolor(gs6) lpattern(dash) lwidth(thick)) scheme(s1color)
graph save "graph-claim.gph", replace
graph export "graph-claim.pdf", replace

*1.2
glm czo_prp ln_l_rebgov_ratio ln_l_borderdist l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot l_gdpt, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results, alpha(.01, .05, .1) append
margins, atmeans at(ln_l_rebgov_ratio=(-6(0.2)1)) 
marginsplot, level(95) ciopts(lp(dash) lcolor(gs6)) recastci(rline) xlabel(-6(1)1, angle(horizontal)) xtitle(Logged Ratio of Rebel to Government Troops) ytitle(Predicted Proportion Overlap of Conflict Zone) title("") note("Note: solid lines are predicted values, dashed lines are 95% confidence intervals") plotop(ms(i)  lcolor(gs6) lwidth(vthick) lpattern(solid)) scheme(s1color)
graph save "graph-troopratio.gph", replace
graph export "graph-troopratio.pdf", replace
margins, atmeans at(ln_l_borderdist=(1(0.5)7)) 
marginsplot, level(95) ciopts(lp(dash) lcolor(gs6)) recastci(rline) xlabel(1(2)7, angle(horizontal)) xtitle("Distance to non-Coastal Border (km, logged)") ytitle(Predicted Proportion Overlap of Conflict Zone) title("") note("Note: solid lines are predicted values, dashed lines are 95% confidence intervals") plotop(ms(i)  lcolor(gs6) lwidth(vthick) lpattern(solid)) scheme(s1color)
graph save "graph-border.gph", replace
graph export "graph-border.pdf", replace


*1.3
glm czo_prp l_rebmuchweak l_external_type_x_B claim1 c.claim1#c.l_rebmuchweak ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results, alpha(.01, .05, .1) append
margins, atmeans at(l_rebmuchweak=(0 1) claim1=(0 1)) 
marginsplot, recast(scatter) level(95) xscale(range(-0.5 1.5)) xtitle(Relative Rebel Strength) ytitle(Predicted Proportion Overlap of Conflict Zone) title("") note("Note: Predicted values with 95% confidence intervals") plot1opts(mcolor(gs8) msize(vlarge)) ci1opts(lcolor(gs8) lpattern(dash) lwidth(thick)) plot2opts(mcolor(gs0) msize(vlarge)) ci2opts(lcolor(gs0) lpattern(dash) lwidth(thick)) scheme(s1color)
graph save "graph-interact.gph", replace
graph export "graph-interact.pdf", replace

*1.4
glm czo_prp ln_l_rebgov_ratio ln_l_borderdist l_external_type_x_B claim1 c.claim1#c.ln_l_rebgov_ratio ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot l_gdpt, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results, alpha(.01, .05, .1) append
margins, atmeans at(ln_l_rebgov_ratio=(-6(0.2)1) claim1=(0 1)) 
marginsplot, level(95) ci1opts(lp(dash) lcolor(gs8)) ci2opts(lp(dash) lcolor(gs0)) recastci(rline) xlabel(-6(1)1, angle(horizontal)) xtitle(Logged Ratio of Rebel to Government Troops) ytitle(Predicted Proportion Overlap of Conflict Zone) title("") note("Note: solid lines are predicted values, dashed lines are 95% confidence intervals") plot1op(ms(i)  lcolor(gs8) lwidth(vthick) lpattern(solid)) plot2op(ms(i)  lcolor(gs0) lwidth(vthick) lpattern(solid)) scheme(s1color)
graph save "graph-interact_ratio.gph", replace
graph export "graph-interact_ratio.pdf", replace



*2.1
xtreg centchange l_rebmuchweak l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, cluster(side_A)
outreg2 using ISQ_final_results_robust, alpha(.01, .05, .1) replace

*2.2
glm czo_prp l_czo_prp l_rebmuchweak l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results_robust, alpha(.01, .05, .1) append


*2.3
glm czo_prp l_rebmuchweak l_external_type_x_B seccon ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results_robust, alpha(.01, .05, .1) append

*2.4
glm czo_prp i.l_rebstrength2 l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results_robust, alpha(.01, .05, .1) append

*2.5
glm czo_prp l_rebmuchweak l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot ln_area, cluster(side_A) family(binomial) link(logit)
outreg2 using ISQ_final_results_robust, alpha(.01, .05, .1) append


*2.6
gllamm czo_prp l_rebmuchweak l_external_type_x_B claim1 ln_l_conarea l_no_of_even ln_l_best_est elevmean urbanpct ethnictot, i(DyadID) family(binomial) link(logit)
outreg2 using ISQ_final_results_robust, alpha(.01, .05, .1) append

