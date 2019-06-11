* British Journal of Political Science
* The Micro-Foundations of Party Competition and Issue Ownership: * The Reciprocal Effects of CitizensÕ Issue Salience and Party Attachments* Anja Neundorf and James Adams


* GERMAN SOCIO-ECONOMIC PANEL (SOEP): Data managment 

* This file allows the following:
* 1. Data merging of raw SOEP data
* 2. Recode all variables used in the article


* -----------------------------------------------------------------------------
* DATA ACCESS: 
* To re-analyze this data set,  it is neccesary to apply for a 
* standard SOEP user contract in order to be granted access to the archived data,
* which can be requested via http://www.diw.de/en/diw_02.c.222836.en/access.html. 
* Here we are using version 24 (DOI: 10.5684/soep.v24). 

clear allcapture log closeset more off, perm global inpath   "PATH TO WHERE SOEP DATA IS STORED"global temppath ".../temp/"global outpath  ".../"*************************************************************************************************************************************************************************************************************************************************** -----------------------------------------------------------------------------
* DATA MERGING:
* The SOEP data is available in many single files. You first need to merge the variables
* from the different files into one masterfile.*** Extrahieren der Variablen aus xp ******************************************** 1. Party ID variables and political worries *local year=1984foreach wave of any a b c d e f g h i j k l m n o p q r s t u v w x y z {	cd "${inpath}"	use `wave'p.dta, clear	gen year=`year'	foreach pid of any ap5601 bp7901 cp7901 dp8801 ep7701 fp9301 gp8501 hp9001 ip9001 jp9001 kp9201 lp9801 mp8401 np9401 op9701 pp111 qp116 ///				 rp111 sp111 tp118 up123 vp129 wp119 xp128  yp130    zp123    { 		capture rename `pid' pid 		} 	foreach party of any ap5602 bp7902 cp7902 dp8802 ep7702 fp9302 gp8502 hp9002 ip9002 jp9002 kp9202 lp9802 mp8402 np9402 op9702 pp11201 qp11701 ///				 rp112 sp11201 tp11901 up12401 vp13001 wp12001 xp12901 yp13101  zp12401 { 		capture rename `party' party 		} 	foreach econdev of any ap5401 bp7701 cp7701 dp8901 ep7801 fp9401 gp8601 hp9101 ip9101 jp9101 kp9301 lp9901 mp10901 np9501 op9801 pp10901 qp11801 ///				     rp11401 sp11301 tp12001 up12501 vp13101 wp12101 xp13001 yp13201  zp12801    { 		capture rename `econdev' econdev 		} 	foreach enviro of any ap5403 bp7703 cp7703 dp8903 ep7803 fp9403 gp8603 hp9103 ip9103 jp9103 kp9303 lp9903 mp10903 np9503 op9803 pp10904 qp11804 ///				     rp11404 sp11304 tp12004 up12504 vp13104 wp12104 xp13004 yp13204  zp12805 { 		capture rename `enviro' enviro 		} 		keep persnr year pid party econdev enviro
	sort persnr year      save "${temppath}`wave'prec.dta", replace	local year=`year'+1	}* 2. Crime *local year=1994foreach wave of any  k l m n o p q r s t u v w x y z {	cd "${inpath}"	use `wave'p.dta, clear	gen year=`year'	foreach crime of any kp9306   lp9906   mp10908  np9508 op9808   pp10906  qp11806  rp11406  sp11306  tp12006  up12506  vp13106  ///wp12106  xp13006  yp13207  zp12809{	capture rename `crime' crime 			}	keep persnr year crime 	sort persnr year      save "${temppath}`wave'_issue1.dta", replace	local year=`year'+1}* 3. Political interest *local year=1985foreach wave of any  b c d e f g h i j k l m n o p q r s t u v w x y z {	cd "${inpath}"	use `wave'p.dta, clear	gen year=`year'	foreach polint of any bp75 cp75 dp84 ep73 fp89 gp83 hp89 ip89 jp89 kp91 lp97 mp83 np93 op96 pp110 qp115 rp110 sp110 tp117 up122 vp128 ///	wp118 xp127 yp129    zp122 {	capture rename `polint' polint 			}	keep persnr year polint 	sort persnr year      save "${temppath}`wave'prec85.dta", replace	local year=`year'+1}*** Extract variables from the cross-sectional file xpgen *****************************************************************>> 84 bis 2007*/local year=1984foreach welle in "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" {      	use hhnr persnr erwtyp${`welle'year2} partz${`welle'year2} nation${`welle'year2} `welle'bilzeit `welle'psbil `welle'famstd labgro${`welle'year2} ///	labnet${`welle'year2} impgro${`welle'year2}  impnet${`welle'year2}  `welle'erwzeit  `welle'tatzeit lfs${`welle'year2} egp${`welle'year2} emplst${`welle'year2} stib${`welle'year2} ///	isei${`welle'year2}  is88${`welle'year2}  jobch${`welle'year2}  `welle'pbbil02${`welle'year2}  ///    using "${inpath}`welle'pgen.dta", clear	local year=`year'+1	sort persnr	save "${temppath}`welle'pgenX.dta", replace} *------------------------------------------------------------------------------------------------------**------------------------------------------------------------------------------------------------------*use "${temppath}apgenX.dta", clearlocal year=1983foreach welle in "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v"  "w" "x" "y" "z" {	local year=`year'+1	use  "${temppath}`welle'pgenX.dta"	rename `welle'psbil psbil	rename `welle'bilzeit bilzeit	rename `welle'famstd famstd	rename `welle'erwzeit erwzeit	rename `welle'tatzeit tatzeit 	rename nation nation	rename labgro labgro	rename labnet labnet	rename impgro impgro	rename impnet impnet	rename erwtyp erwtyp 	rename partz partz	rename emplst emplst	rename jobch jobch	rename lfs lfs	rename egp egp	rename is88 is88	rename isei isei	rename stib stib
	rename `welle'pbbil02 college 	gen year=`year'save "${temppath}`welle'pgenXrec.dta", replace	}***************************************************************************************************************************************************************************************************************************************************** Extract variables from the longitudinal files ppfad                                                          ****************************************************************************************************************************use "${inpath}ppfad", clearuse 	hhnr persnr sex gebjahr corigin psample loc1989 ///	anetto bnetto cnetto dnetto enetto fnetto gnetto hnetto inetto jnetto knetto lnetto mnetto nnetto onetto pnetto  ///	qnetto rnetto snetto tnetto unetto vnetto wnetto xnetto ynetto znetto ///	using "${inpath}ppfad.dta", clearsort persnr*** Final step of ppfadX ***********************************local year=1984foreach welle in "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" {	ren `welle'netto netto`year'	local year=`year'+1}sort persnrreshape long netto , i(persnr) j(year) save "${temppath}ppfadXlong.dta", replaceuse "${temppath}ppfadXlong.dta"*----------------------------------------------------------------------------------------------------**--------------------- MERGING ALL FILES --------------------------------------------*use "${temppath}apgenxrec.dta"foreach welle in  "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" {append using "${temppath}`welle'pgenxrec.dta"}sort persnr year save "${temppath}pgenall.dta", replaceclearuse "${temppath}aprec.dta"foreach welle in  "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" {append using "${temppath}`welle'prec.dta"}sort persnr year save "${temppath}pall84.dta", replaceclearuse "${temppath}bprec85.dta"foreach welle in  "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" {append using "${temppath}`welle'prec85.dta"}sort persnr year save "${temppath}pall85.dta", replaceclearuse "${temppath}i_issue1.dta"foreach welle in  "j" "k" "l" "m" "n" "o" {append using "${temppath}`welle'_issue1.dta"}sort persnr year save "${temppath}_issue1.dta", replace*** Merging ***use "${temppath}ppfadXlong.dta"sort persnr yearmerge persnr year using "${temppath}pgenall.dta"sort persnr yeardrop _mergesort persnr yearmerge persnr year using "${temppath}pall84.dta" sort persnr yeardrop _mergemerge persnr year using "${temppath}_issue1.dta" sort persnr yeardrop _mergemerge persnr year using "${temppath}pall85.dta" sort persnr yeardrop _merge**** SAVE ***********save "${outpath}Masterfile_SOEP.dta", replace**---------------------------------------------------------------------------
** RECODING OF VARIABLES*** reducde variable number  ***keep  persnr year sex gebjahr  econdev enviro  pid party polint ///  psbil college egp immig crime churchsave "${outpath}Masterfile_SOEP.dta", replace*** Time ***
/// Time variable is used in Markov model as count variable. 
gen time =.forvalues i = 0/25{replace time = `i' if year == 1984 + `i' }recode time (0=.)         /* First time point needs to be set to Missing */


