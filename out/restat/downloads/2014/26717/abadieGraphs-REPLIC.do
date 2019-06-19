* Graphs
* ======

foreach num of numlist 99 90 75 {
clear all
clear matrix
set maxvar 32000

 local Dtail = "P`num'"
 local measure "Killed"

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1

  use  synthresults_merged_`measure'_`Dtail'.dta, clear

preserve

	drop *synth*
	keep  YearsFromLD   gdppccteus_*_*PL0*_100
	
	if  "`Dtail'" == "P99" & "`measure'"=="Killed" {
		egen   gdppccteus_AVG_100 = rowmean(gdppccteus_56_PL0_100-gdppccteus_145_PL0_100)
	}	
	if  "`Dtail'" == "P90" & "`measure'"=="Killed" {
	    drop gdppccteus_37_PL0_100  gdppccteus_127_PL0_100 gdppccteus_146_PL0_100  gdppccteus_156_PL0_100
		egen   gdppccteus_AVG_100 = rowmean(gdppccteus_26_PL0_100-gdppccteus_176_PL0_100)
	}
	if  "`Dtail'" == "P75" & "`measure'"=="Killed" {
		drop gdppccteus_34_PL0_100  gdppccteus_54_PL0_100 gdppccteus_68_PL0_100 gdppccteus_116_PL0_100  gdppccteus_121_PL0_100 gdppccteus_141_PL0_100 gdppccteus_173_PL0_100
		egen   gdppccteus_AVG_100 = rowmean(gdppccteus_11_PL0_100-  gdppccteus_159_PL0_100)
	}
	sort  YearsFromLD
	save	 gdppccteus_AVG_`measure'_`Dtail'.dta, replace

restore 
preserve

	keep  YearsFromLD   *PL0synth*_100

	if  "`Dtail'" == "P99" & "`measure'"=="Killed" {
		egen   gdppccteus_AVG_100_Synthetic = rowmean(gdppccteus_56_PL0synth_100-gdppccteus_145_PL0synth_100)
	}
	if  "`Dtail'" == "P90" & "`measure'"=="Killed" {
		drop  gdppccteus_37_PL0synth_100 gdppccteus_127_PL0synth_100  gdppccteus_146_PL0synth_100 gdppccteus_156_PL0synth_100  
		egen   gdppccteus_AVG_100_Synthetic = rowmean(gdppccteus_26_PL0synth_100-gdppccteus_176_PL0synth_100)
	}	
	if  "`Dtail'" == "P75" & "`measure'"=="Killed" {
		drop gdppccteus_34_PL0synth_100 gdppccteus_54_PL0synth_100  gdppccteus_68_PL0synth_100 gdppccteus_116_PL0synth_100 gdppccteus_121_PL0synth_100 gdppccteus_141_PL0synth_100 gdppccteus_173_PL0synth_100
		egen   gdppccteus_AVG_100_Synthetic  = rowmean(gdppccteus_11_PL0synth_100-gdppccteus_159_PL0synth_100)
	}	
	sort  YearsFromLD
	save	 gdppccteus_AVG_synthetic_`measure'_`Dtail'.dta, replace
restore

use gdppccteus_AVG_`measure'_`Dtail'.dta
merge  YearsFromLD using gdppccteus_AVG_synthetic_`measure'_`Dtail'.dta
gen diff_AVG_100 =gdppccteus_AVG_100- gdppccteus_AVG_100_Synthetic
save fullgraph_`measure'_`Dtail'.dta, replace

	#delimit ;

		twoway scatter gdppccteus_AVG_100 gdppccteus_AVG_100_Synthetic YearsFromLD
            if  YearsFromLD>=-15 & YearsFromLD<=`MaxLEAD',
		yaxis(1 2)
		xaxis(1 2)
		ytitle("Real GDP Per Capita (Normalized to 1 in Period 0)")
		ytitle("",  axis(2))
		xtitle("Period")
		xtitle("",  axis(1))
		xtitle("",  axis(2))
		ylabel(0.50(0.10)1.50,         angle(horizontal) nogrid format(%9.2fc))
		ylabel(0.50(0.10)1.50, axis(2) angle(horizontal) nogrid format(%9.2fc))
		xlabel(-16(2)`MaxLEADplus1'  , angle(horizontal)         )
		xlabel(-16(2)`MaxLEADplus1'  , angle(horizontal) axis(2) )
		xline(0)
		msymbol(0 T) mlcolor(gs5 gs5) mfcolor(gs14 gs14)
		connect(l l)
		lpattern(solid dash)
		graphregion(ifcolor(white) icolor(white) ilcolor(white) lcolor(white) color(white) lstyle(none) style(none))
		legend(region(lcolor(none)))
		title("Average Real GDP Per Capita")
		subtitle("Countries Exposed to Severe Natural Disasters (`Dtail')")
		legend( label(1 "Actual") label(2 "Counterfactual") )
		note("Note: Average taken across large disaster countries without missing data")
		saving(AvgRealGDPpc_`measure'_`Dtail', replace);
		graph export AvgRealGDPpc_`measure'_`Dtail'_upLead_`MaxLEAD'.eps, replace;

	#delimit cr


keep  YearsFromLD diff_AVG_100
keep if  YearsFromLD>=1 &  YearsFromLD<=40
matwrite using diffs_ActualAVG_`Dtail', replace
outsheet using diffs_ActualAVG_`Dtail', comma replace

}


