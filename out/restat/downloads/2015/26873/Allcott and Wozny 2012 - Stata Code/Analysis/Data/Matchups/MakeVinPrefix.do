# delimit ;

/******************************************************************************
MakeVinPrefix.do
Nathan Wozny, 8/17/09. Further modified by Hunt Allcott 11/2010.
Uses the raw data ("Complete Prefix File") provided by Polk and creates a Stata
dataset that can be used to match VINs to vehicle information that will then be
matched to the Polk quantity data (the NVPP).
******************************************************************************/

capture log close;
log using MakeVinPrefix.log, replace;

clear all;

** Pre-prepare Generations.dta;
insheet using Generations.csv, comma names case clear;
drop v5 StartMY EndMY Notes;
sort Make Model;
save Generations.dta, replace;

infile using Prefix.dct,clear;
rename BaseModel Model;
rename NVPPSeries Trim;
assert trim(YearModel)=="";

* There are two versions of "Number of Cylinders."  They agree most of the time, with ~15 exceptions
* (plus ~150 more where one is missing).  We use the later one first, filling in the earlier one if
* the later one is missing.;
replace Cylinders = CylCode if Cylinders=="";
destring Cylinders, ignore("R") gen(Cylinder);
replace Cylinder = 0 if Cylinders=="R";

* There are two versions of "Drive wheels."  We use the one applicable to all vehicles, not just trucks.
* Documentation says that blank values represent RWD.  I will trust this, although it seems likely that
* some blanks should actually be missing.;
replace DriveWheels="R" if DriveWheels=="";

destring Liters, ignore("L") gen(NumLiters);
drop Liters;
rename NumLiters Liters;

replace FuelType = "GAS/ELEC" if FuelType=="B";
replace FuelType = "CNVRTBLE" if FuelType=="C";
replace FuelType = "DIESEL" if FuelType=="D";
replace FuelType = "ELECTRIC" if FuelType=="E";
replace FuelType = "FLEXIBLE" if FuelType=="F";
replace FuelType = "GAS" if FuelType=="G";
replace FuelType = "ETHANOL" if FuelType=="H";
replace FuelType = "METHANOL" if FuelType=="M";
replace FuelType = "NATR.GAS" if FuelType=="N";
replace FuelType = "PROPANE" if FuelType=="P";
*rename FuelType FuelCode;

* Gas is to mean primarily gasoline, which includes Gas/Elec and Flexible but not Propane, methanol, ethanol, etc.;
replace FuelType = "Gas" if FuelType=="FLEXIBLE"|FuelType=="GAS"|FuelType=="GAS/ELEC";
replace FuelType = "Diesel" if FuelType=="DIESEL";
replace FuelType = "Electricity" if FuelType == "ELECTRIC";
* Methanol is only two model year 1983 sedans, Convertible appears to be CNG, methanol is uncommon;
replace FuelType = "Other Hydrocarbon" if (FuelType == "CNVRTBLE"|FuelType=="PROPANE"|FuelType=="METHANOL"|FuelType == "NATR.GAS"|FuelType=="ETHANOL");

gen AltFuel = cond(FuelType=="Gas"|FuelType=="Diesel",0,1);
label var AltFuel "=1 if vehicle is not powered directly or indirectly by gas";

label var BodyStyle "Body Style (text description)";
label var BodyType "Body Style (2 digit code)";

** Special vehicle type is vehicles that are for commercial use or are not good substitutes with other vehicles in the passenger vehicle market;
	* Note that panel vehicles are OK - this is the Chevy HHR;
gen SpecialVehType = (BodyStyle=="2 PASS LOW SPEED VEH" | BodyStyle=="CARGO CUTAWAY" | BodyStyle=="CUTAWAY" | BodyStyle=="FORWARD CONTROL" | BodyStyle=="HEARSE" | BodyStyle=="INCOMPLETE CHASSIS" | BodyStyle=="INCOMPLETE EXT VAN" | BodyStyle=="INCOMPLETE PASSENGER" | BodyStyle=="MOTORIZED CUTAWAY" | BodyStyle=="MOTORIZED HOME"|BodyStyle=="AMBULANCE"|BodyStyle=="BUS"|BodyStyle=="CARGO VAN"|BodyStyle=="DISPLAY VAN"|BodyStyle=="EXTENDED CARGO VAN"|BodyStyle=="LIMOUSINE"|BodyStyle=="PARCEL DELIVERY"|BodyStyle=="STEP VAN"|BodyStyle=="VAN CAMPER"|BodyStyle=="3 DR EXT CAB / CHASS"|BodyStyle=="4 DR EXT CAB / CHASS"|BodyStyle=="CAB AND CHASSIS"|BodyStyle=="CLUB CHASSIS"|BodyStyle=="CREW CHASSIS"|BodyStyle=="TILT CAB");
label var SpecialVehType "=1 for incomplete vehicles, motor homes, golf carts, etc";

