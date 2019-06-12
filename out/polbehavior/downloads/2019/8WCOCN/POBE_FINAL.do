****
****	POBE_Prep.do
****	
****
****	Replication file for "A Healthy Democracy?"
****
****	Julianna Pacheco and Christopher Ojeda
****
****	Political Behavior
****
****
****
****	Table of Contents:
****
****		- Section 1: Data Merging
****
****		- Section 2: Variable Cleaning
****
****		- Section 3: Analyses
****

********************************************************************************
**** SECTION 1: DATA MERGING

use "CCES2012.dta", clear

* State
rename inputstate state
gen st_fips=state
drop state
gen state=.
replace state=1 if st_fip==1
replace state=2 if st_fip==2
replace state=3 if st_fip==4
replace state=4 if st_fip==5
replace state=5 if st_fip==6
replace state=6 if st_fip==8
replace state=7 if st_fip==9
replace state=8  if st_fip==10
replace state=9  if st_fip==11
replace state=10 if st_fip==12
replace state=11 if st_fip==13
replace state=12 if st_fip==15
replace state=13 if st_fip==16
replace state=14 if st_fip==17
replace state=15 if st_fip==18
replace state=16 if st_fip==19
replace state=17 if st_fip==20
replace state=18 if st_fip==21
replace state=19 if st_fip==22
replace state=20 if st_fip==23
replace state=21 if st_fip==24
replace state=22 if st_fip==25
replace state=23 if st_fip==26
replace state=24 if st_fip==27
replace state=25 if st_fip==28
replace state=26 if st_fip==29
replace state=27 if st_fip==30
replace state=28 if st_fip==31
replace state=29 if st_fip==32
replace state=30 if st_fip==33
replace state=31 if st_fip==34
replace state=32 if st_fip==35
replace state=33 if st_fip==36
replace state=34 if st_fip==37
replace state=35 if st_fip==38
replace state=36 if st_fip==39
replace state=37 if st_fip==40 
replace state=38 if st_fip==41
replace state=39 if st_fip==42
replace state=40 if st_fip==44
replace state=41 if st_fip==45
replace state=42 if st_fip==46
replace state=43 if st_fip==47
replace state=44 if st_fip==48
replace state=45 if st_fip==49
replace state=46 if st_fip==50
replace state=47 if st_fip==51
replace state=48 if st_fip==53 
replace state=49 if st_fip==54
replace state=50 if st_fip==55
replace state=51 if st_fip==56

gen state_st=string(state)
gen zero=0
gen zero_st=string(zero)

* State/District Identifier
egen id_statecdst=concat(StateAbbr cdid)
sort id_statecdst

* Merging in roll call and DW-nominate variables
merge id_statecdst using "house_rollcall_final.dta"
drop _merge
sort id_statecdst
merge id_statecdst using "nominate_112.dta"
drop _merge
gen countyfips_new = real(countyfips)
drop countyfips
rename countyfips_new countyfips
merge m:1 countyfips using "CountyFips_Zhvi_AllHomes.dta", force


********************************************************************************
**** SECTION 2: VARIABLE CLEANING

* Health
gen health=genhealth
recode genhealth (1=5) (2=4) (3=3) (4=2) (5=1) (8=.) (9=.)
recode CC326* (1=1) (2=0)
alpha CC326_1 CC326_2 CC326_3 CC326_5 CC326_6 genhealth, std detail item gen(health3)

gen healthcat=.
replace healthcat=3 if health3<=-.5253906 
replace healthcat=2 if health3>-.5253906  & health3<=.2141881 
replace healthcat=1 if health3>.2141881 

gen healthcat2=.
replace healthcat2=3 if health3<=-.4149778 
replace healthcat2=2 if health3>-.4149778  & health3<=.0713211
replace healthcat2=1 if health3>.0713211

gen healthdummy=.
replace healthdummy=1 if healthcat==3
replace healthdummy=0 if healthcat==1
replace healthdummy=0 if healthcat==2

