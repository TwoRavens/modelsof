************************************************************************************
*Replication Code (STATA 14) 
*
*Electoral Volatility and Turnout: Party Entry and Exit in Indian National Elections
*
*Oliver Heath and Adam Ziegfeld 
*
*Journal of Politics
*************************************************************************************

use "Turnout & Volatility JOP replication data 1.dta", clear


***Table 1. Party Entry and Exit and Turnout
xtset pc_num
xtreg turnout_change turnout_lagged ENP_lagged margin_lagged electorate concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change vote_entry vote_ind vote_exit turnout_lagged ENP_lagged margin_lagged  electorate concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change vote_newfound vote_successor vote_prioralliance vote_ind vote_defunct vote_alliance turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change vote_entry vote_ind vote_exit c.vote_entry#c.vote_exit turnout_lagged ENP_lagged margin_lagged electorate concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change vote_newfound vote_successor vote_prioralliance vote_ind vote_defunct vote_alliance c.vote_successor#c.vote_defunct turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r



***Figure 1. Marginal Effects of Exit on Turnout when Followed by Entry 
set scheme s1mono

*Left panel
qui xtreg turnout_change vote_entry vote_ind vote_exit c.vote_entry#c.vote_exit turnout_lagged ENP_lagged margin_lagged electorate concurrent elapse suffrage time popdense_log literacy, fe r
qui margins, dydx(vote_exit) at(vote_entry=(0(.01).8))
marginsplot

*Right panel
qui xtreg turnout_change vote_newfound vote_successor vote_prioralliance vote_ind vote_defunct vote_alliance c.vote_successor#c.vote_defunct turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r
qui margins, dydx(vote_defunct) at(vote_successor=(0(.01).8))
marginsplot



****Table 2. Robustness Check: Number of New Parties and Major Independents
xtreg turnout_change num_newfound num_successor num_prioralliance num_ind vote_defunct vote_alliance turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change num_newfound5 num_successor5 num_prioralliance5 num_ind vote_defunct vote_alliance turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change num_newfound10 num_successor10 num_prioralliance10 num_ind vote_defunct vote_alliance turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change num_newfound15 num_successor15 num_prioralliance15 num_ind vote_defunct vote_alliance turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r
xtreg turnout_change num_newfound20 num_successor20 num_prioralliance20 num_ind vote_defunct vote_alliance turnout_lagged ENP_lagged margin_lagged electorate  concurrent elapse suffrage time popdense_log literacy, fe r



****Table 3. Mechanism: Party Entry and Exit and Mobilization, 2004
regress mobilized vote_entry vote_exit vote_ind turnout_lagged ENP margin_lagged electorate concurrent literacy, vce (robust)
regress turnout_change vote_entry vote_exit vote_ind turnout_lagged ENP margin_lagged electorate concurrent literacy if mobilized!=., vce (robust)
regress turnout_change mobilized vote_entry vote_exit vote_ind turnout_lagged ENP margin_lagged electorate concurrent literacy, vce (robust)




************************************************************************************
*************************************NOTES******************************************
*
*
*State codes for the variable "st_code" are as follows:
*	S01 = Andhra Pradesh
*	S03 = Assam
*	S04 = Bihar
*	S06 = Gujarat
*	S07 = Haryana
*	S08 = Himachal Pradesh
*	S09 = Jammu & Kashmir
*	S10 = Karnataka
*	S11 = Kerala
*	S12 = Madhya Pradesh
*	S13 = Maharashtra
*	S18 = Odisha [Orissa]
*	S19 = Punjab
*	S20 = Rajasthan
*	S22 = Tamil Nadu
*	S24 = Uttar Pradesh 
* 	S25 = West Bengal
*	S26 = Chhattisgarh
*	S27 = Jharkhand
* 	S28 = Uttarakhand
*	U05 = Delhi
*
*
*************************************************************************************
