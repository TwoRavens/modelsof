* Replication file
* Journal of Politics
* "When the Pound in People’s Pocket Matters:
* How changes to personal financial circumstances affect party choice"
* James Tilley (Oxford), Anja Neundorf (Nottingham) and Sara Hobolt (LSE)


* BRITISH HOUSEHOLD PANEL STUDY (BHPS): Data managment, recoding and modelling

* This file allows the following:
* 1. Data merging of raw BHPS data
* 2. Recode all variables used in the article
* 3. Prepare sepearte datasets for Conservative and Labour governmental periods. 
* 	 Several datasets were created to allow also for robustness tests. 
*	 Data is used in LatentGOLD to estimate Markov models.
* 4. Estimation of Robustness Tests: Fixed effects models


* -----------------------------------------------------------------------------
* DATA ACCESS: 
* To re-analyze this data set,  it is neccesary to apply for a 
* standard BHPS user contract in order to be granted access to the archived data,
* which can be requested via  https://discover.ukdataservice.ac.uk/catalogue/?sn=5151
* at the UK DATA ARCHIVE

clear all
set more off
cd "PATH" // change path to where BHPS raw data is saved; in that folder also create a subfolder called "temp"


* -----------------------------------------------------------------------------
* 1. Data merging of raw BHPS data


* ========================================
* = extract variables from raw bhps data =
* ========================================


local waves = "a b c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp", clear
	keep `i'vote1 `i'vote2 `i'vote4 `i'vote5 `i'sex `i'qfachi `i'casmin `i'isced `i'jbgold `i'tenure `i'region ///
	`i'race  `i'qfedhi `i'fimn `i'fiyr `i'fiyrl `i'fiyeari `i'jbonus `i'jbrise `i'age `i'hid `i'pno  `i'jbsemp ///
	`i'jbmngr `i'jbisco `i'jssize  `i'jbhrs `i'jbot `i'jshrs `i'jbsoc `i'jbsect ///
	`i'paygu `i'paynu `i'paygui `i'paynui `i'mastat  ///
	`i'fimnb `i'fimnbi `i'fimnp `i'fimnpi   ///
	`i'fiyrb `i'fiyrbi `i'fiyrp `i'fiyrpi   `i'fiyrt `i'fiyrti  ///
	`i'hlsv `i'jbsat4 `i'plbornc  `i'jbft `i'jbstat  `i'jbub `i'jbuby `i'fisit `i'fisitc `i'fisitx  ///
	`i'jbstatl `i'jbstat `i'spjbyr `i'cjsbgy4 `i'jlend4 `i'njbnew `i'njbwks `i'sppid `i'jboff `i'jboffy pid ///
	
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _a
append using _b _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main.dta", replace

* ========================================
* = extract variables vote3 =
* ========================================


local waves = "a c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'vote3  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _a
append using   _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main_vote3.dta", replace


* ========================================
* = extract variables Job History =
* ========================================


local waves = "a b c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'jobhist", clear
	keep `i'jhstpy  pid
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _a
append using _b _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

tab jhstpy, 
tab jhstpy, nolabel 
recode jhstpy (-9/-1=.)
drop if jhstpy==. 
 
*drop jhstpy_new
bys pid waven: egen jhstpy_new = mode(jhstpy)

drop if jhstpy_new==.
drop count
bys pid waven: egen count = count(waven)
tab count

sort count  pid waven
// IMPORTANT! AT THIS POINT, I CODED ALL DOUBLE WAVES AS 1 IN EXCELL 
drop if count_new!=1

corr jhstpy jhstpy_new
drop jhstpy

lab def reasolbl 1"Promoted"	2"Left for better job"	3"Made redundant"	4"Dismissed or sacked"	///
5 "Temporary job ended"	6"Took retirement"	7"Stopped health reas"	8"Left to have baby"	///
9" Children/home care"	10"Care of other person" 11	"Moved away" 12 "Started college or university" ///
13"Other reason"

lab val jhstpy_new reasolbl
lab var jhstpy_new "Reason for stopping previous job"

recode jhstpy_new (11=13) if waven>5
rename jhstpy_new jhstpy
tab jhstpy

