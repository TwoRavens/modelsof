/**********************************************
trip_trip_vmt_95_mmdd.do

By Victor Couture, Fall 2009

Calculate vehicle miles and time traveled by POV, 
per msa, from the trip file, for 1995.
**********************************************/
*set up;
#delimit;
clear all;

set memory 500m;
set more 1;
quietly capture log close;
*log using trip_trip_vmt_95_mmdd, text replace;
* specify locations of data sets;


global npts1995		"D:\S_congestion\data_processing\data\npts1995" ;
global npts2001		"D:\S_congestion\data_processing\data\npts2001" ;
global npts2009		"D:\S_congestion\data_processing\data\npts2001" ;
global county2pmsa	"D:\S_congestion\data_processing\data\county2pmsa\county2pmsa_GD";
global sprawl_4VC 	"D:\S_congestion\data_processing\data\sprawl_4VC";
cd D:\S_congestion\data_processing\data_generated;
*****************************************************************************;

use  $npts1995/tday.dta,clear;

keep  		 trptrans houseid personid trpmiles tday_mon travday travwknd trpnum trvl_min 
                   proxy howfaru prevrep whyto whyfrom  whytrp95 whytrp90 strttime whodrove drvr_flg worker wttrdfin r_age r_sex;

* generate person weights from trip weights;
gen wtperfin = wttrdfin/365;

compress;

save temp, replace;

*************************************************************************************;
*I want to add an observation from the person file for each individual who does not travel, because I compute vmt and vtime 
*based by scaling up sample averages by population count;
*************************************************************************************;

use  $npts1995\perd.dta,clear;

keep houseid personid wtperfin;

merge 1:m houseid personid using temp;
drop _merge;


*************************************************************************************;
*define, redefine some variables;
*************************************************************************************;

* transform some variables into a dummy, for regression purposes;
destring whytrp90, replace;
destring r_sex, replace;
replace r_sex = 0 if r_sex == 2;
destring worker, replace;
replace worker = 0 if worker == 2;
destring travwknd, replace;
replace travwknd = 0 if travwknd == 2;

*rename a variable to match definitin in 2001;

rename travwknd tdwknd;

* generate dummies for month of travel day;

tabulate tday_mon, gen(month_);

*create dummy for each trip purpose;
*First consolitade last 2 categories (11 = other, 98 = not ascertained, );

replace whytrp90 = 11 if whytrp90 == 98;

tabulate whytrp90, gen(purpose);

* Note that we generate only 10 dummies, because
  somehow trip purpose code go from 1 to 11, but
  without a code 9...;

* generate a person id;

   gen long pid = houseid*10 + personid; 
   sort pid;




*gen a dummy for trips during peak hours;

destring strttime, replace;

gen peak = 0;
replace peak = 1 if (((strttime >= 0600  & strttime < 1000) | (strttime >= 1500 & strttime < 1900)) & tdwknd == 0);


*********************************************************************************
*Prepare for merger later with msa information by adding info from the household file
*********************************************************************************;

sort houseid;

compress;
save temp,replace;

* get 1995 household information, from 1995 hh file;

use $npts1995/hhdo,clear;

keep houseid hhfaminc ref_educ hh_hisp hh_race hhsize hhstate hhstfips hhcounty urban;

compress;

* create a dummy for trips by indiduals in urban areas;
* In 1995 the variable urban is only in HH file;

gen urb = 0;
replace urb = 1 if urban == "01";

*make 5 digit county fips;

gen county = hhstfips *1000 +real(hhcounty);
  drop hhstfips hhcounty;

*simplify race info, put white, other and asian in the same category (white/other) so that merge with 2001 works better;

*gen race = .;
gen race = 1;
  replace race = cond(hh_hisp=="01",3,race);
  replace race = cond(hh_race=="02",2,race);
  replace race = cond(hh_race=="01" | hh_race=="03" | hh_race =="04" ,1,race);

label define race_name 1 "white/other" 2 "black" 3 "hispanic";		
label values race race_name;

tab race, missing;
 drop hh_race hh_hisp;


* Clean up income variable. Note that codes for 1995 and 2001 are the same except for missings
 ignore changes in price level over six years.;


