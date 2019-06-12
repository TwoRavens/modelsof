# delimit ;
clear;
*version 13;
set matsize 400;
set more off;



log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/CreatingDataSetsFromAmelia.log", replace;

*********************************************************************;
*Author: Jeff Carter                                                *;
*Date: Tuesday, December 9, 2014                                     *;
*Purpose: Creating Data Sets from Amelia Output    *;
***********************************************************************;


*** Data Set 1  ***;
insheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.csv";
outsheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.dta", replace;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.dta", replace;
sum;
clear;


*** Data Set 2  ***;
insheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.csv";
outsheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.dta", replace;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.dta", replace;
sum;
clear;


*** Data Set 3  ***;
insheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.csv";
outsheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.dta", replace;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.dta", replace;
sum;
clear;


*** Data Set 4  ***;
insheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.csv";
outsheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.dta", replace;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.dta", replace;
sum;
clear;


*** Data Set 5  ***;
insheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.csv";
outsheet using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.dta", replace;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.dta", replace;
sum;
clear;





