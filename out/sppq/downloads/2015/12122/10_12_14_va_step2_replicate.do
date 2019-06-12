//global directory "C:\Users\AG\Dropbox\PhD - Third Year\Ballot Labels\STATA Code\june reboot\"
cd "$directory"

/*
1 - Bring in the raw data
*/
clear all
use "virginia_pct_results_1997-2005_combined.dta"

local extra_parties "C G L I V W"
foreach g of local extra_parties{
replace candidate="" if party == "`g'"
}

//drop if office==5

/*
NB: See last footnote in SPPQ Paper for rationale with changing these precinct names and codes to match. 
*/

gen new_precinct_name = ""
replace new_precinct_name = precinct_name
gen new_location_code = ""
replace new_location_code = location_code

replace new_precinct_name = "STUART ADMINISTRATION" if location_code=="141-0402"
replace new_precinct_name = "CRITZSTELLA" if location_code=="141-0301"
replace new_precinct_name = "CRITZSTELLA" if location_code=="141-0303"
replace new_precinct_name = "GEORGE WASHINGTON SCHOOL" if location_code=="510-0108"
replace new_precinct_name = "COURTHOUSE" if locality=="CAMPBELL COUNTY" & precinct_name == "COURT HOUSE"
replace new_precinct_name = "DAUGHERTY" if locality=="RUSSELL COUNTY" & precinct_name == "DAUGHERTYS"
replace new_precinct_name = "HORSEPASTURE" if locality=="HENRY COUNTY" & precinct_name == "HORSEPASTURE 1" | locality=="HENRY COUNTY" & precinct_name == "HORSEPASTURE 2"
replace new_precinct_name = "RIDGEWAY" if locality=="HENRY COUNTY" & precinct_name == "RIDGEWAY 1" | locality=="HENRY COUNTY" & precinct_name == "RIDGEWAY 2"
replace new_precinct_name = "LOUISA" if locality=="LOUISA COUNTY" & precinct_name == "LOUISA 1" | locality=="LOUISA COUNTY" & precinct_name == "LOUISA 2"

replace new_precinct_name = subinstr(new_precinct_name, ".", "",.) 
replace new_precinct_name = subinstr(new_precinct_name, "-", " ",.) 
replace new_precinct_name = subinstr(new_precinct_name, "'", "",.) 
replace new_precinct_name = subinstr(new_precinct_name, ",", "",.) 
replace new_precinct_name = subinstr(new_precinct_name, "#", "",.) 
replace new_precinct_name = subinstr(new_precinct_name, "&", "",.) 
replace new_precinct_name = subinstr(new_precinct_name, "/", "",.) 

gen solution=.

//names good, codes bad
replace solution = 1 if locality == "CAMPBELL COUNTY"
replace solution = 1 if locality == "HENRICO COUNTY"
replace solution = 1 if locality == "LOUDON COUNTY"
replace solution = 1 if locality == "NEWPORT NEWS CITY"
replace solution = 1 if locality == "RUSSELL COUNTY"
replace solution = 1 if locality == "STAFFORD COUNTY"
replace solution = 1 if locality == "FAIRFAX COUNTY"
replace solution = 1 if locality == "ROCKINGHAM COUNTY" 
replace solution = 1 if locality == "VIRGINIA BEACH CITY"
replace solution = 1 if locality == "CRAIG COUNTY"
replace solution = 1 if locality == "HENRY COUNTY"
replace solution = 1 if locality == "LOUISA COUNTY"
replace solution = 1 if locality == "KING GEORGE COUNTY"

//codes good, names changed
replace solution = 2 if locality == "BEDFORD COUNTY"
replace solution = 2 if locality == "ALEXANDRIA CITY"
replace solution = 2 if locality == "NORFOLK CITY"
replace solution = 2 if locality == "PATRICK COUNTY"
replace solution = 2 if locality == "STAUNTON CITY"
replace solution = 2 if locality == "WESTMORELAND COUNTY"
replace solution = 2 if locality == "FLOYD COUNTY"
replace solution = 2 if locality == "LUNENBURG COUNTY"
replace solution = 2 if locality == "CHESAPEAKE CITY"
replace solution = 2 if locality == "ROCKBRIDGE COUNTY"
replace solution = 2 if locality == "HAMPTON CITY"
replace solution = 2 if locality == "PRINCE GEORGE COUNTY"
replace solution = 2 if locality == "WINCHESTER CITY"

egen location_code_clean = mode(new_location_code), max by (locality new_precinct_name)
replace new_location_code = location_code_clean if solution == 1

egen precinct_name_clean = mode(new_precinct_name), max by (location_code)
replace new_precinct_name = precinct_name_clean if solution == 2
replace new_precinct_name = lower(new_precinct_name)

replace new_location_code = "031-0603" if new_location_code == "031-0301" & locality == "CAMPBELL COUNTY" & new_precinct_name == "EVINGTON"
replace new_location_code = "167-0302" if new_location_code == "167-0303" & locality == "RUSSELL COUNTY" & new_precinct_name == "HONAKER"
replace locality = lower(locality)

drop location_code_clean precinct_name_clean solution

save "virginia_pct_results_1997-2005.dta", replace
