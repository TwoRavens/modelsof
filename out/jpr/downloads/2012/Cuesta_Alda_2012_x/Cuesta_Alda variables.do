
************************************************************
* PROGRAMA DE APOYO A LA CONVIVENCIA Y SEGURIDAD CIUDADANA *

*1/ SOCIOECONOMICS
* It is not possible to define poverty at the household level becuase the number of household members is not reported
* Nevertherless, households' stratum is reported. 
* Birthplace:

encode D03, gen(birthplace)
label var birthplace "birthplace, D03"

gen CALENO=1 if birthplace==57
recode CALENO .=0
label var CALENO "nacido en CALI"


* 2/ CIVISM

* 2.0/ exposure to civic campaigns

gen EXPOSURE_a=1 if CC1A==1
gen EXPOSURE_b=1 if CC1B==1
gen EXPOSURE_c=1 if CC1C==1
gen EXPOSURE_d=1 if CC1D==1
gen EXPOSURE_e=1 if CC1E==1
gen EXPOSURE_f=1 if CC1F==1
gen EXPOSURE_g=1 if CC1G==1

recode EXPOSURE_a .=0
recode EXPOSURE_b .=0
recode EXPOSURE_c .=0
recode EXPOSURE_d .=0
recode EXPOSURE_e .=0
recode EXPOSURE_f .=0
recode EXPOSURE_g .=0

gen EXPOSURE=EXPOSURE_a+EXPOSURE_b+EXPOSURE_c+EXPOSURE_d+EXPOSURE_e+EXPOSURE_f+EXPOSURE_g
drop EXPOSURE_*
label var EXPOSURE "exposure to civic campaigns CC1"



*2.1/ Tolerance to uncivic acts

* Def: Individuals agree fully/agree on uncivic transit acts under seven situations. 
* Description: index from 0 (ideally civic) to 7 (totally uncivic)
* Note that those answering that they dont know or not answering are regarded as fully civic... not big deal as these categories oscilate between 1 and 10 individuals

gen uncivic_tolerance_a=1 if 1<=CC4A & CC4A<=2
gen uncivic_tolerance_b=1 if 1<=CC4B & CC4B<=2
gen uncivic_tolerance_c=1 if 1<=CC4C & CC4C<=2
gen uncivic_tolerance_d=1 if 1<=CC4D & CC4D<=2
gen uncivic_tolerance_e=1 if 1<=CC4E & CC4E<=2
gen uncivic_tolerance_f=1 if 1<=CC4E & CC4E<=2
gen uncivic_tolerance_g=1 if 1<=CC4E & CC4E<=2

recode uncivic_tolerance_a .=0
recode uncivic_tolerance_b .=0
recode uncivic_tolerance_c .=0
recode uncivic_tolerance_d .=0
recode uncivic_tolerance_e .=0
recode uncivic_tolerance_f .=0
recode uncivic_tolerance_g .=0

gen uncivic_tolerance=uncivic_tolerance_a+uncivic_tolerance_b+uncivic_tolerance_c+uncivic_tolerance_d+uncivic_tolerance_e+uncivic_tolerance_f+uncivic_tolerance_g

drop uncivic_tolerance_a  uncivic_tolerance_b uncivic_tolerance_c uncivic_tolerance_d uncivic_tolerance_e uncivic_tolerance_f uncivic_tolerance_g

label var uncivic_tolerance "indice de estar 'totalmente de acuerdo' o 'de acuerdo' en justificar actos no civicos de transito de CC4"


*2.2/ Civic messages conveyed to the public

* Def: individuals report to perceive positive messages on civism from youth mimes
* Description: individuals report 'Yes' to the question of mimes acting transmitted positive messages from question CC3
* Those reporting 'dont remember or n.a' are considered not to have received such messages
* One of the questions is 'trust in people', option 'g'. Interesting to separate. 

gen civic_messages_a=1 if CC3A==1
gen civic_messages_b=1 if CC3B==1
gen civic_messages_c=1 if CC3C==1
gen civic_messages_d=1 if CC3D==1
gen civic_messages_e=1 if CC3E==1
gen civic_messages_f=1 if CC3F==1
gen civic_messages_g=1 if CC3G==1
gen civic_messages_h=1 if CC3H==1

recode civic_messages_a .=0
recode civic_messages_b .=0
recode civic_messages_c .=0
recode civic_messages_d .=0
recode civic_messages_e .=0
recode civic_messages_f .=0
recode civic_messages_g .=0
recode civic_messages_h .=0

gen civic_messages=civic_messages_a+civic_messages_b+civic_messages_c+civic_messages_d+civic_messages_e+civic_messages_f+civic_messages_g+civic_messages_h
recode civic_messages .=0
label var civic_messages "mensajes civicos transmitidos por mimos, CC3"

rename civic_messages_g civic_messages_trust
label var civic_messages_trust "mensaje civico de confianza en las personas, CC3G"

drop civic_messages_a civic_messages_b civic_messages_c civic_messages_d civic_messages_e civic_messages_f civic_messages_h


*2.3/ Reaction to uncivic acts

* Ideally one would like to have information on EACH individual but not all of them report to have seen uncivic acts.
* so, we can construct an index of reaction to uncivic acts by COMUNA. Comuna reports sufficient observations. Barrios report too few observations
* Def: grade of civic reaction to uncivic acts by comuna
* Description: three types of answers: 0: n.a.; 1: didnt do anything; 2: did something civic as to report to police or try dialogue; 1: use violence

gen civic_reaction_a=2 if CC9AREAC==1
replace civic_reaction_a=3 if 2<=CC9AREAC & CC9AREAC<=3
replace civic_reaction_a=1 if CC9AREAC==4
recode civic_reaction_a .=0

gen civic_reaction_b=2 if CC9BREAC==1
replace civic_reaction_b=3 if 2<=CC9BREAC & CC9BREAC<=3
replace civic_reaction_b=1 if CC9BREAC==4
recode civic_reaction_b .=0

gen civic_reaction_c=2 if CC9CREAC==1
replace civic_reaction_c=3 if 2<=CC9CREAC & CC9CREAC<=3
replace civic_reaction_c=1 if CC9CREAC==4
recode civic_reaction_c .=0

gen civic_reaction_d=2 if CC9DREAC==1
replace civic_reaction_d=3 if 2<=CC9DREAC & CC9DREAC<=3
replace civic_reaction_d=1 if CC9DREAC==4
recode civic_reaction_d .=0

gen civic_reaction_e=2 if CC9EREAC==1
replace civic_reaction_e=3 if 2<=CC9EREAC & CC9EREAC<=3
replace civic_reaction_e=1 if CC9EREAC==4
recode civic_reaction_e .=0

gen civic_reaction_f=2 if CC9FREAC==1
replace civic_reaction_f=3 if 2<=CC9FREAC & CC9FREAC<=3
replace civic_reaction_f=1 if CC9FREAC==4
recode civic_reaction_f .=0 

gen civic_reaction_g=2 if CC9GREAC==1
replace civic_reaction_g=3 if 2<=CC9GREAC & CC9GREAC<=3
replace civic_reaction_g=1 if CC9GREAC==4
recode civic_reaction_g .=0

gen civic_reaction=civic_reaction_a+civic_reaction_b+civic_reaction_c+civic_reaction_d+civic_reaction_e+civic_reaction_f+civic_reaction_g
replace civic_reaction=(civic_reaction/21)*100
egen civic_reaction_comuna=mean(civic_reaction), by(COMUNA)

label var civic_reaction_comuna "indice de 0 a 100 sobre el grado de reaccion civica ante hechos no civicos a nivel comuna, CC9REAC"
drop civic_reaction_a civic_reaction_b civic_reaction_c civic_reaction_d civic_reaction_e civic_reaction_f civic_reaction_g  civic_reaction




*3/ SECURITY

*3.1/ PERCEPTION OF SECURITY: As in PS1

* 3.2/ BEHAVIOURAL CHANGE DUE TO SECURITY CONCERNS
* Def: individuals changes behaviour in five areas due to security concerns: min 0, max 5


gen behaviour_change_a=1 if PS2A==1
gen behaviour_change_b=1 if PS2B==1
gen behaviour_change_c=1 if PS2C==1
gen behaviour_change_d=1 if PS2D==1
gen behaviour_change_e=1 if PS2E==1

recode behaviour_change_a .=0
recode behaviour_change_b .=0
recode behaviour_change_c .=0
recode behaviour_change_d .=0
recode behaviour_change_e .=0

gen behaviour_change=behaviour_change_a+behaviour_change_b+behaviour_change_c+behaviour_change_d+behaviour_change_e
recode behaviour_change .=0

drop behaviour_change_a behaviour_change_b behaviour_change_c behaviour_change_d behaviour_change_e

label var behaviour_change "index of behavioural change due to insecurity: PS2"


*3.3/ CAUSE OF INSECURITY 
**********************************************************************************
*** HYPOTHESIS OF BROKEN WINDOWS VS. SOCIAL CAPITAL VS. INSTITUTIONAL PRESENCE ***
*** part of the story section for Cali!!! 						 ***
**********************************************************************************

* Def: Three different sources of insecurity in the comuna can be worked out: one related to the broken windows, the other related to social capital and the third related to institutional presence
* Description: Broken windows refer to robos, riñas, pandillas, negocios que generan desconfianza, jovenes desocupados, venta y consumo de drogas
* Social capital captured by 'desunion de las personas en el barrio'
* Institucional presence: poca presencia de la policia y poca presencia y acccion de las instituciones publicas del sector

