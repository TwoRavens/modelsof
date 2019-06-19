/* These are changes that make counties consistent
from 1940-2000.  Some are aggregated forwards, and 
some are aggregated backwards. */

replace cntyfips = 27 if cntyfips==12 & statefips==4
** Miami-Dade County changed its fips code in 1997, use old one
replace cntyfips = 25 if cntyfips==86 & statefips==12
replace cntyfips = 215 if cntyfips==510 & statefips==13 
replace cntyfips = 43 if cntyfips==89 & statefips==16
*Ste Genevieve Co, MO changed codes in 1980
replace cntyfips = 193 if cntyfips==186 & statefips==29
replace cntyfips = 510 if cntyfips==25 & statefips==32
*Los Alamos, NM => Sandoval -- split from Sandoval & Santa Fe in 1949
replace cntyfips = 43 if cntyfips==28 & statefips==35
replace cntyfips = 61 if cntyfips==6 & statefips==35
replace cntyfips = 55 if cntyfips==1 & statefips==46
replace cntyfips = 71 if cntyfips==131 & statefips==46
*Washington County, SD absorbed into Shannon County in 1941
replace cntyfips = 113 if cntyfips==133 & statefips==46
replace cntyfips = 29 if cntyfips==47 & statefips==56

replace cntyfips = 3 if cntyfips==540 & statefips==51
replace cntyfips = 5 if cntyfips==580 & statefips==51
replace cntyfips = 15 if cntyfips==790 & statefips==51
replace cntyfips = 15 if cntyfips==820 & statefips==51
replace cntyfips = 19 if cntyfips==515 & statefips==51
replace cntyfips = 41 if cntyfips==570 & statefips==51
replace cntyfips = 59 if cntyfips==600 & statefips==51
replace cntyfips = 59 if cntyfips==610 & statefips==51
replace cntyfips = 69 if cntyfips==840 & statefips==51
replace cntyfips = 77 if cntyfips==640 & statefips==51
replace cntyfips = 81 if cntyfips==595 & statefips==51
replace cntyfips = 83 if cntyfips==780 & statefips==51
replace cntyfips = 95 if cntyfips==830 & statefips==51
replace cntyfips = 121 if cntyfips==750 & statefips==51
**These are all consolidated into Norfolk and assigned
*code 129
replace cntyfips = 129 if cntyfips==550 & statefips==51
replace cntyfips = 129 if cntyfips==710 & statefips==51
replace cntyfips = 129 if cntyfips==740 & statefips==51
replace cntyfips = 129 if cntyfips==800 & statefips==51
replace cntyfips = 129 if cntyfips==810 & statefips==51
**
replace cntyfips = 143 if cntyfips==590 & statefips==51
**730 took part from 53 too but the 149 part is bigger
replace cntyfips = 149 if cntyfips==730 & statefips==51
replace cntyfips = 153 if cntyfips==683 & statefips==51
replace cntyfips = 153 if cntyfips==685 & statefips==51
replace cntyfips = 161 if cntyfips==770 & statefips==51
replace cntyfips = 161 if cntyfips==775 & statefips==51
replace cntyfips = 163 if cntyfips==530 & statefips==51
replace cntyfips = 163 if cntyfips==678 & statefips==51
replace cntyfips = 165 if cntyfips==660 & statefips==51
replace cntyfips = 175 if cntyfips==620 & statefips==51
replace cntyfips = 177 if cntyfips==630 & statefips==51
replace cntyfips = 191 if cntyfips==520 & statefips==51
replace cntyfips = 195 if cntyfips==720 & statefips==51
replace cntyfips = 199 if cntyfips==735 & statefips==51
**These counties existed in 1940 but don't exist today
*129 is a code resurrected for convenience
replace cntyfips = 129 if cntyfips==123 & statefips==51
replace cntyfips = 129 if cntyfips==154 & statefips==51
replace cntyfips = 129 if cntyfips==785 & statefips==51
replace cntyfips = 650 if cntyfips==55 & statefips==51
replace cntyfips = 700 if cntyfips==189 & statefips==51
replace cntyfips = 700 if cntyfips==815 & statefips==51

**Assign Menominee WI to Shawano - Menominee had been an indian reservation
replace cntyfips = 115 if cntyfips==78 & statefips==55



