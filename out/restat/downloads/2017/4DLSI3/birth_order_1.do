**************************************************************************
/********************** Effects of birth order **************************/
/********************* on non-cognitive skills **************************/
/***************** Review of Economics and Statistics *******************/
**************************************************************************

cd C:\Users\bjooc\Projekt_pagaende\Birth_order\Archive

* 1. Define population: (1) Mothers born 1918-1964, (2) who are born in Sweden or who have immigrated before age 15, and (3) who have only single-births and who have no adopted children.

* The objective is to keep families were the mother can be observed over the main fertile ages (16-45 year)  
* The generational register starts for the 1932 birth cohorts, but not all individuals are covered in the beginning of the panel. Starting with the 1934 birth cohort, more than 80 percent of the individuals (born in Sweden) can be linked to the mother. 
* The information on birth order and family size comes from the generational register and is only based on links to individuals in the register. Individuals who are born before 1932 (or individuals who are born later but not covered by the register) are not used to calculate birth order and family size. Thus, the information on family size and birth order is likely to be underreported for the first cohorts in the register. 
* The information on births ends in 2009
* Restrict the sample to mothers who are at least 16 years in 1934 (born 1918) and who are at the most 45 years in 2009 (born 1964). 
* The data cover 47 birth cohorts of mothers.

use idnr idnrc yob mob woman bcounty if yob>=1932 & yob<=2009 using C:\Data\Education-data\Population-data\pop2.dta, clear 

merge idnr using C:\Data\Education-data\Generation-data\gen_2009_4.dta, keep(idnr midnr fidnr amidnr afidnr mbcounty fbcounty ambcounty afbcounty mochild mnchild myob amyob fyob afyob) 
drop if _merge==2
drop _merge 

* Drop individuals without information on biological mother 
drop if midnr==.

* Drop families with varying information about the mother, probably due to non-unique mother.
sort midnr myob mbcounty mnchild
gen temp1=((midnr==midnr[_n-1] & ((myob!=myob[_n-1]) | (mbcounty!=mbcounty[_n-1]) | (mnchild!=mnchild[_n-1]))) | (midnr==midnr[_n+1] & ((myob!=myob[_n+1]) | (mbcounty!=mbcounty[_n+1]) | (mnchild!=mnchild[_n+1]))))
egen temp2=max(temp1), by(midnr)
drop if temp2==1
drop temp*

* Restrict the sample to mothers who are at least 16 years in 1934 (born 1918) and who are at the most 45 years in 2009 (born 1964). 
keep if myob>=1918 & myob<=1976

* Drop mothers who immigrated after age 14 or who have non-unique identifier
rename idnr oidnr
rename idnrc oidnrc

rename midnr idnr
sort idnr
merge idnr using C:\Data\Education-data\Population-data\pop2.dta, keep(fimdate idnrc)
drop if _merge==2
drop _merge
rename idnr midnr
rename fimdate mfimdate
keep if idnrc==0 & (mfimdate==. | (mfimdate!=. & (int(mfimdate/10000)-myob)<=14))
drop mfimdate idnrc

rename oidnr idnr
rename oidnrc idnrc

* Drop families with twins, children born abroad, or were some children have non-unique personal identifiers, since the information on family size and birth order is not reliable for them
sort midnr yob mob
gen temp1=1 if ((yob==yob[_n-1] & mob==mob[_n-1] & midnr==midnr[_n-1]) | (yob==yob[_n+1] & mob==mob[_n+1] & midnr==midnr[_n+1]))
gen temp2=1 if (temp1==1 | bcounty==. | idnrc==1)
egen temp3=max(temp2), by(midnr)
drop if temp3==1
drop temp* idnrc

* Generate an indicator for being a Swedish-born adoptee
gen adoptee=1 if bcount<=25 & (midnr!=. & amidnr!=. & afidnr!=. & amidnr!=midnr & afidnr!=fidnr)
lab var adoptee "adoptee"

* Generate birth order in families with adoptive children 
gen atmidnr=midnr
replace atmidnr=amidnr if amidnr!=.
egen adfam=max(adoptee), by(atmidnr)
sort atmidnr yob mob
egen amochild=seq() if adfam==1, by(atmidnr)
egen amnchild=count(1) if adfam==1, by(atmidnr)
lab var atmidnr "adoptive mother identity number, total"
lab var adfam "adoptive family"
lab var amochild "order of child, adoptive mother"
lab var amnchild "number of children, adoptive mother"
drop amidnr afidnr ambcounty afbcounty amyob afyob bcounty mbcounty fbcounty

* Drop families with adoptive children (but not families who have put up their children for adoption)
drop if adfam==1 & adoptee!=1
drop adfam atmidnr amochild amnchild

* Drop families with inconstistency in the number of children and the number of observed siblings
* Note that this may drop a few (about 300) families with children who born and die in the same year. This is mainly for individuals born 1994 or later.
egen temp1=count(idnr), by(midnr)
gen temp2=mnchild-temp1
gen temp3=temp2!=0
egen temp4=max(temp3), by(midnr)
drop if temp4==1 
drop temp*

* Generate variables on mother's and father's age at birth
rename idnr oidnr
rename mob omob

rename midnr idnr
sort idnr
merge idnr using C:\Data\Education-data\Population-data\pop2.dta, keep(mob)
drop if _merge==2
drop _merge
rename idnr midnr
rename mob mmob

rename fidnr idnr
sort idnr
merge idnr using C:\Data\Education-data\Population-data\pop2.dta, keep(mob)
drop if _merge==2
drop _merge
rename idnr fidnr
rename mob fmob

rename oidnr idnr
rename omob mob

gen dob=15
replace dob=14 if mob==2
gen db=mdy(mob, dob, yob)
lab var db "date of birth"

replace mmob=6 if mmob==.
gen mdob=15
replace mdob=14 if mmob==2
gen mdb=mdy(mmob, mdob, myob)
lab var mdb "mother's date of birth"

gen mbage=db-mdb
lab var mbage "mother's age at birth, days"
egen mfbage=min(mbage), by(midnr)
lab var mfbage "mother's age at first birth, days"
drop dob mdob mdb

gen fdob=15
replace fdob=14 if fmob==2
gen fdb=mdy(fmob, fdob, fyob)
lab var fdb "father's date of birth"
drop fdob fmob fdb mmob

* Add mortality data
sort idnr
merge idnr using C:\data\Education-data\Population-data\death_61_09_1.dta, keep(yod mod dod)
drop if _merge==2
drop _merge

gen dd=mdy(mod, dod, yod)
lab var dd "date of death, days"
drop yod mod dod

* Generate variables for biological and social birth order
sort midnr mochild
egen mochildad=seq() if ((dd-db)/365.25)>0.2 & adoptee!=1, by(midnr)
lab var mochildad "mother order of child, excluding dead and adopted siblings"

sort midnr mochild
egen mochildw=seq() if woman==1, by(midnr)
replace mochildw=0 if mochildw==.
lab var mochildw "mother order of child, girls"

sort midnr mochild
egen mochildm=seq() if woman==0, by(midnr)
replace mochildm=0 if mochildm==.
lab var mochildm "mother order of child, boys"
drop dd adoptee

sort midnr
save bo_data_1.dta, replace

* 2. Add identity of biological siblings (restricting to five siblings)
use idnr yob mob woman midnr mochild using C:\Data\Education-data\Generation-data\gen_2009_4.dta, clear
drop if midnr==.

* Drop a few observations where the mother has multiple children with the same birth order
egen temp1=count(idnr), by(midnr mochild)
egen temp2=max(temp1), by(midnr)
keep if temp2==1
drop temp*

drop if mochild>5

gen dob=15
replace dob=14 if mob==2

gen db=mdy(mob, dob, yob)
lab var db "date of birth"

drop yob mob dob

reshape wide idnr woman db, i(midnr) j(mochild)

forvalues X=1/5 {
	rename woman`X' swoman`X' 
	lab var swoman`X' "woman, sibling `X'"
	rename db`X' sdb`X' 
	lab var sdb`X' "date of birth, sibling `X'"
	}

sort midnr
merge midnr using bo_data_1.dta

drop if _merge==1
drop _merge

sort idnr
save bo_data_1.dta, replace

* 3. Add information on parental education and earnings
use bo_data_1.dta, clear
keep idnr midnr fidnr fyob

* a. Biological mother's educational attainment
rename idnr oidnr
rename midnr idnr
sort idnr
merge idnr using C:\Data\Education-data\Louise-data\education_1960_2009_midage_2.dta, keep(melength)
drop if _merge==2
drop _merge

