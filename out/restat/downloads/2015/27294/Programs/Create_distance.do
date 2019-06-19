#delimit;
clear;
set mem 700m;
set more off;

cd "..\Data";

macro define styr=1997 ;
macro define endyr=2003 ;

tempfile temp;

use origin dest distance using  "DOT_DB1B_Data_Coupon_1997_1.dta";
duplicates drop;
save DistNS;

forval YR=$styr(1)$endyr	{ ;

	foreach QTR in 1 2 3 4  { ;
	
		use origin dest distance using "DOT_DB1B_Data_Coupon_`YR'_`QTR'.dta";
		duplicates drop;
		
		append using DistNS;
		duplicates drop;
		save DistNS, replace;
	};

};

forval YR=2007(1)2007   { ;

	foreach QTR in 1 2 3 4  { ;
	
		use origin dest distance using "DOT_DB1B_Data_Coupon_`YR'_`QTR'.dta";
		duplicates drop;
		
		append using DistNS;
		duplicates drop;
		save DistNS, replace;
	};

};

duplicates drop;
save DistNS, replace;

rename origin x;
rename dest origin;
rename x dest;

append using DistNS;
duplicates drop;
collapse (mean) distance, by (origin dest);
save DistNS, replace;

**************************************************;

replace origin = "CHI" if origin == "ORD" | origin == "MDW";
replace origin = "NYC" if origin == "JFK" | origin == "EWR" | origin == "LGA";
replace origin = "WAS" if origin == "DCA" | origin == "IAD" | origin == "BWI";

collapse (mean) distance, by (origin dest);

save `temp'1, replace;

rename origin x;
rename dest origin;
rename x dest;

append using `temp'1;
append using DistNS;
duplicates drop;

	
sort origin dest;
save DistNS, replace;
