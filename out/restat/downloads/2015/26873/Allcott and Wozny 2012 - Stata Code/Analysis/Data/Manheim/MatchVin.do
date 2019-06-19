# delimit ;

/********************************************************
MatchVin.do
Nathan Wozny 8/17/09
Match VINs in auction data to Polk prefix file.
Called from AuctionPrices.do.
********************************************************/

gen MatchVin810 = substr(vin,1,8)+"*"+substr(vin,10,1)+"*******";
sort MatchVin810;
merge MatchVin810 using ../Matchups/Prefix810, nokeep keep(CarID ModelYear);
tab _merge;

* Double-check what these unmatched vehicles look like, then drop them;
*tab dmmake if match==0, m;
tab dmmodelyr _merge;
capture tab dmjdcat _merge, m;
capture tab dmjdsubcat _merge, m;

drop if _merge==1;
compare dmmodelyr ModelYear;
drop vin MatchVin810 _merge dmmodelyr;
capture drop dmjdsubcat;
