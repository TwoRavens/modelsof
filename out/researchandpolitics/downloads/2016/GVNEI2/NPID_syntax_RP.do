*merge with country info
**download cses modul3 from webpage
** http://www.cses.org/datacenter/module3/data/cses3_stata.zip
use "[path]/cses3.dta",replace

**include your path
merge m:1 C1003 using "[path]/cses_country_codings_all.dta"

*delete all country data not needed (== not matched with country info)

drop if _merge !=3

drop if C1003==25002007

gen long laender=C1003
la def laend 72402008 "SPAIN (2008)" 75602007 "SWITZERLAND (2007)" 4002008"AUSTRIA (2008)" 19102007"CROATIA (2007)" 20302010"CZECH REPUBLIC (2010)" 20802007"DENMARK (2007)" 23302011"ESTONIA (2011)" 24602011"FINLAND (2011)" 25002007"FRANCE (2007)" 27602009"GERMANY (2009)" 30002009"GREECE (2009)"  42802010"LATVIA (2010)" 52802010"NETHERLANDS (2010)" 57802009"NORWAY (2009)" 61602005"POLAND (2005)"  70302010"SLOVAKIA (2010)" 70502008"SLOVENIA (2008)" 75202006"SWEDEN (2006)" , replace
la val laender laend
tab laender




*dummy for central and eastern european countries
gen cee= inlist(C1003,42802010,19102007,61602005,23302011,70302010,70502008,20302010)

*dummy for countries with liberal right party, DENMARK, ESTONIA and the NETHERLANDS
gen lib=inlist(C1003, 20802007, 23302011, 52802010)

*dummy for countries where cons and soz are not the biggest party, ESTONIA and POLAND
gen not_biggest=inlist(C1003, 23302011, 61602005)

