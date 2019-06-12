cd "/Users/kevinrinz/Box Sync/Research/Milwaukee Vouchers/Published Tables"

global data "Data"
global output "Output"
global scripts "Scripts"

***** NTEE codes C, D, and E
clear *
set more off
set matsize 2000

use "$data/nccs_wi_1999.dta", clear
forvalues y = 2000/2012 {
	append using "$data/nccs_wi_`y'.dta", force
}
sort ein fisyr

keep if inlist(ntee1,"C","D","E")

bys ein: egen nobs = count(ein)
bys ein: egen minrev = min(totrev)
bys ein: egen minexp = min(exps)

keep if nobs>=10 & minrev>=10000 & minexp>=10000
drop if address==""

saveold "$data/nccs_panel.dta", replace

duplicates drop address city zip5, force

gen address2 = address
gen city2 = city
* switch to subinstr?
replace address2 = subinstr(address2,"STREET","ST",1)
replace address2 = subinstr(address2,"BOULEVARD","BLVD",1)
replace address2 = subinstr(address2,"PLZ","PLAZA",1)
replace address2 = subinstr(address2,"PLAZZA","PLAZA",1)
replace address2 = subinstr(address2,"ROAD","RD",1)
replace address2 = subinstr(address2,"AVENUE","AVE",1)
replace address2 = subinstr(address2,"PLACE","PL",1)
replace address2 = subinstr(address2,"DRIVE","DR",1)
replace address2 = subinstr(address2,"PARKWAY","PKWY",1)
replace address2 = subinstr(address2,"HIGHWAY","HWY",1)
replace address2 = subinstr(address2,"TRAIL","TRL",1)
replace address2 = subinstr(address2,"LANE","LN",1)
replace address2 = subinstr(address2,"COURT","CT",1)
replace address2 = subinstr(address2,"MOUNT ","MT ",1)

replace address2 = subinstr(address2,"SUITE","STE",1)

replace address2 = subinstr(address2,"NORTH","N",1)
replace address2 = subinstr(address2,"SOUTH","S",1)
replace address2 = subinstr(address2,"EAST","E",1)
replace address2 = subinstr(address2,"WEST","W",1)

replace address2 = subinstr(address2,"P O BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\.O\. BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\. O\. BOX","PO BOX",1)

replace city2 = subinstr(city2,"ADDLETON","APPLETON",1)
replace city2 = subinstr(city2,"ALQOMA","ALGOMA",1)
replace city2 = subinstr(city2,"AMERV","AMERY",1)
replace city2 = subinstr(city2,"ANTILO","ANTIGO",1)
replace city2 = subinstr(city2,"BAILEYS HBR","BAILEYS HARBOR",1)
replace city2 = subinstr(city2,"BLK RIVER FLS","BLACK RIVER FALLS",1)
replace city2 = subinstr(city2,"BTE DES MORTS","BUTTE DES MORTS",1)
replace city2 = subinstr(city2,"CHIPPEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"DESOTO","DE SOTO",1)
replace city2 = subinstr(city2,"DURAUD","DURAND",1)
replace city2 = subinstr(city2,"E TROY","EAST TROY",1)
replace city2 = subinstr(city2,"EAU CIAIRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EAU CLALRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EGHRAIM","EPHRAIM",1)
replace city2 = subinstr(city2,"FENNIMORE MONTFORT","MONTFORT",1)
replace city2 = subinstr(city2,"FON DU LAC","FOND DU LAC",1)
replace city2 = subinstr(city2,"FR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"GRANDSBURG","GRANTSBURG",1)
replace city2 = subinstr(city2,"KOBLER","KOHLER",1)
replace city2 = subinstr(city2,"LACROSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LACOSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"HIHILLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"MADIWON","MADISON",1)
replace city2 = subinstr(city2,"MADLSON","MADISON",1)
replace city2 = subinstr(city2,"MARSHFIEID","MARSHFIELD",1)
replace city2 = subinstr(city2,"MENOMONEE FAILS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONEE FLS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MIDISON","MADISON",1)
replace city2 = subinstr(city2,"MILWAUKEEM","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWUAKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MIWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKIE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLILWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLLWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKEEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MOUNT CALVARY","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVARV","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVERY","MT CALVARY",1)
replace city2 = subinstr(city2,"MONFORT","MONTFORT",1)
replace city2 = subinstr(city2,"MOUNT HOREB","MT HOREB",1)
replace city2 = subinstr(city2,"MUKWANAGO","MUKWONAGO",1)
replace city2 = subinstr(city2,"NELLLSVILLE","NEILLSVILLE",1)
replace city2 = subinstr(city2,"PHYMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PLEASANT PR","PLEASANT PRAIRIE",1)
replace city2 = subinstr(city2,"PLVMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PR DU CHIEN","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRAIRIEDUSAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRT WASHINGTN","PORT WASHINGTON",1)
replace city2 = subinstr(city2,"RACTNE","RACINE",1)
replace city2 = subinstr(city2,"RHINEIANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RICHLAND CTR","RICHLAND CENTER",1)
replace city2 = subinstr(city2,"S MILWAUKEE","SOUTH MILWAUKEE",1)
replace city2 = subinstr(city2,"SHEBOUYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOVAAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYOAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SLINAER","SLINGER",1)
replace city2 = subinstr(city2,"SOLDIER GROVE","SOLDIERS GROVE",1)
replace city2 = subinstr(city2,"ST CROIX FLS","ST CROIX FALLS",1)
replace city2 = subinstr(city2,"STOUGMON","STOUGHTON",1)
replace city2 = subinstr(city2,"VIROQUA WI","VIROQUA",1)
replace city2 = subinstr(city2,"VLAYVME","MAYVILLE",1)
replace city2 = subinstr(city2,"W ALLIS","WEST ALLIS",1)
replace city2 = subinstr(city2,"W BEND","WEST BEND",1)
replace city2 = subinstr(city2,"W LAKE","WEST LAKE",1)
replace city2 = subinstr(city2,"W SALEM","WEST SALEM",1)
replace city2 = subinstr(city2,"W WATERTOWN PLANK","WEST WATERTOWN PLANK",1)
replace city2 = subinstr(city2,"WASHINGTON IS","WASHINGTON ISLAND",1)
replace city2 = subinstr(city2,"WATEROWN","WATERTOWN",1)
replace city2 = subinstr(city2,"WAUGACA","WAUPACA",1)
replace city2 = subinstr(city2,"WIR RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WIS RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WISC RAPIDS","WISCONSIN RAPIDS",1)

saveold "$data/nccs_raw_addresses.dta", replace

keep ein fisyr name state address2 city2 state zip5
duplicates drop address2 city2 zip5, force
gen fulladdr = address2 + ", " + city2 + " " + zip5 + ", WI, USA"

saveold "$data/nccs_clean_addresses.dta", replace

use "$data/nccs_clean_addresses.dta", clear

gen line = _n
gen cenaddr = string(line)+","+address2+","+city2+",WI,"+zip5
outsheet cenaddr using "$data/cenaddr1.csv" if inrange(line,1,1000), comma nonames replace
outsheet cenaddr using "$data/cenaddr2.csv" if inrange(line,1001,2000), comma nonames replace

opencagegeo, key(e2a58234ed0e46518386435d9ab080bf) fulladdress(fulladdr)

saveold "$data/nccs_latlon.dta", replace
* fix a few manually, then saveold again
saveold "$data/nccs_latlon.dta", replace

use "$data/nccs_raw_addresses.dta", clear
merge m:1 address2 city2 zip5 using "$data/nccs_latlon.dta", keepusing(g_lat g_lon city2)
drop _m
tempfile temp
saveold `temp'

use "$data/nccs_panel.dta", clear
merge m:1 address city zip5 using `temp', keepusing(g_lat g_lon city2)
drop _m
sort ein fisyr
saveold "$data/nccs_panel_latlon.dta", replace





clear *
set more off
set matsize 2000

use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
saveold `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
saveold `tracts2010'

use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
keep if year==2000
tempfile fpl2000
saveold `fpl2000'

foreach year in 2000 2009 2010 2011 2012 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	saveold `covars`year''
}

use "$data/nccs_panel_latlon.dta", clear

keep ein fisyr name state ntee1 nteecc address city city2 zip zip5 fips taxper cont progrev totrev totrev2 exps g_lat g_lon
rename (g_lat g_lon) (lat lon)

duplicates drop ein taxper lat lon cont progrev totrev totrev2 exps, force

gen taxper_y = substr(taxper,1,4)
gen taxper_m = substr(taxper,5,2)
destring taxper_y, replace
destring taxper_m, replace
destring fisyr, replace
destring lat, replace
destring lon, replace
gen year = taxper_y if taxper_m==12
replace year = taxper_y - 1 if taxper_m<12
replace year = fisyr - 1 if year==.

merge m:1 year using "$data/prices.dta"
drop if _m==2
drop _m

gen id1 = ein + "-" + taxper

gen pobox = (strpos(address," BOX ")>0)
bys ein taxper: egen totpobox = sum(pobox)
bys ein taxper: egen totobs = count(ein)

drop if pobox==1 & totpobox<totobs

sort ein taxper exps
by ein taxper: keep if _n==_N

isid id1

tempfile temp
saveold `temp'

geonear id1 lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
rename id id2
merge m:1 id2 using `fpl2000'
drop if _m==2
drop _m

collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(id1 year)
saveold "$data/wisconsin_nccs_fpl_1miles_faminc_famtype.dta", replace

foreach year in 2000 2009 2010 2011 2012 {
	use `temp', clear
	if `year'<=2009 {
		geonear id lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		saveold `near`year''
	}
	if `year'>=2010 {
		geonear id lat lon using `tracts2010', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		saveold `near`year''
	}
	
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* [fw=pop_all], by(id1 year)
	tempfile means`year'
	saveold `means`year''
}

use `means2000', clear
foreach year in 2009 2010 2011 2012 {
	append using `means`year''
}
saveold "$data/wisconsin_nccs_covars_1miles.dta", replace

foreach file in covars_1miles {
	use "$data/wisconsin_nccs_`file'.dta", clear
	
	egen id3 = group(id1)
	tsset id3 year
	tsfill
	by id3: egen idfill = mode(id1)
	replace id1 = idfill if id1==""
	drop idfill
	
	qui ds
	local allvars = r(varlist)
	local exclude id1 year
	local vars: list allvars - exclude
	disp "`vars'"

	foreach var in `vars' {
		bys id1: ipolate `var' year, generate(i_`var')
	}
	drop `vars'
	sort id1 year
	saveold "$data/wisconsin_nccs_`file'_interp.dta", replace
}

