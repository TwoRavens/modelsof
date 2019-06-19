/**************************************
  CREATE VARIABLES O.B.V. SSB data
  NB run after Adjust_3mos.do !!
*********************************************************/
/*** SEC-VARIABELEN: reference group is employee ***/ 
gen byte zelfstandig = (SECa1==2)
gen byte Onbenefit = (SECa1>=3 & SECa1<=8)

/**** INKOMEN ***/
replace MNDINK1=0 if SECa1==9  /** no income when inactive!! **/

gen byte mndink_neg= (MNDINK1 < 0)
gen byte mndink_k= (MNDINK1 < 1000) *(MNDINK1 >= 0)
gen byte mndink_1000= (MNDINK1 < 2000) *(MNDINK1 >= 1000)
gen byte mndink_3000= (MNDINK1 < 4000) *(MNDINK1 >= 3000)
gen byte mndink_4000= (MNDINK1 < 5000) *(MNDINK1 >= 4000)
gen byte mndink_5000= (MNDINK1 < 6000) *(MNDINK1 >= 5000)
gen byte mndink_g= (MNDINK1 >= 6000) *(MNDINK1 <=.)

/**** Marital status ***/
gen byte gehuwd = (BURGST1==2)
gen byte samenwonend = (BURGST1 >4 )
gen byte gescheiden = (BURGST1==4) 

* kinderen=AANTKINDHH1
* type huishouden: met kinderen, eenouder, overig, institutioneel ?

/*** AGE(op 1e immigratie) ***/
gen byte lft1825 = (leeftijd_immi1  < 25) 
gen byte lft2530 = (leeftijd_immi1 >= 25)*(leeftijd_immi1 < 30)
* gen byte lft3035 = (leeftijd_immi1 >= 30)*(leeftijd_immi1 < 35) /* ref group */
gen byte lft3540 = (leeftijd_immi1 >= 35)*(leeftijd_immi1 < 40)
gen byte lft4045 = (leeftijd_immi1 >= 40)*(leeftijd_immi1 < 45)
gen byte lft4550 = (leeftijd_immi1 >= 45)*(leeftijd_immi1 < 50)
gen byte lft5055 = (leeftijd_immi1 >= 50)*(leeftijd_immi1 < 55)
gen byte lft5560 = (leeftijd_immi1 >= 55)*(leeftijd_immi1 < 60)
gen byte lft6065 = (leeftijd_immi1 >= 60)

/*** Rental house of owner ***/
gen byte Koop = (HuurKoop==1) /* owner */

/* Value of house
gen byte WOZ400 = (WOZWAARDE1 >= 400000)*(WOZWAARDE1!=.)
gen byte WOZ100 = (WOZWAARDE1 < 100000)*(WOZWAARDE1!=-9)
gen byte WOZ200 = (WOZWAARDE1 >= 200000)*(WOZWAARDE1 < 300000)
gen byte WOZ300 = (WOZWAARDE1 >= 300000)*(WOZWAARDE1 < 400000)

/*** Employment sector ***/
replace SBI1 = -9 if SECa1!=1 & SECa1!=2 /** No SBI if unemployed **/

gen byte SBIlandbouw = (SBI1==1)
gen byte SBIindus = (SBI1==3|SBI1==4|SBI1==5)
gen byte SBIbouw = (SBI1==6)
gen byte SBIhandel = (SBI1==9)
gen byte SBIhoreca = (SBI1==10)
gen byte SBIvervoer = (SBI1==11)
gen byte SBIfin = (SBI1==12)
gen byte SBIzak = (SBI1==14)
gen byte SBIonderwijs = (SBI1==18)
gen byte SBIzorg = (SBI1==19)
gen byte SBIcultuur = (SBI1==20)

label var SBIlandbouw "Agriculture"
label var SBIindus    "Industry"
label var SBIbouw     "Construction"
label var SBIhandel   "Trade"
label var SBIhoreca   "Horeca"
label var SBIvervoer  "Transportation and communication"
label var SBIfin      "Financial services"
label var SBIzak      "Other services"
label var SBIonderwijs "Education"
label var SBIzorg     "Health care"
label var SBIcultuur  "Cultural and public services"

/*** NATIONALITEIT ***/
* NL, na eerst niet-NL?
* verschil met geboorteland?
* NB Nationaliteit is endogeen aan verblijfsduur!!

/*** Parental country of birth ***/
gen byte interethnic = ( geb_land_ma!= geb_land_pa)*(geb_land_pa!=0)*(geb_land_ma!=0)
gen byte NLparent = (( geb_land_ma==6030)|( geb_land_pa==6030))

/*** Country of last residence differs from country of birth ***/
gen byte otherherkomst = ( geb_land!= herkomst_land)*(herkomst_land!=0)*(geb_land!=0)