gen broken_window_a=1 if PS3A==1 
gen broken_window_b=1 if PS3B==1
gen broken_window_c=1 if PS3C==1
gen broken_window_d=1 if PS3D==1
gen broken_window_e=1 if PS3E==1
gen broken_window_i=1 if PS3I==1
gen broken_window=broken_window_a+broken_window_b+broken_window_c+broken_window_d+broken_window_e+broken_window_i
recode broken_window .=0
label var broken_window "broken window reported by individual on his/her barrio, PS3"
drop broken_window_a broken_window_b broken_window_c broken_window_d broken_window_e broken_window_i 


gen institutional_absence=2 if PS3F==2 & PS3G==2
replace institutional_absence=1 if PS3F==1 & PS3G==2
replace institutional_absence=1 if PS3F==2 & PS3G==1
replace institutional_absence=0 if PS3F==1 & PS3G==1
recode institutional_absence .=0
label var institutional_absence "poca presencia de policia e instituciones publicas en el sector"


gen no_socialcapital=1 if PS3H==1
recode no_socialcapital .=0
label var no_socialcapital "desunion entre las personas del barrio/sector"


*3.4/ SECURITY FACTORS
*****************************************************************************************
* HYPOTHESIS: EFFECTIVENESS OF DETERRANCE VS. SOCIAL CAPITAL VS. INSTITUTIONAL PRESENCE *
* PART OF THE STORY OF CALI 										    *
*****************************************************************************************

***** KEY !!!! *************************
***************************************

* Here we want to separate factors of DETERRANCE from others of institutional presence and social capital
* Using PS4!
* Interestingly, some of these categories can be singled out, such as presence of institutions of edu, health and justice and security projects

gen deterrance_a=1 if PS4A==1 
gen deterrance_c=1 if PS4C==1
recode deterrance_a .=0
recode deterrance_c .=0
gen deterrance=1 if 0<deterrance_a+deterrance_c
recode deterrance .=0
label var deterrance "presencia de vigilancia privada y presencia policial" 

gen solidaridad_vecinal=1 if PS4B==1 
gen grupos_com=1 if PS4F==1
gen mesas_conviv=1 if PS4G==1
gen ong=1 if PS4H==1
recode solidaridad_vecinal .=0
recode grupos_com .=0
recode mesas_conviv .=0
recode ong .=0
gen accion_comunitaria=1 if 1<=solidaridad_vecinal+mesas_conviv+grupos_com+ong
recode accion_comunitaria .=0
label var accion_comunitaria "solidaridad, grupos comunitarios, mesas de convivencia y/o ong; PS4"



gen security_institutions_d=1 if PS4D==1
gen security_institutions_e=1 if PS4E==1
recode security_institutions_d .=0
recode security_institutions_e .=0
gen security_institutions=1 if 1<=security_institutions_d+security_institutions_e
recode security_institutions .=0
label var security_institutions "presencia de instituciones publicas de salud, edu, justicia + proyectos de convivencia ciudadana"
 
rename deterrance_c presencia_policia
rename security_institutions_d presencia_publica
rename security_institutions_e proyectos_conviv

label var presencia_policia "policia presente"
label var presencia_publica "presencia de instituciones publicas de edu, salud, justicia, etc"
label var proyectos_conviv "proyectos de convivencia"
label var mesas_conviv "mesas y comites de convivencia"

drop solidaridad_vecinal grupos_com ong 


* 3.5/ JOVENES PROBLEMATICOS
* Def: problematic youths wasting time and consuming drugs vs. other involved in artistic, recreational and physical reconstruction activities
* Using PS11 in a sort of index, when people respond that the 'majority' of youths are in troublesome activities

********* POSSIBLE PERVERSE CAPITAL !!!!! Ho


gen trouble_youth_C=1 if PS11C==1
gen trouble_youth_D=1 if PS11D==1
recode trouble_youth_C .=0
recode trouble_youth_D .=0

gen trouble_youth=trouble_youth_C+trouble_youth_D
replace trouble_youth=1 if trouble_youth==2
recode trouble_youth .=0
label var trouble_youth "youths are reported to waste time and/or consume drugs" 
drop trouble_youth_C trouble_youth_D




*4/ VICTIMIZACION
************************************************
* PART OF THE STORY OF CALI ********************
************************************************

*4.1/ TIPOS DE VICTIMIZACION
gen HURTO=PS5F1
replace HURTO=0 if PS5F==2
replace HURTO=0 if PS5F==8
* number of '8' is about 5... not much an error
recode HURTO .=0
label var HURTO "numero de hurtos sufridos por indiv u hogar en 12 meses"

gen PS5G1_0=PS5G1
recode PS5G1 .=0
gen PS5H1_0=PS5H1
recode PS5H1_0 .=0
gen PS5N1_0=PS5N1
recode PS5N1_0 .=0

gen AMENAZAS=PS5G1_0+PS5H1_0+PS5N1_0
replace AMENAZAS=0 if PS5G1==0 & PS5H1==0 & PS5N1==0
replace AMENAZAS=0 if PS5G==8 & PS5H==8 & PS5N==0
recode AMENAZAS .=0 
label var AMENAZAS "numero de amenazas por dinero, para sacar de casa, o de daños en ult 12 meses"

gen BEATING=PS5I1
replace BEATING=0 if PS5I==0
replace BEATING=0 if PS5I==8
recode BEATING .=0
label var BEATING "golpizas en ult 12 meses"

gen BEATINGPOL=PS5J1
replace BEATINGPOL=0 if PS5J==0
replace BEATINGPOL=0 if PS5J==8
recode BEATINGPOL .=0
label var BEATINGPOL "golpizas de la policia en ult 12 meses"

gen INJURIES=PS5K1
replace INJURIES=0 if PS5K==0
replace INJURIES=0 if PS5K==8
label var INJURIES "heridas por arma blanca o de fuego ult 12 meses"

gen SEXOFFENCE=PS5L1
replace SEXOFFENCE=0 if PS5L==0
replace SEXOFFENCE=0 if PS5L==8
label var SEXOFFENCE "violacion o abuso sexual ult 12 meses"

gen PROPERTYOFFENCE=PS5M1
replace PROPERTYOFFENCE=0 if PS5M==0
replace PROPERTYOFFENCE=8 if PS5M==8
label var PROPERTYOFFENCE "daño a bienes ult 12 meses"

gen SECUESTRO=PS5O1
replace SECUESTRO=0 if PS5O==0
replace SECUESTRO=0 if PS5O==8
label var SECUESTRO "secuestros en el hogar ult 12 meses"

gen ASESINATO=PS5P1
replace ASESINATO=0 if PS5P==0
replace ASESINATO=0 if PS5P==8
label var ASESINATO "asesinatos en el hogar ult 12 meses"

gen VIF=PS5Q1
replace VIF=0 if PS5Q==0
replace VIF=0 if PS5Q==8
label var VIF "violencia intrafamiliar en el hogar ult 12 meses"


gen VICTIMIZACION=HURTO+AMENAZAS+BEATING+BEATINGPOL+INJURIES+SEXOFFENCE+PROPERTYOFFENCE+SECUESTRO+ASESINATO+VIF
recode VICTIMIZACION .=0
label var VICTIMIZACION "victima de cualquier tipo el ind o su hogar en los ult 12 meses"


*4.2/ PERCEPCION DE VIOLENCIA EN ULTIMOS 6 MESES
gen SEG_MEJOR=1 if PS6==1
gen SEG_PEOR=1 if PS6==2
gen SEG_IGUAL=1 if PS6==3
recode SEG_MEJOR .=0
recode SEG_PEOR .=0
recode SEG_IGUAL .=0
label var SEG_MEJOR "percepcion de seguridad aumenta en ult 6 meses en el sector"
label var SEG_PEOR "percepcion de seguridad disminuye en ult 6 meses en el sector"
label var SEG_IGUAL "percepcion de seguridad sigue igual en ult 6 meses en el sector"

*4.3/ ACEPTACION DE LA FUERZA PARA SOLUCIONAR INSEGURIDAD
* Def. Individuo esta totalmente de acuerdo o de acuerdo en matar o tener un arma para garantizar su seguridad en diferentes situaciones
* Usamos PS7's

******* VIGILANTE FORCE ****************************
*********************************************************
* substituto en ausencia de instituciones


gen TOLERANCIA_MATAR_A=1 if 1<=PS7A & PS7A<=2
gen TOLERANCIA_MATAR_B=1 if 1<=PS7B & PS7B<=2
gen TOLERANCIA_MATAR_C=1 if 1<=PS7C & PS7C<=2
gen TOLERANCIA_MATAR_D=1 if 1<=PS7D & PS7D<=2
gen TOLERANCIA_MATAR_E=1 if 1<=PS7E & PS7E<=2
recode TOLERANCIA_MATAR_A .=0
recode TOLERANCIA_MATAR_B .=0
recode TOLERANCIA_MATAR_C .=0
recode TOLERANCIA_MATAR_D .=0
recode TOLERANCIA_MATAR_E .=0


gen TOLERANCIA_MATAR=TOLERANCIA_MATAR_A+TOLERANCIA_MATAR_B+TOLERANCIA_MATAR_C+TOLERANCIA_MATAR_D+TOLERANCIA_MATAR_E
recode TOLERANCIA_MATAR .=0
label var TOLERANCIA_MATAR "tolerancia a matar o usar/tener armas para defenderse - PS7" 
drop TOLERANCIA_MATAR_A TOLERANCIA_MATAR_B TOLERANCIA_MATAR_C TOLERANCIA_MATAR_D TOLERANCIA_MATAR_E

