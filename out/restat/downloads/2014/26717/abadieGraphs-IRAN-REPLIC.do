* Graphs
* ======
clear all
clear matrix
set maxvar 32000

 local Dtail = "P99"
 local measure "Killed"

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1

  use  synthresults_merged_`measure'_`Dtail'.dta, clear

preserve

	drop *synth*
	keep  YearsFromLD   gdppccteus_*_*PL0*_100
	
	if  "`Dtail'" == "P99" & "`measure'"=="Killed" {
		/* drop coutries in P99 except IRAN (93) */
		drop   gdppccteus_56_PL0_100 gdppccteus_85_PL0_100 gdppccteus_145_PL0_100
		egen   gdppccteus_AVG_100 = rowmean(gdppccteus_93_PL0_100)
	}

	sort  YearsFromLD
	save	 gdppccteus_AVG_`measure'_`Dtail'_IRAN.dta, replace

restore 
preserve

	keep  YearsFromLD   *PL0synth*_100

	if  "`Dtail'" == "P99" & "`measure'"=="Killed" {
		/* drop coutries in P99 except IRAN(93) */
		drop gdppccteus_56_PL0synth_100 gdppccteus_85_PL0synth_100 gdppccteus_145_PL0synth_100
		egen   gdppccteus_AVG_100_Synthetic = rowmean(gdppccteus_93_PL0synth_100)
	}
	
	sort  YearsFromLD
	save	 gdppccteus_AVG_synthetic_`measure'_`Dtail'_IRAN.dta, replace
restore


use gdppccteus_AVG_`measure'_`Dtail'_IRAN.dta
merge  YearsFromLD using gdppccteus_AVG_synthetic_`measure'_`Dtail'_IRAN.dta
gen diff_AVG_100 =gdppccteus_AVG_100- gdppccteus_AVG_100_Synthetic
save fullgraph_`measure'_`Dtail'_IRAN.dta, replace

	#delimit ;

		twoway scatter gdppccteus_AVG_100 gdppccteus_AVG_100_Synthetic YearsFromLD
            if  YearsFromLD>=-11 & YearsFromLD<=`MaxLEAD',
		yaxis(1 2)
		xaxis(1 2)
		/*ytitle("Real GDP Per Capita (Normalized to 1 in Period 0")*/
		ytitle("")
		ytitle("",  axis(2))
		xtitle("")
		xtitle("",  axis(2))
		ylabel(0.50(0.10)1.70,         angle(horizontal) nogrid format(%9.2fc))
		ylabel(0.50(0.10)1.70, axis(2) angle(horizontal) nogrid format(%9.2fc))
		xlabel(-10(2)`MaxLEADplus1'  , angle(horizontal)         )
		xlabel(""                    ,                   axis(2) )
		xline(0)
		msymbol(0 T) mlcolor(gs5 gs5) mfcolor(gs14 gs14)
		connect(l l)
		lpattern(solid dash)
		graphregion(ifcolor(white) icolor(white) ilcolor(white) lcolor(white) color(white) lstyle(none) style(none))
		legend(region(lcolor(none)))
		/*title("Average Real GDP Per Capita") */
		/*subtitle("The 1978 Earthquake in Iran") */		
		title("The 1978 Earthquake in Iran")
		legend( label(1 "Actual") label(2 "Counterfactual") )
		/* note("Note: Average taken across large disaster countries with no missing data and no revolutions")*/
		saving(AvgRealGDPpc_`measure'_`Dtail'_IRAN, replace);
		graph export AvgRealGDPpc_`measure'_`Dtail'_upLead_`MaxLEAD'_IRAN.eps, replace;

	#delimit cr


keep  YearsFromLD diff_AVG_100
keep if  YearsFromLD>=1 &  YearsFromLD<=40
matwrite using diffs_ActualAVG_`Dtail'_IRAN, replace
