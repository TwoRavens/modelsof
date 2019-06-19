/*This .do file loads in the replication data and creates all tables and figures in
Bitler, Gelbach, and Hoynes (2016) "Can Variation in Subgroups' Average Treatment 
Effects Explain Treatment Effect Heterogeneity? Evidence from a Social Experiment". 

Before running this file, researchers should obtain the Jobs First data from
MDRC and convert to .dta form.

These replication files were run using Stata MP v14.
*/

clear all
set more off
cap log close

capture log close

args ncores 12
set processors `ncores'

cd "./bgh/replication/"

********************************************************************************
*File directories -- change these lines to replicate results
*.ado directory
adopath + "/scratch/public/k.j.ruffini/bgh/replication/ado/"

*directory where raw MDRC data is stored
global afs2 "/scratch/public/k.j.ruffini/bgh"

********************************************************************************
log using "results/bgh_variationinsubgroupate.smcl", replace
!date

*Create data from MDRC file used to create figures and tables, including wage predictions
do "data/createdata.do"

*Additional numbers in Section 2.3
do "dofiles/bgh_sec2_3.do"

*Figure 1
do "dofiles/bgh_fig1.do"

*Figures 2 and 3
do "dofiles/bgh_fig2and3.do"

*Table 1
do "dofiles/bgh_table1.do"

*Table 2
do "dofiles/bgh_table2.do"

*Online appendix figures 
/*This MUST be run after "dofiles/bgh_fig2and3.do" to create Appendix Figure 3 */
do "dofiles/bgh_onlineappendix.do"

cap log close