gen hh_income = cond(hhfaminc==""|hhfaminc== "98" |hhfaminc== "99" ,.,real(hhfaminc)); 
  drop hhfaminc;
   label var hh_income "family income";
   tab hh_income, missing;
   
*Now let's replace the income category variable by it's mean monetary value;
  replace hh_income = cond(hh_income==1	    ,2500	,hh_income);
  replace hh_income = cond(hh_income==2 	,7500 	,hh_income);
  replace hh_income = cond(hh_income==3 	,12500 	,hh_income);
  replace hh_income = cond(hh_income==4 	,17500 	,hh_income);
  replace hh_income = cond(hh_income==5 	,22500 	,hh_income);
  replace hh_income = cond(hh_income==6 	,27500 	,hh_income);
  replace hh_income = cond(hh_income==7 	,32500 	,hh_income);
  replace hh_income = cond(hh_income==8	    ,37500	,hh_income);
  replace hh_income = cond(hh_income==9 	,42500 	,hh_income);
  replace hh_income = cond(hh_income==10 	,47500 	,hh_income);
  replace hh_income = cond(hh_income==11 	,52500 	,hh_income);
  replace hh_income = cond(hh_income==12 	,57500 	,hh_income);
  replace hh_income = cond(hh_income==13 	,62500 	,hh_income);
  replace hh_income = cond(hh_income==14 	,67500 	,hh_income);
  replace hh_income = cond(hh_income==15	,72500	,hh_income);
  replace hh_income = cond(hh_income==16 	,77500 	,hh_income);
  replace hh_income = cond(hh_income==17 	,90000 	,hh_income);
  replace hh_income = cond(hh_income==18 	,150000 ,hh_income);
   
   
   gen l_hh_income = ln(hh_income);
   tab hh_income, missing;
   
*As an alternative way to eventually control for income, generate dummies for each income category;
tabulate hh_income, gen(hh_income_);

* Clean up education variable. The number of categories is smallest in 2009, so I aggregate the 1995 and 2001 variable
to the 5 categories of 2009;
  
* We change code 98 and 99 to missing;

gen hh_education = cond(ref_educ == "98" |ref_educ == "99" ,.,real(ref_educ)); 
  replace hh_education = cond(hh_education==11	,1	,hh_education);
  replace hh_education = cond(hh_education==12 	,2 	,hh_education);
  replace hh_education = cond(hh_education==21 	,3 	,hh_education);
  replace hh_education = cond(hh_education==22 	,3 	,hh_education);
  replace hh_education = cond(hh_education==24 	,4 	,hh_education);
  replace hh_education = cond(hh_education==25 	,4 	,hh_education);
  replace hh_education = cond(hh_education==26 	,5 	,hh_education);
     drop ref_educ;

label define education 	1 "Less than highschool" 
			2 "Highschool or GED"
			3 "Some college or assiociate deg. (vocational)"
			4 "Bachelor's degree "
			5 "Graduate or professional Degree ";

label values hh_education education;
label var hh_education "respondent education";
tab hh_education;

* generate dummies for each education level;
tabulate hh_education, gen(hh_education_);

*merge the household information with the trip file;

sort houseid;
merge houseid using temp;
  tab _merge;
  drop if _merge==1;
  drop _merge;


*match households to msa's;

sort county;
merge county using $county2pmsa;
tab _merge;

*Note that _merge==1 ==> AK or HI and _merge==2 ==> county with no respondent, mostly non-msa counties;

keep if _merge==3;
   drop  land_ha water_ha _merge county county_name pop1990 pop2000 _merge;
   *order  msa msa_name houseid hhstate   race hhsize  hh_income hh_education;
   drop if msa==.;

sort msa;
save temp,replace;

************************************************************************************;
* add population data from congestion_gd
************************************************************************************;
use $sprawl_4VC/congestion_vc,clear;

keep msa ann_pop95 ann_pop96;

*Given that the data were collected for 1995 and 1996 (about 1/2 and 1/2)
 I use an average of both years population in my calculation;
 
gen ann_pop9596 = (ann_pop95 + ann_pop96)/2;

sort msa;
merge msa using temp;

tab _merge;

keep if _merge==3;

drop _merge;

* the above only dropped one observation for msa 9999 in the congestion_gd data set;


*********************************************************************************
*Now I generate a few variables that give us an idea of sample size for each msa
*********************************************************************************;

