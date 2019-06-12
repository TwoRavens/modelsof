 /*examining the effects of china vs US arms imports on democracy and human rights as reported in the article
 
 Enter the Dragon: An Empirical Examination of China vs US arms Transfers to Democracies and Violators of Human Rights*/

 use isqrepdata, replace
 
/*logistic with democracy as dep var because the two countries can be evaluated on same sample of countries*/

xi: logistic democ armsimportsCHNgdp armsimportsUSAgdp lngdppc i.year, cl(cow)
outreg using table1.rtf , nolabel 3aster replace

xi: logistic democ armsimportsCHNgdp armsimportsUSAgdp  lngdppc civilwar oil i.year, cl(cow)
outreg using table1.rtf , nolabel 3aster append
lroc

xi: logistic democ armsimportsCHNgdp armsimportsUSAgdp  lngdppc civilwar oil lnmilexp i.year , cl(cow)
outreg using table1.rtf , nolabel 3aster append

xi: newey democracy armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil lnmilexp i.year, force lag(1)
outreg using table1.rtf , nolabel 3aster append

/*with logged arms imports vars*/

xi: logistic democ lnnewarmsimportsCHNgdp lnnewarmsimportsUSAgdp lngdppc i.year, cl(cow)
xi: logistic democ lnnewarmsimportsCHNgdp lnnewarmsimportsUSAgdp lngdppc civilwar oil i.year, cl(cow)


/*OLS with Newey-West stadard errors that account for heteroscedasticity and autocorrelation with arms imports as dep var*/

xi: newey armsimportsUSAgdp democ lngdppc civilwar oil i.year, force lag(1)

xi: newey armsimportsCHNgdp democ lngdppc civilwar oil i.year, force lag(1)

xi: newey lnnewarmsimportsUSAgdp democ lngdppc civilwar oil i.year, force lag(1)

xi: newey lnnewarmsimportsCHNgdp democ lngdppc civilwar oil i.year, force lag(1)


/*logistic only AFRICA*/
xi: logistic democ armsimportsCHNgdp armsimportsUSAgdp lngdppc i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table2.rtf , nolabel 3aster replace

xi: logistic democ armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table2.rtf , nolabel 3aster append

xi: logistic democ armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil lnmilexp i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table2.rtf , nolabel 3aster append

xi: newey democracy armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil lnmilexp i.year if cow>401 & cow<626 | cow==651, force lag(1)
outreg using table2.rtf , nolabel 3aster append


/*OLS only AFRICA*/
xi: newey armsimportsUSAgdp democ lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, force lag(1)

xi: newey armsimportsCHNgdp democ lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, force lag(1)

xi: newey lnnewarmsimportsUSAgdp democ lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, force lag(1)

xi: newey lnnewarmsimportsCHNgdp democ lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, force lag(1)

/*testing US effect after dropping EGYPT*/
xi: newey lnnewarmsimportsUSAgdp democ lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651 & wbccode~="EGY", force lag(1)


/*OLS with PHYSINT */
xi: newey armsimportsUSAgdp  physint  lngdppc oil civilwar i.year , force lag(1)

xi: newey armsimportsCHNgdp physint  lngdppc oil civilwar i.year , force lag(1)

xi: oprobit physint armsimportsCHNgdp armsimportsUSAgdp democ lngdppc civilwar oil lnmilexp i.year, cl(cow)
outreg using table3.rtf, nolabel 3aster replace

xi: oprobit physint Lphysint armsimportsCHNgdp armsimportsUSAgdp democ lngdppc civilwar oil lnmilexp i.year, cl(cow)
outreg using table3.rtf, nolabel 3aster append



/*OLS with PHYSINT ONLY AFRICA*/

xi: newey armsimportsUSAgdp  physint  lngdppc oil civilwar i.year if cow>401 & cow<626 | cow==651, force lag(1)

xi: newey armsimportsCHNgdp physint  lngdppc oil civilwar i.year if cow>401 & cow<626 | cow==651, force lag(1)


xi: oprobit physint armsimportsCHNgdp armsimportsUSAgdp democ lngdppc civilwar oil lnmilexp i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table3.rtf, nolabel 3aster append

