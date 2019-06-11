*********************************************************************************************************************************
*** TITLE:   Electoral Institutions, Trade Disputes, and the Monitoring and Enforcement of International Law
*** AUTHOR:  Timm Betz; timm.betz@tamu.edu
*** JOURNAL: International Interactions
*********************************************************************************************************************************

use "II_replication.dta", replace


* Table 1
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas sum_dispute ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas eci_value ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas lnprod lnmarket ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas exelec execrlc ye ye2 ye3 if democ == 1& wto == 1 , robust cluster(iso3n) nolog
estimates store m5

estout m1 m2 m3 m4 m5,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex) varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" lnexports "Log exports" sum_ptas "PTAs" ye "Year" ye2 "Year^2" ye3 "Year^3" eci_value "Economic complexity" exelec "Executive elections" execrlc "Partisanship" sum_disputes "Previous disputes" lnproducts "Log products" lnmarkets "Log markets" _cons "Constant" )  drop(ye ye2 ye3 )


* Predicted number of disputes in main model (p. 19)
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
margins, at(housesys = 0 housesys = 1)


* Table 2, columns 1-4
preserve
qui {
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
drop if e(sample) != 1
by iso3n, sort: egen cdisputes = sum(disputes)
by iso3n, sort: egen avg_housesys = mean(housesys)
by iso3n, sort: egen mdisputes = mean(disputes)
by iso3n, sort: egen avg_gdp = mean(lngdp)
by iso3n, sort: egen avg_gdp_capita = mean(gdp_capita)
by iso3n, sort: egen avg_export = mean(lnexport)
by iso3n, sort: egen avg_import = mean(lnimport)
by iso3n, sort: egen avg_sumptas = mean(sum_ptas)
replace disputes = mdisputes
replace housesys = avg_housesys
replace lngdp = avg_gdp
replace gdp_capita = avg_gdp_capita
replace lnexport = avg_export
replace lnimport = avg_import
replace sum_ptas = avg_sumptas
by iso3n , sort: gen ids = _n
}
reg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas  if ids == 1 , robust
estimates store m1
restore
nbreg disputes l.disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
gmm (disputes - {rho}*l.disputes - exp({xb: housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3} + {b0}))  if democ == 1 & wto == 1, instruments(l.disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3)  vce(cluster iso3n) onestep
estimates store m3
logit dispute housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m4

estout m1 m2 m3 m4 ,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex) varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" lnexports "Log exports" sum_ptas "PTAs" ye "Year" ye2 "Year^2" ye3 "Year^3" eci_value "Economic complexity" exelec "Executive elections" execrlc "Partisanship" sum_disputes "Previous disputes" l.disputes "Lagged disputes" lnproducts "Log products" lnmarkets "Log markets" _cons "Constant" )  drop(ye ye2 ye3 )

* Column 5, Penalized Maximum Likelihood
preserve

qui nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , nolog
drop if e(sample) != 1
gen cons = 1
set matsize 5000
mkmat cons housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3, matrix(mataccumlist)
matrix beta_0 = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)'
capture drop hat_diag1
gen double hat_diag1 = 10/1458

