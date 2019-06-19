/* EPASubmodels.do */
gen Submodel = ""


** Alfa Romeo
replace Submodel = "Veloce" if Model == "Alfa Romeo Spider" & strpos(OModel,"Veloce")!=0

** Amc/Eagle
replace Submodel = "Convertible" if (Model=="Renault Alliance"|Model=="Renault Alliance/Encore") & strpos(OModel,"Convertible")!=0
replace Submodel = "Wagon" if (Model=="Amc Eagle"|Model=="Eagle Medallion"|Model=="Renault Medallion"|Model=="Eagle Summit") & strpos(OModel,"Wagon")!=0

** Audi
* First add Quatro and Wagon. Other model-specific replacements later. So anything with the name "Quattro" in it automatically has the submodel "Quattro"
replace Submodel = "Quattro" if Make=="Audi" & strpos(OModel,"Quattro")!=0
replace Submodel = "Wagon" if Make=="Audi" & strpos(OModel,"Wagon")!=0
replace Submodel = "Quattro Wagon" if Make == "Audi" & strpos(OModel,"Quattro")!=0 & strpos(OModel,"Wagon")!=0

replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"200 ")==1|OModel=="200")

replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"4000")==1)
replace Submodel = "4000 S" if Make=="Audi"&OModel=="4000S"

replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"5000")==1)
replace Submodel = "5000 S" if Make=="Audi"&OModel=="5000S"

replace Submodel = "90 Quattro 20V" if OModel == "90 Quattro 20V"
replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"A4")==1)
replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"A6")==1)
replace Submodel = "A6 Quattro Wagon" if Make=="Audi" & OModel=="A6 Wagon Quattro"
replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"A8")==1)
replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"S4")==1)
replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"S6")==1)
replace Submodel = OModel if Make == "Audi" & (strpos(OModel,"Tt")==1)

** Bentley
replace Submodel = "RL" if Model == "Bentley Arnage" & strpos(OModel,"Rl")!=0
replace Submodel = "R" if Model == "Bentley Continental" & OModel=="Continental R"
replace Submodel = "SC" if Model == "Bentley Continental" & OModel=="Continental Sc"
replace Submodel = "T" if Model == "Bentley Continental" & OModel=="Continental T"
replace Submodel = "GT" if Model == "Bentley Continental" & OModel=="Continental Gt"
replace Submodel = "GTC" if Model == "Bentley Continental" & OModel=="Continental Gtc"

** BMW
* All BMWs now have a submodel, including very basic ones like "BMW 5-Series"
replace Submodel = OModel if Make == "Bmw"

** Buick
replace Submodel = "Wagon" if (Model=="Buick Century"|Model=="Buick Roadmaster"|Model=="Buick Skyhawk")  & strpos(OModel,"Wagon")!=0
replace Submodel = "Convertible" if Model=="Buick Riviera"& strpos(OModel,"Convertible")!=0

** Cadillac
replace Submodel = "V" if Model=="Cadillac Cts"& strpos(OModel,"Cts-V")!=0
replace Submodel = "Wagon" if Model=="Cadillac Cts"& strpos(OModel,"Wagon")!=0
replace Submodel = "Convertible" if Model=="Cadillac Eldorado"& strpos(OModel,"Convertible")!=0
replace Submodel = "Hybrid" if Model=="Cadillac Escalade"&strpos(OModel,"Hybrid")!=0
replace Submodel = "Esv" if Model=="Cadillac Escalade"&strpos(OModel,"Esv")!=0
replace Submodel = "Ext" if Model=="Cadillac Escalade"&strpos(OModel,"Ext")!=0
replace Submodel = "V" if Model=="Cadillac Sts"& strpos(OModel,"Sts-V")!=0
replace Submodel = "V" if Model=="Cadillac Xlr"& strpos(OModel,"Xlr-V")!=0

** Chevrolet
* First Deal with Suburbans
replace Submodel = "K10" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"K10")!=0
replace Submodel = "V10" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"V10")!=0
replace Submodel = "C10" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"C10")!=0
replace Submodel = "R10" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"R10")!=0
replace Submodel = "S10" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"S10")!=0
replace Submodel = "C15" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"C15")!=0
replace Submodel = "K15" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"K15")!=0
replace Submodel = "R15" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"R15")!=0
replace Submodel = "V15" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"V15")!=0
replace Submodel = "1500" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"1500")!=0
replace Submodel = "R1500" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"R1500")!=0
replace Submodel = "V1500" if Model=="Chevrolet/Gmc Suburban" & strpos(OModel,"V1500")!=0

replace Submodel = "C10" if Model == "Chevrolet/Gmc C Series" & strpos(OModel,"C10")!=0
replace Submodel = "C1500" if Model == "Chevrolet/Gmc C Series" & strpos(OModel,"C1500")!=0
replace Submodel = "C1500 Suburban" if Model == "Chevrolet/Gmc C Series" & strpos(OModel,"C1500")!=0 & strpos(OModel,"Suburban")!=0
replace Submodel = "C20" if Model == "Chevrolet/Gmc C Series" & strpos(OModel,"C20")!=0
replace Submodel = "C2500" if Model == "Chevrolet/Gmc C Series" & strpos(OModel,"C2500")!=0

replace Submodel = "5" if Model=="Chevrolet Aveo" & OModel=="Aveo 5"

replace Submodel = "Wagon" if (Model=="Chevrolet Impala/Caprice"|Model=="Chevrolet Cavalier"|Model=="Chevrolet Celebrity") & strpos(OModel,"Wagon")!=0
replace Submodel = "Police" if Model=="Chevrolet Impala/Caprice"&strpos(OModel,"Police")!=0
replace Submodel = "Convertible" if (Model=="Chevrolet Cavalier") & strpos(OModel,"Convertible")!=0

