version 11.0
log using "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.log", replace
#delimit ;

*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      economic_conservatism.do                        *;
*       Date:           October 11, 2012                                *;
*       Author:         MRG                                             *;
*       Purpose:      	Take economic_conservatism.dta and replicate    *;
*                       the results in Table 2.                         *;
* 	    Input File:     economic_conservatism.dta                       *;
*       Output File:    economic_conservatism.log                       *;
*       Data Output:    none                                            *;             
*       Previous file:  economic_conservatism.dta                       *;
*       Machine:        laptop                           				*;
*     ****************************************************************  *;
*     ****************************************************************  *;

set mem 400m;

use "C:\matt\publications\ajps4\replication\data_analysis\economic_conservatism.dta", clear;

set more off;

sum;

desc;

*     ****************************************************************  *;
*       Create a panel ID variable.                                     *;
*     ****************************************************************  *;

egen idn=concat(year ccode);
encode idn, gen(id);

*     ****************************************************************  *;
*       Replicate Table 2                                               *;
*     ****************************************************************  *;

*     ****************************************************************  *;
*       Table 2, Income Inequality -- Additive Model                    *;
*     ****************************************************************  *;

gllamm inequality1 attend_religious_services income_level 
        male age highest_education,  i(id) link(ologit) adapt;

*     ****************************************************************  *;
*       Table 2, Income Inequality -- Interactive Model                 *;
*     ****************************************************************  *;

gllamm inequality1 attend_religious_services income_level attendance_income_level 
        male age highest_education, i(id) link(ologit) adapt;
        
*     ****************************************************************  *;
*       Table 2, Government Responsibility -- Additive Model            *;
*     ****************************************************************  *;

xtreg gov_responsibility attend_religious_services income_level 
        male age highest_education, i(id) theta;

*     ****************************************************************  *;
*       Table 2, Government Responsibility -- Interactive Model         *;
*     ****************************************************************  *;

xtreg gov_responsibility attend_religious_services income_level attendance_income_level 
        male age highest_education,  i(id) theta;

*     ****************************************************************  *;
*       Table 2, Free Market -- Additive Model                          *;
*     ****************************************************************  *;

xtlogit free_market attend_religious_services income_level 
        male age highest_education, i(id) quad(30);

*     ****************************************************************  *;
*       Table 2, Free Market -- Interactive Model                       *;
*     ****************************************************************  *;

xtlogit free_market attend_religious_services income_level attendance_income_level 
        male age highest_education, i(id) quad(30);
        
*     ****************************************************************  *;
*     ****************************************************************  *;
*       Replication of Table 2 complete                                 *;
*     ****************************************************************  *;
*     ****************************************************************  *;

*     ****************************************************************  *; 
*     ****************************************************************  *; 
*       The End                                                         *;
*     ****************************************************************  *; 
*     ****************************************************************  *; 
