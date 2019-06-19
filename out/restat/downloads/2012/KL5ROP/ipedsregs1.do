/*
IPEDS data were downloaded from the National Center for Education Statistics' website for each year other than 1999.
IPEDS institutional characteristics data were merged to IPEDS enrollment data on full-time, first-time, undergraduate, degree-seeking students by race.
IPEDS data for 1999 were not available online at the time I began this study; I received 1999 IPEDS data from Thomas Snyder at the National Center for Education Statistics.
IPEDS data for 1999 are now available online.
US News data from 1995 were hand-entered and merged.
The variable names should mostly be self-explanatory, and variables are labeled.
You will need to set the directory or change the file name in the "use" line in order to run this program.
This program was written for Stata 11.
*/
set mem 600m
set matsize 10000
use ipedsdata1.dta

drop if fips > 56
drop if fips==01|fips==13|fips==26|fips==22|fips==28

*this takes the raw IPEDS data and generates the enrollment variables I use
gen pctwhite = 100*efrace22/(efrace24 - efrace23)
gen pctblack = 100*efrace18/(efrace24 - efrace23)
gen pcthisp = 100*efrace21/(efrace24 - efrace23)
gen pctasian = 100*efrace20/(efrace24 - efrace23)
gen pctna = 100*efrace19/(efrace24 - efrace23)
gen totalenrollment = efrace24
replace pctwhite = 100*(efrace11+efrace12)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pctblack = 100*(efrace03+efrace04)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pcthisp = 100*(efrace09+efrace10)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pctasian = 100*(efrace07+efrace08)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pctna = 100*(efrace05+efrace06)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace totalenrollment = efrace15 + efrace16 if year == 1999

*this defines the "ban" dummy, as well as the interactions that are used in Table 6
gen ban = 0
replace ban = 1 if fips == 6 & year >= 1998
replace ban = 1 if fips == 12 & year >= 2001
replace ban = 1 if fips == 48 & year >= 1997
replace ban = 1 if fips == 53 & year >= 1999
gen banadmit = ban*acceptancerate
gen bansat = ban*sat

*this will drop obs that have missing or inconsistent data
gen diff1 =  efrace24 - efrace17 - efrace18 - efrace19 - efrace20 - efrace21 - efrace22 - efrace23
drop if diff1 ~= 0 & year ~= 1999
gen diff2 =  efrace16 - efrace12 - efrace04 - efrace10 - efrace08 - efrace06 - efrace14 - efrace02
drop if diff2 ~= 0
gen diff3 = efrace15 - efrace11 - efrace03 - efrace09 - efrace07 - efrace05 - efrace13 - efrace01
drop if diff3 ~= 0 & year == 1999
drop if pctwhite == .

*this defines the various categories of universities
gen all4yr = (sector >= 1 & sector <= 3)
gen public4yr = (sector == 1)
gen usnews = (yield ~= .)
gen publicusnews = (yield ~= . & sector == 1)
gen usnewstop50 = (rank ~= .)
gen publicusnewstop50 = (rank ~= . & sector == 1)

/*
IMPORTANT NOTE:
Running the rest of the program as written will generate the first column of Table 4 and Table 5.
To generate the other columns, please change the line that is not commented out in the block of code below.
*/
keep if all4yr == 1
*keep if public4yr == 1
*keep if usnews == 1
*keep if publicusnews == 1
*keep if usnewstop50 == 1
*keep if publicusnewstop50 == 1

*this drops schools that switch categories or that do not appear in the data every year, as well as HBCUs
sort unitid
by unitid: egen count = count(unitid)
drop if count ~= 9
keep if hbcu ~= 1

*TABLE 4
summarize pctblack pcthisp pctasian pctna pctwhite [aw = totalenrollment]

*TABLE 5
xi: reg pctasian ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctblack ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pcthisp ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctna ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctwhite ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)

*TABLE 6
*To generate Table 6, please remove the comments below and run the code using the "usnews" sample
/*xi: reg pctasian banadmit ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctblack banadmit ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pcthisp banadmit ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctna banadmit ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctwhite banadmit ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctasian bansat ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctblack bansat ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pcthisp bansat ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctna bansat ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
xi: reg pctwhite bansat ban i.unitid i.year i.fips*year [aw = totalenrollment], cluster(fips)
*/
