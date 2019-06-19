********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 3

* START LOG SESSION
	log using "LOGS/TAB_3", replace

* BUILDING ESTIMATES ***********************************************************	
	
	* LOAD DATA
		u "DATA/BUILDING_LV.dta", clear	

	* BIVARIATE LN LAND VALUE LN DISSTANCE FROM CBD REGRESSIONS BY DECADE
		foreach num of numlist 1870 1890	1910 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010 {
			reg lLV ldist_cbd if CC == `num', robust
				scalar b_BLV_`num' = _b[ldist_cbd]
				scalar se_BLV_`num' = _se[ldist_cbd]
				scalar P_BLV_`num' = (2*ttail(e(df_r), abs(_b[ldist_cbd]/_se[ldist_cbd])))
				scalar N_BLV_`num' = e(N)
				scalar R2_BLV_`num' = e(r2)
				}
	* BIVARIATE LN HEIGHT LN DISSTANCE FROM CBD REGRESSIONS BY DECADE
		foreach num of numlist 1870 1890	1910 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010 {
			reg lHEIGHT ldist_cbd if CC == `num', robust
				scalar b_BH_`num' = _b[ldist_cbd]
				scalar se_BH_`num' = _se[ldist_cbd]
				scalar P_BH_`num' = (2*ttail(e(df_r), abs(_b[ldist_cbd]/_se[ldist_cbd])))
				scalar N_BH_`num' = e(N)
				scalar R2_BH_`num' = e(r2)
				}
					
		* WRITE ESTIMATES TO TABLE 
			collapse (first) LVYEAR , by(CC)
				foreach name in BLV BH {
					gen b_`name' = .
					gen se_`name' = .
					gen P_`name' = .
					gen N_`name' = .
					gen R2_`name' = .
					}
				foreach name1 in BLV BH {
				foreach name2 in b se P N R2 {
				foreach num of numlist 1870 1890	1910 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010 {	
					replace `name2'_`name1' = `name2'_`name1'_`num' if CC == `num'
					}
					}
					}
		* FORMAT AND FINALIZE GRID RESULTS	
			foreach name in BLV BH {
				replace b_`name' = round(b_`name', 0.01)
				replace R2_`name' = round(R2_`name', 0.01)
				tostring b_`name', gen(B_`name') force format(%9.2f)
				replace B_`name' = B_`name'+"*" if P_`name' < 0.1
				replace B_`name' = B_`name'+"*" if P_`name' < 0.05
				replace B_`name' = B_`name'+"*" if P_`name' < 0.01
				}
		* TEMPORARILY SAVE BUILDING RESULTS
			keep CC LVYEAR B_BLV R2_BLV B_BH R2_BH
			save "DATA/TEMP/temp.dta", replace
				
* GRID ESTIMATES ***************************************************************	

	* LOAD DATA
		u "DATA/GRID_WIDE.dta", clear

	* PARAMETRIC GRADIENTS ESTIMATES
		foreach num of numlist 1873 1892  1913 1926 1932 1939 1949 1961 1971 1981 1990 2000 2009  {
		reg llv`num' ldist_cbd, robust
			scalar  b_ALL_`num' = _b[ldist_cbd]
			scalar se_ALL_`num' = _se[ldist_cbd]
			scalar P_ALL_`num' = (2*ttail(e(df_r), abs(_b[ldist_cbd]/_se[ldist_cbd])))
			scalar N_ALL_`num' = e(N)
			scalar R2_ALL_`num' = e(r2)
		}
		* WRITE ESTIMATES TO TABLE
			clear
			set obs 13
			gen year = 1873
			replace year = 1892 if _n == 2
			replace year = 1913 if _n == 3
			replace year = 1926 if _n == 4
			replace year = 1932 if _n == 5
			replace year = 1939 if _n == 6
			replace year = 1949 if _n == 7
			replace year = 1961 if _n == 8
			replace year = 1971 if _n == 9
			replace year = 1981 if _n == 10
			replace year = 1990 if _n == 11
			replace year = 2000 if _n == 12
			replace year = 2009 if _n == 13
			gen b_ALL = .
			gen se_ALL = .
			gen P_ALL = .
			gen N_ALL = .
			gen R2_ALL = .
			foreach var of varlist b_ALL se_ALL  P_ALL N_ALL R2_ALL {
			foreach num of numlist 1873 1892  1913 1926 1932 1939 1949 1961 1971 1981 1990 2000 2009  {
				replace `var' = `var'_`num' if year == `num'
				}
				}
		* FORMAT AND FINALIZE GRID RESULTS	
			ren year LVYEAR
			replace b_ALL = round(b_ALL, 0.01)
			replace R2_ALL = round(R2_ALL, 0.01)
			tostring b_ALL, gen(B_ALL)  force format(%9.2f)
			replace B_ALL = B_ALL+"***" if P_ALL < 0.01
			keep LVYEAR B_ALL R2_ALL
			
* MERGE WITH GRID ESTIMATES ****************************************************			
		merge LVYEAR using "DATA/TEMP/temp.dta", unique sort
		tab _m
		drop _m
		erase "DATA/TEMP/temp.dta"
		drop LVYEAR 
		order CC
* WRITE TABLE 
	label var CC "Construction cohort"
	label var B_ALL "Land price elasticity: All grid cells"
	label var R2_ALL "Land price regression R2: All grid cells"
	label var B_BLV "Land price elasticity: Buildings sample"
	label var R2_BLV "Land price regression R2: Buildings sample"	
	label var B_BH "Height elasticity: Buildings sample"
	label var R2_BH "Height regression R2: Buildings sample"	
	export excel using "TABS\TAB_3.xls", firstrow(varlabels) replace

	
* END LOG SESSION
 log close	
