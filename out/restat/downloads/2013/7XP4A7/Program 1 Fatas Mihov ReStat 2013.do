*** PROGRAM 1: This program generates the output and constructs Tables 1 through 6 in Fatas and Mihov (2013)
*** Place the "do" file and the "dta" file in the same directory, or provide a path in the "use" line   

program drop _all
drop _all
set more 1

use GV2013.dta
sort cname year


** Some cleaning of the data set

replace rgdpch_v63 = "." if rgdpch_v63 == "na"
destring rgdpch_v63, replace
replace pi_v63 = "." if pi_v63 == "na"
destring pi_v63, replace
replace cg_v63 = "." if cg_v63 == "na"
destring cg_v63, replace

** Extrapolate data for Germany using 10-year average growth for the following entries:

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

** Clean the data a bit more

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

** Create trends
	
	g t1 = year - 1959

** Controls

	g lpop = log(wpop)
	g lrgdpch = log(rgdpch_v63)
	
	g lprices = log(deflator)
	g wdiinf = 100*(lprices - l.lprices)
	g inf2 = wdiinf*wdiinf

	g loil = ln(avg_crude_price)

** Generate lags, differences, and growth rates
	
	g growth = 100*(lrgdpch - l.lrgdpch)

***********************************************
****************** NEW DATA *******************
***********************************************
	
	g rgdp = gdp_lcu 
	g lrgdp = ln(rgdp)

	replace glcu = govt_exp_lcu
	g lg = ln(glcu)
 
	g grealgr = 100*(lg - l.lg)
	g growth2 = 100*(lrgdp - l.lrgdp)

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

** Schooling

	g pri = (100 - no25)/100
	g sec = (100 - no25 - pri25)/100
	* g pri = (pric25 + secc25 + highc25)/100
	g prienr = p60 + p65

** Empty vectors (many are redundant from old versions)

	g tr = 0
	g pval = 0

	g res = .
	g dts = .
 
	g vresg4ols = .

	g betay = .
	g fstat = .
	g avggove = .
	g avggove60 = .

	g volg = .

	g avgpop = .
	g avgpopgr = .
	g avgdep = .
	g avgurb = .

	g rgdp6065 = .
	g pri6070 = .
	g sec6070 = .

	g amaj = .
	g nelec = .
	g polcon1 = .
	g aconstr = .
	g polcon60 = .
	g constr60 = .

	g vargro1 = .
	g vargove = .

	g avggro1 = .
	g avggro70 = .
	g atrade1 = .
	g agdppc90 = .
	g aiy = .
	g aiy60 = .
	g api60 = .

	g avginf = .
	g varinf = .

	g sample1 = 1

	g gdp1969 = .

	g awbgr = .

	g sel = 1

sort ccode year

***********************************************
****** End of BASIC DATA TRANSFORMATION *******
***********************************************

** Procedure "Fiscal" to be run for every country 
** The procedure is called below individually for each country

program define fiscal /* cname */

 	** Summary statistics - means and variances

 	quietly sum growth if cname == "`1'" & year > 1969
 	quietly replace avggro70 = r(mean) if cname == "`1'"
 	quietly replace vargro1 = r(Var) if cname == "`1'"

	** Main controls

	quietly sum rgdpch_v63 if cname=="`1'" & year >= 1967 & year <= 1969
	quietly replace gdp1969 = r(mean) if cname == "`1'" 

	quietly sum cg if cname == "`1'" & year >= 1967 & year <= 1969
 	quietly replace avggove60 = r(mean) if cname == "`1'"

 	quietly sum openc if cname == "`1'" & year >= 1967 & year <= 1969
 	quietly replace atrade1 = r(mean) if cname == "`1'"

	quietly sum pi if cname == "`1'" & year >= 1967 & year <= 1969
 	quietly replace api60 = r(mean) if cname == "`1'"

 	quietly sum lpop if cname == "`1'" & sample1 == 1
 	quietly replace avgpop = r(mean) if cname == "`1'"

 	quietly sum wdiinf if cname == "`1'" & sample1 == 1 & year > 1969
 	quietly replace avginf = r(mean) if cname == "`1'"
	quietly replace varinf = r(Var) if cname == "`1'"

 	quietly sum pri if cname == "`1'" & year <= 1965
 	quietly replace pri6070 = r(mean) if cname == "`1'"

 	quietly sum sec if cname == "`1'" & year <= 1960
 	quietly replace sec6070 = r(mean) if cname == "`1'"

	** Political variables

 	quietly sum constr if cname == "`1'" & year > 1968 & year <= 1969
 	quietly replace constr60 = r(mean) if cname == "`1'"

 	quietly sum elsys if cname == "`1'" & sample1 == 1
 	quietly replace amaj = r(mean) if cname == "`1'"

 	quietly sum polsys if cname == "`1'" & sample1 == 1
 	quietly replace ptpres = r(mean) if cname == "`1'"

 	quietly sum polconv if cname == "`1'" & sample1 == 1
 	quietly replace polcon1 = r(mean) if cname == "`1'"

 	quietly sum elec if cname == "`1'" & sample1 == 1
 	quietly replace nelec= r(mean) if cname == "`1'"

