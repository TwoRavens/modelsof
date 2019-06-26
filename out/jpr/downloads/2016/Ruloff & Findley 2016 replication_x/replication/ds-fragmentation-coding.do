/*
Do file to code fragmentation data
October 7, 2015
Authors: Findley and Rudloff
*/


cd "SET PATH HERE"
use "DS2006repl.dta"



/* Meta information */
* for Doyle/Sambanis (2006)
gen fragmentation = 0
gen fragmentationbefore = 0
gen fragmentationafter = 0
gen fragdatescoded = 0

*gen nonuppsalasource = 0

/*************************************************************/
/* AFGHANISTAN */
/*************************************************************/

* Doyle/Sambanis 2006: 3 wars

********************
*AFG1: 

replace fragmentationbefore = 1 if ccode == "AFG1"
*NOTES: According to Ashley's coding 1975 is when this group split

replace fragmentation = 1 if ccode == "AFG1"
*NOTES: see spreadsheet


********************
*AFG2

replace fragmentation = 1 if ccode == "AFG2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), "April 15, 1992 factionalization removed Najibullah..."

replace fragdatescoded = 1 if ccode == "AFG2"

********************
*AFG3

* There is a splinter in 1998, but it is part of the non-state dataset. so don't code here....
* We also checked DS 2006 data and Sambanis 04 coding notes and found no evidence of the fragmented group's name





/*************************************************************/
/* ALGERIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ALG1


********************
*ALG2

replace fragmentation = 1 if ccode == "ALG2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1996 and 1998 multiple fragmentations
*this accords with what Ashley and Peter independently ("ucdp-actors-splinter_dates...")




/*************************************************************/
/* ANGOLA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ANG1


********************
*ANG2


********************
*ANG3

replace fragmentation = 1 if ccode == "ANG3"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1998 
*From frag dates: UPPSALA doesn't include this fracture on its spreadsheet because they never reach the 25 battle related deaths mark: "However, in 1998 five UNITA moderates based in Luanda issued a declaration in which they suspended Savimbi from the movement. Calling themselves UNITA-Renovada, the group were more open to compromise and negotiations and were subsequently recognised by the MPLA government as the sole legitimate representative of UNITA. However, the splinter group had very little support and was not able to..." (from UCDP narrative)
replace fragdatescoded = 1 if ccode == "ANG3"


********************
*ANG4







/*************************************************************/
/* ARGENTINA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ARG1


********************
*ARG2



/*************************************************************/
/* AZERBAIJAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*AZE





/*************************************************************/
/* BANGLADESH */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*BGL




/*************************************************************/
/* BOLIVIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*BOL



/*************************************************************/
/* BOSNIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*BOS



/*************************************************************/
/* BURUNDI */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*BUR1

********************
*BUR2

********************
*BUR3

********************
*BUR4

replace fragmentation = 1 if ccode == "BUR4"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1990, 1991, 1997, and early 2000s
*This accords with Ashely and Peter's coding 

replace fragmentationbefore = 1 if ccode == "BUR4"
*NOTES: According to the Ashley and Peter coding, looks like splits occurred in 1990




/*************************************************************/
/* CAMBODIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CAM1


********************
*CAM2



/*************************************************************/
/* CENTRAL AFRICAN REPUBLIC */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CAF



/*************************************************************/
/* CHAD */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CHD1

replace fragmentation = 1 if ccode == "CHD1"
*NOTES: According to Ashley and Peter's coding based on UCDP actor data; lots of evidence here



********************
*CHD2

replace fragmentation = 1 if ccode == "CHD2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1992; 
*   according to D/S, FARF 

replace fragdatescoded = 1 if ccode == "CHD2"


********************
*CHD3

replace fragmentation = 1 if ccode == "CHD3"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1994
*	note that uppsala says frag after agreement, but doesn't specify when (CHD2 ends in mid-1994; check on this)
*   note that D/S code chd 2 ending in agreement and uppsala text says fragmentation after agreement....

replace fragdatescoded = 1 if ccode == "CHD3"



/*************************************************************/
/* CHINA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CHI1

********************
*CHI2

********************
*CHI3

********************
*CHI4

********************
*CHI5





/*************************************************************/
/* COLOMBIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*COL1

********************
*COL2

*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1991
*	note that uppsala is ambiguous about dates. 1991 prob not the right date. check further
*not enough information to code this....
*replace fragmentation = 1 if ccode == "COL2"





/*************************************************************/
/* Congo Brazzaville */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CON1

