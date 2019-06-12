*********************************************
** Replication File **
** Title: Personal Experience and Public Opinion: A Theory and Test of Conditional Policy Feedback
** Authors: Amy E. Lerman and Katherine T. McCabe
** Journal: The Journal of Politics
** Analysis Data File name: joprep3.dta, Data derive from KFF Trends Study
** **********************************************

clear
cd ""
use "joprep3.dta"


**********************
** Create Table 3 ****
***********************

* All *
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age6566) if (year == 2 | year == 3), robust
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age656667) if (year == 2 | year == 3), robust

* HS or Less *
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age6566) if (year == 2 | year == 3) & educn_s == 0, robust
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age656667) if (year == 2 | year == 3) & educn_s == 0, robust

* Some College *
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age6566) if (year == 2 | year == 3) & educn_s == .5, robust
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age656667) if (year == 2 | year == 3) & educn_s == .5, robust

* College or More *
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age6566) if (year == 2 | year == 3) & educn_s == 1, robust
ivregress 2sls acafavyesno Xl Xr i.date (onmedicarenotpub = age656667) if (year == 2 | year == 3) & educn_s == 1, robust