/* Drop alternate fuels and special vehicle types */
drop if FuelType~="Gas" | SpecialVehType==1;

keep  MatchVin ModelYear Make Model BodyType BodyStyle Trim TransCode DriveWheels Cylinder Liters FuelType AltFuel SpecialVehType Wheelbase ShippingWeight CubicInches;
rename Wheelbase PolkWheelbase;

foreach var in MatchVin Make Model BodyType BodyStyle Trim TransCode DriveWheels FuelType {;
    di "Missing values of `var'";
    gen msg`var' = (`var'=="");
    tab msg`var';
    drop msg`var';
};
foreach var in ModelYear Cylinder Liters PolkWheelbase ShippingWeight CubicInches {;
    di "Missing values of `var'";
    gen msg`var' = (`var'==.);
    tab msg`var';
    drop msg`var';
};

/* Clean names */
replace Make= proper(trim(Make));
replace Model= proper(trim(Model));
replace Trim=proper(trim(Trim));
replace Make="Hummer" if Make=="Am General";
replace Make="Amc/Eagle" if Make=="American Motors";
replace Make="Amc/Eagle" if Make=="Eagle";
replace Make="Nissan" if Make=="Nissan Diesel" | Make=="Datsun";
replace Make="Rolls-Royce" if Make=="Rolls";
replace Make="Toyota" if Make=="Scion";
replace Model="Jimny" if Make=="Suzuki" & Model=="Samurai";
replace Trim=substr(Trim,1,length(Trim)-5) if substr(Trim,length(Trim)-5,.)==" U.S.";
replace Trim=substr(Trim,1,length(Trim)-5) if substr(upper(Trim),length(Trim)-5,.)==" (US)";
replace Trim=substr(Trim,4,.) if substr(upper(Trim),1,3)=="US ";
replace Model=trim(substr(Model,1,length(Model)-6)) if substr(Model,length(Model)-6,.)=="(U.S.)";
replace Model="Rabbit" if Make=="Volkswagen" & Model=="U.S. Rabbit";
replace Model="Halfton Pickup" if Make=="Toyota" & Model=="Hlftn Pkup U.S.";
replace Model=trim(substr(Model,1,length(Model)-8)) if substr(Model,length(Model)-8,.)=="(Canada)";
replace Model=trim(substr(Model,1,length(Model)-5)) if substr(Model,length(Model)-5,.)=="(Can)";
replace Trim=trim(substr(Trim,1,length(Trim)-8)) if substr(Trim,length(Trim)-8,.)=="(Canada)";
replace Trim=trim(substr(Trim,1,length(Trim)-5)) if substr(Trim,length(Trim)-5,.)=="(Can)";


/* Jaguar*/
replace Trim="Xkr" if Model=="Xkr New Gen 2007"&Trim=="Xkr New Generation";
replace Model="Xkr" if Model=="Xkr New Gen 2007";


/* Clean Mercedes Names */
replace Model="C230" if Model=="C230 Gen 2006";
replace Trim="C230" if Trim=="C230 4Matic"|Trim=="C230 New Gen";

replace Model="C280" if Model=="C280 Gen 2006";
replace Trim="C280" if Trim=="C280 4Matic"|Trim=="C280 New Gen";