sort idnr
merge idnr using C:\Data\Education-data\Louise-data\education_level_1960_2009_midage_1.dta
drop if _merge==2
drop _merge

sort idnr
merge idnr using C:\Data\Education-data\Louise-data\earnings_1960_2009_lifecycle_2.dta, keep(pmlnearn)
drop if _merge==2
drop _merge

rename idnr midnr
rename melength medu
rename medlev medl
rename pmlnearn mplnearn
lab var medu "mother's years of schooling"
lab var medl "mother's highest educational level"
lab var mplnearn "mother's log-earnings, pctl"

* b. Biological father's educational attainment and earnings
rename fidnr idnr
sort idnr
merge idnr using C:\Data\Education-data\Louise-data\education_1960_2009_midage_2.dta, keep(melength)
drop if _merge==2
drop _merge

sort idnr
merge idnr using C:\Data\Education-data\Louise-data\education_level_1960_2009_midage_1.dta
drop if _merge==2
drop _merge

sort idnr
merge idnr using C:\Data\Education-data\Louise-data\earnings_1960_2009_lifecycle_2.dta, keep(pmlnearn)
drop if _merge==2
drop _merge

rename idnr fidnr
rename melength fedu
rename medlev fedl
rename pmlnearn fplnearn
lab var fedu "father's years of schooling"
lab var fedl "father's highest educational level"
lab var fplnearn "father's log-earnings, pctl"

rename oidnr idnr

sort idnr
merge idnr using bo_data_1.dta
drop _merge

sort idnr
save bo_data_2.dta, replace

* 4. Adding information on cognitive and non-cognitive abilities at the military draft (men born 1951-1982)
use idnr yob woman using bo_data_2.dta, replace

sort idnr
merge idnr using "C:\Data\Education-data\Draft-data\draft2_sp.dta", keep(test sc sclog scverb scspat sctech snc)
drop if _merge==2
drop _merge

replace sc=. if (yob<1951 | yob>1987)
replace sclog=. if (yob<1951 | yob>1987)
replace scverb=. if (yob<1951 | yob>1987)
replace scspat=. if (yob<1951 | yob>1987)
replace sctech=. if (yob<1951 | yob>1987)
replace snc=. if (yob<1951 | yob>1987)

sort idnr
merge idnr using bo_data_2.dta
drop _merge

compress
sort idnr
save bo_data_3.dta, replace

* 5. Add information on wages, employment and occupation  
use idnr using bo_data_3.dta, clear

sort idnr
merge idnr using C:\data\Education-data\Wage-data\wage_midage_2.dta, keep(wage nwweight)
drop if _merge==2
drop _merge

rename nwweight wweight
lab var wweight "weight, wages"

lab var wage "wage, mid-age"
gen lnwage=ln(wage)
lab var lnwage "log-wage, mid-age"

sort idnr
merge idnr using C:\data\Education-data\Louise-data\empl_midage_1.dta, keep(empl)
drop if _merge==2
drop _merge

sort idnr
merge idnr using C:\data\Education-data\Louise-data\self_empl_midage_1.dta, keep(selfemp)
drop if _merge==2
drop _merge

replace empl=0 if empl==1 & selfemp==1

* Occupational data to use for description of occupational sorting (Table A.1)
* Restricted to cohorts born 1941-74 (35-55 years in 1996-2009)
sort idnr
merge idnr using C:\data\Education-data\Wage-data\occ_midage_panel_alt_2.dta, keep(nwweight ceo* jcreate)
drop if _merge==2
drop _merge

drop ceop

rename nwweight noweighta
lab var noweight "weight, occupations, alternative"
rename ceopp ceoppa
lab var ceoppa "manager in private firms or public organisations, alternative"
rename ceopb ceopba
lab var ceopba "managers, broad definition, alternative"
rename jcreate jcreatea
lab var jcreatea "creative occupations, alternative"

sort idnr
merge idnr using C:\data\Education-data\Wage-data\occ_midage_3.dta, keep(nwweight ceopp ceopb jcreate sv1A1 sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o)
drop if _merge==2
drop _merge

rename nwweight noweight
lab var noweight "weight, occupations"

sort idnr
merge idnr using bo_data_3.dta
drop _merge

compress
sort idnr
save bo_data_4.dta, replace

* 6. Generate analysis variables 
use bo_data_4.dta, clear

* Generate birth order variables
gen bo_2=mochild==2
gen bo_3=mochild==3
gen bo_4=mochild==4
gen bo_5=mochild==5
lab var bo_2 "second child"
lab var bo_3 "third child"
lab var bo_4 "fourth child"
lab var bo_5 "fifth child"

gen boad_2=mochildad==2
gen boad_3=mochildad==3
gen boad_4=mochildad==4
gen boad_5=mochildad==5
lab var boad_2 "second child, excluding adopted and dead siblings"
lab var boad_3 "third child, excluding adopted and dead siblings"
lab var boad_4 "fourth child, excluding adopted and dead siblings"
lab var boad_5 "fifth child, excluding adopted and dead siblings"

gen ss_bo_2=mochildw==2
gen ss_bo_3=mochildw==3
gen ss_bo_4=mochildw==4
gen ss_bo_5=mochildw==5
replace ss_bo_2=1 if mochildm==2
replace ss_bo_3=1 if mochildm==3
replace ss_bo_4=1 if mochildm==4
replace ss_bo_5=1 if mochildm==5
lab var ss_bo_2 "second child, same sex"
lab var ss_bo_3 "third child, same sex"
lab var ss_bo_4 "fourth child, same sex"
lab var ss_bo_5 "fifth child, same sex"

* Generate variables on year of birth of siblings
gen syob1=year(sdb1)
gen syob2=year(sdb2)
gen syob3=year(sdb3)
gen syob4=year(sdb4)
gen syob5=year(sdb5)
lab var syob1 "year of birth, sibling 1"
lab var syob2 "year of birth, sibling 2"
lab var syob3 "year of birth, sibling 3"
lab var syob4 "year of birth, sibling 4"
lab var syob5 "year of birth, sibling 5"
drop sdb1 sdb2 sdb3 sdb4 sdb5

replace syob1=0 if syob1==.
replace syob2=0 if syob2==.
replace syob3=0 if syob3==.
replace syob4=0 if syob4==.
replace syob5=0 if syob5==.

replace medl=0 if medl==.
replace fedl=0 if fedl==.
replace medu=10 if medu==.

drop mbage mfbage
gen mbage=yob-myob
egen mfbage=min(mbage), by(midnr)
lab var mbage "mother's age at birth"
lab var mfbage "mother's age at first birth"

compress
sort idnr
save bo_1.dta, replace

* 7. Generate analysis data with ETF-data
* In population-wide data, it is enough to control for family size FE to obtain balance in all  family-constant characteristics by birth order.
* If the model includes year of birth FE, it is necessary to also control for the interaction between family size and all observed siblings' year of birth to obtain balance.
* Identification is only possible for family types with at least to children born in the years covered by the ETF-data.
* It is enough to control for the year of birth that can be sampled in the ETF-data.
use idnr yob mob woman midnr myob mnchild mochild medl mfbage mbage bo_2 bo_3 bo_4 bo_5 syob1 syob2 syob3 syob4 syob5 swoman* ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5 snc using bo_1.dta, clear

* Drop families without siblings
drop if mnchild==1

* Drop families with more than five children
drop if mnchild>5

sort idnr
merge idnr using C:\Data\Education-data\UGU-data\ugu1.dta, keep(idnr cohort)
keep if _merge==3
drop _merge

keep if (cohort==1967 | cohort==1972 | cohort==1977 | cohort==1982 | cohort==1987 | cohort==1992)

* Only use the ETF cohorts
gen nsyob1=syob1 if (syob1==1967 | syob1==1972 | syob1==1977 | syob1==1982 | syob1==1987 | syob1==1992)
replace nsyob1=0 if nsyob1==.
gen nsyob2=syob2 if (syob2==1967 | syob2==1972 | syob2==1977 | syob2==1982 | syob2==1987 | syob2==1992)
replace nsyob2=0 if nsyob2==.
gen nsyob3=syob3 if (syob3==1967 | syob3==1972 | syob3==1977 | syob3==1982 | syob3==1987 | syob3==1992)
replace nsyob3=0 if nsyob3==.
gen nsyob4=syob4 if (syob4==1967 | syob4==1972 | syob4==1977 | syob4==1982 | syob4==1987 | syob4==1992)
replace nsyob4=0 if nsyob4==.
gen nsyob5=syob5 if (syob5==1967 | syob5==1972 | syob5==1977 | syob5==1982 | syob5==1987 | syob5==1992)
replace nsyob5=0 if nsyob5==.
egen fcomp=group(mnchild nsyob1 nsyob2 nsyob3 nsyob4 nsyob5)
lab var fcomp "family composition, etf year of birth"

