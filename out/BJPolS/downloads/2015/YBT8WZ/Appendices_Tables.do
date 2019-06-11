* Appendices_Tables.do
* This do-file is used to produce tables and figures in the Online Appendices in 
* the paper "Political Competition and Ethnic Riots in Democratic Transition: A Lesson from Indonesia"
* submitted to BJPS resubmission 
* Risa J. Toha
* Replication do-file
* Last updated: 5 June 2015
* run on Stata 12. 

* Note 1: please update the file pathways to match where you store the datasets in your personal computer
* Note 2: if not yet installed, download estout and esttab from within stata.

*********************
** Figure 1: Communal conflicts by regime type 1989-2013
** Last checked and rerun 25 May 2015

** open original Polity IV dataset
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/polity4_original.dta"
** take only necessary variables and observations
keep country year polity2
keep if year>1988
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/polity4_1989onwards.dta"

** open original UCDP nonstate data
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/ucdp_nonstate_original.dta"
** keep only events that were communal clashes, i.e., org==3
keep if org==3 & org!=.
keep org year location
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/ucdp_org3_new.dta"
rename location country
sort country year
** locate events that involve multiple countries
list country year if strpos(country,",")
count if strpos(country,",")
** update these events including multiple countries to only include one
** create a new var to identify whether events were originally coded to occur in multiple contries
gen multicountry=.
label var multicountry "events involving more than one country (y/n)?"
replace multicountry=1 if strpos(country,",")
replace multicountry=0 if multicountry==.
** create a new var for country that only identify one location
gen country_n=country
label var country_n "country adjusted to include only one location"
list year country_n if multicountry==1
rename country country_original
rename country_n country
label var country_original "Original location variable in UCDP data"

** Fix the observations that had multiple countries, to include only the first country listed; Fix country names that do not match with Polity IV codebook
replace country="Ethiopia" if country=="Ethiopia, Kenya" & year==1998
replace country="Ethiopia" if country=="Ethiopia, Kenya" & year==2000
replace country="Ethiopia" if country=="Ethiopia, Kenya" & year==2013
replace country="Ethiopia" if country=="Ethiopia, South Sudan" & year==2012
replace country="Kenya" if country=="Kenya, Ethiopia" & year==2005
replace country="Kenya" if country=="Kenya, Ethiopia" & year==2007
replace country="Kenya" if country=="Kenya, Ethiopia" & year==2009
replace country="Kenya" if country=="Kenya, Somalia" & year==2004
replace country="Kenya" if country=="Kenya, Sudan, South Sudan" & year==2011
replace country="Kenya" if country=="Kenya, Uganda" & year==2006
replace country="Kenya" if country=="Kenya, Uganda" & year==2008
replace country="Mali" if country=="Mali, Niger" & year==1997
replace country="USSR" if country=="Russia (Soviet Union)" & year==1989
replace country="USSR" if country=="Russia (Soviet Union)" & year==1990
replace country="Senegal" if country=="Senegal, Mauritania" & year==1989
replace country="South Sudan" if country=="South Sudan, Sudan" & year==2011
replace country="Sudan" if country=="Sudan, Chad" & year==1999
replace country="Sudan" if country=="Sudan, South Sudan" & year==2011
replace country="Sudan" if country=="Sudan, South Sudan" & year==2012
replace country="Yemen" if country=="Yemen (North Yemen)" & year==2004
replace country="Congo Kinshasa" if country=="DR Congo (Zaire)"

** merge m:m
merge m:m country year using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/polity4_1989onwards.dta"
list country year if _merge==1
** Sudan 2012 and 2013 were not scored in the Polity IV data
** Allow to stay missing

** Rerun this code, and check if I actually need to drop polity2
drop _merge polity2
** Rerun this, this line might not be necessary
merge m:m country year using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/polity4_1989onwards.dta"
keep if org==3
** There should only be 408 observations

** compare with original, figure out why there are 409 observations.
** Ethiopia 1993 is duplicated in polity original data
** Likely because eritrea split from ethiopia in 1993, and Ethiopia is counted as two different countries (pre- and post-split) in 1993. 
** Older (pre-split) Ethiopia is scored 0 on the polity2 variable, the new (post-split) Ethiopia is scored 1 on the polity2
** scode and ccode in original polity data are different
** I deleted the second Ethiopia observation with a polity2 score of 1, and kept only the Ethiopia 1993 observation with the polity2 score of 0, assuming that this was the score of the older/mother Ethiopia

* delete the ethiopia with a polity2 score of 1 in 1993
drop in 37/37
drop _merge

