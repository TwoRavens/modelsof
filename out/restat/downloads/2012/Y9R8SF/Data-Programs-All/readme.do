****************************************************
* readme.do                                        *
* This file should be in the foodstamps/mortality  *
* folder.  Readme.do can run the data creation     *
* files.                                           *
****************************************************

#delimit;
set more off;
clear;
set mem 2000m;

*********************************************************
* makemort.do                                           *
*                                                       *
* Dofile Outline:                                       *
* 1. define program varcollapse to                      *
*    a. merge in the FIPS codes                         *
*    b. recode cause of death to Hilary's specification *
*    c. determine month and year of birth               *
*    d. create two collapsed files, one with "born on"  *
*       dates and one with "died on" dates              *
* 2. format the crosswalk file                          *
* 3. run countyfix.do on the crosswalk file             *
* 4. run through each year                              *
*    a. read in the data                                *
*    b. run varcollapse                                 *
* 5. merge "born on" and "died on" files                *
*********************************************************;

do /3310/research/foodstamps/vitals_mortality/dofiles/makemort.do;

*********************************************************
* mergemort.do                                          *
*                                                       *
* Dofile Outline:                                       *
* 1. append 1968-1978 files                             *
* 2. Make two denominators for death outcomes		*
*    "born on" divide deaths by births at time of birth	*
*    "died on" divide deaths by births at time of death	*
* 3. merge in FS caseloads for each year, and racial    *
*    characteristics for (unspecified year?)            *
* 4. merge in county characteristics from the 1960      *
*    county book (racial, employment, income, farmland) *
*********************************************************;

do /3310/research/foodstamps/vitals_mortality/dofiles/mergemort.do;

