
/*******************************************

The final output of this do file is the final dataset: dataset_weight_crisis.dta

Before running the do file, make sure you replace "directory_name" with the actual name of your directory:

Edit --> Find --> Replace

Find what: directory_name

Replace with: the actual name of your directory  

*******************************************/

*** (1) DESTRING FILES ***

*** Required for years 2000, 2003, 2004 ***

clear all
set mem 4000m
set more off

cd "directory_name\Data_Replication_Files_RESTAT\DBF_files"
**you must replace "directory_name" with the actual name of your directory

use bw2000, clear
destring, replace
save 2000d.dta

use bw2003, clear
destring MPRORES, replace
save 2003d.dta

use bw2004, clear
destring MPRORES, replace
save 2004d.dta

*** No need to destring files for years 2001, 2002, 2005, 2006 ***

use bw2001, clear
save 2001d.dta

use bw2002, clear
save 2002d.dta

use bw2005, clear
save 2005d.dta

use bw2006, clear
save 2006d.dta

*** (2) Date of Birth: Checking and Cleaning (if required) ***

***2000***
use 2000d, clear
rename MESOC month
destring month, replace
gen year=1999 if ANOOC==99
replace year=2000 if ANOOC==00

drop ANOOC

save 2000clean

***cleaning 2001 file***

use 2001d, clear

gen n0 = regexs(0) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n1 = regexs(1) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n2 = regexs(2) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n22 = regexs(2) if regexm(FECOC, "([0-9]*)\/[ ]([0-9]*)\/([0-9]*)")
gen n3 = regexs(3) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n33 = regexs(3) if regexm(FECOC, "([0-9]*)\/[ ]([0-9]*)\/([0-9]*)")


destring n2, replace
destring n22, replace


gen month=n2
replace month=n22 if n2==.

move month FECOC

gen day=n1
destring day, replace

move day FECOC


destring n3, replace
destring n33, replace

gen year=n3
replace year=n33 if n3==.

move year FECOC

gen monthclean=month if month<13
tab day if month>12

replace monthclean=day if month>12

gen yearclean=year
replace yearclean=2000 if year==0
replace yearclean=2001 if year==1

save 2001clean 


***cleaning 2002 file***

use 2002d, clear

gen n0 = regexs(0) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n1 = regexs(1) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //day
gen n2 = regexs(2) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //month
gen n3 = regexs(3) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //year

move n0 FECOC
move n1 FECOC
move n2 FECOC
move n3 FECOC

destring n2, replace
destring n3, replace

tab n2
tab n3
**after exploring n2 and n3

rename n2 monthclean
rename n3 yearclean

save 2002clean

***cleaning 2003 file***

use 2003d, clear

gen n0 = regexs(0) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n1 = regexs(1) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //day
gen n2 = regexs(2) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //month
gen n3 = regexs(3) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //year

move n0 FECOC
move n1 FECOC
move n2 FECOC
move n3 FECOC

destring n2, replace
destring n3, replace

tab n2
tab n3
**after exploring n2 and n3

rename n2 monthclean
rename n3 yearclean

save 2003clean

***cleaning 2004 file***

use 2004d, clear

gen n0 = regexs(0) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n1 = regexs(1) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //day
gen n2 = regexs(2) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //month
gen n3 = regexs(3) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //year

move n0 FECOC
move n1 FECOC
move n2 FECOC
move n3 FECOC

destring n1, replace
destring n2, replace
destring n3, replace

rename n1 day
rename n2 month
rename n3 year

tab month 
tab year

**after exploring n2 and n3

gen monthclean=month if month<13
tab day if month>12
replace monthclean=day if month>12
replace monthclean=. if monthclean==0

tab year
rename year yearclean 

drop  n0 day month  FECOC

move monthclean SEXO


save 2004clean


***cleaning 2005 file***
use 2005d, clear

gen n0 = regexs(0) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n1 = regexs(1) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //day
gen n2 = regexs(2) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //month
gen n3 = regexs(3) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //year

move n0 FECOC
move n1 FECOC
move n2 FECOC
move n3 FECOC

destring n1, replace
destring n2, replace
destring n3, replace

rename n1 day
rename n2 month
rename n3 year

tab month 
tab year

rename month monthclean
rename year yearclean 

drop n0 day  FECOC

save 2005clean

***cleaning 2006 file***
use 2006d, clear

