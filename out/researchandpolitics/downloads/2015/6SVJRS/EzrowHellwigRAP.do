*******************************************
******replication file for Ezrow and Hellwig, "The Hidden Cost of Consensus: How Coordinated Market Economies Insulate Politics."
******forthcoming, RESEARCH AND POLITICS
*******************************************

/* DO FILE REQUIRES "GRINTER" COMMAND TO RUN 
IF YOU DO NOT HAVE THE GRINTER COMMAND: 
STEP 1: TYPE IN COMMAND "findit grinter"
STEP 2: follow prompts to install grinter
*/

/*CODING AND LABELING VARIABLES */
/*rescaling to get these measures on same plane as for CSES-based analyses*/
gen rmv = (meanvote-1)*10/9
gen rcmp = (cmp+100)/20
gen rkofecon = kofecon/100
gen rflows = flows/100
gen rrestrictions = restrictions/100
gen rcmpe = (cmpecon+100)/20
gen rcmpn = (cmpnecon+100)/20

tsset party electnum
gen dlogrile = d.logrile
gen ldlogrile = l.d.logrile
rename rilese rileSE
gen lrileSE = l.rileSE
gen drcmp = d.rcmp
gen ldrcmp = l.d.rcmp
gen drcmpe = d.rcmpe
gen ldrcmpe = l.d.rcmpe
gen drcmpn = d.rcmpn
gen ldrcmpn = l.d.rcmpn
gen drmv = d.rmv
gen drmvxrkofecon = drmv*rkofecon
label variable rkofecon "economic globalization index"
label variable drmv "public opinion shift"
label variable drcmp "party shift"
gen cme = 0
recode cme *=1 if austria==1
recode cme *=1 if belgium==1
recode cme *=1 if denmark==1
recode cme *=1 if finland==1
recode cme *=1 if germany==1
recode cme *=1 if lux==1
recode cme *=1 if neth==1
recode cme *=1 if norway==1
recode cme *=1 if swe==1
label variable cme "coordinated market economy"
label variable dispro "Gallagher disproportionality"
gen scorp = ccode
label variable scorp "Siaroff corporatism"
recode scorp 11=4.808 12=4.917 13=3.583 14=3.458 21=2.750 22=4.269 23=3.000 31=1.462 32=1.583 33=1.000 34=1.000 35=1.000 41=3.308 42=5.000 51=1.577 53=2.050 63=1.375 64=1.900
gen drmvxcme = drmv*cme
gen drmvxdispro = drmv*dispro
gen drmvxscorp = drmv*scorp

/*TABLE 1 & FIGURE 1*/
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
grinter drmv, inter(drmvxrkofecon) const02(rkofecon) depvar(drcmp) clevel(90) title(A. All Governing Parties) nom scheme(s1mono) name(me_m1, replace) 
test drmv drmvxrkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==0, cluster(edate)
grinter drmv, inter(drmvxrkofecon) const02(rkofecon) depvar(drcmp) clevel(90) title(B. Parties in Uncoordinated Market Economies) nom scheme(s1mono) name(me_m2, replace) 
test drmv drmvxrkofecon
/*Table 1 model 3 - main model just for CMEs*/
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==1, cluster(edate)
grinter drmv, inter(drmvxrkofecon) const02(rkofecon) depvar(drcmp) clevel(90) title(C. Parties in Coordinated Market Economies) nom scheme(s1mono) name(me_m3, replace) 
test drmv drmvxrkofecon

/*TABLE A1 - SAMPLE LIST*/

/*TABLE A2*/
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==0 & greece==0 & italy==0 & port==0 & spain==0, cluster(edate)
test drmv drmvxrkofecon
gen cmexrkofecon = cme*rkofecon
gen drmvxkofxcme = drmvxrkofecon*cme
regress drcmp ldrcmp drmv rkofecon cme drmvxrkofecon drmvxcme cmexrkofecon drmvxkofxcme dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
test drmv drmvxrkofecon drmvxcme drmvxkofxcme

/*TABLE A3*/
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & scorp<2.75, cluster(edate)
test drmv drmvxrkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & scorp>2.75, cluster(edate)
test drmv drmvxrkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & dispro>3.37, cluster(edate)
test drmv drmvxrkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & dispro<3.37, cluster(edate)
test drmv drmvxrkofecon

/*TABLE A4 & FIGURE A1 */
gen corpptypf = 0
recode corpptypf *=1 if parfam1==30
recode corpptypf *=1 if parfam1==50
recode corpptypf *=1 if parfam1==60
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & corpptypf==0 & cme==1, cluster(edate)
test drmv drmvxrkofecon
grinter drmv, inter(drmvxrkofecon) const02(rkofecon) depvar(drcmp) clevel(90) title(Non-historical partners in CMEs) nom scheme(s1mono)

/*TABLE A5 - CMP CODINGS*/

/*TABLE A6*/ 
regress drcmpe ldrcmpe drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
test drmv drmvxrkofecon
regress drcmpe ldrcmpe drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==0, cluster(edate)
test drmv drmvxrkofecon
regress drcmpe ldrcmpe drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==1, cluster(edate)
test drmv drmvxrkofecon

/*TABLE A7*/
regress dlogrile ldlogrile drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
test drmv drmvxrkofecon
regress dlogrile ldlogrile drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==0, cluster(edate)
test drmv drmvxrkofecon
regress dlogrile ldlogrile drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==1, cluster(edate)
test drmv drmvxrkofecon

/*TABLE A8*/
gen absdcmp = abs(dcmp)
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & rileSE < absdcmp, cluster(edate)
test drmv drmvxrkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==0 & rileSE < absdcmp, cluster(edate)
test drmv drmvxrkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & cme==1 & rileSE < absdcmp, cluster(edate)
test drmv drmvxrkofecon

log off
