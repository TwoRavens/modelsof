*Generate main dataset for analysis

global restrict birthyr>=1910 & birthyr <=1940 | (year-age>=1910 & year - age <=1940)

*Malaria/Hookworm Rates	
use "longdiff_us", clear
	keep bplg infkof malecol_hong malmort1890 malpc1920 south
	sort bplg

	rename bpl statefip
	sort statefip
	
	tempfile bleak
	save `bleak'


*Compulsory Schooling laws
use "tb", clear
	keep statename statefip
	sort statename 
	tempfile temp
	save `temp'

use "comp", clear
	
	g statename=upper(state)
	sort statename
	
	merge m:1 statename using `temp'
	keep if _merge==3
	
	replace yr=yr+1900
	
	*lleras-muney: matches individuals to laws in place when they were 14 years old
	
	
	bysort statename: g tag=1 if _n==_N
	bysort statename: g num=_N
	
	expand=10 if tag==1
	sort statename yr
	
	bysort statename: replace yr=yr+(_n-num) if tag==1
	
	
	g birthyr=yr-14
	order state statename yr birthyr
 
	rename statefip bpl 
	sort bpl birthyr
	

	tempfile schooling
	save `schooling'


*TB
use "tb", clear
	keep statefip tbpulmonary  statename stateabbr
	
	*latitude, long
	sort stateabbr
	merge 1:1 stateabbr using "state_latlon", generate(_latlon)
		keep if _latlon==3
		drop _latlon

	merge 1:1  statefip using `bleak'
 
	keep if _merge==3
	
	
	rename statename statenm


	g statename=proper(trim(statenm)) 

	rename statename stateofbirth 

	do "stateofbirth_coding"
	tempfile diseases
	save `diseases'
		
*State Mobilization Rates
insheet using "ww2-state-mob-rates.csv", comma clear
	g stateabbr=trim(state)
	tempfile temp
	save `temp'

use "tb", clear
	sort stateabbr
	keep stateabbr statefip
	merge 1:1 stateabbr using `temp'
	keep if _merge==3
		drop _merge
	sort statefip
	tempfile mobil
	save `mobil'
	

		
*****Merge with Census Data***************************************************************************************************
use "$censusfile", clear
	keep if $restrict

	replace birthyr=year-age if birthyr==0
	replace birthyr=. if birthyr==0		
	
	*region mapping to bpl
	preserve
		bysort statefip region: keep if _n==1
		keep statefip region 
		rename statefip bpl
		
		g bplregion4=floor(region/10)
		g bplregion9=region 
		keep if bpl < 99 & bplregion4 < 9 
		
		keep bpl*
		
		sort bpl
		tempfile region
		save `region'
	restore
	
	sort bpl birthyr
	merge m:1 bpl birthyr using `schooling', generate(_compschool) keepusing(bpl birthyr comyrs childcom)
	merge m:1 bpl using `diseases', gen(_m)
	merge m:1 bpl using `region', nogenerate 
	
	drop if _compschool==2
	
	*_m = 1 is people born abroad, so no pre-goiter variable for them
	keep if _m==3
	drop _m
	
	rename statenm statename
	
	*State of residence
	merge m:1 statefip using `mobil', keepusing(statefip mobrate) nogenerate


