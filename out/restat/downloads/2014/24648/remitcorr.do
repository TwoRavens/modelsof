*********************************************************
* Remittances deteriorate governance			*
* Date: July 2012					*
* Author: Faisal Ahmed					*
*********************************************************



* Clear data from memory
drop _all

* Set memory
set mem 500m
set maxvar 5000
set matsize 5000
mata: mata set matafavor speed, perm


* READ IN DATA
set more off
use remitcorr.dta

***
* Table 1: Remittances and distance from Mecca
tab dist_cat if insample & muslim, sum(remit_gdp)
tab dist_cat if insample & muslim, sum(polity2)

***
* Table 2: Remittances, corruption, and POLITY2 scores in poor, non-oil producers 
tab cname if samp==1, sum(remit_gdp)
tab cname if samp==1, sum(corruption)
tab cname if samp==1, sum(polity2)
tab cname if samp==1 & muslim==1 


***
* Table 3: Summary statistics 
sum corruption remit_gdp remitpc lnremit lnremitpc leg_brit britcol prot80 ggdpcap lngdpcap lnpop pautoc polity2 autoc autoc_remit if samp==1


***
* Table 4: Annual change in government corruption
* All countries
tab chg_corruption if samp==1 

* Non-Muslim countries
tab chg_corruption if samp==1 & muslim==0

* Muslim countries
tab chg_corruption if samp==1 & muslim==1


/*
* NOTE: Data underlying figure 3 which accompanies table 4 
* For Muslim countries
tab year if samp==1 & year!=1984 & muslim==1 & chg_corruption==1, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==1 & chg_corruption==2, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==1 & chg_corruption==0, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==1 & chg_corruption==-1, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==1 & chg_corruption==-2, sum(dt_corruption)

* For Non-Muslim countries
tab year if samp==1 & year!=1984 & muslim==0 & chg_corruption==1, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==0 & chg_corruption==2, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==0 & chg_corruption==0, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==0 & chg_corruption==-1, sum(dt_corruption)
tab year if samp==1 & year!=1984 & muslim==0 & chg_corruption==-2, sum(dt_corruption)
*/

***
* Table 5: Determinants of corruption
reg corruption remit_gdp leg_brit britcol prot80 ggdpcap lngdpcap lnpop year if insample, cluster(govtcode)
reg corruption remit_gdp pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
reg corruption remit_gdp autoc autoc_remit pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)


* Table 6: First stage regression
* First stage :Use log distance in instrument (this is instb)
reg remit_gdp instrument lndmecca pautoc ggdpcap lngdpcap lnpop year britcol leg_brit prot80 if insample & corruption!=., cluster(govtcode)
test instrument

reg remit_gdp instrument pautoc ggdpcap lngdpcap lnpop year codummy* if insample & corruption!=., cluster(govtcode)
test instrument

reg remit_gdp linstrument pautoc ggdpcap lngdpcap lnpop year codummy* if insample & corruption!=., cluster(govtcode)
test linstrument

reg remit_gdp muslimoil pautoc ggdpcap lngdpcap lnpop year codummy* if insample & corruption!=., cluster(govtcode)
test muslimoil

reg remitpc instrument pautoc ggdpcap lngdpcap lnpop year codummy* if insample & corruption!=., cluster(govtcode)
test instrument


***
* Table 7: Second stage estimates

reg corruption remit_gdp pautoc ggdpcap lngdpcap lnpop year codummy* if insample & muslim==1, cluster(govtcode)
reg corruption remit_gdp autoc_remit autoc ggdpcap lngdpcap lnpop year codummy* if insample & muslim==1, cluster(govtcode)

ivreg corruption (remit_gdp=instrument) lndmecca pautoc ggdpcap lngdpcap lnpop year leg_brit britcol prot80 if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (lremit_gdp=linstrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)

ivreg corruption (autoc_remit=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (autoc_remit=instrument) autoc remit_gdp pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)

ivreg corruption (lnremit=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (lnremitpc=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)


***
* Table 8: Remittances and government patronage
ivreg pubsec (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg pubsec (lremit_gdp=linstrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg pubsec (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)

ivreg xconst (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg xconst (lremit_gdp=linstrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg xconst (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)

***
* Table 9: Alternate specifications
ivreg corruption (remit_gdp=instrument) corruption84_remit pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) pautoc84_remit pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)

ivreg corruption (remit_gdp=instrument) corruption84_lndmecca corruption84 lndmecca pautoc ggdpcap lngdpcap lnpop year if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) pautoc84_lndmecca pautoc84 lndmecca pautoc ggdpcap lngdpcap lnpop year if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) lngdpcap_lndmecca pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)

ivreg corruption4 (remit_gdp4=instrument4) pautoc4 ggdpcap4 lngdpcap4 lnpop4 yearavg4 sam africa asia if insample & remit_gdp!=. & year_dum4==1, robust 
ivreg corruption4 (remit_gdp4=instrument4) pautoc4 ggdpcap4 lngdpcap4 lnpop4 yearavg4 codummy* if insample & remit_gdp!=. & year_dum4==1 & (sam!=. & africa!=. & asia!=.), robust 


/*
* Additional: 4 year average regression, remittances per capita and log remittances per capita
ivreg corruption4 (remitpc4=instrument4) pautoc4 ggdpcap4 lngdpcap4 lnpop4 yearavg4 sam africa asia if insample & remit_gdp!=. & year_dum4==1, robust 
ivreg corruption4 (remitpc4=instrument4) pautoc4 ggdpcap4 lngdpcap4 lnpop4 yearavg4 codummy* if insample & remit_gdp!=. & year_dum4==1 & (sam!=. & africa!=. & asia!=.), robust 

ivreg corruption4 (lnremitpc4=instrument4) pautoc4 ggdpcap4 lngdpcap4 lnpop4 yearavg4 sam africa asia if insample & remit_gdp!=. & year_dum4==1, robust 
ivreg corruption4 (lnremitpc4=instrument4) pautoc4 ggdpcap4 lngdpcap4 lnpop4 yearavg4 codummy* if insample & remit_gdp!=. & year_dum4==1 & (sam!=. & africa!=. & asia!=.), robust 
*/

/*
* Additional: Differential trends (note: main effects are subsumed by country FE and year trend)
ivreg corruption (remit_gdp=instrument) muslim_autoc pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) muslim_cw pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) avgincome_year pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop asia_yr nam_yr sam_yr africa_yr europe_yr meast_yr year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year_ctry* if insample, cluster(govtcode)
*/



****
* Table 10: Exclusion restriction
ivreg corruption (remit_gdp=instrument) aid pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) gxrat pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) inf pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) trade pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_trade=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) media_freedom pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)

****
* Table 11: Mechanisms
* Panel A
ivreg measle (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg measle (remit_gdp=instrument) pautoc84 pautoc84_remit ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg measle (autoc_remit=instrument) autoc remit_gdp pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)

ivreg healthpub (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg healthpriv (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg school (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg transfers (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)

* Panel B
ivreg measle (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg measle (remitpc=instrument) pautoc84 pautoc84_remitpc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg measle (autoc_remitpc=instrument) autoc remitpc pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)

ivreg healthpub (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg healthpriv (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg school (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg transfers (remitpc=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)

/*
* Additional: Discounting other mechanisms
* Effect on taxes
ivreg inctax (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)
ivreg contax (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year sam africa asia if insample, cluster(govtcode)

* Anti-government demonstrations
ivreg demonstration (remit_gdp=instrument) pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
ivreg corruption (remit_gdp=instrument) demonstration pautoc ggdpcap lngdpcap lnpop year codummy* if insample, cluster(govtcode)
*/






