cd "...\Replication files" /* Set directory */
capture log close
log using BJPolS.log, replace

*		************************************************************************		*
*		************************************************************************		*
*		  File:				BJPolS.do													*
*		  Date:				August 2015													*
*		  Author:			MG															*
*		  Purpose:			Contested Sovereignty Data Paper 							*
*		  Input file:		Contested_Sovereignty_v1.dta								*
*		  Log file:			BJPolS.log													*
*		  Data output:		None														*
*		  Machine:			Office laptop												*
*		  Stata version:	11.2														*
*		************************************************************************		*
*		************************************************************************		*



***********
** Get data
***********

* Load CS data set
use "Contested_Sovereignty_v1.dta", clear

* Attach cluster data
preserve
clear
insheet using "Sov_Clusters.csv", delim(;)
rename event clevent
drop entity - issue
sort id
save sov_clusters.dta, replace
restore
sort id
merge id using sov_clusters.dta
drop _merge

* Check merging
gen t = 1 if event != clev
list event clevent if t==1
drop clevent t

   
**************************
** Decade-wise frequencies
**************************

gen decade = floor(year/10)
replace decade = (decade+.5) * 10
egen decade2 = seq() in 1/24, from(177) to(200) block(1) 
replace decade2 = (decade2+.5) * 10
gen refs = .
forvalues i = 1775(10)2005 {
count if decade == `i'
replace refs = r(N) if decade2 == `i'
}


************************
** Year-wise frequencies
************************

egen year2 = seq() , from(1776) to(2012) block(1) 
replace year2 = . in 238/597
gen reg_europe = .
gen reg_noa = .
gen reg_rest = .
gen logic_int = .
gen logic_disint = .
gen logic_mixed = .
gen scope_partial = .
gen scope_full = .
gen scope_pooled = .
gen scope_mixed = .
forvalues i = 1776(1)2012 {
count if year == `i' & region == "Europe"
replace reg_europe = r(N) if year2 == `i'
count if year == `i' & region == "North America"
replace reg_noa = r(N) if year2 == `i'
count if year == `i' & region != "Europe" & region !="North America"
replace reg_rest = r(N) if year2 == `i'
count if year == `i' & logic == "Integrative"
replace logic_int = r(N) if year2 == `i'
count if year == `i' & logic == "Disintegrative"
replace logic_disint = r(N) if year2 == `i'
count if year == `i' & logic == "Mixed"
replace logic_mixed = r(N) if year2 == `i'
count if year == `i' & scope == "Partial"
replace scope_partial = r(N) if year2 == `i'
count if year == `i' & scope == "Full"
replace scope_full = r(N) if year2 == `i'
count if year == `i' & scope == "Pooled"
replace scope_pooled = r(N) if year2 == `i'
count if year == `i' & scope == "Mixed"
replace scope_mixed = r(N) if year2 == `i'
}


***************************
** Cluster-wise frequencies
***************************

gen cluster = .
replace cluster = 1 if code == "US"
replace cluster = 2 if code == "F"
replace cluster = 3 if code == "E"
replace cluster = 4 if code == "ww1"
replace cluster = 5 if code == "decol"
replace cluster = 6 if code == "devo"
replace cluster = 7 if code == "Supra"
replace cluster = 8 if code == "p89"
replace cluster = 9 if code == ""
label define cluster 1 "US" 2 "French Revolution" 3 "19th state formation" ///
	4 "Post-WWI" 5 "Decolonization" 6 "Devo/Sep" 7 "Supranationalization" ///
	8 "Post-Communism" 9 "Other", replace
label value cluster cluster


****************
** Numeric types
****************

gen typenum = .
replace typenum = 1 if type == "Incorporation"
replace typenum = 2 if type == "Sub-state merger"
replace typenum = 3 if type == "Unification"
replace typenum = 4 if type == "Transfer"
replace typenum = 5 if type == "Supranational accession"
replace typenum = 6 if type == "Supranational delegation"
replace typenum = 7 if type == "Autonomy"
replace typenum = 8 if type == "Sub-state split"
replace typenum = 9 if type == "Independence"
replace typenum = 10 if type == "Irredentist separation"
replace typenum = 11 if type == "Supranational withdrawal"
replace typenum = 12 if type == "Supranational repatriation"
replace typenum = 13 if type == "Multi-option"
label define typenum 1 "Incorporation" 2 "Sub-state merger" 3 "Unification" 4 "Transfer" ///
	5 "Supranat. accession" 6  "Supranat. delegation" 7 "Autonomy" 8 "Sub-state split" ///
	9 "Independence" 10 "Irredent. separation" 11 "Supranat. withdrawal" 12 "Supranat. repatriation" 13 "Multi-option"
