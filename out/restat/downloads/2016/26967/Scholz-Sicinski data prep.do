*Set environment
	version 12.1
	set maxvar 30000
	set more off

*Prepare the dataset
scalar RemakeData = 0

if RemakeData!=0 {

* Read in private dataset
	set maxvar 30000
	use "wls_priv_12_27.dta"
	wls2stata _all	//recodes negative codes to missing values
	sort idpriv

*Replace attractiveness variables with those suggested by the reviewers

	foreach var of varlist numreports-normscore12 {
		rename `var' old_`var'
	}

	merge 1:1 idpriv using "standardized-beauty.dta",gen(_merge_beau) update replace
	keep if _merge_beau==3

	merge 1:1 idpriv using "standardized-beauty-by-coder-gender.dta",gen(_merge_coder)
	keep if _merge_coder==3

*Add school identifier that is not part of the release
	merge 1:1 idpriv using "schoolid.dta",gen(_merge_schoolid)
	keep if _merge_schoolid==3

*Save final dataset
	save "Scholz-Sicinski.dta",replace
}	//End remake data

use "Scholz-Sicinski.dta",clear

log using "Scholz-Sicinski data prep.log",replace

*****************************************************************
*			VARIABLE CONSTRUCTION			*
*****************************************************************

	egen iqscore=std(gwiiq_bm)
	gen female=sexrsp-1
	clonevar hsrank=hsrscorq

	egen bsamp1=group(schoolid) if attrnd==0
	egen bsamp2=group(schoolid) if attrnd==1

* Beauty measure
	drop if numreports<11	//drop if incomplete coding

	egen zbm=std(meanrat) if female==0
	egen zbeautyf=std(meanrat) if female==1
	replace zbeautyf=zbm if female==0

	egen mzbm=std(meanrat_mcoder) if female==0
	egen mbeautyf=std(meanrat_mcoder) if female==1
	replace mbeautyf=mzbm if female==0

	egen fzbm=std(meanrat_fcoder) if female==0
	egen fbeautyf=std(meanrat_fcoder) if female==1
	replace fbeautyf=fzbm if female==0

	foreach bmeasure of varlist zbeautyf mbeautyf fbeautyf {
		gen `bmeasure'sq=`bmeasure'*`bmeasure'
		xtile `bmeasure'int=`bmeasure', nq(4)
	}

* Height
	gen height= mx010rec/100
	replace height=. if height>83
	replace height=. if height<48
	egen zheight=std(height) if female==0
	egen zfheight=std(height) if female==1
	replace zheight=zfheight if female==1

* Health
	clonevar health=mx001rer

	clonevar ohealth=health
	replace ohealth=2 if health==1
	clonevar ihealth=ohealth
	replace ihealth=3 if ohealth==2

	gen h5=ihealth==5
	gen h4=ihealth==4
	gen h3=ihealth==3
	foreach var of varlist h3 h4 h5 {
		replace `var'=. if health>=.
	}

*********************************
*	FAMILY BACKGROUND	*
*********************************
	clonevar mothed=bmmaedu
	replace mothed=5 if mothed<5
	replace mothed=16 if mothed>16 & mothed<.

	clonevar fathed=bmfaedu
	replace fathed=4 if fathed<4
	replace fathed=17 if fathed>16 & fathed<.

	clonevar pinc57=bmpin1
	replace pinc57=log(pinc57)

	gen fullhh=2-bklvpr
	gen momemployed=2-wrmo57
	gen momhead=bkhs57==2
	gen fathdead=0
	replace fathdead=1 if re064fab<54

*parents in professional/executive job
	gen fathproex=ocf57==5
	gen fathproman=(ocf157==7 | ocf157==8)
	gen mothproman=(ocm157==7 | ocm157==8)

*farm background;
	gen farmbg=0
	replace farmbg=1 if ocf357==2 | ocf357==3 | ocmh57u==16

*race
	gen minority=0
	replace minority =1 if natfth==35 | natfth==36 | natfth==41
	replace minority =1 if ge095ma==35 | ge095ma==36 | ge095ma==41

*geographic
	gen ipop57=1 if pop57==2 | pop57==3 | pop57==4
	replace ipop57=2 if pop57==5 | pop57==6 | pop57==7
	replace ipop57=3 if pop57==8 | pop57==9 
	replace ipop57=. if pop57>=. 

	gen pop74=spl100/1000
	gen pop92=ra025re/100000

	gen outwis74=st75g==50
	replace outwis74=1-outwis74
	gen outwis92=ra020re==50
	replace outwis92=1-outwis92

*************************
*	Personality	*
*************************
	clonevar extraver92m=mh001rec
	replace extraver92m=. if mh002re!=6

	clonevar agreeable92m=mh009rec
	replace agreeable92m=. if mh010re!=6

	clonevar conscientious92m=mh017rec
	replace conscientious92m=. if mh018re!=6

	clonevar neurotic92m=mh025rec
	replace neurotic92m=. if mh026re!=5

	clonevar open92m=mh032rec
	replace open92m=. if mh033re!=6

	clonevar selfacc92m=mn046rei
	replace selfacc92m=. if mn047re<6

	clonevar purplife92m=mn037rei
	replace purplife92m=. if mn038re<6

*************************
*	EDCUATION	*
*************************
	clonevar educ04=gb103red
	clonevar educ92=rb003red
	clonevar educ74=edeqyr
	clonevar ivocat74=vteqyr

	foreach eduyrs in educ74 educ92 educ04 {
		gen i`eduyrs'=.
		qui replace i`eduyrs'=4 if `eduyrs'<.
		qui replace i`eduyrs'=3 if `eduyrs'<=16
		qui replace i`eduyrs'=2 if `eduyrs'<=15
		qui replace i`eduyrs'=1 if `eduyrs'<=12
	}

