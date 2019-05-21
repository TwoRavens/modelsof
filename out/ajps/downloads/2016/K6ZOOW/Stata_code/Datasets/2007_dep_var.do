***************************************************************************
* File:               2007_dep_var.do
* Author:             Miguel R. Rueda
* Description:        Creates dataset with total monitors' reports for 2007.  
* Created:            September - 22 - 2015
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************




 

cd "\Datasets\Dep_vars\"

use 2007f4.dta,clear

*Transforming to numeric values, adding labels and names

*Form F4 -moving election monitors-
encode p3a , generate(armed)
drop p3a
recode armed (1=0)(2=1)
label define armedl 0 "no" 1 "si" 
label val armed armedl
label var armed "Observo actores armados ilegales en las calles?"

encode p4a , generate(moving_votes)
drop p4a
recode moving_votes (1=0)(2=1)
label define moving_votesl 0 "no" 1 "si" 
label val moving_votes moving_votesl
label var moving_votes "Llegaron votantes transportados en medios distintos de transporte ordinario a votar?"

encode p4b , generate(pol_suport1)
drop p4b
recode pol_suport1 (1=0)(2=1)
label define pol_suport1l 0 "no" 1 "si" 
label val pol_suport1 pol_suport1l
label var pol_suport1 "¿Observó carros con distintivos oficiales en actividad política?"

encode p5e , generate(pol_suport2)
drop p5e
recode pol_suport2 (1=0)(2=1)
label define pol_suport2l 0 "no" 1 "si" 
label val pol_suport2 pol_suport2l
label var pol_suport2 "¿Observó autoridades públicas apoyando a un  partido o a un candidato?"

encode p5a, generate(crime_irregularity)
drop p5a
recode crime_irregularity (1=0)(2=1)
label define crime_irregularityl 0 "no" 1 "si" 
label val crime_irregularity crime_irregularityl
label var crime_irregularity "Observo alguna irregularidad o ilegalidad?"

encode p5a1, generate(type_crime_irregularity)
drop p5a1
label var type_crime_irregularity "Que tipo de irregularidad?"

encode p5b, generate(intimidation)
drop p5b
recode intimidation (1=0)(2=1)
label define intimidationl 0 "no" 1 "si" 
label val intimidation intimidationl
label var intimidation "Observo personas presionando a ciudadanos antes del acto de votacion?"

encode p5c, generate(marked_ballot)
drop p5c
recode marked_ballot (1=0)(2=1)
label define marked_ballotl 0 "no" 1 "si" 
label val marked_ballot marked_ballotl
label var marked_ballot "Observo que se repartieran tarjetones marcados?"

encode p5d, generate(vote_buying)
drop p5d
recode vote_buying (1=0)(2=1)
label define vote_buyingl 0 "no" 1 "si" 
label val vote_buying vote_buyingl
label var vote_buying "Observo que se repartiera dinero o cosas a cambio de votos?"

encode p5f, generate(neg_t_buying)
drop p5f
recode neg_t_buying (1=0)(2=1)
label define neg_t_buyingl 0 "no" 1 "si" 
label val neg_t_buying neg_t_buyingl
label var neg_t_buying "Observo o fue informado de personas repartiendo cedulas de ciudadanía?"

encode p7, generate(difficulty_monitoring)
drop p7
recode difficulty_monitoring (1=0)(2=1)
label define difficulty_monitoringl 0 "no" 1 "si" 
label val difficulty_monitoring difficulty_monitoringl
label var difficulty_monitoring "Tuvo alguna dificultad para desempeñar su rol como observador itinerante?"

*Fixing names of municipalities
replace municipio="bogota" if municipio=="bogotÃ¡"
replace municipio="quibdo" if municipio=="quibdo“"
replace municipio="ibague" if municipio=="ibaguÃ¨"
replace municipio="cachala" if municipio=="cachalÃ¡ cund"
replace municipio="bogota" if municipio=="nn"
replace municipio="pueblo bello" if municipio=="peblo bello"
replace municipio="puerto rico" if municipio=="pto rico"
replace municipio="gachala" if municipio=="cachala"
replace municipio="chiquinquira" if municipio=="chiqinquira"
replace municipio="chibolo" if municipio=="chivolo"
replace municipio="ariguani" if municipio=="dificil"
replace municipio="villa de san diego de ubate" if municipio=="ubate"
replace municipio="magangue" if municipio=="magangué"
replace municipio="maria la baja" if municipio=="marialabaja"
replace municipio="ocana" if municipio=="ocaña"
replace municipio="tesalia (carnicerias)" if municipio=="tesalia"

 
*Fixing names of departments
replace departamento="santander" if departamento=="santadner"
replace departamento="guajira" if departamento=="la guajira"
replace departamento="bogota" if municipio=="bogota"


