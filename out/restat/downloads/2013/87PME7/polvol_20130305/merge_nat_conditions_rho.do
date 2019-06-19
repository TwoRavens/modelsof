#delimit;
drop _all;


/*
use "$startdir/$outputdata\alleconconds.dta", clear;
keep year  lnRmkt nipadgdp_neg  nipadgdp recsty  nipadgdp_nsq2 fips recmonth;
collapse recmonth lnRmkt nipadgdp_neg  nipadgdp recsty  nipadgdp_nsq2 (sd) sdlnRmkt=lnRmkt, by(year);
*/;

use "$startdir/$outputdata/natmacroconditions.dta", clear;
*merge m:1 year using "$startdir/$outputdata/natreturns.dta", uniqusing sort;
merge  year using "$startdir/$outputdata/natreturns.dta", uniqusing sort;
drop _merge;

replace recmonth=recmonth/12;
replace nipadgdp=nipadgdp/100;
replace nipadgdp_nsq2=nipadgdp_nsq2/10000;

sort year;
gen lagnipadgdp=nipadgdp[_n-1];
gen leadnipadgdp=nipadgdp[_n+1];
gen lagnipadgdp_neg=nipadgdp_neg[_n-1];
gen leadnipadgdp_neg=nipadgdp_neg[_n+1];

reg recmonth nipadgdp lagnipadgdp leadnipadgdp nipadgdp_neg lagnipadgdp_neg leadnipadgdp_neg;
predict recmonthhat, xb;

probit recsty nipadgdp lagnipadgdp leadnipadgdp nipadgdp_neg lagnipadgdp_neg leadnipadgdp_neg;
predict recstyhat, xb;


rename year trueyear;

sort trueyear;

expand 7;
egen CY=seq(), by (trueyear);
replace CY=1950 if CY==1;
replace CY=1960 if CY==2;
replace CY=1970 if CY==3;
replace CY=1980 if CY==4;
replace CY=1990 if CY==5;
replace CY=2000 if CY==6;
replace CY=2005 if CY==7;
gen yearsago=CY-trueyear;
drop if yearsago<0; 
drop if yearsago>40;
gen rhoadjust=$rho^(2*yearsago);
gen rhotransadjust=$rhotrans^(2*yearsago);
rename CY year;
sort trueyear year;
save "$startdir/$outputdata/tempd", replace;


use A C Ninc varloginc p*loginc year  using "$startdir/$outputdata\natcohorts_fweight$control.dta", clear;
joinby year using "$startdir/$outputdata/tempd", unmatched(both);
drop if _merge==1;
drop _merge;
gen inityear=year-A*5;
gen initcondsyear=inityear-5;
gen ya5=year-5;
gen ya10=year-10;
gen ya15=year-15;
gen ya20=year-20;
gen ya25=year-25;
gen ya30=year-30;
gen ya35=year-35;

save "$startdir/$outputdata/forNATrobustness.dta", replace;