use `temp', clear
merge 1:1 id1 using "$data/wisconsin_nccs_fpl_1miles_faminc_famtype.dta"
drop if _m==2
drop _m

merge 1:1 id1 year using "$data/wisconsin_nccs_covars_1miles_interp.dta"
drop if _m==2
drop _m

gen milwaukee = city2=="MILWAUKEE"
gen racine = inlist(city2,"RACINE","CALEDONIA","ELMWOOD PARK","MT PLEASANT","NORTH BAY","STURTEVANT","WIND POINT")

gen vouchermax = .
replace vouchermax = 4984 if year==1999
replace vouchermax = 5326 if year==2000
replace vouchermax = 5553 if year==2001
replace vouchermax = 5783 if year==2002
replace vouchermax = 5783 if year==2003
replace vouchermax = 5943 if year==2004
replace vouchermax = 6351 if year==2005
replace vouchermax = 6501 if year==2006
replace vouchermax = 6501 if year==2007
replace vouchermax = 6607 if year==2008
replace vouchermax = 6442 if year==2009
replace vouchermax = 6442 if year==2010
replace vouchermax = 6442 if year==2011
replace vouchermax = 6442 if year==2012
gen r_vouchermax = vouchermax/cpiu14

gen eligfam1st_count = fpl175count
replace eligfam1st_count = fpl220count if year>=2006
replace eligfam1st_count = fpl300count if year>=2011
replace eligfam1st_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
gen pvr = (eligfam1st_count*r_vouchermax)/1000

foreach var in cont progrev totrev totrev2 exps {
	replace `var' = `var'/1000
	gen r`var' = `var'/cpiu14
}

gen i_rmedhhinc = i_medhhinc/cpiu14
gen i_rmedfaminc = i_medfaminc/cpiu14

gen i_educ_lths = i_educ_lt9 + i_educ_somehs
gen i_educ_socol = i_educ_socolnd + i_educ_assoc
gen i_educ_col = i_educ_bach + i_educ_grad

qui tab ein, gen(E_)
qui tab year, gen(Y_)
forvalues g = 1/647 {
	gen T_`g' = E_`g'*(year-1998)
}

compress
saveold "$data/nccs_analysis_sample.dta", replace










***** NTEE codes S and T
clear *
set more off
set matsize 2000

use "$data/nccs_wi_1999.dta", clear
forvalues y = 2000/2012 {
	append using "$data/nccs_wi_`y'.dta", force
}
sort ein fisyr

keep if inlist(ntee1,"S","T")

bys ein: egen nobs = count(ein)
bys ein: egen minrev = min(totrev)
bys ein: egen minexp = min(exps)

keep if nobs>=10 & minrev>=10000 & minexp>=10000
drop if address==""

saveold "$data/nccs_panel_st.dta", replace

duplicates drop address city zip5, force

gen address2 = address
gen city2 = city

replace address2 = subinstr(address2,"STREET","ST",1)
replace address2 = subinstr(address2,"BOULEVARD","BLVD",1)
replace address2 = subinstr(address2,"PLZ","PLAZA",1)
replace address2 = subinstr(address2,"PLAZZA","PLAZA",1)
replace address2 = subinstr(address2,"ROAD","RD",1)
replace address2 = subinstr(address2,"AVENUE","AVE",1)
replace address2 = subinstr(address2,"PLACE","PL",1)
replace address2 = subinstr(address2,"DRIVE","DR",1)
replace address2 = subinstr(address2,"PARKWAY","PKWY",1)
replace address2 = subinstr(address2,"HIGHWAY","HWY",1)
replace address2 = subinstr(address2,"TRAIL","TRL",1)
replace address2 = subinstr(address2,"LANE","LN",1)
replace address2 = subinstr(address2,"COURT","CT",1)
replace address2 = subinstr(address2,"MOUNT ","MT ",1)

replace address2 = subinstr(address2,"SUITE","STE",1)

replace address2 = subinstr(address2,"NORTH","N",1)
replace address2 = subinstr(address2,"SOUTH","S",1)
replace address2 = subinstr(address2,"EAST","E",1)
replace address2 = subinstr(address2,"WEST","W",1)

replace address2 = subinstr(address2,"P O BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\.O\. BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\. O\. BOX","PO BOX",1)

