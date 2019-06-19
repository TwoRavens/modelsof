clear
set more off
*set mem 200m
capture log close
log using "c:\beth\ipria\projects\patent granting\type12-hausman.smcl", replace
/*********************************************************************************************/
/* This do file identifying grant threshold by minimising the prediction error with respect to
   the estimated probabilities of making incorrect grant and making incorrect reject as estimated
   using Hausman et al.'s (1998) method.

   04-08-2008: Add MNL model
   04-10-2008: Add P(Type1) and P(type2) models, and skip the MNL model

normalize years to 1990 as year 1  ie replace decideyr=1 if decideyr==1990
*/
/*********************************************************************************************/
set more off

/* Prepare the pooled data */
/**** JPO ****************************************************************/
use "s:\micro\transfer\patgrant\jpo-nonPCT.dta", clear

* use only rejected and granted applications at both EPO & JPO *
keep if epoappstat==4 | epoappstat==6
keep if jpoappstat==10 | jpoappstat==6 | jpoappstat==9
* merge in rexp
sort usost
merge usost using "S:\micro\Transfer\patgrant\type12error\restat\rexp.dta", nokeep
drop _merge
gen rexp=.
replace rexp=jprexp 
gen locjpcite=0
replace locjpcite=citeratioost if localinv==1
gen forjpcite=0
replace forjpcite=citeratioost if localinv==0
replace jpopastapp=jpopastapp/1000
gen grant=.
replace grant=0 if jpostat==3
replace grant=1 if jpostat==4
gen appeal=0
replace appeal=1 if  jpoappealnum~=""
rename locjpcite loccite
rename forjpcite forcite
gen locjprra=0
replace locjprra=jprra if localinv==1
rename locjprra locrra
rename jpopastapp pastapp
gen office=1
/* biotechnology */
gen biotech = 0
replace biotech=1 if ipc4=="A01H" & index(ipcsub,"1/00")
replace biotech=1 if ipc4=="A01H" & index(ipcsub,"4/00")
replace biotech=1 if ipc4=="A61K" & index(ipcsub,"38/00")
replace biotech=1 if ipc4=="A61K" & index(ipcsub,"39/00")
replace biotech=1 if ipc4=="A61K" & index(ipcsub,"48/00")
replace biotech=1 if ipc4=="C02F" & index(ipcsub,"3/34")
replace biotech=1 if ipc4=="C07G" & index(ipcsub,"11/00")
replace biotech=1 if ipc4=="C07G" & index(ipcsub,"13/00")
replace biotech=1 if ipc4=="C07G" & index(ipcsub,"15/00")
replace biotech=1 if ipc4=="C12M"
replace biotech=1 if ipc4=="C12N"
replace biotech=1 if ipc4=="C12P"
replace biotech=1 if ipc4=="C12Q"
replace biotech=1 if ipc4=="C12S"
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"27/327")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/53")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/54")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/55")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/57")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/68")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/74")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/76")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/78")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/88")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/92")
replace biotech=. if ipc4==""
/* ICT */
gen ict = 0
replace ict=1 if index(ipc4,"G06") /*computing, calculating, & counting*/
replace ict=1 if index(ipc4,"G11") /*information storage*/
replace ict=1 if index(ipc4,"H04") /*electric communication technique*/
replace ict=. if ipc4==""
/* Software (see Graham & Mowery 2002) */
gen software = 0
replace software = 1 if ipc4=="G06F" & index(ipcsub,"3/") & !index(ipcsub,"153/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"5/") & !index(ipcsub,"165/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"7/") & !index(ipcsub,"17/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"9/") & !index(ipcsub,"19/") & !index(ipcsub,"159/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"11/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"12/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"13/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"15/")
replace software = 1 if ipc4=="G06K" & index(ipcsub,"9/") & !index(ipcsub,"19/")
replace software = 1 if ipc4=="G06K" & index(ipcsub,"15/")
replace software = 1 if ipc4=="H04L" & index(ipcsub,"9/")& !index(ipcsub,"29/")
replace software = . if ipc4==""
gen automobile=0
replace automobile=1 if subcat==53 | subcat==55
/* six technology group dummies */
tabulate cat, gen(catdummy)
rename catdummy1 chem
rename catdummy2 comp
rename catdummy3 drug
rename catdummy4 elec
rename catdummy5 mech
replace mech = 0 if automobile==1
replace drug = 0 if biotech==1
replace comp = 0 if software==1|ict==1
replace ict = 0 if software==1
gen speed = 10.65343 if epoost1==1       
replace speed = 10.58167 if epoost1==2       
replace speed = 8.722228 if epoost1==3       
replace speed = 11.94605 if epoost1==4       
replace speed = 11.51499 if epoost1==5       
replace speed = 13.04555 if epoost1==6       
replace speed = 9.2423 if epoost1==7       
replace speed = 6.454053 if epoost1==8       
replace speed = 5.995874 if epoost1==9       
replace speed = 8.857937 if epoost1==10       
replace speed = 5.825318 if epoost1==11       
replace speed = 10.19043 if epoost1==12       
replace speed = 9.680638 if epoost1==13       
replace speed = 9.164793 if epoost1==14       
replace speed = 10.55724 if epoost1==15       
replace speed = 12.61668 if epoost1==16       
replace speed = 11.66225 if epoost1==17       
replace speed = 8.369942 if epoost1==18       
replace speed = 10.22834 if epoost1==19       
replace speed = 13.1257 if epoost1==20       
replace speed = 6.417716 if epoost1==21       
replace speed = 6.731305 if epoost1==22       
replace speed = 7.276257 if epoost1==23       
replace speed = 9.344931 if epoost1==24       
replace speed = 9.559062 if epoost1==25       
replace speed = 9.586847 if epoost1==26       
replace speed = 8.526317 if epoost1==27       
replace speed = 10.48982 if epoost1==28       
replace speed = 10.79298 if epoost1==29       
replace speed = 10.56769 if epoost1==30
replace claims=eponclaims if missing(claims)
egen claimsmy=mean(claims), by(applyyr)
egen claimsm=mean(claims) 
gen claimsnorm=claims*(claimsm/claimsmy)
gen requestlag=(jpoexamdate-jpofiledate)/30
gen examdur = (jpograntdate - jpoexamdate)/30
replace examdur = (jporejectdate - jpoexamdate)/30 if missing(examdur)
egen examdurmy=mean(examdur), by(applyyr)
egen examdurm=mean(examdur) 
gen examdurnorm=examdur*(examdurm/examdurmy)
sort patent
merge patent using "s:\micro\transfer\patgrant\type12error\stata\usptomfee\mfee_lstz1.dta", nokeep
tab _merge
drop _merge
replace expire=20 if expire==.
egen expireost=mean(expire), by(usost usinv gyear)
gen expireratioost = expire / expireost
sort patent
keep requestlag locrra epostat jpostat eopposed numinv asscode examdurnorm examdur mech drug comp speed biotech elec chem ict software automobile claimsnorm office patent grant appeal epostat expireratioost citeratioost granted  family_id loccite forcite localinv rexp rexp usinv othgr_early othrj_early usearly  pastapp  decideyr applyyr
save "c:\beth\ipria\projects\patent granting\jpotemp.dta", replace
keep patent jpostat
sort patent 
save "c:\beth\ipria\projects\patent granting\jpotemp2.dta", replace

/**** EPO ****************************************************************/
use "s:\micro\transfer\patgrant\epo-nonPCT.dta", clear

* use only rejected and granted applications at both EPO & JPO * 
keep if epoappstat==4 | epoappstat==6
keep if jpoappstat==10 | jpoappstat==6 | jpoappstat==9
* merge in rexp
sort usost
merge usost using "S:\micro\Transfer\patgrant\type12error\restat\rexp.dta", nokeep
drop _merge
gen rexp=.
replace rexp=eprexp 
gen locepcite=0
replace locepcite=citeratioost if localinv==1
gen forepcite=0
replace forepcite=citeratioost if localinv==0
replace epopastapp=epopastapp/1000
gen grant=.
replace grant=0 if epostat==3
replace grant=1 if epostat==4
gen appeal=0
replace appeal=1 if  epoappealnum~=.
rename locepcite loccite
rename forepcite forcite
gen loceprra=0
replace loceprra=eprra if localinv==1
rename loceprra locrra
rename epopastapp pastapp
gen office=0
/* biotechnology */
gen biotech = 0
replace biotech=1 if ipc4=="A01H" & index(ipcsub,"1/00")
replace biotech=1 if ipc4=="A01H" & index(ipcsub,"4/00")
replace biotech=1 if ipc4=="A61K" & index(ipcsub,"38/00")
replace biotech=1 if ipc4=="A61K" & index(ipcsub,"39/00")
replace biotech=1 if ipc4=="A61K" & index(ipcsub,"48/00")
replace biotech=1 if ipc4=="C02F" & index(ipcsub,"3/34")
replace biotech=1 if ipc4=="C07G" & index(ipcsub,"11/00")
replace biotech=1 if ipc4=="C07G" & index(ipcsub,"13/00")
replace biotech=1 if ipc4=="C07G" & index(ipcsub,"15/00")
replace biotech=1 if ipc4=="C12M"
replace biotech=1 if ipc4=="C12N"
replace biotech=1 if ipc4=="C12P"
replace biotech=1 if ipc4=="C12Q"
replace biotech=1 if ipc4=="C12S"
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"27/327")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/53")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/54")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/55")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/57")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/68")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/74")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/76")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/78")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/88")
replace biotech=1 if ipc4=="G01N" & index(ipcsub,"33/92")
replace biotech=. if ipc4==""
/* ICT */
gen ict = 0
replace ict=1 if index(ipc4,"G06") /*computing, calculating, & counting*/
replace ict=1 if index(ipc4,"G11") /*information storage*/
replace ict=1 if index(ipc4,"H04") /*electric communication technique*/
replace ict=. if ipc4==""
/* Software (see Graham & Mowery 2002) */
gen software = 0
replace software = 1 if ipc4=="G06F" & index(ipcsub,"3/") & !index(ipcsub,"153/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"5/") & !index(ipcsub,"165/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"7/") & !index(ipcsub,"17/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"9/") & !index(ipcsub,"19/") & !index(ipcsub,"159/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"11/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"12/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"13/")
replace software = 1 if ipc4=="G06F" & index(ipcsub,"15/")
replace software = 1 if ipc4=="G06K" & index(ipcsub,"9/") & !index(ipcsub,"19/")
replace software = 1 if ipc4=="G06K" & index(ipcsub,"15/")
replace software = 1 if ipc4=="H04L" & index(ipcsub,"9/")& !index(ipcsub,"29/")
replace software = . if ipc4==""
gen automobile=0
replace automobile=1 if subcat==53 | subcat==55
/* six technology group dummies */
tabulate cat, gen(catdummy)
rename catdummy1 chem
rename catdummy2 comp
rename catdummy3 drug
rename catdummy4 elec
rename catdummy5 mech
replace mech = 0 if automobile==1
replace drug = 0 if biotech==1
replace comp = 0 if software==1|ict==1
replace ict = 0 if software==1
gen speed = 10.65343 if epoost1==1       
replace speed = 10.58167 if epoost1==2       
replace speed = 8.722228 if epoost1==3       
replace speed = 11.94605 if epoost1==4       
replace speed = 11.51499 if epoost1==5       
replace speed = 13.04555 if epoost1==6       
replace speed = 9.2423 if epoost1==7       
replace speed = 6.454053 if epoost1==8       
replace speed = 5.995874 if epoost1==9       
replace speed = 8.857937 if epoost1==10       
replace speed = 5.825318 if epoost1==11       
replace speed = 10.19043 if epoost1==12       
replace speed = 9.680638 if epoost1==13       
replace speed = 9.164793 if epoost1==14       
replace speed = 10.55724 if epoost1==15       
replace speed = 12.61668 if epoost1==16       
replace speed = 11.66225 if epoost1==17       
replace speed = 8.369942 if epoost1==18       
replace speed = 10.22834 if epoost1==19       
replace speed = 13.1257 if epoost1==20       
replace speed = 6.417716 if epoost1==21       
replace speed = 6.731305 if epoost1==22       
replace speed = 7.276257 if epoost1==23       
replace speed = 9.344931 if epoost1==24       
replace speed = 9.559062 if epoost1==25       
replace speed = 9.586847 if epoost1==26       
replace speed = 8.526317 if epoost1==27       
replace speed = 10.48982 if epoost1==28       
replace speed = 10.79298 if epoost1==29       
replace speed = 10.56769 if epoost1==30       
replace claims=eponclaims if missing(claims)
egen claimsmy=mean(claims), by(applyyr)
egen claimsm=mean(claims) 
gen claimsnorm=claims*(claimsm/claimsmy)
gen requestlag=(epoexamdate-epofiledate)/30
gen examdur = (epograntdate - epoexamdate)/30
replace examdur = (eporejectdate - epoexamdate)/30 if missing(examdur)
egen examdurmy=mean(examdur), by(applyyr)
egen examdurm=mean(examdur) 
gen examdurnorm=examdur*(examdurm/examdurmy)
sort patent
merge patent using "s:\micro\transfer\patgrant\type12error\stata\usptomfee\mfee_lstz1.dta", nokeep
tab _merge
drop _merge
replace expire=20 if expire==.
egen expireost=mean(expire), by(usost usinv gyear)
gen expireratioost = expire / expireost
sort patent
keep requestlag locrra eponum epostat jpostat eopposed numinv asscode examdurnorm examdur mech drug comp speed biotech elec chem ict software automobile claimsnorm office patent grant appeal epostat expireratioost citeratioost granted  family_id loccite forcite localinv rexp  usinv othgr_early othrj_early usearly  pastapp  decideyr applyyr
save "c:\beth\ipria\projects\patent granting\epotemp.dta", replace
keep patent epostat
sort patent 
save "c:\beth\ipria\projects\patent granting\epotemp2.dta", replace

