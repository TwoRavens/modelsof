capture log close
clear

set matsize 800

local dir "data_Pinotti_RESTAT2012"
cd "$_dir"

********************** WVS data ****************************
use  xwvsevs_1981_2000_v20060423_wave4_vars_Pinotti_RESTAT2012, clear 
/* this is an exctract of the official WVS four-wave aggregate data file, version 20060423
the complete WVS archive can be obtained (upon registration) from "http://spitswww.uvt.nl/web/fsw/evs/datadownload/xwvsevs_1981_2000_v20060423_dta.zip"
the version here is obtained by keeping only the 4th wave (s002==4) and the variables e042 a165 s024 x025r x047r x028 x035_2 x001 x003 s017

******* variable e042 *********
Now I'd like you to tell me your views on various issues. How would you place your views on this scale? 1 means you
agree completely with the statement on the left; 10 means you agree completely with the statement on the right; and if
your views fall somewhere in between, you can choose any number in between. Sentences:
The state should give more freedom to firms vs The state should control firms more effectively
1 'State should give more freedom to firms'
2 '2'
3 '3'
4 '4'
5 '5'
6 '6'
7 '7'
8 '8'
9 '9'
10 'State should control firms more effectively'
-1 'Don´t know'
-2 'No answer'
-3 'Not applicable'
-4 'Not asked in survey'
-5 'Missing; Unknown'
Sample:
Austria [1999], Belarus [2000], Belgium [1999], Bulgaria [1999], Croatia [1999], Czech Republic [1999], Denmark [1999],
Estonia [1999], Finland [2000], France [1999], Germany [1999], Great Britain [1999], Greece [1999], Hungary [1999],
Iceland [1999], Ireland [1999], Italy [1999], Latvia [1999], Lithuania [1999], Luxembourg [1999], Malta [1999],
Netherlands [1999], Northern Ireland [1999], Poland [1999], Portugal [1999], Romania [1999], Russian Federation
[1999], Slovakia [1999], Slovenia [1999], Spain [1999], Sweden [1999], Turkey [2001], Ukraine [1999] */

rename e042 control
tab control
label var control "firms: freedom(1) - control(10)"

*** trust
rename a165 trust
replace trust=0 if trust==2
tab trust
label var trust "trust: yes(1) - no(0)"

keep if missing(control)==0 & missing(trust)==0 // keep only countries for which the two main variables are available

******* create labels for countries *******
gen codewb="AUT" if s024==404
replace codewb="BEL" if s024==564
replace codewb="BGR" if s024==1004
replace codewb="BLR" if s024==1124
replace codewb="HRV" if s024==1914
replace codewb="CZE" if s024==2034
replace codewb="DNK" if s024==2084
replace codewb="EST" if s024==2334
replace codewb="FIN" if s024==2464
replace codewb="FRA" if s024==2504
replace codewb="DEU" if s024==2764
replace codewb="GRC" if s024==3004
replace codewb="HUN" if s024==3484
replace codewb="ISL" if s024==3524
replace codewb="IRL" if s024==3724
replace codewb="ITA" if s024==3804
replace codewb="LVA" if s024==4284
replace codewb="LTU" if s024==4404
replace codewb="LUX" if s024==4424
replace codewb="MLT" if s024==4704
replace codewb="NLD" if s024==5284
replace codewb="POL" if s024==6164
replace codewb="PRT" if s024==6204
replace codewb="ROM" if s024==6424
replace codewb="RUS" if s024==6434
replace codewb="SVK" if s024==7034
replace codewb="SVN" if s024==7054
replace codewb="ESP" if s024==7244
replace codewb="SWE" if s024==7524
replace codewb="TUR" if s024==7924
replace codewb="UKR" if s024==8044
replace codewb="GBR" if s024==8264
replace codewb="GBR" if s024==9094

*** schooling
rename x025r schooling
label var schooling "schooling: 3 values"
tab schooling, gen(school)
rename school1 lowschool
rename school2 medschool
rename school3 highschool

*** income
rename x047r income
label var income "income: 3 values"
tab income, g(inc)
rename inc1 lowincome
rename inc2 medincome
rename inc3 highincome

*** self employed
tab x028, g(emplstatus)
gen selfemployed=emplstatus3

*** bureaucrats and managers
tab x035_2, gen(prof)
rename prof2 burpol /*11 legislators and senior officials*/
gen manager=max(prof3, prof4) /* 12 corporate managers  13 general managers */

*** insider & incumbents
gen insider=max(selfemployed, manager, burpol)
gen incumbent=max(selfemployed, manager)

*** sex
tab x001, g(sex)
gen female=sex2

*** age
gen age=x003/100
gen age2=age^2

*** sampling weights ***
merge m:1 codewb using popweight
keep if _merge==3
drop _merge

bys codewb: egen s017tot=sum(s017)
gen weight=(s017/s017tot)*pop2000 // total weight is product of equilibrated weight (=1 for all countries) times the population of each country

keep control trust age age2 female highincome lowincome highschool lowschool female codewb weight insider burpol incumbent pop2000

save individual_level_data, replace 

