version 9.2

#delim ;
clear ;
set mem 1g ;
set more off ;

cd "..\Data";

**************************************************************************************
Purpose: Merge DOT DB1B Data and keep relevant variables
************************************************************************************** ;

tempfile temp ;

forval YR=2004(1)2007	{ ;

	foreach QTR in 1 3 4 { ;

	use itinid mktid seqnum coupons year quarter origin dest break tkcarrier opcarrier rpcarrier passengers fareclass distance 
		using "DOT DB1B Data Coupon_`YR'_`QTR'.dta", clear ;
	capture destring itinid mktid, replace;
	compress ;
	sort itinid mktid ;
	save `temp'_coupon, replace ;

	use itinid mktid mktcoupons tkcarrierchange opcarrierchange opcarrier mktfare mktmilesflown nonstopmiles
		using "DOT DB1B Data Market_`YR'_`QTR'.dta", clear ;
	capture destring itinid mktid, replace;
	compress ;
	sort itinid mktid ;
	save `temp'_market, replace ;

	use itinid roundtrip online dollarcred itinfare bulkfare milesflown 
		using "DOT DB1B Data Ticket_`YR'_`QTR'.dta", clear ;
	capture destring itinid mktid, replace;
	compress ;
	sort itinid ;
	save `temp'_ticket, replace ;

	use `temp'_coupon, clear ;
	merge itinid mktid using `temp'_market, uniqusing ;
	tab _merge ;
	drop _merge ;
	sort itinid ;
	merge itinid using `temp'_ticket, uniqusing ;
	tab _merge ;
	sort itinid seqnum ;
	save "DOT DB1B Data ALL_`YR'_`QTR'.dta", replace ;
	sum;


	erase "DOT DB1B Data Coupon_`YR'_`QTR'.dta" ;
	erase "DOT DB1B Data Market_`YR'_`QTR'.dta" ;
	erase "DOT DB1B Data Ticket_`YR'_`QTR'.dta" ;

	} ;
} ;


foreach YR in 2003 	{ ;

	foreach QTR in 3 4 { ;

	use itinid mktid seqnum coupons year quarter origin dest break tkcarrier opcarrier rpcarrier passengers fareclass distance 
		using "DOT DB1B Data Coupon_`YR'_`QTR'.dta", clear ;
	capture destring itinid mktid, replace;
	compress ;
	sort itinid mktid ;
	save `temp'_coupon, replace ;

	use itinid mktid mktcoupons tkcarrierchange opcarrierchange opcarrier mktfare mktmilesflown nonstopmiles
		using "DOT DB1B Data Market_`YR'_`QTR'.dta", clear ;
	capture destring itinid mktid, replace;
	compress ;
	sort itinid mktid ;
	save `temp'_market, replace ;

	use itinid roundtrip online dollarcred itinfare bulkfare milesflown 
		using "DOT DB1B Data Ticket_`YR'_`QTR'.dta", clear ;
	capture destring itinid mktid, replace;
	compress ;
	sort itinid ;
	save `temp'_ticket, replace ;

	use `temp'_coupon, clear ;
	merge itinid mktid using `temp'_market, uniqusing ;
	tab _merge ;
	drop _merge ;
	sort itinid ;
	merge itinid using `temp'_ticket, uniqusing ;
	tab _merge ;
	sort itinid seqnum ;
	save "DOT DB1B Data ALL_`YR'_`QTR'.dta", replace ;
	sum; 

	erase "DOT DB1B Data Coupon_`YR'_`QTR'.dta" ;
	erase "DOT DB1B Data Market_`YR'_`QTR'.dta" ;
	erase "DOT DB1B Data Ticket_`YR'_`QTR'.dta" ;

	} ;
} ;
