/*
 * Analysis of the longitudinal data set
 */


#delimit ;

clear;

set more off;

use "longitudinal census tract data set.dta";

gen diff_log_income  = log(median_household_income_2010) - log(median_household_income);
winsor diff_log_income, p(0.05) g(diff_log_income_w);

keep if msa_blacks>150000;

keep if msa != .;

egen msatag = tag(msa);
gsort -msa_blacks;

local K = 20;

xtile qblacks = frac_black , n(`K');

gen nonblack_pop_2010 = total_pop_2010 - black_pop_2010;
gen nonblack_pop      = total_pop      - black_pop;

gen diff_log_pop = log(total_pop_2010) - log(total_pop);

sort qblacks;
by qblacks: gen mean_frac_black 	= sum(frac_black*total_pop)/sum(total_pop);
by qblacks: replace mean_frac_black = mean_frac_black[_N];

gen all_pop = total_pop;

gen diff_log_all_nw 			= (total_pop_2010 		- total_pop)			/ total_pop;
gen diff_log_blacks_nw 			= (black_pop_2010 		- black_pop)			/ total_pop;
gen diff_log_whites_nw 			= (white_pop_2010 		- white_pop)			/ total_pop;
gen diff_log_hispanics_nw 		= (hispanic_pop_2010 	- hispanic_pop)			/ total_pop;
gen diff_log_housing_units_nw 	= (housing_units_2010	- housing_units_2000)	/ housing_units_2000;

foreach var in diff_log_all diff_log_blacks diff_log_whites diff_log_hispanics diff_log_housing_units {;
	
	gen `var' = `var'_nw ;
	
	centile `var'_nw, c(2 98);

	replace `var' = r(c_2) if `var'_nw > r(c_2);
	replace `var' = r(c_1) if `var'_nw < r(c_1);
	
};

drop if msa_average_loutskina == .;

gen high_liquidity = msa_average_loutskina > 0.3962764 & msa_average_loutskina !=.;
gen low_liquidity  = msa_average_loutskina <= 0.3962764 & msa_average_loutskina !=.;

forvalues k = 1/`K' {;

	gen qxi`k'         = qblacks == `k';
	
};

forvalues k = 1/`K' {;

	gen qxi`k'_low    = (qblacks == `k')*low_liquidity;

};

forvalues k = 1/`K' {;

	gen qxi`k'_high    = (qblacks == `k')*high_liquidity;

};

forvalues k = 1/`K' {;
	
	quietly sum mean_frac_black if qblacks == `k';
	local frac_blacks_q`k' = r(mean);
		
};

foreach variable in diff_frac_blacks diff_frac_hispanics diff_frac_asians {;

	sum `variable' [aweight=black_pop];
	replace `variable' = `variable' - r(mean);
	
};

foreach race in all blacks hispanics whites  {;

	winsor diff_log_`race', p(0.01) g(diff_log_`race'_w);
	
};

egen msa_blacks_2010    = sum(black_pop_2010), 		by(msa);
egen msa_hispanics_2010 = sum(hispanic_pop_2010), 	by(msa);
egen msa_asians_2010    = sum(asian_pop_2010),		by(msa);

gen msa_black_inflow 	= (msa_blacks_2010		- msa_blacks)	/msa_blacks;
gen msa_hispanic_inflow = (msa_hispanics_2010	- msa_hispanics)/msa_hispanics;
gen msa_asians_inflow 	= (msa_asians_2010		- msa_asians)	/msa_asians;

foreach variable in msa_black_inflow msa_hispanic_inflow msa_asians_inflow {;

	sum `variable' [aweight=black_pop];
	replace `variable' = `variable' - r(mean);
	
};

