*********************************************
** Replication File **
** Title: Personal Experience and Public Opinion: A Theory and Test of Conditional Policy Feedback 
** Authors: Amy E. Lerman and Katherine T. McCabe
** Journal: The Journal of Politics
** Analysis Data File name: joprep2.dta, Data derive from June 2011 Pew Study
** **********************************************

clear
cd ""
use "joprep2.dta"

**********************
** Create Table 2 ****
***********************

** Reduced Form **
regress keepmedss Xl Xr age65over if age >= 63 & age <= 66, robust
regress keepmedss Xl Xr age65over if age >= 62 & age <= 67, robust 
regress keepmedss Xl Xr age65over if age >= 61 & age <= 68, robust
regress keepmedss Xl Xr age65over if age >= 60 & age <= 69, robust

** IV: Receives Medicare **
ivregress 2sls keepmedss Xl Xr (recmedicare = age65over) if age >= 63 & age <= 66, robust 
ivregress 2sls keepmedss Xl Xr (recmedicare = age65over) if age >= 62 & age <= 67,robust
ivregress 2sls keepmedss Xl Xr (recmedicare = age65over) if age >= 61 & age <= 68, robust
ivregress 2sls keepmedss Xl Xr (recmedicare = age65over) if age >= 60 & age <= 69, robust


** OLS Regressions **
regress keepmedss Xl Xr recmedicare recss recprivins if age >= 63 & age <= 66, robust
regress keepmedss Xl Xr recmedicare recss recprivins if age >= 62 & age <= 67, robust
regress keepmedss Xl Xr recmedicare recss recprivins if age >= 61 & age <= 68, robust 
regress keepmedss Xl Xr recmedicare recss recprivins if age >= 60 & age <= 69, robust
