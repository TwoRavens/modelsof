/* WardsWorksheetPrep.do */
/* Allcott and Wozny (2011) */

** Address OCR Errors
replace v1 = subinstr(v1,"pass, ","pass. ",.)
replace v1 = subinstr(v1,"Ing-B","Long-b",.)
replace v1 = subinstr(v1,"Ing-b","long-b",.)
replace v1 = subinstr(v1,"B'ham","Brougham",.)

/* For years before 1996, Wards put the body style and Drive Type into v1, the submodel name */
	* This generates Submodel (later renamed Body Style) and Drive for the Wards years 1996 and before
if `year' <= 1996 {
** Drive
gen Drive = ""
foreach dr in fwd awd 4wd rwd 4x4 4X4 {
	replace Drive = upper("`dr'") if strpos(v1,"`dr'")!=0|strpos(v1,upper("`dr'"))!=0|strpos(v1,proper("`dr'"))!=0
	
	* Sub out the drive from the submodel name
	replace v1 = subinstr(v1,"`dr'","",.)
	replace v1 = subinstr(v1,upper("`dr'"),"",.)
}

	

** Submodel (This is really Body Style; it is renamed later)
* Door
gen Door=""
global DoorList ""2-door" "2 door" "2-dr" "2 dr" "3-door" "3 door" "3-dr" "3 dr" "4-door" "4 door" "4-dr" "4 dr" "4 dr" "5-door" "5 door" "5-dr" "5 dr""
foreach door in $DoorList {
	replace Door = proper("`door'") if strpos(v1,"`door'")!=0|strpos(v1,proper("`door'"))!=0
	* Sub out the Door from the submodel name
	replace v1 = subinstr(v1,"`door'","",.)
	replace v1 = subinstr(v1,proper("`door'"),"",.)
}
* Style
	* Note that these include some mis-reads for the OCR
gen Style = ""
	* Note that "van" is not in StyleList because it results in the Caravan, Vanagon, and Ram Van being mis-named and because "van" is not a useful BodyStyle anyway.
	* Note also that the order of the StyleList is important: e.g. at the end of the next line, we want pickup, but only if not Extended Cab. So pickup comes before Extended Cab, but after Extended Cab Pickup.
global StyleList " "club coupe" "club cpe." "conv. SSUV" "hardtop SSUV" "hdtop. SSUV"  "sedan" "sed" "set" "convertible" "convert" "Conv't" "conv't" "conv" "hardtop" "H'top" "h'top" "wagon" "wag" "notch" "notch coupe" "natchback" "hatchback" "H'back" "h'back" "hatch" "halch" "coupe" "coup" "cpe" "small cargo van" "ext. mid. cargo van" "mid. cargo van" "small ext. cargo van" "extended compact cargo van" "compact cargo van" "cargo van" "Cargo van" "cargo Van"  "ext. mid. pass. van" "ext. mid. pass van" "ext. pass. van" "mid. pass. van" "mid pass. van" "mid. Pass. van" "mid pass van" "mid. pass. Van" "small pass. van" "small pass van" "extended compact passenger van" "compact passenger van" "compact pass. van" "passenger van" "pass van" "pass. van" "pass, van" "extended compact van" "full size van" "h.d. van" "extended van" "SSUV" "SUV" "sport-utility" "sport utility" "ext. cab pickup" "ext cab pickup" "cab plus pickup" "club cab pickup" "Crew cab pickup"  "crew cab pickup" "supercab pickup" "pickup" "ext. cab" "ext cab" "extended cab" "cab plus" "club cab"  "Crew cab" "crew cab" "king cab" "Super Cab" "Super cab" "supercab" "SuperCab" "xtracab" "maxi cab" "maxicab" "ch. cab" "bonus cab" "SpaceCab" "
foreach style in $StyleList {
	replace Style = proper("`style'") if (strpos(v1,"`style'")!=0|strpos(v1,proper("`style'"))!=0 ) & ((strpos(v1,"Ram Wagon")==0&strpos(v1,"Club Wagon")==0&strpos(v1,"Value Wagon")==0&strpos(v1,"Maxi")==0&strpos(v1,"Wagoneer")==0) | ("`style'"!="wagon"&"`style'"!="wag"))
			* not needed: if v1 != "Volkswagen" & strpos(v1,"Vanagon")==0 
	replace v1 = subinstr(v1,"`style'","",.) if (strpos(v1,"Ram Wagon")==0&strpos(v1,"Club Wagon")==0&strpos(v1,"Value Wagon")==0&strpos(v1,"Maxi")==0&strpos(v1,"Wagoneer")==0) | ("`style'"!="wagon"&"`style'"!="wag")
	replace v1 = subinstr(v1,proper("`style'"),"",.) if (strpos(v1,"Ram Wagon")==0&strpos(v1,"Club Wagon")==0&strpos(v1,"Value Wagon")==0&strpos(v1,"Maxi")==0&strpos(v1,"Wagoneer")==0) | ("`style'"!="wagon"&"`style'"!="wag")
}	

