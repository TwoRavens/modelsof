* Date: July 19, 2012
* Apply to: 07803-0001-Data.txt
* Description: This set of commands imports ICPSR Study 7803 into STATA
* ICPSR Study 7803 identifies all members serving in each congress and
* provides biographical and other information

clear

set more off


* Import, format ICPSR Study 7803 text file

infix V1 1-5 ///
     V2 6-8 ///
     V3 9-9 ///
     V4 10-11 ///
     V5 12-13 ///
     V6 14-17 ///
     V7 18-19 ///
     str V8 20-44 ///
     V9 45-45 ///
     V10 46-46 ///
     V11 47-48 ///
     V12 49-49 ///
     V13 50-50 ///
     V14 51-52 ///
     V15 53-53 ///
     V16 54-54 ///
     V17 55-57 ///
     V18 58-58 ///
     V19 59-59 ///
     V20 60-60 ///
     V21 61-62 ///
     V22 63-63 ///
     V23 64-65 ///
     V24 66-66 ///
     V25 67-67 ///
     V26 68-69 ///
     V27 70-70 ///
     V28 71-71 ///
     V29 72-72 ///
     V30 73-74 ///
     V31 75-75 ///
     V32 76-76 ///
     V33 77-78 ///
     V34 79-79 ///
     V35 80-80 ///
     V36 81-82 ///
     V37 83-83 ///
     V38 84-84 ///
     V39 85-85 ///
     V40 86-86 ///
     V41 87-88 ///
     V42 89-89 ///
     V43 90-91 ///
     V44 92-92 ///
     V45 93-95 ///
     V46 96-98 ///
     V47 99-101 ///
     V48 102-103 ///
     V49 104-105 ///
     V50 106-108 ///
     V51 109-111 ///
     V52 112-114 ///
     V53 115-117 ///
     V54 118-119 ///
     V55 120-121 ///
     V56 122-123 ///
     V57 124-126 ///
     V58 127-129 ///
     V59 130-132 ///
     V60 133-135 ///
     V61 136-137 ///
     V62 138-139 ///
     V63 140-141 ///
     V64 142-143 ///
     V65 144-145 ///
     V66 146-147 ///
     V67 148-149 ///
     V68 150-151 ///
     V69 152-153 ///
     V70 154-155 ///
     V71 156-157 ///
     V72 158-159 ///
     V73 160-161 ///
     V74 162-163 ///
     V75 164-165 ///
     V76 166-167 ///
     V77 168-169 ///
     V78 170-171 ///
     V79 172-173 ///
     V80 174-175 ///
     V81 176-177 ///
     V82 178-179 ///
     V83 180-181 ///
     V84 182-183 ///
     V85 184-185 ///
     V86 186-188 ///
     V87 189-190 ///
     V88 191-192 ///
     V89 193-195 ///
     str V90 196-197 ///
     str V91 198-201 ///
     V92 202-205 ///
     V93 206-210 ///
     V94 211-215 ///
     V95 216-220 ///
     V96 221-225 ///
     V97 226-230 ///
     V98 231-235 ///
     V99 236-237 ///
     V100 238-239 ///
     V101 240-241 ///
     V102 242-245 ///
     V103 246-247 ///
     V104 248-248 ///
     using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\McKibben\07803-0001-Data.txt"


* Rename relevant variables

rename V1 icpsrno
rename V2 congress
rename V3 chamber_class
rename V4 state
rename V5 district
rename V101 age


* Drop extraneous variables

drop V8-V42
drop V44-V100
drop V102-V104


* Fix incorrect districts

* Carter Glass
replace state = 40 if icpsrno==3625 & congress==57

* Richard Wayne Parker
replace district = 7 if icpsrno==7203 & congress==61

* Henry Loudenslager
replace district = 1 if icpsrno==5786 & congress==54

* Warren Otis Arnold
replace district = 2 if icpsrno==250 & congress==54

* Horace Moore
replace district = 2 if icpsrno==6635 & congress==53

* Sydney Epes
replace district = 4 if icpsrno==2976 & congress==56

* Charles Keith Bell
replace district = 8 if icpsrno==599 & congress==53

* Edward Coke Mann
replace district = 7 if icpsrno==5956 & congress==66


* Drop Senate observations

drop if chamber_class!=3

drop chamber_class


* Member-Congress ID

gen long icpsr_cong = (icpsrno * 1000) + congress

sort icpsr_cong


* Define a year of election variable for use in merge commands
* NOTE: Throughout the 1881-1931 period, states frequently held elections 
* during different years.  Thus, these indices do not identify actual 
* election years for some members

gen yearofelect = (1786 + (2 * congress)) - 1000


* State-Year ID

gen stateyear = (state * 10000) + (yearofelect + 1000)

sort stateyear


