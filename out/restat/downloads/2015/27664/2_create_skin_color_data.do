**-------------------------------------------------------------------
** NLSY97 SKIN COLOR RECODING - THROUGH 2010 (RD 14)
**-------------------------------------------------------------------

* BEGIN LOG
cap log close
log using "${directory}/2_create_skin_color", text replace

* IMPORT DATA
clear
clear mata
clear matrix
set mem 1g
set maxvar 7000
version 11
set more off
qui infile using "${extracts}/skincolor/skincolor.dct
qui do "${extracts}/skincolor/skincolor-value-labels.do"


* RACE VARIABLES 
*--------------------------------------------------------------------
*--------------------------------------------------------------------

* HISPANIC
cap drop hispanic 
recode R0538600 (-9/-1=.), gen(hispanic)

* WHITE NON-HISP
cap drop wnh
gen wnh=R0538700==1 & R1482600==4 & (hispanic==0 | hispanic==.) 
tab wnh	 

* BLACK NON-HISP
cap drop bnh
gen bnh=R0538700==2 & R1482600==1 & (hispanic==0 | hispanic==.)
tab bnh		 

* OTHER NON-HISP
cap drop onh
gen onh=R0538700>2 & R1482600!=2 & hispanic==0
replace onh= 1 if (R0538700<0 | R0538700==2) & R1482600==3 & (hispanic==0 | hispanic==.)
tab onh		 

* HISPANIC ONLY
cap drop hh
gen hh=(R0538700==5 | R0538700<0) & R1482600==2 
tab hh 		 

* WHITE-HISPANIC
cap drop hw
gen hw=R0538700==1 & hispanic==1
tab hw		 

* BLACK-HISPANIC
cap drop hb
gen hb=R0538700==2 & hispanic==1
tab hb		 

* OTHER-HISPANIC
cap drop ho
gen ho=(R0538700==3 | R0538700==4) & hispanic==1
tab ho		 

* RACE VARIABLE
cap drop racefull
gen racefull=.
replace racefull=1 if wnh==1
replace racefull=2 if bnh==1
replace racefull=3 if onh==1
replace racefull=4 if hh==1
replace racefull=5 if hw==1
replace racefull=6 if hb==1
replace racefull=7 if ho==1
tab racefull
lab def racefull 1"White non-Hisp" 2"Black non-Hisp" 3"Other non-Hisp" 4"Hispanic" 5"Hisp White" 6"Hisp Black" 7"Hisp Other", modify
lab val racefull racefull
tab racefull, m

* RACE
recode racefull (1=1) (2=2) (4/7=3) (3=4), gen(race)
label define race 1"White" 2"Black" 3"Hispanic" 4"Other", modify
label values race race
lab var race Race
tab race, gen(x)
rename x1 white
rename x2 black
rename x3 hisp
rename x4 other
lab var white White
lab var black Black 
lab var hisp Hisp 
lab var other Other

* NLSY97 RACE/ETHNICITY VARIABLE
recode R1482600 (-9/-1=.) (4=1) (1=2) (2=3) (3=4), gen(raceeth)
 lab def raceeth 1"Non Black, Hispanic" 2"Black" 3"Hispanic" 4"Mixed", modify
 lab val raceeth raceeth
 lab var raceeth "Race nlsy original"

