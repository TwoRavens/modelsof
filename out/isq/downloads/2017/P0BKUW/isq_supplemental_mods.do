//  program:    isq_supplemental_mods.do
//  task:       supplemental mods. 1. with other variables; 2. FRA/PRT recode (fn8) ; 3. fn10
//  project:    ISQ tipping


version 14
set linesize 80
set sortseed 88316337
clear all
macro drop _all
set matsize 11000



//  #1
//  Table 1 base mod_1, robust - 1 : with other variables

use isq_tipping_cs , clear

* mod_1
tobit tip usentries communist gdppc neighbortip sc labor , ll(0) 
	

* mod_2
tobit tip usentries communist gdppc neighbortip sc labor gini , ll(0) 

 
* mod_3
tobit tip usentries communist gdppc neighbortip sc labor tax , ll(0) 
 

* mod_4
tobit tip usentries communist gdppc neighbortip sc labor govxpgdp , ll(0) 


* mod_5
tobit tip usentries communist gdppc neighbortip sc labor english , ll(0) 	
	

* mod_6
tobit tip usentries communist gdppc neighbortip sc labor ethfrac relfrac , ll(0) 


* mod_7
tobit tip usentries communist gdppc neighbortip sc labor mulsim mixed , ll(0)


* mod_8
tobit tip usentries communist gdppc neighbortip sc labor wgindexpct , ll(0) 


* mod_9
tobit tip usentries communist gdppc neighbortip sc labor givemoney givetime helpstr , ll(0) 





//  #2
//  Table 1, robust - 2 : FRA/PRT recode (fn 8)

* mod_1
tobit tip_fp usentries communist gdppc neighbortip_fp sc_fp labor , ll(0) 
	
* mod_2
tobit tip_fp usentries communist gdppc neighbortip_fp sc_fp wage , ll(0)

* mod_3	
ivtobit tip_fp communist gdppc neighbortip_fp sc_fp labor (usentries = usally) , ll(0)

* mod_4
tobit tip_fp ustourism communist gdppc neighbortip_fp sc_fp labor , ll(0)

* mod_5	
tobit tip_fp usentries communist gdppc neighbortip_fp sc_fp labor mcdonalds internet trade , ll(0)	





//  #3
//  Table 1 , robust - 3 : another wage/value added (fn 10)

tobit tip usentries communist gdppc neighbortip sc wageV2 , ll(0) 	





//  #4
//  Table 2, robust : FRA/PRT recode (fn 8)

use isq_tipping_pa , clear

* mod_1
reg d_tip_fp d_usentries sc2010_fp stsc_fp sc1982_fp d_neighbortip_fp d_labor d_gdppc d_comm

* mod_2
reg d_tip_fp d_usentries sc2010_fp stsc_fp sc1982_fp
 		
	

clear
exit
