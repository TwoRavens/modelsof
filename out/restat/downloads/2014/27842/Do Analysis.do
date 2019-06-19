/* Do Analysis.do */
/* This do file is the primary do file for conducting the analysis of 
Meier and Sprenger Temporal stability of time preferences. The do file
establishes path and log, calls 5 additional do files and then closes the log.
The five additional do files are: 	
	1. ML Estimators.do: reads maximum likelihood estimators for quasihyperbolic and
	hyperbolic discounting into memory.
	2. Aggregate Tables.do: conducts aggregate analysis.
	3. Individual Tables.do: conducts individual analysis.
	4. Figures.do: constructs figures.
	5. Expected Correlation.do: conducts expected correlation analysis under varying noise estimates
*/


clear
set mem 100m
set more off


/* Establish Path */
/* Note: Change path accordingly to location of Stata folder */
cd "/Users/cspreng/Desktop/Preference Stability/Stata"

/* Read in Data Set */
use "`c(pwd)'/Data/dataset.dta"

/* Establish Log Location */
log using "`c(pwd)'/Output/log.txt", replace textlog off

/* Bring maximum likelihood estimators into memory */
do "`c(pwd)'/Do Files/ML Estimators.do"
/* Conduct Aggregate Analyses */
do "`c(pwd)'/Do Files/Aggregate Tables.do"
/* Conduct Individual Analyses */
do "`c(pwd)'/Do Files/Individual Tables.do"
/* Construct Figures */
do "`c(pwd)'/Do Files/Figures.do"
/* Conduct expected correlation analysis */
do "`c(pwd)'/Do Files/Expected Correlation.do"

log close