** categorize incidents based on their polity2 score 
gen democracies=.
gen anocracies=.
gen autocracies=.
label var democracies "Democracy (y/n)"
label var anocracies "Anocracy (y/n)"
label var autocracies "Autocracy (y/n)"
replace democracies=1 if polity2>5 & polity2!=.
replace anocracies=1 if polity2>-6 & polity2<6 & polity2!=. 
replace autocracies=1 if polity2<-5 & polity2!=. 
list country year polity2 if anocracies==. & democracies==. & auto==.
replace autocracies=0 if auto==.
replace anocracies=0 if ano==.
replace demo=0 if demo==.

** create a table tabulating # of countries based on regime type over years
count if ano==1
count if auto==1
count if demo==1
tabstat autocracies anocracies democracies, by(year) stat(sum)

** collapse and save as a different file to use to draw Figure 1
tabstat autocracies anocracies democracies, by(year) stat(sum)
collapse (sum) auto ano demo, by(year)
export excel using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/org3regimetype_final.csv", firstrow(variables)

** Open StackedPlot_revised.R to draw Figure 1 in Appendices


***********************
** Figure 2: count of riots per year 
** Last run: 25 May 2015
clear
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
tabstat unkomptemp, by(year) stat(sum)
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/riot_counts_year.dta"
collapse (sum) unkomptemp, by(year)
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/riot_counts_year.dta", replace

** Open countofriots.R to draw Figure 2 in Appendices


************************
** Table 1: Count of riots for 1999-2005 per province
** Last run: 25 May 2015
clear
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
tabstat unkomptemp, by (province) stat(sum)
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/riot_counts_province.dta"
collapse (sum) unkomptemp, by(province)
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/riot_counts_province.dta", replace
outsheet using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/riot_counts_province.xls"

************************* 
** Figure 3: Electoral competition 1990-2005
** Last run: 25 May 2015
clear
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
tabstat golkarvs revvotmar nongolkarvs, by(year) stat(mean)
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/elcompyear.dta"
collapse (mean) golkarvs revvotmar nongolkarvs, by(year)
gen votmar=-1*revvotmar
drop revvotmar
** put all the variables on the same scale to make graphing easier
replace golkarvs=golkarvs*100
replace nongolkarvs=nongolkarvs*100
save "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/replication trial/elcompyear.dta", replace

** Use elcompyear.R  to draw Figure 3 in Appendices

***************************

** Table 3: Summary Statistics
** Last run: 29 May 2015
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
sum unkomptemp riotsdeath sevviol revvotmar golkarvs gol8797_percent afterel b4el elyear revelprox nongolkarvs pdipvs muslimpartyvs2 lpdrbcap urban larea sepstrict java postsoeharto unkomptemp_1 lpop securityadj rel5050gr21 gr2relprop rel2dist50 rel3dist50 compgr2dist golgr2dist elf3 elf3sq elfeth turnopp delta_votmar
estpost sum unkomptemp riotsdeath sevviol revvotmar golkarvs gol8797_percent afterel b4el elyear revelprox nongolkarvs pdipvs muslimpartyvs2 lpdrbcap urban larea sepstrict java postsoeharto larea unkomptemp_1 lpop securityadj rel5050gr21 gr2relprop rel2dist50 rel3dist50 compgr2dist golgr2dist elf3 elf3sq elfeth turnopp delta_votmar
estout using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table_sumstats_final_2.xls", cells("count mean sd min max") replace 

****************************

** Table 4: Variable description and sources
** Written by hand; no code

****************************

** Figure 4: goodness of fit
** Use gof_pred_count_riots.R

****************************

** Table 5: Full results presented in Table 1 in the main paper
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m2, title(2)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==0
est store m4, title(4)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==1
est store m5, title(5)
estout m1 m2 m3 m4 m5 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table5_App_Final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace 
est stats m1 m2 m3 m4 m5

*****************************

** Table 6: IRR of results presented in Table 1 in the main paper
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m1irr, title(IRR Model 1)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m2irr, title(IRR Model 2)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m3irr, title(IRR Model 3)
esttab m1irr m2irr m3irr using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table6_App_Final.csv", legend label varlabels(_cons Intercept) eform csv replace

*****************************
** Figure 5: Predicted count of riots given varying levels of Golkar voteshare
** Use gof_pred_count_riots.R


****************************
** Results on Table 7
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp pdipvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m2, title(2)
xtnbreg unkomptemp muslimpartyvs2 afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtnbreg unkomptemp nongolkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m4, title(4)
estout m1 m2 m3 m4  using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table7_App_Final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4

