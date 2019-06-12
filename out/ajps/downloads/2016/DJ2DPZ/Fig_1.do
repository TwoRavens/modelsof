
use database_parties, clear
do variables_parties

* define bandwith and binsze

local bandwidth "0.4"
local binsize "0.01"

* Do graphs

set scheme s1color

* VOTE SHARE

* RDD
rdd_plot vs, control(running) binsize(`binsize')  bw(`bandwidth') title("Vote Share") 

* Diff-in-disc
rdd_plot_diff vs, control(running) binsize(`binsize')  bw(`bandwidth') title("Vote Share") 

* WINNING PROB 

* RDD
rdd_plot d_inc, control(running) binsize(`binsize')  bw(`bandwidth') title("Winning Probability") 

* Diff-in-disc
rdd_plot_diff d_inc, control(running) binsize(`binsize')  bw(`bandwidth') title("Winning Probability") 