gen n0 = regexs(0) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)")
gen n1 = regexs(1) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //day
gen n2 = regexs(2) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //month
gen n3 = regexs(3) if regexm(FECOC, "([0-9]*)\/([0-9]*)\/([0-9]*)") //year

move n0 FECOC
move n1 FECOC
move n2 FECOC
move n3 FECOC

destring n1, replace
destring n2, replace
destring n3, replace

rename n1 day
rename n2 month
rename n3 year

tab month 
tab year

rename month monthclean
rename year yearclean 

drop n0 day  FECOC

save 2006clean

*** (3) Dropping redundant variables and creating 2000-2005 BW file ***

use 2000clean, clear
save 2000r

use 2001clean, clear
drop month day year FECOC n0 n1 n2 n22 n3 n33
rename monthclean month
rename yearclean year
save 2001r

use 2002clean, clear
drop n0 n1 FECOC
rename monthclean month
rename yearclean year
save 2002r

use 2003clean, clear
drop n0 n1 FECOC
rename monthclean month
rename yearclean year
save 2003r

use 2004clean, clear
rename monthclean month
rename yearclean year
save 2004r

use 2005clean, clear
rename monthclean month
rename yearclean year
save 2005r

use 2006clean, clear
rename monthclean month
rename yearclean year
save 2006r

********************

use 2000r.dta
append using 2001r.dta
append using 2002r.dta
append using 2003r.dta
append using 2004r.dta
append using 2005r.dta
append using 2006r.dta


keep if year>=2000 & year<=2005
drop if year==.

save 2000_2005.dta, replace

******************************

*** (4) Creating variables ***

clear all

set mem 4000m

*****************************************
use 2000_2005.dta, clear


compress

drop MFECNAC

rename PESONAC bw

rename TIEMGEST gestl

gen female=0 if SEXO==1
replace female=1 if SEXO==2
drop SEXO

gen singleton=1 if TIPPARTO==1
replace singleton=0 if TIPPARTO>1 & TIPPARTO<4
drop TIPPARTO

rename MEDAD age

***education
gen heduc=0 if MINSTRUC>=1 & MINSTRUC<5
replace heduc=0 if MINSTRUC>=11 & MINSTRUC<16
replace heduc=1 if MINSTRUC>=5 & MINSTRUC<8
replace heduc=1 if MINSTRUC==16


/*******************************************MINSTRUC: Nivel de instrucción de la madre

before-2000
CÓDIGO	DESCRIPCIÓN
1	ANALFABETO
2	PRIMARIO INCOMPLETO
3	PRIMARIO COMPLETO
4	SECUND INCOMPLETO
5	SECUND COMPLETO
6	SUP.O UNIV INCOMPLET
7	SUP.O UNIV COMPLETO
9	SE IGNORA

2001-after
CÓDIGO	DESCRIPCIÓN
1	NUNCA ASISTIÓ
2	PRIMARIO INCOMPLETO
3	PRIMARIO COMPLETO
4	SECUNDARIO INCOMPLETO
5	SECUNDARIO COMPLETO
6	SUPERIOR O UNIVERSITARIO INCOMPLETO
7	SUPERIOR O UNIVERSITARIO COMPLETO
11	CICLOS EGB ( 1 Y 2) INCOMPLETO
12	CICLOS EGB ( 1 Y 2) COMPLETO
13	CICLO EGB 3 INCOMPLETO
14	CICLO EGB 3 COMPLETO
15	POLIMODAL INCOMPLETO
16	POLIMODAL COMPLETO

***/

drop MINSTRUC

***partner (living with a partner 1, otherwise 0)
gen partner=0 if MSITCONY==1 & year<2001
replace partner=0 if MSITCONY>2 & MSITCONY<6 & year<2001
replace partner=0 if MSITCONY==2 & year>=2001
replace partner=1 if MSITCONY==1 & year>=2001
replace partner=1 if MSITCONY==2 & year<2001
replace partner=1 if MSITCONY==6 & year<2001


/*******************************************MSITCONY: Situación conyugal de la madre

before-2000
CÓDIGO	DESCRIPCIÓN
1	SOLTERO
2	CASADO
3	VIUDO
4	DIVORCIADO
5	SEPARADO
6	UNIDO DE HECHO
9	SE IGNORA

2001-after
CÓDIGO	DESCRIPCIÓN
1	SI CONVIVE EN PAREJA
2	NO CONVIVE EN PAREJA


***/	
	
drop MSITCONY

***total births=total live births + total stillbirths

gen totpreg=TOTNACVI+TOTNACMU