label value typenum typenum


***********
** Outcomes
***********

gen change_passed = .
replace change_passed = 100 if passed == 1 & yes_direction == 1
replace change_passed = 100 if passed == 0 & yes_direction == 0
replace change_passed = 0 if passed == 0 & yes_direction == 1
replace change_passed = 0 if passed == 1 & yes_direction == 0

gen prochange_yes = .
replace prochange_yes = yes if yes_direction == 1
replace prochange_yes = 100-yes if yes_direction == 0


******************
** Other variables
******************

gen zero = 0
gen one = 100


********************************
** Graph decade-wise frequencies
********************************

twoway bar refs decade2, ///
	sort barwidth(10) fcolor(gs14) lcolor(black) ytitle("Frequency", size(medium) margin(zero)) yscale(nofextend noextend ) ///
	ylabel(0(20)100, angle(horizontal) nogrid nogextend) ymtick(10(10)90, nolabels) ///
	xtitle("Decade", margin(medsmall) size(medium)) xscale(nofextend noextend) ///
	xlabel(1780(20)2000, angle(forty_five) valuelabels) xmtick(1770(20)2010) ///
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=3 r=5 b=0 t=5)) ///
	ysize(6) xsize(9)
graph export "Fig3.eps", replace


******************************
** Types by clusters (Table 1)
******************************

tab typenum cluster, col
* get start/end dates
bysort cluster: sum year


***********************
** Frequencies of types
***********************

gen sovref = 1
graph bar (sum) sovref, over(typenum, gap(*.5) sort(1) descending label(angle(forty_five) labgap(small)) ///
	axis(lcolor(none))) bar(1, fcolor(gs14) lcolor(black)) outergap(*.1) ///
	ytitle(Frequency, size(medium) margin(zero)) ytitle(, size(medium) margin(zero)) yscale(nofextend) ///
	ylabel(0(20)120, angle(horizontal) nogrid) ymtick(10(10)110, nolabels) ///
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=3 r=5 b=0 t=5)) ///
	ysize(6) xsize(9)
graph export "Fig4.eps", replace


****************************************************
** Graph year-wise frequencies by regions (smoothed)
****************************************************

* Smoothed using local polynomial kernel regression (bwidth = 4, at year to make it look smoother)
lpoly reg_noa year2, bwidth(4) at(year2) generate(x_noa fx_noa)
lpoly reg_europe year2, bwidth(4) at(year2) generate(x_europe fx_europe)
lpoly reg_rest year2, bwidth(4) at(year2) generate(x_rest fx_rest)
corr fx* reg_europe reg_noa reg_rest

gen l1_reg_sm = fx_noa
label var l1_reg_sm "North America" 
gen l2_reg_sm = fx_noa + fx_europe
label var l2_reg_sm "Europe"
gen l3_reg_sm = fx_noa + fx_europe + fx_rest
label var l3_reg_sm "Rest"

twoway (rarea zero l1_reg_sm year2, sort fcolor(gs4) lcolor(black)) ///
	   (rarea l1_reg_sm l2_reg_sm year2, sort fcolor(gs9) lcolor(black)) ///
	   (rarea l2_reg_sm l3_reg_sm year2, sort fcolor(gs14) lcolor(black)), ///
        ytitle("Frequency", margin(zero) size(medium))  yscale(range (0 10) noextend nofextend) ///
		ylabel(0(5)10, angle(horizontal) nogrid nogextend)  ymtick(0(1)10, nolabels) ///
	    xtitle("Year", margin(medsmall) size(medium)) xscale(range(1770 2020) noextend nofextend) ///
    	xlabel(1780(20)2020, angle(forty_five)) xmtick(1770(20)2010) ///
		legend( order(- "Region:" 1 2 3) span label(1 "North America") label(2 "Europe") label(3 "All other") rows(1) pos(6) colgap(*1.5) symxsize(*.35) region(lstyle(none) lcolor(white)))  ///
	    scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=3 r=5 b=0 t=5)) ///
		ysize(6) xsize(9)