capture drop p
	local s = 0
	quietly while `s' < 400 {
		capture drop xb p prob Zvar weight hat_diag_old
		scalar b0 = beta_0[1,1] 
		scalar b1 = beta_0[2,1] 
		scalar b2 = beta_0[3,1]
		scalar b3 = beta_0[4,1]
		scalar b4 = beta_0[5,1]
		scalar b5 = beta_0[6,1]
		scalar b6 = beta_0[7,1]
		scalar b7 = beta_0[8,1]
		scalar b8 = beta_0[9,1]
		scalar b9 = beta_0[10,1]

		matrix beta_old = (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9)'
		gen double hat_diag_old = hat_diag1
		gen double xb = 1*b0 + housesys*b1 + lngdp*b2 + gdp_capita*b3 + lnexport*b4 + lnimport*b5 + sum_ptas*b6 + ye*b7 + ye2*b8 + ye3*b9
		gen double p = exp(xb)
		gen double prob = exp(xb)
		gen double Zvar = xb + (disputes+hat_diag_old/2-p)/prob
		gen double weight = (prob)
		mkmat weight, matrix(weight_mtx)
		mkmat Zvar, matrix(adjY)
		matrix W = diag(weight_mtx)
		matrix beta_0 = inv(mataccumlist' * W * mataccumlist)*mataccumlist' * W * adjY
		matrix hat = W * mataccumlist * inv(mataccumlist' * W * mataccumlist) * mataccumlist'
		matrix hat_diag = vecdiag(hat)'
		capture drop hat_diag1
		svmat hat_diag
		matrix deviance = beta_0 - beta_old
		matrix top = (deviance' * deviance)
		matrix bottom = (beta_old' * beta_old)
		scalar gap = sqrt(top[1,1]/bottom[1,1])
		scalar converge_f = 0
		scalar s = `s'
		if gap < .000001 {
			scalar converge_f = 1 
			local s = 401
			}
		else local s = `s' + 1
		}
	scalar b0_f = beta_0[1,1]
	scalar b1_f = beta_0[2,1]
	scalar b2_f = beta_0[3,1]
	scalar b3_f = beta_0[4,1]
	scalar b4_f = beta_0[5,1]
	scalar b5_f = beta_0[6,1]
	scalar b6_f = beta_0[7,1]
	scalar b7_f = beta_0[8,1]
	scalar b8_f = beta_0[9,1]
	scalar b9_f = beta_0[10,1]

	matrix info = mataccumlist' * W * mataccumlist
	scalar penalty = ln(det(info))
	capture drop ll_i ll
	gen ll_i = disputes*xb - prob
	egen ll = sum(ll_i)
	scalar ll = ll[1] + .5*penalty
	
	capture  drop est_var_i est_var
	gen est_var_i = (disputes - prob)^2/prob
	egen est_var = sum(est_var_i)
	scalar phi = est_var[1]/(1458-10)
	matrix vcov = inv(info)
	scalar se0_f = sqrt(phi)*sqrt(vcov[1,1])
	scalar se1_f = sqrt(phi)*sqrt(vcov[2,2])
	scalar se2_f = sqrt(phi)*sqrt(vcov[3,3])
	scalar se3_f = sqrt(phi)*sqrt(vcov[4,4])
	scalar se4_f = sqrt(phi)*sqrt(vcov[5,5])	
	scalar se5_f = sqrt(phi)*sqrt(vcov[6,6])
	scalar se6_f = sqrt(phi)*sqrt(vcov[7,7])
	scalar se7_f = sqrt(phi)*sqrt(vcov[8,8])
	scalar se8_f = sqrt(phi)*sqrt(vcov[9,9])
	scalar se9_f = sqrt(phi)*sqrt(vcov[10,10])

	local i = 0
	while `i' < 10 {
	scalar t_`i' = b`i'_f/se`i'_f
	if `i' == 0 matrix t = (t_`i')
	if `i' != 0 matrix t = (t \ t_`i')
	scalar p_`i' = 2*ttail(1458,abs(t_`i'))
	if `i' == 0 matrix p = (p_`i')
	if `i' != 0 matrix p = (p \ p_`i')
	local i = `i' + 1
	}
	
matrix list beta_0
matrix list p

restore


* Figure 1: effective sample 
use "II_Figure1.dta", replace

spmap insample using sov_coord , id(_ID) fcolor(gs12 gs19)  name(sample)
spmap c_weight using sov_coord , id(_ID) fcolor(Greys) clmethod(quantile) legstyle(2) name(weights)

graph combine sample weights, rows(2) subtitle("Nominal and effective sample")


* Table 3: Legal Quality 
use "II_Table3.dta", replace

glm mean housesys lngdp gdp_capita lnexport lnimport  ye ye2 ye3 if democ == 1, robust cluster(iso3n) link(logit) family(binomial)
estimates store m1
glm mean housesys lngdp gdp_capita lnexport lnimport sum_disputes  ye ye2 ye3 if democ == 1, robust cluster(iso3n) link(logit) family(binomial)
estimates store m2
glm mean housesys lngdp gdp_capita lnexport lnimport sum_disputes us_eu  ye ye2 ye3 if democ == 1, robust cluster(iso3n) link(logit) family(binomial)
estimates store m3

logit median housesys lngdp gdp_capita lnexport lnimport ye ye2 ye3  if democ == 1, robust cluster(iso3n)
estimates store m4
logit median housesys lngdp gdp_capita lnexport lnimport sum_disputes  ye ye2 ye3 if democ == 1, robust cluster(iso3n)
estimates store m5
logit median housesys lngdp gdp_capita lnexport lnimport sum_disputes us_eu ye ye2 ye3 if democ == 1, robust cluster(iso3n)
estimates store m6

nbreg numberclaims housesys lngdp gdp_capita lnexport lnimport  ye ye2 ye3 if democ == 1 , robust cluster(iso3n)
estimates store m7
nbreg numberclaims housesys lngdp gdp_capita lnexport lnimport sum_disputes ye ye2 ye3 if democ == 1, robust cluster(iso3n)
estimates store m8
nbreg numberclaims housesys lngdp gdp_capita lnexport lnimport sum_disputes us_eu ye ye2 ye3 if democ == 1, robust cluster(iso3n)
estimates store m9

estout m*, extracols(4 7) cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex) drop(ye ye2 ye3) varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnexports "Log exports" sum_ptas "PTAs" ye "Year" ye2 "Year^2" ye3 "Year^3" sum_disputes "Previous disputes" lnimports "Log imports" us_eu "US/EU plaintiff" lnproducts "Log products" lnmarkets "Log markets" _cons "Constant" )


* Table 4: Specific Trade Concerns
use "II_replication.dta", replace

nbreg concerns housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg concerns housesys lngdp gdp_capita lnexport lnimport sum_ptas sum_dispute ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg concerns housesys lngdp gdp_capita lnexport lnimport sum_ptas eci_value ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg concerns housesys lngdp gdp_capita lnexport lnimport sum_ptas lnprod lnmarket ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg concerns housesys lngdp gdp_capita lnexport lnimport sum_ptas exelec execrlc ye ye2 ye3 if democ == 1& wto == 1 , robust cluster(iso3n) nolog
estimates store m5

estout m1 m2 m3 m4 m5 ,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex) varlabels(ln_districts "Log districts" index "Personal vote" FHouse "Freedom House" polity2 "Polity score" parcomp "Polity participation" housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" lnexports "Log exports" sum_ptas "PTAs" ye "Year" ye2 "Year^2" ye3 "Year^3" eci_value "Economic complexity" exelec "Executive elections" execrlc "Partisanship" sum_disputes "Previous disputes" lnproducts "Log products" lnmarkets "Log markets" _cons "Constant" )  drop(ye ye2 ye3 )


**********************
** RESULTS APPENDIX **
**********************

use "II_replication.dta", replace

* Table A1
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1  & wto == 1 , robust cluster(iso3n) nolog exposure(lnmarkets)
estimates store m1
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1  & wto == 1 , robust cluster(iso3n) nolog exposure(lnproducts)
estimates store m2
nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog exposure(lnexport)
estimates store m3
xtnbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas i.year if democ == 1  & wto == 1 , nolog
estimates store m4

estout m1 m2 m3 m4 ,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex) varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" lnexports "Log exports" sum_ptas "PTAs" ye "Year" ye2 "Year^2" ye3 "Year^3" eci_value "Economic complexity" exelec "Executive elections" execrlc "Partisanship" sum_disputes "Previous disputes" lnproducts "Log products" lnmarkets "Log markets" _cons "Constant" )  drop(ye ye2 ye3 *year)


* Table A2
nbreg disputes housesys lngdp gdp_capita lnexport lnimport c.lnundervalued sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg disputes housesys lngdp gdp_capita lnexport lnimport i.floater sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes housesys lngdp gdp_capita lnexport lnimport gdp_growth sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes housesys lngdp gdp_capita lnexport lnimport gdp_growth_world sum_ptas ye ye2 ye3 if democ == 1  & wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg disputes housesys allhouse lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m5
nbreg disputes housesys checks lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m6

estout m1 m2 m3 m4 m5 m6,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex)  drop(0.floaters ye ye2 ye3 )  ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" ///
lnexports "Log exports" sum_ptas "PTAs" ye "Year" ye2 "Year^2" ye3 "Year^3" eci_value "Economic complexity" ///
exelec "Executive elections" gdp_growth "GDP growth" execrlc "Partisanship" sum_disputes "Previous disputes" ///
lnproducts "Log products" lnmarkets "Log markets" _cons "Constant" gdp_growth_world "World GDP growth" ///
checks "Veto players" allhouse "Divided government" 1.floaters "Floating x-rate" lnundervalued "Exchange rate")


* Table A3
nbreg disputes housesys lngdp gdp_capita  lnexport lnimport sum_ptas  if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg disputes housesys lngdp gdp_capita  lnexport lnimport sum_ptas i.year if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes housesys lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 & countryname != "United States", robust cluster(iso3n) nolog
estimates store m3
nbreg disputes housesys lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 & countryname != "Japan", robust cluster(iso3n) nolog
estimates store m4

estout m1 m2 m3 m4 ,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust , fmt(0) label("Number Obs." "Number Countries")) nolz style(tex)  drop(ye ye2 ye3 *.year) ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnexports "Log exports"  ///
sum_ptas "PTAs" lnimports "Log imports" _cons "Constant" )




* Table A4
gen mixed = housesys*2
nbreg disputes housesys lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 & housesys != .5, robust cluster(iso3n) nolog
estimates store m1
nbreg disputes housesys_old lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes pluralty lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes i.mixed lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m4

estout m1 m2 m3 m4 ,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust , fmt(0) label("Number Obs." "Number Countries")) nolz style(tex)  drop(ye ye2 ye3 ) ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnexports "Log exports"  ///
sum_ptas "PTAs" lnimports "Log imports" _cons "Constant" )



* Table A5
qui nbreg disputes housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
gen sample = e(sample)
nbreg disputes housesys  														if sample == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg disputes housesys  	   gdp_capita 							 ye ye2 ye3 if sample == 1  , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes housesys        gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if sample == 1  , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes housesys  lngnp gdp_capita  							 ye ye2 ye3 if sample == 1  , robust cluster(iso3n) nolog
estimates store m4
nbreg disputes housesys  lngnp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if sample == 1  , robust cluster(iso3n) nolog
estimates store m5

estout m1 m2 m3 m4 m5 ,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust , fmt(0) label("Number Obs." "Number Countries")) nolz style(tex)  drop(ye ye2 ye3 ) ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnexports "Log exports"  ///
lngnp "Log GNP" sum_ptas "PTAs" lnimports "Log imports" _cons "Constant" )


* Table A6
nbreg disputes ln_district lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1  & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg disputes index lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes FHouse lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if  wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes polity2 lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if  wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg disputes parcomp lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if wto == 1 , robust cluster(iso3n) nolog
estimates store m5
nbreg disputes i.triple lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if wto == 1 , robust cluster(iso3n) nolog
estimates store m6

estout m1 m2 m3 m4 m5 m6,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex)   drop(ye ye2 ye3) ///
varlabels(ln_districts "Log districts" index "Personal vote" FHouse "Freedom House" polity2 "Polity score" ///
parcomp "Polity participation" housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" ///
lnexports "Log exports" sum_ptas "PTAs" _cons "Constant" )  


* Table A7
local var concentration
nbreg disputes c.housesys##c.`var' lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
margins, at(housesys = 0 housesys = 1)
nbreg disputes c.housesys##c.`var' lngdp gdp_capita lnexport lnimport sum_ptas sum_dispute ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes c.housesys##c.`var' lngdp gdp_capita lnexport lnimport sum_ptas eci_value ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes c.housesys##c.`var' lngdp gdp_capita lnexport lnimport sum_ptas lnprod lnmarket ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg disputes c.housesys##c.`var' lngdp gdp_capita lnexport lnimport sum_ptas exelec execrlc ye ye2 ye3 if democ == 1& wto == 1 , robust cluster(iso3n) nolog
estimates store m5