gen preg_m=1 if totpreg>=0 & totpreg<=1
replace preg_m=2 if totpreg==2
replace preg_m=3 if totpreg==3
replace preg_m=4 if totpreg>=4 & totpreg<21

drop TOTNACVI TOTNACMU totpreg

***age categories
gen age_category=1 if age>=15 & age<=19
replace age_category=2 if age>=20 & age<=24
replace age_category=3 if age>=25 & age<=29
replace age_category=4 if age>=30 & age<=34
replace age_category=5 if age>=35 & age<=39
replace age_category=6 if age>=40 & age<=44
replace age_category=7 if age>=45 & age<=49

***medical center

gen medical_center=0 if OCLOC>=2 & OCLOC<=3 & year<2001
replace medical_center=0 if OCLOC>=3 & OCLOC<=4 & year>=2001
replace medical_center=1 if OCLOC==1 & year<2001
replace medical_center=1 if OCLOC>=1 & OCLOC<=2 & year>=2001

/*******************************************OCLOC: Local de ocurrencia


before-2000
CÓDIGO	DESCRIPCIÓN
1	ESTAB.ASISTENCIAL   
2	DOMICILIO PARTICULAR  
3	OTROS   
9	SE IGNORA

2001-after
CÓDIGO	DESCRIPCIÓN
1	ESTABLECIMIENTO DE SALUD PUBLICO  
2	ESTABLECIMIENTO DE SALUD PRIVADO, OBRA SOCIAL, ETC. 
3	VIVIENDA (DOMICILIO) PARTICULAR  
4	OTRO LUGAR (VIA PÚBLICA, TRASNPORTES,ETC.)  
	
***/

drop OCLOC

***doctor

gen doctor=1 if ATPARTO==1
replace doctor=0 if ATPARTO>1 & ATPARTO<9


/*******************************************ATPARTO	Quién atendió el parto


before-2000
CÓDIGO	DESCRIPCIÓN	
1	MEDICO
2	PARTERA
3	COMADRE
4	SIN ATENCI
5	OTROS
9	SE IGNORA

2001-after
CÓDIGO	DESCRIPCIÓN
1	MEDICO/A	
2	PARTERO/A	
3	ENFERMERO/A	
4	OTRO AGENTE SANITARIO	
5	COMADRE	
6	OTROS	
7	SIN ATENCIÓN	
8	COMADRONA	SOLO PARA CHACO
9   SE IGNORNA

***/

drop ATPARTO

drop DEPOC PROOC MDEPRES PINSTRU PCONDACT NDOMDEP NDOMPRO MASOCIAD PASOCIAD SITLABOR


***Our sample***
***95.34% of all live births***


count 

count if (singleton==1 & age>=15 & age<=49 & bw>=500 & bw<9000)

label variable year "Year of birth"
label variable month "Month of birth"

tab year

keep if singleton==1
keep if age>=15 & age<=49
keep if bw>=500 & bw!=.
keep if bw<9000

drop singleton

tab year


gen LBW=1 if bw<=2500
replace LBW=0 if bw>2500 & bw!=.


label variable bw "Birth weight (g)"
label variable gestl "Gestational length (weeks)"
label variable LBW "Low Birth Weight (<=2,500 g)"
label variable female "Sex of the child (1 if female)"
label variable age "Mother's age (years)"
label variable age_category "Mother's age category"
label variable heduc "Mother's high education (1 if high-school or more)"
label variable preg_m "Parity (number of births)"
label variable partner "Marital status (1 if living with a partner)"
label variable medical_center "Born in medical center (0 otherwise)"
label variable doctor "Attended by a doctor (0 otherwise)"
label variable MPRORES "Mother's province of residence"


move year month
move female age
rename MPRORES mprores
move LBW gestl

replace gestl=. if gestl==0
replace gestl=. if gestl==99
replace mprores=. if mprores==99

save 2000_2005_bw.dta

*** (5) JOINBY ***


gen time=month if year==2000
replace time=12 + month if year==2001
replace time=24 + month if year==2002
replace time=36 + month if year==2003
replace time=48 + month if year==2004
replace time=60 + month if year==2005

joinby time using  "directory_name\Data_Replication_Files_RESTAT\datasets\economic_activity_data_2000_2005.dta"

drop medical_center doctor 

label variable time "1 (Jan 2000),..., 72 (Dec 2005)"


save "directory_name\Data_Replication_Files_RESTAT\datasets\dataset_weight_crisis.dta", replace

***************************************************** 
