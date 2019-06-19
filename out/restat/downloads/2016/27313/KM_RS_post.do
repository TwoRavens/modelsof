*********************************************************************************
** Do-file for Kahn and MacGarvie, REStat **
*********************************************************************************

** users should change these directory names: DATALOC contains data, OUTLOC is destination of out- and log-files, and DOLOC contains do-files
global DATALOC "C:\Users\mmacgarv\Dropbox\Shu_Megan\REStat\dataverse"
global OUTLOC "C:\Users\mmacgarv\Dropbox\Shu_Megan\REStat\dataverse\output"
global DOLOC ""

** run ivpois cluster adjustment (can be commented out after first run)
*do DOLOC/ivpois_clusterSE.ado

capture log close
set more off
log using $OUTLOC\KM_RS, t replace
clear

insheet using $DATALOC\KM_RS_post.out

label var	year"calendar year"
label var	fulbrightdummy"1 if fulbright, 0 if control"
label var	yearphd"year of PhD completion"
label var	region"region of origin"
label var	logcgdp"log real GDP per capita of home country"
label var	probablegender"gender"
label var	top_rank_qs_08"rank of current academic institution"
label var	pubcountbyyr"publication count"
label var	citcountbyyr"citation count"
label var	firstauthcount"count of first-authored publications"
label var	firstauthcitc~t"count of first-authored citations"
label var	lastauthcount"count of last-authored publications"
label var	lastauthcit"count of last-authored citations"
label var	highimpcount"count of high-impact publications"
label var	highimpcit"count of high-impact citations"
label var	pregradpubs"count of publications before PhD graduation"
label var	pregradfirstpub"count of first-authored publications before PhD"
label var	pregradhiflco"count of high-impact first- or last-authored pubs before PhD"
label var	forloc"1 if located outside the US, 0 if in US"
label var	lagforloc"forloc lagged 1 year"
label var	laglogcurr"log GDP per capita of current location"
label var	lagcurreg"lagged current region"
label var	rich"1 if high-income home country"
label var	laglogcgdp"lagged log real GDP per capita of home country"
label var	loghomegdp"Log real gdp per cap of home country 5 yrs prior to grad"
label var	highart"1 if high-science home country"
label var	fieldnsf"field of study"
label var	relrank"relative rank of PhD institution"
label var	yearphd2"grouped year of PhD"
label var	year2"grouped calendar year"
label var	logrank"log of relrank"
label var	id2"scientist id"
label var	expand_cont"propensity score weight"
label var	cemfreq"CEM weight"

* create dummies
xi i.fieldnsf i.yearphd2 i.year2 

*********************************************************************************
** TABLE 1**
*********************************************************************************
tab lagforloc, summ(pubcount)
tab lagforloc, summ(highimpco)
tab lagforloc if lagcurreg=="EuropeEtc"| lagforloc==0, summ(pubcount)
tab lagforloc if lagcurreg=="EuropeEtc"| lagforloc==0, summ(highimpco)
tab lagforloc if lagcurreg~="EuropeEtc", summ(pubcount)
tab lagforloc if lagcurreg~="EuropeEtc", summ(highimpco)

*********************************************************************************
*** TABLE 2 ********************************************************
*********************************************************************************
summ pubcount citco firstauthco firstauthci lastauthco lastauthci highimpco highimpci   relrank year yearphd probableg loghomegdp pregradfirstpub pregradhiflco if lagforloc==0
summ pubcount citco firstauthco firstauthci lastauthco lastauthci highimpco highimpci  relrank year yearphd probableg loghomegdp pregradfirstpub pregradhiflco if lagforloc==1
summ pubcount citco firstauthco firstauthci lastauthco lastauthci highimpco highimpci  relrank year yearphd probableg loghomegdp pregradfirstpub pregradhiflco if fulbright==0 & lagforloc~=.
summ pubcount citco firstauthco firstauthci lastauthco lastauthci highimpco highimpci  relrank year yearphd probableg loghomegdp pregradfirstpub pregradhiflco if fulbright==1 & lagforloc~=.

