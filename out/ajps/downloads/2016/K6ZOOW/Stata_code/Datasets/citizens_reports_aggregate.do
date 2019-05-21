***************************************************************************
* File:               citizens_reports_aggregate.do
* Author:             Miguel R. Rueda
* Description:        Creates a panel with citizens' reports for years 2008 onwards. 
* Created:            Jul - 17 - 2012
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************

cd "\Datasets\Dep_vars\"
set more off

foreach var in ingreso_SPOA ingreso_SIJUF acu_SPOA acu_SIJUF{
import excel "Casos x Delitos 2008 al 2011 - 01_02_2012_ok (3).xls", sheet("`var'_export") firstrow clear

replace DEPARTAMENTO=rtrim(DEPARTAMENTO)
replace MUNICIPIO=rtrim(MUNICIPIO)

*Taking out tildes, ñ and others
	gen ciu=regexr(DEPARTAMENTO,"á","a")
	gen ciu1=regexr(ciu,"é","e")
	gen ciu2=regexr(ciu1,"í","i")
	gen ciu3=regexr(ciu2,"ú","u")
	gen ciu4=regexr(ciu3,"ñ","n")
	gen ciu5=regexr(ciu4,"ó","o")
	gen ciu6=regexr(ciu5,"ü","u")
	drop ciu5 ciu4 ciu3 ciu2 ciu1 ciu DEPARTAMENTO
	rename ciu6 DEPARTAMENTO

gen departamento=upper(DEPARTAMENTO)
drop DEPARTAMENTO
rename departamento DEPARTAMENTO

	gen ciu=regexr(MUNICIPIO,"Á","A")
	gen ciu1=regexr(ciu,"É","E")
	gen ciu2=regexr(ciu1,"Í","I")
	gen ciu3=regexr(ciu2,"Ú","U")
	gen ciu4=regexr(ciu3,"Ñ","N")
	gen ciu5=regexr(ciu4,"Ó","O")
	gen ciu6=regexr(ciu5,"Ü","U")
	drop ciu5 ciu4 ciu3 ciu2 ciu1 ciu MUNICIPIO
	rename ciu6 MUNICIPIO

*Fixing names to add muni_code
replace DEPARTAMENTO="SAN ANDRES" if DEPARTAMENTO=="DEPARTAMENTO ARCHIPIELAGO DE SAN ANDRéS, PROVIDENCIA Y SANTA CATALINA"
replace DEPARTAMENTO="CUNDINAMARCA" if MUNICIPIO=="BOGOTA, D.C."
replace MUNICIPIO="BOGOTA, DISTRITO CAPITAL" if MUNICIPIO=="BOGOTA, D.C."
replace MUNICIPIO="CARTAGENA DE INDIAS" if MUNICIPIO=="CARTAGENA"
replace MUNICIPIO="BAJO BAUDO  (PIZARRO)" if MUNICIPIO=="BAJO BAUDO"
replace MUNICIPIO="BUGA" if MUNICIPIO=="GUADALAJARA DE BUGA"
replace MUNICIPIO="UBATE" if MUNICIPIO=="VILLA DE SAN DIEGO DE UBATE"
replace MUNICIPIO="HATO NUEVO" if MUNICIPIO=="HATONUEVO"
replace MUNICIPIO="EL TABLON" if MUNICIPIO=="EL TABLON DE GÓMEZ"
replace MUNICIPIO="SINCE" if MUNICIPIO=="SAN LUIS DE SINCE"
replace MUNICIPIO="SANTUARIO" if MUNICIPIO=="EL SANTUARIO"
replace MUNICIPIO="TOGUL" if MUNICIPIO=="TOGUI"
replace MUNICIPIO="VILLA DE LEIVA" if MUNICIPIO=="VILLA DE LEYVA"
replace MUNICIPIO="SAN JUAN DE RIOSECO" if MUNICIPIO=="SAN JUAN DE RIO SECO"
replace MUNICIPIO="EL CARMEN" if MUNICIPIO=="EL CARMEN DE CHUCURI"
replace MUNICIPIO="TOLU" if MUNICIPIO=="SANTIAGO DE TOLU"
replace MUNICIPIO="SAN ANDRES" if MUNICIPIO=="SAN ANDRES DE CUERQUIA"
replace MUNICIPIO="TIQUISIO (PUERTO RICO)" if MUNICIPIO=="TIQUISIO"
replace MUNICIPIO="YONDO (CASABE)" if MUNICIPIO=="YONDO"
replace MUNICIPIO="SANTA FE ANTIOQUIA" if MUNICIPIO=="SANTAFE DE ANTIOQUIA"
replace MUNICIPIO="MONTANITA" if MUNICIPIO=="LA MONTANITA"
replace MUNICIPIO="PURACE  (COCONUCO)" if MUNICIPIO=="PURACE"
replace MUNICIPIO="SOTARA  (PAISPAMBA)" if MUNICIPIO=="SOTARA"
replace MUNICIPIO="BAHIA SOLANO  (MUTIS)" if MUNICIPIO=="BAHIA SOLANO"
replace MUNICIPIO="SAN ANDRES DE SOTAVENTO" if MUNICIPIO=="SAN ANDRES SOTAVENTO"
replace MUNICIPIO="CERRO DE SAN ANTONIO" if MUNICIPIO=="CERRO SAN ANTONIO"
replace MUNICIPIO="PIJINO  DEL CARMEN" if MUNICIPIO=="PIJINO DEL CARMEN"
replace MUNICIPIO="ZONA BANANERA (PRADO-SEVILLA)" if MUNICIPIO=="ZONA BANANERA"
replace MUNICIPIO="SANTA CRUZ" if MUNICIPIO=="SANTACRUZ"
replace MUNICIPIO="TOLUVIEJO" if MUNICIPIO=="TOLU VIEJO"
replace MUNICIPIO="LA PEDRERA (Cor. Dptal.)" if MUNICIPIO=="LA PEDRERA"
replace MUNICIPIO="CARMEN DE VIBORAL" if MUNICIPIO=="EL CARMEN DE VIBORAL"
replace MUNICIPIO="ATRATO (YUTO)" if MUNICIPIO=="ATRATO"
replace MUNICIPIO="TARAPACA (Cor. Dptal)" if MUNICIPIO=="TARAPACA"
replace MUNICIPIO="MALLAMA  (PIEDRANCHA)" if MUNICIPIO=="MALLAMA"
replace MUNICIPIO="GUACHENE (1)" if MUNICIPIO=="GUACHENE"
replace MUNICIPIO="COLON  (GENOVA)" if MUNICIPIO=="COLON"&DEPARTAMENTO=="NARINO"
replace MUNICIPIO="MANAURE BALCON DEL CESAR" if MUNICIPIO=="MANAURE"&DEPARTAMENTO=="CESAR"
replace MUNICIPIO="SANTA BARBARA  (ISCUANDE)" if MUNICIPIO=="SANTA BARBARA"&DEPARTAMENTO=="NARINO"
replace MUNICIPIO="PAEZ (BELALCAZAR)" if MUNICIPIO=="PAEZ"&DEPARTAMENTO=="CAUCA"

replace MUNICIPIO="ISTMINA" if MUNICIPIO=="ITSMINA"
replace MUNICIPIO="MONITOS" if MUNICIPIO=="MO#ITOS"
replace MUNICIPIO="SAN BERNARDO DEL VIENTO" if MUNICIPIO=="SAN BERNARDO DEL VIE"
replace MUNICIPIO="SAN JOSE DEL GUAVIARE" if MUNICIPIO=="SAN JOSE DEL GUAVIAR"
replace MUNICIPIO="BOGOTA, DISTRITO CAPITAL" if MUNICIPIO=="SANTAFE DE BOGOTA DC"
replace MUNICIPIO="OCANA" if MUNICIPIO=="OCA#A"
replace DEPARTAMENTO="CUNDINAMARCA" if DEPARTAMENTO=="BOGOTA"
replace DEPARTAMENTO="VALLE DEL CAUCA" if DEPARTAMENTO=="VALLE"
replace DEPARTAMENTO="NORTE DE SANTANDER" if DEPARTAMENTO=="NORTE SANTANDER"

replace MUNICIPIO="PUERTO NARINO" if MUNICIPIO=="PUERTO NARI#O"
replace MUNICIPIO="BOGOTA, DISTRITO CAPITAL" if MUNICIPIO=="SANTAFE DE BOGOTA DC"



rename MUNICIPIO municipio
rename DEPARTAMENTO departamento
sort departamento municipio

drop if municipio==""

merge m:m departamento municipio using "controls_municodes.dta"
drop if _merge==2
drop _merge

save `var'.dta,replace
}




foreach var in ingreso_SPOA ingreso_SIJUF acu_SPOA acu_SIJUF{

use `var'.dta
keep if DELITO=="ALTERACION DE RESULTADOS ELECTORALES ART. 394  C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito manipulating_`var'
save `var'_manipulating.dta, replace

use `var'.dta
keep if DELITO=="CONSTREÑIMIENTO AL SUFRAGANTE ART. 387 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito intimidation_`var'
save `var'_intimidating.dta, replace

use `var'.dta
keep if DELITO=="CORRUPCION DE SUFRAGANTE ART. 390 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito vb_`var'
save `var'_vote_vuying.dta, replace

use `var'.dta
keep if DELITO=="FRAUDE AL SUFRAGANTE ART. 388 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito information_`var' 
save `var'_information.dta , replace

use `var'.dta
keep if DELITO=="INTERVENCION EN POLITICA ART. 422 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito polsuport_`var' 
save `var'_pol_suport.dta , replace

use `var'.dta
keep if DELITO=="MORA EN LA ENTREGA DE DOCUMENTOS RELACIONADOS CON UNA VOTACION ART. 393 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito delay_`var'  
save `var'_delay.dta  , replace

use `var'.dta
keep if DELITO=="OCULTAMIENTO, RETENCION Y POSESION ILICITA DE CEDULA ART. 395 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito negtbuying_`var' 
save `var'_neg_t_buying.dta , replace

use `var'.dta
keep if DELITO=="PERTURBACION DE CERTAMEN DEMOCRATICO ART. 386 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito perturbacion_`var' 
save `var'_perturbacion.dta, replace

use `var'.dta
keep if DELITO=="VOTO FRAUDULENTO ART. 391 C.P"
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito irregular_`var'  
save `var'_irregular_voting.dta, replace

use `var'.dta
keep if DELITO=="FRAUDE EN LA INSCRIPCION DE CEDULAS ART. 389 C.P."
drop DELITO municipio departamento
reshape long delito, i(muni_code) j(year)
rename delito f_irregular_`var' 
save `var'_f_irregular.dta , replace

}


use controls.dta, clear
keep muni_code year

foreach var1 in ingreso_SPOA ingreso_SIJUF acu_SPOA acu_SIJUF{
foreach var2 in f_irregular irregular_voting perturbacion neg_t_buying delay pol_suport information vote_vuying intimidating manipulating{
merge 1:1 muni_code year using "`var1'_`var2'.dta"
drop if _merge==2
drop _merge
}
}


