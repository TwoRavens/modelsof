#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 250
set logtype text
log using ../log/create-permutation-figure.log , replace

/* --------------------------------------

Prepare data for permutation tests.

--------------------------------------- */

clear all
estimates clear
set matsize 10000
graph set window fontface "Garamond"


use ../dta/randomization_inference_results.dta, replace

forvalues i = 1/6 {
 preserve
 global result = results`i'[1]
 drop if _n == 1
 count
 local N = r(N)
 if ($result < 0) {
  count if $result > results`i'
  local c = r(N)
  local p = 2*`c'/`N'
 }
 else {
  count if $result < results`i'
  local c = r(N)
  local p = 2*`c'/`N'
 } 
 di "(two-sided) p-val (`i') = `p'"
 restore
}

*tiny, vsmall, small, medsmall, medium

local i = 1
 preserve
 global result = results`i'[1]
 drop if _n == 1
 keep results`i' 
 gen resultx = $result if _n == 1
 gen resulty = 0.3 if _n == 1

 local y2 = 0.3 * 1.02
 local x2 = $result * 0.98
 local y1 = `y2' * 1.22
 local x1 = `x2' * 0.96

 tw ///
  (kdensity results`i', lcolor(blue) ) (bar resulty resultx, color(gray) barwidth(0.09) ) ///
  (pcarrowi `y1' `x1' `y2' `x2' (9) "Empirical estimate [p < 0.001]", msize(vsmall) mcolor(gray) mlabsize(medium) ), /// 
  legend(off) xtitle("Chapter 7 effect (levels)") ytitle("density") ///
  xscale(r(-5.1 7.1)) xlabel(-5(1)7) ///
  scheme(s2mono) ylabel(, nogrid angle(horizontal) ) yscale(nofextend) xscale(nofextend) graphregion(fcolor(white))

 graph save ../gph/permutation`i'.gph, replace
 restore

local i = 2
 preserve
 global result = results`i'[1]
 drop if _n == 1
 keep results`i' 
 gen resultx = $result if _n == 1
 gen resulty = 40 if _n == 1

 local y2 = 40 * 1.02
 local x2 = $result * 0.98
 local y1 = `y2' * 1.18
 local x1 = `x2' * 0.93

 tw ///
  (kdensity results`i', lcolor(blue) ) (bar resulty resultx, barwidth(0.0006) color(gray) ) ///
  (pcarrowi `y1' `x1' `y2' `x2' (9) "Empirical estimate [p < 0.001]", msize(vsmall) mcolor(gray) mlabsize(medium) ), /// 
  legend(off) xtitle("Chapter 7 effect (logs)") ytitle("density") ///
  xscale(r(-0.0425 0.0425)) xlabel(-0.04(.01)0.04) ///
  scheme(s2mono) ylabel(, nogrid angle(horizontal) ) yscale(nofextend) xscale(nofextend) graphregion(fcolor(white))

 graph save ../gph/permutation`i'.gph, replace
 restore

local i = 3
 preserve
 global result = results`i'[1]
 drop if _n == 1
 keep results`i' 
 gen resultx = $result if _n == 1
 gen resulty = 0.4 if _n == 1

 local y2 = 0.4 * 1.03
 local x2 = $result * 0.95
 local y1 = `y2' * 1.11
 local x1 = `x2' * 0.2

 tw ///
  (kdensity results`i', lcolor(blue) ) (bar resulty resultx, color(gray) barwidth(0.09) ) ///
  (pcarrowi `y1' `x1' `y2' `x2' (3) "Empirical estimate [p = 0.219]", msize(vsmall) mcolor(gray) mlabsize(medium) ), /// 
  legend(off) xtitle("Chapter 13 effect (levels)") ytitle("density") ///
  xscale(r(-5.1 7.1)) xlabel(-5(1)7) ylabel(0(0.2)0.8) ///
  scheme(s2mono) ylabel(, nogrid angle(horizontal) ) yscale(nofextend) xscale(nofextend) graphregion(fcolor(white))

 graph save ../gph/permutation`i'.gph, replace
 restore

local i = 4
 preserve
 global result = results`i'[1]
 drop if _n == 1
 keep results`i' 
 gen resultx = $result if _n == 1
 gen resulty = 25 if _n == 1

 local y2 = 25 * 1.03
 local x2 = $result * 0.98
 local y1 = `y2' * 1.11
 local x1 = `x2' * 0.8

 tw ///
  (kdensity results`i', lcolor(blue) ) (bar resulty resultx, color(gray) barwidth(0.0006) ) ///
  (pcarrowi `y1' `x1' `y2' `x2' (3) "Empirical estimate [p = 0.185]", msize(vsmall) mcolor(gray) mlabsize(medium) ), /// 
  legend(off) xtitle("Chapter 13 effect (logs)") ytitle("density") ///
  xscale(r(-0.0425 0.0425)) xlabel(-0.04(.01)0.04) ///
  scheme(s2mono) ylabel(, nogrid angle(horizontal) ) yscale(nofextend) xscale(nofextend) graphregion(fcolor(white))

 graph save ../gph/permutation`i'.gph, replace
 restore

local i = 5
 preserve
 global result = results`i'[1]
 drop if _n == 1
 keep results`i' 
 gen resultx = $result if _n == 1
 gen resulty = 0.25 if _n == 1

 local y2 = 0.25 * 1.02
 local x2 = $result * 0.98
 local y1 = `y2' * 1.13
 local x1 = `x2' * 0.95

 tw ///
  (kdensity results`i', lcolor(blue) ) (bar resulty resultx, color(gray) barwidth(0.09) ) ///
  (pcarrowi `y1' `x1' `y2' `x2' (9) "Empirical estimate [p < 0.001]", msize(vsmall) mcolor(gray) mlabsize(medium) ), /// 
  legend(off) xtitle("Chapter 7+13 effect (levels)") ytitle("density") ///
  xscale(r(-5.1 7.1)) xlabel(-5(1)7) ylabel(0(0.1)0.4) ///
  scheme(s2mono) ylabel(, nogrid angle(horizontal) ) yscale(nofextend) xscale(nofextend) graphregion(fcolor(white))

 graph save ../gph/permutation`i'.gph, replace
 restore

local i = 6
 preserve
 global result = results`i'[1]
 drop if _n == 1
 keep results`i' 
 gen resultx = $result if _n == 1
 gen resulty = 50 if _n == 1

 local y2 = 50 * 1.02
 local x2 = $result * 0.98
 local y1 = `y2' * 1.1
 local x1 = `x2' * 0.9

 tw ///
  (kdensity results`i', lcolor(blue) ) (bar resulty resultx, color(gray) barwidth(0.0006) ) ///
  (pcarrowi `y1' `x1' `y2' `x2' (9) "Empirical estimate [p < 0.001]", msize(vsmall) mcolor(gray) mlabsize(medium) ), ///
  legend(off) xtitle("Chapter 7+13 effect (logs)") ytitle("density") ///
  xscale(r(-0.0425 0.0425)) xlabel(-0.04(.01)0.04) ///
  scheme(s2mono) ylabel(, nogrid angle(horizontal) ) yscale(nofextend) xscale(nofextend) graphregion(fcolor(white))

 graph save ../gph/permutation`i'.gph, replace
 restore



graph combine ///
 ../gph/permutation1.gph ../gph/permutation2.gph ../gph/permutation3.gph ///
 ../gph/permutation4.gph ../gph/permutation5.gph ../gph/permutation6.gph, ///
 title("Figure 14: Randomization inference, 2001 rebates", size(small) ) col(2) ///
 iscale(0.42) ysize(7.0) xsize(6) ///
 scheme(s2mono) graphregion(fcolor(white)) 
graph export ../gph/fig14.$gph_extension, replace

log close
exit