*********************************************************************************
** TABLE 3**
*********************************************************************************

tab fieldnsf fulbright if year==yearphd

*********************************************************************************
******** IVPOIS: Table 4 ********************************************************
*********************************************************************************

*** IVPOIS , controlling for home country GDP
ivpois_clusterSE pubcountb  _I* logrank  probableg loghomegdp , endog(lagforloc ) exog(fulbright ) cluster(id2)
eststo estpub
outreg2 lagforloc using $OUTLOC\Table4rowA,   replace excel

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var'   _I* logrank  probableg loghomegdp , endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowA, excel 
}

*** IVPOIS , controlling for home country GDP & pregrad
ivpois_clusterSE pubcountb  _I* logrank  loghomegdp probableg pregradpubs pregradfirstpub pregradhiflco , endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowB,  replace excel  

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var' _I* logrank  probableg loghomegdp pregradpubs pregradfirstpub pregradhiflco , endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowB,  excel   
}

log close
log using $OUTLOC\KM_RS_table4rowCandD, t replace
*************************
***** TABLE 4 ROW C ****
*************************
*** IVPOIS GDP per cap interacted with fulbright, not controlling for home country GDP
ivpois_clusterSE pubcountb  _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright laglogcgdp) cluster(id2)
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1



foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var'   _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright laglogcgdp) cluster(id2)
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1
}

*************************
***** TABLE 4 ROW D ****
*************************
*** GDP per cap interacted with fulbright, with pregrad, not controlling for home country GDP
ivpois_clusterSE pubcountb  pregradpubs pregradfirstpub pregradhiflco _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright laglogcgdp) cluster(id2)
nlcom exp(_b[lagforloc]+_b[laglogcurr]* 7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1

foreach var in firstauthco lastauthco highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  pregradpubs pregradfirstpub pregradhiflco  _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright laglogcgdp) cluster(id2)
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1
}
log close
log using $OUTLOC\KM_RS, t append
*************************
*****SPLITTING SAMPLE****
*************************

** rich, without pregrad pubs**
ivpois_clusterSE pubcountb  _I* logrank  probableg loghomegdp if rich==1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowE, replace excel  title(Split sample, rich countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  _I* logrank  probableg loghomegdp if rich==1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowE,  excel   
}

** rich, with pregrad pubs**
ivpois_clusterSE pubcountb  pregradpubs pregradfirstpub pregradhiflco loghomegdp _I* logrank  probableg if rich==1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowF, replace excel  title(Split sample, rich countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if rich==1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowF,  append excel   
}

** poor, without pregrad pubs**
ivpois_clusterSE pubcountb  _I* logrank  probableg loghomegdp if rich<1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowG, replace excel  title(Split sample, poor countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  _I* logrank  probableg loghomegdp if rich<1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowG,  append excel   
}

** poor, with pregrad pubs**
ivpois_clusterSE pubcountb  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if rich<1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowH, replace excel  title(Split sample, poor countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if rich<1, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table4rowH,  append excel   
}

*** IVPOIS , controlling for home country GDP & pregrad & top-ranked school
sort id2 year
replace top_rank_qs=0 if top_rank_qs==.
by id2: gen lagtoprank=top_rank_qs[_n-1]
replace lagtoprank=lagtoprank*lagforloc