* DROP 
foreach x in hispanic wnh bnh onh hh hw hb ho {
	cap drop `x'
}

* SKIN COLOR VARIABLES
*--------------------------------------------------------------------

*--------------------------------------------------------------------

* SKIN COLOR (2008-2010)
cap drop color*

recode T3173000 (-9/-1=.), gen(color_2008) 
recode T4584700 (-9/-1=.), gen(color_2009)     
recode T6217800 (-9/-1=.), gen(color_2010)  

gen color=(color_2008)
replace color=color_2009 if color==. & color_2009!=.  

replace color=color_2010 if color==. & color_2010!=.  
lab var color "Skincolor"
tab color race, m

* FLAG FOR WHICH YEAR COLOR MEASURED (IMPORTANT FOR INTERVIEWER DEMOGRAPHICS)
cap drop coloryear
gen coloryear=.
replace coloryear=2008 if color_2008!=.
replace coloryear=2009 if color_2009!=.
replace coloryear=2010 if color_2010!=.
cap drop color_2008
cap drop color_2009
cap drop color_2010


* INTERACTIONS (COLOR WITH BLACK)
cap drop bxcolor*
gen bxcolor=black*color
recode bxcolor (1/3=3) (9/10=10)
replace bxcolor=0 if black==0
 lab var bxcolor "Black x color"

 lab def bxcolor 3"1-3" 10"9-10", modify
 lab val bxcolor bxcolor
tab bxcolor, gen(bxcolor)
 cap drop bxcolor1
 cap drop b1t3 b4 b5 b6 b7 b8 b9t10
 rename bxcolor2 b1t3
 rename bxcolor3 b4
 rename bxcolor4 b5
 rename bxcolor5 b6
 rename bxcolor6 b7
 rename bxcolor7 b8
 rename bxcolor8 b9t10
 
* BL (BLACK, LIGHT=1/5), BM (BLACK, MEDIUM6/7), BD (BLACK, DARK=8/10)
recode color (1/5=1) (6/10=0) if black==1, gen(bl)
recode color (1/5=0) (6/7=1) (8/10=0) if black==1, gen(bm)
recode color (1/5=0) (6/7=0) (8/10=1)if black==1, gen(bd)
 replace bl=0 if black==0 
 replace bm=0 if black==0 
 replace bd=0 if black==0 
 lab var bl "Black, 1-5"
 lab var bm "Black, 6-7"
 lab var bd "Black, 8-10"


* GENDER, AGE, REGION AND MSA
*--------------------------------------------------------------------
*--------------------------------------------------------------------

* GENDER
tab R0536300
cap drop male
recode R0536300 (2=0), gen(male)  
lab var male "Male"
label def male 0"Female" 1"Male", modify
label val male male
tab male, m

* NON INTERVIEW IN 2008
gen noninterview_2008= T2019401==-5
lab var noninterview_2008 "Not interviewed in 2008"

* AGE AT INTERVIEW
local yr=1997
foreach x in R1193900 R2553400 R3876200 R5453600 R7215900 S1531300 S2000900 S3801000 S5400900 S7501100 T0008400 T2011000 T3601400 T5201300 {
 d `x'
 cap drop age_`yr'
 recode `x' (-9/-1=.), gen(age_`yr')
 replace age_`yr'=(age_`yr'/12)
 lab var age_`yr' "Age `yr'"
 qui count if age_`yr'==.
 disp "`r(N)' missing age in `yr'"
 local yr=`yr'+1
}

* REGION
local yr=1997
foreach x in R1200300 R2558800 R3880300 R5459400 R7222400 S1535500 S2005400 S3805700 S5405600 S7506100 T0009400 T2012100 T3602100 T5202300 {
 d `x'
 local name "region_"
 cap drop `name'`yr'
 recode `x' (-9/-1=.), gen(`name'`yr')
 lab var `name'`yr' "Region `yr'"
 qui count if `name'`yr'==.
 disp "`r(N)' missing in `yr'"
 local yr=`yr'+1
}


* MSA / RURAL
local yr=1997
foreach x in R1210400 R2569500 R3891500 R5473500 R7237200 S1552500 S2022300 S3823200 S5423200 S7525300 T0025600 T2020500 T3611200 T5211600 {
 d `x'
 local name "msa_"
 cap drop `name'`yr'
 recode `x' (-9/-1=.) (4/5=1), gen(`name'`yr')
 lab var `name'`yr' "MSA `yr'"
 qui count if `name'`yr'==.
 disp "`r(N)' missing in `yr'"
 local yr=`yr'+1
}

* IF ENROLLED
*--------------------------------------------------------------------
global ifenr_edt "R1201400 R2560001	R3881501 R5460601 R7224201 S1538001 S2007701 S3808501 S5408900 S7509700 T0013000 T2015900 T3606200 T5206600" 
d $ifenr_edt
lab def ifenr 0"Not enrolled" 1"Enrolled", modify
local yr = 1997
foreach var in $ifenr_edt {
 cap drop ifenr_`yr'
 recode `var' (-9/-1=.) (1/7=0) (8/11=1), gen(ifenr_`yr')
  lab val ifenr_`yr' ifenr
  lab var ifenr_`yr' "Enrollment status `yr'"
 recode `var' (-9/-1=.) (1/7=0) (8=1) (9/11=0), gen(ifenrhs_`yr')
  lab var ifenrhs_`yr' "Enrolled HS"
  lab val ifenrhs_`yr' ifenr
 recode `var' (-9/-1=.) (1/8=0) (9/11=1), gen(ifenrco_`yr')
  lab var ifenrco_`yr' "Enrolled college"
  lab val ifenrco_`yr' ifenr
