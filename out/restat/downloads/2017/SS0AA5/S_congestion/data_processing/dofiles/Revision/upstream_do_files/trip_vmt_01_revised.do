/**********************************************
trip_trip_vmt_01_mmdd.do

By Victor Couture, Fall 2009

Calculate vehicle miles and time traveled by POV, 
per msa, from the trip file, for 2001.
**********************************************/
*set up;
#delimit;
clear all;

set memory 500m;
set more 1;
quietly capture log close;
*log using trip_trip_vmt_01_mmdd, text replace;
* specify locations of data sets;


global npts1995		"D:\S_congestion\data_processing\data\npts1995" ;
global npts2001		"D:\S_congestion\data_processing\data\npts2001" ;
global npts2009		"D:\S_congestion\data_processing\data\npts2001" ;
global county2pmsa	"D:\S_congestion\data_processing\data\county2pmsa\county2pmsa_GD";
global sprawl_4VC 	"D:\S_congestion\data_processing\data\sprawl_4VC";
cd D:\S_congestion\data_processing\data_generated;
*****************************************************************************;

use  $npts2001/day_dotx.dta,clear;
keep  		 trptrans houseid tdboa911 trpmiles travday trvl_min  whyto whyfrom whytrp01 whytrp1s whytrp90 drvr_flg tdwknd whodrove educ r_age r_sex 
                    editentm editmile editmin editmode editsttm endhour endmin
                    tdwknd travday tdaydate urban
                    imptentm imptmile imptmin impttrip imptsttm personid strthr strtmin strttime trpblks trpdist proxy worker wttrdfin;

* generate person weights from trip weights;
gen wtperfin = wttrdfin/365;

compress;

*************************************************************************************;
*I want to add an observation from the person file for each individual who does not travel, because I compute vmt and vtime 
*based by scaling up sample averages by population count;
*************************************************************************************;
save temp, replace;

use  $npts2001\ppdotr_2.dta,clear;

keep houseid personid wtperfin;

merge 1:m houseid personid using temp;
drop _merge;


********************************************************************************
* define, redefine some variables;
********************************************************************************;

* transform some variables into a dummy, for regression purposes;
destring whytrp90, replace;
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
replace tday_mon = (tdaydate - 200100) if tdaydate < 200200;
replace tday_mon = (tdaydate - 200200) if tdaydate > 200200;
tabulate tday_mon, gen(month_);

* modify a variable (from string to numeric);

*create dummy for each purpose;
*First consolitade last 3 categories (11 = other, 98 = N/A, 99 - Refused, );
replace whytrp90 = 11 if whytrp90 == 98;
replace whytrp90 = 11 if whytrp90 == 99;
tabulate whytrp90, gen(purpose);


*this is a pre-post 9/11 indicator;
destring tdboa911, replace;

*des;

* create a dummy for trips by indiduals in urban areas;

gen urb = 0;
replace urb = 1 if urban == "2";


*gen a dummy for trips during peak hours;

destring strttime, replace;
gen peak = 0;
replace peak = 1 if (((strttime >= 0600  & strttime < 1000) | (strttime >= 1500 & strttime < 1900)) & tdwknd == 0);				

* Now check whether I need to drop trips for which no driver is entered;
tab drvr_flg;

sort houseid;
save temp, replace;


*********************************************************************************
*Prepare for merger later with msa information by adding info from the household file
*****************************************************************************;

*NOTE that using the hhfile here is unnecessary as all the information is already on the trip file,
*but the program below was already written and it works so let's keep it like that;

*organize 2001 hh file;

use $npts2001/hhdotr_2,clear;

keep houseid hhfaminc hhr_educ hhr_hisp hhr_race hhsize hhstate hhstfips hhc_msa;

compress;
*simplify race info, white/others =1, black = 2, hispanic = 3;

gen race = .;
  replace race = cond(hhr_race=="02",2,race);
  replace race = cond(	hhr_race=="01" | 
			      hhr_race=="03" | 
			      hhr_race=="04" | 
			      hhr_race=="05" | 
			      hhr_race=="07" | 
			      hhr_race=="08" | 
			      hhr_race=="09" | 
			      hhr_race=="10" | 
			      hhr_race=="11" | 
			      hhr_race=="12" | 
			      hhr_race=="13" | 
			      hhr_race=="14" | 
			      hhr_race=="15" | 
			      hhr_race=="16" | 
			      hhr_race=="17" 
			                ,1,race);

  replace race = cond(	hhr_race=="06"	,3,race);
  replace race = cond(hhr_hisp=="1",3,race);
      label define race_name 1 "white/other" 2 "black" 3 "hispanic";		
      label values race race_name;
  tab race;
  drop hhr_race hhr_hisp;

