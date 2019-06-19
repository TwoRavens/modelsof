clear all
set mem 1g
set more off
capture log close
log using "misclassification.smcl", replace

set more off

/***************************************************************************/
* PREPARE USPTO DATA ON RENEWALS TO BE MERGE INTO OUR DATA LATER
* taking the USPTO data on renewals and preparing to match with out data
use "mfee_lstz.dta", clear
* all these patents have atleast one positive entry for expired (without re-instatment)
* thus patents missing from this list must have been renewed beyond 12 years
gen x=substr(patent,1,7) 
gen r3=substr(patent, 8,1)
gen e3=substr(patent, 9,1)
gen r2=substr(patent, 10,1)
gen e2=substr(patent, 11,1)
gen r1=substr(patent, 12,1)
gen e1=substr(patent, 13,1)
rename patent meggilbert
rename x patent
sort patent
* if this list is empty , then shows the list only has expires on it
l if  e3=="" & e2=="" & e1==""
* expire variable indicates the year in which patent expired and not re-instated
gen expire=20
replace expire=4 if e1=="Y" & r1~="Y"
replace expire=8 if e2=="Y" & r2~="Y"
replace expire=12 if e3=="Y" & r3~="Y"
destring patent, replace
sort patent
save "mfee_lstz1.dta", replace

/***************************************************************************/
* PREPARE THE SEPARATE OFFICE DATA FOR POOLING 
/**** JPO ****************************************************************/
use "jpo-nonPCT.dta", clear
* make sure that we use only rejected and granted applications at both EPO & JPO *
keep if epoappstat==4 | epoappstat==6
keep if jpoappstat==10 | jpoappstat==6 | jpoappstat==9
* merge in rexp
sort usost
merge usost using "rexp.dta", nokeep
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
merge patent using "mfee_lstz1.dta", nokeep
tab _merge
drop _merge
replace expire=20 if expire==.
egen expireost=mean(expire), by(usost usinv gyear)
gen expireratioost = expire / expireost
sort patent
keep epoappstat jpoappstat requestlag locrra epostat jpostat eopposed numinv asscode examdurnorm examdur mech drug comp speed biotech elec chem ict software automobile claimsnorm office patent grant appeal epostat expireratioost citeratioost granted  family_id loccite forcite localinv rexp rexp usinv othgr_early othrj_early usearly  pastapp  decideyr applyyr
save "jpotemp.dta", replace
keep patent jpostat
sort patent 
save "jpotemp2.dta", replace

/**** EPO ****************************************************************/
use "epo-nonPCT.dta", clear
*make sure that we use only rejected and granted applications at both EPO & JPO * 
keep if epoappstat==4 | epoappstat==6
keep if jpoappstat==10 | jpoappstat==6 | jpoappstat==9
* merge in rexp
sort usost
merge usost using "rexp.dta", nokeep
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
merge patent using "mfee_lstz1.dta", nokeep
tab _merge
drop _merge
replace expire=20 if expire==.
egen expireost=mean(expire), by(usost usinv gyear)
gen expireratioost = expire / expireost
sort patent
keep epoappstat jpoappstat requestlag locrra eponum epostat jpostat eopposed numinv asscode examdurnorm examdur mech drug comp speed biotech elec chem ict software automobile claimsnorm office patent grant appeal epostat expireratioost citeratioost granted  family_id loccite forcite localinv rexp  usinv othgr_early othrj_early usearly  pastapp  decideyr applyyr
save "epotemp.dta", replace
keep patent epostat
sort patent 
save "epotemp2.dta", replace

/**** Pooling ****************************************************************/
use "epotemp2.dta", clear
sort patent
merge patent using "jpotemp2.dta"
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
save "epojpotemp.dta", replace

use "jpotemp.dta", clear
merge patent using "epojpotemp.dta"
save "jpotemp3.dta", replace

use "epotemp.dta", clear
merge patent using "epojpotemp.dta"
save "epotemp3.dta", replace
append using "jpotemp3.dta"
sort patent
drop _merge
save "pooled_h.dta", replace

* ESTIMATE THE NUMBERS OF FALSE GRANTS AND FALSE REJECTS USING THE BENCHMARK FROM THE MATLAB ESTIMATE

/**** Misclassification analysis ****************************************************************/
use "pooled_h.dta", clear
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

sort patent
save "error_h.dta", replace

* BEGIN HERE THE REGRESSIONS FOR THE TABLES PUBLISHED IN RESTAT PAPER

/* Probability of Error */
use "error_h.dta", clear
gen techspeed = 1/speed
label var techspeed "inverse of speed"
rename office jpooffice
label var jpooffice "=1 if JPO, 0 if EPO"
rename expireratioost uspatinforce
label var uspatinforce "Normalized number of years patent in force through renewal"


/* Probability of Incorrect grant*/
* TABLE 5, COL 2 - RESTAT PAPER BY PALANGKARAYA, WEBSTER & JENSEN
xi: logit falsegrant examdur uspatinforce claims techspeed pastapp rexp decideyr localinv usinv ///
         jpooffice mech drug chem elec comp biotech ict software automobile decideyr if trueg==0
mfx