replace city2 = subinstr(city2,"ADDLETON","APPLETON",1)
replace city2 = subinstr(city2,"ALQOMA","ALGOMA",1)
replace city2 = subinstr(city2,"AMERV","AMERY",1)
replace city2 = subinstr(city2,"ANTILO","ANTIGO",1)
replace city2 = subinstr(city2,"BAILEYS HBR","BAILEYS HARBOR",1)
replace city2 = subinstr(city2,"BLK RIVER FLS","BLACK RIVER FALLS",1)
replace city2 = subinstr(city2,"BTE DES MORTS","BUTTE DES MORTS",1)
replace city2 = subinstr(city2,"BLANCHARDVLLE","BLANCHARDVILLE",1)
replace city2 = subinstr(city2,"CHIDDEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"CHIPPEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"DESOTO","DE SOTO",1)
replace city2 = subinstr(city2,"DURAUD","DURAND",1)
replace city2 = subinstr(city2,"E TROY","EAST TROY",1)
replace city2 = subinstr(city2,"EAU CIAIRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EAU CLALRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EGHRAIM","EPHRAIM",1)
replace city2 = subinstr(city2,"FENNIMORE MONTFORT","MONTFORT",1)
replace city2 = subinstr(city2,"FON DU LAC","FOND DU LAC",1)
replace city2 = subinstr(city2,"FR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"GRANDSBURG","GRANTSBURG",1)
replace city2 = subinstr(city2,"GREEN BAV","GREEN BAY",1)
replace city2 = subinstr(city2,"GREEN BAY WI","GREEN BAY",1)
replace city2 = subinstr(city2,"KOBLER","KOHLER",1)
replace city2 = subinstr(city2,"LACROSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LACOSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"HIHILLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"IPLATTEVILLE","PLATTEVILLE",1)
replace city2 = subinstr(city2,"LAC DU FLAMBU","LAC DU FLAMBEAU",1)
replace city2 = subinstr(city2,"MADIWON","MADISON",1)
replace city2 = subinstr(city2,"MADLSON","MADISON",1)
replace city2 = subinstr(city2,"MANTOWOC","MANITOWOC",1)
replace city2 = subinstr(city2,"MARSHFIEID","MARSHFIELD",1)
replace city2 = subinstr(city2,"MEANSHA","MENASHA",1)
replace city2 = subinstr(city2,"MENOMONEE FAILS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONEE FLS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONLE","MENOMONIE",1)
replace city2 = subinstr(city2,"MIDISON","MADISON",1)
replace city2 = subinstr(city2,"MILWAUKEEM","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWUAKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MIWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKIE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLILWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLLWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKEEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MOUNT CALVARY","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVARV","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVERY","MT CALVARY",1)
replace city2 = subinstr(city2,"MONFORT","MONTFORT",1)
replace city2 = subinstr(city2,"MONONA BRANCH","MONONA",1)
replace city2 = subinstr(city2,"MOUNT HOREB","MT HOREB",1)
replace city2 = subinstr(city2,"MUKWANAGO","MUKWONAGO",1)
replace city2 = subinstr(city2,"NELLLSVILLE","NEILLSVILLE",1)
replace city2 = subinstr(city2,"PHYMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PLEASANT PR","PLEASANT PRAIRIE",1)
replace city2 = subinstr(city2,"PLVMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PR DU CHIEN","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PRAIRIE DU CHIEM","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRAIRIEDUSAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRT WASHINGTN","PORT WASHINGTON",1)
replace city2 = subinstr(city2,"RACTNE","RACINE",1)
replace city2 = subinstr(city2,"RECINE","RACINE",1)
replace city2 = subinstr(city2,"RHINEIANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RHINLANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RICHLAND CTR","RICHLAND CENTER",1)
replace city2 = subinstr(city2,"RIVER","RIVER FALLS",1)
replace city2 = subinstr(city2,"S MILWAUKEE","SOUTH MILWAUKEE",1)
replace city2 = subinstr(city2,"SHEBOUYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOVAAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYOAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYGAN FLS","SHEBOYGAN FALLS",1)
replace city2 = subinstr(city2,"SLINAER","SLINGER",1)
replace city2 = subinstr(city2,"SOLDIER GROVE","SOLDIERS GROVE",1)
replace city2 = subinstr(city2,"ST CROIX FLS","ST CROIX FALLS",1)
replace city2 = subinstr(city2,"STOUGMON","STOUGHTON",1)
replace city2 = subinstr(city2,"STURAEON BAV","STURGEON BAY",1)
replace city2 = subinstr(city2,"SUEPRIOR","SUPERIOR",1)
replace city2 = subinstr(city2,"VIROQUA WI","VIROQUA",1)
replace city2 = subinstr(city2,"VLAYVME","MAYVILLE",1)
replace city2 = subinstr(city2,"W ALLIS","WEST ALLIS",1)
replace city2 = subinstr(city2,"W BEND","WEST BEND",1)
replace city2 = subinstr(city2,"W LAKE","WEST LAKE",1)
replace city2 = subinstr(city2,"W SALEM","WEST SALEM",1)
replace city2 = subinstr(city2,"W WATERTOWN PLANK","WEST WATERTOWN PLANK",1)
replace city2 = subinstr(city2,"WASHINGTON IS","WASHINGTON ISLAND",1)
replace city2 = subinstr(city2,"WATEROWN","WATERTOWN",1)
replace city2 = subinstr(city2,"WAUGACA","WAUPACA",1)
replace city2 = subinstr(city2,"WIS DELLS","WISCONSIN DELLS",1)
replace city2 = subinstr(city2,"WISC DELLS","WISCONSIN DELLS",1)
replace city2 = subinstr(city2,"WIR RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WIS RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WISC RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WSCONSIN RAPIDS","WISCONSIN RAPIDS",1)

saveold "$data/nccs_raw_addresses_st.dta", replace

keep ein fisyr name state address2 city2 state zip5
duplicates drop address2 city2 zip5, force
gen fulladdr = address2 + ", " + city2 + " " + zip5 + ", WI, USA"

saveold "$data/nccs_clean_addresses_st.dta", replace

use "$data/nccs_clean_addresses_st.dta", clear

opencagegeo, key(5bdacdfad0444e27bda5a6e3190a8d10) fulladdress(fulladdr)

saveold "$data/nccs_latlon_st.dta", replace

use "$data/nccs_raw_addresses_st.dta", clear
merge m:1 address2 city2 zip5 using "$data/nccs_latlon_st.dta", keepusing(g_lat g_lon city2)
drop _m
tempfile temp
saveold `temp'

use "$data/nccs_panel_st.dta", clear
merge m:1 address city zip5 using `temp', keepusing(g_lat g_lon city2)
drop _m
sort ein fisyr
saveold "$data/nccs_panel_latlon_st.dta", replace





clear *
set more off
set matsize 2000

use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
keep if year==2000
tempfile fpl2000
save `fpl2000'

foreach year in 2000 2009 2010 2011 2012 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

use "$data/nccs_panel_latlon_st.dta", clear

keep ein fisyr name state ntee1 nteecc address city city2 zip zip5 fips taxper cont progrev totrev totrev2 exps g_lat g_lon
rename (g_lat g_lon) (lat lon)

duplicates drop ein taxper lat lon cont progrev totrev totrev2 exps, force

gen taxper_y = substr(taxper,1,4)
gen taxper_m = substr(taxper,5,2)
destring taxper_y, replace
destring taxper_m, replace
destring fisyr, replace
destring lat, replace
destring lon, replace
gen year = taxper_y if taxper_m==12
replace year = taxper_y - 1 if taxper_m<12
replace year = fisyr - 1 if year==.

merge m:1 year using "$data/prices.dta"
drop if _m==2
drop _m

gen id1 = ein + "-" + taxper

gen pobox = (strpos(address," BOX ")>0)
bys ein taxper: egen totpobox = sum(pobox)
egen einn = group(ein)
bys ein taxper: egen totobs = count(einn)
drop einn

drop if pobox==1 & totpobox<totobs

sort ein taxper exps
by ein taxper: keep if _n==_N

isid id1

tempfile temp
save `temp'

geonear id1 lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
rename id id2
merge m:1 id2 using `fpl2000'
drop if _m==2
drop _m

collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(id1 year)
saveold "$data/wisconsin_nccs_st_fpl_1miles_faminc_famtype.dta", replace

foreach year in 2000 2009 2010 2011 2012 {
	use `temp', clear
	if `year'<=2009 {
		geonear id lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id lat lon using `tracts2010', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		save `near`year''
	}
	
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* [fw=pop_all], by(id1 year)
	tempfile means`year'
	save `means`year''
}

use `means2000', clear
foreach year in 2009 2010 2011 2012 {
	append using `means`year''
}
saveold "$data/wisconsin_nccs_st_covars_1miles.dta", replace