*********** CONOCIMIENTO DE PROYECTOS :   PS8 Y PS9 **** solo son posibles en ciertas comunas!!!!


* 5/ VIOLENCIA DOMESTICA - AMBIENTE DE VIOLENCIA EN EL HOGAR 
*******************************************************************************************************
*  VIF NO COMO VICTIMIZACION, QUE YA ESTA RECOGIDA, SINO COMO VAR AMBIENTAL DE VIOLENCIA EN EL HOGAR  *
*******************************************************************************************************

*5.1/ TOLERANCIA AL CASTIGO FISICO A NIÑOS
* No uso VIF3's porque estas solo las pueden contestar aquellos que tienen niños en la casa... en algunos casos estamos excluyendo mas de 400 observaciones
* Mejor uso VIF4's que las responden todos y tienen que ver con aceptacion de castigos fisicos a hijos en 5 dif situaciones
* Creamos un indice de 1 si esta totalmente de acuerdo o de acuerdo con 5 situaciones de uso de castigo fisico en VIF4


gen TOLERANCIA_CASTIGOFISICO_A=1 if 1<=VIF4A & VIF4A<=2
gen TOLERANCIA_CASTIGOFISICO_B=1 if 1<=VIF4B & VIF4B<=2
gen TOLERANCIA_CASTIGOFISICO_C=1 if 1<=VIF4C & VIF4C<=2
gen TOLERANCIA_CASTIGOFISICO_D=1 if 1<=VIF4D & VIF4D<=2
 
recode TOLERANCIA_CASTIGOFISICO_A .=0
recode TOLERANCIA_CASTIGOFISICO_B .=0
recode TOLERANCIA_CASTIGOFISICO_C .=0
recode TOLERANCIA_CASTIGOFISICO_D .=0
 

gen TOLERANCIA_CASTIGOFISICO=TOLERANCIA_CASTIGOFISICO_A+TOLERANCIA_CASTIGOFISICO_B+TOLERANCIA_CASTIGOFISICO_C+TOLERANCIA_CASTIGOFISICO_D
recode TOLERANCIA_CASTIGOFISICO .=0
label var TOLERANCIA_CASTIGOFISICO "tolerancia al castigo fisico a los niños VIF4's"

drop TOLERANCIA_CASTIGOFISICO_A TOLERANCIA_CASTIGOFISICO_B TOLERANCIA_CASTIGOFISICO_C TOLERANCIA_CASTIGOFISICO_D 



*5.2/ REACCION ANTE EL MALTRATO A NIÑOS
gen MALTRATONINOS_nada=1 if VIF6==1
gen MALTRATONINOS_civico=1 if 2<=VIF6 & VIF6<=4
gen MALTRATONINOS_violencia=1 if VIF6==5
recode MALTRATONINOS_nada .=0
recode MALTRATONINOS_civico .=0
recode MALTRATONINOS_violencia .=0

label var MALTRATONINOS_nada "reacciona al maltrato de niños haciendo nada VIF6"
label var MALTRATONINOS_civico "reacciona al maltrato de niños de forma civica VIF6"
label var MALTRATONINOS_violencia "reacciona al maltrato de niños de forma violenta VIF6"


*5.3/ TOLERANCIA DE LA VIOLENCIA CON LA PAREJA
* Mismo problema que antes... solo los que tienen pareja pueden responder a esta pregunta con lo que mas de 400 observaciones se pierden
* Por eso usamos mejor actitud de violencia usando VIF19 y VIF20 que las responden todos
* Incluye violencia física y psicologica (esta ultima incluye tambien retiro de apoyo economico)

gen TOLERANCIA_VIOLENCIAPAREJA_A=1 if 1<=VIF19A & VIF19A<=2
gen TOLERANCIA_VIOLENCIAPAREJA_B=1 if 1<=VIF19B & VIF19B<=2
gen TOLERANCIA_VIOLENCIAPAREJA_C=1 if 1<=VIF19C & VIF19C<=2
gen TOLERANCIA_VIOLENCIAPAREJA_D=1 if 1<=VIF19D & VIF19D<=2
gen TOLERANCIA_VIOLENCIAPAREJA_E=1 if 1<=VIF19E & VIF19E<=2
gen TOLERANCIA_VIOLENCIAPAREJA_F=1 if 1<=VIF19F & VIF19F<=2
gen TOLERANCIA_VIOLENCIAPAREJA_G=1 if 1<=VIF19G & VIF19G<=2

recode TOLERANCIA_VIOLENCIAPAREJA_A .=0
recode TOLERANCIA_VIOLENCIAPAREJA_B .=0
recode TOLERANCIA_VIOLENCIAPAREJA_C .=0
recode TOLERANCIA_VIOLENCIAPAREJA_D .=0
recode TOLERANCIA_VIOLENCIAPAREJA_E .=0
recode TOLERANCIA_VIOLENCIAPAREJA_F .=0
recode TOLERANCIA_VIOLENCIAPAREJA_G .=0

gen TOLERANCIA_VIOLENCIAPAREJA_PSICO=TOLERANCIA_VIOLENCIAPAREJA_A+TOLERANCIA_VIOLENCIAPAREJA_E+TOLERANCIA_VIOLENCIAPAREJA_F+TOLERANCIA_VIOLENCIAPAREJA_G
recode TOLERANCIA_VIOLENCIAPAREJA_PSICO .=0

gen TOLERANCIA_VIOLENCIAPAREJA_FISI=TOLERANCIA_VIOLENCIAPAREJA_B+TOLERANCIA_VIOLENCIAPAREJA_C+TOLERANCIA_VIOLENCIAPAREJA_D
recode TOLERANCIA_VIOLENCIAPAREJA_FISI .=0

gen TOLERANCIA_VIOLENCIAPAREJA=TOLERANCIA_VIOLENCIAPAREJA_PSICO+TOLERANCIA_VIOLENCIAPAREJA_FISI
recode TOLERANCIA_VIOLENCIAPAREJA .=0

label var TOLERANCIA_VIOLENCIAPAREJA_PSICO "tolera violencia psicologica a la pareja VIF19"
label var TOLERANCIA_VIOLENCIAPAREJA_FISI "tolera violencia fisica a la pareja VIF19"
label var TOLERANCIA_VIOLENCIAPAREJA "tolera violencia a la pareja psico y fisica VIF19"

drop  TOLERANCIA_VIOLENCIAPAREJA_A TOLERANCIA_VIOLENCIAPAREJA_B TOLERANCIA_VIOLENCIAPAREJA_C TOLERANCIA_VIOLENCIAPAREJA_D TOLERANCIA_VIOLENCIAPAREJA_E


*5.4/ REACCION ANTE VIOLENCIA DE PAREJA
gen VIOLENCIAPAREJA_nada=1 if VIF20==1
gen VIOLENCIAPAREJA_civico=1 if 2<=VIF20 & VIF20<=4
gen VIOLENCIAPAREJA_violencia=1 if VIF20==5
recode VIOLENCIAPAREJA_nada .=0
recode VIOLENCIAPAREJA_civico .=0
recode VIOLENCIAPAREJA_violencia .=0

label var VIOLENCIAPAREJA_nada "reacciona al maltrato de niños haciendo nada VIF6"
label var VIOLENCIAPAREJA_civico "reacciona al maltrato de niños de forma civica VIF6"
label var VIOLENCIAPAREJA_violencia "reacciona al maltrato de niños de forma violenta VIF6"




*5.5/ PERCEPCION DE RESOLUCION DE CONFLICTOS FAMILIARES EN LA COMUNIDAD

gen VIF_MEJOR=1 if VIF22==1
gen VIF_PEOR=1 if VIF22==2
gen VIF_IGUAL=1 if VIF22==3
recode VIF_MEJOR .=0
recode VIF_PEOR .=0
recode VIF_IGUAL .=0
label var VIF_MEJOR "percepcion de que resolucion de VIF en sector mejoro ult 6 meses"
label var VIF_PEOR "percepcion de que resolucion de VIF en sector empeoro ult 6 meses"
label var VIF_IGUAL "percepcion de que resolucion de VIF en sector quedo igual ult 6 meses"



*5.5/  CONSECUENCIA DE LA VIOLENCIA, V18, SOLO SIRVE PARA AQUELLOS QUE REPORTAN SER OBJETO DE VIOLENCIA, LUEGO NO VALE PARA ETRIX,
* AUNQUE SI PARA DESCRIPTICS




**************************************************************
*6/ DRIVE PERSONAL DE RESOLUCION PACIFICA DE CONFLICTOS ****
**************************************************************

*6.1/ Drive personal de resolucion pacifica de conflictos

* def: una variable que nos aproxima si el individuo esta dispuesto a buscar ayuda de forma pacifica para la resolucion de sus conflictos o problemas
* Consideramos que un individuo tiene un drive personal para resolver conflictos de forma pacifica cuando reporta que siempre o casi siempre busca solucionar sus problemas
* con ayuda de un vecino, institucion, persona, familias, infractor, etc. 

gen DRIVE_PACIFICO_A=1 if 1<=VIF21A & VIF21A<=2
gen DRIVE_PACIFICO_B=1 if 1<=VIF21B & VIF21B<=2
gen DRIVE_PACIFICO_C=1 if 1<=VIF21C & VIF21C<=2
gen DRIVE_PACIFICO_D=1 if 1<=VIF21D & VIF21D<=2
gen DRIVE_PACIFICO_E=1 if 1<=VIF21E & VIF21E<=2

