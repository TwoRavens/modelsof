* PROGRAM :			FouirnaiesMutluErenEnglishBacon.do
* AUTHOR :			Alexander Fouirnaies + Hande Mutlu-Eren
* INFILE(S) :		
* OUTFILE(S) :		
* DATE WRITTEN :	31 Jan 2015
*************************************************************************

clear
program drop _all


gl BaconPath "~/Dropbox/research/Grants/partisanship_and_grants_uk/ReplicationFiles"
*************************************************************************
set matsize 2000

*NOTE: The dataset is created in the council_majority do-file.


********************************
**Figure 1: Aligned and non-aligned local councils
********************************
clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
drop if year >=2012 
gen x=1 
gen y = 400
sort year
by year: egen totalcouncils = total(x)
by year: egen numberofcouncilelections= total(electionyear)
by year: egen numberoftreated = total(treat) 

gen s_numberofcouncilelections = string(numberofcouncilelections, "%4.0f")

contract year s_numberofcouncilelections numberoftreated numberofcouncilelections totalcouncils y

graph      twoway                                                                  ///
(bar numberoftreated year    , color(ltblue))  ///
|| rbar numberoftreated  totalcouncils year  , ///
|| connected numberofcouncilelections year, ms(s) mla(s_numberofcouncilelections) mlabpos(12) mcolor(black) mlabcolor(black) lcolor(black) ///
legend(label(1 "Aligned") label(2 "Non-Aligned" ) label(3 "Number of council elections") region(lwidth(none)) rows(1) ) ///
graphregion(color(white)) ytitle("Number of Councils") xtitle("Year") ///
xlab(1992 (2) 2012)  
graph export "$BaconPath/FinalFiguresTables/elections_overview.pdf" , replace


***************
**Analysis
***************


********************************
**Figure 3: pre and post treat diff-in-diffs
********************************

estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren, clear
keep if treat_Tplus1!=. & treat_Tplus2!=. & treat_Tplus3!=.    & ///
treat_Tminus0!=. & treat_Tminus1!=. & treat_Tminus2!=. & treat_Tminus3!=. & treat_Tminus4!=. & treat_Tminus5!=. & treat_Tminus6!=. 
tempfile data
save `data'

cd "$BaconPath/FinalFiguresTables/"

foreach outcome in logSgwaPercap {
matrix B = J(15, 8, .)
local pre_periods = 3
local post_periods = 6

qui forval j =1/`pre_periods' {
	local x = 1+`pre_periods' - `j' 
	use `data', clear
	xi: areg `outcome' treat_Tplus`x' i.year i.councilnumber council_trend*  , absorb(councilnumber) cluster(council_cycle)
	local se1 = _se[treat_Tplus`x']
	xi: areg `outcome' treat_Tplus`x' i.year i.councilnumber council_trend*  , absorb(councilnumber) r
	local se2 = _se[treat_Tplus`x']
	xi: areg `outcome'  treat_Tplus`x' i.year i.councilnumber council_trend*  ,  absorb(councilnumber) 
	local se3 = _se[treat_Tplus`x']
	local se = max(`se1', `se2', `se3')
	*xi: areg `outcome' treat_Tplus`x' i.year council_trend*  , absorb(councilnumber) vce(bootstrap (_b[treat_Tplus`x']),rep(200) seed(123) cluster(council_cycle)) 
	matrix B[`j', 1] = _b[treat_Tplus`x']
	matrix B[`j', 2] = _b[treat_Tplus`x'] - 1.96*`se'
	matrix B[`j', 3] = _b[treat_Tplus`x'] + 1.96*`se'
	matrix B[`j', 4] = -`x'
}

qui forvalues j = 0/`post_periods' {
	use `data', clear
	xi: areg `outcome'  treat_Tminus`j' i.year i.councilnumber council_trend*  ,  absorb(councilnumber)  cluster(council_cycle)
	local se1 = _se[treat_Tminus`j']
	xi: areg `outcome'  treat_Tminus`j' i.year i.councilnumber council_trend*  ,  absorb(councilnumber)  r
	local se2 = _se[treat_Tminus`j']
	xi: areg `outcome'  treat_Tminus`j' i.year i.councilnumber council_trend*  ,  absorb(councilnumber)
	local se3 = _se[treat_Tminus`j']
	local se = max(`se1', `se2', `se3')
	*xi: areg `outcome' treat_Tplus`x' i.year council_trend*  , absorb(councilnumber) vce(bootstrap (_b[treat_Tplus`x']),rep(200) seed(123) cluster(council_cycle)) 
	matrix B[`j'+1+`pre_periods', 1] = _b[treat_Tminus`j']
	matrix B[`j'+1+`pre_periods', 2] = _b[treat_Tminus`j'] - 1.96*`se'
	matrix B[`j'+1+`pre_periods', 3] = _b[treat_Tminus`j'] + 1.96*`se'
	matrix B[`j'+1+`pre_periods', 4] = `j'
}

svmat B
keep if B1 != .
keep B*
rename B1 est_did
rename B2 lower_did
rename B3 upper_did
rename B4 x


 twoway (scatter est_did x, mcolor(blue) msymbol(S)   ) (rcap upper_did lower_did x,lcolor(blue))  , graphregion(color(white)) ///
yline(0,  lcolor(black)) xtitle("Years Relative to Partisan Alignment") xlab(-3(1)6) ylab(-0.05(0.05)0.15) ///
ytitle("Effect of Partisan Alignment on (log) Specific Grants") subtitle(, bcolor(white)) legend(  label(1 "Diff-in-Diff") label(2 "95%") ///
 ring(0) position(2)) xline(0.5 ,lcolor(black) lpattern(dash))
 graph export DiffGraphs_`outcome'_linear.pdf , replace
}




***************
***************
** Table 1
***************
***************

********************************
**Panel A: Diff-in-Diff no council linear trends
********************************
clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
keep if treat_Tminus1!=. | treat_Tminus2!=.| treat_Tminus3!=.|treat_Tminus4!=.|treat_Tminus5!=.
local outcome logSgwaPercap

qui forval i =1/5 {
	xi: areg `outcome' treat_Tminus`i' i.year   , absorb(councilnumber) cluster(council_cycle)
	local se_clust = _se[treat_Tminus`i']	
	xi: areg `outcome' treat_Tminus`i' i.year   , absorb(councilnumber) r
	local se_r = _se[treat_Tminus`i']
	xi: areg `outcome' treat_Tminus`i' i.year    , absorb(councilnumber)
	local se_normal = _se[treat_Tminus`i']
	local se`i' = max(`se_clust', `se_r', `se_normal')
	local b`i' = _b[treat_Tminus`i']
	local n`i' = e(N)
}
cd "$BaconPath/FinalFiguresTables/"

quietly {
	capture log close
	log using "diff_in_diff_notrend.tex", text replace
	noisily display " Co-partisan & " %4.3f `b1' " & " %4.3f `b2' " & " %4.3f `b3' " & " %4.3f `b4' " & " %4.3f `b5' " \\ "
	noisily display " & (" %4.3f `se1' ") & (" %4.3f `se2' ") & (" %4.3f `se3' ") & (" %4.3f `se4' ") & (" %4.3f `se5' ")  \\  " 
	noisily display " \midrule "
	noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
	log off
} 	

********************************
**Panel B: Diff-in-Diff with linear trend
********************************
clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
keep if treat_Tminus1!=. | treat_Tminus2!=.| treat_Tminus3!=.|treat_Tminus4!=.|treat_Tminus5!=.
foreach outcome in logSgwaPercap {
	qui forval i =1/5 {
		xi: areg `outcome' treat_Tminus`i' i.year council_trend*   , absorb(councilnumber) cluster(council_cycle)
		local se_clust = _se[treat_Tminus`i']	
		xi: areg `outcome' treat_Tminus`i' i.year council_trend*   , absorb(councilnumber) r
		local se_r = _se[treat_Tminus`i']
		xi: areg `outcome' treat_Tminus`i' i.year council_trend*  , absorb(councilnumber)
		local se_normal = _se[treat_Tminus`i']
		local se`i' = max(`se_clust', `se_r', `se_normal')
		local b`i' = _b[treat_Tminus`i']
		local n`i' = e(N)
	}
cd "$BaconPath/FinalFiguresTables/"

	quietly {
		capture log close
		log using "diff_in_diff_linear.tex", text replace
		noisily display " Co-partisan & " %4.3f `b1' " & " %4.3f `b2' " & " %4.3f `b3' " & " %4.3f `b4' " & " %4.3f `b5' " \\ "
		noisily display " & (" %4.3f `se1' ") & (" %4.3f `se2' ") & (" %4.3f `se3' ") & (" %4.3f `se4' ") & (" %4.3f `se5' ")  \\  " 
		noisily display " \midrule "
		noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
		log off
	} 		
}


********************************
**Panel C: Triple Diff-in-Diff no council trend
********************************
clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
keep if treat_Tminus1!=. | treat_Tminus2!=.| treat_Tminus3!=.|treat_Tminus4!=.|treat_Tminus5!=.

local outcome logDifferencePercap
qui forval i =1/5 {
	xi: areg `outcome' treat_Tminus`i' i.year  , absorb(councilnumber) cluster(council_cycle)
	local se_clust = _se[treat_Tminus`i']	
	xi: areg `outcome' treat_Tminus`i' i.year , absorb(councilnumber) r
	local se_r = _se[treat_Tminus`i']
	xi: areg `outcome' treat_Tminus`i' i.year  , absorb(councilnumber)
	local se_normal = _se[treat_Tminus`i']
	local se`i' = max(`se_clust', `se_r', `se_normal')
	local b`i' = _b[treat_Tminus`i']
	local n`i' = e(N)
}
cd "$BaconPath/FinalFiguresTables/"

quietly {
	capture log close
	log using "triple_diff_notrend.tex", text replace
	noisily display " Co-partisan & " %4.3f `b1' " & " %4.3f `b2' " & " %4.3f `b3' " & " %4.3f `b4' " & " %4.3f `b5' " \\ "
	noisily display " & (" %4.3f `se1' ") & (" %4.3f `se2' ") & (" %4.3f `se3' ") & (" %4.3f `se4' ") & (" %4.3f `se5' ")  \\  " 
	noisily display " \midrule "
	noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
	log off
} 	


********************************
**Panel D: Triple Diff-in-Diff with linear trends
********************************
clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
keep if treat_Tminus1!=. | treat_Tminus2!=.| treat_Tminus3!=.|treat_Tminus4!=.|treat_Tminus5!=.

local outcome logDifferencePercap
qui forval i =1/5 {
	xi: areg `outcome' treat_Tminus`i' i.year council_trend*  , absorb(councilnumber) cluster(council_cycle)
	local se_clust = _se[treat_Tminus`i']	
	xi: areg `outcome' treat_Tminus`i' i.year council_trend*  , absorb(councilnumber) r
	local se_r = _se[treat_Tminus`i']
	xi: areg `outcome' treat_Tminus`i' i.year council_trend*  , absorb(councilnumber)
	local se_normal = _se[treat_Tminus`i']
	local se`i' = max(`se_clust', `se_r', `se_normal')
	local b`i' = _b[treat_Tminus`i']
	local n`i' = e(N)
}
cd "$BaconPath/FinalFiguresTables/"

quietly {
	capture log close
	log using "triple_diff_linear.tex", text replace
	noisily display " Co-partisan & " %4.3f `b1' " & " %4.3f `b2' " & " %4.3f `b3' " & " %4.3f `b4' " & " %4.3f `b5' " \\ "
	noisily display " & (" %4.3f `se1' ") & (" %4.3f `se2' ") & (" %4.3f `se3' ") & (" %4.3f `se4' ") & (" %4.3f `se5' ")  \\  " 
	noisily display " \midrule "
	noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
	log off
} 		


***************
***************
** Table 2: Electoral Cycle
***************
***************

********************************
**Panel A: Election Year
********************************

clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
keep if whole==1
local outcome logSgwaPercap

qui forval i =1/5 {
	gen x = electionyear*treat_Tminus`i'
	gen y = treat_Tminus`i'
	gen z = electionyear
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) cluster(council_cycle)
	local sex1 = _se[x]	
	local sey1 = _se[y]
	local sez1 = _se[z]
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) r
	local sex2 = _se[x]	
	local sey2 = _se[y]
	local sez2 = _se[z]	
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) 
	local sex3 = _se[x]	
	local sey3 = _se[y]
	local sez3 = _se[z]	
	local sex`i' = max(`sex1',`sex2',`sex3')
	local sey`i' = max(`sey1',`sey2',`sey3')
	local sez`i' = max(`sez1',`sez2',`sez3')	
	local bx`i' = _b[x]
	local by`i' = _b[y]
	local bz`i' = _b[z]
	local n`i' = e(N)
	drop x y z
}
cd "$BaconPath/FinalFiguresTables/"

quietly {
	capture log close
	log using "electionyear.tex", text replace
	noisily display " Co-partisan \(\times\) Election Year & " %4.3f `bx1' " & " %4.3f `bx2' " & " %4.3f `bx3' " & " %4.3f `bx4' " & " %4.3f `bx5' " \\ "
	noisily display " & (" %4.3f `sex1' ") & (" %4.3f `sex2' ") & (" %4.3f `sex3' ") & (" %4.3f `sex4' ") & (" %4.3f `sex5' ")  \\ [0.25cm] " 
	noisily display " Co-partisan & " %4.3f `by1' " & " %4.3f `by2' " & " %4.3f `by3' " & " %4.3f `by4' " & " %4.3f `by5' " \\ "
	noisily display " & (" %4.3f `sey1' ") & (" %4.3f `sey2' ") & (" %4.3f `sey3' ") & (" %4.3f `sey4' ") & (" %4.3f `sey5' ")  \\ [0.25cm]  " 	
	noisily display " Election Year & " %4.3f `bz1' " & " %4.3f `bz2' " & " %4.3f `bz3' " & " %4.3f `bz4' " & " %4.3f `bz5' " \\ "
	noisily display " & (" %4.3f `sez1' ") & (" %4.3f `sez2' ") & (" %4.3f `sez3' ") & (" %4.3f `sez4' ") & (" %4.3f `sez5' ")  \\ [0.25cm] " 
	noisily display " \midrule "
	noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
	log off
} 		


********************************
**Panel B: Years to Next Election
********************************

clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
keep if whole==1
local outcome logSgwaPercap

qui forval i =1/5 {
	gen x = yeartonextelection*treat_Tminus`i'
	gen y = treat_Tminus`i'
	gen z = yeartonextelection
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) cluster(council_cycle)
	local sex1 = _se[x]	
	local sey1 = _se[y]
	local sez1 = _se[z]
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) r
	local sex2 = _se[x]	
	local sey2 = _se[y]
	local sez2 = _se[z]	
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) 
	local sex3 = _se[x]	
	local sey3 = _se[y]
	local sez3 = _se[z]	
	local sex`i' = max(`sex1',`sex2',`sex3')
	local sey`i' = max(`sey1',`sey2',`sey3')
	local sez`i' = max(`sez1',`sez2',`sez3')	
	local bx`i' = _b[x]
	local by`i' = _b[y]
	local bz`i' = _b[z]
	local n`i' = e(N)
	drop x y z
}
cd "$BaconPath/FinalFiguresTables/"

quietly {
	capture log close
	log using "yearstonext.tex", text replace
	noisily display " Co-partisan \(\times\) Years to Elect. & " %4.3f `bx1' " & " %4.3f `bx2' " & " %4.3f `bx3' " & " %4.3f `bx4' " & " %4.3f `bx5' " \\ "
	noisily display " & (" %4.3f `sex1' ") & (" %4.3f `sex2' ") & (" %4.3f `sex3' ") & (" %4.3f `sex4' ") & (" %4.3f `sex5' ")  \\ [0.25cm] " 
	noisily display " Co-partisan & " %4.3f `by1' " & " %4.3f `by2' " & " %4.3f `by3' " & " %4.3f `by4' " & " %4.3f `by5' " \\ "
	noisily display " & (" %4.3f `sey1' ") & (" %4.3f `sey2' ") & (" %4.3f `sey3' ") & (" %4.3f `sey4' ") & (" %4.3f `sey5' ")  \\ [0.25cm]  " 	
	noisily display " Years to Elect. & " %4.3f `bz1' " & " %4.3f `bz2' " & " %4.3f `bz3' " & " %4.3f `bz4' " & " %4.3f `bz5' " \\ "
	noisily display " & (" %4.3f `sez1' ") & (" %4.3f `sez2' ") & (" %4.3f `sez3' ") & (" %4.3f `sez4' ") & (" %4.3f `sez5' ")  \\ [0.25cm] " 
	noisily display " \midrule "
	noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
	log off
} 		


********************************
**Figure 4: Heterogeneity across Institutions
********************************
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren, clear
gen toptier = type=="UNITARY" | type=="COUNTY"
gen nonstaggered  = staggered==0

local i = 3
gen x = treat_Tminus`i'
gen y = treat_Tminus`i'*nonstaggered 
gen z = treat_Tminus`i'*toptier
gen xyz = nonstaggered*toptier*treat_Tminus`i'

qui areg logSgwaPercap  x y z xyz i.year  council_trend*  ,  absorb(councilnumber)

matrix B = J(50, 8, .)
matrix B[1, 1] = _b[x]
matrix B[1, 2] = _b[x] -1.96*_se[x]
matrix B[1, 3] = _b[x] +1.96*_se[x]
matrix B[1, 4] = 1

lincom x+y
matrix B[2, 1] = r(estimate)
matrix B[2, 2] = r(estimate) -1.96*r(se)
matrix B[2, 3] = r(estimate) +1.96*r(se)
matrix B[2, 4] = 2

lincom x+z
matrix B[3, 1] = r(estimate)
matrix B[3, 2] = r(estimate) -1.96*r(se)
matrix B[3, 3] = r(estimate) +1.96*r(se)
matrix B[3, 4] = 3


lincom x+y+z+xyz
matrix B[4, 1] = r(estimate)
matrix B[4, 2] = r(estimate) -1.96*r(se)
matrix B[4, 3] = r(estimate) +1.96*r(se)
matrix B[4, 4] = 4

	svmat B
	keep if B1 != .
	keep B* 

	
label define institutions 1 "Lower tier + frequent elect." 2 "Lower tier + infrequent elect." 3 "Upper tier + frequent elect." 4 "Upper tier + infrequent elect." 
label values B4 institutions

	
 twoway   (dot B1 B4,horizontal ndots(1) mcolor(blue) msymbol(square)) (rcap B2 B3 B4, horizontal lcolor(blue))   , ///
 subtitle(, bcolor(white)) xline(0, lcolor(black)) graphregion(color(white))  ylabel(1 2 3 4 ,valuelabel angle(horizontal))  ///
  ytitle("") xtitle("Effect of Partisan Alignment, t+3")  legend( order( 1 "Diff-in-Diff" 2 "95%") ring(0) position(3) cols(1)) yscale(range(0.5 4.5)) ///
  text(4.3 0.4 "Citizen-focused services," "low electoral risk") text(0.65 0.14 "Administrative services," "high electoral risk")
cd "$BaconPath/FinalFiguresTables/"
graph export "institutions_t3.pdf", replace


***************
***************
** Table 3: Swing Councils
***************
***************

********************************
** Swing Councils
********************************
clear
estimates clear
cd "$BaconPath/"
use Replication_FournaiesMutluEren
local outcome logSgwaPercap
keep if treat_Tminus1!=. | treat_Tminus2!=.| treat_Tminus3!=.|treat_Tminus4!=.|treat_Tminus5!=.
qui forval i =1/5 {
	gen x = treat_Tminus`i'*LocalNOC_Tminus`i'
	gen y = treat_Tminus`i'
	gen z = LocalNOC_Tminus`i'
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) cluster(council_cycle)
	local SEx1 = _se[x]	
	local SEy1 = _se[y]
	local SEz1 = _se[z]
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) r
	local SEx2 = _se[x]	
	local SEy2 = _se[y]
	local SEz2 = _se[z]	
	xi: areg `outcome' x y z i.year council_trend*  , absorb(councilnumber) 
	local SEx3 = _se[x]	
	local SEy3 = _se[y]
	local SEz3 = _se[z]	
	local sex`i' = max(`SEx1',`SEx2',`SEx3')
	local sey`i' = max(`SEy1',`SEy2',`SEy3')
	local sez`i' = max(`SEz1',`SEz2',`SEz3')
	local bx`i' = _b[x]
	local by`i' = _b[y]
	local bz`i' = _b[z]
	local n`i' = e(N)
	drop x y z
}
cd "$BaconPath/FinalFiguresTables/"

quietly {
	capture log close
	log using "LocalSwing.tex", text replace
	noisily display " Co-partisan \(\times\) Swing Council & " %4.3f `bx1' " & " %4.3f `bx2' " & " %4.3f `bx3' " & " %4.3f `bx4' " & " %4.3f `bx5' " \\ "
	noisily display " & (" %4.3f `sex1' ") & (" %4.3f `sex2' ") & (" %4.3f `sex3' ") & (" %4.3f `sex4' ") & (" %4.3f `sex5' ")  \\ [0.25cm] " 
	noisily display " Co-partisan & " %4.3f `by1' " & " %4.3f `by2' " & " %4.3f `by3' " & " %4.3f `by4' " & " %4.3f `by5' " \\ "
	noisily display " & (" %4.3f `sey1' ") & (" %4.3f `sey2' ") & (" %4.3f `sey3' ") & (" %4.3f `sey4' ") & (" %4.3f `sey5' ")  \\ [0.25cm]  " 	
	noisily display " Swing Council & " %4.3f `bz1' " & " %4.3f `bz2' " & " %4.3f `bz3' " & " %4.3f `bz4' " & " %4.3f `bz5' " \\ "
	noisily display " & (" %4.3f `sez1' ") & (" %4.3f `sez2' ") & (" %4.3f `sez3' ") & (" %4.3f `sez4' ") & (" %4.3f `sez5' ")  \\ [0.25cm] " 
	noisily display " \midrule "
	noisily display " Observations & " %5.0f `n1' " & " %5.0f `n2' " & " %5.0f `n3' " & " %5.0f `n4' " & " %5.0f `n5' "  \\  " 
	log off
} 



