********************************************************************************
******************  	Data Management - Intel Ratings		 	 ***************
******************		  --- motta018@umn.edu	---	 	  		  **************
********************************************************************************

clear
set seed 123456789
cd "WHERE YOU'VE KEPT ANES TIME SERIES FILES"
use "ANES 2012 TIME SERIES FILE"
cd "WORKING DIRECTORY"

svyset [pweight=weight_full], strata(strata_full) psu(psu_full)

********************************************************************************
* Data Management - Knowledge and Intelligence
********************************************************************************

label define yn 1 "Yes" 0 "No"
label define hl 1 "Highest" 0 "Lowest"

**************
* Pol Know.
***************

** Political Knowledge (General)

	/// Turn all knowledge questions into Right/Wrong dummies
	/// Number of Times POTUS can be Elected

	gen prestimes=.
		replace prestimes=1 if preknow_prestimes==2
		replace prestimes=0 if preknow_prestimes!=2 & preknow_prestimes>=0

	label define corrinc 1 "Correct" 0 "Not Correct"
	label values prestimes corrinc
	label variable prestimes "Number of times POTUS can be elected"

	/// Senate Term Length

	gen senterm=.
		replace senterm=1 if preknow_senterm==6
		replace senterm=0 if preknow_senterm!=6 & preknow_senterm>=0

	label values senterm corrinc
	label variable senterm "Years Between Sen. Elections"

	/// Size of the Federal Deficit

	fre preknow_sizedef // correct = 1

		gen sizedef=.
			replace sizedef=1 if preknow_sizedef==1
			replace sizedef=0 if preknow_sizedef!=1 & preknow_sizedef>=0

	/// Knowledge About Medicare

		fre preknow_medicare // correct = 1 

		gen medicare=.
			replace medicare=1 if preknow_medicare==1
			replace medicare=0 if preknow_medicare!=1 & preknow_medicare>=0
			
	/// Know what GOVT Spends Least Amount of $$ On

	fre preknow_leastsp // correct = 1

		gen leastsp=.
			replace leastsp=1 if preknow_leastsp==1
			replace leastsp=0 if preknow_leastsp!=1 & preknow_medicare>=0

label values sizedef medicare leastsp corrinc

	/// Index

alpha prestimes senterm sizedef medicare leastsp, gen(knowcount) item
	label variable knowcount "Political Knowledge Score"
	label values knowcount hl
	fre knowcount

****************		
** Intelligence
****************

// Set B

fre wordsum_setb
replace wordsum_setb=. if wordsum_setb<0
	gen bcorrect=.
		replace bcorrect=1 if wordsum_setb==5
		replace bcorrect=0 if wordsum_setb!=5 & wordsum_setb!=.
	label values bcorrect corrinc
	fre bcorrect

// Set D

fre wordsum_setd
replace wordsum_setd=. if wordsum_setd<0
	gen dcorrect=.
		replace dcorrect=1 if wordsum_setd==3
		replace dcorrect=0 if wordsum_setd!=3 & wordsum_setd!=.
	label values dcorrect corrinc
	fre dcorrect

// Set E

fre wordsum_sete
replace wordsum_sete=. if wordsum_sete<0
	gen ecorrect=.
		replace ecorrect=1 if wordsum_sete==1
		replace ecorrect=0 if wordsum_sete!=1 & wordsum_sete!=.
	label values ecorrect corrinc
	fre ecorrect

// Set F

fre wordsum_setf
replace wordsum_setf=. if wordsum_setf<0
	gen fcorrect=.
		replace fcorrect=1 if wordsum_setf==3
		replace fcorrect=0 if wordsum_setf!=3 & wordsum_setf!=.
	label values fcorrect corrinc
	fre fcorrect

// Set G

fre wordsum_setg
replace wordsum_setg=. if wordsum_setg<0
	gen gcorrect=.
		replace gcorrect=1 if wordsum_setg==5
		replace gcorrect=0 if wordsum_setg!=5 & wordsum_setg!=.
	label values gcorrect corrinc
	fre gcorrect

// Set H