/* Attempt to fix the many labels of truck models and submodels of GMC / Chevrolet. This affects the construction of CarIDs. */
replace Model = "Van" if Make=="Chevrolet" & Model=="Van (Chevy Trk)";
replace Trim = "Blazer" if Make=="Chevrolet" & Trim=="S10 Blazer";
replace Model = "Blazer" if Make=="Chevrolet" & Trim=="Blazer";
replace Model = "Tahoe" if Make=="Chevrolet" & (Model=="C1500 Tahoe" | Model=="K1500 Tahoe");
replace Model = "Denali" if Make=="Gmc" & Model=="Yukon" & strpos(Trim,"Denali")>0;
replace Model = "Denali" if Make=="Gmc" & Model=="Yukon/Denali";
replace Trim = "C1500 Tahoe" if Make=="Gmc" & Model=="Yukon" & Trim=="C1500 Yukon Xl";
replace Trim = "K1500 Tahoe" if Make=="Gmc" & Model=="Yukon" & Trim=="K1500 Yukon Xl";
replace Trim = "Tahoe Hybrid" if Make=="Chevrolet" & strpos(Model,"Tahoe")>0 & strpos(Trim,"Hybrid")>0;
replace Trim = "Tahoe Hybrid" if Make=="Gmc" & Model=="Yukon" & Trim=="Yukon Hybrid";
replace Model = "Tahoe" if Make=="Gmc" & Model=="Yukon";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Tahoe";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="'S'Truck";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="C1500";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="C2500";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="C3500";
replace Trim = "El Camino" if Make=="Gmc" & Model=="Caballero";
replace Model = "Elcamino" if Make=="Gmc" & Model=="Caballero";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Elcamino";
replace Trim = "Colorado" if Make=="Gmc" & Model=="Canyon";
replace Model = "Colorado" if Make=="Gmc" & Model=="Canyon";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Colorado";
replace Model = "Envoy" if Make=="Gmc" & Model=="Envoydenali";
replace Trim = "Blazer" if Make=="Gmc" & strpos(Model,"Jimmy")>0;
replace Model = "Blazer" if Make=="Gmc" & strpos(Model,"Jimmy")>0;
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Blazer";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="K1500";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="K2500";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="K3500";
replace Model = "R1500" if Make=="Gmc" & Model=="R15 Conv";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="R1500";
replace Model = "R2500" if Make=="Gmc" & Model=="R25 Conv";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="R2500";
replace Model = "R3500" if Make=="Gmc" & Model=="R35 Conv";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="R3500";
replace Trim = "Astro" if Make=="Gmc" & Trim=="Safari";
replace Trim = "Astro Ext" if Make=="Gmc" & Trim=="Safari Xt";
replace Model = "Express Van" if Make=="Gmc" & Trim=="G2500 Savana Xt Cargo";
replace Model = "Astro Van" if Make=="Gmc" & Model=="Safari";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Astro Van";
replace Model = "Express Van" if Make=="Gmc" & Model=="Savana";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Express Van";
replace Model = "Silverado" if Make=="Gmc" & Model=="Sierra";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Silverado";
replace Model = "S10" if Make=="Gmc" & Model=="Sonoma";
replace Model = "S10" if Make=="Gmc" & Model=="Syclone";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="S10";
replace Model = "Blazer" if Make=="Gmc" & Model=="Typhoon";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="Blazer";
replace Trim = "V1500" if Make=="Gmc" & Model=="V15 Conv";
replace Model = "V1500" if Make=="Gmc" & Model=="V15 Conv";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="V1500";
replace Trim = "V2500" if Make=="Gmc" & Model=="V25 Conv";
replace Model = "V2500" if Make=="Gmc" & Model=="V25 Conv";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="V2500";
replace Trim = "V3500" if Make=="Gmc" & Model=="V35 Conv";
replace Model = "V3500" if Make=="Gmc" & Model=="V35 Conv";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="V3500";
replace Make = "Chevrolet" if Make=="Gmc" & Model=="G/P";

/* These either have no observations or only make vehicles that don't belong in our dataset (e.g. pure electric) */
drop if Make=="Aston Martin";
drop if Make=="Avanti";
drop if Make=="Bugatti";
drop if Make=="Daewoo";
drop if Make=="Daihatsu";
drop if Make=="Fiat";
drop if Make=="Freightliner";
drop if Make=="Gm";
drop if Make=="Gem";
drop if Make=="Hino";
drop if Make=="Iveco";
drop if Make=="John Deere";
drop if Make=="Laforza";
drop if Make=="Lamborghini";
drop if Make=="Lotus";
drop if Make=="Merkur";
drop if Make=="Oshkosh";
drop if Make=="Renault";
drop if Make=="Roadmaster Rail";
drop if Make=="Smart";
drop if Make=="Sterling";
drop if Make=="Tesla";
drop if Make=="Utilimaster";
drop if Make=="Winnebago";
drop if Make=="Workhorse";
drop if Make=="Yugo";

drop if Make=="Gmc" & (Model=="4000" | Model=="W3500");
drop if (Make=="Gmc" | Make=="Chevrolet") & (strpos(Model,"C5000")>0 | strpos(Model,"C6000")>0 | strpos(Model,"C6500")>0 | strpos(Model,"P20")>0 | strpos(Model,"P30")>0);
drop if Make=="Gmc" & Model=="Value Van";
drop if Make=="Isuzu" & Model=="Npr";
drop if Model=="Audi";

