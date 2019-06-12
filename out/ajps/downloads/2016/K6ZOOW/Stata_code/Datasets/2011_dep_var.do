***************************************************************************
* File:               2011_dep_var.do
* Author:             Miguel R. Rueda
* Description:        Creates dataset with total monitors' reports per municipality for 2011.  
* Created:            September - 22 - 2015
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************

cd "\Datasets\Dep_vars\"

set more off

foreach file in 2011_elec 2011_pre_elec 2011_post_elec{
 
*Aggregating local election reports
use `file', clear

*Eliminate reports from outside the country
drop if Departamento=="Exterior"

gen municipio=lower(Ciudad)
drop Ciudad

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

*Department changes
replace departamento="bogota" if departamento=="bogota d.c."
replace departamento="guajira" if departamento=="guajira, la"
replace departamento="valle" if departamento=="valle del cauca"

*Common name fixes from electoral files
replace municipio="alban" if municipio=="alban (san jose)"
replace municipio="el carmen de viboral" if municipio=="carmen de viboral"
replace municipio="chibolo" if municipio=="chivolo"
replace municipio="calima (darien)" if municipio=="darien (calima)"
replace municipio="orito" if municipio=="el orito"
replace municipio="puerto nare (la magdalena)" if municipio=="puerto nare"
replace municipio="pasto" if municipio=="san juan de pasto"
replace municipio="santa rosa de cabal" if municipio=="santarosa de cabal"
replace municipio="tierralta" if municipio=="tierralta (alto sinu)"

*Changes from pre_elec file
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

*Changes from post_elec file
replace municipio="venecia (ospina perez)" if municipio=="ospina perez (venecia)"
replace municipio="utica" if municipio=="Útica"


*Generating dependent variables
egen float sub_cat = group(Sub_categoría), missing label

gen vote_buying=cond(Sub_categoría=="Compra de votos",1,0)
gen moving_votes=cond((Sub_categoría=="Trasteo de votantes"),1,0)
gen neg_t_buying=cond((Sub_categoría=="Exclusión ilegal del cédulas")|(Sub_categoría=="Sub_categoría"),1,0)
gen intimidation=cond((Sub_categoría=="Agresiones")|(Sub_categoría=="Amenazas"),1,0)
gen fraud=cond((Sub_categoría=="Escrutinios")|(Delito=="Alteración de resultados electorales,"),1,0)
gen perturbacion=cond((Sub_categoría=="Disturbios")|(Sub_categoría=="Asonadas,"),1,0)
gen pol_suport=cond((Sub_categoría=="Utilizar empleo público en favor o en contra de candidato"),1,0)
gen f_irregular_voting=cond(Delitos=="Favorecimiento de voto fraudulento,",1,0)
gen information=cond(Sub_categoría=="Engaño al sufragante",1,0)

*Merging to have the department code and municipal code
sort municipio departamento
merge m:1 municipio departamento using code_muni_cede.dta

*The only one eliminated in elec does not have reports
drop if (_merge==2|_merge==1)
drop _merge

order dpto_code departamento muni_code municipio

*Generating variable for evidence sent over the internet
gen evidence=cond(Adjuntos!="",1,0)

save `file'_m.dta,replace

*Generating database at the municipality level taking only reliable reports
keep if Confiabilidad=="Alta"
collapse  (sum) vote_buying moving_votes neg_t_buying intimidation fraud perturbacion pol_suport f_irregular_voting information, by(muni_code)
save `file'muni.dta,replace

}


append using 2011_pre_elecmuni.dta
append using 2011_elecmuni.dta

collapse  (sum) vote_buying moving_votes neg_t_buying intimidation fraud perturbacion pol_suport f_irregular_voting information, by(muni_code)
gen year=2011
order year muni_code
sort muni_code
save 2011munif_depvar.dta,replace

*Opening dataset with all municipalities where the MOE had presence
use monitors_2011_b.dta,clear
merge 1:1 muni_code using 2011munif_depvar.dta


*Filling with zeros where there was MOE presence but not reports
foreach var in vote_buying moving_votes neg_t_buying intimidation fraud perturbacion pol_suport f_irregular_voting information{
replace `var'=0 if `var'==.
}

drop _merge
sort muni_code year

gen type=3

gen total_moe= vote_buying+moving_votes+neg_t_buying+intimidation+fraud

save 2011munif_depvar.dta,replace

erase 2011_elec_m.dta
erase 2011_pre_elec_m.dta
erase 2011_post_elec_m.dta

erase 2011_elecmuni.dta
erase 2011_pre_elecmuni.dta
erase 2011_post_elecmuni.dta
