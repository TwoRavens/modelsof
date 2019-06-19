/*Computing all migration data: temporary, permanent, internal and international*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using maymigrationvariable.log, replace

odbc query "dBASE Files"
odbc load, table("MAY-404") dialog(complete)
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
/*Multinomial classification: 0 for non-movers, 1 for intermunicipal migration, 2 for interstatal migration, 3 for migration to the US, 4 for migration elsewhere, 5 for migration undetermined*/
gen mig404 = 0
replace mig404 = . if nc_res == 9
replace mig404 = 1 if (nc_res == 4 & (real(substr(MIG,1,1)) == 1))
replace mig404 = 2 if (nc_res == 4 & (real(substr(MIG,1,1)) == 2))
replace mig404 = 3 if (nc_res == 4 & (real(MIG) == 334))
replace mig404 = 3 if (nc_res == 4 & (real(MIG) == 335))
replace mig404 = 3 if (nc_res == 4 & (real(MIG) == 339))
replace mig404 = 4 if (nc_res == 4 & (real(MIG) == 336))
replace mig404 = 4 if (nc_res == 4 & (real(MIG) == 337))
replace mig404 = 4 if (nc_res == 4 & (real(MIG) == 338))
replace mig404 = 5 if (nc_res == 4 & (real(MIG) == 399))
replace mig404 = 1 if (nc_res == 8 & (real(substr(MIG,1,1)) == 1))
replace mig404 = 2 if (nc_res == 8 & (real(substr(MIG,1,1)) == 2))
replace mig404 = 3 if (nc_res == 8 & (real(MIG) == 334))
replace mig404 = 3 if (nc_res == 8 & (real(MIG) == 335))
replace mig404 = 3 if (nc_res == 8 & (real(MIG) == 339))
replace mig404 = 4 if (nc_res == 8 & (real(MIG) == 336))
replace mig404 = 4 if (nc_res == 8 & (real(MIG) == 337))
replace mig404 = 4 if (nc_res == 8 & (real(MIG) == 338))
replace mig404 = 5 if (nc_res == 8 & (real(MIG) == 399))

/*Return migration*/
gen retmig404 = 0
replace retmig404 = . if nc_res == 9
replace retmig404 = 1 if (nc_res == 2 & (real(substr(MIG,1,1)) == 1))
replace retmig404 = 2 if (nc_res == 2 & (real(substr(MIG,1,1)) == 2))
replace retmig404 = 3 if (nc_res == 2 & (real(MIG) == 334))
replace retmig404 = 3 if (nc_res == 2 & (real(MIG) == 335))
replace retmig404 = 3 if (nc_res == 2 & (real(MIG) == 339))
replace retmig404 = 4 if (nc_res == 2 & (real(MIG) == 336))
replace retmig404 = 4 if (nc_res == 2 & (real(MIG) == 337))
replace retmig404 = 4 if (nc_res == 2 & (real(MIG) == 338))
replace retmig404 = 5 if (nc_res == 2 & (real(MIG) == 399))

sort personid
save may404, replace