* The next commands generate the total number of trips  by POV (1) car, 2) van, 
*3) SUV, 4) Pick-Up) in an MSA, entered by the driver;
* Perhaps I should include: other trucks (05), motorcycle (07), taxicab (15);

gen dpov = 0;
   replace dpov = 1 if (trptrans == "01"| trptrans == "02"| trptrans == "03"| trptrans ==  "04") & drvr_flg == "01";

by msa, sort: egen dpov_trips_msa = sum(dpov);
      
* The next commands generates the total number of trips (the number of
  of observation in the sample per msa);

gen dummy = 1;
*by msa, sort: egen total_trips_msa = sum(dummy);

* The next commands generate the number of person in the
  sample per msa (I create a variable (x3) that add up to one for each person);

by pid, sort: egen x2 = sum(dummy);
gen x3 = dummy/x2;
by msa, sort: egen sample_pop_uw = sum(x3);

* The next commands generate the weighted number of person
  in the sample per msa;

gen x4 = wtperfin/x2;
by msa, sort: egen sample_pop_w = sum(x4);


***************************************************************************************
* Now I create a variable called prop_dpov, representing the proportion of individuals driving at least 1 trip by POV in each msa.
*  Keeping only drivers will lead to an estimate of VMT (no double counting) and of the time it took to travel
*  these miles. After removing every driver who entered a bad trip, I can take this proportion, multiply
*  by population, and multiply it by average mile/time travel in an msa to get a measure of aggreage vmt or vtime.
* If I didn't have to clean data I could compute average time traveled right away and multiply it by population and that would be it.
* However after cleaning the data that simple average is biased because I have removed only drivers through the cleaning process.
* Hence the more complicated method.
**********************************************************************************************;

by pid, sort: egen x7 = sum(dpov);
gen x8 = 0;
  replace x8 = 1 if x7>0;

*ASIDE note that x8 is a variable equal to 1 if a person drove at least one POV trip, and to 0 otherwise
* the following command creates a variable that sums up (per individual) to one if that individual
* drove at least one POV trip, and to 0 if it didn't;

*Note the the abreviation 'dal1t' means 'driving at least one trip';
*To compare vehicle mile and time computed in different year, I need
* to take into account that 0-4 years old are not included in the 1995
* and the 2009 sample. In the 2000 census 0-4 represents 6.82% of the 
* population. In 2001 NPTS they represent 6% of sample (maybe no time 
* to fill a survey with a baby). I use a correction factor of 6% for both
* 1995 and 2009 i.e. I scale to sample population to what it would have
* been if 0-4 years old had been included, so that scaling by a total
* population that contains them makes sense;
 
by pid, sort: egen x9 = count(x8);
gen x10 = x8/x9;
by msa, sort: egen sample_pop_dal1t_uw = sum(x10);
gen pop_dal1t_uw = (sample_pop_dal1t_uw/(sample_pop_uw*(100/94)))*ann_pop9596;

*Now I obtain another, weighted estimates of the same variable;
gen x11 = (x8*wtperfin)/x9;
by msa, sort: egen sample_pop_dal1t_w = sum(x11);
gen pop_dal1t_w = (sample_pop_dal1t_w/(sample_pop_w*(100/94)))*ann_pop9596;