foreach var of varlist consnr1 consnr2 rlibnr libnr1 libnr2 llibnr soznr1 soznr2 econr comnr{
destring `var', replace
}

** drop switzerland - like-question only asked to a sub sample
*drop if laender==75602007

** drop if quebecois
drop if C2027== 24 & laender==12402008

*drop if pais vasco
drop if C2027==16&laender==72402008
*********************
**  Code variables **
*********************

** party identification

* party identification strength

recode C3020_4(7/9=.)

gen ppid_cons=0
replace ppid_cons=1 if C3020_3==consnr1
replace ppid_cons=1 if C3020_3==consnr2
tab ppid_cons
gen ppid_cons_s=C3020_4 if ppid_cons==1
recode ppid_cons_s(1=3)(2=2)(3=1)(.=0)

gen ppid_cd=0
replace ppid_cd=1 if C3020_3==cdnr1
replace ppid_cd=1 if C3020_3==cdnr2
tab ppid_cd
gen ppid_cd_s=C3020_4 if ppid_cd==1
recode ppid_cd_s(1=3)(2=2)(3=1)(.=0)

gen ppid_sd=0
replace ppid_sd=1 if C3020_3==sdnr1
replace ppid_sd=1 if C3020_3==sdnr2
tab ppid_sd
gen ppid_sd_s=C3020_4 if ppid_sd==1
recode ppid_sd_s(1=3)(2=2)(3=1)(.=0)

gen ppid_soz=0
replace ppid_soz=1 if C3020_3==soznr1
replace ppid_soz=1 if C3020_3==soznr2
tab ppid_soz
gen ppid_soz_s=C3020_4 if ppid_soz==1
recode ppid_soz_s(1=3)(2=2)(3=1)(.=0)

gen ppid_lib=0
replace ppid_lib=1 if C3020_3==libnr1
replace ppid_lib=1 if C3020_3==libnr2
tab ppid_lib
gen ppid_lib_s=C3020_4 if ppid_lib==1
recode ppid_lib_s(1=3)(2=2)(3=1)(.=0)

gen ppid_rlib=0
replace ppid_rlib=1 if C3020_3==rlibnr
tab ppid_rlib
gen ppid_rlib_s=C3020_4 if ppid_rlib==1
recode ppid_rlib_s(1=3)(2=2)(3=1)(.=0)

gen ppid_llib=0
replace ppid_llib=1 if C3020_3==llibnr
tab ppid_llib
gen ppid_llib_s=C3020_4 if ppid_llib==1
recode ppid_llib_s(1=3)(2=2)(3=1)(.=0)

gen ppid_eco=0
replace ppid_eco=1 if C3020_3==econr
tab ppid_eco
gen ppid_eco_s=C3020_4 if ppid_eco==1
recode ppid_eco_s(1=3)(2=2)(3=1)(.=0)

gen ppid_com=0
replace ppid_com=1 if C3020_3==comnr
tab ppid_com
gen ppid_com_s=C3020_4 if ppid_com==1
recode ppid_com_s(1=3)(2=2)(3=1)(.=0)

gen ppid_nat=0
replace ppid_nat=1 if C3020_3==natnr
tab ppid_nat
gen ppid_nat_s=C3020_4 if ppid_nat==1
recode ppid_nat_s(1=3)(2=2)(3=1)(.=0)

mvdecode ppid_cons ppid_lib ppid_rlib ppid_llib ppid_soz ppid_nat ppid_eco ppid_com, mv(96/99)
mvdecode ppid_lib_s ppid_cons_s ppid_rlib_s ppid_llib_s ppid_nat_s ppid_eco_s ppid_com_s ppid_soz_s, mv(7/9)


* party identification yes or no
gen ppid_yes=C3020_2==1|C3020_1==1
replace ppid_yes=. if C3020_1==9


*party identification yes with strength

gen ppid_y3=C3020_4 if ppid_yes==1
recode ppid_y3(1=3)(2=2)(3=1)(.=0)

replace ppid_y3=. if ppid_yes==.|(C3020_4==.&ppid_yes==1)

*many missing values in denmark, only asked for C3020_1, and in the netherlands
tab  laender ppid_y3, mis

** issueorientation - Competency for most and 2nd most important sociotropic problem

gen issue_cons=0
replace issue_cons=1 if C3003_1==consnr1
replace issue_cons=1 if C3003_1==consnr2
replace issue_cons=issue_cons+1 if C3003_2==consnr1
replace issue_cons=issue_cons+1 if C3003_2==consnr2
replace issue_cons=. if C3003_1==99
tab issue_cons


gen issue_sd=0
replace issue_sd=1 if C3003_1==sdnr1
replace issue_sd=1 if C3003_1==sdnr2
replace issue_sd=issue_sd+1 if C3003_2==sdnr1
replace issue_sd=issue_sd+1 if C3003_2==sdnr2
replace issue_sd=. if C3003_1==99
tab issue_sd


gen issue_cd=0
replace issue_cd=1 if C3003_1==cdnr1
replace issue_cd=1 if C3003_1==cdnr2
replace issue_cd=issue_cd+1 if C3003_2==cdnr1
replace issue_cd=issue_cd+1 if C3003_2==cdnr2
replace issue_cd=. if C3003_1==99
tab issue_cd


gen issue_soz=0
replace issue_soz=1 if C3003_1==soznr1
replace issue_soz=1 if C3003_1==soznr2
replace issue_soz=issue_soz+1 if C3003_2==soznr1
replace issue_soz=issue_soz+1 if C3003_2==soznr2
replace issue_soz=. if C3003_1==99
tab issue_soz


gen issue_lib=0
replace issue_lib=1 if C3003_1==libnr1
replace issue_lib=1 if C3003_1==libnr2
replace issue_lib=issue_lib+1 if C3003_2==libnr1
replace issue_lib=issue_lib+1 if C3003_2==libnr2
replace issue_lib=. if C3003_1==99
tab issue_lib

gen issue_llib=0
replace issue_llib=1 if C3003_1==llibnr
replace issue_llib=issue_llib+1 if C3003_2==llibnr
replace issue_llib=. if C3003_1==99
tab issue_llib


gen issue_rlib=0
replace issue_rlib=1 if C3003_1==rlibnr
replace issue_rlib=issue_rlib+1 if C3003_2==rlibnr
replace issue_rlib=. if C3003_1==99
tab issue_rlib

gen issue_eco=0
replace issue_eco=1 if C3003_1==econr
replace issue_eco=issue_eco+1 if C3003_2==econr
replace issue_eco=. if C3003_1==99
tab issue_eco

gen issue_com=0
replace issue_com=1 if C3003_1==comnr
replace issue_com=issue_com+1 if C3003_2==comnr
replace issue_com=. if C3003_1==99
tab issue_com

gen issue_nat=0
replace issue_nat=1 if C3003_1==natnr
replace issue_nat=issue_nat+1 if C3003_2==natnr
replace issue_nat=. if C3003_1==99
tab issue_nat

** candidate orientation

*Which candidate is determined by party letter
mvdecode C3010_A-C3010_G, mv(96/99)
gen cand_cons=0 

replace cand_cons=C3010_A if consbuchst1=="A" &  consbuchst2==""
replace cand_cons=C3010_B if consbuchst1=="B"& consbuchst2==""
replace cand_cons=C3010_C if consbuchst1=="C"& consbuchst2==""
replace cand_cons=C3010_D if consbuchst1=="D"& consbuchst2==""
replace cand_cons=C3010_E if consbuchst1=="E"& consbuchst2==""
replace cand_cons=C3010_F if consbuchst1=="F"& consbuchst2==""
replace cand_cons=C3010_G if consbuchst1=="G"& consbuchst2==""

/* if two parties from the same ideological family, take max value */
replace cand_cons=C3010_A if consbuchst2=="A" &  C3010_A>cand_cons
replace cand_cons=C3010_B if consbuchst2=="B"& C3010_B>cand_cons
replace cand_cons=C3010_C if consbuchst2=="C"& C3010_C>cand_cons
replace cand_cons=C3010_D if consbuchst2=="D"& C3010_D>cand_cons
replace cand_cons=C3010_E if consbuchst2=="E"& C3010_E>cand_cons
replace cand_cons=C3010_F if consbuchst2=="F"& C3010_F>cand_cons
replace cand_cons=C3010_G if consbuchst2=="G"& C3010_G>cand_cons

mvdecode cand_cons, mv(96/99)
tab cand_cons


gen cand_soz=0 
replace cand_soz=C3010_A if sozbuchst1=="A" &  sozbuchst2==""
replace cand_soz=C3010_B if sozbuchst1=="B"& sozbuchst2==""
replace cand_soz=C3010_C if sozbuchst1=="C"& sozbuchst2==""
replace cand_soz=C3010_D if sozbuchst1=="D"& sozbuchst2==""
replace cand_soz=C3010_E if sozbuchst1=="E"& sozbuchst2==""
replace cand_soz=C3010_F if sozbuchst1=="F"& sozbuchst2==""
replace cand_soz=C3010_G if sozbuchst1=="G"& sozbuchst2==""

/* if two parties from the same ideological family, take max value */
replace cand_soz=C3010_A if sozbuchst2=="A" &  C3010_A>cand_soz
replace cand_soz=C3010_B if sozbuchst2=="B"& C3010_B>cand_soz
replace cand_soz=C3010_C if sozbuchst2=="C"& C3010_C>cand_soz
replace cand_soz=C3010_D if sozbuchst2=="D"& C3010_D>cand_soz
replace cand_soz=C3010_E if sozbuchst2=="E"& C3010_E>cand_soz
replace cand_soz=C3010_F if sozbuchst2=="F"& C3010_F>cand_soz
replace cand_soz=C3010_G if sozbuchst2=="G"& C3010_G>cand_soz
mvdecode cand_soz, mv(96/99)
tab cand_soz


gen cand_cd=0 

replace cand_cd=C3010_A if cdbuchst1=="A" &  cdbuchst2==""
replace cand_cd=C3010_B if cdbuchst1=="B"& cdbuchst2==""
replace cand_cd=C3010_C if cdbuchst1=="C"& cdbuchst2==""
replace cand_cd=C3010_D if cdbuchst1=="D"& cdbuchst2==""
replace cand_cd=C3010_E if cdbuchst1=="E"& cdbuchst2==""
replace cand_cd=C3010_F if cdbuchst1=="F"& cdbuchst2==""
replace cand_cd=C3010_G if cdbuchst1=="G"& cdbuchst2==""

/* if two parties from the same ideological family, take max value */
replace cand_cd=C3010_A if cdbuchst2=="A" &  C3010_A>cand_cd
replace cand_cd=C3010_B if cdbuchst2=="B"& C3010_B>cand_cd
replace cand_cd=C3010_C if cdbuchst2=="C"& C3010_C>cand_cd
replace cand_cd=C3010_D if cdbuchst2=="D"& C3010_D>cand_cd
replace cand_cd=C3010_E if cdbuchst2=="E"& C3010_E>cand_cd
replace cand_cd=C3010_F if cdbuchst2=="F"& C3010_F>cand_cd
replace cand_cd=C3010_G if cdbuchst2=="G"& C3010_G>cand_cd

mvdecode cand_cd, mv(96/99)
tab cand_cd


gen cand_sd=0 
replace cand_sd=C3010_A if sdbuchst1=="A"& sdbuchst2==""
replace cand_sd=C3010_B if sdbuchst1=="B"& sdbuchst2==""
replace cand_sd=C3010_C if sdbuchst1=="C"& sdbuchst2==""
replace cand_sd=C3010_D if sdbuchst1=="D"& sdbuchst2==""
replace cand_sd=C3010_E if sdbuchst1=="E"& sdbuchst2==""
replace cand_sd=C3010_F if sdbuchst1=="F"& sdbuchst2==""
replace cand_sd=C3010_G if sdbuchst1=="G"& sdbuchst2==""

/* if two parties from the same ideological family, take max value */
replace cand_sd=C3010_A if sdbuchst2=="A" &  C3010_A>cand_sd
replace cand_sd=C3010_B if sdbuchst2=="B"& C3010_B>cand_sd
replace cand_sd=C3010_C if sdbuchst2=="C"& C3010_C>cand_sd
replace cand_sd=C3010_D if sdbuchst2=="D"& C3010_D>cand_sd
replace cand_sd=C3010_E if sdbuchst2=="E"& C3010_E>cand_sd
replace cand_sd=C3010_F if sdbuchst2=="F"& C3010_F>cand_sd
replace cand_sd=C3010_G if sdbuchst2=="G"& C3010_G>cand_sd
mvdecode cand_sd, mv(96/99)
tab cand_sd


gen cand_lib=0 
replace cand_lib=C3010_A if libbuchst1=="A" &  libbuchst2==""
replace cand_lib=C3010_B if libbuchst1=="B"& libbuchst2==""
replace cand_lib=C3010_C if libbuchst1=="C"& libbuchst2==""
replace cand_lib=C3010_D if libbuchst1=="D"& libbuchst2==""
replace cand_lib=C3010_E if libbuchst1=="E"& libbuchst2==""
replace cand_lib=C3010_F if libbuchst1=="F"& libbuchst2==""
replace cand_lib=C3010_G if libbuchst1=="G"& libbuchst2==""

/* if two parties from the same ideological family, take max value */
replace cand_lib=C3010_A if libbuchst2=="A" &  C3010_A>cand_lib
replace cand_lib=C3010_B if libbuchst2=="B"& C3010_B>cand_lib
replace cand_lib=C3010_C if libbuchst2=="C"& C3010_C>cand_lib
replace cand_lib=C3010_D if libbuchst2=="D"& C3010_D>cand_lib
replace cand_lib=C3010_E if libbuchst2=="E"& C3010_E>cand_lib
replace cand_lib=C3010_F if libbuchst2=="F"& C3010_F>cand_lib
replace cand_lib=C3010_G if libbuchst2=="G"& C3010_G>cand_lib
mvdecode cand_lib, mv(96/99)
tab cand_lib




gen cand_llib=0 
replace cand_llib=C3010_A if llibbuchst=="A" 
replace cand_llib=C3010_B if llibbuchst=="B"
replace cand_llib=C3010_C if llibbuchst=="C"
replace cand_llib=C3010_D if llibbuchst=="D"
replace cand_llib=C3010_E if llibbuchst=="E"
replace cand_llib=C3010_F if llibbuchst=="F"
replace cand_llib=C3010_G if llibbuchst=="G"


gen cand_rlib=0 
replace cand_rlib=C3010_A if rlibbuchst=="A" 
replace cand_rlib=C3010_B if rlibbuchst=="B"
replace cand_rlib=C3010_C if rlibbuchst=="C"
replace cand_rlib=C3010_D if rlibbuchst=="D"
replace cand_rlib=C3010_E if rlibbuchst=="E"
replace cand_rlib=C3010_F if rlibbuchst=="F"
replace cand_rlib=C3010_G if rlibbuchst=="G"

gen cand_eco=0 
replace cand_eco=C3010_A if ecobuchst=="A" 
replace cand_eco=C3010_B if ecobuchst=="B"
replace cand_eco=C3010_C if ecobuchst=="C"
replace cand_eco=C3010_D if ecobuchst=="D"
replace cand_eco=C3010_E if ecobuchst=="E"
replace cand_eco=C3010_F if ecobuchst=="F"
replace cand_eco=C3010_G if ecobuchst=="G"


gen cand_com=0 
replace cand_com=C3010_A if combuchst=="A" 
replace cand_com=C3010_B if combuchst=="B"
replace cand_com=C3010_C if combuchst=="C"
replace cand_com=C3010_D if combuchst=="D"
replace cand_com=C3010_E if combuchst=="E"
replace cand_com=C3010_F if combuchst=="F"
replace cand_com=C3010_G if combuchst=="G"


gen cand_nat=0 
replace cand_nat=C3010_A if natbuchst=="A" 
replace cand_nat=C3010_B if natbuchst=="B"
replace cand_nat=C3010_C if natbuchst=="C"
replace cand_nat=C3010_D if natbuchst=="D"
replace cand_nat=C3010_E if natbuchst=="E"
replace cand_nat=C3010_F if natbuchst=="F"
replace cand_nat=C3010_G if natbuchst=="G"


**Austria-no Cand. Questions were included
 /*ELECTION STUDY NOTES - AUSTRIA (2008): C3010
         |
         | This variable was not included in the Austrian Election Study 
         | because it was considered to be less applicable in Austria.*/
replace cand_soz=-1 if laender==4002008
replace cand_cons=-1 if laender==4002008
replace cand_lib=-1 if laender==4002008
replace cand_llib=-1 if laender==4002008
replace cand_rlib=-1 if laender==4002008
replace cand_eco=-1 if laender==4002008
replace cand_com=-1 if laender==4002008
replace cand_nat=-1 if laender==4002008

** turnout

gen turnout=C3021_1==1
replace turnout=. if C3021_1>6

** vote choice


gen vote_cons=0
replace vote_cons=1 if C3023_LH_PL==consnr1
replace vote_cons=1 if C3023_LH_PL==consnr2
replace vote_cons=.a if consnr1==.
tab vote_cons


gen vote_soz=0
replace vote_soz=1 if C3023_LH_PL==soznr1
replace vote_soz=1 if C3023_LH_PL==soznr2
replace vote_soz=.a if soznr1==.
tab vote_soz

gen vote_sd=0
replace vote_sd=1 if C3023_LH_PL==sdnr1
replace vote_sd=1 if C3023_LH_PL==sdnr2
replace vote_sd=.a if sdnr1==.
tab vote_sd

gen vote_cd=0
replace vote_cd=1 if C3023_LH_PL==cdnr1
replace vote_cd=1 if C3023_LH_PL==cdnr2
tab vote_cd


gen vote_lib=0
replace vote_lib=1 if C3023_LH_PL==libnr1
replace vote_lib=1 if C3023_LH_PL==libnr2
replace vote_lib=.a if libnr1==.
tab vote_lib

gen vote_rlib=0
replace vote_rlib=1 if C3023_LH_PL==rlibnr
tab vote_rlib

gen vote_llib=0
replace vote_llib=1 if C3023_LH_PL==llibnr
tab vote_llib

gen vote_eco=0
replace vote_eco=1 if C3023_LH_PL==econr
tab vote_eco

gen vote_com=0
replace vote_com=1 if C3023_LH_PL==comnr
tab vote_com

gen vote_nat=0
replace vote_nat=1 if C3023_LH_PL==natnr
tab vote_nat

* exclude if participant did not vote 
recode vote_cons-vote_nat(0/1=.b) if C3021_1==5



** party one would never vote for
gen never_vote_cons=0
gen never_vote_soz=0
gen never_vote_sd=0
gen never_vote_cd=0
gen never_vote_lib=0
gen never_vote_llib=0
gen never_vote_rlib=0
gen never_vote_eco=0
gen never_vote_com=0
gen never_vote_nat=0

foreach var of varlist C3030_LH_1-C3030_LH_8{
replace never_vote_cons=1 if consnr1==`var'
replace never_vote_cons=1 if consnr2==`var'

replace never_vote_soz=1 if soznr1==`var'
replace never_vote_soz=1 if soznr2==`var'

replace never_vote_sd=1 if sdnr1==`var'
replace never_vote_sd=1 if sdnr2==`var'

replace never_vote_cd=1 if cdnr1==`var'
replace never_vote_cd=1 if cdnr2==`var'

replace never_vote_lib=1 if libnr1==`var'
replace never_vote_lib=1 if libnr2==`var'

replace never_vote_rlib=1 if rlibnr==`var'
replace never_vote_llib=1 if llibnr==`var'

replace never_vote_eco=1 if econr==`var'
replace never_vote_com=1 if comnr==`var'

replace never_vote_nat=1 if natnr==`var'
}
recode never_vote_soz(0=.b) if C3030_LH_1==99|sozbuchst1=="."
recode never_vote_sd(0=.b) if C3030_LH_1==99|sdbuchst1=="."
recode never_vote_lib(0=.b) if C3030_LH_1==99|libbuchst1=="."
recode never_vote_rlib(0=.b) if C3030_LH_1==99|rlibbuchst=="."
recode never_vote_llib(0=.b) if C3030_LH_1==99|llibbuchst=="."
recode never_vote_cd(0=.b) if C3030_LH_1==99|cdbuchst1=="."
recode never_vote_cons(0=.b) if C3030_LH_1==99|consbuchst1=="."