*Merging to have the department code and municipal code
sort municipio departamento
merge m:1 municipio departamento using code_muni_cede.dta
drop if _merge==2

save 2007f4_m.dta, replace

*Creating dataset F4 at the municipality level
collapse (sum) armed moving_votes crime_irregularity intimidation marked_ballot vote_buying neg_t_buying difficulty_monitoring pol_suport1 pol_suport2 (mean) muni_code ,by(municipio)
gen year=2007

gen pol_suport=pol_suport1+pol_suport2

save 2007munif4.dta, replace

*Form F2 -election monitors at polling station-
*use 2007f2.dta,clear

import excel "F2 Consolidado Nacional 23 nov.xls", sheet("aux2") firstrow clear

rename p3d marked_ballot_f2
label define marked_ballot2l 0 "no" 1 "si" 
label val marked_ballot_f2 marked_ballot2l
label var marked_ballot_f2 "Observo que se repartieran tarjetones marcados?"

gen secret=p4f1+p4f2+p4f3+p4f4+p4f5
drop p4f1 p4f2 p4f3 p4f4 p4f5
label var secret "numero de mesas donde voto era secreto/5"


gen children=p4l1+p4l2+p4l3+p4l4+p4l5
drop p4l1 p4l2 p4l3 p4l4 p4l5


gen camara=p3c
drop p3c
label define camaral 0 "no" 1 "si" 
label val camara camaral
label var camara "Observó personas tomando fotos de los tarjetones?"

rename p7 difficulty_monitoring_f2
label define difficulty_monitoring_f2l 0 "no" 1 "si" 
label val difficulty_monitoring_f2 difficulty_monitoring_f2l
label var difficulty_monitoring_f2 "Tuvo alguna dificultad para observar?"

gen irregular_voting1=p2p
drop p2p
label define irregular_voting1l 0 "no" 1 "si" 
label val irregular_voting1 irregular_voting1l
label var irregular_voting1 "¿Se observó a algún ciudadano votar con un documento diferente a la cédula? "

gen irregular_voting2=p3f
drop p3f
label define irregular_voting2l 0 "no" 1 "si" 
label val irregular_voting2 irregular_voting2l
label var irregular_voting2 "¿Alguna persona votó más de una vez?"

gen neg_t_buying=p3g
drop p3g
label define neg_t_buyingl 0 "no" 1 "si" 
label val neg_t_buying neg_t_buyingl
label var neg_t_buying "¿Alguna persona repartía cédulas de ciudadanía?"
rename neg_t_buying neg_t_buying_f2

gen moving_votes=p3e
drop p3e
label define moving_votesl 0 "no" 1 "si" 
label val moving_votes moving_votesl
label var moving_votes "¿Observó votantes siendo transportados en grupo para votar por un  determinado candidato o partido?"
rename moving_votes moving_votes_f2

*Fixing names of municipalities for future merges
rename Municipio municipio
rename Departamento departamento
replace municipio="ariguani" if municipio=="ariguany"
replace municipio="cajica" if municipio=="cajici"
replace municipio="barranquilla" if municipio=="bafrranquilla"
replace municipio="cerro san antonio" if municipio=="cerro de san antonio"
replace municipio="calarca" if municipio=="calarcá"
replace municipio="bogota" if municipio=="bogota "
replace municipio="cajici" if municipio=="cajicí "
replace municipio="carmen de carupa" if municipio=="carman de garupa"
replace municipio="carmen de carupa" if municipio=="carmen carupa"
replace municipio="cerro de san antonio" if municipio=="ceerro de san antoni"
replace municipio="cerro de san antonio" if municipio=="cerrro de san antoni"
replace municipio="cerro de san antonio" if municipio=="cerro san antonio"
replace municipio="chivolo" if municipio=="chibolo"
replace municipio="cienaga" if municipio=="ciendaga"
replace municipio="cienaga" if municipio=="cienega"
replace municipio="facatativa" if municipio=="factativa"
replace municipio="fundacion" if municipio=="fundacií²n"
replace municipio="fundacion" if municipio=="fundación"
replace municipio="gacheta" if municipio=="gachetí "
replace municipio="pedraza" if municipio=="pedroza"
replace municipio="pijiño del carmen" if municipio=="pijií±o del carmen"
replace municipio="pijiño del carmen" if municipio=="pijiño"
replace municipio="puerto rico" if municipio=="pto rico"
replace municipio="quibdo" if municipio=="quibdó"
replace municipio="ubate" if municipio=="ubalí "
replace municipio="bogota" if municipio=="usaquen localidad 1"
replace municipio="choconta" if municipio=="chocontí "
replace municipio="cienaga" if municipio=="#cienaga grande"
replace municipio="villavicencio" if municipio=="villavicenio"
replace municipio="santa barbara de pin" if municipio=="santa barabra de pin"
replace municipio="santa fe de antioquia" if municipio=="santa fe de antioqui"
replace municipio="ibague" if municipio=="ibaguó¨"
replace municipio="quimbaya" if municipio=="quibaya"
replace municipio="giron" if municipio=="girí__n"
replace municipio="la union" if municipio=="la unión"
replace municipio="piñon" if municipio=="pií±on"
replace municipio="santa barbara de pin" if municipio=="sanat barbara de pin"
replace municipio="medellin" if municipio=="medellín"
replace municipio="sabanas de san angel" if municipio=="sabana"