foreach race in all blacks hispanics whites  {;

	areg diff_log_`race' qxi2-qxi`K' diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_log_income_w [aweight=total_pop], a(statefips) cluster(statefips);
	
	matrix A = e(V);
	
	cap drop stateeffect;
	predict stateeffect, d;
	sum stateeffect;
	local mean_stateeffect = r(mean);
	
	local change_`race'_q1 = _b[_cons] + `mean_stateeffect';	
	local se_`race'_q1     = _se[_cons];
	local chgub_`race'_q1 = `change_`race'_q1' + 1.96*`se_`race'_q1';
	local chglb_`race'_q1 = `change_`race'_q1' - 1.96*`se_`race'_q1';

	forvalues k=2/`K' {;
	
		local change_`race'_q`k' = _b[qxi`k'] + _b[_cons] + `mean_stateeffect';
		local se_`race'_q`k'     = _se[qxi`k'];
		local chgub_`race'_q`k' = `change_`race'_q`k'' + 1.96*`se_`race'_q`k'';
		local chglb_`race'_q`k' = `change_`race'_q`k'' - 1.96*`se_`race'_q`k'';
		
	};
	
	areg diff_log_`race' qxi2_low-qxi`K'_low qxi2_high-qxi`K'_high /*diff_frac_blacks diff_frac_hispanics diff_frac_asians*/
		 			msa_black_inflow msa_hispanic_inflow  msa_asians_inflow high_liquidity diff_log_income_w [aweight=total_pop] , a(statefips) cluster(msa);
	
	cap drop stateeffect;
	predict stateeffect, d;
	sum stateeffect;
	local mean_stateeffect = r(mean);
	
	local change_`race'_q1_lowliq  = _b[_cons] + `mean_stateeffect';
	local change_`race'_q1_highliq = _b[_cons] + _b[high_liquidity] + `mean_stateeffect';
	
	local se_`race'_q1_highliq = _se[high_liquidity];
	local se_`race'_q1_lowliq  = _se[_cons];
	
	if ((_b[high_liquidity]/_se[high_liquidity])>1.6) {;

		local star_`race'_highliq_1 = "*";

	};

	if ((_b[high_liquidity]/_se[high_liquidity])>1.96) {;

		local star_`race'_highlig_1 = "**";

	};
	
	if ((_b[high_liquidity]/_se[high_liquidity])>2.576) {;

		local star_`race'_highliq_1 = "***";

	};
	
	if ((_b[_cons]/_se[_cons])>1.6) {;

		local star_`race'_highliq_1 = "*";

	};

	if ((_b[_cons]/_se[_cons])>1.96) {;

		local star_`race'_highlig_1 = "**";

	};
	
	if ((_b[_cons]/_se[_cons])>2.576) {;

		local star_`race'_highliq_1 = "***";

	};
	

	forvalues k=2/`K' {;
	
		local change_`race'_q`k'_lowliq	 = _b[_cons] + _b[qxi`k'_low] + `mean_stateeffect';
		local se_`race'_q`k'_lowliq	 	 = _se[qxi`k'_low];
		local chgub_`race'_q`k'_lowliq	 = `change_`race'_q`k'_lowliq' + 1.96*`se_`race'_q`k'_lowliq';	
		local chglb_`race'_q`k'_lowliq	 = `change_`race'_q`k'_lowliq' - 1.96*`se_`race'_q`k'_lowliq';

		local change_`race'_q`k'_highliq = _b[_cons] + _b[high_liquidity] + _b[qxi`k'_high] + `mean_stateeffect';
		local se_`race'_q`k'_highliq     = _se[qxi`k'_high];
		local chgub_`race'_q`k'_highliq	 = `change_`race'_q`k'_highliq' + 1.96*`se_`race'_q`k'_highliq';	
		local chglb_`race'_q`k'_highliq	 = `change_`race'_q`k'_highliq' - 1.96*`se_`race'_q`k'_highliq';
		
		test qxi`k'_high + high_liquidity = qxi`k'_low;

		if (r(p)<0.10) {;

			local star_`race'_`k' = "*";

		};

		if (r(p)<0.05) {;

			local star_`race'_`k' = "**";

		};

		if (r(p)<0.01) {;

			local star_`race'_`k' = "***";

		};
		
	};

};

areg diff_log_housing_units qxi2-qxi`K' diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_log_income_w [aweight=black_pop], a(statefips) cluster(statefips);

cap drop stateeffect;
predict stateeffect, d;
sum stateeffect;
local mean_stateeffect = r(mean);

local change_hu_q1 = _b[_cons] + `mean_stateeffect';
local se_hu_q1     = _se[_cons];
local chgub_hu_q1 = `change_hu_q1' + 1.96*`se_hu_q1';
local chglb_hu_q1 = `change_hu_q1' - 1.96*`se_hu_q1';