odbc load, table("MAY-304") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen mig304 = 0
replace mig304 = . if nc_res == 9
replace mig304 = 1 if (nc_res == 4 & (real(substr(MIG,1,1)) == 1))
replace mig304 = 2 if (nc_res == 4 & (real(substr(MIG,1,1)) == 2))
replace mig304 = 3 if (nc_res == 4 & (real(MIG) == 334))
replace mig304 = 3 if (nc_res == 4 & (real(MIG) == 335))
replace mig304 = 3 if (nc_res == 4 & (real(MIG) == 339))
replace mig304 = 4 if (nc_res == 4 & (real(MIG) == 336))
replace mig304 = 4 if (nc_res == 4 & (real(MIG) == 337))
replace mig304 = 4 if (nc_res == 4 & (real(MIG) == 338))
replace mig304 = 5 if (nc_res == 4 & (real(MIG) == 399))
replace mig304 = 1 if (nc_res == 8 & (real(substr(MIG,1,1)) == 1))
replace mig304 = 2 if (nc_res == 8 & (real(substr(MIG,1,1)) == 2))
replace mig304 = 3 if (nc_res == 8 & (real(MIG) == 334))
replace mig304 = 3 if (nc_res == 8 & (real(MIG) == 335))
replace mig304 = 3 if (nc_res == 8 & (real(MIG) == 339))
replace mig304 = 4 if (nc_res == 8 & (real(MIG) == 336))
replace mig304 = 4 if (nc_res == 8 & (real(MIG) == 337))
replace mig304 = 4 if (nc_res == 8 & (real(MIG) == 338))
replace mig304 = 5 if (nc_res == 8 & (real(MIG) == 399))
gen retmig304 = 0
replace retmig304 = . if nc_res == 9
replace retmig304 = 1 if (nc_res == 2 & (real(substr(MIG,1,1)) == 1))
replace retmig304 = 2 if (nc_res == 2 & (real(substr(MIG,1,1)) == 2))
replace retmig304 = 3 if (nc_res == 2 & (real(MIG) == 334))
replace retmig304 = 3 if (nc_res == 2 & (real(MIG) == 335))
replace retmig304 = 3 if (nc_res == 2 & (real(MIG) == 339))
replace retmig304 = 4 if (nc_res == 2 & (real(MIG) == 336))
replace retmig304 = 4 if (nc_res == 2 & (real(MIG) == 337))
replace retmig304 = 4 if (nc_res == 2 & (real(MIG) == 338))
replace retmig304 = 5 if (nc_res == 2 & (real(MIG) == 399))
merge personid using may404, keep(mig404 retmig404) unique nokeep
gen mig = mig404
replace mig = . if mig304 > 0
replace mig = . if mig304 == . 
destring FAC, replace
sort personid
save may304, replace

odbc load, table("MAY-204") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen mig204 = 0
replace mig204 = . if nc_res == 9
replace mig204 = 1 if (nc_res == 4 & (real(substr(MIG,1,1)) == 1))
replace mig204 = 2 if (nc_res == 4 & (real(substr(MIG,1,1)) == 2))
replace mig204 = 3 if (nc_res == 4 & (real(MIG) == 334))
replace mig204 = 3 if (nc_res == 4 & (real(MIG) == 335))
replace mig204 = 3 if (nc_res == 4 & (real(MIG) == 339))
replace mig204 = 4 if (nc_res == 4 & (real(MIG) == 336))
replace mig204 = 4 if (nc_res == 4 & (real(MIG) == 337))
replace mig204 = 4 if (nc_res == 4 & (real(MIG) == 338))
replace mig204 = 5 if (nc_res == 4 & (real(MIG) == 399))
replace mig204 = 1 if (nc_res == 8 & (real(substr(MIG,1,1)) == 1))
replace mig204 = 2 if (nc_res == 8 & (real(substr(MIG,1,1)) == 2))
replace mig204 = 3 if (nc_res == 8 & (real(MIG) == 334))
replace mig204 = 3 if (nc_res == 8 & (real(MIG) == 335))
replace mig204 = 3 if (nc_res == 8 & (real(MIG) == 339))
replace mig204 = 4 if (nc_res == 8 & (real(MIG) == 336))
replace mig204 = 4 if (nc_res == 8 & (real(MIG) == 337))
replace mig204 = 4 if (nc_res == 8 & (real(MIG) == 338))
replace mig204 = 5 if (nc_res == 8 & (real(MIG) == 399))
gen retmig204 = 0
replace retmig204 = . if nc_res == 9
replace retmig204 = 1 if (nc_res == 2 & (real(substr(MIG,1,1)) == 1))
replace retmig204 = 2 if (nc_res == 2 & (real(substr(MIG,1,1)) == 2))
replace retmig204 = 3 if (nc_res == 2 & (real(MIG) == 334))
replace retmig204 = 3 if (nc_res == 2 & (real(MIG) == 335))
replace retmig204 = 3 if (nc_res == 2 & (real(MIG) == 339))
replace retmig204 = 4 if (nc_res == 2 & (real(MIG) == 336))
replace retmig204 = 4 if (nc_res == 2 & (real(MIG) == 337))
replace retmig204 = 4 if (nc_res == 2 & (real(MIG) == 338))
replace retmig204 = 5 if (nc_res == 2 & (real(MIG) == 399))
merge personid using may304, keep(mig304 retmig304) unique nokeep
gen mig = mig304
replace mig = . if mig204 > 0
replace mig = . if mig204 == . 
destring FAC, replace
sort personid
save may204, replace

