

// ------------------------------------------------------------------------ // 
//
//		Replicate Figures and Tables in Online Appendix A-C
//
//		"Richer (and Holier) Than Thou? The Impact of Relative Income
//		Improvements on Demand for Redistribution"
//
// ------------------------------------------------------------------------ // 

use final, clear

// Globals
global estoptions "replace style(tex) substitute(_cons Constant) stats(N, fmt(0) labels("Obs")) numbers label collabels(none) cells(b(star fmt(3)) se(par fmt(3))) starlevels($^{*}$ 0.1 $^{**}$ 0.05 $^{***}$ 0.01) posthead(\midrule) prefoot(\addlinespace[0.1cm]) postfoot(\bottomrule)"
global main outcome_index against_redist cons_party decrease_tax
global main_cont outcome_index_rightscale against_redist_cont rightscale decrease_tax_cont

global desc_reg age male married kids urban primary highschool college lincome lwage netwealth ui moderat center folk krist miljo social vanster sd fi noparty iq6
global balance_sur bias informed luck nodist right
global balance_reg age male married kids urban college lincome lwealth ui welfare 
global balance_reg_edu age male married kids urban i.edu lincome lwealth ui welfare 
global balance_reg_noedu age male married kids urban lincome lwealth ui welfare 
global balance_all $balance_sur $balance_reg t1
global balance_all_not1_bias $balance_sur $balance_reg nbias nobias pbias



// ------------------------------------------------------------------------ // 
// 		Appendix A
// ------------------------------------------------------------------------ // 


// Table A.1 Comparison between population and survey respondents
eststo: estpost sum  $desc_reg
eststo: estpost sum $desc_reg if bothrounds==1
esttab using tables\descriptive_reg, style(tab) label mlabels("Round 1 and/or 2" "Round 2") cells("mean(fmt(3))" "sd(fmt(3))" "count") collabels(none) replace
eststo: estpost sum $desc_reg  [aweight=wk]
esttab using tables\descriptive_reg_weight, style(tab) label mlabels("Round 1 weighted") cells("mean(fmt(3))" "sd(fmt(3))" "count") collabels(none) replace
eststo clear


// Tabel A.2: Responding to the second survey and covariates
local replace replace
foreach x of global balance_all {
	reg bothrounds `x', rob	
	outreg2 `x' using tables\bothrounds, excel `replace' dec(3)
	local replace append
}
reg bothrounds iq6, rob
outreg2 using tables\bothrounds, excel append dec(3)
reg bothrounds $balance_all, rob
outreg2 using tables\bothrounds, excel append dec(3)


// Table A.3: Balance in the analysis sample
local replace replace
foreach x of global balance_all_not1_bias {
	qui reg t `x', rob	
	outreg2 `x' using tables\balance, excel dec(3) `replace'
	local replace append
}
qui reg t iq6, rob
outreg2 using tables\balance, excel append dec(3)
qui reg t $balance_all_not1_bias, rob
outreg2 using tables\balance, excel append dec(3)


// Table A.4: Correlates of right-of-center political preferences
foreach x in age male married college urban informed lincome lwealth iq6 luck nodist {
eststo, title(Right): qui reg right `x',rob
}
eststo, title(Right): qui reg right age male married college urban informed lincome lwealth luck nodist,rob
estout using tables\right_corr.tex, $estoptions
eststo clear


// Table A.5: Heterogeneous effects by economic and demographic characteristics
foreach x in age male college urban informed lincome lwealth iq6   {
eststo, title(Index): qui reg outcome_index t t`x' `x' if nbias==1,rob
}
estout using tables\hetero_corr.tex, keep(t* _cons)  $estoptions 
eststo clear


// Table A.6: Heterogeneous effects by prior party preferences and potential confounds
foreach x in age male college urban informed lincome lwealth iq6 {
eststo, title(Index): qui reg outcome_index t tright right  t`x' `x' if nbias==1,rob
}
estout using tables\horse_race.tex, keep(t* _cons) $estoptions 
eststo clear