estout m1 m2 m3 m4 m5,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex)  drop(ye ye2 ye3 ) ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" ///
lnexports "Log exports" sum_ptas "PTAs" eci_value "Economic complexity" exelec "Executive elections" ///
execrlc "Partisanship" sum_disputes "Previous disputes" lnproducts "Log products" lnmarkets "Log markets" ///
concentration "Export concentration" c.housesys#c.concentration "\ \ x export concentration" _cons "Constant" ) 


* Table A8
gen non_high = 1 - imf_adv
local var non_high
nbreg disputes c.housesys##i.`var' lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
margins, at(housesys = 0 housesys = 1)
nbreg disputes c.housesys##i.`var' lngdp gdp_capita lnexport lnimport sum_ptas sum_dispute ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg disputes c.housesys##i.`var' lngdp gdp_capita lnexport lnimport sum_ptas eci_value ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg disputes c.housesys##i.`var' lngdp gdp_capita lnexport lnimport sum_ptas lnprod lnmarket ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg disputes c.housesys##i.`var' lngdp gdp_capita lnexport lnimport sum_ptas exelec execrlc ye ye2 ye3 if democ == 1& wto == 1 , robust cluster(iso3n) nolog
estimates store m5

estout m1 m2 m3 m4 m5,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex)  drop(ye ye2 ye3 0.non_high*) ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" ///
lnexports "Log exports" sum_ptas "PTAs" eci_value "Economic complexity" exelec "Executive elections" ///
execrlc "Partisanship" sum_disputes "Previous disputes" lnproducts "Log products" lnmarkets "Log markets" ///
1.non_high "Non-advanced economy" 1.non_high#c.housesys "\ \ x non-advanced economy" _cons "Constant" ) 