replace swoman1=0 if swoman1==.
replace swoman2=0 if swoman2==.
replace swoman3=0 if swoman3==.
replace swoman4=0 if swoman4==.
replace swoman5=0 if swoman5==.
egen fcompa=group(mnchild nsyob1 nsyob2 nsyob3 nsyob4 nsyob5 swoman1 swoman2 swoman3 swoman4 swoman5)
lab var fcompa "family composition, etf year of birth and gender"
drop nsyob*

sort idnr
merge idnr using C:\Data\Education-data\UGU-data\ugu1.dta, keep(cohort weight mfhome3 mfasp3 mtalkf3 ftalkf3 homewh6 homewmh6 mfhomef6 mfhome6 homewf6 mfhomej6 mfasp6 mtalkf6 ftalkf6 mftalk6 mftalka6 mftalkb6 mftalkc6 preadbook homewfb6 fhomef6 mhomef6 wtvh6 pcomph6 wtvf6 pcompf6 homewh9 mfhomej9 mfaspa3 mfaspa6 wtvh9 pcomph9)

replace weight=1

egen mftalkf3=rmax(mtalkf3 ftalkf3)
lab var mftalkf3 "parents talk about school/week, grade 3"
drop mtalkf3 ftalkf3

egen mftalkf6=rmax(mtalkf6 ftalkf6)
lab var mftalkf6 "parents talk about school/week, grade 6"
drop mtalkf6 ftalkf6

* Percentile rank variables

program drop _all
program define perc 
	{
	local k 1
	while `k'<=25 {
	sort cohort ``k''
	by cohort: gen temp1=sum(weight) if ``k''!=. & weight!=0
	egen temp2=max(temp1) if ``k''!=. & weight!=0, by(cohort ``k'')
	sort cohort ``k''
	gen temp3=temp2[_n-1] if ``k''>``k''[_n-1] & ``k''!=. & weight!=0 & cohort==cohort[_n-1]
	egen temp4=max(temp3) if ``k''!=. & weight!=0, by(cohort ``k'')
	replace temp4=0 if temp4==. & ``k''!=. & weight!=0
	replace temp4=temp4+1 if ``k''!=. & weight!=0
	egen temp5=total(weight) if ``k''!=. & weight!=0, by(cohort)
	gen p``k''=((temp2+temp4)/2-0.5)/temp5*100 if ``k''!=. & weight!=0
	lab var p``k'' "weighted pctile rank, ``k''"
	drop temp* /*``k''*/
	local k=`k'+1
	}
	}
end
perc mfhome3 mftalkf3 mfasp3 homewh6 homewf6 homewfb6 mfhomef6 mfhome6 mfhomej6 mfasp6 mftalk6 mftalka6 mftalkb6 mftalkc6 mftalkf6 wtvf6 wtvh6 wtvh9 pcompf6 pcomph6 pcomph9 homewh9 mfhomej9 mfaspa3 mfaspa6 
program drop _all

rename pmftalkf3 pmftalk3

* Generating variables
* 1. Time spent on homework (1967, 1972, 1977, 1982)
* Hours/week
gen temp1=homewf6
replace temp1=2 if temp1==0.5
replace temp1=homewfb6 if temp1==.
egen temp2=mean(homewh6) if temp1!=., by(temp1) 
gen homew6=homewh6
replace homew6=temp2 if homew6==.
lab var homew6 "time spent on homework, hours, grade 6"
drop temp*

* The average number of homework (and the variance) is very similar in 6th and 9th grade (for the 1992 birth cohort)
gen homew=homew6
replace homew=homewh9 if homew==.
lab var homew "time spent on homework, hours, grade 6 or 9"

* 2. Reading books (1967, 1972, 1977, 1982)
* Percentile rank
gen prbook6=preadbook
lab var prbook6 "read books"

* 3. Non-school-related out-of-school activities
* a. Watch TV/Video (1967, 1972, 1977, 1982, 1987, 1992)
* Hours/day
replace wtvh6=0 if wtvf6==1
replace wtvh6=0.75 if wtvf6==2
replace wtvh6=1.5 if wtvf6==3
replace wtvh6=3 if wtvf6==4
replace pwtvh6=pwtvf6 if pwtvh6==.

gen wtvh=wtvh6
replace wtvh=wtvh9 if wtvh==.
lab var wtvh "watch tv, hours/day, grade 6 or 9"

* b. Play computer games (1982, 1987, 1992)
* Hours/day
replace pcomph6=0 if (pcompf6==1 | pcompf6==2)
replace pcomph6=0.5 if pcompf6==3
replace pcomph6=2 if pcompf6==4
lab var pcomph6 "play computer games tv, hours/day, grade 6"

gen pcomph=pcomph6
replace pcomph=pcomph9 if pcomph==.
lab var pcomph "play computer games tv, hours/day, grade 6 or 9"

* c. Watch TV or play computer games (1967, 1972, 1977, 1982, 1987, 1992)
gen tvcomph6=wtvh6
replace tvcomph6=tvcomph6+pcomph6 if pcomph6!=.
lab var tvcomph6 "tv or computer games, hours, grade 6"

gen tvcomph=wtvh
replace tvcomph=tvcomph+pcomph if pcomph!=.
lab var tvcomph "tv or computer games, hours, grade 6 or 9"

* 4. Parental support
* a. Help with homework (1967, 1972, 1977, 1982, 1992)
* Incidence
gen mfhomet6=mfhome6 if cohort<=1972
replace mfhomet6=0 if mfhomef6==0 & cohort>=1977 & cohort<=1982
replace mfhomet6=1 if mfhomef6>0 & mfhomef6!=. & cohort>=1977 & cohort<=1982
* Judging from the distribution of answers, getting help with homework 1967-82 corresponds roughly to getting help with homework almost always in 1992.
replace mfhomet6=0 if (mfhomej6==1 | mfhomej6==2 | mfhomej6==3) & cohort==1992
replace mfhomet6=1 if (mfhomej6==4 | mfhomej6==5) & cohort==1992
lab var mfhomet6 "parental help with homework, incidence, grade 6"

gen mfhomet=mfhomet6
replace mfhomet=0 if (mfhomej9==1 | mfhomej9==2 | mfhomej9==3) & cohort==1987
replace mfhomet=1 if (mfhomej9==4 | mfhomej9==5) & cohort==1987
replace mfhomet=0 if mfhomet==. & (mfhomej9==1 | mfhomej9==2 | mfhomej9==3) & cohort==1992
replace mfhomet=1 if mfhomet==. & (mfhomej9==4 | mfhomej9==5) & cohort==1992
replace mfhomet=mfhome3 if mfhomet==. & cohort==1972
lab var mfhomet "parental help with homework, incidence, grade 3, 6 or 9"

* b. Talk about school work (1967, 1977, 1982, 1992)
* Percentile rank
replace pmftalk6=pmftalkf6 if pmftalk6==.
lab var pmftalk6 "parents talk about school work, pctile, grade 6"

gen pmftalk=pmftalk6 
replace pmftalk=pmftalk3 if pmftalk==.
lab var pmftalk "parents talk about school work, pctile, grade 3 or 6"
drop pmftalkf6 mftalk6 mftalkf6

* 5. Parental expectations
* Educational aspiration (1967, 1972, 1977)
* pmfasp6

* Generate standardized test scores, by cohort
program drop _all
program define pgrade
    	{
  	local k 1
    	while `k'<=3 {
 	gen s``k''=.
	lab var s``k'' "standardized ``k'', by cohort"
 	local i 1967
    	while `i'<=1992 {
	sum ``k'' if cohort==`i'
	gen temp1=r(mean)
	gen temp2=r(sd)
	replace s``k''=(``k''-temp1)/temp2 if cohort==`i'
	drop temp*
	local i=`i'+5
   	} 
	local k=`k'+1
   	} 
	}
end
pgrade prbook6 pmftalk pmfasp6
program drop _all

lab var homew "home work, grade 6 or 9, hours"
lab var sprbook6 "read books, grade 6, std"
lab var tvcomph "watch tv or play computer, grade 6 or 9, hours"
lab var mfhomet "parents help with homework, grade 3, 6 or 9, incidence"
lab var spmftalk "parents talk about school work, grade 3 or 6, std"
lab var spmfasp6 "parents' expectations, grade 6, std"