replace Submodel = "Crew Cab" if (Model=="Chevrolet Colorado") & strpos(OModel,"Crew Cab")!=0
replace Submodel = "Chassis Cab" if (Model=="Chevrolet Colorado") & strpos(OModel,"Cab Chassis")!=0

replace Submodel = "Convertible" if (Model=="Chevrolet Corvette") & strpos(OModel,"Convertible")!=0

replace Submodel = "1500 Awd" if Model=="Chevrolet Express" & strpos(OModel,"1500 Awd")!=0
replace Submodel = "2500" if Model=="Chevrolet Express" & strpos(OModel,"2500")!=0
replace Submodel = "3500" if Model=="Chevrolet Express" & strpos(OModel,"3500")!=0

replace Submodel = "1500/2500" if Model=="Chevrolet Express" & strpos(OModel,"1500/2500")!=0


* G-Series vans
replace Submodel = "G10/20" if strpos(OModel,"G10/20")!=0
replace Submodel = "G10/20 Sport Van" if strpos(OModel,"Sport Van")!=0 & Submodel=="G10/20"

replace Submodel = "G30" if strpos(OModel,"G30")!=0
replace Submodel = "G30 Sport Van" if strpos(OModel,"Sport Van")!=0 & Submodel=="G30"

replace Submodel = "Panel" if Model=="Chevrolet Hhr" & strpos(OModel,"Panel")!=0


replace Submodel = "K1500" if Model=="Chevrolet/Gmc K Series" & strpos(OModel,"1500")!=0

replace Submodel = "Avalanche 1500 Awd" if OModel == "Avalanche 1500 4Wd"|OModel=="Avalanche 1500 Awd"



replace Submodel = "1500" if Model=="Chevrolet Silverado" & strpos(OModel,"1500")!=0
replace Submodel = "2500" if Model == "Chevrolet Silverado" & strpos(OModel,"2500")!=0
replace Submodel = "Hybrid" if Model == "Chevrolet Silverado" & strpos(OModel,"Hybrid")!=0
replace Submodel = "2500 Hd" if Model == "Chevrolet Silverado" & strpos(OModel,"2500 Hd")!=0

* K Series
replace Submodel = "K10" if Model=="Chevrolet/Gmc K Series" & strpos(OModel,"10")!=0
replace Submodel = "K15" if Model=="Chevrolet/Gmc K Series" & strpos(OModel,"K15")!=0
replace Submodel = "K25" if Model=="Chevrolet/Gmc K Series" & strpos(OModel,"K25")!=0
replace Submodel = "K20" if Model=="Chevrolet/Gmc K Series" & strpos(OModel,"20")!=0
replace Submodel = "K2500" if Model=="Chevrolet/Gmc K Series" & strpos(OModel,"2500")!=0

replace Submodel = "K1500 Pickup" if OModel =="K1500 Pickup 4Wd"
replace Submodel = "K2500 Pickup" if OModel =="K2500 Pickup 4Wd"

replace Submodel = "2500" if Model=="Chevrolet/Gmc Pickup" & strpos(OModel,"2500")!=0

replace Submodel = "Hybrid" if Model=="Chevrolet Malibu" & strpos(OModel,"Hybrid")!=0
replace Submodel = "Maxx" if Model=="Chevrolet Malibu" & strpos(OModel,"Maxx")!=0

replace Submodel = "Lsi" if Model=="Geo Metro"&strpos(OModel,"Lsi")!=0
replace Submodel = "Lsi Convertible" if Model=="Geo Metro"&strpos(OModel,"Lsi Convertible")!=0
replace Submodel = "Xfi" if Model=="Geo Metro"&strpos(OModel,"Xfi")!=0

replace Submodel = "Monte Carlo" if Model=="Chevrolet Lumina/Monte Carlo" & OModel == "Monte Carlo" & ModelYear==2001

replace Submodel = "R10" if Model=="Chevrolet/Gmc R Series" & strpos(OModel,"10")!=0
replace Submodel = "R15" if Model=="Chevrolet/Gmc R Series" & strpos(OModel,"15")!=0
replace Submodel = "R20" if Model=="Chevrolet/Gmc R Series" & strpos(OModel,"20")!=0
replace Submodel = "R25" if Model=="Chevrolet/Gmc R Series" & strpos(OModel,"25")!=0

replace Submodel = "Chassis Cab" if (Model=="Chevrolet S10/T10") & strpos(OModel,"Cab Chassis")!=0
replace Submodel = "Utility Body" if (Model=="Chevrolet S10/T10") & strpos(OModel,"Utility Body")!=0



replace Submodel = "Er" if Model=="Chevrolet Sprint" & strpos(OModel,"Er")!=0
replace Submodel = "Plus" if Model=="Chevrolet Sprint" & strpos(OModel,"Plus")!=0

replace Submodel = "Hybrid" if Model=="Chevrolet Tahoe" & strpos(OModel,"Hybrid")!=0

replace Submodel = "Lt" if Model=="Chevrolet Tracker" & strpos(OModel,"Lt")!=0
replace Submodel = "Zr2" if Model=="Chevrolet Tracker" & strpos(OModel,"Zr2")!=0

replace Submodel = "Ext" if Model=="Chevrolet Trailblazer" & strpos(OModel,"Ext")!=0

replace Submodel = "V10 Pickup" if Model=="Chevrolet/Gmc V Series" & (strpos(OModel,"V10 Pickup")!=0|strpos(OModel,"V10 (K10) Pickup")!=0)


replace Submodel = "V20 Pickup" if Model=="Chevrolet/Gmc V Series" & strpos(OModel,"V20 Pickup")!=0

* Chevy Blazer
replace Submodel = "S10" if Model=="Chevrolet Blazer" & strpos(OModel,"S10")!=0
replace Submodel = "K10/V10" if Model=="Chevrolet Blazer" & (strpos(OModel,"V10")!=0|strpos(OModel,"K10")!=0)