*************************
*	 INCOME		*
*************************

*Wages 75
	gen wagesal74=yrwg74*2.85*100
	gen lwage74=log(wagesal74)

	gen zerowage74=0
	replace zerowage74=1 if yrwg74==0

	gen businc74=yrse74*2.85*100

*Wages 92
	gen wagesal92=rp001re
	replace wagesal92=. if rp001re==9999999
	gen lwage92=ln(wagesal92)

	gen zerowage92=0
	replace zerowage92=1 if rp001re==0

	gen businc92=rp003red

*****************************************
*	LABOR FORCE PARTICIPATION	*
*****************************************

* First job measure {74, updated in 92} 
	gen exp74fj=(1900+cmjx1b/12)
	replace exp74fj=1957 if cmjx1b<684
	replace exp74fj=1975-exp74fj
	replace exp74fj=0 if cmjx1b==.i | exp74fj<0

* Not known out of labor force measure {74}
	gen exp74lf=(cmint-690)/12
	replace exp74lf=exp74lf*newexper/1000

* My best measure of 74 experience (min of the two)
	gen exp74=min(exp74fj,exp74lf)
	gen expsq74=exp74^2

	gen exp92=exp74+rf008jsd
	replace exp92=exp74 if rf001js==1
	gen expsq92=exp92^2

	gen exp04=exp74+gf022jsd
	gen expsq04=exp04^2

* Labor force status
	gen selfemp74=0
	replace selfemp74=1 if cwxcuru==3 | cwxcuru==4 | cwxcuru==5
	replace selfemp74=. if cwxcuru==.

	gen selfemp92=0
	replace selfemp92=1 if rfu07jce==3 | rfu07jce==4 | rfu07jce==5
	replace selfemp92=. if rfu07jce==.

* Refine the self-employed indicators (current job most likely not main job)
	gen sesuspect74=0
	replace sesuspect74=1 if businc74 > wagesal74 & businc74>0 & businc74 <. & selfemp74==0 & selfemp92 ==1
	replace selfemp74=1 if sesuspect74==1

	gen sesuspect92=0
	replace sesuspect92=1 if businc92 > wagesal92 & businc92>0 & businc92 <. & selfemp92 ==0 & selfemp74==1
	replace selfemp92=1 if sesuspect92==1


*************************
*	  MARRIAGE	*
*************************
	gen mar74=mrstat-1
	replace mar74=0 if mrstat~=2 & mrstat<.
	gen mar92=rc001re
	replace mar92=0 if rc001re>1 & rc001re<.

	clonevar nummar74=marno
	clonevar nummar92=rc003re
	gen nummar7592=nummar92-nummar74 

