#delim ;
clear ;
set mem 3g ;
set more off ;

cd "../Data";

*************************************************************************************
                        Purpose: Create file with Fares
************************************************************************************* ;

tempfile temp ;

cap log close;
log using od_fare.log, replace;

insheet using mkt_op_mapping.csv, clear ;
rename v1 mktcar_opcar ;
rename v2 opcarrier2 ;
sort mktcar_opcar ;
save `temp'_mkt_op_mapping, replace ;

foreach code in "oooo" "rprp" "9l_9l" { ;
        insheet using `code'_mapping.csv, clear ;
        rename v1 mktcar_opcar ;
        rename v2 org_dest ;
        rename v3 opcarrier3 ;
        sort mktcar_opcar org_dest ;
        save `temp'_`code'_mapping, replace ;
};


foreach YR in 1997 1998 2000 2001 2003 2007 {;

        foreach QTR in 1 2 3 4 { ;
        
                use "db1b_processed_`YR'_q`QTR'", clear ; 
                count;
#delimit;
           replace opcarrier = "AA" if opcarrier == "TW" & (year >= 2002 | (year == 2001 & quarter >= 2));
           replace tkcarrier = "AA" if tkcarrier == "TW" & (year >= 2002 | (year == 2001 & quarter >= 2));

           replace opcarrier = "US" if opcarrier == "HP" & (year >= 2006 | (year == 2005 & quarter >= 4));
           replace tkcarrier = "US" if tkcarrier == "HP" & (year >= 2006 | (year == 2005 & quarter >= 4));
        

/**** Allocate fare to each leg ********/

sort origin dest;
merge origin dest using DistNS, nokeep;
display "Number of Observations with non-matched Distances";
count if _merge == 1;
drop _merge;


egen ttl_dist = sum(distance), by(year quarter itinid mktid);
gen Fare = mktfare * distance / ttl_dist; 

gen fare_violate = (sifl_violate == 1 | fare_small == 1);

drop fareclass mktfare mktmilesflown nonstopmiles roundtrip online milesflown distance ttl_dist
                sifl_violate fare_small;
compress;
saveold "db1b_complete_`YR'_q`QTR'", replace;


*** create market share and type of market variables   ******;

gen mktcar_opcar=tkcarrier+opcarrier ;
sort mktcar_opcar ;

merge mktcar_opcar using `temp'_mkt_op_mapping, uniqusing nokeep;
drop _merge ;
gen org_dest=origin+dest ;
sort mktcar_opcar org_dest ;
        
foreach code in "oooo" "rprp" "9l_9l" { ;
        merge mktcar_opcar org_dest using `temp'_`code'_mapping, uniqusing nokeep;
        replace opcarrier2=opcarrier3 if opcarrier2=="XX" & _merge==3 ;
        drop _merge opcarrier3 ;
        sort mktcar_opcar org_dest ;
                } ;

display "Mkt/Op Car combinations with Missing OpCarrier 2";
tab mktcar_opcar if opcarrier2 == "";

drop org_dest;

save `temp', replace;

contract itinid mktid opcarrier2; 
drop _freq ;

bysort itinid mktid: gen count=_N ;
bysort itinid mktid: gen opcarrier_seq=opcarrier2[1] if count==1 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2] if count==2 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3] if count==3 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4] if count==4 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4]+opcarrier2[5] if count==5 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4]+opcarrier2[5]+opcarrier2[6]  if count==6 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4]+opcarrier2[5]+opcarrier2[6]+opcarrier2[7] if count==7 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4]+opcarrier2[5]+opcarrier2[6]+opcarrier2[7]+opcarrier2[8] if count==8 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4]+opcarrier2[5]+opcarrier2[6]+opcarrier2[7]+opcarrier2[8]+opcarrier2[9] if count==9 ;
bysort itinid mktid: replace opcarrier_seq=opcarrier2[1]+opcarrier2[2]+opcarrier2[3]+opcarrier2[4]+opcarrier2[5]+opcarrier2[6]+opcarrier2[7]+opcarrier2[8]+opcarrier2[9]+opcarrier2[10] if count==10 ;
drop count ;

replace opcarrier_seq="INTERLINE" if length(opcarrier_seq)>2;

compress;

contract itinid mktid opcarrier_seq ;
drop _freq ;
sort itinid mktid;
save `temp'1, replace ;
                
use `temp', clear ;
sort itinid mktid;
merge itinid mktid using `temp'1, nokeep ;
tab _merge ;
drop _merge ;
                
drop opcarrier2 mktcar_opcar;
rename opcarrier_seq opcarrier2;
gen market = substr(orgdst,1,6);

saveold "db1b_complete_`YR'_q`QTR'", replace;

********************************************************************;

keep if break == "X";

egen NPtotal = sum ( passengers), by (market year quarter);
egen NPcar = sum ( passengers), by ( market opcarrier2 year quarter);

gen mktshare = NPcar/NPtotal;
label var mktshare "market share of airline in terms of #passengers";

keep market opcarrier2 mktshare year quarter;
duplicates drop;
sort year quarter market opcarrier2 mktshare;
egen rk = rank(mktshare), unique by(market  year quarter);
sort year quarter market rk;
gen monopoly = 1 if mktshare > 0.9;
bysort  year quarter market: replace monopoly = 1 if monopoly[_N]==1;
replace monopoly = 0 if monopoly == .;
label var monopoly "a dummy for monopoly";
sort year quarter market rk;
bysort   year quarter market: gen duoph = mktshare[_N] + mktshare[_N-1] if monopoly == 0;
bysort  year quarter market: gen duoph1 = 1 if duoph >= 0.8 & mktshare[_N-2]<0.1 & monopoly == 0;
gen duopoly = 1 if (duoph >= 0.9 & duoph != .) | duoph1 == 1;
replace duopoly = 0 if duopoly ==.;
label var duopoly "dummy for duopoly markets";
gen compete = 1 - duopoly - monopoly;
label var compete "dummy for competitive markets";

keep  year quarter market monopoly duopoly compete;
duplicates drop;
sort  year quarter market;
save `temp'mkt_ash, replace;

use "db1b_complete_`YR'_q`QTR'", clear;
sort  year quarter market;
merge year quarter market using `temp'mkt_ash;
drop _merge;
saveold "db1b_complete_`YR'_q`QTR'", replace;

**** Find Origin Airport for each itinerary **********;

keep if seqnum == 1;
keep itinid origin;
rename origin OrigApt;
sort itinid;
save `temp'1, replace;

use "db1b_complete_`YR'_q`QTR'", clear;
sort itinid;
merge itinid using `temp'1;
drop _merge;
compress;
saveold "db1b_complete_`YR'_q`QTR'", replace;

********************************************************************;
********************************************************************;
********************************************************************;

gen class1 = (class == "First");

keep year quarter origin dest opcarrier Fare passengers class1 
                fare_violate dist_violate jaw AK_HI;

gen fare_pass = Fare * passengers;

display "# observations with missing Class";
count  if class1 == .;
display "# observations with missing fare_violate";
count  if fare_violate  == .;
display "# observations with missing dist_violate";
count  if dist_violate == .;
display "# observations with missing jaw";
count  if jaw == .;
display "# observations with missing AK_HI";
count  if AK_HI == .;

save `temp'help, replace;

                use `temp'help
                        if class1 <= 0 & fare_violate <= 0 & dist_violate <= 0 & jaw <= 0 & AK_HI <= 0
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_0_0_0_0_0_`YR'_q`QTR', replace;

                use `temp'help 
                        if class1 <= 1 & fare_violate <= 0 & dist_violate <= 0 & jaw <= 0 & AK_HI <= 0
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_0_0_0_0_`YR'_q`QTR', replace;

                use `temp'help
                        if class1 <= 1 & fare_violate <= 0 & dist_violate <= 0 & jaw <= 1 & AK_HI <= 0
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_0_0_1_0_`YR'_q`QTR', replace;

                use `temp'help
                        if class1 <= 1 & fare_violate <= 0 & dist_violate <= 0 & jaw <= 0 & AK_HI <= 1
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_0_0_0_1_`YR'_q`QTR', replace;

                use `temp'help
                        if class1 <= 1 & fare_violate <= 1 & dist_violate <= 1 & jaw <= 1 & AK_HI <= 1
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_1_1_1_1_`YR'_q`QTR', replace;

                use `temp'help
                        if class1 <= 1 & fare_violate <= 0 & dist_violate <= 1 & jaw <= 0 & AK_HI <= 0
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_0_1_0_0_`YR'_q`QTR', replace;

                use `temp'help
                        if class1 <= 1 & fare_violate <= 1 & dist_violate <= 0 & jaw <= 0 & AK_HI <= 0
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_1_0_0_0_`YR'_q`QTR', replace;

                use `temp'help
                        if class1 <= 1 & fare_violate <= 1 & dist_violate <= 1 & jaw <= 0 & AK_HI <= 1
                        , clear;
                save `temp'1, replace;
                collapse (mean) Fare [pw=passengers], by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                save `temp'2, replace;
                use `temp'1, clear;
                collapse (sum) passengers, by(year quarter origin dest opcarrier);
                sort year quarter origin dest opcarrier;
                merge year quarter origin dest opcarrier using `temp'2;
                drop _merge;
                compress;
                save `temp'_Fare_1_1_1_0_1_`YR'_q`QTR', replace;


**** calculate weights *****;

use  year quarter origin dest passengers opcarrier OrigApt  monopoly duopoly compete fare_violate
                using "db1b_complete_`YR'_q`QTR'" if fare_violate <= 1, clear;

collapse (sum) passengers, by(year quarter origin dest opcarrier OrigApt monopoly duopoly compete) ;

compress;
save `temp'_weights_1_`YR'_q`QTR', replace;;

use  year quarter origin dest passengers opcarrier OrigApt  monopoly duopoly compete fare_violate
                using "db1b_complete_`YR'_q`QTR'" if fare_violate <= 0 , clear;

collapse (sum) passengers, by(year quarter origin dest opcarrier OrigApt monopoly duopoly compete) ;

compress;
save `temp'_weights_0_`YR'_q`QTR', replace;;


        } ;        * END QTR LOOP ;

} ;         * END YR LOOP ;


*******************************************************************;
*******************************************************************;
*******************************************************************;


foreach name in Fare_0_0_0_0_0 Fare_1_0_0_0_0  Fare_1_0_0_1_0  Fare_1_0_0_0_1 Fare_1_1_1_1_1 
                Fare_1_0_1_0_0 Fare_1_1_0_0_0  Fare_1_1_1_0_1  
                weights_1 weights_0 {;

        use `temp'_`name'_1997_q1, clear;
        saveold `name', replace;

        forval YR=1997(1)1997        { ;

                foreach QTR in 2 3 4 { ;

                        use `temp'_`name'_`YR'_q`QTR', clear;
                        append using `name';
                        saveold `name', replace;

                };
        };

        foreach YR in 1998 2000 2001 2003 2007 { ;

                foreach QTR in 1 2 3 4 { ;
        
                                use `temp'_`name'_`YR'_q`QTR', clear;
                                append using `name';
                                saveold `name', replace;
                };
        };

};

log close;
