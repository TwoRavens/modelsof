* GENERAL INFO
	* Project: Do Men and Women Have Different Policy Preferences in Africa? Determinants and Implications of Gender Gaps in Policy Prioritization
	* Created by: Amanda Robinson & Guy Grossman
	* Date created: April 2014
	* Updated by: Amanda Robinson
	* Updated: May 25 2015
* DO FILE INFO
	* This .do file processes 4th and 5th rounds of AB data.

*********************************************************************************************************************
set more off

*loads program to produce indices (Anderson, 2008)
do "ANALYSES/AB/genindex.do"

*load merged R4 and R5 Afrobarometer data (www.afrobarometer.org)
use "DATA/Afrobarometer/ABr4r5/ggross_r4r5append.dta", clear

*merge in additional variables from R5 & R4
merge 1:1 ROUND RESPNO using "DATA/Afrobarometer/ABr4r5/AddR5Vars.dta", nogen

*3 "important problems facing this country that government should address"
	*32 possible responses + no problems, other, dk, and refused
tab Q63PT1
tab Q63PT2 
tab Q63PT3 

*Recode
*missing, dk, other, nothing, no further response --> .
recode Q63PT1 Q63PT2 Q63PT3 (  996 =.)
*collapse responses into categories
	*no problems
recode Q63PT1 Q63PT2 Q63PT3 (0=1301)
	*health
recode Q63PT1 Q63PT2 Q63PT3 (21 22 39  =20)
	*violence/crime/war
recode Q63PT1 Q63PT2 Q63PT3 (23 25 26 31 141 1261=30)
	*economy
recode Q63PT1 Q63PT2 Q63PT3 (2 3 5 6 35 38 41 143 660 861 862=1)
	*poverty
recode Q63PT1 Q63PT2 Q63PT3 (8 18 42 =4)
	*water
recode Q63PT1 Q63PT2 Q63PT3 (17=17)
	*agriculture
recode Q63PT1 Q63PT2 Q63PT3 (9 10 32 33 40 180  300 463 662 666=7)
	*infrastructure: roads/transportation/electricity/communications
recode Q63PT1 Q63PT2 Q63PT3 (11 12 15 16=13)
	*political issues/rights: discrimination/women's rights/political rights, corruption, emmigration, political reform
recode Q63PT1 Q63PT2 Q63PT3 (24 27 28 34 37 420 421 465 501 740 741 742 743 781 1181 1262=29)
	*other
recode Q63PT1 Q63PT2 Q63PT3 ( 19 181 995 1180= 1300)

**add a category for political reform? (break up social/political issues/rights)?

*Combine into dummies
tab Q63PT1, gen(p1_)
tab Q63PT2, gen(p2_)
tab Q63PT3, gen(p3_)

* Create Indicators of Preference, Using First Policy Mentioned Only
local i=1
foreach v in economy1 poverty1 agriculture1 infrastructure1 education1 water1 health1 rights1 violence1 services1 {
gen `v'=(p1_`i'==1)
local i=`i'+1
}

* Create Indicators of Preference, Using All Three Policies Mentioned
local i=1
foreach v in economy poverty agriculture infrastructure education water health rights violence services {
gen `v'=(p1_`i'==1 | p2_`i'==1 | p3_`i'==1)
local i=`i'+1
}


* Create Indicators of Preference, Counting Times Policies Mentioned
local i=1
foreach v in economy_N poverty_N agriculture_N infrastructure_N education_N water_N health_N rights_N violence_N services_N {
egen `v'= rowtotal(p1_`i' p2_`i' p3_`i')
local i=`i'+1
}


gen none=(Q63PT1==1301)

rename economy poverty agriculture infrastructure education water health rights violence services none, proper
global outcomes Economy Poverty Infrastructure Health Water Education Agriculture Violence Rights  Services  None


*label variables with capitalized variable labels
capture foreach var of varlist $outcomes {
lab var `var' `var'
lab var `var'3 `var'
lab var `var'_N `var'
*local u: variable label `var'
*local l=proper("`u'")
*lab var `var' "`l'"
}

lab var Rights "Political Rights/Reform"

* Number of problems given
egen count=rownonmiss(Q63PT1 Q63PT2 Q63PT3)
replace count=0 if None==1

*Number of distinct problems given
egen count2=rowtotal($outcomes)
replace count2=0 if None==1

