/* CleanEPANames.do */


replace Make= proper(trim(Make))
replace Model= proper(trim(Model))
replace Model= subinstr(Model,"*","",.)

** Generate Original Model to be used in the submodel routine
gen OModel = Model 

** Acura **
replace Model="Acura Cl" if Make=="Acura" & strpos(Model,"Cl")!=0
replace Model="Acura Tl" if Make=="Acura" & strpos(Model,"Tl")!=0
replace Model="Acura Rl" if Make=="Acura" & strpos(Model,"Rl")!=0
replace Model="Acura Integra" if Make=="Acura" & strpos(Model,"Integra")==1
replace Model="Acura Legend" if Make=="Acura" & strpos(Model,"Legend")==1
replace Model="Acura Mdx" if Make=="Acura" & strpos(Model,"Mdx")==1
replace Model="Acura Nsx" if Make=="Acura" & strpos(Model,"Nsx")==1
replace Model="Acura Rdx" if Make=="Acura" & strpos(Model,"Rdx")==1
replace Model="Acura Rsx" if Make=="Acura" & strpos(Model,"Rsx")==1
replace Model="Acura Slx" if Make=="Acura" & strpos(Model,"Slx")==1
replace Model="Acura Tsx" if Make=="Acura" & strpos(Model,"Tsx")==1
replace Model="Acura Vigor" if Make=="Acura" & strpos(Model,"Vigor")==1


** Alfa Romeo **
replace Model="Alfa Romeo 164" if Make=="Alfa Romeo" & strpos(Model,"164")==1
replace Model="Alfa Romeo Alfetta" if (Make==""|Make=="Alfa Romeo") & strpos(Model,"Alfetta")==1
replace Model="Alfa Romeo Gtv" if (Make==""|Make=="Alfa Romeo") & strpos(Model,"Gtv")==1
replace Model="Alfa Romeo Milano" if (Make=="Alfa Romeo") & strpos(Model,"Milano")==1
replace Model="Alfa Romeo Spider" if (Make=="Alfa Romeo") & strpos(Model,"Spider")==1
replace Model="Alfa Romeo Spider" if (Make==""|Make=="Alfa Romeo") & (strpos(Model,"2000 Spider")==1|strpos(Model,"Spider 2000")==1|strpos(Model,"Spider Veloce")==1)
replace Model="Alfa Romeo Sprint Veloce" if (Make=="") & strpos(Model,"Sprint Veloce")==1
replace Model="Alfa Romeo Gtv" if (Make=="Alfa Romeo") & strpos(Model,"Gt V6")==1
replace Model="Alfa Romeo Alfa 6" if Model=="Alfa 6"


** Amc/Eagle **
replace Model="Amc Concord" if Make=="" & strpos(Model,"Concord")==1 & strpos(Model,"Concorde")==0
replace Model="Amc Eagle" if (Make==""|strpos(Make,"Am")==1|strpos(Model,"Federal")==1) & strpos(Model,"Eagle")==1 & strpos(Model,"Talon")==0
replace Model="Eagle Kammback" if strpos(Model,"Eagle: Kam")==1
replace Model="Amc Gremlin" if strpos(Model,"Gremlin")==1
replace Model="Amc Hornet" if strpos(Model,"Hornet")==1
replace Model="Amc Matador" if (Make==""|strpos(Make,"Am")==1) & strpos(Model,"Matador")==1
replace Model="Eagle Medallion" if Make=="Eagle" & strpos(Model,"Medallion")==1
replace Model="Amc Pacer" if (Make==""|strpos(Make,"Am")==1) & strpos(Model,"Pacer")==1
replace Model="Eagle Premier" if (strpos(Make,"Eagle")==1) & strpos(Model,"Premier")==1
replace Model="Eagle Summit" if (strpos(Make,"Eagle")==1) & strpos(Model,"Summit")==1
replace Model="Eagle Talon" if (strpos(Make,"Eagle")==1) & strpos(Model,"Talon")==1
replace Model="Eagle Vision" if (strpos(Make,"Eagle")==1) & strpos(Model,"Vision")==1
replace Model="Eagle Wagon" if (strpos(Make,"Eagle")==1) & strpos(Model,"Wagon")==1
** Additional for CARLIN
replace Model="Amc Concord" if strpos(Model,"Concord")==1 & VClass!="" & strpos(Model,"Concorde")==0


** Am General **
replace Model="Am General P/O Vehicle" if (Make=="Am General"|Make=="A M General") & strpos(Model,"Post Office")==1
replace Model="Am General Dj P/O Vehicle" if (Make=="Am General"|Make=="") & (strpos(Model,"Dj Po")==1|strpos(Model,"Dj Post Office")==1)


** Aston Martin **
replace Model="Aston Martin" if (Make==""|Make=="Aston Martin") & strpos(Model,"Aston Martin")==1
replace Model="Aston Martin Lagonda" if (Make==""|strpos(Make,"Aston Martin")==1) & strpos(Model,"Lagonda")==1
replace Model="Aston Martin Saloon/Vantage/Volante" if (Make==""|strpos(Make,"Aston Martin")==1) & strpos(Model,"Saloon/Vantage/Volante")==1
replace Model="Aston Martin V8" if (Make=="Aston Martin") & strpos(Model,"V8")!=0
replace Model="Aston Martin Vanquish" if (Make=="Aston Martin") & strpos(Model,"Vanquish")!=0
replace Model="Aston Martin Virage" if (Make=="Aston Martin") & strpos(Model,"Virage")!=0
replace Model="Aston Martin DB7" if (Make=="Aston Martin") & (strpos(Model,"Db-7")!=0|strpos(Model,"Db7")!=0)
replace Model="Aston Martin DB9" if (Make=="Aston Martin") & (strpos(Model,"Db-9")!=0|strpos(Model,"Db9")!=0)
replace Model="Aston Martin DB AR1" if Make=="Aston Martin" & Model == "Db Ar1"

** Grouping
* replace Model="Aston Martin" if strpos(Model,"Aston Martin")==1


** Avanti **
replace Model="Avanti Ii" if (Make==""|strpos(Make,"Avanti")==1) & strpos(Model,"Avanti Ii")==1


** Audi **
replace Model="Audi 80" if Make=="Audi" & strpos(Model,"80")==1 & strpos(Model,"90")==0
replace Model="Audi 80/90" if Make=="Audi" & strpos(Model,"80")==1 & strpos(Model,"90")!=0
replace Model="Audi 90" if Make=="Audi" & strpos(Model,"90")==1
replace Model="Audi 100" if Make=="Audi" & strpos(Model,"100")==1
replace Model="Audi 200" if Make=="Audi" & strpos(Model,"200")==1
replace Model="Audi 4000" if (Make==""|Make=="Audi") & strpos(Model,"4000")==1
replace Model="Audi 4000" if (Make=="Audi") & Model=="4" & ModelYear==1984
replace Model="Audi 5000" if (Make==""|Make=="Audi") & strpos(Model,"5000")==1
replace Model="Audi 5000" if (Make=="Audi") & Model=="5" & ModelYear==1984
replace Model="Audi A3" if (Make=="Audi") & strpos(Model,"A3")==1
replace Model="Audi A4" if (Make=="Audi") & strpos(Model,"A4")==1
replace Model="Audi A5" if (Make=="Audi") & strpos(Model,"A5")==1
replace Model="Audi A6" if (Make=="Audi") & strpos(Model,"A6")==1
replace Model="Audi A8" if (Make=="Audi") & strpos(Model,"A8")==1
replace Model="Audi Allroad" if (Make=="Audi") & strpos(Model,"Allroad")==1
replace Model="Audi R8" if (Make=="Audi") & strpos(Model,"R8")==1
replace Model="Audi Cabriolet" if (Make=="Audi") & strpos(Model,"Cabriolet")==1
replace Model="Audi Coupe Gt" if (Make=="Audi") & strpos(Model,"Coupe Gt")==1
replace Model="Audi Coupe Quattro" if (Make=="Audi") & strpos(Model,"Coupe Quattro")==1
replace Model="Audi Fox" if (Make=="Audi") & strpos(Model,"Fox")==1
replace Model="Audi Q7" if (Make=="Audi") & strpos(Model,"Q7")==1
replace Model="Audi Quattro" if (Make==""|Make=="Audi") & Model=="Quattro"
replace Model="Audi Rs4" if (Make=="Audi") & strpos(Model,"Rs4")==1
replace Model="Audi Rs6" if (Make=="Audi") & strpos(Model,"Rs6")==1
replace Model="Audi S4" if (Make=="Audi") & strpos(Model,"S4")==1
replace Model="Audi S5" if (Make=="Audi") & strpos(Model,"S5")==1
replace Model="Audi S6" if (Make=="Audi") & strpos(Model,"S6")==1
replace Model="Audi S8" if (Make=="Audi") & strpos(Model,"S8")==1
replace Model="Audi Tt" if (Make=="Audi") & strpos(Model,"Tt")==1
replace Model="Audi V8" if (Make=="Audi") & strpos(Model,"V8")==1


** Bentley **
replace Model="Bentley Azure" if (Make=="Bentley"|Make=="Rolls-Royce") & strpos(Model,"Azure")==1
replace Model="Bentley Arnage" if (Make=="Bentley") & strpos(Model,"Arnage")==1
replace Model="Bentley Brooklands" if (Make=="Bentley"|Make=="Rolls-Royce") & strpos(Model,"Brooklands")==1
replace Model="Rolls-Royce Camargue" if (Make==""|strpos(Make,"Rolls-Royce")==1) & strpos(Model,"Camargue")==1
replace Model="Bentley Continental" if (Make=="Bentley"|Make=="Rolls-Royce") & strpos(Model,"Continental")==1
replace Model="Rolls-Royce Corniche" if (Make==""|Make=="Rolls-Royce"|Make=="Bentley") & strpos(Model,"Corniche")==1 & strpos(Model,"Continental")==0
replace Model="Rolls-Royce Corniche/Continental" if (Make==""|Make=="Rolls-Royce"|Make=="Bentley") & strpos(Model,"Corniche")==1 & strpos(Model,"Continental")!=0
replace Model="Bentley Eight/Mulsanne" if (Make=="Rolls-Royce") & strpos(Model,"Eight/Mulsan")==1
replace Model="Bentley Silver/Mulsanne" if strpos(Model,"Silver Spirit/Spur/Mulsanne")==1
replace Model="Bentley Turbo R" if (Make=="Bentley"|Make=="Rolls-Royce")& strpos(Model,"Turbo R")==1 & strpos(Model,"Rt")==0

replace Model="Rolls-Royce Phantom" if (Make=="Rolls-Royce") & strpos(Model,"Phantom")==1
replace Model="Bentley Turbo Rt" if (Make=="Bentley"|Make=="Rolls-Royce") & strpos(Model,"Turbo Rt")==1
replace Model="Rolls-Royce Flying Spur" if (Make=="Bentley"|Make=="Rolls-Royce") & strpos(Model,"Flying Spur")==1
replace Model="Rolls-Royce Limousine" if (Make=="Bentley"|Make=="Rolls-Royce") & strpos(Model,"Limousine")==1
replace Model="Rolls-Royce Silver Series" if (strpos(Make,"Rolls-Royce")==1) & strpos(Model,"Silver")==1
replace Model="Rolls-Royce Silver Series" if Make=="" & strpos(Model,"Silver Spirit/Spur")==1

* This needs to go last because some Park Wards are Silver Spur Park Ward
replace Model="Rolls-Royce Park Ward" if (Make=="Rolls-Royce") & strpos(Model,"Park Ward")==1


** Bertone **
replace Model="Bertone X1/9" if (Make=="Bertone") & strpos(Model,"X1/9")==1
replace Model="Bertone Pininfarina" if (Make=="Pininfarina") & strpos(Model,"Pininfarina")==1


** Bmw **
replace Model="Bmw M" if (Make=="Bmw") & (Model=="M Coupe"|Model=="M Roadster")
replace Model="Bmw M3" if (Make=="Bmw") & strpos(Model,"M3")==1
replace Model="Bmw M5" if (Make=="Bmw") & strpos(Model,"M5")==1
replace Model="Bmw M6" if (Make=="Bmw") & strpos(Model,"M6")==1
replace Model="Bmw X3" if (Make=="Bmw") & strpos(Model,"X3")==1
replace Model="Bmw X5" if (Make=="Bmw") & strpos(Model,"X5")==1
replace Model="Bmw X6" if (Make=="Bmw") & strpos(Model,"X6")==1
replace Model="Bmw Z3" if (Make=="Bmw") & strpos(Model,"Z3")==1
replace Model="Bmw Z4" if (Make=="Bmw") & strpos(Model,"Z4")==1
replace Model="Bmw Z8" if (Make=="Bmw") & strpos(Model,"Z8")==1
replace Model="Bmw 3 Series" if (Make=="Bmw") & (strpos(Model,"3 Series")==1|strpos(Model,"3-Series")==1)
replace Model="Bmw 3 Series" if (Make=="Bmw") & strpos(Model,"3")==1
replace Model="Bmw 3 Series" if (Make=="") & (strpos(Model,"320 I")==1|strpos(Model,"320I")==1)
replace Model="Bmw 5 Series" if (Make=="Bmw") & (strpos(Model,"5 Series")==1|strpos(Model,"5-Series")==1)
replace Model="Bmw 5 Series" if (Make=="Bmw") & strpos(Model,"5")==1
replace Model="Bmw 5 Series" if (Make=="") & (strpos(Model,"528 E")==1|strpos(Model,"528E")==1|strpos(Model,"528 I")==1|strpos(Model,"530 I")==1)
replace Model="Bmw 6 Series" if (Make=="Bmw") & (strpos(Model,"6 Series")==1|strpos(Model,"6-Series")==1)
replace Model="Bmw 6 Series" if (Make=="Bmw") & strpos(Model,"6")==1
replace Model="Bmw 6 Series" if (Make=="") & (strpos(Model,"633 Csi")==1|strpos(Model,"633Csi")==1)
replace Model="Bmw 7 Series" if (Make=="Bmw") & (strpos(Model,"7 Series")==1|strpos(Model,"7-Series")==1)
replace Model="Bmw 7 Series" if (Make=="Bmw") & strpos(Model,"7")==1
replace Model="Bmw 7 Series" if (Make=="") & (strpos(Model,"733 I")==1)
replace Model="Bmw 8 Series" if (Make=="Bmw") & (strpos(Model,"8")==1)
replace Model="Bmw Alpina B7" if (Make=="Bmw Alpina") & (strpos(Model,"B7")==1)
replace Model="Bmw 2002" if (Make=="Bmw") & (strpos(Model,"2002")==1)
replace Model="Bmw 128/135" if (Make=="Bmw") & (strpos(Model,"128")==1|strpos(Model,"135")==1)

** Now get more defined model names post-1989. Must do this after.
foreach model in 318 323 325 328 330 335 525 528 530 535 540 545 550 635 645 650 735 740 745 750 760 840 850 {
replace Model="Bmw `model'" if Make=="Bmw" & strpos(OModel,"`model'")==1&ModelYear>=1989
}


** Buick **
replace Model="Buick Apollo" if (Make=="Buick") & strpos(Model,"Apollo")==1
replace Model="Buick Century" if (Make==""|Make=="Buick") & strpos(Model,"Century")==1  & strpos(Model,"Regal")==0
replace Model="Buick Century/Regal" if (Make==""|Make=="Buick") & strpos(Model,"Century")==1  & strpos(Model,"Regal")!=0
replace Model="Buick Electra" if (Make==""|Make=="Buick") & strpos(Model,"Electra")==1 & strpos(Model,"Park Avenue")==0 
replace Model="Buick Electra/Park Avenue" if (Make==""|Make=="Buick") & strpos(Model,"Electra")==1 & strpos(Model,"Park Avenue")!=0
replace Model="Buick Enclave" if (Make=="Buick") & strpos(Model,"Enclave")==1 
replace Model="Buick Estate Wagon" if (Make==""|Make=="Buick") & strpos(Model,"Estate Wagon")==1 
replace Model="Buick Lacrosse/Allure" if (Make=="Buick") & strpos(Model,"Lacrosse/Allure")==1
replace Model="Buick Lesabre" if (Make==""|Make=="Buick") & strpos(Model,"Lesabre")==1 & strpos(Model,"Electra")==0
replace Model="Buick Lesabre/Electra" if (Make==""|Make=="Buick") & strpos(Model,"Lesabre")==1 & strpos(Model,"Electra")!=0
replace Model="Buick Lucerne" if (Make=="Buick") & strpos(Model,"Lucerne")==1
replace Model="Buick Park Avenue" if (Make=="Buick") & strpos(Model,"Park Avenue")==1
replace Model="Buick Rainier" if (Make=="Buick") & strpos(Model,"Rainier")==1
replace Model="Buick Reatta" if (Make=="Buick") & strpos(Model,"Reatta")==1
replace Model="Buick Regal" if (Make==""|Make=="Buick") & strpos(Model,"Regal")==1 & strpos(Model,"Century")==0
replace Model="Buick Regal/Century" if (Make==""|Make=="Buick") & strpos(Model,"Regal")==1 & strpos(Model,"Century")!=0
replace Model="Buick Rendezvous" if (Make=="Buick") & strpos(Model,"Rendezvous")==1
replace Model="Buick Riviera" if (Make==""|Make=="Buick") & strpos(Model,"Riviera")==1
replace Model="Buick Roadmaster" if (Make=="Buick") & strpos(Model,"Roadmaster")==1
replace Model="Buick Skyhawk" if (Make==""|Make=="Buick") & strpos(Model,"Skyhawk")==1
replace Model="Buick Skylark" if (Make==""|Make=="Buick") & strpos(Model,"Skylark")==1
replace Model="Buick Somerset Regal" if (Make=="Buick") & strpos(Model,"Somerset Regal")==1
replace Model="Buick Somerset/Skylark" if (Make=="Buick") & strpos(Model,"Somerset/Skylark")==1
replace Model="Buick Terraza" if (Make=="Buick") & strpos(Model,"Terraza")==1