/**** Pooling ****************************************************************/
use "c:\beth\ipria\projects\patent granting\epotemp2.dta", clear
sort patent
merge patent using "c:\beth\ipria\projects\patent granting\jpotemp2.dta"
drop _merge

/* identify grant-grant and reject-reject status */
gen gg=0
replace gg=1 if jpostat==4 & epostat==4
label var gg "EPO grant - JPO grant"
gen rr=0
replace rr=1 if jpostat==3 & epostat==3
label var rr "EPO reject - JPO reject"
keep patent gg rr
sort patent
save "c:\beth\ipria\projects\patent granting\epojpotemp.dta", replace

use "c:\beth\ipria\projects\patent granting\jpotemp.dta", clear
merge patent using "c:\beth\ipria\projects\patent granting\epojpotemp.dta"
save "c:\beth\ipria\projects\patent granting\jpotemp3.dta", replace

use "c:\beth\ipria\projects\patent granting\epotemp.dta", clear
merge patent using "c:\beth\ipria\projects\patent granting\epojpotemp.dta"
save "c:\beth\ipria\projects\patent granting\epotemp3.dta", replace
append using "c:\beth\ipria\projects\patent granting\jpotemp3.dta"
sort patent
drop _merge
save "c:\beth\ipria\projects\patent granting\pooled_h.dta", replace

