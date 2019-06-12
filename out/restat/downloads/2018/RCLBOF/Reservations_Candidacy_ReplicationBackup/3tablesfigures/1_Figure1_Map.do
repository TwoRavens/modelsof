************************************************************************
************************************************************************
clear
clear matrix
clear mata
cap log close

global root "~/dropbox/Reservations_Candidacy_ReplicationBackup"
include "$root/2progs/00_set_paths.do"
************************************************************************
************************************************************************

***convert state-level borders file -- requires shp2dta / spmap package
shp2dta using "$root/9maps/01. Layer files/World Administrative Areas/IND_adm1.shp", database(indiastatedb) coordinates(indiastatecoord) genid(stateid) replace
shp2dta using "$root/9maps/01. Layer files/WB Shapefile/Districts_FINAL.shp", database(indiadb) coordinates(indiacoord) genid(id) replace
use "$work/indiadb", clear

g districtname = Final_1
g FinalState = upper(trim(STATE))

merge m:1 FinalState districtname using "$work/chairperson_variation_district.dta"
	drop if _m==2  /* this is for states not appearing in the base matrix as target states because they do not have any cross-state borders or they are only captured as target states */
	drop if _m==1 /*this is for states with no records in NSS in the rural areas & age ranges selected */
	drop _m

	
label var cum_distres2007 "Cumulative years of chairperson reservation, 2007"
	replace cum_distres2007 = 2 if mi( cum_distres2007) & FinalState=="BIHAR" //adjust for the missing district in Bihar, found to be 2 yrs
foreach var of varlist cum_distres2007 {
local label : var label `var'
format `var' %9.2f
spmap   `var' using "$work/indiacoord", id(id) osize(thin) polygon(data("$work/indiastatecoord.dta") osize(*2.0) ) ///
			legend(size(small) position(1)) fcolor(Reds) ndfcolor(white) ndocolor(white) clnumber(5) ///
			title("`label'", size(medium)) 
cap graph export "../7tex/analysisoutput/`var'_borders.png", replace
}