** Cadillac **
replace Model="Cadillac Allante" if Make=="Cadillac" & strpos(Model,"Allante")==1
replace Model="Cadillac Deville" if Make=="Cadillac" & strpos(Model,"Deville")!=0 & strpos(Model,"Fleet")==0 & strpos(Model,"Brough")==0 & strpos(Model,"Concour")==0
replace Model="Cadillac Fleetwood/Deville" if Make=="Cadillac" & strpos(Model,"Deville")!=0 & strpos(Model,"Fleetwood")!=0
replace Model="Cadillac Deville/Brougham" if (Make==""|Make=="Cadillac") & strpos(Model,"Deville")!=0 & strpos(Model,"Brougham")!=0
replace Model="Cadillac Deville/Concours" if Make=="Cadillac" & strpos(Model,"Deville")!=0 & strpos(Model,"Concours")!=0
replace Model="Cadillac Dts" if Make=="Cadillac" & strpos(Model,"Dts")!=0
replace Model="Cadillac Brougham" if Make=="Cadillac" & strpos(Model,"Brougham")==1 & strpos(Model,"Deville")==0
replace Model="Cadillac Catera" if (Make=="Cadillac") & strpos(Model,"Catera")==1
replace Model="Cadillac Commercial Chassis" if (Make=="Cadillac") & strpos(Model,"Commercial Chassis")==1
replace Model="Cadillac Cimarron" if (Make==""|Make=="Cadillac") & strpos(Model,"Cimarron")==1
replace Model="Cadillac Cts" if (Make=="Cadillac") & strpos(Model,"Cts")==1
replace Model="Cadillac Eldorado" if (Make==""|Make=="Cadillac") & strpos(Model,"Eldorado")==1
replace Model="Cadillac Escalade" if (Make=="Cadillac") & strpos(Model,"Escalade")==1
replace Model="Cadillac Fleetwood" if (Make=="Cadillac") & strpos(Model,"Fleetwood")==1 & strpos(Model,"Deville")==0 & strpos(Model,"75")==0 & strpos(Model,"Brougham")==0
replace Model="Cadillac Fleetwood 75" if (Make=="Cadillac") & strpos(Model,"Fleetwood")==1 & strpos(Model,"75")!=0
replace Model="Cadillac Brougham" if (Make=="Cadillac") & strpos(Model,"Fleetwood")==1 & strpos(Model,"Brougham")!=0
replace Model="Cadillac Limousine" if (Make==""|Make=="Cadillac") & strpos(Model,"Limousine")==1
replace Model="Cadillac Seville" if (Make==""|Make=="Cadillac") & strpos(Model,"Seville")==1
replace Model="Cadillac Srx" if (Make=="Cadillac") & strpos(Model,"Srx")==1
replace Model="Cadillac Sts" if (Make=="Cadillac") & strpos(Model,"Sts")==1
replace Model="Cadillac Xlr" if (Make=="Cadillac") & strpos(Model,"Xlr")==1

replace Model="Cadillac Hearse" if Make=="Cadillac" & strpos(Model,"Hearse")!=0

** Chevrolet **
replace Model="Chevrolet Astro" if Make=="Chevrolet" & strpos(Model,"Astro")==1
replace Model="Chevrolet Aveo" if Make=="Chevrolet" & strpos(Model,"Aveo")==1
replace Model="Chevrolet Avalanche" if Make=="Chevrolet" & strpos(Model,"Avalanche")==1
replace Model="Chevrolet Beretta" if Make=="Chevrolet" & strpos(Model,"Beretta")==1
replace Model="Chevrolet Blazer" if (Make==""|Make=="Chevrolet") & strpos(Model,"Blazer")!=0 & strpos(Model,"Trail")==0
replace Model="Chevrolet/Gmc Suburban" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & strpos(Model,"Suburban")!=0
replace Model="Chevrolet Trailblazer" if Make=="Chevrolet" & strpos(Model,"Trailblazer")!=0
replace Model="Chevrolet S10/T10" if (Make==""|Make=="Chevrolet") & (strpos(Model,"S10")==1|strpos(Model,"T10")==1) & strpos(Model,"Blazer")==0 & strpos(Model,"100")==0
replace Model="Chevrolet S10/T10" if (Make=="Chevrolet") & (Model=="S1"|Model=="T1") & ModelYear==1984
replace Model="Chevrolet/Gmc C Series" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & (strpos(Model,"C10")==1|strpos(Model,"C15")==1|strpos(Model,"C20")==1|strpos(Model,"C25")==1) & strpos(Model,"Blazer")==0 & strpos(Model,"Jimmy")==0 & strpos(Model,"Suburban")==0 & strpos(Model,"Sierra")==0
replace Model="Chevrolet/Gmc C Series" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & (Model=="C1"|Model=="C15"|Model=="C2"|Model=="C25")
replace Model="Chevrolet/Gmc V Series" if (Make=="Chevrolet"|Make=="Gmc") & (strpos(Model,"V10")==1|strpos(Model,"V15")==1|strpos(Model,"V20")==1|strpos(Model,"V25")==1) & strpos(Model,"Blazer")==0 & strpos(Model,"Jimmy")==0 & strpos(Model,"Suburban")==0 & strpos(Model,"Sierra")==0
replace Model="Chevrolet/Gmc R Series" if (Make=="Chevrolet"|Make=="Gmc") & (strpos(Model,"R10")==1|strpos(Model,"R15")==1|strpos(Model,"R20")==1|strpos(Model,"R25")==1) & strpos(Model,"Blazer")==0 & strpos(Model,"Jimmy")==0 & strpos(Model,"Suburban")==0 & strpos(Model,"Sierra")==0
replace Model="Chevrolet Camaro" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Camaro")==1
replace Model="Chevrolet Chevelle" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Chevelle")==1
replace Model="Chevrolet Impala/Caprice" if (Make==""|Make=="Chevrolet") & strpos(Model,"Impala")!=0 | strpos(Model,"Caprice")!=0
replace Model="Chevrolet Cavalier" if (Make==""|Make=="Chevrolet") & strpos(Model,"Cavalier")==1
replace Model="Chevrolet Celebrity" if (Make==""|Make=="Chevrolet") & strpos(Model,"Celebrity")==1
replace Model="Chevy Van" if (Make==""|Make=="Chevrolet") & strpos(Model,"Chev. Van")==1
replace Model="Chevrolet Chevette" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Chevette")==1
replace Model="Chevrolet Citation" if (Make==""|Make=="Chevrolet") & strpos(Model,"Citation")==1 & strpos(Model,"Ii")==0
replace Model="Chevrolet Citation Ii" if (Make==""|Make=="Chevrolet") & strpos(Model,"Citation")==1 & strpos(Model,"Ii")!=0
replace Model="Chevrolet Classic" if (Make=="Chevrolet") & strpos(Model,"Classic")==1
replace Model="Chevrolet Cobalt" if (Make=="Chevrolet") & strpos(Model,"Cobalt")==1
replace Model="Chevrolet Colorado" if (Make=="Chevrolet") & strpos(Model,"Colorado")==1
replace Model="Chevrolet Corsica" if (Make=="Chevrolet") & strpos(Model,"Corsica")==1
replace Model="Chevrolet Corvette" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & (strpos(Model,"Corvette")==1|strpos(Model,"Twin-Turbo Corvette")==1)
replace Model="Chevrolet El Camino" if (Make==""|Make=="Chevrolet") & strpos(Model,"El Camino")==1
replace Model="Chevrolet Epica" if (Make=="Chevrolet") & strpos(Model,"Epica")==1
replace Model="Chevrolet Equinox" if (Make=="Chevrolet") & strpos(Model,"Equinox")==1
replace Model="Chevrolet Express" if (Make=="Chevrolet") & strpos(Model,"Express")==1
replace Model="Chevrolet/Gmc G Series" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & ((strpos(Model,"G10")==1|strpos(Model,"G15")==1|strpos(Model,"G30")==1|strpos(Model,"G35")==1) | strpos(Model,"Sport Van G")==1)
replace Model="Chevrolet/Gmc G Series" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & (Model=="G1"|Model=="G3")
replace Model="Gmc Vandura" if (Make==""|Make=="Gmc") & strpos(Model,"Vandura")!=0
replace Model="Gmc Rally" if (Make==""|Make=="Gmc") & strpos(Model,"Rally")!=0
replace Model="Chevrolet Hhr" if (Make=="Chevrolet") & strpos(Model,"Hhr")==1
replace Model="Chevrolet/Gmc K Series" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & (strpos(Model,"K10")==1|strpos(Model,"K15")==1|strpos(Model,"K1500")==1|strpos(Model,"K20")==1|strpos(Model,"K25")==1|strpos(Model,"K2500")==1) & strpos(Model,"Blazer")==0 & strpos(Model,"Jimmy")==0 & strpos(Model,"Suburban")==0 & strpos(Model,"Sierra")==0
replace Model="Chevrolet/Gmc K Series" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & (Model=="K1"|Model=="K2")


replace Model="Chevrolet Lumina/Monte Carlo" if (Make=="Chevrolet") & (strpos(Model,"Lumina")!=0 | strpos(Model,"Monte Carlo")!=0)
replace Model="Chevrolet Lumina/Apv Minivan" if (Make=="Chevrolet") & (strpos(OModel,"Lumina Minivan")!=0 | strpos(OModel,"Apv")!=0)


replace Model="Chevrolet Luv" if (Make==""|Make=="Chevrolet") & strpos(Model,"Luv")==1
replace Model="Chevrolet Malibu" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Malibu")==1
replace Model="Chevrolet Metro" if (Make=="Chevrolet") & strpos(Model,"Metro")==1
replace Model="Chevrolet Monte Carlo" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Monte Carlo")==1
replace Model="Chevrolet Monza" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Monza")==1
replace Model="Chevrolet Nova" if (Make==""|Make=="Chevrolet"|strpos(Make,"Vega")==1) & strpos(Model,"Nova")==1
replace Model="Chevrolet Optra" if (Make=="Chevrolet") & strpos(Model,"Optra")==1
replace Model="Chevrolet/Gmc Pickup" if (Make==""|Make=="Chevrolet"|Make=="Gmc") & (strpos(Model,"Pickup")==1|strpos(Model,"Gmc Pickup")==1|strpos(Model,"Chev. Pickup")==1)
replace Model="Chevrolet Postal Cab" if (Make=="Chevrolet") & strpos(Model,"Postal Cab")==1
replace Model="Chevrolet Prizm" if (Make=="Chevrolet") & strpos(Model,"Prizm")==1
replace Model="Chevrolet Silverado" if (Make=="Chevrolet") & strpos(Model,"Silverado")==1
replace Model="Chevrolet Spectrum" if (Make=="Chevrolet") & strpos(Model,"Spectrum")==1
* replace Model="Chevrolet Sport Van" if (Make=="Chevrolet") & strpos(Model,"Sport Van")==1
replace Model="Gmc Sprint" if (Make=="Gmc") & (strpos(Model,"Sprint")==1|strpos(Model,"Turbo Sprint")==1)
replace Model="Chevrolet Sprint" if (Make=="Chevrolet") & (strpos(Model,"Sprint")==1|strpos(Model,"Turbo Sprint")==1)
replace Model="Chevrolet Ssr" if (Make=="Chevrolet") & strpos(Model,"Ssr")==1
replace Model="Chevrolet Tahoe" if (Make=="Chevrolet") & strpos(Model,"Tahoe")==1
replace Model="Chevrolet Tracker" if (Make=="Chevrolet") & strpos(Model,"Tracker")==1
replace Model="Chevrolet Uplander" if (Make=="Chevrolet") & strpos(Model,"Uplander")==1
replace Model="Gmc Van" if (Make=="Gmc") & (strpos(Model,"Van")==1|strpos(Model,"Gmc Van")==1) & strpos(Model,"Vandura")==0
replace Model="Chevrolet Vega" if (Make=="Chevrolet") & strpos(Model,"Vega")==1
replace Model="Chevrolet Venture" if (Make=="Chevrolet") & strpos(Model,"Venture")==1
replace Model="Chevrolet Wagon" if strpos(Model,"Chevrolet Wagon")==1
** Additional for CARLIN
replace Model="Chevrolet Malibu" if strpos(Model,"Malibu")==1 & VClass!=""

** Chrysler **
replace Model="Chrysler 300" if Make=="Chrysler" & strpos(Model,"300")==1
replace Model="Chrysler Aspen" if Make=="Chrysler" & strpos(Model,"Aspen")==1 & ModelYear>2006
replace Model="Chrysler Cirrus" if Make=="Chrysler" & strpos(Model,"Cirrus")==1
replace Model="Chrysler Concorde" if Make=="Chrysler" & strpos(Model,"Concorde")==1 & strpos(Model,"Lhs")==0
replace Model="Chrysler Concorde/Lhs" if Make=="Chrysler" & strpos(Model,"Concorde")==1 & strpos(Model,"Lhs")!=0
replace Model="Chrysler Conquest" if Make=="Chrysler" & strpos(Model,"Conquest")==1
replace Model="Chrysler Cordoba" if (Make==""|Make=="Chrysler") & strpos(Model,"Cordoba")==1 & strpos(Model,"300")==0
replace Model="Chrysler Cordoba/300" if (Make==""|Make=="Chrysler") & strpos(Model,"Cordoba")==1 & strpos(Model,"300")!=0
replace Model="Chrysler Crossfire" if Make=="Chrysler" & strpos(Model,"Crossfire")==1
replace Model="Chrysler E Class/New Yorker" if (Make==""|Make=="Chrysler") & strpos(Model,"E Class/New Yorker")==1
replace Model="Chrysler Executive" if strpos(Model,"Chrysler Executive")==1
replace Model="Chrysler Executive/Limousine" if Make=="Chrysler" & strpos(Model,"Executive")==1
replace Model="Chrysler Fifth Avenue" if (Make==""|Make=="Chrysler") & strpos(Model,"Fifth Avenue")==1 & strpos(Model,"Imperial")==0
replace Model="Chrysler Fifth Avenue/Imperial" if (Make==""|Make=="Chrysler") & strpos(Model,"Fifth Avenue")==1 & strpos(Model,"Imperial")!=0
replace Model="Chrysler Imperial" if (Make==""|Make=="Chrysler") & strpos(Model,"Imperial")==1 
replace Model="Chrysler Jx/Jxi/Convertible" if (Make=="Chrysler") & strpos(Model,"Jx/Jxi/Limited Convertible")==1 
replace Model="Chrysler Laser" if (Make=="Chrysler") & strpos(Model,"Laser")==1 & strpos(Model,"Daytona")==0
replace Model="Chrysler Laser/Daytona" if (Make=="Chrysler") & strpos(Model,"Laser")==1 & strpos(Model,"Daytona")!=0
replace Model="Chrysler Lebaron" if (Make==""|Make=="Chrysler") & strpos(Model,"Lebaron")==1
replace Model="Chrysler Lhs" if (Make=="Chrysler") & strpos(Model,"Lhs")==1 
replace Model="Chrysler New Yorker" if (Make==""|Make=="Chrysler") & strpos(Model,"New Yorker")==1 & strpos(Model,"Avenue")==0 & strpos(Model,"Imperial")==0
replace Model="Chrysler New Yorker/Fifth Avenue" if (Make=="Chrysler") & strpos(Model,"New Yorker")==1 & strpos(Model,"Avenue")!=0 & strpos(Model,"Imperial")==0
replace Model="Chrysler New Yorker/Fifth Avenue/Imperial" if (Make=="Chrysler") & strpos(Model,"New Yorker")==1 & strpos(Model,"Avenue")!=0 & strpos(Model,"Imperial")!=0
replace Model="Chrysler New Yorker/Lhs" if (Make==""|Make=="Chrysler") & strpos(Model,"New Yorker/Lhs")==1
replace Model="Chrysler Newport/Fifth Avenue" if (Make=="Chrysler") & strpos(Model,"Newport/Fifth Avenue")==1
replace Model="Chrysler Newport/New Yorker" if (Make==""|Make=="Chrysler") & strpos(Model,"Newport/New Yorker")==1
replace Model="Chrysler Pacifica" if (Make=="Chrysler") & strpos(Model,"Pacifica")==1 
replace Model="Chrysler Prowler" if (Make=="Chrysler") & strpos(Model,"Prowler")==1 
replace Model="Chrysler Pt Cruiser" if (Make=="Chrysler") & strpos(Model,"Pt Cruiser")==1 
replace Model="Chrysler Sebring" if (Make=="Chrysler") & strpos(Model,"Sebring")==1 
replace Model="Chrysler Tc By" if (Make=="Chrysler") & strpos(Model,"Tc By")==1 
replace Model="Chrysler Town & Country Wagon" if (Make==""|Make=="Chrysler") & strpos(Model,"Town And Country Wagon")==1
replace Model="Chrysler Voyager/Town & Country" if (Make=="Chrysler"|Make=="Plymouth") & (strpos(Model,"Voyager")==1|(strpos(Model,"Town And Country")==1&strpos(Model,"Wagon")==0))
replace Make="Chrysler" if Model=="Chrysler Voyager/Town & Country" 

** Daewoo **
replace Model="Daewoo Kalos" if (Make=="Daewoo") & (Model=="Kalos")
replace Model="Daewoo Lacetti" if (Make=="Daewoo") & (Model=="Lacetti")
replace Model="Daewoo Lanos" if (Make=="Daewoo") & (Model=="Lanos")
replace Model="Daewoo Leganza" if (Make=="Daewoo") & (Model=="Leganza")
replace Model="Daewoo Magnus" if (Make=="Daewoo") & (Model=="Magnus")
replace Model="Daewoo Nubira" if (Make=="Daewoo") & (strpos(Model,"Nubira")==1)

** Daihatsu **
replace Model="Daihatsu Rocky" if (Make=="Daihatsu") & strpos(Model,"Rocky")==1
replace Model="Daihatsu Charade" if (Make=="Daihatsu") & strpos(Model,"Charade")==1