/**** Misclassification analysis ****************************************************************/
use "c:\beth\ipria\projects\patent granting\pooled_h.dta", clear
/* using the same samples through out */
keep if !missing(grant)
keep if !missing(office)
keep if !missing(citeratioost)
keep if !missing(expire)
keep if !missing(examdur)
keep if !missing(claims)
keep if !missing(speed)
keep if !missing(localinv)
keep if !missing(locrra)
keep if !missing(usinv)
keep if !missing(pastapp)
keep if !missing(mech) 
keep if !missing(drug)
keep if !missing(comp)
keep if !missing(speed)
keep if !missing(biotech)
keep if !missing(ict)
keep if !missing(software)
keep if !missing(automobile)
keep if !missing(decideyr)
keep if !missing(applyyr)
bysort patent: gen dup =cond(_N==1,0,1)
tab dup
drop if dup==0
drop dup
label define officelb 0 "EPO" 1 "JPO"
label value office officelb

/* probability of grant based on the estimated patentability index obtained using Hausman et al.'s method */
gen p = normal(1.39788 + (0.10319*citeratioost))
summarize p, detail
gen trueg=.
gen pthres=.
gen truepthres=.
gen res=.
gen minssr=.
gen ssr=.
gen a0=0
gen a1=0
forvalues i = 0(0.01)1 {
	quietly: replace trueg=.
	quietly: replace pthres = `i'
	quietly: replace trueg = 1 if p>=pthres
	quietly: replace trueg = 0 if p<pthres
        quietly: replace a0=1 if trueg==0 & grant==1
        quietly: replace a1=0 if trueg==1 & grant==0
        quietly: egen pra0=sum(a0)
        quietly: replace pra0 = pra0/_N
        quietly: egen pra1=sum(a1)
        quietly: replace pra1 = pra1/_N
	*quietly: replace res=(pra0-0.09786)^2 + (pra1-0.06100)^2
	quietly: replace res=((pra0-0.09786) + (pra1-0.06100))^2
	drop ssr
	quietly: egen ssr=sum(res) 
	quietly: replace minssr=ssr if minssr>ssr
	quietly: replace truepthres = pthres if minssr==ssr
        *di "p* " i " Pr(ao) " pra0 " Pr(a1) " pra1 " Error " ssr " Error " minssr
        quietly: replace a0=0
        quietly: replace a1=0
        drop pra0
        drop pra1
}
summ truepthres, detail
replace trueg=0
replace trueg=1 if p>=truepthres & !missing(p)
tab trueg grant

quietly: replace a0=0
quietly: replace a1=0
quietly: replace a0=1 if trueg==0 & grant==1
quietly: replace a1=1 if trueg==1 & grant==0
quietly: egen pra0=sum(a0)
quietly: replace pra0 = pra0/_N
quietly: egen pra1=sum(a1)
quietly: replace pra1 = pra1/_N

summarize pra0 pra1

/* false result */
gen falseresult=0 if (trueg==1 & grant==1) | (trueg==0 & grant==0)
replace falseresult=1 if trueg==0 & grant==1
replace falseresult=1 if trueg==1 & grant==0
tab falseresult office

/* false negative wrt true reject */
gen falsereject=0 if trueg==1 
replace falsereject=1 if trueg==1 & grant==0
tab falsereject office

/* false positive wrt correct positive */
gen falsegrant=0 if trueg==0 
replace falsegrant=1 if trueg==0 & grant==1
tab falsegrant office

gen lexamdur = log(examdur)
gen lclaims = log(claims)

/* Table 4 in paper */

mvencode falsereject falsegrant , mv(0) o

tab falsereject if grant==0 & falsereject==0 & office==0
tab falsereject if grant==0 & falsereject==1 & office==0
tab falsereject if grant==0 & office==0

tab falsegrant if grant==1 & falsegrant==1 & office==0
tab falsegrant if grant==1 & falsegrant==0 & office==0
tab falsegrant if grant==1 & office==0

tab falsereject if grant==0 & falsereject==0 & office==1
tab falsereject if grant==0 & falsereject==1 & office==1
tab falsereject if grant==0 & office==1

tab falsegrant if grant==1 & falsegrant==1 & office==1
tab falsegrant if grant==1 & falsegrant==0 & office==1
tab falsegrant if grant==1 & office==1


/* Characterise errors */
bysort falseresult: summarize examdur claims speed eopposed numinv applyyr mech drug comp biotech ict software automobile
bysort falsereject: summarize examdur claims speed eopposed numinv applyyr mech drug comp biotech ict software automobile
bysort falsegrant: summarize examdur claims speed eopposed numinv applyyr mech drug comp biotech ict software automobile
summarize rexp examdur claims speed eopposed numinv applyyr mech drug comp biotech ict software automobile

sort patent
save "c:\beth\ipria\projects\patent granting\error_h.dta", replace

/* Probability of Error */
use "c:\beth\ipria\projects\patent granting\error_h.dta", clear
gen techspeed = 1/speed
label var techspeed "inverse of speed"
rename office jpooffice
label var jpooffice "=1 if JPO, 0 if EPO"
rename expireratioost uspatinforce
label var uspatinforce "Normalized number of years patent in force through renewal"
xi: logit falseresult jpooffice  examdur uspatinforce claimsnorm techspeed localinv rexp pastapp usinv mech drug chem elec comp biotech ict software automobile decideyr
mfx

/****************************************************/
display " *** IPC***"

foreach x in "biotech" "drug" "chem" "software" "ict" "comp" "elec" "automobile" "mech" {

	display " *** `x' versus other***"
	
	*hold IPC
	qui gen byte hold1=biotech
	qui gen byte hold2=drug
	qui gen byte hold3=chem
	qui gen byte hold4=software
	qui gen byte hold5=ict
	qui gen byte hold6=comp
	qui gen byte hold7=elec
	qui gen byte hold8=automobile
	qui gen byte hold9=mech

	*assume all patents are `x'
	qui replace biotech=0
	qui replace drug=0
	qui replace chem=0
	qui replace software=0
	qui replace ict=0
	qui replace comp=0
	qui replace elec=0
	qui replace automobile=0
	qui replace mech=0
	qui replace `x'=1

	*predict outcomes if all patents are `x'
	qui predict  pfalse if e(sample)

	*assume every one is other
	qui replace `x'=0
	qui predict  pfalse1 if e(sample)
	

	qui replace biotech=hold1
	qui replace drug=hold2
	qui replace chem=hold3
	qui replace software=hold4
	qui replace ict=hold5
	qui replace comp=hold6
	qui replace elec=hold7
	qui replace automobile=hold8
	qui replace mech=hold9
	drop hold1 hold2 hold3 hold4 hold5 hold6 hold7 hold8 hold8 hold9
	
	qui gen dfalseresult=(pfalse-pfalse1)

	format dfalseresult %4.3f

	sum pfalse pfalse1 dfalseresult, f 
	drop pfalse pfalse1 dfalseresult
}

