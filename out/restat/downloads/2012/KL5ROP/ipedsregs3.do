/*
IPEDS data were downloaded from the National Center for Education Statistics' website for each year other than 1999.
IPEDS institutional characteristics data were merged to IPEDS enrollment data on full-time, first-time, undergraduate, degree-seeking students by race.
IPEDS data for 1999 were not available online at the time I began this study; I received 1999 IPEDS data from Thomas Snyder at the National Center for Education Statistics.
IPEDS data for 1999 are now available online.
US News data from 1995 were hand-entered and merged.
See p. 719 of the paper describing state per capita income and racial composition data that were also merged in.
The variable names should mostly be self-explanatory, and variables are labeled.
You will need to set the directory or change the file name in the "use" line in order to run this program.
You will need to install the "synth" package before running this program.  Please see directions at http://www.mit.edu/~jhainm/synthpage.html
This program was written for Stata 11.
*/


use ipedsdata3.dta

drop if fips > 56
drop if fips == 1|fips==13|fips==22|fips==26|fips==28

*this takes the raw IPEDS data and generates the enrollment variables I use
gen pctblack = 100*efrace18/(efrace24-efrace23)
gen pcthisp = 100*efrace21/(efrace24-efrace23)
gen pctasian = 100*efrace20/(efrace24-efrace23)
gen pctna = 100*efrace19/(efrace24 - efrace23)
gen totalenrollment = efrace24
replace efrace05 = 0 if efrace05 == .
replace pctblack = 100*(efrace03+efrace04)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pcthisp = 100*(efrace09+efrace10)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pctasian = 100*(efrace07+efrace08)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace pctna = 100*(efrace05+efrace06)/(efrace15+efrace16-efrace13-efrace14) if year == 1999
replace totalenrollment = efrace15 + efrace16 if year == 1999
gen pcturm = pctblack + pcthisp + pctna

*this keeps only obs that have race data for every year, drops hbcus, and keeps institutions in the top two tiers of the 1995 US News rankings (the "yield" variable is non-missing only for these institutions)
sort unitid
by unitid: egen racecount = count(pcturm)
keep if hbcu ~= 1
keep if racecount == 16
keep if yield ~= .
tsset unitid year

/*
IMPORTANT NOTE:
Running the rest of the program as written will generate Figure 1 and the left part of Table 8.
To generate Figure 2 and the right part of Table 8, please change the lines that are commented out in the two spots below.
*/
tempfile stuffs
keep if rank ~= . & rank < 48
*keep if rank == . | (rank > 43 & rank < 51)
save "`stuffs'"
sort year
collapse (mean) pcturm pci1995 urm1990 [aw=totalenrollment] if unitid == 110635|unitid == 110662|unitid == 110644|unitid == 110680, by(year)
*collapse (mean) pcturm pci1995 urm1990 [aw=totalenrollment] if unitid == 110653|unitid == 110775|unitid == 110671|unitid == 110714, by(year)
gen unitid = 1
append using "`stuffs'"
drop if (fips==6|fips==12|fips==48|fips==53) 

*FIGURE 1, FIGURE 2, AND TABLE 8
synth pcturm pcturm(1986) pcturm(1988) pcturm(1990) pcturm(1991) pcturm(1992) pcturm(1993) pcturm(1994) pcturm(1995) pcturm(1996) pcturm(1997) pci1995(1995) urm1990(1995), trunit(1) trperiod(1998) figure nested