*Other common name fixes from Mision de Observacion (MOE) files
*Department changes
replace departamento="bogota" if departamento=="bogota d.c."
replace departamento="guajira" if departamento=="guajira, la"
replace departamento="valle" if departamento=="valle del cauca"
replace departamento="santander" if departamento=="santadner"
replace departamento="guajira" if departamento=="la guajira"
replace departamento="bogota" if municipio=="bogota"
replace departamento="quindio" if departamento=="quidnio"
replace departamento="boyaca" if departamento=="boyac a"
replace departamento="norte de santander" if departamento=="nprte de santander"
replace departamento="santander" if departamento=="santan der"
replace departamento="antioquia" if departamento=="ant001"



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

*Name fixes from pre_elec file
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

replace municipio="aracataca" if municipio=="aracata"
replace municipio="cajica" if municipio=="cajici"
replace municipio="el carmen de viboral" if municipio=="carmen"&departamento=="antioquia"
replace municipio="chiquinquira" if municipio=="chiqinquira"
replace municipio="nueva granada" if municipio=="colegio nueva granad"
replace municipio="bogota" if municipio=="bogotÃ¡"
replace municipio="quibdo" if municipio=="quibdo“"
replace municipio="ibague" if municipio=="ibaguÃ¨"
replace municipio="cachala" if municipio=="cachalÃ¡ cund"
replace municipio="bogota" if municipio=="nn"
replace municipio="pueblo bello" if municipio=="peblo bello"
replace municipio="puerto rico" if municipio=="pto rico"
replace municipio="gachala" if municipio=="cachala"
replace municipio="chiquinquira" if municipio=="chiqinquira"
replace municipio="chibolo" if municipio=="chivolo"
replace municipio="ariguani" if municipio=="dificil"
replace municipio="villa de san diego de ubate" if municipio=="ubate"
replace municipio="magangue" if municipio=="magangué"
replace municipio="maria la baja" if municipio=="marialabaja"
replace municipio="ocana" if municipio=="ocaña"
replace municipio="tesalia (carnicerias)" if municipio=="tesalia"


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


sort municipio

save 2007f2_m.dta, replace

*Building database with form F2 at the  municipality level
collapse (sum) marked_ballot_f2 children camara irregular_voting1 irregular_voting2 neg_t_buying  moving_votes (mean) secret ,by(municipio)
gen year=2007

sort municipio

gen irregular_voting=irregular_voting1+irregular_voting2

save 2007munif2.dta, replace

*Merging F2 and F4. Here I am only going to keep municipalities that are observed in the F4 forms

use 2007munif4.dta, clear
sort municipio

merge 1:1 municipio using 2007munif2.dta
drop if _merge==2
drop _merge
order muni_code year

gen type=3

save 2007munif_depvar.dta, replace



*Opening dataset with all municipalities where the MOE had presence
use monitors_2007_b.dta,clear
merge 1:1 muni_code using 2007munif_depvar.dta
*For now let's eliminate those reports from places where there was no MOE presence
*drop if _merge==2


foreach var in vote_buying moving_votes moving_votes_f2 irregular_voting neg_t_buying intimidation marked_ballot_f2 neg_t_buying_f2 pol_suport marked_ballot{
replace `var'=0 if `var'==.
}

drop _merge
sort muni_code year

gen fraud= marked_ballot_f2+ marked_ballot
replace  moving_votes=moving_votes+moving_votes_f2
replace  neg_t_buying=neg_t_buying+neg_t_buying_f2

drop moving_votes_f2 neg_t_buying_f2 marked_ballot_f2 irregular_voting1 irregular_voting2 pol_suport1 pol_suport2

gen total_moe=moving_votes+intimidation+vote_buying+neg_t_buying+fraud


save 2007munif_depvar.dta,replace

*Deleting intermediate auxiliary files
erase 2007munif2.dta
erase 2007munif4.dta
erase 2007f2_m.dta
erase 2007f4_m.dta