* Voting Scale
gen vote2008=CC316
recode vote2008 (1=0) (2=0) (3=0) (4=1) (else=.)
gen vote2012=CC401
recode vote2012 (1=0) (2=0) (3=0) (4=0) (5=1) (else=.)

alpha vote2008 vote2012 votereg_post, gen(votetotal) detail std 
gen votetotal2=(votetotal+4.840454)/(4.840454+.4699168)

* Participation Scale
recode CC417a_1 CC417a_2 CC417a_3 CC417a_4 (1=1) (2=0) (else=.)
rename CC417a_1 polmeet
rename CC417a_2 polsign
rename CC417a_3 polwork
rename CC417a_4 poldonate

alpha polmeet polsign poldonate polwork , gen(polpart) detail std 
gen polpart2=(polpart+.4992842)/(2.160933+.4992842)
alpha vote2008 vote2012 votereg_post polmeet polsign poldonate polwork, gen(part_all2) detail std 

* Gender
gen female= gender
recode female (1=0) (2=1)

* Age
gen age=2012-birthyr
gen agecat=.
replace agecat=1 if age>=17 & age<=24
replace agecat=2 if age>=25 & age<=34
replace agecat=3 if age>=35 & age<=44
replace agecat=4 if age>=45 & age<=54
replace agecat=5 if age>=55

* Education
recode educ 1=0 2=1 3 4= 2 5=3 6=4

* Race
gen white = race ==1
gen black = race == 2
gen other_nonwhite = 1 if race !=1 & race !=2
recode other .=0

* Income
recode faminc (97=.) (98=.) (99=.)
gen inccat=.
replace inccat=1 if faminc<=4
replace inccat=2 if faminc>4 & faminc<=8
replace inccat=3 if faminc>8

gen incdummy=.
replace incdummy=1 if inccat==3
replace incdummy=0 if inccat==1
replace incdummy=0 if inccat==2

* Political Interest
gen polinter = newsint
recode polinter (7=0) (1=4) (2=3) (3=2) (4=1)

* Party Identification
gen pid=CC421a
recode pid3 (1=0) (2=2) (3=1) (else=.)

* Ideology
gen ideology=CC334A
recode ideology (8=.) (98=.) (99=.)
recode ideo5 (6=.)

* Survey Weight
gen weight=V103

* Generating Conflict Districts
recode CC332A CC332B CC332F CC332G CC332H (1=1) (2=0) (else=.)
preserve
collapse (mean) ryanhealthcat1=CC332A simpsonhealthcat1=CC332B uskoreahealthcat1=CC332F repealhealthcat1=CC332G keystonehealthcat1=CC332H if healthcat==1 [pweight=V103], by(id_statecdst) 
sort id_statecdst
save "cd_healthcat1.dta", replace
restore
preserve
collapse (mean) ryanhealthcat3=CC332A simpsonhealthcat3=CC332B uskoreahealthcat3=CC332F repealhealthcat3=CC332G keystonehealthcat3=CC332H if healthcat==3 [pweight=V103], by(id_statecdst) 
sort id_statecdst
save "cd_healthcat3.dta", replace
restore
sort id_statecdst
drop _merge
merge id_statecdst using "cd_healthcat1.dta"
drop _merge
sort id_statecdst
merge id_statecdst using "cd_healthcat3.dta"
sort id_statecdst
drop _merge

replace ryanhealthcat1=0 if ryanhealthcat1<.5
replace ryanhealthcat1=1 if ryanhealthcat1>.5
replace ryanhealthcat3=0 if ryanhealthcat3<.5
replace ryanhealthcat3=1 if ryanhealthcat3>.5

replace simpsonhealthcat1=0 if simpsonhealthcat1<.5
replace simpsonhealthcat1=1 if simpsonhealthcat1>.5
replace simpsonhealthcat3=0 if simpsonhealthcat3<.5
replace simpsonhealthcat3=1 if simpsonhealthcat3>.5