* Address OCR Errors
replace Style = "Sed" if Style == "Set"
replace Style = "Hatch" if Style == "Halch"
replace Style = "Hatch" if Style == "Natch"
replace Style = "Hatchback" if Style == "Natchback"
replace Style = "Pass. Van" if Style == "Pass, Van"

replace v1 = subinstr(v1,",","",.)
replace v1 = subinstr(v1,". "," ",.)
replace v1 = trim(itrim(v1))

gen space = " "
egen Submodel = concat(Door space Style)
drop Door Style space



}
*



/** Get ModelYear **/
replace v1= proper(trim(v1))
replace ModelYear = ModelYear+1 if (real(word(v1,1))==ModelYear+1 | real(substr(v1,1,2))+1900==ModelYear+1 | real(substr(v1,2,2))+1900==ModelYear+1)& ModelYear<=1996

drop if v1=="Import" | v1=="Domestic"
** Drop optional engines
drop if strpos(v1,"Optional")!=0 & (Submodel=="-" | Submodel=="--" | Submodel=="---" | Submodel=="----" | strpos(Submodel,"Optional")!=0)


/** Get Make **/
gen Make = ""
gen ThisIsMake = (strpos(v1,"Acura")!=0|strpos(v1,"Alfa Romeo")!=0|strpos(v1,"Am General")!=0|strpos(v1,"American Motors")!=0|strpos(v1,"Audi")!=0|strpos(v1,"Austin")!=0|strpos(v1,"Bentley")!=0|strpos(v1,"Bertone")!=0|strpos(v1,"Bmw")!=0|strpos(v1,"Buick")!=0|strpos(v1,"Cadillac")!=0|strpos(v1,"Chevrolet")!=0|strpos(v1,"Chrysler")!=0|strpos(v1,"Daihatsu")!=0|strpos(v1,"Daewoo")!=0|strpos(v1,"Dodge")!=0|strpos(v1,"Eagle")!=0|strpos(v1,"Ferrari")!=0|strpos(v1,"Fiat")!=0|strpos(v1,"Ford")!=0|strpos(v1,"General Motors")!=0|strpos(v1,"Gmc")!=0|strpos(v1,"Honda")!=0|(v1=="Hummer")|strpos(v1,"Hyundai")!=0|strpos(v1,"Infiniti")!=0|strpos(v1,"International")!=0|strpos(v1,"Isuzu")!=0|strpos(v1,"Iveco/Magurus")!=0|strpos(v1,"Jaguar")!=0|strpos(v1,"Jeep")!=0|strpos(v1,"Kia")!=0|strpos(v1,"Lamborghini")!=0|strpos(v1,"Lancia")!=0|strpos(v1,"Land Rover")!=0|strpos(v1,"Lexus")!=0|strpos(v1,"Lincoln")!=0|strpos(v1,"Lotus")!=0|strpos(v1,"Maserati")!=0|strpos(v1,"Mazda")!=0|strpos(v1,"Mercedes")!=0|strpos(v1,"Mercury")!=0|strpos(v1,"Merkur")!=0|strpos(v1,"Mini")!=0|strpos(v1,"Mitsubishi")!=0|strpos(v1,"Mitsu-Fuso")!=0|strpos(v1,"Nissan")!=0|strpos(v1,"Oldsmobile")!=0|strpos(v1,"Opel")!=0|strpos(v1,"Peugeot")!=0|strpos(v1,"Plymouth")!=0|strpos(v1,"Pontiac")!=0|strpos(v1,"Porsche")!=0|strpos(v1,"Renault")!=0|strpos(v1,"Rolls")!=0|strpos(v1,"Saab")!=0|strpos(v1,"Saturn")!=0|strpos(v1,"Scion")!=0|strpos(v1,"Sterling")!=0|strpos(v1,"Subaru")!=0|strpos(v1,"Suzuki")!=0|strpos(v1,"Toyota")!=0|strpos(v1,"Triumph")!=0|strpos(v1,"Volkswagen")!=0)
	* Have to add this second step because there are too many "literals" in the above statement.
	replace ThisIsMake = 1 if strpos(v1,"Volvo")!=0|strpos(v1,"Yugo")!=0