drop count count_new 
sort  pid wave
save "temp/__main_Jobhist.dta", replace

* ========================================
* = extract variables Fin sit change =
* ========================================


local waves = "c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'fisitc `i'fisity pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _c
append using _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main_fisit.dta", replace

* ========================================
* = extract vote variables =
* ========================================


local waves = " b e g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'vote1 `i'vote7 `i'vote8  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "temp/_`i'vot", replace
}
* ip -- pid
use temp/_pvot
ren id pid
save "temp/_pvot", replace

use temp/_bvot
append using temp/_evot temp/_gvot temp/_hvot temp/_ivot temp/_jvot temp/_kvot temp/_lvot temp/_mvot temp/_nvot ///
 temp/_ovot temp/_pvot temp/_qvot temp/_rvot
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__mainvote", replace



* ========================================
* = extract political interest  =
* ========================================

local waves = "a b c d e f  k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'vote6  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'pol", replace
}
* ip -- pid
use _ppol
ren id pid
save "_ppol", replace

use _apol
append using _bpol _cpol _dpol _epol _fpol _kpol _lpol _mpol _npol _opol _ppol _qpol _rpol
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save temp/__main_polint, replace

* ========================================
* = extract nat. economic evaluation variables  =
* ========================================


local waves = "b d f "

foreach i of local waves {
	use "Data_BHPS/`i'indresp", clear
	keep `i'opiss1 `i'opiss3  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i'econ, replace
}


use _becon
append using  _decon _fecon 
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__mainecon", replace


* ============================
* = merge in additional info =
* ============================

use "Data_BHPS/xwlsten"
sort pid
save __tmp2, replace

use "temp/__main", clear
*merge m:1 pid using __tmp1, gen(_merge1)
merge m:1 pid using __tmp2, gen(_merge2)
sort pid wave

merge pid wave using "temp/__main_polint"
sort pid wave
drop _merge

merge pid wave using "temp/__mainvote"
sort pid wave
drop _merge

merge pid wave using "temp/__main_vote3"
sort pid wave
drop _merge

merge pid wave  using "temp/__main_Jobhist"
sort pid wave
drop _merge

merge pid wave  using "temp/__main_fisit"
sort pid wave
drop _merge

merge pid wave  using "temp/__mainecon"
sort pid wave
drop _merge


sort pid wave
browse pid waven
save BHPS_main, replace


* ===========================
* = ----- CHECK ------ =
* ===========================
rename waven time
sort hid pid time

browse hid pid time vote8

***** SAFE the BHPS working file 
compress
save "BHPS_working.dta", replace



* -----------------------------------------------------------------------------
* 2. Recode all variables used in the article

use BHPS_working, clear


* ========================================
* = Sample used: region and BHPS samples  =
* ========================================

* Region
tab region, m
tab region, nolabel
drop if region == -9
drop if region==19 //drop Northern Ireland


* ========================================
* = Recoding of variables   =
* ========================================

* Time variable + 1997-dummy
*browse time wave
tab time,m
gen year = time + 1990
tab year

gen gov_period = .
replace gov_period = 1 if year <1997
replace gov_period = 2 if year>1996 
lab def govlbl 1"Tory gov" 2"Labour gov" 
lab val gov_period govlbl
tab gov_period,m

gen y1997=0
replace y1997 = 1 if year>1996

tab year y1997

* ========================================
** DV: Party support
* ========================================
tab vote1 
tab vote2
tab vote3 
tab vote4
tab vote5 
tab vote6
tab vote7 
tab vote8


* ========================================
* PARTY ID JAMES

*Includes vote intention

