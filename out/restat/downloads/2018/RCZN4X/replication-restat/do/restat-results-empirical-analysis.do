cls
clear all
set more off

global REGapp "/Users/taylorjaworski/Dropbox/Papers/EH/REGIONAL/REGapp/replication-restat"
*global shp "/Users/taylorjaworski/Dropbox/Papers/EH/REGIONAL/REGapp/replication/shapefiles/us_county_2010"

************************
* CONSTRUCT FINAL DATA *
************************

	qui use "$REGapp/data/restat-data-county-level.dta", clear
	drop distance_to_adhs distance_to_ihs adhs_miles ihs_miles highway_miles
	
	/* merge with market access variables */	
	
	qui merge m:m fips year using "$REGapp/data/restat-data-marketaccess.dta", nogen
		
	/* merge with local highway controls */
	
	qui merge m:m fips using "$REGapp/data/restat-data-market-size.dta", keepusing(distance_to_adhs2010 distance_to_ihs2010 adhs_miles2010 ihs_miles2010 highway_miles2010 dist_to_port2010) nogen
	
	/* merge market access approximation variables */
	qui merge m:m year fips using "$REGapp/data/restat-data-market-access-intermediate.dta", nogen
	
	/* merge with county area */
	qui merge m:m fips using "$REGapp/data/restat-data-county-area.dta", nogen

	/* merge with ARC variables */

	qui merge m:m fips using "$REGapp/data/restat-data-arc-counties.dta" 

		*drop unused observations from using
		qui drop if _merge==2

		*rename ARC indicator variables
		qui g arc = (arc1967==1)
		
		*create Appalachian state/county indicator
		qui g appalachian = (_merge==3)

		*drop extra variables
		drop _merge state county name arc1967

	/* merge SMA control */
	
	qui merge m:m fips using "$REGapp/data/restat-data-county-sma.dta"

		*drop unusing observations from using (AK, HI, PR)
		qui drop if _merge==2
		
		*create MSA indicator
		qui g control_SMA = (_merge==3)
		qui g control_SMA_id = (_merge==3)*fips
		
		*drop extra variables
		drop _merge	

	qui g state = int(fips/1000)
	
	qui g temp = total_income if year==1960
	egen inc1960 = max(temp), by(fips)
	drop temp
	qui g temp = total_income if year==2010
	egen inc2010 = max(temp), by(fips)
	drop temp
	
	foreach var of varlist manufacturing trade transportation construction finance government {
		qui g temp = `var' if year==1960
		egen ln`var'1960 = max(temp), by(fips)
		qui replace ln`var'1960 = log(ln`var'1960+1)
		drop temp
		}
		
	qui replace total_income = 1 if total_income==0
	qui g lnincome = log(total_income+1)
	sort fips year
	qui by fips, sort: g dlnincome = lnincome - lnincome[_n-1]
	qui g lnpop = log(population+1)
	qui by fips, sort: g dlnpop = lnpop - lnpop[_n-1]
	qui g lnincpc = log((total_income+1)/population)
	qui by fips, sort: g dlnincpc = lnincpc - lnincpc[_n-1]
	qui g lnvalue = log(value+1)
	qui by fips, sort: g dlnvalue = lnvalue - lnvalue[_n-2]
	qui g lnpoverty = log((poverty/100)+.01)
	qui by fips, sort: g dlnpoverty = lnpoverty - lnpoverty[_n-2]
	
	forvalues cost = 1/3 {
		
		qui g lnMAcost`cost' = log(MA_cost`cost')
		sort fips year
		qui by fips, sort: g dlnMAcost`cost' = lnMAcost`cost' - lnMAcost`cost'[_n-1]
		qui g lnMAcost`cost'_cf = log(MA_cost`cost'_cf)
		}
	forvalues cost = 2/2 {
		destring MA_cost`cost'_popCent, replace force
		qui g lnMAcost`cost'_popCent = log(MA_cost`cost'_popCent)
		sort fips year
		qui by fips, sort: g dlnMAcost`cost'_popCent = lnMAcost`cost'_popCent - lnMAcost`cost'_popCent[_n-1]
		qui g lnMAcost`cost'_cf_popCent = log(MA_cost`cost'_cf_popCent)
		}

	qui g area2 = area^2
	qui g area3 = area^3
	qui g latitude2 = latitude^2
	qui g latitude3 = latitude^3
	qui g longitude2 = longitude^2
	qui g longitude3 = longitude^3
	qui g lnarea = log(area)
	qui duplicates drop year fips, force
	
