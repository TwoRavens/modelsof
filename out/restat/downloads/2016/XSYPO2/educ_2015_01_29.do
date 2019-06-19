clear
set more off
capture log close
set logtype text
set matsize 4000
set mem 600m


*******************************************************************************************************


* DATA MANIPULATION AND MERGING


*******************************************************************************************************

cd "H:\YR\labora\labora\Keh\Keksijät\totaaliajot\"

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

log using "educ_`mydate'.log", replace

use uinv_linked.dta

drop vuosi
rename hakuvuosi vuosi
keep shtun vuosi spatent asscode cat  creceive creceive1 no_inv syrtun_patk syrtun_fleedk

gen citlag		=	2002 - vuosi

rename creceive1 cits

*expected lifetime citations, correction factors from Hall et al.

replace cits	= cits / 0.037 if citlag == 1 & cat == 1
replace cits	= cits / 0.045 if citlag == 1 & cat == 2
replace cits	= cits / 0.026 if citlag == 1 & cat == 3
replace cits	= cits / 0.048 if citlag == 1 & cat == 4
replace cits	= cits / 0.043 if citlag == 1 & cat == 5
replace cits	= cits / 0.026 if citlag == 1 & cat == 6

replace cits	= cits / 0.091 if citlag == 2 & cat == 1  
replace cits	= cits / 0.112 if citlag == 2 & cat == 2
replace cits	= cits / 0.067 if citlag == 2 & cat == 3
replace cits	= cits / 0.115 if citlag == 2 & cat == 4
replace cits	= cits / 0.101 if citlag == 2 & cat == 5
replace cits	= cits / 0.069 if citlag == 2 & cat == 6

replace cits	= cits / 0.152 if citlag == 3 & cat == 1
replace cits	= cits / 0.188 if citlag == 3 & cat == 2
replace cits	= cits / 0.114 if citlag == 3 & cat == 3
replace cits	= cits / 0.187 if citlag == 3 & cat == 4
replace cits	= cits / 0.164 if citlag == 3 & cat == 5
replace cits	= cits / 0.123 if citlag == 3 & cat == 6

replace cits	= cits / 0.214 if citlag == 4 & cat == 1
replace cits	= cits / 0.266 if citlag == 4 & cat == 2
replace cits	= cits / 0.165 if citlag == 4 & cat == 3
replace cits	= cits / 0.259 if citlag == 4 & cat == 4
replace cits	= cits / 0.226 if citlag == 4 & cat == 5
replace cits	= cits / 0.182 if citlag == 4 & cat == 6

replace cits	= cits / 0.275 if citlag == 5 & cat == 1
replace cits	= cits / 0.342 if citlag == 5 & cat == 2
replace cits	= cits / 0.216 if citlag == 5 & cat == 3
replace cits	= cits / 0.327 if citlag == 5 & cat == 4
replace cits	= cits / 0.285 if citlag == 5 & cat == 5
replace cits	= cits / 0.244 if citlag == 5 & cat == 6

replace cits	= cits / 0.333 if citlag == 6 & cat == 1
replace cits	= cits / 0.413 if citlag == 6 & cat == 2
replace cits	= cits / 0.265 if citlag == 6 & cat == 3
replace cits	= cits / 0.390 if citlag == 6 & cat == 4
replace cits	= cits / 0.341 if citlag == 6 & cat == 5
replace cits	= cits / 0.306 if citlag == 6 & cat == 6

replace cits	= cits / 0.387 if citlag == 7 & cat == 1
replace cits	= cits / 0.479 if citlag == 7 & cat == 2
replace cits	= cits / 0.314 if citlag == 7 & cat == 3
replace cits	= cits / 0.448 if citlag == 7 & cat == 4
replace cits	= cits / 0.393 if citlag == 7 & cat == 5
replace cits	= cits / 0.366 if citlag == 7 & cat == 6

replace cits	= cits / 0.438 if citlag == 8 & cat == 1
replace cits	= cits / 0.538 if citlag == 8 & cat == 2
replace cits	= cits / 0.360 if citlag == 8 & cat == 3
replace cits	= cits / 0.502 if citlag == 8 & cat == 4
replace cits	= cits / 0.442 if citlag == 8 & cat == 5
replace cits	= cits / 0.424 if citlag == 8 & cat == 6

replace cits	= cits / 0.485 if citlag == 9 & cat == 1
replace cits	= cits / 0.592 if citlag == 9 & cat == 2
replace cits	= cits / 0.404 if citlag == 9 & cat == 3
replace cits	= cits / 0.550 if citlag == 9 & cat == 4
replace cits	= cits / 0.487 if citlag == 9 & cat == 5
replace cits	= cits / 0.479 if citlag == 9 & cat == 6

replace cits	= cits / 0.529 if citlag == 10 & cat == 1
replace cits	= cits / 0.640 if citlag == 10 & cat == 2
replace cits	= cits / 0.446 if citlag == 10 & cat == 3
replace cits	= cits / 0.594 if citlag == 10 & cat == 4
replace cits	= cits / 0.530 if citlag == 10 & cat == 5
replace cits	= cits / 0.530 if citlag == 10 & cat == 6

replace cits	= cits / 0.569 if citlag == 11 & cat == 1
replace cits	= cits / 0.683 if citlag == 11 & cat == 2
replace cits	= cits / 0.486 if citlag == 11 & cat == 3
replace cits	= cits / 0.635 if citlag == 11 & cat == 4
replace cits	= cits / 0.569 if citlag == 11 & cat == 5
replace cits	= cits / 0.578 if citlag == 11 & cat == 6

replace cits	= cits / 0.607 if citlag == 12 & cat == 1
replace cits	= cits / 0.721 if citlag == 12 & cat == 2
replace cits	= cits / 0.524 if citlag == 12 & cat == 3
replace cits	= cits / 0.671 if citlag == 12 & cat == 4
replace cits	= cits / 0.606 if citlag == 12 & cat == 5
replace cits	= cits / 0.622 if citlag == 12 & cat == 6

replace cits	= cits / 0.642 if citlag == 13 & cat == 1
replace cits	= cits / 0.755 if citlag == 13 & cat == 2
replace cits	= cits / 0.560 if citlag == 13 & cat == 3
replace cits	= cits / 0.705 if citlag == 13 & cat == 4
replace cits	= cits / 0.640 if citlag == 13 & cat == 5
replace cits	= cits / 0.662 if citlag == 13 & cat == 6

replace cits	= cits / 0.674 if citlag == 14 & cat == 1
replace cits	= cits / 0.785 if citlag == 14 & cat == 2
replace cits	= cits / 0.593 if citlag == 14 & cat == 3
replace cits	= cits / 0.735 if citlag == 14 & cat == 4
replace cits	= cits / 0.671 if citlag == 14 & cat == 5
replace cits	= cits / 0.699 if citlag == 14 & cat == 6