* MARGINAL EFFECTS FOR CONTINUOUS VARIABLES - COMPARE +SD WITH -SD
foreach x in "examdur" "uspatinforce" "claimsnorm" "techspeed" "pastapp" "decideyr" "rexp" {
	display " *** `x' % change is (mean+sd) versus (mean-sd)***"
	capture drop mean1
	capture drop sd1
	qui egen mean1=mean(`x') if e(sample)
	qui egen sd1=sd(`x') if e(sample)

	*hold `x'
	qui gen hold=`x'

	*assume all patents are (mean+sd)
	qui replace `x'=mean1+sd1

	*predict outcomes if all patents are (mean+sd)
	qui predict  pfalse if e(sample)

	*assume every one is (mean-sd)
	qui replace `x'=mean1-sd1
	qui predict  pfalse1 if e(sample)

	*restore value
	qui replace `x'=hold
	drop hold

	qui sum pfalse pfalse1
	qui gen dfalseresult=(pfalse-pfalse1)
 
	format dfalseresult %4.3f
 
	sum pfalse pfalse1 dfalseresult, f 
	drop pfalse pfalse1 dfalseresult
}


/* Probability of Incorrect grant*/
xi: logit falsegrant jpooffice examdur uspatinforce claims techspeed localinv rexp pastapp usinv mech drug chem elec comp biotech ict software automobile decideyr
mfx

/****************************************************/
display " *** IPC***"

foreach x in "biotech" "drug" "chem" "software" "ict" "comp" "elec" "automobile" "mech" {

	display " *** `x' versus other***"
	
	*hold IPC
	qui gen byte hold1=biotech
	qui gen byte hold2=drug
	qui gen byte hold3=chem
	qui gen byte hold4=software
	qui gen byte hold5=ict
	qui gen byte hold6=comp
	qui gen byte hold7=elec
	qui gen byte hold8=automobile
	qui gen byte hold9=mech

	*assume all patents are `x'
	qui replace biotech=0
	qui replace drug=0
	qui replace chem=0
	qui replace software=0
	qui replace ict=0
	qui replace comp=0
	qui replace elec=0
	qui replace automobile=0
	qui replace mech=0
	qui replace `x'=1

	*predict outcomes if all patents are `x'
	qui predict  pfalse if e(sample)

	*assume every one is other
	qui replace `x'=0
	qui predict  pfalse1 if e(sample)
	

	qui replace biotech=hold1
	qui replace drug=hold2
	qui replace chem=hold3
	qui replace software=hold4
	qui replace ict=hold5
	qui replace comp=hold6
	qui replace elec=hold7
	qui replace automobile=hold8
	qui replace mech=hold9
	drop hold1 hold2 hold3 hold4 hold5 hold6 hold7 hold8 hold8 hold9
	
	qui gen dfalsegrant=(pfalse-pfalse1)

	format dfalsegrant %4.3f

	sum pfalse pfalse1 dfalsegrant, f 
	drop pfalse pfalse1 dfalsegrant
}

* MARGINAL EFFECTS FOR CONTINUOUS VARIABLES - COMPARE +SD WITH -SD
foreach x in "examdur" "uspatinforce" "claimsnorm" "techspeed" "pastapp" "decideyr" "rexp" {
	display " *** `x' % change is (mean+sd) versus (mean-sd)***"
	capture drop mean1
	capture drop sd1
	qui egen mean1=mean(`x') if e(sample)
	qui egen sd1=sd(`x') if e(sample)

	*hold `x'
	qui gen hold=`x'

	*assume all patents are (mean+sd)
	qui replace `x'=mean1+sd1

	*predict outcomes if all patents are (mean+sd)
	qui predict  pfalse if e(sample)

	*assume every one is (mean-sd)
	qui replace `x'=mean1-sd1
	qui predict  pfalse1 if e(sample)

	*restore value
	qui replace `x'=hold
	drop hold

	qui sum pfalse pfalse1
	qui gen dfalsegrant=(pfalse-pfalse1)
 
	format dfalsegrant %4.3f
 
	sum pfalse pfalse1 dfalsegrant, f 
	drop pfalse pfalse1 dfalsegrant
}


/* Probability of Incorrect reject */
xi: logit falsereject jpooffice examdur uspatinforce claims techspeed localinv rexp pastapp usinv mech drug chem elec comp biotech ict software automobile decideyr
mfx

/****************************************************/
display " *** IPC***"

foreach x in "biotech" "drug" "chem" "software" "ict" "comp" "elec" "automobile" "mech" {

	display " *** `x' versus other***" 
	
	*hold IPC
	qui gen byte hold1=biotech
	qui gen byte hold2=drug
	qui gen byte hold3=chem
	qui gen byte hold4=software
	qui gen byte hold5=ict
	qui gen byte hold6=comp
	qui gen byte hold7=elec
	qui gen byte hold8=automobile
	qui gen byte hold9=mech

	*assume all patents are `x'
	qui replace biotech=0
	qui replace drug=0
	qui replace chem=0
	qui replace software=0
	qui replace ict=0
	qui replace comp=0
	qui replace elec=0
	qui replace automobile=0
	qui replace mech=0
	qui replace `x'=1

	*predict outcomes if all patents are `x'
	qui predict  pfalse if e(sample)

	*assume every one is other
	qui replace `x'=0
	qui predict  pfalse1 if e(sample)
	

	qui replace biotech=hold1
	qui replace drug=hold2
	qui replace chem=hold3
	qui replace software=hold4
	qui replace ict=hold5
	qui replace comp=hold6
	qui replace elec=hold7
	qui replace automobile=hold8
	qui replace mech=hold9
	drop hold1 hold2 hold3 hold4 hold5 hold6 hold7 hold8 hold8 hold9
	
	qui gen dfalsereject=(pfalse-pfalse1)

	format dfalsereject %4.3f

	sum pfalse pfalse1 dfalsereject, f 
	drop pfalse pfalse1 dfalsereject
}

* MARGINAL EFFECTS FOR CONTINUOUS VARIABLES - COMPARE +SD WITH -SD
foreach x in "examdur" "uspatinforce" "claimsnorm" "techspeed" "pastapp" "decideyr" "rexp" {
	display " *** `x' % change is (mean+sd) versus (mean-sd)***"
	capture drop mean1
	capture drop sd1
	qui egen mean1=mean(`x') if e(sample)
	qui egen sd1=sd(`x') if e(sample)

	*hold `x'
	qui gen hold=`x'

	*assume all patents are (mean+sd)
	qui replace `x'=mean1+sd1

	*predict outcomes if all patents are (mean+sd)
	qui predict  pfalse if e(sample)

	*assume every one is (mean-sd)
	qui replace `x'=mean1-sd1
	qui predict  pfalse1 if e(sample)

	*restore value
	qui replace `x'=hold
	drop hold

	qui sum pfalse pfalse1
	qui gen dfalsereject=(pfalse-pfalse1)
 
	format dfalsereject %4.3f
 
	sum pfalse pfalse1 dfalsereject, f 
	drop pfalse pfalse1 dfalsereject
}

/* Skip the MNL model

/* Multinomial logit of error probability */
gen class=0 if (trueg==1 & grant==1)
replace class=1 if (trueg==1 & grant==0)
replace class=2 if (trueg==0 & grant==1)
replace class=3 if (trueg==0 & grant==0)

label define classlbl 0 "correct_g" 1 "false_r" 2 "false_g" 3 "correct_r"
label value class classlbl

xi: mlogit class jpooffice examdur uspatinforce claims techspeed localinv rexp pastapp usinv mech drug chem elec comp biotech ict software automobile decideyr


* ESTIMATING THE MARGINAL EFFECTS

/****************************************************/
display " *** IPC***"

foreach x in "biotech" "drug" "chem" "software" "ict" "comp" "elec" "automobile" "mech" {

	display " *** `x' versus other***"
	

	*hold IPC
	qui gen byte hold1=biotech
	qui gen byte hold2=drug
	qui gen byte hold3=chem
	qui gen byte hold4=software
	qui gen byte hold5=ict
	qui gen byte hold6=comp
	qui gen byte hold7=elec
	qui gen byte hold8=automobile
	qui gen byte hold9=mech

	*assume all patents are `x'
	qui replace biotech=0
	qui replace drug=0
	qui replace chem=0
	qui replace software=0
	qui replace ict=0
	qui replace comp=0
	qui replace elec=0
	qui replace automobile=0
	qui replace mech=0
	qui replace `x'=1

	*predict outcomes if all patents are `x'
	qui predict  correct_g false_r false_g correct_r if e(sample)

	*assume every one is other
	qui replace `x'=0
	qui predict  correct_g1 false_r1 false_g1 correct_r1 if e(sample)
	qui replace biotech=hold1
	qui replace drug=hold2
	qui replace chem=hold3
	qui replace software=hold4
	qui replace ict=hold5
	qui replace comp=hold6
	qui replace elec=hold7
	qui replace automobile=hold8
	qui replace mech=hold9
	drop hold1 hold2 hold3 hold4 hold5 hold6 hold7 hold8 hold8 hold9
	

	qui gen dcorrect_g=(correct_g-correct_g1)
	qui gen dfalse_r=(false_r-false_r1)
	qui gen dfalse_g=(false_g-false_g1)
	qui gen dcorrect_r=(correct_r-correct_r1)

	format dcorrect_g %4.3f
	format dfalse_r %4.3f
	format dfalse_g %4.3f
	format dcorrect_r %4.3f

	sum correct_g correct_g1 dcorrect_g dfalse_r dfalse_g dcorrect_r, f 
	drop dcorrect_g dfalse_r dfalse_g dcorrect_r
	drop correct_g false_r false_g correct_r
	drop correct_g1 false_r1 false_g1 correct_r1
}


/****************************************************/
display " *** Patent Office ***"
	foreach x in "jpooffice"  {
	display " *** `x' versus other***"
	*hold patent office
	qui gen byte hold1=jpooffice

	*predict outcomes if all patents are `x'
	qui replace `x'=1
	qui predict  correct_g false_r false_g correct_r if e(sample)

	*predict outcomes if all patents are NOT `x'
	qui replace `x'=0
	qui predict  correct_g1 false_r1 false_g1 correct_r1 if e(sample)
        
        *restore jpooffice
        qui replace jpooffice=hold1
	drop hold1
	
	qui gen dcorrect_g=(correct_g-correct_g1)
	qui gen dfalse_r=(false_r-false_r1)
	qui gen dfalse_g=(false_g-false_g1)
	qui gen dcorrect_r=(correct_r-correct_r1)

	format dcorrect_g %4.3f
	format dfalse_r %4.3f
	format dfalse_g %4.3f
	format dcorrect_r %4.3f

	sum correct_g correct_g1 dcorrect_g dfalse_r dfalse_g dcorrect_r, f 
	drop dcorrect_g dfalse_r dfalse_g dcorrect_r
	drop correct_g false_r false_g correct_r
	drop correct_g1 false_r1 false_g1 correct_r1
}

/****************************************************/
display " *** US inventor ***"
	foreach x in "usinv"  {
	display " *** `x' versus other***"
	*hold usinv
	qui gen byte hold1=usinv

	*predict outcomes if all patents are `x'
	qui replace `x'=1
	qui predict  correct_g false_r false_g correct_r if e(sample)

	*predict outcomes if all patents are NOT `x'
	qui replace `x'=0
	qui predict  correct_g1 false_r1 false_g1 correct_r1 if e(sample)
        
        *restore usinv
        qui replace usinv=hold1
	drop hold1
	
	qui gen dcorrect_g=(correct_g-correct_g1)
	qui gen dfalse_r=(false_r-false_r1)
	qui gen dfalse_g=(false_g-false_g1)
	qui gen dcorrect_r=(correct_r-correct_r1)

	format dcorrect_g %4.3f
	format dfalse_r %4.3f
	format dfalse_g %4.3f
	format dcorrect_r %4.3f

	sum correct_g correct_g1 dcorrect_g dfalse_r dfalse_g dcorrect_r, f 
	drop dcorrect_g dfalse_r dfalse_g dcorrect_r
	drop correct_g false_r false_g correct_r
	drop correct_g1 false_r1 false_g1 correct_r1
}

/****************************************************/
display " *** Local inventor ***"
	foreach x in "localinv"  {
	display " *** `x' versus other***"
	*hold locinv
	qui gen byte hold1=localinv

	*predict outcomes if all patents are `x'
	qui replace `x'=1
	qui predict  correct_g false_r false_g correct_r if e(sample)

	*predict outcomes if all patents are NOT `x'
	qui replace `x'=0
	qui predict  correct_g1 false_r1 false_g1 correct_r1 if e(sample)
        
        *restore usinv
        qui replace localinv=hold1
	drop hold1
	
	qui gen dcorrect_g=(correct_g-correct_g1)
	qui gen dfalse_r=(false_r-false_r1)
	qui gen dfalse_g=(false_g-false_g1)
	qui gen dcorrect_r=(correct_r-correct_r1)

	format dcorrect_g %4.3f
	format dfalse_r %4.3f
	format dfalse_g %4.3f
	format dcorrect_r %4.3f

	sum correct_g correct_g1 dcorrect_g dfalse_r dfalse_g dcorrect_r, f 
	drop dcorrect_g dfalse_r dfalse_g dcorrect_r
	drop correct_g false_r false_g correct_r
	drop correct_g1 false_r1 false_g1 correct_r1
}


/****************************************************/
* MARGINAL EFFECTS FOR CONTINUOUS VARIABLES - COMPARE +SD WITH -SD
foreach x in "examdur" "uspatinforce" "claimsnorm" "techspeed" "pastapp" "decideyr" "rexp" {
	display " *** `x' % change is (mean+sd) versus (mean-sd)***"
	capture drop mean1
	capture drop sd1
	qui egen mean1=mean(`x') if e(sample)
	qui egen sd1=sd(`x') if e(sample)

	*hold `x'
	qui gen hold=`x'

	*assume all patents are (mean+sd)
	qui replace `x'=mean1+sd1

	*predict outcomes if all patents are (mean+sd)
	qui predict  correct_g false_r false_g correct_r if e(sample)

	*assume every one is (mean-sd)
	qui replace `x'=mean1-sd1
	qui predict  correct_g1 false_r1 false_g1 correct_r1 if e(sample)

	*restore value
	qui replace `x'=hold
	drop hold

	qui sum correct_g correct_g1 false_r false_r1 false_g false_g1 correct_r correct_r1
	qui gen dcorrect_g=(correct_g-correct_g1)
	qui gen dfalse_r=(false_r-false_r1)
	qui gen dfalse_g=(false_g-false_g1)
	qui gen dcorrect_r=(correct_r-correct_r1)
 
	format dcorrect_g %4.3f
	format dfalse_r %4.3f
	format dfalse_g %4.3f
	format dcorrect_r %4.3f
 
	sum correct_g correct_g1 dcorrect_g dfalse_r dfalse_g dcorrect_r, f 
	drop dcorrect_g dfalse_r dfalse_g dcorrect_r
	drop correct_g false_r false_g correct_r
	drop correct_g1 false_r1 false_g1 correct_r1
}



*/



/* Descriptive statistics of the sample */
use "c:\beth\ipria\projects\patent granting\error_h.dta", clear
gen techspeed = 1/speed
label var techspeed "inverse of speed"
rename office jpooffice
label var jpooffice "=1 if JPO, 0 if EPO"
rename expire uspatinforce
label var uspatinforce "Normalized number of years patent in force through renewal"

tab jpostat epostat
tab jpostat trueg		
tab epostat trueg
summarize 


/* Chart */
use "c:\beth\ipria\projects\patent granting\error_h.dta", clear
label var p "F(Xb)"
kdensity p, bwidth(0.005) scheme(mylean2) ylabel(,nogrid) note("") title("")
sort cite
label variable cite "Cite ratio"
twoway hist cite, scheme(mylean2) ylabel(,nogrid axis(1)) yaxis(2) note("") title("") || line p cite , ylabel(,nogrid) legend(pos(0))
graph save Graph "c:\beth\ipria\projects\patent granting\probgrant.gph", replace
graph export "c:\beth\ipria\projects\patent granting\probgrant.eps", as(eps) preview(off) replace


/**********************************************************************/


* check the number of applications with XY cites

capture log close
log using "c:\beth\ipria\projects\patent granting\type12-hausman_check_xy_cites.smcl", replace
use "c:\beth\ipria\projects\patent granting\error_h.dta", clear
sort patent
merge patent using "S:\micro\Transfer\patgrant\type12error\restat\patent_xycite_forward.dta"
tab _merge
keep if _merge==3
keep if office==0
mvencode falsereject, mv(0) o
mvencode falsegrant, mv(0) o
sum patent epostat falsegrant falsereject

sum patent epostat falsegrant falsereject if epostat==4
sum patent epostat falsegrant falsereject if epostat==3
gen truegrant =(epostat==4 & falsegrant==0)
gen truereject =(epostat==3 & falsereject==0)
tab truegrant
tab truereject
tab falsegrant
tab falsereject
tabstat  fxycite fxcite, by( truegrant)
tabstat  fxycite fxcite, by( truereject)
tabstat  fxycite fxcite, by( falsegrant)
tabstat  fxycite fxcite, by( falsereject)

tabstat  fxycite, by(epostat)
save "c:\beth\ipria\projects\patent granting\error_h_epostatus.dta", replace


use "c:\beth\ipria\projects\patent granting\error_h.dta", clear
sort patent
merge patent using "S:\micro\Transfer\patgrant\type12error\restat\patent_xycite_forward.dta"
tab _merge
keep if _merge==3
keep if office==1
mvencode falsereject, mv(0) o
mvencode falsegrant, mv(0) o
sum patent epostat falsegrant falsereject

sum patent jpostat falsegrant falsereject if jpostat==4
sum patent jpostat falsegrant falsereject if jpostat==3
gen truegrant =(jpostat==4 & falsegrant==0)
gen truereject =(jpostat==3 & falsereject==0)
tab truegrant
tab truereject
tab falsegrant
tab falsereject
tabstat  fxycite fxcite, by( truegrant)
tabstat  fxycite fxcite, by( truereject)
tabstat  fxycite fxcite, by( falsegrant)
tabstat  fxycite fxcite, by( falsereject)

tabstat  fxycite, by(jpostat)
save "c:\beth\ipria\projects\patent granting\error_h_jpostatus.dta", replace

append using "c:\beth\ipria\projects\patent granting\error_h_epostatus.dta"
count
gen truegrant_falsereject=(truegrant==1 | falsereject==1)
gen truereject_falsegrant=(truereject==1 | falsegrant==1)

tabstat  fxycite fxcite, by(truegrant_falsereject) s(n mean)
tabstat  fxycite fxcite, by(truereject_falsegrant) s(n mean)


