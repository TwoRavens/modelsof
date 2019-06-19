/*** CREATES HOUSING-COST INDEX FOR RESTAT FORTHCOMING ARTICLE "WHAT ARE CITIES WORTH" **/
/** NON-FARM, NON-INSTITUTIONAL 
GROSS RENTS USED FOR RENTAL UNITS
CALCULATES AN IMPUTED RENT BASED ON USER-COST COEFFICEINT OF 0.0785 OF HOUSE VALUE + UTILITIES
IMPOSES A FLOOR OF $1 A DAY
*/

# delimit ;

version 13.1 ;
set more off;

clear all ;
set mem 4000m ;
set matsize 2000 ;

/** SET DIRECTORY **/
cd d:\data\restat ;

/** READ IN DATA - LIST OF VARIABLES USED **/

use ipums2000h_wacw_albouy, replace ;

keep year hhwt statefip puma gq farm ownershpd commuse acreprop rentgrs condo condofee 
costelec costgas costwatr costfuel hhincome valueh kitchen rooms plumbing builtyr unitsstr bedrooms fuelheat ;


/** DROP GROUP QUARTERS, FARMS, AND THOSE NOT PAYING CASH RENT */

drop if inlist(gq,3,4) | farm==2 ;
drop if ownershpd==21 ;
drop gq farm ownershpd ;


/**** HOUSEHOLD CHARACTERISTICS ****/

*** UTILITIES ;
/* may need to deal with topcodes eventually */

foreach V of var costelec costgas costwatr costfuel { ;
	replace `V' = 0 if inrange(`V',9990,9999) ;
	} ;

g costutil = costelec + costgas + costwatr + costfuel ;
la var costutil "Total Utility Cost" ;

*** KITCHEN AND PLUMBING  ;

*g byte kitchen_na = kitchen==0 ;
g byte kitchen_own = kitchen==4 ;
drop kitchen ;

la var kitchen_own "Kitchen in unit" ;
*g byte plumb_na = plumbing== 0 ;
g byte plumb_comp = plumbing==20 ;
la var plumb_comp "Complete plumbing" ;
drop plumbing ;

**** ROOMS AND BEDROOMS ;
/** deal with zero room and no more than 9 rooms 1960-2007) */

*g room_na =  rooms==0 ;
replace rooms = . if rooms==0 ;

replace rooms = 9 if inrange(rooms,9,28) ;
tab rooms, g(room_) ;

for N in num 2(1)8: la var room_N "N rooms" ;
la var room_1 "1 room" ;
la var room_9 "9+ rooms" ;

*drop room_0 ;

/*** DEAL WITH NUMBER OF ROOMS ***/
*g bedroom_na = bedrooms==0 ;
g bedroom_0 = bedrooms==1 ;
replace bedrooms= . if inlist(bedrooms,0,1) ;
replace bedrooms = 6 if inrange(bedrooms,6,22) ; 
tab bedrooms, g(bedroom_) ;

la var bedroom_0 "no bedroom" ;
la var bedroom_1 "1 bedroom" ;
la var bedroom_5 "5+ bedrooms" ;
for N in num 2(1)4: la var bedroom_N "N bedrooms" ;

g room_int = rooms*(bedrooms -1)  ;
replace room_int = 0 if (rooms==.) | (bedrooms==.) ; 

la var room_int "Rooms and bedrooms interacted" ;

drop rooms bedrooms  ;

/** COMMERICAL USE - could drop */

*recode commus 2=1 *=0 ;  
g comm_no = commus==1 ;
g comm_yes = commus==2 ;

la var comm_no "Commercial use: no" ;
la var comm_yes "Commercial use: yes" ;

drop commus ;

**** YEAR BUILT & UNITS in STRUCTURE ;

replace builtyr =7 if inlist(builtyr,8,9) ;
*replace builtyr =. if builtyr==0;