/* Group_Firm */
gen Firm = Make;
replace Firm = "Honda" if (Make=="Acura"|Make=="Honda");
* Alfa Romeo joined Fiat in 1986;
replace Firm = "Fiat" if (Make=="Alfa Romeo" & ModelYear>1986);
* Amc/Eagle bought out by Chrysler in March 1987.;
replace Firm = "Renault" if Make == "Amc/Eagle" & ModelYear <= 1987;
replace Firm = "Chrysler" if Make == "Amc/Eagle" & ModelYear > 1987;
* Ford bought Aston Martin in 1994. Ford then sold Aston Martin to an independent group in 2007 and retained only a small share.;
replace Firm = "Ford" if Make == "Aston Martin" & ModelYear>1994 & ModelYear<2007;
replace Firm = "Volkswagen" if Make == "Audi";
* Bentley was part of Rolls Royce, then Volkswagen bought Bentley in 1998.;
replace Firm = "Rolls-Royce" if Make == "Bentley";
replace Firm = "Volkswagen" if Make == "Bentley" & ModelYear>1998;
* Bertone is independent as of mid 2009.;
* Volkswagen bought Bugatti in 1998;
replace Firm = "Volkswagen" if Make == "Bugatti" & ModelYear>1998;
replace Firm = "Gm" if (Make=="Buick"|Make=="Cadillac"|Make=="Chevrolet"|Make=="Daewoo"|strpos(Make,"Gmc")!=0|Make=="Oldsmobile"|Make=="Pontiac"||Make=="Opel"|Make=="Saturn"|Make=="Vauxhall");
* Toyota bought 51% of Daihatsu in 1999;
replace Firm = "Toyota" if Make=="Daihatsu"&ModelYear>1999;
replace Firm = "Nissan" if Make=="Datsun";
replace Firm = "Daimler" if Make == "Dcx Sprinter";
replace Firm = "Chrysler" if Make == "Dodge";
replace Firm = "Fiat" if Make == "Ferrari";
replace Firm = "Daimler" if Make=="Freightliner";
replace Firm = "Chrysler" if Make=="Gem";
replace Firm = "Toyota" if Make=="Hino";
* AM General sold the brand name to GM in 1998.;
replace Firm = "Gm" if Make=="Hummer"&ModelYear>1998;
replace Firm = "Nissan" if Make=="Infiniti";
* Jaguar was part of BL (British Leland, of which Rover was a part) until it was floated separately in 1984. Then purchased by Ford and then by Tata.;
replace Firm = "Rover" if Make == "Jaguar" & ModelYear<=1984;
replace Firm = "Ford" if Make == "Jaguar" & ModelYear>1989;
replace Firm = "Tata" if Make == "Jaguar" & ModelYear>2008;
* Chrysler bought Jeep (and the rest of AMC, of which Jeep was a part) in 1987.;
replace Firm = "Renault" if Make == "Jeep" & ModelYear<=1987;
replace Firm = "Chrysler" if Make == "Jeep";
replace Firm = "Hyundai" if Make == "Kia";
replace Firm = "Chrysler" if Make == "Lamborghini" & ModelYear>1987 & ModelYear<=1993;
replace Firm = "Volkswagen" if Make=="Lamborghini" & ModelYear>1998;
* Land Rover was part of BL and then Rover group before/after 1986. Call all of this "Rover";
replace Firm = "Rover" if Make == "Land Rover" & ModelYear<=1994;
replace Firm = "Bmw" if Make == "Land Rover" & ModelYear>1994;
replace Firm = "Ford" if Make == "Land Rover" & ModelYear > 2000;
replace Firm = "Tata" if Make == "Land Rover" & ModelYear>2009;
replace Firm = "Toyota" if Make == "Lexus";
replace Firm = "Ford" if Make == "Lincoln";
* Bugatti sold Lotus to an independent investor in 1994.;
replace Firm = "Bugatti" if Make == "Lotus" & ModelYear<=1994;
replace Firm = "Fiat" if Make == "Maserati" & ModelYear>1993;
replace Firm = "Daimler" if Make == "Maybach" & ModelYear>=1997;
* Ford bought a controlling stake in Mazda in 1997.;
replace Firm = "Ford" if Make == "Mazda" & ModelYear>1997;
replace Firm = "Daimler" if Make=="Mercedes-Benz";
replace Firm = "Ford" if Make == "Mercury"|Make=="Merkur";
* All the Minis in the dataset are post-2000, next generation minis made by Bmw.;
replace Firm = "Bmw" if Make=="Mini";
*Chrysler held small stakes in Mitsubishi until 1991, but they were not controlling. Daimler was a controlling shareholder between 2000 and 2005.;
replace Firm = "Daimler" if Make=="Mitsubishi" & ModelYear>2000&ModelYear<=2005;
* Renault-Nissan alliance signed in March 1999;
replace Firm = "Renault" if Make == "Nissan" & ModelYear>1999;
* Peugeot is independent;
replace Firm = "Chrysler" if Make == "Plymouth";
* The Porsche family holding company owns a majority stake in Volkswagen;
replace Firm = "Volkswagen" if Make=="Porsche";
replace Firm = "Rover" if Make == "Sterling";
* GM owned Saab from 1989 to 2009;
replace Firm = "Gm" if Make=="Saab" & ModelYear>1989 & ModelYear<=2009;
* BMW bought Rolls-Royce (not Bentley) in 1998.;
replace Firm = "Bmw" if Make=="Rolls-Royce" & ModelYear>1998;
* Subaru has partnerships and partial ownership by other firms, but no controlling stakes seem to be owned by other firms.;
replace Firm = "Ford" if Make=="Th!nk";
replace Firm = "Ford" if Make=="Volvo" &ModelYear>1999;
* Yugo was based on Fiat models, but do not seem to be owned by Yugo.;
*** Daimler-Chrysler merger;
replace Firm = "Daimler" if Firm == "Chrysler" & ModelYear>1998 & ModelYear<=2007;

