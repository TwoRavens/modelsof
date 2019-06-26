* UCDP Data Set up
* Peter Rudloff and Michael Findley
* Last Updated: October 7, 2015
* Analysis run with Stata 12.1 on a Mac


***********
* Indicate directory
***********

cd "SET PATH HERE"

***********
* Open Log
***********

log using "ucdpdatasetup.log", replace

***********
* Import data to merge
***********

insheet using NMC_v4_0.csv
drop irst milex milper tpop upop cinc version stateabb
sort ccode year
save cowelectricity.dta, replace

***********
* Import data from Rustad and Binningsbo (2012)
***********

use "Rustad_Binningsbo_JPR_49(4).dta"


***********
* Drop Analysis Specific Variables from Rustad and Binningsbo
***********

drop _st _d _t _t0 _origin

***********
* Import additional data
***********

* Import COW electricity data
sort ccode year
merge ccode year using cowelectricity.dta

***********
** Create averaged variables for analysis
***********
sort pperid

* Average primary commodity exports (Collier et. al.)
by pperid: egen pce = mean(i_sxp_may06)

* Average ethnic factionalization
by pperid: egen fractional = mean(ethfrac)

* UN peacekeeping?
by pperid: egen un = max(unoper)

* Victory?
by pperid: egen vict = max(victory)

* Electricity
by pperid: egen cowelectric = mean(pec)
replace cowelectric = cowelectric/1000000

* Copy Peace Failure date
gen failuredate = peacefail
format failuredate %td

***********
* Drop duplicate observations
***********

duplicates drop pperid sideb, force

***********
* Create failure variable and censoring variable
***********

*drop censor
gen cwrightcensored = 0
replace cwrightcensored = 1 if victory==.

***********
* Create number of factions variable (number of nonstate sideb actors)
***********

gen factions = 1
replace factions = 2 if pperid=="103_1975"
replace factions = 4 if pperid=="103_1998"
replace factions = 2 if pperid=="112_1990"
replace factions = 4 if pperid=="112_2006"
replace factions = 2 if pperid=="113_2006"
replace factions = 2 if pperid=="118_1974"
* Did not include "various organizations" for 118_1991 pperid
replace factions = 4 if pperid=="118_1991"
replace factions = 3 if pperid=="12-1947"
replace factions = 6 if pperid=="120_1991"
replace factions = 2 if pperid=="122_1979"
replace factions = 2 if pperid=="129_2006"
replace factions = 4 if pperid=="131_1995"
replace factions = 6 if pperid=="141_1996"
replace factions = 2 if pperid=="141_2006"
replace factions = 2 if pperid=="143_2006"
replace factions = 2 if pperid=="146_1995"
replace factions = 3 if pperid=="150_1988"
replace factions = 3 if pperid=="152_2000"
replace factions = 3 if pperid=="157_2006"
replace factions = 2 if pperid=="178_1994"
replace factions = 2 if pperid=="185_1993"
replace factions = 3 if pperid=="186_1991"
replace factions = 2 if pperid=="186_2004"
replace factions = 4 if pperid=="191_2006"
replace factions = 2 if pperid=="192_1998"
replace factions = 2 if pperid=="192_2004"
replace factions = 2 if pperid=="193_1994"
replace factions = 2 if pperid=="193_2005"
* Included both "Serbian Republic of Bosnia-Herzegovina" and "Serb irregulars"
replace factions = 2 if pperid=="194_1995"
replace factions = 2 if pperid=="200_1998"
replace factions = 2 if pperid=="201_1995"
* Included both "Croatioan Republic of Bosnia and Herzegovina" and "Croation irregulars"
replace factions = 2 if pperid=="203_1994"
replace factions = 2 if pperid=="212_1997"
replace factions = 2 if pperid=="214_1994"
replace factions = 3 if pperid=="214_1999"
replace factions = 2 if pperid=="216_1999"
* For pperid 22_1947, I coded "Opposition coalition (Febreristas, Liberals and Communists)" as 1 faction
replace factions = 2 if pperid=="222_2002"
replace factions = 3 if pperid=="225_2004"
replace factions = 3 if pperid=="24_1994"
replace factions = 2 if pperid=="25_1994"
replace factions = 2 if pperid=="29_1972"
replace factions = 5 if pperid=="29_2006"
* For pperid 32_1950, I coded "Leftist insurgents (e.g. Inmin-gun: Peoples Army, military faction)" as 2 factions
replace factions = 2 if pperid=="32_1950"
replace factions = 6 if pperid=="36_1995"
replace factions = 5 if pperid=="37_1996"
replace factions = 4 if pperid=="37_2006"
replace factions = 3 if pperid=="46_1961"
replace factions = 2 if pperid=="50_1977"
replace factions = 2 if pperid=="62_1959"
* Did not include "various groups" in pperid 62_2006
replace factions = 3 if pperid=="62_2006"
* Coded "Lebanese Army (Aoun), Lebanese Forces" as 2 factions for pperid 63_1990
replace factions = 2 if pperid=="63_1990"
replace factions = 2 if pperid=="65_1973"
replace factions = 3 if pperid=="67_1970"
replace factions = 4 if pperid=="67_1988"
replace factions = 2 if pperid=="67_2002"
replace factions = 5 if pperid=="70_1991"
replace factions = 2 if pperid=="74_1993"
replace factions = 3 if pperid=="78_1991"
* Inlcuded both "Opposition militias" and "CNL" in pperid 86_1967
replace factions = 2 if pperid=="86_1967"
replace factions = 3 if pperid=="86_2001"
replace factions = 2 if pperid=="90_2006"
* Did not include "Various groups" in pperid 91_1994
replace factions = 7 if pperid=="91_1994"
replace factions = 3 if pperid=="91_2002"
replace factions = 3 if pperid=="91_2006"
replace factions = 8 if pperid=="92_2006"
replace factions = 3 if pperid=="95_1966"
replace factions = 2 if pperid=="95_1999"


