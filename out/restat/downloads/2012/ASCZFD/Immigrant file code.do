*This file is designed to take the married couple and single person Census files and source country data and produce a dataset of immigrants for analysis
clear
set mem 6g
set more off
global path "u:\user3\klp27\Blau and Kahn\Immigration"

*Create source country dataset
use "$path\finaldata"

label var final_label "Country/area names that reflect our final grouping"
label var poptot "Population total, estimates and projections UN"
label var fertrate "Fertility rate total, estimates and projections UN"
label var ear15m "Economic activity rate age 15 and over, male, computed eap15/ (pop over 15)"
label var ear15f "Economic activity rate age 15 and over, female, computed eap15/ (pop over 15)"
label var proprefug "Refugees and asylees from each country as a proportion of the total number of immigs admitted into US from that country, computed as nrefug/immig"
label var miles "Distance (miles) of country's capital to closest of three US gateways NY, LA or Miami, www.into.com"
label var tertiary "School enrolment tertiary (% gross) WB"
label var secondarym "School enrolment secondary male (% gross) WB"
label var secondaryf "School enrolment secondary female (% gross) WB"
label var primarym "School enrolment primary male (% gross) WB"
label var primaryf "School enrolment primary female (% gross) WB"
label var infmortun "Infant mortality rate UN estimates and projections"

*replace bpld==10000 if bpld==9900
rename gdpconcap gdpcap
rename i_gdpconcap i_gdpcap
rename i_gdpcon i_gdp
drop if bpld<10000
keep if year==1950 | year==1955 | year==1960 | year==1965 | year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000
drop num1865cur-wgt1865arr

*Create region code (see Blau, Kahn, Moriarty and Souza (2003) p. 442)
gen reg_code=.
replace reg_code=real(substr(string(final_code),1,2))
replace reg_code=reg_code+10 if reg_code>=25
replace reg_code=real(substr(string(reg_code),1,1))
replace reg_code=3 if final_label=="West Indies"
replace reg_code=reg_code+1 if reg_code>=6
replace reg_code=6 if final_code==52200 | (final_code>=53000 & final_code<=54400) | (final_code>=60011 & final_code<=60014)
replace reg_code=5 if final_code==16040
replace reg_code=8 if final_code==16020
label define reg_code 1 "North America" 2 "Central America" 3 "Carribean" 4 "South America" 5 "Europe" 6 "Middle East" 7 "Asia" 8 "Africa" 9 "Oceania"
label values reg_code reg_code

preserve
for var fertrate-reg_code: rename X Xcurr
sort bpld year
save "$path\Source country data current date"
restore
preserve
rename year yrimmig2
for var fertrate-reg_code: rename X Xarr
sort bpld yrimmig2
save "$path\Source country data arrival date"
for var bpld-reg_code: rename X spX
sort spbpld spyrimmig2
save "$path\Source country data arrival date (spouse)"
restore
for var final_label final_code bpld: rename X spX
for var fertrate-reg_code: rename X spXcurr
sort spbpld year
save "$path\Source country data current date (spouse)"

foreach year of numlist 1980 1990 2000 {
  use "$path\Source country data current date", clear
  keep if year==`year'
  keep final_code gdpcapcurr
  rename gdpcapcurr gdpcap`year'
  save "$path\Source country data current date `year'", replace
  use "$path\Source country data current date (spouse)", clear
  keep if year==`year'
  keep spfinal_code spgdpcapcurr
  rename spgdpcapcurr spgdpcap`year'
  save "$path\Source country data current date `year' (spouse)", replace
}

*Create updated country group codes
use "$path\Country group codes.dta", clear
rename bpld ipums_code
*Combine small countries with little source country data
replace final_label="West Indies" if ipums_code==16010 | ipums_code==26042 | (ipums_code>=26045 & ipums_code<=26059)
replace final_label="Guiana" if ipums_code==30035 | ipums_code==30055
replace final_label="Switzerland" if ipums_code==42200
replace final_label="Spain" if ipums_code==43100
replace final_label="Italy" if ipums_code==43900
replace final_label="Pacific Islands" if ipums_code==71023 | ipums_code==71024 | ipums_code==71025
sort final_label ipums_code
by final_label: egen final_code=min(ipums_code) if drop==0
sort ipums_code
drop ipums_label grouped_label drop
save "$path\Augmented country group codes"