replace fragmentationafter = 1 if ccode == "CON1"


********************
*CON2


replace fragmentationbefore = 1 if ccode == "CON2"
*NOTES: According to the Uppsala database summary of the "thrid phase: roles reversed..." fragmentation occurred during the first half of 1998




/*************************************************************/
/* CONGO-ZAIRE */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ZAI1

********************
*ZAI2

********************
*ZAI3

********************
*ZAI4

********************
*ZAI5

********************
*ZAI6

replace fragmentation = 1 if ccode == "ZAI6"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1999 clear; the 1998 one not as clear
* this accords with what ashley and peter coded



/*************************************************************/
/* COSTA RICA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*COS


/*************************************************************/
/* CROATIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CRO2


/*************************************************************/
/* CUBA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CUB


/*************************************************************/
/* CYPRUS */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CYP1

********************
*CYP2


/*************************************************************/
/* DJIBOUTI */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*DJI

replace fragmentation = 1 if ccode == "DJI"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1994 (very clear)
* this accords with ashley and peter's coding




/*************************************************************/
/* DOMINICAN REPUBLIC */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*DOM



/*************************************************************/
/* EL SALVADOR */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SAL


/*************************************************************/
/* EGYPT */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*EGY

replace fragmentationafter = 1 if ccode == "EGY"
replace fragdatescoded = 1 if ccode == "EGY"


*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1997
*	description indicates that frag before end of war, but we're not certain; need to check further
*doesn't look like there is evidence for this. most likely occurred after the war ended. also a split with nonviolent/violent groups doesn't seem to fit
*replace fragmentation = 1 if ccode == "EGY"



/*************************************************************/
/* ETHIOPIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ETH1

replace fragmentationbefore = 1 if ccode == "ETH1"
*based on ashley and peter's coding

replace fragmentation = 1 if ccode == "ETH1"

replace fragmentationafter = 1 if ccode == "ETH1"
*may be fragmentation in eritrea in 1993; 

********************
*ETH2

replace fragmentation = 1 if ccode == "ETH2"
**NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file); 16 May 1989 coup
*	this accords with what peter and ashley found...



********************
*ETH3




/*************************************************************/
/* GEORGIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*GRG1

********************
*GRG2



/*************************************************************/
/* GREECE */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*GRE




/*************************************************************/
/* GUATEMALA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*GUA1

********************
*GUA2



/*************************************************************/
/* GUINEA-BISSAU */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*GBS


/*************************************************************/
/* HAITI */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*HAI

replace fragmentationafter = 1 if ccode == "HAI"
*may be fragmentation in Haiti in November 1996 (Uppsala Database with notes from "frag dates.xlsx"); 
replace fragdatescoded = 1 if ccode == "HAI"



/*************************************************************/
/* INDIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*IND1


replace fragmentation = 1 if ccode == "IND1"
**NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file); Tons of fragmentation throughout Kashmir
replace fragdatescoded = 1 if ccode == "IND1"


********************
*IND2


replace fragmentation = 1 if ccode == "IND2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), LOTS OF FRAGMENTATION THROUGHOUT

replace fragdatescoded = 1 if ccode == "IND2"


********************
*IND3
replace fragmentationbefore = 1 if ccode == "IND3"

*a fragmentation in 1980, which would have been 9 years prior to the war listed in D/S
*	IND7 from frag dates is also likely a fragmentation in 1980
* yes, peter and ashley's coding confirms this

********************
*IND4

replace fragmentationbefore = 1 if ccode == "IND4"
*NOTE: Nagas vertical split in 1988; see IND8 from "frag dates.xls"
* confirms this in ashley and peter's coding

replace fragmentation = 1 if ccode == "IND4"
* based on ashley and peter's coding; ucdp actors dataset


********************
*IND5



/*************************************************************/
/* INDONESIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*IDN1

********************
*IDN2

********************
*IDN3

********************
*IDN4

********************
*IDN5

********************
*IDN6



/*************************************************************/
/* IRAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*IRN1

********************
*IRN2




/*************************************************************/
/* IRAQ */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*IRQ1

********************
*IRQ2


********************
*IRQ3

replace fragmentationafter = 1 if ccode == "IRQ3"
**NOTES: According to ucdp, ashley, peter, fragment happened a couple months after the conflict ended


********************
*IRQ4

********************
*IRQ5




