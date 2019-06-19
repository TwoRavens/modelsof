clear
#delimit;
set more 1;
capture log close;

set mem 400m;
set matsize 800;

use yields_data.dta, replace;

gen number=_n;


reshape long  y ycan yuk yjp, i(number) j(month);




gen level_ns=0;
gen slope_ns=0;
gen curvature_ns=0;
gen level_se_ns=0;
gen slope_se_ns=0;
gen curvature_se_ns=0;
gen r2_ns = 0;


gen diff=y-yuk;

gen ns1 =1;

gen ns2 = (1-exp(-0.0609*month))/(0.0609*month);

gen ns3 =  (1-exp(-0.0609*month))/(0.0609*month) -exp(-0.0609*month);



foreach x of numlist 1/240 {; 

regress diff ns1 ns2 ns3 if number==`x', robust noconstant ;
replace level_ns = _b[ns1] if number==`x';
replace slope_ns = _b[ns2] if number==`x';
replace curvature_ns = _b[ns3] if number==`x';
replace level_se_ns = _se[ns1] if number==`x';
replace slope_se_ns = _se[ns2] if number==`x';
replace curvature_se_ns = _se[ns3] if number==`x';
replace r2_ns = e(r2_a) if number==`x';
};

drop ns1 ns2 ns3;

reshape wide diff y ycan yuk yjp , i(number) j(month);


outsheet using NS_factors, replace;