forvalues k=2/`K' {;

	local change_hu_q`k' = _b[qxi`k'] + _b[_cons] + `mean_stateeffect';
	local se_hu_q`k'     = _se[qxi`k'];
	local chgub_hu_q`k' = `change_hu_q`k'' + 1.96*`se_hu_q`k'';
	local chglb_hu_q`k' = `change_hu_q`k'' - 1.96*`se_hu_q`k'';
	
};

areg diff_log_housing_units qxi2_low-qxi`K'_low qxi2_high-qxi`K'_high diff_frac_blacks diff_frac_hispanics diff_frac_asians high_liquidity diff_log_income_w [aweight=black_pop], a(statefips) cluster(statefips);

cap drop stateeffect;
predict stateeffect, d;
sum stateeffect;
local mean_stateeffect = r(mean);

local change_hu_q1_lowliq  = _b[_cons] + `mean_stateeffect' ;
local change_hu_q1_highliq = _b[_cons] + _b[high_liquidity] + `mean_stateeffect';

if ((_b[high_liquidity]/_se[high_liquidity])>1.6) {;

	local star_hu_1 = "*";

};

if ((_b[high_liquidity]/_se[high_liquidity])>1.96) {;

	local star_hu_1 = "**";

};

if ((_b[high_liquidity]/_se[high_liquidity])>2.576) {;

	local star_hu_1 = "***";

};

forvalues k=2/`K' {;

	local change_hu_q`k'_lowliq	 = _b[_cons] + _b[qxi`k'_low] + `mean_stateeffect' ;
	local change_hu_q`k'_highliq = _b[_cons] + _b[high_liquidity] + _b[qxi`k'_high] + `mean_stateeffect';
	
	test qxi`k'_low = qxi`k'_high + high_liquidity;
	
	if (r(p)<0.10) {;
	
		local star_hu_`k' = "*";
	
	};
	
	if (r(p)<0.05) {;
	
		local star_hu_`k' = "**";
	
	};
	
	if (r(p)<0.01) {;
	
		local star_hu_`k' = "***";
	
	};
	
};


drop _all;

set obs `K';

gen q = _n;

gen frac_blacks = .;

gen change_blacks = .;
gen change_blacks_ub = .;
gen change_blacks_lb = .;

gen change_whites = .;
gen change_whites_ub = .;
gen change_whites_lb = .;

gen change_hispanics = .;
gen change_hispanics_ub = .;
gen change_hispanics_lb = .;


gen change_all = .;
gen change_all_ub = .;
gen change_all_lb = .;

gen change_hu  = .;
gen change_hu_ub  = .;
gen change_hu_lb  = .;

gen change_blacks_highliq = .;
gen change_blacks_lowliq  = .;
gen label_blacks = "";

gen change_whites_highliq = .;
gen change_whites_lowliq  = .;
gen label_whites = "";

gen change_hispanics_highliq = .;
gen change_hispanics_lowliq  = .;
gen label_hispanics = "";

gen change_all_highliq = .;
gen change_all_lowliq  = .;
gen label_all = "";

gen change_hu_highliq = .;
gen change_hu_lowliq  = .;
gen label_hu = "";

forvalues k=1/`K' {;

	quietly {;
	
		replace frac_blacks   		  = `frac_blacks_q`k'' if q == `k';
		
		replace change_blacks         = `change_blacks_q`k'' if q == `k';
		replace change_blacks_ub      = `chgub_blacks_q`k''  if q == `k';
		replace change_blacks_lb      = `chglb_blacks_q`k''  if q == `k';
		
		replace change_blacks_highliq = `change_blacks_q`k'_highliq' if q == `k';
		replace change_blacks_lowliq  = `change_blacks_q`k'_lowliq'  if q == `k';
		replace label_blacks  = "`star_blacks_`k''" if q == `k';
	
		replace change_whites 		  = `change_whites_q`k'' if q == `k';
		replace change_whites_ub      = `chgub_whites_q`k''  if q == `k';
		replace change_whites_lb      = `chglb_whites_q`k''  if q == `k';

		replace change_whites_highliq = `change_whites_q`k'_highliq' if q == `k';
		replace change_whites_lowliq  = `change_whites_q`k'_lowliq'  if q == `k';
		replace label_whites  = "`star_whites_`k''" if q == `k';
	
		replace change_hispanics 		  = `change_hispanics_q`k'' if q == `k';
		replace change_hispanics_ub      = `chgub_hispanics_q`k''  if q == `k';
		replace change_hispanics_lb      = `chglb_hispanics_q`k''  if q == `k';

		replace change_hispanics_highliq = `change_hispanics_q`k'_highliq' if q == `k';
		replace change_hispanics_lowliq  = `change_hispanics_q`k'_lowliq'  if q == `k';
		replace label_hispanics  = "`star_hispanics_`k''" if q == `k';
		
		replace change_all 		  = `change_all_q`k'' if q == `k';
		replace change_all_ub      = `chgub_all_q`k''  if q == `k';
		replace change_all_lb      = `chglb_all_q`k''  if q == `k';
		
		replace change_all_highliq = `change_all_q`k'_highliq' if q == `k';
		replace change_all_lowliq  = `change_all_q`k'_lowliq'  if q == `k';
		replace label_all = "`star_all_`k''" if q == `k';

		replace change_hu 		  = `change_hu_q`k'' if q == `k';
		replace change_hu_ub      = `chgub_hu_q`k''  if q == `k';
		replace change_hu_lb      = `chglb_hu_q`k''  if q == `k';		
		
		replace change_hu_highliq = `change_hu_q`k'_highliq' if q == `k';
		replace change_hu_lowliq  = `change_hu_q`k'_lowliq'  if q == `k';
		replace label_hu = "`star_hu_`k''" if q == `k';

	};

};

