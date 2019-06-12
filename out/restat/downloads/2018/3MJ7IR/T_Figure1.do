# delimit ;

drop _all;
clear;
set more off;
set matsize 11000;

* Citation: Rangel, M. A. and T. Vogl 
"Agricultural Fires and Health at Birth"
The Review of Economics and Statistics;

******************************************************************************
ABSTRACT

Do file uses fires and milled cane for dscriptives.

OFFICIAL SOURCES OF DATA:
INPE
UNICA

WE PROVIDE DATA IN STATA FORMAT:
rolling_fires_SPstate.dta
calendarmonth_fires_SPstate.dta

******************************************************************************;

global data_repository "../RESTAT_data";
global logs_final "../RESTAT_logs";

************************************************************************
FIGURE 1 - Descriptive Line Graphs for Fires and Milled Cane
************************************************************************;

* PANEL A;

use "$data_repository/rolling_fires_SPstate.dta", clear;

twoway (line sum_nr_fires date, sort), 
ytitle(Counts of fires in SP (rolling fortnight)) xtitle("") xlabel(#12, grid angle(forty_five)) ylabel(#10)
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
;
graph save "$logs_final/T_Figure1_fires_PanelA.gph", replace;
graph save "$logs_final/T_Figure1_fires_PanelA.png", replace;
	
	

* PANEL B;
	
use "$data_repository/calendarmonth_fires_SPstate.dta", clear;	
replace mean_nr_risks=ln(mean_nr_risks);
replace mean_nr_fires=ln(mean_nr_fires);


twoway (connected mean_nr_fires month , msymbol(square) sort)
(connected mean_nr_risks month ,  sort) 
 (connected mean_milled month , sort msymbol(triangle) lpattern(dash) yaxis(2)), 
ytitle("Ln Counts of fires in state") xtitle(Calendar Month) 
ytitle("1,000 Tons processed", axis(2)) 
ylabel(#10, nogrid)
xlabel(#12, grid ) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
 legend(on order(1 "Fires" 2 "INPE-Adjusted fires" 3 "Milled cane") cols(3) size(vsmall) margin(medsmall) region(fcolor(none) lcolor(none)));
graph save  "$logs_final/T_Figure1_fires_PanelB.gph", replace;
graph save  "$logs_final/T_Figure1_fires_PanelB.png", replace;

exit; 



	