replace ThisIsMake = 0 if ((strpos(v1,"Mazdaspeed")==0&strpos(v1,"Mazda3")==0&strpos(v1,"Mazda5")==0&strpos(v1,"Mazda6")==0)&strpos(v1,"Passport")==0&strpos(v1,"Odyssey")==0)==0
replace Make= word(v1,1) if ThisIsMake
replace Make="Am General" if Make=="Am"
replace Make="American Motors" if ThisIsMake==1 & strpos(v1,"American Motors")!=0
replace Make="Buick" if ThisIsMake==1 & strpos(v1,"Buick")!=0
replace Make="Chrysler" if ThisIsMake==1 & strpos(v1,"Chrysler")!=0
replace Make="Land Rover" if Make=="Land"
*replace Make="Plymouth" if ThisIsMake == 1 & strpos(v1,"Plymouth")!=0 * Ward's often does not distinguish between Chrysler and Plymouth
replace Make="Lincoln-Mercury" if ThisIsMake == 1 & strpos(v1,"Lincoln")!=0 & strpos(v1,"Mercury")!=0
replace Make="Eagle" if ThisIsMake == 1 & strpos(v1,"Eagle")!=0 
drop ThisIsMake
replace Make="" if Wheelbase!=""
replace Make=substr(Make,1,strpos(Make,"-")-1) if strpos(Make,"-")!=0
replace Make=Make[_n-1] if Make==""