** Figure 6: Party voteshares and count of riots
coefplot m1 || m2 || m3||m4, xline(0) keep (golkarvs pdipvs muslimpartyvs2 nongolkarvs) byopts(row(1))  order(golkarvs pdipvs muslimpartyvs nongolkarvs) levels (95)
graph save Graph "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Graph/Figure6_App_final.gph"

*****************************
** Results on Table 8: Party voteshare and violence full results, with fixed effects
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban postsoeharto if sepstrict==0, fe
est store m1, title(1)
xtnbreg unkomptemp pdipvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban postsoeharto if sepstrict==0, fe
est store m2, title(2)
xtnbreg unkomptemp muslimpartyvs2 afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban postsoeharto if sepstrict==0, fe
est store m3, title(3)
xtnbreg unkomptemp nongolkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban postsoeharto if sepstrict==0, fe
est store m4, title(4)
estout m1 m2 m3 m4  using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table8_App_Final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4

*********************
*** Results on Table 9: Party Voteshare and violence IRR 
use "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/BJPS_data_clean_052115.dta",
tis year
iis dist_c
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m1irr, title(Model 1 IRR)
xtnbreg unkomptemp pdipvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m2irr, title(Model 2 IRR)
xtnbreg unkomptemp muslimpartyvs2 afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m3irr, title(Model 3 IRR)
xtnbreg unkomptemp nongolkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, irr
est store m4irr, title(Model 4 IRR)
esttab m1irr m2irr m3irr m4irr using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table9_App_Final.csv", legend label varlabels(_cons Intercept) eform csv replace

** Results on Table 10: Table 1 results with fixed effects. 
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban postsoeharto if sepstrict==0, fe
est store m1, title(1)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban postsoeharto if sepstrict==0, fe
est store m2, title(2)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, fe
est store m3, title(3)
xtreg riotsdeath revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto if sepstrict==0, fe
est store m4, title(4)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto if sepstrict==0, fe
est store m5, title(5)
estout m1 m2 m3 m4 m5 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table10_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5

** Results on Table 11: Full results of Soeharto-era and Post-Soeharto era observations
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==0
est store m1, title(1)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==1
est store m2, title(2)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==0
est store m3, title(3)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==1
est store m4, title(4)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoehart==0
est store m5, title(5)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoehar==1
est store m6, title(6)
estout m1 m2 m3 m4 m5 m6 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table11_App_final.xls",cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 

** Results on Table 12: Full results of Soeharto-era and Post-soeharto era observations, with fixed effects. 
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban if sepstrict==0 & postsoeharto==0, fe
est store m1, title(1)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban if sepstrict==0 & postsoeharto==1, fe
est store m2, title(2)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban  if sepstrict==0 & postsoeharto==0, fe
est store m3, title(3)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban if sepstrict==0 & postsoeharto==1, fe
est store m4, title(4)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban if sepstrict==0 & postsoehart==0, fe
est store m5, title(5)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban if sepstrict==0 & postsoehar==1, fe
est store m6, title(6)
estout m1 m2 m3 m4 m5 m6 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table12_App_final.xls",cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 

** Results on Table 13: Full results of Table 2 of main paper
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if compcut3==0 & sepstrict==0
est store m2, title (2)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea urban if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0
est store m3, title (3)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0
est store m4, title (4)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0 & compcut3==0
est store m5, title (5)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea urban if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0
est store m6, title (6)
estout m1 m2 m3 m4 m5 m6  using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table13_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 

** Results on Table 14: IRR of results in Table 2 of main paper
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0, irr
est store m1irr, title(IRR Model 1)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if compcut3==0 & sepstrict==0, irr
est store m2irr, title (IRR Model 2)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea urban if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0, irr
est store m3irr, title (IRR Model 3)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0, irr
est store m4irr, title (IRR Model 4)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0 & compcut3==0, irr
est store m5irr, title (IRR Model 5)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea urban if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0, irr
est store m6irr, title (IRR Model 6)
esttab m1irr m2irr m3irr m4irr m5irr m6irr using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table14_App_Final.csv", legend label varlabels(_cons Intercept) eform csv replace

** Results on Table 15: Full results of Table 2 with fixed effects
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban if sepstrict==0, fe
est store m1, title(1)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban if compcut3==0 & sepstrict==0, fe
est store m2, title (2)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0, fe
est store m3, title (3)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban if sepstrict==0, fe
est store m4, title (4)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban if sepstrict==0 & compcut3==0, fe
est store m5, title (5)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0, fe
est store m6, title (6)
estout m1 m2 m3 m4 m5 m6  using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table15_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 