rename  f_irregular_ingreso_SPOA f_irregular_voting_a
label var f_irregular_voting_a "Facilitating irregular voting (reports SPOA)"
rename irregular_ingreso_SPOA irregular_voting_a 
label var irregular_voting_a "Voting without being registered/ Voting twice (reports SPOA)"
rename  perturbacion_ingreso_SPOA perturbacion_a
label var perturbacion_a "Action that inhibits voting (reports SPOA)"
rename  negtbuying_ingreso_SPOA neg_t_buying_a
label var neg_t_buying_a "Negative turnout buying (reports SPOA)"
rename  delay_ingreso_SPOA delay_a
label var delay_a "Unjustified delays with materials in voting station (reports SPOA)"
rename  polsuport_ingreso_SPOA pol_suport_a
label var pol_suport_a "Using public policy to help a candidate during campaign (reports SPOA)"
rename  information_ingreso_SPOA information_a
label var information_a "False information to induce voting/abstention (reports SPOA)"
rename  vb_ingreso_SPOA vote_buying_a
label var vote_buying_a "Payments to induce voting for a given candidate (reports SPOA)"
rename  intimidation_ingreso_SPOA intimidation_a
label var intimidation_a "Threats to induce voting/abstention (reports SPOA)"
rename  manipulating_ingreso_SPOA manipulating_results_a
label var manipulating_results_a "Manipulating results (e.g. double counting) (reports SPOA)"