replace uskoreahealthcat1=0 if uskoreahealthcat1<.5
replace uskoreahealthcat1=1 if uskoreahealthcat1>.5
replace uskoreahealthcat3=0 if uskoreahealthcat3<.5
replace uskoreahealthcat3=1 if uskoreahealthcat3>.5

replace repealhealthcat1=0 if repealhealthcat1<.5
replace repealhealthcat1=1 if repealhealthcat1>.5
replace repealhealthcat3=0 if repealhealthcat3<.5
replace repealhealthcat3=1 if repealhealthcat3>.5

replace keystonehealthcat1=0 if keystonehealthcat1<.5
replace keystonehealthcat1=1 if keystonehealthcat1>.5
replace keystonehealthcat3=0 if keystonehealthcat3<.5
replace keystonehealthcat3=1 if keystonehealthcat3>.5

gen ryanagg=.
replace ryanagg=1 if ryanhealthcat1!=ryanhealthcat3

gen simpsonagg=.
replace simpsonagg=1 if simpsonhealthcat1!=simpsonhealthcat3

gen uskoreaagg=.
replace uskoreaagg=1 if uskoreahealthcat1!=uskoreahealthcat3

gen repealagg=.
replace repealagg=1 if repealhealthcat1!=repealhealthcat3

gen keystoneagg=.
replace keystoneagg=1 if keystonehealthcat1!=keystonehealthcat3

recode ryanagg simpsonagg uskoreaagg keystoneagg repealagg (.=0)
gen conflict_tot=keystoneagg + repealagg + uskoreaagg + simpsonagg + ryanagg
gen conflict = 0
replace conflict = 1 if conflict_tot >= 1
replace conflict = . if conflict_tot == .


/*
There was a resignation in Oregon 1, leading to two OR1 nominations in the nomination data.
*/


**
** Policy Preferences/Win Ratio

* Missingness
tab1 CC332A CC332B CC332F CC332G CC332H, missing

* Generate win ratio components (skip coded as missing)
gen ryanwin_miss=.
replace ryanwin_miss=1 if (CC332A==1 & ryan==1) | (CC332A==0 & ryan==0)
replace ryanwin_miss=0 if (CC332A==1 & ryan==0) | (CC332A==1 & ryan==8) | (CC332A==0 & ryan==1) | (CC332A==0 & ryan==8)

gen repealwin_miss=.
replace repealwin_miss=1 if (repeal_aca1==1 & CC332G==1) | (repeal_aca1==0 & CC332G==0)
replace repealwin_miss=0 if (repeal_aca1==1 & CC332G==0) | (repeal_aca1==8 & CC332G==0) | (repeal_aca1==0 & CC332G==1) | (repeal_aca1==8 & CC332G==1)

gen repealwin2_miss=.
replace repealwin2_miss=1 if (repeal_aca2==1 & CC332G==1) | (repeal_aca2==0 & CC332G==0)
replace repealwin2_miss=0 if (repeal_aca2==1 & CC332G==0) | (repeal_aca2==8 & CC332G==0) | (repeal_aca2==0 & CC332G==1) | (repeal_aca2==8 & CC332G==1)

gen simpsonwin_miss=.
replace simpsonwin_miss=1 if (CC332B==1 & simpson==1) | (CC332B==0 & simpson==0)
replace simpsonwin_miss=0 if (CC332B==1 & simpson==0) | (CC332B==1 & simpson==8) | (CC332B==0 & simpson==1) | (CC332B==0 & simpson==8)

gen uskoreawin_miss=.
replace uskoreawin_miss=1 if (CC332F==1 & uskorea==1) | (CC332F==0 & uskorea==0)
replace uskoreawin_miss=0 if (CC332F==1 & uskorea==0) | (CC332F==1 & uskorea==8) | (CC332F==0 & uskorea==1) | (CC332F==0 & uskorea==8)

