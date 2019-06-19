clear
#delimit;
set more off;
capture log close;

use datatables2_3.dta;
log using Table2_3_du.log, replace;

tsset year;

g D2UR=urtotal-L2.urtotal;
g D3UR=urtotal-L3.urtotal;

forval i=2/3 {;
forval k=4/5 {;
gen D`i'L`k'UR=l`k'.urtotal-l`=`i'+`k''.urtotal;
};
};

forval i=2/3 {;
foreach g in 1517 1819 2024 2529 3034 3539 {;
g D`i'prcrrt`g'C=prcrrt`g'C-l`i'.prcrrt`g'C;
};
};

/* Table 2 */
forval k==4/5 {;
forval i=2/3 {;
foreach g in 1517 1819 2024 2529 3034 3539 {;
newey D`i'prcrrt`g'C D`i'UR D`i'L`k'UR, lag(3);
};
};
};

/* Table 3 */
foreach g in 1517 1819 2024 2529 3034 3539 {;
newey prcrrt`g'C l.prcrrt`g'C urplus urminus, lag(8);
test urplus=urminus;
};

log close ;
