#delim ;
clear ;
set mem 3g ;
set more off ;

cd "../Data";

*************************************************************************************
                        Purpose: Create file with Instruments
************************************************************************************* ;

cap log close;
log using instruments.log, replace;

tempfile temp ;

foreach YR in 1997 1998 2000 2001 2003 2007 {;

        foreach QTR in 1 2 3 4 { ;
        
                use "db1b_complete_`YR'_q`QTR'", clear ; 
                count;

                save `temp', replace;

        *** instrum 1 - number of airline's itineraries that include the segment. **;

                keep year quarter opcarrier origin dest orgdst;
                duplicates drop;
                gen x = 1;

                collapse (sum) instrum1=x, by (year quarter opcarrier origin dest);


                sort year quarter opcarrier origin dest;

                save `temp'ins1, replace;


        *** instrum 2 - average population of the endpoint cities across all airline's itineraries that include the segment **;

                **** bring the data on demog *****;
 
                use arpcode msa using airpAllan, clear;
                replace msa = 0 if msa == -1;
                expand 11;
                bysort msa arpcode: gen year = 1996+_n;
                sort year msa;
                compress;
                save `temp'ash, replace;

                use demog, clear;
                sort year msa;

                merge year msa using `temp'ash, nokeep;
                tab _merge;
                keep if _merge == 3;

                keep msa year population arpcode;
                sort year arpcode;
                compress;
                save `temp'ashDemog, replace;

                keep if arpcode == "LGA" | arpcode == "JFK" | arpcode == "EWR"
                        | arpcode == "MDW" | arpcode == "ORD"
                        | arpcode == "DCA" | arpcode == "IAD" | arpcode == "BWI";

                replace arpcode = "NYC" if arpcode == "LGA" | arpcode == "JFK" | arpcode == "EWR";
                replace arpcode = "CHI" if arpcode == "MDW" | arpcode == "ORD";
                replace arpcode = "WAS" if arpcode == "DCA" | arpcode == "IAD" | arpcode == "BWI";

                replace population = log(population);
                
                collapse (sum) population (count) n=population, by(year arpcode);
                replace population = (exp(population))^(1/n);
                drop n;
                save `temp'trD, replace;

                use `temp'ashDemog, clear;
                append using `temp'trD;
                sort year arpcode;
                save `temp'ashDemog, replace;

                keep msa year population;
                duplicates drop;
                collapse (mean) population, by(year);
                rename population popAv;
                sort year;
                compress;
                save `temp'ashDemog1, replace;

                use orgdst year quarter origin dest opcarrier using `temp', clear;
                duplicates drop;
                gen arpcode = substr(orgdst,1,3);

                sort year arpcode;
                merge year arpcode using `temp'ashDemog, nokeep;
                drop _merge arpcode msa;
                compress;

                sort year;
                merge year using `temp'ashDemog1, nokeep;
                drop _merge;

                replace popAv = population if population != .;
                rename popAv Origin_Pop;
                drop population;


                gen arpcode = substr(orgdst,4,3);

                sort year arpcode;
                merge year arpcode using `temp'ashDemog, nokeep;
                drop _merge arpcode;
                compress;

                sort year;
                merge year using `temp'ashDemog1, nokeep;
                drop _merge;

                replace popAv = population if population != .;
                rename popAv Dest_Pop;
                drop population;
                
                gen pop_geom_mean = sqrt(Origin_Pop * Dest_Pop);

                collapse (sum) instrum2=pop_geom, by (year quarter opcarrier origin dest);

                sort year quarter opcarrier origin dest;

                save `temp'ins2, replace;


        *** instrum 4 - Percentage of airline passengers on a segment traveling on direct route. **;

                use year quarter opcarrier origin dest orgdst passengers using `temp', clear;
                gen direct = (length(orgdst)==7);

                collapse (sum) passengers, by (year quarter opcarrier origin dest direct);
                sort year quarter opcarrier origin dest;
                save `temp'1, replace;

                collapse (sum) total=passengers, by (year quarter opcarrier origin dest);
                sort year quarter opcarrier origin dest;
                save `temp'2, replace;

                use `temp'1 if direct == 1, clear;
                sort year quarter opcarrier origin dest ;
                merge year quarter opcarrier origin dest using `temp'2, nokeep;

                gen instrum4 = passengers / total;
                drop _merge direct passengers total;
                sort year quarter opcarrier origin dest;

                save `temp'ins4, replace;

        *** instruments 10/11 - number of cities to which a carrier flies nonstop flights from the origin/destination airport  ***;

                use year quarter orgdst opcarrier using `temp' if length(orgdst)==7, clear;
                duplicates drop;
                gen arpcode = substr(orgdst,1,3);
                gen x = 1;
                collapse (sum) nr_arps = x, by (year quarter arpcode opcarrier);
                save `temp'ins10, replace;

        *** instrument 12/13 - Percentage of passengers on a given segment that transfer at the hub. ***;

                use year quarter orgdst opcarrier origin dest passengers using `temp', clear;
                gen arpcode = substr(orgdst,8,3);
                sort year quarter opcarrier arpcode;
                merge year quarter opcarrier arpcode using hub, nokeep keep(year quarter opcarrier arpcode);
                gen hub = (_merge == 3 & arpcode != "");
                drop arpcode _merge;


                gen arpcode = substr(orgdst,11,3);
                sort year quarter opcarrier arpcode;
                merge year quarter opcarrier arpcode using hub, nokeep keep(year quarter opcarrier arpcode);
                replace hub = 1 if _merge == 3 & arpcode != "";
                drop arpcode _merge;

                collapse (sum) hub_passengers = passengers, by (year quarter opcarrier origin dest hub);
                sort year quarter opcarrier origin dest;
                 save `temp'i12a, replace;

                collapse (sum) total_segment_pass = hub_passengers, by (year quarter opcarrier origin dest);
                sort year quarter opcarrier origin dest;
                save `temp'i12b, replace;

                use `temp'i12a if hub==1, clear;
                drop hub;
                save, replace;

        *** Instrument 14 - The fraction of the airline's itineraries from the origin airport that are direct ***************;
        *** Instrument 16 - The fraction of the airline's itineraries from the destination airport that are direct ***************;

                use year quarter orgdst opcarrier using `temp', clear;
                duplicates drop;
                gen arpcode = substr(orgdst,1,3);
                gen direct = (length(orgdst)==7);
                gen x = 1;
                collapse (sum) nr_direct_itins = x, by (year quarter arpcode opcarrier direct);
                sort year quarter arpcode opcarrier ;
                save `temp'1, replace;

                collapse (sum) total_itins = nr_direct_itins, by(year quarter arpcode opcarrier);
                sort year quarter arpcode opcarrier ;
                save `temp'2, replace;

                use `temp'1 if direct == 1, clear;
                drop direct;
                sort year quarter arpcode opcarrier;
                merge year quarter arpcode opcarrier using `temp'2, nokeep;
                drop _m;

                gen perc_direct_itin = nr_direct_itins / total_itins;
                sort year quarter arpcode opcarrier;

                save `temp'ins14, replace;
                
********************************************************************************************;
        
        ****  merge instruments ******************************************************************;
                
********************************************************************************************;

                use  `temp'ins1, clear; 
                sort year quarter opcarrier origin dest ;
                merge year quarter opcarrier origin dest using `temp'ins2 `temp'ins4 `temp'i12a `temp'i12b;
                drop _merge*;
                replace instrum4 = 0 if instrum4 == .;
                replace hub_passengers = 0 if hub_passengers == .;
                gen instrum12 = hub_passengers / total_segment_pass;
                save `temp'ins12, replace;

                save `temp'_instruments1_`YR'_q`QTR', replace; 

                use `temp'ins10, clear;
                sort year quarter arpcode opcarrier;
                merge year quarter arpcode opcarrier using `temp'ins14;
                drop _merge;
                save `temp'_instruments2_`YR'_q`QTR', replace;

        };

};

foreach name in instruments1 instruments2 {;

        use `temp'_`name'_1997_q1, clear;
        saveold `name', replace;

        forval YR=1997(1)1997        { ;

                foreach QTR in 2 3 4 { ;

                        use `temp'_`name'_`YR'_q`QTR', clear;
                        append using `name';
                        saveold `name', replace;

                };
        };

        foreach YR in 1998 2000 2001 2003 2007 {;

                foreach QTR in 1 2 3 4 { ;
        
                                use `temp'_`name'_`YR'_q`QTR', clear;
                                append using `name';
                                saveold `name', replace;
                };
        };

};


use instruments1, clear;
sort year quarter origin dest opcarrier;
save, replace;

use instruments2, clear;
sort year quarter arpcode opcarrier;
save, replace;

log close;
