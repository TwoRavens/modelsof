set more off

use AutoPQXG.dta,clear
drop Weight
rename ShippingWeight Weight
keep CarID ModelYear Year Month Price Age Quantity NumObs Make Model Trim Weight VClass

sum Weight if Weight!=0

replace Weight = r(mean) if Weight == 0 | Weight==.

xi i.Age*Weight, pre(_A)
gen lnPrice = log(Price)
reg lnPrice _A*
predict lnPriceHat
gen lnPriceDev = lnPrice - lnPriceHat
bysort CarID: egen meanlnPriceDev = mean(lnPriceDev)

reg Price _A*
predict PriceHat
gen PriceDev = Price - PriceHat
bysort CarID: egen meanPriceDev = mean(PriceDev)

collapse (mean) Price meanlnPriceDev meanPriceDev ModelYear, by(CarID Make Model VClass)

/* Generate subjective group variables */
** Exotic: strict definition of Exotic. 
* Most expensive sports cars and rare imports
gen Exotic = 0
replace Exotic=1 if Make=="Acura"&(Model=="Nsx")
replace Exotic=1 if Make=="Alfa Romeo"
replace Exotic=1 if Make=="Audi"&(Model=="R8"|Model=="Tt")
replace Exotic=1 if Make=="Bentley"
replace Exotic=1 if Make=="Chrysler"&(Model=="Prowler"|Model=="Tc (By Maserati)")
* The Allante was positioned alongside Jaguar and Mercedes: http://en.wikipedia.org/wiki/Cadillac_Allante
replace Exotic=1 if Make=="Cadillac"&(Model=="Allante"|Model=="Xlrroadster")
replace Exotic=1 if Make=="Dodge"&(Model=="Viper"|Model=="Stealth")
replace Exotic=1 if Make=="Ferrari"
replace Exotic=1 if Make=="Ford"&(Model=="Gt")
replace Exotic=1 if Make=="Jaguar"
replace Exotic=1 if Make=="Lamborghini"
replace Exotic=1 if Make=="Maserati"
replace Exotic=1 if Make=="Maybach"
replace Exotic=1 if Make=="Plymouth"&Model=="Prowler"
replace Exotic=1 if Make=="Porsche"
replace Exotic=1 if Make=="Rolls-Royce"
replace Exotic=1 if Make=="Tvr"
* Note that the Corvette is also classified as a sports car
replace Exotic=1 if Make=="Chevrolet"&Model=="Corvette"


gen ForeignHighLuxury = 0
replace ForeignHighLuxury=1 if Make=="Bmw"
replace ForeignHighLuxury=1 if Make=="Mercedes-Benz"
replace ForeignHighLuxury = 1 if Make=="Audi"&(substr(Model,1,1)=="R"|substr(Model,1,1)=="S"|Model=="V8 Quattro")

gen ForeignLuxury = ForeignHighLuxury
replace ForeignLuxury=1 if Make=="Acura"
replace ForeignLuxury=1 if Make=="Audi"
replace ForeignLuxury=1 if Make=="Infiniti"
replace ForeignLuxury=1 if Make == "Land Rover"
replace ForeignLuxury=1 if Make=="Lexus"
replace ForeignLuxury=1 if Make=="Volvo"
replace ForeignLuxury = 1 if Make=="Toyota"&(Model=="Landcruiser"|Model=="Landcruiser S/W")
* replace ForeignLuxury=1 if Make=="Saab"


gen SportsCar = 0
replace SportsCar=1 if Make=="Buick"&(Model=="Reatta")
replace SportsCar=1 if Make=="Chevrolet"&(Model=="Corvette"|Model=="Elcamino"|Model=="Camaro")
replace SportsCar=1 if Make=="Chrysler"&(Model=="Conquest"|Model=="Crossfire"|Model=="Laser")
replace SportsCar=1 if Make=="Cadillac"&Model=="Eldorado"
replace SportsCar=1 if Make=="Dodge"&(Model=="Daytona"|Model=="Challenger"|Model=="Challngr(Sub-Cpt)"|Model=="Conquest")
replace SportsCar=1 if Make=="Ford"&(Model=="Mustang"|Model=="Thunderbird")
replace SportsCar=1 if Make=="Mercury"&Model=="Capri"
replace SportsCar=1 if Make == "Mitsubishi"&(Model=="3000Gt"|Model=="Eclipse"|Model=="Starion")
	* Volvo C30 is a coupe, but intended for the "youth market" and "first time Volvo buyers."
replace SportsCar=1 if Make=="Volvo"&(Model=="C70"|Model=="C30")
replace SportsCar=1 if Make=="Honda"&(Model=="Prelude"|Model=="S2000")
replace SportsCar=1 if Make=="Mazda"&(Model=="Mx-5 Miata"|Model=="Mx-3"|Model=="Mx-6"|Model=="Mx=6 (U.S.)"|Model=="Rx7"|Model=="Rx8")
replace SportsCar=1 if Make == "Nissan"&(Model=="280Zx"|Model=="300Zx"|Model=="350Z")
replace SportsCar=1 if Make=="Pontiac"&(Model=="Fiero"|Model=="Firebird"|Model=="Solstice"|Model=="Gto")
replace SportsCar=1 if Make=="Toyota"&(Model=="Supra"|Model=="Mr2")
replace SportsCar=1 if Make=="Volkswagen"&(Model=="Scirocco"|Model=="Corrado")

* Mazda Speed 3 is performance but only costs $22,835 according to Wikipedia.
replace SportsCar = 1 if Make == "Mazda"&Model=="Speed3"

gen DomesticLuxury = 0
replace DomesticLuxury = 1 if Make=="Buick" & Model=="Riviera"
replace DomesticLuxury = 1 if Make=="Cadillac"
replace DomesticLuxury= 1 if Make=="Chrysler"&(Model=="Executive Sedan"|Model=="Fifth Avenue")
* wikipedia says that Lincoln is the luxury brand for Ford.
* replace DomesticLuxury=1 if Make=="Lincoln"&Model=="Town Car"
replace DomesticLuxury = 1 if Make=="Lincoln"




** Vehicles left out: Hummer
** replace Exotic=1 if Make=="Hummer"


/* Generate Lux variables */
sort meanPriceDev
sum Price
gen LuxPctile = _n/r(N)
replace LuxPctile = . if Price==.

sort meanlnPriceDev
sum Price
gen LuxlnPctile = _n/r(N)
replace LuxlnPctile = . if Price==.

gen LuxP85 = cond(LuxPctile>=.85&((VClass!=8&VClass!=7)|Exotic==1),1,0)
gen LuxlnP85 = cond(LuxlnPctile>=.85&((VClass!=8&VClass!=7)|Exotic==1),1,0)

collapse (max) Exotic ForeignHighLuxury ForeignLuxury SportsCar DomesticLuxury LuxP85 LuxlnP85, by(Make Model)
sort Make Model
save ExoticList.dta, replace