sort A C year yearsago;
*list  A C year yearsago trueyear;
sort C year;
by C year: egen rhoterm=total(rhoadjust) if trueyear>inityear;
quietly{;
foreach var of varlist lnRmkt recmonth nipadgdp_neg nipadgdp recsty nipadgdp_nsq2 recstyhat recmonthhat{;
gen rho`var'=rhoadjust*`var';
gen rhotrans`var'=rhotransadjust*`var';
sort C year;
by C year: egen cumsum`var'=total(`var') if trueyear>inityear; 
by C year: egen rhocumsum`var'=total(rho`var') if trueyear>inityear; 
by C year: egen initconds`var'=total(`var') if trueyear<inityear & trueyear>initcondsyear;
gen Ainitconds`var'=A*initconds`var';
gen Asqinitconds`var'=A*A*initconds`var';
by C year: egen ya5cumsum`var'=total(`var') if trueyear>ya5; 
by C year: egen ya5rhocumsum`var'=total(rho`var') if trueyear>ya5; 
by C year: egen ya10cumsum`var'=total(`var') if trueyear>ya10 & trueyear<=ya5; 
by C year: egen ya10rhocumsum`var'=total(rho`var') if trueyear>ya10 & trueyear<=ya5; 
replace ya10cumsum`var'=0 if A<2;
replace ya10rhocumsum`var'=0 if A<2;
by C year: egen ya15cumsum`var'=total(`var') if trueyear>ya15 & trueyear<=ya10; 
by C year: egen ya15rhocumsum`var'=total(rho`var') if trueyear>ya15 & trueyear<=ya10; 
replace ya15cumsum`var'=0 if A<3;
replace ya15rhocumsum`var'=0 if A<3;
by C year: egen ya20cumsum`var'=total(`var') if trueyear>ya20 & trueyear<=ya15; 
by C year: egen ya20rhocumsum`var'=total(rho`var') if trueyear>ya20 & trueyear<=ya15; 
replace ya20cumsum`var'=0 if A<4;
replace ya20rhocumsum`var'=0 if A<4;
by C year: egen ya25cumsum`var'=total(`var') if trueyear>ya25 & trueyear<=ya20; 
by C year: egen ya25rhocumsum`var'=total(rho`var') if trueyear>ya25 & trueyear<=ya20; 
replace ya25cumsum`var'=0 if A<5;
replace ya25rhocumsum`var'=0 if A<5;
by C year: egen ya30cumsum`var'=total(`var') if trueyear>ya30 & trueyear<=ya25; 
by C year: egen ya30rhocumsum`var'=total(rho`var') if trueyear>ya30 & trueyear<=ya25;  
replace ya30cumsum`var'=0 if A<6;
replace ya30rhocumsum`var'=0 if A<6;
by C year: egen ya35cumsum`var'=total(`var') if trueyear>ya35 & trueyear<=ya30;  
by C year: egen ya35rhocumsum`var'=total(rho`var') if trueyear>ya35 & trueyear<=ya30;  
replace ya35cumsum`var'=0 if A<7;
replace ya35rhocumsum`var'=0 if A<7;

by  C year: egen seven`var'=total(`var') if trueyear>inityear & trueyear>1970 & trueyear<1986; 
by  C year: egen rhoseven`var'=total(rho`var') if trueyear>inityear & trueyear>1970 & trueyear<1986; 
by  C year: egen notseven`var'=total(`var') if trueyear>inityear & (trueyear<1971 | trueyear>1985);  
by  C year: egen rhonotseven`var'=total(rho`var') if trueyear>inityear & (trueyear<1971 | trueyear>1985); 

};
};


foreach var of varlist lnRmkt recmonth nipadgdp_neg nipadgdp recsty nipadgdp_nsq2 recstyhat recmonthhat{;
by C year: egen currrecent`var'=total(`var') if yearsago<=4;
by C year: egen rhocurrrecent`var'=total(rho`var') if yearsago<=4;
by C year: egen rhotransrecent`var'=total(rhotrans`var') if yearsago<=4;
gen adjcumsum`var'=cumsum`var'-currrecent`var';
gen rhoadjcumsum`var'=rhocumsum`var'-rhocurrrecent`var';
};
collapse recsty recmonth nipadgdp_neg nipadgdp nipadgdp_nsq2 ya* seven*  notsev* rho* currrecent* cumsum* init* Ainit* Asqinit* varloginc p*loginc Ninc adjcumsum*, by (A C year);
foreach var in lnRmkt recmonth nipadgdp_neg nipadgdp recsty nipadgdp_nsq2 recmonthhat recstyhat{;
replace rhoseven`var'=0 if rhoseven`var'==.;
replace seven`var'=0 if seven`var'==.;
replace notseven`var'=0 if notseven`var'==.;
replace rhonotseven`var'=0 if rhonotseven`var'==.;
};

gen rho=$rho;
gen rhotrans=$rhotrans;
global bigrho=$rho*100;
save "$startdir/$outputdata\natcohortswconditionsrho$bigrho", replace;

drop ya*rhocumsum* rho*;
save "$startdir/$outputdata\natcohortswconditions$control", replace;


erase "$startdir/$outputdata/tempd.dta"