recode never_vote_*(0=.a) if C3030_LH_1>96&C3030_LH_1<99

*not asekd for a second party in Austria and Slovenia
tab C3030_LH_2 laender

mvdecode C3023_LH_PL, mv(91/99)

recode vote_cons-vote_nat(0/4=.) if C3023_LH_PL==.




** negative party evaluations
mvdecode C3009_A-C3009_H, mv(96/98=.a\99=.b)
/*lowest value counts */

gen neg_cons=.b
replace neg_cons=C3009_A if consbuchst1=="A" 
replace neg_cons=C3009_B if consbuchst1=="B"
replace neg_cons=C3009_C if consbuchst1=="C"
replace neg_cons=C3009_D if consbuchst1=="D"
replace neg_cons=C3009_E if consbuchst1=="E"
replace neg_cons=C3009_F if consbuchst1=="F"
replace neg_cons=C3009_G if consbuchst1=="G"
replace neg_cons=C3009_H if consbuchst1=="H"

/* never more than two parties from the same family so not needed to count the parties */
replace neg_cons=C3009_A if consbuchst2=="A" & C3009_A>neg_cons
replace neg_cons=C3009_B if consbuchst2=="B" & C3009_B>neg_cons
replace neg_cons=C3009_C  if consbuchst2=="C" & C3009_C>neg_cons
replace neg_cons=C3009_D if consbuchst2=="D" & C3009_D>neg_cons
replace neg_cons=C3009_E if consbuchst2=="E" & C3009_E>neg_cons
replace neg_cons=C3009_F  if consbuchst2=="F" & C3009_F>neg_cons
replace neg_cons=C3009_G  if consbuchst2=="G" & C3009_G>neg_cons
replace neg_cons=C3009_H  if consbuchst2=="H" & C3009_H>neg_cons
tab neg_cons


