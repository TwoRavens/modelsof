
/*figure 1  (Panels) 
A -infants 
B -children 1-4 
C -55-64
D -65-74
*/



use "fig1data.dta", clear 

/*Note: Differences in mortality rates contained in race_sex=3 are differences for black v. white men*/
/*In race_sex=4 are differences for black v. white women*/

graph twoway (connected _diff_mort_infant year if race_sex==3 , ytitle(Difference in Infant  Mortality Rates) ///
xline(1972) lcolor(blue) mcolor(blue) xlabel(1968(2)1988)  ) ///
(connected _diff_mort_infant year if race_sex==4, mcolor(red) lcolor(red) legend(off)) 
graph export "fig1_panelA.tif", replace 

graph twoway (connected _diff_mort1_4 year if race_sex==3 , ytitle(Difference in Child Mortality Rates) ///
xline(1972) lcolor(blue) mcolor(blue) xlabel(1968(2)1988)  ) ///
(connected _diff_mort1_4 year if race_sex==4, mcolor(red) lcolor(red) legend(off))
graph export "fig1_panelB.tif", replace 

graph twoway (connected _diff_mort55_64 year if race_sex==3 , ytitle(Difference in 55-64 Mortality Rates) ///
xline(1972) lcolor(blue) mcolor(blue) xlabel(1968(2)1988) ) ///
(connected _diff_mort55_64 year if race_sex==4, mcolor(red) lcolor(red) legend(off)) 
graph export "fig1_panelC.tif", replace 

graph twoway (connected _diff_mort65_74 year if race_sex==3 , ytitle(Difference in 65-74 Mortality Rates) ///
xline(1972) lcolor(blue) mcolor(blue) xlabel(1968(2)1988)  ) ///
(connected _diff_mort65_74 year if race_sex==4, mcolor(red) lcolor(red) legend(off)) 
graph export "fig1_panelD.tif", replace 


