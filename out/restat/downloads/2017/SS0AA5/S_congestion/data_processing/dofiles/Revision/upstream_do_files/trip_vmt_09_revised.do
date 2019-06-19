/**********************************************
trip_trip_vmt_09_mmdd.do

By Victor Couture, Fall 2009

Calculate vehicle miles and time traveled by POV, 
per msa, from the trip file, for 1995.
**********************************************/
*set up;
#delimit;
clear all;

set memory 1000m;							
set more 1;
quietly capture log close;
*log using trip_trip_vmt_09_mmdd, text replace;
* specify locations of data sets;


global npts1995		"D:\S_congestion\data_processing\data\npts1995" ;
global npts2001		"D:\S_congestion\data_processing\data\npts2001" ;
global npts2009		"D:\S_congestion\data_processing\data\npts2009" ;
global npts2009_2		"D:\S_congestion\data_processing\data\npts2009_2" ;
global county2pmsa	"D:\S_congestion\data_processing\data\county2pmsa\county2pmsa_GD";
global sprawl_4VC 	"D:\S_congestion\data_processing\data\sprawl_4VC";
cd D:\S_congestion\data_processing\data_generated;
*****************************************************************************;

use  $npts2009_2\day2pub.dta,clear;

keep  		 houseid personid trpmiles trptrans travday tdaydate drvr_flg trvl_min whyto
             whyfrom whytrp1s whytrp90 tdwknd educ r_age r_sex proxy worker wttrdfin travday tdaydate
			 strttime vmt_mile urban;                   
                   
* generate person weights from trip weights;
gen wtperfin = wttrdfin/365;

compress;

*************************************************************************************;
*I want to add an observation from the person file for each individual who does not travel, because I compute vmt and vtime 
*based by scaling up sample averages by population count;
**************************************************************************************;

save temp, replace;

use  $npts2009_2\per2pub.dta,clear;

keep houseid personid wtperfin;

merge 1:m houseid personid using temp;
drop _merge;

************************************************************************************
* define, redefine some variables;
************************************************************************************;

 * destring the person id;
 destring personid, replace;
 * transform some variables into a dummy, for regression purposes;
destring r_sex, replace;
replace r_sex = 0 if r_sex == 2;
replace r_sex = . if r_sex <0;
destring worker, replace;
replace worker = 0 if worker == 2;
replace worker = . if worker < 0;
destring tdwknd, replace;
replace tdwknd = 0 if tdwknd  == 2;

* create a dummy for each month;
destring tdaydate, replace;
gen tday_mon = .;
replace tday_mon = (tdaydate - 200800) if tdaydate < 200900;
replace tday_mon = (tdaydate - 200900) if tdaydate > 200900;
tabulate tday_mon, gen(month_);

*create dummy for each purpose;
*First consolitade last 3 categories (11 = other, 98 = N/A, 99 - Refused, );
destring whytrp90, replace;
replace whytrp90 = 11 if whytrp90 == 98;
replace whytrp90 = 11 if whytrp90 == 99;
tabulate whytrp90, gen(purpose);

* create a dummy for trips by indiduals in urban areas;

gen urb = 0;
replace urb = 1 if urban == 1;

*gen a dummy for trips during peak hours;

destring strttime, replace;
gen peak = 0;
replace peak = 1 if (((strttime >= 0600  & strttime < 1000) | (strttime >= 1500 & strttime < 1900)) & tdwknd == 0);		

*des;