*Clean up income variable. Note that codes for 1995 and 2001 are the same except for missings.;
*Ignore changes in price level over six years.;
   
  gen hh_income = cond(hhfaminc==""| hhfaminc=="-1"| hhfaminc=="-7"| hhfaminc=="-8"| hhfaminc=="-9"| ,.,real(hhfaminc)); 
   drop hhfaminc;
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


* Clean up education variable. The number of categories is smallest in 2009, so I aggregate the 1995 and 2001 variable
*to the 5 categories of 2009;
  
* We change code -1, -7 and -9 to missing;
gen hh_education = cond(hhr_educ==""| hhr_educ=="-1"| hhr_educ=="-7"| hhr_educ=="-8"| hhr_educ=="-9"|,.,real(hhr_educ));
 
  replace hh_education = cond(hh_education==1	,1	,hh_education);
  replace hh_education = cond(hh_education==2 	,2 	,hh_education);
  replace hh_education = cond(hh_education==3 	,3 	,hh_education);
  replace hh_education = cond(hh_education==4 	,3 	,hh_education);
  replace hh_education = cond(hh_education==5 	,3 	,hh_education);
  replace hh_education = cond(hh_education==6 	,4 	,hh_education);
  replace hh_education = cond(hh_education==7 	,4 	,hh_education);
  replace hh_education = cond(hh_education==8 	,5 	,hh_education);
     drop hhr_educ;

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

compress;
sort houseid;
merge houseid using temp;
drop if _merge ==1;
drop _merge;

*match households to msa's using the dot geocode file;
*note there are lots of households in the geocode file that we've dropped for missing data;
  
  sort houseid;
  merge houseid using $npts2001/2001_geocodes;
  *tab _merge;
  keep if _merge==3;


*there are houseid's with msa's in the public data but not in the confidential data -- find out why;
    
   count if hhc_msa!=msacmsa & hhc_msa!="9999";

*fill in missing geocode msa's with public msa's where possible;
    
    replace msacmsa=cond(msacmsa=="" & hhc_msa!="",hhc_msa,msacmsa);
    drop if msa == "9999";
   *drop hh in AK or HI;
    drop if hhstate=="AK" | hhstate=="HI";

*drop if non-msa household;
   
    drop if msacmsa=="";

*cleanup;

   gen msa= real(msacmsa);
   drop hhc_msa msacmsa _merge  lsad lsad_trans jtp;
   rename name msa_name;

*clean up little disagreements in msa code between npts and us;
replace msa = cond(msa==730,733,msa);
replace msa = cond(msa==740,743,msa);
replace msa = cond(msa==1122,1123,msa);
replace msa = cond(msa==1305,1303,msa);
replace msa = cond(msa==3280,3283,msa);
replace msa = cond(msa==4240,4243,msa);
replace msa = cond(msa==5520,5523,msa);
replace msa = cond(msa==6320,6323,msa);
replace msa = cond(msa==6400,6403,msa);
replace msa = cond(msa==6480,6483,msa);
replace msa = cond(msa==8000,8003,msa);

sort msa;
save temp,replace;


************************************************************************************;
* add population data from congestion_gd
************************************************************************************;

use $sprawl_4VC/congestion_vc,clear;

keep msa ann_pop01 ann_pop02;

* The data for 2001 were in fact collected in 2001 and 2002, so I use an average
 * of the population in both years in my computation;
 
gen ann_pop0102 = (ann_pop01 + ann_pop02)/2;

sort msa;
merge msa using temp;

tab _merge;

keep if _merge==3;

drop _merge;

* the above dropped one observation for msa 9999, and there also seem
 * to be another msa '5483' (New Haven-Bridgeport-Stamford-Waterbury-Danbury, CT NECMAwith population 1700000!) for which we have 
 * no observation in the trip file...);

*********************************************************************************
*Now I generate a few variables that give us an idea of sample size for each msa
*********************************************************************************;

