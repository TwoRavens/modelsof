

**********************************************************************************************************************************************************
***************************************************************************** GDP REGRESSIONS TABLES 1-9
**********************************************************************************************************************************************************


cd "/Users/luigipascali/Dropbox/JEWS STATA 2013/REPLICATION MATERIAL"
set more off

use TEMP_replicate.dta,clear

** DEFINE MAIN VARIABLES
gen CREDIT= creditP
gen GDP= VA_pc_*1000
gen LCREDIT= ln(CREDIT)
gen LGDP= ln(GDP)
gen NORTH=1 if comuni_REGNO_NAPOLI ==0
replace NORTH=0 if comuni_REGNO_NAPOLI ==1
gen J_by_N        =NORTH*JEW
gen JEW_size1_by_N =NORTH*JEW_size1
gen JEW_size2_by_N =NORTH*JEW_size2
gen JEW_size3_by_N =NORTH*JEW_size3
gen JEW_bank=1 if c4==1
replace JEW_bank=0 if c4==0 | c4==.

** DUMMIES
tabulate year, gen(yd)
tabulate n_prov_103, gen(p103_)

** EDUCATION
gen sq_perc_analf = perc_analf*perc_analf
gen sq_perc_elem =perc_elem *perc_elem
gen sq_perc_medie =perc_medie *perc_medie
gen sq_perc_diploma = perc_diploma*perc_diploma
gen sq_perc_laurea = perc_laurea*perc_laurea
gen sq_perc_notitolo = perc_notitolo*perc_notitolo

** DEFINE LOCALS
local PROVINCE_DUM p103*
local GEOGR "altimetria__q_min altimetria__q_max altimetria__q_capol sismicit__class_sism sea closetosea river"
local CAPITAL  capoluogo_regione
local POP "POP1300 POP1400"
local EDUC "perc_analf perc_elem perc_medie perc_diploma perc_laurea perc_notitolo sq_perc_analf sq_perc_elem sq_perc_medie sq_perc_diploma sq_perc_laurea sq_perc_notitolo"
local JEW_SIZES JEW_size1 JEW_size2 JEW_size3
local JEW_INTER JEW_size1_by_N JEW_size2_by_N JEW_size3_by_N


***************************************************************************** TABLES IN PAPER


********************** Descriptive Statistics
tabstat `JEW_SIZES' Monte JEW_bank `POP' GDP CREDIT creditS `GEOGR' `CAPITAL' superficie__supe_9 `EDUC' , s(mean p50 sd Min Max N) f(%9.2fc)  c(s)

********************** TABLE 2 LONG TERM PERSISTENCE 
*Jewish pawnshops
ivreg2 JEW_bank `JEW_SIZES' 					      if year==2002 & NORTH==0 ,cluster(id_publication)  
est store col1
ivreg2 JEW_bank `JEW_SIZES' `PROVINCE_DUM' 			  if year==2002 &  NORTH==0 ,cluster(id_publication) partial(`PROVINCE_DUM' ) 
est store col2
ivreg2 JEW_bank `JEW_SIZES' 						  if year==2002 &  NORTH==1 ,cluster(id_publication)  
est store col3
ivreg2 JEW_bank `JEW_SIZES' `PROVINCE_DUM' 			  if year==2002 & NORTH==1 ,cluster(id_publication) partial(`PROVINCE_DUM' ) 
est store col4

*Monte di Pieta
ivreg2 Monte JEW_bank  							 if year==2002 & NORTH==1 ,cluster(id_publication) 
est store col5
ivreg2 Monte JEW_bank `PROVINCE_DUM' 		     if year==2002 & NORTH==1 ,cluster(id_publication) partial(`PROVINCE_DUM' ) 
est store col6

*Credit/GDP
ivreg2 LCREDIT Monte             				yd*  if NORTH==1  					,cluster(id_publication year) partial( yd*) 
est store col7
ivreg2 LCREDIT Monte  `PROVINCE_DUM'            yd*  if NORTH==1  						,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col8
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LCREDIT Monte             				yd*  if NORTH==1  						,cluster(id_publication year) partial( yd*) 
est store col9
ivreg2 LCREDIT Monte  `PROVINCE_DUM'            yd*  if NORTH==1  					,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col10
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

*GDP
ivreg2 LGDP LCREDIT             			   yd*  if NORTH==1  						 ,cluster(id_publication year) partial( yd*) 
est store col11
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LGDP LCREDIT              			   yd*  if NORTH==1  						 ,cluster(id_publication year) partial( yd*) 
est store col12
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col*  using replication.txt, replace  title(table2 LONG TERM PERSISTENCE)  s(r2  N ) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