replace cits	= cits / 0.704 if citlag == 15 & cat == 1
replace cits	= cits / 0.812 if citlag == 15 & cat == 2
replace cits	= cits / 0.625 if citlag == 15 & cat == 3
replace cits	= cits / 0.763 if citlag == 15 & cat == 4
replace cits	= cits / 0.701 if citlag == 15 & cat == 5
replace cits	= cits / 0.732 if citlag == 15 & cat == 6

rename cits creceive1

*---------------------------------------------------------------------------------

*merge patent data with inventor data

*---------------------------------------------------------------------------------

sort shtun vuosi
save inv_linked_app.dta, replace
clear

use ht8804_inv.dta
keep shtun vuosi sp ika kieli kans saika ptoim1 amas1 apvm1 tyokk yotutk ttyotu tyrtu svatva svatvp syrtun nuts1 nuts2 nuts3 ututku amko skunta  
destring vuosi, replace
sort shtun vuosi
merge shtun vuosi using inv_linked_app.dta, uniqmaster
tab _merge
drop _merge
sort shtun vuosi


*---------------------------------------------------------------------------------

*calculate patents & citations per individual by application year

*---------------------------------------------------------------------------------

egen paten					= group(spatent)
by shtun vuosi: egen pats	= count(paten)

by shtun vuosi: egen cits	= total(creceive1)

duplicates drop shtun vuosi pats, force

save inv.dta, replace

clear

use inv.dta 

*drop last 3 years of data because of truncation issues

keep if vuosi				>= 1988 & vuosi <= 1996

sort shtun

by shtun: egen totpat		= total(pats)

drop if totpat				== 0

by shtun: egen totcit		= total(cits)

*---------------------------------------------------------------------------------

*APPEND A RANDOM SAMPLE OF PEOPLE AS CONTROLS

*---------------------------------------------------------------------------------

append using "H:\YR\labora\labora\Keh\Keksijät\kontrollit\kontr_otos1.dta"

keep if vuosi				== 1988

replace totpat				= 0 if totpat ==.
replace totcit				= 0 if totcit ==.

drop if shtun				== ""

sort shtun
duplicates report shtun

egen id						= group(shtun)

gsort id -totpat
duplicates drop id, force

save inv_linked_s2.dta, replace
clear

*---------------------------------------------------------------------------------

*add data on parents

*---------------------------------------------------------------------------------

use inv_linked_s2.dta
sort shtun

merge shtun using isat_1970.dta, uniqmaster sort keep(iedu)

tab _merge

drop if _merge				== 2
rename _merge isat

*---------------------------------------------------------------------------------

*PERSON-LEVEL CONTROLS

*---------------------------------------------------------------------------------

destring sp, 		replace
destring kieli, 	replace
destring ika, 		replace
destring kans, 		replace
destring ptoim1, 	replace
destring amas1, 	replace
destring tyokk, 	replace
destring yotutk, 	replace
destring nuts2, 	replace


*GENDER
gen female				= 1 if sp == 2
replace female			= 0 if sp == 1
tabstat female, 		stat(mean p50 n)

*EDUCATION
rename yotutk college
rename ututku educ 

gen edu_level			= substr(educ,1,1)
destring edu_level, replace
tab edu_level

gen edu_field			= substr(educ,2,1)
destring edu_field, replace
tab edu_field

gen edu					= substr(educ,1,2)
destring edu, replace
*tab edu

sort id vuosi

gen uni_eng				= 0
replace uni_eng			= 1 if edu == 75 | edu == 85
tabstat uni_eng, 		stat(mean p50 n)

gen eng					= 0
replace eng				= 1 if edu == 65 | edu == 75 | edu == 85
tabstat eng, 			stat(mean p50 n)

gen uni					= 0
replace uni				= 1 if edu_level == 7 | edu_level == 8
tabstat uni, 			stat(mean n)

*NATIONALITY
gen finn				= 1 if kans == 1
replace finn			= 0 if kans != 1 & kans !=.
tabstat finn, 			stat(mean n)

*LANGUAGE
tab kieli

gen finnish				= 1 if kieli == 1
replace finnish			= 0 if kieli != 1 & kieli !=.

gen swedish				= 1 if kieli == 2
replace swedish			= 0 if kieli != 2 & kieli !=.

*AGE
gen age					= ika

drop if ika				==.

gen age2				= age^2
gen age3				= age^3
gen age4				= age^4
gen age5				= age^5
gen age6				= age^6

*BIRTH COHORTS
gen syntaika			= vuosi - age

gen synt1 				= 0
replace synt1 			= 1 if syntaika < 1930
gen synt2 				= 0
replace synt2 			= 1 if syntaika > 1929 & syntaika < 1940
gen synt3 				= 0
replace synt3 			= 1 if syntaika > 1939 & syntaika < 1950
gen synt4 				= 0
replace synt4 			= 1 if syntaika > 1949 & syntaika < 1960
gen synt5 				= 0
replace synt5 			= 1 if syntaika > 1959 & syntaika < 1970
gen synt6 				= 0
replace synt6 			= 1 if syntaika > 1969 & syntaika < 1980
gen synt7 				= 0
replace synt7 			= 1 if syntaika > 1979 & syntaika !=.

gen born_29_50			= synt2 + synt3
gen born_49_60			= synt4
gen born_59_70			= synt5

*---------------------------------------------------------------------------------

gen svuosi 				= vuosi - age + 18
keep 					if svuosi > 1949 & svuosi < 1982

sort skunta svuosi

merge skunta svuosi using dist_stud1.dta, uniqusing sort keep(near_uni near_tec km490)

tab _merge
drop _merge 

sort skunta svuosi

merge skunta svuosi using dist_stud3.dta, uniqusing sort keep(espoo tampere oulu lappeen turku maakunta)

tab _merge
drop _merge

replace near_tec		= near_tec / 100
replace near_uni		= near_uni / 100

*merge regional dummies

sort skunta

merge skunta using alueet07.dta, uniqusing sort keep(mkkoodi skkoodi tkaluenro)

*---------------------------------------------------------------------------------

*generate areas and cohort sizes to do Wald-estimate & new IV based on number of study places

*---------------------------------------------------------------------------------

*need to use sampling weights (1/sampling probability for non-inventors)

gen paino				= 1
replace paino			= 20 if totpat == 0


*cohort size
sort svuosi mkkoodi
by svuosi mkkoodi: egen pop_mk = total(paino)

*generate an indicator for inventors
gen d_pat				= 0
replace d_pat			= 1 if totpat > 0 & totpat !=.

*inventors
bysort svuosi mkkoodi: egen inv_mk = total(d_pat)

*engineers
gen eng_paino			= paino * eng
bysort svuosi mkkoodi: egen eng_mk = total(eng_paino) 

*uni engineers
gen ueng_paino			= paino * uni_eng
bysort svuosi mkkoodi: egen ueng_mk = total(ueng_paino)


gen inv_mkpc			= inv_mk / pop_mk
gen eng_mkpc			= eng_mk / pop_mk

