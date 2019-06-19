*** PROGRAM 2: This program generates the output and constructs Tables 7 and 8 in Fatas and Mihov (2013)
*** Place the "do" file and the "dta" file in the same directory, or provide a path in the "use" line   

program drop _all
drop _all
set more 1

use GV2013.dta
sort cname year

** Some new stuff

replace rgdpch_v63 = "." if rgdpch_v63 == "na"
destring rgdpch_v63, replace
replace pi_v63 = "." if pi_v63 == "na"
destring pi_v63, replace
replace cg_v63 = "." if cg_v63 == "na"
destring cg_v63, replace

** Extrapolate data for Germany using 10-year avergae growth for the following entries:

replace rgdpch_v63 = 14195.70531 if cname == "DEU" & year == 1967
replace rgdpch_v63 = 14575.02743 if cname == "DEU" & year == 1968
replace rgdpch_v63 = 14964.48538 if cname == "DEU" & year == 1969

replace pi_v63 = 58.57672 if cname == "DEU" & year == 1967
replace pi_v63 = 61.32973 if cname == "DEU" & year == 1968
replace pi_v63 = 64.21213 if cname == "DEU" & year == 1969

replace cg_v63 = 11.3172 if cname == "DEU" & year == 1967
replace cg_v63 = 11.5628 if cname == "DEU" & year == 1968
replace cg_v63 = 11.8137 if cname == "DEU" & year == 1969

replace openc = 35.89956283 if cname == "DEU" & year == 1967
replace openc = 36.91929215 if cname == "DEU" & year == 1968
replace openc = 37.96798696 if cname == "DEU" & year == 1969

replace nrgdpch = rgdpch_v63
replace pi = pi_v63
replace cg = cg_v63

** Data for SGP

replace  govt_exp_lcu = glcu if cname == "SGP" & year < 2002

** Clean the data a bit

drop if year <= 1959
drop ccode
sort cname year 
encode cname, g(ccode) 
drop if ccode == .
sort cname year 
drop if year == year[_n-1] & cname == cname[_n-1]
drop prim25 secm25

** Drop countries with insufficient data from PWT 6.1

drop if cname == "MLT"
drop if cname == "SAU"
drop if cname == "SWZ"

drop id3 id4

***********************************************
************** PANEL DEFINITIONS **************
***********************************************

**  Cross-section by ccode
**  Time dimension by year

 	sort ccode year 
	tsset ccode year

***********************************************	
************* DATA TRANSFORMATION *************
***********************************************

** Polecon variables
** For regimes use PT when availble and DPI for the rest

	g dpipolsys = 0
	replace dpipolsys = 1 if system == 0
	replace dpipolsys = 1 if system == 1
	replace dpipolsys = . if system == .

	g polsys = ptpres
	g elsys = ptmaj

 	replace polsys = dpipolsys if dfpind == .
 	replace elsys = pr if dfpind == .

	replace polconv = polconv_2002

	g constr = l1 + l2 + j + f

	g elec = exelec + legelec
	replace xconst = . if xconst <= 0

	g prima = (100 - no25)/100

** Create trends

	g t1 = year - 1959

** Government spending

	g lpop = log(wpop)
	g lrgdpch = log(rgdpch_v63)
	
	g lprices = log(deflator)
	g wdiinf = 100*(lprices - l.lprices)
	g inf2 = wdiinf*wdiinf

** Generate lags, differences, and growth rates
	
	g growth = 100*(lrgdpch-l.lrgdpch)

***********************************************
****************** NEW DATA *******************
***********************************************

	g rgdp = gdp_lcu 
	g lrgdp = ln(rgdp)

	replace glcu = govt_exp_lcu
	g lg = ln(glcu)
 
	g grealgr = 100*(lg - l.lg)
	g growth2 = 100*(lrgdp - l.lrgdp)

	g loil = ln(avg_crude_price)

** Create instruments
	
	g totalgdp = rgdpch_v63*wpop
	bysort year: egen worldgdp = sum(totalgdp)
	g weight = totalgdp/worldgdp
	sort cname year
	bysort cname: egen aveweight = mean(weight)
	sort cname year
	g contribute = aveweight*growth2
	bysort year: egen worldgr = sum(contribute)
	sort cname year
	g rowgr = worldgr - contribute
	g rowgdp = worldgdp - totalgdp
	g lrowgdp = ln(rowgdp)

	sort ccode year