*** Chrysler
replace Submodel = "M" if Model=="Chrysler 300" & strpos(OModel,"M")!=0
replace Submodel = "C" if Model=="Chrysler 300" & strpos(OModel,"C")!=0
replace Submodel = "Srt-8" if Model=="Chrysler 300" & strpos(OModel,"Srt-8")!=0
replace Submodel = "C/Srt-8" if Model=="Chrysler 300" & strpos(OModel,"C/Srt-8")!=0

replace Submodel = "Hybrid" if Model=="Chrysler Aspen" & strpos(OModel,"Hev")!=0

replace Submodel = "Coupe" if Model =="Chrysler Crossfire" & strpos(OModel,"Coupe")!=0
replace Submodel = "Convertible" if Model =="Chrysler Crossfire" & strpos(OModel,"Roadster")!=0

replace Submodel = "Convertible" if Model =="Chrysler Lebaron" & strpos(OModel,"Convertible")!=0
replace Submodel = "Gts" if Model =="Chrysler Lebaron" & strpos(OModel,"Gts")!=0
replace Submodel = "Landau" if Model =="Chrysler Lebaron" & strpos(OModel,"Landau")!=0

replace Submodel = "Turbo" if Model =="Chrysler New Yorker" & strpos(OModel,"Turbo")!=0
replace Submodel = "4 Door" if Model =="Chrysler Sebring" & strpos(OModel,"4 Door")!=0

replace Submodel = "Convertible" if Model =="Chrysler Pt Cruiser" & strpos(OModel,"Convertible")!=0
replace Submodel = "Convertible" if Model =="Chrysler Sebring" & strpos(OModel,"Convertible")!=0

*** Daewoo
replace Submodel = "Wagon" if Model=="Daewoo Nubira" & strpos(OModel,"Wagon")!=0

*** Dodge
replace Submodel = "Convertible" if Model =="Dodge 600" & strpos(OModel,"Convertible")!=0
replace Submodel = "Wagon" if Model =="Dodge Aries" & strpos(OModel,"Wagon")!=0
replace Submodel = "150/250" if Model =="Dodge Ram Van" & (strpos(OModel,"150")!=0|strpos(OModel,"250")!=0)
replace Submodel = "1500/2500" if Model =="Dodge Ram Van" & (strpos(OModel,"1500")!=0|strpos(OModel,"2500")!=0)

replace Submodel = "1500" if Model =="Dodge Ram Van" & (strpos(OModel,"1500")!=0&strpos(OModel,"2500")==0)
replace Submodel = "2500" if Model =="Dodge Ram Van" & (strpos(OModel,"1500")==0&strpos(OModel,"2500")!=0)

replace Submodel = "350" if Model =="Dodge Ram Van" & strpos(OModel,"350")!=0
replace Submodel = "3500" if Model =="Dodge Ram Van" & strpos(OModel,"3500")!=0

replace Submodel = "Wagon" if Model =="Dodge/Plymouth Colt" & strpos(OModel,"Wagon")!=0

* Dodge D Series
replace Submodel = "150" if Model=="Dodge D Series" & strpos(OModel,"D100/D150")!=0
replace Submodel = "250" if Model=="Dodge D Series" & strpos(OModel,"D250")!=0
replace Submodel = "250 Cab Chassis" if Model=="Dodge D Series" & strpos(OModel,"Cab Chassis")!=0

replace Submodel = "Cab Chassis" if Model=="Dodge Dakota" & strpos(OModel,"Cab Chassis")!=0

replace Submodel = "Hybrid" if Model=="Dodge Durango" & strpos(OModel,"Hev")!=0

replace Submodel = "1500" if Model =="Dodge Ram 1500/2500/3500" & strpos(OModel,"1500")!=0
replace Submodel = "2500" if Model =="Dodge Ram 1500/2500/3500" & strpos(OModel,"2500")!=0

replace Submodel = "Convertible" if Model =="Dodge Shadow" & strpos(OModel,"Convertible")!=0
replace Submodel = "4 Door" if Model =="Dodge Stratus" & strpos(OModel,"4 Door")!=0

replace Submodel = "150" if Model =="Dodge W Series" & strpos(OModel,"150")!=0
replace Submodel = "250" if Model =="Dodge W Series" & strpos(OModel,"250")!=0

replace Submodel = "Convertible" if Model =="Dodge Viper" & strpos(OModel,"Convertible")!=0
replace Submodel = "Coupe" if Model =="Dodge Viper" & strpos(OModel,"Coupe")!=0

*** Ford
replace Submodel = "Police" if Model =="Ford Crown Victoria" & strpos(OModel,"Police")!=0

replace Submodel = "150" if Model =="Ford E Series" & strpos(OModel,"150")!=0
replace Submodel = "250" if Model =="Ford E Series" & strpos(OModel,"250")!=0

replace Submodel = "Hybrid" if Model =="Ford Escape" & strpos(OModel,"Hybrid")!=0

replace Submodel = "Wagon" if Model =="Ford Escort" & strpos(OModel,"Wagon")!=0
replace Submodel = "Zx2" if Model =="Ford Escort" & strpos(OModel,"Zx2")!=0

replace Submodel = "Sport" if Model =="Ford Explorer" & strpos(OModel,"Sport")!=0
replace Submodel = "Sport Trac" if Model =="Ford Explorer" & strpos(OModel,"Sport Trac")!=0

replace Submodel = "150" if Model =="Ford F Series" & strpos(OModel,"150")!=0
replace Submodel = "250" if Model =="Ford F Series" & strpos(OModel,"250")!=0

replace Submodel = "Wagon" if Model =="Ford Focus" & strpos(OModel,"Wagon")!=0

replace Submodel = "Hybrid" if Model =="Ford Fusion" & strpos(OModel,"Hybrid")!=0

replace Submodel = "Wagon" if Model =="Ford Ltd" & strpos(OModel,"Wagon")!=0

