 
*===============================================================*
*Do-File: 
*Do State Responses to Automation Matter for Voters? *
*Research and Politics *
*ISSP FILE *

*January 25th 2019*
*Creates Figure 1*
*===============================================================*

/*cd "SET WORKING DIRECTORY"*/

use "RP_Context_Data.dta"

*Puts inactivity on same scale as spending*
replace inactive_rate_older=inactive_rate_older*100
 
 graph twoway (lowess inactive_rate_older year if ccode==826, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==826, lcolor(black)) ///
(lowess epl_combined year if ccode==826, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(UK2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(UK, size(small))

 
  graph twoway (lowess inactive_rate_older year if ccode==840, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==840, lcolor(black)) ///
(lowess epl_combined year if ccode==840, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(USA2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(USA, size(small))
 
 graph twoway (lowess inactive_rate_older year if ccode==124, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==124, lcolor(black)) ///
(lowess epl_combined year if ccode==124, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Canada2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Canada, size(small))
 
 graph twoway (lowess inactive_rate_older year if ccode==36, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==36, lcolor(black)) ///
(lowess epl_combined year if ccode==36, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Australia2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Australia, size(small))
 
 graph twoway (lowess inactive_rate_older year if ccode==752, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==752, lcolor(black)) ///
(lowess epl_combined year if ccode==752, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(swe2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Sweden, size(small))
 graph twoway (lowess inactive_rate_older year if ccode==208, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==208, lcolor(black)) ///
(lowess epl_combined year if ccode==208, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Denmark2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Denmark, size(small))
 graph twoway (lowess inactive_rate_older year if ccode==578, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==578, lcolor(black)) ///
(lowess epl_combined year if ccode==578, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Norway2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Norway, size(small))
 
 graph twoway (lowess inactive_rate_older year if ccode==276, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==276, lcolor(black)) ///
(lowess epl_combined year if ccode==276, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Germany2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Germany, size(small))

 graph twoway (lowess inactive_rate_older year if ccode==250, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==250, lcolor(black)) ///
(lowess epl_combined year if ccode==250, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(France2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(France, size(small))
 graph twoway (lowess inactive_rate_older year if ccode==724, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==724, lcolor(black)) ///
(lowess epl_combined year if ccode==724, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Spain2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Spain, size(small))

 graph twoway (lowess inactive_rate_older year if ccode==380, lcolor(gs12)  ) ///
(lowess prog_gdp9002 year if ccode==380, lcolor(black) ) ///
(lowess epl_combined year if ccode==380, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Italy2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Italy, size(small))
 graph twoway (lowess inactive_rate_older year if ccode==724, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==724, lcolor(black)) ///
(lowess epl_combined year if ccode==724, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Spain2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Spain, size(small))

  graph twoway (lowess inactive_rate_older year if ccode==56, lcolor(gs12)) ///
(lowess prog_gdp9002 year if ccode==56, lcolor(black)) ///
(lowess epl_combined year if ccode==56, yaxis(2)  lcolor(black) lpattern("-")), ///
 legend(order( 1 "Older Male Inactivity (Axis 1)" 2 "In Kind Spending (Axis 1)" 3 "EPL (Axis 2)")) ///
 graphregion(color(white)) name(Belgium2, replace) ytitle("% of Age Group/GDP") ytitle("Average EPL", axis(2)) ///
 title(Belgium, size(small))

  
 grc1leg Australia2 Canada2 USA2 UK2  swe2 Denmark2 Norway2 Germany2 France2 Belgium2 Spain2 Italy2, cols(4) ///
imargin(2 2 2 2) legendfrom(swe2) ycommon xcommon plotregion(color(white)) graphregion(color(white))