** Results on Table 16: Alternative measures of proximity to election 
xtnbreg unkomptemp revvotmar revelprox rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp golkarvs revelprox rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m2, title(2)
xtnbreg unkomptemp gol8797_percent revelprox rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtnbreg unkomptemp revvotmar elyear rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m4, title(4)
xtnbreg unkomptemp golkarvs elyear rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m5, title(5)
xtnbreg unkomptemp gol8797_percent elyear rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m6, title(6)
xtnbreg unkomptemp revvotmar b4el rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m7, title(7)
xtnbreg unkomptemp golkarvs b4el rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m8, title(8)
xtnbreg unkomptemp gol8797_percent b4el rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m9, title(9)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m10, title(10)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m11, title(11)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m12, title(12)
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table16_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12

** Results on Table 17: Alternative measures of ethnic composition/balance
xtnbreg unkomptemp revvotmar afterel elf3 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp golkarvs afterel elf3 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m2, title(2)
xtnbreg unkomptemp revvotmar afterel elf3 elf3sq unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtnbreg unkomptemp golkarvs afterel elf3 elf3sq unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m4, title(4)
xtnbreg unkomptemp revvotmar afterel gr2relprop unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m5, title(5)
xtnbreg unkomptemp golkarvs afterel gr2relprop unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m6, title(6)
xtnbreg unkomptemp revvotmar afterel rel2dist50  unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m7, title(7)
xtnbreg unkomptemp golkarvs afterel rel3dist50 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m8, title(8)
xtnbreg unkomptemp compgr2dist revvotmar rel2dist50 afterel  unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m9, title(9)
xtnbreg unkomptemp golgr2dist golkarvs rel2dist50 afterel unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m10, title(10)
xtnbreg unkomptemp revvotmar elfeth unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0
est store m11, title(11)
xtnbreg unkomptemp golkarvs elfeth unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0
est store m12, title(12)
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table17_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12

** Results on Table 18
** This was done in R. 
** Use ameliaimputedresults.R 

** Results on Table 19: Results of only provinces and years covered by UNSFIR data
*** Run regressions only on years 1990-2003 and provinces covered by UNSFIR data: Riau, Jakarta, Central Java, West Java, East Java, Banten, Central Kalimantan, West Kalimantan, South Sulawesi, Central Sulawesi, East Nusa Tenggara, West Nusa Tenggara, Maluku, North Maluku. 
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m1, title(1)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m2, title(2)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m3, title(3)
xtreg riotsdeath revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m4, title(4)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m5, title(5)
xtreg riotsdeath gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m6, title(6)
ologit sevviol revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m7, title(7)
ologit sevviol golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m8, title(8)
ologit sevviol gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & unsfirprov==1 & year<2004
est store m9, title(9)
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table19_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 m7 m8 m9

** Graphing Residuals in Figure 7
** OUTLIERS
** Check residuals
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
predict yhat
gen resid=.
replace resid=unkomptemp-yhat

** Figure 7: histogram of Residuals
hist resid
graph save Graph "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Graph/Figure7_App_final.gph", replace

sum resid, detail
** 3 standard deviations away from the mean residual
list district dist_c year revvotmar if resid>9.93 & resid!=. 
gen outliers=.
replace outliers=1 if dist_c==1309 & year==1999 | dist_c==1903 & year==1999 | dist_c==1903 & year==2000 | dist_c==1903 & year==2001| dist_c==1903 & year==2002 | dist_c==1904 & year==1999 | dist_c==1904 & year==2000 | dist_c==1904 & year==2001 | dist_c==1904 & year==2002
replace outliers=0 if outliers==.

** Results on Table 20
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & outliers==0
est store m2, title(2)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & outliers==0
est store m4, title(4)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m5, title(5)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0 & outliers==0
est store m6, title(6)
estout m1 m2 m3 m4 m5 m6 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table20_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6

** Table 21: Party voteshares in Poso elections
list district elyeardate muslimpartyvs golkarvs pdipvs nongolkarvs if year==1990 & dist_c==2808 | year==1993 & dist_c==2808 | year==1998 & dist_c==2808 | year==2000 & dist_c==2808 | year==2005 & dist_c==2808
** copy and paste table by hand, save in an excel file. 

** Table 22: Alternative dependent variables
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m2, title(2)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtreg riotsdeath revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0, fe
est store m4, title(4)
xtreg riotsdeath golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m5, title(5)
xtreg riotsdeath gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m6, title(6)
ologit sevviol revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m7, title(7)
ologit sevviol golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m8, title(8)
ologit sevviol gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m9, title(9)
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 using "/Users/risatoha/Documents/Political Competition/Revisions/Conditional Accept/Tables/Table22_App_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept) replace
est stats m1 m2 m3 m4 m5 m6 m7 m8 m9


