* British Journal of Political Science
* The Micro-Foundations of Party Competition and Issue Ownership: * The Reciprocal Effects of Citizens’ Issue Salience and Party Attachments* Anja Neundorf and James Adams


* BRITISH HOUSEHOLD PANEL STUDY (BHPS): Data managment 

* This file allows the following:
* 1. Data merging of raw SOEP data
* 2. Recode all variables used in the article


* -----------------------------------------------------------------------------
* DATA ACCESS: 
* To re-analyze this data set,  it is neccesary to apply for a 
* standard BHPS user contract in order to be granted access to the archived data,
* which can be requested via http://discover.ukdataservice.ac.uk/series/?sn=20000
* at the UK DATA ARCHIVE


clear allcapture log closeset more off, perm 

global inpath   "PATH TO WHERE BHPS DATA IS STORED"global temppath ".../temp/"global outpath  ".../"


*************************************************************************************************************************************************************************************************************************************************** -----------------------------------------------------------------------------
* DATA MERGING:
* The SOEP data is available in many single files. You first need to merge the variables
* from the different files into one masterfile.


* ========================================
* = extract variables from raw bhps data =
* ========================================


local waves = "a b c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "${inpath}`i'indresp", clear
	keep `i'vote1 `i'vote2 `i'vote4 `i'sex `i'qfedhi `i'isced  ///
	 `i'tenure `i'region `i'age `i'hid  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i', replace
}
* ip -- pid
use _p
ren id pid
save _p, replace

use _a
append using _b _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "${temppath}__main.dta", replace

* ========================================
* = extract variables vote3 =
* ========================================


local waves = "a c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "${inpath}`i'indresp", clear
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

save "${temppath}__main_vote3.dta", replace


* ========================================
* = extract political interest  =
* ========================================

local waves = "a b c d e f  k l m n o p q r"

foreach i of local waves {
	use "${inpath}`i'indresp", clear
	keep `i'vote6  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i'pol, replace
}
* ip -- pid
use _ppol
ren id pid
save _ppol, replace

use _apol
append using _bpol _cpol _dpol _epol _fpol _kpol _lpol _mpol _npol _opol _ppol _qpol _rpol
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "${temppath}__main_polint", replace


* ========================================
* = extract issue salience variables  =
* ========================================


local waves = "b d f "

foreach i of local waves {
	use "${inpath}`i'indresp", clear
	keep `i'opiss1 `i'opiss2 `i'opiss3 `i'opiss4 pid 
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

save "${temppath}__mainissues", replace

* ============================
* = merge in additional info =
* ============================

use "${temppath}__main", clear
sort pid wave

merge pid wave using "${temppath}__main_vote3"
sort pid wave
drop _merge

merge pid wave using "${temppath}__main_polint"
sort pid wave
drop _merge

merge pid wave using "${temppath}__mainissues"
sort pid wave
drop _merge

**** SAVE ***********save "${outpath}Masterfile_BHPS.dta", replace**---------------------------------------------------------------------------
** RECODING OF VARIABLES


** Creating time and year variables

rename waven time

gen year = time + 1990
replace year = 1991 if wave=="a"
tab year,m



* ========================================
* = Recode Party ID =
* ========================================

gen partyid =. 
replace partyid = 4 if vote2==2
replace partyid = 4 if vote2==-1
replace partyid = 4 if vote3==10
replace partyid = 4 if vote3==8
replace partyid = 4 if vote3==-1
replace partyid = 1 if vote3==1 
replace partyid = 2 if vote3==2 
replace partyid = 3 if vote3==3 
replace partyid = 4 if vote3==4
replace partyid = 4 if vote3==5
replace partyid = 4 if vote3==6
replace partyid = 4 if vote3==7


recode partyid (4=0) 
lab def pidlbl1 0"No/other PID" 1"Cons" 2"Labour" 3"Libdem"
lab val partyid pidlbl1
tab partyid


* ========================================
* = Political issues =
* ========================================


tab1 opiss1-opiss5


foreach i  of any   1 2 3 4 5 {
gen iss`i' = opiss`i'
recode iss`i' (-9/0=.) (4=0) (3=0) (2=0) (1=1)
}


foreach i  of any   1 2 3 4 5 {
gen opiss_`i'_dum = opiss`i'
recode opiss_`i'_dum (-9/0=.) (4=0) (3=0) (2=1) (1=1)
}


*** Party ID and issues

foreach i  of any   1 2 3 4 5 {
tab partyid  opiss_`i'_dum1,  row nof
}