foreach file in covars_1miles {
	use "$data/wisconsin_nccs_st_`file'.dta", clear
	
	egen id3 = group(id1)
	tsset id3 year
	tsfill
	by id3: egen idfill = mode(id1)
	replace id1 = idfill if id1==""
	drop idfill
	
	qui ds
	local allvars = r(varlist)
	local exclude id1 year
	local vars: list allvars - exclude
	disp "`vars'"

	foreach var in `vars' {
		bys id1: ipolate `var' year, generate(i_`var')
	}
	drop `vars'
	sort id1 year
	saveold "$data/wisconsin_nccs_st_`file'_interp.dta", replace
}

use `temp', clear
merge 1:1 id1 using "$data/wisconsin_nccs_st_fpl_1miles_faminc_famtype.dta"
drop if _m==2
drop _m

merge 1:1 id1 year using "$data/wisconsin_nccs_st_covars_1miles_interp.dta"
drop if _m==2
drop _m

gen milwaukee = city2=="MILWAUKEE"
gen racine = inlist(city2,"RACINE","CALEDONIA","ELMWOOD PARK","MT PLEASANT","NORTH BAY","STURTEVANT","WIND POINT")

gen vouchermax = .
replace vouchermax = 4984 if year==1999
replace vouchermax = 5326 if year==2000
replace vouchermax = 5553 if year==2001
replace vouchermax = 5783 if year==2002
replace vouchermax = 5783 if year==2003
replace vouchermax = 5943 if year==2004
replace vouchermax = 6351 if year==2005
replace vouchermax = 6501 if year==2006
replace vouchermax = 6501 if year==2007
replace vouchermax = 6607 if year==2008
replace vouchermax = 6442 if year==2009
replace vouchermax = 6442 if year==2010
replace vouchermax = 6442 if year==2011
replace vouchermax = 6442 if year==2012
gen r_vouchermax = vouchermax/cpiu14

gen eligfam1st_count = fpl175count
replace eligfam1st_count = fpl220count if year>=2006
replace eligfam1st_count = fpl300count if year>=2011
replace eligfam1st_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
gen pvr = (eligfam1st_count*r_vouchermax)/1000

foreach var in cont progrev totrev totrev2 exps {
	replace `var' = `var'/1000
	gen r`var' = `var'/cpiu14
}

gen i_rmedhhinc = i_medhhinc/cpiu14
gen i_rmedfaminc = i_medfaminc/cpiu14

gen i_educ_lths = i_educ_lt9 + i_educ_somehs
gen i_educ_socol = i_educ_socolnd + i_educ_assoc
gen i_educ_col = i_educ_bach + i_educ_grad

qui tab ein, gen(E_ST)
qui tab year, gen(Y_ST)
forvalues g = 1/426 {
	gen T_ST`g' = E_ST`g'*(year-1998)
}

compress
saveold "$data/nccs_st_analysis_sample.dta", replace










***** NTEE codes Hi, I, K, M, Q, R, U, V, W, Y, Z
sysdir set PERSONAL "H:/ado"
set scheme cea, perm

clear *
set more off
set matsize 2000

global data "H:/Milwaukee Vouchers/Data"
global logs "H:/Milwaukee Vouchers/Logs"
global output "H:/Milwaukee Vouchers/Output/ReStat RR"
global scripts "H:/Milwaukee Vouchers/Scripts"

use "$data/nccs_wi_1999.dta", clear
forvalues y = 2000/2012 {
	append using "$data/nccs_wi_`y'.dta", force
}
sort ein fisyr

keep if inlist(ntee1,"H","I","K","M") | inlist(ntee1,"Q","R","U","V") | inlist(ntee1,"W","Y","Z")

bys ein: egen nobs = count(ein)
bys ein: egen minrev = min(totrev)
bys ein: egen minexp = min(exps)

keep if nobs>=10 & minrev>=10000 & minexp>=10000
drop if address==""

saveold "$data/nccs_panel_small.dta", replace

duplicates drop address city zip5, force

gen address2 = address
gen city2 = city

replace address2 = subinstr(address2,"STREET","ST",1)
replace address2 = subinstr(address2,"BOULEVARD","BLVD",1)
replace address2 = subinstr(address2,"PLZ","PLAZA",1)
replace address2 = subinstr(address2,"PLAZZA","PLAZA",1)
replace address2 = subinstr(address2,"ROAD","RD",1)
replace address2 = subinstr(address2,"AVENUE","AVE",1)
replace address2 = subinstr(address2,"PLACE","PL",1)
replace address2 = subinstr(address2,"DRIVE","DR",1)
replace address2 = subinstr(address2,"PARKWAY","PKWY",1)
replace address2 = subinstr(address2,"HIGHWAY","HWY",1)
replace address2 = subinstr(address2,"TRAIL","TRL",1)
replace address2 = subinstr(address2,"LANE","LN",1)
replace address2 = subinstr(address2,"COURT","CT",1)
replace address2 = subinstr(address2,"MOUNT ","MT ",1)

replace address2 = subinstr(address2,"SUITE","STE",1)

replace address2 = subinstr(address2,"NORTH","N",1)
replace address2 = subinstr(address2,"SOUTH","S",1)
replace address2 = subinstr(address2,"EAST","E",1)
replace address2 = subinstr(address2,"WEST","W",1)

replace address2 = subinstr(address2,"P O BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\.O\. BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\. O\. BOX","PO BOX",1)

