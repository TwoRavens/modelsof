
#delimit;

set more off;
set mem 100000;
set mat 350;

capture log close;

use Stpanel.dta;
log using RESTAT_WEBSITE_Table_1.log, replace;


tsset state year;

xi: regress rpropert urplus urminus i.state i.year i.state*year  [weight=pop], robust;
test urplus=urminus;




xi: reg rpropert urplus urminus prisrat perwhite perblack perhisp perpopurban beerrat ppop15_19 ppop20_24 
ppop25_34 ppop35_44 ppop45_54  i.state i.year i.state*year   [weight=pop], robust  ;

test urplus=urminus;



xi: regress violent urplus urminus i.state i.year i.state*year [weight=pop], robust;

test urplus=urminus;

xi: reg violent urplus urminus prisrat perwhite perblack perhisp perpopurban beerrat ppop15_19 ppop20_24 
ppop25_34 ppop35_44 ppop45_54 beerrat i.state i.year i.state*year    [weight=pop], robust  ;

test urplus=urminus;



xi: reg rburglar urplus urminus prisrat perwhite perblack perhisp perpopurban beerrat ppop15_19 ppop20_24 
ppop25_34 ppop35_44 ppop45_54 beerrat i.state i.year i.state*year   [weight=pop], robust  ;

test urplus=urminus;




xi: reg rlarcenytheft urplus urminus prisrat perwhite perblack perhisp perpopurban beerrat ppop15_19 ppop20_24 
ppop25_34 ppop35_44 ppop45_54 beerrat i.state i.year i.state*year   [weight=pop], robust  ;

test urplus=urminus;




xi: reg rmvt urplus urminus prisrat perwhite perblack perhisp perpopurban beerrat ppop15_19 ppop20_24 
ppop25_34 ppop35_44 ppop45_54 beerrat i.state i.year i.state*year   [weight=pop], robust  ;

test urplus=urminus;



log close ;