/*************************************************************/
/* ISRAEL */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ISR1

replace fragmentationbefore = 1 if ccode == "ISR1"
*NOTES: see spreadsheet

*NOTES: Hamas is likely a fragmentation during this period (see *http://www.cfr.org/israel/hamas/p8968#p2), but it is not included because it is not a rebel group in the Uppsala dataset; also see START terrorist group profile....
*staying consistent, we do not code this as a fragmentation
*replace fragmentation = 1 if ccode == "ISR1"

*replace nonuppsalasource = 1 if ccode == "ISR1"


********************
*ISR2

* replace fragmentation = 1 if ccode == "ISR2"
*NOTES: Still need to finad a date to be sure, but according to:
*Source: International Policy Institute for Counter-Terrorism
*A political tool with an edge, Yael Shahar, ICT Researcher
* september 1990 the Al-Aqsa Martyr's Brigade was formed
* START lists the beginning as 1990 as well...  question about whether it is a formal military wing of fatah....they didn't officially claim it, but most fighters also belong to fatah.....




/*************************************************************/
/* JORDAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*JRD


/*************************************************************/
/* KENYA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*KEN1

********************
*KEN2


/*************************************************************/
/* KOREA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*KOR


/*************************************************************/
/* LAOS */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*LAO

*not clear there really was a splinter...see peter's note in the ucdp-actors-splinter data file
*replace fragmentationbefore = 1 if ccode == "LAO"



/*************************************************************/
/* LEBANON */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*LEB1


********************
*LEB2

replace fragmentation = 1 if ccode == "LEB2"
*NOTES: see spreadsheet with peter's note in column F




/*************************************************************/
/* LIBERIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*LBR1

replace fragmentation = 1 if ccode == "LBR1"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1989
* This accords with Ashley and Peter's information....see sambanis 04 coding notes as well

********************
*LBR2

replace fragmentation = 1 if ccode == "LBR2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1993
* this accords with what peter and ashley coded...see sambanis 04 coding notes 
* even though ulimo-j listed as non-state....


********************
*LBR3

*2003 LURD splits and MODEL forms....
replace fragmentation = 1 if ccode == "LBR3"



/*************************************************************/
/* MALI */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*MLI

replace fragmentation = 1 if ccode == "MLI"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), plenty of evidence from the file
replace fragdatescoded = 1 if ccode == "MLI"



/*************************************************************/
/* MOLDOVA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*MLD



/*************************************************************/
/* MOROCCO */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*MOR



/*************************************************************/
/* MOZAMBIQUE */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*MOZ



/*************************************************************/
/* MYANMAR */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*MYA1

replace fragmentationafter = 1 if ccode == "MYA1"
*NOTES: see spreadsheet

********************
*MYA2

replace fragmentationbefore = 1 if ccode == "MYA2"
*NOTES: see spreadsheet

*replace fragmentation = 1 i ccode == "MYA2"
*NOTES: "Communist Party of Burma - faction" is vague title in Uppsala, but there is evidence regarding a fragmentation of "Communist Party of Burma (Red Flag)" resulting in the "Communist Party of Arakan (CPA)" in one of the sources
*Not included because it does not appear to specifically match the case in the Upsalla data....

replace fragmentationafter = 1 if ccode == "MYA2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), CPB explicitly discussed, but 1989. seems like may have split earlier so possible code as such


********************
*MYA3

replace fragmentationbefore = 1 if ccode == "MYA3"
*NOTES: see spreadsheet

replace fragmentation = 1 if ccode == "MYA3"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), reference to ethnic groups suggests not part of communist insurgency
* knup splits from knu (or vice versa)

replace fragmentationafter = 1 if ccode == "MYA3"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 2000 (5 years after for KNU)
*fits with what peter and ashley coded


/*************************************************************/
/* NAMIBIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*NAM


/*************************************************************/
/* NEPAL */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*NPL


/*************************************************************/
/* NICARAGUA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*NIC1

********************
*NIC2


/*************************************************************/
/* NIGERIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*NIG1

********************
*NIG2


/*************************************************************/
/* OMAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*OMN


/*************************************************************/
/* PAKISTAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*PAK1

********************
*PAK2

********************
*PAK3

*can't find good information on the mqm-h split....
*replace fragmentationbefore = 1 if ccode == "PAK3"
*based on ashley and peter's coding of the ucdp data





/*************************************************************/
/* PAPUA NEW GUINEA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*PNG1



/*************************************************************/
/* PARAGUAY */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*PAR