* ========================================
** First year included in study

egen min_year = min(year) if pid!=., by(persnr)    /* Gen a variable when respondents were first included in the study,
												    which is later used to determine value of covariates ate t=0   */
																								 										***-----------------------------------------****** recode missing values of party ID question **tab pid,mtab pid, nolabelrecode pid (-2=.)  (-1=.) (3=0) (2=0)***--------------------------------******** Rename party identification ***gen partynew=0replace partynew=1 if party==6 & year==1991replace partynew=1 if party==7 & (year==1992 | year==1993)replace partynew=1 if party==6 & year>1993replace partynew=2 if party==6  & year<1991replace partynew=2 if (party==4 | party==5) & year==1991replace partynew=2 if (party==5 | party==6) & (year==1992 | year==1993)replace partynew=2 if party==5 & year>1991replace partynew=3 if party==1 replace partynew=4 if  party== 5 & year<1991replace partynew=4 if party==3 & year==1991 replace partynew=4 if party==4 & year>1991 replace partynew=5 if (party==2 | party==3 | party==4) & year<1991replace partynew=5 if party==2 & year==1991replace partynew=5 if (party==2 | party==3) & year>1991replace partynew=5 if party==13 & year>1997replace partynew=6 if party==7 & year>1989 & year~=1993replace partynew=6 if party==8 & year==1993replace partynew=. if party==.replace partynew=. if party==(-2)