drop wtvh6 homewh6 mfhome6 mfasp6 homewf6 preadbook mfaspa6 mfasp3 mfhome3 homewfb6 homewmh6 mfaspa3 mfhomef6 mhomef6 fhomef6 mftalka6 mftalkb6 mftalkc6 pcomph6 homewh9 wtvh9 pcomph9 mfhomej9 mfhomej6 wtvf6 pcompf6 mftalkf3 pmfhome3 pmftalk3 pmfasp3 phomewh6 phomewf6 phomewfb6 pmfhomef6 pmfhome6 pmfhomej6 pmfasp6 pmftalk6 pmftalka6 pmftalkb6 pmftalkc6 pwtvf6 pwtvh6 pwtvh9 ppcompf6 ppcomph6 ppcomph9 phomewh9 pmfhomej9 pmfaspa3 pmfaspa6 homew6 prbook6 wtvh pcomph tvcomph6 mfhomet6 pmftalk   

keep if _merge==3
drop _merge

sort idnr
save bo_etf_1.dta, replace

* 8. Generate analysis sample
* The sample is restricted to boys born 1952-82 with valid draft records in families were at least two children are observed. 
use bo_1.dta, clear

* Keep mothers born 1918-1964
keep if myob>=1918 & myob<=1964

* Keep men born 1952-1982 with valid draft records
keep if woman==0 & yob>=1952 & yob<=1982 & sc!=. & snc!=. & mnchild<=5 & mochildad!=. 

* Keep families with at least two observed children
egen temp1=count(idnr), by(midnr)
keep if temp1>=2 
drop temp*

* In population-wide data, it is enough to control for family size FE to obtain balance in all  family-constant characteristics by birth order.
* If the model includes year of birth FE, it is necessary to also control for the interaction between family size and all observed siblings' year of birth to obtain balance.
* Since the analysis sample is restricted by gender and year of birth, it is necessary to control for the interaction between family size, birth order and the year of birth for all observed children.

* Observed siblings' birth order
bysort midnr (yob): gen temp1=mochild if _n==1
bysort midnr (yob): gen temp2=mochild if _n==2
bysort midnr (yob): gen temp3=mochild if _n==3
bysort midnr (yob): gen temp4=mochild if _n==4
bysort midnr (yob): gen temp5=mochild if _n==5
egen sobsbo1=max(temp1), by(midnr)
egen sobsbo2=max(temp2), by(midnr)
egen sobsbo3=max(temp3), by(midnr)
egen sobsbo4=max(temp4), by(midnr)
egen sobsbo5=max(temp5), by(midnr)
replace sobsbo1=0 if sobsbo1==.
replace sobsbo2=0 if sobsbo2==.
replace sobsbo3=0 if sobsbo3==.
replace sobsbo4=0 if sobsbo4==.
replace sobsbo5=0 if sobsbo5==.
drop temp*

* Observed siblings' year of birth
bysort midnr (yob): gen temp1=yob if _n==1
bysort midnr (yob): gen temp2=yob if _n==2
bysort midnr (yob): gen temp3=yob if _n==3
bysort midnr (yob): gen temp4=yob if _n==4
bysort midnr (yob): gen temp5=yob if _n==5
egen sobsyob1=max(temp1), by(midnr)
egen sobsyob2=max(temp2), by(midnr)
egen sobsyob3=max(temp3), by(midnr)
egen sobsyob4=max(temp4), by(midnr)
egen sobsyob5=max(temp5), by(midnr)
replace sobsyob1=0 if sobsyob1==.
replace sobsyob2=0 if sobsyob2==.
replace sobsyob3=0 if sobsyob3==.
replace sobsyob4=0 if sobsyob4==.
replace sobsyob5=0 if sobsyob5==.
drop temp*

egen fcomp=group(mnchild sobsbo1 sobsbo2 sobsbo3 sobsbo4 sobsbo5 sobsyob1 sobsyob2 sobsyob3 sobsyob4 sobsyob5) 
lab var fcomp "family composition"
drop sobsbo1 sobsbo2 sobsbo3 sobsbo4 sobsbo5 sobsyob1 sobsyob2 sobsyob3 sobsyob4 sobsyob5

sort idnr
save bo_skills_1.dta, replace


******************************************************************************
/*************************** Generating main tables *************************/
******************************************************************************

* Table 1. Descriptive statistics - Main data
use bo_skills_1.dta, clear

* Generate age in 2010
gen age=round((mdy(6,1,2010)-db)/365.25, .01)
lab var age "age"

* Indicator for sibling who have been adopted away or died
gen oldsibad=mochild!=mochildad & mochildad!=.
lab var oldsibad "older sibling dead or adopted away"

program drop _all
program define msum 
	{
	local var "snc mnchild age mfbage medu" /*  */

	quietly log using tab_1.log, replace
	quietly log off

	local restr_0 "" 
	local restr_1 "if mochild==1" 
	local restr_2 "if mochild==2"
	local restr_3 "if mochild==3"
	local restr_4 "if mochild==4"
	local restr_5 "if mochild==5"

	local k 0		/* Restriction */
	while `k'<=5 {
	quietly log on
	display "restriction: `restr_`k''" 
	quietly log off

    	tokenize `var'
   	foreach x in `var' {
   	sum `x' `restr_`k''
    	local mean=round(r(mean),.001)
    	local sd=round(r(sd),.001)
    	local n=r(N)
    	local lab: variable label `x'
    	quietly log on
    	*display  "`lab'"
    	display  "`mean'"
    	display "(`sd')"
    	quietly log off
	}
    	sum idnr `restr_`k''
    	local n=r(N)
    	quietly log on
    	display  "Obs."
    	display "`n'"
    	quietly log off
	
	local k=`k'+1
	}
    	quietly log close
	}
end
msum    
program drop _all


* Table 2. Descriptive statistics - employment and occupational data
* Appendix Table B1. Descriptive statistics, females
use if yob>=1941 & yob<=1974 & myob>=1918 & myob<=1964 & mnchild<=5 & mochildad!=. & empl!=.  using bo_1.dta, clear

* Keep families with at least two observed children with same gender
egen temp1=count(idnr), by(midnr woman)
keep if temp1>=2 
drop temp*

program drop _all
program define msum 
	{
	local var "empl selfemp ceopp ceopb jcreate sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o" /*  */

	quietly log using tab_2.log, replace
	quietly log off

	local restr_0 "" 
	local restr_1 "& mochild==1" 
	local restr_2 "& mochild==2"
	local restr_3 "& mochild==3"
	local restr_4 "& mochild==4"
	local restr_5 "& mochild==5"

	local restrb_1 "if woman==0" 
	local restrb_2 "if woman==1" 

	local m 1		/* Restriction */
	while `m'<=2 {
	local k 0		/* Restriction */
	while `k'<=5 {
	quietly log on
	display "restriction: `restrb_`m'' `restr_`k''" 
	quietly log off

    	tokenize `var'
   	foreach x in `var' {
   	if ("`x'"=="empl" | "`x'"=="selfemp") {
   	sum `x' `restrb_`m'' `restr_`k'' 
   	}
   	else {
   	sum `x' `restrb_`m'' `restr_`k'' [aw=noweight]
   	}
    	local mean=round(r(mean),.001)
    	local sd=round(r(sd),.001)
    	local n=r(N)
    	local lab: variable label `x'
    	quietly log on
    	*display  "`lab'"
    	display  "`mean'"
    	display "(`sd')"
    	quietly log off
	}
    	sum idnr `restrb_`m'' `restr_`k'' 
    	local n=r(N)
    	quietly log on
    	display  "Obs."
    	display "`n'"
    	quietly log off
	
	local k=`k'+1
	}
	local m=`m'+1
	}
    	quietly log close
	}
end
msum    
program drop _all

* Table 3. Birth order effects on non-cognitive ability
use using bo_skills_1.dta, clear
gen sc2=sc^2
gen sc3=sc^3
gen sclog2=sclog^2
gen sclog3=sclog^3
gen scverb2=scverb^2
gen scverb3=scverb^3
gen scspat2=scspat^2
gen scspat3=scspat^3
gen sctech2=sctech^2
gen sctech3=sctech^3