** Empty vectors (many are redundant from old versions)

	g tr = 0
	g pval = 0

	g res = .
	g resiv = .
	g dts = .
 
	g vresg4 = .
	g vresg5 = .

	g vresg4ols = .

	g res2ols = .

	g betay = .
	g betalag = .
	g avggove = .
	
	g volg = .

	g agovinit = .
	g fstat = .
	g avgpop = .
	g avgpop2 = .
	g avgdep = .
	g avgurb = .

	g rgdp6065 = .
	g rgdpinit = .

	g prim = .
	g secm60 = .
	g priminit = .
	g secminit = .

	g amaj = .
	g nelec = .
	g polcon1 = .
	g constr60 = .
	g consinit = .

	g vargro1 = .
	g vargove = .
	g lvargove = .

	g avggro1 = .
	g atrade1 = .
	g tradinit = .

	g agdppc90 = .
	g aiy = .
	g api60 = .
	g apiinit = .

	g avginf = .
	g varinf = .

	g sample1 = 1

	g sel = 1

	g vres2 = .
	g gdp1969 = .

	g resgy =.

***********************************************
****** End of BASIC DATA TRANSFORMATION *******
***********************************************

** Procedure "Fiscal" to be run for every country 
** The procedure is called below individually for each country

program define fiscal /* cname */

 	** Summary statistics - Means and Variances

	quietly sum rgdpch_v63 if cname == "`1'" & year >= 1967 & year <= 1969
	quietly replace gdp1969 = r(mean) if cname == "`1'" 

 	quietly sum growth if cname == "`1'" & sample1 == 1
 	quietly replace vargro1 = r(Var) if cname == "`1'"
 	quietly replace avggro1 = r(mean) if cname == "`1'"

	** Initial GDP
	
 	quietly sum nrgdpch if cname == "`1'" & year >= 1962 & year <= 1964
 	quietly replace rgdpinit = r(mean) if cname=="`1'"&year>=1964&year<=1974

 	quietly sum nrgdpch if cname == "`1'" & year >= 1972 & year <= 1974
 	quietly replace rgdpinit = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum nrgdpch if cname == "`1'" & year >= 1982 & year <= 1984
 	quietly replace rgdpinit = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum nrgdpch if cname == "`1'" & year >= 1992 & year <= 1994
 	quietly replace rgdpinit = r(mean) if cname == "`1'" & year >= 1995

	** Openness
	
 	quietly sum openc if cname == "`1'" & year >= 1962 & year <= 1964
 	quietly replace tradinit = r(mean) if cname == "`1'" & year >= 1964 & year <= 1974

 	quietly sum openc if cname == "`1'" & year >= 1972 & year <= 1974
 	quietly replace tradinit = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum openc if cname == "`1'" & year >= 1982 & year <= 1984
 	quietly replace tradinit = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum openc if cname == "`1'" & year >= 1992 & year <= 1994
 	quietly replace tradinit = r(mean) if cname == "`1'" & year >= 1995

	** Constraints

 	quietly sum constr if cname == "`1'" & year >= 1962 & year <= 1964
 	quietly replace consinit = r(mean) if cname == "`1'" & year >= 1964 & year <= 1974

 	quietly sum constr if cname == "`1'" & year >= 1972 & year <= 1974
 	quietly replace consinit = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum constr if cname == "`1'" & year >= 1982 & year <= 1984
 	quietly replace consinit = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum constr if cname == "`1'" & year >= 1992 & year <= 1994
 	quietly replace consinit = r(mean) if cname == "`1'" & year >= 1995

	** Primary education

 	quietly sum p60 if cname == "`1'" & year <= 1964
 	quietly replace priminit = r(mean) if cname == "`1'" & year >= 1964 & year <= 1974

 	quietly sum p65 if cname == "`1'" & year >= 1970 & year <= 1974
 	quietly replace priminit = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum p75 if cname == "`1'" & year >= 1980 & year <= 1984
 	quietly replace priminit = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum p85 if cname == "`1'" & year >= 1990 & year <= 1994
 	quietly replace priminit = r(mean) if cname == "`1'" & year >= 1995

	** Primary education

 	quietly sum prima if cname == "`1'" & year <= 1964
 	quietly replace prim = r(mean) if cname == "`1'" & year >=1964 & year <= 1974

 	quietly sum prima if cname == "`1'" & year >= 1965 & year <= 1974
 	quietly replace prim = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum prima if cname == "`1'" & year >= 1975 & year <= 1984
 	quietly replace prim = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum prima if cname == "`1'" & year >= 1985 & year <= 1994
 	quietly replace prim = r(mean) if cname == "`1'" & year >= 1995

	** Price of investment
 	
	quietly sum pi if cname == "`1'" & year >= 1962 & year <= 1964
 	quietly replace apiinit = r(mean) if cname == "`1'" & year >= 1964 & year <= 1974

 	quietly sum pi if cname == "`1'" & year >= 1972 & year <= 1974
 	quietly replace apiinit = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum pi if cname == "`1'" & year >= 1982 & year <= 1984
 	quietly replace apiinit = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum pi if cname == "`1'" & year >= 1992 & year <= 1994
 	quietly replace apiinit = r(mean) if cname == "`1'" & year >= 1995

	** Government size
	
	quietly sum cg if cname == "`1'"
 	quietly replace avggove = r(mean) if cname == "`1'"
	quietly replace vargove = r(Var) if cname == "`1'"

 	quietly sum cg if cname == "`1'" & year >= 1962 & year <= 1964
 	quietly replace agovinit = r(mean) if cname == "`1'" & year >= 1964 & year <= 1974

 	quietly sum cg if cname == "`1'" & year >= 1972 & year <= 1974
 	quietly replace agovinit = r(mean) if cname == "`1'" & year >= 1975 & year <= 1984

 	quietly sum cg if cname == "`1'" & year >= 1982 & year <= 1984
 	quietly replace agovinit = r(mean) if cname == "`1'" & year >= 1985 & year <= 1994

 	quietly sum cg if cname == "`1'" & year >= 1992 & year <= 1994
 	quietly replace agovinit = r(mean) if cname == "`1'" & year >= 1995

 	quietly sum elsys if cname == "`1'" & sample1 == 1
 	quietly replace amaj= r(mean) if cname == "`1'"

 	quietly sum polsys if cname == "`1'" & sample1 == 1
 	quietly replace ptpres = r(mean) if cname == "`1'"

 	quietly sum elec if cname == "`1'" & sample1 == 1
 	quietly replace nelec = r(mean) if cname== "`1'"