* Education in 2009 is a person level variable (as opposed to a household level 
  variable in 2001 and 2009... so let's deal with it in this section of the program;

* Clean up education variable. The number of categories is smallest in 2009, so I aggregate the 1995 and 2001 variable
to the 5 categories of 2009;
* We change code -1, -7 and -9 to missing;
replace educ = . if educ == -1|educ == -7|educ==-8|educ == -9;

rename educ hh_education;

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


sort houseid;
save temp, replace;

*********************************************************************************;
*Prepare for merger later with msa information by adding info from the household file;
*****************************************************************************;

*NOTE that in 2009 using the hhfile here is unnecessary as all the information is already on the trip file,
*but the program below was already written and it works so let's keep it like that;

 #delimit;

use $npts2009_2/hh2pub,clear;

keep houseid hhfaminc hh_hisp hh_race hhsize hhstate hhstfips hhc_msa ;



compress;

*simplify race info, white/others =1, black = 2, hispanic = 3;

gen race = .;
  replace race = cond(hh_race==2,2,race);
  replace race = cond(hh_race==1 | 
			      hh_race==3 | 
			      hh_race==4 | 
			      hh_race==5 | 
			      hh_race==7 | 
			      hh_race==97  
			                ,1,race);

  replace race = cond(hh_race== 7	,3,race);
  replace race = cond(hh_hisp== 1,3,race);
      label define race_name 1 "white/other" 2 "black" 3 "hispanic";		
      label values race race_name;
  tab race;
  drop hh_race hh_hisp;

*Clean up income variable. Note that codes for 1995, 2001 and 2009 are the same except for missings.;
*Ignore changes in price level over 14 years.;
   
  replace hhfaminc = . if hhfaminc == -7 | hhfaminc == -8|hhfaminc==-9;
  rename hhfaminc hh_income;
   
  label var hh_income "hh income";
  
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
     
tab hh_income, missing;

 gen l_hh_income = ln(hh_income);

   
*As an alternative way to eventually control for income, generate dummies for each income category;   
tabulate hh_income, gen(hh_income_);

compress;
sort houseid;
merge houseid using temp;
tab _merge;
drop if _merge ==1;
drop _merge;
 sort houseid;
 save temp, replace;
 
****************************************************************************;
*match households to msa's using the information on their county;
****************************************************************************;


use $npts2009/hhctbg,clear;
keep HOUSEID HHSTFIPS HHCNTYFP;

rename HHCNTYFP hhcntyfp;
rename HHSTFIPS hhstfips;
rename HOUSEID houseid;

*make 5 digit county fips;
gen county = real(hhstfips) *1000 + real(hhcntyfp);

destring houseid, replace;
sort houseid;
merge houseid using temp;
tab _merge;
keep if _merge==3;
drop _merge;

*match households to msa's;

sort county;
merge county using $county2pmsa;
tab _merge;

*Note that _merge==1 ==> HI and AK, and two observations from TX, which I will just ignore;
*Note that  _merge==2 ==> county with no respondent, mostly non-msa counties;

keep if _merge==3;
   drop  land_ha water_ha _merge county county_name pop1990 pop2000 _merge;
   *order  msa msa_name houseid hhstate   race hhsize  hh_income hh_education;
   drop if msa==.;

  
sort msa;
save temp,replace;

************************************************************************************
* add population data from congestion_gd
************************************************************************************;

use $sprawl_4VC/congestion_vc,clear;

*The data for npts 2009 were collected in 2008 and 2009, so I use
 an average of both years in my computation;
 
keep msa ann_pop08 ann_pop09;
gen ann_pop0809 = (ann_pop08 + ann_pop09)/2;

sort msa;
merge msa using temp;

tab _merge;

keep if _merge==3;

drop _merge;

* the above only dropped one observation for msa 9999 in the congestion_gd data set;

*********************************************************************************
*Now I generate a few variables that give us an idea of sample size for each msa;
*********************************************************************************;

* The next commands generate the total number of trips  by POV (1) car, 2) van, 
*3) SUV, 4) Pick-Up) in an MSA, entered by the driver;
* Perhaps I should include: other trucks (05), motorcycle (07), taxicab (15);

*In 2009, 5% of the sample has trips "unascertained". We replace assume that these trips are by a driver. The idea is that 
*there are only 1.25 (well,  1.287 without drvr_flg = -9 and 1.265 with drvr_flg = -9) people on an average trip, and often individuals have most or all of their trips unascertained, and it is
*likely that they drove at least on and therefore belong to the sample of indiviudals driving at least one trip;
*However we eliminate these drivers when computing our averages;

gen dpov = 0;
   replace dpov = 1 if (trptrans == 1| trptrans == 2| trptrans == 3| trptrans ==  4) & (drvr_flg == 1|drvr_flg == -9);

by msa, sort: egen dpov_trips_msa = sum(dpov);
      
* The next commands generates the total number of trips (the number of
  of observation in the sample per msa);

gen dummy = 1;
*by msa, sort: egen total_trips_msa = sum(dummy);

* The next commands generate the number of person in the
  sample per msa (I create a variable (x3) that add up to one for each person);

by houseid personid, sort: egen x2 = sum(dummy);
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

by houseid personid, sort: egen x7 = sum(dpov);
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
 
by houseid personid, sort: egen x9 = count(x8);
gen x10 = x8/x9;