* Panel a. Family size FE 
reg snc bo_2 bo_3 bo_4 bo_5 i.myob i.yob i.mfbage i.mnchild, vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3a.doc, se dec(3) replace label nocons title("Table 3a. Birth order effects on non-cognitive ability, Panel A. Family size FE") ctitle("All families")
reg snc bo_2 bo_3 bo_4 bo_5 i.myob i.yob i.mfbage if mnchild==2, vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3a.doc, se dec(3) append label nocons ctitle("Two child family")
reg snc bo_2 bo_3 bo_4 bo_5 i.myob i.yob i.mfbage if mnchild==3, vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3a.doc, se dec(3) append label nocons ctitle("Three child family")
reg snc bo_2 bo_3 bo_4 bo_5 i.myob i.yob i.mfbage if mnchild==4, vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3a.doc, se dec(3) append label nocons ctitle("Four child family")
reg snc bo_2 bo_3 bo_4 bo_5 i.myob i.yob i.mfbage if mnchild==5, vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3a.doc, se dec(3) append label nocons ctitle("Five child family")
reg snc bo_2 bo_3 bo_4 bo_5 i.myob i.yob i.mfbage sc sc2 sc3 sclog sclog2 sclog3 scverb scverb2 scverb3 scspat scspat2 scspat3 sctech sctech2 sctech3, vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3a.doc, se dec(3) append label nocons ctitle("All, conditional on cognitive abilities")

* Panel b. Family FE 
xtset midnr
areg snc bo_2 bo_3 bo_4 bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3b.doc, se dec(3) replace label nocons title("Table 3b. Birth order effects on non-cognitive ability, Panel B. Family FE") ctitle("All families")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==2, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3b.doc, se dec(3) append label nocons ctitle("Two child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==3, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3b.doc, se dec(3) append label nocons ctitle("Three child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==4, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3b.doc, se dec(3) append label nocons ctitle("Four child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==5, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3b.doc, se dec(3) append label nocons ctitle("Five child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob sc sc2 sc3 sclog sclog2 sclog3 scverb scverb2 scverb3 scspat scspat2 scspat3 sctech sctech2 sctech3, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_3b.doc, se dec(3) append label nocons ctitle("All, conditional on cognitive abilities")

* Table 4. Effects of birth order on children’s employment and occupational sorting
* Table 5. Effects of birth order on sorting into jobs with different skill requirements
* Table 6. Effects of birth order and siblings’ gender composition on children’s employment and occupational sorting
* Table A9. Effects of birth order and siblings’ gender composition on sorting into jobs with different skill requirements
* Apendix B Table 2. Effects of birth order on children’s employment and occupational sorting, females
* Apendix B Table 3. Effects of birth order on sorting into jobs with different skill requirements, females
* Apendix B Table 4. Effects of birth order and siblings’ gender composition on children’s employment and occupational sorting, females
* Apendix B Table 5. Effects of birth order and siblings’ gender composition on sorting into jobs with different skill requirements, females

* Population data
use idnr yob woman midnr myob mnchild mochildad bo_2 bo_3 bo_4 bo_5 ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5 empl selfemp ceopp ceopb jcreate sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o noweight if yob>=1941 & yob<=1974 & myob>=1918 & myob<=1964 & mnchild<=5 & mochildad!=. & empl!=. using bo_1.dta, clear

* Keep families with at least two observed children with same gender
egen temp1=count(idnr), by(midnr woman)
keep if temp1>=2 
drop temp*

program drop _all
program define msum 
	{
	local var "empl selfemp ceopp ceopb jcreate sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o" 

	local restr_1 "if woman==0" 
	local restr_2 "if woman==1"
	local treat_1 "bo_2 bo_3 bo_4 bo_5" 
	local treat_2 "bo_2 bo_3 bo_4 bo_5 ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5"

	local k 1		/* Restriction */
	while `k'<=2 {
	local m 1		/* Treatment */
	while `m'<=2 {
    	tokenize `var'
    	local l 0
   	foreach x in `var' {
   	local l=`l'+1
   	if ("`x'"=="empl" | "`x'"=="selfemp") {
    	local lab: variable label `x'
	areg `x' `treat_`m'' i.yob `restr_`k'', absorb(midnr) vce(robust)
	}
   	else {
    	local lab: variable label `x'
	areg `x' `treat_`m'' i.yob `restr_`k'' [aw=noweight], absorb(midnr) vce(robust)
	}
	if `l'==1 {
	outreg2 `treat_`m'' using tab_4_7_g_`k'_t_`m'.doc, se dec(3) replace label nocons title("Table 7. Birth order effects on worker characteristics, Family FE") ctitle("`lab'")
	}
	if `l'!=1 {
   	if ("`x'"=="ceopp" | "`x'"=="jcreate" ) {
	outreg2 `treat_`m'' using tab_4_7_g_`k'_t_`m'.doc, se dec(4) append label nocons ctitle("`lab'")
	}
   	if ("`x'"!="ceopp" & "`x'"!="jcreate") {
	outreg2 `treat_`m'' using tab_4_7_g_`k'_t_`m'.doc, se dec(3) append label nocons ctitle("`lab'")
	}
	}
	}
	local m=`m'+1
	}
	local k=`k'+1
	}
	}
end
msum    
program drop _all

* Table 6. Effects of birth order and siblings’ gender composition on children’s non-cognitive abilities 
* Appendix Table 8. Effects of birth order and siblings’ gender composition on children’s cognitive and non-cognitive abilities 
* Note that this analysis cannot be done with family fixed effects for families with two children, since there is no variation in gender composition within families.
* Identifying the within-family effect of gender composition of siblings requires having at least three children where at least two are boys.
* Family fixed effects

use bo_skills_1.dta, clear
* The share of boys is given by the variables: gc_bo_2 gc_bo_3 gc_bo_4 gc_bo_5

areg snc bo_2 bo_3 bo_4 bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a8.doc, se dec(3) replace label nocons title("Appendix table 8. Effects of birth order and siblings’ gender composition on children’s non-cognitive abilities, Family FE") ctitle("Non-cognitive ability")
areg snc bo_2 bo_3 bo_4 bo_5 ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5 using tab_a8.doc, se dec(3) append label nocons ctitle("Non-cognitive ability")
areg sc bo_2 bo_3 bo_4 bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a8.doc, se dec(3) append label nocons ctitle("Cognitive ability")
areg sc bo_2 bo_3 bo_4 bo_5 ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 ss_bo_2 ss_bo_3 ss_bo_4 ss_bo_5 using tab_a8.doc, se dec(3) append label nocons ctitle("Cognitive ability")

* Table 7. Effects of biological and social birth order on children’s cognitive and non-cognitive abilities, exploiting older siblings’ vital and adoption status
* Appendix Table 10. Effects of biological and social birth order on children’s non-cognitive abilities and cognitive, exploiting older siblings’ vital and adoption status
* Restrict to families with at least one child who have been adopted away or who have died.
* It is not possible to identify the social birth order effect for the last child in the family. To be able to identify both biological and social borth order effects for the fifth child we include family with at the most six children
* Family fixed effects
use bo_1.dta, clear

* Keep mothers born 1918-1964
keep if myob>=1918 & myob<=1964 

* Keep families with at least three  and at the most six children
keep if mnchild>=3 & mnchild<=6 

* Drop individuals who have been adopted away or died
drop if mochildad==.

* Keep men with valid draft records 
keep if sc!=. & snc!=. 

* Keep families with at least two observed boys 
egen temp1=count(idnr), by(midnr)
keep if temp1>=2 & temp1!=.
drop temp*

replace swoman1=0 if swoman1==.
replace swoman2=0 if swoman2==.
replace swoman3=0 if swoman3==.
replace swoman4=0 if swoman4==.
replace swoman5=0 if swoman5==.

gen gmfbage=mfbage
replace gmfbage=15 if gmfbage<15
replace gmfbage=44 if gmfbage>44 & gmfbage!=.
gen nmyob=int(myob/5)*5
gen temp1=mochild!=mochildad
egen temp2=max(temp1), by(midnr)
egen temp3=group(mnchild swoman1 swoman2 swoman3 swoman4 swoman5 medl nmyob gmfbage) 
egen temp4=mean(temp2), by(temp3)
gen temp5=temp3 if temp4>0 & temp4<=0.5
egen temp6=group(mnchild swoman1 swoman2 swoman3 swoman4 swoman5 medl gmfbage) 
egen temp7=mean(temp2) if temp5==., by(temp6)
replace temp5=25000+temp6 if temp5==. & temp7>0 & temp7<=0.5
egen temp8=group(mnchild swoman1 swoman2 swoman3 swoman4 swoman5 gmfbage) 
egen temp9=mean(temp2) if temp5==., by(temp8)
replace temp5=50000+temp8 if temp5==. & temp9>0 & temp9<=0.5
egen temp10=count(1) if temp2==1, by(temp5)
egen temp11=count(1) if temp2==0, by(temp5)
egen temp12=max(temp10), by(temp5)
egen temp13=max(temp11), by(temp5)
egen temp14=count(1) if temp2==0
egen temp15=count(1) if temp2==1
egen temp16=max(temp14)
egen temp17=max(temp15)

