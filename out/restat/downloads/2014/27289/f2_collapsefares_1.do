
clear
*set mem 6000m
set processors 2
set more off


** files cleans and collapses fares

forvalues i = 1(1)4 {
	forvalues j = 1993(1)2010 {


	** loads fare data 
	use itinid tktroundtrip tktdollarcred mkttkcarrier mkttkcarrierchange tktpassengers tktitinfare mktid coupseqnum totcoupons /// 
	year quarter mktorigin mktdest mktmilesflown mktnonstopmiles couporigin coupdest using "fares_`j'_`i'.dta", clear

	compress	
	egen mkt=concat(mktorigin mktdest)
	
	* drops itinid if carrier is missing
	gen ind=0
	replace ind=1 if mkttkcarrier=="--"
	bysort itinid: egen totind=total(ind)
	drop if totind>0
	drop ind totind
	
	* drops if no itinid or mktid
	destring itinid mktid, replace force	
	drop if itinid==.
	drop if mktid==.

	
	* merges in cpi data
	sort year quarter
	merge year quarter using "blscpi_cleanQ.dta"
	tab _merge
	drop if _merge==2
	drop _merge
	
	* adjusts fares for inflation before dropping
	replace tktitinfare=tktitinfare/cpi
	
	* fixes number of passengers for 10% sample
	replace tktpassengers=10*tktpassengers
	
	** fixes the independence problem (need to update this at some point)
	replace mkttkcarrier="DL" if (mkttkcarrier=="EV" & ((year==1999 & quarter>1) | year>1999))
	replace mkttkcarrier="AA" if (mkttkcarrier=="HQ" & ((year==1999 & quarter>1) | year>1999))
	replace mkttkcarrier="FL" if (mkttkcarrier=="J7" & year>1998)
	replace mkttkcarrier="WN" if (mkttkcarrier=="KN" & year>1994)
	replace mkttkcarrier="PN" if (mkttkcarrier=="PA")
	replace mkttkcarrier="PN" if (mkttkcarrier=="KW")
	replace mkttkcarrier="PN" if (mkttkcarrier=="OP")
	replace mkttkcarrier="AA" if (mkttkcarrier=="MQ" & ((year==1998 & quarter>1) | year>1998))
	replace mkttkcarrier="DL" if (mkttkcarrier=="OH" & year>1999)
	replace mkttkcarrier="AA" if (mkttkcarrier=="QQ" & ((year==1999 & quarter>2) | year>1999))
	replace mkttkcarrier="AS" if (mkttkcarrier=="QX")
	replace mkttkcarrier="CO" if (mkttkcarrier=="RU")
	replace mkttkcarrier="US" if (mkttkcarrier=="TB")
	replace mkttkcarrier="9N" if (mkttkcarrier=="U2")
	replace mkttkcarrier="UA" if (mkttkcarrier=="ZW")
	replace mkttkcarrier="US" if (mkttkcarrier=="HP" & ((year==2005 & quarter>3) | year>2005))
	replace mkttkcarrier="DL" if (mkttkcarrier=="NW" & ((year==2008 & quarter>3) | year>2008))
	drop if (mkttkcarrier=="N5")
	
	
	** drops strange carriers (charters maybe?)
	* drop weird observations (2) in MSPLAS and LASMSP, 1995 quarter 1
	drop if mkttkcarrier=="EO"
	* drops carrier to the carribean
	drop if mkttkcarrier=="CS"
		
	* drop if DOT considers questionable
	drop if tktdollarcred==0
	drop tktdollarcred	
	
	* drops itineraries where carrier switches within a market (may want to drop entire itinid, rather than the half where carrier is not observed)
	drop if mkttkcarrierchange==1
	drop mkttkcarrierchange
	
	* drop tickets with many coupons
	drop if (totcoupons>6 & tktroundtrip==1)
	drop if (totcoupons>3 & tktroundtrip==0)

	
	
	
	* drop interline tickets (multiple ticketing carriers on same itinid)
	sort itinid coupseqnum
	gen ind=0
	replace ind=1 if (itinid==itinid[_n-1] & mkttkcarrier~=mkttkcarrier[_n-1])
	bysort itinid: egen totind=total(ind)
	drop if totind>0
	drop ind totind		
	
	/*
	* drops one-way tickets where multiple mktid are included in itinid (usually open-jaw tickets)
	sort itinid coupseqnum
	gen ind=0
	replace ind=1 if (itinid==itinid[_n-1] & mktid~=mktid[_n-1] & tktroundtrip==0)
	bysort itinid: egen totind=total(ind)
	drop if totind>0
	drop ind totind	
	*/
	
	* adjusts round-trip fares to make them comparable to one-way fares
	sort itinid coupseqnum
	replace tktitinfare = tktitinfare/2 if tktroundtrip==1

	
	* drop tickets with price outliers (ff or questionably expensive)
	drop if (tktitinfare<25 | tktitinfare>2500 | tktitinfare==.)
				
		
	* generates a variable to indicate nonstop/connecting itinerary
	gen ind=1
	bysort itinid mktid: egen totind=total(ind)
	gen nonstop=0
	replace nonstop=1 if totind==1
	drop ind totind
			
				
	* keeps only the first observation for each itinid & mktid combination (keeps return flights on roundtrip tickets in return mkt)
	sort itinid mktid coupseqnum
	gen ind=0
	replace ind=1 if ((itinid==itinid[_n-1] & mktid~=mktid[_n-1]) | (itinid~=itinid[_n-1]))
	drop if ind==0
	drop ind
	drop  itinid mktid coupseqnum totcoupons
	
	* calculates weights for each itinid
	bysort mkt mkttkcarrier nonstop: egen totpassengers=total(tktpassengers)
	bysort mkt: egen mkt_totpassengers=total(tktpassengers)
	gen itinid_wgt=(tktpassengers)/totpassengers
	gen mkt_itinid_wgt=(tktpassengers)/mkt_totpassengers

		
	* saves data before collapsing then collapsed data back in
	sort mkt mkttkcarrier nonstop
	save "temp.data", replace

	** calculates average fare by mkt/tktrpcarrier/nonstop, also passenger volumes
	use mkt mkttkcarrier nonstop tktitinfare tktpassengers using "temp.data", clear
	sort mkt mkttkcarrier nonstop 
	collapse (mean) avg_fare=tktitinfare (p10) pct10_fare=tktitinfare (p20) pct20_fare=tktitinfare (p30) pct30_fare=tktitinfare (p40) pct40_fare=tktitinfare ///
		 (p50) pct50_fare=tktitinfare (p60) pct60_fare=tktitinfare (p70) pct70_fare=tktitinfare (p80) pct80_fare=tktitinfare (p90) pct90_fare=tktitinfare ///
		 (p25) pct25_fare=tktitinfare (p75) pct75_fare=tktitinfare [fweight= tktpassengers], by(mkt mkttkcarrier nonstop)
	sort mkt mkttkcarrier nonstop
	save "temp_mkt-firm.data", replace	
	
	** calculates average fare by mkt
	use mkt tktitinfare tktpassengers using "temp.data", clear
	sort mkt
	collapse (mean) mkt_avg_fare=tktitinfare (p10) mkt_pct10_fare=tktitinfare (p20) mkt_pct20_fare=tktitinfare (p30) mkt_pct30_fare=tktitinfare ///
		 (p40) mkt_pct40_fare=tktitinfare (p50) mkt_pct50_fare=tktitinfare (p60) mkt_pct60_fare=tktitinfare (p70) mkt_pct70_fare=tktitinfare ///
		 (p80) mkt_pct80_fare=tktitinfare (p90) mkt_pct90_fare=tktitinfare (p25) mkt_pct25_fare=tktitinfare (p75) mkt_pct75_fare=tktitinfare ///
		 [fweight= tktpassengers], by(mkt)	
	sort mkt
	save "temp_mkt.data", replace
	
	** merges back in fare quantiles
	use "temp.data", clear
	
	sort mkt mkttkcarrier nonstop
	merge mkt mkttkcarrier nonstop using "temp_mkt-firm.data"
	tab _merge
	drop if _merge==2
	drop _merge
	
	
	
	sort mkt 
	merge mkt using "temp_mkt.data"
	tab _merge
	drop if _merge==2
	drop _merge	

	* erases the temp files
	erase "temp.data"
	erase "temp_mkt-firm.data"
	erase "temp_mkt.data"

	* drops a couple observations
	drop tktpassengers
	
	* calculates a few more variables
	bysort mkt mkttkcarrier nonstop: egen avg_distance=total(itinid_wgt*mktmilesflown)
	bysort mkt mkttkcarrier nonstop: egen avg_tktroundtrip=total(itinid_wgt*tktroundtrip)
	drop tktitinfare mktmilesflown tktroundtrip itinid_wgt mkt_itinid_wgt
	
	** drops duplicate observations
	sort mkt mkttkcarrier nonstop
	drop if (mkt==mkt[_n-1] & mkttkcarrier==mkttkcarrier[_n-1] & nonstop==nonstop[_n-1])
			
	** calculates the pctorigin measure for each carrier
	gen dummy=0
	sort mkttkcarrier mktorigin mktdest
	replace dummy=1 if (mkttkcarrier[_n-1]==mkttkcarrier[_n] & mktorigin[_n-1]==mktorigin[_n] & mktdest[_n-1]~=mktdest[_n])
	bysort mktorigin mkttkcarrier: egen numrouteserved=total(dummy)
	drop dummy
	
	gen dummy=0	
	sort mktorigin mktdest
	replace dummy=1 if (mktorigin[_n-1]==mktorigin[_n] & mktdest[_n-1]~=mktdest[_n])
	bysort mktorigin: egen totnumrouteserved=total(dummy)
	drop dummy
	
	gen fraction_routes=numrouteserved/totnumrouteserved
	drop mktorigin mktdest

	* sorts and saves data 
	compress
	sort year quarter mkt mkttkcarrier nonstop
	saveold "avgfare_`j'_`i'.dta", replace

	
	}
}


* appends all the files
clear
gen temp=.
forvalues i = 1(1)4 {
	forvalues j = 1993(1)2009 {	
	append using "avgfare_`j'_`i'.dta"	
	}
}
drop temp

* generates a mkt (time and endpoints) and carrier ids
sort mkt year quarter
egen mkt_id=group(mkt year quarter)

sort mkttkcarrier 
egen carrier_id=group(mkttkcarrier)

* sorts and saves the data
compress
sort mkt year quarter mkttkcarrier nonstop
save "avgfare.dta", replace
/*
* erases all the individual files 
forvalues i = 1(1)4 {
	forvalues j = 1993(1)2008 {		
	erase "avgfare_`j'_`i'.dta"			
	}
}
*/