gen partyid =. 
replace partyid = 5 if vote2==2
replace partyid = 5 if vote2==-1
replace partyid = 5 if vote4==10
replace partyid = 5 if vote4==8
replace partyid = 5 if vote4==-1
replace partyid = 5 if vote3==10
replace partyid = 5 if vote3==8
replace partyid = 5 if vote3==-1
replace partyid = 1 if vote3==1 
replace partyid = 2 if vote3==2 
replace partyid = 3 if vote3==3 
replace partyid = 1 if vote4==1 
replace partyid = 2 if vote4==2
replace partyid = 3 if vote4==3
replace partyid = 4 if vote3==4
replace partyid = 4 if vote3==5
replace partyid = 4 if vote3==6
replace partyid = 4 if vote3==7
replace partyid = 4 if vote4==4
replace partyid = 4 if vote4==5
replace partyid = 4 if vote4==6
replace partyid = 4 if vote4==7
recode partyid (1=1 "Con") (2=2 "Lab") (3=3 "LD") (4=4 "Other") (5=5 "None") (else=.), into(partyid1)
replace partyid1 = 5 if (partyid1==. & year==1992 & vote7==2)
replace partyid1 = 5 if (partyid1==. & year==1992 & vote7==-1)
replace partyid1 = 5 if (partyid1==. & year==1992 & vote8==-1)
replace partyid1 = 1 if (partyid1==. & year==1992 & vote8==1)
replace partyid1 = 2 if (partyid1==. & year==1992 & vote8==2)
replace partyid1 = 3 if (partyid1==. & year==1992 & vote8==3)
replace partyid1 = 4 if (partyid1==. & year==1992 & vote8==4)
replace partyid1 = 4 if (partyid1==. & year==1992 & vote8==5)
replace partyid1 = 4 if (partyid1==. & year==1992 & vote8==6)
replace partyid1 = 4 if (partyid1==. & year==1992 & vote8==7)
replace partyid1 = 1 if (partyid1==5 & year==1992 & vote8==1)
replace partyid1 = 2 if (partyid1==5 & year==1992 & vote8==2)
replace partyid1 = 3 if (partyid1==5 & year==1992 & vote8==3)
replace partyid1 = 4 if (partyid1==5 & year==1992 & vote8==4)
replace partyid1 = 4 if (partyid1==5 & year==1992 & vote8==5)
replace partyid1 = 4 if (partyid1==5 & year==1992 & vote8==6)
replace partyid1 = 4 if (partyid1==5 & year==1992 & vote8==7)

 tab partyid1
 bysort gov_period: tab partyid1
 
* Opp/Gov
recode partyid1 (1=1 "Govt") (2/4=2 "Opposition") (5=3 "None"), into(govopp)
replace govopp = 2 if (partyid1==1 & year>1996)
replace govopp = 1 if (partyid1==2 & year>1996)
replace govopp = 2 if (partyid1==3 & year>1996)
replace govopp = 2 if (partyid1==4 & year>1996)

 
recode govopp (1=1 "Government") (2=0 "Opposition") (3=.), into(govopp1)
recode govopp (2/3=0), gen(gov_pid)
tab gov_pid
 
recode partyid1 (1=1 "Govt") (2=2 "Opposition") (3/4=3 "LDs and others")(5=4 "None"), into(govopp2)
replace govopp2 = 2 if (partyid1==1 & year>1996)
replace govopp2 = 1 if (partyid1==2 & year>1996)



*Excludes vote intention

gen partyida =. 
replace partyida = 5 if vote2==2
replace partyida = 5 if vote2==-1
replace partyida = 5 if vote4==10
replace partyida = 5 if vote4==8
replace partyida = 5 if vote4==-1
replace partyida = 1 if vote4==1 
replace partyida = 2 if vote4==2
replace partyida = 3 if vote4==3
replace partyida = 4 if vote4==4
replace partyida = 4 if vote4==5
replace partyida = 4 if vote4==6
replace partyida = 4 if vote4==7
recode partyida (1=1 "Con") (2=2 "Lab") (3=3 "LD") (4=4 "Other") (5=5 "None") (else=.), into(partyida1)

* ========================================
*** Recoding Vote choice

tab vote8,m
tab vote8,nolabel

tab vote7,m
tab vote7,nolabel
 
gen vote=vote8 
recode vote (-9/-1=.) (4/8=4)
replace vote=5 if vote7==2|vote7==3
lab def votelbl 1 "Con" 2 "Lab" 3 "LD" 4 "Other" 5 "None"
lab val vote  votelbl
tab vote