local yr = `yr'+1
}


* FAMILY BACKGROUND CHARACTERISTICS
*--------------------------------------------------------------------
*--------------------------------------------------------------------


* REGION, AGE 12
cap drop region12
recode R1200400 (-5/-1 = .), gen(region12)
lab def region 1"N East" 2"N Central" 3"South" 4"West", modify
lab val region12 region 
lab var region12 "Region age 12"
cap drop south12
gen south12=region12==3
lab var south12 "South age 12"

* Replace region12 if missing because age <=12 at interview 1997
replace region12=region_1997 if region12==. & region_1997!=. & age_1997<156

* RURAL AGE 12
cap drop rural12
recode R1210500 (-4 -3 4 5=.) (2/3=0) (1=1), gen(rural12)
	tab rural12, m
 
* MOM HGC
cap drop tmp_mom1
recode R0554500 (-9/-1=.) (0/2=1) (3=2) (4/7=3), gen(tmp_mom1)
cap drop tmp_mom2
recode R0564800 (-9/-1=.) (0/2=1) (3=2) (4/7=3), gen(tmp_mom2)
tab tmp_mom1 tmp_mom2, m
cap drop hgcmom
gen hgcmom=tmp_mom1
replace hgcmom=tmp_mom2 if hgcmom==. & tmp_mom2!=.
lab def hgcp 1"Less than HS" 2"HS" 3"More than HS", modify
lab val hgcmom hgcp
lab var hgcmom "HGC mom"
tab hgcmom, m

* POVERTY RATIO - 1997
cap drop povratio
recode R1204900 (-9/-1=.), gen(povratio)
 lab var povratio "Poverty ratio, 1997"

* EVER GOV'T AID - 1997
cap drop aid
recode R0606900 (-9/-1=.), gen(aid)
 lab var aid "Parent ever gov't aid"

* LIVE WITH PARENTS - 1997
cap drop parents6
recode R1205200 (-9/-1=.) (1=1) (2/10=0), gen(parents6)
 lab var parents6 "Both bio parents, age6"


* DEFINE PARENT RACE (AS ANY NON-WHITE OR ANY NON-BLACK PARENT)
*--------------------------------------------------------------------
*--------------------------------------------------------------------
* HOUSEHOLD ID
rename R1193000 hhid

* HOUSEHOLD ROSTER ITEMS (1997)
*--------------------------------------------------------------------

* RELATIONSHIP OF EACH HH ROSTER MEMBER PERSON TO Y
local i=0
foreach x of varlist R1315800-R1317400 {
	local ++i
	rename `x' hhi2_rely_`i'
	tab hhi2_rely_`i', m
}	


* BIO MOM AND DAD ID'S (CORRECTED VERSION)
cap drop *id_match
gen momid_match=.
gen dadid_match=.
forvalues i=1(1)16 { 
	replace momid_match=`i' if hhi2_rely_`i'==3
	replace dadid_match=`i' if hhi2_rely_`i'==4
}

* RACE OF EACH HH PERSON
local i=0
foreach x of varlist R1115400 R1115500 R1115600 R1115700 R1115800 R1115900 R1116000 R1116100 R1116200 R1116300 R1116400 R1116500 R1116600 R1116700 R1116800 R1116900 {
	local ++i
	rename `x' hhi2_race_`i'
	replace hhi2_race_`i'=. if hhi2_race_`i'<=0
	lab val hhi2_race_`i' vlR1115400
}

* ETHNICITY OF EACH HH PERSON
local i=0
foreach x of varlist R1094600 R1094700 R1094800 R1094900 R1095000 R1095100 R1095200 R1095300 R1095400 R1095500 R1095600 R1095700 R1095800 R1095900 R1096000 R1096100 {
	local ++i
	rename `x' hhi2_eth_`i'
	replace hhi2_eth_`i'=. if hhi2_eth_`i'<0
}

* NON-RES MOM AND DAD RACE AND ETHNICITY
cap drop biorace_mom
cap drop bioeth_mom
cap drop biorace_dad
cap drop bioeth_dad
gen biorace_mom=.
gen bioeth_mom =.
gen biorace_dad =.
gen bioeth_dad =.
forvalues i=1(1)16 {
	replace biorace_mom=	hhi2_race_`i' 	if momid_match==`i' & hhi2_race_`i'!=.
	replace biorace_dad=	hhi2_race_`i' 	if dadid_match==`i' & hhi2_race_`i'!=.
	replace bioeth_mom=		hhi2_eth_`i' 	if momid_match==`i' & hhi2_eth_`i'!=.
	replace bioeth_dad=		hhi2_eth_`i' 	if dadid_match==`i' & hhi2_eth_`i'!=.
	lab val biorace_mom vlR1115400
	lab val biorace_dad vlR1115400
}
* RECODE
recode biorace_mom biorace_dad (3/7=3) 
lab def biorace 1"White" 2"Black" 3"Other", modify
lab val biorace_mom biorace
lab val biorace_dad biorace

* NON-HOUSEHOLD ROSTER ITEMS
*--------------------------------------------------------------------

* NR ROSTER RELATIONSHIP TO RESPONDENT
local i=0
foreach x in R1186600 R1186700 R1186800 R1186900 R1187000 R1187100 R1187200 R1187300 R1187400 R1187500 R1187600 R1187700 R1187800 R1187900 R1188000 R1188100 {
	local ++i
	rename `x' nr_rel_`i'
}