/** Get Model **/
if (`year' <= 2000 & `car' == 1)|(`year'<=2002 & `truck'==1)|`import'==1 gen Model = v1
if (`year' >=2001&`car'==1)|(`year'>=2003&`truck'==1) gen Model = v1 if Wheelbase==""

replace Model=Model[_n-1] if Model=="" & Make==Make[_n-1]
rename v1 Trim

drop if Submodel=="" & Wheelbase==""
/*
replace Model = word(v1,2) if word(v1,1)=="Honda" & ( word(v1,2)=="Passport" |word(v1,2)=="Odyssey" )
replace Model = word(v1,2) if ( real(word(v1,1))==ModelYear | real(substr(v1,2,2))+1900==ModelYear )
replace Model = "" if (strpos(Model,"Optional")==1 | Model=="“SSEi” Model Option" | Model=="“Ss” Model Option" |Model==""SS" Model" |Model=="Model Option"|Model=="Quattro option"|Model=="Touring Sedan Option"|Model=="Gle Option"|Model=="“Ssei” Model Option"|Model=="Ssei Option")
replace Submodel = Submodel[_n-1] if (Submodel=="-" | Submodel=="--" | Submodel=="---" | Submodel=="----") & Model[_n]==""
replace Model = Model[_n-1] if Model[_n]==""
replace Model=substr(Model,1,length(Model)-1) if substr(Model,length(Model),1)==":"
replace Model=substr(Model,1,length(Model)-1) if substr(Model,length(Model),1)==","
replace Model=substr(Model,1,length(Model)-3) if substr(Model,length(Model)-1,2)=="**"


/** Get Submodel **/
replace Submodel=Submodel[_n-1] if strpos(Model,"Optional")==1
*/



/* Get MSRP */
replace MSRP= trim(MSRP)
replace MSRP= substr(MSRP,2,length(MSRP)) if strpos(MSRP,"$")==1
replace MSRP= subinstr(MSRP,",","",.)
destring MSRP, replace force

/* Get HP & Torque & Weight & Wheelbase & Cylinders & Liters */
replace HP= substr(HP,1,strpos(HP,"@")-1) if strpos(HP,"@")!=0
destring HP, replace force

replace Torque= substr(Torque,1,strpos(Torque,"@")-1) if strpos(Torque,"@")!=0
destring Torque, replace force

destring Weight, replace force ignore(",")

replace Wheelbase=substr(Wheelbase,1,3) if length(Wheelbase)>4
destring Wheelbase, replace force

replace Cylinders = substr(Cylinders,length(Cylinders),1)
destring Cylinders, replace force

destring Liters, replace force

/* Traction, Stability, and ABS */
foreach var in Traction Stability ABS {
	gen Num`var' = .
	replace Num`var' = 2 if substr(`var',1,1) == "S"
	replace Num`var' = 1 if substr(`var',1,1) == "O"
	replace Num`var' = 0 if `var' == "--" | `var' == ""
	drop `var'
	rename Num`var' `var'
}

/* Get MPG */
if (`car'==1 & `year' <= 1990)|(`truck'==1&`year'<=1990)|(`import'==1&`year'<=1992) {
	capture destring MPGCity MPGHwy, replace force
	gen slash = "-"
	egen MPGWards = concat(MPGCity slash MPGHwy)
	drop slash
}
else {
gen MPGCity = real(substr(MPGWards,1,strpos(MPGWards,"/")-1))
gen MPGHwy = real(substr(MPGWards,strpos(MPGWards,"/")+1,length(MPGWards)-strpos(MPGWards,"/")))
replace MPGCity = real(substr(MPGWards,2,strpos(MPGWards,"/")-2)) if substr(MPGWards,1,1)=="*"
replace MPGCity = real(substr(MPGWards,3,strpos(MPGWards,"/")-3)) if substr(MPGWards,1,2)=="**"
replace MPGCity = 12 if substr(MPGWards,strpos(MPGWards,"-")+1,3)=="Dec"
replace MPGHwy = real(substr(MPGWards,1,strpos(MPGWards,"-")-1)) if substr(MPGWards,strpos(MPGWards,"-")+1,3)=="Dec"
}

/* Get attributes for optional engines */
** Numeric variables
	* This typically does not change anything
foreach var in Weight Cylinders Liters HP MPGCity MPGHwy MSRP Wheelbase Truck Torque Stability ABS Traction {
replace `var' = `var'[_n-1] if `var'==.&Model==Model[_n-1]&Make==Make[_n-1]
}

** String variables
foreach var in Drive MPGWards {
replace `var' = `var'[_n-1] if `var'=="--"&Model==Model[_n-1]&Make==Make[_n-1]
}


/** Shape the Data **/
drop if ( HP==. & Weight==. & Liters == .)

keep Make Model Submodel Trim ModelYear Weight Drive Cylinders Liters HP MPGWards MPG* MSRP Wheelbase Torque Traction ABS Stability Truck
order Make Model Submodel Trim ModelYear Weight Drive Cylinders Liters HP MPGWards MPG* MSRP Wheelbase Torque Traction ABS Stability Truck