recode DRIVE_PACIFICO_A .=0
recode DRIVE_PACIFICO_B .=0
recode DRIVE_PACIFICO_C .=0
recode DRIVE_PACIFICO_D .=0
recode DRIVE_PACIFICO_E .=0

gen DRIVE_PACIFICO=DRIVE_PACIFICO_A+DRIVE_PACIFICO_B+DRIVE_PACIFICO_C+DRIVE_PACIFICO_D+DRIVE_PACIFICO_E
recode DRIVE_PACIFICO .=0
drop DRIVE_PACIFICO_A DRIVE_PACIFICO_B DRIVE_PACIFICO_C DRIVE_PACIFICO_D DRIVE_PACIFICO_E
label var DRIVE_PACIFICO "individuo tipicamente busca solucionar pacificamente sus conflictos"




************ VIF23: CAUSAS DE LA VIOLENCIA: ALCOHOL, ECON, FAMILIARES
************ h0 PROBLEMAS FAMILIARIES LLEVAN A CASAS DE JUSTICIA MAS PROBABLE QUE ECON, ALCOHOL
**** VARIOUS COMPOSITES 3X



*********************************
*7/ RECURSOS INSTITUCIONALES ****
*********************************


*7.1/ No conoce instituciones que brindan asistencia en caso de VIF
gen NOCONOCE_INST_VIF_A=1 if 2<=VIF25A & VIF25A<=8
gen NOCONOCE_INST_VIF_B=1 if 2<=VIF25B & VIF25B<=8
gen NOCONOCE_INST_VIF_C=1 if 2<=VIF25C & VIF25C<=8
gen NOCONOCE_INST_VIF_D=1 if 2<=VIF25D & VIF25D<=8
gen NOCONOCE_INST_VIF_E=1 if 2<=VIF25E & VIF25E<=8
gen NOCONOCE_INST_VIF_F=1 if 2<=VIF25F & VIF25F<=8
gen NOCONOCE_INST_VIF_RED=1 if VIF26==2

recode NOCONOCE_INST_VIF_A .=0
recode NOCONOCE_INST_VIF_B .=0
recode NOCONOCE_INST_VIF_C .=0
recode NOCONOCE_INST_VIF_D .=0
recode NOCONOCE_INST_VIF_E .=0
recode NOCONOCE_INST_VIF_F .=0
recode NOCONOCE_INST_VIF_RED .=0

gen NOCONOCE_INST_VIF=NOCONOCE_INST_VIF_A+NOCONOCE_INST_VIF_B+NOCONOCE_INST_VIF_C+NOCONOCE_INST_VIF_D+NOCONOCE_INST_VIF_E+NOCONOCE_INST_VIF_F+NOCONOCE_INST_VIF_RED
recode NOCONOCE_INST_VIF .=0
label var NOCONOCE_INST_VIF "GRADO DESCONOCIMIENTO - no conoce inst o programas que brindan apoyo a VIF, VIF25 y VIF26"

drop NOCONOCE_INST_VIF_A NOCONOCE_INST_VIF_B NOCONOCE_INST_VIF_C NOCONOCE_INST_VIF_D NOCONOCE_INST_VIF_E NOCONOCE_INST_VIF_F NOCONOCE_INST_VIF_RED


*7.2/ ACUDIRIA A LAS SIGUIENTES INSTITUCIONES EN CASO DE VIOLENCIA
* Def: Le damos el valor 1 si acudiria a la inst X en caso de violencia del tipo 1; 1 si iria a X en caso de violencia tipo 2; ... y asi sucesivamente con todos los tipos de violencia
* Al final calculamos un indice de acudir a cada institucion


gen VIF30AIC_0=VIF30AIC 
recode VIF30AIC_0 2=0
recode VIF30AIC_0 .=0
gen VIF30ACO_0=VIF30ACO 
recode VIF30ACO_0 2=0
recode VIF30ACO_0 .=0
gen VIF30ASA_0=VIF30ASA
recode VIF30ASA_0 2=0
recode VIF30ASA_0 .=0
gen VIF30AFI_0=VIF30AFI 
recode VIF30AFI_0 .=0
recode VIF30AFI_0 2=0
gen VIF30APO_0=VIF30APO 
recode VIF30APO_0 .=0
recode VIF30APO_0 2=0
gen VIF30ANO_0=VIF30ANO 
recode VIF30ANO_0 .=0
recode VIF30ANO_0 2=0

 
gen VIF30BIC_0=VIF30BIC 
recode VIF30BIC_0 .=0
recode VIF30BIC_0 2=0
gen VIF30BCO_0=VIF30BCO 
recode VIF30BCO_0 .=0
recode VIF30BCO_0 2=0
gen VIF30BSA_0=VIF30BSA 
recode VIF30BSA_0 .=0
recode VIF30BSA_0 2=0
gen VIF30BFI_0=VIF30BFI 
recode VIF30BFI_0 .=0
recode VIF30BFI_0 2=0
gen VIF30BPO_0=VIF30BPO 
recode VIF30BPO_0 .=0
recode VIF30BPO_0 2=0
gen VIF30BNO_0=VIF30BNO 
recode VIF30BNO_0 .=0
recode VIF30BNO_0 2=0


gen VIF30CIC_0=VIF30CIC 
recode VIF30CIC_0 .=0
recode VIF30CIC_0 2=0
gen VIF30CCO_0=VIF30CCO
recode VIF30CCO_0 .=0
recode VIF30CCO_0 2=0
gen VIF30CSA_0=VIF30CSA 
recode VIF30CSA_0 .=0
recode VIF30CSA_0 2=0
gen VIF30CFI_0=VIF30CFI 
recode VIF30CFI_0 .=0
recode VIF30CFI_0 2=0
gen VIF30CPO_0=VIF30CPO 
recode VIF30CPO_0 .=0
recode VIF30CPO_0 2=0
gen VIF30CNO_0=VIF30CNO 
recode VIF30CNO_0 .=0
recode VIF30CNO_0 2=0


gen VIF30DIC_0=VIF30DIC 
recode VIF30DIC_0 .=0
recode VIF30DIC_0 2=0
gen VIF30DCO_0=VIF30DCO 
recode VIF30DCO_0 .=0
recode VIF30DCO_0 2=0
gen VIF30DSA_0=VIF30DSA 
recode VIF30DSA_0 .=0
recode VIF30DSA_0 2=0
gen VIF30DFI_0=VIF30DFI 
recode VIF30DFI_0 .=0
recode VIF30DFI_0 2=0
gen VIF30DPO_0=VIF30DPO 
recode VIF30DPO_0 .=0
recode VIF30DPO_0 2=0
gen VIF30DNO_0=VIF30DNO 
recode VIF30DNO_0 .=0
recode VIF30DNO_0 2=0


gen VIF30EIC_0=VIF30EIC 
recode VIF30EIC_0 .=0
recode VIF30EIC_0 2=0
gen VIF30ECO_0=VIF30ECO 
recode VIF30ECO_0 .=0
recode VIF30ECO_0 2=0
gen VIF30ESA_0=VIF30ESA 
recode VIF30ESA_0 .=0
recode VIF30ESA_0 2=0
gen VIF30EFI_0=VIF30EFI 
recode VIF30EFI_0 .=0
recode VIF30EFI_0 2=0
gen VIF30EPO_0=VIF30EPO 
recode VIF30EPO_0 .=0
recode VIF30EPO_0 2=0
gen VIF30ENO_0=VIF30ENO 
recode VIF30ENO_0 .=0
recode VIF30ENO_0 2=0


gen VIF30FIC_0=VIF30FIC 
recode VIF30FIC_0 .=0
recode VIF30FIC_0 2=0
gen VIF30FCO_0=VIF30FCO 
recode VIF30FCO_0 .=0
recode VIF30FCO_0 2=0
gen VIF30FSA_0=VIF30FSA 
recode VIF30FSA_0 .=0
recode VIF30FSA_0 2=0
gen VIF30FFI_0=VIF30FFI 
recode VIF30FFI_0 .=0
recode VIF30FFI_0 2=0
gen VIF30FPO_0=VIF30FPO 
recode VIF30FPO_0 .=0
recode VIF30FPO_0 2=0
gen VIF30FNO_0=VIF30FNO 
recode VIF30FNO_0 .=0
recode VIF30FNO_0 2=0


gen ACUDE_ICBF=(VIF30AIC_0+VIF30BIC_0+VIF30CIC_0+VIF30DIC_0+VIF30EIC_0+VIF30FIC_0)/6
gen ACUDE_COMFAM=(VIF30ACO_0+VIF30BCO_0+VIF30CCO_0+VIF30DCO_0+VIF30ECO_0+VIF30FCO_0)/6
gen ACUDE_SALUD=(VIF30ASA_0+VIF30BSA_0+VIF30CSA_0+VIF30DSA_0+VIF30ESA_0+VIF30FSA_0)/6
gen ACUDE_FISCAL=(VIF30AFI_0+VIF30BFI_0+VIF30CFI_0+VIF30DFI_0+VIF30EFI_0+VIF30FFI_0)/6
gen ACUDE_POLICIA=(VIF30APO_0+VIF30BPO_0+VIF30CPO_0+VIF30DPO_0+VIF30EPO_0+VIF30FPO_0)/6
gen ACUDE_NO=(VIF30ANO_0+VIF30BNO_0+VIF30CNO_0+VIF30DNO_0+VIF30ENO_0+VIF30FNO_0)/6
 
