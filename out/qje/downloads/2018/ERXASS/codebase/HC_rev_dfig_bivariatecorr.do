/*-----------------------------------------------------HC_rev_dfig_bivariatecorr.do

Stuart Craig
Last updated	20180816
*/


// Want the scheme without lines
timestamp, output
cap mkdir dfig_bivariatecorr
cd dfig_bivariatecorr
set scheme burd


// Build contract measures

	// Share of Charges
	use ${ddHC}/HC_cdata_ip_h.dta, clear
	rename ptc_norestrict price_to_charge
	rename prov_e_npi merge_npi
	rename ep_adm_y merge_year
	keep merge* price_to_charge
	tempfile ptc
	save `ptc'
	
	// Medicare Link
	use ${ddHC}/HC_cdata_ip_medid.dta, clear
	keep if inlist(c_type,1,2)
	collapse (mean) medanchor, by(prov_e_npi ep_adm_y) fast
	rename prov_e_npi merge_npi
	rename ep_adm_y merge_year
	keep merge* medanchor
	tempfile medanchor
	save `medanchor'

// Run all correlates measures against our LHS variables
	foreach pvar in adj_price price_to_charge medanchor {

	use ${ddHC}/HC_hdata_ip.dta, clear
	if "`pvar'"=="price_to_charge" merge 1:1 merge_npi merge_year using `ptc', keep(3) nogen
	if "`pvar'"=="medanchor" merge 1:1 merge_npi merge_year using `medanchor', keep(3) nogen
	keep if adj_price<.

	cap drop e_price
	qui summ `pvar'
	qui gen e_price = (`pvar' - r(mean))/r(sd)

	// Generate the correlates
	makex, rural hccishare
	qui replace x_mdt_2 = max(x_mdt_2,x_mdt_1)
	qui replace x_mdt_3 = max(x_mdt_3,x_mdt_2)
	// Bring in extra quality scores
	merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_mhc.dta, ///
		nogen keepusing(mhc_amim10 mhc_amim01 mhc_surgm08 mhc_surgm38)
	// Impute the average for missings (quality scores only)
	foreach v of varlist mhc* {
		qui summ `v', mean
		qui replace `v' = r(mean) if `v'==.
	}
	pfixdrop x_qual
	qui gen x_qual1=mhc_amim10 
	qui gen x_qual2=mhc_surgm08
	qui gen x_qual3=mhc_surgm38
	qui gen x_qual4=1 - mhc_amim01/100

	// Compute correlation coefficients and standard errors
	loc ctr=0
	foreach v of varlist x_* {
		loc ++ctr
		loc stub = subinstr("`v'","x_","",.)
		
		cap drop e_x
		qui summ `v'
		qui gen e_x = (`v'-r(mean))/r(sd)
		qui reg e_price e_x

		qui gen mu_`stub' 	= _b[e_x]
		qui gen cih_`stub'	= _b[e_x] + 1.96*_se[e_x]
		qui gen cil_`stub'	= _b[e_x] - 1.96*_se[e_x]
		qui gen pos_`stub'	= `ctr'
	}
	keep mu* ci* pos*
	keep if _n==1
	gen i=.
	reshape long mu_ cih_ cil_ pos_, i(i) j(x) s

	// Make the scatterplot
	qui summ pos, d
	qui replace pos = r(max)-pos
	sort pos
	list

	qui replace pos = pos+1 if pos>3
	qui replace pos = pos+1 if pos>7
	qui replace pos = pos+1 if pos>11
	qui replace pos = pos+1 if pos>18
	list

	expand 2
	bys pos: gen n=_n
	sort pos n
	qui replace cih_ = cil_ if n==1
	drop cil_

	#d ;
	label define x
		23 	"Hospital in Monopoly Market, 15m"
		22 	"Hospital in Duopoly Market, 15m"	
		21	"Hospital in Triopoly Market, 15m"
		20 	"HCCI Share of Lives Covered, County"
		19 	""
		18 	"Number of Technologies"
		17 	"Ranked by US News and World Reports"
		16 	"Number of Beds"
		15 	"Teaching"
		14	"Government"
		13	"Non-Profit"
		12	""
		11	"Percent of County Uninsured"
		10	"County Median Income"
		9	"Rural"
		8	""
		7 	"Medicare Base Payment"
		6 	"Medicare Share of Patients"
		5 	"Medicaid Share of Patients"
		4	""
		3	"% AMI Patients Given Aspirin at Arrival"
		2	"% Patients Given Antibiotic 1 Hr Pre-Surgery"
		1	"% of Surgery Patients Treated to Prevent Blood Clots"
		0	"30-day AMI Survival Rate", replace;
	label val pos x;
	#d cr

	tw	line pos cih_ if pos==0, lc("${blu}") || 	scatter pos mu  if pos==0, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==1, lc("${blu}") || 	scatter pos mu  if pos==1, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==2, lc("${blu}") || 	scatter pos mu  if pos==2, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==3, lc("${blu}") || 	scatter pos mu  if pos==3, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==5, lc("${blu}") || 	scatter pos mu  if pos==5, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==6, lc("${blu}") || 	scatter pos mu  if pos==6, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==7, lc("${blu}") || 	scatter pos mu  if pos==7, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==9, lc("${blu}") || 	scatter pos mu  if pos==9, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==10, lc("${blu}") || 	scatter pos mu  if pos==10, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==11, lc("${blu}") ||	scatter pos mu  if pos==11, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==13, lc("${blu}") ||	scatter pos mu  if pos==13, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==14, lc("${blu}") ||	scatter pos mu  if pos==14, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==15, lc("${blu}") ||	scatter pos mu  if pos==15, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==16, lc("${blu}") ||	scatter pos mu  if pos==16, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==17, lc("${blu}") ||	scatter pos mu  if pos==17, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==18, lc("${blu}") ||	scatter pos mu  if pos==18, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==20, lc("${blu}") ||	scatter pos mu  if pos==20, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==21, lc("${blu}") ||	scatter pos mu  if pos==21, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==22, lc("${blu}") ||	scatter pos mu  if pos==22, msymbol(circle) mc("${red}") || ///
		line pos cih_ if pos==23, lc("${blu}") ||	scatter pos mu  if pos==23, msymbol(circle) mc("${red}")  ///
		legend(off)  ///
		ylab(0 1 2 3 5 6 7 9 10 11 13 14 15 16 17 18 20 21 22 23, valuelabel labsize(small)) ytitle("") xtitle("{&rho}") ///
		yline(4, lc(black)) yline(8, lc(black)) yline(12, lc(black)) yline(19, lc(black)) ///
		xlab(-.4(.2).4, format("%2.1f") labsize(small)) xline(0, lc(black) lstyle(solid)) xsize(2) ysize(1.2)
	graph export HC_rev_dfig_bivariatecorr_`pvar'.png, as(png) replace
STOP
	// B/W version for publication (only need for price)
	if "`pvar'"=="adj_price" {
		tw	line pos cih_ if pos==0, lc(gs6) || 	scatter pos mu  if pos==0, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==1, lc(gs6) || 	scatter pos mu  if pos==1, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==2, lc(gs6) || 	scatter pos mu  if pos==2, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==3, lc(gs6) || 	scatter pos mu  if pos==3, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==5, lc(gs6) || 	scatter pos mu  if pos==5, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==6, lc(gs6) || 	scatter pos mu  if pos==6, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==7, lc(gs6) || 	scatter pos mu  if pos==7, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==9, lc(gs6) || 	scatter pos mu  if pos==9, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==10, lc(gs6) || 	scatter pos mu  if pos==10, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==11, lc(gs6) ||	scatter pos mu  if pos==11, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==13, lc(gs6) ||	scatter pos mu  if pos==13, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==14, lc(gs6) ||	scatter pos mu  if pos==14, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==15, lc(gs6) ||	scatter pos mu  if pos==15, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==16, lc(gs6) ||	scatter pos mu  if pos==16, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==17, lc(gs6) ||	scatter pos mu  if pos==17, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==18, lc(gs6) ||	scatter pos mu  if pos==18, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==20, lc(gs6) ||	scatter pos mu  if pos==20, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==21, lc(gs6) ||	scatter pos mu  if pos==21, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==22, lc(gs6) ||	scatter pos mu  if pos==22, msymbol(circle) mc(gs6) || ///
			line pos cih_ if pos==23, lc(gs6) ||	scatter pos mu  if pos==23, msymbol(circle) mc(gs6)  ///
			legend(off)  ///
			ylab(0 1 2 3 5 6 7 9 10 11 13 14 15 16 17 18 20 21 22 23, valuelabel labsize(small)) ytitle("") xtitle("{&rho}") ///
			yline(4, lc(black)) yline(8, lc(black)) yline(12, lc(black)) yline(19, lc(black)) ///
			xlab(-.4(.2).4, format("%2.1f") labsize(small)) xline(0, lc(black) lstyle(solid)) xsize(2) ysize(1.2)
			graph export HC_pub_dfig_bivariatecorr_`pvar'.tif, replace width(5000)
	}
	}

// Set scheme back to original
	set scheme isps_health, perm

	
exit
