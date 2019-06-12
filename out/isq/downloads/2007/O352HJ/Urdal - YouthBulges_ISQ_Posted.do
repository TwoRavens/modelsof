* REPLICATION DATA (do-file)
* Citation: Urdal, Henrik, 2006. 'A Clash of Generations? Youth Bulges and Political Violence', International Studies Quarterly 50(1).

*(dataset YouthBulges_Urdal_ISQ_Posted.dta)



*Description, variables

*ss_numbe: country code accoding to Small & Singer (1982), my codes for non-S&S countries
*sscntr: dummy, '1' if defined as state according to Small & Singer (1982), '0' otherwise
*uppin2: conflict onset, PRIO/Uppsala dataset (Gleditsch et al. 2002). Allows for two years of inactivity before coding a bew onset
*py3neo: brevity of peace, risk halved every three yrs
*uppwarneo: ongoing war (occurrence)
*waronset: onset of conflict with at least 1000 annual battledeaths (Gleditsch et al. 2002)
*ythblgap: youth bulges. 15-24 year olds as share of total adult population (15 years and above) 
*ythapnew: centered term of 'ythblgap'
*ytapsqne: squared 'ythapnew'
*ythblgtp: youth bulges, Collier's operationalization. 15-24 year olds as share of total population 
*ythtpnew: centered term of 'ythblgtp'
*yttpsqne: squared 'ythtpnew'
*totpopln: total population in 1000, logtransformed
*imr: infant mortality rate
*polity: regime type (Polity score)
*politysq: squared 'polity'
*polmiss: 0 if original Polity value, 1 if imputed mean
*gdpcapppp: gdp per capita, PPP, originating from Penn World Tables. Missing values: imputed mean value
*gdpcappppln: logtransformed gdpcapppp
*pwtmiss: 0 if original value in PWT, 1 if imputed mean
*depratio: the number of 0-14 year-olds relative to the number of 15-24 year-olds
*deprationew: centered depratio
*ybdeprationew: interaction ythapnew*deprationew
*ybtpdepratnew: interaction ythtpnew*deprationew
*urbangrowth: annual increase in urban populations
*urbangrnew: centered urbangrowth
*yburbannew: interaction ythapnew*urbangrnew
*pwtecgrowth_5: the average annual change in PPP GDP per capita over the five-year period prior to the year of observation
*pwtecgrowth_5inv: inverted pwtecgrowth_5
*pwtecgr5invnew: centered pwtecgrowth_5inv
*ybpwtgr5invnew: interaction ythapnew*pwtecgr5invnew
*pwtgrowth_miss: 0 if growth data from PWT, 1 if imputed mean
*ybpolity: interaction ythblgap*polity
*ybpolitysq: interaction ythblgap*politysq
*tegr5lagg: average annual growth in tertiary enrollment been lagged by 1 period (5 yrs)
*tegr5laggnew: centered tegr5lagg
*ybtegrlagg: interaction ythapnew*tegr5laggnew
*pasumterr: annual count of terrorism events, originating from the US State Failure Task Force (SFTF) project
*pasumterrlagg: one year lagged pasumterr
*pa871: annual event count of riots and violent demonstrations, originating from the US State Failure Task Force (SFTF) project
*pa871lagg: one year lagged pa871

 


* TABLE 1
* Model 1
logit uppin2 ythblgap totpopln imr polity politysq py3neo if sscntr==1 & polmiss==0 & !(uppin2==0 & uppwarneo==1)

*Model 2
logit uppin2 ythblgap totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)

* Model 3 
logit uppin2 ythblgap totpopln gdpcappppln polity politysq polmiss py3neo if pwtmiss==0 & !(uppin2==0 & uppwarneo==1)

* Model 4
logit uppin2 ythapnew ytapsqne totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)

*Model 5
logit uppin2 ythblgtp totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)

*Model 6
logit uppin2 ythtpnew deprationew ybtpdepratnew totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)


*TABLE 2

*Model 7 
logit uppin2 ythapnew pwtecgr5invnew ybpwtgr5invnew totpopln imr polity politysq polmiss pwtgrowth_miss py3neo if !(uppin2==0 & uppwarneo==1)

*Model 8 
logit uppin2 ythapnew deprationew ybdeprationew totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)

* Model 9 
logit uppin2 ythapnew totpopln imr polity politysq ybpolity ybpolitysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)