********************** TABLE 4 DIFF IN DIFF GDP 
gen JEW_NORTH_MONTE=J_by_N*Monte
gen JEW_MONTE=JEW*Monte
gen MONTE_NORTH=Monte*NORTH

ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR'           									yd*   		,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col1
ivreg2 LGDP JEW J_by_N JEW_NORTH_MONTE NORTH  `PROVINCE_DUM'  `GEOGR'       					yd*   		,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col2
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR' superficie__supe_91    					yd*    		,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col3	
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM' `GEOGR' `CAPITAL'  									yd*  		,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col4
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR' `POP'     									yd*     	,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col5
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR' `EDUC'    									yd*  		,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col6
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR'           									yd*  if  ducato_1454~=1 		,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col7
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR'           									yd*  if  ripartizione_geografica=="Italia centrale" 			,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col8

esta col*  using replication.txt, append  title(table4 JEWISH COMMUNITIES AND CURRENT ECONOMIC DEVELOPMENT)  s(r2  N ) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

********************** TABLE 5 DIFF IN DIFF GDP -ROBUSTNESS
foreach band in 100 150 250 350 450 { 
ivreg2 LGDP JEW J_by_N NORTH `PROVINCE_DUM'  `GEOGR'           yd*  if 	dist_border<`band'  		 ,cluster(id_publication year) partial(`PROVINCE_DUM' yd*) 
est store col`band'
}
esta col*  using replication.txt, append  title(table5 JEWISH COMMUNITIES AND CURRENT ECONOMIC DEVELOPMENT -robustness)  s(r2  N ) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

********************** TABLE 6 IV REGRESSIONS 

ivreg2 LGDP (LCREDIT= JEW)  					     							yd* if  NORTH==1  , partial( yd*)  ffirst
est store col1
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM' 					     				yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)  ffirst
est store col2
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)  ffirst
est store col3
ivreg2 LGDP (LCREDIT=`JEW_SIZES')  									     		yd* if  NORTH==1  , partial( yd*)   ffirst
est store col4
ivreg2 LGDP (LCREDIT=`JEW_SIZES')  `PROVINCE_DUM' 					     		yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)  ffirst
est store col5
ivreg2 LGDP (LCREDIT=`JEW_SIZES')  `PROVINCE_DUM'  `GEOGR'			     		yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)  ffirst
est store col6
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LGDP (LCREDIT= JEW)   					     							yd* if  NORTH==1  , partial( yd*)  ffirst
est store col7
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM' 					     				yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)  ffirst
est store col8
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)  ffirst
est store col9
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col*  using replication.txt, append  title(table6 BANKS AND LOCAL ECONOMIC DEVELOPMENT)  s(N sarganp jp widstat cdf) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

********************** TABLE 7 IV REGRESSIONS -ROBUSTNESS 

ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'  superficie__supe_91  		yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)   ffirst
est store col1
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR' `CAPITAL'  					yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)   ffirst
est store col2
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR' `POP'	    				yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)   ffirst
est store col3
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'  superficie__supe_91  		yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)   ffirst
est store col4
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR' `CAPITAL'  					yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)   ffirst
est store col5
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR' `POP'	    				yd* if  NORTH==1  , partial(`PROVINCE_DUM' yd*)   ffirst
est store col6
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1   & ducato_1454~=1 , partial(`PROVINCE_DUM' yd*)  ffirst
est store col7
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1 & ripartizione_geografica=="Italia centrale" , partial(`PROVINCE_DUM' yd*)  ffirst
est store col9
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM' 	 `GEOGR'				     		yd* if  NORTH==1  & stato_pontificio_1454==1 , partial(`PROVINCE_DUM' yd*)  ffirst
est store col11

replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1   & ducato_1454~=1 , partial(`PROVINCE_DUM' yd*)  ffirst
est store col8
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1 & ripartizione_geografica=="Italia centrale" , partial(`PROVINCE_DUM' yd*)  ffirst
est store col10
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM' 	 `GEOGR'					     	yd* if  NORTH==1  & stato_pontificio_1454==1 , partial(`PROVINCE_DUM' yd*)  ffirst
est store col12
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12  using replication.txt, append  title(table7 BANKS AND LOCAL ECONOMIC DEVELOPMENT -robustness)  s(N sarganp jp widstat cdf) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

********************** TABLE 8 IV REGRESSIONS -ROBUSTNESS 

foreach band in 100 150 250 350 450 { 
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1  & 	dist_border<`band', partial(`PROVINCE_DUM' yd*)  ffirst
est store col`band'
}
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
foreach band in 100 150 250 350 450 { 
ivreg2 LGDP (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'			     				yd* if  NORTH==1  & 	dist_border<`band', partial(`PROVINCE_DUM' yd*)  ffirst
est store col_a_`band'
}
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col*  using replication.txt, append  title(table8 BANKS AND LOCAL ECONOMIC DEVELOPMENT -robustness)  s(N sarganp jp widstat cdf) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

************************* TABLE 9 REGRESSIONS ON PERSISTENCE (CAUSAL)

** Persistence Second Stage
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR'           yd*  if  NORTH==1 						, partial(`PROVINCE_DUM' yd*) ffirst
est store col1
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR' `POP'     yd*  if  NORTH==1 						, partial(`PROVINCE_DUM' yd*)  ffirst
est store col2
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR'           yd*  if  ducato_1454~=1  & NORTH==1 		, partial(`PROVINCE_DUM' yd*)  ffirst
est store col5
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR'           yd*  if  ripartizione_geografica=="Italia centrale"  & NORTH==1 		, partial(`PROVINCE_DUM' yd*)  ffirst
est store col7



replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR'           yd*  if  NORTH==1 						, partial(`PROVINCE_DUM' yd*)  ffirst
est store col3
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR' `POP'     yd*  if  NORTH==1 						, partial(`PROVINCE_DUM' yd*)  ffirst
est store col4
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR'           yd*  if  ducato_1454~=1  & NORTH==1 		, partial(`PROVINCE_DUM' yd*)  ffirst
est store col6
ivreg2 LCREDIT (Monte= JEW)  `PROVINCE_DUM'  `GEOGR'           yd*  if  ripartizione_geografica=="Italia centrale"     & NORTH==1 		, partial(`PROVINCE_DUM' yd*)  ffirst
est store col8

replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col1 col2 col3 col4 col5 col6 col7 col8  using replication.txt, append  title(table9 LONG-TERM PERSISTENCE OF LOCAL FINANCIAL INSTITUTIONS)  s(N sarganp jp widstat cdf) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear


**********************************************************************************************************************************************************
***************************************************************************** PRODUCTIVITY REGRESSIONS TABLES 10-11
**********************************************************************************************************************************************************

use TEMP_replicate2.dta,clear

** DEFINE MAIN VARIABLES
gen CREDIT= creditP
gen LCREDIT= ln(CREDIT)
gen NORTH=1 if comuni_REGNO_NAPOLI ==0
replace NORTH=0 if comuni_REGNO_NAPOLI ==1
gen J_by_N        =NORTH*JEW
gen REAL_ltfp_diff_ols_city=    ltfp_diff_ols_city -   unweight_ltfp_diff_ols_city
gen REAL_ltfp_diff_ols_city_c = ltfp_diff_ols_city_c - unweight_ltfp_diff_ols_city_c

** DUMMIES
tabulate year, gen(yd)
tabulate n_prov_103, gen(p103_)

**DEFINE LOCALS
local PROVINCE_DUM p103*
local GEOGR "altimetria__q_min altimetria__q_max altimetria__q_capol sismicit__class_sism sea closetosea river"
local CAPITAL  capoluogo_regione
local POP "POP1300 POP1400"
local EDUC "perc_analf perc_elem perc_medie perc_diploma perc_laurea perc_notitolo sq_perc_analf sq_perc_elem sq_perc_medie sq_perc_diploma sq_perc_laurea sq_perc_notitolo"


********************** TABLE 10 BANKS AND AGGREGATE PRODUCTIVITY - MANUFACTURING
gen LTFP= ltfp_diff_ols_city
gen REALLOC=REAL_ltfp_diff_ols_city
gen TECHNL =unweight_ltfp_diff_ols_city
  
ivreg2 LTFP (LCREDIT= JEW)    `PROVINCE_DUM'  `GEOGR'  			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col1
ivreg2 REALLOC (LCREDIT= JEW) `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col3	
ivreg2 TECHNL (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col5
       	   	  
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LTFP (LCREDIT= JEW)    `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col2
ivreg2 REALLOC (LCREDIT= JEW) `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col4
ivreg2 TECHNL (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col6
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col1 col2 col3 col4 col5 col6 using replication.txt, append  title(table10 Banks and Local Aggregate Productivity Manufacturing)  s(N sarganp jp widstat cdf) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear

********************** TABLE 11 BANKS AND AGGREGATE PRODUCTIVITY - CONSTRUCTION
gen LTFP_c= ltfp_diff_ols_city_c
gen REALLOC_c=REAL_ltfp_diff_ols_city_c
gen TECHNL_c =unweight_ltfp_diff_ols_city_c
  
ivreg2 LTFP_c (LCREDIT= JEW)    `PROVINCE_DUM'  `GEOGR'  			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col1
ivreg2 REALLOC_c (LCREDIT= JEW) `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col3	
ivreg2 TECHNL_c (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col5
       	   	  
replace CREDIT= creditS
replace LCREDIT= ln(CREDIT)
ivreg2 LTFP_c (LCREDIT= JEW)    `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col2
ivreg2 REALLOC_c (LCREDIT= JEW) `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col4
ivreg2 TECHNL_c (LCREDIT= JEW)  `PROVINCE_DUM'  `GEOGR'   			       yd* if NORTH==1 , cluster(id_publication year) partial(`PROVINCE_DUM' yd*)
est store col6
replace CREDIT= creditP
replace LCREDIT= ln(CREDIT)

esta col1 col2 col3 col4 col5 col6 using replication.txt, append  title(table11 Banks and Local Aggregate Productivity Construction)  s(N sarganp jp widstat cdf) se starlevels(* 0.10 ** 0.05 *** 0.01)   
estimates clear



