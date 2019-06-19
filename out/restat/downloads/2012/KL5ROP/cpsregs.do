/*
The October CPS for each year from 1995 to 2003 was downloaded from the NBER website.
The variable names should mostly be self-explanatory.
The weights employed are the CPS's "final weight."
The state variable contains FIPS codes.
The data set only includes individuals who are 18 years old.
You will need to set the directory or change the file name in the "use" line in order to run this program.
This program was written for Stata 11.
*/

clear
set more off
use cpsdata.dta

drop if state==01|state==13|state==26|state==22|state==28

gen urm = black + hispanic + nativeam

gen ban = 0
replace ban = 1 if state==6 & year >= 1998
replace ban = 1 if state==12 & year >= 2001
replace ban = 1 if state == 48 & year >= 1997
replace ban = 1 if state == 53 & year >= 1999

*TABLE 1 (top)
summarize college collegepublic college4yr college4yrpublic male [aw = weight] if white == 1 | urm == 1
summarize college collegepublic college4yr college4yrpublic male [aw = weight] if white == 1 & weight ~= 0
summarize college collegepublic college4yr college4yrpublic male [aw = weight] if urm == 1 & weight ~= 0

*TABLE 3 (top)
xi: reg college ban male i.year i.state if urm == 1 & weight ~= 0, cluster(state)
xi: reg collegepublic ban male i.year i.state if urm == 1 & weight ~= 0, cluster(state)
xi: reg college4yr ban male i.year i.state if urm == 1 & weight ~= 0, cluster(state)
xi: reg college4yrpublic ban male i.year i.state if urm == 1 & weight ~= 0, cluster(state)
xi: reg college ban male i.year i.state*year if urm == 1 & weight ~= 0, cluster(state)
xi: reg collegepublic ban male i.year i.state*year if urm == 1 & weight ~= 0, cluster(state)
xi: reg college4yr ban male i.year i.state*year if urm == 1 & weight ~= 0, cluster(state)
xi: reg college4yrpublic ban male i.year i.state*year if urm == 1 & weight ~= 0, cluster(state)
xi: reg college ban male i.year i.state if white == 1 & weight ~= 0, cluster(state)
xi: reg collegepublic ban male i.year i.state if white == 1 & weight ~= 0, cluster(state)
xi: reg college4yr ban male i.year i.state if white == 1 & weight ~= 0, cluster(state)
xi: reg college4yrpublic ban male i.year i.state if white == 1 & weight ~= 0, cluster(state)
xi: reg college ban male i.year i.state*year if white == 1 & weight ~= 0, cluster(state)
xi: reg collegepublic ban male i.year i.state*year if white == 1 & weight ~= 0, cluster(state)
xi: reg college4yr ban male i.year i.state*year if white == 1 & weight ~= 0, cluster(state)
xi: reg college4yrpublic ban male i.year i.state*year if white == 1 & weight ~= 0, cluster(state)