gen neg_soz=.b
replace neg_soz=C3009_A if sozbuchst1=="A"
replace neg_soz=C3009_B if sozbuchst1=="B"
replace neg_soz=C3009_C if sozbuchst1=="C"
replace neg_soz=C3009_D if sozbuchst1=="D"
replace neg_soz=C3009_E if sozbuchst1=="E"
replace neg_soz=C3009_F if sozbuchst1=="F"
replace neg_soz=C3009_G if sozbuchst1=="G"
replace neg_soz=C3009_H if sozbuchst1=="H"

replace neg_soz=C3009_A if sozbuchst2=="A" & C3009_A>neg_soz
replace neg_soz=C3009_B if sozbuchst2=="B" & C3009_B>neg_soz
replace neg_soz=C3009_C  if sozbuchst2=="C" & C3009_C>neg_soz
replace neg_soz=C3009_D if sozbuchst2=="D" & C3009_D>neg_soz
replace neg_soz=C3009_E if sozbuchst2=="E" & C3009_E>neg_soz
replace neg_soz=C3009_F  if sozbuchst2=="F" & C3009_F>neg_soz
replace neg_soz=C3009_G  if sozbuchst2=="G" & C3009_G>neg_soz
replace neg_soz=C3009_H  if sozbuchst2=="H" & C3009_H>neg_soz 
tab neg_soz



