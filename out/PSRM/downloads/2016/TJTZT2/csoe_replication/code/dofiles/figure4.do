*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Manuscript Figure 4
*********

* version 13
set more off
clear all

*set working directory to folder containing data

use "datasets/nds_ee_ge_1998-2014.dta"

egen mean_to_csoe_ep = mean(to) if csoe2014==1 & level == "ep", by(year)
egen mean_to_control_ep = mean(to) if csoe2014==0  & level == "ep", by(year)
egen mean_to_csoe_btw = mean(to) if csoe2014==1 & level == "btw", by(year)
egen mean_to_control_btw = mean(to) if csoe2014==0  & level == "btw", by(year)

keep csoe2014 mean_to_csoe_ep mean_to_control_ep mean_to_csoe_btw mean_to_control_btw year level
duplicates drop

twoway scatter mean_to_csoe_ep year if csoe2014==1 & level == "ep" , connect(L) || scatter mean_to_control_ep year if csoe2014==0 & level == "ep", connect(L) || ///
scatter mean_to_csoe_btw year if csoe2014==1 & level == "btw", connect(L) || scatter mean_to_control_btw year if csoe2014==0 & level == "btw", connect(L) ///
scheme(s1mono) xlabel(1998 "1998" 1999 "99" 2002 "2002" 2004 "2004"  2005 "05" 2009 "2009" 2013 "2013" 2014 "14" ) ///
xtitle(Year of European or General Election) ytitle(Average Turnout in Municipalities) ///
legend(col(2) symxsize(*0.8) order(1 3 2 4) label( 1 "EE, CSOE in 2014") label(2 "EE, Control in 2014") label(3 "GE, CSOE in 2014") label(4 "GE, Control in 2014"))

graph export "output/figure4-stata.eps", replace