* The next commands generate the total number of trips  by POV (1) car, 2) van, 
*3) SUV, 4) Pick-Up) in an MSA, entered by the driver;
* Perhaps I should include: other trucks (05), motorcycle (07), taxicab (15);

gen dpov = 0;
   replace dpov = 1 if (trptrans == "01"| trptrans == "02"| trptrans == "03"| trptrans ==  "04") & drvr_flg == "1";

by msa, sort: egen dpov_trips_msa = sum(dpov);
      
* The next commands generates the total number of trips (the number of
*  of observation in the sample per msa);

gen dummy = 1;
*by msa, sort: egen total_trips_msa = sum(dummy);

*The next commands generate the number of person in the sample per msa (I create a variable (x3) that add up to one for each person);

by houseid personid, sort: egen x2 = sum(dummy);
gen x3 = dummy/x2;
by msa, sort: egen sample_pop_uw = sum(x3);

* The next commands generate the weighted number of person;
  *in the sample per msa;

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
by houseid personid, sort: egen x9 = count(x8);
gen x10 = x8/x9;
by msa, sort: egen sample_pop_dal1t_uw = sum(x10);
gen pop_dal1t_uw = (sample_pop_dal1t_uw/sample_pop_uw)*ann_pop0102;

* Now I obtain another, weighted estimates of the same variable;

gen x11 = (x8*wtperfin)/x9;
by msa, sort: egen sample_pop_dal1t_w = sum(x11);
gen pop_dal1t_w = (sample_pop_dal1t_w/sample_pop_w)*ann_pop0102;


* Seems like proportion of driver usually higher unweighted... so non-driver are unrepresented in sample and carry more weight;
gen prop_dpov_uw = sample_pop_dal1t_uw/(sample_pop_uw);
gen prop_dpov_w = sample_pop_dal1t_w/(sample_pop_w);


******************************************************************;
*Clean data, remove extreme trip values or observation with missing inf;
******************************************************************;

* drop every person who enters an unusable trip i.e. trptrans (refused to answer,
*  unascertained etc code -7 -8 -9 -1). I do this because I try to
*  match population counts (population using POVs) and I cannot just drop trips and not persons. The procedure
*  biases our estimates if persons entering 98 or 99 are more or less likely than average to use POV (could verify);


gen x = 0;
replace x = 1 if trptrans == "-1"|trptrans == "-7"|trptrans == "-8"|trptrans == "-9";
by houseid personid, sort: egen y = sum(x);
drop if y>0;
drop y x;


* Those with drvr_flg == -1 (appropriate skip) are kept (apart from 15 unexplained cases, these
*  are all for trips not by POV, like walking). Those with flag -9 are unascertained... I drop those
*  persons who entered these trips (again, just dropping trips and not persons would bias my results 
*  downward, as I compute total vmt and vehicle time travel by matching a population total from the census);

gen x = 0;
replace x = 1 if drvr_flg == "-9";
by houseid personid, sort: egen y = sum(x);
drop if y>0;
drop y x;


*Now I am ready to drop all trips not by driver in a POV;
* 'trptrans' selects only trips with a driver by: 1) car, 2) van, 3) SUV, 4) Pick-Up;



keep if 	((trptrans=="01"|
   		trptrans=="02"|
   		trptrans=="03"|
   		trptrans=="04") &
            drvr_flg =="1");

gen mph_trip = trpmiles/(trvl_min/60);


*We eliminate the 0.5% highest/lowest values
* for speed, distance and time. An alternative would be to keep the 0.5% lowest for time and distance. 
* Even very small distance (half a block) and time (1 minute) could have a plausible interpretation;
 
*First create a variable for whether a trip was in blocks or miles that is similar to that in 1995;

gen str1 howfaru = ".";
   replace howfaru = "M" if trpblks == -1;
    replace howfaru = "B" if trpblks > 0;


gen var1 = 0;
   replace var1 = 1 if trvl_min <= 0 | trpmiles <= 0 |imptentm == "1" | imptmile == "1" | imptmin == "1" | 
   impttrip == "1" | imptsttm == "1" | howfaru == ".";

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

*I eliminated extreme trips, but there could still be persons who spent an improbable amount of time ont the road;

*************************************************************************************************************************
*Generate a trip_level variable, called "purpose", equal to average distance for of all trips of the same purpose in the individual's msa
*(the idea is to use it or a modification of it) as an instrument for distance... a trip to work is generally longer than a shopping trip etc)
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