* TABLE A3, COL 2 - RESTAT PAPER BY PALANGKARAYA, WEBSTER & JENSEN
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
* TABLE A3, COL 1 - RESTAT PAPER BY PALANGKARAYA, WEBSTER & JENSEN
xi: logit falsereject examdur uspatinforce claims techspeed pastapp rexp decideyr localinv usinv ///
         jpooffice mech drug chem elec comp biotech ict software automobile if trueg==1
mfx

* TABLE 5, COL 1 - RESTAT PAPER BY PALANGKARAYA, WEBSTER & JENSEN
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


/**********************************************************************/
* DESCRIPTIVES 
/* Descriptive statistics of the sample */
use "error_h.dta", clear
gen techspeed = 1/speed
label var techspeed "inverse of speed"
rename office jpooffice
label var jpooffice "=1 if JPO, 0 if EPO"
rename expire uspatinforce
label var uspatinforce "Normalized number of years patent in force through renewal"

/*************************************************************************/		  
*Table A2
summarize grant trueg citeratioost examdurnorm uspatinforce claimsnorm ///
          speed rexp decideyr localinv usinv biotech drug chem software ///
		  ict comp elec automobile mech jpooffice

/*************************************************************************/		  
*TABLE 1: bottom part
tab jpostat epostat if jpooffice==1

*TABLE 1: top part
use "jpotemp.dta", clear
tab jpostat epostat 		  

/*************************************************************************/		  
*TABLE 2
* need to use the full data which include pending and withdrawn applications
use "epojpouspto-nonPCT.dta", clear
/* there is a US inventor involved */
gen usinv=0
replace usinv=1 if numusinv>0
replace usinv=0 if numusinv==.
* drop if missing
drop if jpostat==1 | epostat==1
/*application year dummy*/
gen  jpapplyyr=year(jpofiledate)
/*citation ratio*/
gen citeratio = creceive/cmade
/* normalise on citations for that grant yr */
egen citeratiomy=mean(citeratio), by(gyear)
egen citeratiom=mean(citeratio) 
gen citerationorm=citeratio*(citeratiom/citeratiomy)
egen cmadeost=mean(cmade), by(usost usinv gyear)
egen creceiveeost=mean(creceive), by(usost usinv gyear)
gen citeratioost = creceive / creceiveeost
/*Summarize citeratio by application status*/
tab jpostat epostat, summarize(citeratioost) means
tab jpostat epostat
		   
/**********************************************************************/
* FIGURE 1 - RESTAT PAPER BY PALANGKARAYA, WEBSTER & JENSEN
/* Chart */
use "error_h.dta", clear
label var p "F(Xb)"
kdensity p, bwidth(0.005) scheme(mylean2) ylabel(,nogrid) note("") title("")
graph save Graph "probgrant.gph", replace
graph export "probgrant.eps", as(eps) preview(off) replace
*need to add vertical line on F(Xb)=.92 manually; saved as figure1.gph then export to eps
*graph export "figure1.eps", as(eps) preview(off) replace

/**********************************************************************/
* TABLE 4 - RESTAT PAPER BY PALANGKARAYA, WEBSTER & JENSEN
* check the number of applications with XY cites

*EPO
use "error_h.dta", clear
sort patent
merge patent using "patent_xycite_forward.dta"
tab _merge
keep if _merge==3
keep if office==0
mvencode falsereject, mv(0) o
mvencode falsegrant, mv(0) o
gen truegrant =(epostat==4 & falsegrant==0)
gen truegrantgranted =(epostat==4 & falsegrant==0)
gen truerejectrejected =(epostat==3 & falsereject==0)
*Table 4 EPO - True Grant - Granted
tabstat  fxycite, by( truegrantgranted)
*Table 4 EPO - True Reject - Rejected
tabstat  fxycite, by( truerejectrejected)
*Table 4 EPO - True Reject - Granted
tabstat  fxycite, by( falsegrant)
*Table 4 EPO - True Grant - Rejected
tabstat  fxycite, by( falsereject)
*Table 4 EPO - Total Rejected and  Total Granted
tabstat  fxycite, by(epostat)
save "error_h_epostatus.dta", replace

*JPO
use "error_h.dta", clear
sort patent
merge patent using "patent_xycite_forward.dta"
tab _merge
keep if _merge==3
keep if office==1
mvencode falsereject, mv(0) o
mvencode falsegrant, mv(0) o
gen truegrantgranted =(jpostat==4 & falsegrant==0)
gen truerejectrejected =(jpostat==3 & falsereject==0)
*Table 4 JPO - True Grant - Granted
tabstat  fxycite, by( truegrantgranted)
*Table 4 JPO - True Reject - Rejected
tabstat  fxycite, by( truerejectrejected)
*Table 4 JPO - True Reject - Granted
tabstat  fxycite, by( falsegrant)
*Table 4 JPO - True Grant - Rejected
tabstat  fxycite, by( falsereject)
*Table 4 JPO - Total Rejected and  Total Granted
tabstat  fxycite, by(jpostat)
save "error_h_jpostatus.dta", replace

*TOTAL
*Table 4 Total (last row)
append using "error_h_epostatus.dta"
count
gen truegrant_falsereject=(truegrantgranted==1 | falsereject==1)
gen truereject_falsegrant=(truerejectrejected==1 | falsegrant==1)
tabstat  fxycite, by(truegrant_falsereject) s(n mean)

log close