recode ACUDE_ICBF .=0
recode ACUDE_COMFAM .=0
recode ACUDE_SALUD .=0
recode ACUDE_FISCAL .=0
recode ACUDE_POLICIA .=0
recode ACUDE_NO .=0

gen ACUDE_INSTITUCION=1-ACUDE_NO

label var ACUDE_ICBF "% prob que individuo acuda a ICBF en caso de varios tipos de maltratos en el hogar VIF30" 
label var ACUDE_COMFAM "% prob que individuo acuda a COM FAM en caso de varios tipos de maltratos en el hogar VIF30" 
label var ACUDE_SALUD "% prob que individuo acuda a CENTRO SALUD en caso de varios tipos de maltratos en el hogar VIF30" 
label var ACUDE_FISCAL "% prob que individuo acuda a FISCALIA en caso de varios tipos de maltratos en el hogar VIF30" 
label var ACUDE_POLICIA "% prob que individuo acuda a POLICIA en caso de varios tipos de maltratos en el hogar VIF30" 
label var ACUDE_NO "% prob que individuo acuda a NADA en caso de varios tipos de maltratos en el hogar VIF30" 
label var ACUDE_INSTITUCION "% prob que individuo acuda a ALGUNA INSTITUCION en caso de varios tipos de maltratos en el hogar VIF30" 


drop VIF30AIC_0 VIF30BIC_0 VIF30CIC_0 VIF30DIC_0 VIF30EIC_0 VIF30FIC_0
drop VIF30ACO_0 VIF30BCO_0 VIF30CCO_0 VIF30DCO_0 VIF30ECO_0 VIF30FCO_0
drop VIF30ASA_0 VIF30BSA_0 VIF30CSA_0 VIF30DSA_0 VIF30ESA_0 VIF30FSA_0
drop VIF30AFI_0 VIF30BFI_0 VIF30CFI_0 VIF30DFI_0 VIF30EFI_0 VIF30FFI_0
drop VIF30APO_0 VIF30BPO_0 VIF30CPO_0 VIF30DPO_0 VIF30EPO_0 VIF30FPO_0
drop VIF30ANO_0 VIF30BNO_0 VIF30CNO_0 VIF30DNO_0 VIF30ENO_0 VIF30FNO_0



**** alternativa a esa pregunta con pregunta VIF36: "SI TUVIERA UN PROBLEMA CON ALGUIEN EN SU FAMILIA A QUIEN ACUDIRIA":
gen ACUDE_JUECESPAZ=1 if VIF36A==1
gen ACUDE_MADRESCOM=1 if VIF36B==1
gen ACUDE_EDUCADORAS=1 if VIF36C==1
gen ACUDE_CONSEJERAS=1 if VIF36D==1
gen ACUDE_PROMOTORAS=1 if VIF36E==1
gen ACUDE_VECINO=1 if VIF36F==1
gen ACUDE_INSTV36=1 if VIF36G==1

recode ACUDE_JUECESPAZ .=0
recode ACUDE_MADRESCOM .=0
recode ACUDE_EDUCADORAS .=0
recode ACUDE_CONSEJERAS .=0
recode ACUDE_PROMOTORAS .=0
recode ACUDE_VECINO .=0
recode ACUDE_INSTV36 .=0

label var ACUDE_JUECESPAZ "en caso de problema familiar, acude a juez de paz"
label var ACUDE_MADRESCOM "en caso de problema familiar, acude a madres comunitarias"
label var ACUDE_EDUCADORAS "en caso de problema familiar, acude a educadoras"
label var ACUDE_CONSEJERAS "en caso de problema familiar, acude a consejeras"
label var ACUDE_PROMOTORAS "en caso de problema familiar, acude a promotoras"
label var ACUDE_VECINO "en caso de problema familiar, acude a vecinos"
label var ACUDE_INSTV36 "en caso de problema familiar, acude a instituciones VIF36"



**********
** INTERES POR RESOLVER PROBLEMAS EN INSTI
** FUENTE DE INFO VIF35 Y 36

*7.3/ CONSECUENCIAS DE LOS CONFLICTOS FAMILIARES

gen CONSECUENCIA_VIF_AYUDA_A=1 if VIF31A==1
gen CONSECUENCIA_VIF_AYUDA_B=1 if VIF31B==1
gen CONSECUENCIA_VIF_AYUDA_C=1 if VIF31C==1
gen CONSECUENCIA_VIF_AYUDA_D=1 if VIF31G==1
recode CONSECUENCIA_VIF_AYUDA_A .=0
recode CONSECUENCIA_VIF_AYUDA_B .=0
recode CONSECUENCIA_VIF_AYUDA_C .=0
recode CONSECUENCIA_VIF_AYUDA_D .=0
gen CONSECUENCIA_VIF_AYUDA=CONSECUENCIA_VIF_AYUDA_A+CONSECUENCIA_VIF_AYUDA_B+CONSECUENCIA_VIF_AYUDA_C+CONSECUENCIA_VIF_AYUDA_D
drop CONSECUENCIA_VIF_AYUDA_*
label var CONSECUENCIA_VIF_AYUDA "busca ayuda medica, psico, legal, o amigos/agentes comunitarios tras conflicto familiar, VIF31"

gen CONSECUENCIA_VIF_CAMBIOVIDA_A=1 if VIF31D==1
gen CONSECUENCIA_VIF_CAMBIOVIDA_B=1 if VIF31E==1
gen CONSECUENCIA_VIF_CAMBIOVIDA_C=1 if VIF31F==1
recode CONSECUENCIA_VIF_CAMBIOVIDA_A .=0
recode CONSECUENCIA_VIF_CAMBIOVIDA_B .=0
recode CONSECUENCIA_VIF_CAMBIOVIDA_C .=0
gen CONSECUENCIA_VIF_CAMBIOVIDA=CONSECUENCIA_VIF_CAMBIOVIDA_A+CONSECUENCIA_VIF_CAMBIOVIDA_B+CONSECUENCIA_VIF_CAMBIOVIDA_C
drop CONSECUENCIA_VIF_CAMBIOVIDA_*
label var CONSECUENCIA_VIF_CAMBIOVIDA "deja la casa, trabajo o amigos/familiares tras conflicto familiar, VIF31"





*******************************************************
***** 8/ MOBILIZACION PARA CONVIVENCIA  ***************
*******************************************************

*8.1/ PARTICIPACION EN LA 'PROMOCION DE CONVIVENCIA FAMILIAR"

gen PROMO_CONVIVENCIAPART=1 if VIF32==1
recode PROMO_CONVIVENCIAPART .=0
label var PROMO_CONVIVENCIAPART "participo en act de promocion de conv fam en ult 12 meses"

*8.2/ SE DESARROLLARON ACTIVIDADES DE PROMOCION EN SU SECTOR?

gen PROMO_CONVIVENCIA=1 if VIF38==1
recode PROMO_CONVIVENCIA .=0
label var PROMO_CONVIVENCIA "hubo actividades de promo de convivencia en el sector en ult 12 meses"



*** WHETHER GOV PROMOTES  INFO VIF40D


* 8.3/ ACTIVIDADES DE PARTICIPACION SOBRE CONVIVENCIA:

gen REUNIONES_ENTREFAMILIAS=1 if VIF39A==1
gen CARPASITINERANTES=1 if VIF39B==1
gen CULTURA_CONVIVENCIA=1 if VIF39C==1
recode REUNIONES_ENTREFAMILIAS .=0
recode CARPASITINERANTES .=0
recode CULTURA_CONVIVENCIA .=0

label var REUNIONES_ENTREFAMILIAS "participo en reuniones con otras familias sobre VIF, VIF39"
label var CARPASITINERANTES "participo en carpas itinerantes"
label var CULTURA_CONVIVENCIA "participo en act culturales para fomentar la convivencia"


* 8.4/ A FAVOR DE NO EJERCER CONTROL SOCIAL

gen NO_CONTROLSOCIAL=1 if VIF41==2 & VIF42==2
recode NO_CONTROLSOCIAL .=0
label var NO_CONTROLSOCIAL "en contra de denunciar si observara maltratos a la pareja o violación de menores"




******************************************************************
** 9/ CAPITAL SOCIAL Y PARTICIPACION COMUNITARIA  ****************
******************************************************************

*9.1/ PARTICIPACION
* total!
gen PARTCOMUNITARIA=2 if CS1A==1 & CS1B==1
replace PARTCOMUNITARIA=1 if CS1A==1 & CS1B==2
replace PARTCOMUNITARIA=1 if CS1A==2 & CS1B==1
replace PARTCOMUNITARIA=0 if CS1A==2 & CS1B==2

* religiosa

gen PARTCOMUNITARIA_RELIGION=1 if CS12==1 
replace PARTCOMUNITARIA_RELIGION=1 if CS122==1 
replace PARTCOMUNITARIA_RELIGION=1 if CS123==1 
replace PARTCOMUNITARIA_RELIGION=1 if CS12B==1  & CS12!=1 & CS122!=1 & CS123!=1
replace PARTCOMUNITARIA_RELIGION=1 if CS122B==1 & CS12!=1 & CS122!=1 & CS123!=1
replace PARTCOMUNITARIA_RELIGION=1 if CS123B==1 & CS12!=1 & CS122!=1 & CS123!=1
recode PARTCOMUNITARIA_RELIGION .=0