***********************
* EMPIRICIAL ANALYSIS *
***********************	
	
	/* Table 1 */
		
	est clear
				
		*(1) cost1, first-difference, year FE
		rename dlnMAcost2 dlnMA
		qui reg dlnincome dlnMA i.year [aw=total_income], vce(cl state)
		qui eststo est_cty_year_FE
		rename dlnMA dlnMAcost2
				
				preserve
				qui keep if year==2010
				qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
				qui mean cf_est if [_n]==_N
				qui eststo cf_est_cty_year_FE
				qui mean cf_se if [_n]==_N
				qui eststo cf_se_cty_year_FE
				restore
		
		*(2)state-year FE
		rename dlnMAcost2 dlnMA
		qui xi 	i.state*i.year
		qui reg dlnincome dlnMA _I* [aw=total_income], vce(cl state)
		qui eststo
		rename dlnMA dlnMAcost2
			
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_geography
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_geography
			restore
			
		*(3)f(latitude, longitude), area
		rename dlnMAcost2 dlnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea 
		qui reg dlnincome dlnMA _I* [aw=total_income], vce(cl state)
		qui eststo
		rename dlnMA dlnMAcost2
		
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_stateyear_FE
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_stateyear_FE
			restore
		
		*(4)transportation
		rename dlnMAcost2 dlnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 
		qui reg dlnincome dlnMA _I* [aw=total_income], vce(cl state)
		qui eststo
		rename dlnMA dlnMAcost2
				
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_transport
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_transport
			restore
		
		*(5)coal, employment composition
		rename dlnMAcost2 dlnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960
		qui reg dlnincome dlnMA _I* [aw=total_income], vce(cl state)
		qui eststo
		rename dlnMA dlnMAcost2
				
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_coal
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_coal
			restore
			
		*(6)SMA
		rename dlnMAcost2 dlnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		qui reg dlnincome dlnMA _I* [aw=total_income], vce(cl state)
		qui eststo
		rename dlnMA dlnMAcost2
			
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_msa
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_msa
			restore
	
		*blank
		qui	reg dlnincome i.year
		eststo
		qui	reg dlnincome i.year
		eststo firstblank
		qui	reg dlnincome i.year
		eststo cf_est_blank
		qui	reg dlnincome i.year
		eststo cf_se_blank
		
		forvalues i = 1/6 {
			qui	reg dlnincome i.year
			eststo first`i'
			}
		
		*(7)instrumental variables
		rename dlnMAcost2 dlnMA
		
		sort fips year
		qui g lnIV = log(IV_state_cost2)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
		
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea  ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		 ivreg2 dlnincome (dlnMA = dlnIV) _I* [aw=total_income], cl(state) first partial(_I*) savefirst savefp(first)
		qui eststo
		rename dlnMA dlnMAcost2
		
		nlcom (theta: (1.6-_b[dlnMA])/(_b[dlnMA]*.19))
		
			preserve
			keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[dlnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_iv1
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_iv1
			restore
			drop lnIV dlnIV*
			
		**display results
		estout est*, replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA) ///
			varlabels(dlnMA 	"$\ln(\text{MA})$")
		
		estout first*, replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnIV) ///
			varlabels(dlnIV 	"First Stage Coefficient")
		
		estout est*, replace style(tex) ///  
			drop(*) cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) ///
			stats(widstat, fmt(2) labels("First Stage \textit{F}-stat"))
		
		estout cf_est*, replace style(tex) /// 
			cells(b(fmt(1))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(cf_est) ///
			varlabels(cf_est "counterfactual loss (in billions)")
			
		estout cf_se*, replace style(tex) /// 
			cells(b(par fmt(1)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(cf_se) ///
			varlabels(cf_se " ")	
		
		**export results	
		estout est* using "$REGapp/results-tables/table1/table1.tex", replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA) ///
			varlabels(dlnMA "log(market access)")
		
		estout first* using "$REGapp/results-tables/table1/table1_first.tex", replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnIV) ///
			varlabels(dlnIV "  log($\widehat{\text{travel time}}$)")
		
		estout est* using "$REGapp/results-tables/table1/table1_Fstat.tex", replace style(tex) ///  
			drop(*) cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) ///
			stats(widstat, fmt(2) labels("First Stage \textit{F}-statistic"))
		
		estout cf_est* using "$REGapp/results-tables/table1/table1_cfest.tex", replace style(tex) /// 
			cells(b(fmt(1))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(cf_est) ///
			varlabels(cf_est "counterfactual loss (in billions)")
			
		estout cf_se* using "$REGapp/results-tables/table1/table1_cfse.tex", replace style(tex) /// 
			cells(b(par fmt(1)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(cf_se) ///
			varlabels(cf_se " ")	
	
	
	/* Table 2 */
	
		est clear
		
		*income
		rename dlnMAcost2 dlnMA
		qui g dlnMA_arc = dlnMA*arc
		
		sort fips year
		qui g lnIV = log(IV_state_cost2)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
		qui g dlnIV_arc = dlnIV*arc
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		qui ivreg2 dlnincome (dlnMA dlnMA_arc = dlnIV dlnIV_arc) _I* [aw=total_income], cl(state) partial(_I*) first
		qui eststo
		drop dlnMA_arc lnIV dlnIV*
		rename dlnMA dlnMAcost2
		
		qui reg dlnincome i.year
		qui eststo
		
		
		*employment
		rename dlnMAcost2 dlnMA
		qui g dlnMA_arc = dlnMA*arc
		
		sort fips year
		qui g lnIV = log(IV_state_cost2)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
		qui g dlnIV_arc = dlnIV*arc
		
		sort fips year
		qui by fips, sort: g dlnemployment = log(employment) - log(employment[_n-1])
		qui by fips, sort: g dlnmanufacturing = log(manufacturing) - log(manufacturing[_n-1])
		qui by fips, sort: g dlntrade = log(trade) - log(trade[_n-1])
		qui by fips, sort: g dlntransportation = log(transportation) - log(transportation[_n-1])
		qui by fips, sort: g dlnconstruction = log(construction) - log(construction[_n-1])
		qui by fips, sort: g dlnfinance = log(finance) - log(finance[_n-1])
		qui by fips, sort: g dlngovernment = log(government) - log(government[_n-1])
		
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		foreach var of varlist dlnmanufacturing dlntrade dlntransportation dlnconstruction dlnfinance dlngovernment {
			qui ivreg2 `var' (dlnMA dlnMA_arc = dlnIV dlnIV_arc) _I* [aw=total_income], cl(state) partial(_I*)
			qui eststo
			}
		drop dlnem* dlnma* dlntra* dlntra* dlncon* dlnfin* dlngov* dlnMA_arc lnIV dlnIV*
		rename dlnMA dlnMAcost2
		
		**display results	
		estout est* , replace style(tex) ///  
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "log(market access)" dlnMA_arc "log(market access) $\times$ ARC")
		
		**export results	
		estout est* using "$REGapp/results-tables/table2/table2.tex", replace style(tex) ///  
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "log(market access)" dlnMA_arc "log(market access) $\times$ ARC")
			
	/* Figure 5 */
		
		est clear 
		
		*figure for IV
		preserve
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		qui g dlnpop19301910 = log(population1930) - log(population1910)
		qui g lnIV = log(IV_state_cost2) 
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
				
		qui sum dlnpop19301910 if year==2010
		qui g dlnpop19301910_std = (dlnpop19301910 - `r(mean)')/`r(sd)'  
		
		qui sum dlnIV if year==2010
		qui g dlnIV_std = (dlnIV - `r(mean)')/`r(sd)' 

		qui reg dlnpop19301910_std _I* 
		qui predict residuals, resid
		
		qui reg dlnIV_std _I* 
		qui predict residualsbartik, resid
		
		qui reg residuals residualsbartik _I* if year==1985 [aw=total_income], cl(state)
		qui eststo
		
		qui reg residuals residualsbartik _I* if year==2010 [aw=total_income], cl(state)
		qui eststo
		
		gr tw (scatter residuals residualsbartik if residuals<9 & year==1985, mc(black) ms(oh)) (lfit residuals residualsbartik if year==1985 [aw=total_income], lc(black) lp(dash)) ///
			,ylabel(-9(3)9,nogrid) xlabel() legend(off) xtitle("% change in IV, 1960-1985") ytitle("% change in population, 1910-1930") graphregion(color(white)) ///
			saving("$REGapp/results-figures/figure5/figure5a.gph",replace)
		
		gr tw (scatter residuals residualsbartik if residuals<9 & year==2010, mc(gray) ms(oh)) (lfit residuals residualsbartik if year==2010 [aw=total_income], lc(gray) lp(dash)) ///
			,ylabel(-9(3)9,nogrid) xlabel() legend(off) xtitle("% change in IV, 1985-2010") ytitle("% change in population, 1910-1930") graphregion(color(white)) ///
			saving("$REGapp/results-figures/figure5/figure5b.gph",replace)
		
		gr combine "$REGapp/results-figures/figure5/figure5a.gph" "$REGapp/results-figures/figure5/figure5b.gph", graphregion(color(white)) 
		gr export "$REGapp/results-figures/figure5/figure5.pdf", as(pdf) replace 
		rm "$REGapp/results-figures/figure5/figure5a.gph" 
		rm "$REGapp/results-figures/figure5/figure5b.gph"
		restore
		
		*display coefficient on bartik IV for [1: 1985, 2: 2010, 3: all years]
		estout est*, replace style(tex) ///
			cells(b(fmt(3)) se(par fmt(3)) p(fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(residualsbartik*) ///
			varlabels(residualsbartik " \% change in IV")
		
		*export coefficient on bartik IV for [1: all years, 2: 1985, 3: 2010]
		estout est* using "$REGapp/results-footnotes/ivcheck.tex", replace style(tex) ///
			cells(b(fmt(3)) se(par fmt(3)) p(fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(residualsbartik*) ///
			varlabels(residualsbartik " \% change in IV")
	
	*(7)instrumental variables
		
		rename dlnMAcost2 dlnMA
		
		sort fips year
		qui g lnIV = log(IV_state_cost2)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
		
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*lnarea  ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		qui ivreg2 dlnpop (dlnMA = dlnIV) _I* [aw=total_income], cl(state) first partial(_I*) savefirst savefp(first)
		qui eststo
		rename dlnMA dlnMAcost2
		drop lnIV dlnIV*
		
		nlcom (beta: _b[dlnMA])
		
		display `beta'
	
	/* footnote : by income, population, and income per capita */
		
		est clear
		
		rename dlnMAcost2 dlnMA
		qui g lnIV = log(IV_state_cost2)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea 
		foreach var of newlist income pop incpc {
		
			qui reg dln`var' dlnMA _I* [aw=total_income], cl(state) 
			qui eststo
			
			}
		rename dlnMA dlnMAcost2
		drop dlnIV lnIV
		
		**export results	
		
		estout est* using "$REGapp/results-footnotes/decomp.tex", replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "$\ln(\text{MA})$")

	/* footnote : housing values */
	
		est clear
		
		rename lnMAcost2 lnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea 
		qui areg lnvalue lnMA _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		rename lnMA lnMAcost2
		
		**export results	
		
		estout est* using "$REGapp/results-footnotes/housing.tex", replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(lnMA*) ///
			varlabels(lnMA "$\ln(\text{MA})$")

	/* footnote : poverty */
	
		est clear
		
		rename lnMAcost2 lnMA
		qui g lnMA_arc = lnMA*arc
		
		sort fips year
		qui g lnIV = log(IV_state_cost2)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-2]
		qui by fips, sort: g dlnMA 	= lnMA - lnMA[_n-2]
		qui g dlnIV_arc = dlnIV*arc
		qui g dlnMA_arc = dlnMA*arc
		
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		
		*poverty
		qui ivreg2 dlnpoverty (dlnMA dlnMA_arc = dlnIV dlnIV_arc ) _I* [aw=total_income], cl(state) partial(_I*)
		qui eststo
		
		*housing
		qui ivreg2 dlnvalue (dlnMA dlnMA_arc = dlnIV dlnIV_arc ) _I* [aw=total_income], cl(state) partial(_I*)
		qui eststo
		
		rename lnMA lnMAcost2 
		drop lnMA_arc dlnMA_arc dlnMA dlnIV dlnIV_arc lnIV
		
		**export results	
		
		estout est* , replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "$\ln(\text{MA})$")
			
	/* footnote : employment by sector */
		
		est clear
		
		rename dlnMAcost2 dlnMA
		
		sort fips year
		qui by fips, sort: g dlnemployment = log(employment) - log(employment[_n-1])
		qui by fips, sort: g dlnmanufacturing = log(manufacturing) - log(manufacturing[_n-1])
		qui by fips, sort: g dlntrade = log(trade) - log(trade[_n-1])
		qui by fips, sort: g dlntransportation = log(transportation) - log(transportation[_n-1])
		qui by fips, sort: g dlnconstruction = log(construction) - log(construction[_n-1])
		qui by fips, sort: g dlnfinance = log(finance) - log(finance[_n-1])
		qui by fips, sort: g dlngovernment = log(government) - log(government[_n-1])
		
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea  
		foreach var of varlist dlnemployment dlnmanufacturing dlntrade dlntransportation dlnconstruction dlnfinance dlngovernment {
			qui reg `var' dlnMA _I* [aw=total_income], vce(cl state)
			qui eststo
			}
		drop dlnem* dlnma* dlntra* dlntra* dlncon* dlnfin* dlngov*
		rename dlnMA dlnMAcost2
		
		**export results	
		
		estout est* using "$REGapp/results-footnotes/employment.tex", replace style(tex) ///
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "$\ln(\text{MA})$")

	/* footnote : by ARC */
	
		est clear
		
		*income
		rename dlnMAcost2 dlnMA
		qui g dlnMA_arc = dlnMA*arc
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea 
		qui reg dlnincome dlnMA dlnMA_arc _I* [aw=total_income], vce(cl state)
		qui eststo
		drop dlnMA_arc
		rename dlnMA dlnMAcost2
		
		*poverty
		rename lnMAcost2 dlnMA
		qui g dlnMA_arc = dlnMA*arc 
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea 
		qui areg lnpoverty dlnMA dlnMA_arc _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		drop dlnMA_arc
		rename dlnMA lnMAcost2
		
		**export results	
		
		estout est* using "$REGapp/results-footnotes/arc.tex", replace style(tex) ///  
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "$\ln(\text{MA})$" dlnMA_arc "$\ln(\text{MA}) \times ARC$")

	/* footnote : population centroids */
	
		est clear
		
		*income
		rename dlnMAcost2_popCent dlnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea 
		qui reg dlnincome dlnMA _I* [aw=total_income], vce(cl state)
		qui eststo
		rename dlnMA dlnMAcost2_popCent
		
		**export results	
		
		estout est* using "$REGapp/results-footnotes/populationcentroids.tex", replace style(tex) ///  
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(dlnMA*) ///
			varlabels(dlnMA "$\ln(\text{MA})$" dlnMA_arc "$\ln(\text{MA}) \times ARC$")

	/* Appendix Table for summary statistics */
	
	est clear
	
		*(1) all counties
		preserve
		keeporder year arc total_income population MA_cost2
		qui g incomepc = (total_income+1)/(population+1)
		qui g inc_temp = total_income/1000000
		qui g pop_temp = population/1000
		qui g incpc_temp = incomepc
		qui g MA_temp = MA_cost2
		
		foreach year of numlist 1960 1985 2010 {
			foreach var of newlist inc pop incpc MA {
				qui g `var'_`year'_mean = .
				qui g `var'_`year'_sd = .
				qui sum `var'_temp if year==`year'
				qui replace `var'_`year'_mean = `r(mean)'
				qui replace `var'_`year'_sd = `r(sd)' 
				qui mean `var'_`year'_mean if _n==1
				eststo `var'_`year'_mall
				qui mean `var'_`year'_sd if _n==1
				eststo `var'_`year'_sall
				}
			}
		restore
		
		*(2) ARC counties
		preserve
		qui g incomepc = (total_income+1)/(population+1)
		qui g inc_temp = total_income/1000000
		qui g pop_temp = population/1000
		qui g incpc_temp = incomepc
		qui g MA_temp = MA_cost2
		
		foreach year of numlist 1960 1985 2010 {
			foreach var of newlist inc pop incpc MA {
				qui g `var'_`year'_mean = .
				qui g `var'_`year'_sd = .
				qui sum `var'_temp if year==`year' & arc==1
				qui replace `var'_`year'_mean = `r(mean)' 
				qui replace `var'_`year'_sd = `r(sd)' 
				qui mean `var'_`year'_mean if _n==1
				eststo `var'_`year'_marc
				qui mean `var'_`year'_sd if _n==1
				eststo `var'_`year'_sd_sarc
				}
			}
		restore
		
		*combine and display
			
			**income, by year
			foreach year of numlist 1960 1985 2010 {
				qui estout inc_`year'_m* using "$REGapp/results-tables/appendix/summarystats/appendix_inc_est_`year'.tex", replace style(tex) ///
					cells(b(fmt(%10.1fc ))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(inc*) ///
					varlabels(inc_`year'_mean "labor income (in millions)")
				qui estout inc_`year'_s* using "$REGapp/results-tables/appendix/summarystats/appendix_inc_se_`year'.tex", replace style(tex) ///
					cells(b(par fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(inc*) ///
					varlabels(inc_`year'_sd " ")
				}
			
			**population, by year
			foreach year of numlist 1960 1985 2010 {
				qui estout pop_`year'_m* using "$REGapp/results-tables/appendix/summarystats/appendix_pop_est_`year'.tex", replace style(tex) ///
					cells(b(fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(pop*) ///
					varlabels(pop_`year'_mean "population (in thousands)")
				qui estout pop_`year'_s* using "$REGapp/results-tables/appendix/summarystats/appendix_pop_se_`year'.tex", replace style(tex) ///
					cells(b(par fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(pop*) ///
					varlabels(pop_`year'_sd " ")
				}
			
			**income per capita, by year
			foreach year of numlist 1960 1985 2010 {
				qui estout incpc_`year'_m* using "$REGapp/results-tables/appendix/summarystats/appendix_incpc_est_`year'.tex", replace style(tex) ///
					cells(b(fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(incpc*) ///
					varlabels(incpc_`year'_mean "income per capita")
				qui estout incpc_`year'_s* using "$REGapp/results-tables/appendix/summarystats/appendix_incpc_se_`year'.tex", replace style(tex) ///
					cells(b(par fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(incpc*) ///
					varlabels(incpc_`year'_sd " ")
				}
				
			**market access, by year
			foreach year of numlist 1960 1985 2010 {
				qui estout MA_`year'_m* using "$REGapp/results-tables/appendix/summarystats/appendix_ma_est_`year'.tex", replace style(tex) ///
					cells(b(fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(MA*) ///
					varlabels(MA_`year'_mean "market access")
				qui estout MA_`year'_s* using "$REGapp/results-tables/appendix/summarystats/appendix_ma_se_`year'.tex", replace style(tex) ///
					cells(b(par fmt(%10.1fc))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(MA*) ///
					varlabels(MA_`year'_sd " ")
				}
		
			
	/* Appendix Table for main regression results */
		
	est clear
				
		*(1) cost1, first-difference, year FE
		rename lnMAcost2 lnMA
		qui areg lnincome lnMA i.year [aw=total_income], vce(cl state) a(fips)
		qui eststo est_cty_year_FE
		rename lnMA lnMAcost2
				
				preserve
				qui keep if year==2010
				qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
				qui mean cf_est if [_n]==_N
				qui eststo cf_est_cty_year_FE
				qui mean cf_se if [_n]==_N
				qui eststo cf_se_cty_year_FE
				restore
		
		*(2)state-year FE
		rename lnMAcost2 lnMA
		qui xi 	i.state*i.year
		qui areg lnincome lnMA _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		rename lnMA lnMAcost2
			
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_geography
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_geography
			restore
			
		*(3)f(latitude, longitude), area
		rename lnMAcost2 lnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea 
		qui areg lnincome lnMA _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		rename lnMA lnMAcost2
		
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_stateyear_FE
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_stateyear_FE
			restore
		
		*(4)transportation
		rename lnMAcost2 lnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 
		qui areg lnincome lnMA _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		rename lnMA lnMAcost2
				
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_transport
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_transport
			restore
		
		*(5)coal and employment by sector
		rename lnMAcost2 lnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960
		qui areg lnincome lnMA _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		rename lnMA lnMAcost2
				
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_coal
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_coal
			restore
			
		*(6)SMA
		rename lnMAcost2 lnMA
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		qui areg lnincome lnMA _I* [aw=total_income], vce(cl state) a(fips)
		qui eststo
		rename lnMA lnMAcost2
			
			preserve
			qui keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost2_cf - lnMAcost2)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_msa
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_msa
			restore
		
		*blank
		qui	reg dlnincome i.year
		eststo
		qui	reg dlnincome i.year
		eststo firstblank
		qui	reg dlnincome i.year
		eststo cf_est_blank
		qui	reg dlnincome i.year
		eststo cf_se_blank
		
		forvalues i = 1/6 {
			qui	reg dlnincome i.year
			eststo first`i'
			}
		
		*(7)instrumental variables
		rename lnMAcost1 lnMA
		
		sort fips year
		qui g lnIV = log(IV_state_cost1)
		qui by fips, sort: g dlnIV 	= lnIV - lnIV[_n-1]
		
		xtset fips
		qui xi 	i.state*i.year i.year*latitude i.year*longitude i.year*latitude2 i.year*longitude2 i.year*latitude3 i.year*longitude3 i.year*lnarea ///
				i.year*dist_to_port i.year*ihs_miles2010 i.year*adhs_miles2010 i.year*highway_miles2010 i.year*railroad2010 i.year*railroad1911 ///
				i.year*coal_reserves i.year*lnmanufacturing1960 i.year*lntrade1960 i.year*lntransportation1960 i.year*lnconstruction1960 i.year*lnfinance1960 i.year*lngovernment1960 ///
				i.year*control_SMA
		qui xtivreg2 lnincome (lnMA = lnIV) _I* [aw=total_income], cl(state) first partial(_I*) fe savefirst savefp(first)
		qui eststo
		rename lnMA lnMAcost1
				
			preserve
			keep if year==2010
			qui predictnl cf_est = sum(((exp(_b[lnMA] * -1 * (lnMAcost1_cf - lnMAcost1)) - 1)*(total_income/1000000000))) if year==2010, se(cf_se)
			qui mean cf_est if [_n]==_N
			qui eststo cf_est_iv1
			qui mean cf_se if [_n]==_N
			qui eststo cf_se_iv1
			restore
			drop lnIV dlnIV*
		
		
		**display results
		estout est* using "$REGapp/results-tables/appendix/mainresults/appendix_mainresults.tex", replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(lnMA) ///
			varlabels(lnMA 	"market access")
		
		estout first* using "$REGapp/results-tables/appendix/mainresults/appendix_mainresults_first.tex", replace style(tex) /// 
			cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(lnIV) ///
			varlabels(lnIV 	" $ \widehat{\text{travel time}}$")
		
		estout est* using "$REGapp/results-tables/appendix/mainresults/appendix_mainresults_Fstat.tex", replace style(tex) ///  
			drop(*) cells(b(fmt(3)) se(par fmt(3))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) ///
			stats(widstat, fmt(2) labels("First Stage \textit{F}-stat"))
		
		estout cf_est* using "$REGapp/results-tables/appendix/mainresults/appendix_mainresults_cfest.tex", replace style(tex) /// 
			cells(b(fmt(1))) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(cf_est) ///
			varlabels(cf_est "counterfactual loss (in billions)")
			
		estout cf_se* using "$REGapp/results-tables/appendix/mainresults/appendix_mainresults_cfse.tex", replace style(tex) /// 
			cells(b(par fmt(1)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(cf_se) ///
			varlabels(cf_se " ")		

			
			
		
