/* 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
DO-FILE DESCRIPTION

Jeroen Sabbe, last updated 15 May 10
last updated 9 Jan 17

This do-file restricts the CEX diary sample in the fmly-file to households that meet certain criteria.
It also distinguishes between singles, couples and families and stores data in 3 separate files.

Inputs: 
fmlyd`yearshort'.dta: CEX fmly file (contains family characteristics, sample selection and BLS-made commodity groups)
(assumed stored at location specified in local "inputpath"

Outputs:
fmlydsample`yearshort'.dta 		(The general sample of households that are retained)
fmlydsample`yearshort'sing.dta	(The specific sample of singles that are retained)
fmlydsample`yearshort'coup.dta	(The specific sample of couples = couples without children, that are retained)
fmlydsample`yearshort'fam.dta		(The specific sample of families = couples with or without children, that are retained)
(all stored at location specified in local "outputpath")
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
*/

clear
clear matrix
*-------------------------------USER INPUT!!!------------------------------------
set mem 50m
set maxvar 32767
local yearlong = "2000"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX3/DIARY`yearshort'
local outputpath C:/CodesPublishedVersion/CEX3/`yearlong'

* -------------------------------------------------------------------
* Make fmlydsample`yearshort', the file that will contain the restricted sample
* -------------------------------------------------------------------
cd `inputpath'
use fmlyd`yearshort'
cd `outputpath'
save fmlydsample`yearshort'.dta, replace
use fmlydsample`yearshort'.dta

gen cuid=int(newid/10)	// in the early years of CEX, the variable cuid did not exist so we need to create it.

destring respstat, replace
destring bls_urbn, replace
destring cutenure, replace
destring region, replace
destring state, replace
destring fam_type, replace
destring childage, replace
destring empltyp1, replace
destring empltyp2, replace
destring sex_ref, replace
destring sex2, replace
destring educ_ref, replace
destring educa2, replace
destring earncomp, replace
destring weeki, replace
destring ref_race, replace
destring race2, replace
destring marital1, replace
destring strtmnth, replace

rename marital1 marital

gen owncar=.
replace owncar=0 if vehq==0
replace owncar=1 if vehq>0

replace state=0 if state==.

egen yearincomebeftx=rowtotal(unempx wrkrsx welfrx intx divx pensionx chdothx aliothx othinx jfs_amt fwagex fss_rrx fsuppx)
gen yearincome=yearincomebeftx-perstax
drop if yearincome<=0

count

* -----------------------------------------------------------
* Measures to restrict sample, applicable to ALL family types
* -----------------------------------------------------------
* We base fam characteristics on situation at start of 1st week
keep if weeki==1

* only keep CU's that consist of 1 household (note: does not restrict nr of hh MEMBERS)
keep if hh_cu_q==1
count

* only keep hhs that completed the two weeks of the diary. 
keep if weekn==2 
count

* no hhs living in student housing (see Batt 03)
drop if cutenure==6
count

* only keep vehicle owners (see BBC 2003) in order to include fuel expenses
drop if vehq==.
count

gen ownhouse=.
replace ownhouse=0 if cutenure>=4
replace ownhouse=1 if cutenure<=3

local hhchar "yearincome strtmnth state ownhouse owncar fam_type fam_size marital perslt18 childage"
local refchar "age_ref ref_race sex_ref educ_ref empltyp1 hrsprwk1 wk_wrkd1"
local partnerchar "age2 race2 sex2 educa2 empltyp2 hrsprwk2 wk_wrkd2"

keep cuid `hhchar' `refchar' `partnerchar'
order cuid `hhchar' `refchar' `partnerchar'
save fmlydsample`yearshort'.dta, replace
outfile using fmlydsample`yearshort'.txt,w replace

* -------
* Singles
* -------
use fmlydsample`yearshort'
save fmlydsample`yearshort'sing.dta, replace
use fmlydsample`yearshort'sing
count

* Rename some of the variables because singles
rename age_ref age
rename ref_race race
rename sex_ref sex
rename educ_ref educ
rename empltyp1 empltyp
rename hrsprwk1 hrsprwk
rename wk_wrkd1 wk_wrkd

* keep only singles
keep if fam_type==8	//Singles
count

* only keep hh if at least 21
keep if age>=21
count

* Only keep if worked at least 17 hrs per week (= part time)
keep if hrsprwk>=17
count

* Drop self-employed (see AB 95)
drop if empltyp==5 	// drop self-employed
drop if empltyp==6 	// drop family business/farm/work without pay
count

* Make age classes
gen ageclass=.
replace ageclass=1 if age<20
replace ageclass=2 if (age>=20 & age<25)
replace ageclass=3 if (age>=25 & age<30)
replace ageclass=4 if (age>=30 & age<35)
replace ageclass=5 if (age>=35 & age<40)
replace ageclass=6 if (age>=40 & age<45)
replace ageclass=7 if (age>=45 & age<50)
replace ageclass=8 if (age>=50 & age<55)
replace ageclass=9 if (age>=55 & age<60)
replace ageclass=10 if (age>=60 & age<65)
replace ageclass=11 if age>=65

* Make education classes
gen educlass=.
replace educlass=1 if educ==00
replace educlass=2 if (educ==10 | educ==11)
replace educlass=3 if educ==12
replace educlass=4 if educ==13
replace educlass=5 if (educ==14 | educ==15)
replace educlass=6 if educ==16
replace educlass=7 if educ==17

* keep variables we need and save
local singchar "race sex ageclass educlass"
keep cuid `hhchar' `singchar'
order cuid `hhchar' `singchar'
save fmlydsample`yearshort'sing.dta, replace
outfile using fmlydsample`yearshort'sing.txt,w replace
count