* ========================================
** CONTROL VARIABLES

* ========================================
** First year included in study

egen min_year = min(year) if partyid!=., by(pid)
tab min_year



* ========================================
** 1) Age: Min

bysort pid: gen age1 = age if year== min_year
recode age1 (.=-2)
bysort pid: egen min_age = max(age1)
lab var min_age "Age at t=0"
recode min_age (-2=.)
drop age1


* ========================================
** 2) Gender 
recode sex (-9 -7 = .) (1=0) (2=1), gen(female)
drop sex
tab female,m

* ========================================
** 3) Region: only England

tab region,m 
drop if region == -9 |  region == 17 | region ==18 | region ==19 

bysort pid: gen reg1 = region if year== min_year 
recode reg1 (.=-2)
bysort pid: egen min_region = max(reg1)
lab var min_region "Region at t=0"
recode min_region (-2=.)
drop reg1

recode min_region (1 / 2 = 1) (13/14 = 12) (15=16) (7=8) (9/10=11)

lab def reglbl 3 "r. of south east" 4 " south west " 5 " east anglia " 6 "east midlands"  ///
8 "r. of west midlands" 11 " r. of north west" 12 "yorkshire & humber"  ///
16"r. of north east " 1 "Greater London"

lab val min_region reglbl
tab min_region


* ========================================
** 4) Housing: Min

recode tenure (-9=.) (1=1 owned) (2=2 mortgage) (3 4=3 scoial) (5/8=4 rented), gen(housing2)


bysort pid: gen tem1 = housing2  if year== min_year 
recode tem1 (.=-2)
bysort pid: egen min_housing = max(tem1)
lab var min_housing  "Housing at t=0"
recode min_housing (-2=.)
drop tem1

lab def houslbl 2"Mortgage" 3"Social" 4"Rented" 1"Own"
lab val min_housing houslbl
tab min_housing


* ========================================
** 5) Education: Min

gen educ = isced
recode educ  (7=6)  (2=1) (-7/0=.)
replace educ=1 if qfedhi==13
lab def educlbl 1 "Primary or still in school" 3 "low sec-voc" 4 "hisec-mivoc" 5"higher voc" 6 "degree"
lab val educ educlbl
tab educ

**

bysort pid: gen tem1 = educ  if year== min_year 
recode tem1 (.=-2)
bysort pid: egen min_educ = max(tem1)
lab var min_educ  "Education at t=0"
recode min_educ (-2=.)
drop tem1

lab val min_educ educlbl
tab min_educ


* ========================================
** 8) Political Interest

tab vote6,m
tab vote6, nolabel

gen polint = vote6
recode polint (-9/0=.) (1=4) (2=3) (3=2) (4=1)
lab def intlbl 1"not at all int" 2"not very int" 3"fairly int" 4"very int"
lab val polint intlbl
lab var polint "RECODE Political Interest"
tab polint


bysort pid: egen mean_int = mean(polint) if partyid!=.
lab var mean_int "Mean Interest"


* ========================================
* = Create smaller dataset =
* ========================================


bys pid: egen validresp_issues = count(iss1)
tab validresp_issues

drop if iss1 ==. | validresp_issues<2

tab time,m
recode time  (1=.) (3=1) (5=2) 


***--------------------------------****
* SAVE WORKING FILE 
***--------------------------------****

save "${outpath}Masterfile_BHPS.dta", replace