replace city2 = subinstr(city2,"ADDLETON","APPLETON",1)
replace city2 = subinstr(city2,"ALQOMA","ALGOMA",1)
replace city2 = subinstr(city2,"AMERV","AMERY",1)
replace city2 = subinstr(city2,"ANTILO","ANTIGO",1)
replace city2 = subinstr(city2,"BAILEYS HBR","BAILEYS HARBOR",1)
replace city2 = subinstr(city2,"BLK RIVER FLS","BLACK RIVER FALLS",1)
replace city2 = subinstr(city2,"BALCK RIVER FALLS FALLS","BLACK RIVER FALLS",1)
replace city2 = subinstr(city2,"BTE DES MORTS","BUTTE DES MORTS",1)
replace city2 = subinstr(city2,"BLANCHARDVLLE","BLANCHARDVILLE",1)
replace city2 = subinstr(city2,"BROOKFLELD","BROOKFIELD",1)
replace city2 = subinstr(city2,"CHIDDEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"CHIPPEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"DESOTO","DE SOTO",1)
replace city2 = subinstr(city2,"DURAUD","DURAND",1)
replace city2 = subinstr(city2,"E TROY","EAST TROY",1)
replace city2 = subinstr(city2,"EAU CIAIRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EAU CLALRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EGHRAIM","EPHRAIM",1)
replace city2 = subinstr(city2,"FENNIMORE MONTFORT","MONTFORT",1)
replace city2 = subinstr(city2,"FON DU LAC","FOND DU LAC",1)
replace city2 = subinstr(city2,"FR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"GRANDSBURG","GRANTSBURG",1)
replace city2 = subinstr(city2,"GREEN BAV","GREEN BAY",1)
replace city2 = subinstr(city2,"GREEN BQY","GREEN BAY",1)
replace city2 = subinstr(city2,"GREEN BAY WI","GREEN BAY",1)
replace city2 = subinstr(city2,"KOBLER","KOHLER",1)
replace city2 = subinstr(city2,"LACROSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LACOSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"HIHILLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"IPLATTEVILLE","PLATTEVILLE",1)
replace city2 = subinstr(city2,"LAC DU FLAMBU","LAC DU FLAMBEAU",1)
replace city2 = subinstr(city2,"LK GENEVA","LAKE GENEVA",1)
replace city2 = subinstr(city2,"MADIWON","MADISON",1)
replace city2 = subinstr(city2,"MADLSON","MADISON",1)
replace city2 = subinstr(city2,"MANTOWOC","MANITOWOC",1)
replace city2 = subinstr(city2,"MARSHFIEID","MARSHFIELD",1)
replace city2 = subinstr(city2,"MEANSHA","MENASHA",1)
replace city2 = subinstr(city2,"MENOMONEE FAILS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONEE FLS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONLE","MENOMONIE",1)
replace city2 = subinstr(city2,"MENAMONIE","MENOMONIE",1)
replace city2 = subinstr(city2,"MIDISON","MADISON",1)
replace city2 = subinstr(city2,"MILWAUKEEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKEEM","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWUAKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MIWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKIE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLILWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLLWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKEEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MOUNT CALVARY","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVARV","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVERY","MT CALVARY",1)
replace city2 = subinstr(city2,"MONFORT","MONTFORT",1)
replace city2 = subinstr(city2,"MONONA BRANCH","MONONA",1)
replace city2 = subinstr(city2,"MOUNT HOREB","MT HOREB",1)
replace city2 = subinstr(city2,"MUKWANAGO","MUKWONAGO",1)
replace city2 = subinstr(city2,"NELLLSVILLE","NEILLSVILLE",1)
replace city2 = subinstr(city2,"NEERAH","NEENAH",1)
replace city2 = subinstr(city2,"PHYMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PLEASANT PR","PLEASANT PRAIRIE",1)
replace city2 = subinstr(city2,"PLVMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PR DU CHIEN","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PRAIRIE DU CHIEM","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRAIRIEDUSAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRT WASHINGTN","PORT WASHINGTON",1)
replace city2 = subinstr(city2,"RACTNE","RACINE",1)
replace city2 = subinstr(city2,"RECINE","RACINE",1)
replace city2 = subinstr(city2,"RHINEIANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RHINLANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RICHLAND CTR","RICHLAND CENTER",1)
replace city2 = subinstr(city2,"RIVER","RIVER FALLS",1)
replace city2 = subinstr(city2,"RIVER FALLS FALLS","RIVER FALLS",1)
replace city2 = subinstr(city2,"S MILWAUKEE","SOUTH MILWAUKEE",1)
replace city2 = subinstr(city2,"SHEBOUYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOVAAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYOAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYGAN FLS","SHEBOYGAN FALLS",1)
replace city2 = subinstr(city2,"SLINAER","SLINGER",1)
replace city2 = subinstr(city2,"SOLDIER GROVE","SOLDIERS GROVE",1)
replace city2 = subinstr(city2,"ST CROIX FLS","ST CROIX FALLS",1)
replace city2 = subinstr(city2,"STOUGMON","STOUGHTON",1)
replace city2 = subinstr(city2,"STOUAHTON","STOUGHTON",1)
replace city2 = subinstr(city2,"STURAEON BAV","STURGEON BAY",1)
replace city2 = subinstr(city2,"SUEPRIOR","SUPERIOR",1)
replace city2 = subinstr(city2,"TWO RIVER FALLSS","TWO RIVER FALLS",1)
replace city2 = subinstr(city2,"VIROQUA WI","VIROQUA",1)
replace city2 = subinstr(city2,"VLAYVME","MAYVILLE",1)
replace city2 = subinstr(city2,"WARREN","WARRENS",1)
replace city2 = subinstr(city2,"WARRENSS","WARRENS",1)
replace city2 = subinstr(city2,"W ALLIS","WEST ALLIS",1)
replace city2 = subinstr(city2,"W BEND","WEST BEND",1)
replace city2 = subinstr(city2,"W LAKE","WEST LAKE",1)
replace city2 = subinstr(city2,"W SALEM","WEST SALEM",1)
replace city2 = subinstr(city2,"W WATERTOWN PLANK","WEST WATERTOWN PLANK",1)
replace city2 = subinstr(city2,"WASHINGTON IS","WASHINGTON ISLAND",1)
replace city2 = subinstr(city2,"WATEROWN","WATERTOWN",1)
replace city2 = subinstr(city2,"WAUGACA","WAUPACA",1)
replace city2 = subinstr(city2,"WIS DELLS","WISCONSIN DELLS",1)
replace city2 = subinstr(city2,"WISC DELLS","WISCONSIN DELLS",1)
replace city2 = subinstr(city2,"WIR RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WIS RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WISC RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WSCONSIN RAPIDS","WISCONSIN RAPIDS",1)

saveold "$data/nccs_raw_addresses_small.dta", replace

keep ein fisyr name state address2 city2 state zip5
duplicates drop address2 city2 zip5, force
gen fulladdr = address2 + ", " + city2 + " " + zip5 + ", WI, USA"

saveold "$data/nccs_clean_addresses_small.dta", replace

use "$data/nccs_clean_addresses_small.dta", clear

opencagegeo, key(5bdacdfad0444e27bda5a6e3190a8d10) fulladdress(fulladdr)

saveold "$data/nccs_latlon_small.dta", replace

use "$data/nccs_raw_addresses_small.dta", clear
merge m:1 address2 city2 zip5 using "$data/nccs_latlon_small.dta", keepusing(g_lat g_lon city2)
drop _m
tempfile temp
saveold `temp'

use "$data/nccs_panel_small.dta", clear
merge m:1 address city zip5 using `temp', keepusing(g_lat g_lon city2)
drop _m
sort ein fisyr
saveold "$data/nccs_panel_latlon_small.dta", replace





clear *
set more off
set matsize 2000

use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
saveold `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
saveold `tracts2010'

use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
keep if year==2000
tempfile fpl2000
saveold `fpl2000'

foreach year in 2000 2009 2010 2011 2012 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	saveold `covars`year''
}

use "$data/nccs_panel_latlon_small.dta", clear

keep ein fisyr name state ntee1 nteecc address city city2 zip zip5 fips taxper cont progrev totrev totrev2 exps g_lat g_lon
rename (g_lat g_lon) (lat lon)

duplicates drop ein taxper lat lon cont progrev totrev totrev2 exps, force

gen taxper_y = substr(taxper,1,4)
gen taxper_m = substr(taxper,5,2)
destring taxper_y, replace
destring taxper_m, replace
destring fisyr, replace
destring lat, replace
destring lon, replace
gen year = taxper_y if taxper_m==12
replace year = taxper_y - 1 if taxper_m<12
replace year = fisyr - 1 if year==.

merge m:1 year using "$data/prices.dta"
drop if _m==2
drop _m

gen id1 = ein + "-" + taxper

gen pobox = (strpos(address," BOX ")>0)
bys ein taxper: egen totpobox = sum(pobox)
bys ein taxper: egen totobs = count(ein)

drop if pobox==1 & totpobox<totobs

sort ein taxper exps
by ein taxper: keep if _n==_N

isid id1

tempfile temp
saveold `temp'

geonear id1 lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
rename id id2
merge m:1 id2 using `fpl2000'
drop if _m==2
drop _m

collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(id1 year)
saveold "$data/wisconsin_nccs_small_fpl_1miles_faminc_famtype.dta", replace

foreach year in 2000 2009 2010 2011 2012 {
	use `temp', clear
	if `year'<=2009 {
		geonear id lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		saveold `near`year''
	}
	if `year'>=2010 {
		geonear id lat lon using `tracts2010', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		saveold `near`year''
	}
	
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* [fw=pop_all], by(id1 year)
	tempfile means`year'
	saveold `means`year''
}

