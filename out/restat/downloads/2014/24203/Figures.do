

* This file is used to generate figures 1-3, and the figures in Appendics C-D

clear all
set more off
set memo 500m
set matsize 800
capture log close


cd ~/Crime

log using figure.log, text replace 

********************************************************************************************

* Figure 1

********************************************************************************************

use figures_1_3.dta, clear 


	twoway (scatter arrests year, c(l) ytitle("Arrests/10,000 Population") /*
           */legend(label(1 "Arrests/10,000 Population")) xlabel(1985(5)2005, grid) yline(0.01 0.03) title())
       
	graph export figure1.eps, replace    


********************************************************************************************

* Figure 2

********************************************************************************************

	twoway (scatter sexratio year, c(l) ytitle("Male/Female 16-25") /*
           */legend(label(1 "Male/Female 16-25")) xlabel(1985(5)2005, grid) yline(0.01 0.03) title())
        
	graph export figure2.eps, replace   

********************************************************************************************

* Figure 3

******************************************************************************************** 

use figures_1_3.dta, clear 

twoway (scatter  propertyrate year, c(l) yaxis(1) ) /*
       */ scatter violencerate year, c(l) msymbol(triangle) yaxis(2)  ytitle("Property crime rates",axis(2)) /*
       */ ytitle("Violent crime rates", axis(1)) xtitle("Year") legend(label(1 "Property crime rates")  label(2 "Violent crime rates")) /*
       */ xlabel(1985(5)2005, grid) title()
                         
	   graph export figure3.eps, replace 
	   
clear

********************************************************************************************

* Appendix C

********************************************************************************************

use Sexratio_crime.dta, clear 

tsset id year

global prov "11 12 13 14 15 21 22 23 31 32 33 34 35 36 37 41 42 43 44 45 46 51 52 53 54 61 62 63 64 65"


foreach p in $prov {

        twoway (scatter  mf90x1625  provmf1625 bprovmf1625  mfw1625 year if id==`p', c(l l  l l) yaxis(1) lwidth(vthin vthin vthin thick) ) /*
            */ scatter lcrime year if id==`p', c(l) yaxis(2) lwidth(thick)  ytitle("ln(Crime/10,000 population)",axis(2)) /*
            */ ytitle("Males/Females 16-25",axis(1)) xtitle("Year") legend(label(1 "1990, resident")  label(2 "2000, resident") /*
            */ label(3 "2000, birth")  label(4 "2000, weighted") label(5 "Crime (logged, right scale)")) /*
            */ xlabel(1985(5)2005, grid) title()
                         
			graph export Ratio`p'.eps, replace   
}


********************************************************************************************

* Appendix D

********************************************************************************************

ge diff=mf90x1625- bprovmf1625

foreach p in $prov{

       twoway (scatter diff year if id==`p', c(l) ytitle("1990 resident minus 2000 birth sex ratio, 16-25 year olds") /*
              */legend(label(1 "16-25 cohort sex ratio, 1990 vs. 2000 census")) xlabel(1990(5)2000, grid) yline(0.01 0.03) title())
       
	   graph export Diff`p'.eps, replace   

}

********************************************************************************************

log close

clear