gen neg_sd=.b
replace neg_sd=C3009_A if sdbuchst1=="A"
replace neg_sd=C3009_B if sdbuchst1=="B"
replace neg_sd=C3009_C if sdbuchst1=="C"
replace neg_sd=C3009_D if sdbuchst1=="D"
replace neg_sd=C3009_E if sdbuchst1=="E"
replace neg_sd=C3009_F if sdbuchst1=="F"
replace neg_sd=C3009_G if sdbuchst1=="G"
replace neg_sd=C3009_H if sdbuchst1=="H"

replace neg_sd=C3009_A if sdbuchst2=="A" & C3009_A>neg_sd
replace neg_sd=C3009_B if sdbuchst2=="B" & C3009_B>neg_sd
replace neg_sd=C3009_C  if sdbuchst2=="C" & C3009_C>neg_sd
replace neg_sd=C3009_D if sdbuchst2=="D" & C3009_D>neg_sd
replace neg_sd=C3009_E if sdbuchst2=="E" & C3009_E>neg_sd
replace neg_sd=C3009_F  if sdbuchst2=="F" & C3009_F>neg_sd
replace neg_sd=C3009_G  if sdbuchst2=="G" & C3009_G>neg_sd
replace neg_sd=C3009_H  if sdbuchst2=="H" & C3009_H>neg_sd 
tab neg_sd

tab neg_sd


gen neg_cd=.b
replace neg_cd=C3009_A if cdbuchst1=="A"
replace neg_cd=C3009_B if cdbuchst1=="B"
replace neg_cd=C3009_C if cdbuchst1=="C"
replace neg_cd=C3009_D if cdbuchst1=="D"
replace neg_cd=C3009_E if cdbuchst1=="E"
replace neg_cd=C3009_F if cdbuchst1=="F"
replace neg_cd=C3009_G if cdbuchst1=="G"
replace neg_cd=C3009_H if cdbuchst1=="H"

replace neg_cd=C3009_A if cdbuchst2=="A" & C3009_A>neg_cd
replace neg_cd=C3009_B if cdbuchst2=="B" & C3009_B>neg_cd
replace neg_cd=C3009_C  if cdbuchst2=="C" & C3009_C>neg_cd
replace neg_cd=C3009_D if cdbuchst2=="D" & C3009_D>neg_cd
replace neg_cd=C3009_E if cdbuchst2=="E" & C3009_E>neg_cd
replace neg_cd=C3009_F  if cdbuchst2=="F" & C3009_F>neg_cd
replace neg_cd=C3009_G  if cdbuchst2=="G" & C3009_G>neg_cd
replace neg_cd=C3009_H  if cdbuchst2=="H" & C3009_H>neg_cd 
tab neg_cd



gen neg_lib=.b
replace neg_lib=C3009_A if libbuchst1=="A"
replace neg_lib=C3009_B if libbuchst1=="B"
replace neg_lib=C3009_C if libbuchst1=="C"
replace neg_lib=C3009_D if libbuchst1=="D"
replace neg_lib=C3009_E if libbuchst1=="E"
replace neg_lib=C3009_F if libbuchst1=="F"
replace neg_lib=C3009_G if libbuchst1=="G"
replace neg_lib=C3009_H if libbuchst1=="H"

replace neg_lib=C3009_A if libbuchst2=="A" & C3009_A>neg_lib
replace neg_lib=C3009_B if libbuchst2=="B" & C3009_B>neg_lib
replace neg_lib=C3009_C  if libbuchst2=="C" & C3009_C>neg_lib
replace neg_lib=C3009_D if libbuchst2=="D" & C3009_D>neg_lib
replace neg_lib=C3009_E if libbuchst2=="E" & C3009_E>neg_lib
replace neg_lib=C3009_F  if libbuchst2=="F" & C3009_F>neg_lib
replace neg_lib=C3009_G  if libbuchst2=="G" & C3009_G>neg_lib
replace neg_lib=C3009_H  if libbuchst2=="H" & C3009_H>neg_lib 
tab neg_lib