*politico
gen PARTCOMUNITARIA_POLITICA=1 if CS12==2 
replace PARTCOMUNITARIA_POLITICA=1 if CS122==2 
replace PARTCOMUNITARIA_POLITICA=1 if CS123==2 
replace PARTCOMUNITARIA_POLITICA=1 if CS12B==2  & CS12!=2 & CS122!=2 & CS123!=2
replace PARTCOMUNITARIA_POLITICA=1 if CS122B==2 & CS12!=2 & CS122!=2 & CS123!=2
replace PARTCOMUNITARIA_POLITICA=1 if CS123B==2 & CS12!=2 & CS122!=2 & CS123!=2
recode PARTCOMUNITARIA_POLITICA .=0
 
* cultural
gen PARTCOMUNITARIA_CULTURA=1 if CS12==3 
replace PARTCOMUNITARIA_CULTURA=1 if CS122==3 
replace PARTCOMUNITARIA_CULTURA=1 if CS123==3 
replace PARTCOMUNITARIA_CULTURA=1 if CS12B==3  & CS12!=3 & CS122!=3 & CS123!=3 
replace PARTCOMUNITARIA_CULTURA=1 if CS122B==3 & CS12!=3 & CS122!=3 & CS123!=3
replace PARTCOMUNITARIA_CULTURA=1 if CS123B==3 & CS12!=3 & CS122!=3 & CS123!=3
recode PARTCOMUNITARIA_CULTURA .=0
 
* economica
gen PARTCOMUNITARIA_ECON=1 if CS12==4 
replace PARTCOMUNITARIA_ECON=1 if CS122==4 
replace PARTCOMUNITARIA_ECON=1 if CS123==4 
replace PARTCOMUNITARIA_ECON=1 if CS12B==4  & CS12!=4 & CS122!=4 & CS123!=4
replace PARTCOMUNITARIA_ECON=1 if CS122B==4 & CS12!=4 & CS122!=4 & CS123!=4
replace PARTCOMUNITARIA_ECON=1 if CS123B==4 & CS12!=4 & CS122!=4 & CS123!=4
recode PARTCOMUNITARIA_ECON .=0

* social 
gen PARTCOMUNITARIA_SOCIAL=1 if CS12==9 
replace PARTCOMUNITARIA_SOCIAL=1 if CS122==9 
replace PARTCOMUNITARIA_SOCIAL=1 if CS123==9 
replace PARTCOMUNITARIA_SOCIAL=1 if CS12B==9  & CS12!=9 & CS122!=9 & CS123!=9
replace PARTCOMUNITARIA_SOCIAL=1 if CS122B==9 & CS12!=9 & CS122!=9 & CS123!=9
replace PARTCOMUNITARIA_SOCIAL=1 if CS123B==9 & CS12!=9 & CS122!=9 & CS123!=9
recode PARTCOMUNITARIA_SOCIAL .=0

* seguridad y convivencia

gen PARTCOMUNITARIA_SEG=1 if CS12==11 
replace PARTCOMUNITARIA_SEG=1 if CS122==11
replace PARTCOMUNITARIA_SEG=1 if CS123==11
replace PARTCOMUNITARIA_SEG=1 if CS12B==11  & CS12!=11 & CS122!=11 & CS123!=11
replace PARTCOMUNITARIA_SEG=1 if CS122B==11 & CS12!=11 & CS122!=11 & CS123!=11
replace PARTCOMUNITARIA_SEG=1 if CS123B==11 & CS12!=11 & CS122!=11 & CS123!=11
recode PARTCOMUNITARIA_SEG .=0

* gestion comunal 

gen PARTCOMUNITARIA_GESTIONCOM=1 if CS12==5 
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS122==5
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS123==5
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS12==6
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS122==6
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS123==6
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS12==8
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS122==8
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS123==8

replace PARTCOMUNITARIA_GESTIONCOM=1 if CS12B==5  
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS122B==5
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS123B==5
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS12B==6 
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS122B==6
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS123B==6
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS12B==8  
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS122B==8
replace PARTCOMUNITARIA_GESTIONCOM=1 if CS123B==8

recode PARTCOMUNITARIA_GESTIONCOM .=0

* resto
gen PARTCOMUNITARIA_OTRAS=1 if CS12==7
replace PARTCOMUNITARIA_OTRAS=1 if CS122==7
replace PARTCOMUNITARIA_OTRAS=1 if CS123==7
replace PARTCOMUNITARIA_OTRAS=1 if CS12==10
replace PARTCOMUNITARIA_OTRAS=1 if CS122==10
replace PARTCOMUNITARIA_OTRAS=1 if CS123==10
replace PARTCOMUNITARIA_OTRAS=1 if CS12==12
replace PARTCOMUNITARIA_OTRAS=1 if CS122==12
replace PARTCOMUNITARIA_OTRAS=1 if CS123==12
replace PARTCOMUNITARIA_OTRAS=1 if CS12==13
replace PARTCOMUNITARIA_OTRAS=1 if CS122==13
replace PARTCOMUNITARIA_OTRAS=1 if CS123==13

replace PARTCOMUNITARIA_OTRAS=1 if CS12B==7  
replace PARTCOMUNITARIA_OTRAS=1 if CS122B==7
replace PARTCOMUNITARIA_OTRAS=1 if CS123B==7
replace PARTCOMUNITARIA_OTRAS=1 if CS12B==10 
replace PARTCOMUNITARIA_OTRAS=1 if CS122B==10
replace PARTCOMUNITARIA_OTRAS=1 if CS123B==10
replace PARTCOMUNITARIA_OTRAS=1 if CS12B==12
replace PARTCOMUNITARIA_OTRAS=1 if CS122B==12
replace PARTCOMUNITARIA_OTRAS=1 if CS123B==12
replace PARTCOMUNITARIA_OTRAS=1 if CS12B==13
replace PARTCOMUNITARIA_OTRAS=1 if CS122B==13
replace PARTCOMUNITARIA_OTRAS=1 if CS123B==13

recode PARTCOMUNITARIA_OTRAS .=0

label var PARTCOMUNITARIA "participacion en asociaciones en la  comunidad"
label var PARTCOMUNITARIA_RELIGION "participacion en asociaciones religiosas en la comunidad"
label var PARTCOMUNITARIA_POLITICA "participacion en asociaciones politicas en la  comunidad"
label var PARTCOMUNITARIA_CULTURA "participacion en asociaciones culturales, dep, recreativas en la  comunidad"
label var PARTCOMUNITARIA_ECON "participacion en asociaciones economicas-credito en la  comunidad"
label var PARTCOMUNITARIA_SOCIAL "participacion en asociaciones sociales en la  comunidad"
label var PARTCOMUNITARIA_GESTIONCOM "participacion en asociaciones de gestion com en la  comunidad"
label var PARTCOMUNITARIA_OTRAS "participacion en otras asociaciones - viejos, jovenes, ONGs, otras en la  comunidad"


*9.2/ CAUSAS POR LA NO PARTICIPACION COMUNITARIA: 
*Desconocimiento comunal de organizaciones
gen PARTCOMUNITARIA_DESCONOCIDO=1 if CS3A==1
recode PARTCOMUNITARIA_DESCONOCIDO .=0
egen PARTCOMUNITARIA_DESC_COMUNA=mean(PARTCOMUNITARIA_DESCONOCIDO), by(COMUNA)
drop PARTCOMUNITARIA_DESCONOCIDO

* Falta de interes
gen PARTCOMUNITARIA_FALTAINTERES=1 if CS3B==1
recode PARTCOMUNITARIA_FALTAINTERES .=0
egen PARTCOMUNITARIA_FALTAINT_COMUNA=mean(PARTCOMUNITARIA_FALTAINTERES), by(COMUNA)
drop PARTCOMUNITARIA_FALTAINTERES 

* Falta de tiempo
gen PARTCOMUNITARIA_FALTATIEMPO=1 if CS3C==1
recode PARTCOMUNITARIA_FALTATIEMPO .=0
egen PARTCOMUNITARIA_FALTATIE_COMUNA=mean(PARTCOMUNITARIA_FALTATIEMPO), by(COMUNA)
drop PARTCOMUNITARIA_FALTATIEMPO

*Problemas de las organizaciones  
gen PARTCOMUNITARIA_BADORG=1 if CS3D==1
replace PARTCOMUNITARIA_BADORG=1 if CS3E==1
recode PARTCOMUNITARIA_BADORG .=0
egen PARTCOMUNITARIA_BADORG_COMUNA=mean(PARTCOMUNITARIA_BADORG), by(COMUNA)
drop PARTCOMUNITARIA_BADORG

label var PARTCOMUNITARIA_DESC_COMUNA "no participacion com por desconocimiento"
label var PARTCOMUNITARIA_FALTATIE_COMUNA "no participacion com por falta de tiempo"
label var PARTCOMUNITARIA_FALTAINT_COMUNA "no participacion com por falta de interes"
label var PARTCOMUNITARIA_BADORG_COMUNA "no participacion com por problemas de la organizacion"


*9.3/ CAUSAS DE LA PARTICIPACION COMUNITARIA

* Oportunidades politicas o economicas
gen PARTCOMA_BENECONPOL=1 if CS2A==1
replace PARTCOMA_BENECONPOL=1 if CS2E==1
recode PARTCOMA_BENECONPOL .=0
egen PARTCOMA_BENECONPOL_COMUNA=mean(PARTCOMA_BENECONPOL), by(COMUNA)
drop PARTCOMA_BENECONPOL