fre wordsum_seth
replace wordsum_seth=. if wordsum_seth<0
	gen hcorrect=.
		replace hcorrect=1 if wordsum_seth==4
		replace hcorrect=0 if wordsum_seth!=4 & wordsum_seth!=.
	label values hcorrect corrinc
	fre hcorrect

// Set J

fre wordsum_setj
replace wordsum_setj=. if wordsum_setj<0
	gen jcorrect=.
		replace jcorrect=1 if wordsum_setj==1
		replace jcorrect=0 if wordsum_setj!=1 & wordsum_setj!=.
	label values jcorrect corrinc
	fre jcorrect


// Set K 

fre wordsum_setk
replace wordsum_setk=. if wordsum_setk<0
	gen kcorrect=.
		replace kcorrect=1 if wordsum_setk==1
		replace kcorrect=0 if wordsum_setk!=1 & wordsum_setk!=.
	label values kcorrect corrinc
	fre kcorrect

// Set L

fre wordsum_setl
replace wordsum_setl=. if wordsum_setl<0
	gen lcorrect=.
		replace lcorrect=1 if wordsum_setl==4
		replace lcorrect=0 if wordsum_setl!=4 & wordsum_setl!=.
	label values lcorrect corrinc
	fre lcorrect

// Set O

fre wordsum_seto
replace wordsum_seto=. if wordsum_seto<0
	gen ocorrect=.
		replace ocorrect=1 if wordsum_seto==2
		replace ocorrect=0 if wordsum_seto!=2 & wordsum_seto!=.
	label values ocorrect corrinc
	fre ocorrect

// Intelligence Index

alpha bcorrect dcorrect ecorrect fcorrect gcorrect ///
	hcorrect jcorrect kcorrect lcorrect ocorrect, item gen(intelligence)


**********************
* Interviewer Ratings
**********************

/// Interviewer Intelligence Ratings

** Pre Intelligence Rating

gen intel_pre=iwrobspre_intell if iwrobspre_intell>0
	recode intel_pre (1=4) (2=3) (3=2) (4=1) (5=0)
	replace intel_pre=intel_pre/4
	label values intel_pre hl
	label variable intel_pre "PRE: Interviewer's Rate of R's Intelligence"
	fre intel_pre

** Post Intelligence Rating

gen intel_post=iwrobspost_intell if iwrobspost_intell>0
	recode intel_post (1=4) (2=3) (3=2) (4=1) (5=0)
	replace intel_post=intel_post/4
	label values intel_post hl
	label variable intel_post "POST: Interviewer's Rate of R's Intelligence"
	fre intel_post
	
	
/// Interviewer Knowledge Ratings 

** Pre Information Rating

gen info_pre=iwrobspre_levinfo if iwrobspre_levinfo>0
	recode info_pre (1=4) (2=3) (3=2) (4=1) (5=0)
	replace info_pre=info_pre/4
	label values info_pre hl
	label variable info_pre "PRE: Interviewer's Rate of R's Information"
	fre info_pre
	
** Post Information Rating

gen info_post=iwrobspost_levinfo if iwrobspost_levinfo>0
	recode info_post (1=4) (2=3) (3=2) (4=1) (5=0)
	replace info_post=info_post/4
	label values info_post hl
	label variable info_post "POST: Interviewer's Rate of R's Information"
	fre info_post

	
********************************************************************************
* Data Management - Controls
********************************************************************************

/// Party ID

replace pid_x=. if pid_x<0

gen democrat=.
	replace democrat=1 if pid_x==1 | pid_x==2 | pid_x==3
	replace democrat=0 if pid_x>=4 & pid_x!=.
	label values democrat yn
	label variable democrat "R is a Democrat?"
fre democrat

gen gop=.
	replace gop=1 if pid_x==5 | pid_x==6 | pid_x==7
	replace gop=0 if pid_x<=4 & pid_x!=.
	label values gop yn
	label variable gop "R is a Republican?"
fre gop

/// PID Strength

gen strength=(pid_x-4)
	replace strength=abs(strength)
	replace strength=strength/3
	label values strength hl
	label variable strength "Strength of PID"
