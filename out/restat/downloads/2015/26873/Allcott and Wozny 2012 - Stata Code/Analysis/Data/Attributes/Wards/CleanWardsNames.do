/* CleanWardsNames.do */
/* This file cleans the Model names and unifies them so that they can be matched with the Polk and EPA data. */

/** Change the Category of Make/Model/Submodel **/
** Change the category so that they can match with POLK Model names 

replace Make= proper(trim(Make))
replace Model= proper(trim(Model))
replace Submodel= proper(trim(Submodel))

** Acura **
replace Model="Cl" if Make=="Acura" & strpos(Model,"Cl")!=0
replace Model="Tl" if Make=="Acura" & strpos(Model,"Tl")!=0
replace Model="Rl" if Make=="Acura" & strpos(Model,"Rl")!=0
replace Model="Integra" if Make=="Acura" & strpos(Model,"Integra")==1
replace Model="Mdx" if Make=="Acura" & strpos(Model,"Mdx")==1
replace Model="Nsx" if Make=="Acura" & strpos(Model,"Nsx")==1
replace Model="Rsx" if Make=="Acura" & strpos(Model,"Rsx")==1

** Am General / Hummer **
replace Make="Am General" if Make=="Am"
replace Model="Hummer Softtop" if Model=="Hummer Soft Top"
replace Make="Hummer" if Make=="Am General" & strpos(Model,"Hummer")==1

** Audi **
replace Model="A4" if Make=="Audi" & strpos(Model,"A4")==1
replace Model="A3" if Make=="Audi" & strpos(Model,"A3")==1
replace Model="A6" if Make=="Audi" & strpos(Model,"A6")==1
replace Model="A8" if Make=="Audi" & strpos(Model,"A8")==1
replace Model="Audi Q7" if Make=="Audi" & strpos(Model,"Q7")==1
replace Model="Allroad Quattro" if Make=="Audi" & strpos(Model,"All-Road")==1
replace Model="Tt" if Make=="Audi" & strpos(Model,"Tt")==1
replace Model="Allroad Quattro" if Make=="Audi" & strpos(Model,"Allroad Quattro")==1
replace Model="Audi R8" if Make=="Audi" & strpos(Model,"R8")==1
replace Model="Audi Rs4" if Make=="Audi" & strpos(Model,"Rs4")==1
replace Model="Audi S4" if Make=="Audi" & strpos(Model,"S4")==1
replace Model="Audi S6" if Make=="Audi" & strpos(Model,"S6")==1
replace Model="Audi S8" if Make=="Audi" & strpos(Model,"S8")==1


** BMW **
replace Model="Bmw 318" if Make=="Bmw" & strpos(Model,"318")==1
replace Model="Bmw 323" if Make=="Bmw" & strpos(Model,"323")==1
replace Model="Bmw 325" if Make=="Bmw" & strpos(Model,"325")==1
replace Model="Bmw 328" if Make=="Bmw" & strpos(Model,"328")==1
replace Model="Bmw 330" if Make=="Bmw" & strpos(Model,"330")==1
replace Model="Bmw 525" if Make=="Bmw" & strpos(Model,"525")==1
replace Model="Bmw 528" if Make=="Bmw" & strpos(Model,"528")==1
replace Model="Bmw 530" if Make=="Bmw" & strpos(Model,"530")==1
replace Model="Bmw 540" if Make=="Bmw" & strpos(Model,"540")==1
replace Model="Bmw 740" if Make=="Bmw" & strpos(Model,"740")==1
replace Model="Bmw 750" if Make=="Bmw" & strpos(Model,"750")==1
replace Model="Bmw 840" if Make=="Bmw" & strpos(Model,"840")==1
replace Model="Bmw 850" if Make=="Bmw" & strpos(Model,"850")==1
replace Model="Bmw X5" if Make=="Bmw" & strpos(Model,"X5")==1
replace Model="Bmw Z3" if Make=="Bmw" & strpos(Model,"Z3")==1
replace Model="Bmw Z4" if Make=="Bmw" & strpos(Model,"Z4")==1
replace Model="Bmw Z8" if Make=="Bmw" & strpos(Model,"Z8")==1
replace Model="Bmw 335" if Make=="Bmw" & strpos(Model,"335")==1
replace Model="Bmw 535" if Make=="Bmw" & strpos(Model,"535")==1
replace Model="Bmw 545" if Make=="Bmw" & strpos(Model,"545")==1
replace Model="Bmw 550" if Make=="Bmw" & strpos(Model,"550")==1
replace Model="Bmw 645" if Make=="Bmw" & strpos(Model,"645")==1
replace Model="Bmw 650" if Make=="Bmw" & strpos(Model,"650")==1
replace Model="Bmw 745" if Make=="Bmw" & strpos(Model,"745")==1
replace Model="Bmw 760" if Make=="Bmw" & strpos(Model,"760")==1
replace Model="Bmw M" if Make=="Bmw" & (strpos(Model,"M Coupe")==1|strpos(Model,"M Road")==1)
replace Model="Bmw X3" if Make=="Bmw" & strpos(Model,"X3")==1


** Bentley **
replace Model="Arnage" if Make=="Bentley" & strpos(Model,"Arnage")==1

** Buick **
replace Model="Regal" if Make=="Buick" & strpos(Model,"Regal")==1
replace Model="Park Avenue" if Make=="Buick" & strpos(Model,"Park")==1
replace Model="Lacrosse" if Make=="Buick" & (strpos(Model,"Cxl")==1|strpos(Model,"Cxs")==1|strpos(Model,"Cx")==1|strpos(Model,"Super")==1) & (Weight==3495|Weight==3502|Weight==3568|Weight==3770)
replace Model="Lucerne" if Make=="Buick" & (strpos(Model,"Cxl")==1|strpos(Model,"Cxs")==1|strpos(Model,"Cx")==1) & (Weight==3764|Weight==3969|Weight==4013)
replace Model="Lacrosse" if Make=="Buick" & (strpos(Model,"Cxl")==1|strpos(Model,"Cxs")==1|strpos(Model,"Cx")==1|strpos(Model,"Super")==1) & (Weight==1585|Weight==1589|Weight==1619)
replace Model="Enclave" if Make=="Buick" & strpos(Model,"Enclave")==1 
replace Model="Ranier" if Make=="Buick" & strpos(Model,"Ranier")==1 
replace Model="Rendezvous" if Make=="Buick" & strpos(Model,"Rendezvous")==1 
replace Model="Terraza" if Make=="Buick" & strpos(Model,"Terraza")==1 
replace Model="Lesabre" if Make=="Buick" & strpos(Model,"Lesabre")==1 
replace Model="Century" if Make=="Buick" & strpos(Model,"Century")==1 


