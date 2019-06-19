/*
The 2005, 2006, and 2007 ACS were downloaded from IPUMS.
The variable names should mostly be self-explanatory.
The "yearat18" variable is described in footnote 8 of the paper.
The weights employed are the person weights.
The "stateofbirth" variable contains FIPS codes.
This data set only includes individuals who were born in the US and for whom "yearat18" is between 1995-2003 (inclusive).
You will need to set the directory or change the file name in the "use" line in order to run this program.
This program was written for Stata 11.
*/

clear
set more off
set mem 745m
use acsdata.dta

drop if stateofbirth==01|stateofbirth==13|stateofbirth==26|stateofbirth==22|stateofbirth==28

gen urm = black+hispanic+nativeam

gen ban = 0
replace ban = 1 if stateofbirth == 6 & yearat18 >= 1998
replace ban = 1 if stateofbirth == 12 & yearat18 >= 2001
replace ban = 1 if stateofbirth == 48 & yearat18 >= 1997
replace ban = 1 if stateofbirth == 53 & yearat18 >= 1999

*TABLE 1 (bottom)
summarize college associatedegree bachelorsplus male [aw = weight]
summarize college associatedegree bachelorsplus male [aw = weight] if white == 1
summarize college associatedegree bachelorsplus male [aw = weight] if urm == 1

*TABLE 3 (bottom)
xi: reg college ban i.stateofbirth i.yearat18 male if urm == 1, cluster(stateofbirth)
xi: reg associatedegree ban i.stateofbirth i.yearat18 male if urm == 1, cluster(stateofbirth)
xi: reg bachelorsplus ban i.stateofbirth i.yearat18 male if urm == 1, cluster(stateofbirth)
xi: reg college ban i.yearat18 male i.stateofbirth*yearat18 if urm == 1, cluster(stateofbirth)
xi: reg associatedegree ban i.yearat18 male i.stateofbirth*yearat18 if urm == 1, cluster(stateofbirth)
xi: reg bachelorsplus ban i.yearat18 male i.stateofbirth*yearat18 if urm == 1, cluster(stateofbirth)
xi: reg college ban i.stateofbirth i.yearat18 male if white == 1, cluster(stateofbirth)
xi: reg associatedegree ban i.stateofbirth i.yearat18 male if white == 1, cluster(stateofbirth)
xi: reg bachelorsplus ban i.stateofbirth i.yearat18 male if white == 1, cluster(stateofbirth)
xi: reg college ban i.yearat18 male i.stateofbirth*yearat18 if white == 1, cluster(stateofbirth)
xi: reg associatedegree ban i.yearat18 male i.stateofbirth*yearat18 if white == 1, cluster(stateofbirth)
xi: reg bachelorsplus ban i.yearat18 male i.stateofbirth*yearat18 if white == 1, cluster(stateofbirth)

