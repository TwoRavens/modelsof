*************************************************************************************************************

*When using these data please cite:
*Bishop, Sylvia & Anke Hoeffler. 2016. Free and Fair Elections - A New Database. Journal of Peace Research. 
*Do file to replicate the variables free&fair election, free election, fair election, Tables II & III

*************************************************************************************************************

use "C:\F&Fv1.dta", clear

*************data organization***********************
*-33 na
*-22 no information
*0 does not fulfill the standard
*1 does fulfill the standard

* Problems may be underreported, instances of violation of rules, violence and intimidation not reported , this leads to too many false negatives
* one potential way is to use no information as 'no problems' ie code as one

replace  legalframework=. if legalframework==-22
replace  embs=. if embs==-22
replace  electoralrights=. if  electoralrights==-22
replace  voterregister=. if  voterregister==-22
replace  ballotaccess=. if ballotaccess==-22
replace campaignprocess=. if  campaignprocess==-22
replace  mediaaccess=. if  mediaaccess==-22
replace  votingprocess=. if  votingprocess==-22
replace  roleofofficials=. if  roleofofficials==-22
replace  countingofvotes=. if  countingofvotes==-22


egen infocount=rownonmiss( legalframework embs electoralrights voterregister ballotaccess campaignprocess mediaaccess votingprocess roleofofficials countingofvotes)

tab infocount

list cow country year if infocount==0

sum legalframework embs electoralrights voterregister ballotaccess campaignprocess mediaaccess votingprocess roleofofficials countingofvotes

tab embs
list cow country year if embs==-33
replace embs=1 if embs==-33

tab voterregister
list cow country year if voterregister==-33

replace  voterregister=1 if voterregister==-33 & cow==630
replace  voterregister=1 if voterregister==-33 & cow==367
replace  voterregister=0 if voterregister==-33 & cow==850

*overall quality of the election

egen missing=rowmiss( legalframework embs electoralrights voterregister ballotaccess campaignprocess mediaaccess votingprocess roleofofficials countingofvotes)

egen electotal = rowtotal (legalframework embs electoralrights voterregister ballotaccess campaignprocess mediaaccess votingprocess roleofofficials countingofvotes), missing

*tab electotal if missing<5
*gen ffelec=.
*replace ffelec=0 if electotal<5 & missing<5
*replace ffelec=1 if electotal>=5 & missing<5
*tab ffelec

*rowtotal, missing creates the row sum, treating missing as 0. If missing is specified and all values in varlist are missing for an observation, newvar is set to missing

egen freetotal = rowtotal (legalframework embs electoralrights voterregister ballotaccess campaignprocess mediaaccess), missing

egen fairtotal = rowtotal (votingprocess roleofofficials countingofvotes), missing

*tab freetotal if ffelec~=.
*tab fairtotal if ffelec~=.

gen freelec=.
replace freelec=0 if freetotal<4&freetotal~=.&fairtotal~=. 
replace freelec=1 if freetotal>=4&freetotal~=.&fairtotal~=. 

gen fairelec=.
replace fairelec=0 if fairtotal<2&freetotal~=.&fairtotal~=.
replace fairelec=1 if fairtotal>=2&freetotal~=.&fairtotal~=.

gen ffelec=.
replace ffelec=0 if freelec==0
replace ffelec=0 if fairelec==0
replace ffelec=1 if freelec==1 & fairelec==1

tab ffelec

*Table II
tab freelec fairelec

*************************************************************************
******************regressions Table III**********************************
*************************************************************************

use "C:\BHelection.dta", clear

probit ff lnyAV3  wdiAV3_natresrents_gdp AV3aid_gdp wdi_econpol_trade_gdp observerpresent polity_exconst dpi_finittrm presidential fourthwave east_asia_pacific europe_central_asia mena south_asia subsaharan_africa , robust cluster(country)

*At the mean
 display normal(-1.19554)
*.11593806

*exec constraints=0 & observerspresent=0
display normal(-2.24526)
*.01237572

*exec constraints=1 & observerspresent=1
display normal(-0.4584)
*.32333255

sum ff lnyAV3  wdiAV3_natresrents_gdp AV3aid_gdp wdi_econpol_trade_gdp observerpresent polity_exconst dpi_finittrm presidential fourthwave east_asia_pacific europe_central_asia mena south_asia subsaharan_africa if e(sample)
 
probit ffe_free_election  lnyAV3  wdiAV3_natresrents_gdp AV3aid_gdp wdi_econpol_trade_gdp observerpresent polity_exconst dpi_finittrm presidential fourthwave east_asia_pacific europe_central_asia mena south_asia subsaharan_africa, robust cluster(country)


probit ffe_fair_election  lnyAV3  wdiAV3_natresrents_gdp AV3aid_gdp wdi_econpol_trade_gdp observerpresent polity_exconst dpi_finittrm presidential fourthwave  east_asia_pacific europe_central_asia mena south_asia subsaharan_africa, robust cluster(country)































