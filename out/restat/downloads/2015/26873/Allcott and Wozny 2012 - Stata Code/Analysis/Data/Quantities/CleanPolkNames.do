/* CleanPolkNames.do */
/* Allcott & Wozny */
/* This is used by both PolkDataPrep.do and NVPPToPrefix.do */


foreach var in Make Model ModelYear Trim Cylinder Liters FuelCode BodyStyle DriveWheel {
    local varlower = lower("`var'")
    rename `varlower' `var'
}
rename FuelCode FuelType
rename Cylinder Cylinders
rename DriveWheel Drive

/* Model Year */
* Get data types right. Liters needs to be double for the match to work properly, so the insheet must be double.
recast int ModelYear

/* Make and Model */
replace Make= proper(trim(Make))
replace Model= proper(trim(Model))

** Clean Make (1976~2006)
replace Make="Bertone" if Make=="Bertone/Pininfa"
replace Make="Amc/Eagle" if Make=="Eagle/Amc"
replace Make="Dodge" if Make=="Challenger-Dodge"
replace Make="Dodge" if Make=="Colt - Dodge"
replace Make="Plymouth" if Make=="Champ - Plymouth"
replace Make="Plymouth" if Make=="Cricket - Plymouth"
replace Make="Plymouth" if Make=="Sapporo-Plymouth"
replace Make="Ford" if Make=="English Ford Line"
replace Make="Ford" if Make=="Fiesta-Ford"
replace Make="Nissan/Datsun" if Make=="Nissan/Datsun/Ud"
replace Make="Iveco/Magurus" if Make=="Iveco/Magirus"
replace Make="Mg" if Make=="M G"
replace Make="Oshkosh" if Make=="Oshkosh/John Deere"
replace Make="Rolls-Royce" if Make=="Rolls Royce"
replace Make="Sterling" if Make=="Sterling/Rover"

replace Make= proper(trim(Make))
replace Model= proper(trim(Model))

** Clean Model
gen Ind=.
replace Ind=1 if ModelYear!=2007 & ModelYear!=2008
replace Model="Gtv6 2.5" if Model=="Gtv6" & Ind==1
replace Model="Classic Fleet" if Model=="Classic" & Ind==1
replace Model="Grnd Voyager Se" if Model=="Grand Voyager Se" & Ind==1
replace Model="Grnd Voyager" if Model=="Grand Voyager" & Ind==1
replace Model="Pt Cruiser Lmt/Dream" if Model=="Pt Cruiser Limited/D" & Ind==1
replace Model="Twn And Country" if Model=="Town And Country" & Ind==1
replace Model="Town And Country Lmt" if Model=="Town And Country Lim" & Ind==1
replace Model="Twn And Cntry Lx/Lxi" if Model=="Town And Country Lx/" & Ind==1
replace Model="Twn And Country Sx" if Model=="Town And Country Sx" & Ind==1
replace Model="Twn And Country Tour" if Model=="Town And Country Tou" & Ind==1
replace Model="Town And Country Lx" if Model=="Town And Countrylx" & Ind==1
replace Model="Town And Country Lxi" if Model=="Town And Countrylxi" & Ind==1
replace Model="Twn And Country Sx" if Model=="Town And Countrysx" & Ind==1
replace Model="Grand Caravan Se/Sp" if Model=="Grand Caravan Se/Spo" & Ind==1
replace Model="F-150 Supercrew Har" if Model=="F-150 Supercrew Harl" & Ind==1
replace Model="Gt Coupe" if Model=="Gt" & Make=="Ford" & Ind==1
replace Model="Grand Cherokee Lard" if Model=="Grand Cherokee Lared" & Ind==1
replace Model="Grand Cherokee Limi" if Model=="Grand Cherokee Limit" & Ind==1
replace Model="Grand Cherokee Lmtd" if Model=="Grand Cherokee Lmtd/" & Ind==1
replace Model="Grand Cherokee Over" if Model=="Grand Cherokee Overl" & Ind==1
replace Model="Grand Cherokee Sr-8" if Model=="Grand Cherokee Srt-8" & Ind==1
replace Model="Liberty Sport/Freed" if Model=="Liberty Sport/Freedo" & Ind==1
replace Model="Wrangler Lwb/Unlimi" if Model=="Wrangler Lwb/Unlimit" & Ind==1
replace Model="Wrangler Rubicon Ul" if Model=="Wrangler Rubicon Unl" & Ind==1
replace Model="Wrangler S/Rio Gran" if Model=="Wrangler S/Rio Grand" & Ind==1
replace Model="Mazda3 Hatch" if Model=="Mazda3" & Ind==1
replace Model="Mazda6 I" if Model=="Mazda6" & Ind==1
replace Model="Sentra I" if Model=="Sentra Se-R Limite" & Ind==1
replace Model="Olds 98" if Model=="98" & strpos(Make,"Olds")==1 & Ind==1
replace Model="Olds Lss" if Model=="Lss" & strpos(Make,"Olds")==1 & Ind==1
replace Model="Grand Voyager Se/Ex" if Model=="Grand Voyager Se/Exp" & Ind==1
replace Model="Grand Voyager Se/Rl" if Model=="Grand Voyager Se/Ral" & Ind==1
replace Model="Seqouia Limited" if Model=="Sequoia Limited" & Ind==1

/* Cylinders and Liters */
destring Cylinders, replace force
replace Liters = Liters*10
recast int Liters

/* Drive */
replace Drive="AWD" if Drive=="4X4"
replace Drive="4WD" if Drive=="AWD"
replace Drive="2WD" if Drive=="FWD"|Drive=="RWD"

/* FuelTypes: Gas, CNG, Diesel, Electricity */
replace FuelType = "CNG" if FuelType == "NATR. GAS"
replace FuelType = "Gas" if FuelType == "CNVRTBLE"|FuelType=="FLEXIBLE"|FuelType=="GAS"|FuelType=="GAS/ELEC"|FuelType=="PROPANE"|FuelType=="METHANOL"
replace FuelType = "Diesel" if FuelType=="DIESEL"
replace FuelType = "Electricity" if FuelType == "ELECTRIC"

/* Body Style */
replace BodyStyle = "PICKUP" if BodyStyle == "PICKUP - CREW CAB"
replace BodyStyle = "CHASSIS - CAB" if BodyStyle == "CHASSIS - CREW CAB"
replace BodyStyle = "COUPE" if BodyStyle == "SEDAN 2 DOOR"

* The Mazda Rx6 and Rx8 are missing cylinders for some years. It should be 2 cylinders.
replace Cylinders = 2 if Model=="Rx7" & Cylinders==.
replace Cylinders = 2 if Model=="Rx8" & Cylinders==.

* The GMC Envoy Xl is missing liters. Should be 5.3
replace Liters = 53 if Make == "Gmc" & Model=="Envoy Xl" & Liters==.

* Infiniti Fx45 has an error in liters. Should be 4.5
replace Liters = 45 if Make == "Infiniti" & Model=="Fx45" & ModelYear==2006&Liters==35

* Isuzu Ascender has an error also. Should be 5.3 Liters
replace Liters = 53 if Make == "Isuzu" & Model=="Ascender Ls/Ltd" & Liters == 42 & Cylinders == 8 & ModelYear==2005

* 1984 Isuzu Impulse should be 1.9, not 1.8 Liters.
replace Liters = 19 if Make=="Isuzu" & Model=="Impulse" & Liters == 18 & ModelYear==1984

*
