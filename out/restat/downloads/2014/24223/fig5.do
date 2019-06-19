*Description: This file generates Figure 5 in the online appendix. 

*Preliminaries: You need to have the following data files in your current directory
*	1. data3d.txt
*	2. data2d.txt

clear all

set more off

log using fig5.log, replace

*** Import data ***
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data3d.txt, tab
drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Generate time and industry dummies ***
tabulate industry, gen(ii)
tabulate year, gen(d)

*** Generate competition squared
gen c1sq = c1^2

*--------------------
*** (a) Benchmark ***
*--------------------
egen gap2_p50 = pctile(gap2),p(50)
gen gap2_ind = 1 if gap2<gap2_p50
replace gap2_ind = 0 if gap2_ind==.
gen c1gap2 = c1*gap2_ind
gen c1sqgap2 = c1sq*gap2_ind

* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_cf, resid

* second stage
nbreg cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* ii*
test c1 c1sq
test c1gap2 c1sqgap2

gen curveall = exp(_b[_cons] + _b[c1]*c1 + _b[c1sq]*c1sq )
gen curvenn = exp(_b[_cons] +  _b[c1]*c1 + _b[c1sq]*c1sq + _b[c1gap2]*c1gap2 + _b[c1sqgap2]*c1sqgap2 )

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

sort c1

