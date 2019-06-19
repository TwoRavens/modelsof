capture log close
log using makepov70quart.log, replace

*************************************************************************
* makepov70quart.do							*
* 									*
* Takes 1960 poverty (from Doug MIller) and 1970 poverty (created by Becky/Ankur) 	*
*  merges and compares (for data checking)				*
*  assigns 4 quartiles of poverty for 1960 pov and 1970 poverty		*
*************************************************************************

  #delimit;
  clear;
  set mem 100m;
  set more off;

**************************;
*  1960 Poverty 	  ;
*  (old code from makepovquart.do);
**************************;

  tempfile tffull tfcwalk tfmatched tfunmatched;

/* data from Doug miller */

  use forHilary;

  gen nstate = floor(oldcode/1000);

  gen ncnty60 = oldcode - nstate * 1000;

  duplicates list nstate ncnty60;
  list if nstate==27 & ncnty60==56;
  duplicates drop nstate ncnty60, force;

  drop if povrate60==0;
  drop if povrate60==.;

  * Doug's codes don't seem to match anything I can find, so I'll use county names instead;

  sort nstate;
  drop if nstate==2;
  gen cntyname = upper(county_name_60);

  * Egregious misspellings;
  replace cntyname="ETOWAH" if county_name_60=="Etowal" & nstate==1;
  replace cntyname="ELMORE" if county_name_60=="Escambia" & nstate==1;
  replace cntyname="ESCAMBIA" if county_name_60=="Escambu" & nstate==1;
  replace cntyname="OGLETHORPE" if county_name_60=="Oglethorge" & nstate==11;
  replace cntyname="YELLOWSTONE NATIONAL PARK (PART)" if county_name_60=="" & nstate==13;
  replace cntyname="ST LAWRENCE" if county_name_60=="St. Lawrence" & nstate==33;
  replace cntyname="WALWORTH" if county_name_60=="Walwort" & nstate==42;
  replace cntyname="TODD" if county_name_60=="Woods" & nstate==42;
  replace cntyname="PENNINGTON" if county_name_60=="Penning" & nstate==42;
  replace cntyname="JACKSON (+81 INCLUDES WASHABAUGH)" if county_name_60=="Jackson" & nstate==42;
  replace cntyname="APPOMATTOX" if county_name_60=="Appomaros" & nstate==47;
  replace cntyname="BUENA VISTA CITY" if county_name_60=="Buena Vista" & nstate==47;
  replace cntyname="BRISTOL CITY" if county_name_60=="Bristol" & nstate==47;
  replace cntyname="ALEXANDRIA CITY" if county_name_60=="Alexandria" & nstate==47;
  replace cntyname="CHARLOTTESVILLE CITY" if county_name_60=="Charlottesville" & nstate==47;
  replace cntyname="COVINGTON CITY" if county_name_60=="Covinton" & nstate==47;
  replace cntyname="CHESAPEAKE CITY" if county_name_60=="Chesapeake" & nstate==47;
  replace cntyname="COLONIAL HEIGHTS CITY" if county_name_60=="Colonial Heights" & nstate==47;
  replace cntyname="CLIFTON FORGE CITY" if county_name_60=="Clifton Forge" & nstate==47;
  replace cntyname="DANVILLE CITY" if county_name_60=="Danville" & nstate==47;
  replace cntyname="FALLS CHURCH CITY" if county_name_60=="Falls Church" & nstate==47;
  replace cntyname="FREDERICKSBURG CITY" if county_name_60=="Fredericksburg" & nstate==47;
  replace cntyname="GALAX CITY" if county_name_60=="Galax" & nstate==47;
  replace cntyname="HAMPTON CITY" if county_name_60=="Hampton" & nstate==47;
  replace cntyname="HARRISONBURG CITY" if county_name_60=="Harrisonburg" & nstate==47;
  replace cntyname="HOPEWELL CITY" if county_name_60=="Hopewell" & nstate==47;
  replace cntyname="LYNCHBURG CITY" if county_name_60=="Lunchburg" & nstate==47;
  replace cntyname="MARTINSVILLE CITY" if county_name_60=="Martinsville" & nstate==47;
  replace cntyname="NEWPORT NEWS CITY" if county_name_60=="Newport News" & nstate==47;
  replace cntyname="NORFOLK CITY" if county_name_60=="Norfolk" & nstate==47;
  replace cntyname="NORTON CITY" if county_name_60=="Norton" & nstate==47;
  replace cntyname="PETERSBURG CITY" if county_name_60=="Petersburg" & nstate==47;
  replace cntyname="PORTSMOUTH CITY" if county_name_60=="Portsmouth" & nstate==47;
  replace cntyname="RADFORD CITY" if county_name_60=="Radford" & nstate==47;
  replace cntyname="RICHMOND CITY" if county_name_60=="Richmond" & nstate==47 & ncnty60==122;
  replace cntyname="ROANOKE CITY" if county_name_60=="Roanoke" & nstate==47 & ncnty60==123;
  replace cntyname="SOUTH BOSTON CITY" if county_name_60=="South Boston" & nstate==47;
  replace cntyname="STAUNTON CITY" if county_name_60=="Staunton" & nstate==47;
  replace cntyname="SUFFOLK CITY" if county_name_60=="suffolk" & nstate==47;
  replace cntyname="VIRGINIA BEACH CITY" if county_name_60=="Virginia Beach" & nstate==47;
  replace cntyname="WAYNESBORO CITY" if county_name_60=="Waynesboro" & nstate==47;
  replace cntyname="WILLIAMSBURG CITY" if county_name_60=="Williamsburg" & nstate==47;
  replace cntyname="WINCHESTER CITY" if county_name_60=="Winchester" & nstate==47;
  replace cntyname="PEPIN" if county_name_60=="0471Pepin" & nstate==50;

  sort nstate cntyname;
  save `tffull', replace;

/* Format county cross walk */

  use /3310/research/foodstamps/vitals_mortality/cwalk/cwalkpre68/octcwalk/cwalkpre68;
  drop if fstate==2;

  * somehow the 1960 povrates includes a rate for a county not created until 1963;
  replace year = 1960 if year==1963 & fstate==51 & fcounty==550;

  keep if year==1960;
  rename fstate stfips;
  rename fcounty countyfips;
  keep nstate stabb ncnty60 stfips countyfips cntyname;
  replace cntyname = upper(cntyname);
  replace cntyname="BRONX" if stfips==36 & countyfips==5;
  replace cntyname="KINGS" if stfips==36 & countyfips==47;
  replace cntyname="NEW YORK" if stfips==36 & countyfips==61;
  replace cntyname="RICHMOND" if stfips==36 & countyfips==85;
  replace cntyname="QUEENS" if stfips==36 & countyfips==81;
  sort nstate cntyname;
  save `tfcwalk', replace;