graph export "Fig5.eps", replace


**************************************************
** Graph year-wise frequencies by logic (smoothed)
**************************************************
	
* Smoothed using local polynomial kernel regression (bwidth = 4, at year so that we get estimate for all years included)
lpoly logic_int year2, bwidth(4) at(year2) generate(x_int fx_int)
lpoly logic_disint year2, bwidth(4) at(year2) generate(x_disint fx_disint)
lpoly logic_mixed year2, bwidth(4) at(year2) generate(x_mixlo fx_mixlo)
corr fx_int fx_disint fx_mixlo logic_int logic_disint logic_mixed

gen l1_log_sm = fx_int
label var l1_log_sm "Integrative" 
gen l2_log_sm = fx_int + fx_disint
label var l2_log_sm "Disintegrative"
gen l3_log_sm = fx_int + fx_disint + fx_mixlo
label var l3_log_sm "Mixed"

twoway (rarea zero l1_log_sm year2, sort fcolor(gs4) lcolor(black)) ///
	   (rarea l1_log_sm l2_log_sm year2, sort fcolor(gs9) lcolor(black)) ///
	   (rarea l2_log_sm l3_log_sm year2, sort fcolor(gs14) lcolor(black)), ///
        ytitle("Frequency", margin(zero) size(medium))  yscale(range (0 10) noextend nofextend) ///
		ylabel(0(5)10, angle(horizontal) nogrid nogextend) ymtick(0(1)10) ///
	    xtitle("Year", margin(medsmall) size(medium)) xscale(range(1770 2020) noextend nofextend) ///
    	xlabel(1780(20)2020, angle(forty_five)) xmtick(1770(20)2010) ///
		legend( order(- "Logic:" 1 2 3) span label(1 "Integrative") label(2 "Disintegrative") label(3 "Mixed logic") rows(1) pos(6) colgap(*1.5) symxsize(*.35) region(lstyle(none) lcolor(white)))  ///
	    scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=3 r=5 b=0 t=5)) ///
		ysize(6) xsize(9)
graph export "Fig6.eps", replace


**************************************************
** Graph year-wise frequencies by scope (smoothed)
**************************************************

* Smoothed using local polynomial kernel regression (bwidth = 4, at year so that we get estimate for all years included)
lpoly scope_full year2, bwidth(4) at(year2) generate(x_full fx_full)
lpoly scope_par year2, bwidth(4) at(year2) generate(x_par fx_par)
lpoly scope_pool year2, bwidth(4) at(year2) generate(x_pool fx_pool)
lpoly scope_mix year2, bwidth(4) at(year2) generate(x_mixsco fx_mixsco)
corr fx_full fx_par fx_pool fx_mixsco scope_full scope_par scope_pool scope_mix

gen l1_sco_sm = fx_full
label var l1_sco_sm "Full" 
gen l2_sco_sm = fx_full + fx_par
label var l2_sco_sm "Partial"
gen l3_sco_sm = fx_full + fx_par + fx_pool
label var l3_sco_sm "Pooled"
gen l4_sco_sm = fx_full + fx_par + fx_pool + fx_mixsco
label var l4_sco_sm "Mixed"

twoway (rarea zero l1_sco_sm year2, sort fcolor(gs4) lcolor(black)) ///
	   (rarea l1_sco_sm l2_sco_sm year2, sort fcolor(gs8) lcolor(black)) ///
	   (rarea l2_sco_sm l3_sco_sm year2, sort fcolor(gs14) lcolor(black)) ///
	   (rarea l3_sco_sm l4_sco_sm year2, sort fcolor(gs16) lcolor(black)), ///
        ytitle("Frequency", margin(zero) size(medium))  yscale(range (0 10) noextend nofextend) ///
		ylabel(0(5)10, angle(horizontal) nogrid nogextend) ymtick(0(1)10) ///
	    xtitle("Year", margin(medsmall) size(medium)) xscale(range(1770 2020) noextend nofextend) ///
    	xlabel(1780(20)2020, angle(forty_five)) xmtick(1770(20)2010) ///
	    legend(order(- "Scope:" 1 2 3 4) span label(1 "Full") label(2 "Partial") label(3 "Pooled") label(4 "Mixed") rows(1) pos(6) colgap(*1.5) symxsize(*.35) region(lstyle(none) lcolor(white)))  ///	   
		scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=3 r=5 b=0 t=5)) ///
		ysize(6) xsize(9)