gen keystonewin_miss=.
replace keystonewin_miss=1 if (CC332H==1 & keystone==1) | (CC332H==0 & keystone==0)
replace keystonewin_miss=0 if (CC332H==1 & keystone==0) | (CC332H==1 & keystone==8) | (CC332H==0 & keystone==1) | (CC332H==0 & keystone==8)

gen winratio2_unit=((ryanwin_miss+repealwin_miss+repealwin2_miss+simpsonwin_miss+uskoreawin_miss+keystonewin_miss)/6)*100
egen winratio2_mean=rowmean(ryanwin_miss repealwin_miss repealwin2_miss simpsonwin_miss uskoreawin_miss keystonewin_miss)
gen winratio2_per=winratio2_mean*100
egen winratio2_miss=rowmiss(repealwin_miss repealwin2_miss simpsonwin_miss uskoreawin_miss keystonewin_miss)
egen wincount2=rowtotal(repealwin_miss repealwin2_miss simpsonwin_miss uskoreawin_miss keystonewin_miss)

corr ryanwin_miss repealwin_miss repealwin2_miss simpsonwin_miss uskoreawin_miss keystonewin_miss
alpha ryanwin_miss repealwin_miss repealwin2_miss simpsonwin_miss uskoreawin_miss keystonewin_miss, std item

**
** MC Characteristics

* Gender of house member
gen housegender=.
replace housegender=1 if CurrentHouseGender=="F"
replace housegender=0 if CurrentHouseGender=="M"

* Freshmen status of house member
gen housefresh=.
replace housefresh=1 if CurrentHouseFreshman=="1"
replace housefresh=0 if CurrentHouseFreshman=="0"

* Black MC dummy variable
* http://history.house.gov/Exhibitions-and-Publications/BAIC/Historical-Data/Black-American-Representatives-and-Senators-by-Congress/
gen mcblack=0
replace mcblack=1 if name=="BASS"
replace mcblack=1 if name=="BISHOP"
replace mcblack=1 if name=="BROWN"
replace mcblack=1 if name=="BUTTERFIELD"
replace mcblack=1 if name=="CARSON"
replace mcblack=1 if name=="CLARKE" & id_statecdst=="MI13"
replace mcblack=1 if name=="CLARKE" & id_statecdst=="NY11"
replace mcblack=1 if name=="CLAY"
replace mcblack=1 if name=="CLEAVER"
replace mcblack=1 if name=="CLYBURN"
replace mcblack=1 if name=="CONYERS"
replace mcblack=1 if name=="CUMMINGS"
replace mcblack=1 if name=="DAVIS"
replace mcblack=1 if name=="EDWARDS"
replace mcblack=1 if name=="ELLISON"
replace mcblack=1 if name=="FATTAH"
replace mcblack=1 if name=="FUDGE"
replace mcblack=1 if name=="GREEN"
replace mcblack=1 if name=="HASTINGS"
replace mcblack=1 if name=="JACKSON"
replace mcblack=1 if name=="JACKSON-LEE"
replace mcblack=1 if name=="JOHNSON" & id_statecdst=="TX30"
replace mcblack=1 if name=="JOHNSON" & id_statecdst=="GA4"
replace mcblack=1 if name=="LEE"
replace mcblack=1 if name=="LEWIS"
replace mcblack=1 if name=="MEEKS"
replace mcblack=1 if name=="MOORE"
replace mcblack=1 if name=="NORTON"
replace mcblack=1 if name=="PAYNE"
replace mcblack=1 if name=="RANGEL"
replace mcblack=1 if name=="RICHARDSON"
replace mcblack=1 if name=="RICHMOND"
replace mcblack=1 if name=="RUSH"
replace mcblack=1 if name=="SCOTT" & id_statecdst=="GA13"
replace mcblack=1 if name=="SCOTT" & id_statecdst=="VA3"
replace mcblack=1 if name=="SCOTT" & id_statecdst=="SC1"
replace mcblack=1 if name=="SEWELL"
replace mcblack=1 if name=="THOMPSON" & id_statecdst=="MS2"
replace mcblack=1 if name=="TOWNS"
replace mcblack=1 if name=="WATERS"
replace mcblack=1 if name=="WATT"
replace mcblack=1 if name=="WEST"
replace mcblack=1 if name=="WILSON"