corr partyida vote
tab partyida vote

* ========================================
*** ATTITUDE: Change in financial situation

tab1 fisit fisitc fisitx fisity
tab1 fisit fisitc fisitx, nolabel


recode fisit (-9/-1=.) 
recode fisitc (-9/-1=.) 
recode fisitx (-9/-1=.)
recode fisity (-9/-1=.)

tab fisitc
tab fisitc, nolabel

recode fisitc  (3=0), gen(fisit_new)
tab fisit_new 
lab def worrylbl 1"better off" 2"worse off" 0"same"
lab val fisit_new worrylbl

* ========================================
* Subjective reasons
* ========================================


recode fisity (1=1 "Increased earnings") (2=2 "Increased benefits") (3=3 "Increased investment") ///
 (4=4 "Reduced expenses") (5=5 "Windfall") ///
(26=6 "Good management") (31=7 "Other reason") (else=.), into (whybetteroff)
replace whybetteroff = 8 if fisitc == 3                        
replace whybetteroff = 0 if fisitc == 2
                                   
recode fisity (11=1 "Decreased earnings") (12=2 "Decreased benefits") (13=3 "Decreased investment") ///
 (14=4 "More expenses") (15=5 "Windloss") ///
(32=7 "Other reason") (else=.), into (whyworseoff)
replace whyworseoff = 8 if fisitc == 3                        
replace whyworseoff = 0 if fisitc == 1

tab1 whyworseoff whybetteroff
           
recode fisity (1=1 "Increased earnings") (2=2 "Increased benefits") (3=3 "Increased investment") ///
 (4=4 "Reduced expenses") (5=5 "Windfall") ///
(26=6 "Good management") (31=7 "Other reason") (11=8 "Decreased earnings") (12=9 "Decreased benefits") ///
(13=10 "Decreased investment") ///
(14=11 "More expenses") (15=12 "Windloss") (32=13 "Other reason") (else=.), into(betterworseoff)

replace betterworseoff = 0 if fisitc == 3          
replace betterworseoff = 0 if fisity == 27                   
replace betterworseoff = 0 if fisity == 33       
replace betterworseoff = . if fisitc == 2 & fisity == 1  
replace betterworseoff = . if fisitc == 2 & fisity == 2  
replace betterworseoff = . if fisitc == 2 & fisity == 3  
replace betterworseoff = . if fisitc == 2 & fisity == 4  
replace betterworseoff = . if fisitc == 2 & fisity == 5  
replace betterworseoff = . if fisitc == 1 & fisity == 11
replace betterworseoff = . if fisitc == 1 & fisity == 12
replace betterworseoff = . if fisitc == 1 & fisity == 13
replace betterworseoff = . if fisitc == 1 & fisity == 14
replace betterworseoff = . if fisitc == 1 & fisity == 15
replace betterworseoff = 4 if fisitc == 1 & fisity == 21           
replace betterworseoff = 8 if fisitc == 2 & fisity == 21
replace betterworseoff = 1 if fisitc == 1 & fisity == 22           
replace betterworseoff = 11 if fisitc == 2 & fisity == 22         
replace betterworseoff = 1 if fisitc == 1 & fisity == 23           
replace betterworseoff = 9 if fisitc == 2 & fisity == 23           
replace betterworseoff = 2 if fisitc == 1 & fisity == 24           
replace betterworseoff = 11 if fisitc == 2 & fisity == 24         
replace betterworseoff = 10 if fisitc == 2 & fisity == 25         
replace betterworseoff = 7 if fisitc == 1 & fisity == 96           
replace betterworseoff = 13 if fisitc == 2 & fisity == 96         
 
recode betterworseoff (1=1 "Increased earnings") (2=2 "Increased benefits") (4=3 "Reduced expenses") ///
 (3=4 "Other increase") (5=4) (6=4) (7=4) (8=5 "Decreased earnings") (9=6 "Decreased benefits") ///
 (11=7 "More expenses") (12=12 "Other decrease") (10=12) (13=12) (else=.), into(betterworseoff1)

tab betterworseoff1