* Ayuda
gen PARTCOMUNITARIA_BENEFICIOSAYUDA=1 if CS2B==1
recode PARTCOMUNITARIA_BENEFICIOSAYUDA .=0
egen PARTCOMUNITARIA_BENAYUDA_COMUNA=mean(PARTCOMUNITARIA_BENEFICIOSAYUDA), by(COMUNA)
drop PARTCOMUNITARIA_BENEFICIOSAYUDA

* Mejora de la comunidad
gen PARTCOMUNITARIA_BENEFICIOSCOMUNA=1 if CS2C==1
recode PARTCOMUNITARIA_BENEFICIOSCOMUNA .=0
egen PARTCOMUNITARIA_BENCOMUNA_COMUNA=mean(PARTCOMUNITARIA_BENEFICIOSCOMUNA), by(COMUNA)
drop PARTCOMUNITARIA_BENEFICIOSCOMUNA


* Diversion
gen PARTCOMUNITARIA_BENDIVERSION=1 if CS2D==1
recode PARTCOMUNITARIA_BENDIVERSION .=0
egen PARTCOMA_BENDIVERSION_COMUNA=mean(PARTCOMUNITARIA_BENDIVERSION), by(COMUNA)
drop PARTCOMUNITARIA_BENDIVERSION

* Reconocimiento
gen PARTCOMUNITARIA_BENEFICIOSRECO=1 if CS2F==1
recode PARTCOMUNITARIA_BENEFICIOSRECO .=0
egen PARTCOMUNITARIA_BENRECO_COMUNA=mean(PARTCOMUNITARIA_BENEFICIOSRECO), by(COMUNA)
drop PARTCOMUNITARIA_BENEFICIOSRECO


label var PARTCOMA_BENECONPOL_COMUNA "part en comunidad por beneficios econ o politicos"
label var PARTCOMUNITARIA_BENAYUDA_COMUNA "part en comunidad por ayuda en caso de necesidad "
label var PARTCOMUNITARIA_BENCOMUNA_COMUNA "part en comunidad por beneficios para la comunidad"
label var PARTCOMA_BENDIVERSION_COMUNA "part en comunidad por diversion"
label var PARTCOMUNITARIA_BENRECO_COMUNA "part en comunidad por reconocimiento"



*9.4/ CONFIANZA

gen TRUST=CS8A
replace TRUST=3 if CS8A==8
replace TRUST=TRUST-1
replace TRUST=4-TRUST

gen NO_SEAPROVECHAN=CS8B
replace NO_SEAPROVECHAN=3 if CS8B==8
replace NO_SEAPROVECHAN=NO_SEAPROVECHAN-1

gen PERSONAS_AYUDAN=CS8C
replace PERSONAS_AYUDAN=3 if CS8C==8
replace PERSONAS_AYUDAN=PERSONAS_AYUDAN-1
replace PERSONAS_AYUDAN=4-PERSONAS_AYUDAN


label var TRUST "grado de confianza en la mayoria de personas del sector, 0-4, CS8A"
label var NO_SEAPROVECHAN "grado de creencia de que las personas no se aprovechan, 0-4, CS8B"
label var PERSONAS_AYUDAN "grado de creencia de que las personas ayudan, 0-4, CS8C"



*9.4/ CONFIANZA INSTITUCIONAL

gen TRUST_funcionarios_salud=CS9A
gen TRUST_funcionarios_educacion=CS9B
gen TRUST_funcionarios_CALI=CS9C
gen TRUST_funcionarios_ICBF=CS9D
gen TRUST_funcionarios_ComFamilia=CS9E
gen TRUST_funcionarios_CasaJusticia=CS9F
gen TRUST_funcionarios_Alcaldia=CS9G
gen TRUST_funcionarios_Policia=CS9H
gen TRUST_funcionarios_Liderescom=CS9I
gen TRUST_funcionarios_ONG=CS9J
gen TRUST_funcionarios_voluntarios=CS9K

recode TRUST_funcionarios_salud 8=0
recode TRUST_funcionarios_educacion 8=0
recode TRUST_funcionarios_CALI 8=0
recode TRUST_funcionarios_ICBF 8=0
recode TRUST_funcionarios_ComFamilia 8=0
recode TRUST_funcionarios_CasaJusticia 8=0
recode TRUST_funcionarios_Alcaldia 8=0
recode TRUST_funcionarios_Policia 8=0
recode TRUST_funcionarios_Liderescom 8=0
recode TRUST_funcionarios_ONG 8=0
recode TRUST_funcionarios_voluntarios 8=0

gen TRUST_INSTITUCIONES=(TRUST_funcionarios_salud+TRUST_funcionarios_educacion+TRUST_funcionarios_CALI+TRUST_funcionarios_ICBF+TRUST_funcionarios_ComFamilia+TRUST_funcionarios_CasaJusticia+TRUST_funcionarios_Alcaldia+TRUST_funcionarios_Policia)/24
gen TRUST_personascomunitarias=(TRUST_funcionarios_Liderescom+TRUST_funcionarios_ONG+TRUST_funcionarios_voluntarios)/9


label var TRUST_funcionarios_salud "grado de confianza en funcionarios de salud, 0-3, SC9"
label var TRUST_funcionarios_educacion "grado de confianza en funcionarios de educacion, 0-3, SC9"
label var TRUST_funcionarios_CALI "grado de confianza en funcionarios de centro atencion CALI, 0-3, SC9"
label var TRUST_funcionarios_ICBF "grado de confianza en funcionarios de ICBF, 0-3, SC9"
label var TRUST_funcionarios_ComFamilia "grado de confianza en funcionarios de comisarias de familias, 0-3, SC9"
label var TRUST_funcionarios_CasaJusticia "grado de confianza en funcionarios de casa de justicia, 0-3, SC9"
label var TRUST_funcionarios_Alcaldia "grado de confianza en funcionarios de alcaldia, 0-3, SC9"
label var TRUST_funcionarios_Policia "grado de confianza en funcionarios de policia, 0-3, SC9"
label var TRUST_funcionarios_Liderescom "grado de confianza en funcionarios de lideres comunitarios, 0-3, SC9"
label var TRUST_funcionarios_ONG "grado de confianza de personal de ONGs, 0-3, SC9"
label var TRUST_funcionarios_voluntarios "grado de confianza en personas que trabajan en org comunitarias, 0-3, SC9"
label var TRUST_INSTITUCIONES "grado de confianza en 9 instituciones, 0-1"
label var TRUST_personascomunitarias "grado de confianza en lideres, ongs, y personal de org comunitarias, 0-1"



*9.5/ Percepcion de confianza

gen trust_mejor_a=1 if CS10A==1
gen trust_mejor_b=1 if CS10B==1
gen trust_mejor_c=1 if CS10C==1
gen trust_mejor_d=1 if CS10D==1
gen trust_mejor_e=1 if CS10D1==1

gen trust_peor_a=1 if CS10A==2
gen trust_peor_b=1 if CS10B==2
gen trust_peor_c=1 if CS10C==2
gen trust_peor_d=1 if CS10D==2
gen trust_peor_e=1 if CS10D1==2

gen trust_igual_a=1 if CS10A==3
gen trust_igual_b=1 if CS10B==3
gen trust_igual_c=1 if CS10C==3
gen trust_igual_d=1 if CS10D==3
gen trust_igual_e=1 if CS10D1==3

recode trust_mejor_a .=0
recode trust_mejor_b .=0
recode trust_mejor_c .=0
recode trust_mejor_d .=0
recode trust_mejor_e .=0
recode trust_peor_a .=0
recode trust_peor_b .=0
recode trust_peor_c .=0
recode trust_peor_d .=0
recode trust_peor_e .=0
recode trust_igual_a .=0
recode trust_igual_b .=0
recode trust_igual_c .=0
recode trust_igual_d .=0
recode trust_igual_e .=0


gen trust_mejor_suma=(trust_mejor_a+trust_mejor_b+trust_mejor_c+trust_mejor_d+trust_mejor_e)
gen trust_peor_suma=(trust_peor_a+trust_peor_b+trust_peor_c+trust_peor_d+trust_peor_e)
gen trust_igual_suma=(trust_igual_a+trust_igual_b+trust_igual_c+trust_igual_d+trust_igual_e)
recode trust_mejor_suma .=0
recode trust_peor_suma .=0
recode trust_igual_suma .=0

gen trust_igual=1 if 3<=trust_igual_suma
gen trust_peor=1 if 3<=trust_peor_suma
gen trust_mejor=1 if 3<=trust_mejor_suma
recode trust_mejor .=0
recode trust_peor .=0
recode trust_igual .=0

drop trust_igual_* trust_peor_* trust_mejor_*

label var trust_mejor "confianza mejoro en las instituciones y vecinos desde el 2003"
label var trust_peor "confianza empeoro en las instituciones y vecinos desde el 2003"
label var trust_igual "confianza sigue igual en las instituciones y vecinos desde el 2003"



* 9.6/ CALIFICACION DE LAS INSTITUCIONES
** valores de 1 a 5 donde 0 es lo peor y 4 es la mejor calificacion

gen EVALUACION_IGLESIA=CS11A
replace EVALUACION_IGLESIA=. if CS11A==8
replace EVALUACION_IGLESIA=5-EVALUACION_IGLESIA