* Hispanic MC dummy variable
* http://history.house.gov/Exhibitions-and-Publications/HAIC/Historical-Data/Hispanic-American-Representatives,-Senators,-Delegates,-and-Resident-Commissioners-by-Congress/
gen mchisp=0
replace mchisp=1 if name=="BACA"
replace mchisp=1 if name=="BECERRA"
replace mchisp=1 if name=="CANSECO"
replace mchisp=1 if name=="CARDOZA"
replace mchisp=1 if name=="COSTA"
replace mchisp=1 if name=="CUELLAR"
replace mchisp=1 if name=="DIAZ-BALART"
replace mchisp=1 if name=="FLORES"
replace mchisp=1 if name=="GONZALEZ"
replace mchisp=1 if name=="GRIJALVA"
replace mchisp=1 if name=="GUTIERREZ"
replace mchisp=1 if name=="HERRERA-Beutler"
replace mchisp=1 if name=="HINOJOSA"
replace mchisp=1 if name=="LABRADOR"
replace mchisp=1 if name=="LUJAN"
replace mchisp=1 if name=="NAPOLITANO"
replace mchisp=1 if name=="NUNES"
replace mchisp=1 if name=="PASTOR"
replace mchisp=1 if name=="REYES"
replace mchisp=1 if name=="RIVERA"
replace mchisp=1 if name=="ROS-LEHTINEN"
replace mchisp=1 if name=="ROYBAL-ALLARD"
replace mchisp=1 if name=="SANCHEZ" & id_statecdst=="CA47"
replace mchisp=1 if name=="SANCHEZ" & id_statecdst=="CA39"
replace mchisp=1 if name=="SERRANO"
replace mchisp=1 if name=="SIRES"
replace mchisp=1 if name=="VELAZQUEZ"

* Party identification of house member
gen partyhouse=.
replace partyhouse=1 if party=="Democratic"
replace partyhouse=0 if party=="Republican"


**
** Respondent/MC congruence

* Co-Partisanship
gen copartisan=0
replace copartisan=1 if pid3==1 & partyhouse==1
replace copartisan=1 if pid3==2 & partyhouse==0

* Ideological similarity
gen newnom=(dwnom1*2)+3
gen newnom2=(dwnom1*1.5)+3
gen absdiff=abs(newnom-ideo5)

**
** Keeping respondents who have answered (i.e., not skipped) at least two policy preference questions
keep if winratio2_miss < 4


********************************************************************************
**** SECTION 3: ANALYSES

**
** Table 1: Descriptive Statistics
sum winratio2_per health3 faminc educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1

**
** Regression results

* Table 2 models
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

* Table 3 models
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)

* Table 4 models
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

* Figure 1 (code between preserve and restore should be run all at once)
sum CC332A CC332B CC332F CC332G CC332H if healthcat == 1
sum CC332A CC332B CC332F CC332G CC332H if healthcat == 2
sum CC332A CC332B CC332F CC332G CC332H if healthcat == 3

preserve
clear
set obs 15

gen pref = .
replace pref = 13.34 if _n == 1
replace pref = 44.05 if _n == 2
replace pref = 48.19 if _n == 3
replace pref = 44.16 if _n == 4
replace pref  = 75.27 if _n == 5

replace pref = 18.81 if _n == 6
replace pref = 48.44 if _n == 7
replace pref = 50.84 if _n == 8
replace pref = 45.29 if _n == 9
replace pref = 73.09 if _n == 10

replace pref = 24.45 if _n == 11
replace pref = 54.40 if _n == 12
replace pref = 53.89 if _n == 13
replace pref = 44.50 if _n == 14
replace pref = 71.63 if _n == 15