recode betterworseoff (0=0) (1=1 "Increased earnings") (2=2 "Increased benefits") (4=3 "Reduced expenses") ///
(3=4 "Other increase") (5=4) (6=4) (7=4) (8=5 "Decreased earnings") (9=6 "Decreased benefits") ///
(11=7 "More expenses") (12=12 "Other decrease") (10=12) (13=12) (else=.), into(betterworseoff2)

tab1 betterworseoff1 betterworseoff2

recode betterworseoff2 (0/1=0) (2=1 "Increased benefits") (4/5=0 ) ///
 (6=-1 "Decreased benefits") ///
(7/12=0) (else=.),  gen(benefits_change)
tab benefits_change



* ========================================
* CONTROL VARIABLES
* ========================================

* Set panel structure
tsset pid time

* ============================================
**  Employment 

tab1  jbstat
tab jbstat, nolabel

recode jbstat (-9/-1=.), gen(workingpop) 

* unempl in t 
gen unemp =0
replace unemp = 1 if jbstat==3
tab unemp


* ========================================
* Income
* income last month: fimn
* income last annual: fiyr
* labour income last annual: fiyrl
* fiyeari is imputation flag


sum fiyr fiyrl fimn paynu,d

recode fimn (-9 -7 = .), gen(incmnth)
recode fiyr (-9 -7 = .), gen(incyear)
recode fiyrl (-9 -7 = .), gen(incyear_lab) 
recode paynu (-9/-1 = .), gen(netpay) 

**** NET INCOME

net search xtile // Install package egenmore
sum netpay, d
egen netpay_10 = xtile(netpay), nq(10) by(year)


* ========================================
**** Benefits

tab jbub
tab jbub, nolabel

recode jbub (-9/-1=.) (2=0), gen(uenmp_bf) 
tab uenmp_bf

** Benfits general
sum fimnb fiyrb,d
recode fimnb fiyrb (-9/-1=.) ( 12469.2/378130.6=.) // Kicking out the outliers

*drop benef_dum
gen benef_dum = . 
replace benef_dum = 1 if fiyrb>0
replace benef_dum = 0 if fiyrb==0
tab benef_dum

bys benef_dum: sum fimnb fiyrb

* Create lagged variables
sort pid time
gen benef_dum1 = L1.benef_dum
gen fiyrb1 = L1.fiyrb
browse pid time fiyrb1 fiyrb


** Absolute change in benefits
gen benefits_diff = fiyrb-fiyrb1 
sum benefits_diff,d
kdensity benefits_diff

bys benefits_change: sum benefits_diff

* Generating categorical variable for losses and gains (amount = average change)
gen benef_diff_ch = .
replace benef_diff_ch=-1 if benefits_diff<-150
replace benef_diff_ch=1 if benefits_diff>150
replace benef_diff_ch=0 if benefits_diff>-149.9 &  benefits_diff<150.1
replace benef_diff_ch=. if benefits_diff==.

lab def benchlbl1 -1"Loss of at least £150 in benefits" 0"No change" 1"Gain of at least £150 in benefits"
lab val benef_diff_ch benchlbl1
bys y1997: tab benef_diff_ch
tab benef_diff_ch, gen( benef_diff_ch)


** Proportional change in benefits
gen benefits_prop = fiyrb/fiyrb1 if benef_dum1==1 & benef_dum==1
sum benefits_prop,d
kdensity benefits_prop if benefits_prop<8 // Plotting 99% of values, kicking out outliers

gen benef_ch = .
replace benef_ch=-1 if benefits_prop<0.75
replace benef_ch=1 if benefits_prop>1.25
replace benef_ch=0 if benefits_prop>0.749 &  benefits_prop<1.251
replace benef_ch=. if benefits_prop==.


lab def benchlbl -1"25%+ loss in benefits" 0"No change" 1"25%+ gain in benefits"
lab val benef_ch benchlbl
tab benef_ch, gen(benef_ch)


* ========================================
** Gender
recode sex (-9 -7 = .) (1=0) (2=1), gen(female)
drop sex

tab female if partyid1!=.

* ========================================
*housing tenure