*g byte built_na = builtyr==0 ;
g byte built1 = builtyr==1 ;
g byte built5 = builtyr==2 ;
g byte built10 = builtyr==3 ;
g byte built20 = builtyr==4 ;
g byte built30 = builtyr==5 ;
g byte built40 = builtyr==6 ;
g byte built50 = builtyr==7 ;
g byte built60 = builtyr==8 ;
g byte built70 = builtyr==9 ;

la var built1 "0-1 year old" ;
la var built5 "2-5 years old" ;
la var built10 "6-10 years old" ;
la var built20 "11-20 years old" ;
la var built30 "21-30 years old" ;
la var built40 "31-40 years old" ;
la var built50 "41-50 years old" ;
la var built60 "51-60 years old" ;
la var built70 "61+ years old" ;


drop builtyr ;


/** Default single, family detached */ 
g byte sz_mob = unitsstr==1;
g byte sz_btrv = unitsstr==2 ;
g byte sz_att = unitsstr ==4 ;
g byte sz_ap2 = unitsstr==5;
g byte sz_ap3 = unitsstr==6;
g byte sz_ap5 = unitsstr==7;
g byte sz_ap10 = unitsstr==8 ;
g byte sz_ap20 = unitsstr==9 ;
g byte sz_ap50 = unitsstr==10 ;

la var sz_mob "Mobile home or trailer" ;
la var sz_btrv "Boat, tent, van, other" ;
la var sz_att "1-family house, attached" ;
la var sz_ap2 "2-family building" ;
la var sz_ap3 "3-4 family building" ;
la var sz_ap5 "5-9 family building" ;
la var sz_ap10 "10-19 family building" ;
la var sz_ap20 "20-49 family building" ;
la var sz_ap50 "50+ family building" ;

drop unitsstr ;

*** CONDOMINIMIUM ;
g byte condo_na = condo==0 ;
g byte condo_yes = condo==2 ;

drop condo ;

**** ACREAGE ;

*replace acrep=. if acrep==0 ;

g byte acre0= inlist(acreprop,1,2);
g byte acre19= inlist(acrep,7);
g byte acre10= acrep==8;
*g byte acre_na = acrep==0 ;

la var acre0 "City or suburban lot, rural <1 acre" ;
la var acre19 "rural 1-9 acres" ;
la var acre10 "rural 10+ acres" ;

drop acrep ;

********** FUELHEAT ;

*g byte fuel_no = inlist(fuelheat,0) ;
g byte fuel_gaspi = inlist(fuelheat,1) ;
g byte fuel_gasta = inlist(fuelheat,2) ;
g byte fuel_elec = inlist(fuelheat,3) ;
g byte fuel_oil = inlist(fuelheat,4) ;
g byte fuel_coal = inlist(fuelheat,5) ;
g byte fuel_wood = inlist(fuelheat,6) ;
g byte fuel_sol = inlist(fuelheat,7) ;
g byte fuel_oth = inlist(fuelheat,8) ;

drop fuelheat ;

la var fuel_gaspi "Heating fuel: gas from pipes" ;
la var fuel_gasta "Heating fuel: bottled, tank, or LP gas" ;
la var fuel_elec "Heating fuel: electricity" ;
la var fuel_oil "Heating fuel: fuel oil, kerosene, other liquid" ;
la var fuel_coal "Heating fuel: coal or coke" ;
la var fuel_wood "Heating fuel: wood " ;
la var fuel_sol "Heating fuel: solar" ;
la var fuel_oth "Heating fuel: other" ;

/**** GEOGRAPHY ****/
/*** CREATE MULTIPLE OBSERVATIONS WHEN PUMA IS SPLIT ACROSS CMSAS ***/

joinby statefip puma using match_puma2000_pmsa99 ;
g oldhhwt = hhwt ;
g afact = pop/pumapop ;
replace hhwt = hhwt*afact ;
drop pop pumapop ;
drop if afact==0 ;

la var afact "Fraction of household assigned to area" ;
la var oldhhwt "Original household weight = householdweight/afact" ;

* TOP-CODING OF HOUSING VALUES ;

replace valueh = 9000 if valueh==5000  ;
replace valueh = 1250000 if valueh==1000000  ;

