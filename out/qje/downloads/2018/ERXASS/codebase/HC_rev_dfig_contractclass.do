/*---------------------------------------------------------------HC_rev_dfig_contractclass.do

Stuart Craig
Last updated	20180816
*/
timestamp, output
cap mkdir dfig_contractclass
cd dfig_contractclass


/*
---------------------------------------------------

Contract classification rates by clinical cohort
in one figure

---------------------------------------------------
*/
	tempfile build
	loc c=0
	loc pl=subinstr("${proclist}","ip hip","ip ip20 hip",.)
	di "`pl'"

// Build the dataset of averages	
	foreach proc of local pl {
		loc ++c
		if "`proc'"=="kmri" continue
		
		loc p2 "`proc'"
		if "`proc'"=="ip20" loc p2 "ip"
		use ${ddHC}/HC_cdata_`p2'_i.dta, clear
		keep if adj_price<.
		if "`proc'"=="ip20" bys prov_e_npi ep_drg: keep if _N>=20
		
		recode c_type (1=1) (2=2) (-9 3=3), gen(cat)
		qui gen count=1
		bys prov_e_npi: gen N_h = _n==1
		collapse (sum) count N_h (sum) spend=price, by(cat) fast
		gen proc="`proc'"
		gen i=`c'
		reshape wide count spend N_h, i(i) j(cat)
		egen tot = rowtotal(count*)
		egen totspend = rowtotal(spend*)
		egen N_h = rowtotal(N_h*)
		forval i=1/3 {
			qui gen pct`i' = count`i'/tot
		}
		if `c'>1 append using `build'
		save `build', replace
	}
	
// Formatting names
	#d ;
	label define proccd 
		1 "Inpatient"
		2 "Inpatient*"
		3 "Hip Replacement"
		4 "Knee Replacement"
		5 "Cesarean Section"
		6 "Vaginal Delivery"
		7 "PTCA"
		8 "Colonoscopy"
		9 "Lower Limb MRI", replace;
	#d cr
	label val i proccd
	
// Formatting the labels
	foreach v of varlist pct? {
		cap drop str_`v'
		gen str_`v' = string(`v'*100,"%3.1f")
		replace str_`v' = str_`v' + "%"
	}
	
// Bars need to be cumulative percentages
	qui replace pct2 = pct1 + pct2
	qui replace pct3 = pct3 + pct2
	forval i=1/3 {
		cap drop labpos`i'
		qui gen labpos`i' = pct`i'
	}
	
// Make the figure
	tw bar pct1 i, color("${blu}") barw(.9) fintensity(30) ///
		|| rbar pct2 pct1 i, color("${red}") barw(.9) ///
		|| rbar pct3 pct2 i, color(gs14) barw(.9) lpattern(solid) lstyle(solid) lw(vvvthin) ///
		xlabel(1/`=_N', noticks valuelabel angle(45) labsize(vsmall)) ///
		xtitle("") ytitle("Contract Share") ylab(0(0.2)1,format(%2.1f)) ///
		legend(order(1 "Prospective Payment" 2 "Share of Charges" 3 "Unclassified") pos(6) row(1)) ///
		|| scatter labpos1 i, ms(none) mla(str_pct1) mlabpos(6) mlabgap(0) mlabcolor(black) mlabsize(small) ///
		|| scatter labpos2 i, ms(none) mla(str_pct2) mlabpos(6) mlabgap(0) mlabcolor(black) mlabsize(small) ///
		|| scatter labpos3 i, ms(none) mla(str_pct3) mlabpos(6)  mlabgap(0) mlabcolor(black) mlabsize(small) ///
		aspect(.6) 
	 graph export HC_rev_dfig_contractclass_cohorts.png, replace
	
// B/W version for publication	
	 tw bar pct1 i, color(gs9) barw(.9) fintensity(30) ///
		|| rbar pct2 pct1 i, color(gs5) barw(.9) ///
		|| rbar pct3 pct2 i, color(gs15) barw(.9) lpattern(solid) lstyle(solid) lw(vvvthin) ///
		xlabel(1/`=_N', noticks valuelabel angle(45) labsize(vsmall)) ///
		xtitle("") ytitle("Contract Share") ylab(0(0.2)1,format(%2.1f)) ///
		legend(order(1 "Prospective Payment" 2 "Share of Charges" 3 "Unclassified") pos(6) row(1)) ///
		|| scatter labpos1 i, ms(none) mla(str_pct1) mlabpos(6) mlabgap(0) mlabcolor(black) mlabsize(small) ///
		|| scatter labpos2 i, ms(none) mla(str_pct2) mlabpos(6) mlabgap(0) mlabcolor(black) mlabsize(small) ///
		|| scatter labpos3 i, ms(none) mla(str_pct3) mlabpos(6)  mlabgap(0) mlabcolor(black) mlabsize(small) ///
		aspect(.6) 
	graph export HC_pub_dfig_contractclass_cohorts.tif, replace width(5000)
	
	


exit