# delimit ;
graph twoway (line curveall c1 if curveall<80, ysc(r(0 80)) ylabel(0(20)80)
sort lwidth(thick) color(black) title("(a) Benchmark", size(medsmall)) legend(off) xtitle("Competition", size(medsmall)) ytitle("Estimated CWP", size(medsmall))) 
(line curvenn c1 if c1gap2~=0 & curvenn<80, 
sort lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig5_11, replace

drop curveall curvenn

*----------------------------
*** (c) The Poisson Model ***
*----------------------------

* second stage
poisson cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* ii*
test c1 c1sq
test c1gap2 c1sqgap2
gen curveall = exp(_b[_cons] + _b[c1]*c1 + _b[c1sq]*c1sq )
gen curvenn = exp(_b[_cons] +  _b[c1]*c1 + _b[c1sq]*c1sq + _b[c1gap2]*c1gap2 + _b[c1sqgap2]*c1sqgap2 )

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

sort c1

# delimit ;
graph twoway 
(line curveall c1 if curveall<80, legend(off) lwidth(thick) color(black) 
title("(c) The Poisson Model", size(medsmall))
xtitle("Competition", size(medsmall)) ytitle("Estimated CWP", size(medsmall)) )
(line curvenn c1 if c1gap2~=0 & curvenn<80, legend(off) lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig5_21, replace

drop curveall curvenn
*--------------------------------------------
*** (d) Alternative Definition of Competition ***
*--------------------------------------------
gen c1asq = c1a^2
gen c1agap2 = c1a*gap2_ind
gen c1asqgap2 = c1asq*gap2_ind

* first stage
reg c1a instf_1 d* ii*
test instf_1
predict c1a_cf, resid

* second stage
nbreg cwp c1a c1asq c1a_cf c1agap2 c1asqgap2 d* ii*
test c1a c1asq
test c1agap2 c1asqgap2
gen curveall = exp(_b[_cons] + _b[c1a]*c1a + _b[c1asq]*c1asq )
gen curvenn = exp(_b[_cons] +  _b[c1a]*c1a + _b[c1asq]*c1asq + _b[c1agap2]*c1agap2 + _b[c1asqgap2]*c1asqgap2 )

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

sort c1a

# delimit ;
graph twoway 
(line curveall c1a, legend(off) lwidth(thick) color(black) 
title("(d) Alternative Definition of Competition", size(medsmall))
xtitle("Competition", size(medsmall)) ytitle("Estimated CWP", size(medsmall)) )
(line curvenn c1a if c1gap2~=0, legend(off) lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig5_22, replace

drop curveall curvenn

*---------------------------------------
*** (e) R&D as the Measure of Innovation ***
*---------------------------------------

*** First-stage regression ***
regress c1 instf_1 d* ii*
test instf_1
predict c1hat
gen c1hatsq = c1hat^2

*** Second-stage regression ***
gen c1hatgap2 = c1hat*gap2_ind
gen c1hatsqgap2 = c1hatsq*gap2_ind
regress rnd c1hat c1hatsq c1hatgap2 c1hatsqgap2 d* ii*
test c1hat c1hatsq
test c1hatgap2 c1hatsqgap2 

gen curveall = _b[_cons] + _b[c1hat]*c1hat + _b[c1hatsq]*c1hatsq
gen curvenn = _b[_cons] +  _b[c1hat]*c1hat + _b[c1hatsq]*c1hatsq + _b[c1hatgap2]*c1hatgap2 + _b[c1hatsqgap2]*c1hatsqgap2

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

sort c1hat

# delimit ;
graph twoway 
(line curveall c1hat, legend(off) lwidth(thick) color(black) 
title("(e) R&D as the measure of innovation", size(medsmall))
xtitle("Competition", size(medsmall)) ytitle("Estimated R&D", size(medsmall)) )
(line curvenn c1hat if c1gap2~=0, legend(off) lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig5_31, replace

drop curveall curvenn

drop c1gap2 c1sqgap2

*-------------------------------------------
*** (b) Base-year Definition of Tech Gap ***
*-------------------------------------------

* generate a variable `nval' that is 1 if the industry appears for the first time in the data
by industry (year), sort: gen nvals = _n == 1

* Generate a variable `med_gap' that contains median gap by year
by year, sort: egen med_gap = median(gap2)

* Generate a variable `low_gap' that takes the value 1 if gap is below year median
gen low_gap=1 if gap2<med_gap
replace low_gap=0 if low_gap~=1

mkmat industry if low_gap==1 & nvals==1
mat rename industry A

gen split2=0

forvalues rowno = 1(1)59 {
scalar indcode = A[`rowno',1]
replace split2=1 if industry== indcode
display `rowno'
}

gen c1gap2 = c1*(split2==1)
gen c1sqgap2 = c1sq*(split2==1)

* stage 2
nbreg cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* ii*, vce(cluster industry)
test c1 c1sq
test c1gap2 c1sqgap2

gen curveall = exp(_b[_cons] + _b[c1]*c1 + _b[c1sq]*c1sq )
gen curvenn = exp(_b[_cons] +  _b[c1]*c1 + _b[c1sq]*c1sq + _b[c1gap2]*c1gap2 + _b[c1sqgap2]*c1sqgap2 )

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

sort c1

# delimit ;
graph twoway (line curveall c1 if curveall<80, ysc(r(0 80)) ylabel(0(20)80)
sort lwidth(thick) color(black) title("(b) Base-year Definition of Tech Gap", size(medsmall)) legend(off) xtitle("Competition", size(medsmall)) ytitle("Estimated CWP", size(medsmall))) 
(line curvenn c1 if c1gap2~=0 & curvenn<80, 
sort lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig5_12, replace

drop curveall curvenn

*---------------------
*** (f) Two-Digit Data ***
*---------------------
clear
set more off
*** Import data ***
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data2d.txt, tab
drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Generate time and industry dummies ***
tabulate industry, gen(ii)
tabulate year, gen(d)

*** Generate competition squared
gen c1sq = c1^2

egen gap2_p50 = pctile(gap2),p(50)
gen gap2_ind = 1 if gap2<gap2_p50
replace gap2_ind = 0 if gap2_ind==.
gen c1gap2 = c1*gap2_ind
gen c1sqgap2 = c1sq*gap2_ind

* first stage
reg c1 instf_1 d* ii*
test instf_1 
predict c1_cf, resid

* second stage
nbreg cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* ii*
test c1 c1sq
test c1gap2 c1sqgap2
gen curveall = exp(_b[_cons] + _b[c1]*c1 + _b[c1sq]*c1sq )/100
gen curvenn = exp(_b[_cons] +  _b[c1]*c1 + _b[c1sq]*c1sq + _b[c1gap2]*c1gap2 + _b[c1sqgap2]*c1sqgap2 )/100

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

sort c1

# delimit ;
graph twoway 
(line curveall c1, legend(off) lwidth(thick) color(black) 
title("(f) Two-digit Data", size(medsmall))
xtitle("Competition", size(medsmall)) ytitle("Estimated CWP", size(medsmall)) )
(line curvenn c1 if c1gap2~=0, legend(off) lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig5_32, replace

drop curveall curvenn

*---------------------------------------------------------------------------
graph combine fig5_11.gph fig5_12.gph fig5_21.gph fig5_22.gph fig5_31.gph fig5_32.gph, note("Note: CWP refers to citation-weighted patent count.") cols(2) ysize(8) xsize(6)
graph save fig5, replace
graph export fig5.ps, replace logo(off)

log close