** Dodge **
replace Model="Dodge 024" if (Make==""|Make=="Dodge") & (strpos(Model,"024")==1|Model=="24")
replace Model="Dodge 400" if (Make=="") & (Model=="400"|Model=="400 Convertible")
replace Model="Dodge 600" if (Make==""|Make=="Dodge") & strpos(Model,"600")==1
replace Model="Dodge 600" if (Make=="Dodge") & Model=="6"
replace Model="Dodge Aries" if (Make==""|Make=="Dodge") & strpos(Model,"Aries")==1
replace Model="Dodge Avenger" if (Make==""|Make=="Dodge") & strpos(Model,"Avenger")==1
replace Model="Dodge Aspen" if (Make==""|Make=="Dodge"|strpos(Make,"Available")!=0) & strpos(Model,"Aspen")==1
replace Model="Dodge Ramcharger" if (Make==""|Make=="Dodge") & strpos(Model,"Ramcharger")!=0
replace Model="Dodge Ramcharger" if (Make==""|Make=="Dodge") & (Model=="Aw15"|Model=="Ad15") & ModelYear==1984
replace Model="Dodge B Series" if (Make==""|Make=="Dodge") & (strpos(Model,"B150")==1|strpos(Model,"B100")==1|strpos(Model,"B250")==1|strpos(Model,"B300")==1|strpos(Model,"B350")==1)
replace Model="Dodge B Series" if (Make==""|Make=="Dodge") & Model=="B15" & ModelYear==1984
replace Model="Dodge B Series" if (Make==""|Make=="Dodge") & Model=="B35" & ModelYear==1984
replace Model="Dodge Caliber" if (Make==""|Make=="Dodge") & strpos(Model,"Caliber")==1
replace Model="Dodge Caravan" if (Make=="Dodge") & (strpos(Model,"Caravan")==1|strpos(Model,"Grand Caravan")==1 ) & strpos(Model,"Ram")==0
replace Model="Dodge Caravan/Ram Van" if (Make=="Dodge") & strpos(Model,"Caravan")==1 & strpos(Model,"Ram")!=0
replace Model="Dodge Celeste" if (Make==""|Make=="Dodge") & strpos(Model,"Celeste")==1
replace Model="Dodge Challenger" if (Make==""|Make=="Dodge") & strpos(Model,"Challenger")==1 & strpos(Model,"Sapporo")==0
replace Model="Dodge Challenger/Plymouth Sapporo" if (Make==""|Make=="Dodge") & strpos(Model,"Challenger")==1 & strpos(Model,"Sapporo")!=0
replace Model="Dodge Charade" if (Make=="Dodge") & strpos(Model,"Charade")==1
replace Model="Dodge Charger" if (Make==""|Make=="Dodge") & strpos(Model,"Charger")==1 & strpos(Model,"Magnum")==0
replace Model="Dodge Charger/Plymouth Magnum" if (Make==""|Make=="Dodge") & strpos(Model,"Charger")==1 & strpos(Model,"Magnum")!=0
replace Model="Dodge/Plymouth Colt" if (Make==""|Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Colt")==1 & strpos(Model,"Vista")==0 & strpos(Model,"Pickup")==0 & strpos(Model,"Champ")==0
replace Model="Dodge/Plymouth Colt (Pickup)" if (Make==""|Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Colt")==1 & strpos(Model,"Vista")==0 & strpos(Model,"Pickup")!=0
replace Model="Dodge/Plymouth Colt Vista" if (Make==""|Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Colt")==1 & strpos(Model,"Vista")!=0 & strpos(Model,"Pickup")==0
replace Model="Dodge Colt/Plymouth Champ" if (Make==""|Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Colt")==1 & strpos(Model,"Vista")==0 & strpos(Model,"Pickup")==0 & strpos(Model,"Champ")!=0
replace Model="Dodge/Plymouth Conquest" if (Make==""|Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Conquest")==1
replace Model="Dodge Coronet" if (Make==""|Make=="Dodge"|strpos(Make,"*Avail")==1) & strpos(Model,"Coronet")==1 & strpos(Model,"Charg")==0
replace Model="Dodge Coronet/Charger" if (Make==""|Make=="Dodge"|strpos(Make,"*Avail")==1) & strpos(Model,"Coronet")==1 & strpos(Model,"Charg")!=0
replace Model="Dodge Csx" if (Make=="Dodge") & strpos(Model,"Csx")==1
replace Model="Dodge D Series" if (Make==""|Make=="Dodge") & (strpos(Model,"D100")==1|strpos(Model,"D150")==1|strpos(Model,"D200")==1|strpos(Model,"D250")==1|strpos(Model,"D50")==1)
replace Model="Dodge D Series" if (Make==""|Make=="Dodge") & (Model=="D25"|Model=="D1") & ModelYear==1984
replace Model="Dodge Dakota" if (Make=="Dodge") & strpos(Model,"Dakota")==1
replace Model="Dodge Dart" if (Make=="Dodge") & strpos(Model,"Dart")==1
replace Model="Dodge Daytona" if (Make=="Dodge") & strpos(Model,"Daytona")==1
replace Model="Dodge Diplomat" if (Make==""|Make=="Dodge") & strpos(Model,"Diplomat")==1
replace Model="Dodge Durango" if (Make=="Dodge") & strpos(Model,"Durango")==1
replace Model="Dodge Dynasty" if (Make=="Dodge") & strpos(Model,"Dynasty")==1
replace Model="Dodge Journey" if (Make=="Dodge") & strpos(Model,"Journey")==1
replace Model="Dodge Intrepid" if (Make=="Dodge") & strpos(Model,"Intrepid")==1
replace Model="Dodge Lancer" if (Make=="Dodge") & strpos(Model,"Lancer")==1
replace Model="Plymouth Lancer" if (Make==""|Make=="Plymouth") & strpos(Model,"Lancer")==1 & ModelYear<1982
replace Model="Plymouth Cricket/Lancer" if (Make=="Plymouth") & strpos(Model,"Cricket/Lancer")==1
replace Model="Dodge Magnum" if (Make==""|Make=="Dodge") & (strpos(Model,"Magnum")==1)
replace Model="Dodge Mirada" if (Make==""|Make=="Dodge") & (strpos(Model,"Mirada")==1)
replace Model="Dodge Monaco" if (Make==""|Make=="Dodge"|strpos(Make,"*Avail")==1) & (strpos(Model,"Monac")==1)
replace Model="Dodge/Plymouth Neon" if (Make=="Dodge"|Make=="Plymouth") & (strpos(Model,"Neon")==1) & strpos(Model,"Srt")==0
replace Model="Dodge Neon/Srt4/Sx" if (Make=="Dodge"|Make=="Plymouth") & (strpos(Model,"Neon")==1) & strpos(Model,"Srt")!=0 & strpos(Model,"Sx")!=0
replace Model="Dodge Nitro" if (Make=="Dodge") & strpos(Model,"Nitro")==1
replace Model="Dodge Omni" if (Make==""|Make=="Dodge") & strpos(Model,"Omni")==1 & strpos(Model,"De Toma")==0
replace Model="Dodge Omni/De Tomaso" if (Make==""|Make=="Dodge") & strpos(Model,"Omni")==1 & strpos(Model,"De Toma")!=0
replace Model="Dodge/Plymouth Pickup" if (Make=="Dodge"|Make=="Plymouth") & strpos(Model,"Pickup")==1
replace Model="Dodge Ram 50" if (Make==""|Make=="Dodge") & strpos(Model,"Power Ram")==1
replace Model="Dodge Raider" if (Make=="Dodge") & strpos(Model,"Raider")==1
replace Model="Dodge Ram 1500/2500/3500" if (Make=="Dodge") & (strpos(Model,"Ram 1500")==1|strpos(Model,"Ram 2500")==1|strpos(Model,"Ram 3500")==1)
replace Model="Dodge Ram 50" if (Make==""|Make=="Dodge") & (strpos(Model,"Ram 50")==1|strpos(Model,"Ram5")==1|strpos(Model,"Dodge Ram50")==1) & strpos(Model,"Arrow")==0 & strpos(Model,"L200")==0
replace Model="Dodge Ram Van/Wagon" if (Make=="Dodge") & (strpos(Model,"Ram Van")==1|strpos(Model,"Ram Wagon")==1)
replace Model="Dodge Ram 50/Plymouth Arrow (Pickup)" if (Make==""|Make=="Dodge") & (strpos(Model,"Ram 50")==1|strpos(Model,"Ram5")==1) & strpos(Model,"Arrow")!=0 & strpos(Model,"L200")==0
replace Model="Dodge Ram 50/L200/Plymouth Arrow (Pickup)" if (Make==""|Make=="Dodge") & (strpos(Model,"Ram 50")==1|strpos(Model,"Ram5")==1) & strpos(Model,"Arrow")!=0 & strpos(Model,"L200")!=0
replace Model="Dodge Rampage" if (Make==""|Make=="Dodge") & strpos(Model,"Rampage")==1
replace Model="Dodge Royal Monaco" if (Make==""|Make=="Dodge") & strpos(Model,"Royal Monaco")==1
replace Model="Dodge Shadow" if (Make=="Dodge") & strpos(Model,"Shadow")==1
replace Model="Dodge Spirit" if (Make==""|Make=="Dodge") & strpos(Model,"Spirit")==1
replace Model="Dodge St Regis" if (Make==""|Make=="Dodge") & strpos(Model,"St. Regis")==1
replace Model="Dodge Stealth" if (Make=="Dodge") & strpos(Model,"Stealth")==1
replace Model="Dodge Stratus" if (Make=="Dodge") & strpos(Model,"Stratus")==1
replace Model="Dodge/Plymouth Van" if (Make=="Plymouth"|Make=="Dodge") & strpos(Model,"Van")==1
replace Model="Dodge Viper" if (Make=="Dodge") & strpos(Model,"Viper")==1
replace Model="Dodge W Series" if (Make==""|Make=="Dodge") & (strpos(Model,"W100")==1|strpos(Model,"W150")==1|strpos(Model,"W200")==1|strpos(Model,"W250")==1)
replace Model="Dodge W Series" if (Make==""|Make=="Dodge") & (Model=="W25"|Model=="W1") & ModelYear==1984
** Additional for CARLIN
replace Model="Dodge 400" if Model=="400" & VClass!=""
* Collapse Ram Van, B Series, and Ram Wagon.
replace Model = "Dodge Ram Van" if Model=="Dodge Ram Van/Wagon"|Model=="Dodge B Series"

** Ferrari **
replace Model="Ferrari F141" if (Make=="Ferrari") & strpos(Model,"F141")==1
replace Model="Ferrari F40" if (Make=="Ferrari") & (strpos(Model,"F40")==1|strpos(Model,"F 40")==1)
replace Model="Ferrari F430" if (Make=="Ferrari") & strpos(Model,"F430")==1
replace Model="Ferrari F355" if (Make=="Ferrari") & strpos(Model,"Ferrari F355")==1
replace Model="Ferrari 308" if (Make=="Ferrari") & strpos(Model,"308")==1
replace Model="Ferrari 328" if Make=="Ferrari" & strpos(Model,"328")==1
replace Model="Ferrari 348" if Make=="Ferrari" & (strpos(Model,"348")==1|strpos(Model,"Ferrari 348")==1)
replace Model="Ferrari 360" if Make=="Ferrari" & strpos(Model,"360")==1
replace Model="Ferrari 456" if Make=="Ferrari" & (strpos(Model,"456")==1|strpos(Model,"Ferrari 456")==1)
replace Model="Ferrari 512" if (Make==""|Make=="Ferrari") & (strpos(Model,"Ferrari 512")==1)
replace Model="Ferrari 550" if (Make==""|Make=="Ferrari") & (strpos(Model,"Ferrari 550")==1)
replace Model="Ferrari 550" if (Make=="Ferrari") & (strpos(Model,"550")==1)
replace Model="Ferrari 575" if (Make=="Ferrari") & (strpos(Model,"575")==1)
replace Model="Ferrari 599" if (Make=="Ferrari") & (strpos(Model,"599")==1)
replace Model="Ferrari 612" if (Make=="Ferrari") & (strpos(Model,"612")==1)
replace Model="Ferrari Mondial/Cabriolet" if (Make==""|Make=="Ferrari") & strpos(Model,"Mondial/Cabriolet")==1
replace Model="Ferrari F355" if Make=="Ferrari" & (strpos(Model,"F355")==1)
replace Model="Ferrari F50" if Make=="Ferrari" & (strpos(Model,"F50")==1)
replace Model="Ferrari F512" if Make=="Ferrari" & (strpos(Model,"F512")==1)
replace Model="Ferrari Mondial" if (Make==""|Make=="Ferrari") & (strpos(Model,"Mondial")==1) & strpos(Model,"Cabriolet")==0
replace Model="Ferrari Mondial/Cabriolet" if (Make==""|Make=="Ferrari") & (strpos(Model,"Mondial")!=0) & strpos(Model,"Cabriolet")!=0
replace Model="Ferrari Testarossa" if (Make=="Ferrari"|Make=="J.K. Motors") & (strpos(Model,"Testarossa")==1|strpos(Model,"Testerossa")==1)
replace Model="Ferrari Enzo" if Model=="Enzo Ferrari"


** Fiat **
replace Model="Fiat 124" if (Make==""|Make=="Fiat") & strpos(Model,"124")==1
replace Model="Fiat 128" if (Make==""|Make=="Fiat") & strpos(Model,"128")==1
replace Model="Fiat 131" if (Make==""|Make=="Fiat") & strpos(Model,"131")==1
replace Model="Fiat 138" if (Make==""|Make=="Fiat") & strpos(Model,"138")==1
replace Model="Lancia Beta/Zagato" if (Make==""|Make=="Lancia") & strpos(Model,"Beta/Zagato")==1
replace Model="Fiat Brava" if (Make==""|Make=="Fiat") & strpos(Model,"Brava")==1
replace Model="Fiat X1/9" if (Make==""|Make=="Fiat") & strpos(Model,"X1/9")==1
replace Model="Fiat Strada" if (Make==""|Make=="Fiat") & strpos(Model,"Strada")==1


** Ford **
replace Model="Ford Aerostar" if Make=="Ford" & strpos(Model,"Aerostar")==1
replace Model="Ford Aspire" if Make=="Ford" & strpos(Model,"Aspire")==1
replace Model="Ford Bronco" if (Make==""|Make=="Ford") & strpos(Model,"Bronco")==1 & strpos(Model,"Ii")==0
replace Model="Ford Bronco Ii" if (Make==""|Make=="Ford") & strpos(Model,"Bronco")==1 & strpos(Model,"Ii")!=0
replace Model="Ford Ltd" if (Make==""|strpos(Make,"Ford")==1) & strpos(Model,"Ltd")==1 & strpos(Model,"Ii")==0
replace Model="Ford Ltd Ii" if (Make==""|strpos(Make,"Ford")==1) & strpos(Model,"Ltd")==1 & strpos(Model,"Ii")!=0
replace Model="Ford Contour" if Make=="Ford" & strpos(Model,"Contour")==1
replace Model="Ford Courier" if (Make==""|Make=="Ford") & strpos(Model,"Courier")==1
replace Model="Ford Crown Victoria" if (Make=="Ford") & strpos(Model,"Crown Victoria")==1
replace Model="Ford E Series" if (Make==""|Make=="Ford") & (strpos(Model,"E-100")==1|strpos(Model,"E100")==1|strpos(Model,"E150")==1|strpos(Model,"E250")==1|strpos(Model,"Econoline")!=0)
replace Model="Ford E Series" if (Make==""|Make=="Ford") & (Model=="E15"|Model=="E25") & ModelYear==1984
replace Model="Ford Edge" if (Make=="Ford") & strpos(Model,"Edge")==1
replace Model="Ford Elite" if (Make=="Ford"|strpos(Make,"Fiat")!=0) & strpos(Model,"Elite")==1
replace Model="Ford Escape" if (Make=="Ford") & strpos(Model,"Escape")==1
replace Model="Ford Escort" if (Make==""|strpos(Make,"Ford")==1) & strpos(Model,"Escort")==1
replace Model="Ford Exp" if (Make==""|strpos(Make,"Ford")==1) & Model=="Exp"
replace Model="Ford Expedition" if (Make=="Ford") & strpos(Model,"Expedition")==1
replace Model="Ford Explorer" if (Make=="Ford") & strpos(Model,"Explorer")==1
replace Model="Ford F Series" if (Make==""|Make=="Ford") & (strpos(Model,"F-100")==1|strpos(Model,"F100")==1|strpos(Model,"F141")==1|strpos(Model,"F150")==1|strpos(Model,"F250")==1|strpos(Model,"F355")==1|strpos(Model,"F40")==1|strpos(Model,"F430")==1)
replace Model="Ford F Series" if (Make=="Ford") & (strpos(Model,"Lightning F150")==1)
replace Model="Ford F Series" if (Make=="Ford") & (Model=="F15"|Model=="F25") & ModelYear==1984
replace Model="Ford Fairmont" if (Make==""|Make=="Ford") & strpos(Model,"Fairmont")==1
replace Model="Ford Festiva" if (Make=="Ford") & strpos(Model,"Festiva")==1
replace Model="Ford Fiesta" if (Make==""|Make=="Ford") & strpos(Model,"Fiesta")==1
replace Model="Ford Flex" if (Make==""|Make=="Ford") & strpos(Model,"Flex")==1
replace Model="Ford 500" if (Make=="Ford") & strpos(Model,"Five Hundred")==1
replace Model="Ford Focus" if (Make=="Ford") & strpos(Model,"Focus")==1
replace Model="Ford Freestar" if (Make=="Ford") & strpos(Model,"Freestar")==1
replace Model="Ford Freestyle" if (Make=="Ford") & strpos(Model,"Freestyle")==1
replace Model="Ford Fusion" if (Make=="Ford") & strpos(Model,"Fusion")==1
replace Model="Ford Granada" if (Make==""|Make=="Ford"|strpos(Make,"Fiat")!=0) & strpos(Model,"Granada")==1
replace Model="Ford Gt" if (Make=="Ford") & strpos(Model,"Gt")==1
replace Model="Ford Laser" if (Make==""|strpos(Make,"Ford")==1) & strpos(Model,"Laser")!=0
replace Model="Ford Maverick" if (Make=="Ford"|strpos(Make,"Fiat")!=0) & strpos(Model,"Maverick")==1
replace Model="Ford Mustang" if (Make==""|strpos(Make,"Ford")==1) & strpos(Model,"Mustang")==1 & strpos(Model,"Ii")==0
replace Model="Ford Mustang Ii" if (Make==""|strpos(Make,"Ford")==1) & strpos(Model,"Mustang")==1 & strpos(Model,"Ii")!=0
replace Model="Ford Pickup" if (Make=="Ford") & strpos(Model,"Pickup")==1
replace Model="Ford Pinto" if (Make==""|Make=="Ford") & strpos(Model,"Pinto")==1 & strpos(Model,"Panel")==0
replace Model="Ford Pinto (Panel Del)" if (Make==""|Make=="Ford") & strpos(Model,"Pinto")==1 & strpos(Model,"Panel")!=0
replace Model="Ford Postal Vehicle" if (Make=="Ford") & strpos(Model,"Postal Vehicle")==1
replace Model="Ford Probe" if (Make=="Ford") & strpos(Model,"Probe")==1
replace Model="Ford Ranchero" if (Make==""|Make=="Ford") & strpos(Model,"Ranchero")==1
replace Model="Ford Ranger" if (Make==""|Make=="Ford") & strpos(Model,"Ranger")==1
replace Model="Ford Taurus" if (Make=="Ford") & strpos(Model,"Taurus")==1
replace Model="Ford Tempo" if (strpos(Make,"Ford")==1) & strpos(Model,"Tempo")==1
replace Model="Ford Th!Nk" if (strpos(Make,"Ford")==1) & strpos(Model,"Th!Nk")==1
replace Model="Ford Thunderbird" if (Make==""|strpos(Make,"Ford")==1|strpos(Make,"Fiat")!=0) & strpos(Model,"Thunderbird")==1
replace Model="Ford Torino" if (strpos(Make,"Ford")==1|strpos(Make,"Fiat")!=0) & strpos(Model,"Torino")==1 & strpos(Model,"Elite")==0
replace Model="Ford Torino/Elite" if (strpos(Make,"Ford")==1|strpos(Make,"Fiat")!=0) & strpos(Model,"Torino")==1 & strpos(Model,"Elite")!=0
replace Model="Ford Windstar" if (Make=="Ford") & strpos(Model,"Windstar")==1
replace Model="Ford Wagon" if (Make==""|Make=="Ford"|strpos(Make,"Fiat")!=0) & strpos(Model,"Ford Wagon")==1
** Additional for CARLIN
replace Model="Ford Ltd" if strpos(Model,"Ltd")==1 & strpos(Model,"Ii")==0 & VClass!=""
replace Model="Ford Ltd Ii" if strpos(Model,"Ltd")==1 & strpos(Model,"Ii")!=0 & VClass!=""
replace Model="Ford Elite" if strpos(Model,"Elite")==1 & VClass!=""


** Geo **
replace Model="Geo Metro" if (Make=="Geo") & strpos(Model,"Metro")==1
replace Model="Geo Prizm" if (Make=="Geo") & strpos(Model,"Prizm")==1
replace Model="Geo Spectrum" if (Make=="Geo") & strpos(Model,"Spectrum")==1
replace Model="Geo Storm" if (Make=="Geo") & strpos(Model,"Storm")==1
replace Model="Geo Tracker" if (Make=="Geo") & strpos(Model,"Tracker")==1


** Gmc **
replace Model="Gmc Sierra" if (Make=="Gmc") & strpos(Model,"Sierra")!=0
replace Model="Gmc Sonoma" if (Make=="Gmc") & strpos(Model,"Sonoma")!=0
replace Model="Gmc Jimmy" if (Make==""|Make=="Gmc") & strpos(Model,"Jimmy")!=0 
replace Model="Gmc Syclone" if Model=="Pas-Syclone"
replace Model="Gmc Typhoon" if Model=="Pas-Typhoon"
replace Model="Gmc Acadia" if (Make=="Gmc") & strpos(Model,"Acadia")==1
replace Model="Gmc Caballero" if (Make==""|Make=="Gmc") & strpos(Model,"Caballero")==1
replace Model="Gmc Canyon" if (Make=="Gmc") & strpos(Model,"Canyon")==1
replace Model="Gmc Envoy" if (Make=="Gmc") & strpos(Model,"Envoy")==1
replace Model="Gmc S15/T15" if (Make==""|Make=="Gmc") & (strpos(Model,"S15")==1|strpos(Model,"T15")==1) & strpos(Model,"Jimmy")==0
replace Model="Gmc Safari" if (Make=="Gmc") & strpos(Model,"Safari")==1
replace Model="Gmc Savana" if (Make=="Gmc") & strpos(Model,"Savana")==1
replace Model="Gmc Yukon" if (Make=="Gmc") & strpos(Model,"Yukon")==1 & strpos(Model,"Xl")==0
replace Model="Gmc Yukon Xl" if (Make=="Gmc") & strpos(Model,"Yukon")==1 & strpos(Model,"Xl")!=0
* Overwrite a couple of earlier assignments to Chevy-GMC G Series
replace Model = "Gmc Rally" if (Make=="Gmc"|Make=="Chevrolet")&(Model=="G15/25 Rally 2Wd"|Model=="G35 Rally 2Wd")
replace Model = "Gmc Vandura" if (Make=="Gmc"|Make=="Chevrolet")&(Model=="G15/25 Vandura 2Wd"|Model=="G35 Vandura 2Wd")

** Honda **
replace Model="Honda Accord" if (Make==""|Make=="Honda") & strpos(Model,"Accord")==1
replace Model="Honda Civic" if (Make==""|Make=="Honda") & (strpos(Model,"Civic")==1|strpos(Model,"Del Sol")!=0)
replace Model="Honda Cr-V" if (Make=="Honda") & strpos(Model,"Cr-V")==1
*replace Model="Honda Del Sol" if (Make=="Honda") & strpos(Model,"Del Sol")==1
replace Model="Honda Civic" if Make=="Honda" & strpos(Model,"Del Sol")==1 /* The Del Sol is really a submodel of the Civic */
replace Model="Honda Element" if (Make=="Honda") & strpos(Model,"Element")==1
replace Model="Honda Fit" if (Make=="Honda") & strpos(Model,"Fit")==1
replace Model="Honda Insight" if (Make=="Honda") & strpos(Model,"Insight")==1
replace Model="Honda Integra" if (Make=="Honda") & strpos(Model,"Integra")==1
replace Model="Honda Legend" if (Make=="Honda") & strpos(Model,"Legend")==1
replace Model="Honda Odyssey" if (Make=="Honda") & strpos(Model,"Odyssey")==1
replace Model="Honda Passport" if (Make=="Honda") & strpos(Model,"Passport")==1
replace Model="Honda Pilot" if (Make=="Honda") & strpos(Model,"Pilot")==1
replace Model="Honda Prelude" if (Make==""|Make=="Honda") & strpos(Model,"Prelude")==1
replace Model="Honda Ridgeline" if (Make=="Honda") & strpos(Model,"Ridgeline")==1
replace Model="Honda S2000" if (Make=="Honda") & strpos(Model,"S2000")==1
** Additional for CARLIN
replace Model="Honda Accord" if strpos(Model,"Accord")==1 & VClass!=""
replace Model="Honda Civic" if strpos(Model,"Del Sol")==1


** Hummer **
replace Model="Hummer H3" if (Make=="Hummer") & strpos(Model,"H3")==1


** Hyundai **
replace Model="Hyundai Azera" if (Make==""|Make=="Hyundai") & strpos(Model,"Azera")==1
replace Model="Hyundai Accent" if (Make==""|Make=="Hyundai") & strpos(Model,"Accent")==1
replace Model="Hyundai Elantra" if (Make=="Hyundai") & (strpos(Model,"Elantra")==1|Model=="J-Car/Elantra")
replace Model="Hyundai Entourage" if (Make=="Hyundai") & strpos(Model,"Entourage")==1
replace Model="Hyundai Excel" if (Make=="Hyundai") & (strpos(Model,"Excel")==1|strpos(Model,"Pony Excel")==1)
replace Model="Hyundai Genesis" if (Make=="Hyundai") & strpos(Model,"Genesis")==1
replace Model="Hyundai Santa Fe" if (Make=="Hyundai") & strpos(Model,"Santa Fe")==1
replace Model="Hyundai Scoupe" if (Make=="Hyundai") & strpos(Model,"Scoupe")==1
replace Model="Hyundai Sonata" if (Make=="Hyundai") & strpos(Model,"Sonata")==1
replace Model="Hyundai Tiburon" if (Make=="Hyundai") & strpos(Model,"Tiburon")==1
replace Model="Hyundai Tucson" if (Make=="Hyundai") & strpos(Model,"Tucson")==1
replace Model="Hyundai Veracruz" if (Make=="Hyundai") & strpos(Model,"Veracruz")==1
replace Model="Hyundai Xg300" if (Make=="Hyundai") & strpos(Model,"Xg300")==1
replace Model="Hyundai Xg350" if (Make=="Hyundai") & strpos(Model,"Xg350")==1


** Infiniti **
replace Model="Infiniti Ex35" if (Make=="Infiniti") & strpos(Model,"Ex35")==1
replace Model="Infiniti Fx35" if (Make=="Infiniti") & strpos(Model,"Fx35")==1
replace Model="Infiniti Fx45" if (Make=="Infiniti") & strpos(Model,"Fx45")==1
replace Model="Infiniti G20" if (Make=="Infiniti") & strpos(Model,"G20")==1
replace Model="Infiniti G35" if (Make=="Infiniti") & strpos(Model,"G35")==1
replace Model="Infiniti G37" if (Make=="Infiniti") & strpos(Model,"G37")==1
replace Model="Infiniti I30" if (Make=="Infiniti") & strpos(Model,"I30")==1
replace Model="Infiniti I35" if (Make=="Infiniti") & strpos(Model,"I35")==1
replace Model="Infiniti J30" if (Make=="Infiniti") & strpos(Model,"J30")==1
replace Model="Infiniti M30" if (Make=="Infiniti") & strpos(Model,"M30")==1
replace Model="Infiniti M35" if (Make=="Infiniti") & strpos(Model,"M35")==1
replace Model="Infiniti M45" if (Make=="Infiniti") & strpos(Model,"M45")==1
replace Model="Infiniti Q45" if (Make=="Infiniti") & strpos(Model,"Q45")==1
replace Model="Infiniti Qx4" if (Make=="Infiniti") & strpos(Model,"Qx4")==1
replace Model="Infiniti Qx56" if (Make=="Infiniti") & strpos(Model,"Qx56")==1


** International **
replace Model="International Scout Ii" if (Make=="") & strpos(Model,"Scout Ii")==1
replace Model="International Traveler" if (Make=="") & strpos(Model,"Traveler")==1
replace Model="International Terra" if (Make=="") & strpos(Model,"Terra")==1
replace Model="International Ss Ii" if (Make=="") & strpos(Model,"Ss Ii")==1


** Isuzu **
replace Model="Isuzu Ascender" if (Make==""|Make=="Isuzu") & strpos(Model,"Ascender")==1
replace Model="Isuzu Axiom" if Make=="Isuzu" & strpos(Model,"Axiom")==1
replace Model="Isuzu Amigo" if Make=="Isuzu" & strpos(Model,"Amigo")==1
replace Model="Isuzu Hombre" if Make=="Isuzu" & strpos(Model,"Hombre")==1
replace Model="Isuzu I-280" if Make=="Isuzu" & strpos(Model,"I-280")==1
replace Model="Isuzu I-290" if Make=="Isuzu" & strpos(Model,"I-290")==1
replace Model="Isuzu I-350" if Make=="Isuzu" & strpos(Model,"I-350")==1
replace Model="Isuzu I-370" if Make=="Isuzu" & strpos(Model,"I-370")==1
replace Model="Isuzu I-Mark" if (Make==""|Make=="Isuzu") & strpos(Model,"I-Mark")==1
replace Model="Isuzu 750C/I-Mark" if (Make=="Isuzu") & strpos(Model,"750C/I-Mark")==1
replace Model="Isuzu Impulse" if (Make=="Isuzu") & strpos(Model,"Impulse")==1
replace Model="Isuzu Oasis" if (Make=="Isuzu") & strpos(Model,"Oasis")==1
replace Model="Isuzu Pickup" if (Make=="Isuzu") & (strpos(Model,"Pickup")==1|strpos(Model,"P'Up")==1)
replace Model="Isuzu Rodeo" if Make=="Isuzu" & strpos(Model,"Rodeo")==1
replace Model="Isuzu Stylus" if Make=="Isuzu" & strpos(Model,"Stylus")==1
replace Model="Isuzu Trooper" if Make=="Isuzu" & strpos(Model,"Trooper")==1
replace Model="Isuzu Vehicross" if Make=="Isuzu" & strpos(Model,"Vehicross")==1


** Jaguar **
replace Model="Jaguar Xf" if (Make==""|strpos(Make,"Jaguar")==1) & (Model=="Xf"|Model=="Xf Supercharged")
replace Model="Jaguar Xjs" if Model=="Jaguar Xj-S"
replace Model="Jaguar Xj" if (Make==""|strpos(Make,"Jaguar")==1) & (Model=="Xj"|Model=="Xj Sport")
replace Model="Jaguar Xj" if (Make==""|strpos(Make,"Jaguar")==1) & (strpos(Model,"Xj6")!=0|strpos(Model,"Xj8")!=0|strpos(Model,"Xj12")!=0)
replace Model="Jaguar Xjr" if (Make==""|strpos(Make,"Jaguar")==1) & (strpos(Model,"Xjr")!=0) & strpos(Model,"Xjrs")==0
replace Model="Jaguar Xjrs" if (Make==""|strpos(Make,"Jaguar")==1) & (strpos(Model,"Xjrs")!=0)
replace Model="Jaguar Xjs" if (Make==""|strpos(Make,"Jaguar")==1) & (strpos(Model,"Xjs")!=0|strpos(Model,"Xj-S")!=0)&strpos(Model,"Xj-Sc")==0
replace Model="Jaguar Xj-Sc" if (Make==""|strpos(Make,"Jaguar")==1) & (strpos(Model,"Xj-Sc")!=0)
replace Model="Jaguar S-Type" if (strpos(Make,"Jaguar")==1) & (strpos(Model,"S-Type")==1)
replace Model="Jaguar Super V8" if (strpos(Make,"Jaguar")==1) & (strpos(Model,"Super V8")==1)
replace Model="Jaguar Vanden Plas" if (strpos(Make,"Jaguar")==1) & (strpos(Model,"Vanden Plas")==1|strpos(Model,"Vdp")==1)
replace Model="Jaguar X200" if (strpos(Make,"Jaguar")==1) & strpos(Model,"X200")==1
replace Model="Jaguar Xk" if (strpos(Make,"Jaguar")==1) & strpos(Model,"Xk")==1 & strpos(Model,"8")==0 & strpos(Model,"Xkr")==0
replace Model="Jaguar Xk8" if (strpos(Make,"Jaguar")==1) & strpos(Model,"Xk")==1 & strpos(Model,"8")!=0
replace Model="Jaguar Xkr" if (strpos(Make,"Jaguar")==1) & strpos(Model,"Xkr")==1
replace Model="Jaguar X-Type" if (strpos(Make,"Jaguar")==1) & strpos(Model,"X-Type")==1


** Jeep **
replace Model="Jeep Cherokee" if (Make=="Jeep") & strpos(Model,"Cherokee")==1 & strpos(Model,"Wagoneer")==0
replace Model="Jeep Cherokee/Wagoneer" if (Make==""|Make=="Jeep") & strpos(Model,"Cherokee")==1 & strpos(Model,"Wagoneer")!=0
replace Model="Jeep Cj5/7" if (Make==""|Make=="Jeep") & (strpos(Model,"Cj-5/7")==1|strpos(Model,"Cj-5/Cj-7")==1)
replace Model="Jeep Cj7" if (Make==""|Make=="Jeep") & (strpos(Model,"Cj7")==1|strpos(Model,"Cj-7")==1)
replace Model="Jeep Comanche" if (Make=="Jeep") & strpos(Model,"Comanche")==1 
replace Model="Jeep Commander" if (Make=="Jeep") & strpos(Model,"Commander")==1 
replace Model="Jeep Compass" if (Make=="Jeep") & strpos(Model,"Compass")==1 
replace Model="Jeep Grand Cherokee" if (Make=="Jeep") & strpos(Model,"Grand Cherokee")==1 
replace Model="Jeep Grand Wagoneer" if (Make=="Jeep") & strpos(Model,"Grand Wagoneer")==1 
replace Model="Jeep Cj5/7" if (Make==""|Make=="Jeep") & strpos(Model,"Cj-5/Cj-7")!=0 & strpos(Model,"Scrambler")==0 
replace Model="Jeep Cj8" if (Make=="Jeep") & strpos(Model,"Jeep Cj-8")==1 
replace Model="Jeep Cj5/7/Scrambler" if (Make==""|Make=="Jeep") & strpos(Model,"Jeep: Scrambler, Cj-5/7")==1
replace Model="Jeep Liberty" if (Make=="Jeep") & strpos(Model,"Liberty")==1
replace Model="Jeep Patriot" if (Make=="Jeep") & strpos(Model,"Patriot")==1 
replace Model="Jeep Scrambler" if (Make==""|Make=="Jeep") & strpos(Model,"Scrambler")==1 
replace Model="Jeep Wagoneer" if (Make==""|Make=="Jeep") & strpos(Model,"Wagoneer")==1 
replace Model="Jeep Wrangler" if (Make==""|Make=="Jeep") & strpos(Model,"Wrangler")==1 & strpos(Model,"Tj")==0
replace Model="Jeep Wrangler" if (Make==""|Make=="Jeep") & strpos(Model,"Wrangler")==1 & strpos(Model,"Tj")!=0
replace Model="Jeep J10" if (Make==""|Make=="Jeep") & (strpos(Model,"J10")==1|strpos(Model,"J-10")==1) & strpos(Model,"1000")==0
replace Model="Jeep J10" if (Make=="Jeep") & (Model=="J-1") & ModelYear==1984
replace Model="Jeep J20" if (Make==""|Make=="Jeep") & (strpos(Model,"J20")==1|strpos(Model,"J-20")==1) & strpos(Model,"2000")==0
replace Model="Jeep J20" if (Make=="Jeep") & (Model=="J-2") & ModelYear==1984


** Kia **
replace Model="Kia Amanti" if (Make=="Kia") & strpos(Model,"Amanti")==1
replace Model="Kia Optima" if (Make=="Kia") & strpos(Model,"Optima")==1
replace Model="Kia Rio" if (Make=="Kia") & strpos(Model,"Rio")==1
replace Model="Kia Rondo" if (Make=="Kia") & strpos(Model,"Rondo")==1
replace Model="Kia Sedona" if (Make=="Kia") & strpos(Model,"Sedona")==1
replace Model="Kia Sephia" if (Make=="Kia") & strpos(Model,"Sephia")==1 & strpos(Model,"Spectra")==0
replace Model="Kia Sephia/Spectra" if (Make=="Kia") & strpos(Model,"Sephia")==1 & strpos(Model,"Spectra")!=0
replace Model="Kia Sorento" if (Make=="Kia") & strpos(Model,"Sorento")==1
replace Model="Kia Spectra" if (Make=="Kia") & strpos(Model,"Spectra")==1
replace Model="Kia Sportage" if (Make=="Kia") & strpos(Model,"Sportage")==1


** Lamborghini **
replace Model="Lamborghini Countach" if (Make==""|strpos(Make,"Lamborghini")==1) & strpos(Model,"Countach")==1
replace Model="Lamborghini Diablo" if (strpos(Make,"Lamborghini")==1) & strpos(Model,"Diablo")!=0
replace Model="Lamborghini Gallardo" if (strpos(Make,"Lamborghini")==1) & strpos(Model,"Gallardo")!=0
replace Model="Lamborghini Murcielago" if (strpos(Make,"Lamborghini")==1) & strpos(Model,"Murcielago")!=0


** Lexus **
replace Model="Lexus Es 250" if (Make=="Lexus") & strpos(Model,"Es 250")==1
replace Model="Lexus Es 300" if (Make=="Lexus") & strpos(Model,"Es 300")==1
replace Model="Lexus Es 330" if (Make=="Lexus") & strpos(Model,"Es 330")==1
replace Model="Lexus Es 350" if (Make=="Lexus") & strpos(Model,"Es 350")==1
replace Model="Lexus Gs 300" if (Make=="Lexus") & (strpos(Model,"Gs300")==1|strpos(Model,"Gs 300")==1) & strpos(Model,"400")==0 & strpos(Model,"430")==0
replace Model="Lexus Gs 300/Gs 400" if (Make=="Lexus") & strpos(Model,"Gs 300")==1 & strpos(Model,"400")!=0
replace Model="Lexus Gs 300/Gs 430" if (Make=="Lexus") & strpos(Model,"Gs 300")==1 & strpos(Model,"430")!=0
replace Model="Lexus Gs 350" if (Make=="Lexus") & strpos(Model,"Gs 350")==1 
replace Model="Lexus Gs 430" if (Make=="Lexus") & strpos(Model,"Gs 430")==1 
replace Model="Lexus Gs 450" if (Make=="Lexus") & strpos(Model,"Gs 450")==1 
replace Model="Lexus Gs 460" if (Make=="Lexus") & strpos(Model,"Gs 460")==1 
replace Model="Lexus Gs 470" if (Make=="Lexus") & strpos(Model,"Gs 470")==1 
replace Model="Lexus Gx 470" if (Make=="Lexus") & strpos(Model,"Gx 470")==1 
replace Model="Lexus Is 250" if (Make=="Lexus") & strpos(Model,"Is 250")==1 
replace Model="Lexus Is 300" if (Make=="Lexus") & strpos(Model,"Is 300")==1 
replace Model="Lexus Is F" if (Make=="Lexus") & strpos(Model,"Is F")==1 
replace Model="Lexus Is 350" if (Make=="Lexus") & strpos(Model,"Is 350")==1 
replace Model="Lexus Ls 400" if (Make=="Lexus") & strpos(Model,"Ls 400")==1 
replace Model="Lexus Ls 430" if (Make=="Lexus") & strpos(Model,"Ls 430")==1 
replace Model="Lexus Ls 460" if (Make=="Lexus") & strpos(Model,"Ls 460")==1 
replace Model="Lexus Ls 600" if (Make=="Lexus") & strpos(Model,"Ls 600")==1 
replace Model="Lexus Lx 450" if (Make=="Lexus") & strpos(Model,"Lx 450")==1 
replace Model="Lexus Lx 470" if (Make=="Lexus") & strpos(Model,"Lx 470")==1 
replace Model="Lexus Lx 570" if (Make=="Lexus") & strpos(Model,"Lx 570")==1 
replace Model="Lexus Rx 300" if (Make=="Lexus") & strpos(Model,"Rx 300")==1 
replace Model="Lexus Rx 330" if (Make=="Lexus") & strpos(Model,"Rx 330")==1 
replace Model="Lexus Rx 350" if (Make=="Lexus") & strpos(Model,"Rx 350")==1 
replace Model="Lexus Rx 400" if (Make=="Lexus") & strpos(Model,"Rx 400")==1 
replace Model="Lexus Rx 450" if (Make=="Lexus") & strpos(Model,"Rx 450")==1 
replace Model="Lexus Sc 300/Sc 400" if (Make=="Lexus") & strpos(Model,"Sc 300/Sc 400")==1
replace Model="Lexus Sc 300/Sc 430" if (Make=="Lexus") & strpos(Model,"Sc 300/Sc 430")==1
replace Model="Lexus Sc 300/Sc 400" if (Make=="Lexus") & Model=="Sc" 
replace Model="Lexus Sc 430" if (Make=="Lexus") & strpos(Model,"Sc 430")==1 


** Lincoln **
replace Model="Lincoln Aviator" if (Make==""|Make=="Lincoln") & strpos(Model,"Aviator")==1
replace Model="Lincoln Blackwood" if Make=="Lincoln" & strpos(Model,"Blackwood")==1
replace Model="Lincoln Zephyr" if (Make==""|Make=="Lincoln") & strpos(Model,"Zephyr")==1
replace Model="Lincoln Continental" if (Make==""|strpos(Make,"Lincoln")==1|strpos(Make,"Jaguar Requires")!=0) & strpos(Model,"Continental")==1
replace Model="Lincoln Town Car" if Model=="Lincolin Town Car"
replace Model="Lincoln Ls" if Make=="Lincoln" & Model=="Ls"
replace Model="Lincoln Mark Series" if (Make==""|strpos(Make,"Lincoln")!=0) & strpos(Model,"Mark")==1
replace Model="Lincoln Mkx" if Make=="Lincoln" & strpos(Model,"Mkx")==1
replace Model="Lincoln Mkz" if Make=="Lincoln" & strpos(Model,"Mkz")==1
replace Model="Lincoln Navigator" if Make=="Lincoln" & strpos(Model,"Navigator")==1
replace Model="Lincoln Town Car" if (Make==""|strpos(Make,"Lincoln")==1) & strpos(Model,"Town Car")==1
replace Model="Lincoln Versailles" if (Make==""|strpos(Make,"Lincoln")==1) & strpos(Model,"Versailles")==1
** Additional for CARLIN
replace Model="Lincoln Zephyr" if strpos(Model,"Zephyr")==1 & VClass!=""


** Lotus **
replace Model="Lotus Esprit" if (Make=="") & strpos(Model,"Lotus Esprit")==1
replace Model="Lotus Esprit" if (Make=="Lotus") & strpos(Model,"Esprit")==1
replace Model="Lotus Elan" if (Make=="Lotus") & strpos(Model,"Elan")==1
replace Model="Lotus Elise/Exige" if (Make=="Lotus") & strpos(Model,"Elise/Exige")==1


** Maserati **
replace Model="Maserati 222" if Make=="Maserati" & strpos(Model,"222")==1 
replace Model="Maserati 225" if Make=="Maserati" & strpos(Model,"225")==1 
replace Model="Maserati 228" if Make=="Maserati" & strpos(Model,"228")==1 
replace Model="Maserati 425" if Make=="Maserati" & strpos(Model,"425")!=0
replace Model="Maserati 430" if Make=="Maserati" & strpos(Model,"430")==1 
replace Model="Maserati Biturbo" if Make=="Maserati" & strpos(Model,"Biturbo")==1 & strpos(Model,"425")==0
replace Model="Maserati Granturismo" if Make=="Maserati" & strpos(Model,"Granturismo")==1 
replace Model="Maserati Coupe Cambiocorsa" if Make=="Maserati" & strpos(Model,"Coupe Cambiocorsa")==1 
replace Model="Maserati Coupe and Gransport" if Make=="Maserati" & strpos(Model,"Coupe And Gransport")==1 
replace Model="Maserati Karif" if Make=="Maserati" & strpos(Model,"Karif")==1 
replace Model="Maserati Khamsin" if Make=="Maserati" & strpos(Model,"Khamsin")==1 
replace Model="Maserati Quattroporte" if (Make==""|Make=="Maserati") & strpos(Model,"Quattroporte")==1 
replace Model="Maserati Spyder" if Make=="Maserati" & (strpos(Model,"Spyder")==1|strpos(Model,"Spider")==1) 


** Maybach **
replace Model="Maybach 57" if Make=="Maybach" & strpos(Model,"57")==1 
replace Model="Maybach 62" if Make=="Maybach" & strpos(Model,"62")==1 


** Mazda **
replace Model="Mazda 2500" if (Make==""|Make=="Mazda") & strpos(Model,"2500")==1
replace Model="Mazda 323" if (Make==""|Make=="Mazda") & strpos(Model,"323")==1 & strpos(Model,"Protege")==0 
replace Model="Mazda 323/Protege" if (Make==""|Make=="Mazda") & strpos(Model,"323")==1 & strpos(Model,"Protege")!=0
replace Model="Mazda 626" if (Make==""|Make=="Mazda") & Model=="626"
replace Model="Mazda 626/Mx6" if (Make==""|Make=="Mazda") & Model=="626/Mx-6"
replace Model="Mazda 808" if (Make==""|Make=="Mazda") & (Model=="808"|Model=="808 Wagon")
replace Model="Mazda 929" if (Make==""|Make=="Mazda") & Model=="929"
replace Model="Mazda 3" if Make=="Mazda" & Model=="3"
replace Model="Mazda 5" if Make=="Mazda" & Model=="5"
replace Model="Mazda 6" if Make=="Mazda" & (Model=="6"|Model=="6 Sport Wagon")
replace Model="Mazda B Series" if (Make==""|Make=="Mazda") & (strpos(Model,"B2000")==1|strpos(Model,"B2200")==1|strpos(Model,"B2300")==1|strpos(Model,"B2500")==1|strpos(Model,"B2600")==1|strpos(Model,"B3000")==1|strpos(Model,"B4000")==1|strpos(Model,"B1600")==1|strpos(Model,"B 1600")==1|strpos(Model,"B1800")==1)
replace Model="Mazda B Series" if (Make==""|Make=="Mazda") & Model=="B2" & ModelYear==1984
replace Model="Mazda Cosmo" if (Make==""|Make=="Mazda") & strpos(Model,"Cosmo")==1
replace Model="Mazda Cx7" if (Make=="Mazda") & strpos(Model,"Cx-7")==1
replace Model="Mazda Cx9" if (Make=="Mazda") & strpos(Model,"Cx-9")==1
replace Model="Mazda Glc" if (Make==""|Make=="Mazda") & strpos(Model,"Glc")==1
replace Model="Mazda Millenia" if (Make=="Mazda") & strpos(Model,"Millenia")==1
replace Model="Mazda Mpv" if (Make=="Mazda") & strpos(Model,"Mpv")==1
replace Model="Mazda Mx3" if (Make=="Mazda") & strpos(Model,"Mx-3")==1
replace Model="Mazda Mx5" if (Make=="Mazda") & strpos(Model,"Mx-5")==1 & strpos(Model,"Miata")==0
replace Model="Mazda Mx5/Miata" if (Make=="Mazda") & strpos(Model,"Mx-5")==1 & strpos(Model,"Miata")!=0
replace Model="Mazda Mx6" if (Make=="Mazda") & strpos(Model,"Mx-6")==1
replace Model="Mazda Navajo" if (Make=="Mazda") & strpos(Model,"Navajo")==1
replace Model="Mazda Protege" if (Make=="Mazda") & strpos(Model,"Protege")==1
replace Model="Mazda Rotary" if (Make=="Mazda") & strpos(Model,"Rotary")==1
replace Model="Mazda Rx3" if (Make==""|Make=="Mazda") & strpos(Model,"Rx-3")==1
replace Model="Mazda Rx4" if (Make==""|Make=="Mazda"|strpos(Make,"Rotary")!=0) & strpos(Model,"Rx-4")==1
replace Model="Mazda Rx7" if (Make==""|Make=="Mazda") & strpos(Model,"Rx-7")==1
replace Model="Mazda Rx8" if (Make==""|Make=="Mazda") & strpos(Model,"Rx-8")==1
replace Model="Mazda Speed 3" if (Make=="Mazda") & strpos(Model,"Speed 3")==1
replace Model="Mazda Tribute" if (Make=="Mazda") & strpos(Model,"Tribute")==1


** Mercedes **
replace Model="Mercedes-Benz 300" if (Make=="Mercedes-Benz") & Model=="3" & ModelYear==1984 
replace Model="Mercedes-Benz 500" if (Make=="Mercedes-Benz") & Model=="5" & ModelYear==1984 
replace Model="Mercedes-Benz 380" if (Make=="Mercedes-Benz") & Model=="38" & ModelYear==1984 
replace Model="Mercedes-Benz 230" if (Make=="Mercedes-Benz") & strpos(Model,"230")==1 
replace Model="Mercedes-Benz 240" if (Make=="Mercedes-Benz") & strpos(Model,"240")==1 
replace Model="Mercedes-Benz 260" if (Make=="Mercedes-Benz") & strpos(Model,"260")==1 
replace Model="Mercedes-Benz 280" if (Make=="Mercedes-Benz") & strpos(Model,"280")==1 
replace Model="Mercedes-Benz 300" if (Make=="Mercedes-Benz") & strpos(Model,"300")==1 
replace Model="Mercedes-Benz 350" if (Make=="Mercedes-Benz") & strpos(Model,"350")==1 
replace Model="Mercedes-Benz 380" if (Make=="Mercedes-Benz") & strpos(Model,"380")==1 
replace Model="Mercedes-Benz 400" if (Make=="Mercedes-Benz") & strpos(Model,"400")==1 
replace Model="Mercedes-Benz 420" if (Make=="Mercedes-Benz") & strpos(Model,"420")==1 
replace Model="Mercedes-Benz 450" if (Make=="Mercedes-Benz") & strpos(Model,"450")==1 
replace Model="Mercedes-Benz 500" if (Make=="Mercedes-Benz"|strpos(Make,"Texas")==1) & strpos(Model,"500")==1 
replace Model="Mercedes-Benz 560" if (Make=="Mercedes-Benz") & strpos(Model,"560")==1 
replace Model="Mercedes-Benz 600" if (Make=="Mercedes-Benz") & strpos(Model,"600")==1 
replace Model="Mercedes-Benz 280" if (Make=="") & strpos(Model,"Mb")==1 & strpos(Model,"280")!=0
replace Model="Mercedes-Benz 230" if (Make=="") & strpos(Model,"Mb")==1 & strpos(Model,"230")!=0
replace Model="Mercedes-Benz 240" if (Make=="") & strpos(Model,"Mb")==1 & strpos(Model,"240")!=0
replace Model="Mercedes-Benz 450" if (Make=="") & strpos(Model,"Mb")==1 & strpos(Model,"450")!=0
replace Model="Mercedes-Benz 240/280/300" if (Make=="") & strpos(Model,"240D/280E/280Ce/300D/300Cd")==1
replace Model="Mercedes-Benz 240/280/300" if (Make=="") & strpos(Model,"240D/280E/280Ce/300D/300C")==1
replace Model="Mercedes-Benz 240/300" if (Make=="") & strpos(Model,"240D/300D/300Cd")==1 
replace Model="Mercedes-Benz 280/300" if (Make=="") & strpos(Model,"280Se/300Sd")==1 
replace Model="Mercedes-Benz 300" if (Make=="") & (Model=="300Sd"|Model=="300Td")
replace Model="Mercedes-Benz 380" if (Make=="") & (Model=="380Sec"|Model=="380Sel"|Model=="380Sl"|Model=="380Slc"|Model=="300Sel"|Model=="300Sl"|Model=="300Slc")
replace Model="Mercedes-Benz 450" if (Make=="") & (Model=="450Sel"|Model=="450Sl"|Model=="450Slc")
replace Model="Mercedes-Benz 6.9" if (Make=="") & Model=="6.9" 
replace Model="Mercedes-Benz 190" if (Make==""|Make=="Mercedes-Benz") & strpos(Model,"190")==1 
replace Model="Mercedes-Benz 190" if (Make=="Mercedes-Benz") & Model=="19" & ModelYear==1984
replace Model="Mercedes-Benz C220" if (Make=="Mercedes-Benz") & strpos(Model,"C220")==1 
replace Model="Mercedes-Benz C230" if (Make=="Mercedes-Benz") & strpos(Model,"C230")==1 
replace Model="Mercedes-Benz C240" if (Make=="Mercedes-Benz") & strpos(Model,"C240")==1 
replace Model="Mercedes-Benz C280" if (Make=="Mercedes-Benz") & strpos(Model,"C280")==1 
replace Model="Mercedes-Benz C300" if (Make=="Mercedes-Benz") & strpos(Model,"C300")==1 
replace Model="Mercedes-Benz C320" if (Make=="Mercedes-Benz") & strpos(Model,"C320")==1 
replace Model="Mercedes-Benz C350" if (Make=="Mercedes-Benz") & strpos(Model,"C350")==1 
replace Model="Mercedes-Benz C430" if (Make=="Mercedes-Benz") & strpos(Model,"C430")==1 
replace Model="Mercedes-Benz C550" if (Make=="Mercedes-Benz") & strpos(Model,"C550")==1 
replace Model="Mercedes-Benz C32" if (Make=="Mercedes-Benz") & strpos(Model,"C32")==1 & strpos(Model,"320")==0
replace Model="Mercedes-Benz C36" if (Make=="Mercedes-Benz") & strpos(Model,"C36")==1 
replace Model="Mercedes-Benz C43" if (Make=="Mercedes-Benz") & strpos(Model,"C43")==1 & strpos(Model,"430")==0
replace Model="Mercedes-Benz C55" if (Make=="Mercedes-Benz") & strpos(Model,"C55")==1 & strpos(Model,"550")==0
replace Model="Mercedes-Benz C63" if (Make=="Mercedes-Benz") & strpos(Model,"C63")==1 & strpos(Model,"630")==0
replace Model="Mercedes-Benz Cl500" if (Make=="Mercedes-Benz") & strpos(Model,"Cl500")==1 
replace Model="Mercedes-Benz Cl55" if (Make=="Mercedes-Benz") & strpos(Model,"Cl55")==1 
replace Model="Mercedes-Benz Cl600" if (Make=="Mercedes-Benz") & strpos(Model,"Cl600")==1 
replace Model="Mercedes-Benz Cl63" if (Make=="Mercedes-Benz") & strpos(Model,"Cl63")==1 
replace Model="Mercedes-Benz Cl65" if (Make=="Mercedes-Benz") & strpos(Model,"Cl65")==1 
replace Model="Mercedes-Benz Clk320" if (Make=="Mercedes-Benz") & strpos(Model,"Clk320")==1 
replace Model="Mercedes-Benz Clk350" if (Make=="Mercedes-Benz") & strpos(Model,"Clk350")==1 
replace Model="Mercedes-Benz Clk430" if (Make=="Mercedes-Benz") & strpos(Model,"Clk430")==1 
replace Model="Mercedes-Benz Clk500" if (Make=="Mercedes-Benz") & strpos(Model,"Clk500")==1 
replace Model="Mercedes-Benz Clk55" if (Make=="Mercedes-Benz") & strpos(Model,"Clk55")==1 
replace Model="Mercedes-Benz Clk550" if (Make=="Mercedes-Benz") & strpos(Model,"Clk550")==1 
replace Model="Mercedes-Benz Clk63" if (Make=="Mercedes-Benz") & strpos(Model,"Clk63")==1 
replace Model="Mercedes-Benz Cls500" if (Make=="Mercedes-Benz") & strpos(Model,"Cls500")==1 
replace Model="Mercedes-Benz Cls550" if (Make=="Mercedes-Benz") & strpos(Model,"Cls550")==1 
replace Model="Mercedes-Benz Cls55" if (Make=="Mercedes-Benz") & strpos(Model,"Cls55")==1 & strpos(Model,"550")==0
replace Model="Mercedes-Benz Cls63" if (Make=="Mercedes-Benz") & strpos(Model,"Cls63")==1
replace Model="Mercedes-Benz E300" if (Make=="Mercedes-Benz") & strpos(Model,"E300")==1
replace Model="Mercedes-Benz E320" if (Make=="Mercedes-Benz") & strpos(Model,"E320")==1
replace Model="Mercedes-Benz E350" if (Make=="Mercedes-Benz") & strpos(Model,"E350")==1
replace Model="Mercedes-Benz E420" if (Make=="Mercedes-Benz") & strpos(Model,"E420")==1
replace Model="Mercedes-Benz E430" if (Make=="Mercedes-Benz") & strpos(Model,"E430")==1
replace Model="Mercedes-Benz E500" if (Make=="Mercedes-Benz") & strpos(Model,"E500")==1
replace Model="Mercedes-Benz E55" if (Make=="Mercedes-Benz") & strpos(Model,"E55")==1 & strpos(Model,"550")==0
replace Model="Mercedes-Benz E550" if (Make=="Mercedes-Benz") & strpos(Model,"E550")==1
replace Model="Mercedes-Benz E63" if (Make=="Mercedes-Benz") & strpos(Model,"E63")==1
replace Model="Mercedes-Benz G500" if (Make=="Mercedes-Benz") & (strpos(Model,"G 500")==1|strpos(Model,"G500")==1)
replace Model="Mercedes-Benz G55" if (Make=="Mercedes-Benz") & (strpos(Model,"G 55")==1|strpos(Model,"G55")==1)
replace Model="Mercedes-Benz G550" if (Make=="Mercedes-Benz") & (strpos(Model,"G 550")==1|strpos(Model,"G550")==1)
replace Model="Mercedes-Benz Gl320" if (Make=="Mercedes-Benz") & strpos(Model,"Gl320")==1
replace Model="Mercedes-Benz Gl450" if (Make=="Mercedes-Benz") & strpos(Model,"Gl450")==1
replace Model="Mercedes-Benz Gl550" if (Make=="Mercedes-Benz") & strpos(Model,"Gl550")==1
replace Model="Mercedes-Benz Ml320" if (Make=="Mercedes-Benz") & strpos(Model,"Ml320")==1
replace Model="Mercedes-Benz Ml350" if (Make=="Mercedes-Benz") & strpos(Model,"Ml350")==1
replace Model="Mercedes-Benz Ml430" if (Make=="Mercedes-Benz") & strpos(Model,"Ml430")==1
replace Model="Mercedes-Benz Ml500" if (Make=="Mercedes-Benz") & strpos(Model,"Ml500")==1
replace Model="Mercedes-Benz Ml55" if (Make=="Mercedes-Benz") & strpos(Model,"Ml55")==1 & strpos(Model,"550")==0
replace Model="Mercedes-Benz Ml550" if (Make=="Mercedes-Benz") & strpos(Model,"Ml550")==1
replace Model="Mercedes-Benz Ml63" if (Make=="Mercedes-Benz") & strpos(Model,"Ml63")==1 
replace Model="Mercedes-Benz R320" if (Make=="Mercedes-Benz") & strpos(Model,"R320")==1 
replace Model="Mercedes-Benz R350" if (Make=="Mercedes-Benz") & strpos(Model,"R350")==1 
replace Model="Mercedes-Benz R500" if (Make=="Mercedes-Benz") & strpos(Model,"R500")==1 
replace Model="Mercedes-Benz R63" if (Make=="Mercedes-Benz") & strpos(Model,"R63")==1 
replace Model="Mercedes-Benz S320" if (Make=="Mercedes-Benz") & strpos(Model,"S320")==1 
replace Model="Mercedes-Benz S350" if (Make=="Mercedes-Benz") & strpos(Model,"S350")==1 
replace Model="Mercedes-Benz S420" if (Make=="Mercedes-Benz") & strpos(Model,"S420")==1 
replace Model="Mercedes-Benz S430" if (Make=="Mercedes-Benz") & strpos(Model,"S430")==1 
replace Model="Mercedes-Benz S500" if (Make=="Mercedes-Benz") & strpos(Model,"S500")==1 
replace Model="Mercedes-Benz S550" if (Make=="Mercedes-Benz") & strpos(Model,"S550")==1 
replace Model="Mercedes-Benz S55" if (Make=="Mercedes-Benz") & strpos(Model,"S55")==1 & strpos(Model,"550")==0 
replace Model="Mercedes-Benz S600" if (Make=="Mercedes-Benz") & strpos(Model,"S600")==1 
replace Model="Mercedes-Benz S63" if (Make=="Mercedes-Benz") & strpos(Model,"S63")==1 
replace Model="Mercedes-Benz S65" if (Make=="Mercedes-Benz") & strpos(Model,"S65")==1 
replace Model="Mercedes-Benz Sl320" if (Make=="Mercedes-Benz") & strpos(Model,"Sl320")==1 
replace Model="Mercedes-Benz Sl500" if (Make=="Mercedes-Benz") & strpos(Model,"Sl500")==1 
replace Model="Mercedes-Benz Sl55" if (Make=="Mercedes-Benz") & strpos(Model,"Sl55")==1 & strpos(Model,"550")==0 
replace Model="Mercedes-Benz Sl550" if (Make=="Mercedes-Benz") & strpos(Model,"Sl550")==1 
replace Model="Mercedes-Benz Sl600" if (Make=="Mercedes-Benz") & strpos(Model,"Sl600")==1 
replace Model="Mercedes-Benz Sl63" if (Make=="Mercedes-Benz") & strpos(Model,"Sl63")==1 & strpos(Model,"630")==0 
replace Model="Mercedes-Benz Sl65" if (Make=="Mercedes-Benz") & strpos(Model,"Sl65")==1 & strpos(Model,"650")==0 
replace Model="Mercedes-Benz Slk230" if (Make=="Mercedes-Benz") & strpos(Model,"Slk230")==1
replace Model="Mercedes-Benz Slk280" if (Make=="Mercedes-Benz") & strpos(Model,"Slk280")==1
replace Model="Mercedes-Benz Slk300" if (Make=="Mercedes-Benz") & strpos(Model,"Slk300")==1
replace Model="Mercedes-Benz Slk32" if (Make=="Mercedes-Benz") & strpos(Model,"Slk32")==1
replace Model="Mercedes-Benz Slk320" if (Make=="Mercedes-Benz") & strpos(Model,"Slk320")==1
replace Model="Mercedes-Benz Slk350" if (Make=="Mercedes-Benz") & strpos(Model,"Slk350")==1
replace Model="Mercedes-Benz Slk55" if (Make=="Mercedes-Benz") & strpos(Model,"Slk55")==1
replace Model="Mercedes-Benz Slr" if (Make=="Mercedes-Benz") & strpos(Model,"Slr")==1
** Grouping
replace Model="Mercedes-Benz C Class" if strpos(Model,"Mercedes-Benz C")==1 & strpos(Model,"Cl")==0
replace Model="Mercedes-Benz Cl Class" if strpos(Model,"Mercedes-Benz Cl")==1 & strpos(Model,"Clk")==0 & strpos(Model,"Cls")==0 
replace Model="Mercedes-Benz Clk Class" if strpos(Model,"Mercedes-Benz Clk")==1 
replace Model="Mercedes-Benz Cls Class" if strpos(Model,"Mercedes-Benz Cls")==1 
replace Model="Mercedes-Benz E Class" if strpos(Model,"Mercedes-Benz E")==1 
replace Model="Mercedes-Benz S Class" if strpos(Model,"Mercedes-Benz S")==1 & strpos(Model,"Sl")==0
replace Model="Mercedes-Benz Sl Class" if strpos(Model,"Mercedes-Benz Sl")==1 & strpos(Model,"Slk")==0 & strpos(Model,"Slr")==0 
replace Model="Mercedes-Benz Slk Class" if strpos(Model,"Mercedes-Benz Slk")==1 
replace Model="Mercedes-Benz Slr Class" if strpos(Model,"Mercedes-Benz Slr")==1 
** Additional for CARLIN
replace Model="Mercedes-Benz 6.9" if Model=="6.9" & VClass!="" 
replace Model="Mercedes-Benz 380" if strpos(Model,"380")==1 & VClass!="" 
replace Model="Mercedes-Benz 380" if strpos(Model,"380")==1 & VClass!=""
replace Model="Mercedes-Benz 500" if strpos(Model,"500")==1 & VClass!="" & strpos(Model,"5000")==0
** Additional Grouping to reduce columns
replace Model="Mercedes-Benz 240/280/300" if Model=="Mercedes-Benz 280/300" 


** Mercury **
replace Model="Mercury Bobcat" if (Make==""|strpos(Make,"Mercury")!=0) & strpos(Model,"Bobcat")==1 
replace Model="Mercury Capri" if (Make==""|strpos(Make,"Mercury")!=0) & strpos(Model,"Capri")==1 & strpos(Model,"Ii")==0
replace Model="Mercury Capri Ii" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"*Jaguar")==1) & strpos(Model,"Capri")==1 & strpos(Model,"Ii")!=0
replace Model="Mercury Comet" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"*Jaguar")==1) & strpos(Model,"Comet")==1
replace Model="Mercury Cougar" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"*Jaguar")==1) & strpos(Model,"Cougar")==1 & strpos(Model,"Xr7")==0
replace Model="Mercury Cougar Xr7" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"*Jaguar")==1) & strpos(Model,"Cougar")==1 & strpos(Model,"Xr7")!=0
replace Model="Mercury Cougar/Cougar Xr7" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"*Jaguar")==1) & strpos(Model,"Cougar")==1 & strpos(Model,"Xr-7")!=0
replace Model="Mercury Grand Marquis" if (Make==""|strpos(Make,"Mercury")!=0) & strpos(Model,"Grand Marquis")==1
replace Model="Mercury Lynx" if (Make==""|strpos(Make,"Mercury")!=0) & strpos(Model,"Lynx")==1 
replace Model="Mercury Ln7" if (Make==""|strpos(Make,"Mercury")!=0) & (strpos(Model,"Ln-7")==1|strpos(Model,"Ln7")==1)
replace Model="Mercury Marauder" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Marauder")==1 
replace Model="Mercury Mariner" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Mariner")==1 
replace Model="Mercury Marquis" if (Make==""|strpos(Make,"Mercury")!=0) & strpos(Model,"Marquis")==1 
replace Model="Mercury Milan" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Milan")==1 
replace Model="Mercury Monarch" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"Jaguar")!=0) & strpos(Model,"Monarch")==1 
replace Model="Mercury Montego" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"Jaguar")!=0) & strpos(Model,"Montego")==1 & strpos(Model,"Cougar")==0
replace Model="Mercury Montego/Cougar" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"Jaguar")!=0) & strpos(Model,"Montego")==1 & strpos(Model,"Cougar")!=0
replace Model="Mercury Monterey" if (Make==""|strpos(Make,"Mercury")!=0|strpos(Make,"*Jaguar")==1) & strpos(Model,"Monterey")==1
replace Model="Mercury Mountaineer" if (Make==""|strpos(Make,"Mercury")==1) & strpos(Model,"Mountaineer")==1 
replace Model="Mercury Mystique" if (strpos(Make,"Mercury")==1) & strpos(Model,"Mystique")==1 
replace Model="Mercury Sable" if (strpos(Make,"Mercury")==1) & strpos(Model,"Sable")==1 
replace Model="Mercury Topaz" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Topaz")==1
replace Model="Mercury Tracer" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Tracer")==1
replace Model="Mercury Villager" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Villager")==1
replace Model="Mercury Wagon" if (strpos(Make,"Mercury")!=0) & strpos(Model,"Mercury Wagon")==1
replace Model="Mercury Xr7" if (Make==""|strpos(Make,"Mercury")!=0) & strpos(Model,"Xr7")==1