by msa, sort: egen sample_pop_dal1t_uw = sum(x10);
gen pop_dal1t_uw = (sample_pop_dal1t_uw/(sample_pop_uw*(100/94)))*ann_pop0809;

* Now I obtain another, weighted estimates of the same variable;
gen x11 = (x8*wtperfin)/x9;
by msa, sort: egen sample_pop_dal1t_w = sum(x11);
gen pop_dal1t_w = (sample_pop_dal1t_w/(sample_pop_w*(100/94)))*ann_pop0809;


* Seems like proportion of driver usually higher unweighted... so non-driver are unrepresented in sample and carry more weight;
gen prop_dpov_uw = sample_pop_dal1t_uw/(sample_pop_uw*(100/94));
gen prop_dpov_w = sample_pop_dal1t_w/(sample_pop_w*(100/94));



******************************************************************;
*Clean data, remove extreme trip values or observation with missing inf;
******************************************************************;

* drop every person who enters an unusable trip i.e. trptrans (refused to answer,
*  unascertained etc code -7 -8 -9 -1). I do this because I try to
*  match population counts (population using POVs) and I cannot just drop trips and not persons. The procedure
*  biases our estimates if persons entering 98 or 99 are more or less likely than average to use POV (could verify);

gen x = 0;
replace x = 1 if trptrans == -1|trptrans == -7|trptrans == -8|trptrans == -9;
by houseid personid, sort: egen y = sum(x);
drop if y>0;
drop y x;


*I drop all individuals with drvr_flg = -9 (driver's status unascertained).  When we computed (above) the proportion of individuals 
*driving at least one trip we had to make a decision (keep them) but here we can safely drop these individuals when computing averages;


gen x = 0;
replace x = 1 if drvr_flg == -9;
by houseid personid, sort: egen y = sum(x);
drop if y>0;
drop y x;


*Now I am ready to drop all trips not by a driver in a POV, and to clean the data by removing trips with
*extreme values;

* 'trptrans' selects only trips with a driver by: 1) car, 2) van, 3) SUV, 4) Pick-Up;


keep if 	((trptrans==1|
   		trptrans==2|
   		trptrans==3|
   		trptrans==4) &
            drvr_flg ==1);

  #delimit;
* The only measure of travel time available in 2009 in trvlcmin, calculated travel time (from
*  start and end time I presume). The variable "triptime" is curiously just a 01,02 yes/no
*  character variable... check this out when codebook becomes available;
  

gen mph_trip = trpmiles/(trvl_min/60);


*We eliminate the 0.5% highest/lowest values
 *for speed, distance and time. An alternative would be to keep the 0.5% lowest for time and distance. 
* Even very small distance and time could have a plausible interpretation;

gen var1 = 0;
   replace var1 = 1 if trvl_min <= 0 | trpmiles <= 0;

_pctile mph_trip if var1 == 0, percentile(0.5, 99.5);
   *return list;
   scalar mph05 = r(r1);
   scalar mph995 = r(r2);

_pctile trpmiles if var1 == 0, percentile(0.5, 99.5);
   *return list;
   scalar dist05 = r(r1);
   scalar dist995 = r(r2);

_pctile trvl_min if var1 == 0, percentile(0.5, 99.5);
   *return list;
   scalar time05 = r(r1);
   scalar time995 = r(r2);


sort houseid personid;
save temp, replace; 
  gen x13 = 0;
     display mph05, mph995, dist05, dist995, time05, time995;
     replace x13 = 1 if mph_trip < mph05 | 
                     mph_trip > mph995 | 
                     trpmiles < dist05|
                     trpmiles > dist995|
                     trvl_min < time05 | 
                     trvl_min > time995 |
                      var1 == 1;

by houseid personid, sort: egen x14 = sum(x13);
drop if x14>0;

*Note that I eliminated extreme trips, but there could still be persons who spent an improbable amount of time ont the road;

*************************************************************************************************************************
*Generate a trip_level variable, called "purpose", equal to average distance for of all trips of the same purpose in the individual's msa
* (the idea is to use it or a modification of it) as an instrument for distance... a trip to work is generally longer than a shopping trip etc)
*I also generate msa-level variables purpmsa_1-purpmsa_11, equal to the average distance for each trip purpose in each msa. 
**************************************************************************************************************************;

