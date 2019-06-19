clear all
set more off

**********PENN WORLD TABLE: p,y**********

insheet using ~/borja2/DATA/sources/pennwt.csv, names

rename yr year
replace isocode = "DEU" if isocode == "GER"

drop if p==. | y==.

label var y "CGDP Relative to the US (PWT)"
label var p "Price Level of Gross Domestic Product (PWT)"

save ~/borja2/DATA/sources/pennwt.dta, replace

clear

**********PENN WORLD TABLE: rgdpch, grgdpch**********

insheet using ~/borja2/DATA/sources/pennwt_controls.csv, names

rename yr year
replace isocode = "DEU" if isocode == "GER"

label var rgdpch "Real GDP per Capita: Constant Prices (PWT)"
label var grgdpch "Growth Rate of Real GDP per Capita: Constant Prices (PWT)"

save ~/borja2/DATA/sources/pennwt_controls.dta, replace

clear

**********BECK et al., WORLD BANK: stock mkt cap/gdp**********

insheet using ~/borja2/DATA/sources/wb_fin_dev.txt, names

rename countrycode isocode
rename countryname country
rename stockmarketcapitalizationtogdp stockmkt_gdp_wb

label var stockmkt_gdp_wb "Stock Market Cap to GDP (WB-Beck et al.)"

save ~/borja2/DATA/sources/wb_fin_dev.dta, replace

clear

**********SHLEIFER, legal origin**********

insheet using ~/borja2/DATA/sources/legal_origin.txt, names

label var brit_new "British Legal Origin"
label var fren_new "French Legal Origin"
label var germ_new "German Legal Origin"
label var scan_new "Scandinavian Legal Origin"
label var socialist_new "Socialist Legal Origin"

save ~/borja2/DATA/sources/legal_origin.dta, replace

clear

**********WDI: current account balance and general govt final consumption expenditure**********

insheet using ~/borja2/DATA/sources/wdi_cab.txt, names

rename country isocode
rename country_name country
drop ind1 ind1_desc

forval i = 5(1)49 {
  local j = `i'+1955
  rename v`i' v`j'
}

gen id = _n
reshape long v, j(year) i(id)
drop id

gen cab = real(v)
replace cab = cab/100
drop v

label var cab "Current Account Balance to GDP (WDI)"

save ~/borja2/DATA/sources/wdi_cab.dta, replace

clear

insheet using ~/borja2/DATA/sources/wdi_govt_c.txt, names

rename country isocode
rename country_name country
drop ind1 ind1_desc

forval i = 5(1)49 {
  local j = `i'+1955
  rename v`i' v`j'
}

gen id = _n
reshape long v, j(year) i(id)
drop id

gen govt_c = real(v)
replace govt_c = govt_c/100
drop v

label var govt_c "General Govt Final Consumption Expenditure to GDP (WDI)"

save ~/borja2/DATA/sources/wdi_govt_c.dta, replace

clear

**********EASTERLY, WORLD BANK: terms of trade**********

insheet using ~/borja2/DATA/sources/wb_tot.txt, names

forval i = 3(1)27 {
  local j = `i'+1972
  rename v`i' v`j'
}

gen id = _n
reshape long v, j(year) i(id)
drop id

gen tot = real(v)
drop v

label var tot "Terms of Trade from Easterly's dataset(WB)"

save ~/borja2/DATA/sources/tot_wb.dta, replace

clear

**********SHLEIFER, employment law, collective law and social security law indices**********

insheet using ~/borja2/DATA/sources/employment_law.txt, names
label var employment_law "Shleifer et al.(2004)QJE"
save ~/borja2/DATA/sources/employment_law.dta, replace
clear

insheet using ~/borja2/DATA/sources/collective_law.txt, names
label var collective_law "Shleifer et al.(2004)QJE"
save ~/borja2/DATA/sources/collective_law.dta, replace
clear

insheet using ~/borja2/DATA/sources/ssecurity_law.txt, names
label var ssecurity_law "Shleifer et al.(2004)QJE"
save ~/borja2/DATA/sources/ssecurity_law.dta, replace
clear

**********SHLEIFER, number of procedures**********

use ~/borja2/DATA/sources/registration_new.dta

keep country procedures

label var procedures "Shleifer et al.(2002)QJE"

replace country="Korea, Republic of" if country=="Korea, Rep."
replace country="Hong Kong" if country=="Hong Kong SAR"
replace country="Russia" if country=="Russian Federation"
replace country="Egypt" if country=="Egypt, Arab Rep."
replace country="Taiwan" if country=="Taiwan, China"

save ~/borja2/DATA/sources/procedures.dta, replace

clear

**********REINHART et al.: exchange rate flexibility index**********

use "/export/home/a1mxg02/borja2/DATA/sources/annual1.dta"

replace country="Czech Republic" if country=="Czech Rep"
replace country="Korea, Republic of" if country=="Korea"
replace country="Slovak Republic" if country=="Slovak Rep"
replace country="Trinidad &Tobago" if country=="Trinidad Tob"
replace country="United Kingdom" if country=="UK"
replace country="United States" if country=="US"
replace country="Cote "+"d"+"`"+"Ivoire" if country=="Cote D'Ivoire"

save ~/borja2/DATA/sources/xrate_flexibility.dta, replace


