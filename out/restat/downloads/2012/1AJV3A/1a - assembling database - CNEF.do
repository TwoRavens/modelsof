/*Set memory, etc*/
set more off
clear all 
set mem 50m
/* THIS SECTION DOWNLOADS THE CNEF DATA FROM THE C-DRIVE (FROM CD-ROM) AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

capture program drop cnefYY
program define cnefYY
local i = "`1'"
if `1' == 94 {
local file "kpequiv.dta"
local fileout "19`1' cnef.dta"
}
else if `1' == 95 {
local file "lpequiv.dta"
local fileout "19`1' cnef.dta"
}
else if `1' == 96 {
local file "mpequiv.dta"
local fileout "19`1' cnef.dta"
}
else if `1' == 97 {
local file "npequiv.dta"
local fileout "19`1' cnef.dta"
}
else if `1' == 98 {
local file "opequiv.dta"
local fileout "19`1' cnef.dta"
}
else if `1' == 99 {
local file "ppequiv.dta"
local fileout "19`1' cnef.dta"
}
else if `1' == 00 {
local file "qpequiv.dta"
local fileout "20`1' cnef.dta"
}
else if `1' == 01 {
local file "rpequiv.dta"
local fileout "20`1' cnef.dta"
}
else if `1' == 02 {
local file "spequiv.dta"
local fileout "20`1' cnef.dta"
}
else if `1' == 03 {
local file "tpequiv.dta"
local fileout "20`1' cnef.dta"
}
else if `1' == 04 {
local file "upequiv.dta"
local fileout "20`1' cnef.dta"
}
use hhnr hhnrakt persnr l11101`i'  l11102`i' d11102ll x11104ll  d11101`i' d11103`i' d11104`i' d11105`i' d11106`i' d11107`i' d11108`i' d11109`i' e11102`i' i11101`i' i11102`i' i11103`i'  i11104`i' i11105`i' i11106`i' i11107`i' i11108`i' i11109`i' i11110`i' i11111`i' i11112`i' i11117`i' w11101`i' w11102`i' h11101`i' h11102`i' h11112`i' y11101`i' i11118`i'  e11105`i' e11106`i' using "$datapath\\`file'", clear

rename  hhnr 		hhnum
rename  hhnrakt 	new_hhnum`i'
rename  persnr  	pnum
rename  d11102ll 	gender`i'
rename  x11104ll 	subsample_id`i'
rename   d11101`i' 	age_years`i'
rename  d11103`i' 	race_hhh`i'
rename  d11104`i' 	marital`i'
rename  d11105`i' 	relation_hh`i'
rename  d11106`i' 	people_hh`i'
rename  d11107`i' 	children_hh`i'
rename  d11108`i' 	educ`i'
rename  d11109`i' 	education_years`i'
rename  e11102`i' 	employed`i'
rename  i11101`i' 	hh_y_pregov`i'
rename  i11102`i' 	hh_y_postgov`i'
rename  i11103`i'  	hh_y_labour`i'
rename  i11104`i' 	hh_y_assets`i'
rename  i11105`i' 	hh_imputed_rent`i'
rename  i11106`i' 	hh_priv_trans`i'
rename  i11107`i' 	hh_pub_trans`i'
rename  i11108`i' 	hh_ss_pension`i'
rename  i11109`i' 	hh_tot_taxes`i'
rename  i11110`i' 	cnef_g_income`i'
rename  i11111`i' 	hh_fed_taxes`i'
rename  i11112`i' 	hh_ss_taxes`i'
rename  i11117`i' 	hh_priv_pension`i'
rename  w11101`i'  	per_weight`i'
rename  w11102`i' 	hh_weight`i'
rename  h11101`i' 	kids_014_`i'
rename  h11102`i' 	kids_1518_`i'
rename  h11112`i' 	wife_hh_`i'
rename  i11118`i' 	hh_y_windfall
rename  l11101`i' 	state_`i'
rename  l11102`i' 	region_`i'
rename  e11105`i'	occupation`i'
rename  e11106`i'	occ_industry`i'

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum`i'=hhnum
replace hhnum`i'=new_hhnum`i' if new_hhnum`i'~=hhnum
sort pnum
save "$datapath\GiavazziMcMahonReStat\\`fileout'", replace
end

* NOW TO RUN THE FILE IN A LOOP FOR 1995 to 1999
local j=94
while `j'<=99 {
cnefYY `j'
local j= `j'+1
}
* AND TO RUN IT FOR 2000
cnefYY 00
cnefYY 01
cnefYY 02
cnefYY 03
cnefYY 04