* Save Single Males and Single Females separately too
use fmlydsample`yearshort'sing
save fmlydsample`yearshort'singmale.dta, replace
keep if sex==1 // male
save fmlydsample`yearshort'singmale.dta, replace
outfile using fmlydsample`yearshort'singmale.txt,w replace

use fmlydsample`yearshort'sing
save fmlydsample`yearshort'singfemale.dta, replace
keep if sex==2 // female
save fmlydsample`yearshort'singfemale.dta, replace
outfile using fmlydsample`yearshort'singfemale.txt,w replace

* -----------------------
* Multi-person households
* -----------------------
use fmlydsample`yearshort'
save fmlydsample`yearshort'coupandfam.dta, replace
use fmlydsample`yearshort'coupandfam.dta
count

* drop homosexual couples (just because we want to be clear on 'husband' and 'wife')
drop if sex_ref==sex2
count

* only keep hh if reference person at least 21
keep if age_ref>=21
count

* Age of husband and wife
gen age_h=age_ref if sex_ref==1 	// if ref person is husband, put his age in for age_h
replace age_h=age2 if sex_ref==2 	// if ref person is wife, put spouse's age in for age_h
gen age_w=age_ref if sex_ref==2
replace age_w=age2 if sex_ref==1

gen ageclassm=.
replace ageclassm=1 if age_h<20
replace ageclassm=2 if (age_h>=20 & age_h<25)
replace ageclassm=3 if (age_h>=25 & age_h<30)
replace ageclassm=4 if (age_h>=30 & age_h<35)
replace ageclassm=5 if (age_h>=35 & age_h<40)
replace ageclassm=6 if (age_h>=40 & age_h<45)
replace ageclassm=7 if (age_h>=45 & age_h<50)
replace ageclassm=8 if (age_h>=50 & age_h<55)
replace ageclassm=9 if (age_h>=55 & age_h<60)
replace ageclassm=10 if (age_h>=60 & age_h<65)
replace ageclassm=11 if age_h>=65

gen ageclassf=.
replace ageclassf=1 if age_w<20
replace ageclassf=2 if (age_w>=20 & age_w<25)
replace ageclassf=3 if (age_w>=25 & age_w<30)
replace ageclassf=4 if (age_w>=30 & age_w<35)
replace ageclassf=5 if (age_w>=35 & age_w<40)
replace ageclassf=6 if (age_w>=40 & age_w<45)
replace ageclassf=7 if (age_w>=45 & age_w<50)
replace ageclassf=8 if (age_w>=50 & age_w<55)
replace ageclassf=9 if (age_w>=55 & age_w<60)
replace ageclassf=10 if (age_w>=60 & age_w<65)
replace ageclassf=11 if age_w>=65

* Education of husband and wife
gen educ_h=educ_ref if sex_ref==1 	// if ref person is husband, put his age in for age_h
replace educ_h=educa2 if sex_ref==2 // if ref person is wife, put spouse's age in for age_h
gen educ_w=educ_ref if sex_ref==2
replace educ_w=educa2 if sex_ref==1

gen educlassm=.
replace educlassm=1 if educ_h==00
replace educlassm=2 if (educ_h==10 | educ_h==11)
replace educlassm=3 if educ_h==12
replace educlassm=4 if educ_h==13
replace educlassm=5 if (educ_h==14 | educ_h==15)
replace educlassm=6 if educ_h==16
replace educlassm=7 if educ_h==17

gen educlassf=.
replace educlassf=1 if educ_w==00
replace educlassf=2 if (educ_w==10 | educ_w==11)
replace educlassf=3 if educ_w==12
replace educlassf=4 if educ_w==13
replace educlassf=5 if (educ_w==14 | educ_w==15)
replace educlassf=6 if educ_w==16
replace educlassf=7 if educ_w==17

count

* Only keep if both members worked at least 17 hrs per week (= part-time)
keep if hrsprwk1>=17 & hrsprwk2>=17
count

* Drop self-employed (see AB 95)
drop if (empltyp1==5 | empltyp1==6) & (empltyp2==5 | empltyp2==6) 	// drop if both self-employed or family business/farm/work without pay
count

* From ref person to m/f
gen racem=.
replace racem=ref_race if sex_ref==1
replace racem=race2 if sex_ref==2
gen racef=.
replace racef=race2 if sex_ref==1
replace racef=ref_race if sex_ref==2

* keep variables we need and save
local mchar "racem ageclassm educlassm"
local fchar "racef ageclassf educlassf"
keep cuid `hhchar' `mchar' `fchar'
order cuid `hhchar' `mchar' `fchar'
save fmlydsample`yearshort'coupandfam.dta, replace

	* -----------
	* H/W Couples
	* -----------
	use fmlydsample`yearshort'coupandfam.dta	
	save fmlydsample`yearshort'coup.dta, replace	
	keep if fam_type==1	//Husband and wife only
	count
	save fmlydsample`yearshort'coup.dta, replace
	outfile using fmlydsample`yearshort'coup.txt,w replace

	* ------------------------------------------------
	* H/W Families (=H/W couples with and without kids)
	* ------------------------------------------------
	use fmlydsample`yearshort'coupandfam.dta	
	save fmlydsample`yearshort'fam.dta, replace	
	keep if (fam_type>=1 & fam_type<=5)	// keep only families (=H/W couples with and without kids)
	count
	save fmlydsample`yearshort'fam.dta, replace
	outfile using fmlydsample`yearshort'fam.txt,w replace

*log close