use `means2000', clear
foreach year in 2009 2010 2011 2012 {
	append using `means`year''
}
saveold "$data/wisconsin_nccs_small_covars_1miles.dta", replace

foreach file in covars_1miles {
	use "$data/wisconsin_nccs_small_`file'.dta", clear
	
	egen id3 = group(id1)
	tsset id3 year
	tsfill
	by id3: egen idfill = mode(id1)
	replace id1 = idfill if id1==""
	drop idfill
	
	qui ds
	local allvars = r(varlist)
	local exclude id1 year
	local vars: list allvars - exclude
	disp "`vars'"

	foreach var in `vars' {
		bys id1: ipolate `var' year, generate(i_`var')
	}
	drop `vars'
	sort id1 year
	saveold "$data/wisconsin_nccs_small_`file'_interp.dta", replace
}

use `temp', clear
merge 1:1 id1 using "$data/wisconsin_nccs_small_fpl_1miles_faminc_famtype.dta"
drop if _m==2
drop _m

merge 1:1 id1 year using "$data/wisconsin_nccs_small_covars_1miles_interp.dta"
drop if _m==2
drop _m

gen milwaukee = city2=="MILWAUKEE"
gen racine = inlist(city2,"RACINE","CALEDONIA","ELMWOOD PARK","MT PLEASANT","NORTH BAY","STURTEVANT","WIND POINT")

gen vouchermax = .
replace vouchermax = 4984 if year==1999
replace vouchermax = 5326 if year==2000
replace vouchermax = 5553 if year==2001
replace vouchermax = 5783 if year==2002
replace vouchermax = 5783 if year==2003
replace vouchermax = 5943 if year==2004
replace vouchermax = 6351 if year==2005
replace vouchermax = 6501 if year==2006
replace vouchermax = 6501 if year==2007
replace vouchermax = 6607 if year==2008
replace vouchermax = 6442 if year==2009
replace vouchermax = 6442 if year==2010
replace vouchermax = 6442 if year==2011
replace vouchermax = 6442 if year==2012
gen r_vouchermax = vouchermax/cpiu14

gen eligfam1st_count = fpl175count
replace eligfam1st_count = fpl220count if year>=2006
replace eligfam1st_count = fpl300count if year>=2011
replace eligfam1st_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
gen pvr = (eligfam1st_count*r_vouchermax)/1000

foreach var in cont progrev totrev totrev2 exps {
	replace `var' = `var'/1000
	gen r`var' = `var'/cpiu14
}

gen i_rmedhhinc = i_medhhinc/cpiu14
gen i_rmedfaminc = i_medfaminc/cpiu14

gen i_educ_lths = i_educ_lt9 + i_educ_somehs
gen i_educ_socol = i_educ_socolnd + i_educ_assoc
gen i_educ_col = i_educ_bach + i_educ_grad

qui tab ein, gen(E_SML)
qui tab year, gen(Y_SML)
forvalues g = 1/307 {
	gen T_SML`g' = E_SML`g'*(year-1998)
}

compress
saveold "$data/nccs_small_analysis_sample.dta", replace










***** NTEE codes B and X
clear *
set more off
set matsize 2000

use "$data/nccs_wi_1999.dta", clear
forvalues y = 2000/2012 {
	append using "$data/nccs_wi_`y'.dta", force
}
sort ein fisyr

keep if inlist(ntee1,"B","X")

egen einn = group(ein)
bys ein: egen nobs = count(einn)
drop einn
bys ein: egen minrev = min(totrev)
bys ein: egen minexp = min(exps)

keep if nobs>=10 & minrev>=10000 & minexp>=10000
drop if address==""

saveold "$data/nccs_panel_bx.dta", replace

duplicates drop address city zip5, force

gen address2 = address
gen city2 = city

replace address2 = subinstr(address2,"STREET","ST",1)
replace address2 = subinstr(address2,"BOULEVARD","BLVD",1)
replace address2 = subinstr(address2,"PLZ","PLAZA",1)
replace address2 = subinstr(address2,"PLAZZA","PLAZA",1)
replace address2 = subinstr(address2,"ROAD","RD",1)
replace address2 = subinstr(address2,"AVENUE","AVE",1)
replace address2 = subinstr(address2,"PLACE","PL",1)
replace address2 = subinstr(address2,"DRIVE","DR",1)
replace address2 = subinstr(address2,"PARKWAY","PKWY",1)
replace address2 = subinstr(address2,"HIGHWAY","HWY",1)
replace address2 = subinstr(address2,"TRAIL","TRL",1)
replace address2 = subinstr(address2,"LANE","LN",1)
replace address2 = subinstr(address2,"COURT","CT",1)
replace address2 = subinstr(address2,"MOUNT ","MT ",1)

replace address2 = subinstr(address2,"SUITE","STE",1)

replace address2 = subinstr(address2,"NORTH","N",1)
replace address2 = subinstr(address2,"SOUTH","S",1)
replace address2 = subinstr(address2,"EAST","E",1)
replace address2 = subinstr(address2,"WEST","W",1)

replace address2 = subinstr(address2,"P O BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\.O\. BOX","PO BOX",1)
replace address2 = subinstr(address2,"P\. O\. BOX","PO BOX",1)