/*************************************************************/
/* PERU */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*PER


*coded no, because the pacificists did not pursue violence; thus did not reach 25 battle deaths threshold for uppsala
*replace fragmentation = 1 if ccode == "PER"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), clear reference for 1994



/*************************************************************/
/* PHILIPPINES */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*PHL1

********************
*PHL2

********************
*PHL3

replace fragmentation = 1 if ccode == "PHL3"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), clear reference for 1994
* sounds like one in 1980 (frag dates) as well as 2001 from ucdp actors file...

replace fragmentationbefore = 1 if ccode == "PHL3"



/*************************************************************/
/* RUSSIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*RUS1

replace fragmentation = 1 if ccode == "RUS1"
*NOTES: ARUTYUINOV, DUNLOP, FINDLEY



********************
*RUS2




/*************************************************************/
/* RWANDA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*RWA1

********************
*RWA2


********************
*RWA3



/*************************************************************/
/* SENEGAL */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SGL

*probably code as no, because UCDP lists all three as non-state and DS do not list any of the splinter groups
*replace fragmentation = 1 if ccode == "SGL"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), fairly clear reference
* accords with peter and ashley's coding



/*************************************************************/
/* SIERRA LEONE */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SIE1

********************
*SIE2

replace fragmentation = 1 if ccode == "SIE2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), appears to be post-coup
*accords with peter and ashley's coding; frag dates talks about west side boys beginning in 2000
replace fragdatescoded = 1 if ccode == "SIE2"



/*************************************************************/
/* SOMALIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SOM1

********************
*SOM2

replace fragmentation = 1 if ccode == "SOM2"
*NOTES: see spreadsheet; see peter's note in column f. looks like splinter occurred in augut after war restarts



/*************************************************************/
/* SOUTH AFRICA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SAF


/*************************************************************/
/* SRI LANKA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SRI1

********************
*SRI2

*non-state actor...not listed in DS or Samb 04; occurred before anyway
*replace fragmentationbefore = 1 if ccode == "SRI2"
*ucdp, peter, ashley

********************
*SRI3



/*************************************************************/
/* SUDAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SUD1



********************
*SUD2


replace fragmentation = 1 if ccode == "SUD2"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), 1991 CLEARLY LISTED





/*************************************************************/
/* SYRIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SYR



/*************************************************************/
/* TAJIKISTAN */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*TAJ

replace fragmentationafter = 1 if ccode == "TAJ"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), CHECK ON THIS
replace fragdatescoded = 1 if ccode == "TAJ"



/*************************************************************/
/* THAILAND */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*THA

*no evidence from uppsala or the ucdp actors; some info in frag dates, but can't substantiate



/*************************************************************/
/* TURKEY */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*TUR

*no; there is some info about dev sol and factions, but doesn't pass threshold and not in DS or Samb 04




/*************************************************************/
/* UGANDA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*UGA1


********************
*UGA2


********************
*UGA3

replace fragmentation = 1 if ccode == "UGA3"
*NOTES: ucdp, peter, and ashley
*qualitative info confirms this as well....




********************
*UGA4


********************
*UGA5

replace fragmentation = 1 if ccode == "UGA5"
*NOTES: According to the Uppsala database (as recorded in "frag dates.xlsx" file), fairly clear
*qualitative summaries confirm this....


/*************************************************************/
/* UNITED KINGDOM */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*UKG

*real ira forms in nov 1997 and carries out bombings in early 1998; but no one dies until august/september
* so code no
*replace fragmentation = 1 if ccode == "UKG"







/*************************************************************/
/* USSR */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*SOV1


********************
*SOV2


********************
*SOV3


********************
*SOV4


/*************************************************************/
/* VIETNAM */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*VTN




/*************************************************************/
/* YEMEN AR */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*YEM1


********************
*YEM3




/*************************************************************/
/* YEMEN (SOUTH) */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*YEM2



/*************************************************************/
/* YEMEN PR */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*YEM4




/*************************************************************/
/* CROATIA */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*CRO1



/*************************************************************/
/* KOSOVO */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*YUG



/*************************************************************/
/* ZIMBABWE */
/*************************************************************/

* Doyle/Sambanis 2006: 

********************
*ZMB1

replace fragmentationbefore = 1 if ccode == "ZMB1"


********************
*ZMB2


save "fragmentation-with-DS2006.dta", replace




