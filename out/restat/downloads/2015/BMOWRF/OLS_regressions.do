/**
 *
 * OLS MSA regression analysis
 *
 */

#delimit;

clear;

set more off;

use MSA_file.dta;

gen diff_log_wage_income     = log(msa_median_wage_income2006)     - log(msa_median_wage_income2000);
gen diff_log_black_income    = log(msa_black_median_income2006) - log(msa_black_median_income2000);
gen diff_log_hispanic_income    = log(msa_hispanic_median_income2006) - log(msa_hispanic_median_income2000);
gen diff_log_asian_income    = log(msa_asian_median_income2006) - log(msa_asian_median_income2000);
gen diff_log_white_income    = log(msa_white_median_income2006) - log(msa_white_median_income2000);
gen diff_log_personal_income = log(msa_median_personal_income2006) - log(msa_median_personal_income2000);
gen diff_unemployment_rate   = msa_unemployment_rate2006           - msa_unemployment_rate2000;
gen diff_employment_rate     = msa_employment_rate2006             - msa_employment_rate2000;

global CONTROLS = "elasticity_2000 past_due_2006 frac_high_risk_2006 frac_very_high_risk_2006 frac_low_risk_2006 spread_msa_p50_2006 diff_missing";
global INCOME_PRICE_CONTROLS = "diff_log_wage_income diff_log_hpi"; 

foreach var in $CONTROLS {;

	gen `var'_m = `var' == .;
	replace `var' = 0 if `var' == .;
	
};

global CONTROLS_MIS = "elasticity_2000_m past_due_2006_m frac_high_risk_2006_m frac_very_high_risk_2006_m frac_low_risk_2006_m spread_msa_p50_2006_m diff_missing_m";


label variable diff_lti "∆ LTI";
label variable diff_missing "∆ Pct. Missing Income";
label variable diff_acceptance "∆ Acceptance Rate";

local race1_blacks = "white";
local race2_blacks = "hispanic";

local race1_whites = "hispanic";
local race2_whites = "black";

local race1_hispanics = "white";
local race2_hispanics = "black";

set scheme s2mono;

foreach race in white black hispanic asian {;

	egen total_`race's2000 = sum(msa_`race's2000);

	gen weight_`race's = msa_`race's2000/total_`race's2000;
	
};

foreach race in white hispanic black {;

   areg diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_acceptance  [pweight=weight_`race's], a(statefips) cluster(statefips);
			
   areg diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_acceptance $CONTROLS $CONTROLS_MIS [pweight=weight_`race's], a(statefips) cluster(statefips);

   areg diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_acceptance $CONTROLS $CONTROLS_MIS $INCOME_PRICE_CONTROLS [pweight=weight_`race's], a(statefips) cluster(statefips);

   areg diff_exp_`race's_to_`race1_`race's's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_acceptance $CONTROLS $CONTROLS_MIS  [pweight=weight_`race's], cluster(statefips) a(statefips);

   areg diff_exp_`race's_to_`race2_`race's's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_acceptance $CONTROLS $CONTROLS_MIS [pweight=weight_`race's], cluster(statefips) a(statefips);
	
   areg diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_lti  [pweight=weight_`race's], a(statefips) cluster(statefips);
			
   areg diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_lti $CONTROLS $CONTROLS_MIS [pweight=weight_`race's], a(statefips) cluster(statefips);

   areg diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_lti $CONTROLS $CONTROLS_MIS $INCOME_PRICE_CONTROLS [pweight=weight_`race's], a(statefips) cluster(statefips);

   areg diff_exp_`race's_to_`race1_`race's's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_lti $CONTROLS $CONTROLS_MIS  [pweight=weight_`race's], cluster(statefips) a(statefips);

   areg diff_exp_`race's_to_`race2_`race's's diff_frac_blacks diff_frac_hispanics diff_frac_asians diff_lti $CONTROLS $CONTROLS_MIS  [pweight=weight_`race's], cluster(statefips) a(statefips);

};







