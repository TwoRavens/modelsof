
******CHANGE POINT ANALYSIS******
use "Change Point Data.dta"
*If not previously installed, install zandrews by entering "ssc install zandrews" into the Stata command box
tsset year
zandrews yhat1, break(trend)
*interpretation: there is a structural break in rate of exile for culpable leaders at end of 1997/start of 1998
