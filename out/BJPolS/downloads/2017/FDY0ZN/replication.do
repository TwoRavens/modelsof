* ==============================================================================
* 	Risky business? 
*	Welfare state reforms and government support in Britain and Denmark 
*
*	Lee, Jensen, Arndt, and Wenzelburger 
* 	British Journal of Political Science 2017
*
* 	Replication Do File for: Tables and Figures (main)
*	May 15, 2017
* ==============================================================================
set scheme sol /* ado file available at: https://dl.dropbox.com/u/3011470/scheme_sol.zip */


********************************************************************************
*****					 *******************************************************
*****   UNITED KINGDOM   *******************************************************
*****					 *******************************************************
********************************************************************************

*======================
* Figures 1 and 2
*======================
use uk_policy.dta, clear

sort policydomain year
collapse direction numreform sumdirec* numpos* numneg* (max) numdirec*, by(policydomain year)

xtset policydomain year
replace numdirecneg = -1*numdirecneg
label def numdirecneg -1 "1" -2 "2" -3 "3" -4 "4" -5 "5" -6 "6" -7 "7" -8 "8" -9 "9", modify
label val numdirecneg numdirecneg
label def numdirecpos 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9", modify
label val numdirecpos numdirecpos

***** Figure 1

#delimit ;
	local j = "numdirecpos"; local k = "numdirecneg";
	local jpt = "solid"; local kpt = "dash";
	local jsb = "circle"; local ksb = "circle_hollow";
	graph twoway 
		(scatter `k' year, mcolor(black) msize(small) msymbol(`ksb')) 
		(scatter `j' year, mcolor(black) msize(small) msymbol(`jsb')) 
		(line `j' year, lpattern(`jpt') lcolor(black)) 
		(line `k' year, lpattern(`kpt') lcolor(black)) if policydomain == 2,
		xline(1945 1950 1951 1955 1959 1964 1966 1970 1974 1979 1983 1987 1992 1997 2001 2005 2010, lpattern(tight_dot) lcolor(gs2))
		yline(0, lpattern(solid) lcolor(gs7)) legend(off) xtitle("") ytitle("")
		xlabel(1945(5)2015) ylabel(-7(1)9, labels valuelabel glcolor(gs15)) xsize(9) ysize(4);
#delimit cr	

***** Figure 2

#delimit ;
	local j = "numdirecpos"; local k = "numdirecneg";
	local jpt = "solid"; local kpt = "dash";
	local jsb = "circle"; local ksb = "circle_hollow";
	graph twoway 
		(scatter `k' year, mcolor(black) msize(small) msymbol(`ksb')) 
		(scatter `j' year, mcolor(black) msize(small) msymbol(`jsb')) 
		(line `j' year, lpattern(`jpt') lcolor(black)) 
		(line `k' year, lpattern(`kpt') lcolor(black)) if policydomain == 1,
		xline(1945 1950 1951 1955 1959 1964 1966 1970 1974 1979 1983 1987 1992 1997 2001 2005 2010, lpattern(tight_dot) lcolor(gs2))
		yline(0, lpattern(solid) lcolor(gs7)) legend(off) xtitle("") ytitle("")
		xlabel(1945(5)2015) ylabel(-7(1)9, labels valuelabel glcolor(gs15)) xsize(9) ysize(4);
#delimit cr


*======================
* Figure 5
*======================	
use uk_annual_final.dta, clear

rename supportannual support_y2

preserve
	keep if pm==1
	collapse support cor_y support_y2, by(year party)
	xtset party year
	local i = "black"
	local j = "black"
	local ipt = "dash" // pm=cons pattern
	local jpt = "solid" // pm=lab patterm	
	graph twoway (scatter support_y2 year if party==3, mcolor(black) msize(small) msymbol(circle_hollow)) ///
		(line support_y2 year if party==3&year>=1951&year<=1965, lcolor(`i') lpattern(`ipt')) ///
		(line support_y2 year if party==3&year>=1970&year<=1974, lcolor(`i') lpattern(`ipt')) ///
		(line support_y2 year if party==3&year>=1979&year<=1997, lcolor(`i') lpattern(`ipt')) ///
		(line support_y2 year if party==3&year>=2010, lcolor(`i') lpattern(`ipt')) ///
		(scatter support_y2 year if party==8, mcolor(black) msize(small) msymbol(circle)) ///
		(line support_y2 year if party==8&year<=1951, lcolor(`j') lpattern(`jpt')) ///
		(line support_y2 year if party==8&year>=1964&year<=1970, lcolor(`j') lpattern(`jpt')) ///
		(line support_y2 year if party==8&year>=1974&year<=1979, lcolor(`j') lpattern(`jpt')) ///
		(line support_y2 year if party==8&year>=1997&year<=2010, lcolor(`j') lpattern(`jpt')), ///
		xline(1945 1950 1951 1955 1959 1964 1966 1970 1974 1979 1983 1987 1992 1997 2001 2005 2010, lpattern(tight_dot) lcolor(gs5)) xline(1950, lpattern(tight_dot) lcolor(gs5)) ///			
		yline(30(10)55, lpattern(tight_dot)) ytitle("Government Support (%)") xtitle("")   ///
		legend(order(7 "Labour" 2 "Conservative") position(8) ring(0) row(2) region(lcolor(none)) lcolor(none)) ///
		xlabel(1945(5)2015) xsize(9) ysize(4) 
restore


*======================
* Table 1
*======================	
use uk_annual_final.dta, clear
	* drop new govt's support in transitional (elec) year as DV
	foreach i of var support* {
		replace `i' = . if uk_trans_y==2
		}		
	* set controls
	global epiv_uk "cor_y2 l.gdpgrowth l.inflation l.unemp_ameco"
		
* pension
preserve
	keep if domain==1
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg, vce(cluster party)
		estimates store uk1
		xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 		
		estimates store uk2
		test l.numdirecpos-(l.numdirecneg*(-1))=0
restore

* unemployment
preserve
	keep if domain==2
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg, vce(cluster party)
		estimates store uk3
		xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 
		estimates store uk4
		test l.numdirecpos-(l.numdirecneg*(-1))=0
restore

***** Table 1

esttab uk1 uk2 uk3 uk4, mlabel ("Pension" "Pension" "Unemp." "Unemp.") ///
	b(%10.3f) se scalars(N r2_o sigma_e sigma_e "N_g \# Groups") star(+ 0.10 * 0.05 ** 0.01) label replace

	
*======================
* Table 2
*======================	
* pension
preserve
	keep if domain==1
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 		
		estimates store uk2
		lincom 0*[l.numdirecneg]+1*[l.numdirecpos]	// # cutbacks * # expansions
		lincom 0*[l.numdirecneg]+2*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+0*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+1*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+2*[l.numdirecpos]
		lincom 2*[l.numdirecneg]+0*[l.numdirecpos]
		lincom 2*[l.numdirecneg]+1*[l.numdirecpos]
restore

* unemployment
preserve
	keep if domain==2
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 		
		estimates store uk4
		lincom 0*[l.numdirecneg]+1*[l.numdirecpos] // # cutbacks * # expansions
		lincom 0*[l.numdirecneg]+2*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+0*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+1*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+2*[l.numdirecpos]
		lincom 2*[l.numdirecneg]+0*[l.numdirecpos]
		lincom 2*[l.numdirecneg]+1*[l.numdirecpos]
		lincom 2*[l.numdirecneg]+2*[l.numdirecpos]
restore


*======================
* Table 5
*======================	
* row 1
preserve
	keep if domain==1
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 		
		lincom [l.numdirecneg]
		di abs(r(estimate))		// magnitude: effect of cutbacks
		lincom [l.numdirecpos]
		di abs(r(estimate))		// magnitude: effect of expansions
restore

* row 2
preserve
	keep if domain==2
	tsset party uk_yt
	set more off
		xtreg support_y l.numdirecpos l.numdirecneg $epiv_uk, vce(cluster party) 		
		lincom [l.numdirecneg]
		di abs(r(estimate))		// magnitude: effect of cutbacks
		lincom [l.numdirecpos]
		di abs(r(estimate))		// magnitude: effect of expansions
restore



	
********************************************************************************
*****			  **************************************************************
*****   DENMARK   **************************************************************
*****			  **************************************************************
********************************************************************************

*======================
* Figures 3 and 4
*======================
use dk_policy.dta, clear

sort year month
collapse direction numreform sumdirec* (max) numdirec*, by(policydomain year)

xtset policydomain year
replace numdirecneg = -1*numdirecneg
label def numdirecneg -1 "1" -2 "2" -3 "3" -4 "4" -5 "5" -6 "6" -7 "7" -8 "8" -9 "9", modify
label val numdirecneg numdirecneg
label def numdirecpos 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9"
label val numdirecpos numdirecpos

***** Figure 3

#delimit ;
	local j = "numdirecpos"; local k = "numdirecneg";
	local jpt = "solid"; local kpt = "dash";
	local jsb = "circle"; local ksb = "circle_hollow";
	graph twoway 
		(scatter `k' year, mcolor(black) msize(small) msymbol(`ksb')) 
		(scatter `j' year, mcolor(black) msize(small) msymbol(`jsb')) 
		(line `j' year, lpattern(`jpt') lcolor(black)) 
		(line `k' year, lpattern(`kpt') lcolor(black)) if policydomain == 2,
		xline(1957 1960 1964 1966 1968 1971 1973 1975 1977 1979 1981 1984 1987 1988 1990 1994 1998 2001 2005 2007 2011, lpattern(tight_dot) lcolor(gs2))
		yline(0, lpattern(solid) lcolor(gs7)) legend(off) xtitle("") ytitle("")
		xlabel(1960(5)2015) ylabel(-8(1)9, labels valuelabel glcolor(gs15)) xsize(9) ysize(4);
#delimit cr	
	
***** Figure 4

#delimit ;
	local j = "numdirecpos"; local k = "numdirecneg";
	local jpt = "solid"; local kpt = "dash";
	local jsb = "circle"; local ksb = "circle_hollow";
	graph twoway 
		(scatter `k' year, mcolor(black) msize(small) msymbol(`ksb')) 
		(scatter `j' year, mcolor(black) msize(small) msymbol(`jsb')) 
		(line `j' year, lpattern(`jpt') lcolor(black)) 
		(line `k' year, lpattern(`kpt') lcolor(black)) if policydomain == 1,
		xline(1957 1960 1964 1966 1968 1971 1973 1975 1977 1979 1981 1984 1987 1988 1990 1994 1998 2001 2005 2007 2011 , lpattern(tight_dot) lcolor(gs2))
		yline(0, lpattern(solid) lcolor(gs7)) legend(off) xtitle("") ytitle("")
		xlabel(1955(5)2012) ylabel(-8(1)9, labels valuelabel glcolor(gs15)) xsize(9) ysize(4);
#delimit cr


*======================
* Figure 6
*======================
use dk_annual_final.dta, clear	

preserve
keep if pm==1	
sort party year
	local i = "black"
	local j = "black"
	local ipt = "solid" 	// A (1) pattern
	local jpt = "tight_dot" // B (2) patterm
	local kpt = "shortdash"	// V (4) pattern
	local lpt = "dash"	// c (3) pattern
	graph twoway (scatter cabsupport_y year if party=="A", mcolor(black) msize(small) msymbol(circle)) ///
		(line cabsupport_y year if party=="A"&year>=1957&year<=1967+1, lcolor(`i') lpattern(`ipt')) ///
		(line cabsupport_y year if party=="A"&pm==1&year>=1971&year<=1973, lcolor(`i') lpattern(`ipt')) ///
		(line cabsupport_y year if party=="A"&year>=1975&year<=1981+1, lcolor(`i') lpattern(`ipt')) ///
		(line cabsupport_y year if party=="A"&year>=1993&year<=2000+1, lcolor(`i') lpattern(`ipt')) ///
		(line cabsupport_y year if party=="A"&year>=2011&year<=2014+1, lcolor(`i') lpattern(`ipt')) ///
		(scatter cabsupport_y year if party=="B", mcolor(black) msize(small) msymbol(circle)) ///
		(line cabsupport_y year if party=="B"&year>=1968&year<=1970+1, lcolor(`i') lpattern(`jpt') lwidth(medthick)) ///
		(scatter cabsupport_y year if party=="V", mcolor(black) msize(small) msymbol(circle)) ///		
		(line cabsupport_y year if party=="V"&year>=1973&year<=1974+1, lcolor(`i') lpattern(`kpt')) ///
		(line cabsupport_y year if party=="V"&year>=2001&year<=2010+1, lcolor(`i') lpattern(`kpt')) ///
		(scatter cabsupport_y year if party=="C", mcolor(black) msize(small) msymbol(circle)) ///
		(line cabsupport_y year if party=="C"&year>=1982&year<=1992+1, lcolor(`j') lpattern(`lpt')), ///
		xline(1957 1960 1964 1966 1968 1971 1973 1975 1977 1979 1981 1984 1987 1988 1990 1994 1998 2001 2005 2007 2011 2015, lpattern(tight_dot) lcolor(gs5)) ///			
		yline(20(10)50, lpattern(tight_dot)) ///
		legend(order(2 "A (Sd)" 8 "B (RV)" 10 "V" 13 "C (KF)") position(8) ring(0) row(4) region(lcolor(none)) lcolor(none)) ///
		xlabel(1955(5)2015) xsize(9) ysize(4) ylabel(,glcolor(gs15)) xtitle("") ytitle("Government Support (%)")
restore


*======================
* Table 3
*======================
use dk_annual_final.dta, clear	
	* drop new govt's support in transitional (elec) year as DV
	foreach i of var cabsupport* {
		replace `i' = . if dk_trans_y_pm==2
		}
		replace cor_pm_y2=0 if year==2001&party=="V"
	* define bloc
	gen bloc2 =. 		// 1 RED = A, B, BCV (1968); 2 BLUE = C, V, AV (1978)
		replace bloc2 = 1 if party=="A"|party=="B"
		replace bloc2 = 2 if party=="C"|party=="V"|dk_yt_pm==26|dk_yt_pm==27 // = year 78 and 79
	gen bloc3 = bloc2 	// 1 RED = A, B; 2 BLUE = C, V; 3 CROSS = BCV (1968), AV (1978)
		replace bloc3 = 3 if dk_yt_pm==13|dk_yt_pm==14|dk_yt_pm==15|dk_yt_pm==16|dk_yt_pm==26|dk_yt_pm==27
	gen earlyelec = 0
		replace earlyelec=1 if year==1973|year==1975|year==1977|year==1979|year==1981|year==2007
	recode elec_y (.=0)
		label def bloc 1 "red" 2 "blue" 3 "cross"
		label val bloc2 bloc3 bloc 
	* set controls
	global epiv_dk "cor_pm_y2 l.gdpgrowth l.inflation l.unemprate_ameco numcabparty"

* pension
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg, vce(cluster bloc3)
		estimates store dk1
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk2
restore

* unemployment
preserve
	keep if domain==2
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg, vce(cluster bloc3)
		estimates store dk3
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk4
restore

***** Table 3

esttab dk1 dk2 dk3 dk4 , mlabel ("Pension" "Pension" "Unemp." "Unemp.") ///
	b(%10.3f) se scalars(N r2_o) star(+ 0.10 * 0.05 ** 0.01) label replace

	
*======================
* Table 4
*======================
* pension only
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		estimates store dk2
		lincom 1*[l.numdirecneg]+0*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+1*[l.numdirecpos]
		lincom 1*[l.numdirecneg]+2*[l.numdirecpos]
		lincom 2*[l.numdirecneg]+0*[l.numdirecpos]
		lincom 3*[l.numdirecneg]+0*[l.numdirecpos]
restore


*======================
* Table 5
*======================
* row 3
preserve
	keep if domain==1
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		lincom [l.numdirecneg]
		di abs(r(estimate))		// magnitude: effect of cutbacks
		lincom [l.numdirecpos]
		di abs(r(estimate))		// magnitude: effect of expansions
restore

* row 4
preserve
	keep if domain==2
	tsset bloc3 dk_yt_pm
	set more off
		xtreg cabsupport_y l.numdirecpos l.numdirecneg $epiv_dk, vce(cluster bloc3) 
		lincom [l.numdirecneg]
		di abs(r(estimate))		// magnitude: effect of cutbacks
		lincom [l.numdirecpos]
		di abs(r(estimate))		// magnitude: effect of expansions
restore




*\END