*write an ugly program which works (the program use the fact stata does not factor in missing values 
*when computing means... I want one mean for each purpose, for each msa;
 
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

keep houseid personid pmsa race hh_income hh_income_1-hh_income_18 hh_education hh_education_1-hh_education_5 r_age r_sex tdwknd worker 
     month_1-month_12 trpmiles trvl_min mph_trip msa pop_dal1t_w pop_dal1t_uw  prop_dpov_uw  prop_dpov_w wtperfin 
     purpose1-purpose10 purpmsa_1-purpmsa_11 sample_pop_w sample_pop_uw dpov_trips_msa purpose ann_pop0809 whytrp90 dummy
	 peak urb strttime; 

sort houseid personid;
save temp, replace;

*generate average trip distance in each msa (just an interesting variable);
by msa, sort: egen av_trip_dist_uw = mean(trpmiles);

********************************************************************************************
*Collapse the data by individual. The goal is to obtain the variables "person_vmt"
*and "person_vtime" which is equal to total time travel for an individual.
********************************************************************************************;
#delimit;


collapse 
(sum) person_vmt = trpmiles person_vtime = trvl_min
(mean) msa pop_dal1t_w pop_dal1t_uw av_trip_dist_uw wtperfin sample_pop_w sample_pop_uw
       dpov_trips_msa ann_pop0809 prop_dpov_uw prop_dpov_w
(count) n_driver_trip_person = dummy
, by(houseid personid);

*Create a person identifier that will be useful when using fixed effect (and better if sorted by msa before);
*The id for 1995 is just the count, that for 2001 is 1000000 plus count and for 2009 is 2000000 plus count;

sort msa;
gen pid = 2000000 + _n;


**********************************************************************************************
*We now create the key variables "vmt_trip_uw" and "vtime_trip_uw", which are our estimates of total
*vehicle mile traveled and total vehicle time traveled in each msa.
*Total vehicle mile travel is equal to the average person time for a driver, times the proportion of the msa population who drives, times that population;
***********************************************************************************************;

*vehicle time, unweighted;
by msa, sort: egen vtime_trip_uw = mean(person_vtime*prop_dpov_uw*ann_pop0809);

*vehicle time, weighted;
by msa, sort: egen x = mean(person_vtime*wtperfin*prop_dpov_w*ann_pop0809);
by msa, sort: egen y = mean(wtperfin);
gen vtime_trip_w = x/y;
drop x y;

*vehicle mile, unweighted;
by msa, sort: egen vmt_trip_uw = mean(person_vmt*prop_dpov_uw*ann_pop0809);

*vehicle miles, weighted;
by msa, sort: egen x = mean(person_vmt*wtperfin*prop_dpov_w*ann_pop0809);
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
(mean) vmt_trip_uw_09 = vmt_trip_uw 
      vtime_trip_uw_09  = vtime_trip_uw 
      vmt_trip_w_09  = vmt_trip_w  
      vtime_trip_w_09  = vtime_trip_w
	   prop_dpov_uw_09 = prop_dpov_uw
	   prop_dpov_w_09 = prop_dpov_w
       ann_pop0809 = ann_pop0809
	   purpose_09 = purpose
	   purpmsa_1_09 = purpmsa_1
	   purpmsa_2_09 = purpmsa_2
	   purpmsa_3_09 = purpmsa_3
	   purpmsa_4_09 = purpmsa_4
	   purpmsa_5_09 = purpmsa_5
	   purpmsa_6_09 = purpmsa_6
	   purpmsa_7_09 = purpmsa_7
	   purpmsa_8_09 = purpmsa_8
	   purpmsa_10_09 = purpmsa_10
	   purpmsa_11_09 = purpmsa_11	      
       sample_dpop_w_09 = sample_pop_w
       sample_dpop_uw_09 = sample_pop_uw
,by(msa);
       

*compare unweighted with weighted;

gen compare_trip_vmt_09 = 1-(vmt_trip_uw_09 /vmt_trip_w_09  );
gen compare_trip_vtime_09 = 1-(vtime_trip_uw_09  /vtime_trip_w_09);

mean compare_trip_vmt_09;
mean compare_trip_vtime_09;

sort msa;

*save a dataset containing one observation per msa;
save trip_msa_vmt_09, replace;

*merge the dataset with information from the trip file that was previously saved;
merge msa using temp;
drop _merge;
sort msa;
compress;
save trip_trip_vmt_09, replace;