ivpois_clusterSE pubcountb  _I* logrank  loghomegdp probableg pregradpubs pregradfirstpub pregradhiflco lagtoprank , endog(lagforloc ) exog(fulbright ) cluster(id2)
nlcom _b[lagforloc]+_b[lagtoprank]
outreg2 lagforloc lagtop using $OUTLOC\Table4rowI,  replace excel  
foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var' _I* logrank  loghomegdp probableg pregradpubs pregradfirstpub pregradhiflco lagtoprank, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc lagtop using $OUTLOC\Table4rowI,  excel  
nlcom _b[lagforloc]+_b[lagtoprank]
}
log close
log using $OUTLOC\KM_RS_table5, t replace
*********************************************************************************************
******* TABLE 5 ******************************************* 
***GENERATE ESTIMATES OF EFFECT OF MOVING FROM FIRST TO SECOND QUARTILE ON PUBS
****** A GUIDE TO POTENTIAL BIAS *******
*********************************************************************************************
** schools near mean rank in first quartile
*tab schoolphd if relrank<.03, summ(rank)
** schools near second quartile
*tab schoolphd if relrank>.23& relrank<.27, summ(rank)

xi i.year2 i.yearphd2 
 
*regress controls' publication output on relative rank to get effect of program rank on productivity for controls
foreach var in pubcount firstauthco lastauthco highimpco citco firstauthci lastauthci highimpci {
quietly reg `var' relrank _I* if fulbright==0
eststo est`var'
gen b`var'= _b[relrank]
egen mean`var'=mean(`var')
* percentage impact of rank on publications
gen pc`var'=b`var'/mean`var'
}
estout estpubcount estfirstauthco estlastauthco esthighimpco estcitco estfirstauthci estlastauthci esthighimpci

** average percentage impacts across publication variables
gen avgpc=(pcpubcount+pcfirstauthco+pclastauthco+pchighimpco+pccitco+pcfirstauthci+pclastauthci+pchighimpci)/8

summ avgpc
** Averaged across all the coefficients, the percentage reduction in moving from 0 to 1 in relative rank is -.2794587
** this times 0.25 equals 6.986%

** Calculate bias: average percent effect of moving 0.25 in rank times mean of research output measure
foreach var in pubcount firstauthco lastauthco highimpco citco firstauthci lastauthci highimpci {
gen bias`var'=-avgpc*0.25*mean`var'
}

summ b* mean* pc* 

global biaspubcount	0.0589971
global biasfirstauthcount	0.026519
global biaslastauthcount	0.0168405
global biashighimpcount	0.0254267
global biascitcount	1.474707
global biasfirstauthcit	0.4846559
global biaslastauthcit	0.1905136
global biashighimpcit	0.8025796


*****************************************************
*********** TABLE 5  **************************
*****************************************************