rename  f_irregular_ingreso_SIJUF f_irregular_voting_b 
label var f_irregular_voting_b "Facilitating irregular voting (reports SIJUF)"
rename  irregular_ingreso_SIJUF irregular_voting_b
label var irregular_voting_b "Voting without being registered/ Voting twice (reports SIJUF)"
rename  perturbacion_ingreso_SIJUF perturbacion_b
label var perturbacion_b "Action that inhibits voting (reports SIJUF)"
rename  negtbuying_ingreso_SIJUF neg_t_buying_b
label var neg_t_buying_b "Negative turnout buying (reports SIJUF)"
rename delay_ingreso_SIJUF delay_b 
label var delay_b "Unjustified delays with materials in voting station (reports SIJUF)"
rename  polsuport_ingreso_SIJUF pol_suport_b
label var pol_suport_b "Using public policy to help a candidate during campaign (reports SIJUF)"
rename  information_ingreso_SIJUF information_b
label var information_b "False information to induce voting/abstention (reports SIJUF)"
rename  vb_ingreso_SIJUF vote_buying_b
label var vote_buying_b "Payments to induce voting for a given candidate (reports SIJUF)"
rename  intimidation_ingreso_SIJUF intimidation_b
label var intimidation_b "Threats to induce voting/abstention (reports SIJUF)"
rename  manipulating_ingreso_SIJUF manipulating_results_b
label var manipulating_results_b "Manipulating results (e.g. double counting) (reports SIJUF)"