* Just to get a `visual measure';
* Seems like proportion of driver usually higher unweighted... so non-driver are unrepresented in sample and carry more weight;
gen prop_dpov_uw = sample_pop_dal1t_uw/(sample_pop_uw*(100/94));
gen prop_dpov_w = sample_pop_dal1t_w/(sample_pop_w*(100/94));


******************************************************************;
*Clean data, remove extreme trip values or observation with missing inf;
******************************************************************;


* drop every individual who enters an unusable trip i.e. trptrans (transportation
*  mode) unascertained (98) or refused ((99). I do this because I try to
*  match population counts (population using POVs) and I cannot just drop trips and not persons. The procedure
*  biases our estimates if persons entering 98 or 99 are more or less likely than average to use POV (could verify).
*  As an aside, note that the driver's flag (drvr_flg) is never missing, sor no need to drop here;

gen x = 0;
   replace x = 1 if trptrans == "98"|trptrans == "99";
   by pid, sort: egen y = sum(x);
   drop if y>0;
drop y x;

*Now I am ready to drop all trips not by a driver in a POV;

* 'trptrans' selects only trips with a driver by: 1) car, 2) van, 3) SUV, 4) Pick-Up;


keep if 	((trptrans=="01"|
   		trptrans=="02"|
   		trptrans=="03"|
   		trptrans=="04") &
            drvr_flg =="01");


*replace a value for trpmiles (distance in miles) of 9997 by 0.5 (half-mile) and of 9996 by 0.06 (less than half block);

   replace trpmiles = cond(trpmiles == 9997, 0.5, trpmiles);
   replace trpmiles = cond(trpmiles == 9996, 0.06, trpmiles);

*Note that we keep all trips entered in blocks  (howfaru = B) converted to 9 blocks per miles. We keep answers were reported by proxy (proxy = 2). 

*generate a speed variable for each trip;

   gen mph_trip = trpmiles/(trvl_min/60);


*We eliminate the 0.5% highest/lowest values
 for speed, distance and time. An alternative would be to keep the 0.5% lowest for time and distance. 
 Even very small distance (half a block) and time (1 minute) could have a plausible interpretation;

*first I create a flag for trips with unascertained time or distance or unit (block, miles) that I will drop later, 
 I want to remove then from percentile computation for now, and later I will drop the persons who entered these trips;
  
gen x12 = 0;
   replace x12 = 1 if trvl_min > 9000 | trpmiles > 9000 | howfaru == "98" | howfaru == "99";


_pctile mph_trip if x12 == 0, percentile(0.5, 99.5);
   *return list;
   scalar mph05 = r(r1);
   scalar mph995 = r(r2);

_pctile trpmiles if x12 == 0, percentile(0.5, 99.5);
   *return list;
   scalar dist05 = r(r1);
   scalar dist995 = r(r2);

_pctile trvl_min if x12 == 0, percentile(0.5, 99.5);
   *return list;
   scalar time05 = r(r1);
   scalar time995 = r(r2);

*The next commands cut not only an extreme or unascertained trip, but all trips from the individual who entered it.
 *The rational is that other trips by that person are probably bad data too, and most importantly, we are trying to 
 *match a population target so I cannot drop trips, I need to drop person;

save temp, replace; 

gen x13 = 0;
   display mph05, mph995, dist05, dist995, time05, time995;
   replace x13 = 1 if mph_trip < mph05 | 
                    mph_trip > mph995 |
                    trpmiles < dist05 | 
                    trpmiles > dist995 |
                    trvl_min < dist05 |
                    trvl_min > time995 | 
                    x12 == 1;
      

by pid, sort: egen x14 = sum(x13);
drop if x14>0;

*I eliminated extreme trips, but there could still be persons who spent an improbable amount of time ont the road;

*************************************************************************************************************************
*Generate a trip_level variable, called "purpose", equal to average distance for of all trips of the same purpose in the individual's msa
* (the idea is to use it or a modification of it) as an instrument for distance... a trip to work is generally longer than a shopping trip etc)
*I also generate msa-level variables purpmsa_1-purpmsa_11, equal to the average distance for each trip purpose in each msa. 
**************************************************************************************************************************;

*write an ugly program which works (the program use the fact stata does not factor in missing values 
* when computing means... I want one mean for each purpose, for each msa;
 
by whytrp90 msa, sort: egen purpose = mean(trpmiles);

forvalues i = 1(1)11 {;
gen x15 = .;
replace x15 = purpose if whytrp90 == `i';
by msa, sort : egen purpmsa_`i' = mean(x15);
drop x15; 
};

order purpose purpmsa_1-purpmsa_11;

* note that there is no purpose "9" (in any of the years, for some reason), so drop it;
drop purpmsa_9;

* note that purpose 7 and 11 contain very few trips, so the variable is missing for some msa;


********************************************************************************************
*Save the dataset to re-merge later;
********************************************************************************************;

keep houseid personid trpmiles worker whytrp90 r_age r_sex tdwknd month_1-month_12 race
     purpose1-purpose10 purpose purpmsa_1-purpmsa_11
     hh_education whytrp90 hh_education_1-hh_education_5 hh_income hh_income_1-hh_income_18 trvl_min mph_trip msa 
	 prop_dpov_uw prop_dpov_w pop_dal1t_w pop_dal1t_uw wtperfin 
     purpose sample_pop_w sample_pop_uw dpov_trips_msa ann_pop9596 dummy
	 peak urb strttime; 

sort houseid personid;
save temp, replace;

*generate average trip distance in each msa (just an interesting variable);
by msa, sort: egen av_trip_dist_uw = mean(trpmiles);

********************************************************************************************
*Now I can collapse the data by individual. The goal is to obtain the variables "person_vmt"
*and "person_vtime" which is equal to total time travel for an individual.
********************************************************************************************;


collapse 
(sum) person_vmt = trpmiles person_vtime = trvl_min
(mean) msa pop_dal1t_w pop_dal1t_uw wtperfin sample_pop_w sample_pop_uw
       prop_dpov_uw prop_dpov_w dpov_trips_msa av_trip_dist_uw ann_pop9596 
(count) n_driver_trip_person = dummy
, by(houseid personid);

#delimit;
*Create a new person identifier that will never be the same for 1995, 2001 and 2009;

sort msa;
gen pid = _n;

**********************************************************************************************
*We now create the key variables "vmt_trip_uw" and "vtime_trip_uw", which are our estimates of total
*vehicle mile traveled and total vehicle time traveled in each msa.
*Total vehicle mile travel is equal to the average person time for a driver, times the proportion of the msa population who drives, times that population;
***********************************************************************************************;

*vehicle time, unweighted;
by msa, sort: egen vtime_trip_uw = mean(person_vtime*prop_dpov_uw*ann_pop9596);

*vehicle time, weighted;
by msa, sort: egen x = mean(person_vtime*wtperfin*prop_dpov_w*ann_pop9596);
by msa, sort: egen y = mean(wtperfin);
gen vtime_trip_w = x/y;
drop x y;

*vehicle mile, unweighted;
by msa, sort: egen vmt_trip_uw = mean(person_vmt*prop_dpov_uw*ann_pop9596);

*vehicle miles, weighted;
by msa, sort: egen x = mean(person_vmt*wtperfin*prop_dpov_w*ann_pop9596);
by msa, sort: egen y = mean(wtperfin);
gen vmt_trip_w = x/y;
drop x y;

*save data set and merge with trip level data to prepare for collapse and re-merge later, along with msa level variables;
sort houseid personid;
merge houseid personid using temp;
drop _merge;
sort msa;
save temp, replace;

**************************************************************************
*Now recover msa totals (I use a lot of means because I already collapsed most of the
*the data set manually).
*******************************************************************************;

collapse
(mean) vmt_trip_uw_95 = vmt_trip_uw 
      vtime_trip_uw_95  = vtime_trip_uw 
      vmt_trip_w_95  = vmt_trip_w  
      vtime_trip_w_95  = vtime_trip_w
	   prop_dpov_uw_95 = prop_dpov_uw
	   prop_dpov_w_95 = prop_dpov_w
       ann_pop9596 = ann_pop9596
	   purpose_95 = purpose
	   purpmsa_1_95 = purpmsa_1
	   purpmsa_2_95 = purpmsa_2
	   purpmsa_3_95 = purpmsa_3
	   purpmsa_4_95 = purpmsa_4
	   purpmsa_5_95 = purpmsa_5
	   purpmsa_6_95 = purpmsa_6
	   purpmsa_7_95 = purpmsa_7
	   purpmsa_8_95 = purpmsa_8
	   purpmsa_10_95 = purpmsa_10
	   purpmsa_11_95 = purpmsa_11	      
       sample_dpop_w_95 = sample_pop_w
       sample_dpop_uw_95 = sample_pop_uw
,by(msa);
       

* compare unweighted with weighted;

gen compare_trip_vmt_95 = 1-(vmt_trip_uw_95 /vmt_trip_w_95  );
gen compare_trip_vtime_95 = 1-(vtime_trip_uw_95  /vtime_trip_w_95);

sort msa;

* save a dataset containing one observation per msa;
save trip_msa_vmt_95, replace;

mean compare_trip_vmt_95;
mean compare_trip_vtime_95;

*merge the dataset with information from the trip file that was previously saved;
merge msa using temp;
drop _merge;
sort msa;


merge msa using temp;
drop _merge;
sort msa;
compress;
save trip_trip_vmt_95, replace;
