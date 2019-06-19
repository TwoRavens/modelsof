********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE A4

* START LOG SESSION
	log using "LOGS/TAB_A4", replace

* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear
		
	* GENERATE INDICATOR FOR NON-COMMERCIAL NON-RESIDENTIAL BUILDINGS		
			gen OTHER = 1-COMMERICIAL-RESIDENTIAL		
	
	* GENERATE YEAR TREND WITH 0-VALUE IN 2000
				gen Y = YEAR - 2000
				label var Y "Year - 2000"		
		
	* GEN INTERACTIONS
	
		* LAND PRICE x LAND USE INTERACTIONS
			gen lLV_RES = lLV * RESIDENTIAL		
			gen lLV_COM = lLV * COM
			gen lLV_OTHER = lLV * OTHER
			
		* LAND PRICE x LAND USE x TIME TREND INTERACTIONS
			gen lLV_Y = lLV*Y
			gen lLV_Y_COM = lLV*Y*COMMERICIAL
			gen lLV_Y_RES = lLV*Y*RESIDENTIAL
			gen lLV_Y_OTHER = lLV*Y*OTHER

		* COHORT EFFECTS x LAND USE INTERACTIONS
			tab CC, gen(CCD)
			foreach var of varlist CCD* {
				gen COM_`var' = COMMERICIAL *`var'
				gen RES_`var' = RESIDENTIAL *`var'
				}
		* GENERATE LAG LV INSTRUMENT	
			gen lLV_LAG= .
				replace lLV_LAG = llv1873 if CC == 1870
				replace lLV_LAG = llv1873 if CC == 1890
				replace lLV_LAG = llv1892 if CC == 1910
				replace lLV_LAG = llv1913 if CC == 1920
				replace lLV_LAG = llv1926 if CC == 1930
				replace lLV_LAG = llv1932 if CC == 1940
				replace lLV_LAG = llv1939 if CC == 1950
				replace lLV_LAG = llv1949 if CC == 1960
				replace lLV_LAG = llv1961 if CC == 1970
				replace lLV_LAG = llv1971 if CC == 1980
				replace lLV_LAG = llv1981 if CC == 1990			
				replace lLV_LAG = llv1990 if CC == 2000
				replace lLV_LAG = llv2000 if CC == 2010

		* IV LAG INTERACTIVES 
			gen lLV_LAG_COM = lLV_LAG*COMMERICIAL
			gen lLV_LAG_RES = lLV_LAG*RESIDENTIAL
			gen lLV_LAG_OTHER = lLV_LAG*OTHER
			gen lLV_LAG_Y_COM = lLV_LAG*Y*COMMERICIAL
			gen lLV_LAG_Y_RES = lLV_LAG*Y*RESIDENTIAL
			gen lLV_LAG_Y_OTHER = lLV_LAG*Y*OTHER			
			
		* LABEL GENERATED VARIABLES 	
			label var lLV_COM "Log land price x commercial"
			label var lLV_RES "Log land price x residential"
			label var lLV_OTHER "Log land price x (1 - commercial - residential)"
			label var lLV_Y "Log land price x (Year - 2000)"	
			label var lLV_Y_COM "Log land price x commercial  x (year - 2000)"
			label var lLV_Y_RES "Log land price x residential  x (year - 2000)"
			label var lLV_Y_OTHER "Log land price x (1 - commercial - residential)  x (year - 2000)"
		
		* GENERATE DISTANCE FROM RIVER DUMMY FOR IV GENERATION		
			gen Dr = dist_river < 0.1
			label var Dr "River within 0.1 mile (dummy)"

			
		* SAVE TEMPORARY DATA  
			save DATA/TEMP/temp.dta, replace
	
			
