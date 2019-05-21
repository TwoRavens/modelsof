***************************************************************************
* File:               2010_dep_var.do
* Author:             Miguel R. Rueda
* Description:        Creates dataset with total monitors' reports per municipality for 2010.  
* Created:            September - 22 - 2015
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************

cd "\Datasets\Dep_vars\"
set more off
foreach file in 2010_pres_May 2010_pres_Jun{

*Aggregating congressional election reports
use `file'.dta, clear


gen municipio=lower(Municipio)
drop Municipio


gen departamento=lower(Departamento)
drop Departamento

*Taking out tildes, ñ and others
foreach var in municipio departamento{
	gen ciu=regexr(`var',"á","a")
	gen ciu1=regexr(ciu,"é","e")
	gen ciu2=regexr(ciu1,"í","i")
	gen ciu3=regexr(ciu2,"ú","u")
	gen ciu4=regexr(ciu3,"ñ","n")
	gen ciu5=regexr(ciu4,"ó","o")
	gen ciu6=regexr(ciu5,"ü","u")
	drop ciu5 ciu4 ciu3 ciu2 ciu1 ciu `var'
	rename ciu6 `var'
}

*These are name changes to facilitate the merge with election variables

*Departments' name changes
replace departamento="bogota" if departamento=="bogota d.c."
replace departamento="guajira" if departamento=="guajira, la"
replace departamento="valle" if departamento=="valle del cauca"
replace departamento="bogota" if municipio=="bogota"

replace municipio="alban" if municipio=="alban (san jose)"
replace municipio="el carmen de viboral" if municipio=="carmen de viboral"
replace municipio="chibolo" if municipio=="chivolo"
replace municipio="calima (darien)" if municipio=="darien (calima)"
replace municipio="orito" if municipio=="el orito"
replace municipio="puerto nare (la magdalena)" if municipio=="puerto nare"
replace municipio="pasto" if municipio=="san juan de pasto"
replace municipio="santa rosa de cabal" if municipio=="santarosa de cabal"
replace municipio="tierralta" if municipio=="tierralta (alto sinu)"
replace municipio="guadalajara de buga" if municipio=="buga"
replace municipio="cartagena del chaira" if municipio=="cartagena de chaira"
replace municipio="cerro san antonio" if municipio=="cerro de san antonio"
replace municipio="chalan (ricaurte)" if municipio=="chalan"
replace municipio="genova" if municipio=="colon (genova)"
replace municipio="el tablon de gomez" if municipio=="el tablon"
replace municipio="guadalupe" if municipio=="gudalupe"
replace municipio="santa barbara (iscuande)" if municipio=="iscuande (el charco)"
replace municipio="la argentina" if municipio=="la argentina (plata vieja)"
replace municipio="la jagua de ibirico" if municipio=="la jagua ibirico"
replace municipio="lopez" if municipio=="lopez de micay"
replace municipio="magui" if municipio=="magui- payan (julio plaza)"
replace municipio="mallama" if municipio=="mallama (piedrancha)"
replace municipio="paez" if municipio=="paez (belalcazar)"
replace municipio="patia" if municipio=="patia (el bordo)"
replace municipio="inirida" if municipio=="pto inirida"
replace municipio="puebloviejo" if municipio=="pueblo viejo"
replace municipio="puerto boyaca (puerto vasquez)" if municipio=="puerto boyaca"
replace municipio="leguizamo" if municipio=="puerto leguizamo"
replace municipio="apulo (rafael reyes)" if municipio=="rafael reyes (apulo)"
replace municipio="rio viejo (olaya herrera)" if municipio=="rioviejo"
replace municipio="san andres sotavento" if municipio=="san andres de sotavento"
replace municipio="san bernardo" if municipio=="san bernando"
replace municipio="montelibano" if municipio=="san jose de uré"
replace municipio="san jose del fragua" if municipio=="san jose fragua"
replace municipio="san juan de rio seco" if municipio=="san juan de rioseco"
replace municipio="cubarral" if municipio=="san luis de cubarral"
replace municipio="san pedro" if municipio=="san pedro de los milagros"
replace municipio="san pablo de borbur" if municipio=="sanpablo de borbur"
replace municipio="santa barbara de pinto" if municipio=="santa barbara de pin"
replace municipio="santa cruz" if municipio=="santa cruz (guachaves)"
replace municipio="sotara" if municipio=="sotara (paispamba)"
replace municipio="tisquisio" if municipio=="tiquisio"
replace municipio="piendamo (tunia)" if municipio=="tunia (piendamo)"
replace municipio="tutaza" if municipio=="tutasa"
replace municipio="villa de san diego de ubate" if municipio=="ubate"
replace municipio="valle del guamuez" if municipio=="valle guamuez"
replace municipio="villa del rosario" if municipio=="villa rosario"
replace municipio="villagarzon (villa amazonica)" if municipio=="villagarzon (villa amazónica)"
replace municipio="vistahermosa" if municipio=="vista hermosa"
replace municipio="cuaspud" if municipio=="cuaspud - carlosama"
replace municipio="santacruz" if municipio=="santa cruz"
replace municipio="el santuario" if municipio=="santuario"&departamento=="antioquia"
replace municipio="el carmen de atrato" if municipio=="el carmen"&departamento=="choco"
replace municipio="el carmen de chucuri" if municipio=="el carmen"&departamento=="santander"
replace municipio="colon" if municipio=="genova"
replace municipio="venecia (ospina perez)" if municipio=="ospina perez (venecia)"
replace municipio="utica" if municipio=="Útica"

