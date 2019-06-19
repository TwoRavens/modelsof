clear
version 9
clear all
set mem 800m
cap log close
set more off
cd "/Users/paulinegrosjean/LITS/Research/MarkDemocPaper/RESTAT"

use LIT2006_RESTAT.dta
log using reg_paper, replace
****************************************************

# delimit;
set more off;
*************************************************************************
*		Figure 1 					 *
*************************************************************************;
collapse (mean) favmarket favdemo laborindex [aweight=weight_2], by (country countryname);

gen favmark=favmarket*100;
gen favdemo=favdemoc*100;

label var favmark "Support for the Market";
label var favdemo "Support for Democracy";
label var laborindex "Country Average Industrial Index";

#delimit;
twoway (scatter favdemo favmark in 1/8, msymbol(diamond) mcolor(blue) msize(tiny) mlabel(countryname) mlabcolor(blue) mlabsize(vsmall))
	(scatter favdemo favmark in 9/16, msymbol(diamond) mcolor(blue) msize(tiny) mlabel(countryname) mlabcolor(blue) mlabsize(vsmall) mlabposition(6)) 
	(scatter favdemo favmark in 17/27,msymbol(diamond) mcolor(blue) msize(tiny) mlabel(countryname ) mlabcolor(blue) mlabsize(vsmall)  mlabposition(1)) 
	(scatter favdemo favmark in 28,  msymbol(diamond)  mcolor(blue) msize(tiny) mlabel(countryname)mlabcolor(blue)  mlabsize(vsmall) mlabposition(9)), legend(off);



*************************************************************************
*		I. FROM DEMOCRACY TO SUPPORT FOR MARKET				 *
*************************************************************************;
reg favmarket moredemocracy;
outreg using "Table1.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) replace;
outreg using "Table2.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) replace;
outreg using "Table3.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) replace;

**************************************************************************
*		With More demo=Freehouse qualitative var that reflects diff levels  		 *
*************************************************************************;
# delimit;
set more off;
use LIT2006_RESTAT.dta, clear;
drop numfront;
gen numfront=.;
local i=1;
while `i'<43 {;
replace numfront=`i' if fronteer`i'==1;
local i=`i' +1;
};
gen freehouse2=8-freehouse;

keep if numfront<37;

foreach y in favmarket favcom {;
xi: dprobit `y' freehouse2 i.numfront  adult old midage poor rich i.educ genderB 
unemp selfemp whnow blnow servnow farmfarmworker pensioner student housewife if fronteer==1, cluster(numfront);
xi: outreg freehouse2  adult old midage poor rich i.educ genderB unemp selfemp whnow blnow servnow farmfarmworker pensioner student housewife 
using "Table1.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) append ;
};

**************************************************************************
* 	More demo=binary index from Freedom house	 *
*************************************************************************;
# delimit;
set more off;
foreach y in favmarket  favcomm {;
xi: dprobit `y' moredemocracy i.numfront adult old midage poor rich i.educ genderB 
unemp selfemp whnow blnow servnow farmfarmworker pensioner student housewife if fronteer==1, cluster(numfront);
xi: outreg moredemocracy  adult old midage poor rich i.educ genderB unemp selfemp whnow blnow servnow farmfarmworker pensioner student housewife 
using "Table1.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) append ;
};


**************************************************************************
*				Table 2:  Within zones          	*
*************************************************************************;
#delimit;
set more off;
use LIT2006_RESTAT.dta, clear;

drop numfront;
gen numfront=.;
local i=1;
while `i'<43 {;
replace numfront=`i' if fronteer`i'==1;
local i=`i' +1;
};
keep if numfront<37;
gen freehouse2=8-freehouse;

foreach x in austro ottoman prussia pol USSR yougo CIS cafsu {;
xi: dprobit favmarket freehouse2 rich poor old midage adult i.educ genderB unemp selfemp whnow blnow servnow
farmfarmworker pensioner student housewife i.numfront  if (fronteer==1 & zone_`x'==1), cluster(numfront);
xi: outreg freehouse2 
using "Table2.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) ctitle ("`x'") append ;
};
preserve;
drop if country==8;
xi: dprobit favmarket freehouse2 rich poor old midage adult i.educ genderB unemp selfemp whnow blnow servnow
farmfarmworker pensioner student housewife i.numfront  if (fronteer==1 ), cluster(numfront);
xi: outreg freehouse2 using "Table2.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) )  append ;
restore;
	

*************************************************************************
*		II. FROM MARKET TO SUPPORT FOR DEMOCRACY					 *
*************************************************************************;

/***********************************************************
*		Table 3: With laborindex, all regions  		*
************************************************************/

#delimit;
set more off;
use LIT2006_RESTAT.dta, clear;

gen metropole=(tablec==3);
tab metrop;

foreach y in favdemo favautho  {;
xi: dprobit `y' laborindex adult midage old poor rich   genderB i.educ unemp selfemp whnow blnow servnow farmfarmworker 
pensioner student housewife i.tablec i.country, cluster(country);
xi: outreg laborindex adult midage old poor rich   genderB i.educ unemp selfemp whnow blnow servnow farmfarmworker 
pensioner student housewife i.tablec using "Table3.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) append ;
};

/*****************************************************
*		Table 4: within  zones 			*
******************************************************/
#delimit;
set more off;
use LIT2006_RESTAT.dta, clear;

foreach x in austro ottoman prussia pol USSR yougo CIS cafsu {; 
xi: dprobit favdemo laborindex adult midage old poor rich genderB i.educ unemp selfemp whnow blnow servnow farmfarmworker 
pensioner student housewife i.country i.tablec if zone_`x'==1, cluster(country);
xi: outreg laborindex using "Table4.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) ) ctitle ("`x'") append ;
};

preserve;
drop if country==8;
xi: dprobit  favdemo laborindex adult midage old poor rich genderB i.educ unemp selfemp whnow blnow servnow farmfarmworker 
pensioner student housewife i.country i.tablec if  zone_austro==1 , cluster(country);
xi: outreg laborindex using "Table4.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) )   append ;
restore;


/***********************************************************
* Table 5: relative regional expenditures instead of  laborindex   *
*************************************************************/
foreach y in favdemo favautho  {;
xi: dprobit `y' relexp_region adult midage old poor rich genderB i.educ unemp selfemp whnow blnow servnow farmfarmworker
pensioner student housewife  i.tablec i.country, cluster(country);
xi: outreg relexp_region  using "Table5.xls", se bdec(3) coefastr 3aster  rdec(3) bracket bfmt(fc) addstat( "log likelihood", e(ll) )   append ;
};