***********************************************
**************** REGRESSIONS ******************
***********************************************

	quietly reg grealgr growth2 if cname == "`1'"
	quietly replace vresg4 = e(rmse) if cname == "`1'" 
	quietly predict res1, resid
	quietly replace res2ols = res1 if cname == "`1'"
	quietly drop res1

	quietly replace dts = 1 if cname == "`1'" & e(N) >= 20

end

** Run procedure "Fiscal" for each country

	fiscal BDI
	fiscal BEN	
	fiscal BFA	
	fiscal BGD	
	fiscal CIV	
	fiscal CMR	
	fiscal COG	
	fiscal COM

	fiscal CPV
	fiscal DZA	
	fiscal EGY	
	fiscal ETH	
	fiscal FJI	

	fiscal GAB	
	fiscal GHA	
	fiscal GIN
	fiscal GMB	
	fiscal GNB	

	fiscal HKG	
	fiscal IDN	
	fiscal ISL	

	fiscal JOR
	fiscal KEN
	fiscal KOR
	fiscal LSO
	fiscal MAR

	fiscal MDG
	fiscal MLI
	fiscal MOZ
	fiscal MRT
	fiscal MWI

	fiscal NAM
	fiscal NER
	fiscal PAK
	fiscal PAN

	fiscal RWA
	fiscal SEN
	fiscal SYC
	fiscal SYR
	fiscal TCD

	fiscal TGO
	fiscal TZA
	fiscal TUN
	fiscal UGA
	fiscal ZAF

	fiscal ZMB
	fiscal ZWE

	fiscal AUS	
	fiscal AUT	
	fiscal BEL	
	fiscal BOL	

	fiscal BWA	
	fiscal BRA	
	fiscal CAN	
	fiscal CHL	
	fiscal COL	

	fiscal CRI	
	fiscal DNK	
	fiscal DOM	
	fiscal ECU	
	fiscal SLV	

	fiscal FIN	
	fiscal FRA	
	fiscal DEU	
	fiscal GRC	
	fiscal GTM	

	fiscal HND	
	fiscal IND	
	fiscal IRL	
	fiscal ISR	
	fiscal ITA	

	fiscal JPN	
	fiscal MYS	
	fiscal MUS	
	fiscal MEX	
	fiscal NLD	
	fiscal NZL	
	fiscal NIC	
	fiscal NOR	
	fiscal PNG	

	fiscal PRY	
	fiscal PER	
	fiscal PHL	
	fiscal PRT	
	fiscal SGP	

	fiscal ESP	
	fiscal LKA	
	fiscal SWE	
	fiscal CHE	
	fiscal THA	

	fiscal TTO	
	fiscal TUR	
	fiscal GBR	
	fiscal USA	
	fiscal URY	

	fiscal VEN	

