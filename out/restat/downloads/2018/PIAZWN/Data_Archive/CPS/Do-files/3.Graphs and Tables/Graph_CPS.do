******************************************************************************
**Using the results produced by the program "Program-CPS-aggregate-power.do", 
**this code generates graphs 4B-4E in figure 4.
*******************************************************************************

 
clear *
set more off

cd "XXXX define path to folders XXXX/CPS/"

foreach x in 1 3 5 7 {
forvalues power=0(1)30 {

cap append using "Results/Power/CPS_Bootstrap_l_wage_`x'_`power'_500.dta"

}
}


tab Power

collapse (mean) rejec* , by(Power Range above)

replace Power=Power/100

la var reject_FP_5 "Reject H_0 at 5%"

foreach Range in 1 3 5 7 {

		twoway (connected reject_FP_5 Power if above==1 & Range==`Range', mcolor(gs4) lcolor(gs4))   ///
			   (connected reject_FP_5 Power if above==0 & Range==`Range', mcolor(gs10) lcolor(gs10))   ///
      		 , yscale(range(0 1))  ylabel(0(0.1)1) xscale(range(0 0.3))  xlabel(0(0.02)0.3) graphregion(color(white))  ///
      		 legend(cols(2)) legend(label(1 "Above the median") label(2 "Below the median" ))
      		 
      		 
      		 
      		 graph export "Figures/CPS_`Range'.pdf", replace



}

