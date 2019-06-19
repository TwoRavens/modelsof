/*Computing temporary and permanent migrant numbers*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using menmigrationvariable.log, replace

odbc query "dBASE Files"
odbc load, table("MEN-404") dialog(complete)
/*Generate household id*/
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
/*Generate person id*/
gen str20 personid = houseid+ R_TRH
sort personid
/*Erase observations from people who left for circumstances different from migration (ausentes definitivos no emigrantes o no especificados)*/
/*First, convert residence condition into a numeric variable, creating missing values for A*/
destring C_RES, generate(nc_res) force
/*Recode migration variable*/
/*Binary classification, 1 for US migrants, 0 for everybody else, missing for non-specified condition*/
/*Temporary migrants in the US*/
gen binmigr404t = 0
replace binmigr404t = . if nc_res == 9
replace binmigr404t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr404t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr404t = 1 if (nc_res == 4 & (real(MIG) == 339))
/*Permanent migrants in the US*/
gen binmigr404p = 0
replace binmigr404p = . if nc_res == 9
replace binmigr404p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr404p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr404p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

save men404m, replace

odbc load, table("MEN-304") dialog(complete) clear
/*Generate household id*/
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
/*Generate person id*/
gen str20 personid = houseid+ R_TRH
sort personid
/*Erase observations from people who left for circumstances different from migration (ausentes definitivos no emigrantes o no especificados)*/
/*First, convert residence condition into a numeric variable, creating missing values for A*/
destring C_RES, generate(nc_res) force
/*Binary classification, 1 for US migrants, 0 for stayers, missing values otherwise*/
/*Temporary migrants in the US*/
gen binmigr304t = 0
replace binmigr304t = . if nc_res == 9
replace binmigr304t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr304t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr304t = 1 if (nc_res == 4 & (real(MIG) == 339))
/*Permanent migrants in the US*/
gen binmigr304p = 0
replace binmigr304p = . if nc_res == 9
replace binmigr304p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr304p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr304p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men404m, keep(binmigr404p binmigr404t) unique nokeep
drop _merge
sort personid
merge personid using may404m, keep(binmigr404p binmigr404t) unique nokeep

gen binmigrt = binmigr404t
replace binmigrt = . if binmigr304t == 1
replace binmigrt = . if binmigr304t == .
replace binmigrt = . if binmigr304p == 1

gen binmigrp = binmigr404p
replace binmigrp = . if binmigr304p == 1
replace binmigrp = . if binmigr304p == .
replace binmigrp = . if binmigr304t == 1

destring FAC, replace
sort personid
save men304m, replace

odbc load, table("MEN-204") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr204t = 0
replace binmigr204t = . if nc_res == 9
replace binmigr204t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr204t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr204t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr204p = 0
replace binmigr204p = . if nc_res == 9
replace binmigr204p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr204p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr204p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men304m, keep(binmigr304p binmigr304t) unique nokeep
drop _merge
sort personid
merge personid using may304m, keep(binmigr304p binmigr304t) unique nokeep

gen binmigrt = binmigr304t
replace binmigrt = . if binmigr204t == 1
replace binmigrt = . if binmigr204t == .
replace binmigrt = . if binmigr204p == 1

gen binmigrp = binmigr304p
replace binmigrp = . if binmigr204p == 1
replace binmigrp = . if binmigr204p == .
replace binmigrp = . if binmigr204t == 1

sort personid
save men204m, replace

use men104, clear
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
ren fac FAC
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr104t = 0
replace binmigr104t = . if nc_res == 9
replace binmigr104t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr104t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr104t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr104p = 0
replace binmigr104p = . if nc_res == 9
replace binmigr104p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr104p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr104p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men204m, keep(binmigr204p binmigr204t) unique nokeep
drop _merge
sort personid
merge personid using may204m, keep(binmigr204p binmigr204t) unique nokeep

gen binmigrt = binmigr204t
replace binmigrt = . if binmigr104t == 1
replace binmigrt = . if binmigr104t == .
replace binmigrt = . if binmigr104p == 1

gen binmigrp = binmigr204p
replace binmigrp = . if binmigr104p == 1
replace binmigrp = . if binmigr104p == .
replace binmigrp = . if binmigr104t == 1

sort personid
save men104m, replace

