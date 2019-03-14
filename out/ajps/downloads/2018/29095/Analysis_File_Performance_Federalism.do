*Analysis Do File for "Performance Federalism and Local Democracy";
*February 8, 2014;

#delimit;
clear all;
set mem 900m;

*Set Path;
cd "~/Box Sync/Replication_AJPS_0215";

*Calls Four Stata Do Files to Reproduce Tables;

do Main_Results;
do Yes_Percent_DV;
do Proficiency_Rates;
do Levy_Proposal_DV;

*To Create Figures 1 and 2 Execute the R Scripts saved in the "Figure 1" and "Figure 2" Folders; 