graph export "Fig7.eps", replace


*****************
** Graph outcomes
*****************

* Share of referendums in favour of change to status quo
graph hbar (mean) change_passed, over(typenum, gap(50) sort(1) descending ///
	axis(lcolor(none))) nofill bar(1, fcolor(gs14) lcolor(black)) bargap(33) outergap(10) ///
	ytitle("Referendums in favour of sovereignty" "reallocation (%)", margin(small)) ///
	yscale(nofextend) ylabel(0(25)100, labels nogrid)  ymtick(5(5)95, nogrid) ///
	legend(off) scale(1) ///
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=1 r=5 b=2 t=5)) ///
	ysize(6) xsize(9) name(passed, replace)

* Yes share in favour of change to status quo
graph hbox prochange_yes, over(typenum, gap(50) sort(1) descending ///
	axis(lcolor(none))) nofill outergap(10) bargap(33) ///
	box(1, fcolor(gs14) lcolor(black) lwidth(vvvthin))  medtype(line) marker(1, msymbol(circle) mlcolor(black) mlwidth(vvvthin) mfcolor(none)) ///
	ytitle("Vote share in favour of sovereignty" "reallocation (%)", margin(small)) ///
	yscale(range(0 100) nofextend) ylabel(0(25)100, labels nogrid) ymtick(5(5)95, nogrid) ///
	legend(off) scale(1) ///
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=1 r=5 b=2 t=5)) ///
	ysize(6) xsize(9) name(yes_share, replace)

graph combine passed yes_share, ysize(8) xsize(12)
graph export "Fig8.eps", replace


*************************************
** Graph outcomes (alternative count)
*************************************

egen tag = tag(eventid) if passed_ref_event == "Event"
replace tag = 1 if passed_ref_event == "Referendum"
bysort eventid: egen eventmean_prochange_yes = mean(prochange_yes)
gen prochange_yes_alt = prochange_yes if passed_ref_event == "Referendum"
replace prochange_yes_alt = eventmean_prochange_yes if passed_ref_event == "Event"

* Share of referendums in favour of change to status quo
graph hbar (mean) change_passed if tag == 1, over(typenum, gap(50) sort(1) descending ///
	axis(lcolor(none))) nofill bar(1, fcolor(gs14) lcolor(black)) bargap(33) outergap(10) ///
	ytitle("Referendum events in favour of" "sovereignty reallocation (%)", margin(small)) ///
	yscale(nofextend) ylabel(0(25)100, labels nogrid)  ymtick(5(5)95, nogrid) ///
	legend(off) scale(1) ///
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=1 r=5 b=2 t=5)) ///
	ysize(6) xsize(9) name(passed_alt, replace)

* Yes share in favour of change to status quo
graph hbox prochange_yes_alt if tag == 1, over(typenum, gap(50) sort(1) descending ///
	axis(lcolor(none))) nofill outergap(2) bargap(10) ///
	box(1, fcolor(gs14) lcolor(black) lwidth(vvvthin))  medtype(line) marker(1, msymbol(circle) mlcolor(black) mlwidth(vvvthin) mfcolor(none)) ///
	ytitle("Vote share in favour of sovereignty" "reallocation (%)", margin(small)) ///
	yscale(range(0 100) nofextend) ylabel(0(25)100, labels nogrid) ymtick(5(5)95, nogrid) ///
	legend(off) scale(1) ///
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(margin(l=1 r=5 b=2 t=5)) ///
	ysize(6) xsize(9) name(yes_share_alt, replace)

graph combine passed_alt yes_share_alt, ysize(8) xsize(12) imargin(right)
graph export "Fig8_alternative.eps", replace


log close