gen weight=1 if temp2==1
*replace weight=temp12/temp13 if temp2==0
replace weight=temp12/temp13*temp16/temp17 if temp2==0
drop temp*

gen mochildn=mochild if mochild>=6
replace mochildn=0 if mochildn==.
gen mochildan=mochildad if mochildad>=6
replace mochildan=0 if mochildan==.

replace weight=1

xtset midnr
areg snc bo_2 bo_3 bo_4 bo_5 i.mochildn i.mochildan i.yob [aw=weight], absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_7.doc, se dec(3) replace label nocons title("Table 7. Birth order effects on different outcomes, excluding adopted and dead siblings") ctitle("Non-cognitive ability")
areg snc bo_2 bo_3 bo_4 bo_5 boad_2 boad_3 boad_4 boad_5 i.mochildn i.mochildan i.yob [aw=weight], absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 boad_2 boad_3 boad_4 boad_5 using tab_7.doc, se dec(3) append label nocons ctitle("Non-cognitive ability")
areg sc bo_2 bo_3 bo_4 bo_5 i.mochildn i.mochildan i.yob [aw=weight], absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_7.doc, se dec(3) append label nocons ctitle("Cognitive ability")
areg sc bo_2 bo_3 bo_4 bo_5 boad_2 boad_3 boad_4 boad_5 i.mochildn i.mochildan i.yob [aw=weight], absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 boad_2 boad_3 boad_4 boad_5 using tab_7.doc, se dec(3) append label nocons ctitle("Cognitive ability")


* Table 8. Effects of birth order on pupil effort and parental investments
use bo_etf_1.dta, clear

keep if cohort==yob

* Student effort and parental investments
areg homew bo_2 bo_3 bo_4 bo_5 i.cohort i.myob i.medl woman, absorb(fcomp) robust
test bo_2 bo_3 bo_4 bo_5 
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_8.doc, se dec(3) replace label nocons addstat(F test: all var=0, r(F), Prob > F, r(p)) adec(3)  title(Table 8. Birth order effects on student effort and parental investments at age 13, Family compositon FE and controls, 1-year age groups) ctitle("Home work, hours")
areg sprbook6 bo_2 bo_3 bo_4 bo_5 i.cohort i.myob i.medl woman, absorb(fcomp) robust
test bo_2 bo_3 bo_4 bo_5 
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_8.doc, se dec(3) append label nocons addstat(F test: all var=0, r(F), Prob > F, r(p)) adec(3) ctitle("Read books, percentile rank")
areg tvcomph bo_2 bo_3 bo_4 bo_5 i.cohort i.myob i.medl woman, absorb(fcomp) robust
test bo_2 bo_3 bo_4 bo_5 
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_8.doc, se dec(3) append label nocons addstat(F test: all var=0, r(F), Prob > F, r(p)) adec(3) ctitle("TV or computer, hours")
areg mfhomet bo_2 bo_3 bo_4 bo_5 i.cohort i.myob i.medl woman, absorb(fcomp) robust
test bo_2 bo_3 bo_4 bo_5 
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_8.doc, se dec(3) append label nocons addstat(F test: all var=0, r(F), Prob > F, r(p)) adec(3) ctitle("Parents, help with homework")
areg spmftalk bo_2 bo_3 bo_4 bo_5 i.cohort i.myob i.medl woman, absorb(fcomp) robust
test bo_2 bo_3 bo_4 bo_5 
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_8.doc, se dec(3) append label nocons addstat(F test: all var=0, r(F), Prob > F, r(p)) adec(3) ctitle("Parents, talk about school")
areg spmfasp6 bo_2 bo_3 bo_4 bo_5 i.cohort i.myob i.medl woman, absorb(fcomp) robust
test bo_2 bo_3 bo_4 bo_5 
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_8.doc, se dec(3) append label nocons addstat(F test: all var=0, r(F), Prob > F, r(p)) adec(3) ctitle("Parents, expectations")


******************************************************************************
/************************* Generating appendix tables ***********************/
******************************************************************************

* Appendix Table 1. Average non-cognitive and cognitive abilities, by occupational status
use idnr myob woman yob mnchild mochildad sc snc empl selfemp ceoppa ceopba jcreatea noweighta if woman==0 & yob>=1952 & yob<=1974 & sc!=. & snc!=. & empl!=. using bo_1.dta, clear

gen nonempl=empl==0 & selfemp==0
lab var nonempl "non-employed"

program drop _all
program define msum 
	{
	local var "empl ceoppa ceopba jcreatea selfemp nonempl" /*  */
	local sumvar "snc sc" /*  */

	quietly log using tab_a1.log, replace
	quietly log off

    	tokenize `sumvar'
   	foreach y in `sumvar' {

    	local laby: variable label `y'
    	quietly log on
    	display  "`laby'"
    	quietly log off
    	
    	tokenize `var'
   	foreach x in `var' {
   	
   	if ("`x'"=="empl" | "`x'"=="selfemp" | "`x'"=="nonempl") {
   	quietly sum `y' if `x'==1
     	local n=r(N)
  	}
   	else {
   	quietly sum `y' if `x'==1 [aw=noweighta]
     	*local n=r(N)
    	local n=r(sum_w)
  	}

    	local mean=round(r(mean),.001)
    	local sd=round(r(sd),.001)
    	local lab: variable label `x'
    	quietly log on
    	display  "`lab'"
    	display  "`mean'"
    	display "(`sd')"
    	display "[n=`n']"
    	quietly log off
	}
	}
	
    	quietly log close
	}
end
msum    
program drop _all

* Appendix Table 2. Descriptive statistics in full and restricted sample
use if myob>=1918 & myob<=1964 & woman==0 & yob>=1941 & yob<=1982 & mnchild>=2 & mnchild<=5 & mochildad!=. using bo_1.dta, clear

gen dsample_1=sc!=. & snc!=. & yob>=1952 & yob<=1982
gen esample_1=empl!=. & yob>=1941 & yob<=1974

* Generate indicator for restrictive sample (families with at least two observed children)
egen temp1=count(idnr) if sc!=. & snc!=. & yob>=1952 & yob<=1982, by(midnr)
gen dsample_2=temp1>=2 & sc!=. & snc!=. & yob>=1952 & yob<=1982
drop temp*

egen temp1=count(idnr) if empl!=. & yob>=1941 & yob<=1974, by(midnr)
gen esample_2=temp1>=2 & empl!=. & yob>=1941 & yob<=1974
drop temp*

* Generate age in 2010
gen age=round((mdy(6,1,2010)-db)/365.25, .01)
lab var age "age"