* generate # study-places at different universities / regional population
gen places				= 398 / pop_mk if svuosi == 1950 & mkkoodi == 1
replace places			= 397 / pop_mk if svuosi == 1951 & mkkoodi == 1
replace places			= 405 / pop_mk if svuosi == 1952 & mkkoodi == 1
replace places			= 376 / pop_mk if svuosi == 1953 & mkkoodi == 1
replace places			= 390 / pop_mk if svuosi == 1954 & mkkoodi == 1
replace places			= 453 / pop_mk if svuosi == 1955 & mkkoodi == 1
replace places			= 451 / pop_mk if svuosi == 1956 & mkkoodi == 1
replace places			= 459 / pop_mk if svuosi == 1957 & mkkoodi == 1
replace places			= 455 / pop_mk if svuosi == 1958 & mkkoodi == 1
replace places			= 473 / pop_mk if svuosi == 1959 & mkkoodi == 1
replace places			= 510 / pop_mk if svuosi == 1960 & mkkoodi == 1
replace places			= 565 / pop_mk if svuosi == 1961 & mkkoodi == 1
replace places			= 560 / pop_mk if svuosi == 1962 & mkkoodi == 1
replace places			= 590 / pop_mk if svuosi == 1963 & mkkoodi == 1
replace places			= 646 / pop_mk if svuosi == 1964 & mkkoodi == 1
replace places			= 596 / pop_mk if svuosi == 1965 & mkkoodi == 1
replace places			= 695 / pop_mk if svuosi == 1966 & mkkoodi == 1
replace places			= 709 / pop_mk if svuosi == 1967 & mkkoodi == 1
replace places			= 737 / pop_mk if svuosi == 1968 & mkkoodi == 1
replace places			= 770 / pop_mk if svuosi == 1969 & mkkoodi == 1
replace places			= 783 / pop_mk if svuosi == 1970 & mkkoodi == 1
replace places			= 834 / pop_mk if svuosi == 1971 & mkkoodi == 1
replace places			= 823 / pop_mk if svuosi == 1972 & mkkoodi == 1
replace places			= 832 / pop_mk if svuosi == 1973 & mkkoodi == 1
replace places			= 892 / pop_mk if svuosi == 1974 & mkkoodi == 1
replace places			= 831 / pop_mk if svuosi == 1975 & mkkoodi == 1
replace places			= 913 / pop_mk if svuosi == 1976 & mkkoodi == 1
replace places			= 901 / pop_mk if svuosi == 1977 & mkkoodi == 1
replace places			= 815 / pop_mk if svuosi == 1978 & mkkoodi == 1
replace places			= 824 / pop_mk if svuosi == 1979 & mkkoodi == 1 
replace places			= 900 / pop_mk if svuosi == 1980 & mkkoodi == 1
replace places			= 892 / pop_mk if svuosi == 1981 & mkkoodi == 1

replace places			= 0 if svuosi >= 1950 & svuosi < 1959 & mkkoodi == 17
replace places			= 38 /pop_mk   if svuosi == 1959 & mkkoodi == 17
replace places			= 45 /pop_mk   if svuosi == 1960 & mkkoodi == 17
replace places			= 49 / pop_mk  if svuosi == 1961 & mkkoodi == 17
replace places			= 23 / pop_mk  if svuosi == 1962 & mkkoodi == 17
replace places			= 37 / pop_mk  if svuosi == 1963 & mkkoodi == 17
replace places			= 74 / pop_mk  if svuosi == 1964 & mkkoodi == 17
replace places			= 175 / pop_mk if svuosi == 1965 & mkkoodi == 17
replace places			= 159 / pop_mk if svuosi == 1966 & mkkoodi == 17
replace places			= 184 / pop_mk if svuosi == 1967 & mkkoodi == 17
replace places			= 187 / pop_mk if svuosi == 1968 & mkkoodi == 17
replace places			= 186 / pop_mk if svuosi == 1969 & mkkoodi == 17
replace places			= 187 / pop_mk if svuosi == 1970 & mkkoodi == 17
replace places			= 235 / pop_mk if svuosi == 1971 & mkkoodi == 17
replace places			= 212 / pop_mk if svuosi == 1972 & mkkoodi == 17
replace places			= 241 / pop_mk if svuosi == 1973 & mkkoodi == 17
replace places			= 256 / pop_mk if svuosi == 1974 & mkkoodi == 17
replace places			= 240 / pop_mk if svuosi == 1975 & mkkoodi == 17
replace places			= 244 / pop_mk if svuosi == 1976 & mkkoodi == 17
replace places			= 207 / pop_mk if svuosi == 1977 & mkkoodi == 17
replace places			= 163 / pop_mk if svuosi == 1978 & mkkoodi == 17
replace places			= 203 / pop_mk if svuosi == 1979 & mkkoodi == 17
replace places			= 222 / pop_mk if svuosi == 1980 & mkkoodi == 17
replace places			= 243 / pop_mk if svuosi == 1981 & mkkoodi == 17

replace places			= 0 if svuosi >= 1950 & svuosi < 1965 & mkkoodi == 6
replace places			= 132 / pop_mk if svuosi == 1965 & mkkoodi == 6
replace places			= 108 / pop_mk if svuosi == 1966 & mkkoodi == 6
replace places			= 124 / pop_mk if svuosi == 1967 & mkkoodi == 6
replace places			= 116 / pop_mk if svuosi == 1968 & mkkoodi == 6
replace places			= 115 / pop_mk if svuosi == 1969 & mkkoodi == 6
replace places			= 125 / pop_mk if svuosi == 1970 & mkkoodi == 6
replace places			= 190 / pop_mk if svuosi == 1971 & mkkoodi == 6
replace places			= 232 / pop_mk if svuosi == 1972 & mkkoodi == 6
replace places			= 308 / pop_mk if svuosi == 1973 & mkkoodi == 6
replace places			= 364 / pop_mk if svuosi == 1974 & mkkoodi == 6
replace places			= 413 / pop_mk if svuosi == 1975 & mkkoodi == 6
replace places			= 468 / pop_mk if svuosi == 1976 & mkkoodi == 6
replace places			= 427 / pop_mk if svuosi == 1977 & mkkoodi == 6
replace places			= 444 / pop_mk if svuosi == 1978 & mkkoodi == 6
replace places			= 415 / pop_mk if svuosi == 1979 & mkkoodi == 6
replace places			= 435 / pop_mk if svuosi == 1980 & mkkoodi == 6
replace places			= 432 / pop_mk if svuosi == 1981 & mkkoodi == 6 

