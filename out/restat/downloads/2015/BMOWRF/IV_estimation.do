
#delimit ;

clear;

set more off;
use MSA_file_with_IV.dta, replace;

label variable diff_lti "∆LTI";
label variable diff_acceptance "∆Acceptance Rate";

local race1_blacks = "whites";
local race2_blacks = "hispanics";

local race1_whites = "hispanics";
local race2_whites = "blacks";

local race1_hispanics = "whites";
local race2_hispanics = "blacks";

local race1_asians = "blacks";
local race2_asians = "hispanics";

local iv_acceptance = "msa_loutskina";
local iv_lti = "msa_liquidity";

label variable msa_liquidity "Liquidity";
label variable msa_loutskina "Securitizability";

foreach race in white hispanic black {;
		
   ivreg2 diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians (diff_acceptance=`iv_acceptance')  , cluster(statefips) first;

   ivreg2 diff_exp_`race's_to_`race1_`race's' diff_frac_blacks diff_frac_hispanics diff_frac_asians (diff_acceptance=`iv_acceptance')  , cluster(statefips) first;

   ivreg2 diff_exp_`race's_to_`race2_`race's' diff_frac_blacks diff_frac_hispanics diff_frac_asians (diff_acceptance=`iv_acceptance') , cluster(statefips) first;

   regress diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians `iv_acceptance' , cluster(statefips) ;

   ivreg2 diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians (diff_lti = `iv_lti')  , cluster(statefips) first;

   ivreg2 diff_exp_`race's_to_`race1_`race's' diff_frac_blacks diff_frac_hispanics diff_frac_asians (diff_lti = `iv_lti')  , cluster(statefips) first;

   ivreg2 diff_exp_`race's_to_`race2_`race's' diff_frac_blacks diff_frac_hispanics diff_frac_asians (diff_lti = `iv_lti')  , cluster(statefips) first;

   regress diff_isolation_`race's diff_frac_blacks diff_frac_hispanics diff_frac_asians `iv_lti'  , cluster(statefips) ;
   
};






