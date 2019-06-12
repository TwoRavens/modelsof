version 11.0
log using "C:\matt\publications\ajps4\replication\data_analysis\individual_religious_participation.log", replace
#delimit ;

*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      individual_religious_participation.do           *;
*       Date:           October 11, 2012                                *;
*       Author:         MRG                                             *;
*       Purpose:      	Take individual_religious_participation.dta     *;
*                       and replicate the results in Table 1            *;
* 	    Input File:     individual_religious_participation.dta          *;
*       Output File:    individual_religious_participation.log          *;
*       Data Output:    none                                            *;             
*       Previous file:  individual_religious_participation.dta          *;
*       Machine:        office computer                 				*;
*     ****************************************************************  *;
*     ****************************************************************  *;

set mem 400m;

use "C:\matt\publications\ajps4\replication\data_analysis\individual_religious_participation.dta", clear;

set more off;

sum;

desc;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

*     ****************************************************************  *;
*       Get some descriptive information.                               *;
*     ****************************************************************  *;

xtset id;

xtsum attend_religious_services;

xttab  attend_religious_services;

*     ****************************************************************  *;
*       Replicate Table 1                                               *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Table 1, Model 1                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, vce (cluster id) theta;
        
*     ****************************************************************  *;
*       Table 1, Model 2                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services income_level lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, cluster(id) i(id) theta;

*     ****************************************************************  *;
*       Table 1, Model 3                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services male lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, cluster(id) i(id) theta;
        
*     ****************************************************************  *;
*       Table 1, Model 4                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services age65 lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, cluster(id) i(id) theta;

*     ****************************************************************  *;
*       Table 1, Model 5                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services highest_education lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, cluster(id) i(id) theta;

*     ****************************************************************  *;
*       Table 1, Model 6                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services social_class lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, cluster(id) i(id) theta;
        
*     ****************************************************************  *;
*       Table 1, Model 7                                                *;
*     ****************************************************************  *;

xtreg attend_religious_services income_level male age65 highest_education social_class lhdi urbanization inequality_gini  
        government_regulation government_favoritism social_regulation
        communist postcommunist roman_catholic_alesina protestant_alesina muslim_alesina, cluster(id) i(id) theta;
        
*     ****************************************************************  *;
*     ****************************************************************  *;
*       Replication of Table 1 complete                                 *;
*     ****************************************************************  *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*     ****************************************************************  *;
*       The End                                                         *;
*     ****************************************************************  *;
*     ****************************************************************  *;