rename  f_irregular_acu_SPOA f_irregular_voting_c
label var f_irregular_voting_c "Facilitating irregular voting (accusations  SPOA)"
rename irregular_acu_SPOA irregular_voting_c 
label var irregular_voting_c "Voting without being registered/ Voting twice (accusations  SPOA)"
rename  perturbacion_acu_SPOA perturbacion_c
label var perturbacion_c "Action that inhibits voting (accusations  SPOA)"
rename  negtbuying_acu_SPOA neg_t_buying_c
label var neg_t_buying_c "Negative turnout buying (accusations  SPOA)"
rename  delay_acu_SPOA delay_c
label var delay_c "Unjustified delays with materials in voting station (accusations  SPOA)"
rename  polsuport_acu_SPOA pol_suport_c
label var pol_suport_c "Using public policy to help a candidate during campaign (accusations  SPOA)"
rename  information_acu_SPOA information_c
label var information_c "False information to induce voting/abstention (accusations  SPOA)"
rename  vb_acu_SPOA vote_buying_c
label var vote_buying_c "Payments to induce voting for a given candidate (accusations  SPOA)"
rename  intimidation_acu_SPOA intimidation_c
label var intimidation_c "Threats to induce voting/abstention (accusations  SPOA)"
rename  manipulating_acu_SPOA manipulating_results_c
label var manipulating_results_c "Manipulating results (e.g. double counting) (accusations  SPOA)"


rename  f_irregular_acu_SIJUF f_irregular_voting_d
label var f_irregular_voting_d "Facilitating irregular voting (accusations  SIJUF)"
rename irregular_acu_SIJUF irregular_voting_d 
label var irregular_voting_d "Voting without being registered/ Voting twice (accusations  SIJUF)"
rename  perturbacion_acu_SIJUF perturbacion_d
label var perturbacion_d "Action that inhibits voting (accusations  SIJUF)"
rename  negtbuying_acu_SIJUF neg_t_buying_d
label var neg_t_buying_d "Negative turnout buying (accusations  SIJUF)"
rename  delay_acu_SIJUF delay_d
label var delay_d "Unjustified delays with materials in voting station (accusations  SIJUF)"
rename  polsuport_acu_SIJUF pol_suport_d
label var pol_suport_d "Using public policy to help a candidate during campaign (accusations  SIJUF)"
rename  information_acu_SIJUF information_d
label var information_d "False information to induce voting/abstention (accusations  SIJUF)"
rename  vb_acu_SIJUF vote_buying_d
label var vote_buying_d "Payments to induce voting for a given candidate (accusations  SIJUF)"
rename  intimidation_acu_SIJUF intimidation_d
label var intimidation_d "Threats to induce voting/abstention (accusations  SIJUF)"
rename  manipulating_acu_SIJUF manipulating_results_d
label var manipulating_results_d "Manipulating results (e.g. double counting) (accusations  SIJUF)"


foreach var1 in a b{
foreach var2 in f_irregular_voting irregular_voting perturbacion neg_t_buying delay pol_suport information vote_buying intimidation manipulating_results{
replace `var2'_`var1'=0 if  `var2'_`var1'==.&year>=2008 
}
}

foreach var1 in c{
foreach var2 in f_irregular_voting irregular_voting perturbacion neg_t_buying delay pol_suport information vote_buying intimidation manipulating_results{
replace `var2'_`var1'=0 if  `var2'_`var1'==.&year>=2006 
}
}
 
foreach var1 in d{
foreach var2 in f_irregular_voting irregular_voting perturbacion neg_t_buying delay pol_suport information vote_buying intimidation manipulating_results{
replace `var2'_`var1'=0 if  `var2'_`var1'==.&year>=2002 
}
}


save new_citizens_rep.dta, replace


foreach var1 in ingreso_SPOA ingreso_SIJUF acu_SPOA acu_SIJUF{
foreach var2 in f_irregular irregular_voting perturbacion neg_t_buying delay pol_suport information vote_vuying intimidating manipulating{
erase `var1'_`var2'.dta
}
}
erase acu_SIJUF.dta
erase acu_SPOA.dta
erase ingreso_SIJUF.dta
erase ingreso_SPOA.dta
