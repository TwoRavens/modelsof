* The measure of US people killed
* Table 2
* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)

* Table 3
* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb   usarmsexports_milexpcomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usarmsexports_milexpcomb   usmilpers_milperscomb   if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb   usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)


* The measure of incidents involving US victims
* Table 2
* US military aid to domestic military expenditures 
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)

* Table 3
* US military aid to domestic military expenditures 
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb   usarmsexports_milexpcomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usarmsexports_milexpcomb   usmilpers_milperscomb   if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US military aid to domestic military expenditures 
xi: nbreg incidentsusvictims lnpopterr lndistance lngdppcconstterrorists polity2terrorists     usmilaid_milexpcomb   usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)

** Robustness tests
* Controlling for international and civil wars
* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     type1and2terrorists type3and4terrorists  usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      type1and2terrorists type3and4terrorists usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     type1and2terrorists type3and4terrorists  usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* All of the above together
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists     type1and2terrorists type3and4terrorists  usmilaid_milexpcomb  usarmsexports_milexpcomb   usmilpers_milperscomb    if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)

* Controlling for state sponsorship of terrorism
preserve
capture drop usstatesponsors
ge usstatesponsors=0
replace usstatesponsors=. if year<1978
replace usstatesponsors=1 if countryallterrorists=="Syrian Arab Republic" & year>=1978 
replace usstatesponsors=1 if countryallterrorists=="Iran, Islamic Rep." & year>=1984
replace usstatesponsors=1 if countryallterrorists=="Korea, Dem. Rep." & year>=1988
replace usstatesponsors=1 if countryallterrorists=="Cuba" & year>=1982
replace usstatesponsors=1 if countryallterrorists=="Sudan" & year>=1993 
replace usstatesponsors=1 if countryallterrorists=="Libya" & year>=1978 & year<2006
replace usstatesponsors=1 if countryallterrorists=="Iraq" & year>=1978 & year<1982
replace usstatesponsors=1 if countryallterrorists=="Iraq" & year>=1990 & year<2003
replace usstatesponsors=1 if countryallterrorists=="Yemen, Rep." & year>=1978 & year<1990
* Afghanistan not on the official list, but apparently only because US did not recognise Taliban as legitimate government of Afghanistan
replace usstatesponsors=1 if countryallterrorists=="Afghanistan" & year>=1996 & year<2002

* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usstatesponsors  usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists       usstatesponsors usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usstatesponsors  usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* All of the above together
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usstatesponsors  usmilaid_milexpcomb  usarmsexports_milexpcomb   usmilpers_milperscomb    if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
restore


* Terror attacks of "Indeterminate Arabs, Palestine" allocated randomly to 10 big Arab countries with few misssings (Algeria, Egypt, Jordan, Mali, Morocco, Saudi Arabia, Sudan, Syria, Tunisia, Yemen)
preserve
drop if year==1968
capture drop random
generate random=uniform()
replace  countryallterrorists="Algeria" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random<.1
replace  countryallterrorists="Egypt, Arab Rep." if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.1 & random<.2
replace  countryallterrorists="Jordan" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.2 & random<.3
replace  countryallterrorists="Mali" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.3 & random<.4
replace  countryallterrorists="Morocco" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.4 & random<.5
replace  countryallterrorists="Saudi Arabia" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.5 & random<.6
replace  countryallterrorists="Sudan" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.6 & random<.7
replace  countryallterrorists="Syrian Arab Republic" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.7 & random<.8
replace  countryallterrorists="Tunisia" if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.8 & random<.9
replace  countryallterrorists="Yemen, Rep." if  countryallterrorists=="Indeterminate Arabs, Palestine" & random>=.9 & random<1

keep country* year sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terroristsnew usmilaid_milexpcomb usarmsexports_milexpcomb usmilpers_milperscomb 
collapse (sum) sumuskilled (mean) lnpopterr lndistance lngdppcconstterrorists polity2terroristsnew usmilaid_milexpcomb usarmsexports_milexpcomb usmilpers_milperscomb, by( countryallterrorists countrytarget year)

* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists       usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* All of the above together
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilaid_milexpcomb  usarmsexports_milexpcomb   usmilpers_milperscomb    if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)

restore

* Two thirds of 9/11 non-terrorist victims allocated to Saudi-Arabia
preserve
replace sumuskilled=2000 if countryallterrorists=="Saudi Arabia" & year==2001
* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists       usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* All of the above together
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilaid_milexpcomb  usarmsexports_milexpcomb   usmilpers_milperscomb    if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
restore

* Pre 9/11 events only
preserve
drop if year>2001
* US military aid to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilaid_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* US arms exports to domestic military expenditures 
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists       usarmsexports_milexpcomb     if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
*  US military personnel to domestic military personnel
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilpers_milperscomb  if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
* All of the above together
xi: nbreg sumuskilled lnpopterr lndistance lngdppcconstterrorists polity2terrorists      usmilaid_milexpcomb  usarmsexports_milexpcomb   usmilpers_milperscomb    if  countrytarget=="United States" & countryallterrorists!="United States",  nolrtest level(90) cluster( countryallterrorists)
restore

* Terror on other arms exporters of top 10 arms exporters
xi: nbreg  allincidentsfirstvictfirstterr lnpopterr lndistance lngdppcconstterrorists polity2terrorists     armsexports_milexpcomb     if  countrytarget!="United States" & countryallterrorists!="United States" & countrytarget!=countryallterrorists,  nolrtest level(90) cluster( countryallterrorists)
xi: nbreg  killingsfirstvictfirstterr lnpopterr lndistance lngdppcconstterrorists polity2terrorists     armsexports_milexpcomb     if  countrytarget!="United States" & countryallterrorists!="United States"  & countrytarget!=countryallterrorists,  nolrtest level(90) cluster( countryallterrorists)