* NON-RES MOM AND DAD ID's
cap drop nrdad_match
cap drop nrmom_match
gen nrdad_match=.
gen nrmom_match=.
forvalues i=1(1)16 {
	replace nrmom_match=`i' if nr_rel_`i'==3
	replace nrdad_match=`i' if nr_rel_`i'==4
}

* NON-RES RACE
local i=0
foreach x in R1184500 R1184600 R1184700 R1184800 R1184900 R1185000 R1185100 R1185200 R1185300 R1185400 R1185500 R1185600 R1185700 R1185800 R1185900 R1186000 R1186100 R1186200 R1186300 R1186400 R1186500 {
	local ++i
	rename `x' nr_race_`i'
	replace nr_race_`i'=. if nr_race_`i'<=0
	lab val nr_race_`i' vlR1184500
}

* NON-RES ETHNICITY
local i=0
foreach x in R1172500 R1172600 R1172700 R1172800 R1172900 R1173000 R1173100 R1173200 R1173300 R1173400 R1173500 R1173600 R1173700 R1173800 R1173900 R1174000 R1174100 R1174200 R1174300 R1174400 R1174500 {
	local ++i
	rename `x' nr_eth_`i'
	replace nr_eth_`i'=. if nr_eth_`i'<0
}

* NON-RES MOM AND DAD RACE AND ETHNICITY
cap drop nrrace_mom
cap drop nreth_mom
gen nrrace_mom =.
gen nreth_mom =.
cap drop nrrace_dad
cap drop nreth_dad
gen nrrace_dad =.
gen nreth_dad =.
forvalues i=1(1)16 {
	replace nrrace_mom=nr_race_`i' if nrmom_match==`i' & nr_race_`i'!=.
	replace nrrace_dad=nr_race_`i' if nrdad_match==`i' & nr_race_`i'!=.
	replace nreth_mom=nr_eth_`i'   if nrmom_match==`i' & nr_eth_`i'!=.
	replace nreth_dad=nr_eth_`i'   if nrdad_match==`i' & nr_eth_`i'!=.
	lab val nrrace_mom vlR1184500
	lab val nrrace_dad vlR1184500
}
* RECODE
recode nrrace_mom nrrace_dad (3/7=3)
lab def nrrace 1"White" 2"Black" 3"Other", modify
lab val nrrace_mom nrrace
lab val nrrace_dad nrrace


* DETERMINE IF ANY NON-WHITE OR ANY NON-BLACK PARENTS
*--------------------------------------------------------------------
cap drop tmp
egen tmp=rowmiss(biorace_mom biorace_dad bioeth_mom bioeth_dad nrrace_mom nrrace_dad nreth_mom nreth_dad)
tab tmp, m

* NONBLACK PARENT
cap drop nonblack_parent
gen nonblack_parent=. 
replace nonblack_parent=0 if tmp<8
replace nonblack_parent=1 if ///
	biorace_mom==1 | biorace_mom==3 | biorace_dad==1 | biorace_dad==3 | ///
	nrrace_mom==1 | nrrace_mom==3 | nrrace_dad==1 | nrrace_dad==3 | ///
	nreth_mom==1 | nreth_dad==1 | bioeth_mom==1 | bioeth_dad==1


* NONWHITE PARENT
cap drop nonwhite_parent
gen nonwhite_parent=. 
replace nonwhite_parent=0 if tmp<8
replace nonwhite_parent=1 if ///
	biorace_mom==2 | biorace_mom==3 | biorace_dad==2 | biorace_dad==3 | ///
	nrrace_mom==2 | nrrace_mom==3 | nrrace_dad==2 | nrrace_dad==3 | ///
	nreth_mom==1 | nreth_dad==1 | bioeth_mom==1 | bioeth_dad==1

* WHITE MOTHERS
cap drop white_mom
tab biorace_mom nrrace_mom, m
gen white_mom=.
replace white_mom=1 if biorace_mom==1
replace white_mom=0 if (biorace_mom==2 | biorace_mom==3)
replace white_mom=1 if nrrace_mom==1
replace white_mom=0 if (nrrace_mom==2 | nrrace_mom==3)
replace white_mom=0 if bioeth_mom==1
replace white_mom=0 if nreth_mom==1
lab var white_mom "White mother"

* MIXED RACE CHILD, DEPENDING ON PARENTS' RACE
cap drop mixed
gen mixed=.
replace mixed=0 if race<3 & (nonblack_parent!=. | nonwhite_parent!=.)
replace mixed=1 if (black==1 & nonblack_parent==1) 
replace mixed=1 if (white==1 & nonwhite_parent==1)