*Merging with population codes
sort municipio departamento

sort municipio departamento
merge m:1 municipio departamento using code_muni_cede.dta
drop if _merge==2
drop _merge

*Changing variable names
foreach var in l__Utilizar_el_empleo_para_presi p__Constreñimiento_al_sufragante q__Fraude_en_la_inscripción_de_c t__Voto_Fraudulento__Suplantació ///
w__Ocultamiento__retención_o_pos x__Corrupción_de_Sufragante__Com ff__Incumplimiento_de_procedimie gg__Falta_de_material_electoral hh__Traslado_de_mesas_de_votació{
recode `var' (.=0)
}

gen intimidation=l__Utilizar_el_empleo_para_presi+p__Constreñimiento_al_sufragante
drop l__Utilizar_el_empleo_para_presi p__Constreñimiento_al_sufragante

rename q__Fraude_en_la_inscripción_de_c moving_votes
rename w__Ocultamiento__retención_o_pos neg_t_buying
rename x__Corrupción_de_Sufragante__Com vote_buying
rename t__Voto_Fraudulento__Suplantació irregular_voting


drop hh__Traslado_de_mesas_de_votació gg__Falta_de_material_electoral ff__Incumplimiento_de_procedimie id Fecha Hora Receptor Lugar

order muni_code municipio departamento

save `file'_m.dta,replace

*Keeping only high reliability reports
keep if Confiabilidad=="Alta"
collapse  (sum) vote_buying moving_votes neg_t_buying intimidation irregular_voting, by(muni_code)

save `file'muni.dta,replace
}

*Appending both datasets
append using 2010_pres_Maymuni.dta
collapse  (sum) vote_buying moving_votes neg_t_buying intimidation irregular_voting, by(muni_code)
gen year=2010
gen type=2
order muni_code year
label var type "Election Type"

save 2010munif_depvar.dta,replace


*Opening dataset with all municipalities where the Mision de Observacion Electoral had presence
use monitors_2010P_b.dta,clear
merge 1:1 muni_code using 2010munif_depvar.dta
*For now let's eliminate those reports from places where there was no MOE presence
*drop if _merge==2

*Filling with zeros where there was MOE presence but not reports
foreach var in vote_buying moving_votes neg_t_buying intimidation irregular_voting{
replace `var'=0 if `var'==.
}

drop _merge
sort muni_code year
recode type (.=2)


gen fraud=0

replace fraud=1 if muni_code==11001|muni_code==8001|muni_code==76001


gen total_moe=vote_buying+moving_votes+neg_t_buying+intimidation+fraud

save 2010munif_depvar.dta,replace

erase 2010_pres_May_m.dta
erase 2010_pres_Jun_m.dta
erase 2010_pres_Maymuni.dta
erase 2010_pres_Junmuni.dta
