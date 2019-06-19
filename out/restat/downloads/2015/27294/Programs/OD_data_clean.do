#delim ;
clear ;
set mem 2g ;
set more off ;

cd "../Data";

*************************************************************************************
Purpose: Clean Department of Transportation (DoT) DB1B airline data 

************************************************************************************* ;

tempfile temp ;

cap log close;
log using od_data_clean.log, replace;

* CLEAN DATA ;

foreach YR in 1997 1998 2000 2001 2003 2007 { ;

	foreach QTR in 1 2 3 4 { ;
	
		use "DOT_DB1B_Data_ALL_`YR'_`QTR'", clear ; 
		count ;

		drop _merge rpcarrier distance tkcarrierchange opcarrierchange;
		capture drop v35;
		
		* APPLY SCREENS I ;

 			* keep itineraries with at most one stop ;

			gen temp=mktcoupons>2 ;
			bysort itinid: egen drop=max(temp) ;
			drop if drop==1 ;
			drop temp drop ;
			display "Number of Observations After Deleting mktcoupons > 2";
			count; 
		 
			* drop itineraries involving bulk or non-credible fares ;

			gen temp=bulkfare==1|dollarcred==0 ;
			bysort itinid: egen drop=max(temp) ;
			drop if drop==1 ;
			drop temp drop dollarcred bulkfare;
			display "Number of Observations After Deleting bulk and non-credible fares";
			count; 
			
			* drop itineraries involving flights on carriers with missing names or unknown carriers;
			* note that UK carrier won't be in the estimation anyway cause they don't appear in T100 
				but we don't want to account for these when calculating instruments (other carriers) ;

			gen temp=(opcarrier=="--" | opcarrier == "UK"); 
			bysort itinid: egen drop=max(temp) ;
			drop if drop==1 ;
			drop temp drop ;
			display "Number of Observations After Deleting Carriers with Missing Names and Unknown carriers";
			count; 

			* drop itineraries involving flights on foreign carriers ;

			sort opcarrier;
			merge opcarrier using foreign_airlines, nokeep;
			gen temp = (_merge == 3); 
			bysort itinid: egen drop=max(temp) ;
			drop if drop==1 ;
			drop temp drop _merge ;
			display "Number of Observations After Deleting Itins with Foreign Carriers";
			count; 

			*** Note that i'm keeping in observations that involve NYC, CHI and WAS airports => they won't be matched
				in the T100 data, but the fares will be calculated on the non-NYC segments of corresponding itineraries ;

			*** drop itineraries with Southwest flights through DFW ***;

		gen temp = (opcarrier == "WN" & (origin == "DFW" | dest == "DFW"));
		bysort itinid: egen drop = max(temp);
		drop if drop == 1;
		drop temp drop;
		display "Number of observations After Deleting Southwests flight trhough DFW";
		count;

			* airport - states ;

		sort origin;
		merge origin using airport_state, nokeep;
		display "origin airports that do not have states";
		tab origin if _merge == 1;
		drop _merge;
		rename state or_state;

		rename origin x;
		rename dest origin;

		sort origin;
		merge origin using airport_state, nokeep;
		display "dest airports that do not have states";
		tab origin if _merge == 1;
		drop _merge;
		rename state dest_state;
		
		rename origin dest;
		rename x origin;

			* drop itineraries involving trips to overseas territories; 

			gen temp=(	or_state == "PR" | or_state == "TT" | 
					or_state == "VI" | or_state == "GU"  |
					or_state == "AS" | or_state == "FM"  |
					or_state == "MH" | or_state == "MP"  |
					or_state == "PW" | or_state == "AQ" |
					or_state == "NQ" | 

					dest_state == "PR" | dest_state == "TT" | 
					dest_state == "VI" | dest_state == "GU"  |
					dest_state == "AS" | dest_state == "FM"  |
					dest_state == "MH" | dest_state == "MP"  |
					dest_state == "PW" | dest_state == "AQ" |
					dest_state == "NQ" 
			);

			bysort itinid: egen drop=max(temp) ;
			drop if drop==1 ;
			drop temp drop;
			display "Number of Observations After Deleting Itineraries to Overseas Territories"; ;
			count; 


		* identify itineraries to HI and AK ;

			gen temp=(or_state == "AK" | or_state == "HI" | dest_state == "AK" | dest_state == "HI" );
			bysort itinid: egen AK_HI = max(temp) ;
			tab AK_HI ; 
			drop or_state dest_state temp;

			* create class variable;


			replace fareclass="X" if opcarrier=="WN" | opcarrier=="B6" ;	* Convert Southwest and JetBlue fare classes ;

			gen x = (fareclass == "X" | fareclass == "Y");
			egen max_x = min(x), by (itinid);
			gen class = "Coach" if max_x == 1;
			replace class = "First" if class == "";
			drop x max_x;

			* mark ("Jaws") itineraries that are not either one-way or round-trip ;

			gen breaks=break=="X" ;
			bysort itinid: egen totbreaks=sum(breaks) ;
			gen temp=((roundtrip==1 & totbreaks==2) | (roundtrip==0 & totbreaks==1)) ; 
			replace temp=temp==0 ;
			bysort itinid: egen jaw=max(temp) ;
			drop temp breaks totbreaks ;

**** fare restrictions  **********;
 

			sort year quarter;
			merge year quarter using cpi, nokeep;
			drop _merge;

			replace mktfare = mktfare *CPI;
			replace itinfare = itinfare * CPI;

			sort year quarter;
			merge year quarter using sifl, nokeep;
			drop _merge;
			gen SIFL =  termchrg +  miles1 * mktmilesflown;
			replace SIFL =  termchrg+ miles2 * mktmilesflown if mktmilesflown >=501 & mktmilesflown <=1500;
			replace SIFL =  termchrg+ miles3 * mktmilesflown if mktmilesflown >=1501;
			gen x = mktfare/SIFL;

			gen temp=((x < 5 &  mktmilesflown >=500) | (x < 6 &  mktmilesflown <=500)) ; 
			replace temp=temp==0 ;
			bysort itinid: egen sifl_violate=max(temp) ;
			drop temp termchrg - x;
		
			tab sifl_violate;

		* mark itineraries involving roundtrip fares less than $25 (economy class) or $70 (business class);
	
			gen temp = 0;
			replace temp = 1 if itinfare == .;
			replace temp = 1 if temp == 0 & class == "Coach" & itinfare <35;
			replace temp = 1 if temp == 0 & class == "First" & itinfare <75;

			bysort itinid: egen fare_small =max(temp) ;
			drop temp;

			tab fare_small;

/******* distance restrictions                    ****/

			gen temp=((nonstopmiles < 100) | (mktmilesflown > 2*nonstopmiles & nonstopmiles > 1000)) ; 
			bysort itinid: egen dist_violate=max(temp) ;
			drop temp;
		
			tab dist_violate;

		compress;

		* CREATE ITINERARY ;
				
		bysort itinid mktid (seqnum): gen orgdstthroughs=origin[1]+dest[_N]+"." if _N==1 ;
		bysort itinid mktid (seqnum): replace orgdstthroughs=origin[1]+dest[_N]+"."+dest[1] if _N==2 ;
		bysort itinid mktid (seqnum): replace orgdstthroughs=origin[1]+dest[_N]+"."+dest[1]+dest[2] if _N==3 ;
		bysort itinid mktid (seqnum): replace orgdstthroughs=origin[1]+dest[_N]+"."+dest[1]+dest[2]+dest[3] if _N==4 ;
		bysort itinid mktid (seqnum): replace orgdstthroughs=origin[1]+dest[_N]+"."+dest[1]+dest[2]+dest[3]+dest[4] if _N==5 ;
		
		
			* Format Variables ;
			
		format itinid %16.0g ;
		format mktid %16.0g ;

		keep itinid mktid seqnum coupons origin dest opcarrier nonstopmiles break passengers
			fareclass mktcoupons mktfare mktmilesflown roundtrip online itinfare milesflown 
			 orgdstthroughs tkcarrier class year quarter dist_violate sifl_violate fare_small jaw AK_HI;

		compress ;
	
                save "db1b_processed_`YR'_q`QTR'", replace ;
                
	
	
	} ;	* END QTR LOOP ;

} ; 	* END YR LOOP ;

log close;
