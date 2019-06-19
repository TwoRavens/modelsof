/*
IPEDS data were downloaded from the National Center for Education Statistics' website.
IPEDS institutional characteristics data were merged to IPEDS residence and migration data.
US News data from 1995 were hand-entered and merged.
The variable names should mostly be self-explanatory, and variables are labeled.
Note that the unit of observation in the data set is a (college, stateofresidence) pair.
You will need to set the directory or change the file name in the "use" line in order to run this program.
This program was written for Stata 11.
*/

use ipeds2.dta

/*
IMPORTANT NOTE:
Running the rest of the program as written will generate the first column of Table 7.
To generate the other columns, please change the line that is not commented out in the block of code below.
*/
keep if all4yr == 1
*keep if public4yr == 1
*keep if usnews == 1
*keep if publicusnews == 1
*keep if usnewstop50 == 1
*keep if publicusnewstop50 == 1

keep if efcstate < = 56
gen samestate = (fips == efcstate)
gen ownstatecount = samestate*efres01

*collapse the data to the level of the sending state
collapse (sum) efres01 ownstatecount, by(efcstate year)
gen pctinstate = 100*ownstatecount / efres01

*generate the affirmative action ban dummy
gen ban = 0
replace ban = 1 if efcstate == 6 & year >= 1998
replace ban = 1 if efcstate == 12 & year >= 2001
replace ban = 1 if efcstate == 48 & year >= 1997
replace ban = 1 if efcstate == 53 & year >= 1999

*TABLE 7
summarize pctinstate [aw = efres01]
xi: reg pctinstate ban i.year i.efcstate*year [aw = efres01], cluster(efcstate)