*recode q56pt1 (34=.)(4=2)(7=3)(13=4)(14=5)(17=6)(33=10)(20=7)(27=8)(30=9) 
*lab define Preference 1 "Economy" 2 "Poverty" 3 "Agriculture" 4 "Infrastructure" 5 "Education" 6 "Water" 7 "Health" 8 "Rights" 9 "Violence" 10 "Services", modify
*lab value q56pt1 Preference
*tab q56pt1

* Add country names
local code "BDI BEN BFO BOT CAM CDI CVE GHA GUI KEN LES LIB MAD MAU MLI MLW MOZ NAM NGR NIG SAF SEN SRL SWZ TAN TOG UGA ZAM ZIM"
local country "Burundi Benin BurkinaFaso Botswana Cameroon CotedIvoire CapeVerde Ghana Guinea Kenya Lesotho Liberia Madagascar Mauritius Mali Malawi Mozambique Namibia Niger Nigeria SouthAfrica Senegal SierraLeone Swaziland Tanzania Togo Uganda Zambia Zimbabwe"
local n : word count `code'
gen cname=""
forvalues i = 1/`n' {
	local a : word `i' of `code'
	local b : word `i' of `country'
	replace cname="`b'" if CABBR=="`a'"
	}
replace cname="Burkina Faso" if cname=="BurkinaFaso"
replace cname="Cote d'Ivoire" if cname=="CotedIvoire"
replace cname="Cape Verde" if cname=="CapeVerde"
replace cname="South Africa" if cname=="SouthAfrica"
replace cname="Sierra Leone" if cname=="SierraLeone"
label var cname "Country Name"
encode cname, gen(country) l(country)
lab var country "Country"

* IV: gender
recode THISINT (2=1)(1=0), gen(female)
lab define female 0 "Male" 1 "Female", modify
lab value female female
lab var female "Female"

* Control variables
* priorities named
lab var count2 "\# Priorities"
recode Q1 (-1 998 999=.), gen(age)
* demographics: age, education, urban
lab var age "Age"
recode Q97 (0/2=0)(3/9=1) (99 998 -1=.), gen(primary)
lab var primary "Completed Primary School"
recode URBRUR (2=0) (3=1), gen(urban)
lab var urban "Urban"
*weights
rename WITHINWT Withinwt
* wealth index
recode Q3B Q4 (9 998 -1=.), gen(subjincome relincome)
lab var relincom "Perceived SES"
lab var subjincome "Present living conditions"
recode Q8A Q8B Q8C Q8D Q8E (4=0)(3=1)(2=2)(1=3)(0=4)(-1 9 =.), gen(q8ab q8bb q8cb q8db q8eb) 
recode Q96 (0/1=0)(2/3=1) (9 -1 99 998=.), gen(employment)
gen femployment=employment if female==1
gen memployment=employment if female==0
recode Q90A Q90B Q90C (-1 9=.), gen(ownradio owntv ownvehicle)
recode Q95A (-1 9=.) (1=3)(2=2)(3=1), gen(q93ab)
corr relincome subjincome q8ab q8bb q8cb q8db q8eb employment ownradio owntv ownvehicle
alpha relincome subjincome q8ab q8bb q8cb q8db q8eb employment q93ab ownradio owntv ownvehicle, item std
genindex relincome subjincome q8ab q8bb q8cb q8db q8eb ownradio owntv ownvehicle, nv(wealth)
drop  wealthM- n_wealth_var
lab var wealthA "Wealth index"
lab var wealthA_B "Wealth index-binary"
lab var employment "Employed"
* religion
recode Q98A (2/16 30/40 141/422 462/465 543 701/862 1140 1260/1262=1) (19/24 461 500/504 620 660 930/931=18)(0 17 25/29 466 900/903=995)(-1 998 999=.), gen(rel)
tab rel, gen(rel)
rename rel1 christian 
label var christian "Christian"
rename rel2 muslim
label var muslim "Muslim"
rename rel3 other_rel
label var other_rel "Other/No Religion"
* Political information index
recode Q13A Q13B Q13C Q14 Q15 (-1 9 998=.), gen(radio tvnews newspaper interest discuss)
*dropped knowMP and knowMoF, not available in R5
lab var radio "Radio News"
lab var tvnews "Television news"
lab var newspaper "Newspaper news"
lab var interest "Interest in public affairs"
lab var discuss "Discuss politics"
genindex radio tvnews newspaper interest discuss, nv(polinform)
drop polinformM- n_polinform_var
lab var polinformA "Political knowledge index"
lab var polinformA_B "Political knowledge index, binary"
tabstat polinformA, by(female) stats (mean sd N)
table country female , c(mean polinformA)
* radio: dichotomize 
recode radio (1/4 =1), gen(radioB)
lab var radioB "Radio access (binary)" 

