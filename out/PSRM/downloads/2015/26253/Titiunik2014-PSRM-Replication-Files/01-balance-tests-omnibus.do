#delimit;
clear all;
cap log close;
set more off;
program drop _all;
postutil clear;

/*************************************

Omnibus balance tests (footnote 18)

**************************************/
* Texas;    
use "./output/dataTX-final.dta", clear;
gen dunop = votesh_incumb == 1;
/* remove dwhite_incumb to avoid collinearity */
mvtest means party gender dblack_incumb dhispa_incumb children  age  votesh_incumb dunop  sen_seniority hou_seniority 
                 dattorney  dbusiness  dmilitary  dbaptist  dcatholic  dmethodist    dbornhouston  dmaster  djd  turnoutsh presvotesh_dem usrepvotesh_dem  staterepvotesh_dem 
                 govvotesh_dem ussenvotesh_dem  pop_hispanic18sh  pop_white18sh  pop_black18sh if (year == 1993 | year ==1995) , by(dshort_term) heterogeneous;

mvtest means party gender dblack_incumb dhispa_incumb children  age  votesh_incumb dunop  sen_seniority hou_seniority 
                 dattorney  dbusiness  dmilitary  dbaptist  dcatholic  dmethodist    dbornhouston  dmaster  djd  turnoutsh presvotesh_dem usrepvotesh_dem  staterepvotesh_dem 
                 govvotesh_dem ussenvotesh_dem  pop_hispanic18sh  pop_white18sh  pop_black18sh if (year == 2003) , by(dshort_term) heterogeneous;

* Check that it makes sense; 
mvtest means party if (year == 2003) , by(dshort_term) heterogeneous;
ttest party if (year == 2003), by(dshort_term);

* Arkansas;
use "./output/dataAR-final.dta", clear;
gen dunop = votesh == 1;
mvtest means party gender dblack  children  age  votesh dunop sen_seniority hou_seniority dattorney  dbusiness  dbaptist  dpresbyterian dbornlittlerock  dmarried  
                 usrepvotesh_dem  ussenvotesh_dem  govvotesh_dem  pop_hispanic18sh  pop_white18sh  pop_black18sh, by(dshort_term) heterogeneous;

* Illinois;
use "./output/dataIL-final.dta", clear;
/* remove dopen to avoid collinearity*/
mvtest means inc_ddemocrat inc_votesh duncontested  dhispanic  inc_dincumb_2000   dblack gender   age  dma  dlaw  pop_hispanic18sh pop_white18sh  pop_black18sh  
                         house_votesh_dem house_open  house_uncontested inc_ddefeat_incumb2000, by(dshort_term) heterogeneous;