odbc load, table("MEN-403") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr403t = 0
replace binmigr403t = . if nc_res == 9
replace binmigr403t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr403t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr403t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr403p = 0
replace binmigr403p = . if nc_res == 9
replace binmigr403p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr403p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr403p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men104m, keep(binmigr104p binmigr104t) unique nokeep
drop _merge
sort personid
merge personid using may104m, keep(binmigr104p binmigr104t) unique nokeep

gen binmigrt = binmigr104t
replace binmigrt = . if binmigr403t == 1
replace binmigrt = . if binmigr403t == .
replace binmigrt = . if binmigr403p == 1

gen binmigrp = binmigr104p
replace binmigrp = . if binmigr403p == 1
replace binmigrp = . if binmigr403p == .
replace binmigrp = . if binmigr403t == 1

sort personid
save men403m, replace

odbc load, table("MEN-303") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr303t = 0
replace binmigr303t = . if nc_res == 9
replace binmigr303t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr303t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr303t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr303p = 0
replace binmigr303p = . if nc_res == 9
replace binmigr303p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr303p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr303p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men403m, keep(binmigr403p binmigr403t) unique nokeep
drop _merge
sort personid
merge personid using may403m, keep(binmigr403p binmigr403t) unique nokeep

gen binmigrt = binmigr403t
replace binmigrt = . if binmigr303t == 1
replace binmigrt = . if binmigr303t == .
replace binmigrt = . if binmigr303p == 1

gen binmigrp = binmigr403p
replace binmigrp = . if binmigr303p == 1
replace binmigrp = . if binmigr303p == .
replace binmigrp = . if binmigr303t == 1

sort personid
save men303m, replace

odbc load, table("MEN-203") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr203t = 0
replace binmigr203t = . if nc_res == 9
replace binmigr203t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr203t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr203t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr203p = 0
replace binmigr203p = . if nc_res == 9
replace binmigr203p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr203p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr203p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men303m, keep(binmigr303p binmigr303t) unique nokeep
drop _merge
sort personid
merge personid using may303m, keep(binmigr303p binmigr303t) unique nokeep

gen binmigrt = binmigr303t
replace binmigrt = . if binmigr203t == 1
replace binmigrt = . if binmigr203t == .
replace binmigrt = . if binmigr203p == 1

gen binmigrp = binmigr303p
replace binmigrp = . if binmigr203p == 1
replace binmigrp = . if binmigr203p == .
replace binmigrp = . if binmigr203t == 1

sort personid
save men203m, replace

odbc load, table("MEN-103") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr103t = 0
replace binmigr103t = . if nc_res == 9
replace binmigr103t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr103t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr103t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr103p = 0
replace binmigr103p = . if nc_res == 9
replace binmigr103p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr103p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr103p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men203m, keep(binmigr203p binmigr203t) unique nokeep
drop _merge
sort personid
merge personid using may203m, keep(binmigr203p binmigr203t) unique nokeep

gen binmigrt = binmigr203t
replace binmigrt = . if binmigr103t == 1
replace binmigrt = . if binmigr103t == .
replace binmigrt = . if binmigr103p == 1

gen binmigrp = binmigr203p
replace binmigrp = . if binmigr103p == 1
replace binmigrp = . if binmigr103p == .
replace binmigrp = . if binmigr103t == 1

sort personid
save men103m, replace

odbc load, table("MEN-402") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr402t = 0
replace binmigr402t = . if nc_res == 9
replace binmigr402t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr402t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr402t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr402p = 0
replace binmigr402p = . if nc_res == 9
replace binmigr402p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr402p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr402p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men103m, keep(binmigr103p binmigr103t) unique nokeep
drop _merge
sort personid
merge personid using may103m, keep(binmigr103p binmigr103t) unique nokeep

gen binmigrt = binmigr103t
replace binmigrt = . if binmigr402t == 1
replace binmigrt = . if binmigr402t == .
replace binmigrt = . if binmigr402p == 1

gen binmigrp = binmigr103p
replace binmigrp = . if binmigr402p == 1
replace binmigrp = . if binmigr402p == .
replace binmigrp = . if binmigr402t == 1

sort personid
save men402m, replace

odbc load, table("MEN-302") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr302t = 0
replace binmigr302t = . if nc_res == 9
replace binmigr302t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr302t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr302t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr302p = 0
replace binmigr302p = . if nc_res == 9
replace binmigr302p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr302p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr302p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men402m, keep(binmigr402p binmigr402t) unique nokeep
drop _merge
sort personid
merge personid using may402m, keep(binmigr402p binmigr402t) unique nokeep

