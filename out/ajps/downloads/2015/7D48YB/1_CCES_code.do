* This file cleans the CCES common data file for use in Study 3 of Broockman & Ryan, Preaching
* to the Choir (AJPS). Analysis was conducted on State/SE 13.1 for 
* Mac (64-bit Intel) 

clear all
cd "~/Dropbox/Broockman-Ryan/Outpartisan Communication/DATA/Final Replication Files/Study3"
use "cces_2008_common.dta", clear // Load CCES dataset, to be downloaded from CCES website. (Not included with replication files.)


gen id = V100

gen weight = V201

* State
rename V206 state2
decode state2, gen(state)
numlabel V206, add

* District
gen district = V250
destring district, replace
replace district = 1 if district==0

* Partisanship
gen pidr2 = CC307a
replace pidr2 = pidr2 - 1
replace pidr2 = . if pidr2==7

gen rdem = .
replace rdem = 1 if pidr2 < 3
replace rdem = 0 if pidr2 > 3
replace rdem = . if pidr2 == .

recode CC307a (1 = 3) (2 = 2) (3 = 1) (4 5 6 7 8 = 0), gen(dempidstr2)
recode CC307a (7 = 3) (6 = 2) (5 = 1) (4 3 2 1 8 = 0), gen(reppidstr2)
gen dempidstr = dempidstr2 / 3
gen reppidstr = reppidstr2 / 3

* Leglislator contact
recode CC320 (1 = 1) (2 = 0), gen(contact)

* Gender
recode V208 (1 = 0) (2 = 1), gen(female)

* Age
gen agecat = V247-1
lab def agecat 0 "18-34" 1 "35-54" 2 "55+"
lab val agecat agecat

gen age = 2008 - V207

* Income
gen incomecat2 = V246 - 1
gen incomecat = incomecat2 / 14


* Pol activity
foreach num of numlist 1/5 { // Exclude donations. These will be handled separately.
	recode CC415_`num' (1 = 1) (2 = 0), gen(act`num')
	}

alpha act*, gen(actscale)

* Donations
foreach num of numlist 1/9 {
	recode CC416a_`num' (1 = 1) (2 = 0), gen(donate`num')
	}

recode CC415_6 (1=1) (2=0) (.=.), gen(donategen)
	
gen donatescale2 = donate1 + donate2 + donate3 + donate4 + donate5 + donate6 + donate7 + donate8 + donate9
replace donatescale2 = 0 if donatescale2==.
gen donatescale = donatescale2/9


* Church attendance
tab V217, gen(church)
drop church7
recode V217 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) (6 = 0) (7 = .), gen(church)
replace church = church / 5

* Interest in politics
recode V244 (1 = 3) (2 = 2) (3 = 1) (4 = 0) (7 = 0), gen(followpol2)
gen followpol = followpol2 / 3


** Political knowledge (Thanks to Daniel Biggers for providing code here, though he bears no responsibility for any errors.)

* Party control of U.S. House - Code correct if answer = Dem.
gen pk1pmh=0
replace pk1pmh=1 if  CC308a==2

*Party control of U.S. Senate - Code correct if answer = Dem.
gen pk2pms=0
replace pk2pms=1 if  CC308b==2

*Party control of State Senate. 
gen pk3pmss=0
replace pk3pmss=1 if state2==1 &  CC308c==2 | state2==2 &  CC308c==1 | ///
	state2==4 & CC308c==1 | state2==5 &  CC308c==2 | state2==6 & CC308c==2 | ///
	state2==8 & CC308c==2 | state2==9 & CC308c==2 | state2==10 & CC308c==2 | ///
	state2==12 & CC308c==1 | state2==13 & CC308c==1 | state2==15 & CC308c==2 | ///
	state2==16 & CC308c==1 | state2==17 & CC308c==2 | state2==18 & CC308c==1 | ///
	state2==19 & CC308c==2 | state2==20 & CC308c==1 | state2==21 & CC308c==1 | ///
	state2==22 & CC308c==2 | state2==23 & CC308c==2 | state2==24 & CC308c==2 | ///
	state2==25 & CC308c==2 | state2==26 & CC308c==1 | state2==27 & CC308c==2 | ///
	state2==28 & CC308c==2 | state2==29 & CC308c==1 | state2==30 & CC308c==2 | ///
	state2==31 & CC308c==3 | state2==32 & CC308c==1 | state2==33 & CC308c==2 | ///
	state2==34 & CC308c==2 | state2==35 & CC308c==2 | state2==36 & CC308c==1 | ///
	state2==37 & CC308c==2 | state2==38 & CC308c==1 | state2==39 & CC308c==1 | ///
	state2==40 & CC308c==3 | state2==41 & CC308c==2 | state2==42 & CC308c==1 | ///
	state2==44 & CC308c==2 | state2==45 & CC308c==1 | state2==46 & CC308c==1 | ///
	state2==47 & CC308c==1 | state2==48 & CC308c==1 | state2==49 & CC308c==1 | ///
	state2==50 & CC308c==2 | state2==51 & CC308c==2 | state2==53 & CC308c==2 | ///
	state2==54 & CC308c==2 | state2==55 & CC308c==2 | state2==56 & CC308c==1