replace places			= 0 if svuosi >= 1950 & svuosi < 1969 & mkkoodi == 9
replace places			= 47 / pop_mk  if svuosi == 1969 & mkkoodi == 9
replace places			= 43 / pop_mk  if svuosi == 1970 & mkkoodi == 9
replace places			= 45 / pop_mk  if svuosi == 1971 & mkkoodi == 9
replace places			= 71 / pop_mk  if svuosi == 1972 & mkkoodi == 9
replace places			= 105 / pop_mk if svuosi == 1973 & mkkoodi == 9
replace places			= 108 / pop_mk if svuosi == 1974 & mkkoodi == 9
replace places			= 149 / pop_mk if svuosi == 1975 & mkkoodi == 9
replace places			= 148 / pop_mk if svuosi == 1976 & mkkoodi == 9
replace places			= 138 / pop_mk if svuosi == 1977 & mkkoodi == 9
replace places			= 175 / pop_mk if svuosi == 1978 & mkkoodi == 9
replace places			= 217 / pop_mk if svuosi == 1979 & mkkoodi == 9
replace places			= 241 / pop_mk if svuosi == 1980 & mkkoodi == 9
replace places			= 251 / pop_mk if svuosi == 1981 & mkkoodi == 9 

sort svuosi mkkoodi
by svuosi mkkoodi: tab places


*******************************************************************************************************


* TABLES & NUMBERS IN TEXT PRODUCED BELOW


*******************************************************************************************************


*---------------------------------------------------------------------------------

* DESCRIPTIVE STATISTICS - TABLES 1 AND A.1

*---------------------------------------------------------------------------------

* TABLE A.1

tab iedu 				if d_pat == 1
tab iedu 				if d_pat == 0

* TABLE 1 panel A
tab edu_level 			if totpat > 0
tab edu_level 			if totpat == 0

tab edu_field 			if totpat > 0
tab edu_field 			if totpat == 0

tab uni_eng 			if totpat > 0 
tab uni_eng 			if totpat == 0

* entrepreneurship status
tab amas1 				if totpat > 0 
tab amas1	 			if totpat == 0

* TABLE 1 panel B
tabstat age female finn finnish swedish born_* near_tec totpat totcit uni_eng if totpat > 0, stat(mean sd p50 n)
tabstat age female finn finnish swedish born_* near_tec totpat totcit uni_eng if totpat == 0, stat(mean sd p50 n)

tab ptoim1 				if totpat > 0
tab ptoim1 				if totpat == 0

*histogram totpat 		if totpat!= 0, discrete frequency
*save fig3.gph, replace

*---------------------------------------------------------------------------------

* DESCRIPTIVE OLS - TABLE 2

*---------------------------------------------------------------------------------

save our_est_temp.dta, replace

qui xi: reg totpat female finn finnish swedish  uni_eng i.syntaika near_tec
keep if e(sample)

xi: reg totpat female finn finnish swedish i.edu i.syntaika [pw=paino], robust

*---------------------------------------------------------------------------------

* WALD ESTIMATES - TABLE 3

*---------------------------------------------------------------------------------

clear all
use our_est_temp.dta

*TREATMENTS AND CONTROLS
sort svuosi

*define before & after cohorts
*1950-1958 Oulu 1960-1968
*1956-1964 Tampere 1966-1974
*1960-1968 Lappeenranta 1970-1978

*gen indicators for groups (treatments, before and after)

gen bOulu				=.
replace bOulu			= 1 if svuosi >= 1950 & svuosi <= 1958 & mkkoodi == 17

gen aOulu				=.
replace aOulu			= 1 if svuosi >= 1960 & svuosi <= 1968 & mkkoodi == 17

gen bTampere			=.
replace bTampere		= 1 if svuosi >= 1956 & svuosi <= 1964 & mkkoodi == 6

gen aTampere			=.
replace aTampere		= 1 if svuosi >= 1966 & svuosi <= 1974 & mkkoodi == 6

gen bLappeen			=.
replace bLappeen		= 1 if svuosi >= 1960 & svuosi <= 1968 & mkkoodi == 9

gen aLappeen			=.
replace aLappeen		= 1 if svuosi >= 1970 & svuosi <= 1978 & mkkoodi == 9

*for helsinki, three diff definitions (for relevant comparison)

gen bHelO				=.
replace bHelO			= 1 if svuosi >= 1950 & svuosi <= 1958 & mkkoodi == 1

gen aHelO				=.
replace   aHelO			= 1 if svuosi >= 1960 & svuosi <= 1968 & mkkoodi == 1

gen bHell				=.
replace bHell			= 1 if svuosi >= 1960 & svuosi <= 1968 & mkkoodi == 1

gen aHell				=.
replace aHell			= 1 if svuosi >= 1970 & svuosi <= 1978 & mkkoodi == 1

gen bHelt				=.
replace bHelt			= 1 if svuosi >= 1956 & svuosi <= 1964 & mkkoodi == 1

gen aHelt				=.
replace aHelt			= 1 if svuosi >= 1966 & svuosi <= 1974 & mkkoodi == 1

* TABLE 3 panel A -  Pohjois-Pohjanmaa
*cohort size
egen bOulu_pop			= total(paino) if bOulu == 1
tabstat bOulu_pop, 		stat(mean p50 n)

egen aOulu_pop			= total(paino) if aOulu == 1
tabstat aOulu_pop, 		stat(mean p50 n)

*inventors
egen bOulu_inv			= total(d_pat) if bOulu == 1
tabstat bOulu_inv, 		stat(mean p50 n)

egen aOulu_inv			= total(d_pat) if aOulu == 1
tabstat aOulu_inv, 		stat(mean p50 n)

*engineers
egen bOulu_eng			= total(eng_paino) if bOulu == 1
tabstat bOulu_eng, 		stat(mean p50 n)

egen aOulu_eng			= total(eng_paino) if aOulu == 1
tabstat aOulu_eng, 		stat(mean p50 n)

* TABLE 3 panel A - Uusimaa
*cohort size
egen bHelO_pop			= total(paino) if bHelO == 1
tabstat bHelO_pop, 		stat(mean p50 n)

egen aHelO_pop			= total(paino) if aHelO == 1
tabstat aHelO_pop, 		stat(mean p50 n)

*inventors
egen bHelO_inv			= total(d_pat) if bHelO == 1
tabstat bHelO_inv, 		stat(mean p50 n)

egen aHelO_inv			= total(d_pat) if aHelO == 1
tabstat aHelO_inv, 		stat(mean p50 n)

*engineers
egen bHelO_eng			= total(eng_paino) if bHelO == 1
tabstat bHelO_eng, 		stat(mean p50 n)

egen aHelO_eng			= total(eng_paino) if aHelO == 1
tabstat aHelO_eng, 		stat(mean p50 n)


* TABLE 3 panel B - Pirkanmaa
*cohort size
egen bTam_pop			= total(paino) if bTampere == 1
tabstat bTam_pop, 		stat(mean p50 n)

egen aTam_pop			= total(paino) if aTampere == 1
tabstat aTam_pop, 		stat(mean p50 n)

*inventors
egen bTam_inv			= total(d_pat) if bTampere == 1
tabstat bTam_inv, 		stat(mean p50 n)

egen aTam_inv			= total(d_pat) if aTampere == 1
tabstat aTam_inv, 		stat(mean p50 n)

*engineers
egen bTam_eng			= total(eng_paino) if bTampere == 1
tabstat bTam_eng, 		stat(mean p50 n)
egen aTam_eng			= total(eng_paino) if aTampere == 1
tabstat aTam_eng, 		stat(mean p50 n)