// Table A.7 and A.8: Robustness to using a 5 and 15 percentage point cutoff for bias
foreach x of global main {
	local label: variable label `x'	
	eststo, title(`label'): qui reg `x' t if nbias5==1, rob
	eststo, title(`label'): qui reg `x' t tright right if nbias5==1, rob
}
estout using tables\nbias5.tex, varlabels(tright "Treated\$\times\$Right") $estoptions
eststo clear
foreach x of global main {
	local label: variable label `x'	
	eststo, title(`label'): qui reg `x' t if nbias15==1, rob
	eststo, title(`label'): qui reg `x' t tright right if nbias15==1, rob
}
estout using tables\nbias15.tex, varlabels(tright "Treated\$\times\$Right") $estoptions
eststo clear


// Table A.9: Weighted estimates
foreach x of global main {
	local label: variable label `x'	
	eststo, title(`label'): qui reg `x' t [pweight=Vikt] if nbias==1, rob
	eststo, title(`label'): qui xi: reg `x' t tright right [pweight=Vikt] if nbias==1, rob
}
estout using tables\weighted.tex, varlabels(tright "Treated\$\times\$Right") $estoptions
eststo clear


// Table A.10: Alternative definition of right-of-center party preferences
foreach x of global main {
	local label: variable label `x'	
	eststo, title(`label'): qui xi: reg `x' t tright_sd right_sd if nbias==1, rob
	eststo, title(`label'): qui xi: reg `x' t tright_left right_left if nbias==1, rob
}
estout using tables\right_sd_left.tex, varlabels(tright_sd "Treated\$\times\$Right SD" right_sd "Right SD" tright_left "Treated\$\times\$Right Left" right_left "Right Left") $estoptions
eststo clear


// Table A.11: Robustness to attrition
foreach x of global main {
	local label: variable label `x'	
	eststo, title(`label'): qui reg `x' t if nbias==1 & cons_party!=., rob
}
local label: variable label cons_party2
eststo, title(`label'): qui reg cons_party2 if nbias==1, rob
estout using tables\attrition.tex, $estoptions
eststo clear


// Table A.12: Continuous measure of party choice
foreach x in outcome_index_rightscale rightscale {
	local label: variable label `x'	
	eststo, title("`label'"): reg `x' tnbias nobias tnobias pbias tpbias, rob
}
estout using tables\average_rightscale.tex, $estoptions  varlabels(tnbias "Treated\$\times\$Neg. Bias" tnobias "Treated\$\times\$No Bias" tpbias "Treated\$\times\$Pos. Bias")
eststo clear


// Table A.13: Respondents' understanding of the treatment
eststo, title("Wrong answer"): qui reg wronganswer right if t==1, rob
eststo, title("Wrong answer"): qui reg wronganswer nodist if t==1, rob
eststo, title("Wrong answer"): qui reg wronganswer luck if t==1, rob
eststo, title("Wrong answer"): qui reg wronganswer right nodist luck if t==1, rob
estout using tables\wronganswer.tex, $estoptions
eststo clear


// Table A.14: Heterogeneous effects below and above the median
foreach x of global main {
	local label: variable label `x'	
	eststo, title(`label'): qui reg `x' t tbelowmed_true belowmed_true if nbias==1, rob
}
estout using tables\belowmed.tex, $estoptions varlabels(tbelowmed_true "Treated\$\times\$Below med.")
eststo clear


// Figure A.1: Graphical representation of treatment effects
twoway (kdensity redist_post if t==0, color(black) lwidth(thick) kernel(rectangle) bwidth(1)) (kdensity redist_post if t==1, color(gray) lwidth(thick) kernel(rectangle) bwidth(1)) if nbias==1, ytitle(Density) xtitle("Demand for redistribution" "1: No redistribution" "10: Full redistribution") legend(label(1 "Control") label(2 "Treatment")) xlabel(1/10) graphregion(color(white)) bgcolor(white)
graph save graphs\redist, replace
graph export graphs\redist.png, replace

twoway (hist moderat_post if t==0, color(black) lcolor(white) discrete fraction barwidth(0.45)) (hist moderat_post if t==1, color(gray)lcolor(white) discrete fraction barwidth(0.35)) if nbias==1 & moderat_post!=., ytitle(Fraction) xtitle("Support for the Conservative party") legend(label(1 "Control") label(2 "Treatment")) xlabel(0 1) graphregion(color(white)) bgcolor(white)
graph save graphs\cons, replace
graph export graphs\cons.png, replace

twoway (kdensity changetax_post if t==0, color(blatabck) lwidth(thick) kernel(rectangle) bwidth(1)) (kdensity changetax_post if t==1, color(gray) lwidth(thick) kernel(rectangle) bwidth(1)) if nbias==1, ytitle(Density) xtitle("Willingness to change income taxes" "<5: decrease" "5: no change" ">5: increase") legend(label(1 "Control") label(2 "Treatment")) xlabel(1/9) graphregion(color(white)) bgcolor(white)
graph save graphs\decreasetax, replace
graph export graphs\decreasetax.png, replace


// Figure A.2, Panel A, C and E
twoway (kdensity redist_post if t==0, color(black) lwidth(thick) kernel(rectangle) bwidth(1)) (kdensity redist_post if t==1, color(gray) lwidth(thick) kernel(rectangle) bwidth(1)) if nbias==1 & right==1, ytitle(Density) xtitle("Demand for redistribution" "1: No redistribution" "10: Full redistribution") legend(label(1 "Control Right") label(2 "Treated Right")) xlabel(1/10) graphregion(color(white)) bgcolor(white)
graph save graphs\redist_right, replace
graph export graphs\redist_right.png, replace
twoway (hist moderat_post if t==0, color(black) lcolor(white) discrete fraction barwidth(0.45)) (hist moderat_post if t==1, color(gray)lcolor(white) discrete fraction barwidth(0.35)) if nbias==1 & moderat_post!=. & right==1, ytitle(Fraction) xtitle("Support for the Conservative party") legend(label(1 "Control Right") label(2 "Treated Right")) xlabel(0 1) graphregion(color(white)) bgcolor(white)
graph save graphs\cons_right, replace
graph export graphs\cons_right.png, replace
twoway (kdensity changetax_post if t==0, color(black) lwidth(thick) kernel(rectangle) bwidth(1)) (kdensity changetax_post if t==1, color(gray) lwidth(thick) kernel(rectangle) bwidth(1)) if nbias==1 & right==1, ytitle(Density) xtitle("Willingness to change income taxes" "<5: decrease" "5: no change" ">5: increase") legend(label(1 "Control Right") label(2 "Treated Right")) xlabel(1/9) graphregion(color(white)) bgcolor(white)
graph save graphs\decreasetax_right, replace
graph export graphs\decreasetax_right.png, replace


// Figure A.2, Panels B, D and F
twoway (kdensity redist_post if t==0, color(black) lwidth(thick) kernel(rectangle) bwidth(1)) (kdensity redist_post if t==1, color(gray) lwidth(thick) kernel(rectangle) bwidth(1)) if nbias==1 & right==0, ytitle(Density) xtitle("Demand for redistribution" "1: No redistribution" "10: Full redistribution") legend(label(1 "Control Non-Right") label(2 "Treated Non-Right")) xlabel(1/10) graphregion(color(white)) bgcolor(white)
graph save graphs\redist_left, replace
graph export graphs\redist_left.png, replace
twoway (hist moderat_post if t==0, color(black) lcolor(white) discrete fraction barwidth(0.45)) (hist moderat_post if t==1, color(gray)lcolor(white) discrete fraction barwidth(0.35)) if nbias==1 & moderat_post!=. & right==0, ytitle(Fraction) xtitle("Support for the Conservative party") legend(label(1 "Control Non-Right") label(2 "Treated Non-Right")) xlabel(0 1) graphregion(color(white)) bgcolor(white)
graph save graphs\cons_left, replace
graph export graphs\cons_left.png, replace
twoway (kdensity changetax_post if t==0, color(black) lwidth(thick) kernel(rectangle) bwidth(1)) (kdensity changetax_post if t==1, color(gray) lwidth(thick) kernel(rectangle) bwidth(1)) if nbias==1 & right==0, ytitle(Density) xtitle("Willingness to change income taxes" "<5: decrease" "5: no change" ">5: increase") legend(label(1 "Control Non-Right") label(2 "Treated Non-Right")) xlabel(1/9) graphregion(color(white)) bgcolor(white)
graph save graphs\decreasetax_left, replace
graph export graphs\decreasetax_left.png, replace





// ------------------------------------------------------------------------ // 
// 		Appendix B
// ------------------------------------------------------------------------ // 


// Table B1: Average effects
foreach x of global main {
	local label: variable label `x'	
	eststo, title("`label'"): qui reg `x' tnbias nobias tnobias pbias tpbias $balance_reg_edu, rob
	eststo, title("`label'"): qui reg `x' tnbias nobias tnobias pbias tpbias $balance_reg_edu $balance_sur, rob
}
estout using tables\average_ctrls.tex, $estoptions drop(*edu) indicate("Admin. controls=$balance_reg_noedu" "Survey controls=$balance_sur") varlabels(tnbias "T\$\times\$Neg. Bias" tnobias "T\$\times\$No Bias" tpbias "T\$\times\$Pos. Bias")
eststo clear


// Table B.2
foreach x of global main {
	local label: variable label `x'	
	eststo, title("`label'"): qui reg `x' t tright right $balance_reg_edu if nbias==1, rob
	eststo, title("`label'"): qui reg `x' t tright right $balance_reg_edu $balance_sur if nbias==1, rob
}
estout using tables\right_ctrls.tex, $estoptions drop(*edu) indicate("Admin. controls=$balance_reg_noedu" "Survey controls=$balance_sur") varlabels(tnbias "T\$\times\$Neg. Bias" tnobias "T\$\times\$No Bias" tpbias "T\$\times\$Pos. Bias")
eststo clear


// Table B.3
foreach x in age male college urban informed lincome lwealth iq6  {
eststo, title(Index): qui reg outcome_index t t`x' `x' $balance_reg_edu if nbias==1,rob
eststo, title(Index): qui reg outcome_index t t`x' `x' $balance_reg_edu $balance_sur if nbias==1,rob
}
estout using tables\hetero_corr_ctrls.tex, keep(t*) $estoptions indicate("Admin. controls=$balance_reg_noedu" "Survey controls=$balance_sur")
eststo clear


// Table B.4
foreach x in age male college urban informed lincome lwealth iq6  {
eststo, title(Index): qui reg outcome_index t tright right  t`x' `x' $balance_reg_edu if nbias==1,rob
eststo, title(Index): qui reg outcome_index t tright right  t`x' `x' $balance_reg_edu $balance_sur if nbias==1,rob
}
estout using tables\horse_race_ctrls.tex, keep(t*) $estoptions indicate("Admin. controls=$balance_reg_noedu" "Survey controls=$balance_sur")
eststo clear


// Table B.5-B.8
foreach y of global main {
local label: variable label `y'
foreach x in redist_distort nodist luck {
	eststo, title(`label'): qui reg `y' t t`x' `x' $balance_reg if nbias==1, rob
	eststo, title(`label'): qui reg `y' t t`x' `x' $balance_reg bias informed just care right if nbias==1, rob
}
estout using tables\beliefs_`y'_ctrls.tex, varlabels(tbeliefs "T\$\times\$Redist-Distort" tluck "T\$\times\$Luck" tnodist "T\$\times\$No dist.") $estoptions indicate("Admin controls=$balance_reg" "Survey controls=bias informed just care right")
eststo clear
}




// ------------------------------------------------------------------------ // 
// 		Appendix C Tables
// ------------------------------------------------------------------------ // 

// Table C.1
foreach x of global main_cont {
	local label: variable label `x'	
	eststo, title("`label'"): qui reg `x' tnbias nobias tnobias pbias tpbias, rob
}
estout using tables\average_cont.tex, $estoptions  // drop(*edu) indicate("Controls=$ctrl_noedu")
eststo clear

// Table C.2
foreach x of global main_cont {
	local label: variable label `x'
	eststo, title(`label'): qui reg `x' t tright right if nbias==1, rob
}
estout using tables\right_cont.tex, $estoptions varlabels(tright "Treated\$\times\$Right") 
eststo clear

// Table C.3
foreach x in beliefs nodist luck {
	eststo, title("Index"): qui reg outcome_index_rightscale t t`x' `x' if nbias==1, rob
}
eststo, title("Index"): qui reg outcome_index_rightscale t tredist_distort redist_distort right if nbias==1, rob
eststo, title("Index"): qui reg outcome_index_rightscale t tredist_distort redist_distort if nbias==1 & right==1, rob
eststo, title("Index"): qui reg outcome_index_rightscale t tredist_distort redist_distort if nbias==1 & right==0, rob
estout using tables\redist_distort_cont.tex, $estoptions 
eststo clear


// Tables C.4 - C.9
foreach outcomes in main main_cont {
	eststo clear
	
	foreach x of global `outcomes' {
	local label: variable label `x'
	eststo, title(`label'): qui reg `x' t tbias bias if abs(bias)<30, rob
	eststo, title(`label'): qui reg `x' t tbias $balance_sur $balance_reg_edu if abs(bias)<30, rob
	}
	estout using tables\average_contbias_`outcomes'.tex, drop(*edu) indicate("Controls=age male married kids urban lincome lwealth ui welfare informed luck nodist right") $estoptions 
	eststo clear
	
	foreach x of global `outcomes' {
	local label: variable label `x'
	eststo, title(`label'): qui reg `x' t tbias tright tbiasright bias right biasright if abs(bias)<30, rob
	eststo, title(`label'): qui reg `x' t tbias tright tbiasright biasright $balance_sur $balance_reg_edu if abs(bias)<30, rob
	}
	estout using tables\right_contbias_`outcomes'.tex, drop( *edu) indicate("Controls=age male married kids urban lincome lwealth ui welfare informed luck nodist")  $estoptions 
	eststo clear
	
	foreach x of global `outcomes' {
	local label: variable label `x'
	eststo, title(`label'): qui reg `x' t tbias tbeliefs tbiasbeliefs bias beliefs biasbeliefs if abs(bias)<30, rob
	eststo, title(`label'): qui reg `x' t tbias tbeliefs tbiasbeliefs beliefs biasbeliefs $balance_sur $balance_reg_edu  if abs(bias)<30, rob
	}
	estout using tables\beliefs_contbias_`outcomes'.tex, drop(*edu) indicate("Controls=age male married kids urban lincome lwealth ui welfare informed luck nodist right")  $estoptions 
	eststo clear
}





// ------------------------------------------------------------------------ // 
// 		Appendix C Figures
// ------------------------------------------------------------------------ // 

egen b3=cut(bias) if abs(bias)<30, group(3) icodes
gen r = against_redist
gen m = cons_party
gen d = decrease_tax

global graphoptions yline(0) xtitle("Bias") xscale(range(-26/2)) graphregion(color(white)) xlabel(-25 -20 -15 -10 -5 0)


preserve
collapse (mean) outcome_index r m d bias (sd) outcome_index_sd=outcome_index r_sd=r m_sd=m d_sd=d (count) obs=outcome_index if abs(bias)<30, by(t b3)

foreach x in outcome_index r m d {
	gen `x'_v=`x'_sd^2
	gen `x'_se=sqrt(`x'_v/obs)
	gen lb_`x'=`x'-invttail(obs-1,0.025)*`x'_se
	gen ub_`x'=`x'+invttail(obs-1,0.025)*`x'_se
}

drop lb* ub* 
drop if t==.
reshape wide outcome_index* r* m* d* bias obs, i(b3) j(t)
label variable outcome_index1 "Outcome Index"
label variable r1 "Against-Redist"
label variable d1 "Decrease Taxes"
label variable m1 "Cons. Party"

foreach x in outcome_index r m d {
	gen `x'_diff=`x'1-`x'0
	gen `x'_diff_sd=sqrt(`x'_v0/obs0+`x'_v1/obs1)
	gen `x'_diff_df=((`x'_v0/obs0+`x'_v1/obs1)^2)/(((`x'_v0/obs0)^2/(obs0-1))+((`x'_v1/obs1)^2/(obs1-1)))
	gen lb_`x'_diff=`x'_diff-invttail(`x'_diff_df,0.025)*`x'_diff_sd
	gen ub_`x'_diff=`x'_diff+invttail(`x'_diff_df,0.025)*`x'_diff_sd

	format outcome_index* r* m* d* lb* ub* %9.1fc
	local label: variable label `x'1
	twoway (line `x'_diff bias1, lwidth(medthick)) ///
	(rcap ub_`x'_diff lb_`x'_diff bias1, color(maroon) lpattern(dash)), ///
	$graphoptions ytitle("`label'") legend(off)
	graph save graphs\3g_`x'_diff_ci, replace
	graph export graphs\3g_`x'_diff_ci.png, replace
}
restore

// Right versus non-right graphs
preserve
collapse (mean) outcome_index r m d bias (sd) outcome_index_sd=outcome_index r_sd=r m_sd=m d_sd=d (count) obs=outcome_index if abs(bias)<30, by(t right b3)

foreach x in outcome_index r m d {
	gen `x'_v=`x'_sd^2
	gen `x'_se=sqrt(`x'_v/obs)
	gen lb_`x'=`x'-invttail(obs-1,0.025)*`x'_se
	gen ub_`x'=`x'+invttail(obs-1,0.025)*`x'_se
}

drop if t==.
reshape wide outcome_index* r r_sd r_se r_v m* d* obs ub* lb* bias, i(b3 right) j(t)

label variable outcome_index1 "Outcome Index"
label variable r1 "Against-Redist"
label variable d1 "Decrease Taxes"
label variable m1 "Conservative Party"

foreach x in outcome_index r m d {
	gen `x'_diff=`x'1-`x'0
	gen `x'_diff_sd=sqrt(`x'_v0/obs0+`x'_v1/obs1)
	gen `x'_diff_df=((`x'_v0/obs0+`x'_v1/obs1)^2)/(((`x'_v0/obs0)^2/(obs0-1))+((`x'_v1/obs1)^2/(obs1-1)))
	gen lb_`x'_diff=`x'_diff-invttail(`x'_diff_df,0.025)*`x'_diff_sd
	gen ub_`x'_diff=`x'_diff+invttail(`x'_diff_df,0.025)*`x'_diff_sd

	format outcome_index* r* m* d* lb* ub* %9.1fc
	local label: variable label `x'1
	twoway (line `x'_diff bias1 if right==1, lwidth(medthick)) ///
	(rcap ub_`x'_diff lb_`x'_diff bias1 if right==1, color(maroon) lpattern(dash)) ///
	(line `x'_diff bias1 if right==0, lwidth(medthick) lpattern(shortdash)) ///
	(rcap ub_`x'_diff lb_`x'_diff bias1 if right==0, color(maroon) lpattern(dash)), $graphoptions  ///
	ytitle("`label'") legend(order(1 3) holes(2) label(1 "Treatment Effects, Right") label(3 "Treatment Effects, Non-Right"))

	graph save graphs\3g_`x'_diff_right_ci, replace
	graph export graphs\3g_`x'_diff_right_ci.png, replace
}
restore



