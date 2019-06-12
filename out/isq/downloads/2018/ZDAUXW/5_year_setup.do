cd "___YOUR_PATH_HERE___"
use panel.dta


***** PREPARE PANEL FOR AVERAGING *********
gen fiveyears = .
keep if year < 1996
replace fiveyears = 5 if year < 1996
replace fiveyears = 4 if year < 1991
replace fiveyears = 3 if year < 1986
replace fiveyears = 2 if year < 1981
replace fiveyears = 1 if year < 1976

genl countryfiveyear = iso_num*10+fiveyear
gen fivecount = mod(year,5)+1
order  iso_num year  countryyear fiveyears countryfiveyear fivecount



***** CREATE FIVE YEAR AVERAGES **********
by countryfiveyear, sort: egen kaopen_5 = mean(kaopen)
label var kaopen_5 "KAOPEN"

by countryfiveyear, sort: egen ckaopen_5 = mean(ckaopen)
label var ckaopen_5 "CKAOPEN"

by countryfiveyear, sort: egen k3_5 = mean(k3)
label var k3_5 "K3"

by countryfiveyear, sort: egen cabalance_5  = mean(cabalance)
label var cabalance_5 "CABALANCE"

by countryfiveyear, sort: egen lngdp_ppp2000_5 = mean(lngdp_ppp2000)
label var lngdp_ppp2000_5 "LNGDP"

by countryfiveyear, sort: egen lngdppc_ppp2000_5  = mean(lngdppc_ppp2000)
label var lngdppc_ppp2000_5 "LNGDPPC"

by countryfiveyear, sort: egen gov_fce_5 = mean(gov_fce)
label var gov_fce_5 "EXPENDITURE"

by countryfiveyear, sort: egen growth_gdppc2000_5 = mean(growth_gdppc2000)
label var growth_gdppc2000_5 "GROWTH"

by countryfiveyear, sort: egen ln_inf_5 = mean(ln_inf)
label var ln_inf_5 "INFLATION"

by countryfiveyear, sort: egen privcred_gdp_5 = mean(privcred_gdp)
label var privcred_gdp_5 "PRIVATE CREDIT"

by countryfiveyear, sort: egen reserves_imports_5 = mean(reserves_imports)
label var reserves_imports_5 "RESERVES_IMPORTS"

by countryfiveyear, sort: egen savings_5 = mean(savings)
label var savings_5 "SAVINGS"

by countryfiveyear, sort: egen trade_5 = mean(trade)
label var trade_5 "TRADE"

by countryfiveyear, sort: egen peg_5 = mean(peg)
label var peg_5 "PEG"

by countryfiveyear, sort: egen crisis_5 = mean(eventld)
label var crisis_5 "CRISIS"

by countryfiveyear, sort: egen istar_5 = mean(istar)
label var istar_5 "ISTAR"

by countryfiveyear, sort: egen polity2_5 = mean(polity2)
label var polity2_5 "POLITY2"

by countryfiveyear, sort: egen polconiii_5 = mean(polconiii)
label var polconiii_5 "POLCONIII"

by countryfiveyear, sort: egen s_cap_5 = mean(c_cap100)
label var s_cap_5 "S_CAP"


***** SET UP THE FIVE YEAR PANEL *********
keep if fivecount==1
drop if fiveyear==.
drop if year < 1970
sort countryfiveyear
xtset iso_num fiveyear


***** CREATE LAGS AND INTERACTION TERMS ***********
gen distar_5 = d.istar_5
label var distar_5 "D ISTAR"

gen listar_5 = l.istar_5
label var listar_5 "L ISTAR"

gen lcrisis_5 = l.crisis_5
label var lcrisis_5 "L CRISIS"

gen dkaopen_5 = d.kaopen_5
label var dkaopen_5 "D KAOPEN"

gen dckaopen_5 = d.ckaopen_5
label var dckaopen_5 "D CKAOPEN"

gen dk3_5 = d.k3_5
label var dk3_5 "D K3"

gen ds_cap_5 = d.s_cap_5
label var ds_cap_5 "D S_CAP"

gen lkaopen_5 = l.kaopen_5
label var lkaopen_5 "L KAOPEN"

gen lckaopen_5 = l.ckaopen_5
label var lckaopen_5 "L CKAOPEN"

gen lk3_5 = l.k3_5
label var lk3_5 "L K3"

gen ls_cap_5 = l.s_cap_5
label var ls_cap_5 "L S_CAP"

gen politycrisis_5 = polity2_5*lcrisis_5
label var politycrisis_5 "POLITY * L CRISIS"

gen polityistar_5 = polity2_5*listar_5
label var polityistar_5 "POLITY * L ISTAR"

gen polconiiicrisis_5 = polconiii_5*lcrisis_5
label var polconiiicrisis_5 "POLCON * L CRISIS"

gen polconiiiistar_5 = polconiii_5*listar_5
label var polconiiiistar_5 "POLCON * L ISTAR"


***** DROP OLD VARIABLES, UNNEEDED COUNTRIES ***************
#delimit ;

keep iso_num year countryyear fiveyears countryfiveyear sample counter country_name ccode ifscode kaopen_5
	ckaopen_5 k3_5 cabalance_5 lngdp_ppp2000_5 lngdppc_ppp2000_5 gov_fce_5 growth_gdppc2000_5 ln_inf_5 
	privcred_gdp_5 reserves_imports_5 savings_5 trade_5 peg_5 crisis_5 istar_5 polity2_5 polconiii_5 s_cap_5 
	distar_5 listar_5 lcrisis_5 dkaopen_5 dckaopen_5 dk3_5 ds_cap_5 lkaopen_5 lckaopen_5 lk3_5 ls_cap_5 
	politycrisis_5 polityistar_5 polconiiicrisis_5 polconiiiistar_5;
drop if sample!=1;
drop sample;
#delimit cr


***** SAVE AS NEW DATASET **************
save 5_year.dta, replace