*political engagement index 
recode Q25B (0 1=0)(2 3=1)(-1 9 998=.), gen(villcom)
recode Q26A Q26B Q26D (0 1=0)(2/4=1)(-1 9 998=.), gen(meeting issue protest)
recode Q27 (0 2/7=0)(1=1) (-1 9 998=.), gen(voted)
recode Q30B_MAD Q30B1_MAD Q30A1_NAM Q30B1_NAM Q30A Q30B Q30C (-1 9 998=.)
egen temp1=rowmax(Q30B_MAD Q30B1_MAD) if country==13
replace Q30B=temp1 if country==13 & ROUND==5 & Q30B==.
egen temp2=rowmax(Q30B Q30B1_NAM) if country==18
replace Q30B=temp2 if country==18 & ROUND==5 
egen temp3=rowmax(Q30A Q30A1_NAM) if country==18
replace Q30A=temp3 if country==18 & ROUND==5 
drop temp*
recode Q30A Q30B Q30C (-1 9 998=.), gen(contact_local contact_mp contact_gov)
	*Q30A missing for MalawiR5 (polindex calculated without contact_local for R5)
	*Q30B asked sep. for lower/uppper house in Madagascar (combined by taking highest response)
	*Q30A & Q30B asked sep. for diff. off. in Namibia (combined by taking highest response)
global poleng villcom meeting issue protest voted contact_local contact_mp contact_gov
pwcorr $poleng
alpha $poleng, item std
genindex $poleng, nv(polindex)
rename polindexA polindex
lab var polindex "Political Engagement Index"
tabstat polindex, by(female) stats (mean sd N)
table country female , c(mean polindex)

*removed (5/5/15): rule of law index, support for democratic institutions, trust in state institutions
	* trust traditional leader, satisfaction with government performance index
	*see GGR_DatasetConstruction_20150505 to add these back in

*quality of services (ind. level)
recode Q8A Q8B Q8C (9 998 -1=.) (4=1)(3=2)(2=3)(1=4)(0=5), gen(Poverty_quality Water_quality Health_quality)
lab def quality 1 "Very Poor" 2 "Poor" 3 "Fine" 4 "Good" 5 "Very Good"
lab val Poverty_quality Water_quality Health_quality quality
recode Q5B (9 998 -1=.)
rename Q5B Economy_quality
lab var Economy_quality "Improving Economy"
	*add in quality of economy for R5
lab var Poverty_quality "Food Security"
lab var Water_quality "Water Access"
lab var Health_quality "Access to Healthcare"

*vulnerability at individual level (diff, in SD, of F edu/cell/travel compared to M age cohort)
recode age (18/19=1)(20/24=2)(25/29=3)(30/34=4)(35/39=5)(40/44=6)(45/49=7)(50/54=8)(55/59=9) ///
		   (60/64=10)(65/69=11)(70/120=12), gen(agecat)
recode Q97  (-1 99=.), gen(edulev)
bys ROUND country agecat : egen maleedu=median(edulev) if female==0
sort ROUND country agecat maleedu
replace maleedu=maleedu[_n-1] if maleedu==.
gen edgap=(maleedu>edulev) if maleedu~=. & edulev~=.
lab var edgap "Vulnerable (Less Edu. Avg. Male)"

*removed (5/26/15): cell phone use and gender gap (time scales too different across R4 & R5)
					*travel beyond 10k, not asked in R5
		   
*country dummies
tab country, gen(country)
rename (country1 country2 country3  country4  country5 country6 country7 country8 country9 country10 country11 /// 
country12 country13 country14 country15 country16 country17 country18 country19 country20 ///
 country21 country22 country23 country24 country25 country26 country27 country28 country29) ///
(Benin Botswana Burkina Burundi Cameroon CapeVerde CotedIvoire Ghana Guinea Kenya Lesotho ///
 Liberia Madagascar Malawi Mali Mauritius Mozambique  Namibia Niger Nigeria Senegal SierraLeone SouthAfrica  ///
  Swaziland Tanzania Togo Uganda Zambia Zimbabwe)
global countries Benin Botswana Burkina Burundi Cameroon CapeVerde CotedIvoire Ghana Guinea Kenya Lesotho ///
 Liberia Madagascar Malawi Mali Mauritius Mozambique  Namibia Niger Nigeria Senegal SierraLeone SouthAfrica  ///
  Swaziland Tanzania Togo Uganda Zambia Zimbabwe
set more off

***************************************************************************