replace Submodel = "Convertible" if Model =="Ford Mustang" & strpos(OModel,"Convertible")!=0

replace Submodel = "Cab Chassis" if Model =="Ford Ranger" & strpos(OModel,"Cab Chassis")!=0

replace Submodel = "Sho" if Model =="Ford Taurus" & strpos(OModel,"Sho")!=0
replace Submodel = "Wagon" if Model =="Ford Taurus" & strpos(OModel,"Wagon")!=0
replace Submodel = "X" if Model =="Ford Taurus" & strpos(OModel,"X")!=0


*** Gmc 
replace Submodel = "Cab Chassis" if Model =="Gmc Canyon" & strpos(OModel,"Cab Chassis")!=0
replace Submodel = "Crew Cab" if Model =="Gmc Canyon" & strpos(OModel,"Crew Cab")!=0

replace Submodel = "Hybrid" if Model =="Gmc Sierra" & strpos(OModel,"Hybrid")!=0

replace Submodel = "1500" if Model =="Gmc Sierra" & strpos(OModel,"1500")!=0
replace Submodel = "1500" if Model =="Gmc Sierra" & strpos(OModel,"1500")!=0
replace Submodel = "2500" if Model =="Gmc Sierra" & strpos(OModel,"2500")!=0
replace Submodel = "2500 Hd" if Model =="Gmc Sierra" & strpos(OModel,"2500 Hd")!=0
replace Submodel = "Denali 1500" if Model =="Gmc Sierra" & strpos(OModel,"Denali 1500")!=0

* GMC Savana- the only ambiguity within a model year is really Passenger vs. Cargo.
replace Submodel = "Passenger" if Model =="Gmc Savana" & strpos(OModel,"Pass")!=0
replace Submodel = "Cargo" if Model =="Gmc Savana" & strpos(OModel,"Cargo")!=0
*replace Submodel = "2500 Passenger" if Model =="Gmc Savana" & (strpos(OModel,"2500")!=0) & strpos(OModel,"Pass")!=0
*replace Submodel = "2500 Cargo" if Model =="Gmc Savana" & strpos(OModel,"2500")!=0 & strpos(OModel,"Cargo")!=0


* Yukon
replace Submodel = "Denali" if Model =="Gmc Yukon" & strpos(OModel,"Denali")!=0

replace Submodel = "2500" if Model =="Gmc Yukon Xl" & strpos(OModel,"2500")!=0
replace Submodel = "Denali" if Model =="Gmc Yukon Xl" & strpos(OModel,"Denali")!=0


replace Submodel = "Xl" if Model =="Gmc Envoy" & strpos(OModel,"Xl")!=0
replace Submodel = "Xuv" if Model =="Gmc Envoy" & strpos(OModel,"Xuv")!=0

replace Submodel = "15/25" if Model =="Gmc Rally" & strpos(OModel,"15")!=0
replace Submodel = "35" if Model =="Gmc Rally" & strpos(OModel,"35")!=0

replace Submodel = "15/25" if Model =="Gmc Vandura" & strpos(OModel,"15")!=0
replace Submodel = "35" if Model =="Gmc Vandura" & strpos(OModel,"35")!=0

replace Submodel = "S15" if Model=="Gmc S15/T15" & strpos(OModel,"S15")!=0
replace Submodel = "S15 Cab Chassis" if Model=="Gmc S15/T15" & strpos(OModel,"S15 Cab Chassis")!=0

replace Submodel = "K15" if Model=="Gmc Jimmy" & strpos(OModel,"K15")!=0
replace Submodel = "S15" if Model=="Gmc Jimmy" & strpos(OModel,"S15")!=0
replace Submodel = "V15" if Model=="Gmc Jimmy" & strpos(OModel,"V15")!=0


replace Submodel = "15" if Model=="Chevrolet/Gmc V Series" & strpos(OModel,"15")!=0
replace Submodel = "25" if Model=="Chevrolet/Gmc V Series" & strpos(OModel,"25")!=0

replace Submodel = "Hybrid" if Model=="Gmc Yukon"&strpos(OModel,"Hybrid")!=0




*** Honda
replace Submodel = "Wagon" if Model=="Honda Accord"&strpos(OModel,"Wagon")!=0
replace Submodel = "Hybrid" if Model=="Honda Accord"&strpos(OModel,"Hybrid")!=0
replace Submodel = "Coupe" if Model=="Honda Accord"&strpos(OModel,"Coupe")!=0

replace Submodel = "Coupe" if Model=="Honda Civic"&strpos(OModel,"Coupe")!=0
replace Submodel = "Hybrid" if Model=="Honda Civic"&strpos(OModel,"Hybrid")!=0
replace Submodel = "Wagon" if Model=="Honda Civic"&strpos(OModel,"Wagon")!=0
replace Submodel = "Crx" if Model=="Honda Civic"&strpos(OModel,"Crx")!=0
replace Submodel = "Crx Hf" if Model=="Honda Civic"&strpos(OModel,"Crx Hf")!=0
replace Submodel = "Del Sol" if Model=="Honda Civic"&strpos(OModel,"Del Sol")!=0
replace Submodel = "Gx" if Model=="Honda Civic"&strpos(OModel,"Gx")!=0
replace Submodel = "Hx" if Model=="Honda Civic"&strpos(OModel,"Hx")!=0
replace Submodel = "Hb Vx" if Model=="Honda Civic"&strpos(OModel,"Hb Vx")!=0


*** Hyundai
replace Submodel = "Wagon" if Model=="Hyundai Elantra"&strpos(OModel,"Wagon")!=0



*** Infiniti
replace Submodel = "Coupe" if Model=="Infiniti G35"&strpos(OModel,"Coupe")!=0