* BEHAVIORIAL PROXIES
*--------------------------------------------------------------------
*--------------------------------------------------------------------
cap drop evr_*
recode R0034900 (-9/-1=.), gen(evr_suspended97)
recode R0357900 (-9/-1=.), gen(evr_smoke97) 
recode R0358300 (-9/-1=.), gen(evr_drink97) 
recode R0358900 (-9/-1=.), gen(evr_marijuana97) 
recode R0359800 (-9/-1=.), gen(evr_handgun97) 
recode R0360900 (-9/-1=.), gen(evr_destroy97) 
recode R0361100 (-9/-1=.), gen(evr_steal97) 
recode R0361400 (-9/-1=.), gen(evr_selldrugs97) 

* THESE ARE MADE BINARY WHERE 1=GREATER THAN HALF
* PEERS_CHURCH IS REVERSED TO KEEP DIRECTIONALITY
cap drop peers_*
recode R0070300(-9/-1=.) (1/2=1) (3/5=0), gen(peers_church97)
recode R0070400(-9/-1=.) (1/2=0) (3/5=1), gen(peers_smoke97)
recode R0071000(-9/-1=.) (1/2=0) (3/5=1), gen(peers_drugs97)

* PRINCIPAL COMPONENT ANALYSIS
*--------------------------------------------------------------------
pca evr_smoke97 evr_drink97 evr_marijuana97 evr_handgun97 evr_destroy97 evr_steal97 evr_selldrugs97 peers_smoke97 peers_drugs97 peers_church97
predict pca1 pca2


* HEIGHT AND WEIGHT
*--------------------------------------------------------------------
*--------------------------------------------------------------------

* HEIGHT
cap drop tmp*
cap drop height97
recode R0322500 (-9/-1=.) (1/3=.) (8=.), gen(tmpft)
replace tmpft=tmpft*12
recode R0322600 (-9/-1=.), gen(tmpin)
gen height97=(tmpft+tmpin)

* WEIGHT
cap drop weight97
recode R0322700 (-9/-1=.) (1/69=.), gen(weight97)


* AFQT
*--------------------------------------------------------------------
*--------------------------------------------------------------------
* AFQT   
sum R9829600
cap drop afqt
recode R9829600 (-9/-1=.), gen(afqt)
lab var afqt "AFQT"
sum afqt

* NORMALIZE TO BLACK AND WHITE MALES
* ---------------------------------------------------------------------- *
cap drop afqtz
cap drop tmp*
egen afqtz=std(afqt) if (male==1 & race<3)  
lab var afqtz "AFQT"
note afqtz: For Black and White Males

 
* EMPLOYMENT VARIABLES FOR JOBS 1 AND 2
*--------------------------------------------------------------------
*--------------------------------------------------------------------
 
* EMPLOYER UNIQUE ID = ROSTER ID
*--------------------------------------------------------------------

* HOURS WORKED PER WEEK
local hrs "R1209101 R2568001 R3889701 R5471801 R7235601 S1550401 S2020301 S3821501 S5421801 S7523100 T0023600 T2018500 T3609000 T5209400"local yr=1996
foreach x in `hrs' {
	local ++yr
	cap drop hrs_`yr'
	recode `x' (-9/-1=.) (81/99999=.), gen(hrs_`yr')
	sum `x' hrs_`yr' if hrs_`yr'!=.
}


* HOURLY WAGES (< 2$ per hr & >100 =.)
local hrly "R1207800 R2566300 R3888000 R5470100 R7234100 S1548300 S2018400 S3820200 S5420100 S7521300 T0022000 T2016900 T3607200 T5207600"
local yr=1996
foreach x in `hrly' {
	local ++yr
	cap drop hrly_`yr'
 	recode `x' (-9/-1=.) (0/200=.) (10100/99999999=.), gen(hrly_`yr')
	sum `x' hrly_`yr' if hrly_`yr'!=.
	replace hrly_`yr'=(hrly_`yr'/100)
}
 

* SELF-EMPLOYMENT. MAKE SELFEMP=0 PRE-2000 - NOT ASKED THEN
local selfemp 	"R5309200 R7050300 S1519900 S3585900 S5239600 S7029800 S9000900 T1410600 T3507200 T4937100 T6590200"
local yr=1999
foreach x in `selfemp' {
	local ++yr
	cap drop selfemp_`yr'
	recode `x' (-9/-1=.), gen(selfemp_`yr')
	sum `x' selfemp_`yr' if selfemp_`yr'!=.
}
forvalues yr=1997(1)1999 {
	cap drop selfemp_`yr'
	gen selfemp_`yr'=0
}	
 
