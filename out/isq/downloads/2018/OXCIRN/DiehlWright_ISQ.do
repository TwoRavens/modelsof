***
*Getting Descriptive Stats for Diehl & Wright "A Conditional Defense of the Dyadic Approach"
*International Studies Quarterly
*Spring, 2015 (all data accessed in April 2015)
***

*For Table 1.

*import MID dispute level data

clear matrix
clear

cd "/Users/twrigh11/Dropbox/DiehlWrightDyadDefense/DiehlWrightFirstRound"

use "mid4a.dta"

*numa is number of states on side a, numb is number of states on side b

*generate a variable if there is only one state on each side

gen puredyadic=1 if (numa==1 & numb==1)

*recode missing to 0 for multilateral mids

recode puredyadic .=0

tab puredyadic

tab puredyadic if styear<1946
tab puredyadic if styear>1945 & styear<1990
tab puredyadic if styear>1989

**Shows roughly 85% of MIDs are between just two states


clear

*For the percentage of interstate wars that are dyadic.

**import COW interstate war data

use "cowinterstatewar.dta"

*this data is listed by participant, but also has a code for the war itself. If a war has more than two participants, then it should be multilateral

by warnum: gen participantcount=_n

*should be able to collapse on the max value of participant count to generate only the war and how many states participated in it. The range should be from 2-a lot.

collapse (max) participantcount, by (warnum)

*generate a variable coding which are purely dyadic

gen dyadicwar=1 if participantcount==2

recode dyadicwar .=0
tab dyadicwar

*60% are dyadic
clear

*For the percentage of civil conflicts that are purely dyadic.

**import UCDP data

use "ucdp2014.dta"

*drop all interstate and extrasystemic, keeping only internal and internationalized internal

keep if (type==3 | type==4)

*generate separate variables based on how many rebels groups side b has

split sidebid, p(",")

destring sidebid1 sidebid2 sidebid3 sidebid4 sidebid5 sidebid6, replace

*if there's at least one more actor in sideb then sidebid2 will not be zero, also if type is 4 at any time, another state has entered into it.

gen nondyadic=1 if sidebid2!=. 
recode nondyadic .=1 if type==4 
recode nondyadic .=0

*collapse by whether there is a multi-lateral conflict year during the course of the conflict

collapse (max) nondyadic, by (conflictid)

*what's left is one observation by conflict ID and whether it's got at least more than one rebel group or an external intervention in any year in the conflict. 

gen puredyadic=1 if nondyadic==0
recode puredyadic .=0
tab puredyadic

*puredyadic is the flip of nondyadic, roughly 55% of civil conflicts from 1946-2013 are purely dyadic for the entirety of the conflict. 

*find out the number of nondyadic India-Pakistan MIDs, and participant characteristics of Israel's MIDs, 
*using Gennady Rudkevich's dyadic version of MID 4.0 (source: https://sites.google.com/site/gennadyrudkevich/codes; April 20, 2015)

clear

use "MID4.0cleanedup.dta"

*generate a variable if there is only one state on each side

gen puredyadic=1 if (numa==1 & numb==1)

*recode missing to 0 for multilateral mids

recode puredyadic .=0

tab puredyadic

*Same number of disputes are purely dyadic as the dispute level data above (2,209)

*note that dyads are directional here, so India-Pakistan is both 750770 and 770750
gen dyad=(ccodea*1000)+ccodeb

gen indiapakistan=1 if dyad==750770
recode indiapakistan .=1 if dyad==770750

*for Israel-Jordan
gen israeljordan=1 if dyad==666663
recode israeljordan .=1 if dyad==663666


*for Egypt-Israel
gen israelegypt=1 if dyad==666651
recode israelegypt .=1 if dyad==651666


*for Israel-Syria
gen israelsyriat=1 if dyad==666652
recode israelsyria .=1 if dyad==652666


tab indiapakistan puredyadic

tab israeljordan puredyadic 

tab israelegypt puredyadic 

tab israelsyria puredyadic

*check number of israel-jordan MIDs also involving Syria and Egypt (just compare where the MID numbers line up)
*MIDs: 1035, 1046, 1793, 3412 involved Jordan, Syria and Egypt against Israel
* MIDs 353,3405,3419,3429,3431 include Syria and Egypt, but not Jordan
list dispnum3 if israeljordan==1 & puredyadic==0 
list dispnum3 if israelegypt==1 & puredyadic==0
list dispnum3 if israelsyria==1 & puredyadic==0

*check to see if those Israel-Egypt and Israel-Syria MIDs only had those two states against Israel

list dyad if dispnum3==353
*This one doesn't--looks like the Yom Kippur war. Also involves the US and Soviet Union in some capacity
list dyad if dispnum3==3405
*just egypt and syria against israel
list dyad if dispnum3==3419
*just egypt and syria against israel
list dyad if dispnum3==3429
*just egypt and syria against israel
list dyad if dispnum3==3431
*just egypt and syria against israel