***********************************************
**************** REGRESSIONS ******************
***********************************************

** Regressions to generate volatility of policy

** With OLS 

 	quietly reg growth2 rowgr l.rowgr d.loil if cname == "`1'"
	quietly replace fstat = e(r2_a)

	quietly reg grealgr growth2 if cname == "`1'"
	quietly replace vresg4ols = e(rmse) if cname == "`1'" 
	quietly replace betay = _b[growth2] if cname == "`1'"

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

***********************************************
********** More DATA TRANSFORMATION ***********
***********************************************

	drop if dts == .

***********************************************
***** Determine here which measure to use *****
***********************************************

	gen vresg4 = vresg4ols
	g logr4 = log(vresg4)
	replace vresg4 = logr4

	g stdgro1 = sqrt(vargro1)
	g logstdy = log(stdgro1)
	replace stdgro1 = logstdy

	g stdinf = sqrt(varinf)
	g lstdinf = log(stdinf)

	replace avggro1 = avggro70

	g apolcon = polcon1
	replace polcon1 = constr60

**  Dummy for developing countries
	
	g rich = 1 if gdp1969 > 6000 
	replace rich = 0 if gdp1969 < 6000

	g lgdp69 = log(gdp1969)
	replace rgdp6065 = lgdp69

** Primary education
	
	g prim60 = b_p60

******************************************************************
*********** Table 1: Policy Voltility and Institutions ***********
******************************************************************

** Col. 1

reg vresg4 polcon1 if year == 1990, robust

** Col. 2 Do standard alter the result?

reg vresg4 polcon1 ptpres amaj nelec if year == 1990, robust

** Col. 3 Rich

reg vresg4 polcon1 ptpres amaj nelec if year == 1990 & rich == 1, robust

** Col. 4 Poor

reg vresg4 polcon1 ptpres amaj nelec if year == 1990 & rich == 0, robust

******************************************************************
*********** Table 2: Policy Voltility and Growth: OLS ************
******************************************************************

graph7 vresg4 avggro1, s([cname])

** Col. 1

reg avggro1 vresg4 if year == 1990, robust

** Col. 2 Do standard controls alter the result?

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990, robust

** Col. 3 Rich

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & rich == 1, robust

** Col. 4 Poor

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & rich == 0, robust

** Col. 5 Is it output volatility that we capture with vresg4?

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 stdgro1 avginf varinf if year == 1990, robust

********************************************************************************************************
*********** Table 3: Back to Growth: Using Institutions as Instruments for Policy Volatility ***********
********************************************************************************************************

** Col. 1

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) if year == 1990, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec if year == 1990
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

** Col. 2 MAIN REGRESSION: Do standard controls alter the result?

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

** col. 3 Rich

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & rich == 1, robust

** OID test

predict r1, resid
reg r1 amaj ptpres polcon1 nelec avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & rich == 1
replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

** Col. 4 Poor 

ivreg avggro1 (vresg4 = polcon1 amaj ptpres nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & rich == 0, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & rich == 0
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) stdgro1 avginf varinf avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec avggove60 stdgro1 api60 rgdp6065 prim60 atrade1 if year == 1990
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avginf avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec avggove60 avginf api60 rgdp6065 prim60 atrade1 if year == 1990
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) varinf avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990, robust