use may104, clear
ren t_hij T_HIJ
ren e_civ E_CIV
ren mun MUN
ren a_met A_MET
ren est EST
ren ageb AGEB
ren sec SEC
ren a_lis A_LIS
ren man MAN
ren pan PAN
ren d_sem D_SEM
ren ent ENT
ren con CON
ren v_sel V_SEL
ren hog HOG
ren h_mud H_MUD
ren per PER
ren n_ent N_ENT
ren t_reg T_REG
ren r_trh R_TRH
ren par PAR
ren sex SEX
ren eda EDA
ren l_nac L_NAC
ren esc ESC
ren c_res C_RES
ren mig MIG
ren inf INF
ren p1_1 P1_1
ren p1_2 P1_2
ren p1_3 P1_3
ren p1_4 P1_4
ren p1a1 P1A1
ren p1a2 P1A2
ren p1a3 P1A3
ren p1a4 P1A4
ren p1b P1B
ren p1c P1C
ren p1d P1D
ren p1e P1E
ren p1f P1F
ren p1g P1G
ren p2 P2
ren p2a P2A
ren p2b P2B
ren p2b1_1 P2B1_1
ren p2b1_2 P2B1_2
ren p2c P2C
ren p2d P2D
ren p2e P2E
ren p2f_1 P2F_1
ren p2f_2 P2F_2
ren p3 P3
ren p3a P3A
ren p3b P3B
ren p3c P3C
ren p3d P3D
ren p3e P3E
ren p4 P4
ren p5 P5
ren p5a P5A
ren p5b P5B
ren p5c P5C
ren p5c1 P5C1
ren p6_1 P6_1
ren p6_2 P6_2
ren p6a P6A
ren p6b P6B
ren p6c P6C
ren p7 P7
ren p7a_1 P7A_1
ren p7a_2 P7A_2
ren p7b P7B
ren p7c P7C
ren p7d_1 P7D_1
ren p7d_2 P7D_2
ren p7d_3 P7D_3
ren p7d_4 P7D_4
ren p7d_5 P7D_5
ren p7d_6 P7D_6
ren p7d_7 P7D_7
ren p7d_8 P7D_8
ren p7d_9 P7D_9
ren p8a P8A
ren p8b P8B
ren p8c P8C
ren p8d P8D
ren p9 P9
ren p9a P9A
ren p10 P10
ren p10a P10A
ren fac FAC
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen mig104 = 0
replace mig104 = . if nc_res == 9
replace mig104 = 1 if (nc_res == 4 & (real(substr(MIG,1,1)) == 1))
replace mig104 = 2 if (nc_res == 4 & (real(substr(MIG,1,1)) == 2))
replace mig104 = 3 if (nc_res == 4 & (real(MIG) == 334))
replace mig104 = 3 if (nc_res == 4 & (real(MIG) == 335))
replace mig104 = 3 if (nc_res == 4 & (real(MIG) == 339))
replace mig104 = 4 if (nc_res == 4 & (real(MIG) == 336))
replace mig104 = 4 if (nc_res == 4 & (real(MIG) == 337))
replace mig104 = 4 if (nc_res == 4 & (real(MIG) == 338))
replace mig104 = 5 if (nc_res == 4 & (real(MIG) == 399))
replace mig104 = 1 if (nc_res == 8 & (real(substr(MIG,1,1)) == 1))
replace mig104 = 2 if (nc_res == 8 & (real(substr(MIG,1,1)) == 2))
replace mig104 = 3 if (nc_res == 8 & (real(MIG) == 334))
replace mig104 = 3 if (nc_res == 8 & (real(MIG) == 335))
replace mig104 = 3 if (nc_res == 8 & (real(MIG) == 339))
replace mig104 = 4 if (nc_res == 8 & (real(MIG) == 336))
replace mig104 = 4 if (nc_res == 8 & (real(MIG) == 337))
replace mig104 = 4 if (nc_res == 8 & (real(MIG) == 338))
replace mig104 = 5 if (nc_res == 8 & (real(MIG) == 399))
gen retmig104 = 0
replace retmig104 = . if nc_res == 9
replace retmig104 = 1 if (nc_res == 2 & (real(substr(MIG,1,1)) == 1))
replace retmig104 = 2 if (nc_res == 2 & (real(substr(MIG,1,1)) == 2))
replace retmig104 = 3 if (nc_res == 2 & (real(MIG) == 334))
replace retmig104 = 3 if (nc_res == 2 & (real(MIG) == 335))
replace retmig104 = 3 if (nc_res == 2 & (real(MIG) == 339))
replace retmig104 = 4 if (nc_res == 2 & (real(MIG) == 336))
replace retmig104 = 4 if (nc_res == 2 & (real(MIG) == 337))
replace retmig104 = 4 if (nc_res == 2 & (real(MIG) == 338))
replace retmig104 = 5 if (nc_res == 2 & (real(MIG) == 399))
merge personid using may204, keep(mig204 retmig204) unique nokeep
gen mig = mig204
replace mig = . if mig104 > 0
replace mig = . if mig104 == . 
destring FAC, replace
sort personid
save may104, replace