* TENURE (REPLACE WITH TENURE/50 = 1 YEAR OF WORK; 50 WEEKS)
local tenure "R1219900 R2579200 R3901600 R5484800 R7249100 S1565000 S2035100 S3836500 S5437000 S7537800 T0034400 T2021700 T3612400 T5212300"
local yr=1996
foreach x in `tenure' {
	local ++yr
	cap drop tenure_`yr'
	recode `x' (-9/-1=.), gen(tenure_`yr')
	sum `x' tenure_`yr' if tenure_`yr'!=.
	replace tenure_`yr'=(tenure_`yr'/50)
}

* MILITARY & ACS SPECIAL CODES JOBS (9800 TO 9840) (9950-9990)
local occ "S3659000 S3681000 S3697000 S3713000 S3729000 S1603000 S3757000 S5041700 S6783100 S8689700 T1109400 T3186900 T4597800 T6231000"
local yr=1996
foreach x in `occ' {
	local ++yr
 	cap drop military_`yr'
	recode `x' (10/9790=0) (9800/9830=1) (9840=1) (9970/9990=1) (9950/9990=1) (-9/-1=.), gen(military_`yr')	
	tab `x' if military_`yr'==1
}


* REPLACE WAGES=. IF MILITARY OR SELF
forvalues yr=1997(1)2010 {
	replace hrly_`yr'=. if (military_`yr'==1 | selfemp_`yr'==1)
}
	

* EDUCATION / HGC / DEGREES
*--------------------------------------------------------------------
*--------------------------------------------------------------------


* HIGHEST DEGREE  (ANNUAL, BEGINS IN 1998) 
*--------------------------------------------------------------------
local yr=1998
foreach x in R2564001 R3885601 R5464801 R7228501 S1542401 S2012201 S3813701 S5413300 S7514200 T0014600 T2016700 T3607000 T5207400 {
 d `x' 
 local name "degree_"
 cap drop `name'`yr'
 recode `x' (-9/-1=.) (5/7=5), gen(`name'`yr')
 lab var `name'`yr' "Highest degree `yr'"
 lab def degree 0"None" 1"GED" 2"HS" 3"2 yr" 4"4 yr" 5"Grad", modify
 lab val `name'`yr' degree
 qui count if `name'`yr'==.
 disp "`r(N)' missing in `yr'"
 local yr=`yr'+1
}

* HIGHEST DEGREE EVER
cap drop hdcever
recode Z9083900 (-9/-1=.) (5/7=5), gen(hdcever)
 lab var hdcever "Highest degree ever 2010"
 lab val hdcever degree 
 
 
* HIGHEST GRADE COMPLETED - EVER (CVC VERSION)
* REPLACE (UNGRADED IF POSSIBLE)
*--------------------------------------------------------------------
cap drop hgcever
recode Z9083800 (-9/-1=.), gen(hgcever)
lab var hgcever "HGC EVER (2010)"
tab hdcever if hgcever==95
replace hgcever=12 if (hdcever==1 | hdcever==2)  & hgcever==95
replace hgcever=14 if (hdcever==3) & hgcever==95
replace hgcever=16 if (hdcever==4) & hgcever==95
replace hgcever=18 if (hdcever==5) & hgcever==95
recode hgcever (95=.)

* HIGHEST GRADE COMPLETED - ANNUAL
local yr=1997
foreach x in R1204400 R2563101 R3884701 R5463901 R7227601 S1541501 S2011301 S3812201 S5412600 S7513500 T0013900 T2016000 T3606300 T5206700 {
 d `x'
 local name "hgc_"
 cap drop `name'`yr'
 recode `x' (-9/-1 95 =.), gen(`name'`yr')
 lab var `name'`yr' "HGC `yr'"
 qui count if `name'`yr'==.
 disp "`r(N)' missing in `yr'"
 local yr=`yr'+1
}
cap drop _hgc
egen _hgc=rowmiss(hgc_*)
tab _hgc

* REPLACE MISSING HGC ANNUAL VARIABLES
*--------------------------------------------------------------------
* (1) Using temp variable rhgc_yyyy, replace rhgc_yyyy if the year(s) before == year(s) after
* (2) Then replace missing rhgc_yyyy if year before = year after-2
* (3) Replace hgc with rhgc values

* Temp vars
forvalues yr=1997(1)2010 {
	cap drop rhgc_`yr' 
	gen rhgc_`yr'=hgc_`yr'
}

*(1)
forvalues yr=1998(1)2009 {
 	local A=`yr'-1 
 	local B=`yr'+1
	forvalues a=1997(1)`A' {
 		forvalues b=`B'(1)2010 {
 			replace rhgc_`yr'=rhgc_`a' if (rhgc_`a'==rhgc_`b' & rhgc_`a'!=. & rhgc_`yr'==.)
 		}
	}
}
cap drop _rhgc
egen _rhgc=rowmiss(rhgc_*)
tab _hgc
tab _rhgc