** OID test
quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec avggove60 varinf api60 rgdp6065 prim60 atrade1 if year == 1990
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue
display tr 
display pval
quietly drop r1

******************************************************************
************** Table 4: Robustness: BACE Variables ***************
******************************************************************

** Tables for BACE variables 

g bgr = 100*b_gr6096
replace b_gr6096 = bgr

reg b_gr6096 vresg4 b_iprice1 b_gvr61 b_gdpch60l b_p60 b_opendec1 if year == 1990, robust

** Col. 2 Vresg + Top 6 variables

reg avggro1 vresg4 api60 rgdp6065 prim60 b_east b_tropicar b_dens65c if year == 1990, robust

** col. 3 IV 

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) api60 rgdp6065 prim60 b_east b_tropicar b_dens65c if year == 1990, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres polcon1 nelec api60 rgdp6065 prim60 b_east b_tropicar b_dens65c  if year == 1990
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

******************************************************************
************** Table 5: Insitutions and Volatility ***************
******************************************************************

** Col. 1 Institutions 

reg avggro1 polcon1 if year == 1990, robust

** Col. 2 Institutions & policy volatility

reg avggro1 polcon1 vresg4 if year == 1990, robust

** Col. 3 Institutions & policy volatility + controls

reg avggro1 polcon1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990, robust

** Col. 4 Do institutions have additional explanatory power?

ivreg avggro1 (vresg4 = ptpres amaj nelec) polcon1 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & sel == 1, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres ACElogem4 nelec polcon1 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & sel == 1
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr, "", pval
quietly drop r1

** Col. 5 Do institutions have additional explanatory power?

ivreg avggro1 vresg4 (polcon1 = ACElogem4 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & sel == 1, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres ACElogem4 nelec vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & sel == 1
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr, "", pval
quietly drop r1

** Col. 6 Do institutions have additional explanatory power?

ivreg avggro1 (vresg4 polcon1 = ACElogem4 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & sel == 1, robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres ACElogem4 nelec avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & sel == 1
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(2,tr)

** T-stat Pvalue

display tr 
display pval
quietly drop r1

******************************************************************
****************** Table 6: Within Constraints *******************
******************************************************************

g d1 =0
g d2 =0
g d3 =0
g d4 =0
g d5 =0

replace d1 = 1 if polcon1 == 0
replace d2 = 1 if polcon1 > 0 & polcon1 <= 1.5
replace d3 = 1 if polcon1 > 1.5 & polcon1 <= 2.5
replace d4 = 1 if polcon1 > 2.5 & polcon1 <= 3.5
replace d5 = 1 if polcon1 > 3.5 & polcon1 ~= .

g vd1 = d1*vresg4
g vd2 = d2*vresg4
g vd3 = d3*vresg4
g vd4 = d4*vresg4
g vd5 = d5*vresg4

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 < 2 & polcon1 ~= ., robust

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 >= 2 & polcon1 ~= ., robust

reg avggro1 vresg4 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 == 0 & polcon1 ~=., robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 < 2 & polcon1 ~=., robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres nelec polcon1 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 < 2 & polcon1 ~=.
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr, "", pval
quietly drop r1

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 >= 2 & polcon1 ~=., robust

** OID test

quietly predict r1, resid
quietly reg r1 amaj ptpres nelec polcon1 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 >= 2 & polcon1 ~= .
quietly replace tr = e(r2)*e(N)
quietly replace pval = chi2tail(3,tr)

** T-stat Pvalue

display tr, "", pval
quietly drop r1

reg avggro1 d1 d2 d3 d4 d5 vd1 vd2 vd3 vd4 vd5 avggove60 api60 rgdp6065 prim60 atrade1 if year == 1990 & polcon1 ~= ., robust noconst

******************************************************************
************** Appendix Table B1: BACE Sequentially **************
******************************************************************

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_east if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_tropicar if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_dens65c if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_malfal66 if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_life060 if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_confuc if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_safrica if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_laam if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_mining if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_spain if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_yrsopen if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_muslim00 if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_buddha if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_avelf if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_dens60 if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_rerd if year == 1990, robust

ivreg avggro1 (vresg4 = polcon1 ptpres amaj nelec) avggove60 api60 rgdp6065 prim60 atrade1 b_othfrac if year == 1990, robust

exit
