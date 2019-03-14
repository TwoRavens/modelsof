* ./dcp_rundir.do
* Replication script for Distelhorst and Locke. Does Compliance Pay?. AJPS.

* Runs all STATA scripts
* Results collect in ./output/

* NOTE: These scripts use Linux shell commands (e.g. !sed) to format tables
* Behavior may vary on Windows-based systems

clear
set more off

* Need outreg2 and entropy balancing packages
ssc install outreg2
ssc install ebalance

* Main analyses and tables
do dcp_main.do

* Effect magnitudes using bootstrap method
do dcp_bootstraps.do 

* Table A6: Pre- and post-entropy balancing covariate moments
do dcp_baltabs.do

* Rightmost panel of Table 2
* Computationally intensive, uncomment and run on high-perf cluster or overnight on personal computer
* do dcp_tt.do