** Cadillac **
replace Model=subinstr(Model,"B'ham","Brougham",.) if Make=="Cadillac"
replace Model="Cts" if Make=="Cadillac" & strpos(Model,"Cts")==1
replace Model="Dts" if Make=="Cadillac" & strpos(Model,"Dts")==1
replace Model="Deville" if Make=="Cadillac" & Model=="De"
replace Model="Deville" if Make=="Cadillac" & strpos(Model,"Deville")==1
replace Model="Eldorado" if Make=="Cadillac" & strpos(Model,"Eldorado")==1
replace Model="Escalade" if Make=="Cadillac" & strpos(Model,"Escalade")==1
replace Model="Seville" if Make=="Cadillac" & strpos(Model,"Seville")==1
replace Model="Catera" if Make=="Cadillac" & strpos(Model,"Catera")==1
replace Model="Srx" if Make=="Cadillac" & strpos(Model,"Srx")==1
replace Model="Sts" if Make=="Cadillac" & strpos(Model,"Sts")==1
replace Model="Xlr" if Make=="Cadillac" & strpos(Model,"Xlr")==1


** Chevrolet **
replace Model="Astro" if Make=="Chevrolet" & strpos(Model,"Astro")==1
replace Model="Cobalt" if Make=="Chevrolet" & strpos(Model,"Cobalt")==1
replace Model="Colorado" if Make=="Chevrolet" & strpos(Model,"Colorado")==1
replace Model="Corvette" if Make=="Chevrolet" & strpos(Model,"Corvette")==1
replace Model="Commander" if Make=="Chevrolet" & strpos(Model,"Commander")==1
replace Model="Compass" if Make=="Chevrolet" & strpos(Model,"Compass")==1
replace Model="Equinox" if Make=="Chevrolet" & strpos(Model,"Equinox")==1
replace Model="Blazer" if Make=="Chevrolet" & strpos(Model,"Blazer")==1 & strpos(Model,"K10")==0 
replace Model="C1500 Sportside" if Make=="Chevrolet" & Model=="C1500  Sportside"
replace Model="Camaro" if Make=="Chevrolet" & strpos(Model,"Camaro")==1 
replace Model="Cavalier" if Make=="Chevrolet" & strpos(Model,"Cavalier")==1 
replace Model="Chevy Van G2500" if Make=="Chevrolet" & Model=="Chevy Van  G2500"
replace Model="Chevy Van G3500" if Make=="Chevrolet" & Model=="Chevy Van  G3500" 
replace Model="Express G2500" if Make=="Chevrolet" & Model=="Express  G2500"
replace Model="Express G3500" if Make=="Chevrolet" & Model=="Express  G3500" 
replace Model="Geo Metro" if Make=="Chevrolet" & Model=="Geo" & strpos(Submodel,"Metro")==1
replace Model="Geo Prism" if Make=="Chevrolet" & Model=="Geo" & strpos(Submodel,"Prism")==1
replace Model="K1500 Sportside" if Make=="Chevrolet" & Model=="K1500  Sportside"
replace Model="Monte Carlo" if Make=="Chevrolet" & Model=="Monte"
replace Model="Prizm" if strpos(Model,"Prism")==1
replace Model="S10" if Make=="Chevrolet" & strpos(Model,"S10")==1 & strpos(Model,"Blazer")==0
replace Model="Tracker" if Make=="Chevrolet" & strpos(Model,"Tracker")==1
replace Model="Venture" if Make=="Chevrolet" & strpos(Model,"Venture")==1
replace Model="Chevrolet G20" if Make=="Chevrolet" & strpos(Model,"G20")==1
replace Model="Lumina Apv" if Make=="Chevrolet" & (strpos(Submodel,"APV")!=0 |strpos(Submodel,"Apv")!=0)
replace Model="Lumina" if Make=="Chevrolet" & strpos(Model,"Lumina")==1 & strpos(Model,"Apv")==0
replace Model="Avalanche" if Make=="Chevrolet" & strpos(Model,"Avalanche")==1
replace Model="Aveo" if Make=="Chevrolet" & strpos(Model,"Aveo")==1
replace Model="Hhr" if Make=="Chevrolet" & strpos(Model,"Hhr")==1
replace Model="Ssr" if Make=="Chevrolet" & strpos(Model,"Ssr")==1
replace Model="Impala" if Make=="Chevrolet" & strpos(Model,"Impala")==1
replace Model="Malibu" if Make=="Chevrolet" & strpos(Model,"Malibu")==1
replace Model="Monte Carlo" if Make=="Chevrolet" & strpos(Model,"Monte Carlo")==1
** drop the syntax below, when matching with POLK instead of NHTS
replace Model="Chevrolet C Series" if Make=="Chevrolet" & (strpos(Model,"C1500")==1|strpos(Model,"C2500")==1|strpos(Model,"C3500")==1|strpos(Model,"(C1500)")==1)
replace Model="Chevrolet G Series" if Make=="Chevrolet" & (strpos(Model,"G1500")!=0|strpos(Model,"G2500")!=0|strpos(Model,"G3500")!=0) & strpos(Model,"Van")==0 & strpos(Model,"Express")==0
replace Model="Express" if Make=="Chevrolet" & strpos(Model,"Express")==1
replace Model="Chevrolet G Series" if Make=="Chevrolet" & (strpos(Model,"G10")==1|strpos(Model,"G20")!=0|strpos(Model,"G30")!=0)
replace Model="Chevrolet K Series" if Make=="Chevrolet" & (strpos(Model,"K1500")==1|strpos(Model,"K2500")==1|strpos(Model,"K3500")==1|strpos(Model,"(K1500)")==1)
replace Model="Chevy Van" if Make=="Chevrolet" & strpos(Model,"Chevy Van")==1
replace Model="Silverado" if Make=="Chevrolet" & strpos(Model,"Silverado")==1
replace Model="Suburban" if Make=="Chevrolet" & strpos(Model,"Suburban")==1
replace Model="Tahoe" if Make=="Chevrolet" & strpos(Model,"Tahoe")==1
replace Model="Uplander" if Make=="Chevrolet" & strpos(Model,"Uplander")==1
replace Model="Trailblazer" if Make=="Chevrolet" & (strpos(Model,"Trail Blazer")==1|strpos(Model,"Trailblazer")==1)