** Merkur **
replace Model="Merkur Scorpio" if (strpos(Make,"Merkur")==1) & strpos(Model,"Scorpio")==1 
replace Model="Merkur Xr4Ti" if (strpos(Make,"Merkur")==1) & strpos(Model,"Xr4Ti")==1 


** Mg **
replace Model="Mg Mgb" if Model=="Mgb"
replace Model="Mg Midget" if Model=="Midget"


** Mini **
replace Model="Mini Cooper" if Make=="Mini" & strpos(Model,"Cooper")==1
replace Model="Mini Clubman" if Make=="Mini" & strpos(Model,"Clubman")==1


** Mitsubishi **
replace Model="Mitsubishi 3000Gt" if Make=="Mitsubishi" & (strpos(Model,"3000 Gt")==1|strpos(Model,"3000Gt")==1)
replace Model="Mitsubishi Cordia" if (Make==""|Make=="Mitsubishi") & (strpos(Model,"Cordia")==1)
replace Model="Mitsubishi Diamante" if Make=="Mitsubishi" & (strpos(Model,"Diamante")==1)
replace Model="Mitsubishi Eclipse" if Make=="Mitsubishi" & (strpos(Model,"Eclipse")==1)
replace Model="Mitsubishi Endeavor" if Make=="Mitsubishi" & (strpos(Model,"Endeavor")==1)
replace Model="Mitsubishi Expo" if Make=="Mitsubishi" & (strpos(Model,"Expo")==1)
replace Model="Mitsubishi Galant" if Make=="Mitsubishi" & (strpos(Model,"Galant")==1)
replace Model="Mitsubishi Lancer" if Make=="Mitsubishi" & (strpos(Model,"Lancer")==1)
replace Model="Mitsubishi Mirage" if Make=="Mitsubishi" & (strpos(Model,"Mirage")==1)
replace Model="Mitsubishi Montero" if (Make==""|Make=="Mitsubishi") & (strpos(Model,"Montero")==1)
replace Model="Mitsubishi Nativa" if (Make=="Mitsubishi") & (strpos(Model,"Nativa")==1)&strpos(Model,"Puerto")==0 /* Exclude the "Puerto Rico Only" model */
replace Model="Mitsubishi Outlander" if (Make=="Mitsubishi") & (strpos(Model,"Outlander")==1)
replace Model="Mitsubishi Precis" if (Make==""|Make=="Mitsubishi"|Make=="Hyundai") & (strpos(Model,"Precis")!=0)
** For Precis, I follow the NHTS classification.
replace Model="Mitsubishi Raider" if (Make=="Mitsubishi") & (strpos(Model,"Raider")==1)
replace Model="Mitsubishi Sigma" if (Make=="Mitsubishi") & (strpos(Model,"Sigma")==1)
replace Model="Mitsubishi Space Wagon" if (Make=="Mitsubishi") & (strpos(Model,"Space Wagon")==1)
replace Model="Mitsubishi Starion" if (Make==""|Make=="Mitsubishi") & (strpos(Model,"Starion")==1)
replace Model="Mitsubishi Tredia" if (Make==""|Make=="Mitsubishi") & (strpos(Model,"Tredia")==1)
replace Model="Mitsubishi Truck" if (Make=="Mitsubishi") & (strpos(Model,"Truck")==1)
replace Model="Mitsubishi Van" if (Make=="Mitsubishi") & (strpos(Model,"Van")==1)
replace Model="Mitsubishi Wagon" if (Make=="Mitsubishi") & (strpos(Model,"Wagon")==1)
* I think that Mitsubishi Space Wagon (MY 1987-1990) should be the Wagon, not the Expo. The Expo is not listed in Polk for these model years, while the Wagon is. The Liters differences will distinguish.
replace Model="Mitsubishi Wagon" if Make=="Mitsubishi" & (strpos(Model,"Space Wagon")==1)

