

// ------------------------------------------------------------------------ // 
//
//		Replicate Table 1-4 in the main paper
//
//		"Richer (and Holier) Than Thou? The Impact of Relative Income
//		Improvements on Demand for Redistribution"
//
// ------------------------------------------------------------------------ // 

use final, clear


// Globals
global estoptions "replace style(tex) substitute(_cons Constant) stats(N, fmt(0) labels("Obs")) numbers label collabels(none) cells(b(star fmt(3)) se(par fmt(3))) starlevels($^{*}$ 0.1 $^{**}$ 0.05 $^{***}$ 0.01) posthead(\midrule) prefoot(\addlinespace[0.1cm]) postfoot(\bottomrule)"
global main outcome_index against_redist cons_party decrease_tax


// Table 1: Determinants of bias
foreach x in college iq6 informed urban right age male married lwealth lincome posdiff movedup movingup changeincome {
local label: variable label `x'
eststo, title(Bias): xi: reg bias i.position `x',rob
}
eststo, title(Bias): xi: reg bias i.position college informed urban right age male married lwealth lincome posdiff movedup movingup changeincome,rob
estout using tables\bias.tex, drop(_Ipos*) $estoptions 
eststo clear

// Table 1: Determinants of absolute bias
foreach x in college iq6 informed urban right age male married lwealth lincome posdiff movedup movingup changeincome {
local label: variable label `x'
eststo, title(Bias): xi: reg absbias i.position `x',rob
}
eststo, title(Bias): xi: reg absbias i.position college informed urban right age male married lwealth lincome posdiff movedup movingup changeincome,rob
estout using tables\absbias.tex, drop(_Ipos*) $estoptions 
eststo clear


// Table 2: Average effects
foreach x of global main {
	local label: variable label `x'	
	eststo, title("`label'"): qui reg `x' tnbias nobias tnobias pbias tpbias, rob
}
estout using tables\average.tex, $estoptions  varlabels(tnbias "Treated\$\times\$Neg. Bias" tnobias "Treated\$\times\$No Bias" tpbias "Treated\$\times\$Pos. Bias")
eststo clear

// Table 3: Heterogeneous effects by prior party preferences
foreach x in outcome_index against_redist cons_party decrease_tax effort {
	local label: variable label `x'
	eststo, title(`label'): qui reg `x' t tright right if nbias==1, rob
}
estout using tables\right.tex, varlabels(tright "Treated\$\times\$Right") $estoptions 
eststo clear

// Table 4: Beliefs
foreach x in redist_distort nodist luck {
	eststo: qui reg outcome_index t t`x' `x' if nbias==1, rob
}
eststo: qui reg outcome_index t tredist_distort redist_distort right if nbias==1, rob
eststo: qui reg outcome_index t tredist_distort redist_distort if nbias==1 & right==1, rob
eststo: qui reg outcome_index t tredist_distort redist_distort if nbias==1 & right==0, rob
estout using tables\beliefs.tex, varlabels(tredist_distort "Treated\$\times\$Redist-Distort" tluck "Treated\$\times\$Luck" tnodist "T\$\times\$No dist.") $estoptions
eststo clear