*(2)
forvalues yr=1998(1)2009 {
 	local A=`yr'-1 
 	local B=`yr'+1

	cap drop diff_`yr'
	gen diff_`yr'=(rhgc_`B'-rhgc_`A') 
	cap drop x_`yr'

	gen x_`yr'=rhgc_`B'-1 if  diff_`yr'==2 & rhgc_`yr'==.
	replace rhgc_`yr'=x_`yr' if rhgc_`yr'==. & x_`yr'!=.
	
	cap drop diff_`yr'
	cap drop x_`yr'
}
cap drop _rhgc
egen _rhgc=rowmiss(rhgc_*)
tab _hgc
tab _rhgc
cap drop _rhgc

*(3)
forvalues yr=1997(1)2010 {
 replace hgc_`yr'=rhgc_`yr' if hgc_`yr'==. & rhgc_`yr'!=.
 cap drop rhgc_`yr'
}
cap drop _hgc
egen _hgc=rowmiss(hgc_*)
tab _hgc
cap drop _hgc


* INTERVIEWER DEMOGRAPHICS
* CREATED IN 1.2_CREATE_INTERVIEWER
*----------------------------------------------------------------------
* FIND INTERVIEWER ID FOR YEAR IN WHICH COLOR IS TAKEN
cap drop intvid*
recode T2022700 (-9/-1=.), gen(intvid_2008)
recode T3613500 (-9/-1=.), gen(intvid_2009) 
recode T5213400 (-9/-1=.), gen(intvid_2010)
gen intvid=.
replace intvid=intvid_2008 if coloryear==2008
replace intvid=intvid_2009 if coloryear==2009
replace intvid=intvid_2010 if coloryear==2010
cap drop intvid_*


* MERGE ON INTERVIEWER DEMOGRAPHICS 
*----------------------------------------------------------------------
preserve
clear
do "${do}/create/1.2_create_interviewer.do"
restore

merge m:1 intvid using "${data}/1.2_interviewer.dta" 
tab color _merge, m
drop if _merge==2
cap drop _merge
count

* KEEP ONLY VARIABLES CREATED 
*-------------------------------------------------------------------
rename R0000100 id
foreach x in E R S T Z hhi* nr* {
	cap drop `x'*
}
rename id R0000100


* SAVE AS WIDE
*-------------------------------------------------------------------
*-------------------------------------------------------------------
save "${data}/skin_color_wide.dta", replace 


* RESHAPE TO LONG
*-------------------------------------------------------------------
reshape long ///
	age_ south_ rural_ msa_ region_ hrs_ hrly_ tenure_ military_ selfemp_ ///
	degree_ hgc_ ifenr_ ifenrhs_ ifenrco_, i(R0000100) j(year)  
rensfix _

 

* DATA NOW LONG
*-------------------------------------------------------------------
*-------------------------------------------------------------------


* MERGE IN LABOR MARKET ENTRY DATA
* CREATED IN  1.3_CREATE_NEWENTRY.DO
*-------------------------------------------------------------------
* RUN DOFILE
preserve
clear
do "${do}/create/1.3_create_newentry.do"
restore

* MERGE ON
cap drop _merge
sort R0000100 year
merge 1:1 R0000100 year using "${data}/1.3_newentry.dta"
cap drop _merge
sort R0000100 year

* FIX AGE IN NON-INTERVIEW YEARS
cap drop temp
gen temp=age
bys R0000100: replace temp=(temp[_n-1]+1) if temp==. & year>1997
replace age=temp if age==.
cap drop temp

* Age at entry
cap drop entryage
cap drop temp
gen temp=age if year==new_entry
bys R0000100: egen entryage=max(temp)
cap drop temp
lab var entryage "Entry age"
sum entryage 

* AGE squared 
cap drop age2
gen age2=age^2
lab var age2 "Age sq"

* HGC at Entry 
cap drop temp
gen temp=hgc if year==new_entry
cap drop entryhgc
bys R0000100: egen entryhgc=max(temp)
cap drop temp
lab var entryhgc "HGC 1st FTjob"
sum entryhgc 
 

* MAKE WAGES INTO LN REAL (2010) WAGES (REQUIRES STATA COMMAND CPIGEN)
*-------------------------------------------------------------------
cap cpigen
cap drop wage*
cap drop lnwage*
cap drop cpi2010
sum cpi if year==2010
gen cpi2010=r(mean)

replace hrly =(hrly*cpi2010)/cpi
gen wage=ln(hrly)
 
* IFENR (ENROLLMENT)  
* - IF SAME HGC 2 YEARS IN A ROW & LAST YEAR IFENR==0 & THIS YEAR==.
sort R0000100 year
gen tmp=ifenr
bys R0000100: replace ifenr=ifenr[_n-1] if hgc==hgc[_n-1] & hgc==hgc[_n+1] & ifenr[_n-1]==0 & ifenr==. & ifenr[_n-1]!=.

* POTENTIAL EXPERIENCE = AGE-AGE ENTERED LABOR MARKET
cap drop potexp
gen potexp=(age-entryage)
  
  
* DEFINE ENTRY WAGE
cap drop tmp
cap drop entry_wage
gen tmp=wage if year==new_entry 
bys R0000100: egen entry_wage=max(tmp)
cap drop tmp
  

* MERGE ON WEEKLY EMPLOYMENT VARIABLES
* CREATED IN 1.4_CREATE_WEEKLY_LFS.DO
*-------------------------------------------------------------------

* RUN DOFILE (COMPUTATIONALLY INTENSIVE, SHOULD RUN ON AN MP SERVER)
preserve
clear
do "${do}/create/1.4_create_weekly_lfs.do"
restore

* MERGE ON
merge R0000100 year using "${data}/1.4_weekly_lfs.dta", sort
tab _merge
cap drop _merge


* CREATE AND DUMMY OUT REGRESSION VARIABLES
*-------------------------------------------------------------------

* REGION 
gen region_m=region==.
forvalues i=1(1)4 {
	cap drop region`i'
	gen region`i'_=region==`i'
}

