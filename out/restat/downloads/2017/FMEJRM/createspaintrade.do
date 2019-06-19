/*The dataset used witsdataset.csv was downloaded from the UN COMTRADE database using WITS, http://wits.worldbank.org
It contains imports and exports of Spain.
reporter=Spain; NACE Rev 1; years:1988-2010; partner=all countries in world
It contains the following variables:

Contains data
  obs:        32,297                          
 vars:            14                          
 size:     4,004,828                          
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
nomenclature    str2    %9s                   Nomenclature
reporteriso3    str3    %9s                   ReporterISO3
productcode     str6    %9s                   ProductCode
reportername    str5    %9s                   ReporterName
partneriso3     str4    %9s                   PartnerISO3
partnername     str34   %34s                  PartnerName
year            int     %8.0g                 Year
tradeflowname   str6    %9s                   TradeFlowName
tradeflowcode   byte    %8.0g                 TradeFlowCode
tradevaluein1~d float   %9.0g                 TradeValue in 1000 USD
quantity        double  %10.0g                Quantity
quantitytoken   byte    %8.0g                 QuantityToken
qtyunit         str13   %13s                  QtyUnit
productdescri~n str35   %35s                  ProductDescription
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Sorted by:  

*/
insheet using "spaintrade.csv", clear
cap drop  nomenclature
gen tradevalueinUSD= tradevaluein1000usd*1000
drop  tradeflowcode tradevaluein1000usd
drop if  tradeflowname=="Gross Exp."
drop if  tradeflowname=="Gross Imp."
drop if  tradeflowname=="Re-Import"
collapse (sum) tradevalueinUSD, by(reporteriso3 productcode  partneriso3 year tradeflowname)
reshape wide  tradevalueinUSD, i( reporteriso3 productcode  partneriso3 year) j( tradeflowname) string
rename  tradevalueinUSDExport exportusd
rename  tradevalueinUSDImport importusd
drop if partneriso3=="EU27"
drop if partneriso3=="All"
replace exportusd=0 if exportusd==.
replace importusd=0 if importusd==.
//regroup industries to naceclio
replace productcode="0" if productcode==" Total"
destring productcode, replace
rename productcode ind
gen naceclio=.
replace naceclio=0 if ind==0
replace naceclio=1 if ind==151
replace naceclio=2 if (ind>=152 & ind<=158)
replace naceclio=2 if ind==160
replace naceclio=3 if ind==159
replace naceclio=4 if (ind>=171 & ind<=177)
replace naceclio=4 if (ind>=181 & ind<=183)
replace naceclio=5 if (ind>=191 & ind<=193)
replace naceclio=6 if (ind>=201 & ind<=205)
replace naceclio=7 if (ind==211 | ind==212)
replace naceclio=8 if (ind>=221 & ind<=223)
replace naceclio=9 if (ind>=241 & ind<=247)
replace naceclio=10 if (ind>=251 & ind<=252)
replace naceclio=11 if (ind>=261 & ind<=268)
replace naceclio=12 if (ind>=271 & ind<=275)
replace naceclio=13 if (ind>=281 & ind<=287)
replace naceclio=14 if (ind>=291 & ind<=297)
replace naceclio=15 if (ind==300 |(ind>=331 & ind<=335))
replace naceclio=16 if (ind>=311 & ind<=316)
replace naceclio=16 if (ind>=321 & ind<=323)
replace naceclio=17 if (ind>=341 & ind<=343)
replace naceclio=18 if (ind>=351 & ind<=355)
replace naceclio=19 if (ind==361)
replace naceclio=20 if (ind>=362 & ind<=366)
replace naceclio=20 if (ind>=371 & ind<=372)
gen nacecliodescr=""
replace nacecliodescr="Total trade" if naceclio==0
replace nacecliodescr="Meat related products" if naceclio==1
replace nacecliodescr="Food and tobacco" if naceclio==2
replace nacecliodescr="Beverage" if naceclio==3
replace nacecliodescr="Textiles and clothing" if naceclio==4
replace nacecliodescr="Leather, fur and footwear" if naceclio==5
replace nacecliodescr="Timber" if naceclio==6
replace nacecliodescr="Paper" if naceclio==7
replace nacecliodescr="Printing and publishing" if naceclio==8
replace nacecliodescr="Chemicals" if naceclio==9
replace nacecliodescr="Plastic and rubber products" if naceclio==10
replace nacecliodescr="Nonmetal mineral products" if naceclio==11
replace nacecliodescr="Basic metal products" if naceclio==12
replace nacecliodescr="Fabricated metal products" if naceclio==13
replace nacecliodescr="Industrial and agricultural equipment" if naceclio==14
replace nacecliodescr="Computer products, electronics and optical" if naceclio==15
replace nacecliodescr="Electric materials and accessories" if naceclio==16
replace nacecliodescr="Vehicles and accessories" if naceclio==17
replace nacecliodescr="Other transportation materials" if naceclio==18
replace nacecliodescr="Furniture" if naceclio==19
replace nacecliodescr="Misc." if naceclio==20
drop  reporteriso3 ind 
collapse (sum) exportusd importusd  , by(naceclio nacecliodescr  partneriso3 year)
drop nacecliodescr 
reshape wide exportusd importusd, i(naceclio year) j(partneriso3) string
drop import*
label var naceclio "NACECLIO industry classification"
label var year "Year"
label var exportusdEU25 "Exports to EU25, USD"
label var exportusdWLD "Exports to world, USD"
keep if year>=2003
save "spaintrade.dta", replace
