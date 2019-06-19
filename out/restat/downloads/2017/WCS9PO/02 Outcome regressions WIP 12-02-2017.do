

* Use Outcome Dataset: outcome.dta

*****
* Descriptive for outcome variable
sum outcome if licensed==1 | inlic==0

 * IMR regression
local controls usa product delivery composition method claims newpat pat_inn patent_scope family_size fcite ln_sales
probit condition patlaw inlic `controls', vce(cluster id)
predict phat, pr
gen imr=normalden(phat)/normprob(phat)


*****
* Table 4: KSR outcome Diffs-in-Diffs
* Model 1: LPM with all controls
local control product delivery composition method claims bwd_cits fcite newpat pat_inn 
eststo t5_0: xtreg outcome patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id)
gen sample=e(sample)

* Model 2: LPM with all controls + market fe
local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.atc_n 
eststo t5_1: xtreg outcome patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id)

* Model 3: LPM with all controls + market FE + Firm FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.firm i.atc_n 
eststo t5_2: xtreg outcome patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id)

* Model 4: IMR model
local control product delivery composition method claims bwd_cits fcite newpat pat_inn imr i.atc_n i.firm
eststo t5_4: xtreg outcome patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id)

esttab t5_* ///
	using outcome_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 5.KSR impact on outcome - Diffs-in-Diffs") ///
	order(patlaw usa 1.patlaw 1.usa 1.patlaw#1.usa inlic 1.inlic) ///
	scalars("N Obs.") sfmt(%12.0fc %12.3fc)

*****
* Table 5: Impact of KSR on outcome: triple interactions
* Model 1: LPM with all controls
local control product delivery composition method claims bwd_cits fcite newpat pat_inn  
eststo t6_0: xtreg outcome patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t6_0, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t6_0, add(diff `diff' diff_p `diff_p')

* Model 2: LPM with all controls + market FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn  i.atc_n
eststo t6_1: xtreg outcome patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t6_1, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t6_1, add(diff `diff' diff_p `diff_p')

* Model 3: LPM with all controls + market FE + Firm FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn  i.firm i.atc_n 
eststo t6_2: xtreg outcome patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t6_2, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t6_2, add(diff `diff' diff_p `diff_p')


* Model 4: IMR model
local control product delivery composition method claims bwd_cits fcite newpat pat_inn imr i.atc_n i.firm
eststo t6_4: xtreg outcome patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t6_4, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t6_4, add(diff `diff' diff_p `diff_p')

esttab t6_* ///
	using outcome_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 6.KSR impact on challenge with triple interaction") ///
	order(1.patlaw 1.usa 1.inlic 1.patlaw#1.usa 1.patlaw#1.inlic 1.usa#1.inlic 1.patlaw#1.usa#1.inlic) ///
	scalars("N Obs." "inte Internal Patent" "int_p" "ext External Patent" "ext_p" "diff Difference" ///
	"diff_p p_value" "N_cens Censored Obs." "rho Rho" "p_c Wald test of indep. eqns. (rho = 0)" ///
	"first F-stat" "first_p p-value" "lr LR" "lr_p LR-p" ///
	"over OverId" "over_p OverId-p") sfmt(%12.0fc %12.3fc)
	


***************
* Table 6a
forvalues i = 0/1 {
local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.atc_n i.firm   
eststo t8a_lic_`i': xtreg outcome patlaw##usa##inlic `control' if top==`i'& sub_lic==1, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t8a_lic_`i', add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t8a_lic_`i', add(diff `diff' diff_p `diff_p')

local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.atc_n i.firm   
eststo t8a_lic2_`i': xtreg outcome patlaw##usa##inlic `control' imr if top==`i'& sub_lic==1, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t8a_lic2_`i', add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t8a_lic2_`i', add(diff `diff' diff_p `diff_p')
}

esttab t8a_lic_0 t8a_lic_1 t8a_lic2_0 t8a_lic2_1  ///
	using outcome_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 8a.Outcome regressions based on firm size (total assets) split samples, diff-in-diffs with triple interaction") ///
	order(1.patlaw 1.usa 1.inlic 1.patlaw#1.usa 1.patlaw#1.inlic 1.usa#1.inlic 1.patlaw#1.usa#1.inlic) ///
	scalars("N Obs." "inte Internal Patent" "int_p" "ext External Patent" "ext_p" "diff Difference" ///
	"diff_p p_value") sfmt(%12.0fc %12.3fc)


	
*******
* Table 6b.
forvalues i = 0/1 {
local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.atc_n i.firm   
eststo t8c_lic_`i': xtreg outcome patlaw##usa##inlic `control' if top_pat==`i'| licensed2==1, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t8c_lic_`i', add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t8c_lic_`i', add(diff `diff' diff_p `diff_p')

local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.atc_n i.firm   
eststo t8c_lic2_`i': xtreg outcome patlaw##usa##inlic `control' imr if top_pat==`i'| licensed2==1, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t8c_lic2_`i', add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t8c_lic2_`i', add(diff `diff' diff_p `diff_p')
}

esttab t8c_lic_0 t8c_lic_1 t8c_lic2_0 t8c_lic2_1  ///
	using outcome_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 8b.Outcome regressions based on Assignee Cumulative patenting") ///
	order(1.patlaw 1.usa 1.inlic 1.patlaw#1.usa 1.patlaw#1.inlic 1.usa#1.inlic 1.patlaw#1.usa#1.inlic) ///
	scalars("N Obs." "inte Internal Patent" "int_p" "ext External Patent" "ext_p" "diff Difference" ///
	"diff_p p_value") sfmt(%12.0fc %12.3fc)



**************
* Table 6c.
gen matrix=1 if top_pat==0 & top==0 /* This is the base group, low patenting and low assets*/
replace matrix=2 if top_pat==1 & top==0 /* High patenting and low assets*/
replace matrix=3 if top_pat==0 & top==1 /* low patenting and High assets*/
replace matrix=4 if top_pat==1 & top==1 /* This is the base group, low patenting and low assets*/

forvalues i = 1/4 {
local control product delivery composition method claims bwd_cits fcite newpat pat_inn i.atc_n i.firm   
eststo t8d_lic_`i': xtreg outcome patlaw##usa##inlic `control' imr if matrix==`i' | licensed2==1, vce(cluster id)
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t8d_lic_`i', add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t8d_lic_`i', add(diff `diff' diff_p `diff_p')
}

esttab t8d_lic_1 t8d_lic_2 t8d_lic_3 t8d_lic_4 ///
	using outcome_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 8c.Outcome regressions based on 2X2 interaction between Assets and Patenting Activity") ///
	order(1.patlaw 1.usa 1.inlic 1.patlaw#1.usa 1.patlaw#1.inlic 1.usa#1.inlic 1.patlaw#1.usa#1.inlic) ///
	scalars("N Obs." "inte Internal Patent" "int_p" "ext External Patent" "ext_p" "diff Difference" ///
	"diff_p p_value") sfmt(%12.0fc %12.3fc)


*****************
* Table Appendix Figure 4
table inlic patlaw if sample==1 & usa==1, c(mean outcome)
table inlic patlaw if sample==1 & usa==0, c(mean outcome)

table patlaw if sample==1 & usa==1, c(mean outcome)
table patlaw if sample==1 & usa==0, c(mean outcome)