*Party control of State House.
gen pk4pmsh=0
replace pk4pmsh=1 if state2==1 & CC308d==2 | state2==2 & CC308d==1 | ///
	state2==4 & CC308d==1 | state2==5 & CC308d==2 | state2==6 & CC308d==2 | ///
	state2==8 & CC308d==2 | state2==9 & CC308d==2 | state2==10 & CC308d==1 | ///
	state2==12 & CC308d==1 | state2==13 & CC308d==1 | state2==15 & CC308d==2 | ///
	state2==16 & CC308d==1 | state2==17 & CC308d==2 | state2==18 & CC308d==2 | ///
	state2==19 & CC308d==2 | state2==20 & CC308d==1 | state2==21 & CC308d==2 | ///
	state2==22 & CC308d==2 | state2==23 & CC308d==2 | state2==24 & CC308d==2 | ///
	state2==25 & CC308d==2 | state2==26 & CC308d==2 | state2==27 & CC308d==2 | ///
	state2==28 & CC308d==2 | state2==29 & CC308d==1 | state2==30 & CC308d==1 | ///
	state2==31 & CC308d==3 | state2==32 & CC308d==2 | state2==33 & CC308d==2 | ///
	state2==34 & CC308d==2 | state2==35 & CC308d==2 | state2==36 & CC308d==2 | ///
	state2==37 & CC308d==2 | state2==38 & CC308d==1 | state2==39 & CC308d==1 | ///
	state2==40 & CC308d==1 | state2==41 & CC308d==2 | state2==42 & CC308d==2 | ///
	state2==44 & CC308d==2 | state2==45 & CC308d==1 | state2==46 & CC308d==1 | ///
	state2==47 & CC308d==2 | state2==48 & CC308d==1 | state2==49 & CC308d==1 | ///
	state2==50 & CC308d==2 | state2==51 & CC308d==1 | state2==53 & CC308d==2 | ///
	state2==54 & CC308d==2 | state2==55 & CC308d==1 | state2==56 & CC308d==1

*Party control of Governor.
gen pk5prgov=0
replace pk5prgov=1 if state2==1 & CC309a==2 | state2==2 & CC309a==2 | ///
	state2==4 & CC309a==3 | state2==5 & CC309a==3 | state2==6 & CC309a==2 | ///
	state2==8 & CC309a==3 | state2==9 & CC309a==2 | state2==10 & CC309a==3 | ///
	state2==12 & CC309a==2 | state2==13 & CC309a==2 | state2==15 & CC309a==2 | ///
	state2==16 & CC309a==2 | state2==17 & CC309a==3 | state2==18 & CC309a==2 | ///
	state2==19 & CC309a==3 | state2==20 & CC309a==3 | state2==21 & CC309a==3 | ///
	state2==22 & CC309a==2 | state2==23 & CC309a==3 | state2==24 & CC309a==3 | ///
	state2==25 & CC309a==3 | state2==26 & CC309a==3 | state2==27 & CC309a==2 | ///
	state2==28 & CC309a==2 | state2==29 & CC309a==2 | state2==30 & CC309a==3 | ///
	state2==31 & CC309a==2 | state2==32 & CC309a==2 | state2==33 & CC309a==3 | ///
	state2==34 & CC309a==3 | state2==35 & CC309a==3 | state2==36 & CC309a==3 | ///
	state2==37 & CC309a==3 | state2==38 & CC309a==2 | state2==39 & CC309a==3 | ///
	state2==40 & CC309a==3 | state2==41 & CC309a==3 | state2==42 & CC309a==3 | ///
	state2==44 & CC309a==2 | state2==45 & CC309a==2 | state2==46 & CC309a==2 | ///
	state2==47 & CC309a==3 | state2==48 & CC309a==2 | state2==49 & CC309a==2 | ///
	state2==50 & CC309a==2 | state2==51 & CC309a==3 | state2==53 & CC309a==3 | ///
	state2==54 & CC309a==3 | state2==55 & CC309a==3 | state2==56 & CC309a==3

*U.S. Sen 1 & 2 Party ID.
gen pk6sen1=0
encode V544, gen(sen1pid)
numlabel sen1pid, add
replace pk6sen1=1 if sen1pid==1 & CC309b==3
replace pk6sen1=1 if sen1pid==2 & CC309b==2
numlabel LABE, add

gen pk7sen2=0
encode V548, gen(sen2pid)
numlabel sen2pid, add
replace pk7sen2=1 if sen2pid==4 & CC309c==2
replace pk7sen2=1 if sen2pid==1 & CC309c==3
replace pk7sen2=1 if sen2pid==2 & CC309c==3
replace pk7sen2=1 if sen2pid==3 & CC309c==4

*Ideological placement of Dem and Rep Party.
gen pk8pp=0
replace pk8pp=1 if (CC317b < CC317c) & CC317b~=. & CC317c~=.

*Ideological placement of Obama and McCain.
gen pk9om=0
replace pk9om=1 if (CC317h < CC317g) & CC317h~=. & CC317g~=.

*Ideological placement of Obama and Bush.
gen pk10ob=0
replace pk10ob=1 if (CC317h < CC317d) & CC317h~=. & CC317d~=.

alpha pk*, detail // .86

egen pknowl = rowtotal(pk*)
replace pknowl = pknowl / 10


foreach var in church age actscale followpol dempidstr reppidstr incomecat donategen {
	gen `var'mr = `var'	
	sum `var'
	gen `var'miss = 0
	replace `var'miss = 1 if `var'mr==.
	replace `var'mr = r(mean) if `var'mr==.	
}

keep pidr2 district state contact id weight rdem female agecat age incomecat* ///
	church* dempidstr* reppidstr* followpol* actscale* pk* *mr pknowl donate*
	

save "cces_2008_working.dta", replace