* PROGRAM FOR IV ANALYSIS ******************************************************
	program define IV 
		u DATA/TEMP/temp, clear
			* DEFINE ARGUMENTS: IVS TO BE USED 
			args IV1 IV2 IV3
			* GENERATE IV INTERACTIONS
			foreach var of varlist `IV1' `IV2' `IV3'{
				gen IV_COM_`var' = `var' * COMMERICIAL
				gen IV_RES_`var' = `var' * RESIDENTIAL
				gen IV_OTHER_`var' = `var' * OTHER
				* gen IV_Y_`var' = `var' * (YEAR - 2000)
				gen IV_COM_Y_`var' = `var' * (YEAR - 2000) * COMMERICIAL
				gen IV_RES_Y_`var' = `var' * (YEAR - 2000) * RESIDENTIAL
				gen IV_OTHER_Y_`var' = `var' * (YEAR - 2000) * OTHER
				}
			
			* AUX GREGRESSION OF OVER ID STAT
			ivreg2 lHEIGHT (lLV_COM lLV_RES lLV_OTHER lLV_Y_COM lLV_Y_RES lLV_Y_OTHER = IV* ) COM_CCD* RES_CCD*   RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church CCD* , partial(CCD* COM_CCD* RES_CCD*   RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church)
				local HJP = round( e(jp), 0.001)

			* MAIN REGRESSION REPORTED		
			eststo: ivreg2 lHEIGHT (lLV_COM lLV_RES lLV_OTHER lLV_Y_COM lLV_Y_RES lLV_Y_OTHER = IV* ) COM_CCD* RES_CCD*   RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church CCD*,   cluster(CC)   // partial(CCD* COM_CCD* RES_CCD*   RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church)
					estadd local Cohort_effects = "Yes"
					estadd local Cohort_lu_effects = "Yes"
					estadd local Land_price_lu_trend_effect = "Yes"
					estadd local Controls = "Yes"
					estadd local IV = "`IV1', `IV2', `IV3'"
					local KPF = round( e(rkf), 0.001)
					local KPP = round( e(idp), 0.001)
					estadd local KP_F_stat = `KPF'
					estadd local KP_LM_P_val = `KPP'
					estadd local HJ_P_val = `HJP'			
		end
		
* REGRESSIONS ******************************************************************
		
	* RUN IV PROGRAM WITH DIFFERENT IVS	
		
	* [1] IVS: DIST FROM CBD
		IV ldist_cbd 
	* [2] IVS: DIST FROM CBD & LAKE MICHIGAN
		IV ldist_cbd ldist_lm	
	* [3] IVS: DIST FROM CBD & LAKE MICHIG & CHICAGO RIVER
		IV ldist_cbd ldist_lm Dr	
	* [4] IVS: LAKE MICHIGAN
		IV  ldist_lm 
	* [5] IVS: LAKE MICHIGAN & CHICAGO RIVER
		IV  ldist_lm Dr
	* [6] IVS: CHICAGO RIVER
		IV  Dr
	* [7] IVS: LAGGED LAND PRICE
		IV  lLV_LAG 
		 
* WRITE TABLE A4				
	esttab using "TABS/TAB_A4.rtf", replace b(3) se(3) onecell label compress r2(3) aic(1)  drop( _cons lLV_Y_COM lLV_Y_COM  lLV_Y_RES lLV_Y_OTHER  COM_CCD* RES_CCD*   RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church CCD*) /// HOTEL WAREHOUSE PUBLIC CULTURE SPORTS RETAIL
	title ("Tab A4.	Elasticity of density with respect to land price: IV models") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) stats(Cohort_effects Cohort_lu_effects Land_price_lu_trend_effect Controls IV KP_LM_P_val HJ_P_val r2 N , fmt(%18.3g ) )  ///
	addnote("Notes:	2SLS estimates. Model (3) is identical to model (6) in Table 5 in the main paper. Standard errors clustered on con-struction date cohorts (decades). Controls include dummies for the following categories: Retail, hotel, warehouse, public use, cultural facility, sports facility. CBD / Lake Michigan / Chicago River instruments for land price are log distance from the CBD / log distance from Lake Michigan / within 0.1 mile from Chicago River throughout col-umns (1) to (6). Interactions of the instruments and land use indicators as well as time trends are used to instru-ment of land price interaction terms. In column (7), land prices lagged by one (decadal) cohort (the same co-hort for the 1870 cohort) are used as an instrument.")
	eststo clear	
	
* CLEAN MEMORY
	program drop _all
	erase DATA/TEMP/temp.dta	
	
	
* END LOG SESSION
 log close	

