******************************************************************************
*Using the results from the program "Program_ACS-Boostrap", this program 
*generates the graphs in Figure 4
********************************************************************************



clear *
set more off

cd "XXXX define path to folders XXXX/ACS/"

gen Power=.

forvalues power=0(1)30  {

append using "Results/Power/ACS_Bootstrap_State_`power'_500.dta" // Need to add the path for the data-sets obtained using the program "Program_ACS-Boostrap"


}


tab Power

replace Power=Power/100

collapse (mean) rejec* , by(Power above)

la var reject_FP_5 "Reject H_0 at 5%"

		twoway (connected reject_FP_5 Power if above==1 , mcolor(gs4) lcolor(gs4))  ///
			   (connected reject_FP_5 Power if above==0 , mcolor(gs10) lcolor(gs10))  ///
      		 , yscale(range(0 1))  ylabel(0(0.1)1) xscale(range(0 0.3))  xlabel(0(0.02)0.3)   ///
      		 legend(cols(2)) legend(label(1 "Above the median") label(2 "Below the median" )) graphregion(color(white))
      		 
      		 
      		graph export "Figures/ACS.pdf", replace
      		



table Power above, c(mean reject_FP)


