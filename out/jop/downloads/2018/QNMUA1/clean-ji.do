
 
**BEGIN**
clear

import excel "JI_2012.xlsx", sheet("JI_csv.txt") firstrow

rename ccode cowcode 

* Note that Yemen Arab Republic and Yemen exist in 1990, so one must be dropped. I drop 1990 for YAR.
* Find where the cowcode year observations are not unique identifiers
bysort cow: gen repeat = year==year[_n-1] if cow==cow[_n-1]
tab country if repeat==1
* Turns out GFR is coded 255 1949-1990 and overlaps "Germany" which is coded 255 from 1980-2012.
* GWF has GFR through 1989 and then Germany 1990-2012
drop if country == "Germany" & year <= 1989 /* match to GWF coding */
drop if country == "German Federal Republic" & year >= 1990

drop if cowcode == 678 & year == 1990
replace cowcode = 678 if cowcode ==679 & year>=1990  /*recode all Yemen to N Yemen cowcode*/
recode cowcode (260=255) /*recode all Germany to West Germany cowcode*/
recode cowcode (364=365) if year<=1991  /* Russia/Soviet Union */

rename country ji_country
rename abbr ji_abbr
rename LJI lji
rename postsd postsd

drop repeat

sort cowcode year   
save ji-merge, replace

**END**
