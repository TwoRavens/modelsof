clear all
set mem 1m

* City-Industry Level
cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_ind.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_se*1.96
	gen selo = `1' - `1'_se*1.96
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 95% Confidence Interval"
	label var selo "+ 95% "
	** twoway rarea selo sehi quantile, vertical || connected sehi selo `1' quantile , connect(l l l) lpattern(shortdash shortdash solid) msymbol(none none none) xlabel(10(5)90) ylabel(`4'(`6')`5') title(`2') subtitle(`3') xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

* LALSIZE, single instrument
doplot lalsize_qr "A. The Effect of Initial Firm Size on City-Industry Growth" "Quantile Regression Estimates" -1.5 0.5 0.5
doplot lalsize_ivqr "B. The Effect of Initial Firm Size on City-Industry Growth" "Instrumental Quantile Regression Estimates" -1.5 0.5 0.5



* City Level
clear all
set mem 1m

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_city.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_bsse*1.645
	gen selo = `1' - `1'_bsse*1.645
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 90% Confidence Interval"
	label var selo "+ 90% "
	** twoway rarea selo sehi quantile, vertical || connected sehi selo `1' quantile , connect(l l l) lpattern(shortdash shortdash solid) msymbol(none none none) xlabel(10(5)90) ylabel(`4'(`6')`5') title(`2') subtitle(`3') xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

* LALSIZE, single instrument
doplot clalsize_qr "A. The Effect of Initial Firm Size on City Growth" "Quantile Regression Estimates" -2.5 0.5 0.5
doplot clalsize_ivqr "B. The Effect of Initial Firm Size on City Growth" "Instrumental Quantile Regression Estimates" -2.5 0.5 0.5




* EMP SHARE, single instrument
clear all
set mem 1m

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_emp_city.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_bsse*1.645
	gen selo = `1' - `1'_bsse*1.645
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 90% Confidence Interval"
	label var selo "+ 90% "
	
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log start-up employment share" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

doplot empsha_qr "A. The Effect of Initial Start-up Employment Share on City Growth" "Quantile Regression Estimates" -1 1 1
doplot empsha_ivqr "B. The Effect of Initial Start-up Employment Share on City Growth" "Instrumental Quantile Regression Estimates" -1 1 1


* Alternative instrument
* City Level
clear all
set mem 1m

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_city_alt.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_bsse*1.645
	gen selo = `1' - `1'_bsse*1.645
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 90% Confidence Interval"
	label var selo "+ 90% "
	** twoway rarea selo sehi quantile, vertical || connected sehi selo `1' quantile , connect(l l l) lpattern(shortdash shortdash solid) msymbol(none none none) xlabel(10(5)90) ylabel(`4'(`6')`5') title(`2') subtitle(`3') xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

* LALSIZE, single instrument
doplot clalsize_qr_alt "A. The Effect of Initial Firm Size on City Growth" "Quantile Regression Estimates" -2.5 0.5 0.5
doplot clalsize_ivqr_alt "B. The Effect of Initial Firm Size on City Growth" "Instrumental Quantile Regression Estimates" -2.5 0.5 0.5




* EMP SHARE, single instrument
clear all
set mem 1m

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_emp_city_alt.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_bsse*1.645
	gen selo = `1' - `1'_bsse*1.645
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 90% Confidence Interval"
	label var selo "+ 90% "
	
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log start-up employment share" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

doplot empsha_qr_alt "A. The Effect of Initial Start-up Employment Share on City Growth" "Quantile Regression Estimates" -1 1 1
doplot empsha_ivqr_alt "B. The Effect of Initial Start-up Employment Share on City Growth" "Instrumental Quantile Regression Estimates" -1 1 1

* Both instruments
* City Level
clear all
set mem 1m

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_city_both.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_bsse*1.645
	gen selo = `1' - `1'_bsse*1.645
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 90% Confidence Interval"
	label var selo "+ 90% "
	** twoway rarea selo sehi quantile, vertical || connected sehi selo `1' quantile , connect(l l l) lpattern(shortdash shortdash solid) msymbol(none none none) xlabel(10(5)90) ylabel(`4'(`6')`5') title(`2') subtitle(`3') xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log employment growth" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

* LALSIZE, single instrument
doplot clalsize_qr_both "A. The Effect of Initial Firm Size on City Growth" "Quantile Regression Estimates" -2.5 0.5 0.5
doplot clalsize_ivqr_both "B. The Effect of Initial Firm Size on City Growth" "Instrumental Quantile Regression Estimates" -2.5 0.5 0.5

clear all
set mem 1m

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/plotting
use ivqr_estimates_emp_city_both.dta

drop if quantile <10
drop if quantile > 90

program drop _all
program define doplot
    ** Parameters:
 	** 1 - Plot variable
	** 2 - Graph title
	** 3 - Graph subtitle
	** 4 - Y lo
	** 5 - Y hi
	** 6 - Y interval
	gen sehi = `1' + `1'_bsse*1.645
	gen selo = `1' - `1'_bsse*1.645
	sort quantile
	label var `1' "Point Estimate"
	label var sehi "- 90% Confidence Interval"
	label var selo "+ 90% "
	
	twoway rarea selo sehi quantile, vertical color(ltblue) || connected `1' quantile , connect(l) msymbol(none) xlabel(10(5)90) ylabel(`4'(`6')`5', /* nogrid */) title(`2', size(medsmall)) subtitle(`3', size(medsmall)) xtitle("") ytitle("Log start-up employment share" " ", size(medsmall)) saving(plot-`1'.gph,replace)

	drop sehi selo
	end

label var quantile "Quantile"	

doplot empsha_qr_both "A. The Effect of Initial Start-up Employment Share on City Growth" "Quantile Regression Estimates" -1 1 1
doplot empsha_ivqr_both "B. The Effect of Initial Start-up Employment Share on City Growth" "Instrumental Quantile Regression Estimates" -1 1 1