***********
* Create fragmentation variable
***********

gen fragmentation = 0
replace fragmentation = 1 if pperid=="23_1992"
replace fragmentation = 1 if pperid=="24_1994"
replace fragmentation = 1 if pperid=="26_1963"
* Did not code fragmention for PNDF in conflict ID 34 - no reliable date of fragmentation
replace fragmentation = 1 if pperid=="37_1996"
* Did not code fragmentation for NSCN - IM in conflict ID 54 - appears to have occured between civil wars
replace fragmentation = 1 if pperid=="56_1957"
replace fragmentation = 1 if pperid=="63_1990"
* Did not code fragmentation for Pathet Lao in conflict ID 65 - occurred before start of war
replace fragmentation = 1 if pperid=="67_1970"
replace fragmentation = 1 if pperid=="67_2002"
replace fragmentation = 1 if pperid=="70_1991"
replace fragmentation = 1 if pperid=="74_1993"
replace fragmentation = 1 if pperid=="78_1991"
replace fragmentation = 1 if pperid=="86_2001"
replace fragmentation = 1 if pperid=="90_2006"
replace fragmentation = 1 if pperid=="91_1994"
replace fragmentation = 1 if pperid=="112_1990"
replace fragmentation = 1 if pperid=="112_2006"
* Did not code fragmention for SLM/A-Unity in Conflict ID 113 - no firm date for fragmentation
replace fragmentation = 1 if pperid=="118_1991"
replace fragmentation = 1 if pperid=="118_2006"
* Real IRA could be coded either way for Conflict ID 119
replace fragmentation = 1 if pperid=="119_1998"
replace fragmentation = 1 if pperid=="137_2006"
* Did not code fragmentation for NLFT in COnflict ID 139 - appears to have occurred between conflicts
replace fragmentation = 1 if pperid=="141_1996"
replace fragmentation = 1 if pperid=="146_1995"
* DId not code fragmentation for FIAA in Conflict ID 177 - best date for fragmentation is 1990, conflict from August 1 to December 31 1990
replace fragmentation = 1 if pperid=="184_1994"
* Did not code fragmantation for WSB in Conflict ID 187 - best date for fragmentation is 2000, conflict from April 1, 1991 to November 10, 2000
replace fragmentation = 1 if pperid=="191_2006"
replace fragmentation = 1 if pperid=="214_1999"
* Did not code fragmenation for UWSA in Conflict ID 228 - fragmentation appeasr to have occured before conflict