gen pref_str = "."
replace pref_str = "13%" if _n == 1
replace pref_str = "44%" if _n == 2
replace pref_str = "48%" if _n == 3
replace pref_str = "44%" if _n == 4
replace pref_str = "75%" if _n == 5

replace pref_str = "19%" if _n == 6
replace pref_str = "48%" if _n == 7
replace pref_str = "51%" if _n == 8
replace pref_str = "45%" if _n == 9
replace pref_str = "73%" if _n == 10

replace pref_str = "24%" if _n == 11
replace pref_str = "54%" if _n == 12
replace pref_str = "54%" if _n == 13
replace pref_str = "45%" if _n == 14
replace pref_str = "72%" if _n == 15

forvalues i=1(1)15{
gen pref`i' = .
replace pref`i' = pref if _n == `i'
}
*

gen n_var = .
replace n_var = 1 if _n == 1
replace n_var = 2 if _n == 6
replace n_var = 3 if _n == 11

replace n_var = 5 if _n == 2
replace n_var = 6 if _n == 7
replace n_var = 7 if _n == 12

replace n_var = 9 if _n == 3
replace n_var = 10 if _n == 8
replace n_var = 11 if _n == 13

replace n_var = 13 if _n == 4
replace n_var = 14 if _n == 9
replace n_var = 15 if _n == 14

replace n_var = 17 if _n == 5
replace n_var = 18 if _n == 10
replace n_var = 19 if _n == 15

twoway(bar pref1 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("240 240 240")) ///
		(bar pref2 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("240 240 240")) ///
		(bar pref3 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("240 240 240")) ///
		(bar pref4 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("240 240 240")) ///
		(bar pref5 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("240 240 240")) ///
		(bar pref6 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("189 189 189")) ///
		(bar pref7 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("189 189 189")) ///
		(bar pref8 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("189 189 189")) ///
		(bar pref9 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("189 189 189")) ///
		(bar pref10 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("189 189 189")) ///
		(bar pref11 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("99 99 99")) ///
		(bar pref12 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("99 99 99")) ///
		(bar pref13 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("99 99 99")) ///
		(bar pref14 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("99 99 99")) ///
		(bar pref15 n_var, barwidth(0.75) lcolor(black) lwidth(thin) fcolor("99 99 99")) ///
		(scatter pref n_var, msymbol(i) mlabel(pref_str) mlabposition(12) mlabsize(2.5) mcolor(black)), ///
		legend(order(1 6 11) label(1 "Low Health") label(6 "Middle Health") label(11 "High Health") row(1) symxsize(5) size(small)) /// 
		ylabel(0 10 20 30 40 50 60 70 80 90 100, labsize(2.5) angle(horizontal) nogrid) ///
		xlabel(2 "Ryan Budget" 6 "Simpson-Bowles" 10 "US/Korea" 14 "Repeal ACA" 18 "Keystone", notick labgap(2)) ///
		xtitle("") ///
		ytitle("Percentage Supporting") ///
		scheme(s1mono) graphregion(fcolor(white))

restore



********************************************************************************
**** SECTION 4: RESULTS FOR THE APPENDIX

**
** ACA preferences
logit CC332G i.healthcat i.inccat educ age black hispanic female if pid3 == 0
logit CC332G i.healthcat i.inccat educ age black hispanic female if pid3 == 2
logit CC332G i.healthcat i.inccat educ age black hispanic female i.pid3 if ideo5 == 1 | ideo5 == 2
logit CC332G i.healthcat i.inccat educ age   hispanic female i.pid3 if ideo5 == 4 | ideo5 == 5

**
** Correlation of Variables
pwcorr winratio2_per health3 faminc educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1

**
** Testing for wealth effects

* Including homeownership as a control
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff i.ownhome if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff i.ownhome if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff i.ownhome if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff i.ownhome if conflict==1 [pweight=weight], cluster(id_statecdst)