tempfile file1 file2 file3
save `file1', replace

*Create country-level dataset with: 
	*gender gap in 10 DVs 
	*IVs: female labor force partiticipation
	*Service quality for water, economy, and poverty 
global preferences Economy Poverty Infrastructure Health Water Education Agriculture Violence Rights  Services  None
	
foreach x in $preferences polindex polinformA {
egen f_`x'=wtmean(`x') if female==1, by(ROUND country) weight(Withinwt)
}
foreach x in $preferences polindex polinformA {
egen m_`x'=wtmean(`x') if female==0, by(ROUND country) weight(Withinwt)
}

* service quality at country level
global quality Water_quality Poverty_quality Economy_quality
foreach x in $quality {
egen avg_`x'=wtmean(`x'), by(ROUND country) weight(Withinwt)
}

*avg. female vulnerability
egen avg_edgap=wtmean(edgap) if female==1, by(ROUND country) weight(Withinwt)
label var avg_edgap "Share vulnerable women"

*collapse to country level
tempfile c1 c2
save `c1', replace
	*already weighted
collapse f_* m_* avg_*, by(ROUND country) 
save `c2', replace
	*need to be weighted
use `c1'
collapse $preferences muslimshare=muslim femploy=femployment memploy=memployment [pweight=Withinwt], by(ROUND country) 
label variable femploy "Share female employment" 
lab variable memploy "Share male employment"
gen emp_ratio=femploy/memploy
lab var emp_ratio "Ratio of Female to Male Employment Share"
label variable muslimshare "Share muslim" 
merge 1:1 ROUND country using `c2', nogen

foreach x in $preferences polindex polinformA {
gen gap_`x'=abs(f_`x' - m_`x')
gen femD_`x' = (f_`x' - m_`x')
}

drop f_* m_* 
gen total_gap=gap_Economy + gap_Poverty + gap_Infrastructure + gap_Health + gap_Agriculture + gap_Water + gap_Education + gap_Violence + gap_Rights + gap_Services


*merge in country-level data
merge m:1 country using "DATA/CountryLevel/VulnerabilityNew", gen(_merge2)
drop if _merge2==2
drop _merge2

* create indices for 2 different country-level variable sets
* add vulnrability measure : teen marriage (WDI)
replace firstmarriage = firstmarriage*-1
alpha muslim polygyny fertility firstmarriage, std item 
*genindex polygyny fertility Edgap maternalmat firstmarriage , nv(vul)
genindex polygyny fertility firstmarriage , nv(vul)
drop vulM-n_vul_var
lab var vulA "Vulnerability index"
lab var vulA_B "Vulnerability index-binary"
ren femalelabor laborfemale
ren femalemps mpsfemale

drop Country 
decode country, gen(Country)
move Country country
gen cname = Country
drop _merge
merge m:1 cname using "DATA/CountryLevel/country_codes.dta", keepus(ccodealp ccodecow ccodewb)
keep if _m==3
drop _merge

replace ccodewb=trim(ccodewb)
replace ccodewb=itrim(ccodewb)
replace ccodewb=ltrim(ccodewb)

merge m:1 ccodewb using "DATA/CountryLevel/PolOpenness.dta"
gen polity=polityR4 if ROUND==4
replace polity=polityR5 if ROUND==5
lab var polity "PolityIV"

gen gdp=GDPR4 if ROUND==4
replace gdp=GDPR5 if ROUND==5
lab var gdp "GDP/Capita"

gen wempower=wempower08 if ROUND==4
replace wempower=wempower12 if ROUND==5
lab var wempower "Women empowerment index"

gen WMPshare=WMPshareR4 if ROUND==4
replace WMPshare=WMPshareR5 if ROUND==5
lab var WMPshare "Women share of MPs"

drop _merge polityR4 polityR5 wempower08 wempower09 wempower10 wempower12 WMPshareR4 WMPshareR5


label var avg_edgap "Share vulnerable women"

save `file3' , replace

**************************************
* Merge individual and group level data
**************************************
use `file1' , clear
merge m:1 ROUND country using `file3', nogen

*capture cd "~/Dropbox/Gender differences/ANALYSES/AB"
*capture cd "ANALYSES/AB"

**************************************
* Merge CIRI data
**************************************
merge m:m ccodecow ROUND using "DATA/CIRI/CIRI-ROUND.data"
drop if _m==2
drop _m

*************************************************
* tag one obs per country *
*************************************************
egen ctag=tag(cname ROUND)

drop if country==6 | country==16


**********************
* Save final dataset *
**********************

saveold "ANALYSES/AB/GGR_FinalData.dta", replace 