xi: oprobit physint Lphysint armsimportsCHNgdp armsimportsUSAgdp democ lngdppc civilwar oil lnmilexp i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table3.rtf, nolabel 3aster append

xi: oprobit physint Lphysint armsimportsCHNgdp armsimportsUSAgdp democ lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, cl(cow)

/*Who supports civil wars with arms?*/

xi: logistic civilwar armsimportsCHNgdp armsimportsUSAgdp lngdppc lnpop i.year, cl(cow)
outreg using table4.rtf, nolabel 3aster replace
xi: logistic civilwar l.civilwar armsimportsCHNgdp armsimportsUSAgdp lngdppc lnpop i.year, cl(cow)
outreg using table4.rtf, nolabel 3aster append
xi: logistic civilwar armsimportsCHNgdp armsimportsUSAgdp lngdppc lnpop i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table4.rtf, nolabel 3aster append
xi: logistic civilwar l.civilwar armsimportsCHNgdp armsimportsUSAgdp lngdppc lnpop i.year if cow>401 & cow<626 | cow==651, cl(cow)
outreg using table4.rtf, nolabel 3aster append

xi: logistic civilwar peaceyrs armsimportsCHNgdp armsimportsUSAgdp lngdppc lnpop i.year, cl(cow)
xi: logistic civilwar peaceyrs armsimportsCHNgdp armsimportsUSAgdp lngdppc lnpop i.year if cow>401 & cow<626 | cow==651, cl(cow)


/*ROBUSTNESS CHECKS including corruption, military in politics and external conflict*/
xi: logistic democ extconf armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year, cl(cow)
xi: logistic democ extconf armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, cl(cow)

xi: logistic democ milinpol armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year, cl(cow)
xi: logistic democ milinpol armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, cl(cow)

xi: logistic democ coc armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year, cl(cow)
xi: logistic democ coc armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil i.year if cow>401 & cow<626 | cow==651, cl(cow)

/*VIF test for multicollinearity among the indep vars*/
xi: regress democracy armsimportsCHNgdp armsimportsUSAgdp lngdppc civilwar oil lnmilexp i.year, cl(cow)
vif

keep cow country countryname year wbccode democ democracy physint armsimportsCHNgdp armsimportsUSAgdp lnnewarmsimportsCHNgdp lnnewarmsimportsUSAgdp lngdppc oil civilwar lnmilexp lnpop extconf milinpol coc peaceyrs Lphysint Ldemoc 
la var cow "Correlates of war country code"
la var wbccode "world bank country codes"
la var democ "Democ=1 if polity2>=6 in the PolityIV dataset & democ=0 if not"
la var democracy "polity2 scale + 11 to make continuous democracy measure from 1 to 21"
la var physint "Physical integrity rights scale from CIRI Human Rights dataset"
la var armsimportsCHNgdp "arms imports from China as a share of importing country's GDP--arms imports from SIPRI divided by current dollar GDP from WDI 2009"
la var armsimportsUSAgdp "arms imports from USA as a share of importing country's GDP--arms imports from SIPRI divided by current dollar GDP from WDI 2009"
la var lnnewarmsimportsCHNgdp "logged arms imports from CHN share of GDP--var logged by adding 1 to all values"
la var lnnewarmsimportsUSAgdp "logged arms imports from USA share of GDP--var logged by adding 1 to all values"
la var lngdppc "logged per capita income from World Bank's WDI2009 database"
la var oil "dummy variable taking value 1 if Oil exports greater than 1/3 of total export revenue from Fearon and Laitin (2003) updated using World Bank fuel exports data"
la var civilwar "the incidence of civil war with over 25 battle-related deaths from Uppsala Conflict Data Project"
la var lnmilexp "The logged value of military expenditures to GDP from WDI 2009"
la var lnpop "logged total population from WDI 2009"
la var extconf "ICRG data on degree of external conflict tensions as measured by the ICRG researcher dataset--see www.prs.com for more details"
la var milinpol "ICRG data on military involvement in politics"
la var coc "ICRG data on control of corruption"
la var Lphysint "physint lagged one year"
la var Ldemoc "democracy dummy lagged 1 year"

save isqrepdata, replace

exit
