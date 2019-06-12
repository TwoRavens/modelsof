*ENVUD

use "/rawdata/Base nacional de la ENVUD para trabajar por estado.dta", clear

gen estadoid=estado
tostring estadoid, replace

tostring seccion, replace

gen sectionID=estadoid+" _ "+seccion


drop if estado<9
drop if estado>15
drop if estado==10
drop if estado==11
drop if estado==12
drop if estado==13
drop if estado==14

sort sectionID


save "envud2012.dta", replace

use "precinctdata.dta"

sort sectionID

save "precinctdata.dta", replace

use "envud2012.dta", clear

merge sectionID using "precinctdata.dta"

drop if _merge==2

gen gender=genero
gen age=edad
gen sec=P15
recode sec 0=.


*30b.- (SI DICE SÍ) ¿A cuántos grupos u organizaciones de ese tipo pertenece usted? (ANOTAR EL NUMERO DIRECTO; 0=NINGUNO; 99=NS/NC)
gen belongparty=P30_4
gen belongunion=P30_5
gen belongreligiousgroup=P30_7

recode belongparty 0=. 2=0
recode belongunion 0=. 2=0
recode belongreligiousgroup 0=. 2=0

*44.- (TARJETA 11) En una escala del 1 al 10, donde 1 significa “nada” y 10 “mucho”. ¿A usted...? (LEER) (0=NS/NC)
*a. Cuánto le interesa la política
gen interestpolitics=P44_1
*c. Cuánto participa usted en las elecciones
gen interestelections=P44_2
*e. Cuánto habla usted de asuntos políticos con otras personas
gen discusspolitics=P44_5
*d. Cuánto sigue las noticias sobre política y gobierno
gen follownews=P44_4

*54.- En general, ¿usted aprueba o desaprueba la forma como está haciendo su trabajo...? (1= Aprueba; 2=Desaprueba; 0=NS/NC)
gen presidentialapp=P54_1
gen govapp=P54_2
gen congressapp=P54_4

recode presidentialapp 0=. 2=0
recode govapp 0=. 2=0
recode congressapp 0=. 2=0

*87.- Generalmente, ¿usted se considera priísta, panista o perredista? (INSISTIR) ¿Muy (PRIISTA / PANISTA / PERREDISTA) o algo (PRIISTA / PANISTA /PERREDISTA)? (NS/NC=0)
gen partyid=P87
gen pri=0
gen prd=0
gen pan=0

recode pri 0=1 if partyid==1
recode pri 0=1 if partyid==2
recode pan 0=1 if partyid==3
recode pan 0=1 if partyid==4
recode prd 0=1 if partyid==5
recode prd 0=1 if partyid==6

recode partyid 1/2=1 3/4=2 5/6=3 7/99=0

gen education=P104
recode education 1=0 2=1 3=2 4/5=3 6/7=4 8=5 9=6 0=.

gen cellphone=P112_2
gen internet=P112_3
recode cellphone 3=.
recode internet 3=.

gen prox=1/distance

tostring municipio, replace
gen munID=estadoid+"_"+municipio

destring munID, ignore("_") replace

************************


 
mlogit partyid prox edad gender education sec cellphone internet localidae



xi: logit presidentialapp  prox edad gender education sec cellphone internet localidae 
est store presi

xi: logit govapp  prox edad gender education sec cellphone internet localidae 
est store gov
 
xi: logit congressapp  prox edad gender education sec cellphone internet localidae 
est store congress

 suest presi gov congress
 
xi: logit belongparty  prox edad gender education sec cellphone internet localidae 
est store party

xi: logit belongunion  prox edad gender education sec cellphone internet localidae 
est store union
 
xi: logit belongreligiousgroup  prox edad gender education sec cellphone internet localidae 
est store reli

suest party union reli

sureg (interestpolitics  prox edad gender education sec cellphone internet localidae)(interestelections  prox edad gender education sec cellphone internet localidae )(discusspolitics prox edad gender education sec cellphone internet localidae) (follownews  prox edad gender education sec cellphone internet localidae )


 
