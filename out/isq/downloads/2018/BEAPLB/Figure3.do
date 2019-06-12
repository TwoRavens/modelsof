*Authors: Elena McLean and Mitch Radtke
*Project: Figure 3
*Date Last Modified: August 29, 2016


*Importing Data

use "E:\isa_mclean_radtke_replication.dta", clear

*Figure 3 Code

#delimit;
graph twoway line ideal_diff year if sender==2 & target==155 & year>=1964 & year<=1975, clwidth(thin) clcolor(black)
			yline(0, lpattern(dash))
		    xlabel(1965 1970 1975, labsize(3.5))
            legend(off)
            title("", size(4))
            xtitle("Year", size(3.5))
            ytitle("Ideal Point Deviation", size(3.5))
            xsca(titlegap(3))
            ysca(titlegap(3))
            scheme(s2mono) graphregion(fcolor(white));
			
*Labels were manually inserted 
