cls
clear all

global REGapp "/Users/taylorjaworski/Dropbox/Papers/EH/REGIONAL/REGapp/replication"
global shp "/Users/taylorjaworski/Dropbox/Data/Shapefiles/us_county_2010"

*****************************************
* IMPORT MARKET ACCESS DATA FROM MATLAB *
*****************************************
	
	*1960-1985-2010
	forvalues cost = 2/2 {
		foreach year of numlist 1960 1985 2010 {
			qui import delimited using "$REGapp/Matlab/marketaccess/output/MA-`year'-cost`cost'.csv", clear
			rename (v1 v2) (fips ma`year')
			if `year'==2010 {
				rename v3 ma`year'_cf
				}
			*keeporder fips ma`year'*
			qui save "$REGapp/data/temp/MA-`year'-cost`cost'.dta", replace
			}
		}
	use "$REGapp/data/temp/MA-1960-cost2.dta"
	qui merge m:m fips using "$REGapp/data/temp/MA-1985-cost2.dta", nogen
	qui merge m:m fips using "$REGapp/data/temp/MA-2010-cost2.dta", nogen
	
	save "$REGapp/data/temp/MA-cost2.dta", replace
	rm "$REGapp/data/temp/MA-1960-cost2.dta"
	rm "$REGapp/data/temp/MA-1985-cost2.dta"
	rm "$REGapp/data/temp/MA-2010-cost2.dta"
	
	*merge boundaries identifiers, fix VA county border for mapmaking
	qui merge m:m fips using "$REGapp/data/merge_to_map.dta"
	qui do "$REGapp/do/fix_VA_counties3.do"
	foreach var of varlist ma1960 ma1985 ma2010 ma2010_cf {
		*qui replace `var' = 0 if `var'==.
		qui egen T`var' = total(`var'), by(fips)
		qui replace `var' = T`var'
		}
	qui do "$REGapp/do/fix_VA_counties4.do"
	drop T* _merge

	*save market access variables for empirical analysis
	keeporder fips ma1960 ma1985 ma2010*
	qui save "$REGapp/data/MA_map.dta", replace
	
	*make maps
	*preserve
	*	import delimited "$REGapp/excel/merge_to_map.csv", clear 
	*	rename geoid10 fips
	*	save "$REGapp/data/merge_to_map.dta", replace	
	*restore
	
		*load map data
		shp2dta using "$shp/US_county_2010", database("$REGapp/data/usdb") coordinates("$REGapp/data/uscoord") genid(id) replace
		use "$REGapp/data/usdb", clear
		qui destring GEOID10 STATEFP10 COUNTYFP10, replace
		qui drop if STATEFP10==2 | STATEFP10==15 | STATEFP10==72
		rename GEOID10 fips 
		rename STATEFP10 stfp 
		rename COUNTYFP10 ctyfp
		rename NAME10 name

		*identify ARC states
		qui g appalachian = (stfp==1|stfp==13|stfp==21|stfp==24|stfp==28|stfp==36|stfp==37|stfp==39|stfp==42|stfp==45|stfp==47|stfp==51|stfp==54)

		*merge market access variables
		 merge m:m fips using "$REGapp/data/MA_map.dta"
		
		replace fips = 	51059	if fips ==	51610
		replace fips = 	51163	if fips ==	51678
		replace fips = 	51153	if fips ==	51685
		replace fips = 	51053	if fips ==	51730
		replace fips = 	51015	if fips ==	51820
		foreach var of varlist ma1960 ma1985 ma2010{
			*qui replace `var' = 0 if `var'==.
			qui egen M`var' = max(`var'), by(fips)
			qui replace `var' = M`var'
			}
		drop M* 
		replace fips = 51610 if fips ==	51059 & _merge==1
		replace fips = 51678 if fips ==	51163 & _merge==1
		replace fips = 51685 if fips ==	51153 & _merge==1
		replace fips = 51730 if fips ==	51053 & _merge==1
		replace fips = 51820 if fips ==	51015 & _merge==1
		qui drop _merge
		qui duplicates drop fips , force
		keeporder GISJOIN fips stfp ctyfp fips name id appalachian ma*
		
		qui g dln_MA = log(ma2010/ma1960)
		qui g dln_MA_cf = log(ma2010/ma2010_cf)
		
		*fix Westmoreland, PA county for map
		replace dln_MA_cf = 0.043 if fips==42129
		
		*fix Brown, OH county for map
		replace dln_MA_cf = .0092354 if fips==39015
		
		qui export delimited GISJOIN fips dln_MA using "$REGapp/data/factual-MA-change.csv", replace
		qui export delimited GISJOIN fips dln_MA_cf using "$REGapp/data/counterfactual-MA-change.csv", replace
		
		/*
		*calculate breaks for 9 groups
		xtile deciles_of_dln_MA_cf = dln_MA_cf if appalachian==1, n(10) 
		by deciles_of_dln_MA_cf, sort: sum dln_MA_cf if appalachian==1
		
		**make map for change in ACTUAL market access all US counties (adjusted income)	[Figure 4A]
		spmap dln_MA using "$REGapp/data/uscoord", id(id) legenda(off) cln(9) fcolor(Blues)
		gr export "$REGapp/paper/figures/figure4/figure4A.png", as(png) replace
		
		**make map for change in ACTUAL market access Appalachian counties (adjusted income) [Figure 4B]
		spmap dln_MA using "$REGapp/data/uscoord" if appalachian==1, id(id) legenda(off) cln(9) fcolor(Blues)
		gr export "$REGapp/paper/figures/figure4/figure4B.png", as(png) replace

		**make map for change in ACTUAL market access all US counties (adjusted income)	[Figure 6]
		spmap dln_MA_cf using "$REGapp/data/uscoord" if appalachian==1, id(id) legenda(off) fcolor(Blues) clb(.0019464 .0028393 .0037983 .0050499 .0062618 .0084646 .013536 .0297638 .063846)
		gr export "$REGapp/paper/figures/figure6/figure6.png", as(png) replace
		
		**make map for change in ACTUAL market access all US counties (adjusted income)	[Figure 6]
		spmap dln_MA_cf using "$REGapp/data/uscoord", id(id) legenda(off) fcolor(Blues) clb(.0019464 .0028393 .0037983 .0050499 .0062618 .0084646 .013536 .0297638 .063846)
		gr export "$REGapp/paper/figures/figure6/figure6_alt.png", as(png) replace
		*/
	
******************************************
* IMPORT COUNTERFACTUAL DATA FROM MATLAB *
******************************************
	
	*1960 (by county)
	forvalues cost = 2/2 {
		foreach year of numlist 1960 {
			qui import delimited using "$REGapp/Matlab/counterfactuals/output/cf-`year'-cost`cost'-county.csv", clear
			rename 	(v1 v2 v3 v4 v5 v6) (fips population income marketaccess amentities productiivty)
			qui g year = `year'
			keeporder year fips population income marketaccess amentities productiivty
			qui save "$REGapp/data/temp/CF-`year'-Cost`cost'-county.dta", replace

			}
		}
	
	*1985 (by county)
	forvalues cost = 2/2 {
		foreach year of numlist 1985 {
			qui import delimited using "$REGapp/Matlab/counterfactuals/output/cf-`year'-cost`cost'-county.csv", clear
			rename 	(v1 v2 v3 v4 v5 v6 v7 v8 v9) (fips population income marketaccess amentities productiivty popcf inccf macf )
			qui g year = `year'
			keeporder year fips population income marketaccess amentities productiivty popcf inccf macf
			qui save "$REGapp/data/temp/CF-`year'-Cost`cost'-county.dta", replace

			}
		}
		
	*2010 (by county)
	forvalues cost = 2/2 {
		foreach year of numlist 2010 {
			qui import delimited using "$REGapp/Matlab/counterfactuals/output/cf-`year'-cost`cost'-county.csv", clear
			rename 	(v1 v2 v3 v4 v5 v6 v7 v8 v9 v13 v14 v15) (fips population income marketaccess amentities productiivty popcf inccf macf popcf_Nconst inccf_Nconst macf_Nconst)
			qui g year = `year'
			keeporder year fips population income marketaccess amentities productiivty popcf inccf macf popcf_Nconst inccf_Nconst macf_Nconst
			qui save "$REGapp/data/temp/CF-`year'-Cost`cost'-county.dta", replace

			}
		}
		
	
	clear
	append using "$REGapp/data/temp/CF-1960-Cost2-county.dta"
	append using "$REGapp/data/temp/CF-1985-Cost2-county.dta"
	append using "$REGapp/data/temp/CF-2010-Cost2-county.dta"
	save "$REGapp/data/temp/CF-Cost2-county.dta", replace
	rm "$REGapp/data/temp/CF-1960-Cost2-county.dta"
	rm "$REGapp/data/temp/CF-1985-Cost2-county.dta"
	rm "$REGapp/data/temp/CF-2010-Cost2-county.dta"
	
	*1985 (aggregate)
	forvalues cost = 2/2 {
		foreach year of numlist 1985 {
			qui import delimited using "$REGapp/Matlab/counterfactuals/output/cf-`year'-cost`cost'-nation.csv", clear
			rename 	(v1 v2 v3 v4 v5) (Ntotal Ytotal Ncf_noadhs Ycf_noadhs Ucf_noadhs)
			qui g year = `year'
			keeporder year N* Y* U*
			qui save "$REGapp/data/temp/CF-`year'-Cost`cost'.dta", replace
			}
		}

	*2010 (aggregate)
	forvalues cost = 2/2 {
		foreach year of numlist 2010 {
			qui import delimited using "$REGapp/Matlab/counterfactuals/output/cf-`year'-cost`cost'-nation.csv", clear
			rename 	(v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20) ///
					(Ntotal Ytotal Ncf_noadhs Ycf_noadhs Ncf_parc Ycf_parc Ncf_delta Ycf_delta Ncf_i9 Ycf_i9 Ncf_i11 Ycf_i11 Ncf_i69 Ycf_i69 Ucf_noadhs Ucf_parc Ucf_delta Ucf_i9 Ucf_i11 Ucf_i69)
			qui g year = `year'
			keeporder year N* Y* U*
			qui save "$REGapp/data/temp/CF-`year'-Cost`cost'.dta", replace
	
			}
		}
			
	*robustness to theta and alpha
	foreach theta of newlist theta2 theta3 theta4 theta5 theta6 theta7 theta8 theta9 theta10 theta11 theta12 theta13 theta14 theta15 theta16 theta17 theta18 {
		foreach alpha of newlist alpha5 alpha10 alpha15 alpha19 {
			qui import delimited using "$REGapp/Matlab/counterfactuals/output/cf-2010-cost2-`theta'-`alpha'-nation.csv", clear
			rename 	(v1 v2 v3 v4 v15) (Ntotal Ytotal Ncf_noadhs Ycf_noadhs Ucf_noadhs)
			qui g alpha = "`alpha'"
			qui g theta = "`theta'"
			keeporder alpha theta N* Y* U*
			qui save "$REGapp/data/temp/CF-2010-Cost2-`theta'-`alpha'.dta", replace			
			}
		}
	clear
	foreach theta of newlist theta2 theta3 theta4 theta5 theta6 theta7 theta8 theta9 theta10 theta11 theta12 theta13 theta14 theta15 theta16 theta17 theta18 {
		foreach alpha of newlist alpha5 alpha10 alpha15 alpha19 {
			append using "$REGapp/data/temp/CF-2010-Cost2-`theta'-`alpha'.dta"
			rm "$REGapp/data/temp/CF-2010-Cost2-`theta'-`alpha'.dta"
			}
		}
	save "$REGapp/data/temp/CF-2010-Cost2-theta-alpha.dta", replace
	
*******************
* COUNTERFACTUALS *
*******************
	
	*1985 results 
	forvalues cost = 2/2 {
		foreach year of numlist 1985 {
			qui use "$REGapp/data/temp/CF-`year'-Cost`cost'.dta", clear
			rm "$REGapp/data/temp/CF-`year'-Cost`cost'.dta"
			}
		}
		
	*Table 3A (all counties) and Table 4 (alternative counterfactuals)
	forvalues cost = 2/2 {
		foreach year of numlist 2010 {
			qui use "$REGapp/data/temp/CF-`year'-Cost`cost'.dta", clear
			rm "$REGapp/data/temp/CF-`year'-Cost`cost'.dta"
			}
		}	
		
		*->create share of labor income variable
		foreach var of varlist Ycf_noadhs Ycf_parc Ycf_delta Ycf_i9 Ycf_i11 Ycf_i69 {
			qui g share_`var' = (`var'/Ytotal)*100
			}
		
		*->create share of labor income variable
		foreach var of varlist Ncf_noadhs {
			qui g share_`var' = (`var'/Ntotal)*100
			}
		
			**all counties [Table 3A]
			est clear
			rename Ycf_noadhs variable
			qui mean variable 
			qui eststo yr2010_Ycf_baseline
			rename variable Ycf_noadhs
			
			foreach var of varlist Ycf_noadhs {	
				rename share_`var' variable
				}
				
				qui mean variable
				qui eststo yr2010_Ycf_baseline_share
				
			foreach var of varlist Ycf_noadhs {	
				rename variable share_`var' 
				}	
			
			mean Ycf_noadhs
			qui eststo blank
			
			rename Ncf_noadhs variable
			qui mean variable
			qui eststo yr2010_Ncf_baseline
			rename variable Ncf_noadhs 
			
			foreach var of varlist Ncf_noadhs {	
				rename share_`var' variable
				}
				
				qui mean variable
				qui eststo yr2010_Ncf_baseline_share
				
			foreach var of varlist Ncf_noadhs {	
				rename variable share_`var' 
				}	
				
			
			
			qui g variable = 100*(1-Ucf_noadhs)/1
			qui mean variable
			qui eststo yr2010_Ucf_baseline
			drop variable
			
			estout yr2010_Ycf_baseline yr2010_Ycf_baseline_share blank yr2010_Ncf_baseline yr2010_Ncf_baseline_share blank yr2010_Ucf_baseline ///
				using "$REGapp/paper/tables/table3/table3_baseline.tex", replace style(tex) ///
				cells(b(fmt(2)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(variable*) ///
				varlabels(variable "1. All Counties")	
			estout yr2010_Ycf_baseline yr2010_Ycf_baseline_share using "$REGapp/paper/tables/table4/table4_baseline.tex", replace style(tex) /// 
				cells(b(fmt(2)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(variable*) ///
				varlabels(variable "1. ADHS")		
				
			
			**alternative counterfactuals [Table 4]
			foreach cf of newlist parc delta i9 i11 i69 {	
				est clear
				
				rename Ycf_`cf' variable
				qui mean variable 
				qui eststo
				rename variable Ycf_`cf'
				
				rename share_Ycf_`cf' variable
				qui mean variable 
				qui eststo
				rename variable share_Ycf_`cf'
				
				if "`cf'" == "parc" {
					local name = "PARC"
					local number = "2. "
					}
				if "`cf'" == "delta" {
					local name = "Delta Regional Authority"
					local number = "3. "
					}
				if "`cf'" == "i9" {
					local name = "I-9"
					local number = "4. "
					}
				if "`cf'" == "i11" {
					local name = "I-11"
					local number = "5. "
					}
				if "`cf'" == "i69" {
					local name = "I-69"
					local number = "6. "
					}
				
				
				estout est* using "$REGapp/paper/tables/table4/table4_`cf'.tex", replace style(tex) ///
					cells(b(fmt(2)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(variable*) ///
					varlabels(variable "`number'`name'")	

				}
				
	*Table 3B (by ARC, Non-ARC)
	use "$REGapp/data/temp/CF-Cost2-county.dta", clear
				
		/* merge with ARC variables */

		qui merge m:m fips using "$REGapp/data/data-arc-counties.dta" 

			*drop unused observations from using
			qui drop if _merge==2

			*rename ARC indicator variables
			qui g arc = (arc1967==1)
			
			*create Appalachian state/county indicator
			qui g appalachian = (_merge==3)

			*drop extra variables
			drop _merge state county name arc1967		
				
				*all counties by ARC==1
				preserve
				est clear
				collapse (sum) income inccf population popcf inccf_Nconst popcf_Nconst, by(year arc)
				qui replace income = income/1000000000
				qui replace population = population/1000000
				egen totalincome = total(income), by(year)
				egen totalpopulation = total(population), by(year)
				qui replace inccf = inccf/1000000000
				qui replace popcf = popcf/1000000
				qui replace inccf_Nconst = inccf_Nconst/1000000000
				qui replace popcf_Nconst = popcf_Nconst/1000000
				qui g incomeloss = (income-inccf)
				qui g incomeloss_Nconst = (income-inccf_Nconst)
				qui g populationloss = (population-popcf)
				qui g populationloss_Nconst = (population-popcf_Nconst)
				qui g percentinc = 100*(incomeloss/totalincome)
				qui g percentinc_Nconst = 100*(incomeloss_Nconst/totalincome)
				qui g percentpop = 100*(populationloss/totalpopulation)
				qui g percentpop_Nconst = 100*(populationloss_Nconst/totalpopulation)
				
					**Holding Utility Fixed
				
						*->income loss
						rename incomeloss variable
						qui mean variable if year==2010 & arc==1
						qui eststo est1
						rename variable incomeloss 
						
						*->share income loss
						rename percentinc variable
						qui mean variable if year==2010 & arc==1
						qui eststo est2
						rename variable percentinc 
					
						qui mean arc
						eststo blank
					
						*->population loss
						rename populationloss variable
						qui mean variable if year==2010 & arc==1
						qui eststo est3
						rename variable populationloss 
						
						*->share population loss
						rename percentpop variable
						qui mean variable if year==2010 & arc==1
						qui eststo est4
						rename variable percentpop 
				
					**Holding Population Fixed
				
						*->income loss
						rename incomeloss_Nconst variable
						 mean variable if year==2010 & arc==1
						qui eststo est5
						rename variable incomeloss_Nconst
						
						*->share income loss
						rename percentinc_Nconst variable
						 mean variable if year==2010 & arc==1
						qui eststo est6
						rename variable percentinc_Nconst
					
						qui mean arc
						eststo blank
					
						*->population loss
						rename populationloss_Nconst variable
						 mean variable if year==2010 & arc==1
						qui eststo est7
						rename variable populationloss_Nconst 
						
						*->share population loss
						rename percentpop_Nconst variable
						 mean variable if year==2010 & arc==1
						qui eststo est8
						rename variable percentpop_Nconst 
				
					*output
					estout est1 est2 blank est3 est4 blank blank using "$REGapp/paper/tables/table3/table3_arc1.tex", replace style(tex) /// 
						cells(b(fmt(2)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(variable*) ///
						varlabels(variable "2. ARC")	
						
				restore
				
				*all counties by ARC==0
				preserve
				est clear
				collapse (sum) income inccf population popcf inccf_Nconst popcf_Nconst, by(year arc)
				qui replace income = income/1000000000
				qui replace population = population/1000000
				egen totalincome = total(income), by(year)
				egen totalpopulation = total(population), by(year)
				qui replace inccf = inccf/1000000000
				qui replace popcf = popcf/1000000
				qui replace inccf_Nconst = inccf_Nconst/1000000000
				qui replace popcf_Nconst = popcf_Nconst/1000000
				qui g incomeloss = (income-inccf)
				qui g incomeloss_Nconst = (income-inccf_Nconst)
				qui g populationloss = (population-popcf)
				qui g populationloss_Nconst = (population-popcf_Nconst)
				qui g percentinc = 100*(incomeloss/totalincome)
				qui g percentinc_Nconst = 100*(incomeloss_Nconst/totalincome)
				qui g percentpop = 100*(populationloss/totalpopulation)
				qui g percentpop_Nconst = 100*(populationloss_Nconst/totalpopulation)
					
					
					**Holding Utility Fixed
					
						*->income loss
						rename incomeloss variable
						qui mean variable if year==2010 & arc==0
						qui eststo
						rename variable incomeloss 
						
						*->share income loss
						rename percentinc variable
						qui mean variable if year==2010 & arc==0
						qui eststo
						rename variable percentinc 
					
						qui mean arc
						eststo blank
					
						*->population loss
						rename populationloss variable
						qui mean variable if year==2010 & arc==0
						qui eststo est3
						rename variable populationloss 
						
						*->share population loss
						rename percentpop variable
						qui mean variable if year==2010 & arc==0
						qui eststo est4
						rename variable percentpop 
					
					**Holding Population Fixed
				
						*->income loss
						rename incomeloss_Nconst variable
						 mean variable if year==2010 & arc==0
						qui eststo est5
						rename variable incomeloss_Nconst
						
						*->share income loss
						rename percentinc_Nconst variable
						 mean variable if year==2010 & arc==0
						qui eststo est6
						rename variable percentinc_Nconst
					
						qui mean arc
						eststo blank
					
						*->population loss
						rename populationloss_Nconst variable
						 mean variable if year==2010 & arc==0
						qui eststo est7
						rename variable populationloss_Nconst 
						
						*->share population loss
						rename percentpop_Nconst variable
						 mean variable if year==2010 & arc==0
						qui eststo est8
						rename variable percentpop_Nconst 
					
					*output
					estout est1 est2 blank est3 est4 blank blank using "$REGapp/paper/tables/table3/table3_arc0.tex", replace style(tex) /// 
						cells(b(fmt(2)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(35) modelwidth(10) keep(variable*) ///
						varlabels(variable "3. Non-ARC")		
						
				restore
	
			*Price index	
			
				*->by region
				preserve
				qui g priceindex = marketaccess^(-1/8)
				qui g priceindex_cf = macf^(-1/8)
				qui summ priceindex 
				qui replace priceindex = priceindex/`r(mean)'
				qui replace priceindex_cf = priceindex_cf/`r(mean)'
				collapse (mean) priceindex priceindex_cf [aw=population], by(year arc)
				qui g percentpriceincrease = 100*(priceindex_cf-priceindex)/priceindex
				by year, sort: summ percentpriceincrease if arc==1
				by year, sort: summ percentpriceincrease if arc==0
				restore
				
				*->all counties
				preserve
				qui g priceindex = marketaccess^(-1/8)
				qui summ priceindex 
				qui replace priceindex = priceindex/`r(mean)'
				qui g priceindex_cf = macf^(-1/8)
				qui replace priceindex_cf = priceindex_cf/`r(mean)'
				collapse (mean) priceindex priceindex_cf [aw=population], by(year)
				qui g percentpriceincrease = 100*(priceindex_cf-priceindex)/priceindex
				by year, sort: summ percentpriceincrease
				restore
				
			
			
	*Figure 7
	use "$REGapp/data/temp/CF-Cost2-county.dta", clear
	*rm "$REGapp/data/temp/CF-Cost2-county.dta"
	
		/* merge with ARC variables */

		qui merge m:m fips using "$REGapp/data/data-arc-counties.dta" 

			*drop unused observations from using
			qui drop if _merge==2

			*rename ARC indicator variables
			qui g arc = (arc1967==1)
			
			*create Appalachian state/county indicator
			qui g appalachian = (_merge==3)

			*drop extra variables
			drop _merge state county name arc1967

			*construct "ARC relative to rest of country" variables
			collapse (sum) income inccf population popcf, by(year arc)
			
			qui replace inccf = income if year==1960
			qui replace popcf = population if year==1960
			
			qui g incpc = income/population
			qui g incpccf = inccf/popcf
			
			qui g incometemp = income if arc==0 
			egen income_rest = max(incometemp), by(year)
			qui g populationtemp = population if arc==0 
			egen population_rest = max(populationtemp), by(year)
			qui g incpctemp = incpc if arc==0 
			egen incpc_rest = max(incpctemp), by(year)
			
			g income_rel = (income/income_rest) 
			g population_rel = (population/population_rest) 
			g incpc_rel = (incpc/incpc_rest) 
			
			qui g inccftemp = inccf if arc==0 
			egen inccf_rest = max(inccftemp), by(year)
			qui g popcftemp = popcf if arc==0 
			egen popcf_rest = max(populationtemp), by(year)
			qui g incpccftemp = incpccf if arc==0 
			egen incpccf_rest = max(incpccftemp), by(year)
			
			g inccf_rel = (inccf/inccf_rest) 
			g popcf_rel = (popcf/popcf_rest) 
			g incpccf_rel = (incpccf/incpccf_rest) 
			
			qui sum income_rel if year==2010
			scalar income_rel = `r(mean)'
			qui sum inccf_rel if year==2010
			scalar inccf_rel = `r(mean)'
			
			*make figure
			gr tw 	(scatter income_rel year if arc==1, c(l) lc(black) mc(black) mfc(white) ms(o)) ///
					(scatter inccf_rel year if arc==1, c(l) lc(gray) lp(dash) mc(gray) mfc(white) ms(o)) ///
					, graphregion(color(white)) ylabel(.06(.01).09,nogrid format(%12.2f)) yscale(range(0.06 0.09)) xlabel(1960(25)2010,nogrid) xscale(range(1960 2010)) ///
					legend(off) text(.075 1990 "actual, w/ ADHS", size(small) color(black)) text(.072 1977.5 "counterfactual, w/o ADHS", color(gray) size(small) ) ///
					xtitle("") ytitle("percent income in ARC relative to rest of country")
			gr export "$REGapp/paper/figures/figure7/figure7.pdf", as(pdf) replace

				
	*Figure 8
	qui use "$REGapp/data/temp/CF-2010-Cost2-theta-alpha.dta", clear
	*rm "$REGapp/data/temp/CF-2010-Cost2-theta-alpha.dta"
	keeporder alpha theta Ytotal Ycf
	qui split alpha, p("alpha")
	qui split theta, p("theta")
	qui destring alpha2 theta2, replace
	drop alpha theta alpha1 theta1
	rename (alpha2 theta2) (alpha theta)
		
		*make figure
		preserve
		qui reshape wide Ytotal Ycf_noadhs, i(theta) j(alpha)
		rename Ytotal5 Ytotal
		keeporder theta Ytotal Ycf* 
		qui sum Ycf_noadhs5 if theta==18
		scalar alpha5 = `r(mean)'
		qui sum Ycf_noadhs10 if theta==18
		scalar alpha10 = `r(mean)'
		qui sum Ycf_noadhs15 if theta==18
		scalar alpha15 = `r(mean)'
		qui sum Ycf_noadhs19 if theta==18
		scalar alpha19 = `r(mean)'
			
			**different values of alpha and theta
			gr tw 	(scatter Ycf_noadhs5 theta, c(l) lc(gs0) mc(gs0) ms(o) mfc(gs0) lp(solid) msize(small)) ///
					(scatter Ycf_noadhs10 theta, c(l) lc(gs4) mc(gs4) ms(o) mfc(gs5) lp(solid) msize(small)) ///
					(scatter Ycf_noadhs15 theta, c(l) lc(gs8) mc(gs8) ms(o) mfc(gs10) lp(solid) msize(small)) ///
					(scatter Ycf_noadhs19 theta, c(l) lc(gs12) mc(gs12) ms(o) mfc(gs15) lp(solid) msize(small)) ///
					, graphregion(color(white)) ylabel(0(25)125,nogrid) legend(off) xlabel(2(2)18) xscale(range(1.5 19.5)) ytitle("income loss in 2010 from removing ADHS") xtitle("theta ({&theta})") ///
					text(`=alpha5' 18.85 "{&alpha} = 0.05", color(gs0) size(vsmall)) ///
					text(`=alpha10' 18.85 "{&alpha} = 0.10", color(gs4) size(vsmall)) ///
					text(`=alpha15' 18.85 "{&alpha} = 0.15", color(gs8) size(vsmall)) ///
					text(`=alpha19' 18.85 "{&alpha} = 0.19", color(gs12) size(vsmall)) 
			gr export "$REGapp/paper/figures/figure8/figure8.pdf", as(pdf) replace
			
		restore
		
		*make corresponding table for Figure 8
		preserve
		qui reshape wide Ytotal Ycf_noadhs, i(alpha) j(theta)
		rename Ytotal2 Ytotal
		keeporder alpha Ytotal Ycf* 
	
			**different values of alpha and theta
			est clear
			foreach alpha of numlist 5 10 15 19 {
				qui mean Ycf* if alpha==`alpha'
				eststo yr2010_Ycf_alpha`alpha'
				}
			estout yr2010_Ycf_alpha*, replace style(tex) ///
				cells(b(fmt(2)) ) collabels(none) mlabels(none) eqlabels(none) varwidth(20) modelwidth(10) keep(Ycf*) ///
				varlabels(	Ycf_noadhs2 " $\theta = 2$" ///
							Ycf_noadhs3 " $\theta = 3$" ///	
							Ycf_noadhs4 " $\theta = 4$" ///
							Ycf_noadhs5 " $\theta = 5$" ///
							Ycf_noadhs6 " $\theta = 6$" ///
							Ycf_noadhs7 " $\theta = 7$" ///
							Ycf_noadhs8 " $\theta = 8$" ///
							Ycf_noadhs9 " $\theta = 9$" ///
							Ycf_noadhs10 " $\theta = 10$" ///
							Ycf_noadhs11 " $\theta = 11$" ///
							Ycf_noadhs12 " $\theta = 12$" ///
							Ycf_noadhs13 " $\theta = 13$" ///
							Ycf_noadhs14 " $\theta = 14$" ///
							Ycf_noadhs15 " $\theta = 15$" ///
							Ycf_noadhs16 " $\theta = 16$" ///
							Ycf_noadhs17 " $\theta = 17$" ///
							Ycf_noadhs18 " $\theta = 18$")		
							
		restore

	*Different costs
	clear all
	append using "$REGapp/data/temp/CF-2010-Cost1.dta", 
	qui g cost = 1
	append using "$REGapp/data/temp/CF-2010-Cost3.dta", 
	qui replace cost = 3 if cost==.
	by cost, sort: sum Ycf_noadhs