* TABLE 3 panel B - Uusimaa
*cohort size
egen bHelt_pop			= total(paino) if bHelt == 1
tabstat bHelt_pop, 		stat(mean p50 n)

egen aHelt_pop			= total(paino) if aHelt == 1
tabstat aHelt_pop, 		stat(mean p50 n)

*inventors
egen bHelt_inv			= total(d_pat) if bHelt == 1
tabstat bHelt_inv, 		stat(mean p50 n)

egen aHelt_inv			= total(d_pat) if aHelt == 1
tabstat aHelt_inv, 		stat(mean p50 n)

*engineers
egen bHelt_eng			= total(eng_paino) if bHelt == 1
tabstat bHelt_eng, 		stat(mean p50 n)

egen aHelt_eng			= total(eng_paino) if aHelt == 1
tabstat aHelt_eng, 		stat(mean p50 n)

* TABLE 3 panel C - Etelä-Karjala
*cohort size
egen bLap_pop			= total(paino) if bLappeen == 1
tabstat bLap_pop, 		stat(mean p50 n)
egen aLap_pop			= total(paino) if aLappeen == 1
tabstat aLap_pop, 		stat(mean p50 n)

*inventors
egen bLap_inv			= total(d_pat) if bLappeen == 1
tabstat bLap_inv, 		stat(mean p50 n)

egen aLap_inv			= total(d_pat) if aLappeen == 1
tabstat aLap_inv, 		stat(mean p50 n)

*engineers
egen bLap_eng			= total(eng_paino) if bLappeen == 1
tabstat bLap_eng, 		stat(mean p50 n)

egen aLap_eng			= total(eng_paino) if aLappeen == 1
tabstat aLap_eng, 		stat(mean p50 n)

egen bLap_ueng			= total(ueng_paino) if bLappeen == 1
tabstat bLap_ueng, 		stat(mean p50 n)

egen aLap_ueng			= total(ueng_paino) if aLappeen == 1
tabstat aLap_ueng, 		stat(mean p50 n)

* TABLE 3 panel C - Uusimaa
*cohort size
egen bHell_pop			= total(paino) if bHell == 1
tabstat bHell_pop, 			stat(mean p50 n)

egen aHell_pop			= total(paino) if aHell == 1
tabstat aHell_pop, 			stat(mean p50 n)

*inventors
egen bHell_inv			= total(d_pat) if bHell == 1
tabstat bHell_inv, 			stat(mean p50 n)

egen aHell_inv			= total(d_pat) if aHell == 1 
tabstat aHell_inv, 		stat(mean p50 n)

*engineers
egen bHell_eng			= total(eng_paino) if bHell == 1
tabstat bHell_eng, 		stat(mean p50 n)

egen aHell_eng			= total(eng_paino) if aHell == 1
tabstat aHell_eng, 		stat(mean p50 n)

*---------------------------------------------------------------------------------

*OLS REGRESSIONS - TABLE 4

*---------------------------------------------------------------------------------

qui xi: reg totpat female finn finnish swedish  uni_eng i.syntaika near_tec
keep if e(sample)

global dep_vars totpat d_pat totcit
global end_vars uni_eng eng uni

foreach i of global dep_vars {
	foreach j of global end_vars {
		qui xi: regr `i' `j' female  finn  finnish swedish  i.syntaika [pw=paino], vce(robust) first
		estimates store T4c1_`i'_`j'
	}
}

foreach i of global dep_vars {
	foreach j of global end_vars {
		qui xi: regr `i' `j' female  finn  finnish swedish  i.syntaika i.iedu [pw=paino], vce(robust) first
		estimates store T4c2_`i'_`j'
	}
}


display "These are ols estimates, T4 panel 1"
estimates table T4c1_totpat* T4c2_totpat* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)
display "These are ols estimates, T4 panel 2"
estimates table T4c1_d_pat* T4c2_d_pat* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)
display "These are ols estimates, T4 panel 3"
estimates table T4c1_totcit* T4c2_totcit*, b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

*---------------------------------------------------------------------------------

* FIRST STAGE ESTIMATES - TABLE 5

*---------------------------------------------------------------------------------

global end_vars uni_eng eng

foreach k of global end_vars {
	* table 5 column 1 rows 1 & 2
	xi: regr `k'  female  finn  finnish swedish  i.syntaika  near_tec [pw=paino], vce(robust)
	estimates store T5c1_`k'
	* table 5 column 2 rows 1 & 2 
	xi: regr `k'  female  finn  finnish swedish  i.syntaika i.iedu near_tec [pw=paino], vce(robust)
	estimates store T5c2_`k'
	}	

* table 5 column 1 panels A - C row 3
xi: regr uni female finn finnish swedish i.syntaika near_uni [pw=paino], vce(robust)
estimates store T5c1_uni

* table 5 column 2 panels A - C row 3 
xi: regr uni female finn finnish swedish i.syntaika i.iedu near_uni [pw=paino], vce(robust)
estimates store T5c2_uni	

display "These are 1st stage estimates, T5 col 1"
estimates table T5c1_* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(near_tec near_uni)
display "These are 1st stage estimates, T5 col 2"
estimates table T5c2_* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(near_tec near_uni)

*---------------------------------------------------------------------------------

* IV ESTIMATES - TABLE 6

*---------------------------------------------------------------------------------

global dep_vars totpat d_pat totcit
global end_vars uni_eng eng

foreach k of global dep_vars {
	foreach j of global end_vars {
	* table 6 column 1 panels A - C rows 1 & 2
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (`j' = near_tec) [pw=paino], vce(robust)
	estimates store T6c1_`k'_`j'
	* table 6 column 2 panels A - C rows 1 & 2 
	xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (`j' = near_tec ) [pw=paino], vce(robust)
	estimates store T6c2_`k'_`j'
	}	
}

foreach k of global dep_vars {
	* table 6 column 1 panels A - C row 3
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (uni = near_uni) [pw=paino], vce(robust)
	estimates store T6c1_`k'_uni
	* table 6 column 2 panels A - C rows 3 
	xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (uni = near_uni ) [pw=paino], vce(robust)
	estimates store T6c2_`k'_uni
	}	

display "These are IV estimates, T6 col 1"
estimates table T6c1_totpat* T6c1_d_pat* T6c1_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)
display "These are IV estimates, T6 col 2"
estimates table T6c2_totpat* T6c2_d_pat* T6c2_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)

*---------------------------------------------------------------------------------

* IV ROBUSTNESS - SECTION 4.2.3 1ST PARA

*---------------------------------------------------------------------------------

* 1. base specification using the sample for which father's education observed

global dep_vars totpat d_pat totcit
global end_vars uni_eng eng