* Including homeownership as an interaction with income
reg winratio2_per i.healthcat i.inccat##i.ownhome educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

* Including Zillow data
sum homevalue_cty
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh homevalue_cty if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh homevalue_cty if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh homevalue_cty if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh homevalue_cty if conflict==1 [pweight=weight], cluster(id_statecdst)

**
** Mediation Analyses

* Note: Analyses are conducted in R; the following commands prepare the data for analysis
preserve
drop if votetotal2==.| healthdum==. | inccat==. | age==. | black==. | hispanic==. | female==. | housegender==. | mcblack==. | mchisp==. | polpart2==. | copartisan==.| absdiff==.
keep if conflict==1
saveold "cces2012_finalforr.dta", replace
restore

**
** Alternative Mechanisms

* Coding Partisanship and Knowledge
gen strongpartisan=0
replace strongpartisan=1 if pid7==1 | pid7==7
gen knowhouse=0
replace knowhouse=1 if CC309a==1
gen knowsenate=0
replace knowsenate=1 if CC309b==2
recode CC334C CC334D CC334E CC334F (8=.)
gen knowpres=0
replace knowpres=1 if CC334C<CC334D
gen knowparty=0
replace knowparty=1 if CC334E<CC334F
alpha knowhouse knowsenate knowpres knowparty, std detail gen(polknow3)

* Estimating models
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff strongpartisan polknow3 polinter if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff strongpartisan polknow3 polinter if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff strongpartisan polknow3 polinter if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff strongpartisan polknow3 polinter if conflict==1 [pweight=weight], cluster(id_statecdst)



********************************************************************************
**** SECTION 5: ADDITIONAL ROBUSTNESS CHECKS (REFERENCED IN TEXT, BUT NOT REPORTED IN APPENDIX)

**
** Footnote 5: Modeling conflict districts

* All districts
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if inccat==3 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh [pweight=weight], cluster(id_statecdst)

* Districts with at least two conflicts
reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict_tot > 1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if inccat==1 & conflict_tot > 1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per i.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if inccat==3 & conflict_tot > 1 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict_tot > 1 [pweight=weight], cluster(id_statecdst)

**
** Page 16: Using alternative estimators (ordered logit and Poisson models of Table 2)
ologit winratio2_mean i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
ologit winratio2_mean i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 if conflict==1 [pweight=weight], cluster(id_statecdst)
ologit winratio2_mean i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)
ologit winratio2_mean i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

poisson wincount2 i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
poisson wincount2 i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 if conflict==1 [pweight=weight], cluster(id_statecdst)
poisson wincount2 i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)
poisson wincount2 i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

**
** Page 16: Examining difference between middle and high health groups

* Table 2
reg winratio2_per ib2.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per ib2.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per ib2.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per ib2.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

* Table 3
reg winratio2_per ib2.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per ib2.healthcat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)
reg winratio2_per ib2.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 & inccat==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per ib2.healthcat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 & inccat==3 [pweight=weight], cluster(id_statecdst)

* Table 4 models
bysort partyhouse: reg winratio2_per ib2.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
bysort partyhouse: reg winratio2_per ib2.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

**
** Footnote 9: Analyzing each "win" separately
logit ryanwin_miss i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
logit repealwin_miss i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
logit repealwin2_miss i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
logit simpsonwin_miss i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
logit uskoreawin_miss i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
logit keystonewin_miss i.healthcat i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)

**
** Footnote 10: Using interaction terms for Table 2 (health*income) and Table 3 (health*party)
reg winratio2_per healthcat##inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per healthcat##inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)

reg winratio2_per healthcat##partyhouse i.inccat educ age black hispanic female housegender mcblack mchisp housefresh if conflict==1 [pweight=weight], cluster(id_statecdst)
reg winratio2_per healthcat##partyhouse i.inccat educ age black hispanic female housegender mcblack mchisp housefresh votetotal2 polpart2 copartisan absdiff if conflict==1 [pweight=weight], cluster(id_statecdst)
