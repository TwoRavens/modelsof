//  program:    isq_tbls.do
//  task:       table 1 , table 2
//  project:    ISQ tipping


version 14
set linesize 80
set sortseed 88316337
clear all
macro drop _all
set matsize 11000




//  #1
//  Table 1: cross-sectional


use isq_tipping_cs , clear

* mod_1
tobit tip usentries communist gdppc neighbortip sc labor , ll(0) 
	
* mod_2
tobit tip usentries communist gdppc neighbortip sc wage , ll(0)

* mod_3	
ivtobit tip communist gdppc neighbortip sc labor (usentries = usally) , ll(0)

* mod_4
tobit tip ustourism communist gdppc neighbortip sc labor , ll(0)

* mod_5	
tobit tip usentries communist gdppc neighbortip sc labor mcdonalds internet trade , ll(0)
 

 
 
//  #2
//  Table 2: panel

use isq_tipping_pa , clear

* mod_1
reg d_tip d_usentries sc2010 stsc sc1982 d_neighbortip d_labor d_gdppc d_comm

* mod_2
reg d_tip d_usentries sc2010 stsc sc1982




clear
exit