matrix quarters = [104, 403, 303, 203, 103, 402, 302, 202, 102, 401, 301, 201, 101, 400, 300, 200]
forvalues qq = 2/16{
	local q = string(quarters[1,`qq'])
	local q1 = string(quarters[1,`qq'-1])
	odbc load, table("MAY-`q'") dialog(complete) clear
	gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
	gen str20 personid = houseid+ R_TRH
	sort personid
	destring C_RES, generate(nc_res) force
	gen mig`q' = 0
	replace mig`q' = . if nc_res == 9
	replace mig`q' = 1 if (nc_res == 4 & (real(substr(MIG,1,1)) == 1))
	replace mig`q' = 2 if (nc_res == 4 & (real(substr(MIG,1,1)) == 2))
	replace mig`q' = 3 if (nc_res == 4 & (real(MIG) == 334))
	replace mig`q' = 3 if (nc_res == 4 & (real(MIG) == 335))
	replace mig`q' = 3 if (nc_res == 4 & (real(MIG) == 339))
	replace mig`q' = 4 if (nc_res == 4 & (real(MIG) == 336))
	replace mig`q' = 4 if (nc_res == 4 & (real(MIG) == 337))
	replace mig`q' = 4 if (nc_res == 4 & (real(MIG) == 338))
	replace mig`q' = 5 if (nc_res == 4 & (real(MIG) == 399))
	replace mig`q' = 1 if (nc_res == 8 & (real(substr(MIG,1,1)) == 1))
	replace mig`q' = 2 if (nc_res == 8 & (real(substr(MIG,1,1)) == 2))
	replace mig`q' = 3 if (nc_res == 8 & (real(MIG) == 334))
	replace mig`q' = 3 if (nc_res == 8 & (real(MIG) == 335))
	replace mig`q' = 3 if (nc_res == 8 & (real(MIG) == 339))
	replace mig`q' = 4 if (nc_res == 8 & (real(MIG) == 336))
	replace mig`q' = 4 if (nc_res == 8 & (real(MIG) == 337))
	replace mig`q' = 4 if (nc_res == 8 & (real(MIG) == 338))
	replace mig`q' = 5 if (nc_res == 8 & (real(MIG) == 399))
	gen retmig`q' = 0
	replace retmig`q' = . if nc_res == 9
	replace retmig`q' = 1 if (nc_res == 2 & (real(substr(MIG,1,1)) == 1))
	replace retmig`q' = 2 if (nc_res == 2 & (real(substr(MIG,1,1)) == 2))
	replace retmig`q' = 3 if (nc_res == 2 & (real(MIG) == 334))
	replace retmig`q' = 3 if (nc_res == 2 & (real(MIG) == 335))
	replace retmig`q' = 3 if (nc_res == 2 & (real(MIG) == 339))
	replace retmig`q' = 4 if (nc_res == 2 & (real(MIG) == 336))
	replace retmig`q' = 4 if (nc_res == 2 & (real(MIG) == 337))
	replace retmig`q' = 4 if (nc_res == 2 & (real(MIG) == 338))
	replace retmig`q' = 5 if (nc_res == 2 & (real(MIG) == 399))
	merge personid using may`q1', keep(mig`q1' retmig`q1') unique nokeep
	gen mig = mig`q1'
	replace mig = . if mig`q' > 0
	replace mig = . if mig`q' == . 
	destring FAC, replace
	sort personid
	save may`q', replace
}