*********************************
*	JOB CHARACTERISTICS	*
*********************************
	gen tenure74=newten/12
	gen tenure92=rf054jce/10

	gen union74=0
	replace union74=1 if sopar2==1 | sopar2==2
	replace union74=1 if rf023j1c==1
	gen union92=2-rf023jcc
	replace union92=0 if union92==.

	gen plantsize92=5
	replace plantsize92=17.5 if rg025jjc==2
	replace plantsize92=38 if rg025jjc==3
	replace plantsize92=76 if rg025jjc==4
	replace plantsize92=300 if rg025jjc==5
	replace plantsize92=750 if rg025jjc==6
	replace plantsize92=. if rg025jjc>=.
	replace plantsize92=plantsize92/100

*Industry 
	clonevar ind74=inmxcru
	clonevar ind92=rfu35jcf

*Occupation
	gen occ74=.
	replace occ74=1 if ocmxcru==1 | ocmxcru==2
	replace occ74=2 if ocmxcru==3 | ocmxcru==4
	replace occ74=3 if ocmxcru==5 | ocmxcru==6
	replace occ74=4 if ocmxcru==7 
	replace occ74=5 if ocmxcru==8 | ocmxcru==9 | ocmxcru==10 
	replace occ74=6 if ocmxcru==11 | ocmxcru==12
	replace occ74=7 if ocmxcru==13 
	replace occ74=8 if ocmxcru==14 | ocmxcru==15 |ocmxcru==16 | ocmxcru==17 

	gen occ92=.
	replace occ92=1 if rfu36jcf==1 | rfu36jcf==2
	replace occ92=2 if rfu36jcf==3 | rfu36jcf==4
	replace occ92=3 if rfu36jcf==5 | rfu36jcf==6
	replace occ92=4 if rfu36jcf==7 
	replace occ92=5 if rfu36jcf==8 | rfu36jcf==9 | rfu36jcf==10 
	replace occ92=6 if rfu36jcf==11 | rfu36jcf==12
	replace occ92=7 if rfu36jcf==13 
	replace occ92=8 if rfu36jcf==14 | rfu36jcf==15 |rfu36jcf==16 | rfu36jcf==17 

	clonevar numempls92=rf005jsc
	replace numempls92=. if rf005jsc==0

*********************************
*	  SIBLING INFO		*
*********************************
	clonevar sibsnum=sibstt

*********************************
*	EXCLUSION SETS		*
*********************************

*racial minority
	tab natfth if natfth==35 | natfth==36 | natfth==41
	drop if minority==1

*sample attrition
	gen nonresp=0
	replace nonresp=1 if stat75>1 & stat92p>1
	tab nonresp
	tab stat92m

*Drop income outliers
	xtile cw74f=lwage74 if female==1, nq(100)
	xtile cw74m=lwage74 if female==0, nq(100)

	xtile cw92f=lwage92 if female==1, nq(100)
	xtile cw92m=lwage92 if female==0, nq(100)

	replace lwage74=. if cw74f<=2 | cw74f==99 | cw74f==100
	replace lwage74=. if cw74m<=2 | cw74m==99 | cw74m==100

	replace lwage92=. if cw92f<=2 | cw92f==99 | cw92f==100
	replace lwage92=. if cw92m<=2 | cw92m==99 | cw92m==100


*************************
*	  LABELS	*
*************************

la define educdummy 0 "HS Dropout" 1 "High school" 2 "Some college" 3 "BA" 4 "MA and beyond"
	la var ieduc74 "Education '74"
	la val ieduc74 educdummy
	la var ieduc92 "Education '92"
	la val ieduc92 educdummy

	la var zbeautyf "Beauty (standardized)"
	la var mbeautyf "Beauty, coder: m (std)"
	la var fbeautyf "Beauty, coder: f (std)"

la define gender 0 "Male" 1 "Female"
	la val female gender

la define ocup74 1 "Professional" 2 "Managers" 3 "Sales" 4 "Clerical" 5 "Craftsmen" 6 "Operatives" 7 "Service" 8 "Laborers and farmers"
	la val occ74 ocup74
	la val occ92 ocup74

log c