/* Continent, country, and luxury/perforance indicator */
gen Continent="";
replace Continent="Asia" if Make=="Acura";
replace Continent="Europe" if Make=="Alfa Romeo";
replace Continent="North America" if Make=="Amc/Eagle";
replace Continent="Europe" if Make=="Audi";
replace Continent="Europe" if Make=="Bentley";
replace Continent="Europe" if Make=="Bmw";
replace Continent="North America" if Make=="Buick";
replace Continent="North America" if Make=="Cadillac";
replace Continent="North America" if Make=="Chevrolet";
replace Continent="North America" if Make=="Chrysler";
replace Continent="Asia" if Make=="Datsun";
replace Continent="North America" if Make=="Dcx Sprinter";
replace Continent="North America" if Make=="Dodge";
replace Continent="Europe" if Make=="Ferrari";
replace Continent="North America" if Make=="Ford";
replace Continent="North America" if Make=="Geo";
replace Continent="North America" if Make=="Gmc";
replace Continent="Asia" if Make=="Honda";
replace Continent="North America" if Make=="Hummer";
replace Continent="Asia" if Make=="Hyundai";
replace Continent="Asia" if Make=="Infiniti";
replace Continent="Asia" if Make=="Isuzu";
replace Continent="Europe" if Make=="Jaguar";
replace Continent="North America" if Make=="Jeep";
replace Continent="Asia" if Make=="Kia";
replace Continent="Europe" if Make=="Lamborghini";
replace Continent="Europe" if Make=="Land Rover";
replace Continent="Asia" if Make=="Lexus";
replace Continent="North America" if Make=="Lincoln";
replace Continent="Europe" if Make=="Maserati";
replace Continent="Europe" if Make=="Maybach";
replace Continent="Asia" if Make=="Mazda";
replace Continent="Europe" if Make=="Mercedes-Benz";
replace Continent="North America" if Make=="Mercury";
replace Continent="Europe" if Make=="Mini";
replace Continent="Asia" if Make=="Mitsubishi";
replace Continent="Asia" if Make=="Nissan";
replace Continent="North America" if Make=="Oldsmobile";
replace Continent="Europe" if Make=="Peugeot";
replace Continent="North America" if Make=="Plymouth";
replace Continent="North America" if Make=="Pontiac";
replace Continent="Europe" if Make=="Porsche";
replace Continent="Europe" if Make=="Rolls-Royce";
replace Continent="Europe" if Make=="Saab";
replace Continent="North America" if Make=="Saturn";
replace Continent="Asia" if Make=="Subaru";
replace Continent="Asia" if Make=="Suzuki";
replace Continent="Asia" if Make=="Toyota";
replace Continent="Europe" if Make=="Tvr";
replace Continent="Europe" if Make=="Volkswagen";
replace Continent="Europe" if Make=="Volvo";