** Chrysler **
replace Model="Sebring" if Make=="Chrysler" & strpos(Model,"Sebring")==1
replace Model="Town & Country" if Make=="Chrysler" & Model=="Town"
replace Model="New Yorker" if Make=="Chrysler" & Model=="New"
replace Model="Chrysler Voyager" if Make=="Chrysler" & strpos(Model,"Voyager")==1
replace Model="Chrysler Grand Voyager" if Make=="Chrysler" & strpos(Model,"Grand Voyager")==1
replace Model="Town & Country" if Make=="Chrysler" & strpos(Model,"Town & Country")==1
replace Model="Concorde" if Make=="Chrysler" & strpos(Model,"Concorde")==1
replace Model="Chrysler 300" if Make=="Chrysler" & (Model=="300"|strpos(Model,"300 Tour")==1|strpos(Model,"300 Limi")==1|strpos(Model,"300 Lx")==1)
replace Model="300C" if Make=="Chrysler" & strpos(Model,"300C")==1
replace Model="300M" if Make=="Chrysler" & strpos(Model,"300M")==1
replace Model="Crossfire" if Make=="Chrysler" & strpos(Model,"Crossfire")==1
replace Model="Pacifica" if Make=="Chrysler" & strpos(Model,"Pacifica")==1
replace Model="Pt Cruiser" if Make=="Chrysler" & strpos(Model,"Pt Cruiser")==1
replace Model="Cirrus" if Make=="Chrysler" & strpos(Model,"Cirrus")==1


** Daewoo **
replace Model="Lanos" if Make=="Daewoo" & strpos(Model,"Lanos")==1
replace Model="Leganza" if Make=="Daewoo" & strpos(Model,"Leganza")==1
replace Model="Nubira" if Make=="Daewoo" & strpos(Model,"Nubira")==1