replace valueh=. if valueh==9999999 ;

* GROSS RENT ;

/** ANNUALIZE RENT & PUT USER COST OF HOUSING WITH UTILITIES ***/

replace rentgrs = . if rentgrs==0 ;
replace rentgrs = rentgrs*12 ;

/* 0.0785 number From Peiser and Smith. Only matters for how utilities are averaged in**/

g housecost = value*0.0785 + costutil + condofee  ;

g renter = inrange(rentgrs,500,100000000) ;
g owner  = inrange(housecost,500,100000000) ; 

la var renter "Tenure: renter" ;
la var owner "Tenure: owner" ;

* TOP-CODING OF HOUSING VALUES ;

replace valueh=. if valueh==9999999 ;
replace valueh = 5000 if inrange(valueh,0,5000) ;

g price = rentgrs if renter ;
replace price = housecost if owner ;

la var price "Housing cost" ;

/** IMPOSE MINIMUM PRICE OF 360 ($1 dollar a day) **/
replace price = 360 if inrange(rentgrs,0,360) ;

g lprice = log(price) ;

la var lprice "Log housing cost" ;

keep if renter | owner ;
  
order year statefip puma cmsa pmsa afact hhwt oldhhwt ;
compress ;

 
 /*** INTERACT EVERYTHING EXCEPT CONDO WITH TENURE STATUS **/

for V in var room_* sz* acre* built* plumb* kitch* comm*  :
	g rent_V = renter*V ;

keep lprice room_* sz* acre* built* plumb* kitch* comm* condo* hhwt renter rent_* cmsa  statefip ;
drop room_1 acre10 built1 comm_no condofee condo_na ;

/* 
1 No covariates except for tenure : "p_raw"
2 All covariates, renters & owners: "p"
3 All covariates with predicted-income weight : "p_wt"
4 All covariates for owner-occupied units : "p_own" 
5 All covariates for rental units: "p_ren" 
*/

local controls = "room_* sz* acre* built* plumb* kitch* comm* condo*" ;


/*** RAW PRICE DIFFERENCES **/

areg lprice renter [aw=hhwt], a(cmsa)  ;
predict p_raw, d ;

/*** ESTIMATE PREDICETED HOUSING VALUES USING OWNED UNITS 0NLY **/

areg lprice `controls' [aw=hhwt] if renter==0 , a(cmsa)  ;
predict xb ;

/*** SEPARATE INDICES FOR OWNERS AND RENTERS ***/

predict p_own, d ;
replace p_own=. if renter==1 ;

areg lprice `controls'  [aw=hhwt] if renter==1 , a(cmsa)  ;
predict p_ren, d ;
replace p_ren=. if renter==0 ;

/** INDEX FOR ALL UNITS **/

areg lprice `controls' renter rent_* [aw=hhwt], a(cmsa)  ;
predict p, d ;

/**** WEIGHTED INDEX USING ALL UNITS WITH WEIGHTS BASED ON PREDICTED HOUSING VALUE ***/
/** Regress residuals on city dummies with weights **/

predict lprice_r, dresid ;

g pricewt = exp(xb) ;
g totwt = hhwt*pricewt ;

areg lprice_r  [aw=totwt], a(cmsa)  ;
predict p_wt, d ;


/********* COLLASPSE RESIDUALS BY CMSA *****/

collapse (mean) p_raw p p_wt p_own p_ren  pricewt
		 	 (count) p_n=p [aw=hhwt], by(cmsa) fast ;

rename p_n num_p ;

la var p "Mean House Price/Rent Adj Diff";
la var p_raw "Mean House Price/Rent Raw Diff";
la var p_wt "Weighted Mean House Price/Rent Adj Diff";
la var p_ren "Mean Rent Differential" ;
la var p_own "Mean Housing-Price Differential" ;
la var num_p "Number of Properties";
la var pricewt "Average Price Weight";


sort cmsa ;

save p_cmsa99_2000_wacw_albouy, replace ;