** Nissan/Datsun **
replace Model="Nissan 200Sx" if (Make==""|Make=="Nissan"|Make=="Datsun") & (Model=="200Sx"|Model=="200 Sx")
replace Model="Nissan 200Sx" if (strpos(Make,"Nissan")==1) & (Model=="2")
replace Model="Nissan 240Sx" if (Make==""|Make=="Nissan"|Make=="Datsun") & (Model=="240Sx"|Model=="240 Sx")
replace Model="Nissan 210" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"210")==1
replace Model="Nissan B210" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"B-210")==1
replace Model="Nissan 280Z" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"280Z")==1 & strpos(Model,"Zx")==0
replace Model="Nissan 280Zx" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"280Zx")==1
replace Model="Nissan 300Zx" if (Make=="Nissan"|Make=="Datsun") & strpos(Model,"300Zx")==1
replace Model="Nissan 300Zx" if (strpos(Make,"Nissan")==1) & Model=="3"
replace Model="Nissan 350Z" if (Make=="Nissan"|Make=="Datsun") & strpos(Model,"350Z")==1
replace Model="Nissan 310" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"310")==1
replace Model="Nissan 510" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"510")==1
replace Model="Nissan 610" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"610")==1
replace Model="Nissan 710" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"710")==1
replace Model="Nissan 810" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"810")==1
replace Model="Nissan Axxess" if (Make=="Nissan"|Make=="Datsun") & strpos(Model,"Axxess")==1
replace Model="Nissan Altima" if (Make=="Nissan"|Make=="Datsun") & strpos(Model,"Altima")==1
replace Model="Nissan Altra" if (Make=="Nissan"|Make=="Datsun") & strpos(Model,"Altra")==1
replace Model="Nissan Armada" if (Make=="Nissan"|Make=="Datsun") & strpos(Model,"Armada")==1
replace Model="Nissan F10" if (Make==""|Make=="Nissan"|Make=="Datsun") & strpos(Model,"F-10")==1 & strpos(Model,"100")==0
replace Model="Nissan Frontier" if (Make=="Nissan") & strpos(Model,"Frontier")==1
replace Model="Nissan Maxima" if (strpos(Make,"Nissan")==1) & strpos(Model,"Maxima")==1
replace Model="Nissan Murano" if (strpos(Make,"Nissan")==1) & strpos(Model,"Murano")==1
replace Model="Nissan Pickup" if strpos(Model,"Nissan Pickup")==1
replace Model="Nissan Sentra" if strpos(Model,"Nissan Sentra")==1
replace Model="Nissan Nx" if strpos(Model,"Nissan Nx")==1
replace Model="Nissan Nx" if Make=="Nissan" & strpos(Model,"Nx")==1
replace Model="Nissan Pathfinder" if strpos(Model,"Nissan Pathfinder")==1 & strpos(Model,"Armada")==0
replace Model="Nissan Pathfinder" if Make=="Nissan" & strpos(Model,"Pathfinder")==1 & strpos(Model,"Armada")==0
replace Model="Nissan Pathfinder Armada" if strpos(Model,"Nissan Pathfinder")==1 & strpos(Model,"Armada")!=0
replace Model="Nissan Pathfinder Armada" if Make=="Nissan" & strpos(Model,"Pathfinder")==1 & strpos(Model,"Armada")!=0
replace Model="Nissan Pickup" if (strpos(Make,"Nissan")==1|Make=="Datsun") & strpos(Model,"Pickup")==1
replace Model="Nissan Pickup" if (Make=="Datsun") & strpos(Model,"Datsun Cab")==1
replace Model="Nissan Pulsar" if (Make==""|strpos(Make,"Nissan")==1) & strpos(Model,"Pulsar")==1
replace Model="Nissan Quest" if (strpos(Make,"Nissan")==1) & strpos(Model,"Quest")==1
replace Model="Nissan Rogue" if (strpos(Make,"Nissan")==1) & strpos(Model,"Rogue")==1
replace Model="Nissan Sentra" if (strpos(Make,"Nissan")==1) & strpos(Model,"Sentra")==1 & strpos(Model,"200Sx")==0
replace Model="Nissan Sentra/200Sx" if (Make==""|Make=="Nissan"|Make=="Datsun") & Model=="Sentra/200Sx"
replace Model="Nissan Stanza" if (strpos(Make,"Nissan")==1) & strpos(Model,"Stanza")==1 & strpos(Model,"Altima")==0
replace Model="Nissan Titan" if (Make=="Nissan") & strpos(Model,"Titan")==1
replace Model="Nissan Truck" if (Make=="Nissan") & (strpos(Model,"Truck")==1|strpos(Model,"Hardbody")==1)
replace Model="Nissan Van" if (Make=="Nissan") & strpos(Model,"Van")==1
replace Model="Nissan Versa" if (Make=="Nissan") & strpos(Model,"Versa")==1
replace Model="Nissan Xterra" if (Make=="Nissan") & strpos(Model,"Xterra")==1
** Additional for CARLIN
replace Model="Nissan 200Sx" if (Model=="200Sx")& ModelYear==1981 & VClass!=""
replace Model="Nissan 280Zx" if strpos(Model,"280Zx")==1 & ModelYear==1981 & VClass!=""
replace Model="Nissan 310" if Model=="310" & VClass!=""
replace Model="Nissan 510" if strpos(Model,"510")==1 & VClass!=""
replace Model="Nissan 810" if strpos(Model,"810")==1 & VClass!=""
** Grouping
replace Model="Nissan Truck" if Model=="Nissan Pickup"