gen binmigrt = binmigr402t
replace binmigrt = . if binmigr302t == 1
replace binmigrt = . if binmigr302t == .
replace binmigrt = . if binmigr302p == 1

gen binmigrp = binmigr402p
replace binmigrp = . if binmigr302p == 1
replace binmigrp = . if binmigr302p == .
replace binmigrp = . if binmigr302t == 1

sort personid
save men302m, replace

odbc load, table("MEN-202") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr202t = 0
replace binmigr202t = . if nc_res == 9
replace binmigr202t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr202t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr202t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr202p = 0
replace binmigr202p = . if nc_res == 9
replace binmigr202p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr202p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr202p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men302m, keep(binmigr302p binmigr302t) unique nokeep
drop _merge
sort personid
merge personid using may302m, keep(binmigr302p binmigr302t) unique nokeep

gen binmigrt = binmigr302t
replace binmigrt = . if binmigr202t == 1
replace binmigrt = . if binmigr202t == .
replace binmigrt = . if binmigr202p == 1

gen binmigrp = binmigr302p
replace binmigrp = . if binmigr202p == 1
replace binmigrp = . if binmigr202p == .
replace binmigrp = . if binmigr202t == 1

sort personid
save men202m, replace

odbc load, table("MEN-102") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr102t = 0
replace binmigr102t = . if nc_res == 9
replace binmigr102t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr102t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr102t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr102p = 0
replace binmigr102p = . if nc_res == 9
replace binmigr102p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr102p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr102p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men202m, keep(binmigr202p binmigr202t) unique nokeep
drop _merge
sort personid
merge personid using may202m, keep(binmigr202p binmigr202t) unique nokeep

gen binmigrt = binmigr202t
replace binmigrt = . if binmigr102t == 1
replace binmigrt = . if binmigr102t == .
replace binmigrt = . if binmigr102p == 1

gen binmigrp = binmigr202p
replace binmigrp = . if binmigr102p == 1
replace binmigrp = . if binmigr102p == .
replace binmigrp = . if binmigr102t == 1

sort personid
save men102m, replace

odbc load, table("MEN-401") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr401t = 0
replace binmigr401t = . if nc_res == 9
replace binmigr401t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr401t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr401t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr401p = 0
replace binmigr401p = . if nc_res == 9
replace binmigr401p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr401p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr401p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men102m, keep(binmigr102p binmigr102t) unique nokeep
drop _merge
sort personid
merge personid using may102m, keep(binmigr102p binmigr102t) unique nokeep

gen binmigrt = binmigr102t
replace binmigrt = . if binmigr401t == 1
replace binmigrt = . if binmigr401t == .
replace binmigrt = . if binmigr401p == 1

gen binmigrp = binmigr102p
replace binmigrp = . if binmigr401p == 1
replace binmigrp = . if binmigr401p == .
replace binmigrp = . if binmigr401t == 1

sort personid
save men401m, replace

odbc load, table("MEN-301") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr301t = 0
replace binmigr301t = . if nc_res == 9
replace binmigr301t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr301t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr301t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr301p = 0
replace binmigr301p = . if nc_res == 9
replace binmigr301p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr301p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr301p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men401m, keep(binmigr401p binmigr401t) unique nokeep
drop _merge
sort personid
merge personid using may401m, keep(binmigr401p binmigr401t) unique nokeep

gen binmigrt = binmigr401t
replace binmigrt = . if binmigr301t == 1
replace binmigrt = . if binmigr301t == .
replace binmigrt = . if binmigr301p == 1

gen binmigrp = binmigr401p
replace binmigrp = . if binmigr301p == 1
replace binmigrp = . if binmigr301p == .
replace binmigrp = . if binmigr301t == 1

sort personid
save men301m, replace

odbc load, table("MEN-201") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr201t = 0
replace binmigr201t = . if nc_res == 9
replace binmigr201t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr201t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr201t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr201p = 0
replace binmigr201p = . if nc_res == 9
replace binmigr201p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr201p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr201p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men301m, keep(binmigr301p binmigr301t) unique nokeep
drop _merge
sort personid
merge personid using may301m, keep(binmigr301p binmigr301t) unique nokeep

gen binmigrt = binmigr301t
replace binmigrt = . if binmigr201t == 1
replace binmigrt = . if binmigr201t == .
replace binmigrt = . if binmigr201p == 1