* Table A.9
nbreg concerns housesys lngdp gdp_capita lnexport lnimport c.lnundervalued sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m1
nbreg concerns housesys lngdp gdp_capita lnexport lnimport i.floater sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m2
nbreg concerns housesys lngdp gdp_capita lnexport lnimport gdp_growth sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m3
nbreg concerns housesys lngdp gdp_capita lnexport lnimport gdp_growth_world sum_ptas ye ye2 ye3 if democ == 1  & wto == 1 , robust cluster(iso3n) nolog
estimates store m4
nbreg concerns housesys allhouse lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m5
nbreg concerns housesys checks lngdp gdp_capita  lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 , robust cluster(iso3n) nolog
estimates store m6
nbreg concerns housesys lngdp gdp_capita lnexport lnimport sum_ptas ye ye2 ye3 if democ == 1 & wto == 1 & countryname != "United States", robust cluster(iso3n) nolog
estimates store m7

estout m1 m2 m3 m4 m5 m6 m7,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) ///
stats(N N_clust, fmt(%4.0f) label("Number Obs." "Number Countries")) nolz style(tex)  drop(ye ye2 ye3 0.floaters )  ///
varlabels(housesys "Plurality rule" lngdp "Log GDP" gdp_capita "GDP per capita" lnimports "Log imports" ///
lnexports "Log exports" sum_ptas "PTAs" eci_value "Economic complexity" exelec "Executive elections" ///
gdp_growth "GDP growth" execrlc "Partisanship" sum_disputes "Previous disputes" lnproducts "Log products" ///
lnmarkets "Log markets" _cons "Constant" gdp_growth_world "World GDP growth" checks "Veto players" ///
 allhouse "Divided government" 1.floaters "Floating x-rate" lnundervalued "Exchange rate")