gen neg_llib=.b
replace neg_llib=C3009_A if llibbuchst=="A"
replace neg_llib=C3009_B if llibbuchst=="B"
replace neg_llib=C3009_C if llibbuchst=="C"
replace neg_llib=C3009_D if llibbuchst=="D"
replace neg_llib=C3009_E if llibbuchst=="E"
replace neg_llib=C3009_F if llibbuchst=="F"
replace neg_llib=C3009_G if llibbuchst=="G"
replace neg_llib=C3009_H if llibbuchst=="H"


gen neg_rlib=.b
replace neg_rlib=C3009_A if rlibbuchst=="A"
replace neg_rlib=C3009_B if rlibbuchst=="B"
replace neg_rlib=C3009_C if rlibbuchst=="C"
replace neg_rlib=C3009_D if rlibbuchst=="D"
replace neg_rlib=C3009_E if rlibbuchst=="E"
replace neg_rlib=C3009_F if rlibbuchst=="F"
replace neg_rlib=C3009_G if rlibbuchst=="G"
replace neg_rlib=C3009_H if rlibbuchst=="H"

gen neg_eco=.b
replace neg_eco=C3009_A if ecobuchst=="A"
replace neg_eco=C3009_B if ecobuchst=="B"
replace neg_eco=C3009_C if ecobuchst=="C"
replace neg_eco=C3009_D if ecobuchst=="D"
replace neg_eco=C3009_E if ecobuchst=="E"
replace neg_eco=C3009_F if ecobuchst=="F"
replace neg_eco=C3009_G if ecobuchst=="G"
replace neg_eco=C3009_H if ecobuchst=="H"

gen neg_com=.b
replace neg_com=C3009_A if combuchst=="A"
replace neg_com=C3009_B if combuchst=="B"
replace neg_com=C3009_C if combuchst=="C"
replace neg_com=C3009_D if combuchst=="D"
replace neg_com=C3009_E if combuchst=="E"
replace neg_com=C3009_F if combuchst=="F"
replace neg_com=C3009_G if combuchst=="G"
replace neg_com=C3009_H if combuchst=="H"


gen neg_nat=.b
replace neg_nat=C3009_A if natbuchst=="A"
replace neg_nat=C3009_B if natbuchst=="B"
replace neg_nat=C3009_C if natbuchst=="C"
replace neg_nat=C3009_D if natbuchst=="D"
replace neg_nat=C3009_E if natbuchst=="E"
replace neg_nat=C3009_F if natbuchst=="F"
replace neg_nat=C3009_G if natbuchst=="G"
replace neg_nat=C3009_H if natbuchst=="H"

foreach var of varlist neg_cons-neg_nat{
replace `var'=10-`var'
}


/*
egen rowmeanrl=mean(neg_rlib), by(laender)
egen rowmeanll=mean(neg_llib), by(laender)
egen rowmeancom=mean(neg_com), by(laender)
egen rowmeanleco=mean(neg_eco), by(laender)
egen rowmeannat=mean(neg_nat), by(laender)

replace neg_rlib=-1 if missing(rowmeanrl)
replace neg_llib=-1 if missing(rowmeanll)
replace neg_com=-1 if missing(rowmeancom)
replace neg_eco=-1 if missing(rowmeanleco)
replace neg_nat=-1 if missing(rowmeannat)
*/
*recode so high value means dislike


*recode into three-point short scale (-1 dislike +1 like 0 indifferent)
recode neg_soz(0/4.5=1)(5=0)(5.5/10=-1), gen(nsoz_b)
recode neg_cons(0/4.5=1)(5=0)(5.5/10=-1), gen(ncons_b)
recode neg_cd(0/4.5=1)(5=0)(5.5/10=-1), gen(ncd_b)
recode neg_sd(0/4.5=1)(5=0)(5.5/10=-1), gen(nsd_b)
recode neg_lib(0/4.5=1)(5=0)(5.5/10=-1), gen(nlib_b)

recode neg_rlib(0/4.5=1)(5=0)(5.5/10=-1), gen(nrlib_b)
recode neg_llib(0/4.5=1)(5=0)(5.5/10=-1), gen(nllib_b)

recode neg_com(0/4.5=1)(5=0)(5.5/10=-1), gen(ncom_b)
recode neg_eco(0/4.5=1)(5=0)(5.5/10=-1), gen(neco_b)
recode neg_nat(0/4.5=1)(5=0)(5.5/10=-1), gen(nnat_b)

** hostile voters
*binary
replace never_vote_soz=1 if C3030_LH_1==3&laender==72402008

gen npid_c=never_vote_cons==1&ncons_b==-1
replace npid_c=. if consbuchst1=="."|(mi(never_vote_cons)&mi(ncons_b))
replace npid_c=1 if never_vote_cons==1 & ncons_b==.&npid_c==0
replace npid_c=1 if ncons_b==-1&never_vote_cons==.a

gen npid_cd=never_vote_cd==1&ncd_b==-1
replace npid_cd=. if cdbuchst1=="."|(mi(never_vote_cd)&mi(ncd_b))
replace npid_cd=1 if never_vote_cd==1 & ncd_b==.&npid_cd==0
replace npid_cd=1 if ncd_b==-1&never_vote_cd==.a


gen npid_sd=never_vote_sd==1&nsd_b==-1
replace npid_sd=. if sdbuchst1=="."|(mi(never_vote_sd)&mi(nsd_b))
replace npid_sd=never_vote_sd==1 if nsd_b==.&npid_sd==0
replace npid_sd=nsd_b==-1&never_vote_sd==.a


gen npid_s=never_vote_soz==1&nsoz_b==-1
replace npid_s=. if sozbuchst1=="."|(mi(never_vote_soz)&mi(nsoz_b))
replace npid_s=1 if never_vote_soz==1&nsoz_b==.&npid_s==0
replace npid_s=1 if nsoz_b==-1 & never_vote_soz==.a



gen npid_l=never_vote_lib==1&nlib_b==-1
replace npid_l=. if libbuchst1=="."|(mi(never_vote_lib)&mi(nlib_b))
replace npid_l=1 if never_vote_lib==1& nlib_b==.&npid_l==0
replace npid_l=1 if nlib_b==-1&never_vote_lib==.a