*** Isuzu
replace Submodel = "Extended" if Model=="Isuzu I-370"&strpos(OModel,"Extended")!=0
replace Submodel = "1-Ton" if Model=="Isuzu Pickup"&strpos(OModel,"1-Ton")!=0
replace Submodel = "Sport" if Model=="Isuzu Rodeo"&strpos(OModel,"Rodeo")!=0

*** Jaguar
replace Submodel = "R" if Model=="Jaguar S-Type"&strpos(OModel,"S-Type R")!=0
replace Submodel = "Supercharged" if Model=="Jaguar Xf"&strpos(OModel,"Supercharged")!=0
replace Submodel = "Sport" if Model=="Jaguar X-Type"&strpos(OModel,"Sport")!=0
replace Submodel = "Sport" if Model=="Jaguar Xj"&strpos(OModel,"Sport")!=0
replace Submodel = "6L" if Model=="Jaguar Xj"&strpos(OModel,"Xj6L")!=0
replace Submodel = "8L" if Model=="Jaguar Xj"&strpos(OModel,"Xj8L")!=0
replace Submodel = "Convertible" if Model=="Jaguar Xjrs"&strpos(OModel,"Convertible")!=0
replace Submodel = "Coupe" if Model=="Jaguar Xjrs"&strpos(OModel,"Coupe")!=0

replace Submodel = "Convertible" if Model=="Jaguar Xjs"&strpos(OModel,"Convertible")!=0

replace Submodel = "Convertible" if Model=="Jaguar Xk"&strpos(OModel,"Convertible")!=0
replace Submodel = "Convertible" if Model=="Jaguar Xk8"&strpos(OModel,"Convertible")!=0
replace Submodel = "Convertible" if Model=="Jaguar Xkr"&strpos(OModel,"Convertible")!=0


*** Lincoln
replace Submodel = "Lt" if Model=="Lincoln Mark Series"&strpos(OModel,"Lt")!=0

*** Maybach
replace Submodel = "S" if Model=="Maybach 57"&strpos(OModel,"57S")!=0
replace Submodel = "S" if Model=="Maybach 62"&strpos(OModel,"62S")!=0


*** Mazda
replace Submodel = "Wagon" if Model=="Mazda 323"&strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Mazda Glc"&strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Mazda 6"&strpos(OModel,"Wagon")!=0
replace Submodel = "Hybrid" if Model=="Mazda Tribute"&strpos(OModel,"Hybrid")!=0

* B Series trucks. Beginning with 1999 they are separated.
	* Before 1999 the 2000 and 2600 are separated out, but they will merge properly given 2Wd or 4Wd.
replace Submodel = "2300" if Model=="Mazda B Series" & strpos(OModel,"B2300")!=0 & strpos(OModel,"/")==0 
replace Submodel = "2500" if Model=="Mazda B Series" & strpos(OModel,"B2500")!=0 & strpos(OModel,"/")==0
replace Submodel = "3000" if Model=="Mazda B Series" & strpos(OModel,"B3000")!=0 & strpos(OModel,"/")==0
replace Submodel = "4000" if Model=="Mazda B Series" & strpos(OModel,"B4000")!=0 & strpos(OModel,"/")==0



*** Mercedes
replace Submodel = "D" if Model=="Mercedes-Benz 190"&strpos(OModel,"190D")!=0
replace Submodel = "D Turbo" if Model=="Mercedes-Benz 190"&strpos(OModel,"190D")!=0&strpos(OModel,"Turbo")!=0
replace Submodel = "E" if Model=="Mercedes-Benz 190"&strpos(OModel,"190E")!=0


replace Submodel = "Ce" if Model=="Mercedes-Benz 300"&strpos(OModel,"Ce")!=0
replace Submodel = "Ce Convertible" if Model=="Mercedes-Benz 300"&strpos(OModel,"Ce Convertible")!=0
replace Submodel = "D" if Model=="Mercedes-Benz 300"&strpos(OModel,"300D")!=0
replace Submodel = "D/Cd" if Model=="Mercedes-Benz 300"&strpos(OModel,"300D/300Cd")!=0
replace Submodel = "E" if Model=="Mercedes-Benz 300"&strpos(OModel,"300E")!=0
replace Submodel = "E 4Matic" if Model=="Mercedes-Benz 300"&strpos(OModel,"E 4Matic")!=0

replace Submodel = "SD" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Sd")!=0
replace Submodel = "SDL" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Sdl")!=0

replace Submodel = "SE" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Se")!=0
replace Submodel = "SEL" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Sel")!=0
replace Submodel = "SL" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Sl")!=0
replace Submodel = "TD" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Td")!=0

replace Submodel = "TE" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Te")!=0
replace Submodel = "TE 4Matic" if Model=="Mercedes-Benz 300"&strpos(OModel,"300Te 4Matic")!=0

replace Submodel = "SD" if Model=="Mercedes-Benz 350"&strpos(OModel,"350Sd")!=0
replace Submodel = "SDL" if Model=="Mercedes-Benz 350"&strpos(OModel,"350Sdl")!=0

replace Submodel = "SE" if Model=="Mercedes-Benz 380"&strpos(OModel,"380Se")!=0
replace Submodel = "SL" if Model=="Mercedes-Benz 380"&strpos(OModel,"380Sl")!=0

replace Submodel = OModel if Model=="Mercedes-Benz 400"
replace Submodel = "420Se" if Model=="Mercedes-Benz 420"&strpos(OModel,"Se")!=0
replace Submodel = "420Sel" if Model=="Mercedes-Benz 420"&strpos(OModel,"Sel")!=0
replace Submodel = OModel if Model=="Mercedes-Benz 500"
replace Submodel = "600Sl" if Model=="Mercedes-Benz 600"&strpos(OModel,"Sl")!=0
replace Submodel = "600Sl" if Model=="Mercedes-Benz 600"&strpos(OModel,"Sl")!=0
replace Submodel = OModel if Model=="Mercedes-Benz 560"
replace Submodel = OModel if Model=="Mercedes-Benz C Class"
replace Submodel = "C320 4Matic" if Model=="Mercedes-Benz C Class"&strpos(OModel,"C320 4Matic")!=0&strpos(OModel,"Wagon")==0
replace Submodel = "C36" if Model=="Mercedes-Benz C Class"&strpos(OModel,"C36")!=0
replace Submodel = "C43" if Model=="Mercedes-Benz C Class"&strpos(OModel,"C43")!=0
replace Submodel = OModel if Model=="Mercedes-Benz Cl Class"

