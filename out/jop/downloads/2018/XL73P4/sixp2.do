cd "C:\Users\nmccarty\Documents\Dropbox\TheData\DW-NOMINATE\"
use "C:\Users\nmccarty\Documents\Dropbox\TheData\DW-NOMINATE\senate_nom_101917.dta", clear

keep if congress > 50


collapse (mean) dim1 (median) mdim=dim1 (count) num=dim1, by(congress party)

keep if party == 100 | party == 200

reshape wide dim1 mdim num, i(congress) j(party)

gen polar=dim1200-dim1100
gen majsize = num100/(num100+num200) if num100 >= num200
replace majsize = num200/(num100+num200) if num200 > num100

gen majdem = 1 if num100 >= num200
replace majdem = 0 if num200 > num100


twoway line polar congress, scheme(s1mono)

save "C:\Users\nmccarty\Documents\Dropbox\TheData\DW-NOMINATE\sixps.dta", replace


use "C:\Users\nmccarty\Documents\Dropbox\TheData\DW-NOMINATE\senate_nom_101917.dta", clear

keep if congress > 50


collapse (median) median=dim1 (p33) vleft = dim1 (p40) left=dim1 (p60) right=dim1 (p67) vright=dim1, by(congress)

gen fgrid = right - left
gen vgrid = vright - vleft


sort congress

merge congress using sixps

twoway line polar fgrid congress, scheme(s1mono)

gen year = 2*congress + 1787

gen     dem = 0
replace dem = 1 if year < 1949
replace dem = 1 if year > 1960 & year < 1969
replace dem = 1 if year > 1976 & year < 1981
replace dem = 1 if year > 1992 & year < 2001
replace dem = 1 if year > 2008 & year < 2017

gen left_piv = dem*vleft + (1-dem)*left
gen right_piv = (1-dem)*vright + dem*right

gen grid = right_piv - left_piv

label var polar "Polarization"
label var grid "Width of Gridlock Interval"
label var year "Year"
label var dem "Democratic President"
label var majsize "Majority Size"

twoway line polar grid year, scheme(s1mono) clw(thick thick) yti("Distance") xlab(1889(16)2017)



eststo: regress grid polar
eststo: regress grid polar dem majsize




# delimit ;
esttab using "C:\Users\nmccarty\Documents\Dropbox\krehbiel\tab1.tex", replace se nostar stats(N r2, labels(N R-Squared)) 
keep(polar dem majsize) 
title("Polarization and Gridlock Interval"\label{tab1}) mtitles("Model 1" "Model 2") 
label nodepvars
eqlabels("") addnote( "OLS Estimates of correlation of polarization and gridlock" "interval controlling for presidential partisanship and majority size.") 
nonumbers;
# delimit cr

est clear





tsset congress




gen majmedian= majdem*mdim100 + (1-majdem)*mdim200

twoway line median majmedian year, scheme(s1mono) clw(thick thick) yti("Distance") xlab(1889(16)2017)


gen abmedian = abs(d.median)
gen abmajsize = abs(d.majsize)
gen polabmaj = polar*abmajsize

label var abmedian "Absolute Shift in Median Ideal Point"
label var abmajsize "$|\Delta \text{ Majority Size}|$"

eststo: regress abmedian polar 
eststo: regress abmedian polar abmajsize 

# delimit ;
esttab using "C:\Users\nmccarty\Documents\Dropbox\krehbiel\tab3.tex", replace se nostar stats(N r2, labels(N R-Squared)) 
title("Polarization and Median Shift"\label{tab3}) mtitles("Model 1" "Model 2") 
label nodepvars
eqlabels("") addnote( "Estimates of correlation of polarization and median shift" "controlling for absolute change in majority size.") 
nonumbers;
# delimit cr

est clear


twoway line polar abmedian year, scheme(s1mono) clw(thick thick) yti("Distance") xlab(1889(16)2017)



gen dpolar = d.polar
gen dmajsize = d.majsize
gen ddem = d.dem

label var dpolar "$\Delta$ Polarization"
label var dmajsize "$\Delta$ Majority Size"
label var ddem "$\Delta$ Dem President"
 

eststo: regress d.grid dpolar 
eststo: regress d.grid dpolar dmajsize ddem




# delimit ;
esttab using "C:\Users\nmccarty\Documents\Dropbox\krehbiel\tab2.tex", replace se nostar stats(N r2, labels(N R-Squared)) 
title("Polarization and Gridlock Interval" "First-Differences"\label{tab2}) mtitles("Model 1" "Model 2") 
label nodepvars
eqlabels("") addnote( "First Difference estimates of correlation of polarization and gridlock" "interval controlling for presidential partisanship and majority size.") 
nonumbers;
# delimit cr

est clear