** Dodge **
replace Model="Dakota Sport" if Make=="Dodge" & Model=="Dakota  Sport"
replace Model="Dakota  Sport R/T" if Make=="Dodge" & Model=="Dakota  Sport R/T"
replace Model="Dakota Quad Cab" if Make=="Dodge" & Model=="Dakota. Quad Cab"
replace Model="Durango" if Make=="Dodge" & (strpos(Model,"Durango")==1 |strpos(Model,"Durange")==1)
replace Model="Grand Caravan" if Make=="Dodge" & Model=="Grand"
replace Model="Grand Caravan" if Make=="Dodge" & strpos(Model,"Grand Caravan")==1
replace Model="Neon" if Make=="Dodge" & strpos(Model,"Neon")==1
replace Model="Ram 1500" if Make=="Dodge" & ( strpos(Model,"Ram 1500")==1 | strpos(Submodel,"1500")==1 | strpos(Submodel,"Ram Quad Cab 1500")==1) 
replace Model="Ram 2500" if Make=="Dodge" & ( strpos(Model,"Ram 2500")==1 | strpos(Submodel,"2500")==1 )
replace Model="Ram 3500" if Make=="Dodge" & ( strpos(Model,"Ram 3500")==1 | strpos(Submodel,"3500")==1 )
replace Model="Ram Van" if Make=="Dodge" & ( strpos(Model,"Ram Van")==1 | strpos(Submodel,"Van")==1 )
replace Model="Ram Wagon" if Make=="Dodge" & ( strpos(Model,"Ram Wagon")==1 | strpos(Submodel,"Wagon")==1 )
replace Model="Stratus Se" if Make=="Dodge" & Model=="Stratus  Se"
replace Model="Caravan" if Make=="Dodge" & strpos(Model,"Caravan")==1
replace Model="Dakota" if Make=="Dodge" & strpos(Model,"Dakota")==1
replace Model="Viper" if Make=="Dodge" & strpos(Model,"Viper")==1
replace Model="Avenger" if Make=="Dodge" & strpos(Model,"Avenger")==1
replace Model="Caliber" if Make=="Dodge" & strpos(Model,"Caliber")==1
replace Model="Charger" if Make=="Dodge" & strpos(Model,"Charger")==1
replace Model="Intrepid" if Make=="Dodge" & strpos(Model,"Intrepid")==1
replace Model="Magnum" if Make=="Dodge" & strpos(Model,"Magnum")==1
replace Model="Nitro" if Make=="Dodge" & strpos(Model,"Nitro")==1
replace Model="Dodge Raider" if Make=="Dodge" & strpos(Model,"Raider")==1
replace Model="Stratus" if Make=="Dodge" & strpos(Model,"Stratus")==1
replace Model="Grand Voyager" if (Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Grand Voyager")==1


** Ford **
replace Model="F350 Super Duty" if Model=="Drw"
replace Model="Aerostar" if Make=="Ford" & strpos(Model,"Aerostar")==1
replace Model="Club Wagon" if Make=="Ford" & Model=="Club"
replace Model="Club Wagon" if Make=="Ford" & strpos(Model,"Club Wagon")==1
replace Model="Contour" if Make=="Ford" & strpos(Model,"Contour")==1
replace Model="Crown Victoria" if Make=="Ford" & strpos(Model,"Crown")==1
replace Model="Crown Victoria" if Make=="Ford" & Model=="Engine"
replace Model="Escape" if Make=="Ford" & strpos(Model,"Escape")==1
replace Model="Escort" if Make=="Ford" & strpos(Model,"Escort")==1
replace Model="Excursion" if Make=="Ford" & strpos(Model,"Excursion")==1
replace Model="Expedition" if Make=="Ford" & strpos(Model,"Expedition")==1
replace Model="Explorer" if Make=="Ford" & strpos(Model,"Explorer")==1
replace Model="F150" if Make=="Ford" & strpos(Model,"F150")==1 & strpos(Model,"Supercab")==0
replace Model="F150 Supercab" if Make=="Ford" & strpos(Model,"F150")==1 & strpos(Model,"Supercab")!=0
replace Model="F250" if Make=="Ford" & strpos(Model,"F250")==1 & strpos(Model,"Supercab")==0
replace Model="F250 Supercab" if Make=="Ford" & strpos(Model,"F250")==1 & strpos(Model,"Supercab")!=0
replace Model="F350" if Make=="Ford" & strpos(Model,"F350")==1
replace Model="F350 Supercab" if Make=="Ford" & strpos(Model,"F350")==1 & strpos(Model,"Supercab")!=0
replace Model="Focus" if Make=="Ford" & strpos(Model,"Focus")==1
replace Model="Mustang" if Make=="Ford" & strpos(Model,"Mustang")==1
replace Model="F250" if Make=="Ford" & Model=="Natural Gas Engine"
replace Model="Ranger" if Make=="Ford" & strpos(Model,"Ranger")==1
replace Model="Taurus" if Make=="Ford" & strpos(Model,"Taurus")==1
replace Model="Taurus" if Make=="Ford" & strpos(Model,"Taurua")==1 & ModelYear==2008
replace Model="Windstar" if Make=="Ford" & strpos(Model,"Windstar")==1
replace Model="Club Wagon" if Make=="Ford" & strpos(Model,"Club Wagon")==1
replace Model="E350" if Make=="Ford" & strpos(Model,"E350")==1
replace Model="Econoline" if Make=="Ford" & strpos(Model,"Econoline")==1
replace Model="Flairside" if Make=="Ford" & strpos(Model,"Flairside")==1
replace Model="Ford F Series" if Make=="Ford" & (strpos(Model,"F150")==1|strpos(Submodel,"F250")==1|strpos(Submodel,"F350")==1|strpos(Submodel,"Lariat")==1)
replace Model="Edge" if Make=="Ford" & strpos(Model,"Edge")==1
replace Model="Freestar" if Make=="Ford" & strpos(Model,"Freestar")==1
replace Model="Freestyle" if Make=="Ford" & strpos(Model,"Freestyle")==1
replace Model="Fusion" if Make=="Ford" & strpos(Model,"Fusion")==1
replace Model="Thunderbird" if Make=="Ford" & strpos(Model,"Thunderbird")==1
replace Model="Thunderbird" if Make=="Ford" & strpos(Model,"T'bird")==1
replace Model="Probe" if Make=="Ford" & strpos(Model,"Probe")==1
replace Model="Zx2" if Make=="Ford" & strpos(Model,"Zx2")==1
replace Model="Gt Coupe" if Make=="Ford" & Model=="Gt"


** Eagle **
replace Model="Vision" if Make=="Eagle" & strpos(Model,"Vision")==1
replace Model="Talon" if Make=="Eagle" & strpos(Model,"Talon")==1


** Gmc **
replace Model="Acadia" if Make=="Gmc" & strpos(Model,"Acadia")==1
replace Model="Jimmy" if Make=="Gmc" & strpos(Model,"Jimmy")==1
replace Model="Sonoma" if Make=="Gmc" & strpos(Model,"Sonoma")==1
replace Model="Suburban" if Make=="Gmc" & strpos(Model,"Suburban")==1
replace Model="Yukon" if Make=="Gmc" & strpos(Model,"Yukon")==1 & strpos(Model,"Xl")==0 & strpos(Model,"Denali")==0
replace Model="Yukon Xl/Denali" if Make=="Gmc" & strpos(Model,"Yukon")==1 & (strpos(Model,"Xl")!=0|strpos(Model,"Denali")!=0)
replace Model="Envoy" if Make=="Gmc" & strpos(Model,"Envoy")==1
replace Model="Sierra" if Make=="Gmc" & strpos(Model,"Sierra")==1
replace Model="Savana" if Make=="Gmc" & strpos(Model,"Savana")==1
replace Model="Canyon" if Make=="Gmc" & strpos(Model,"Canyon")==1
replace Model="Gmc Safari" if Make=="Gmc" & strpos(Model,"Safari")==1
replace Model="Envoy" if Make=="Gmc" & strpos(Model,"Envoy")==1


** Honda **
replace Model="Accord" if Make=="Honda" & strpos(Model,"Accord")==1
replace Model="Civic" if Make=="Honda" & strpos(Model,"Civic")==1 & strpos(Model,"Del Sol")==0
replace Model="Civic Del Sol" if Make=="Honda" & strpos(Model,"Civic Del Sol")==1
replace Model="Cr-V" if Make=="Honda" & strpos(Model,"Cr-V")==1
replace Model="Passport" if Make=="Honda" & Model=="Honda" & (strpos(Submodel,"Passport")!=0|Submodel=="")
replace Model="Odyssey" if Make=="Honda" & Model=="Honda" & strpos(Submodel,"Odyssey")!=0
replace Model="Passport" if Make=="Honda" & strpos(Model,"Passport")==1
replace Model="Odyssey" if Make=="Honda" & strpos(Model,"Odyssey")==1
replace Model="Element" if Make=="Honda" & strpos(Model,"Element")==1
replace Model="Honda Fit" if Make=="Honda" & strpos(Model,"Fit")==1
replace Model="Pilot" if Make=="Honda" & strpos(Model,"Pilot")==1
replace Model="Ridgeline" if Make=="Honda" & strpos(Model,"Ridgeline")==1
replace Model="S2000" if Make=="Honda" & strpos(Model,"S2000")==1
replace Model="Prelude" if Make=="Honda" & strpos(Model,"Prelude")==1


** Hyundai **
replace Model="Accent" if Make=="Hyundai" & strpos(Model,"Accent")==1
replace Model="Elantra" if Make=="Hyundai" & strpos(Model,"Elantra")==1
replace Model="Santa Fe" if Make=="Hyundai" & strpos(Model,"Santa Fe")==1
replace Model="Sonata" if Make=="Hyundai" & strpos(Model,"Sonata")==1
replace Model="Xg300" if Make=="Hyundai" & strpos(Model,"Xg300")==1
replace Model="Xg350" if Make=="Hyundai" & strpos(Model,"Xg350")==1
replace Model="Azera" if Make=="Hyundai" & strpos(Model,"Azera")==1
replace Model="Entourage" if Make=="Hyundai" & strpos(Model,"Entourage")==1
replace Model="Tiburon" if Make=="Hyundai" & strpos(Model,"Tiburon")==1
replace Model="Tucson" if Make=="Hyundai" & strpos(Model,"Tucson")==1
replace Model="Veracruz" if Make=="Hyundai" & strpos(Model,"Veracruz")==1


** Hummer **
replace Model="H3" if Make=="Hummer" & strpos(Model,"H3")==1
replace Model="H2" if Make=="Hummer" & strpos(Model,"H2")==1
replace Model="H1" if Make=="Hummer" & strpos(Model,"H1")==1


** Infiniti **
replace Model="Ex35" if Make=="Infiniti" & strpos(Model,"Ex35")==1
replace Model="G20" if Make=="Infiniti" & strpos(Model,"G20")==1
replace Model="G35" if Make=="Infiniti" & strpos(Model,"G35")==1
replace Model="G37" if Make=="Infiniti" & strpos(Model,"G37")==1
replace Model="I30" if Make=="Infiniti" & strpos(Model,"I30")==1
replace Model="M35" if Make=="Infiniti" & strpos(Model,"M35")==1
replace Model="M45" if Make=="Infiniti" & strpos(Model,"M45")==1
replace Model="Q45" if Make=="Infiniti" & strpos(Model,"Q45")==1
replace Model="Qx56" if Make=="Infiniti" & strpos(Model,"Qx56")==1


** Isuzu **
replace Model="Oasis" if Make=="Isuzu" & strpos(Model,"Oasis")==1
replace Model="Rodeo" if Make=="Isuzu" & strpos(Model,"Rodeo")==1
replace Model="Trooper" if Make=="Isuzu" & strpos(Model,"Trooper")==1
replace Model="Spacecab" if Make=="Isuzu" & strpos(Model,"Spacecab")==1
replace Model="Ascender" if Make=="Isuzu" & strpos(Model,"Ascender")==1
replace Model="Axiom" if Make=="Isuzu" & strpos(Model,"Axiom")==1
replace Model="Hombre" if Make=="Isuzu" & strpos(Model,"Hombre")==1
replace Model="I-280" if Make=="Isuzu" & (strpos(Model,"I-280")==1|strpos(Model,"I280")==1)
replace Model="I-290" if Make=="Isuzu" & strpos(Model,"I-290")==1
replace Model="I-350" if Make=="Isuzu" & strpos(Model,"I-350")==1
replace Model="I-370" if Make=="Isuzu" & strpos(Model,"I-370")==1


** Jaguar **
replace Model="S-Type" if Make=="Jaguar" & strpos(Model,"S-Type")==1
replace Model="X-Type" if Make=="Jaguar" & strpos(Model,"X-Type")==1
replace Model="Xj Super V8" if Make=="Jaguar" & Model=="Super V8"
replace Model="Vanden Plas" if Make=="Jaguar" & strpos(Model,"Vanden Plas")==1
replace Model="Vehicross" if Make=="Jaguar" & strpos(Model,"Vehicross")==1
replace Model="Xj8" if Make=="Jaguar" & strpos(Model,"Xj8")==1
replace Model="Xj6" if Make=="Jaguar" & strpos(Model,"Xj6")==1
replace Model="Xj" if Make=="Jaguar" & ( Model=="Xj Sport"|Model=="Xj Super V8")
replace Model="Xkr" if Make=="Jaguar" & strpos(Model,"Xkr")==1
replace Model="Xj6/8/12" if Make=="Jaguar" & ( Model=="Xj6"|Model=="Xj8"|Model=="Xj12")


** Jeep **
replace Model="Grand Cherokee" if Make=="Jeep" & Model=="Grand"
replace Model="Grand Cherokee" if Make=="Jeep" & strpos(Model,"Grand Cherokee")==1
replace Model="Wrangler" if Make=="Jeep" & strpos(Model,"Wrangler")==1
replace Model="Liberty" if Make=="Jeep" & strpos(Model,"Liberty")==1
replace Model="Patriot" if Make=="Jeep" & strpos(Model,"Patriot")==1
replace Model="Cherokee" if Make=="Jeep" & strpos(Model,"Cherokee")==1
replace Model="Commander" if Make=="Jeep" & strpos(Model,"Commander")==1
replace Model="Compass" if Make=="Jeep" & strpos(Model,"Compass")==1


** Kia **
replace Model="Spectra" if Make=="Kia" & strpos(Model,"Spectra")==1
replace Model="Sportage" if Make=="Kia" & strpos(Model,"Sportage")==1
replace Model="Optima" if Make=="Kia" & strpos(Model,"Optima")==1
replace Model="Kia Rio" if Make=="Kia" & strpos(Model,"Rio")==1
replace Model="Kia Rondo" if Make=="Kia" & strpos(Model,"Rondo")==1
replace Model="Sedona" if Make=="Kia" & strpos(Model,"Sedona")==1
replace Model="Sephia" if Make=="Kia" & strpos(Model,"Sephia")==1
replace Model="Sorento" if Make=="Kia" & strpos(Model,"Sorento")==1


** Land Rover **
replace Make="Land Rover" if Make=="Land"
replace Model="Discovery" if Make=="Land Rover" & strpos(Model,"Discovery")==1
replace Model="Range Rover" if Make=="Land Rover" & strpos(Model,"Range")==1
replace Model="Freelander" if Make=="Land Rover" & strpos(Model,"Freelander")==1
replace Model="Lr2" if Make=="Land Rover" & strpos(Model,"Lr2")==1
replace Model="Lr3" if Make=="Land Rover" & strpos(Model,"Lr3")==1


** Lincoln **
replace Model="Navigator" if Model=="1/2"
replace Model="Navigator" if Model=="1/2Navigator"
replace Model="Navigator" if strpos(Model,"Navigator")==1
replace Model="Lincoln Ls" if Make=="Lincoln" & strpos(Model,"Ls")==1
replace Model="Town Car" if Make=="Lincoln" & strpos(Model,"Town")==1
replace Model="Mark" if Make=="Lincoln" & strpos(Model,"Mark")==1
replace Model="Continental" if Make=="Lincoln" & strpos(Model,"Continental")==1
replace Model="Continental_Old" if Make=="Lincoln" & Model=="Continental" & ModelYear<1982
replace Model="Aviator" if Make=="Lincoln" & strpos(Model,"Aviator")==1

** Maybach **
replace Model="Maybach 57" if strpos(Model,"Maybach 57")==1
replace Model="Maybach 62" if strpos(Model,"Maybach 62")==1


** Mazda **
replace Model="Mazda 626" if Make=="Mazda" & strpos(Model,"626")==1
replace Model="Miata" if Make=="Mazda" & strpos(Model,"Miata")==1
replace Model="B3000 Se Cab Plus" if Make=="Mazda" & Model=="B3000 Se Cab Pus"
replace Model="B4000 Cab Plus" if Make=="Mazda" & Model=="B4000 Cab Pus"
replace Model="Millenia" if Make=="Mazda" & strpos(Model,"Millenia")==1
replace Model="Mpv" if Make=="Mazda" & (strpos(Model,"Mpv")==1|strpos(Model,"Mpx")==1)
replace Model="Protege" if Make=="Mazda" & (strpos(Model,"Protege")==1|strpos(Model,"Protegé")==1|strpos(Model,"Protégé")==1) 
replace Model="Mazda B Series" if Make=="Mazda" & strpos(Model,"B")==1
replace Model="Mazda Cx Series" if Make=="Mazda" & strpos(Model,"Cx")==1
replace Model="Mx-5" if Make=="Mazda" & strpos(Model,"Mx-5")==1
replace Model="Mx-6" if Make=="Mazda" & strpos(Model,"Mx-6")==1
replace Model="Mazda Rx8" if Make=="Mazda" & strpos(Model,"Rx8")==1
replace Model="Tribute" if Make=="Mazda" & strpos(Model,"Tribute")==1
replace Model="Mazda3" if Make=="Mazda" & strpos(Model,"Mazda3")==1
replace Model="Mazda6" if Make=="Mazda" & strpos(Model,"Mazda6")==1
replace Model="Mazda5" if Make=="Mazda" & strpos(Model,"Mazda5")==1
replace Model="Mazdaspeed3" if Make=="Mazda" & strpos(Model,"Mazdaspeed3")==1
replace Model="Mazdaspeed6" if Make=="Mazda" & strpos(Model,"Mazdaspeed6")==1


** Mercedes **
replace Model="Clk Class" if Make=="Mercedes" & strpos(Model,"Clk")==1
replace Model="Cls Class" if Make=="Mercedes" & strpos(Model,"Cls")==1
replace Model="Cl Class" if Make=="Mercedes" & strpos(Model,"Cl")==1 & strpos(Model,"Clk")==0 & strpos(Model,"Cls")==0
replace Model="C Class" if Make=="Mercedes" & strpos(Model,"C")==1 & strpos(Model,"Cl")==0
replace Model="E Class" if Make=="Mercedes" & strpos(Model,"E")==1
replace Model="M Class" if Make=="Mercedes" & strpos(Model,"M")==1
replace Model="Slk Class" if Make=="Mercedes" & strpos(Model,"Slk")==1
replace Model="Slr Class" if Make=="Mercedes" & strpos(Model,"Slr")==1
replace Model="Sl Class" if Make=="Mercedes" & strpos(Model,"Sl")==1 & strpos(Model,"Slk")==0 & strpos(Model,"Slr")==0
replace Model="S Class" if Make=="Mercedes" & strpos(Model,"S")==1 & strpos(Model,"Sl")==0
replace Model="G Class" if Make=="Mercedes" & strpos(Model,"G")==1 & strpos(Model,"Gl")==0
replace Model="Gl Class" if Make=="Mercedes" & strpos(Model,"Gl")==1
replace Model="R Class" if Make=="Mercedes" & strpos(Model,"R")==1


** Mercury **
replace Model="Mountaineer" if Model=="97" & Make=="Mercury"
replace Submodel="SUV" if Make=="Mercury" & Submodel=="Mountaineer"
replace Model="Grand Marquis" if Make=="Mercury" & strpos(Model,"Grand")==1
replace Model="Sable" if Make=="Mercury" & strpos(Model,"Sable")==1
replace Model="Villager" if Make=="Mercury" & strpos(Model,"Villager")==1
replace Model="Cougar" if Make=="Mercury" & strpos(Model,"Cougar")==1
replace Model="Mariner" if Make=="Mercury" & strpos(Model,"Mariner")==1
replace Model="Milan" if Make=="Mercury" & strpos(Model,"Milan")==1
replace Model="Montego" if Make=="Mercury" & strpos(Model,"Montego")==1
replace Model="Monterey" if Make=="Mercury" & strpos(Model,"Monterey")==1
replace Model="Mountaineer" if Make=="Mercury" & strpos(Model,"Mountaineer")==1
replace Model="Tracer" if Make=="Mercury" & strpos(Model,"Tracer")==1
replace Model="Mystique" if Make=="Mercury" & strpos(Model,"Mystique")==1


** Mitsubishi **
replace Model="Mighty Max" if Model=="Mighty" & Make=="Mitsubishi"
replace Model="Eclipse" if Make=="Mitsubishi" & strpos(Model,"Eclipse")==1 
replace Model="Diamante" if Make=="Mitsubishi" & strpos(Model,"Diamante")==1 
replace Model="Galant" if Make=="Mitsubishi" & strpos(Model,"Galant")==1 
replace Model="Montero" if Make=="Mitsubishi" & strpos(Model,"Montero")==1 
replace Model="Endeavor" if Make=="Mitsubishi" & strpos(Model,"Endeavor")==1 
replace Model="Lancer" if Make=="Mitsubishi" & strpos(Model,"Lancer")==1 
replace Model="Galant" if Make=="Mitsubishi" & strpos(Model,"Galant")==1
replace Model="Outlander" if Make=="Mitsubishi" & strpos(Model,"Outlander")==1
replace Model="Sable" if Make=="Mitsubishi" & strpos(Model,"Sable")==1
replace Model="3000 Gt" if Make=="Mitsubishi" & (Model=="3000"|strpos(Model,"3000 Gt")==1)
replace Model="Mirage" if Make=="Mitsubishi" & strpos(Model,"Mirage")==1
replace Model="Raider" if Make=="Mitsubishi" & strpos(Model,"Raider")==1


** Nissan **
replace Model="Frontier" if Make=="Nissan" & strpos(Model,"Frontier")==1 
replace Model="Maxima" if Make=="Nissan" & strpos(Model,"Maxima")==1
replace Model="Altima" if Make=="Nissan" & strpos(Model,"Altima")==1
replace Model="Sentra" if Make=="Nissan" & strpos(Model,"Sentra")==1
replace Model="Maxima" if Make=="Nissan" & strpos(Model,"Maxima")==1
replace Model="Xterra" if Make=="Nissan" & strpos(Model,"Xterra")==1
replace Model="Pathfinder" if Make=="Nissan" & strpos(Model,"Pathfinder")==1
replace Model="Quest" if Make=="Nissan" & strpos(Model,"Quest")==1
replace Model="Nissan Kingcab" if Make=="Nissan" & (strpos(Model,"King Cab")==1|Model=="King")
replace Model="200Sx" if Make=="Nissan" & strpos(Model,"200Sx")==1
replace Model="350Z" if Make=="Nissan" & strpos(Model,"350Z")==1
replace Model="Armada" if Make=="Nissan" & strpos(Model,"Armada")==1
replace Model="Murano" if Make=="Nissan" & strpos(Model,"Murano")==1
replace Model="Nissan Rogue" if Make=="Nissan" & strpos(Model,"Rogue")==1
replace Model="Versa" if Make=="Nissan" & strpos(Model,"Versa")==1
replace Model="Titan" if Make=="Nissan" & strpos(Model,"Titan")==1
replace Model="Nissan Pickup" if Make=="Nissan" & strpos(Model,"Pickup")==1


** Oldsmobile **
replace Model="Ciera" if Make=="Oldsmobile" & Model=="Cutlass" & strpos(Submodel,"Ciera")!=0
replace Model="Alero" if Make=="Oldsmobile" & strpos(Model,"Alero")==1
replace Model="Achieva" if Make=="Oldsmobile" & strpos(Model,"Achieva")==1
replace Model="Aurora" if Make=="Oldsmobile" & strpos(Model,"Aurora")==1
replace Model="Cutlass Supreme" if Make=="Oldsmobile" & strpos(Model,"Cutlass Supreme")==1
replace Model="Cutlass" if Make=="Oldsmobile" & strpos(Model,"Cutlass")==1 & strpos(Model,"Supreme")==0
replace Model="Eighty-Eight" if Make=="Oldsmobile" & strpos(Model,"Eighty-Eight")==1
replace Model="Silhouette" if Make=="Oldsmobile" & strpos(Model,"Silhouette")==1
replace Model="Alero" if Make=="Oldsmobile" & strpos(Model,"Alero")==1
replace Model="Intrigue" if Make=="Oldsmobile" & strpos(Model,"Intrigue")==1


** Plymouth **
replace Model="Grand Voyager" if Make=="Plymouth" & Model=="Grand"
replace Model="Grand Voyager" if Make=="Plymouth" & strpos(Model,"Grand Voyager")==1
replace Model="Voyager" if Make=="Plymouth" & strpos(Model,"Voyager")==1
replace Model="Neon" if Make=="Plymouth" & strpos(Model,"Neon")==1

** Pontiac **
replace Model="Grand Am" if Make=="Pontiac" & Model=="Grand" & strpos(Submodel,"Am")==1
replace Model="Trans Am" if Make=="Pontiac" & (Model=="TransAm"|Submodel=="TransAm")
replace Model="Grand Prix" if Make=="Pontiac" & Model=="Grand" & strpos(Submodel,"Prix")==1
replace Model="Grand Prix" if Make=="Pontiac" & strpos(Submodel,"Grand Prix")==1
replace Model="Trans Sport" if Make=="Pontiac" & Model=="Trans"
replace Model="Bonneville" if Make=="Pontiac" & strpos(Model,"Bonneville")==1
replace Model="Aztec" if Make=="Pontiac" & strpos(Model,"Aztec")==1
replace Model="Pontiac G5" if Make=="Pontiac" & strpos(Model,"G5")==1
replace Model="Pontiac G6" if Make=="Pontiac" & strpos(Model,"G6")==1
replace Model="Pontiac G8" if Make=="Pontiac" & strpos(Model,"G8")==1
replace Model="Grand Am" if Make=="Pontiac" & strpos(Model,"Grand Am")==1
replace Model="Grand Prix" if Make=="Pontiac" & strpos(Model,"Grand Prix")==1
replace Model="Montana" if Make=="Pontiac" & strpos(Model,"Montana")==1
replace Model="Solstice" if Make=="Pontiac" & strpos(Model,"Solstice")==1
replace Model="Torrent" if Make=="Pontiac" & strpos(Model,"Torrent")==1
replace Model="Vibe" if Make=="Pontiac" & strpos(Model,"Vibe")==1
replace Model="Firebird" if Make=="Pontiac" & strpos(Model,"Firebird")==1
replace Model="Sunfire" if Make=="Pontiac" & strpos(Model,"Sunfire")==1


** Porsche **
replace Model="911 Carrera" if Make=="Porsche" & strpos(Model,"911 Carrera")==1
replace Model="Porsche 911" if Make=="Porsche" & strpos(Model,"911")==1
replace Model="Boxster" if Make=="Porsche" & (strpos(Model,"Boxster")==1|strpos(Model,"Boxter")==1)
replace Model="Cayenne" if Make=="Porsche" & strpos(Model,"Cayenne")==1
replace Model="Cayman" if Make=="Porsche" & strpos(Model,"Cayman")==1

** Rolls Royce **
replace Model="Phantom" if strpos(Make,"Rolls")==1 & strpos(Model,"Phantom")==1


** Saab **
replace Model="Saab 9-3" if Make=="Saab" & Model=="3-Sep"
replace Model="Saab 9-3" if Make=="Saab" & strpos(Model,"9-3")==1
replace Model="Saab 9-5" if Make=="Saab" & Model=="5-Sep"
replace Model="Saab 9-5" if Make=="Saab" & strpos(Model,"9-5")==1
replace Model="Saab 9-2X" if Make=="Saab" & strpos(Model,"9-2X")==1
replace Model="Saab 9-7X" if Make=="Saab" & strpos(Model,"9-7X")==1
replace Model="Saab 9000" if Make=="Saab" & strpos(Model,"9000")==1
replace Model="Saab 900" if Make=="Saab" & strpos(Model,"900")==1 & strpos(Model,"9000")==0


** Saturn **
replace Model="Saturn Ls" if Make=="Saturn" & Model=="Ls"
replace Model="Saturn Ls" if Make=="Saturn" & (strpos(Model,"L100")==1|strpos(Model,"L200")==1|strpos(Model,"L300")==1)
replace Model="Aura" if Make=="Saturn" & strpos(Model,"Aura")==1
replace Model="Saturn Ev1" if Make=="Saturn" & strpos(Model,"Ev1")==1
replace Model="Saturn Ion" if Make=="Saturn" & strpos(Model,"Ion")==1
replace Model="Outlook" if Make=="Saturn" & strpos(Model,"Outlook")==1
replace Model="Relay" if Make=="Saturn" & strpos(Model,"Relay")==1
replace Model="Saturn Sky" if Make=="Saturn" & strpos(Model,"Sky")==1
replace Model="Saturn Tc" if Make=="Saturn" & strpos(Model,"Tc")==1
replace Model="Saturn Vue" if Make=="Saturn" & strpos(Model,"Vue")==1

** Scion **
replace Model="Scion Tc" if Make=="Scion" & strpos(Model,"Tc")==1


** Subaru **
replace Model="Legacy" if Make=="Subaru" & strpos(Model,"Legacy")==1
replace Model="Impreza" if Make=="Subaru" & strpos(Model,"Impreza")==1
replace Model="Outback" if Make=="Subaru" & strpos(Model,"Outback")==1
replace Model="Forester" if Make=="Subaru" & strpos(Model,"Forester")==1
replace Model="B9 Tribeca" if Make=="Subaru" & strpos(Model,"B9 Tribeca")==1
replace Model="Baja" if Make=="Subaru" & strpos(Model,"Baja")==1
replace Model="Tribeca" if Make=="Subaru" & strpos(Model,"Tribeca")==1
replace Model="Svx" if Make=="Subaru" & strpos(Model,"Svx")==1


** Suzuki **
replace Model="Vitara" if Make=="Suzuki" & strpos(Model,"Vitara")==1
replace Model="Grand Vitara" if Make=="Suzuki" & strpos(Model,"Grand Vitara")==1
replace Model="Esteem" if Make=="Suzuki" & strpos(Model,"Esteem")==1
replace Model="Sidekick" if Make=="Suzuki" & strpos(Model,"Sidekick")==1
replace Model="Aerio" if Make=="Suzuki" & strpos(Model,"Aerio")==1
replace Model="Forenza" if Make=="Suzuki" & strpos(Model,"Forenza")==1
replace Model="Xl7" if Make=="Suzuki" & Model=="Premium" & ModelYear==2008
replace Model="Reno" if Make=="Suzuki" & strpos(Model,"Reno")==1
replace Model="Swift" if Make=="Suzuki" & strpos(Model,"Swift")==1
replace Model="Sidekick" if Make=="Suzuki" & strpos(Model,"Sidekick")==1
replace Model="Sx4" if Make=="Suzuki" & strpos(Model,"Sx4")==1
replace Model="Verona" if Make=="Suzuki" & strpos(Model,"Verona")==1
replace Model="Xl7" if Make=="Suzuki" & (strpos(Model,"Xl7")==1|strpos(Model,"Xl-7")==1)


** Toyota **
replace Model="Camry Solara" if Make=="Toyota" & strpos(Model,"Camry Solara")==1
replace Model="Camry" if Make=="Toyota" & strpos(Model,"Camry")==1 & strpos(Model,"Solara")==0
replace Model="Land Cruiser" if Make=="Toyota" & strpos(Model,"Land")==1
replace Model="Tacoma" if Make=="Toyota" & strpos(Model,"Tacoma")==1
replace Model="Xtracab" if Make=="Toyota" & strpos(Model,"Xtracab")==1
replace Model="Celica" if Make=="Toyota" & strpos(Model,"Celica")==1
replace Model="Corolla" if Make=="Toyota" & strpos(Model,"Corolla")==1
replace Model="T100" if Make=="Toyota" & strpos(Model,"T100")==1
replace Model="Tundra" if Make=="Toyota" & strpos(Model,"Tundra")==1
replace Model="4Runner" if Make=="Toyota" & strpos(Model,"4Runner")==1
replace Model="Avalon" if Make=="Toyota" & strpos(Model,"Avalon")==1
replace Model="Highlander" if Make=="Toyota" & strpos(Model,"Highlander")==1
replace Model="Martrix" if Make=="Toyota" & strpos(Model,"Martrix")==1
replace Model="Prius" if Make=="Toyota" & strpos(Model,"Prius")==1
replace Model="Previa" if Make=="Toyota" & strpos(Model,"Previa")==1
replace Model="Rav4" if Make=="Toyota" & strpos(Model,"Rav4")==1
replace Model="Sienna" if Make=="Toyota" & strpos(Model,"Sienna")==1
replace Model="Sequoia" if Make=="Toyota" & strpos(Model,"Sequoia")==1
replace Model="Supra" if Make=="Toyota" & strpos(Model,"Supra")==1
replace Model="Yaris" if Make=="Toyota" & strpos(Model,"Yaris")==1
replace Model="Tercel" if Make=="Toyota" & strpos(Model,"Tercel")==1
replace Model="Prerunner Xtracab" if Make=="Toyota" & strpos(Model,"Prerunner Xtracab")==1


** Volkswagen **
replace Model="Golf" if Make=="Volkswagen" & strpos(Model,"Golf")!=0
replace Model="Jetta" if Make=="Volkswagen" & strpos(Model,"Jetta")!=0
replace Model="Passat" if Make=="Volkswagen" & strpos(Model,"Passat")==1
replace Model="Volkswagen Cabriolet" if Make=="Volkswagen" & Model=="Cabriolet"
replace Model="Beetle" if Make=="Volkswagen" & strpos(Model,"Beetle")==1 
replace Model="Cabrio" if Make=="Volkswagen" & strpos(Model,"Cabrio")==1 & strpos(Model,"Cabriolet")==0
replace Model="Eurovan" if Make=="Volkswagen" & strpos(Model,"Eurovan")==1
replace Model="Gti" if Make=="Volkswagen" & strpos(Model,"Gti")==1
replace Model="Eos" if Make=="Volkswagen" & strpos(Model,"Eos")==1
replace Model="Phaeton" if Make=="Volkswagen" & strpos(Model,"Phaeton")==1
replace Model="Rabbit" if Make=="Volkswagen" & strpos(Model,"Rabbit")==1
replace Model="Vw R32" if Make=="Volkswagen" & strpos(Model,"R32")==1
replace Model="Touareg" if Make=="Volkswagen" & (strpos(Model,"Touareg")==1|strpos(Model,"Tourag")==1)


** Volvo **
replace Model="Volvo 850" if Make=="Volvo" & strpos(Model,"850")==1
replace Model="Volvo 960" if Make=="Volvo" & strpos(Model,"960")==1
replace Model="Volvo 70 Series" if Make=="Volvo" & ( strpos(Model,"S70")==1 | strpos(Model,"C70")==1 | strpos(Model,"V70")==1)
replace Model="Volvo 80 Series" if Make=="Volvo" & strpos(Model,"S80")==1
replace Model="Volvo 60 Series" if Make=="Volvo" & strpos(Model,"S60")==1
replace Model="Volvo 40 Series" if Make=="Volvo" & ( strpos(Model,"S40")==1 | strpos(Model,"V40")==1 )
replace Model="Volvo 90 Series" if Make=="Volvo" & ( strpos(Model,"S90")==1 | strpos(Model,"V90")==1 )
replace Model="Volvo 30 Series" if Make=="Volvo" & strpos(Model,"C30")==1
replace Model="Volvo 50 Series" if Make=="Volvo" & strpos(Model,"V50")==1
replace Model="Volvo Xc70" if Make=="Volvo" & strpos(Model,"Xc70")==1
replace Model="Volvo Xc90" if Make=="Volvo" & strpos(Model,"Xc90")==1