tab tenure,m

recode tenure (-9=.) (1 2=1 own) (3 4=2 social) (5/8=3 rented), gen(housing)
recode tenure (-9=0 missing) (.=0) (1=1 owned) (2=2 mortgage) (3 4=3 scoial) (5/8=4 rented), gen(housing2)

tab housing2



* ========================================
*education

tab1 qfachi 
tab qfachi, nolabel
recode qfachi (-9/-7=.) (6/7=0) (5=1) (4=2) (1/3=3), gen(quali)
lab def quallbl 0"none" 1"O Level" 2"A Level" 3"Degree"
lab val quali quallbl
tab quali


tab isced
tab isced, nolabel
recode isced (-7/0=.)

gen educ = isced
recode educ  (7=6)  (2=1) 
replace educ=1 if qfedhi==13
recode educ (.=0)
lab def educlbl1 0"Missing" 1 "Primary or none" 3 "low sec-voc" 4 "hisec-mivoc" 5"higher voc" 6 "degree"
lab val educ educlbl1
tab educ

corr educ quali

** Max Education: as non-varying variable

bysort pid: egen max_educ = max(educ) 
lab var max_educ "Max Education"


lab val max_educ educlbl1
tab max_educ


* ========================================
* age
sum age,d
recode age (-9=.)

drop if age<18
gen age2 = age*age


* ========================================
** Political Interest

tab vote6,m
tab vote6, nolabel


gen polint = vote6
recode polint (-9/0=.) (1=4) (2=3) (3=2) (4=1)
lab def intlbl1 0"missing" 1"not at all int" 2"not very int" 3"fairly int" 4"very int"
lab val polint intlbl1
lab var polint "RECODE Political Interest"
tab polint


* ========================================
** Goldthorpe classification

tab jbgold
tab jbgold, nolabel


recode jbgold (.=0) (-9/-1=0) (5/7=5) (8=6) (9=7) (10/11=8),gen(socclass)
lab def classlbl 0"No classification/missing" 1"service class,higher grade" 2"service class,lower grade" ///
3"routine non-manual employees" 4"personal service workers" 5"self-empl. + farmers,smallholders" ///
6 "foreman,technicians" 7"skilled manual workers" 8"semi,unskilled manual workers + agricultural workers"

lab val socclass classlbl
tab socclass,m


* ========================================
** Trade union

tab1 orgmb orgab
tab1 orgmb orgab, nolabel


gen union = orgab
recode union (-9/-7=.)

* ========================================
** sector 

tab1 jbsect
tab1 jbsect, nolabel

recode jbsect (-9/-1=0 Inapp+Missing) (.=0) (1=1 "Privat firm+comp") (2/3=2 "Public+Gov") (4=3  "nhs or higher educ" ) ///
(5=5 Other) (6=4 "non-profit orgs.") (7/8=5), gen(sector) 
tab sector


* ========================================
** Nat. economic indiators

tab1 opiss1 opiss3
tab1 opiss1 opiss3, nolabel

recode  opiss1 opiss3 (-9/-1=.) (1=4)(2=3)(3=2)(4=1)

corr opiss1 opiss3

tab year if opiss1!=.

*** WHO GETS BENEFITS
tab benef_dum

bys benef_dum: sum unemp netpay_10 female  quali polint  union 

**** Recode all IVs to missing
recode netpay_10 (.=0)
recode polint (.=0)

***** CONTROL VARIABLES

tab1 partyid1 fisitc betterworseoff unemp netpay_10 female housing2 max_educ polint socclass union sector if partyid1!=.,m

**** Safe DATA *****

save "BHPS_econvote", replace



* -----------------------------------------------------------------------------
* 3. Prepare sepearte datasets for Conservative and Labour governmental periods. 


* ========================================
** Split file into two periods: TORIES

use "BHPS_econvote", clear
drop if year==.

* 1. Tories
drop if y1997==1
tab time,m
gen time1=time-1 
recode time1(0=.)
drop time
rename time1 time

* ========================================
** First year included in study

egen min_year = min(year) if partyid1 !=., by(pid)
tab min_year 

