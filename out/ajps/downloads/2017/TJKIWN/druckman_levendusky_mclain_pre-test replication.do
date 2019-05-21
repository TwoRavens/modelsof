
/* Stata Replication Commands for pre-test reported in appendix of: "No Need to Watch: How the Effects of Partisan Media Can Spread Via Inter-Personal Discussions" */ 
/* by James Druckman, Matt Levendusky, and Audrey McLain */ 
/* This File: December 2016 */  

/* Start a log file to save the Stata output */ 
log using druckman_levendusky_mclain_pretest.smcl, replace 

/* Analyses below were run in Stata 14, set to version 14 */ 
version 14 

/* Set more off to avoid it interrupting the code */ 
set more off 

/* Read in the data */ 
use "druckman_levendusky_mclain_pre-test replication data"


/* Testing segment differences in direction and effectiveness */

ttest support , by( condition)
ttest effect, by (condition)

/* Run for Democrats and Republicans as discussed in appendix note 2 */

ttest effect, by (condition), if dem == 1
ttest effect, by (condition), if dem == 0


/* Trust and knowledge of networks by partisanship */

sum tfox kfox if dem == 1
sum tfox kfox if dem == 0

sum tmsnbc kmsnbc if dem == 1
sum tmsnbc kmsnbc if dem == 0

ttest tfox, by(dem)
ttest kfox, by(dem)

ttest tmsnbc, by(dem)
ttest kmsnbc, by(dem)
