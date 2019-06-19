**************************************************************************
/********************** Effects of birth order **************************/
/********************* on non-cognitive skills **************************/
/***************** Review of Economics and Statistics *******************/
/******************** Generating occupational data **********************/
**************************************************************************

* Use the five years closest to 45 years
* Restrict to ages 35-55
* Restrict to cohorts born 1941-74 (35-55 years in 1996-2009)

* Population data
use idnr yob woman if yob>=1941 & yob<=1974 using C:\Data\Education-data\Population-data\pop2.dta, clear

* Information on years registrated in Sweden
sort idnr
merge idnr using pop_year_1.dta, keep(year)
keep if _merge==3
drop _merge

keep if (year-yob)>=35 & (year-yob)<=55

keep if (((year-yob)>=55 & (year-yob)<=55 & yob==1941) | ((year-yob)>=54 & (year-yob)<=55 & yob==1942) | ((year-yob)>=53 & (year-yob)<=55 & yob==1943) | ((year-yob)>=52 & (year-yob)<=55 & yob==1944) | ((year-yob)>=51 & (year-yob)<=55 & yob==1945) | ((year-yob)>=50 & (year-yob)<=54 & yob==1946) | ((year-yob)>=49 & (year-yob)<=53 & yob==1947) | ((year-yob)>=48 & (year-yob)<=52 & yob==1948) | ((year-yob)>=47 & (year-yob)<=51 & yob==1949) | ((year-yob)>=46 & (year-yob)<=50 & yob==1950) | ((year-yob)>=45 & (year-yob)<=49 & yob==1951) | ((year-yob)>=44 & (year-yob)<=48 & yob==1952) | ((year-yob)>=43 & (year-yob)<=47 & yob>=1953 & yob<=1962) | ((year-yob)>=42 & (year-yob)<=46 & yob==1963) | ((year-yob)>=41 & (year-yob)<=45 & yob==1964) | ((year-yob)>=40 & (year-yob)<=44 & yob==1965) | ((year-yob)>=39 & (year-yob)<=43 & yob==1966) | ((year-yob)>=38 & (year-yob)<=42 & yob==1967) | ((year-yob)>=37 & (year-yob)<=41 & yob==1968) | ((year-yob)>=36 & (year-yob)<=40 & yob==1969) | ((year-yob)>=35 & (year-yob)<=39 & yob==1970) | ((year-yob)>=35 & (year-yob)<=38 & yob==1971) | ((year-yob)>=35 & (year-yob)<=37 & yob==1972) | ((year-yob)>=35 & (year-yob)<=36 & yob==1973) | ((year-yob)>=35 & (year-yob)<=35 & yob==1974))

* Data on employment and selfemployment
sort idnr year
merge idnr year using C:\data\Education-data\Louise-data\empl_panel_1985_2009_1.dta, keep(empl)
drop if _merge==2
drop _merge

sort idnr year
merge idnr year using C:\data\Education-data\Louise-data\self_empl_panel_1985_2009_1.dta, keep(selfemp)
drop if _merge==2
drop _merge

replace empl=0 if empl==.
replace empl=0 if selfemp==1
drop selfemp

* Add occupational panel
sort idnr year
merge idnr year using occ_panel_1.dta
drop if _merge==2
drop _merge

replace empl=1 if sector!=.
replace wweight=1 if wweight==. & empl==0

gen nsector=sector
replace nsector=4 if nsector==5
replace nsector=4 if nsector==. & empl==1

egen temp1=count(1) if nsector!=., by(year yob woman nsector)
egen temp2=count(1) if sector!=., by(year yob woman nsector)
gen nwweight=temp1/temp2 if sector!=.
replace nwweight=1 if sector==. & empl==0
lab var nwweight "weight, new"
drop temp*

sort idnr
save occ_midage_panel_1.dta, replace


use occ_midage_panel_1.dta, clear

replace occ="1220" if occ=="1240"

* Transfer SSYK-96 codes to ISCO-88 codes using crosstable
gen ssyk96_3=substr(occ, 1, 3)
sort ssyk96_3
merge ssyk96_3 using C:\Users\bjooc\Data\Help_files\occ_ssyk96_isco88_1.dta
drop if _merge==2
drop _merge ssyk96_3

gen isco88_1=real(substr(isco88_3,1,1))
lab var isco88_1 "occupation, isco88-code, one digit"
gen isco88_2=real(substr(isco88_3,1,2))
lab var isco88_2 "occupation, isco88-code, two digits"
destring isco88_3, replace
lab var isco88_3 "occupation, isco88-code, three digits"

* Managers
gen ceop=occ=="1210"
replace ceop=. if (sector==. & empl==1)
lab var ceop "manager in private firms"

gen ceopp=(occ=="1110" | occ=="1210")
replace ceopp=. if (sector==. & empl==1)
lab var ceopp "manager in private firms or public organisations"

gen ceopb=substr(occ, 1, 1)=="1"
replace ceopb=. if (sector==. & empl==1)
lab var ceopb "managers, broad definition"

* Creative occupations
/*
The creative occupations comprise the following ISCO-88 codes: 
Architects, town and traffic planners (2141)
Writers and creative or performing artists (245)
Photographers (3131)
Image and sound recording equipment operators (3132)
Decorators and commercial designers (3471)
Radio, television and other announcers (3472)
Street, night-club and related musicians, singers and dancers (3473)
Clowns, magicians, acrobats, and related professionals (3474)
Fashion and other models (5210).
*/