gen Country="";
replace Country="Japan" if Make=="Acura";
replace Country="Italy" if Make=="Alfa Romeo";
replace Country="USA" if Make=="Amc/Eagle";
replace Country="Germany" if Make=="Audi";
replace Country="United Kingdom" if Make=="Bentley";
replace Country="Germany" if Make=="Bmw";
replace Country="USA" if Make=="Buick";
replace Country="USA" if Make=="Cadillac";
replace Country="USA" if Make=="Chevrolet";
replace Country="USA" if Make=="Chrysler";
replace Country="Japan" if Make=="Datsun";
replace Country="USA" if Make=="Dcx Sprinter";
replace Country="USA" if Make=="Dodge";
replace Country="Italy" if Make=="Ferrari";
replace Country="USA" if Make=="Ford";
replace Country="USA" if Make=="Geo";
replace Country="USA" if Make=="Gmc";
replace Country="Japan" if Make=="Honda";
replace Country="USA" if Make=="Hummer";
replace Country="South Korea" if Make=="Hyundai";
replace Country="Japan" if Make=="Infiniti";
replace Country="Japan" if Make=="Isuzu";
replace Country="UK" if Make=="Jaguar";
replace Country="USA" if Make=="Jeep";
replace Country="South Korea" if Make=="Kia";
replace Country="Italy" if Make=="Lamborghini";
replace Country="UK" if Make=="Land Rover";
replace Country="Japan" if Make=="Lexus";
replace Country="USA" if Make=="Lincoln";
replace Country="Italy" if Make=="Maserati";
replace Country="Germany" if Make=="Maybach";
replace Country="Japan" if Make=="Mazda";
replace Country="Germany" if Make=="Mercedes-Benz";
replace Country="USA" if Make=="Mercury";
replace Country="United Kingdom" if Make=="Mini";
replace Country="Japan" if Make=="Mitsubishi";
replace Country="Japan" if Make=="Nissan";
replace Country="USA" if Make=="Oldsmobile";
replace Country="France" if Make=="Peugeot";
replace Country="USA" if Make=="Plymouth";
replace Country="USA" if Make=="Pontiac";
replace Country="Germany" if Make=="Porsche";
replace Country="UK" if Make=="Rolls-Royce";
replace Country="Sweden" if Make=="Saab";
replace Country="USA" if Make=="Saturn";
replace Country="Japan" if Make=="Subaru";
replace Country="Japan" if Make=="Suzuki";
replace Country="Japan" if Make=="Toyota";
replace Country="UK" if Make=="Tvr";
replace Country="Germany" if Make=="Volkswagen";
replace Country="Sweden" if Make=="Volvo";

* Subjective....;
gen LuxPerf=0;
replace LuxPerf=1 if Make=="Acura";
replace LuxPerf=1 if Make=="Alfa Romeo";
replace LuxPerf=1 if Make=="Amc/Eagle";
replace LuxPerf=1 if Make=="Audi";
replace LuxPerf=1 if Make=="Bentley";
replace LuxPerf=1 if Make=="Bmw";
replace LuxPerf=1 if Make=="Buick";
replace LuxPerf=1 if Make=="Cadillac";
replace LuxPerf=1 if Make=="Dcx Sprinter";
replace LuxPerf=1 if Make=="Ferrari";
replace LuxPerf=1 if Make=="Hummer";
replace LuxPerf=1 if Make=="Infiniti";
replace LuxPerf=1 if Make=="Jaguar";
replace LuxPerf=1 if Make=="Jeep";
replace LuxPerf=1 if Make=="Lamborghini";
replace LuxPerf=1 if Make=="Land Rover";
replace LuxPerf=1 if Make=="Lexus";
replace LuxPerf=1 if Make=="Lincoln";
replace LuxPerf=1 if Make=="Maserati";
replace LuxPerf=1 if Make=="Maybach";
replace LuxPerf=1 if Make=="Mercedes-Benz";
replace LuxPerf=1 if Make=="Mercury";
replace LuxPerf=1 if Make=="Mini";
replace LuxPerf=1 if Make=="Pontiac";
replace LuxPerf=1 if Make=="Porsche";
replace LuxPerf=1 if Make=="Rolls-Royce";
replace LuxPerf=1 if Make=="Saab";
replace LuxPerf=1 if Make=="Tvr";
replace LuxPerf=1 if Make=="Volvo";


