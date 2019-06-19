#delimit;
clear;
set more off;
capture log close;
clear matrix;
set mem 500m;
capture program drop _all;
set scheme s2mono;
cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";



use ../data/stock-price-data, clear;
keep if year(date)>=2006;
keep if toy_producer==1;
/*	Identify firms w/ 2007 recalls	*/
gen hvrecall = ticker=="HAS" | ticker=="EXX" | ticker=="JAKK" |ticker=="MVL" | ticker=="MAT" | ticker=="RCRC";
ta ticker hvrecall;

sort ticker date;
gen mrktcap = stock_price*shrout;
gen yw = wofd(date);
sort ticker yw date;

*Create value weighted returns of toy producers with and without recalls;
gen rec_mrktcap=mrktcap if hvrecall==1;
gen norec_mrktcap=mrktcap if hvrecall==0;

by ticker: gen rec_firm_val=mrktcap[_n-1] if hvrecall==1;
gen rec_weighted_return=ret*rec_firm_val if hvrecall==1;

by ticker: gen norec_firm_val=mrktcap[_n-1] if hvrecall==0;
gen norec_weighted_return=ret*norec_firm_val if hvrecall==0;

*Collapse by day;
collapse vwretd hshld (sum) rec_* norec_*, by(yw date);

*Use returns to create indices starting at 1 at beginning of 2006;
gen rec_ireturn_v=rec_weighted_return/rec_firm_val;
gen norec_ireturn_v=norec_weighted_return/norec_firm_val;

gen rec_ilevel_v=1 if date == d(3jan2006);
replace rec_ilevel_v = (1+rec_ireturn_v)*rec_ilevel_v[_n-1] if date>d(3jan2006);

gen norec_ilevel_v=1 if date == d(3jan2006);
replace norec_ilevel_v = (1+norec_ireturn_v)*norec_ilevel_v[_n-1] if date>d(3jan2006);

*Index for full market;
gen mktlevel=1 if date == d(3jan2006);
replace mktlevel = (1+vwretd)*mktlevel[_n-1] if date>d(3jan2006);

*FF index of household goods;
gen hshldlevel = 1 if date == d(3jan2006);
replace hshldlevel = (1+hshld/100)*hshldlevel[_n-1] if date>d(3jan2006);

sort yw date;
by yw: keep if _n==1;
tw (connect rec_ilevel_v date, mcolor(black) msize(small)  m(Oh)) (connect norec_ilevel_v date, mcolor(black) msize(small)  m(Dh)) (connect mktlevel date, mcolor(black) msize(small)  m(Th)) (connect hshldlevel date, mcolor(black) msize(small)  m(Sh)), legend(lab(1 "Toy Producers w/ 2007 Recall") lab(2 "Toy Producers w/out 2007 Recall") lab(3 "FF Market") lab(4 "FF Consumer Goods") rows(2)) xtitle("Date") xlabel(#10, angle(45));
graph export ../output/toyindex-market-06-07.tif, as(tif) replace;