replace Submodel = "Clk320" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk320")!=0
replace Submodel = "Clk350" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk350")!=0
replace Submodel = "Clk430" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk430")!=0
replace Submodel = "Clk500" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk500")!=0
replace Submodel = "Clk55" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk55")!=0
replace Submodel = "Clk550" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk550")!=0
replace Submodel = "Clk63" if Model=="Mercedes-Benz Clk Class"&strpos(OModel,"Clk63")!=0

replace Submodel = OModel if Model=="Mercedes-Benz Cls Class"

replace Submodel = OModel if Model=="Mercedes-Benz E Class"
replace Submodel = "E55" if Model=="Mercedes-Benz E Class"&strpos(OModel,"E55")!=0&strpos(OModel,"E550")==0
replace Submodel = "E55 Wagon" if Model=="Mercedes-Benz E Class"&strpos(OModel,"E55")!=0&strpos(OModel,"E550")==0&strpos(OModel,"Wagon")!=0

replace Submodel = "CDI" if Model=="Mercedes-Benz Ml320"&strpos(OModel,"Cdi")!=0

replace Submodel = OModel if Model=="Mercedes-Benz S Class"
replace Submodel = OModel if Model=="Mercedes-Benz Sl Class"
replace Submodel = OModel if Model=="Mercedes-Benz Slk Class"
replace Submodel = "Slk230" if Model=="Mercedes-Benz Slk Class"&strpos(OModel,"Slk230")!=0



*** Mercury
replace Submodel = "Wagon" if Model=="Mercury Grand Marquis"&strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Mercury Lynx"&strpos(OModel,"Wagon")!=0
replace Submodel = "Hybrid" if Model=="Mercury Mariner"&strpos(OModel,"Hybrid")!=0
replace Submodel = "Wagon" if Model=="Mercury Marquis"&strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Mercury Sable"&strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Mercury Tracer"&strpos(OModel,"Wagon")!=0

*** Mini Cooper
replace Submodel = OModel if Model=="Mini Cooper"
replace Submodel = "S" if Model=="Mini Clubman"&strpos(OModel,"S")!=0


*** Mitsubishi
replace Submodel = "Spyder" if Model=="Mitsubishi 3000Gt"&strpos(OModel,"Spyder")!=0
replace Submodel = "Wagon" if Model=="Mitsubishi Diamante"&strpos(OModel,"Wagon")!=0

replace Submodel = "Spyder/Convertible" if Model=="Mitsubishi Eclipse"&(strpos(OModel,"Spyder")!=0|strpos(OModel,"Convertible")!=0)

replace Submodel = "Lrv" if Model=="Mitsubishi Expo"&strpos(OModel,"Lrv")!=0
replace Submodel = "Sigma" if Model=="Mitsubishi Galant"&strpos(OModel,"Sigma")!=0
replace Submodel = "Evolution" if Model=="Mitsubishi Lancer"&strpos(OModel,"Evolution")!=0
replace Submodel = "Sport" if Model=="Mitsubishi Montero"&strpos(OModel,"Sport")!=0


*** Nissan
replace Submodel = "2X2" if Model=="Nissan 300Zx" & strpos(OModel,"2X2")!=0
replace Submodel = "Roadster" if Model=="Nissan 350Z" & strpos(OModel,"Roadster")!=0
replace Submodel = "Coupe" if Model=="Nissan Altima" & strpos(OModel,"Coupe")!=0
replace Submodel = "Hybrid" if Model=="Nissan Altima" & strpos(OModel,"Hybrid")!=0
replace Submodel = "Wagon" if Model=="Nissan Maxima"&strpos(OModel,"Wagon")!=0

replace Submodel = "Coupe" if Model=="Nissan Sentra" & strpos(OModel,"Coupe")!=0
replace Submodel = "Wagon" if Model=="Nissan Sentra"&strpos(OModel,"Wagon")!=0
replace Submodel = "Honeybee" if Model=="Nissan Sentra"&strpos(OModel,"Honeybee")!=0

replace Submodel = "Wagon" if Model=="Nissan Stanza"&strpos(OModel,"Wagon")!=0


*** Oldsmobile
replace Submodel = "Supreme" if Model=="Oldsmobile Cutlass Ciera"&strpos(OModel,"Supreme")!=0 /* This is only for pre-1985. Anything Cutlass Supreme is labeled as Model Cutlass Supreme. */
replace Submodel ="Cruiser" if Model=="Oldsmobile Cutlass Ciera"&(strpos(OModel,"Cruiser")!=0|strpos(OModel,"Wagon")!=0)

replace Submodel = "Royale" if Model=="Oldsmobile Delta 88"&strpos(OModel,"Royale")!=0

replace Submodel = "Wagon" if Model=="Oldsmobile Firenza"&strpos(OModel,"Cruiser")!=0



*** Peugeot
replace Submodel = "Wagon" if Model=="Peugeot 405" & strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Peugeot 505" & strpos(OModel,"Wagon")!=0





*** Plymouth
* Already done above: replace Submodel = "Wagon" if Model=="Dodge/Plymouth Colt" & strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Plymouth Reliant" & strpos(OModel,"Wagon")!=0
replace Submodel = "Convertible" if Model=="Plymouth Sundance" & strpos(OModel,"Convertible")!=0


