*** 
*** Women’s Participation in Peace Negotiations and the Durability of Peace

*** Date: 02/2018

*** Stata 14 MP
*** Platform: x86_64-apple-darwin15.6.0 (64-bit)
*** Running under: macOS High Sierra 10.13.2

clear
set more off

cd "PATH"
use "wpipn_krausekrausebränfors.dta"

stset nd_sgmnt, origin( time strt_pa ) ///
	enter( time strt_sgmnt ) failure( pc_nd == 1 ) ///
	exit( time . ) id( cas_id )

sts test fem_sig, logrank



* Table 1
* Model 1

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par ///
	pow_sha dem gdp hum_rig ///
	cpa , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail 

* Model 2

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	civ_soc , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail  

* Model 3

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par ///
	pow_sha dem gdp hum_rig ///
	con_iss , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail 

* Model 4

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	pea , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail  

stcox fem_sig con_dur con_int  war_par pow_sha dem gdp hum_rig ///
	pea , ///
	cluster( new_con_id ) robust ///
	tvc( pea ) texp(ln(_t))

* Model 5

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	fem_leg , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail 


* Model 6

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	fem_com , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail  

* Model 7

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	quo , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail  

* Model 8

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	lef_ide , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail 


* Table 2

preserve
keep if ( iso3c == "COD" & year == 2003 & pa_name == "Inter-Congolese Political Negotiations - The Final Act" ) | ///
	 ( iso3c == "SLV" & year == 1992 ) | ///
	 ( iso3c == "GTM" & year == 1996 ) | ///
	 ( iso3c == "LBR" & year == 2003 ) | ///
	 ( iso3c == "PNG" & year == 2001 ) | ///
	 ( iso3c == "GBR" & year == 1998 ) 
	 
list iso3c year pea dem gdp fem_leg fem_com quo hum_rig con_iss ///
	lef_ide civ_soc 	// remark: the 2004 COD value for fem_leg has been used in table 2 due to missing values
restore

* Figure 2: see wpipn_krausekrausebränfors.R
* Figure 3: see wpipn_krausekrausebränfors.R

* Appendix
* Figure A.1

sts graph, by( fem_sig ) ///
	legend(pos(6) label( 1 "Peace Agreemtents without Women Signatories" ) ///
		label( 2 "Peace Agreemtents with Women Signatories" )) ///
		title( "" ) ///
		xtitle( Time in Days )
		
* Table A.1
* Model 1

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	cpa con_iss pea fem_leg fem_com quo civ_soc, ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail

stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	cpa con_iss pea fem_leg fem_com quo civ_soc, ///
	cluster( new_con_id ) robust ///
	tvc( pea ) texp(ln(_t))
	
	
* Model 2

streg fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	cpa con_iss pea fem_leg fem_com quo civ_soc, ///
	cluster( new_con_id ) robust dist(weibull)

* Table A.2

cap drop sch* sca*
stcox fem_sig con_dur con_int war_par pow_sha dem gdp hum_rig ///
	un_pea_con , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 
	
estat phtest , detail

stcox fem_sig con_dur con_int  war_par pow_sha dem gdp hum_rig ///
	un_pea_con , ///
	tvc( un_pea_con ) texp(ln(_t)) ///
	cluster( new_con_id ) robust

* Table A.3
* Model 1

cap drop sch* sca*
stcox con_dur con_int war_par pow_sha dem gdp hum_rig ///
	civ_soc  , ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail

* Model 2

cap drop sch* sca*
stcox con_dur con_int war_par pow_sha dem gdp hum_rig ///
	cpa con_iss pea fem_leg fem_com quo civ_soc, ///
	cluster( new_con_id ) robust ///
	schoenfeld( sch* ) scaledsch( sca* ) 

estat phtest , detail

stcox con_dur con_int  war_par pow_sha dem gdp hum_rig ///
	cpa con_iss pea fem_leg fem_com quo civ_soc, ///
	cluster( new_con_id ) robust ///
	tvc( con_dur war_par pea ) texp(ln(_t))