** Oldsmobile **
replace Model="Oldsmobile Achieva" if Make=="Oldsmobile" & strpos(Model,"Achieva")==1
replace Model="Oldsmobile Alero" if Make=="Oldsmobile" & strpos(Model,"Alero")==1
replace Model="Oldsmobile Aurora" if Make=="Oldsmobile" & strpos(Model,"Aurora")==1
replace Model="Oldsmobile Bravada" if Make=="Oldsmobile" & strpos(Model,"Bravada")==1
replace Model="Oldsmobile Cutlass Ciera" if (Make==""|Make=="Oldsmobile") & (strpos(Model,"Ciera")!=0|strpos(Model,"Cutlass")!=0)

* replace Model="Oldsmobile Ciera Cruiser" if Model=="Oldsmobile Ciera"&(strpos(OModel,"Cruiser")!=0|strpos(OModel,"Wagon")!=0)
replace Model="Oldsmobile Calais" if Make=="Oldsmobile" & (strpos(OModel,"Calais")!=0)
replace Model="Oldsmobile Custom Cruiser" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Custom Cruiser")==1

* Sounman's old code; not used
*replace Model="Oldsmobile Cutlass" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Cutlass")==1 & strpos(Model,"Calais")==0 & strpos(Model,"Ciera")==0 & strpos(Model,"Supreme")==0
*replace Model="Oldsmobile Cutlass Supreme" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Cutlass")==1 & strpos(Model,"Supreme")!=0
*replace Model="Oldsmobile Cutlass Supreme/Calais" if Make=="" & strpos(Model,"Cutlass Supreme/Calais")==1