foreach k of global dep_vars {
	foreach j of global end_vars {
	* table 6 column 1 panels A - C rows 1 & 2
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (`j' = near_tec) [pw=paino] if iedu != ., vce(robust)
	estimates store T6c1_`k'_`j'
	}	
}

foreach k of global dep_vars {
	* table 6 column 1 panels A - C row 3
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (uni = near_uni) [pw=paino] if iedu != ., vce(robust)
	estimates store T6c1_`k'_uni
	}	

display "These are IV estimates using sample where father's education observed, T6 col 1"
estimates table T6c1_totpat* T6c1_d_pat* T6c1_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)

* 2. add interaction between dist and 1[father has a univv degree]

gen i_uniedu 			= 0
replace i_uniedu		= 1 if iedu > 48 & iedu < 99 /* min is lower tertiary degree, see Table A.1 */

gen near_uni_i_uniedu	= near_uni * i_uniedu			
gen near_tec_i_uniedu	= near_tec * i_uniedu			

global dep_vars totpat d_pat totcit
global end_vars uni_eng eng

foreach k of global dep_vars {
	foreach j of global end_vars {
	* table 6 column 1 panels A - C rows 1 & 2
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (`j' =  near_tec near_tec_i_uniedu) [pw=paino], vce(robust)
	estat firststage, all
	estimates store T6c1_`k'_`j'
	* table 6 column 2 panels A - C rows 1 & 2 
	xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (`j' = near_tec near_tec_i_uniedu) [pw=paino], vce(robust)
	estat firststage, all
	estimates store T6c2_`k'_`j'
	}	
}

foreach k of global dep_vars {
	* table 6 column 1 panels A - C row 3
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (uni = near_uni near_uni_i_uniedu) [pw=paino], vce(robust)
	estat firststage, all
	estimates store T6c1_`k'_uni
	* table 6 column 2 panels A - C rows 3 
	xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (uni = near_uni near_uni_i_uniedu) [pw=paino], vce(robust)
	estat firststage, all
	estimates store T6c2_`k'_uni
	}	

display "These are IV estimates with interaction between a dummy for father's univ education and distance as additional instrument, T6 col 1"
estimates table T6c1_totpat* T6c1_d_pat* T6c1_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)
display "These are IV estimates with interaction between a dummy for father's univ education and distance as additional instrument, T6 col 2"
estimates table T6c2_totpat* T6c2_d_pat* T6c2_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)

* 3. cluster se's at muni level

global dep_vars totpat d_pat totcit
global end_vars uni_eng eng

