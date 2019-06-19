/* FixPrefixTrims.do */
/* This file makes easy changes to the RL Polk Prefix file to make trim names consistent across years.
There actually appear to be only a very limited number of cases where Polk labeled the same car
with different Trims over different years. In many cases, different Trim names correspond to vehicles with
different weights, or they change slightly in the same year that there was a redesign. So in many
cases small changes in Trim names are actually correct. This file changes a limited number that appear
to be incorrect.  */
/* Allcott and Wozny */

# delimit cr
*tab Make
*list Trim Cylinder FuelType StartMY EndMY if Make=="Acura" & FirstRec

/* Acura */
* Legend has L in every year from 1987-1995, except in 1989 when it is split into Lc and Ll.
replace Trim = "Legend L" if Make=="Acura" & (Trim=="Legend Lc" | Trim=="Legend Ll")

/* Chevrolet */
replace Trim = "Cavalier Vl" if Make=="Chevrolet" & (Trim=="Cavalier/Vl")

/* Oldsmobile */
replace Trim = "Cutlass Ciera S" if Make=="Oldsmobile" & Trim=="Cutlass Ciera/S"
replace Trim = "Cutlass Ciera Cruiser S" if Make=="Oldsmobile" & Trim=="Cutlass Cruiser/S"

/* Toyota */
* The 4Runners have different Trims that don't seem to correspond to the redesign years.
replace Trim = "4Runner Sr5" if Make=="Toyota" & Trim=="4 Runner Sr5"
replace Trim = "4Runner Sr5" if Make=="Toyota" & Trim=="4 Runner/Sr5"
replace Trim = "4 Runner Limited" if Make=="Toyota"& Trim=="4Runner Ltd"
replace Trim = "Celica Gt/Gt 25Th Ltd Edition" if Make=="Toyota" & Trim=="Celica Gt/25Th Anniversary Ltd"
replace Trim = "Celica St/St 25Th Ltd Edition" if Make=="Toyota" & Trim=="Celica St/25Th Anniversary Ltd"
replace Trim = "Highlander Sport" if Make=="Toyota" & Trim=="Highlander/Sport"
** These next three are actually similar Trim names for different vehicles, each of which exists for only one model year.
	* replace Trim = "Corolla Dx" if Make=="Toyota" & Trim=="Corolla/Dx"
	* replace Trim = "Previa Dx" if Make=="Toyota" & Trim=="Previa/Dx"
	* replace Trim = "Supra/Sptrf Limited Edition" if Make=="Toyota"&Trim=="Supra W/Sptrf Limited Edtion"
* The Tacoma Doublecab has a Trim name change in 2005 that corresponds to a redesign.




/* Fix Missing Cylinders */
* The Mazda Rx6 and Rx8 are missing cylinders for some years. It should be 2 cylinders.
replace Cylinder = 2 if Model=="Rx7" & Cylinder==0 
replace Cylinder = 2 if Model=="Rx8" & Cylinder==0


/* Fix Missing Liters */
* BMW 328I
replace Liters = 3 if Make == "Bmw" & Model=="328I" &ModelYear==2008 & Trim=="328I Sulev" & Liters==.

* Audi A5 Quattro
replace Liters = 3.2 if Make == "Audi" & Trim=="A5 Quattro" & ModelYear==2008 & Liters==. & Cylinder == 6

* Ford Explorer
replace Liters = 4.6 if Make == "Ford" & Model=="Explorer"&Cylinder==8 & ModelYear==2008 & Liters==.

* Ford Focus
replace Liters = 2.3 if Make == "Ford" & Model=="Focus"&Cylinder==4 & Trim=="Focus Zx4 St" & ModelYear==2005 & Liters==.

* Volkswagen GTI
replace Liters = 2 if Make == "Volkswagen" & Model=="Gti" & Cylinder==4 & Liters==.

* Tvr
replace Liters = 2.8 if Make == "Tvr" & Model=="Tvr" & Cylinder == 6 & Liters==.

* Subaru Legacy
replace Liters = 2.5 if Make == "Subaru" & Model=="Legacy" & Cylinder ==4 & Liters==. & ModelYear==2007

* Maserati Biturbo
replace Liters = 2 if Make == "Maserati" & Model=="Biturbo"& ModelYear==1984 & Liters==. & Cylinder==6

* Hyundai Accent 
replace Liters = 1.6 if Make == "Hyundai" & Model=="Accent" & ModelYear==2008 & Cylinder==4 & Liter==.

* Buick Lucerne
replace Liters = 4.6 if Make == "Buick" & Model=="Lucerne" & Cylinder == 8 & Liters==. & ModelYear==2008

** All others are automatic
bysort Make Model Cylinder Trim: egen AvLiters = mean(Liters)
replace AvLiters = round(AvLiters*10)/10
bysort Make Model Cylinder Trim: egen SDLiters = sd(Liters)
replace Liters = AvLiters if Liters==. & SDLiters<0.0001
drop AvLiters SDLiters

bysort Make Model Cylinder: egen AvLiters = mean(Liters)
replace AvLiters = round(AvLiters*10)/10
bysort Make Model Cylinder: egen SDLiters = sd(Liters)
replace Liters = AvLiters if Liters==. & SDLiters<0.0001
drop AvLiters SDLiters



** Return the delimiter to ; before returning to MakeVinPrefix.do
# delimit ;


