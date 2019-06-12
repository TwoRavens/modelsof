/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Illustrate variation

INPUTS: 
- ${xwalkdir}/rucdate_mtg_xwalk.dta
- See .ado files for inputs indirectly used

OUTPUTS:
- Figure 1
- Figure 3
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

*** Figure 1 *****************************************************************************
tempfile mtgid_xwalk master
use data/crosswalks/rucdate_mtg_xwalk, clear
keep ruc_yr mtg_num mtgid ruc_cycle
duplicates drop
save `mtgid_xwalk', replace
gen_ruc_memspec
drop if member_specialty=="Hematology"&phys_lname=="REGAN"
by ruc_yr mtg_num member_id, sort: drop if _n==2
merge m:1 ruc_yr mtg_num using `mtgid_xwalk', keep(match) nogen

// Select on meetings for consistency
// Omit meeting 1995_1, as only three codes reviewed with no proposing specialty
drop if ruc_yr==1995&mtg_num==1

// Procedural vs. cognitive seats over meetings
gen byte cognitive=inlist(member_specialty,"Emergency Medicine","Family Medicine", ///
	"Geriatrics","Hematology","Infectious Disease","Internal Medicine")
replace cognitive=1 if inlist(member_specialty, ///
	"Nephrology","Neurology","Oncology","Osteopathic Medicine","Pediatrics", ///
	"Psychiatry","Pulmonary Medicine","Rheumatology")
drop if member_specialty=="Osteopathic Medicine"
gen cruc_yr=ruc_yr+(mtg_num-1)/3
by cruc_yr, sort: egen cogcount=total(cognitive)
by cruc_yr: egen proccount=total(!cognitive)
by cruc_yr: egen totalcount=count(_n)
keep cruc_yr *count
duplicates drop
twoway line totalcount proccount cogcount cruc_yr, xtitle("") ///
	legend(off) lcolor(black black black) lpattern(solid dash shortdash) ///
	xlabel(1991 1995(5)2015) graphregion(color(white)) ylabel(, nogrid) ///
	name(Figure1, replace)
graph export "output/Figure_1.eps", as(eps) replace

*** Figure 3 *****************************************************************************
gen_working_data, aff
preserve
keep aff obs_id
duplicates drop
sum aff
restore
gen naff=(aff-r(mean))/r(sd)
preserve
keep naff obs_id
duplicates drop
sum naff, d
scalar np25=r(p25)
scalar np75=r(p75)
restore
levelsof specialty, local(specialties)
local num=1
foreach specialty in `specialties' {
	if inlist("`specialty'","Cardiology","Orthopaedic Surgery","Otolaryngology", ///
		"Radiology","Plastic Surgery","Vascular Surgery") {
		if "`specialty'"=="Orthopaedic Surgery" local title Orthopedic Surgery
		else local title `specialty'
		twoway (histogram naff if specialty=="`specialty'", width(.02) frequency ///
			color(gs5)) (scatteri 0 `=np25' 120 `=np25', c(l) m(i) lcolor(gs11) ///
			lpattern(dash)) (scatteri 0 `=np75' 120 `=np75', c(l) m(i) lcolor(gs11) ///
			lpattern(dash)), xscale(range(-1 1)) xlabel(-1(.5)1) ///
			yscale(range(0 120)) ylabel(0(40)120) legend(off) graphregion(color(white)) ///
			name(gspec`num', replace) xtitle("Affiliation") ///
			title("`title'", color(black)) ylabel(, nogrid)
		local num=`num'+1
	}
}
graph combine gspec1 gspec2 gspec3 gspec4 gspec5 gspec6, ///
	ysize(7) rows(3) cols(2) iscale(*.9) graphregion(color(white)) ///
	name(Figure_3, replace)
graph export "output/Figure_3.eps", as(eps) replace

