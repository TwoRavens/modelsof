/* ----------------------------------------------------HC_rev_dfig_compcorr.do

Stuart Craig
Last updated 	20180816
*/


	timestamp, output
	cap mkdir dfig_compcorr
	cd dfig_compcorr
	set scheme burd

// Instead of a price measure, we have 15m HHI on the LHS
	loc pvar syshhi_15m
	use ${ddHC}/HC_hdata_ip.dta, clear

	cap drop e_price
	qui summ `pvar'
	qui gen e_price = (`pvar' - r(mean))/r(sd)

// Generate correlates
	makex, rural hccishare
	qui replace x_mdt_2 = max(x_mdt_2,x_mdt_1)
	qui replace x_mdt_3 = max(x_mdt_3,x_mdt_2)
	drop x_mdt*

// Bring in and clean the quality scores
	merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_mhc.dta, ///
		nogen keepusing(mhc_amim10 mhc_amim01 mhc_surgm08 mhc_surgm38)
	// Impute the average for missings
	foreach v of varlist mhc* {
		qui summ `v', mean
		qui replace `v' = r(mean) if `v'==.
	}
	pfixdrop x_qual
	qui gen x_qual1=mhc_amim10 
	qui gen x_qual2=mhc_surgm08
	qui gen x_qual3=mhc_surgm38
	qui gen x_qual4=1 - mhc_amim01/100

// Calculate the corr and SEs
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
		9   "Rural"
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
		line pos cih_ if pos==18, lc("${blu}") ||	scatter pos mu  if pos==18, msymbol(circle) mc("${red}") ||  ///
		line pos cih_ if pos==20, lc("${blu}") ||	scatter pos mu  if pos==20, msymbol(circle) mc("${red}")  ///
		legend(off)  ///
		ylab(0 1 2 3 5 6 7 9 10 11 13 14 15 16 17 18 20 , valuelabel labsize(small)) ytitle("") xtitle("{&rho}") ///
		yline(4, lc(black)) yline(8, lc(black)) yline(12, lc(black)) yline(19, lc(black)) ///
		xlab(-.6(.2).6, format("%2.1f") labsize(small)) xline(0, lc(black) lstyle(solid)) xsize(2) ysize(1.2)
	graph export HC_rev_dfig_compcorr.png, as(png) replace

set scheme isps_health, perm


exit