replace city2 = subinstr(city2,"ADDLETON","APPLETON",1)
replace city2 = subinstr(city2,"ALCOMA","ALGOMA",1)
replace city2 = subinstr(city2,"ALQOMA","ALGOMA",1)
replace city2 = subinstr(city2,"AMERV","AMERY",1)
replace city2 = subinstr(city2,"ANTILO","ANTIGO",1)
replace city2 = subinstr(city2,"APPELTON","APPLETON",1)
replace city2 = subinstr(city2,"BAILEYS HBR","BAILEYS HARBOR",1)
replace city2 = subinstr(city2,"BLK RIVER FLS","BLACK RIVER FALLS",1)
replace city2 = subinstr(city2,"BLACK RIVER FALLS FALLS","BLACK RIVER FALLS",1)
replace city2 = subinstr(city2,"BTE DES MORTS","BUTTE DES MORTS",1)
replace city2 = subinstr(city2,"BLANCHARDVLLE","BLANCHARDVILLE",1)
replace city2 = subinstr(city2,"BOOKFIELD","BROOKFIELD",1)
replace city2 = subinstr(city2,"BROOKFILED","BROOKFIELD",1)
replace city2 = subinstr(city2,"CAMPBELLSPOINT","CAMPBELLSPORT",1)
replace city2 = subinstr(city2,"CEDARSBURG","CEDARBURG",1)
replace city2 = subinstr(city2,"CHIDDEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"CHIPPEWA FLS","CHIPPEWA FALLS",1)
replace city2 = subinstr(city2,"DEFOREST","DE FOREST",1)
replace city2 = subinstr(city2,"DELFIELD","DELAFIELD",1)
replace city2 = subinstr(city2,"DEPERE","DE PERE",1)
replace city2 = subinstr(city2,"DESOTO","DE SOTO",1)
replace city2 = subinstr(city2,"DODAEVILLE","DODGEVILLE",1)
replace city2 = subinstr(city2,"DURAUD","DURAND",1)
replace city2 = subinstr(city2,"E TROY","EAST TROY",1)
replace city2 = subinstr(city2,"EAU CIAIRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EAU CLALRE","EAU CLAIRE",1)
replace city2 = subinstr(city2,"EGHRAIM","EPHRAIM",1)
replace city2 = subinstr(city2,"FENNIMORE MONTFORT","MONTFORT",1)
replace city2 = subinstr(city2,"FON DU LAC","FOND DU LAC",1)
replace city2 = subinstr(city2,"FT ATKINSON","FORT ATKINSON",1)
replace city2 = subinstr(city2,"FR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"GRANDSBURG","GRANTSBURG",1)
replace city2 = subinstr(city2,"GREEN BAV","GREEN BAY",1)
replace city2 = subinstr(city2,"GREEN BAY WI","GREEN BAY",1)
replace city2 = subinstr(city2,"GREENFIELD WI","GREENFIELD",1)
replace city2 = subinstr(city2,"GREENTIELD","GREENFIELD",1)
replace city2 = subinstr(city2,"KOBLER","KOHLER",1)
replace city2 = subinstr(city2,"KENSCHA","KENOSHA",1)
replace city2 = subinstr(city2,"KENUSHA","KENOSHA",1)
replace city2 = subinstr(city2,"KSUKAUNA","KAUKAUNA",1)
replace city2 = subinstr(city2,"LACROSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LACOSSE","LA CROSSE",1)
replace city2 = subinstr(city2,"LLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"HIHILLSBORO","HILLSBORO",1)
replace city2 = subinstr(city2,"IPLATTEVILLE","PLATTEVILLE",1)
replace city2 = subinstr(city2,"IHEBOYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"LAC DU FLAMBU","LAC DU FLAMBEAU",1)
replace city2 = subinstr(city2,"MADIWON","MADISON",1)
replace city2 = subinstr(city2,"MADLSON","MADISON",1)
replace city2 = subinstr(city2,"MANTOWOC","MANITOWOC",1)
replace city2 = subinstr(city2,"MARSHFIEID","MARSHFIELD",1)
replace city2 = subinstr(city2,"MARSHNELD","MARSHFIELD",1)
replace city2 = subinstr(city2,"MARHSALL","MARSHALL",1)
replace city2 = subinstr(city2,"MC FARLAND","MCFARLAND",1)
replace city2 = subinstr(city2,"MEANSHA","MENASHA",1)
replace city2 = subinstr(city2,"MENOMONEE FAILS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONEE FLS","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMENEE","MENOMONEE FALLS",1)
replace city2 = subinstr(city2,"MENOMONLE","MENOMONIE",1)
replace city2 = subinstr(city2,"MEQUIN","MEQUON",1)
replace city2 = subinstr(city2,"MIDISON","MADISON",1)
replace city2 = subinstr(city2,"MILWAIKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILSWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKEEM","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAULKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUNEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWUAKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MIWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKIE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLILWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MLLWAUKEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MILWAUKEEE","MILWAUKEE",1)
replace city2 = subinstr(city2,"MOUNT CALVARY","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVARV","MT CALVARY",1)
replace city2 = subinstr(city2,"MT CALVERY","MT CALVARY",1)
replace city2 = subinstr(city2,"MONFORT","MONTFORT",1)
replace city2 = subinstr(city2,"MONONA BRANCH","MONONA",1)
replace city2 = subinstr(city2,"MOUNT HOREB","MT HOREB",1)
replace city2 = subinstr(city2,"MUKWANAGO","MUKWONAGO",1)
replace city2 = subinstr(city2,"NELLLSVILLE","NEILLSVILLE",1)
replace city2 = subinstr(city2,"NORTHLAKE","NORTH LAKE",1)
replace city2 = subinstr(city2,"OOSTBURQ","OOSTBURG",1)
replace city2 = subinstr(city2,"PARTA","SPARTA",1)
replace city2 = subinstr(city2,"PHYMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PLEASANT PR","PLEASANT PRAIRIE",1)
replace city2 = subinstr(city2,"PLVMOUTH","PLYMOUTH",1)
replace city2 = subinstr(city2,"PR DU CHIEN","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PRAIRIE DU CHIEM","PRAIRIE DU CHIEN",1)
replace city2 = subinstr(city2,"PR DU SAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRAIRIEDUSAC","PRAIRIE DU SAC",1)
replace city2 = subinstr(city2,"PRT WASHINGTN","PORT WASHINGTON",1)
replace city2 = subinstr(city2,"RACTNE","RACINE",1)
replace city2 = subinstr(city2,"RECINE","RACINE",1)
replace city2 = subinstr(city2,"RANDOLGH","RANDOLPH",1)
replace city2 = subinstr(city2,"RHINEIANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RHINLANDER","RHINELANDER",1)
replace city2 = subinstr(city2,"RICHLAND CTR","RICHLAND CENTER",1)
replace city2 = subinstr(city2,"RIVER","RIVER FALLS",1)
replace city2 = subinstr(city2,"RIVER FALLS FALLS","RIVER FALLS",1)
replace city2 = subinstr(city2,"RIVER FALLS HILLS","RIVER HILLS",1)
replace city2 = subinstr(city2,"RKIOU","BELOIT",1)
replace city2 = subinstr(city2,"SDOONER","SPOONER",1)
replace city2 = subinstr(city2,"S MILWAUKEE","SOUTH MILWAUKEE",1)
replace city2 = subinstr(city2,"SEVMOUR","SEYMOUR",1)
replace city2 = subinstr(city2,"SHEBCYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOUYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOVAAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYOAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYGEN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHELBOYGAN","SHEBOYGAN",1)
replace city2 = subinstr(city2,"SHEBOYGAN FLS","SHEBOYGAN FALLS",1)
replace city2 = subinstr(city2,"SLINAER","SLINGER",1)
replace city2 = subinstr(city2,"SOLDIER GROVE","SOLDIERS GROVE",1)
replace city2 = subinstr(city2,"ST CROIX FLS","ST CROIX FALLS",1)
replace city2 = subinstr(city2,"STOUGMON","STOUGHTON",1)
replace city2 = subinstr(city2,"STURAEON BAV","STURGEON BAY",1)
replace city2 = subinstr(city2,"SUEPRIOR","SUPERIOR",1)
replace city2 = subinstr(city2,"TWD RVNS","TWO RIVERS",1)
replace city2 = subinstr(city2,"TWO RIVER FALLSS","TWO RIVER FALLS",1)
replace city2 = subinstr(city2,"VIROQUA WI","VIROQUA",1)
replace city2 = subinstr(city2,"VLAYVME","MAYVILLE",1)
replace city2 = subinstr(city2,"W ALLIS","WEST ALLIS",1)
replace city2 = subinstr(city2,"W BEND","WEST BEND",1)
replace city2 = subinstr(city2,"W LAKE","WEST LAKE",1)
replace city2 = subinstr(city2,"W SALEM","WEST SALEM",1)
replace city2 = subinstr(city2,"W WATERTOWN PLANK","WEST WATERTOWN PLANK",1)
replace city2 = subinstr(city2,"WASHINGTON IS","WASHINGTON ISLAND",1)
replace city2 = subinstr(city2,"WATEROWN","WATERTOWN",1)
replace city2 = subinstr(city2,"WAUGACA","WAUPACA",1)
replace city2 = subinstr(city2,"WAUKESKA","WAUKESHA",1)
replace city2 = subinstr(city2,"WAUWOTOSA","WAUWATOSA",1)
replace city2 = subinstr(city2,"WILLIAMS BAV","WILLIAMS BAY",1)
replace city2 = subinstr(city2,"WIS DELLS","WISCONSIN DELLS",1)
replace city2 = subinstr(city2,"WISC DELLS","WISCONSIN DELLS",1)
replace city2 = subinstr(city2,"WI RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WIR RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WIS RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WISC RAPIDS","WISCONSIN RAPIDS",1)
replace city2 = subinstr(city2,"WSCONSIN RAPIDS","WISCONSIN RAPIDS",1)

saveold "$data/nccs_raw_addresses_bx.dta", replace

keep ein fisyr name state address2 city2 state zip5
duplicates drop address2 city2 zip5, force
gen fulladdr = address2 + ", " + city2 + " " + zip5 + ", WI, USA"

saveold "$data/nccs_clean_addresses_bx.dta", replace

use "$data/nccs_clean_addresses_bx.dta", clear

opencagegeo, key(e2a58234ed0e46518386435d9ab080bf) fulladdress(fulladdr)

saveold "$data/nccs_latlon_bx.dta", replace

use "$data/nccs_raw_addresses_bx.dta", clear
merge m:1 address2 city2 zip5 using "$data/nccs_latlon_bx.dta", keepusing(g_lat g_lon city2)
drop _m
tempfile temp
saveold `temp'

use "$data/nccs_panel_bx.dta", clear
merge m:1 address city zip5 using `temp', keepusing(g_lat g_lon city2)
drop _m
sort ein fisyr
saveold "$data/nccs_panel_latlon_bx.dta", replace





sysdir set PERSONAL "H:/ado"
set scheme cea, perm

clear *
set more off
set matsize 2000

global data "H:/Milwaukee Vouchers/Data"
global logs "H:/Milwaukee Vouchers/Logs"
global output "H:/Milwaukee Vouchers/Output/ReStat RR"
global scripts "H:/Milwaukee Vouchers/Scripts"

use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
keep if year==2000
tempfile fpl2000
save `fpl2000'

foreach year in 2000 2009 2010 2011 2012 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

use "$data/nccs_panel_latlon_bx.dta", clear

keep ein fisyr name state ntee1 nteecc address city city2 zip zip5 fips taxper cont progrev totrev totrev2 exps g_lat g_lon
rename (g_lat g_lon) (lat lon)

duplicates drop ein taxper lat lon cont progrev totrev totrev2 exps, force

gen taxper_y = substr(taxper,1,4)
gen taxper_m = substr(taxper,5,2)
destring taxper_y, replace
destring taxper_m, replace
destring fisyr, replace
destring lat, replace
destring lon, replace
gen year = taxper_y if taxper_m==12
replace year = taxper_y - 1 if taxper_m<12
replace year = fisyr - 1 if year==.

merge m:1 year using "$data/prices.dta"
drop if _m==2
drop _m

gen id1 = ein + "-" + taxper

gen pobox = (strpos(address," BOX ")>0)
bys ein taxper: egen totpobox = sum(pobox)
egen einn = group(ein)
bys ein taxper: egen totobs = count(einn)
drop einn

drop if pobox==1 & totpobox<totobs

sort ein taxper exps
by ein taxper: keep if _n==_N

isid id1

tempfile temp
save `temp'

geonear id1 lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
rename id id2
merge m:1 id2 using `fpl2000'
drop if _m==2
drop _m

collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(id1 year)
saveold "$data/wisconsin_nccs_bx_fpl_1miles_faminc_famtype.dta", replace

foreach year in 2000 2009 2010 2011 2012 {
	use `temp', clear
	if `year'<=2009 {
		geonear id lat lon using `tracts2000', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id lat lon using `tracts2010', n(id latitude longitude) long within(1) miles
		rename id id2
		tempfile near`year'
		save `near`year''
	}
	
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* [fw=pop_all], by(id1 year)
	tempfile means`year'
	save `means`year''
}

use `means2000', clear
foreach year in 2009 2010 2011 2012 {
	append using `means`year''
}
saveold "$data/wisconsin_nccs_bx_covars_1miles.dta", replace

foreach file in covars_1miles {
	use "$data/wisconsin_nccs_bx_`file'.dta", clear
	
	egen id3 = group(id1)
	tsset id3 year
	tsfill
	by id3: egen idfill = mode(id1)
	replace id1 = idfill if id1==""
	drop idfill
	
	qui ds
	local allvars = r(varlist)
	local exclude id1 year
	local vars: list allvars - exclude
	disp "`vars'"

	foreach var in `vars' {
		bys id1: ipolate `var' year, generate(i_`var')
	}
	drop `vars'
	sort id1 year
	saveold "$data/wisconsin_nccs_bx_`file'_interp.dta", replace
}