replace Model="Oldsmobile Delta 88" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Delta 88")==1
replace Model="Oldsmobile 88" if Make=="Oldsmobile" & strpos(Model,"Eighty-Eight")==1 & strpos(Model,"Regency")==0
replace Model="Oldsmobile 88/Regency" if Make=="Oldsmobile" & strpos(Model,"Eighty-Eight")==1 & strpos(Model,"Regency")!=0
replace Model="Oldsmobile Firenza" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Firenza")==1 & strpos(Model,"Firenza")==1
replace Model="Oldsmobile Intrigue" if (Make=="Oldsmobile") & strpos(Model,"Intrigue")==1 
replace Model="Oldsmobile 98" if (Make==""|Make=="Oldsmobile") & (strpos(Model,"Ninety-Eight")==1|strpos(Model,"Ninety Eight")==1) & strpos(Model,"Regency")==0 & strpos(Model,"Touring")==0
replace Model="Oldsmobile 98" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Oldsmobile 98")==1
replace Model="Oldsmobile 98/Regency" if (Make==""|Make=="Oldsmobile") & (strpos(Model,"Ninety-Eight")==1|strpos(Model,"Ninety Eight")==1) & strpos(Model,"Regency")!=0
replace Model="Oldsmobile 98/Touring" if (Make==""|Make=="Oldsmobile") & (strpos(Model,"Ninety-Eight")==1|strpos(Model,"Ninety Eight")==1) & strpos(Model,"Touring")!=0
replace Model="Oldsmobile 98" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Olds 98")==1

* collapse the 98s
replace Model ="Oldsmobile 98" if strpos(Model,"Oldsmobile 98")==1

replace Model="Oldsmobile Omega" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Omega")==1
replace Model="Oldsmobile Silhouette" if (Make=="Oldsmobile") & strpos(Model,"Silhouette")==1
replace Model="Oldsmobile Starfire" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Starfire")==1
replace Model="Oldsmobile Toronado" if (Make==""|Make=="Oldsmobile") & strpos(Model,"Toronado")==1
replace Model="Oldsmobile Trofeo/Toronado" if (Make=="Oldsmobile") & strpos(Model,"Trofeo/Toronado")==1
replace Model="Oldsmobile Vista Cruiser" if (Make=="Oldsmobile") & strpos(Model,"Vista Cruiser")==1


** Opel **
replace Model="Opel 1900" if (Make=="Opel") & strpos(Model,"1900")==1 & strpos(Model,"Manta")==0
replace Model="Opel 1900/Manta" if (Make=="Opel") & strpos(Model,"1900")==1 & strpos(Model,"Manta")!=0


** Plymouth **
replace Model="Plymouth Arrow" if (Make==""|Make=="Plymouth") & strpos(Model,"Arrow")==1 & strpos(Model,"Pickup")==0
replace Model="Plymouth Arrow (Pickup)" if (Make==""|Make=="Plymouth") & strpos(Model,"Arrow")==1 & strpos(Model,"Pickup")!=0
replace Model="Plymouth Acclaim" if (Make=="Plymouth") & strpos(Model,"Acclaim")==1
replace Model="Plymouth Breeze" if (Make=="Plymouth") & strpos(Model,"Breeze")==1
replace Model="Plymouth Caravelle" if (Make=="Plymouth") & strpos(Model,"Caravelle")==1
replace Model="Plymouth Champ" if (Make==""|Make=="Plymouth") & strpos(Model,"Champ")==1
replace Model="Plymouth Cricket" if (Make=="Plymouth") & strpos(Model,"Cricket")==1
replace Model="Plymouth Fury" if (Make==""|Make=="Plymouth") & strpos(Model,"Fury")==1
replace Model="Plymouth Gran Fury" if (Make==""|Make=="Plymouth"|strpos(Make,"Available")!=0) & strpos(Model,"Gran Fury")==1
replace Model="Plymouth Horizon" if (Make==""|Make=="Plymouth") & strpos(Model,"Horizon")==1 & strpos(Model,"Turismo")==0
replace Model="Plymouth Horizon/Turismo" if (Make==""|Make=="Plymouth") & strpos(Model,"Horizon")==1 & strpos(Model,"Turismo")!=0
replace Model="Plymouth Arrow (Pickup)" if (Make==""|Make=="Plymouth") & strpos(Model,"Plymouth Arrow Pickup")==1
replace Model="Plymouth Laser" if (Make=="Plymouth") & strpos(Model,"Laser")==1
replace Model="Plymouth Prowler" if (Make=="Plymouth") & strpos(Model,"Prowler")==1
replace Model="Plymouth Trailduster" if (Make==""|Make=="Plymouth") & strpos(Model,"Trailduster")!=0
replace Model="Plymouth Reliant" if (Make==""|Make=="Plymouth") & strpos(Model,"Reliant")==1
replace Model="Plymouth Road Runner/Fury" if (Make=="Plymouth") & strpos(Model,"Road Runner/Fury")==1
replace Model="Plymouth Sapporo" if (Make==""|Make=="Plymouth") & strpos(Model,"Sapporo")==1
replace Model="Plymouth Scamp" if (Make==""|Make=="Plymouth") & strpos(Model,"Scamp")==1
replace Model="Plymouth Sundance" if (Make=="Plymouth") & strpos(Model,"Sundance")==1
replace Model="Plymouth Tc3/Turismo" if (Make==""|Make=="Plymouth") & strpos(Model,"Tc3/Turismo")==1
replace Model="Plymouth Turismo" if (Make==""|Make=="Plymouth") & strpos(Model,"Turismo")==1
replace Model="Plymouth Trailduster" if (Make==""|Make=="Plymouth") & strpos(Model,"Trail Duster")==1
replace Model="Plymouth Valiant/Duster" if (Make=="Plymouth") & strpos(Model,"Valiant/Duster")==1
replace Model="Plymouth Volare" if (Make==""|Make=="Plymouth") & strpos(Model,"Volare")==1
replace Model="Plymouth Voyager" if (Make==""|Make=="Plymouth") & strpos(Model,"Voyager")!=0 & strpos(Model,"Grand")==0


** Peugeot **
replace Model="Peugeot 504" if (Make==""|Make=="Peugeot"|strpos(Make,"*Mg")==1) & strpos(Model,"504")==1
replace Model="Peugeot 505" if (Make==""|Make=="Peugeot") & strpos(Model,"505")==1
replace Model="Peugeot 505" if (Make=="Peugeot") & Model=="5" & ModelYear==1984
replace Model="Peugeot 405" if (Make=="Peugeot") & strpos(Model,"405")==1
replace Model="Peugeot 604" if (Make==""|Make=="Peugeot") & strpos(Model,"604")==1
replace Model="Peugeot 604" if (Make=="Peugeot") & Model=="6" & ModelYear==1984
** Additional for CARLIN
replace Model="Peugeot 504" if strpos(Model,"504")==1 & VClass!=""
replace Model="Peugeot 505" if strpos(Model,"505")==1 & VClass!=""

** Pininfarina ** 
replace Model = "Pininfarina Spider" if Make == "Pininfarina" & Model=="Spider"


** Pontiac **
replace Model="Pontiac 1000" if (Make==""|Make=="Pontiac") & strpos(Model,"1000")==1
replace Model="Pontiac 1000" if (Make=="Pontiac") & Model=="1" & ModelYear==1984
replace Model="Pontiac 2000" if (Make==""|Make=="Pontiac") & strpos(Model,"2000")==1
replace Model="Pontiac 2000" if (Make=="Pontiac") & Model=="2" & ModelYear==1984
replace Model="Pontiac 6000" if (Make==""|Make=="Pontiac") & strpos(Model,"6000")==1
replace Model="Pontiac 6000" if (Make=="Pontiac") & Model=="6" & ModelYear==1984
replace Model="Pontiac Astre" if (Make==""|Make=="Pontiac") & strpos(Model,"Astre")==1
replace Model="Pontiac Aztek" if (Make==""|Make=="Pontiac") & strpos(Model,"Aztek")==1
replace Model="Pontiac Trans Am" if (Make==""|Make=="Pontiac") & strpos(Model,"Trans Am")==1
replace Model="Pontiac Bonneville" if (Make==""|Make=="Pontiac") & strpos(Model,"Bonneville")==1
replace Model="Pontiac Catalina/Bonneville" if (Make==""|Make=="Pontiac") & strpos(Model,"Catalina/Bonneville")==1
replace Model="Pontiac Fiero" if (Make==""|Make=="Pontiac") & strpos(Model,"Fiero")==1
replace Model="Pontiac Firebird" if (Make==""|Make=="Pontiac") & strpos(Model,"Firebird")==1 & strpos(Model,"Formula")==0 & strpos(Model,"Trans Am")==0
replace Model="Pontiac Firebird/Formula" if (Make==""|Make=="Pontiac") & strpos(Model,"Firebird")==1 & strpos(Model,"Formula")!=0
replace Model="Pontiac Firebird/Formula" if (Make==""|Make=="Pontiac") & strpos(Model,"20Th Anniversary Trans Am")==1 
replace Model="Pontiac Firebird/Trans Am" if (Make==""|Make=="Pontiac") & strpos(Model,"Firebird")==1 & strpos(Model,"Trans Am")!=0
replace Model="Pontiac Firefly" if (Make==""|Make=="Pontiac") & (strpos(Model,"Firefly")==1|strpos(Model,"Turbo Firefly")==1)
replace Model="Pontiac G3" if (Make=="Pontiac") & strpos(Model,"G3")!=0
replace Model="Pontiac G5" if (Make=="Pontiac") & strpos(Model,"G5")!=0
replace Model="Pontiac G6" if (Make=="Pontiac") & strpos(Model,"G6")==1
replace Model="Pontiac G8" if (Make=="Pontiac") & strpos(Model,"G8")==1
replace Model="Pontiac Grand Am" if (Make=="Pontiac") & strpos(Model,"Grand Am")==1
replace Model="Pontiac Grand Prix" if (Make==""|Make=="Pontiac") & strpos(Model,"Grand Prix")==1
replace Model="Pontiac Gto" if (Make=="Pontiac") & strpos(Model,"Gto")==1
replace Model="Pontiac J2000" if (Make==""|Make=="Pontiac") & (Model=="J2000"|Model=="J2000 Wagon")
replace Model="Pontiac Lemans" if (Make==""|Make=="Pontiac") & (strpos(Model,"Lemans")==1|strpos(Model,"Le Mans")==1) & strpos(Model,"Safari")==0 & strpos(Model,"Grand Am")==0
replace Model="Pontiac Lemans Safari" if (Make==""|Make=="Pontiac") & (strpos(Model,"Lemans")==1|strpos(Model,"Le Mans")==1) & strpos(Model,"Safari")!=0
replace Model="Pontiac Lemans/Grand Am" if (Make==""|Make=="Pontiac") & (strpos(Model,"Lemans")==1|strpos(Model,"Le Mans")==1) & strpos(Model,"Grand Am")!=0
replace Model="Pontiac Montana" if (Make=="Pontiac") & strpos(Model,"Montana")==1
replace Model="Pontiac Parisienne" if (Make==""|Make=="Pontiac") & strpos(Model,"Parisienne")==1
replace Model="Pontiac Phoenix" if (Make=="Pontiac") & strpos(Model,"Phoenix")==1
replace Model="Pontiac Safari" if (Make==""|Make=="Pontiac") & strpos(Model,"Pontiac Safari")==1
replace Model="Pontiac Safari" if (Make=="Pontiac") & strpos(Model,"Safari")==1
replace Model="Pontiac Solstice" if (Make=="Pontiac") & strpos(Model,"Solstice")==1
replace Model="Pontiac Sunbird" if (Make==""|Make=="Pontiac") & strpos(Model,"Sunbird")==1
replace Model="Pontiac Sunburst" if (Make==""|Make=="Pontiac") & strpos(Model,"Sunburst")==1
replace Model="Pontiac Sunfire" if (Make=="Pontiac") & strpos(Model,"Sunfire")==1
replace Model="Pontiac T1000" if (Make==""|Make=="Pontiac") & Model=="T1000"
replace Model="Pontiac Torrent" if (Make=="Pontiac") & strpos(Model,"Torrent")==1
replace Model="Pontiac Trans Sport" if (Make=="Pontiac") & strpos(Model,"Trans Sport")==1
replace Model="Pontiac Ventura" if (Make=="Pontiac") & strpos(Model,"Ventura")==1
replace Model="Pontiac Vibe" if (Make=="Pontiac") & strpos(Model,"Vibe")==1
replace Model="Chevrolet Aveo" if (Make=="Pontiac") & strpos(Model,"Wave")==1


** Porsche **
replace Model="Porsche 911" if (Make==""|Make=="Porsche") & strpos(Model,"911")==1
replace Model="Porsche 911" if Make=="Porsche" & strpos(Model,"911")!=0

replace Model="Porsche 911" if Make=="Porsche" & strpos(Model,"Turbo Gt2")!=0
replace Model="Porsche 911" if Make=="Porsche" & Model=="Turbo"

replace Model="Porsche 912" if (Make=="Porsche") & strpos(Model,"912")==1
replace Model="Porsche 914" if (Make==""|Make=="Porsche") & strpos(Model,"914")==1
replace Model="Porsche 924" if (Make==""|Make=="Porsche") & strpos(Model,"924")==1
replace Model="Porsche 928" if (Make==""|Make=="Porsche") & strpos(Model,"928")==1
replace Model="Porsche 930" if (Make==""|Make=="Porsche") & strpos(Model,"930")==1
replace Model="Porsche 944" if (Make==""|Make=="Porsche") & strpos(Model,"944")==1
replace Model="Porsche 968" if (Make==""|Make=="Porsche") & strpos(Model,"968")==1
replace Model="Porsche Boxster" if Make=="Porsche" & strpos(Model,"Boxster")==1
replace Model="Porsche Carrera" if Make=="Porsche" & (strpos(Model,"Carrera")==1|strpos(Model,"Turbo Carrera")==1)
replace Model="Porsche Cayenne" if Make=="Porsche" & strpos(Model,"Cayenne")==1
replace Model="Porsche Cayman" if Make=="Porsche" & strpos(Model,"Cayman")==1
replace Model="Porsche Targa" if Make=="Porsche" & strpos(Model,"Targa")==1
replace Model="Porsche Turbo Kit" if Make=="Porsche" & strpos(Model,"Turbo Kit")==1
** Additional for CARLIN
replace Model="Porsche 911" if strpos(Model,"911")==1 & VClass!=""
replace Model="Porsche 924" if strpos(Model,"924")==1 & VClass!=""
replace Model="Porsche 928" if strpos(Model,"928")==1 & VClass!=""


** Renault **
replace Model="Renault 5" if Make=="Renault" & Model=="5"
replace Model="Renault 12" if Make=="Renault" & (Model=="12"|Model=="12 Wagon")
replace Model="Renault 15" if Make=="Renault" & Model=="15"
replace Model="Renault 17" if (Make==""|Make=="Renault") & strpos(Model,"17")==1
replace Model="Renault 18" if (Make==""|Make=="Renault") & strpos(Model,"18")==1 & strpos(Model,"Wagon")==0
replace Model="Renault Alliance" if (Make==""|Make=="Renault") & strpos(Model,"Alliance")==1 & strpos(Model,"Encore")==0
replace Model="Renault Alliance/Encore" if (Make==""|Make=="Renault") & strpos(Model,"Alliance")==1 & strpos(Model,"Encore")!=0
replace Model="Renault Fuego" if (Make==""|Make=="Renault") & strpos(Model,"Fuego")==1
replace Model="Renault Gta" if (Make=="Renault") & strpos(Model,"Gta")==1
replace Model="Renault Lecar" if (Make==""|Make=="Renault") & (strpos(Model,"Le Car")==1|strpos(Model,"Lecar")==1)
replace Model="Renault Medallion" if (Make==""|Make=="Eagle") & strpos(Model,"Renault Medallion")==1
replace Model="Renault Sportwagon" if (Make=="Renault") & (strpos(OModel,"Sportwagon")!=0|OModel=="18I 4Dr Wagon")


** Rover **
replace Model="Rover Defender 110" if (Make=="Land Rover") & strpos(Model,"Defender 110")==1
replace Model="Rover Defender 90" if (Make=="Land Rover") & strpos(Model,"Defender 90")==1
replace Model="Rover Discovery" if (Make=="Land Rover") & strpos(Model,"Discovery")==1
replace Model="Rover Freelander" if (Make=="Land Rover") & strpos(Model,"Freelander")==1
replace Model="Rover Lr2" if (Make=="Land Rover") & strpos(Model,"Lr2")==1
replace Model="Rover Lr3" if (Make=="Land Rover") & strpos(Model,"Lr3")==1
replace Model="Rover Range Rover" if (Make=="Land Rover") & strpos(Model,"Range Rover")==1

** Saab **
replace Model="Saab 99" if (Make==""|Make=="Saab") & strpos(Model,"99")==1
replace Model="Saab 900" if (Make==""|Make=="Saab") & (strpos(Model,"900")==1 & strpos(Model,"9000")==0)|Model=="Convertible"
replace Model="Saab 900" if (Make=="Saab") & Model=="9" & ModelYear==1984
replace Model="Saab 9000" if (Make==""|Make=="Saab") & strpos(Model,"9000")==1
replace Model="Saab 9-3" if (Make=="Saab") & strpos(Model,"9-3")==1
replace Model="Saab 9-5" if (Make=="Saab") & strpos(Model,"9-5")==1
* The csv file thinks that this model name is a date . . . fixed here:
replace Model="Saab 9-3" if (Make=="Saab") & strpos(Model,"3-Sep")==1
replace Model="Saab 9-5" if (Make=="Saab") & strpos(Model,"5-Sep")==1
replace Model="Saab 9-2X" if (Make=="Saab") & strpos(Model,"9-2X")==1
replace Model="Saab 9-7X" if (Make=="Saab") & strpos(Model,"9-7X")==1