* MSA
gen msa_m=msa==.
forvalues i=1(1)3 {
	cap drop msa`i'
	gen msa`i'_=msa==`i'
}

* INTERVIEWER CHARACTERISTICS 
foreach x in intvwhite intvblack intvother intv50 intvmale {
	cap drop `x'_
	recode `x' (.=0), gen(`x'_)
	cap drop `x'
}
cap drop intv_m
gen intv_m=(intvrace==. | intv50==. | intvmale==.)

* DEGREES
gen degreenone=(degree==0)
gen degree2yr=degree==3
gen degree4yr=(degree==4 | degree==5)

* PARENT CONTROLS
cap drop hgcmom_*
tab hgcmom, gen(hgcmom)
foreach x in povratio aid parents6 hgcmom1 hgcmom3 rural12 south12 {
	cap drop `x'_*
	gen `x'_m=`x'==.
	recode `x' (.=0), gen(`x'_)
}
drop hgcmom1_m
drop hgcmom3_m
gen hgcmom_m=(hgcmom==.)

* BEHAVIORIAL CONTROLS
foreach x in pca1 pca2 height97 weight97 evr_smoke97 evr_drink97 evr_marijuana97 evr_handgun97 evr_destroy97 evr_steal97 evr_selldrugs97 peers_church97 peers_smoke97 peers_drugs97 {
	cap drop `x'_*
	recode `x' 	(.=0), gen(`x'_)
	gen `x'_m=`x'==.
}
drop pca1_m pca2_m
gen pca_m=pca1==.

* YEAR DUMMIES
forvalues yr=1999(1)2009 {
	cap drop yr`yr'
	gen yr`yr'=year==`yr'
}	



* KEEP ANALYSIS VARS
*-------------------------------------------------------------------

* KEEP & ORDER VARS
#delimit ;
local vars   
	"R0000100 year 
	race white black hisp other racefull raceeth  
	color b1t3 b4 b5 b6 b7 b8 b9t10 bl bm bd bxcolor coloryear  
	male age age2 msa1_ msa2_ msa3_ msa_m region1_ region2_ region3_ region4_ region_m  
	afqt afqtz hgc degreenone degree2yr degree4yr degree hgcever hdcever  
	povratio_ povratio_m aid_ aid_m parents6_ parents6_m hgcmom1_ hgcmom3_ hgcmom_m hgcmom rural12_ rural12_m south12_ south12_m parents6  	
	intvwhite_ intvblack_ intvother_ intv50_ intvmale_ intv_m intvid 
	wage hrly potexp entry_wage
	shremp_v1 shrwks30_v1 
	ifenr new_entry entryage entryhgc  
	pca1_ pca2_ pca_m height97_ height97_m weight97_ weight97_m   
	hrs tenure    
	mixed nonblack_parent nonwhite_parent white_mom noninterview_2008  
	yr*";

order `vars';
keep `vars';
#delimit cr
 

* APPLY VARIABLE LABELS
*-------------------------------------------------------------------
do "${do}/create/1.5_create_labels.do"


* SAVE DATA
*-------------------------------------------------------------------
save "${data}/skin_color.dta", replace



* CLOSE LOG
cap log close



*-------------------------------------------------------------------
*-------------------------------------------------------------------
*-------------------------------------------------------------------

* END