//52% joined the sample in 1991


* Unempl in first year
gen unemp91 = 0 if partyid!=.
replace unemp91=1 if unemp==1 & year==min_year
bys pid: egen min_unemp = max(unemp91)

sort pid year
*browse pid year min_year unemp unemp91 min_unemp partyid1

* Age
bys pid: egen min_age = min(age)
recode min_age (18/25 =1 "18-25") (26/35 = 2 "26-35") (36/45=3 "36-45") (46/55=4 "46-55") (56/65=5 "56-65") (66/110=6 "66+"), gen(agecat91)
tab agecat91

* Region

gen region91 = 0 if partyid!=.
replace region91=region if year==min_year
bys pid: egen min_region = max(region91)
*browse pid year region region91 min_region

* Housing
gen house91 = 0 if partyid!=.
replace house91=housing2 if year==min_year
bys pid: egen min_housing = max(house91)
lab def houselbl 0"Missing" 1"Own" 2"Mortage" 3"Social" 4"Rented"
lab val min_housing houselbl
tab min_housing,m

* social class
gen class91 = 0 if partyid!=.
replace class91=socclass if year==min_year
bys pid: egen min_class = max(class91)
lab val min_class classlbl
tab min_class 

* education 
gen educ91 = 0 if partyid!=.
replace educ91 =quali if year==min_year
bys pid: egen min_educ = max(educ91)
lab val min_educ educlbl1
tab min_educ

* income
gen inc91 = 0 if partyid!=.
replace inc91 =netpay_10 if year==min_year
bys pid: egen min_inc10 = max(inc91)
bys pid: egen inc10 = max(inc91)

tab min_inc10

* sector 
gen sect91 = 0 if partyid!=.
replace sect91 =sector if year==min_year
bys pid: egen min_sect = max(sect91)
lab val min_sect educlbl1

lab def seclbl 0 "Inapp+Missing" 1 "Privat firm+comp" 2 "Public+Gov" 3  "nhs or higher educ" 5 "Other" 4 "non-profit orgs."
lab val min_sect seclbl


*** Create smaller dataset ***


tab partyid
tab year if partyid!=.

bys pid: egen validresp_pid = count(partyid)
tab validresp_pid
recode validresp_pid (0=.) 
tab validresp_pid

drop if validresp_pid<3 // The analysis only include respondents that have at least 3 valid responses


*** Time variable
tab time,m


**** Safe DATA *****
saveold "BHPS_econvote_91_96", replace  // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models


* ========================================
*** Change sample for robustness tests

use "BHPS_econvote_91_96", clear

* Region: Only England
tab region, m
tab region, nolabel
drop if region==17 //drop Wales
drop if region==18 //drop Scotland

recode partyid1 (4=5) 
tab partyid1


saveold "BHPS_econvote_91_96_ENGL", replace // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models


*** Nat Econ indicators: only selected years

keep if year==1992 | year==1994 | year==1996
tab year

saveold "BHPS_econvote_91_96_Natecon", replace version(12) // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models


*** FULL SAMPLE ONLY: no missings on DV
use "BHPS_econvote_91_96", clear

tab validresp_pid
drop if validresp_pid<6
saveold "BHPS_econvote_91_96_FULL", replace // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models



* ========================================
** Split file into two periods: LABOUR

use "BHPS_econvote", clear
drop if year==.

drop if y1997==0
tab time,m
tab year time
gen time1=time-7 
recode time1(0=.)

drop time
rename time1 time

* ========================================
** First year included in study

egen min_year = min(year) if partyid1 !=., by(pid)
tab min_year 
//52% joined the sample in 1991


* Unempl in first year
gen unemp91 = 0 if partyid!=.
replace unemp91=1 if unemp==1 & year==min_year
bys pid: egen min_unemp = max(unemp91)

sort pid year
browse pid year min_year unemp unemp91 min_unemp partyid1

* Age
bys pid: egen min_age = min(age)
recode min_age (18/25 =1 "18-25") (26/35 = 2 "26-35") (36/45=3 "36-45") (46/55=4 "46-55") (56/65=5 "56-65") (66/110=6 "66+"), gen(agecat91)
tab agecat91