gen npid_rl=never_vote_rlib==1&nrlib_b==-1
replace npid_rl=. if rlibbuchst=="."|(mi(never_vote_rlib)&mi(nrlib_b))
replace npid_rl=1 if never_vote_rlib==1 & nrlib_b==.&npid_rl==0
replace npid_rl=1 if nrlib_b==-1&never_vote_rlib==.a

gen npid_ll=never_vote_llib==1&nllib_b==-1
replace npid_ll=. if llibbuchst=="."|(mi(never_vote_llib)&mi(nllib_b))
replace npid_ll=1 if never_vote_llib==1 & nllib_b==.&npid_ll==0
replace npid_ll=1 if nllib_b==-1&never_vote_llib==.a



egen anti_pol=rowmean(C3009_A-C3009_F)
recode anti_pol(0/1.5=1)(1.5001/10=0)


gen vote_ss=vote_soz==1|vote_sd==1
replace vote_ss=. if (vote_soz==.a&vote_sd==.a)|(vote_soz==.a&vote_sd==.b)|(vote_soz==.b&vote_sd==.a)
gen vote_cc=vote_cons==1|vote_cd==1
replace vote_cc=. if (vote_cons==.a&vote_cd==.a)|(vote_cons==.a&vote_cd==.b)|(vote_cons==.b&vote_cd==.a)

gen vote_lll=vote_lib==1|vote_llib==1|vote_rlib==1
replace vote_lll=. if inlist(vote_lib,.a,.b)&inlist(vote_llib,.a,.b)&inlist(vote_rlib,.a,.b)



gen ppid_ss=ppid_soz_s
replace ppid_ss=ppid_sd_s if ppid_sd>0

gen ppid_cc=ppid_cons_s
replace ppid_cc=ppid_cd_s if ppid_cd>0

gen ppid_lll=ppid_lib_s
replace ppid_lll=ppid_rlib_s if ppid_rlib_s>0
replace ppid_lll=ppid_llib_s if ppid_rlib_s>0

recode ppid*(0/10=.) if  C3020_1>5

egen cand_ss=rowmax(cand_soz cand_sd)
egen cand_cc=rowmax(cand_cons cand_cd)
egen cand_lll=rowmax(cand_lib cand_rlib cand_llib)

egen issue_ss=rowmax(issue_soz issue_sd)
egen issue_cc=rowmax(issue_cons issue_cd)
egen issue_lll=rowmax(issue_lib issue_rlib issue_llib)

egen npid_ss=rowmax(npid_s npid_sd)
egen npid_cc=rowmax(npid_c npid_cd)
egen npid_lll=rowmax(npid_l npid_ll npid_rl)

foreach var of varlist C5001_A-C5001_G{
replace `var'=`var'/100
}
gen pol=C5001_A *C5017_A  +C5001_B *C5017_B  +C5001_C *C5017_C  +C5001_D *C5017_D  +C5001_E *C5017_E  +C5001_F *C5017_F
**REPLICATION of RESULTS from Caruana et al.
gen vote_can_c=C3023_LH_DC==1
gen vote_can_s=C3023_LH_DC==2
recode vote_can*(0=.) if C3023_LH_DC==99
logit vote_can_c ppid_cons ppid_soz ppid_lib npid_c npid_s npid_l, asis
logit vote_can_s ppid_cons ppid_soz ppid_lib npid_c npid_s npid_l



*Drop data for US and Canada*
drop if laender==12402008|laender==84002008


gen npid_main=npid_s==1|npid_c==1|npid_l==1|npid_sd==1|npid_cd==1|npid_rl==1|npid_ll==1

gen ppid_main=ppid_cons==1|ppid_cd==1|ppid_lib==1|ppid_llib==1|ppid_rlib==1|ppid_sd==1|ppid_soz==1

gen ppid_who=1 if ppid_cons==1
replace ppid_who=2 if ppid_cd==1
replace ppid_who=3 if ppid_rlib==1
replace ppid_who=4 if ppid_lib==1
replace ppid_who=5 if ppid_llib==1
replace ppid_who=6 if ppid_sd==1
replace ppid_who=7 if ppid_soz==1

gen loyal_partisans=0
foreach name in cons cd lib rlib llib soz sd{
replace loyal_partisans=1 if vote_`name'==1&ppid_`name'==1
}
replace loyal_partisans=. if ppid_main==0

rename  C3020_4 partisan_strength
*country dummies
encode C1006_NAM, gen(laender_num)
**East Germany
replace cee=1 if laender==27602009& inlist(C2027,12,13,14,15,16)

** control variables
*age
recode C2001 (100/1000=.), gen (age)

*education
recode C2003 (97/99=.)(9=.), gen (education)

*gender
recode C2002 (9=.), gen(gender)

*satisfaction with democracy

recode C3019 (6/9=.), gen(dem_sat)

*******************
**  CALCULATIONS **
*******************



gen voteshare_cons=0
gen voteshare_lib=0
gen voteshare_soz=0

foreach name in A B C D E F G H {
replace voteshare_soz=voteshare_soz+C5001_`name' if C5016_`name'==3|C5016_`name'==4
replace voteshare_lib=voteshare_lib+C5001_`name' if C5016_`name'==5|C5016_`name'==6|C5016_`name'==7
replace voteshare_cons=voteshare_cons+C5001_`name' if C5016_`name'==8|C5016_`name'==9
}

gen voteshare_main=voteshare_soz+voteshare_lib+voteshare_cons

mean voteshare_main, over(C1003)

gen seatshare_cons=0
gen seatshare_lib=0
gen seatshare_soz=0

foreach name in A B C D E F G H {
replace seatshare_soz=seatshare_soz+C5002_`name' if C5016_`name'==3|C5016_`name'==4
replace seatshare_lib=seatshare_lib+C5002_`name' if C5016_`name'==5|C5016_`name'==6|C5016_`name'==7
replace seatshare_cons=seatshare_cons+C5002_`name' if C5016_`name'==8|C5016_`name'==9
}