program drop _all
program define msum 
	{
	local var "snc empl selfemp ceopp ceopb jcreate mnchild age mfbage medu " /*  */

	quietly log using tab_a2.log, replace
	quietly log off

	local k 1		/* Restriction */
	while `k'<=2 {
	quietly log on
	display "restriction: `k'" 
	quietly log off

    	tokenize `var'
   	foreach x in `var' {
   	
   	
   	if ("`x'"=="empl" | "`x'"=="selfemp" | "`x'"=="ceopp" | "`x'"=="ceopb" | "`x'"=="jcreate") {
   	sum `x' if esample_`k'==1 
   	}
    	else {
   	sum `x' if dsample_`k'==1  
   	}
   	
    	local mean=round(r(mean),.001)
    	local sd=round(r(sd),.001)
    	local n=r(N)
    	local lab: variable label `x'
    	quietly log on
    	*display  "`lab'"
    	display  "`mean'"
    	display "(`sd')"
    	quietly log off
	}
    	sum idnr `restr_`k'' if dsample_`k'==1 
    	local n=r(N)
    	quietly log on
    	display  "Obs."
    	display "`n'"
    	quietly log off
	
	local k=`k'+1
	}
    	quietly log close
	}
end
msum    
program drop _all


* Appendix Table 3. Wage premiums for individual abilities and job requirements
use if yob>=1952 & yob<=1974 & sc!=. & snc!=. & sv1A1!=. & wage!=. using bo_1.dta, clear

reg lnwage sc snc i.yob [aw=wweight] if woman==0
outreg2 sc snc using tab_a3.doc, se dec(3) replace label nocons title("Appendix Table 3. The association between skill measures and wages") 

reg lnwage sv1A1 sv2B1 i.yob [aw=wweight] if woman==0
outreg2 sv1A1 sv2B1 using tab_a3.doc, se dec(3) append label nocons 

reg lnwage sv1A1 sbf_c sbf_a sbf_es sbf_ex sbf_o i.yob [aw=wweight] if woman==0
outreg2 sv1A1 sbf_c sbf_a sbf_es sbf_ex sbf_o using tab_a3.doc, se dec(3) append label nocons 

reg lnwage sc snc sv1A1 sv2B1 i.yob [aw=wweight] if woman==0
outreg2 sc snc sv1A1 sv2B1 using tab_a3.doc, se dec(3) append label nocons 

reg lnwage sc snc sv1A1 sbf_c sbf_a sbf_es sbf_ex sbf_o i.yob [aw=wweight] if woman==0
outreg2 sc snc sv1A1 sbf_c sbf_a sbf_es sbf_ex sbf_o using tab_a3.doc, se dec(3) append label nocons 


* Appendix Table 4a. Correlation matrix for different skill measures obtained from the military draft
use bo_skills_1.dta, clear

log using tab_a4a.log, replace
corr snc sc
log close

* Appendix Table 4b. Correlation matrix for different skill measures obtained from occupational sorting
use idnr yob woman midnr myob mnchild mochildad sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o sv1A1 noweight empl if woman==0 & yob>=1941 & yob<=1974 & myob>=1918 & myob<=1964 & mnchild<=5 & mochildad!=. & empl!=. using bo_1.dta, clear

* Keep families with at least two observed children with same gender
egen temp1=count(idnr), by(midnr woman)
keep if temp1>=2 
drop temp*

log using tab_a4b.log, replace
corr sv2B1 sv1C2b sbf_c sbf_a sbf_es sbf_ex sbf_o sv1A1 [aw=noweight]
log close

* Appendix Table 5. Descriptive statistics - ETF-survey
use bo_etf_1.dta, clear

keep if cohort==yob

program drop _all
program define msum 
	{
	local var "homew sprbook6 tvcomph mfhomet spmftalk spmfasp6" /*  */

	quietly log using tab_a5.log, replace
	quietly log off

	local restr_0 "" 
	local restr_1 "& mochild==1" 
	local restr_2 "& mochild==2"
	local restr_3 "& mochild==3"
	local restr_4 "& mochild==4"
	local restr_5 "& mochild==5"

	local restrb_0 "if idnr!=." 
	local restrb_1 "if woman==0" 
	local restrb_2 "if woman==1" 

	local m 0		/* Restriction */
	while `m'<=0 {
	local k 0		
	while `k'<=5 {
	quietly log on
	display "restriction: `restrb_`m'' `restr_`k''" 
	quietly log off

    	tokenize `var'
   	foreach x in `var' {
   	sum `x' `restrb_`m'' `restr_`k''
    	local mean=round(r(mean),.001)
    	local sd=round(r(sd),.001)
    	local n=r(N)
    	local lab: variable label `x'
    	quietly log on
    	*display  "`lab'"
    	display  "`mean'"
    	display "(`sd')"
    	quietly log off
	}
    	sum idnr `restrb_`m'' `restr_`k''
    	local n=r(N)
    	quietly log on
    	display  "Obs."
    	display "`n'"
    	quietly log off
	
	local k=`k'+1
	}
	local m=`m'+1
	}
    	quietly log close
	}
end
msum    
program drop _all


* Appendix Table 6 Effects of birth order on children’s abilities, simulating missing children
use idnr sc snc yob woman midnr myob mnchild mochild medl mfbage fplnearn mplnearn bo_2 if mochild<=2 & myob<=1964 using bo_1.dta, clear

drop if medl==0

gen simobs=mnchild==1
lab var simobs "simulation observations"

* Generate simulation strata
gen gmfbage=mfbage
replace gmfbage=15 if gmfbage<15
replace gmfbage=44 if gmfbage>44 & gmfbage!=.
gen ngmfbage=int(gmfbage/5)*5

gen nmyob=int(myob/5)*5

gen nmedl=1 if (medl==1 | medl==2)
replace nmedl=2 if (medl==3 | medl==4)
replace nmedl=3 if (medl==5 | medl==6 | medl==7)

gen temp1=fplnearn if mochild==1
egen plnearn=max(temp1), by(midnr)
replace plnearn=mplnearn if plnearn==.
egen temp2=mean(plnearn), by(medl nmyob gmfbage)
replace plnearn=temp2 if plnearn==.
drop if plnearn==.
gen gplnearn=int(plnearn/5)*5
lab var gplnearn "father's log-earnings, pctl, grouped"
drop temp* mplnearn fplnearn plnearn

egen temp1=group(medl nmyob gmfbage gplnearn) if mochild==1
egen temp2=mean(simobs) if mochild==1, by(temp1)
gen temp3=temp1 if mochild==1 & temp2>0 & temp2<=0.7

egen temp4=group(medl nmyob ngmfbage gplnearn) if mochild==1
egen temp5=mean(simobs) if mochild==1 & temp3==., by(temp4)
replace temp3=50000+temp4 if mochild==1 & temp3==. & temp5>0 & temp5<=0.7

egen temp6=group(nmedl nmyob) if mochild==1
egen temp7=mean(simobs) if mochild==1 & temp3==., by(temp6)
replace temp3=1000000+temp6 if mochild==1 & temp3==. & temp7>0 & temp7<=0.8

egen temp8=group(temp3) if mochild==1
egen simstra=max(temp8), by(midnr)
lab var simstra "simulation strata"
drop temp* 

* Maximum share with second birth based on human reproductive proababilities ar different ages. 
* Assume parents wait one year until trying to get second child.

/*
Eijkemans et al (2014)

Age	Probability
20	0.98
25	0.96
30	0.93
35	0.88
36	0.86
37	0.83
38	0.80
39	0.75
40	0.66
41	0.50
42	0.40
43	0.30
44	0.20
45	0.12
46	0.08
47	0.06
48	0.04
49	0.02
50	0.00
*/

gen shsmax=0.98 if mfbage+1<=20
replace shsmax=0.98-(0.98-0.96)/5*(mfbage+1-20) if mfbage+1>20 & mfbage+1<25
replace shsmax=0.96 if mfbage+1==25
replace shsmax=0.96-(0.96-0.93)/5*(mfbage+1-25) if mfbage+1>25 & mfbage+1<30
replace shsmax=0.93 if mfbage+1==30
replace shsmax=0.93-(0.93-0.88)/5*(mfbage+1-30) if mfbage+1>30 & mfbage+1<35
replace shsmax=0.88 if mfbage+1==35
replace shsmax=0.86 if mfbage+1==36
replace shsmax=0.83 if mfbage+1==37
replace shsmax=0.80 if mfbage+1==38
replace shsmax=0.75 if mfbage+1==39
replace shsmax=0.66 if mfbage+1==40
replace shsmax=0.50 if mfbage+1==41
replace shsmax=0.40 if mfbage+1==42
replace shsmax=0.30 if mfbage+1==43
replace shsmax=0.20 if mfbage+1==44
replace shsmax=0.12 if mfbage+1==45
replace shsmax=0.08 if mfbage+1==46
replace shsmax=0.06 if mfbage+1==47
replace shsmax=0.04 if mfbage+1==48
replace shsmax=0.02 if mfbage+1==49
replace shsmax=0.02 if mfbage+1==50

gen temp1=mnchild>=2
egen temp2=mean(temp1) if mochild==1, by(mfbage)
egen temp3=max(temp2), by(mfbage)
gen shsba=(shsmax-temp3)/(1-temp3)
replace shsba=0 if shsba<0
replace shsba=0.8 if shsba==.
lab var shsba "share of families with second birth, exploiting biological restrictions"
drop temp* shsmax

drop gmfbage ngmfbage nmedl nmyob

* Generate observations to be simulated
expand 2 if mnchild==1
bysort midnr mochild: gen temp1=_n
replace mochild=2 if mnchild==1 & mochild==1 & temp1==2
drop temp*
replace idnr=. if mnchild==1 & mochild==2 
replace sc=. if mnchild==1 & mochild==2 
replace snc=. if mnchild==1 & mochild==2 
replace woman=. if mnchild==1 & mochild==2 
replace bo_2=1 if mnchild==1 & mochild==2 
replace simobs=0 if mnchild==1 & mochild==1

sort idnr
save bo_sim_1.dta, replace

* Generate data set to draw missing second-born child from
use idnr sc snc woman mnchild mochild simstra if mochild==1 using bo_sim_1.dta, replace

gen temp1=mnchild==1
egen temp2=count(idnr) if temp1==1, by(simstra)
egen temp3=max(temp2), by(simstra)
drop if temp3==.

egen temp4=mean(temp1), by(simstra)
expand 8 if temp4>0.5
drop temp* mnchild mochild 

sort idnr
save bo_sim_data_1.dta, replace

* Generate data set to draw birth spacing (to get year of birth) for missing second-born child
use idnr midnr simstra yob mochild mnchild if mochild<=2 using bo_sim_1.dta, replace

