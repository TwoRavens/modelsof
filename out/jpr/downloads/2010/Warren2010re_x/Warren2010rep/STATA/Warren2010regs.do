#delimit ;

clear;

set mem 100m;

***************************************************************;
* EDIT THE NEXT LINE TO POINT TO THE LOCATION OF THE DATA FILE ;
***************************************************************;

use "/Users/CamberW/Desktop/Warren2010rep/STATA/Regression Data.dta";

**********;
* MODEL 4 ;
**********;

logit ATOPdo_pres distance lcaprat polity_sim language ltrade conflict ally_ally con_con ally_con;


**********;
* MODEL 5 ;
**********;

logit ATOPdo_form distance lcaprat polity_sim language ltrade conflict ally_ally con_con ally_con;