fre strength


/// Income

replace incgroup_prepost_x=. if incgroup_prepost_x<0

gen income=incgroup_prepost_x
	replace income=(income-1)/27
	label values income hl
	label variable income "Household Income"
fre income
	

/// Education

replace dem_edugroup_x=. if dem_edugroup_x<0

gen college=.
	replace college=1 if dem_edugroup_x>=4
	replace college=0 if dem_edugroup_x<4 & dem_edugroup_x!=.
	label values college yn
	label variable college "R has College Degree?"
fre college

/// Ideology

gen conservatism=(libcpre_self-1)/6 if libcpre_self>0
	label define conserv 1 "Ex Conservative" 0 "Ex Liberal"
	label values conservatism conserv
	label variable conservatism "R's Ideology"
fre conservatism
	
/// Gender

gen female=.
	replace female=1 if gender_respondent_x==2
	replace female=0 if gender_respondent_x==1
	label values female yn
	label variable female "R is Female?"
fre female

/// Age

replace dem_age_r_x=. if dem_age_r_x<0

gen age=(dem_age_r_x-17)/(90-17)
	label values age hl
	label variable age "R's Age"
fre age

/// Campaign Media Use

** Different media: mediapo_tv mediapo_radio mediapo_nwsprev 
	// mediapo_net mediapo_site
	
gen tvuse=.
	replace tvuse=0 if mediapo_tvamt==-1
	replace tvuse=1 if mediapo_tvamt==3
	replace tvuse=2 if mediapo_tvamt==2
	replace tvuse=3 if mediapo_tvamt==1
	replace tvuse=tvuse/3
	label values tvuse hl
	label variable tvuse "R Followed Campaign on TV?"
fre tvuse

gen radiouse=.
	replace radiouse=0 if mediapo_radioamt==-1
	replace radiouse=1 if mediapo_radioamt==3
	replace radiouse=2 if mediapo_radioamt==2
	replace radiouse=3 if mediapo_radioamt==1
	replace radiouse=radiouse/3
	label values radiouse hl
	label variable radiouse "R Followed Campaign on Radio?"
fre radiouse


gen newspaperuse=.
	replace newspaperuse=0 if mediapo_nwsprevamt==-1
	replace newspaperuse=1 if mediapo_nwsprevamt==3
	replace newspaperuse=2 if mediapo_nwsprevamt==2
	replace newspaperuse=3 if mediapo_nwsprevamt==1
	replace newspaperuse=newspaperuse/3
	label values newspaperuse hl
	label variable newspaperuse "R Followed Campaign on Radio?"
fre newspaperuse


gen internetuse=.
	replace internetuse=0 if mediapo_netamt==-1
	replace internetuse=1 if mediapo_netamt==3
	replace internetuse=2 if mediapo_netamt==2
	replace internetuse=3 if mediapo_netamt==1
	replace internetuse=internetuse/3
	label values internetuse hl
	label variable internetuse "R Followed Campaign on Web?"
fre internetuse

gen siteuse=.
	replace siteuse=0 if mediapo_siteamt==-1
	replace siteuse=1 if mediapo_siteamt==3
	replace siteuse=2 if mediapo_siteamt==2
	replace siteuse=3 if mediapo_siteamt==1
	replace siteuse=siteuse/3
	label values siteuse hl
	label variable siteuse "R Followed Campaign on Web?"
fre siteuse

// An Index of all Five

alpha tvuse radiouse newspaperuse internetuse siteuse, item gen(campmediaindex)
	label variable campmediaindex "Total Attention to Camp. Across Media"
	kdensity campmediaindex, scheme(s1mono) bwidth(0.1)
	

// Interest in Politics & Elections

gen polinterest=.
	replace polinterest=interest_attention if interest_attention>0
	recode polinterest (1=5) (2=4) (3=3) (4=2) (5=1)
	replace polinterest=(polinterest-1)/4
	label variable polinterest "R Pays Attn to Politics & Elections?"
	label values polinterest hl
fre polinterest

// Presidential Vote Choice