* Region

gen region91 = 0 if partyid!=.
replace region91=region if year==min_year
bys pid: egen min_region = max(region91)
*browse pid year region region91 min_region

* Housing
gen house91 = 0 if partyid!=.
replace house91=housing2 if year==min_year
bys pid: egen min_housing = max(house91)
lab def houselbl 0"Missing" 1"Own" 2"Mortage" 3"Social" 4"Rented"
lab val min_housing houselbl
tab min_housing,m

* social class
gen class91 = 0 if partyid!=.
replace class91=socclass if year==min_year
bys pid: egen min_class = max(class91)
lab val min_class classlbl
tab min_class 

* education 
gen educ91 = 0 if partyid!=.
replace educ91 =quali if year==min_year
bys pid: egen min_educ = max(educ91)
lab val min_educ educlbl1
tab min_educ


* sector 
gen sect91 = 0 if partyid!=.
replace sect91 =sector if year==min_year
bys pid: egen min_sect = max(sect91)
lab val min_sect educlbl1

lab def seclbl 0 "Inapp+Missing" 1 "Privat firm+comp" 2 "Public+Gov" 3  "nhs or higher educ" 5 "Other" 4 "non-profit orgs."
lab val min_sect seclbl


* income
gen inc91 = 0 if partyid!=.
replace inc91 =netpay_10 if year==min_year
bys pid: egen min_inc10 = max(inc91)
tab min_inc10



* ========================================
* = Reduce data to only those with at least 3 valid observations =

tab partyid
tab year if partyid!=.

bys pid: egen validresp_pid = count(partyid)
tab validresp_pid
recode validresp_pid (0=.) 
tab validresp_pid

drop if validresp_pid<3


*** Time variable
tab time,m

**** Safe DATA *****
save "BHPS_econvote_97_08", replace // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models

* ========================================
*** Change sample for robustness tests


use "BHPS_econvote_97_08", clear

* Region
tab region, m
tab region, nolabel
drop if region==17 //drop Wales
drop if region==18 //drop Scotland

recode partyid1 (4=5) 
tab partyid1


saveold "BHPS_econvote_97_08_ENGL", replace // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models


*** FULL SAMPLE ONLY
use "BHPS_econvote_97_08", clear // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models

tab validresp_pid
drop if validresp_pid<12
saveold "BHPS_econvote_97_08_FULL", replace // This file needs to be transferred to SPSS format .sav to be used in LatentGOLD to estimate Markov models



* -----------------------------------------------------------------------------
* 4. Estimation of Robustness Tests: Fixed effects models

use "BHPS_econvote", clear
tsset pid year


** -----------------------------------------------------------------
* Fixed-effects models


** DV = gov versus opposition (incl. non-voting)

* Control variables
logit gov_pid age unemp i.netpay_10 i.socclass i.sect  if y1997==0
logit gov_pid age unemp i.netpay_10 i.socclass i.sect  if y1997==1

* financial situation, no controls
xtlogit gov_pid fisitc2 fisitc3  if y1997==0, fe 
xtlogit gov_pid i.fisitc if y1997==1, fe 

* Subj. change in finances + controls
xtlogit gov_pid i.fisitc age unemp i.netpay_10 i.socclass i.sect if y1997==0 , fe 
estimates store change_Tories

xtlogit gov_pid  i.fisitc  age unemp i.netpay_10 i.socclass i.sect if y1997==1, fe 
estimates store change_Labour


* Subj. reasons for change + 
xtlogit gov_pid  i.betterworseoff2 age unemp i.netpay_10 i.socclass i.sect if y1997==0 , fe 
estimates store reasons_Tories

xtlogit gov_pid  i.betterworseoff2  age unemp i.netpay_10 i.socclass i.sect if y1997==1, fe
estimates store reasons_Labour


set more off
estout * using "FE_Results.txt", transform(ln*: exp(@) exp(@)) ///
	nolz notype delimiter(" `=char(9)'") ///
    cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .1 ** .05 *** .01) ///
    stats(N ll aic, fmt(3)) replace 