*Model 10 
logit uppin2 ythapnew tegr5laggnew ybtegrlagg totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)

*Model 11 
logit uppin2 ythapnew urbangrnew yburbannew totpopln imr polity politysq polmiss py3neo if !(uppin2==0 & uppwarneo==1)


* TABLE 3

iis(ss_numbe)

* Model 1
xtnbreg pasumterr ythapnew pwtecgr5invnew ybpwtgr5invnew imr totpopln polity politysq pasumterrlagg if pwtgrowth_miss==0 & polmiss==0

* Model 2
xtnbreg pasumterr ythapnew imr totpopln polity politysq ybpolity ybpolitysq pasumterrlagg if polmiss==0

* Model 3
xtnbreg pasumterr ythapnew tegr5laggnew ybtegrlagg imr totpopln polity politysq pasumterrlagg if polmiss==0

* Model 4
xtnbreg pasumterr ythapnew urbangrnew yburbannew imr totpopln polity politysq pasumterrlagg if polmiss==0

* Model 5
xtnbreg pa871 ythapnew deprationew ybdeprationew imr totpopln polity politysq pa871lagg if polmiss==0

* Model 6
xtnbreg pa871 ythapnew tegr5laggnew ybtegrlagg imr totpopln polity politysq pa871lagg if polmiss==0




*APPENDIX 

*APPENDIX 1: SPLINE MODELS

*Model 1
logit uppin2 ythblgap totpopln imr polity politysq splinevar2 _spline1 _spline2 _spline3 if polmiss==0 & sscntr==1 & !(uppin2==0 & uppwarneo==1)

*Model 2
logit uppin2 ythblgap totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 3 
logit uppin2 ythblgap totpopln gdpcappppln polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if pwtmiss==0 & !(uppin2==0 & uppwarneo==1)

*Model 4
logit uppin2 ythapnew ytapsqne totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 5
logit uppin2 ythblgtp totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 6
logit uppin2 ythtpnew deprationew ybtpdepratnew totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 7 
logit uppin2 ythapnew pwtecgr5invnew ybpwtgr5invnew totpopln imr polity politysq polmiss pwtgrowth_miss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 8 
logit uppin2 ythapnew deprationew ybdeprationew totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

* Model 9 
logit uppin2 ythapnew totpopln imr polity politysq ybpolity ybpolitysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 10 
logit uppin2 ythapnew tegr5laggnew ybtegrlagg totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)

*Model 11 
logit uppin2 ythapnew urbangrnew yburbannew totpopln imr polity politysq polmiss splinevar2 _spline1 _spline2 _spline3 if !(uppin2==0 & uppwarneo==1)


* APPENDIX 1: FIXED EFFECTS MODEL
iis(ss_numbe)
tis(year)
xtlogit uppin2 ythblgap totpopln imr polity politysq py3neo if sscntr==1 & polmiss==0 & !(uppin2==0 & uppwarneo==1), fe


* APPENDIX 3: WAR MODELS (1000 BATTLEDEATHS)

* Model 1
logit waronset ythblgap totpopln imr polity politysq py3neo if polmiss==0 & sscntr==1 & !(waronset==0 & uppwarneo==1)

*Model 2
logit waronset ythblgap totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

* Model 3 
logit waronset ythblgap totpopln gdpcappppln polity politysq polmiss py3neo if pwtmiss==0 & !(waronset==0 & uppwarneo==1)

* Model 4
logit waronset ythapnew ytapsqne totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

*Model 5
logit waronset ythblgtp totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

*Model 6
logit waronset ythtpnew deprationew ybtpdepratnew totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

*Model 7 
logit waronset ythapnew pwtecgr5invnew ybpwtgr5invnew totpopln imr polity politysq polmiss pwtgrowth_miss py3neo if !(waronset==0 & uppwarneo==1)

*Model 8 
logit waronset ythapnew deprationew ybdeprationew totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

* Model 9
logit waronset ythapnew totpopln imr polity politysq ybpolity ybpolitysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

*Model 10
logit waronset ythapnew tegr5laggnew ybtegrlagg totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

*Model 11 
logit waronset ythapnew urbangrnew yburbannew totpopln imr polity politysq polmiss py3neo if !(waronset==0 & uppwarneo==1)