use `temp', clear
merge 1:1 id1 using "$data/wisconsin_nccs_bx_fpl_1miles_faminc_famtype.dta"
drop if _m==2
drop _m

merge 1:1 id1 year using "$data/wisconsin_nccs_bx_covars_1miles_interp.dta"
drop if _m==2
drop _m

gen milwaukee = city2=="MILWAUKEE"
gen racine = inlist(city2,"RACINE","CALEDONIA","ELMWOOD PARK","MT PLEASANT","NORTH BAY","STURTEVANT","WIND POINT")

gen vouchermax = .
replace vouchermax = 4984 if year==1999
replace vouchermax = 5326 if year==2000
replace vouchermax = 5553 if year==2001
replace vouchermax = 5783 if year==2002
replace vouchermax = 5783 if year==2003
replace vouchermax = 5943 if year==2004
replace vouchermax = 6351 if year==2005
replace vouchermax = 6501 if year==2006
replace vouchermax = 6501 if year==2007
replace vouchermax = 6607 if year==2008
replace vouchermax = 6442 if year==2009
replace vouchermax = 6442 if year==2010
replace vouchermax = 6442 if year==2011
replace vouchermax = 6442 if year==2012
gen r_vouchermax = vouchermax/cpiu14

gen eligfam1st_count = fpl175count
replace eligfam1st_count = fpl220count if year>=2006
replace eligfam1st_count = fpl300count if year>=2011
replace eligfam1st_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
gen pvr = (eligfam1st_count*r_vouchermax)/1000

foreach var in cont progrev totrev totrev2 exps {
	replace `var' = `var'/1000
	gen r`var' = `var'/cpiu14
}

gen i_rmedhhinc = i_medhhinc/cpiu14
gen i_rmedfaminc = i_medfaminc/cpiu14

gen i_educ_lths = i_educ_lt9 + i_educ_somehs
gen i_educ_socol = i_educ_socolnd + i_educ_assoc
gen i_educ_col = i_educ_bach + i_educ_grad

qui tab ein, gen(E_BX)
qui tab year, gen(Y_BX)
forvalues g = 1/426 {
	gen T_ST`g' = E_BX`g'*(year-1998)
}

compress
saveold "$data/nccs_bx_analysis_sample.dta", replace