gen seatshare_main=seatshare_soz+seatshare_lib+seatshare_cons

table laender , c(mean turnout mean C5006_1 mean voteshare_main mean seatshare_main)


tab ppid_main npid_main, cell

*************************
** Analysis of turnout **
*************************

**drop typeof_pid



rename gender female

recode ppid_y3(2/3=2), gen(ppid_y2)

rename C3013 leftright
rename C2020 income

egen cand_max=rowmax(C3010_A-C3010_F)
egen issue_max=rowmax(issue*)

/* all between 0 and 1
replace age=age/99
replace education=education/8
replace gender=gender/2
replace ppid_y3=ppid_y3/3
replace ppid_y2=ppid_y2/2
replace dem_sat=dem_sat/4
replace dem_sat=dem_sat-0.25
replace leftright=leftright/10*/

mvdecode leftright, mv(95/99)
mvdecode income, mv(7/9)




** effect on turnout


set scheme s2mono
/*exclude austria -> turnout not asked */
logit turnout c.ppid_y3##npid_main  age education female leftright dem_sat cee i.laender_num 
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )
collin ppid_y3 npid_main cee pol age education female leftright dem_sat laender_num 


*margins total as observed over cee
margins,  at(npid_main=(0 1) ppid_y3=(0 1 2 3)) by(cee)
marginsplot, bydimension(cee) x(ppid_y3)

*margins change per country as observed
margins, dydx(npid_main) at(ppid_y3=(0 1 3)) over(laender_num)
marginsplot, x(laender_num) plot(ppid_y3) recast(scatter) xlabel(, angle(90))
margins , dydx(npid_main) at(ppid_y3=(0 1 2 3)) by(cee) 

/*
margins , dydx(npid_main) at(ppid_y3=(0 1 2 3)) by(cee) 
marginsplot, x(ppid_y3) recast(scatter) xlabel(, angle(90))*/

*twostep approach
*first logistic regression
logit turnout c.ppid_y3 npid_main  age education female leftright dem_sat i.laender_num 


melogit turnout c.ppid_y3 npid_main  age education female leftright dem_sat  ||laender_num:
estat icc

melogit turnout c.ppid_y3 npid_main  age education female leftright dem_sat  ||laender_num: ppid_y3 npid_main, cov(unstructured)
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )





******************************
** Analysis of loyal voting **
** Pls note: only adherents **
******************************
tab loyal_partisans laender, col
*varies between 54 Poland and 85 percent Austria
*70 percent for very close adherents in PL 95 percent in Austria

recode partisan_strength (1=3)(3=1)
label value  partisan_strength ps

logit loyal_partisans partisan_strength npid_main age education female leftright dem_sat i.laender_num
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )
margins , dydx(npid_main) at(partisan_strength=(1(1)3)) 
margins , at(npid_main=(0 1) partisan_strength=(1(1)3)) 


margins, dydx(npid_main) over(r.b3.partisan_strength)


margins , dydx(npid_main) at(partisan_strength=(1(1)3)) over(laender_num)
marginsplot, x(laender_num)  recast(scatter) xlabel(, angle(90))



melogit loyal_partisans partisan_strength npid_main age education female leftright dem_sat||laender_num: partisan_strength npid_main
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )



******************************
** Analysis of vote choice  **
** All respondents          **
******************************

gen m_vote=1 if vote_cc==1
replace m_vote=3 if vote_ss==1
replace m_vote=2 if vote_lll==1
replace m_vote=0 if m_vote==.&turnout==1
**replace m_vote=4 if vote_rlib==1

label define m_vote 1"CONS/CD" 2"LIB" 3"SOZ/SD"  0"other", replace
label value m_vote m_vote




gen npid_lll2=npid_lll
replace npid_lll2=0 if laender_num==3
replace npid_lll2=0 if laender_num==6
replace npid_lll2=0 if laender_num==15

replace ppid_lll=0 if inlist(laender_num,3,6,15)
replace vote_lll=0 if inlist(laender_num,3,6,15)

replace npid_cc=0 if laender_num==14
replace ppid_cc=0 if laender_num==14
replace vote_cc=0 if laender_num==14


mlogit m_vote ppid_cc ppid_ss ppid_lll npid_ss npid_lll2 npid_cc  i.laender_num age education female dem_sat leftright i.laender_num if !inlist(laender_num,3,6,15,14), b(0)


est sto m


estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )

margins, at(npid_ss=(0 1)) pr(out(1))
margins, at(npid_ss=(0 1)) pr(out(1))pr( out(2)) pr(out(3))


forval i = 0/3 {
est res m
margins, dydx(ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll ) pr(out(`i')) post
est sto m`i'
}


estout m0 m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))

mlogit m_vote ppid_cc ppid_ss ppid_lll npid_ss npid_lll2 npid_cc pol i.laender_num, b(2)

logit vote_cc ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2 issue_cc cand_cc  age education dem_sat leftright i.laender_num,asis
logit vote_ss ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2 issue_ss cand_ss  age education dem_sat leftright i.laender_num,asis
logit vote_lll ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2 issue_lll cand_lll  age education dem_sat leftright i.laender_num,asis




bys laender: mlogit m_vote ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2 age education dem_sat i.laender_num, b(0)




melogit vote_cc ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2  age education dem_sat leftright ||laender_num: ppid_cc  npid_lll2 npid_ss
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )

melogit vote_ss ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2  age education dem_sat leftright ||laender_num: ppid_ss npid_cc  npid_lll2
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )

melogit vote_lll ppid_cc ppid_ss ppid_lll npid_cc npid_ss npid_lll2  age education dem_sat leftright ||laender_num: ppid_lll npid_cc npid_ss 
estout, cells("b(star fmt(3)) se(par fmt(3))") stats(r2_p N, fmt(%9.3f %9.0g) )