***** Variables
	replace bpl=. if bpl>56
	replace statefip=. if statefip==99

	gen post=(birthyr>=1924) 
	gen after=(birthyr>=1928)
	gen during=(birthyr>=1924 & birthyr<=1927)
	gen before=(birthyr <=1923)
	gen placebo=(birthyr <=1919) 

	replace post = . if birthyr == .
	replace after=. if birthyr==.
	replace during=. if birthyr==.
	replace before=. if birthyr==.

	g pre=birthyr<=1919 if birthyr<.

	*demographic
	gen male=(sex==1)
	replace male = . if sex == .

	gen female=1-male

	gen black=(race==2)
	replace black = . if race==.

	g white=race==1 if race<.

	*education
	*years of schooling
	gen schooling=higrade
	replace schooling=. if higrade==0|higrade==.

	*nursery/kindergarten count as 0 years; top code at 5th year of college (17th year of school)
	recode schooling (1 2 3=0) 
	replace schooling=schooling-3 if schooling>0
	replace schooling=17 if schooling>17 & schooling <. 

	gen schooling_sp=higrade_sp
	replace schooling_sp=. if higrade_sp==0|higrade_sp==.
	recode schooling_sp (1 2 3=0) 
	replace schooling_sp=schooling_sp-3 if schooling_sp>0
	replace schooling_sp=17 if schooling_sp>17 & schooling_sp <. 

	*labor force
	recode labforce (0=.) 
	replace labforce=labforce-1
	label drop LABFORCE

	*employment status
	recode empstat (0 3 =.) (2=0)
	label drop EMPSTAT

	*employed (unconditional)
	g employed=(empstat==1)
	replace employed=. if labforce==.

	*Hours/weeks worked
	g weeksworked=wkswork2
	recode weeksworked (0=.)

	g worked_50=weeksworked>=6
		replace worked_50=. if weeksworked==.
	g worked_27=weeksworked>=3
		replace worked_27=. if weeksworked==.
	g worked_40=weeksworked>=4 if weeksworked<.

	g workedlastyear=1 if workedyr==3
		replace workedlastyear=0 if workedyr==1

	*income variables 
	*wage income 1940+
	recode incwage  (999999=.)

	*total income 1950+
	recode inctot inctot_sp (9999999=.)
	replace inctot = . if inctot < 0
	replace inctot_sp = . if inctot_sp <0

	*family income 1950+
	recode ftotinc (9999999=.)
	*replace ftotinc = . if ftotinc <0


	*adjust prices - base year is 1999: scaling numbers from IPUMS
	local incvars inctot incwage ftotinc inctot_sp  
	foreach inc in `incvars' {
		replace `inc'=`inc'*11.99 if year==1940 
		replace `inc'=`inc'*7 if year==1950 /*10k - 70k in 1999 dollars*/
		replace `inc'=`inc'*5.725 if year==1960 /*25k - 143.125k*/
		replace `inc'=`inc'*4.540 if year==1970 /*50k- 227k */
		replace `inc'=`inc'*2.314 if year==1980 /*75k - 173.773 k*/
		replace `inc'=`inc'*1.344 if year==1990 /*400k - 537.6k*/
		}

	*Topcoding /*70,000 because 1950 topcode x inflation = 70k*/
	*Inverse hyperbolic sine 
	foreach var in inctot incwage inctot_sp  {
		replace `var'=70000 if `var'>70000 & `var'<.
		g ihs`var'=ln(`var' + (`var'^2+1)^0.5)
		g ihs`var'_cond=ihs`var' if `var'>0
	}

	*Drop all zeros
	g inctot1=inctot

	*Topcoding /*70,000 because 1950 topcode x inflation = 70k*/

	g inctot2=inctot1
	replace inctot2=70000 if inctot2>70000 & inctot2 <.

	*Unconditional ln(income)
	g lninctot = ln(inctot+1)	
	g lnfaminc = ln(ftotinc+1)

	*Conditional ln(income)
	g lninctot_cond=ln(inctot)
	g lnfam_cond=ln(ftotinc)

	*Conditional ln(income) for topcoded/nonzeros
	g lninctot_cond2=ln(inctot2)

	*Unconditional ln(income) for topcoded
	g lninctot2=ln(inctot2)
		replace lninctot2=0 if inctot==0
	*Unconditional level income for topcoded
	g inctot3=inctot2
		replace inctot3=0 if inctot==0


	*Topcoding /*70,000 because 1950 topcode x inflation = 70k*/
	foreach var in hhinc ftotinc {
		replace `var'=. if `var'<0
		replace `var'=70000 if `var'>70000 & `var'<.
		g ihs`var'=ln(`var' + (`var'^2+1)^0.5)
	}
	
	g latitude2=latitude^2
	g longitude2=longitude^2

		global statevar bpl
	global newvar goiterld
	do "add_goiterld.do"

	global statevar statefip
	global newvar goiterldres
	do "add_goiterld.do"

	g currmarr=inlist(marst,1,2) if marst<.
	g evermarr=marst!=6 if marst<.
		
	replace agemarr=. if agemarr==0
	g agemarruncond=agemarr
	replace agemarruncond=age+1 if evermarr==0 & datanum!=4 /*1970 sample 4 doesn't ask about agemarr, so I don't want to give 0s to the rest*/

	bysort bpl: g one=_n==1
	
	sum goiterld if one==1, d
	global scaleld=r(p75)-r(p25)
	display "$scaleld"

	g y=birthyr-1900
	g y2=y^2

	g goiterldscale=goiterld/$scaleld
	g goiterldscaleres=goiterldres/$scaleld

	foreach var in infkof malecol_hong malmort1890 tbpulmonary {
			sum `var' if one==1, d
			g `var'scale=`var'/(r(p75)-r(p25))
	}


	*create female/black proportions linked to birthplace
	global recodevar bpl
	global newvar female1920bpl
	do "recode_female1920s.do"

	global recodevar bpl 
	global newvar black1920bpl
	do "recode_black1920s.do"

	global recodevar bpl
	global newvar dblack
	do "recode_dblack.do"

	global recodevar bpl
	global newvar popgrowth
	do "recode_popgrowth.do"

	*Weights
	replace perwt=perwt/2 if year==1970
	replace slwt=slwt/2 if year==1970
		/*b/c there are two 1970 samples here: both are random 1% samples*/
	
	
	foreach var in  inctot3 inctot2  lninctot_cond2   agemarr   schooling  ihsinctot weeksworked worked_40 {
		g weight`var'=slwt
		replace weight`var'=perwt if year==1940 
		/*only relevant for schooling b/c income is not available in 1940: schooling is only a sample line variable for 1950; in 1940 everyone answers */
	}
	foreach var in  ihsftotinc employed labforce  ihsinctot_sp  schooling_sp  evermarr  {
		g weight`var'=perwt
	}
	/*only found in one 1970 sample*/
	foreach var in agemarr   {
		replace weight`var'=weight`var'*2 if year==1970
	}

	merge m:1 bpl using "stateunemp", nogenerate
	merge m:1 bpl using "baseline_meanrev", nogenerate
	foreach var in  employed labforce  worked_40   ihsinctot {
		cap g base`var'gender=base`var'male if male==1
		replace base`var'gender=base`var'female if female==1
	}
	
	save "replicationdata", replace