*** Pontiac
replace Submodel = "Convertible" if Model=="Pontiac 2000" & strpos(OModel,"Convertible")!=0
replace Submodel = "Wagon" if Model=="Pontiac 2000" & strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Pontiac 6000" & strpos(OModel,"Wagon")!=0
replace Submodel = "Gt" if Model=="Pontiac G5" & strpos(OModel,"Gt")!=0
replace Submodel = "G6 Gt/Gtp Convertible" if Model=="Pontiac G6" & strpos(OModel,"G6 Gt/Gtp Convertible")!=0
replace Submodel = "Grand Prix Ste Turbo" if Model=="Pontiac Grand Prix" & strpos(OModel,"Grand Prix Ste Turbo")!=0
replace Submodel = "Wagon" if Model=="Pontiac Parisienne" & strpos(OModel,"Wagon")!=0
replace Submodel = "Wagon" if Model=="Pontiac Sunbird" & strpos(OModel,"Wagon")!=0
replace Submodel = "Convertible" if Model=="Pontiac Sunbird" & strpos(OModel,"Convertible")!=0
replace Submodel = "20th Anniversary SE" if (Make=="Pontiac") & strpos(OModel,"20Th Anniversary Trans Am")==1 


*** Porsche
replace Submodel = "Targa" if Model=="Porsche 911" & strpos(OModel,"Targa")!=0
replace Submodel = "Turbo" if Model=="Porsche 911" & strpos(OModel,"Turbo")!=0
replace Submodel = "Gt2" if Model=="Porsche 911" & strpos(OModel,"Gt2")!=0
replace Submodel = "Gt3" if Model=="Porsche 911" & strpos(OModel,"Gt3")!=0


replace Submodel = "Turbo" if Model=="Porsche Cayenne" & strpos(OModel,"Turbo")!=0
replace Submodel = "Gts" if Model=="Porsche Cayenne" & strpos(OModel,"Gts")!=0
replace Submodel = "S" if Model=="Porsche Cayenne" & strpos(OModel,"S")!=0

replace Submodel = "S" if Model=="Porsche Cayman" & strpos(OModel,"S")!=0


*** Rolls-Royce
replace Submodel = "Phantom Drophead Coupe" if Model=="Rolls-Royce Phantom" & strpos(OModel,"Phantom Drophead Coupe")!=0

replace Submodel = "Spur" if Model=="Rolls-Royce Silver Series" & strpos(OModel,"Spur")!=0
replace Submodel = "Spirit" if Model=="Rolls-Royce Silver Series" & strpos(OModel,"Spirit")!=0
replace Submodel = "Seraph" if Model=="Rolls-Royce Silver Series" & strpos(OModel,"Seraph")!=0
replace Submodel = "Dawn" if Model=="Rolls-Royce Silver Series" & strpos(OModel,"Dawn")!=0


*** Rover
replace Submodel = "Ii" if Model=="Rover Discovery" & strpos(OModel,"Ii")!=0
replace Submodel = "3 Door" if Model=="Rover Freelander" & strpos(OModel,"3 Door")!=0
replace Submodel = "Sport" if Model=="Rover Range Rover" & strpos(OModel,"Sport")!=0
replace Submodel = "Lwb" if Model=="Rover Range Rover" & strpos(OModel,"Lwb")!=0

*** Saab
replace Submodel = "Convertible" if Model=="Saab 900" & strpos(OModel,"Convertible")!=0
replace Submodel = "S" if Model=="Saab 900" & strpos(OModel,"S")!=0
replace Submodel = "Se" if Model=="Saab 900" & strpos(OModel,"Se")!=0
replace Submodel = "S Convertible" if Model=="Saab 900" & strpos(OModel,"S Convertible")!=0
replace Submodel = "Se Convertible" if Model=="Saab 900" & strpos(OModel,"Se Convertible")!=0

replace Submodel = "Convertible" if Model=="Saab 9-3" & strpos(OModel,"Convertible")!=0
replace Submodel = "Viggen" if Model=="Saab 9-3" & strpos(OModel,"Viggen")!=0
replace Submodel = "Viggen Convertible" if Model=="Saab 9-3" & strpos(OModel,"Viggen Convertible")!=0
replace Submodel = "Wagon" if Model=="Saab 9-3" & strpos(OModel,"Sportcombi")!=0

replace Submodel = "Aero Wagon" if Model=="Saab 9-3" & strpos(OModel,"Sportcombi")!=0&strpos(OModel,"Aero")!=0
replace Submodel = "Aero Sedan" if Model=="Saab 9-3" & strpos(OModel,"Sportcombi")==0&strpos(OModel,"Aero")!=0

replace Submodel = "Wagon" if Model=="Saab 9-5" & (strpos(OModel,"Sportcombi")!=0 | strpos(OModel,"Wagon")!=0 )

*** Saturn
replace Submodel = "2Dr" if Model=="Saturn Astra" & strpos(OModel,"2Dr")!=0
replace Submodel = "Hybrid" if Model=="Saturn Aura" & strpos(OModel,"Hybrid")!=0

replace Submodel = "Hybrid" if Model=="Saturn Vue" & strpos(OModel,"Hybrid")!=0


*** Subaru
	* There are also hatchback and sedan/3door data in the EPA, but it's not clear what the EPA meant to be a sedan/3door and what they meant to be a hatchback.
replace Submodel = "Wagon" if Model=="Subaru Series" & (strpos(OModel,"Wagon")!=0 )

replace Submodel = "Wagon" if Model=="Subaru Impreza" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Wagon" if Model=="Subaru Legacy" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Wagon" if Model=="Subaru Loyale" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Dl" if Model=="Subaru Xt" & (strpos(OModel,"Dl")!=0 )