gen temp1=mnchild==1 & mochild==1
egen temp2=count(idnr) if temp1==1, by(simstra)
egen temp3=max(temp2), by(simstra)
drop if temp3==.

egen temp4=mean(temp1) if mochild==1, by(simstra)
egen sh=max(temp4), by(simstra)
drop temp*

keep if mnchild>=2

sort midnr yob mochild
gen bspace=yob-yob[_n-1] if midnr==midnr[_n-1] & mnchild>=2 & mochild==2
lab var bspace "birth spacing"

keep if mochild==2 
drop midnr mochild mnchild yob
expand 8 if sh>0.5
drop sh

sort idnr
save bo_sim_yob_data_1.dta, replace

* Generate main data set with missing information on second child 
use idnr sc snc yob woman midnr mnchild mochild bo_2 simstra shsba if ((sc!=. & snc!=. & woman==0 & yob>=1952 & yob<=1982) | (mnchild==1 & mochild==2)) using bo_sim_1.dta, clear

gen temp1=uniform()
bysort simstra mnchild mochild (temp1): gen nidnr=_n if mnchild==1 & mochild==2 
lab var nidnr "identity number, new"
drop temp1

xtset midnr

sort idnr
save bo_sim_2.dta, replace


* Simulating missing children
clear all
set matsize 5000

program drop _all
program define msum 
	{
	
	local k 1		
	while `k'<=2 {

    	matrix b_`k'=0
    	matrix se_`k'=0
    	matrix n_`k'=0
    	matrix b_r_`k'=0
    	matrix se_r_`k'=0
    	matrix n_r_`k'=0

	local k=`k'+1
	}

	local i 1
	while `i'<=1000 {	/* 1000 */
	di "i = `i', time: $S_TIME"
	use bo_sim_data_1.dta, replace
	bsample _N, strata(simstra)
	bysort simstra: gen nidnr=_n
	sort simstra nidnr
	save bo_sim_sample_1.dta, replace

	use bo_sim_yob_data_1.dta, replace
	bsample _N, strata(simstra)
	bysort simstra: gen nidnr=_n
	sort simstra nidnr
	save bo_sim_yob_sample_1.dta, replace

	use bo_sim_2.dta, clear
	sort simstra nidnr
	merge simstra nidnr using bo_sim_sample_1.dta, update
	drop if _merge==2
	drop _merge
	sort simstra nidnr
	merge simstra nidnr using bo_sim_yob_sample_1.dta, update
	drop if _merge==2
	drop _merge

	* Draw missing second-born children with the probability that mothers will have a second child
	gen temp1=uniform()
	gen popa=((mnchild==1 & mochild==1) | mnchild!=1)
	replace popa=1 if mnchild==1 & mochild==2 & temp1<=shsba
	drop temp1
	
	* Generate year of birth for missing child
	replace yob=yob+bspace if mnchild==1 & mochild==2

	keep if sc!=. & snc!=. & yob>=1952 & yob<=1982 & woman==0
	egen temp1=count(idnr) if sc!=. & snc!=. & yob>=1952 & yob<=1982 & woman==0, by(midnr)
	keep if temp1==2
	drop temp1 woman mochild mnchild simstra shsba nidnr bspace

	local k 1		
	while `k'<=2 {

	quietly areg ``k'' bo_2 i.yob, absorb(midnr) vce(robust)
	scalar b=_b[bo_2]
	scalar se=_se[bo_2]
	scalar n=e(N)
	matrix b_`k'=(b_`k'\b)
	matrix se_`k'=(se_`k'\se)
	matrix n_`k'=(n_`k'\n)

	quietly areg ``k'' bo_2 i.yob if popa==1, absorb(midnr) vce(robust)
	scalar b=_b[bo_2]
	scalar se=_se[bo_2]
	scalar n=e(N)
	matrix b_r_`k'=(b_r_`k'\b)
	matrix se_r_`k'=(se_r_`k'\se)
	matrix n_r_`k'=(n_r_`k'\n)

	local k=`k'+1
	}
	local i=`i'+1
	}
	}
end
msum sc snc
program drop _all

drop _all

svmat b_1
rename b_11 b_1
svmat se_1
rename se_11 se_1
svmat n_1
rename n_11 n_1
svmat b_2
rename b_21 b_2
svmat se_2
rename se_21 se_2
svmat n_2
rename n_21 n_2

svmat b_r_1
rename b_r_11 b_r_1
svmat se_r_1
rename se_r_11 se_r_1
svmat n_r_1
rename n_r_11 n_r_1
svmat b_r_2
rename b_r_21 b_r_2
svmat se_r_2
rename se_r_21 se_r_2
svmat n_r_2
rename n_r_21 n_r_2

drop if _n==1
gen num=_n

lab var b_1 "simulated birth order effect, cognitive skills, point estimate" 
lab var se_1 "simulated birth order effect, cognitive skills, standard error" 
lab var n_1 "simulated birth order effect, cognitive skills, observations" 
lab var b_2 "simulated birth order effect, non-cognitive skills, point estimate" 
lab var se_2 "simulated birth order effect, non-cognitive skills, standard error" 
lab var n_2 "simulated birth order effect, non-cognitive skills, observations" 
lab var b_r_1 "simulated birth order effect, restricted, cognitive skills, point estimate" 
lab var se_r_1 "simulated birth order effect, restricted, cognitive skills, standard error" 
lab var n_r_1 "simulated birth order effect, restricted, cognitive skills, observations" 
lab var b_r_2 "simulated birth order effect, restricted, non-cognitive skills, point estimate" 
lab var se_r_2 "simulated birth order effect, restricted, non-cognitive skills, standard error" 
lab var n_r_2 "simulated birth order effect, restricted, non-cognitive skills, observations" 
lab var num "number of repetition"

sort num
save bo_sim_est_1.dta, replace

use bo_sim_est_1.dta, clear
quietly log using tab_a6.log, replace
sum
quietly log off

* Observed data
use idnr sc snc yob woman midnr myob mnchild mochild bo_2 if woman==0 & yob>=1952 & yob<=1982 & myob>=1918 & myob<=1964 & mnchild>=2 & mochild<=2 & sc!=. & snc!=. using bo_1.dta, clear
egen temp1=count(1), by(midnr)
keep if temp1>=2 
drop temp*

quietly log on
areg snc bo_2 i.yob, absorb(midnr) vce(robust)
areg sc bo_2 i.yob, absorb(midnr) vce(robust)
quietly log close

* Appendix Table 7. Birth order effects on cognitive ability
use using bo_skills_1.dta, clear

xtset midnr
areg sc bo_2 bo_3 bo_4 bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a7.doc, se dec(3) replace label nocons title("Appendix Table 7. Birth order effects on cognitive ability, Family FE") ctitle("All families")
areg sc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==2, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a7.doc, se dec(3) append label nocons ctitle("Two child family")
areg sc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==3, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a7.doc, se dec(3) append label nocons ctitle("Three child family")
areg sc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==4, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a7.doc, se dec(3) append label nocons ctitle("Four child family")
areg sc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==5, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a7.doc, se dec(3) append label nocons ctitle("Five child family")


* Appendix Table 11. Specification check non-cognitive ability
use bo_skills_1.dta, clear

* a. Family composition FE 
areg snc bo_2 bo_3 bo_4 bo_5 i.yob, absorb(fcomp) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11a.doc, se dec(3) replace label nocons title("Appendix Table 11a. Birth order effects on non-cognitive ability, family composition FE") ctitle("All families")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==2, absorb(fcomp) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11a.doc, se dec(3) append label nocons ctitle("Two child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==3, absorb(fcomp) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11a.doc, se dec(3) append label nocons ctitle("Three child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==4, absorb(fcomp) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11a.doc, se dec(3) append label nocons ctitle("Four child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==5, absorb(fcomp) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11a.doc, se dec(3) append label nocons ctitle("Five child family")

* b. Family FE and controls
xtset midnr
areg snc bo_2 bo_3 bo_4 bo_5 i.yob, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11b.doc, se dec(3) replace label nocons title("Appendix Table 11b. Birth order effects on non-cognitive ability, Family FE") ctitle("All families")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==2, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11b.doc, se dec(3) append label nocons ctitle("Two child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==3, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11b.doc, se dec(3) append label nocons ctitle("Three child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==4, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11b.doc, se dec(3) append label nocons ctitle("Four child family")
areg snc bo_2 bo_3 bo_4 bo_5 i.yob if mnchild==5, absorb(midnr) vce(robust)
outreg2 bo_2 bo_3 bo_4 bo_5 using tab_a11b.doc, se dec(3) append label nocons ctitle("Five child family")