foreach k of global dep_vars {
	foreach j of global end_vars {
	* table 6 column 1 panels A - C rows 1 & 2
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (`j' = near_tec) [pw=paino], vce(cluster skunta)
	estimates store T6c1_`k'_`j'
	* table 6 column 2 panels A - C rows 1 & 2 
	xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (`j' = near_tec) [pw=paino], vce(cluster skunta)
	estimates store T6c2_`k'_`j'
	}	
}

foreach k of global dep_vars {
	* table 6 column 1 panels A - C row 3
	xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (uni = near_uni) [pw=paino], vce(cluster skunta)
	estimates store T6c1_`k'_uni
	* table 6 column 2 panels A - C rows 3 
	xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (uni = near_uni) [pw=paino], vce(cluster skunta)
	estimates store T6c2_`k'_uni
	}	

display "These are IV estimates with standard errors clustered at municipal level, T6 col 1"
estimates table T6c1_totpat* T6c1_d_pat* T6c1_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)
display "These are IV estimates with standard errors clustered at municipal level, T6 col 2"
estimates table T6c2_totpat* T6c2_d_pat* T6c2_totcit* , b(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(uni_eng eng uni)


*---------------------------------------------------------------------------------

* LATE TESTING  - TABLE 7 & SECTION 4.3

*---------------------------------------------------------------------------------

xi: probit uni_eng female finn finnish swedish  i.syntaika i.iedu near_tec [pw=paino], vce(robust)  

predict ppscore

orthpoly ppscore, deg(5) generate(pscore*)

gen fe_sc1				= female * pscore1
gen fe_sc2				= female * pscore2
gen fe_sc3				= female * pscore3
gen fe_sc4				= female * pscore4
gen fe_sc5				= female * pscore5

gen fi_sc1				= finn * pscore1
gen fi_sc2				= finn * pscore2
gen fi_sc3				= finn * pscore3
gen fi_sc4				= finn * pscore4
gen fi_sc5				= finn * pscore5
 
gen fin_sc1				= finnish * pscore1
gen fin_sc2				= finnish * pscore2
gen fin_sc3				= finnish * pscore3
gen fin_sc4				= finnish * pscore4
gen fin_sc5				= finnish * pscore5

gen swe_sc1				= swedish * pscore1
gen swe_sc2				= swedish * pscore2
gen swe_sc3				= swedish * pscore3
gen swe_sc4				= swedish * pscore4
gen swe_sc5				= swedish * pscore5

* TABLE 7 row 1 column 1 (p-value on pscore2)
xi: reg totpat female finn finnish swedish pscore1 pscore2 i.syntaika i.iedu [pw=paino],  robust
test (pscore1=0) (pscore2=0)

* TABLE 7 row 2 columns 2 (p-value on pscore2 and pscore3)
xi: reg totpat female finn finnish swedish pscore1 pscore2 pscore3 i.syntaika i.iedu [pw=paino],  robust
test (pscore1=0) (pscore2=0) (pscore3=0)
test (pscore2=0) (pscore3=0)

* TABLE 7 row 1 column 2 (p-value on pscore2 and its interactions)
xi: reg totpat female finn finnish swedish pscore1 pscore2 fe_sc1 fe_sc2 fi_sc1 fi_sc2 fin_sc1 fin_sc2 swe_sc1 swe_sc2 i.syntaika i.iedu [pw=paino],  robust
test (pscore2=0) (fe_sc1=0) (fe_sc2=0) (fi_sc1=0) (fi_sc2=0) (fin_sc1=0) (fin_sc2=0) (swe_sc1=0) (swe_sc2=0)
test (pscore2=0) (fe_sc2=0)(fi_sc2=0) (fin_sc2=0) (swe_sc2=0)
test (pscore1=0) (pscore2=0) (fe_sc1=0) (fe_sc2=0) (fi_sc1=0) (fi_sc2=0) (fin_sc1=0) (fin_sc2=0) (swe_sc1=0) (swe_sc2=0)

* TABLE 7 row 2 column 2 (p-value on pscore2, pscore3 and their interactions)
xi: reg totpat female finn finnish swedish pscore1 pscore2 pscore3 fe_sc1 fe_sc2 fe_sc3 fi_sc1 fi_sc2 fi_sc3 fin_sc1 fin_sc2 fin_sc3 swe_sc1 swe_sc2 swe_sc3 i.syntaika i.iedu [pw=paino],  robust
test (pscore1=0) (pscore2=0) (pscore3=0) (fe_sc1=0) (fe_sc2=0) (fe_sc3=0) (fi_sc1=0) (fi_sc2=0) (fi_sc3=0) (fin_sc1=0) (fin_sc2=0) (fin_sc3=0) (swe_sc1=0) (swe_sc2=0) (swe_sc3=0)
test (pscore2=0) (pscore3=0) (fe_sc1=0) (fe_sc2=0) (fe_sc3=0) (fi_sc1=0) (fi_sc2=0) (fi_sc3=0) (fin_sc1=0) (fin_sc2=0) (fin_sc3=0) (swe_sc1=0) (swe_sc2=0) (swe_sc3=0)
test (pscore2=0) (pscore3=0) (fe_sc2=0) (fe_sc3=0) (fi_sc2=0) (fi_sc3=0) (fin_sc2=0) (fin_sc3=0) (swe_sc2=0) (swe_sc3=0)


*---------------------------------------------------------------------------------

*reduced form counterfactuals - SECTION 5

*---------------------------------------------------------------------------------

* NOTE: to calculate the % mentioned in Section 5, divide total_cf by total_pr to get decreases
* to get increases, divide total_pr by total_cf

xi: reg totpat female finn finnish swedish  i.syntaika i.iedu near_tec [pw=paino],  robust

predict pat_pr
gen pat_prpw			= pat_pr * paino

gen near_apu			= near_tec
replace near_tec		= km490 / 100

predict patcf_pr
gen patcf_prpw			= patcf_pr * paino

egen total_cf			= total(patcf_prpw)
tabstat total_cf, 			stat(mean p50 n)

egen total_pr			= total(pat_prpw)
tabstat total_pr, 		stat(mean p50 n)

egen total_act			= total(totpat)
tabstat total_act,		stat(mean p50 n)

drop pat_pr pat_prpw patcf_pr patcf_prpw total_cf total_pr total_act
*---------------------------------------------------------------------------------
replace near_tec		= near_apu

gen near_tec2			= near_tec^2
gen near_tec3			= near_tec^3
gen near_tec4			= near_tec^4
gen near_tec5			= near_tec^5

xi: reg totpat female finn finnish swedish  i.syntaika i.iedu near_tec near_tec2 near_tec3 near_tec4 near_tec5 [pw=paino],  robust
testparm near_tec2 near_tec3 near_tec4 near_tec5
predict pat_pr
gen pat_prpw			= pat_pr * paino

replace near_tec		= km490 / 100
replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5

predict patcf_pr
gen patcf_prpw			= patcf_pr * paino

egen total_cf			= total(patcf_prpw)
tabstat total_cf, 			stat(mean p50 n)

egen total_pr			= total(pat_prpw)
tabstat total_pr, 		stat(mean p50 n)

egen total_act			= total(totpat)
tabstat total_act,			stat(mean p50 n)


drop pat_pr pat_prpw patcf_pr patcf_prpw total_cf total_pr total_act
*---------------------------------------------------------------------------------
replace near_tec		= near_apu

replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5


xi: reg totpat female finn finnish swedish  i.syntaika i.iedu near_tec near_tec2 near_tec3 near_tec4  [pw=paino],  robust

predict pat_pr
gen pat_prpw			= pat_pr * paino

replace near_tec		= km490 / 100
replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5

predict patcf_pr
gen patcf_prpw			= patcf_pr * paino

egen total_cf			= total(patcf_prpw)
tabstat total_cf, 		stat(mean p50 n)

egen total_pr			= total(pat_prpw)
tabstat total_pr, 		stat(mean p50 n)

egen total_act			= total(totpat)
tabstat total_act, 		stat(mean p50 n)

drop pat_pr pat_prpw patcf_pr patcf_prpw total_cf total_pr total_act
*---------------------------------------------------------------------------------
replace near_tec		= near_apu

replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5


xi: reg totpat female finn finnish swedish  i.syntaika i.iedu near_tec near_tec2 near_tec3  [pw=paino],  robust

predict pat_pr
gen pat_prpw			= pat_pr * paino

replace near_tec		= km490 / 100
replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5

predict patcf_pr
gen patcf_prpw			= patcf_pr * paino

egen total_cf			= total(patcf_prpw)
tabstat total_cf, 		stat(mean p50 n)

egen total_pr			= total(pat_prpw)
tabstat total_pr, 		stat(mean p50 n)

egen total_act			= total(totpat)
tabstat total_act, 		stat(mean p50 n)


drop pat_pr pat_prpw patcf_pr patcf_prpw total_cf total_pr total_act
*---------------------------------------------------------------------------------
replace near_tec		= near_apu

replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5


xi: reg totpat female finn finnish swedish  i.syntaika i.iedu near_tec near_tec2  [pw=paino],  robust

predict pat_pr
gen pat_prpw			= pat_pr * paino

replace near_tec		= km490 / 100
replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5

predict patcf_pr
gen patcf_prpw			= patcf_pr * paino

egen total_cf			= total(patcf_prpw)
tabstat total_cf, 			stat(mean p50 n)

egen total_pr			= total(pat_prpw)
tabstat total_pr, 			stat(mean p50 n)

egen total_act			= total(totpat)
tabstat total_act, 			stat(mean p50 n)


drop pat_pr pat_prpw patcf_pr patcf_prpw total_cf total_pr total_act

replace near_tec		= near_apu
replace near_tec2		= near_tec^2
replace near_tec3		= near_tec^3
replace near_tec4		= near_tec^4
replace near_tec5		= near_tec^5

xi: reg uni_eng female finn finnish swedish  i.syntaika i.iedu near_tec [pw=paino],  robust

xi: reg totpat female finn finnish swedish  i.syntaika i.iedu i.maakunta near_tec [pw=paino],  robust

xi: reg uni_eng female finn finnish swedish  i.syntaika i.iedu i.maakunta near_tec [pw=paino],  robust

*---------------------------------------------------------------------------------

* ROBUSTNESS TESTS  - TABLES A.2 - A.13

*---------------------------------------------------------------------------------

* TABLES A.2 - A.10

gen inst 				= near_apu
gen inst2 				= near_apu^2
gen inst3 				= near_apu^3
gen inst4 				= near_apu^4
gen inst5 				= near_apu^5
gen inst6 				= near_apu^6
gen inst7 				= near_apu^7
gen inst8 				= near_apu^8

replace inst 			= near_tec 
replace inst2 			= near_tec^2
replace inst3 			= near_tec^3
replace inst4 			= near_tec^4
replace inst5 			= near_tec^5
replace inst6 			= near_tec^6
replace inst7 			= near_tec^7
replace inst8 			= near_tec^8

global end_vars uni_eng eng uni

global inst_vec1 inst
global inst_vec2 inst inst2
global inst_vec3 inst inst2 inst3
global inst_vec4 inst inst2 inst3 inst4
global inst_vec5 inst inst2 inst3 inst4 inst5
global inst_vec6 inst inst2 inst3 inst4 inst5 inst6
global inst_vec7 inst inst2 inst3 inst4 inst5 inst6 inst7
global inst_vec8 inst inst2 inst3 inst4 inst5 inst6 inst7 inst8

global dep_vars totpat d_pat totcit

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

foreach k of global dep_vars {
	
	replace inst = near_tec 
	replace inst2 = near_tec^2
	replace inst3 = near_tec^3
	replace inst4 = near_tec^4
	replace inst5 = near_tec^5
	replace inst6 = near_tec^6
	replace inst7 = near_tec^7
	replace inst8 = near_tec^8

	local m = 1
	
	foreach j of global end_vars {
	
	replace inst = near_uni if `m' == 3 
	replace inst2 = near_uni^2 if `m' == 3
	replace inst3 = near_uni^3 if `m' == 3
	replace inst4 = near_uni^4 if `m' == 3
	replace inst5 = near_uni^5 if `m' == 3
	replace inst6 = near_uni^6 if `m' == 3
	replace inst7 = near_uni^7 if `m' == 3
	replace inst8 = near_uni^8 if `m' == 3
	
		forvalues i = 1(1)8 {
			* panel A
			xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (`j' = ${inst_vec`i'}) [pw=paino], vce(robust)
			display "These are the results on outcome `k' using `j' as the measure of education and inst_vec`i' as instruments"
			estat firststage, all
			estimates store `k'_1_`i'
			* panel B
			xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (`j' = ${inst_vec`i'}) [pw=paino], vce(robust)
			display "These are the results on outcome `k' using `j' as the measure of education and inst_vec`i' as instruments"
			estat firststage, all
			estimates store `k'_2_`i'
			* panel C
			xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu i.maakunta (`j' = ${inst_vec`i'}) [pw=paino], vce(robust)
			display "These are the results on outcome `k' using `j' as the measure of education and inst_vec`i' as instruments"
			estat firststage, all
			estimates store `k'_3_`i'
	
			display "These are the results on outcome `k' using `j' as the measure of education and inst_vec`i' as instruments"
			display "base model"
			estimates table `k'_1_*, b(%7.4f) se(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(`j')
			display "These are the results on outcome `k' using `j' as the measure of education and inst_vec`i' as instruments"
			display "father's education included"
			estimates table `k'_2_*, b(%7.4f) se(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(`j')
			display "These are the results on outcome `k' using `j' as the measure of education and inst_vec`i' as instruments"
			display "father's education & region dummies included"
			estimates table `k'_3_*, b(%7.4f) se(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(`j')
			*outreg2 [`k'_1_`i'] using table_lin1_`k'_`j'_`mydate', excel   append dec(3)
			*outreg2 [`k'_2_`i'] using table_lin2_`k'_`j'_`mydate', excel   append dec(3)
			*outreg2 [`k'_3_`i'] using table_lin3_`k'_`j'_`mydate', excel   append dec(3)
		}
		estimates clear
		local m = `m' + 1
	}	
}

* TABLES A.11 - A.13

gen lninst = ln(near_tec)
gen lninst2 = ln(near_apu)^2
gen lninst3 = ln(near_apu)^3
gen lninst4 = ln(near_apu)^4
gen lninst5 = ln(near_apu)^5
gen lninst6 = ln(near_apu)^6
gen lninst7 = ln(near_apu)^7
gen lninst8 = ln(near_apu)^8

local m = 1

global lninst_vec1 lninst
global lninst_vec2 lninst lninst2
global lninst_vec3 lninst lninst2 lninst3
global lninst_vec4 lninst lninst2 lninst3 lninst4
global lninst_vec5 lninst lninst2 lninst3 lninst4 lninst5
global lninst_vec6 lninst lninst2 lninst3 lninst4 lninst5 lninst6
global lninst_vec7 lninst lninst2 lninst3 lninst4 lninst5 lninst6 lninst7
global lninst_vec8 lninst lninst2 lninst3 lninst4 lninst5 lninst6 lninst7 lninst8


global dep_vars totpat

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

foreach k of global dep_vars {

	replace lninst = ln(near_tec)
	replace lninst2 = ln(near_tec)^2
	replace lninst3 = ln(near_tec)^3
	replace lninst4 = ln(near_tec)^4
	replace lninst5 = ln(near_tec)^5
	replace lninst6 = ln(near_tec)^6
	replace lninst7 = ln(near_tec)^7
	replace lninst8 = ln(near_tec)^8

	local m = 1
	
	foreach j of global end_vars {

		replace lninst = ln(near_uni) if `m' == 3
		replace lninst2 = ln(near_uni)^2 if `m' == 3
		replace lninst3 = ln(near_uni)^3 if `m' == 3
		replace lninst4 = ln(near_uni)^4 if `m' == 3
		replace lninst5 = ln(near_uni)^5 if `m' == 3
		replace lninst6 = ln(near_uni)^6 if `m' == 3
		replace lninst7 = ln(near_uni)^7 if `m' == 3
		replace lninst8 = ln(near_uni)^8 if `m' == 3
	
		forvalues i = 1(1)8 {
			* panel A
			xi: ivregress 2sls `k'  female  finn  finnish swedish  i.syntaika (`j' = ${lninst_vec`i'}) [pw=paino], vce(robust) 
			display "These are the results on outcome `k' using `j' as the measure of education and lninst_vec`i' as instruments"
			estat firststage, all
			estimates store `k'_1_`i'
			* panel B
			xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu (`j' = ${lninst_vec`i'}) [pw=paino], vce(robust) 
			display "These are the results on outcome `k' using `j' as the measure of education and lninst_vec`i' as instruments"
			estat firststage, all
			estimates store `k'_2_`i'
			* panel C
			xi: ivregress 2sls  `k'  female  finn  finnish swedish  i.syntaika i.iedu i.maakunta (`j' = ${lninst_vec`i'}) [pw=paino], vce(robust) 
			display "These are the results on outcome `k' using `j' as the measure of education and lninst_vec`i' as instruments"
			estat firststage, all
			estimates store `k'_3_`i'
	
			display "These are the results on outcome `k' using `j' as the measure of education and lninst_vec`i' as instruments"
			display "base model and logarithmic distance"
			estimates table `k'_1_*, b(%7.4f) se(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(`j')
			display "These are the results on outcome `k' using `j' as the measure of education and lninst_vec`i' as instruments"
			display "father's education included and logarithmic distance"
			estimates table `k'_2_*, b(%7.4f) se(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(`j')
			display "These are the results on outcome `k' using `j' as the measure of education and lninst_vec`i' as instruments"
			display "father's education & region dummies included and logarithmic distance"
			estimates table `k'_3_*, b(%7.4f) se(%7.4f) p(%7.4f) stfmt(%7.4g)  stats(N F r2) keep(`j')
			*outreg2 [`k'_1_`i'] using table_ln1_`k'_`j'_`mydate', excel   append dec(3)
			*outreg2 [`k'_2_`i'] using table_ln2_`k'_`j'_`mydate', excel   append dec(3)
			*outreg2 [`k'_3_`i'] using table_ln3_`k'_`j'_`mydate', excel   append dec(3)
		}
		estimates clear
		local m = `m' + 1
	}	
}


log close

exit 
exit
exit