*** Suzuki
replace Submodel = "Sx" if Model=="Suzuki Aerio" & (strpos(OModel,"Sx")!=0 )
replace Submodel = "Wagon" if Model=="Suzuki Esteem" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Convertible" if Model=="Suzuki Samurai" & (strpos(OModel,"Convertible")!=0 )
replace Submodel = "Convertible" if Model=="Suzuki Sidekick" & (strpos(OModel,"Convertible")!=0 )
replace Submodel = "2Door" if Model=="Suzuki Sidekick" & (strpos(OModel,"2Door")!=0 )
replace Submodel = "4Door" if Model=="Suzuki Sidekick" & (strpos(OModel,"4Door")!=0 )
replace Submodel = "Sport" if Model=="Suzuki Sidekick" & (strpos(OModel,"Sport")!=0 )
replace Submodel = "V" if Model=="Suzuki Sj410" & (strpos(OModel,"V")!=0 )
replace Submodel = "K" if Model=="Suzuki Sj410" & (strpos(OModel,"K")!=0 )
replace Submodel = "Gt" if Model=="Suzuki Swift" & (strpos(OModel,"Gt")!=0 )
replace Submodel = "Ga" if Model=="Suzuki Swift" & (strpos(OModel,"Ga")!=0 )
replace Submodel = "Sedan" if Model=="Suzuki Sx4" & (strpos(OModel,"Sedan")!=0 )

replace Submodel = "Convertible" if Model=="Suzuki Vitara" & (strpos(OModel,"2 Do")!=0 | strpos(OModel,"2Do")!=0)



*** Toyota
replace Submodel = "Wagon" if Model=="Toyota Camry" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Hybrid" if Model=="Toyota Camry" & (strpos(OModel,"Hybrid")!=0 )
replace Submodel = "Convertible" if Model=="Toyota Camry Solara" & (strpos(OModel,"Convertible")!=0 )

replace Submodel = "Convertible" if Model=="Toyota Celica" & (strpos(OModel,"Convertible")!=0 )

replace Submodel = "Wagon" if Model=="Toyota Corolla" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "All-Trac Wagon" if Model=="Toyota Corolla" & (strpos(OModel,"All-Trac Wagon")!=0 )
replace Submodel = "Sport" if Model=="Toyota Corolla" & (strpos(OModel,"Sport")!=0 )
replace Submodel = "Fx" if Model=="Toyota Corolla" & (strpos(OModel,"Fx")!=0 )

replace Submodel = "Wagon" if Model=="Toyota Cressida" & (strpos(OModel,"Wagon")!=0 )

replace Submodel = "Hybrid" if Model=="Toyota Highlander" & (strpos(OModel,"Hybrid")!=0 )

replace Submodel = "T100 AWD" if Model=="Toyota Truck" & strpos(OModel,"Truck 4Wd/T100 4Wd")!=0
replace Submodel = "T100 2WD" if Model=="Toyota Truck" & strpos(OModel,"Truck 2Wd/T100 2Wd")!=0

replace Submodel = "Wagon" if Model=="Toyota Tercel" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Ez" if Model=="Toyota Tercel" & (strpos(OModel,"Ez")!=0 )




*** Volkswagen
replace Submodel = "Slc" if Model=="Volkswagen Corrado" & (strpos(OModel,"Slc")!=0 )
replace Submodel = "Camper" if Model=="Volkswagen Eurovan" & (strpos(OModel,"Camper")!=0 )
replace Submodel = "Wagon" if Model=="Volkswagen Fox" & (strpos(OModel,"Wagon")!=0 )

replace Submodel = "16V" if Model=="Volkswagen Gti" & (strpos(OModel,"16V")!=0 )
replace Submodel = "VR6" if Model=="Volkswagen Gti" & (strpos(OModel,"Vr6")!=0 )

replace Submodel = "Wagon" if Model=="Volkswagen Jetta" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Gli" if Model=="Volkswagen Jetta" & (strpos(OModel,"Gli")!=0 )
replace Submodel = "Glx" if Model=="Volkswagen Jetta Iii" & (strpos(OModel,"Glx")!=0 )

replace Submodel = "Convertible" if Model=="Volkswagen New Beetle" & (strpos(OModel,"Convertible")!=0 )


replace Submodel = "Wagon" if Model=="Volkswagen Passat" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Syncro" if Model=="Volkswagen Passat" & (strpos(OModel,"Syncro")!=0 )
replace Submodel = "Wagon Syncro" if Model=="Volkswagen Passat" & (strpos(OModel,"Wagon Syncro")!=0 )
replace Submodel = "Wagon" if Model=="Volkswagen Quantum" & (strpos(OModel,"Wagon")!=0 )
replace Submodel = "Wagon Syncro" if Model=="Volkswagen Quantum" & (strpos(OModel,"Syncro Wagon")!=0 )
replace Submodel = "16V" if Model=="Volkswagen Scirocco" & (strpos(OModel,"16V")!=0 )


*** Volvo
replace Submodel = "Wagon" if Make=="Volvo" & (strpos(OModel,"Wagon")!=0 )

replace Submodel = "Se" if Model=="Volvo 940" & (strpos(OModel,"Se")!=0 )
replace Submodel = "Gle" if Model=="Volvo 940" & (strpos(OModel,"Gle")!=0)
replace Submodel = "Se Wagon" if Model=="Volvo 940" & (strpos(OModel,"Se Wagon")!=0 )
replace Submodel = "Gle Wagon" if Model=="Volvo 940" & (strpos(OModel,"Gle")!=0 &strpos(OModel,"Wagon")!=0)

replace Submodel = "Coupe" if Model=="Volvo C70" & (strpos(OModel,"Coupe")!=0 )
replace Submodel = "Convertible" if Model=="Volvo C70" & (strpos(OModel,"Convertible")!=0 )

replace Submodel = "R" if Model=="Volvo S60" & (strpos(OModel,"R")!=0 )

replace Submodel = "R" if Model=="Volvo V70" & (strpos(OModel,"R")!=0 )
replace Submodel = "Xc" if Model=="Volvo V70" & (strpos(OModel,"Xc")!=0 )