gen obamavote=.
	replace obamavote=1 if presvote2012_x==1
	replace obamavote=0 if presvote2012_x==2 | presvote2012_x==5
	label values obamavote yn
	label variable obamavote "R Voted for Obama?"
	fre obamavote


// TIPI

fre tipi_extra tipi_crit tipi_dep tipi_anx tipi_open ///
    tipi_resv tipi_warm tipi_disorg tipi_calm tipi_conv
   
replace tipi_extra=. if tipi_extra<0
replace tipi_crit=. if tipi_crit<0
	recode tipi_crit (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7)
replace tipi_dep=. if tipi_dep<0
replace tipi_anx=. if tipi_anx<0
replace tipi_open=. if tipi_open<0
replace tipi_resv=. if tipi_resv<0
	recode tipi_resv (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7)
replace tipi_warm=. if tipi_warm<0
replace tipi_disorg=. if tipi_disorg<0
	recode tipi_disorg (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7)
replace tipi_calm=. if tipi_calm<0
	recode tipi_calm (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7)
replace tipi_conv=. if tipi_conv<0
	recode tipi_conv (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7)


alpha tipi_extra tipi_resv, item gen(extra)
	replace extra=(extra-1)/6
	label values extra hl
alpha tipi_crit tipi_warm, item gen(agree)
	replace agree=(agree-1)/6
	label values agree hl
alpha tipi_dep tipi_disorg, item gen(consci)
	replace consci=(consci-1)/6
	label values consci hl
alpha tipi_anx tipi_calm, item gen(neuro)
	replace neuro=(neuro-1)/6
	label values neuro hl
alpha tipi_open tipi_conv, item gen(open)
	replace open=(open-1)/6
	label values open hl

alpha tipi_extra tipi_resv, item  // extra
alpha tipi_crit tipi_warm, item // agree
alpha tipi_dep tipi_disorg, item // consci
alpha tipi_anx tipi_calm, item // neuro
alpha tipi_open tipi_conv, item // open

// Need to Evaluate

gen ne=cog_opin_x if cog_opin_x>0
	replace ne=(ne-1)/4
	label values ne hl
	label variable ne "Need to Evaluate"
fre ne


// Authoritarianism


fre auth_ind auth_cur auth_obed auth_consid
	replace auth_ind=. if auth_ind<0
	replace auth_cur=. if auth_cur<0
	replace auth_obed=. if auth_obed<0
	replace auth_consid=. if auth_consid<0
	
	
	gen auth_ind1=auth_ind // Both = 0.5, 1 = Most Auth
		recode auth_ind1 (2=1) (1=0) (3=0.5)
	gen auth_cur1=auth_cur
		recode auth_cur1 (2=1) (2=0) (3=0.5)
	gen auth_obed1=auth_obed 
		recode auth_obed1 (1=1) (2=0) (3=0.5)
	gen auth_consid1=auth_consid
		recode auth_consid1 (2=1) (1=0) (3=0.5)
	
alpha auth_ind1 auth_cur1 auth_obed1 auth_consid1, item gen(author)
	replace author=(author-0.125)/(1.25-0.125)
	label variable author "Authoritarianism"
	label values author hl
fre author
	
// Race

gen black=.
	replace black=1 if dem_raceeth_x==2
	replace black=0 if dem_raceeth_x==1 | dem_raceeth_x==3 | dem_raceeth_x==4
	label variable black "R is Black?"
	label values black yn
fre black
	
gen hisp=.
	replace hisp=1 if dem_raceeth_x==3
	replace hisp=0 if dem_raceeth_x==1 | dem_raceeth_x==2 | dem_raceeth_x==4
	label variable hisp "R is Hispanic?"
	label values hisp yn
fre hisp

gen white=.
	replace white=1 if dem_raceeth_x==1
	replace white=0 if dem_raceeth_x>1 & dem_raceeth_x!=.
	label variable white "R is White?"
	label values white yn
fre white


/// Mode of Survey

gen online=.
	replace online=1 if mode==2
	replace online=0 if mode==1
	label values online yn
	label variable online "R Took ANES Online?"
fre online