gen binmigrp = binmigr301p
replace binmigrp = . if binmigr201p == 1
replace binmigrp = . if binmigr201p == .
replace binmigrp = . if binmigr201t == 1

sort personid
save men201m, replace

odbc load, table("MEN-101") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr101t = 0
replace binmigr101t = . if nc_res == 9
replace binmigr101t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr101t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr101t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr101p = 0
replace binmigr101p = . if nc_res == 9
replace binmigr101p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr101p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr101p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men201m, keep(binmigr201p binmigr201t) unique nokeep
drop _merge
sort personid
merge personid using may201m, keep(binmigr201p binmigr201t) unique nokeep

gen binmigrt = binmigr201t
replace binmigrt = . if binmigr101t == 1
replace binmigrt = . if binmigr101t == .
replace binmigrt = . if binmigr101p == 1

gen binmigrp = binmigr201p
replace binmigrp = . if binmigr101p == 1
replace binmigrp = . if binmigr101p == .
replace binmigrp = . if binmigr101t == 1

sort personid
save men101m, replace

odbc load, table("MEN-400") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr400t = 0
replace binmigr400t = . if nc_res == 9
replace binmigr400t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr400t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr400t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr400p = 0
replace binmigr400p = . if nc_res == 9
replace binmigr400p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr400p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr400p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men101m, keep(binmigr101p binmigr101t) unique nokeep
drop _merge
sort personid
merge personid using may101m, keep(binmigr101p binmigr101t) unique nokeep

gen binmigrt = binmigr101t
replace binmigrt = . if binmigr400t == 1
replace binmigrt = . if binmigr400t == .
replace binmigrt = . if binmigr400p == 1

gen binmigrp = binmigr101p
replace binmigrp = . if binmigr400p == 1
replace binmigrp = . if binmigr400p == .
replace binmigrp = . if binmigr400t == 1

sort personid
save men400m, replace

odbc load, table("MEN-300") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr300t = 0
replace binmigr300t = . if nc_res == 9
replace binmigr300t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr300t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr300t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr300p = 0
replace binmigr300p = . if nc_res == 9
replace binmigr300p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr300p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr300p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men400m, keep(binmigr400p binmigr400t) unique nokeep
drop _merge
sort personid
merge personid using may400m, keep(binmigr400p binmigr400t) unique nokeep

gen binmigrt = binmigr400t
replace binmigrt = . if binmigr300t == 1
replace binmigrt = . if binmigr300t == .
replace binmigrt = . if binmigr300p == 1

gen binmigrp = binmigr400p
replace binmigrp = . if binmigr300p == 1
replace binmigrp = . if binmigr300p == .
replace binmigrp = . if binmigr300t == 1

sort personid
save men300m, replace

odbc load, table("MEN-200") dialog(complete) clear
gen str18 houseid =  SEC+ MUN+ PAN+ ENT+ CON+ V_SEL+ HOG+ H_MUD
gen str20 personid = houseid+ R_TRH
sort personid
destring C_RES, generate(nc_res) force
gen binmigr200t = 0
replace binmigr200t = . if nc_res == 9
replace binmigr200t = 1 if (nc_res == 4 & (real(MIG) == 334))
replace binmigr200t = 1 if (nc_res == 4 & (real(MIG) == 335))  
replace binmigr200t = 1 if (nc_res == 4 & (real(MIG) == 339))
gen binmigr200p = 0
replace binmigr200p = . if nc_res == 9
replace binmigr200p = 1 if (nc_res ==8 & (real(MIG) == 334))
replace binmigr200p = 1 if (nc_res == 8 & (real(MIG) == 335))  
replace binmigr200p = 1 if (nc_res ==8 & (real(MIG) == 339)) 

merge personid using men300m, keep(binmigr300p binmigr300t) unique nokeep
drop _merge
sort personid
merge personid using may300m, keep(binmigr300p binmigr300t) unique nokeep

gen binmigrt = binmigr300t
replace binmigrt = . if binmigr200t == 1
replace binmigrt = . if binmigr200t == .
replace binmigrt = . if binmigr200p == 1

gen binmigrp = binmigr300p
replace binmigrp = . if binmigr200p == 1
replace binmigrp = . if binmigr200p == .
replace binmigrp = . if binmigr200t == 1

sort personid
save men200m, replace
