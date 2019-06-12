*Authors: Elena McLean and Mitch Radtke
*Project: Figure 4
*Date Last Modified: August 29, 2016


*Importing Data

use "E:\isa_mclean_radtke_replication.dta", clear

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.

*Figure 3 Code

#delimit;
graph twoway line pf year if sender==2 & target==155 & year>=1964 & year<=1975, clwidth(thin) clcolor(black)
			yline(.145, lpattern(dash))
		    xlabel(1965 1970 1975, labsize(3.5))
            legend(off)
            title("", size(4))
            xtitle("Year", size(3.5))
            ytitle("Probability of Failure", size(3.5))
            xsca(titlegap(3))
            ysca(titlegap(3))
            scheme(s2mono) graphregion(fcolor(white));
			
*Labels were manually inserted 