replace partynew = 0 if pid==0
label var partynew "Party Identification - parties ordered continuously"label def partylbl -2"NAP" 0 "Other Party or NA" 1 "PDS - Socialist" 2 "The Greens" 3 "SPD - Social Democrats" /// 4 "FDP - The Liberals" 5 "CDU/CSU - Christian Conservative" 6 "Republicans/DVU/NPD - Right Wing"label value partynew partylbl
tab partynew,mtab partynew
gen pid5cat = partynewlabel value pid5cat partylbl recode pid5cat (1=0) (6=0)replace pid5cat = 0 if pid==0tab pid5cat

foreach i of any 1 2 3 4 5   {

bysort persnr: gen pid5cat`i' = pid5cat[_n-`i']
lab val pid5cat`i' partylbl
}****** Recode Worries-battery *****recode  econdev enviro  immig crime   (-3/-1=.)lab def worry 1"very concerned" 0"other"foreach i of any econdev enviro  immig crime  {gen `i'_dum = `i'recode `i'_dum (2/3=0)lab val `i'_dum worry} 



foreach i of any 1 2 3 4 5   {

bysort persnr: gen econdev`i' = econdev_dum[_n-`i']lab val econdev`i' worry

bysort persnr: gen enviro`i' = enviro_dum[_n-`i']
lab val enviro`i' worry}

** Exploring Issue salience and party ID

sum  econdev_dum enviro_dum immig_dum crime_dum 

tab pid5cat econdev_dum , row nof
tab pid5cat enviro_dum , row nof
tab pid5cat crime_dum , row nof
tab pid5cat immig_dum , row nof 
 
 **** Independent Variables ***** Age gen age =year-gebjahr
bysort persnr: egen agemin = min(age)* Sex
tab sexgen female = sexrecode female (1=0) (2=1)* Education

tab  psbil
gen educat = psbil
recode educat (-2/-1=.) (1=1) (2=2) (3/4=3) (5=2) (6=1) (7=3) 


tab college
recode college (4=1) (5=2) (6=2)

replace educat=4  if (college==1 |  college==2)  & educat==3

lab def educlbl 1 "Hauptschule: no/lower" 2"Mittlere Reife: Intermediate" ///
3"Abitur: Upper/still in school" 4"Degree"
lab val educat educlbl
tab educat

by persnr: egen bilmax = max(educat)
lab val bilmax educlbl
tab bilmax
*** Political Interest ***

tab polint,m
tab polint, nolabel

recode polint (4=1) (3=2) (2=3) (1=4) (-2=.) (-1=.)
*lab def pollbl 1 "not at all interested" 4 "very interested"
label value polint pollbl

tab polint,m

bysort persnr: gen pol1 = polint if year== min_year +1
recode pol1 (.=-2)
bysort persnr: egen polint_ini = max(pol1)
lab var polint_ini "Political interest at t=0"
recode polint_ini (-2=.)
drop pol1

bysort persnr: egen av_polint = mean(polint)
lab var av_polint "Average Political interest"


** Religiosity **

recode church (1=4) (2=3) (3=2) (4=1)

bysort persnr: gen chu1 = church if year== min_year
recode chu1 (.=-2)
bysort persnr: egen chur_ini = max(chu1)
lab var chur_ini "Chruch attendence at t=0"
recode chur_ini (-2=.)
drop chu1

bysort persnr: egen av_church= mean(church)
tab av_church
** Occupation ***

gen class=egp

recode class(1=1) (2=2) (3 4=3) (5 6 11=4) (8=5) (9 10=6) (15=0) (18=7) (-1=.) (-2=0)
replace class = 7 if egp==18


lab var class "New Goldthorpe Class codes incl unempl, pension, and other categories"
lab def egplbl1 1 "Class I" 2 "Class II" 3 "Class III_V" 4 "Class IV" 5 "Class VI" 6 "Class VII" 0"no class - other" 7"Pensioner"
lab val class egplbl1


bysort persnr: gen cla1 = class if year== min_year
recode cla1 (.=-2)
bysort persnr: egen class_ini = max(cla1)
recode class_ini (-2=.)
lab var class_ini "Initial class position at t=0"
lab val class_ini egplbl1
drop cla1

by persnr: egen class_mode= mode(class), minmode
lab val class_mode egplbl1
tab class_mode


***--------------------------------****
**** Valid answers depending on PID ***

gen resp_pid=0
forvalues i = 1984/2007{
  replace resp_pid=1 if year == `i' & pid5cat !=.
  }
bysort persnr : egen sumpid = sum(resp_pid)
tab sumpid,m

drop if sumpid<3 // Only using respondents that have at least 3 valid repsonses


***--------------------------------****
* SAVE WORKING FILE 
***--------------------------------****


save "${outpath}Masterfile_SOEP.dta", replace