************************************************

	drop if dts==.

	g lrinit = log(rgdpinit)
	replace rgdpinit = lrinit

***********************************************
********** More DATA TRANSFORMATION ***********
***********************************************

	g stdgro1 = sqrt(vargro1)
	g logstdy = log(stdgro1)
	g logr4 = log(vresg4)

	g stdinf = sqrt(varinf)
	g lstdinf = log(stdinf)

	replace stdgro1 = logstdy
	replace vresg4 = logr4

	g voly = growth*growth

	g rich = 1 if gdp1969 > 6000 
	replace rich = 0 if gdp1969 < 6000
	replace rich = . if gdp1969 == .

** The main variable here is res2

	replace res = res2ols

	g res2 = res*res

	g byte year10 = 0
	replace year10 = 1 if year > 1964 & year <= 1974
	replace year10 = 2 if year > 1974 & year <= 1984
	replace year10 = 3 if year > 1984 & year <= 1994
	replace year10 = 4 if year > 1994 & year <= 2004

	quietly egen avgr10 = mean(growth2), by(ccode year10)
	quietly g devn10 = growth2 - avgr10
	quietly g adevn10 = abs(devn10)
	label var adevn10 "Absolute value of growth rate deviation from 10-year average mean"
	quietly drop avgr10 devn10

	quietly egen std10 = sd(growth2), by(ccode year10)
	label var std10 "Standard deviation of output growth"

	order country year10
	encode cname, g(ccoden)

	drop govt_consump_IFS - countryisocode
	drop scode wbcode2 country2 rgdpl2_v63 isocode
	bysort ccoden year10: egen vres = sd(res)

	collapse (mean) rgdpch-rgdptt polconv_2002 -vres, by(cname year10)

	sort ccoden year10
	tsset ccoden year10

	g byte tf1 = 0
	g byte tf2 = 0
	g byte tf3 = 0
	g byte tf4 = 0

	replace tf1 = 1 if year10 == 1
	replace tf2 = 1 if year10 == 2
	replace tf3 = 1 if year10 == 3
	replace tf4 = 1 if year10 == 4

	g sres2 = sqrt(res2)
	g lres2 = log(sres2)
	g llres2 = l.lres2

	g lvres = log(vres)
	g llvres = l.lvres

	g dvol = lres2-llres2
	g dconstr = constr - l.constr
	g lagcons = l.constr

	gen lagstd10 = l.std10

***********************************************
**************** Regressions ******************
***********************************************

	reg growth lres2 if year10 ~= 0, robust
	
	reg growth lres2 rgdpinit prim tradinit agovinit apiinit if year10 ~= 0, robust
	
	reg growth llres2 rgdpinit prim tradinit agovinit apiinit if year10 ~= 1, robust
	
	reg growth llres2 rgdpinit prim tradinit agovinit apiinit if year10 ~= 1 & rich == 1, robust
	
	reg growth llres2 rgdpinit prim tradinit agovinit apiinit if year10 ~= 1 & rich == 0, robust
	
	reg growth llres2 lagstd10 rgdpinit prim tradinit agovinit apiinit if year10 ~= 1, robust
	
	reg growth llres2 l.growth rgdpinit prim tradinit agovinit apiinit  if year10 ~= 1, robust
	
	** Controlling for fixed effects

	xtreg growth llres2 if year10 ~= 1, fe 
	
	xtreg growth llres2 rgdpinit prim tradinit agovinit apiinit if year10 ~= 1, fe
	
	reg growth llres2 rgdpinit prim tradinit agovinit apiinit tf1-tf3 if year10 ~= 1, robust
	
	xtreg growth llres2 rgdpinit prim tradinit agovinit apiinit tf1-tf3 if year10 ~= 1, fe 
	
	xtreg growth llres2 lagstd10 rgdpinit prim tradinit agovinit apiinit tf1-tf3 if year10 ~= 1, fe 
	
	** ABOND
	xtabond growth lres2 if year10 ~= 1, lags(1) 

	xtabond growth if year10 ~= 1, lags(2) twostep pre(rgdpinit) pre(prim) pre(tradinit) pre(agovinit) pre(apiinit) pre(llres2)
	
	estat abond
	estat sargan

	xtabond growth tf1-tf3 if year10 ~= 1, lags(2) twostep pre(rgdpinit) pre(prim) pre(tradinit) pre(agovinit) pre(apiinit) pre(llres2) 
	
	estat abond
	estat sargan

exit
