
use database_candidates, clear
do variables_candidates

* Generate variable probability of re-running

reg p incumbency inc_ad running inc_ad2 running2 if abs(running)<0.8, r
predict phat

sort code year id
by code: gen l_prob= phat[_n-6]

* Keep only candidates that rerun

keep if rerun==1

** Graphs Selection Bias

* define bandwith and binsze
local bandwidth "0.4"
local binsize "0.01"
****************************************************************************************************************************************************************

set scheme s1color

rdd_plot l_vs, control(running) binsize(`binsize')  bw(`bandwidth') title("Vote Share t-1") 

rdd_plot l_prob, control(running) binsize(`binsize')  bw(`bandwidth') title("Probability of Winning t-1") 

rdd_plot l_idd, control(running) binsize(`binsize')  bw(`bandwidth') title("Party Affiliation") 

rdd_plot l_col, control(running) binsize(`binsize')  bw(`bandwidth') title("Coalition Party") 

rdd_plot l_f, control(running) binsize(`binsize')  bw(`bandwidth') title("Female Candidate") 

rdd_plot l_exp, control(running) binsize(`binsize')  bw(`bandwidth') title("Experience") 