*Select immigrants and append
foreach year of numlist 1980 1990 2000 {
  use "$path\Census `year' Wife data", clear
  gen immigrant=.
  replace immigrant=0 if citizen==1 | bpld<15000 | bpld==71033 | (bpld>=71040 & bpld<=71049)
  replace immigrant=1 if citizen~=1 & bpld>=15000 & bpld~=71033 & (bpld<71040 | bpld>71049)
  gen spimmigrant=.
  replace spimmigrant=0 if spcitizen==1 | spbpld<15000 | spbpld==71033 | (spbpld>=71040 & spbpld<=71049)
  replace spimmigrant=1 if spcitizen~=1 & spbpld>=15000 & spbpld~=71033 & (spbpld<71040 | spbpld>71049)
  keep if immigrant==1 | spimmigrant==1
  save "$path\Census `year' Immigrant Wife data", replace

  use "$path\Census `year' Single Women data", clear
  gen immigrant=.
  replace immigrant=0 if citizen==1 | bpld<15000 | bpld==71033 | (bpld>=71040 & bpld<=71049)
  replace immigrant=1 if citizen~=1 & bpld>=15000 & bpld~=71033 & (bpld<71040 | bpld>71049)
  keep if immigrant==1
  save "$path\Census `year' Immigrant Single Women data", replace

  use "$path\Census `year' Single Men data", clear
  scalar year=`year'
  if scalar(year)==1980 for var pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild bpl citizen yrimmig yrsusa2 hispan school higraded educrec schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migcity5 migcogrp movedin incbus incfarm classwkd qwkswork quhrswor qincbus qincfarm qincinvs qincwage qbpl qyrimm speakeng occmo: rename X spX
  if scalar(year)==1990 for var pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild bpl citizen yrimmig yrsusa2 hispan school educrec educ99 schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migcity5 migpuma migpumas movedin incbus incfarm classwkd qwkswork quhrswor qincbus qincfarm qincinvs qincwage qbpl qyrimm speakeng occmo: rename X spX
  if scalar(year)==2000 for var pernum slwt perwt momloc momrule poploc poprule sploc sprule relate age sex race marst nchild /*racgen00 racdet00*/ racamind racasian racblk racpacis racwht racother racnum bpl citizen yrimmig yrsusa1 yrsusa2 hispan school educrec educ99 gradeatt schltype empstat labforce occ ind wkswork1 uhrswork inctot incwage incinvst migplac5 migmet5 migtype5 migtyp00 migcity5 migpuma migpumas movedin incbus00 classwkd qwkswork quhrswor qincbus qincinvs qincwage qbpl qyrimm speakeng occmo: rename X spX
  gen spimmigrant=.
  replace spimmigrant=0 if spcitizen==1 | spbpld<15000 | spbpld==71033 | (spbpld>=71040 & spbpld<=71049)
  replace spimmigrant=1 if spcitizen~=1 & spbpld>=15000 & spbpld~=71033 & (spbpld<71040 | spbpld>71049)
  keep if spimmigrant==1
  save "$path\Census `year' Immigrant Single Men data", replace

  use "$path\Census `year' Immigrant Wife data", clear
  append using "$path\Census `year' Immigrant Single Women data"
  append using "$path\Census `year' Immigrant Single Men data"
  save "$path\Census `year' Immigrant data", replace
  erase "$path\Census `year' Immigrant Wife data.dta"
  erase "$path\Census `year' Immigrant Single Women data.dta"
  erase "$path\Census `year' Immigrant Single Men data.dta"

  *Create years since migration variable (this doesn't work for 1970 - for analyses using 1970, use the IPUMS var yrsusa2)
  gen yrimmig1=1000+yrimmig
  replace yrimmig1=2000 if yrimmig==1
  replace yrimmig1=. if yrimmig==0 | (yrimmig==999 & scalar(year)==1970) /*Note that 999 means missing in 1970 - may need to impute*/
  gen spyrimmig1=1000+spyrimmig
  replace spyrimmig1=2000 if spyrimmig==1
  replace spyrimmig1=. if spyrimmig==0 | (spyrimmig==999 & scalar(year)==1970) /*Note that 999 means missing in 1970 - may need to impute*/

  *Follow Borjas (1995), as cited in Blau, Kahn, Moriarty and Souza (2003) p. 431
  *Female YSM and cohort vars
  gen ysm=.
  replace ysm=year-yrimmig1
  *What to do in following line??
  replace ysm=90 if yrimmig==910 & year==2000
  replace ysm=87.5 if yrimmig==911 & year==2000
  replace ysm=83 if yrimmig==915 & year==2000
  replace ysm=68 if yrimmig==930 & year==2000

  replace ysm=50 if yrimmig==949 & year==1990
  replace ysm=35.5 if yrimmig==959 & year==1990
  replace ysm=28 if yrimmig==964 & year==1990
  replace ysm=23 if yrimmig==970 & year==1990
  replace ysm=18 if yrimmig==974 & year==1990
  replace ysm=13 if yrimmig==980 & year==1990
  replace ysm=9.5 if yrimmig==981 & year==1990
  replace ysm=7 if yrimmig==984 & year==1990
  replace ysm=4.5 if yrimmig==986 & year==1990
  replace ysm=1.5 if yrimmig==990 & year==1990

  replace ysm=40 if yrimmig==949 & year==1980
  replace ysm=25.5 if yrimmig==959 & year==1980
  replace ysm=18 if yrimmig==964 & year==1980
  replace ysm=13 if yrimmig==970 & year==1980
  replace ysm=8 if yrimmig==974 & year==1980
  replace ysm=2.5 if yrimmig==980 & year==1980
/*
  replace ysm=65 if yrimmig==914 & year==1970
  replace ysm=50.5 if yrimmig==924 & year==1970
  replace ysm=40.5 if yrimmig==934 & year==1970
  replace ysm=30.5 if yrimmig==944 & year==1970
  replace ysm=23 if yrimmig==949 & year==1970
  replace ysm=18 if yrimmig==954 & year==1970
  replace ysm=13 if yrimmig==959 & year==1970
  replace ysm=8 if yrimmig==964 & year==1970
  replace ysm=2.5 if yrimmig==970 & year==1970
*/

  gen ysm1=year-yrimmig1
  replace ysm1=2.5 if ysm>=0 & ysm<=5
  replace ysm1=8 if ysm>=6 & ysm<=10
  replace ysm1=13 if (ysm>=11 & ysm<=15) | (yrimmig==970 & year==1980) | (yrimmig==980 & year==1990)
  replace ysm1=18 if ysm>=16 & ysm<=20
  replace ysm1=25.5 if (ysm>=21 & ysm<=30) | (yrimmig==970 & year==1990)
  *I think the next line is right - check
  replace ysm1=40 if ysm>=31 & ysm~=.
  replace ysm1=0 if ysm==.

  *Also create actual years since migration vars - consistent and inconsistent 

  *Create arrival cohort dummies
  gen impre50=0
  replace impre50=1 if yrimmig1<1950
  gen im5059=0
  replace im5059=1 if yrimmig1>=1950 & yrimmig1<=1959
  gen im6064=0
  replace im6064=1 if yrimmig1>=1960 & yrimmig1<=1964
  gen im6569=0
  replace im6569=1 if (yrimmig1>=1965 & yrimmig1<=1969 & year==2000) | (yrimmig==970 & (year==1970 | year==1980 | year==1990))
  gen im7074=0
  replace im7074=1 if yrimmig1>=1970 & yrimmig1<=1974 & im6569~=1
  *Need to deal with discrepancy between coding of those who arrived in 1980 in 1980 and 1990 Censuses
  gen im7579=0
  replace im7579=1 if (yrimmig1>=1975 & yrimmig1<=1979 & year==2000) | (yrimmig==980 & (year==1980 | year==1990))
  gen im8084=0
  replace im8084=1 if yrimmig1>=1980 & yrimmig1<=1984 & im7579~=1
  gen im8590=0
  replace im8590=1 if yrimmig1>=1985 & yrimmig1<=1990
  gen im9194=0
  replace im9194=1 if yrimmig1>=1991 & yrimmig1<=1994
  gen im9500=0
  replace im9500=1 if yrimmig1>=1995 & yrimmig1<=2000

  *Create age at arrival var (using oldest possible age)
  gen ageatarr=age if ysm>=0 & ysm<=5
  replace ageatarr=age-6 if ysm>=6 & ysm<=10
  replace ageatarr=age-11 if (ysm>=11 & ysm<=15) | (yrimmig==970 & year==1980) | (yrimmig==980 & year==1990)
  replace ageatarr=age-16 if ysm>=16 & ysm<=20
  replace ageatarr=age-21 if (ysm>=21 & ysm<=30) | (yrimmig==970 & year==1990)
  *I think the next line is right - check
  replace ageatarr=age-31 if ysm>=31 & ysm~=.
  replace ageatarr=0 if ageatarr<0

  *Create age at arrival var (using midpoint age)
  gen ageatarrmid=age-ysm1
  replace ageatarrmid=0 if ageatarrmid<0

  *Male YSM and cohort vars
  gen spysm=.
  replace spysm=year-spyrimmig1
  *What to do in following line??
  replace spysm=90 if spyrimmig==910 & year==2000
  replace spysm=87.5 if spyrimmig==911 & year==2000
  replace spysm=83 if spyrimmig==915 & year==2000
  replace spysm=68 if spyrimmig==930 & year==2000

  replace spysm=50 if spyrimmig==949 & year==1990
  replace spysm=35.5 if spyrimmig==959 & year==1990
  replace spysm=28 if spyrimmig==964 & year==1990
  replace spysm=23 if spyrimmig==970 & year==1990
  replace spysm=18 if spyrimmig==974 & year==1990
  replace spysm=13 if spyrimmig==980 & year==1990
  replace spysm=9.5 if spyrimmig==981 & year==1990
  replace spysm=7 if spyrimmig==984 & year==1990
  replace spysm=4.5 if spyrimmig==986 & year==1990
  replace spysm=1.5 if spyrimmig==990 & year==1990

  replace spysm=40 if spyrimmig==949 & year==1980
  replace spysm=25.5 if spyrimmig==959 & year==1980
  replace spysm=18 if spyrimmig==964 & year==1980
  replace spysm=13 if spyrimmig==970 & year==1980
  replace spysm=8 if spyrimmig==974 & year==1980
  replace spysm=2.5 if spyrimmig==980 & year==1980
/*
  replace spysm=65 if spyrimmig==914 & year==1970
  replace spysm=50.5 if spyrimmig==924 & year==1970
  replace spysm=40.5 if spyrimmig==934 & year==1970
  replace spysm=30.5 if spyrimmig==944 & year==1970
  replace spysm=23 if spyrimmig==949 & year==1970
  replace spysm=18 if spyrimmig==954 & year==1970
  replace spysm=13 if spyrimmig==959 & year==1970
  replace spysm=8 if spyrimmig==964 & year==1970
  replace spysm=2.5 if spyrimmig==970 & year==1970
*/

  gen spysm1=year-spyrimmig1
  replace spysm1=2.5 if spysm>=0 & spysm<=5
  replace spysm1=8 if spysm>=6 & spysm<=10
  replace spysm1=13 if (spysm>=11 & spysm<=15) | (spyrimmig==970 & year==1980) | (spyrimmig==980 & year==1990)
  replace spysm1=18 if spysm>=16 & spysm<=20
  replace spysm1=25.5 if (spysm>=21 & spysm<=30) | (spyrimmig==970 & year==1990)
  *I think the next line is right - check
  replace spysm1=40 if spysm>=31 & spysm~=.
  replace spysm1=0 if spysm==.

  *Also create actual years since migration vars - consistent and inconsistent 

  *Create arrival cohort dummies
  gen spimpre50=0
  replace spimpre50=1 if spyrimmig1<1950
  gen spim5059=0
  replace spim5059=1 if spyrimmig1>=1950 & spyrimmig1<=1959
  gen spim6064=0
  replace spim6064=1 if spyrimmig1>=1960 & spyrimmig1<=1964
  gen spim6569=0
  replace spim6569=1 if (spyrimmig1>=1965 & spyrimmig1<=1969 & year==2000) | (spyrimmig==970 & (year==1970 | year==1980 | year==1990))
  gen spim7074=0
  replace spim7074=1 if spyrimmig1>=1970 & spyrimmig1<=1974 & spim6569~=1
  *Need to deal with discrepancy between coding of those who arrived in 1980 in 1980 and 1990 Censuses
  gen spim7579=0
  replace spim7579=1 if (spyrimmig1>=1975 & spyrimmig1<=1979 & year==2000) | (spyrimmig==980 & (year==1980 | year==1990))
  gen spim8084=0
  replace spim8084=1 if spyrimmig1>=1980 & spyrimmig1<=1984 & spim7579~=1
  gen spim8590=0
  replace spim8590=1 if spyrimmig1>=1985 & spyrimmig1<=1990
  gen spim9194=0
  replace spim9194=1 if spyrimmig1>=1991 & spyrimmig1<=1994
  gen spim9500=0
  replace spim9500=1 if spyrimmig1>=1995 & spyrimmig1<=2000

  *Create age at arrival var (using oldest possible age)
  gen spageatarr=spage if spysm>=0 & spysm<=5
  replace spageatarr=spage-6 if spysm>=6 & spysm<=10
  replace spageatarr=spage-11 if (spysm>=11 & spysm<=15) | (spyrimmig==970 & year==1980) | (spyrimmig==980 & year==1990)
  replace spageatarr=spage-16 if spysm>=16 & spysm<=20
  replace spageatarr=spage-21 if (spysm>=21 & spysm<=30) | (spyrimmig==970 & year==1990)
  *I think the next line is right - check
  replace spageatarr=spage-31 if spysm>=31 & spysm~=.
  replace spageatarr=0 if spageatarr<0

  *Create age at arrival var (using midpoint age)
  gen spageatarrmid=spage-spysm1
  replace spageatarrmid=0 if spageatarrmid<0

  label define ysm 0 "N/A" 1 "0-5 years" 2 "6-10 years" 3 "11-15 years" 4 "16-20 years" 5 "21-30 years" 6 "31+ years"
  label values ysm ysm
  label values spysm ysm

  *Merge in source country data using year of arrival and Census year
  gen ipums_code=spbpld
  sort ipums_code
  merge ipums_code using "$path\Augmented country group codes"
  drop if _merge==2
  drop _merge
  rename ipums_code spipums_code
  rename final_label spfinal_label
  rename final_code spfinal_code
  gen ipums_code=bpld
  sort ipums_code
  merge ipums_code using "$path\Augmented country group codes"
  drop if _merge==2
  drop _merge

  gen yrimmig2=.
  replace yrimmig2=1950 if impre50==1
  replace yrimmig2=1955 if im5059==1
  replace yrimmig2=1960 if im6064==1
  replace yrimmig2=1965 if im6569==1
  replace yrimmig2=1970 if im7074==1
  replace yrimmig2=1975 if im7579==1
  replace yrimmig2=1980 if im8084==1
  replace yrimmig2=1985 if im8590==1
  replace yrimmig2=1990 if im9194==1
  replace yrimmig2=1995 if im9500==1

  gen spyrimmig2=.
  replace spyrimmig2=1950 if spimpre50==1
  replace spyrimmig2=1955 if spim5059==1
  replace spyrimmig2=1960 if spim6064==1
  replace spyrimmig2=1965 if spim6569==1
  replace spyrimmig2=1970 if spim7074==1
  replace spyrimmig2=1975 if spim7579==1
  replace spyrimmig2=1980 if spim8084==1
  replace spyrimmig2=1985 if spim8590==1
  replace spyrimmig2=1990 if spim9194==1
  replace spyrimmig2=1995 if spim9500==1

  *Give those born abroad to American parents zeros or missing values for all immigration vars
  foreach var of varlist ysm1 impre50-im9500 {
    replace `var'=0 if immigrant==0
  }
  foreach var of varlist ysm yrimmig1 yrimmig2 ageatarr ageatarrmid {
    replace `var'=. if immigrant==0
  }
  foreach var of varlist spysm1 spimpre50-spim9500 {
    replace `var'=0 if spimmigrant==0
  }
  foreach var of varlist spysm spyrimmig1 spyrimmig2 spageatarr spageatarrmid {
    replace `var'=. if spimmigrant==0
  }

  sort bpld yrimmig2
  merge bpld yrimmig2 using "$path\Source country data arrival date"
  drop if _merge==2
  drop _merge
  drop censusrate illegalrate i_censusrate
  sort spbpld spyrimmig2
  merge spbpld spyrimmig2 using "$path\Source country data arrival date (spouse)"
  drop if _merge==2
  drop _merge
  drop spcensusrate spillegalrate spi_censusrate

  foreach year2 of numlist 1980 1990 2000 {
    sort bpld
    merge bpld using "$path\Source country data current date `year2'"
    drop if _merge==2
    drop _merge
    sort spbpld
    merge spbpld using "$path\Source country data current date `year2' (spouse)"
    drop if _merge==2
    drop _merge
  }

  sort bpld year
  merge bpld year using "$path\Source country data current date"
  drop if _merge==2
  drop _merge
  sort spbpld year
  merge spbpld year using "$path\Source country data current date (spouse)"
  drop if _merge==2
  drop _merge

  save "$path\Census `year' Immigrant data", replace
}

erase "$path\Augmented country group codes.dta"
erase "$path\Source country data arrival date.dta"
erase "$path\Source country data arrival date (spouse).dta"
erase "$path\Source country data current date.dta"
erase "$path\Source country data current date (spouse).dta"
erase "$path\Source country data current date 1980.dta"
erase "$path\Source country data current date 1980 (spouse).dta"
erase "$path\Source country data current date 1990.dta"
erase "$path\Source country data current date 1990 (spouse).dta"
erase "$path\Source country data current date 2000.dta"
erase "$path\Source country data current date 2000 (spouse).dta"