* Independent variables

* Seniority

sort icpsrno congress

by icpsrno: gen hse_terms = [_n]


* Party

* Binary variables for Democrats and Republicans
* Members of the American, Anti-Monopolist and Progressive parties coded as 
* Republicans.  Members of the Populist, Farm Labor, Conservative, and Union 
* Labor parties coded as Democrats

gen V7rev = V7

replace V7rev = 1 if V7==9
replace V7rev = 1 if V7==10
replace V7rev = 1 if V7==11
replace V7rev = 1 if V7==17
replace V7rev = 1 if V6==100 & V7==.
replace V7rev = 1 if V6==100 & V7rev > 2

replace V7rev = 2 if V7==3
replace V7rev = 2 if V7==5
replace V7rev = 2 if V7==6
replace V7rev = 2 if V7==12
replace V7rev = 2 if V7==18
replace V7rev = 2 if V6==200 & V7==.
replace V7rev = 2 if V6==200 & V7rev > 2


gen democrat = 0
replace democrat = 1 if V7rev==1

gen republican = 0
replace republican = 1 if V7rev==2

drop V6 V7


* Majority Status

gen hsemaj_r = 0

replace hsemaj_r = 1 if republican==1 & congress==30
replace hsemaj_r = 1 if democrat==1 & congress>=31 & congress<=33
replace hsemaj_r = 1 if republican==1 & congress==34
replace hsemaj_r = 1 if democrat==1 & congress==35
replace hsemaj_r = 1 if republican==1 & congress>=36 & congress<=43
replace hsemaj_r = 1 if democrat==1 & congress>=44 & congress<=46
replace hsemaj_r = 1 if republican==1 & congress==47
replace hsemaj_r = 1 if democrat==1 & congress>=48 & congress<=50
replace hsemaj_r = 1 if republican==1 & congress==51
replace hsemaj_r = 1 if democrat==1 & congress>=52 & congress<=53
replace hsemaj_r = 1 if republican==1 & congress>=54 & congress<=61
replace hsemaj_r = 1 if democrat==1 & congress>=62 & congress<=65
replace hsemaj_r = 1 if republican==1 & congress>=66 & congress<=71
replace hsemaj_r = 1 if democrat==1 & congress>=72 & congress<=79
replace hsemaj_r = 1 if republican==1 & congress==80
replace hsemaj_r = 1 if democrat==1 & congress>=81 & congress<=82
replace hsemaj_r = 1 if republican==1 & congress==83
replace hsemaj_r = 1 if democrat==1 & congress>=84 & congress<=103
replace hsemaj_r = 1 if republican==1 & congress>=104 & congress<=109


* South
* Defined as the 11 states of the former Confederacy

gen south = 0
replace south = 1 if state==40
replace south = 1 if state==41
replace south = 1 if state==42
replace south = 1 if state==43
replace south = 1 if state==44
replace south = 1 if state==45
replace south = 1 if state==46
replace south = 1 if state==47
replace south = 1 if state==48
replace south = 1 if state==49
replace south = 1 if state==54


* Industrial State
* Identifies seven states ranking in the upper quartile of manufacturing value
* per capita.  See the Supporting Information.

gen ind = 0
replace ind = 1 if state==1
replace ind = 1 if state==21
replace ind = 1 if state==3
replace ind = 1 if state==12
replace ind = 1 if state==13
replace ind = 1 if state==14
replace ind = 1 if state==5


* Coastal State
* Identifies states bordering Atlantic, Pacific, Gulf Coast or one of Great Lakes

gen coastal = 0

* Atlantic Coast

replace coastal = 1 if state==2
replace coastal = 1 if state==4
replace coastal = 1 if state==3
replace coastal = 1 if state==5
replace coastal = 1 if state==1
replace coastal = 1 if state==13
replace coastal = 1 if state==12
replace coastal = 1 if state==11
replace coastal = 1 if state==52
replace coastal = 1 if state==40
replace coastal = 1 if state==47
replace coastal = 1 if state==48
replace coastal = 1 if state==44

* Gulf States

replace coastal = 1 if state==43
replace coastal = 1 if state==41
replace coastal = 1 if state==46
replace coastal = 1 if state==45
replace coastal = 1 if state==49

* Pacific Coast

replace coastal = 1 if state==73
replace coastal = 1 if state==72
replace coastal = 1 if state==71

* Great Lakes

replace coastal = 1 if state==14
replace coastal = 1 if state==24
replace coastal = 1 if state==23
replace coastal = 1 if state==22
replace coastal = 1 if state==21
replace coastal = 1 if state==25
replace coastal = 1 if state==33


* Keep observations for 47th to 71st congresses

drop if congress < 47
drop if congress > 71

sort icpsrno congress


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\McKibben\mck_1.dta", replace

* End