/* First Pass Merge */

  use `tffull';
  merge nstate cntyname using `tfcwalk';
  tab _merge;
  save `tffull', replace;

/* Second Pass Merge */

  * Second pass is going to use codes, since there are a lot of misspelled counties in Doug's data;
  keep if _merge==2;
  keep nstate stabb ncnty60 cntyname stfips countyfips;
  sort nstate ncnty60;
  save `tfcwalk', replace;

  use `tffull';
  keep if _merge==3;
  save `tfmatched', replace;

  use `tffull';
  keep if _merge==1;
  keep oldcode pop60 povrate60 county_name_60 nstate ncnty60;
  sort nstate ncnty60;
  merge nstate ncnty60 using `tfcwalk';
  tab _merge;
  list povrate60 county_name nstate ncnty60 cntyname countyfips if _merge!=3;

/* Concatenate first and second merges */

  append using `tfmatched';
  save `tffull', replace;
  keep if _merge==3|_merge==1;
  list pop60 nstate county_name_60 cntyname if _merge!=3;

  sort stfips countyfips;

  summ;
  drop _merge;

  save temp, replace;

/* Make the quartiles */

  xtile quartilepov60 = povrate60 [weight=pop60], nquantiles(4);

  for num 1/4: sum povrate60 if quartilepov==X [weight=pop60];

  list if quartilepov==.;
  drop if quartilepov==.;

  keep stfips countyfips quartilepov60;
  sort stfips countyfips;

  save povquart60, replace;


**********************;
* 1970 poverty rates  ;
***********************;

  use /3320/research/foodstamps/census/data_poverty/poverty1970.dta, clear;

  rename population pop70;
  rename PrctFamsInPov povrate70;
  rename PrctFamsWKidsUnder6InPov povratekids70;

  keep stfips countyfips pop70 povrate70 povratekids70;

  sort stfips countyfips;

  merge stfips countyfips using temp;

  tab _merge;
  /* _merge=1 missing from 60 file */
  list stfips countyfips povrate60 povrate70 if _merge==1;
  /* _merge=2 missing from 70 file */
  list stfips countyfips povrate60 povrate70 if _merge==2;

  corr povrate60 povrate70 [weight=pop70];


 /* Make the quartiles */

  xtile quartilepov70 = povrate70 [weight=pop70], nquantiles(4);

  for num 1/4: sum povrate70 if quartilepov70==X [weight=pop70];

  list if quartilepov70==.;
  drop if quartilepov70==.;

  xtile quartilepovkids70 = povratekids70 [weight=pop70], nquantiles(4);

  for num 1/4: sum povratekids70 if quartilepovkids70==X [weight=pop70];

  list if quartilepovkids70==.;
  drop if quartilepovkids70==.;

  keep stfips countyfips quartilepov70 quartilepovkids70;
  sort stfips countyfips;

  save povquart70, replace;
 
  log close;

*****************;
* End of Dofile *;
*****************;