*** NOTE: The following fragmented groups did not have a conflict ID associated with them - coded based on location and years
replace fragmentation = 1 if pperid=="137_2006"
replace fragmentation = 1 if pperid=="146_1995"
replace fragmentation = 1 if pperid=="180_2001"

***********
* Create peace failure variable
***********

gen peacefailure = 0
replace peacefailure = 1 if pperid=="1_1946"
replace peacefailure = 1 if pperid=="1_1952"
replace peacefailure = 1 if pperid=="6_1946"
replace peacefailure = 1 if pperid=="6_1968"
replace peacefailure = 1 if pperid=="6_1990"
replace peacefailure = 1 if pperid=="6_1993"
replace peacefailure = 1 if pperid=="10_1954"
replace peacefailure = 1 if pperid=="10_1995"
replace peacefailure = 1 if pperid=="22_1947"
replace peacefailure = 1 if pperid=="22_1954"
replace peacefailure = 1 if pperid=="23_1992"
replace peacefailure = 1 if pperid=="25_1998"
replace peacefailure = 1 if pperid=="26_1963"
replace peacefailure = 1 if pperid=="26_1990"
replace peacefailure = 1 if pperid=="29_1951"
replace peacefailure = 1 if pperid=="29_1972"
replace peacefailure = 1 if pperid=="33_1948"
replace peacefailure = 1 if pperid=="33_1970"
replace peacefailure = 1 if pperid=="34_1949"
replace peacefailure = 1 if pperid=="36_1949"
replace peacefailure = 1 if pperid=="36_1954"
replace peacefailure = 1 if pperid=="37_1996"
replace peacefailure = 1 if pperid=="39_1950"
replace peacefailure = 1 if pperid=="39_1956"
replace peacefailure = 1 if pperid=="43_1982"
replace peacefailure = 1 if pperid=="45_1953"
replace peacefailure = 1 if pperid=="45_1958"
replace peacefailure = 1 if pperid=="46_1953"
replace peacefailure = 1 if pperid=="50_1955"
replace peacefailure = 1 if pperid=="50_1963"
replace peacefailure = 1 if pperid=="54_1968"
replace peacefailure = 1 if pperid=="54_1997"
replace peacefailure = 1 if pperid=="54_2000"
replace peacefailure = 1 if pperid=="56_1957"
replace peacefailure = 1 if pperid=="56_1992"
replace peacefailure = 1 if pperid=="56_1996"
replace peacefailure = 1 if pperid=="62_1959"
replace peacefailure = 1 if pperid=="62_1963"
replace peacefailure = 1 if pperid=="62_1984"
replace peacefailure = 1 if pperid=="62_1987"
replace peacefailure = 1 if pperid=="62_1996"
replace peacefailure = 1 if pperid=="63_1958"
replace peacefailure = 1 if pperid=="64_1960"
replace peacefailure = 1 if pperid=="64_1975"
replace peacefailure = 1 if pperid=="65_1973"
replace peacefailure = 1 if pperid=="67_1970"
replace peacefailure = 1 if pperid=="67_1988"
replace peacefailure = 1 if pperid=="67_2002"
replace peacefailure = 1 if pperid=="70_1960"
replace peacefailure = 1 if pperid=="72_1962"
replace peacefailure = 1 if pperid=="74_1970"
replace peacefailure = 1 if pperid=="74_1993"
replace peacefailure = 1 if pperid=="80_1962"
replace peacefailure = 1 if pperid=="86_1967"
replace peacefailure = 1 if pperid=="86_1978"
replace peacefailure = 1 if pperid=="90_1965"
replace peacefailure = 1 if pperid=="91_1994"
replace peacefailure = 1 if pperid=="91_2002"
replace peacefailure = 1 if pperid=="94_1969"
replace peacefailure = 1 if pperid=="95_1966"
replace peacefailure = 1 if pperid=="98_1966"
replace peacefailure = 1 if pperid=="102_1966"
replace peacefailure = 1 if pperid=="103_1975"
replace peacefailure = 1 if pperid=="111_1970"
replace peacefailure = 1 if pperid=="112_1990"
replace peacefailure = 1 if pperid=="113_1971"
replace peacefailure = 1 if pperid=="113_1976"
replace peacefailure = 1 if pperid=="117_1971"
replace peacefailure = 1 if pperid=="118_1974"
replace peacefailure = 1 if pperid=="118_1991"
replace peacefailure = 1 if pperid=="119_1991"
replace peacefailure = 1 if pperid=="120_1972"
replace peacefailure = 1 if pperid=="129_1977"
replace peacefailure = 1 if pperid=="130_1999"
replace peacefailure = 1 if pperid=="131_1995"
replace peacefailure = 1 if pperid=="133_1983"
replace peacefailure = 1 if pperid=="134_1989"
replace peacefailure = 1 if pperid=="134_1992"
replace peacefailure = 1 if pperid=="139_1988"
replace peacefailure = 1 if pperid=="139_1993"
replace peacefailure = 1 if pperid=="140_1979"
replace peacefailure = 1 if pperid=="141_1978"
replace peacefailure = 1 if pperid=="141_1996"
replace peacefailure = 1 if pperid=="143_1982"
replace peacefailure = 1 if pperid=="143_1988"
replace peacefailure = 1 if pperid=="143_1993"
replace peacefailure = 1 if pperid=="143_2001"
replace peacefailure = 1 if pperid=="146_1980"
replace peacefailure = 1 if pperid=="146_1995"
replace peacefailure = 1 if pperid=="147_1981"
replace peacefailure = 1 if pperid=="147_1987"
replace peacefailure = 1 if pperid=="152_1988"
replace peacefailure = 1 if pperid=="152_2000"
replace peacefailure = 1 if pperid=="163_1986"
replace peacefailure = 1 if pperid=="168_1991"
replace peacefailure = 1 if pperid=="170_1991"
replace peacefailure = 1 if pperid=="171_1991"
replace peacefailure = 1 if pperid=="177_1990"
replace peacefailure = 1 if pperid=="178_1994"
replace peacefailure = 1 if pperid=="179_1994"
replace peacefailure = 1 if pperid=="180_2001"
replace peacefailure = 1 if pperid=="184_1994"
replace peacefailure = 1 if pperid=="186_1991"
replace peacefailure = 1 if pperid=="188_1992"
replace peacefailure = 1 if pperid=="192_1991"
replace peacefailure = 1 if pperid=="192_1998"
replace peacefailure = 1 if pperid=="193_1994"
replace peacefailure = 1 if pperid=="198_1992"
replace peacefailure = 1 if pperid=="205_1994"
replace peacefailure = 1 if pperid=="206_1996"
replace peacefailure = 1 if pperid=="209_1990"
replace peacefailure = 1 if pperid=="214_1994"
replace peacefailure = 1 if pperid=="214_1999"
replace peacefailure = 1 if pperid=="219_1991"
replace peacefailure = 1 if pperid=="221_2000"
replace peacefailure = 1 if pperid=="222_2002"
replace peacefailure = 1 if pperid=="227_1990"

***********
* Create peace duration variable
***********

gen peaceduration = failuredate - ependdate
replace peaceduration=. if peaceduration<=0

***********
* Save data
***********

save "ucdpreplication.dta", replace

***********
* Close log file and clear data
***********

log close
clear
exit




