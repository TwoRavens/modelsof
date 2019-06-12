*********************************************************
*code to replicate analyses reported in 
*Lawrence Ezrow & Timothy Hellwig "Responding to Voters or Responding to Markets? Political Parties and Public Opinion in an Era of Globalization"
*forthcoming, International Studies Quarterly
*July 12, 2013
*********************************************************
log using EzrowHellwigISQ.log, replace
set mem 200m
set matsize 200
set more off
use EzrowHellwigISQ.dta 

/*PRELIMINARY MANIPULATIONS*/
gen rmv = (meanvote-1)*10/9
gen rcmp = (cmp+100)/20
gen rkofecon = kofecon/100
gen rflows = flows/100
gen rrestrictions = restrictions/100
tsset party electnum
gen drcmp = d.rcmp
gen ldrcmp = l.d.rcmp
gen drmv = d.rmv
gen drmvxrkofecon = drmv*rkofecon
gen drmvxrflows = drmv*rflows
gen drmvxrrestrictions = drmv*rrestrictions

/*TABLE 1*/
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==0, cluster(edate)
/*ancillary model: three-way interaction term*/
gen drmvxpmhist = drmv*pm_hist
gen pmhistxrkofecon = pm_hist*rkofecon
gen triple = drmvxpmhist*rkofecon
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon drmvxpmhist pmhistxrkofecon triple dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway, cluster(edate)
test drmv drmvxpmhist triple

/*TABLE 2*/
/*variables generation*/
gen lntrade_c = ln(trade/100)
gen lntrade = lntrade_c + 1.264785 
gen drmvxlntrade = drmv * lntrade
quietly reg rkofecon eyear
predict detrendg, resid
gen drmvxdtg = drmv*detrendg
gen absdcmp = abs(dcmp)
/*Models 1-8*/
regress drcmp drmv rkofecon drmvxrkofecon ldrcmp dgrowth d.rkofecon australia nzld swe ireland austria belgium denmark finland france gb germany greece italy neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv rflows drmvxrflows ldrcmp dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv rrestrictions drmvxrrestrictions ldrcmp dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv lntrade drmvxlntrade ldrcmp dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon eyear ldrcmp dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv detrendg drmvxdtg ldrcmp dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon ldrcmp dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & eu==1, cluster(edate)
regress drcmp ldrcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if pm_hist==1 & absdcmp>rileSE, cluster(edate)

/*ONLINE APPENDIX*/
/*variables generation*/
gen mainstream = parfam1
recode mainstream 30/80=1 *=0
gen lparty = parfam1
recode lparty min/30=1 *=0
gen rparty = parfam1
recode rparty 40/80=1 *=0
gen drmv_m = drmv*mainstream
gen rkofecon_m = rkofecon*mainstream
gen drmvxrkofecon_m = drmvxrkofecon*mainstream
gen drmv_l = drmv*lparty
gen rkofecon_l = rkofecon*lparty
gen drmvxrkofecon_l = drmvxrkofecon*lparty
gen drmv_r = drmv*rparty
gen rkofecon_r = rkofecon*rparty
gen drmvxrkofecon_r = drmvxrkofecon*rparty
gen big =0
replace big = 1 if pervote > 12
gen drmv_big = drmv*big
gen rkofecon_big = rkofecon*big
gen drmvxrkofecon_big = drmvxrkofecon*big
gen extreme = 0
replace extreme = 1 if cmp > -18.2 & cmp < 9.8
/*TABLE A1*/
regress drcmp drmv rkofecon drmvxrkofecon dgrowth australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if big==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if big==0, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if mainstream==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if mainstream==0, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if lparty==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if rparty==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if extreme==0, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if extreme==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if big==1 & pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if big==0 & pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if mainstream==1 & pm_hist==1, cluster(edate)
/*no estimates for niche parties with governing experience - Model 4B*/
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if lparty==1 & pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if rparty==1 & pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if extreme==0 & pm_hist==1, cluster(edate)
regress drcmp drmv rkofecon drmvxrkofecon dgrowth ldrcmp australia nzld swe ireland austria belgium denmark finland france gb germany greece italy lux neth port spain norway if extreme==1 & pm_hist==1, cluster(edate)

log off