graph drop _all;

label variable change_blacks 	"{&Delta}Blacks/Population, 2010-2000";
label variable change_whites 	"{&Delta}Whites/Population, 2010-2000";
label variable change_hispanics "{&Delta}Hispanics/Population, 2010-2000";
label variable change_hispanics "{&Delta}Population/Population, 2010-2000";
label variable change_hu 		"{&Delta}Housing Units/Housing Units, 2010-2000";

label variable frac_blacks "Fraction Black in 2000, by P10 Quantiles";


set scheme s2color;

graph twoway  (rarea change_blacks_ub change_blacks_lb frac_blacks,  pstyle(ci))
				|| (scatter change_blacks frac_blacks,  connect(l) clwidth(medthick) clcolor(black) clpattern(dot) sort), 
			name(regression_analysis_blacks) graphregion(color(white))
			legend(off)
			xtitle( "Fraction Black in 2000, by P10 Quantiles")
			ytitle("{&Delta}Blacks/Population, 2010-2000");

graph twoway (scatter change_blacks_highliq frac_blacks, connect(l) clwidth(medthick) clcolor(blue) clpattern(dot) sort ) 
		|| (scatter change_blacks_lowliq frac_blacks, connect(l) clwidth(thick) clcolor(red) clpattern(solid) sort mlabel(label_blacks)), 
		name(analysis_blacks_highlowliq) graphregion(color(white))
		xtitle("Fraction Black in 2000, by P10 Quantiles")
		ytitle("{&Delta}Blacks/Population, 2010-2000")
		legend(label(1 "Low Predicted {&Delta}Approval") label(2 "High Predicted {&Delta}Approval"))
		;

graph twoway   (rarea change_whites_ub change_whites_lb frac_blacks,  pstyle(ci))
			|| (scatter change_whites    frac_blacks, connect(l) clwidth(medthick) clcolor(black) clpattern(dot) sort)
			, name(regression_analysis_whites) graphregion(color(white))
			legend(off)
			xtitle( "Fraction Black in 2000, by P10 Quantiles")
			ytitle("{&Delta}Whites/Population, 2010-2000");