gen jcreate=1 if (occ=="2141" | occ=="2451" | occ=="2452" | occ=="2453" | occ=="2454" | occ=="2455" | occ=="2456" | occ=="3131" | occ=="3132" | occ=="3471" | occ=="3472" | occ=="3473" | occ=="3474" | occ=="5210")
replace jcreate=0 if jcreate==. & (sector!=. | empl==0)
lab var jcreate "creative occupations"

* Merge with O*NET job descriptions
sort isco88_3
merge isco88_3 using C:\Users\bjooc\Data\Onet-data\isco88_3_onet_all_1.dta, keep(v1A1 v1A2 v1A3 v1C1 v1C3 v1C4 v1C5 v1C6 v2B1 v1A1a v1A1b v1A1c v1A1d v1A1e v1A1f v1A1g v1B1c v1C1a v1C1b v1C1c v1C2b v1C3a v1C3b v1C3c v1C4a v1C4b v1C4c v1C5a v1C5b v1C5c v1C7a v1C7b v2B1a v2B1b v2B1c v2B1d v2B1e v2B1f)
drop if _merge==2
drop _merge

* Generate Big Five personality measures
/*
Big Five (Sacket & Walmsley, 2014)
Conscientiousness
v2B1a	Social Perceptiveness	
v2B1f	Service Orientation	
v2B1e	Instructing
v1C5a	Dependability	
v1C5c	Integrity	
v1C6	Independence	
v1C1c	Initiative	
v1C1b	Persistence	
v1C1a	Achievement/Effort	
v1C5b	Attention to Detail	

Agreeableness
v2B1a	Social Perceptiveness	
v2B1f	Service Orientation	
v2B1b	Coordination	
v2B1d	Negotiation	
v2B1e	Instructing
v1C5c	Integrity	
v1C3a	Cooperation	
v1C3b	Concern for Others	
v1C3c	Social Orientation	

Emotional Stability
v1C5c	Integrity	
v1C4a	Self Control
v1C4b	Stress Tolerance	
v1C4c	Adaptability/Flexibility	

Extraversion
v2B1b	Coordination	
v2B1c	Persuasion
v2B1d	Negotiation	
v2B1e	Instructing
v1C3c	Social Orientation	
v1C2b	Leadership	

Openness to Experience
v1C4c	Adaptability/Flexibility	
v1C6	Independence
v1C7b	Analytical Thinking	
v1C2b	Leadership	
v1C7a	Innovation
*/

gen bf_c=(v2B1a/2+v2B1f/2+v2B1e/3+v1C5a+v1C5c/3+v1C6/2+v1C1c+v1C1b+v1C1a+v1C5b)/(1/2+1/2+1/3+1+1/3+1/2+1+1+1+1)
gen bf_a=(v2B1a/2+v2B1f/2+v2B1b/2+v2B1d/2+v2B1e/3+v1C5c/3+v1C3a+v1C3b+v1C3c/2)/(1/2+1/2+1/2+1/2+1/3+1/3+1+1+1/2)
gen bf_es=(v1C5c/3+v1C4a+v1C4b+v1C4c/2)/(1/3+1+1+1/2)
gen bf_ex=(v2B1b/2+v2B1c+v2B1d/2+v2B1e/3+v1C3c/2+v1C2b/2)/(1/2+1+1/2+1/3+1/2+1/2)
gen bf_o=(v1C4c/2+v1C6/2+v1C7b+v1C2b/2+v1C7a)/(1/2+1/2+1+1/2+1)
lab var bf_c "conscientiousness"
lab var bf_a "agreeableness"
lab var bf_es "emotional stability"
lab var bf_ex "extraversion"
lab var bf_o "openness to experience"

* Standardized job content
program drop _all
program define testt
	{
	local k 1
	while `k'<=8 {
	local lab: variable label ``k''
	gen s``k''=.
	sum ``k'' [aw=nwweight] if sector!=.
	scalar temp1am=r(mean)
	scalar temp1as=r(sd)
	replace s``k''=((``k''-temp1am)/temp1as)  if sector!=.
	*replace s``k''=0 if sector==. & empl==0
	lab var s``k'' "`lab', std"
	drop ``k''
	local k=`k'+1
	} 
}
end
testt sv1A1 sv2B1 sv1C2b bf_c bf_a bf_es bf_ex bf_o
program drop _all

keep idnr yob woman year empl sector nwweight ceop ceopp ceopb jcreate sv1A1 sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o  

sort idnr year
save occ_midage_panel_2.dta, replace


* Collapse data by individual
use occ_midage_panel_2.dta, clear

collapse (mean) yob woman year empl sector ceop ceopp ceopb jcreate sv1A1 sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o (rawsum) nwweight [aw=nwweight], by(idnr) fast

lab var idnr "identity number"
lab var yob "year of birth"
lab var woman "woman"
lab var year "year"
lab var empl "employed"
lab var sector "sector"
lab var nwweight "weight, new"
lab var ceop "manager in private firms"
lab var ceopp "manager in private firms or public organizations"
lab var ceopb "managers, broad definition"
lab var jcreate "creative occupation"
lab var sv1A1 "cognitive abilities, std"
lab var sv2B1 "social skills, std"
lab var sv1C2b "leadership, std"
lab var sbf_c "conscientiousness, std"
lab var sbf_a "agreeableness, std"
lab var sbf_es "emotional stability, std"
lab var sbf_ex "extraversion, std"
lab var sbf_o "openness to experience, std"

sort idnr 
save occ_midage_3.dta, replace