** Saturn **
replace Model="Saturn Aura" if (Make==""|Make=="Saturn") & strpos(Model,"Aura")==1
replace Model="Saturn Astra" if Make=="Saturn" & strpos(Model,"Astra")==1
replace Model="Saturn Ion" if Make=="Saturn" & strpos(Model,"Ion")==1
replace Model="Saturn L100/200" if Make=="Saturn" & strpos(Model,"L100/200")==1
replace Model="Saturn L200" if Make=="Saturn" & strpos(Model,"L200")==1
replace Model="Saturn L300" if Make=="Saturn" & strpos(Model,"L300")==1
replace Model="Saturn Ls" if Make=="Saturn" & strpos(Model,"Ls")==1
replace Model="Saturn Lw" if Make=="Saturn" & Model=="Lw"
replace Model="Saturn Lw200" if Make=="Saturn" & Model=="Lw200"
replace Model="Saturn Lw300" if Make=="Saturn" & Model=="Lw300"
replace Model="Saturn Outlook" if Make=="Saturn" & strpos(Model,"Outlook")==1
replace Model="Saturn Relay" if Make=="Saturn" & strpos(Model,"Relay")==1
replace Model="Saturn Sc" if (Make=="Saturn") & strpos(Model,"Sc")==1
replace Model="Saturn Sky" if (Make=="Saturn") & strpos(Model,"Sky")==1
replace Model="Saturn Sl" if (Make=="Saturn") & strpos(Model,"Sl")==1
replace Model="Saturn Sw" if (Make=="Saturn") & strpos(Model,"Sw")==1
replace Model="Saturn Vue" if (Make=="Saturn") & strpos(Model,"Vue")==1


** Scion **
replace Model="Scion Tc" if (Make=="Scion") & Model=="Tc"
replace Model="Scion Xa" if (Make=="Scion") & Model=="Xa"
replace Model="Scion Xb" if (Make=="Scion") & Model=="Xb"
replace Model="Scion Xd" if (Make=="Scion") & Model=="Xd"

** Sterling
replace Model="Sterling 825" if (strpos(Make,"Sterling")!=0) & Model=="825"
replace Model="Sterling 827" if (strpos(Make,"Sterling")!=0) & Model=="827"


** Subaru **
replace Model="Subaru B9 Tribeca" if (Make=="Subaru") & strpos(Model,"B9 Tribeca")==1
replace Model="Subaru Baja" if (Make=="Subaru") & strpos(Model,"Baja")==1
replace Model="Subaru Brat" if (Make==""|Make=="Subaru") & strpos(Model,"Brat")==1
replace Model="Subaru Forester" if (Make=="Subaru") & strpos(Model,"Forester")==1
replace Model="Subaru Hatchback" if (Make=="Subaru") & strpos(Model,"Hatchback")==1
replace Model="Subaru Impreza" if (Make=="Subaru") & strpos(Model,"Impreza")==1 & strpos(Model,"Outback")==0
replace Model="Subaru Impreza Wagon/Outback Sport" if (Make=="Subaru") & strpos(Model,"Impreza")==1 & strpos(Model,"Outback")!=0 & strpos(Model,"Outback")!=0
replace Model="Subaru Justy" if (Make=="Subaru") & strpos(Model,"Justy")==1
replace Model="Subaru Legacy" if (Make=="Subaru") & strpos(Model,"Legacy")==1 & strpos(Model,"Outback")==0
replace Model="Subaru Legacy/Outback" if (Make=="Subaru") & strpos(Model,"Legacy")==1 & strpos(Model,"Outback")!=0
replace Model="Subaru Loyale" if (Make=="Subaru") & strpos(Model,"Loyale")==1
replace Model="Subaru Outback" if (Make=="Subaru") & strpos(Model,"Outback")==1
replace Model="Subaru Sedan" if (Make=="Subaru") & strpos(Model,"Sedan")==1
replace Model="Subaru Wagon" if (Make=="Subaru") & (strpos(Model,"Subaru Wagon")==1|strpos(Model,"Subaru 4Wd Wagon")==1|strpos(Model,"Wagon")==1)
replace Model="Subaru Svx" if (Make=="Subaru") & strpos(Model,"Svx")==1
replace Model="Subaru Tribeca" if (Make=="Subaru") & strpos(Model,"Tribeca")==1
replace Model="Subaru Xt" if (Make=="Subaru") & strpos(Model,"Xt")==1
replace Model="Subaru Wagon" if (Make==""|Make=="Subaru") & strpos(Model,"Subaru Wagon")==1
** Grouping
replace Model="Subaru Series" if (Model=="Subaru"|strpos(Model,"Subaru 4Wd")==1)
replace Model="Subaru Series" if (Model=="Subaru Hatchback"|Model=="Subaru Sedan"|Model=="Subaru Wagon"|Model=="3 Door 4Wd Turbo")

** Collapse the Legacys
replace Model = "Subaru Legacy" if Make=="Subaru" & (Model=="Subaru Legacy/Outback"|Model=="Subaru Outback")

** Suzuki **
replace Model="Suzuki Aerio" if (Make=="Suzuki") & strpos(Model,"Aerio")==1
replace Model="Suzuki Esteem" if (Make=="Suzuki") & strpos(Model,"Esteem")==1
replace Model="Suzuki Forenza" if (Make=="Suzuki") & strpos(Model,"Forenza")==1
replace Model="Suzuki Forsa" if (Make=="Suzuki") & strpos(Model,"Forsa")==1
replace Model="Suzuki Grand Vitara" if (Make=="Suzuki") & strpos(Model,"Grand Vitara")==1&strpos(Model,"Xl7")==0
replace Model="Suzuki Reno" if (Make=="Suzuki") & strpos(Model,"Reno")==1
replace Model="Suzuki Sa310" if (Make=="Suzuki") & strpos(Model,"Sa310")==1
replace Model="Suzuki Samurai" if (Make=="Suzuki") & strpos(Model,"Samurai")==1
replace Model="Suzuki Sidekick" if (Make=="Suzuki") & strpos(Model,"Sidekick")==1
replace Model="Suzuki Sj410" if (Make==""|Make=="Suzuki") & (strpos(Model,"Sj4")==1|strpos(Model,"Sj 4")==1)
replace Model="Suzuki Swift" if (Make=="Suzuki") & (strpos(Model,"Swift")==1|Model=="Sw")
replace Model="Suzuki Sx4" if (Make=="Suzuki") & strpos(Model,"Sx4")==1
replace Model="Suzuki Verona" if (Make=="Suzuki") & strpos(Model,"Verona")==1
replace Model="Suzuki Vitara" if (Make=="Suzuki") & strpos(Model,"Vitara")==1
replace Model="Suzuki X-90" if (Make=="Suzuki") & strpos(Model,"X-90")==1
replace Model="Suzuki Xl7" if (Make=="Suzuki") & strpos(OModel,"Xl7")!=0


** Toyota **
replace Model="Toyota 4Runner" if (Make=="Toyota") & (strpos(Model,"4Runner")==1|strpos(Model,"4-Runner")==1)
replace Model="Toyota Avalon" if (Make==""|Make=="Toyota") & strpos(Model,"Avalon")==1
replace Model="Toyota Truck" if (Make==""|Make=="Toyota") & strpos(Model,"1-Ton Truck")==1
replace Model="Toyota Cab" if (Make=="Toyota") & strpos(Model,"Cab")==1
replace Model="Toyota Cab" if (Make=="") & Model=="Cab Chassis"
replace Model="Toyota Camry" if (Make==""|Make=="Toyota") & strpos(Model,"Camry")==1 & strpos(Model,"Solara")==0
replace Model="Toyota Camry Solara" if (Make==""|Make=="Toyota") & strpos(Model,"Camry")==1 & strpos(Model,"Solara")!=0
replace Model="Toyota Van" if (Make=="Toyota") & strpos(Model,"Van")!=0
replace Model="Toyota Celica" if (Make==""|Make=="Toyota") & strpos(Model,"Celica")==1
replace Model="Toyota Corolla" if (Make==""|Make=="Toyota") & strpos(Model,"Corolla")==1 & strpos(Model,"Tercel")==0
replace Model="Toyota Tercel" if (Make==""|Make=="Toyota") & strpos(Model,"Tercel")!=0
replace Model="Toyota Corona" if (Make==""|Make=="Toyota") & strpos(Model,"Corona")==1 & strpos(Model,"Mk")==0
replace Model="Toyota Corona Mk Ii" if (Make==""|Make=="Toyota") & strpos(Model,"Corona")==1 & strpos(Model,"Mk")!=0
replace Model="Toyota Cressida" if (Make==""|Make=="Toyota") & strpos(Model,"Cressida")==1
replace Model="Toyota Echo" if (Make=="Toyota") & strpos(Model,"Echo")==1
replace Model="Toyota Fj Cruiser" if (Make=="Toyota") & strpos(Model,"Fj Cruiser")==1
replace Model="Toyota Highlander" if (Make=="Toyota") & strpos(Model,"Highlander")==1
replace Model="Toyota Hilux" if (Make==""|Make=="Toyota") & strpos(Model,"Hilux")==1
replace Model="Toyota Land Cruiser" if (Make==""|Make=="Toyota") & strpos(Model,"Land Cruiser")==1
replace Model="Toyota Matrix" if (Make=="Toyota") & strpos(Model,"Matrix")==1
replace Model="Toyota Mr2" if (Make=="Toyota") & strpos(Model,"Mr2")==1
replace Model="Toyota Paseo" if (Make=="Toyota") & strpos(Model,"Paseo")==1
replace Model="Toyota Previa" if (Make=="Toyota") & strpos(Model,"Previa")==1
replace Model="Toyota Prius" if (Make=="Toyota") & strpos(Model,"Prius")==1
replace Model="Toyota Rav4" if (Make=="Toyota") & strpos(Model,"Rav4")==1
replace Model="Toyota Sequoia" if (Make=="Toyota") & strpos(Model,"Sequoia")==1
replace Model="Toyota Sienna" if (Make=="Toyota") & strpos(Model,"Sienna")==1
replace Model="Toyota Starlet" if (Make==""|Make=="Toyota") & strpos(Model,"Starlet")==1
replace Model="Toyota Supra" if (Make==""|Make=="Toyota") & strpos(OModel,"Supra")!=0 /* This will include the Celica Supra */
replace Model="Toyota T100" if (Make=="Toyota") & strpos(Model,"T100")==1
replace Model="Toyota Tacoma" if (Make=="Toyota") & strpos(Model,"Tacoma")==1
replace Model="Toyota Tercel" if (Make==""|Make=="Toyota") & strpos(Model,"Tercel")==1
replace Model="Toyota Truck" if (Make=="Toyota") & strpos(Model,"Truck")==1
replace Model="Toyota Tundra" if (Make=="Toyota") & strpos(Model,"Tundra")==1
replace Model="Toyota Van" if (Make=="Toyota") & strpos(Model,"Van")==1
replace Model="Toyota Yaris" if (Make=="Toyota") & strpos(Model,"Yaris")==1
** Grouping
replace Model="Toyota Truck" if (Model=="Toyota Pickup"|Model=="Toyota Cab")


** Triumph **
replace Model="Triumph Spitfire" if (Make==""|Make=="Triumph") & strpos(Model,"Spitfire")==1
replace Model="Triumph Tr6" if (Make=="Triumph") & strpos(Model,"Tr-6")==1
replace Model="Triumph Tr7" if (Make=="Triumph") & strpos(Model,"Tr-7")==1
replace Model="Triumph Tr8" if (Make=="") & Model=="Tr"


** Volkswagen **
replace Model="Volkswagen Beetle" if (Make==""|Make=="Volkswagen") & strpos(Model,"Beetle")==1
replace Model="Volkswagen Rabbit" if (Make==""|Make=="Volkswagen") & strpos(Model,"Rabbit")==1
replace Model="Volkswagen Cabrio" if Make=="Volkswagen" & strpos(Model,"Cabrio")==1 & strpos(Model,"Cabriolet")==0
replace Model="Volkswagen Cabriolet" if Make=="Volkswagen" & strpos(Model,"Cabriolet")==1 
replace Model="Volkswagen Corrado" if Make=="Volkswagen" & strpos(Model,"Corrado")==1 
replace Model="Volkswagen Dasher" if (Make==""|Make=="Volkswagen") & strpos(Model,"Dasher")==1 
replace Model="Volkswagen Eos" if (Make=="Volkswagen") & strpos(Model,"Eos")==1 
replace Model="Volkswagen Eurovan" if (Make=="Volkswagen") & strpos(Model,"Eurovan")==1 
replace Model="Volkswagen Fox" if (Make==""|Make=="Volkswagen") & strpos(Model,"Fox")==1 
replace Model="Volkswagen Golf" if (Make=="Volkswagen") & strpos(Model,"Golf")==1 & strpos(Model,"Iii")==0 & strpos(Model,"Gti")==0
replace Model="Volkswagen Golf/Gti" if (Make=="Volkswagen") & strpos(Model,"Golf")==1 & strpos(Model,"Gti")!=0
replace Model="Volkswagen Golf Iii" if (Make=="Volkswagen") & strpos(Model,"Golf")==1 & strpos(Model,"Iii")!=0
replace Model="Volkswagen Gti" if (Make=="Volkswagen") & strpos(Model,"Gti")==1 & strpos(Model,"Golf")==0
replace Model="Volkswagen Gti/Golf" if (Make=="Volkswagen") & strpos(Model,"Gti")==1 & strpos(Model,"Golf")!=0
replace Model="Volkswagen Jetta" if (Make==""|Make=="Volkswagen") & strpos(Model,"Jetta")==1 & strpos(Model,"Iii")==0
replace Model="Volkswagen Jetta Iii" if (Make==""|Make=="Volkswagen") & strpos(Model,"Jetta")==1 & strpos(Model,"Iii")!=0
replace Model="Volkswagen New Beetle" if (Make=="Volkswagen") & strpos(Model,"New Beetle")==1
replace Model="Volkswagen Golf" if (Make=="Volkswagen") & strpos(Model,"New Golf")==1
replace Model="Volkswagen Gti" if (Make=="Volkswagen") & strpos(Model,"New Gti")==1
replace Model="Volkswagen Jetta" if (Make=="Volkswagen") & strpos(Model,"New Jetta")==1
replace Model="Volkswagen Passat" if (Make=="Volkswagen") & strpos(Model,"Passat")==1
replace Model="Volkswagen Phaeton" if (Make=="Volkswagen") & strpos(Model,"Phaeton")==1
replace Model="Volkswagen Quantum" if (Make==""|Make=="Volkswagen") & strpos(Model,"Quantum")==1
replace Model="Volkswagen R32" if (Make=="Volkswagen") & strpos(Model,"R32")==1
replace Model="Volkswagen Scirocco" if (Make==""|Make=="Volkswagen") & strpos(Model,"Scirocco")==1
replace Model="Volkswagen The Thing" if (Make=="Volkswagen") & strpos(Model,"Thing")==1
replace Model="Volkswagen Touareg" if (Make=="Volkswagen") & strpos(Model,"Touareg")==1
replace Model="Volkswagen Vanagon" if (Make==""|Make=="Volkswagen") & strpos(Model,"Vanagon")==1
replace Model="Volkswagen Kombi" if (Make==""|Make=="Volkswagen") & (strpos(Model,"Kombi")!=0)


** Volvo **
replace Model="Volvo 160" if Make=="Volvo" & strpos(Model,"160")==1
replace Model="Volvo 240" if Make=="Volvo" & strpos(Model,"240")==1
replace Model="Volvo 260" if Make=="Volvo" & strpos(Model,"260")==1
replace Model="Volvo 245" if Make=="Volvo" & strpos(Model,"245")==1
replace Model="Volvo 265" if Make=="Volvo" & strpos(Model,"265")==1
replace Model="Volvo 740" if Make=="Volvo" & strpos(Model,"740")==1 & strpos(Model,"760")==0
replace Model="Volvo 740/760" if Make=="Volvo" & strpos(Model,"740")==1 & strpos(Model,"760")!=0
replace Model="Volvo 760" if Make=="Volvo" & (strpos(Model,"760")==1|(Model=="76"&ModelYear==1984))
replace Model="Volvo 760" if Make=="" & Model=="760Gle" & ModelYear==1983
replace Model="Volvo 780" if Make=="Volvo" & strpos(Model,"780")==1
replace Model="Volvo 850" if Make=="Volvo" & strpos(Model,"850")==1
replace Model="Volvo 940" if Make=="Volvo" & strpos(Model,"940")==1
replace Model="Volvo 960" if Make=="Volvo" & strpos(Model,"960")==1
replace Model="Volvo C30" if Make=="Volvo" & strpos(Model,"C30")==1
replace Model="Volvo C70" if Make=="Volvo" & (strpos(Model,"C70")==1|strpos(Model,"New C70")==1)
replace Model="Volvo Dl/Gl/Glt" if (Make==""|Make=="Volvo") & (strpos(Model,"Dl/Gl/Glt")==1|strpos(Model,"Dl/Gl/Turbo")==1)
replace Model="Volvo S40" if Make=="Volvo" & strpos(Model,"S40")==1
replace Model="Volvo S60" if Make=="Volvo" & strpos(Model,"S60")==1
replace Model="Volvo S70" if Make=="Volvo" & strpos(Model,"S70")==1
replace Model="Volvo S80" if Make=="Volvo" & strpos(Model,"S80")==1
replace Model="Volvo S90" if Make=="Volvo" & strpos(Model,"S90")==1
replace Model="Volvo V40" if Make=="Volvo" & strpos(Model,"V40")==1
replace Model="Volvo V50" if Make=="Volvo" & strpos(Model,"V50")==1
replace Model="Volvo V70" if Make=="Volvo" & strpos(Model,"V70")==1
replace Model="Volvo V90" if Make=="Volvo" & strpos(Model,"V90")==1
replace Model="Volvo Sedan" if Make=="" & strpos(Model,"Volvo Sedan")==1
replace Model="Volvo Wagon" if (strpos(Model,"Volvo Station Wagon")==1|strpos(Model,"Volvo Wagon")==1)
replace Model="Volvo Xc70" if Make=="Volvo" & strpos(Model,"Xc 70")==1
replace Model="Volvo Xc90" if Make=="Volvo" & strpos(Model,"Xc 90")==1
** Grouping
replace Model="Volvo 240" if Model=="Volvo 245"
replace Model="Volvo 260" if Model=="Volvo 265"
replace Model="Volvo Sedan/Wagon" if (Model=="Volvo Sedan"|Model=="Volvo Wagon")


** Yugo **
replace Model="Yugo Gv" if Make=="Yugo" & strpos(Model,"Gv")==1 & strpos(Model,"Gvx")==0 & strpos(Model,"Gvl")==0 & strpos(Model,"Gvc")==0 & strpos(Model,"Gvs")==0 & strpos(Model,"Cabrio")==0
replace Model="Yugo Gv+/Gv/Cabrio" if Make=="Yugo" & strpos(Model,"Gv Plus/Gv/Cabrio")==1
replace Model="Yugo Gv/Gvx" if Make=="Yugo" & (strpos(Model,"Gv/Gvx")==1|strpos(Model,"Gy/Yugo Gvx")==1)
** Grouping
replace Model="Yugo Gv Series" if strpos(Model,"Yugo")==1



****************************************************

replace Model="Jeep Liberty" if Model=="Jeep Liberty/Cherokee"


include Data/EPAMPG/EPASubmodels.do 