*** GDP per cap interacted with fulbright, not controlling for home country GDP
xi i.year2 i.yearphd2 i.fieldnsf
ivregress liml pubcountb (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first

display "ASSUMPTION: ZERO BIAS"
***********************************************
***** COLUMN 1 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096

display "ASSUMPTION: NEGATIVE BIAS OF 10%"
***********************************************
***** COLUMN 1 ROW B *************************
***********************************************

lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biaspubcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biaspubcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biaspubcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biaspubcount

display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 1 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biaspubcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biaspubcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biaspubcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biaspubcount


ivregress liml firstauthco (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 2 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096

display  "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 2 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biasfirstauthcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biasfirstauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biasfirstauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biasfirstauthcount

display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 1 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biasfirstauthcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biasfirstauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biasfirstauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biasfirstauthcount

ivregress liml lastauthco (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 3 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096
display "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 3 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biaslastauthcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biaslastauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biaslastauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biaslastauthcount
display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 3 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biaslastauthcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biaslastauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biaslastauthcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biaslastauthcount

ivregress liml highimpco (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 4 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096
display "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 4 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biashighimpcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biashighimpcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biashighimpcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biashighimpcount
display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 4 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biashighimpcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biashighimpcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biashighimpcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biashighimpcount

ivregress liml citco (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 5 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096
display "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 5 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biascitcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biascitcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biascitcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biascitcount
display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 5 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biascitcount
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biascitcount
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biascitcount
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biascitcount


ivregress liml firstauthci (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 6 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096

display "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 6 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biasfirstauthcit
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biasfirstauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biasfirstauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biasfirstauthcit
display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 6 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biasfirstauthcit
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biasfirstauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biasfirstauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biasfirstauthcit

ivregress liml lastauthci (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 7 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096
display "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 7 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biaslastauthcit
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biaslastauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biaslastauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biaslastauthcit
display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 7 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biaslastauthcit
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biaslastauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biaslastauthcit
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biaslastauthcit

ivregress liml highimpci (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) first
display "ASSUMPTION: ZERO $bias"
***********************************************
***** COLUMN 8 ROW A *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151
lincom _b[lagforloc]+_b[laglogcurr]*8.395252
lincom _b[lagforloc]+_b[laglogcurr]*9.314809
lincom _b[lagforloc]+_b[laglogcurr]*9.826096
display "ASSUMPTION: NEGATIVE bias OF one quartile
***********************************************
***** COLUMN 8 ROW B *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151+$biashighimpcit
lincom _b[lagforloc]+_b[laglogcurr]*8.395252+$biashighimpcit
lincom _b[lagforloc]+_b[laglogcurr]*9.314809+$biashighimpcit
lincom _b[lagforloc]+_b[laglogcurr]*9.826096+$biashighimpcit
display "ASSUMPTION: POSITIVE bias OF one quartile
***********************************************
***** COLUMN 8 ROW C *************************
***********************************************
lincom _b[lagforloc]+_b[laglogcurr]*7.309151-$biashighimpcit
lincom _b[lagforloc]+_b[laglogcurr]*8.395252-$biashighimpcit
lincom _b[lagforloc]+_b[laglogcurr]*9.314809-$biashighimpcit
lincom _b[lagforloc]+_b[laglogcurr]*9.826096-$biashighimpcit

log close
log using $OUTLOC\KM_RS, t append
**********************************************************************************************
*********** TABLE 6 *******************************************************
*********** Effect of Being Abroad on Publications and Citations***
*****Cross-sectional data collapsed to scientist-level; Dependent variables averaged over years since Ph.D.
**********************************************************************************************

collapse pubcount citco firstauthco firstauthci lastauthco lastauthci highimpco highimpci forloc , by( loghomegdp logrank id2 fulbright probable pregradpubs pregradfirstpub pregradhiflco yearphd2 fieldnsf yearphd region highart rich)

xi i.fieldnsf i.yearphd2

gen yearssince=2007-yearphd
gen shareabroad=forloc

*******************************************
***** TABLE 6: SPLITTING SAMPLE & COLLAPSING DATA ****
*******************************************
** rich, without pregrad pubs**
ivpois pubcountb  _I* logrank  probableg loghomegdp if rich==1, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowA,  excel replace title(Split sample, rich countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois `var'  _I* logrank  probableg loghomegdp if rich==1, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowA, excel append  
}

** rich, with pregrad pubs**
ivpois pubcountb  pregradpubs pregradfirstpub pregradhiflco loghomegdp _I* logrank  probableg if rich==1, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowB,excel replace title(Split sample, rich countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if rich==1, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowB, excel append  
}

** poor, without pregrad pubs**
ivpois pubcountb  _I* logrank  probableg loghomegdp if rich==0, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowC, excel replace title(Split sample, poor countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois `var'  _I* logrank  probableg loghomegdp if rich==0, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowC, excel append  
}

** poor, with pregrad pubs**
ivpois pubcountb  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if rich==0, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowD,excel  replace title(Split sample, poor countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if rich==0, endog(share) exog(fulbright ) 
outreg2 shareabroad using  $OUTLOC/Table6_rowD, excel append  
}

** highart, without pregrad pubs**
ivpois_clusterSE pubcountb  _I* logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel replace title(Split sample, rich countries)

* combine _Ifieldnsf_5 and _Ifieldnsf_8 bc of difficulty getting regression to converge
gen tmp=_Ifieldnsf_5+_Ifieldnsf_8
ivpois_clusterSE firstauthco _Iy* _Ifieldnsf_2-_Ifieldnsf_4 _Ifieldnsf_6 _Ifieldnsf_7 tmp logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  
ivpois_clusterSE lastauthco _I* logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  
ivpois_clusterSE highimpco _I* logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  
ivpois_clusterSE citcount _I* logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  
ivpois_clusterSE firstauthci _Iy* _Ifieldnsf_2-_Ifieldnsf_4 _Ifieldnsf_6 _Ifieldnsf_7 tmp logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  
ivpois_clusterSE lastauthci _I* logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  
ivpois_clusterSE highimpci  _Iy* _Ifieldnsf_2-_Ifieldnsf_4 _Ifieldnsf_6 _Ifieldnsf_7 tmp  logrank  probableg loghomegdp if highart==1,  endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowE, excel append  


** highart, with pregrad pubs**
ivpois_clusterSE pubcountb  pregradpubs pregradfirstpub pregradhiflco loghomegdp _I* logrank  probableg if highart==1, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowF, replace title(Split sample, rich countries) excel

foreach var in firstauthcount lastauthcount highimpcount citcountb {
ivpois_clusterSE `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if highart==1, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowF, excel append  
}
* combine _Ifieldnsf_5 and _Ifieldnsf_8 bc of difficulty getting regression to converge
ivpois_clusterSE firstauthci  pregradpubs pregradfirstpub pregradhiflco _Ifieldnsf_2-_Ifieldnsf_4 _Ifieldnsf_6 _Ifieldnsf_7 tmp  logrank  loghomegdp probableg if highart==1, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowF, excel append  

foreach var in lastauthci highimpci {
ivpois_clusterSE `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if highart==1, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowF, excel append  
}


** lowart, without pregrad pubs**
ivpois_clusterSE pubcountb  _I* logrank  probableg loghomegdp if highart==0, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowG, excel replace title(Split sample, poor countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  _I* logrank  probableg loghomegdp if highart==0, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowG, excel append  
}

** lowart, with pregrad pubs**
ivpois_clusterSE pubcountb  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if highart==0, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowH, excel replace title(Split sample, poor countries)

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE `var'  pregradpubs pregradfirstpub pregradhiflco _I* logrank  loghomegdp probableg if highart==0, endog(share) exog(fulbright ) cluster(id2)
outreg2 shareabroad using  $OUTLOC/Table6_rowH, excel append  
}


****** APPENDIX TABLE: FIRST STAGE REGRESSIONS*******
clear 
insheet using $DATALOC\KM_RS_post.out

xi i.fieldnsf i.yearphd2 i.year2 
*** Only fulbright
ivregress liml pubcountb (lagforloc=fulbrightdum) loghomeg _I* logrank  probableg , vce(cluster id2) first
estat firststage, all
regress lagforloc fulbrightdum loghomeg _I* logrank  probableg , vce(cluster id2) first
outreg2 using $OUTLOC\pubsinter,  replace excel  

*** GDP per cap interacted with fulbright, not controlling for home country GDP
ivregress liml pubcountb (lagforloc=fulbright )laglogcgdp  _I* logrank  probableg , vce(cluster id2) 
estat firststage, all
reg lagforloc fulbright laglogcgdp  _I* logrank  probableg , vce(cluster id2) 
outreg2 using $OUTLOC\pubsinter,  append excel  

ivregress liml pubcountb (lagforloc laglogcurr=fulbright laglogcgdp)  _I* logrank  probableg , vce(cluster id2) 
estat firststage, all
reg lagforloc fulbright laglogcgdp  _I* logrank  probableg , vce(cluster id2) 
outreg2 using $OUTLOC\pubsinter,  append excel  
reg laglogcurr fulbright laglogcgdp  _I* logrank  probableg , vce(cluster id2) 
outreg2 using $OUTLOC\pubsinter,  append excel  

*** Only fulbright, rich sample
ivregress liml pubcountb (lagforloc=fulbrightdum) loghomeg _I* logrank  probableg if rich==1, vce(cluster id2) first
estat firststage, all
reg lagforloc fulbrightdum loghomeg _I* logrank  probableg if rich==1, vce(cluster id2) first
outreg2 using $OUTLOC\pubsinter,  append excel  
*** Only fulbright, poor sample
ivregress liml pubcountb (lagforloc=fulbrightdum) loghomeg _I* logrank  probableg if rich==0, vce(cluster id2) first
estat firststage, all
reg lagforloc fulbrightdum loghomeg _I* logrank  probableg if rich==0, vce(cluster id2) first
outreg2 using $OUTLOC\pubsinter,  append excel  


**************TABLE 7 *****************
**** MATCHING *********
clear
insheet using $DATALOC\KM_RS_post.out
drop if expand_cont==. 
expand expand_controls

xi i.fieldnsf i.yearphd2 i.year2 
*****************************************************
*********** TABLE 7 ROW A **************************
*****************************************************
*** IVPOIS 
ivpois_clusterSE pubcountb  _I* logrank  probableg loghomeg, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table7_rowA_PS,  replace 

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var'   _I* logrank  probableg loghomeg, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table7_rowA_PS,  append   
}
*****************************************************
*********** TABLE 7 ROW B **************************
*****************************************************
*** IVPOIS GDP per cap interacted with fulbright
ivpois_clusterSE pubcountb _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright logcgdp) cluster(id2)
display exp(_b[lagforloc]+_b[laglogcurr]*7.309151)
display exp(_b[lagforloc]+_b[laglogcurr]*8.395252)
display exp(_b[lagforloc]+_b[laglogcurr]*9.314809)
display exp(_b[lagforloc]+_b[laglogcurr]*9.826096)

capture log close
log using $OUTLOC\Table7, t replace
*****************************************************
*********** TABLE 7 ROW B **************************
*****************************************************
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var' _I* logrank  probableg  , endog(lagforloc laglogcurr) exog(fulbright logcgdp) cluster(id2)
display exp(_b[lagforloc]+_b[laglogcurr]*7.309151)
display exp(_b[lagforloc]+_b[laglogcurr]*8.395252)
display exp(_b[lagforloc]+_b[laglogcurr]*9.314809)
display exp(_b[lagforloc]+_b[laglogcurr]*9.826096)
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1
}

************** Table 7 panels C and D**********************
clear
insheet using $DATALOC\KM_RS_post.out

** drop non-matches
drop if cemfreq==.
** expand controls
expand cemfreq

*****************************************************
*********** TABLE 7 ROW C **************************
*****************************************************
*** IVPOIS 
xi i.fieldnsf i.year2 i.yearphd2
ivpois_clusterSE pubcountb _I* logrank  probableg loghomeg, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table7_rowC_CEM,  replace 

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var' _I* logrank  probableg loghomeg, endog(lagforloc ) exog(fulbright ) cluster(id2)
outreg2 lagforloc using $OUTLOC\Table7_rowC_CEM,  append   
}

*** IVPOIS GDP per cap interacted with fulbright
*****************************************************
*********** TABLE 7 ROW D **************************
*****************************************************


ivpois_clusterSE pubcountb _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright laglogcgdp) cluster(id2)
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1

foreach var in firstauthcount lastauthcount highimpcount citcountb firstauthcit lastauthcit highimpcit {
ivpois_clusterSE  `var'  _I* logrank  probableg , endog(lagforloc laglogcurr) exog(fulbright laglogcgdp) cluster(id2)
nlcom exp(_b[lagforloc]+_b[laglogcurr]*7.309151)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*8.395252)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.314809)-1
nlcom exp(_b[lagforloc]+_b[laglogcurr]*9.826096)-1
}

log close