gen EVALUACION_ORGCOM=CS11B
replace EVALUACION_ORGCOM=. if CS11B==8
replace EVALUACION_ORGCOM=5-EVALUACION_ORGCOM

gen EVALUACION_ONG=CS11F
replace EVALUACION_ONG=. if CS11F==8
replace EVALUACION_ONG=5-EVALUACION_ONG

gen EVALUACION_ACCCOMUNAL=CS11G
replace EVALUACION_ACCCOMUNAL=. if CS11G==8
replace EVALUACION_ACCCOMUNAL=5-EVALUACION_ACCCOMUNAL 

gen EVALUACION_JAL=CS11H
replace EVALUACION_JAL=. if CS11H==8
replace EVALUACION_JAL=5-EVALUACION_JAL


gen EVALUACION_SALUD=CS11C
replace EVALUACION_SALUD=. if CS11C==8
replace EVALUACION_SALUD=5-EVALUACION_SALUD

gen EVALUACION_CASAJUSTICIA=CS11D
replace EVALUACION_CASAJUSTICIA=. if CS11D==8
replace EVALUACION_CASAJUSTICIA=5-EVALUACION_CASAJUSTICIA

gen EVALUACION_ICBF=CS11E
replace EVALUACION_ICBF=. if CS11E==8
replace EVALUACION_ICBF=5-EVALUACION_ICBF

gen EVALUACION_POLICIA=CS11I
replace EVALUACION_POLICIA=. if CS11I==8
replace EVALUACION_POLICIA=5-EVALUACION_POLICIA


* normalizamos a 0-1  la escala 0-4

replace EVALUACION_IGLESIA=EVALUACION_IGLESIA/4
replace EVALUACION_SALUD=EVALUACION_SALUD/4
replace EVALUACION_CASAJUSTICIA=EVALUACION_CASAJUSTICIA/4
replace EVALUACION_ICBF=EVALUACION_ICBF/4
replace EVALUACION_POLICIA=EVALUACION_POLICIA/4
replace EVALUACION_ONG=EVALUACION_ONG/4
replace EVALUACION_ORGCOM=EVALUACION_ORGCOM/4
replace EVALUACION_ACCCOMUNAL=EVALUACION_ACCCOMUNAL/4
replace EVALUACION_JAL=EVALUACION_JAL/4
 

 
label var EVALUACION_IGLESIA "calificacion a iglesia en su labor de seg y convivencia"
label var EVALUACION_SALUD "calificacion a centros de salud en su labor de seg y convivencia"
label var EVALUACION_CASAJUSTICIA "calificacion a CASA JUSTICIA en su labor de seg y convivencia"
label var EVALUACION_ICBF "calificacion a ICBF en su labor de seg y convivencia"
label var EVALUACION_POLICIA "calificacion a POLICIA en su labor de seg y convivencia"


egen EVALUACION_IGLESIA_COMUNA=mean(EVALUACION_IGLESIA), by(COMUNA)
egen EVALUACION_SALUD_COMUNA=mean(EVALUACION_SALUD), by(COMUNA)
egen EVALUACION_CASAJUSTICIA_COMUNA=mean(EVALUACION_CASAJUSTICIA), by(COMUNA)
egen EVALUACION_ICBF_COMUNA=mean(EVALUACION_ICBF), by(COMUNA)
egen EVALUACION_POLICIA_COMUNA=mean(EVALUACION_POLICIA), by(COMUNA)
egen EVALUACION_ONG_COMUNA=mean(EVALUACION_ONG), by(COMUNA)
egen EVALUACION_ORGCOM_COMUNA=mean(EVALUACION_ORGCOM), by(COMUNA)
egen EVALUACION_ACCCOMUNAL_COMUNA=mean(EVALUACION_ACCCOMUNAL), by(COMUNA)
egen EVALUACION_JAL_COMUNA=mean(EVALUACION_JAL), by(COMUNA)


***********************************
*10/ PROGRAMAS PUBLICOS  **
***********************************

*10.1/ No se entera de lo que hace la alcaldia
gen NO_SABE_ALCALDIA=1 if OI1K==1
recode NO_SABE_ALCALDIA .=0

*10.2/ Se entera de lo que hace la comunidad a traves de medios comunitarios:
* tales como tv, radio, periodicos comunitarios; grupos o asociaciones comunitarias; ONGs; Red del Buen trato; comite de convivencia; JAL; lideres comunitarios y CALIs

gen SABE_COMUNIDAD_ALCALDIA=1 if OI1C==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1D==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1F==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1G==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1H==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1I==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1J==1
replace SABE_COMUNIDAD_ALCALDIA=1 if OI1K==1

label var NO_SABE_ALCALDIA "no sabe lo que hace la alcaldia"
label var SABE_COMUNIDAD_ALCALDIA "sabe lo que hace la alcaldia por medios comunitarios: tv, CALIs, JAL, .... "


 
*10.3/ SATISFACCION CON LOS CASAS DE JUSTICIA

* Satisfaccion con la atencion recibida
* Un indice con puntos si esta satisfecho con la atencion, no tiempo de espera, info, orientacion y si se resolvio totalmente (2 puntos) o parcialmente (1 punto) el problema

gen SATIS_CASAJUSTICIA_ATENCION=1 if OI26B1==1
gen SATIS_CASAJUSTICIA_ESPERA=1 if OI26B2==2
gen SATIS_CASAJUSTICIA_INFO=1 if OI26B3==1
gen SATIS_CASAJUSTICIA_ORIENTACION=1 if OI26B4==1
gen SATIS_CASAJUSTICIA_RESOLUCION=2 if OI26C==1
replace SATIS_CASAJUSTICIA_RESOLUCION=1 if OI26C==2

recode SATIS_CASAJUSTICIA_ATENCION .=0
recode SATIS_CASAJUSTICIA_ESPERA .=0
recode SATIS_CASAJUSTICIA_INFO .=0
recode SATIS_CASAJUSTICIA_ORIENTACION .=0
recode SATIS_CASAJUSTICIA_RESOLUCION .=0

gen SATIS_CASAJUSTICIA=(SATIS_CASAJUSTICIA_ATENCION+SATIS_CASAJUSTICIA_ESPERA+SATIS_CASAJUSTICIA_INFO+SATIS_CASAJUSTICIA_ORIENTACION+SATIS_CASAJUSTICIA_RESOLUCION)/6
recode SATIS_CASAJUSTICIA 0=.
egen SATIS_CASAJUSTICIA_COMUNA=mean(SATIS_CASAJUSTICIA), by(COMUNA)

label var SATIS_CASAJUSTICIA "satisfaccion por casa de justicia en un indice de 0-6 normalizado a 1 en funcion de atencion, espera,... y resolucion"
label var SATIS_CASAJUSTICIA_COMUNA "satisfaccion por casa de justicia A NIVEL DE COMUNA en un indice de 0-6 normalizado a 1 en funcion de atencion, espera,... y resolucion"
drop SATIS_CASAJUSTICIA_ATENCION
drop SATIS_CASAJUSTICIA_ESPERA
drop SATIS_CASAJUSTICIA_INFO
drop SATIS_CASAJUSTICIA_ORIENTACION
drop SATIS_CASAJUSTICIA_RESOLUCION
 


* Percepcion del servicio de CASAS De justicia en el ultimo año
gen CASAJUSTICIA_MEJOR=1 if OI5F==1
gen CASAJUSTICIA_PEOR=1 if OI5F==2
gen CASAJUSTICIA_IGUAL=1 if 3<=OI5F & OI5F<=99

recode CASAJUSTICIA_MEJOR .=0
recode CASAJUSTICIA_PEOR .=0
recode CASAJUSTICIA_IGUAL .=0

egen CASAJUSTICIA_MEJOR_COMUNA=mean(CASAJUSTICIA_MEJOR), by(COMUNA)
egen CASAJUSTICIA_PEOR_COMUNA=mean(CASAJUSTICIA_PEOR), by(COMUNA)
egen CASAJUSTICIA_IGUAL_COMUNA=mean(CASAJUSTICIA_IGUAL), by(COMUNA)

label var CASAJUSTICIA_MEJOR_COMUNA "percepcion de que casa justicia ha mejorado su servicio en el ult ano a nivel de comuna"
label var CASAJUSTICIA_PEOR_COMUNA  "percepcion de que casa justicia ha empeorado su servicio en el ult ano a nivel de comuna"
label var CASAJUSTICIA_MEJOR_COMUNA  "percepcion de que casa justicia sigue igual su servicio en el ult ano a nivel de comuna"
drop CASAJUSTICIA_MEJOR CASAJUSTICIA_PEOR CASAJUSTICIA_IGUAL 




******** DUMMY DE PROGRAMAS PUBLICOS!!!

encode COMUNA, gen(COMUNAnum)
generate DISTRITOPAZ1=1 if COMUNAnum==1
replace DISTRITOPAZ1=1 if COMUNAnum==18
replace DISTRITOPAZ1=1 if COMUNAnum==20
recode DISTRITOPAZ1 .=0

gen DISTRITOPAZ3=1 if COMUNAnum==13
replace DISTRITOPAZ3=1 if COMUNAnum==14
replace DISTRITOPAZ3=1 if COMUNAnum==15
recode DISTRITOPAZ3 .=0

label var DISTRITOPAZ1 "comunas 1, 18, 20 con programas especiales de convivencia"
label var DISTRITOPAZ3 "comunas 13, 14, 15 con programas especiales de convivencia"
label var COMUNAnum "comuna, en numero"