keep houseid personid race hh_income hh_income_1-hh_income_18 hh_education hh_education_1-hh_education_5 r_age r_sex tdwknd worker 
     month_1-month_12 trpmiles trvl_min mph_trip tdboa911 msa pop_dal1t_w pop_dal1t_uw prop_dpov_uw prop_dpov_w wtperfin 
     purpose1-purpose10 purpmsa_1-purpmsa_11 sample_pop_w sample_pop_uw dpov_trips_msa purpose ann_pop0102 whytrp90 dummy
	 peak urb strttime; 

sort houseid personid;
save temp, replace;

*generate average trip distance in each msa (just an interesting variable);
by msa, sort: egen av_trip_dist_uw = mean(trpmiles);



********************************************************************************************
*Now I can collapse the data by individual. The goal is to obtain the variables "person_vmt"
*and "person_vtime" which is equal to total time travel for an individual.
********************************************************************************************;
#delimit;


collapse 
(sum) person_vmt = trpmiles person_vtime = trvl_min
(mean) tdboa911 msa pop_dal1t_w pop_dal1t_uw wtperfin sample_pop_w sample_pop_uw
       prop_dpov_uw prop_dpov_w dpov_trips_msa av_trip_dist_uw ann_pop0102 
(count) n_driver_trip_person = dummy
, by(houseid personid);

*Create a person identifier that will be useful when using fixed effect (and better if sorted by msa before);
*The id for 1995 is just the count, that for 2001 is 1000000 plus count and for 2009 is 2000000 plus count;

sort msa;
gen pid = 1000000 + _n;


**********************************************************************************************
*We now create the key variables "vmt_trip_uw" and "vtime_trip_uw", which are our estimates of total
*vehicle mile traveled and total vehicle time traveled in each msa.
*Total vehicle mile travel is equal to the average person time for a driver, times the proportion of the msa population who drives, times that population;
***********************************************************************************************;

*vehicle time, unweighted;
by msa, sort: egen vtime_trip_uw = mean(person_vtime*prop_dpov_uw*ann_pop0102);

*vehicle time, weighted;
by msa, sort: egen x = mean(person_vtime*wtperfin*prop_dpov_w*ann_pop0102);
by msa, sort: egen y = mean(wtperfin);
gen vtime_trip_w = x/y;
drop x y;

*vehicle mile, unweighted;
by msa, sort: egen vmt_trip_uw = mean(person_vmt*prop_dpov_uw*ann_pop0102);

*vehicle miles, weighted;
by msa, sort: egen x = mean(person_vmt*wtperfin*prop_dpov_w*ann_pop0102);
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
(mean) vmt_trip_uw_01 = vmt_trip_uw 
      vtime_trip_uw_01  = vtime_trip_uw 
      vmt_trip_w_01  = vmt_trip_w  
      vtime_trip_w_01  = vtime_trip_w
	   prop_dpov_uw_01 = prop_dpov_uw
	   prop_dpov_w_01 = prop_dpov_w
       ann_pop0102 = ann_pop0102
	   purpose_01 = purpose
	   purpmsa_1_01 = purpmsa_1
	   purpmsa_2_01 = purpmsa_2
	   purpmsa_3_01 = purpmsa_3
	   purpmsa_4_01 = purpmsa_4
	   purpmsa_5_01 = purpmsa_5
	   purpmsa_6_01 = purpmsa_6
	   purpmsa_7_01 = purpmsa_7
	   purpmsa_8_01 = purpmsa_8
	   purpmsa_10_01 = purpmsa_10
	   purpmsa_11_01 = purpmsa_11	      
       sample_dpop_w_01 = sample_pop_w
       sample_dpop_uw_01 = sample_pop_uw
,by(msa);

* compare unweighted with weighted;

gen compare_trip_vmt_01 = 1-(vmt_trip_uw_01 /vmt_trip_w_01  );
gen compare_trip_vtime_01 = 1-(vtime_trip_uw_01  /vtime_trip_w_01);

mean compare_trip_vmt_01;
mean compare_trip_vtime_01;

sort msa;

* save a dataset containing one observation per msa;
save trip_msa_vmt_01, replace;

*merge the dataset with information from the trip file that was previously saved;
merge msa using temp;
drop _merge;
sort msa;
compress;
save trip_trip_vmt_01, replace;
