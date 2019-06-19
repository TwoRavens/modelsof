/*Combining household data with may migration data*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using mayhog.log, replace

odbc query "dBASE Files"

local quarters "200 300 400 101 201 301 401 102 202 302 402 103 203 303 403 104 204 304 404"
foreach quarter of local quarters {
	odbc load, table("HOG-`quarter'") dialog(complete) clear
	gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
	sort houseid
	save hog`quarter'm, replace
	count
	use may`quarter', clear
	sort houseid
	drop _merge
	merge houseid using hog`quarter'm, keep(MEN_12 MAY_12 T_RES T_HOG L_VIV VP1 VP2 VP3 VP3_1 VP3_2 VP3_3 VP4 VP4_1 VP4_2 VP5 VP6) uniqusing nokeep
	codebook houseid if _merge == 3
	save mayhog`quarter'm, replace
}