graph twoway (scatter change_whites_highliq frac_blacks, connect(l) clwidth(medthick) clcolor(blue) clpattern(dot) sort  msize(small)) 
	|| (scatter change_whites_lowliq frac_blacks, connect(l) clwidth(thick) clcolor(red) clpattern(solid) sort mlabel(label_whites) msize(small)), 
		name(analysis_whites_highlowliq) graphregion(color(white))
		/*ylabel(-0.12(.02).08)*/
		xtitle("Fraction Black in 2000, by P10 Quantiles")
		ytitle("{&Delta}Whites/Population, 2010-2000")
		legend(label(1 "Low Predicted {&Delta}Approval") label(2 "High Predicted {&Delta}Approval"));

graph twoway   (rarea change_hispanics_ub change_hispanics_lb frac_blacks, pstyle(ci))
			|| (scatter change_hispanics    frac_blacks, connect(l) clwidth(medthick) clcolor(black) clpattern(dot) sort)
			, name(regression_analysis_hispanics) graphregion(color(white))
				legend(off)
				xtitle( "Fraction Black in 2000, by P10 Quantiles")
				ytitle("{&Delta}Hispanics/Population, 2010-2000");

graph twoway (scatter change_hispanics_highliq frac_blacks, connect(l) clwidth(medthick) clcolor(blue) clpattern(dot) sort ) 
	|| (scatter change_hispanics_lowliq frac_blacks, connect(l) clwidth(thick) clcolor(red) clpattern(solid) sort mlabel(label_hispanics)), 
		name(analysis_hispanics_highlowliq) graphregion(color(white))
		ylabel(-0.20(.05).05)
		xtitle("Fraction Black in 2000, by P10 Quantiles")
		ytitle("{&Delta}Hispanics/Population, 2010-2000")
		legend(label(1 "Low Predicted {&Delta}Approval") label(2 "High Predicted {&Delta}Approval"));

graph twoway   (rarea change_all_ub change_all_lb frac_blacks, pstyle(ci) )
			|| (scatter change_all    frac_blacks, connect(l) clwidth(medthick) clcolor(black) clpattern(dot) sort)
			, name(regression_analysis_all) graphregion(color(white))
			legend(off)
			xtitle( "Fraction Black in 2000, by P10 Quantiles")
			ytitle("{&Delta}Population/Population, 2010-2000");

graph twoway (scatter change_all_highliq frac_blacks, connect(l) clwidth(medthick) clcolor(blue) clpattern(dot) sort) 
	|| (scatter change_all_lowliq frac_blacks, connect(l) clwidth(thick) clcolor(red) clpattern(solid) sort mlabel(label_blacks)), 
		name(analysis_all_highlowliq) graphregion(color(white))
		ylabel(-0.20(.05).05)
		xtitle("Fraction Black in 2000, by P10 Quantiles")
		ytitle("{&Delta}Population/Population, 2010-2000")
		legend(label(1 "Low Predicted {&Delta}Approval") label(2 "High Predicted {&Delta}Approval"));

graph twoway   (rarea change_hu_ub change_hu_lb frac_blacks,pstyle(ci))
			|| (scatter change_hu    frac_blacks, connect(l) clwidth(medthick) clcolor(black) clpattern(dot) sort)
			, name(regression_analysis_hu) graphregion(color(white))
			legend(off)
			xtitle( "Fraction Black in 2000, by P10 Quantiles")
			ytitle("{&Delta}Housing Units/Population, 2010-2000");

graph twoway (scatter change_hu_highliq frac_blacks, connect(l) clwidth(medthick) clcolor(blue) clpattern(dot) sort) 
	|| (scatter change_hu_lowliq frac_blacks, connect(l) clwidth(thick) clcolor(red) clpattern(solid) sort mlabel(label_hu)), 
		name(analysis_hu_highlowliq) graphregion(color(white))
		ylabel(-0.05(.05).20)
		xtitle("Fraction Black in 2000, by P10 Quantiles")
		ytitle("{&Delta}Housing Units/Housing Units, 2010-2000")
		legend(label(1 "Low Predicted {&Delta}Approval") label(2 "High Predicted {&Delta}Approval"));




