

//----------------------------------------
// FIGURE 1
//----------------------------------------

clear
use directflight_panel.dta
by state city, sort: egen flightyear = sum(new_directflight)
by state city, sort: gen tt = 1 if _n == 1
hist flightyear if tt == 1, discrete xlabel(1(1)14) freq ///
xtitle("Number of Year Having a Direct Flight to DC") ytitle("Number of Cities") ///
col(gs12) lcolor(black) graphregion(color(white)) 