/* There are a small number of duplicate MatchVins. */
/* This vehicle is apparently sold as both the Mitsubishi Precis and the Hyundai Excel.  I somewhat arbitrarily choose
   to keep only the Mitsubishi records (although one of the Hyundai VIN records has "unknown" series, which does not
   match to the NVPP). */
drop if (MatchVin=="KMHLA32J*JA******" | MatchVin=="KMHLD11J*JA******" | MatchVin=="KMHLD31J*JA******") & Make=="Hyundai";

duplicates tag MatchVin, gen(dup);
list MatchVin if dup;
assert dup==0;
drop dup;

gen MatchPattern = "";
forvalues i=1/17 {;
    replace MatchPattern = MatchPattern+"*" if substr(MatchVin,`i',1)=="*";
    local digit = mod(`i',10);
    replace MatchPattern = MatchPattern+"`digit'" if substr(MatchVin,`i',1)~="*";
};
/* This is useful for determining how to match VINS to auction data in manheim/AuctionPrices.do */
tab MatchPattern;

gen PatternNum = 0 if MatchPattern == "12345678*0*******";
replace PatternNum = 1 if MatchPattern == "12345678*01******";
replace PatternNum = 2 if MatchPattern == "12345678*012*****";
replace PatternNum = 3 if MatchPattern == "12345678*0123****";
replace PatternNum = 4 if MatchPattern == "12345678*01234***";
replace PatternNum = 5 if MatchPattern == "12345678*012345**";
replace PatternNum = 6 if MatchPattern == "12345678*0123456*";
replace PatternNum = 7 if MatchPattern == "12345678*01234567";
replace PatternNum = 8 if MatchPattern == "12345678*0**3****";
replace PatternNum = 9 if MatchPattern == "12345678*0*234***";
tab PatternNum, m;

gen MatchVin810 = substr(MatchVin,1,10)+"*******";

sort MatchVin810 PatternNum;
by MatchVin810: gen MinPatNum810 = PatternNum[1];
by MatchVin810: gen MaxPatNum810 = PatternNum[_N];
by MatchVin810: gen NumPats810 = _N;
by MatchVin810: gen FirstRec810 = (_n==1);

tab MinPatNum810 if FirstRec810;
tab MaxPatNum810 if FirstRec810;
tab MinPatNum810 MaxPatNum810 if FirstRec810 & MinPatNum810~=MaxPatNum810;
tab NumPats810 if FirstRec810;

drop FirstRec810 MinPatNum810 MaxPatNum810 NumPats810;

/* We want a single match per 8*10 VIN.  Even if we can use the full VIN (Manheim) or
   squished VIN (JD Power) to "disaggregate" further, they will not match the datasets
   (e.g. Polk NVPP) that contain only the 8*10 VIN.  We prefer the lowest pattern number
   (e.g. the simplest pattern) and use the alphabetical order of the VINs as a tiebreaker. */
sort MatchVin810 PatternNum MatchVin;
by MatchVin810: keep if _n==1;
tab MatchPattern;
drop PatternNum MatchPattern MatchVin;

/* Fix the trims in order to make CarIDs consistent across model years */;
include FixPrefixTrims.do;


**  Generate Body Styles to distinguish CarIDs;
gen BodyStyleAgg = "Other";
replace BodyStyleAgg = "Sedan" if BodyStyle == "SEDAN"|BodyStyle=="SEDAN 4 DOOR";

replace BodyStyleAgg = "Station Wagon" if BodyStyle=="STATION WAGON";
	* Note that Wide Wheel Wagon is just one vehicle, the Jeep Cherokee;
* The Aveo 5 and the Aveo are separately rated by EPA:;
replace BodyStyleAgg = "Sedan 5 Door" if BodyStyle=="SEDAN 5 DOOR"&Model=="Aveo";
	* Chevrolet distinguishes some pickups from suburbans even within our CarIDs. Note that for other companies, changes in BodyStyle from "Pickup" to "Crew Cab Pickup" or something similar often only happen for one model year, suggesting that they are simply classification differences. So make this distinction for Chevrolet and Gmc only.;
	replace BodyStyleAgg = "Pickup" if BodyStyle=="PICKUP"&(Make=="Chevrolet"|Make=="Gmc");


** Separate CarIDs if liters more than 0.2 different:;
egen long CarIDNoLiters = group(Make Model Trim Cylinder BodyStyleAgg), missing;
sort CarIDNoLiters Liters;
gen NewLiters = 0;
replace NewLiters = 1 if CarIDNoLiters==CarIDNoLiters[_n-1]&Liters>Liters[_n-1]+0.2;
replace NewLiters = NewLiters+NewLiters[_n-1] if CarIDNoLiters==CarIDNoLiters[_n-1];

egen long CarID = group(CarIDNoLiters NewLiters);

** Other old ways of constructing CarID:;
* egen long CarID = group(Make Model Trim Cylinder), missing;
* egen long CarID = group(Make Model), missing;
* egen long CarID = group(MatchVin810);


/* Separate CarIDs of different generations */
sort Make Model;
merge Make Model using Generations.dta, nokeep;
drop _merge;

** Some fixes;

* Buick Lesabre Estate wagon was not redesigned until 1989;
replace Gen1=1989 if Model=="Lesabre" & strpos(Trim,"Estate Wagon")!=0;
* Chevy C-Series and K-Series was updated only after 1991 for 4-door cabs;
replace Gen1=1992 if (Model=="C10"|Model=="C1500"|Model=="C20"|Model=="C2500"|Model=="C30"|Model=="C3500" | Model=="K10"|Model=="K1500"|Model=="K20"|Model=="K2500"|Model=="K30"|Model=="K3500")&BodyStyle=="WAGON 4 DOOR";

*Chrysler Lebaron depends on the body style;
replace Gen1 = 1985 if Model=="Lebaron"&strpos(Trim,"Gts")!=0;
replace Gen2 = 1990 if Model=="Lebaron"&strpos(Trim,"Gts")!=0;
replace Gen1=  1987 if Model=="Lebaron"&(strpos(BodyStyle,"COUPE")!=0|strpos(BodyStyle,"CONVERTIBLE")!=0);
replace Gen1=  1990 if Model=="Lebaron"&strpos(BodyStyle,"SEDAN")!=0;

* Dodge Ram 3rd generation debuted in 2003 for 2500 and 3500 models;
replace Gen1 = 2003 if Model =="Ram Truck"&(strpos(Trim,"2500")!=0|strpos(Trim,"3500")!=0);

* Prefix 810 already captures the Mazda Protege redesign;
replace Gen1 = . if Make=="Mazda"&Model =="Protege";


rename CarID CarIDNoGen;
gen NewGen = 0;
sort CarIDNoGen ModelYear;
forvalues g=1/8 {;
	*replace NewGen = 1 if ModelYear==Gen`g';
	* Denote an observation as NewGen = 1 if it is the first observation of model year >= the generation change.;
	replace NewGen = 1 if ModelYear>=Gen`g' & ModelYear[_n-1]<Gen`g' & CarIDNoGen==CarIDNoGen[_n-1];
};


gen Gen = 1;
sort CarIDNoGen ModelYear;
replace Gen = cond(CarIDNoGen==CarIDNoGen[_n-1] & NewGen==1 & ModelYear!=ModelYear[_n-1], Gen[_n-1] + 1, Gen[_n-1]) if _n>1 & CarIDNoGen==CarIDNoGen[_n-1];

egen long CarID = group(CarIDNoGen Gen);

*

drop if CarID==.;


/* Diagnostic: do these names change over time in a way that we are splitting what should be the same
   j into multiple CarID values? */
sort CarID ModelYear;
by CarID: egen StartMY  = min(ModelYear);
by CarID: egen EndMY  = max(ModelYear);
by CarID: gen FirstRec=(_n==1);
list Trim Cylinder FuelType StartMY EndMY if Make=="Chevrolet" & FirstRec;
list Trim Cylinder FuelType StartMY EndMY if Make=="Ford" & FirstRec;
list Trim Cylinder FuelType StartMY EndMY if Make=="Toyota" & FirstRec;
drop FirstRec;

sort MatchVin810;
save Prefix810, replace;

/*
*******************
** Outsheet a csv file to serve as the base for the Generations file.;
collapse (min)  StartMY (max) EndMY, by(Make Model);
outsheet using GenerationsBase.csv, comma names replace;
use Prefix810,clear;
**********************;
*/

/* We must make sure that a CarID and ModelYear uniquely identifies a naming sequence.  We therefore
   must drop duplicates.  Note that we are not selective about which name to keep - this does not affect
   our analysis. */
sort CarID ModelYear MatchVin810;
by CarID ModelYear: keep if _n==1;

drop MatchVin810;
sort CarID ModelYear;

save IDToNames, replace;

set more on;

log close;
