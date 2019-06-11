use "L:\oil\REPLICATIONDATA.dta", clear

**************************************
************STAYER********************
**************************************

*MAIN RESULTS
reg voter tcohortXrogaland rogaland fylke_1 fylke_2 fylke_3 fylke_4 fylke_5 fylke_6 fylke_9 fylke_10 fylke_11 yr1957 yr1958 yr1959 yr1967 yr1968 mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1, cluster(idfylkecohort)

*LOGIT/PROBIT
logit voter i.tcohortXrogaland i.rogaland i.yr1957 i.yr1958 i.yr1959 i.yr1967 i.yr1968 i.fylke_1 i.fylke_2 i.fylke_3 i.fylke_4 i.fylke_5 i.fylke_6 i.fylke_9 i.fylke_10 i.fylke_11 i.mil95org i.komund93 i.mil95  i.valg89 i.komund96 i.monitor13 i.monitor11 i.monitor09 i.monitor07 if stayer==1 & sample==1, cluster(idfylkecohort)
margins, dydx(*)
probit voter i.tcohortXrogaland i.rogaland i.yr1957 i.yr1958 i.yr1959 i.yr1967 i.yr1968 i.fylke_1 i.fylke_2 i.fylke_3 i.fylke_4 i.fylke_5 i.fylke_6 i.fylke_9 i.fylke_10 i.fylke_11 i.mil95org i.komund93 i.mil95  i.valg89 i.komund96 i.monitor13 i.monitor11 i.monitor09 i.monitor07 if stayer==1 & sample==1, cluster(idfylkecohort)
margins, dydx(*)

*TRENDPLACEBO
reg voter faketcohortXrogaland rogaland yr1947 yr1948 yr1949 yr1957 yr1958 fylke_1 fylke_2 fylke_3 fylke_4 fylke_5 fylke_6 fylke_9 fylke_10 fylke_11 mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fakenewsample==1, cluster(idfylkecohort)

*COUNTYPLACEBO
reg voter tcohXfake_hed hed yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_opp opp yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_bus bus yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_ves ves yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_tel tel yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_aag aag yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_sfj sfj yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_mro mro yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_str str yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_ntr ntr yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1 & rogaland==0, cluster(idfylkecohort)

*EXCLUDING ONE COUNTY AT THE TIME
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_1==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_2==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_3==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_4==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_5==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_6==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_8==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_9==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_10==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & fylke_11==0 & sample==1, cluster(idfylkecohort)

*POWER
power twomeans .97 .93, sd(0.25) n(2336) alpha(.05) nrat(.07948244)
power twomeans .97 .93, sd(0.25) n(4500) alpha(.05) nrat(.07948244)

*WITHOUT COUNTY AND BIRTH FE TO GET "MAIN EFFECTS"
reg voter tcohortXrogaland tcohort rogaland  mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1, cluster(idfylkecohort)

*WLS ON AGGREGATED DATA
keep if stayer==1 & sample==1
reg voter tcohortXrogaland rogaland fylke_1 fylke_2 fylke_3 fylke_4 fylke_5 fylke_6 fylke_9 fylke_10 fylke_11 yr1957 yr1958 yr1959 yr1967 yr1968 mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if stayer==1 & sample==1, cluster(idfylkecohort)
keep if e(sample)==1
by idfylkecohort, sort: egen noobs = count(_n)
collapse (mean)  voter tcohortXrogaland noobs rogaland fylke_* yr1957 yr1958 yr1959 yr1967 yr1968, by(fylke yrbrn)
gen w = sqrt(noobs)
reg voter tcohortXrogaland fylke_* yr1957 yr1958 yr1959 yr1967 yr1968 [aweight= w], robust


**************************************
**************BIRTH*******************
**************************************

use "L:\oil\REPLICATIONDATA.dta", clear

*MAIN RESULTS
reg voter tcohortXrogaland rogaland fylke_1 fylke_2 fylke_3 fylke_4 fylke_5 fylke_6 fylke_9 fylke_10 fylke_11 yr1957 yr1958 yr1959 yr1967 yr1968 mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1, cluster(idfylkecohort)

*LOGIT/PROBIT
logit voter i.tcohortXrogaland i.rogaland i.yr1957 i.yr1958 i.yr1959 i.yr1967 i.yr1968 i.fylke_1 i.fylke_2 i.fylke_3 i.fylke_4 i.fylke_5 i.fylke_6 i.fylke_9 i.fylke_10 i.fylke_11 i.mil95org i.komund93 i.mil95  i.valg89 i.komund96 i.monitor13 i.monitor11 i.monitor09 i.monitor07 if birth==1 & sample==1, cluster(idfylkecohort)
margins, dydx(*)
probit voter i.tcohortXrogaland i.rogaland i.yr1957 i.yr1958 i.yr1959 i.yr1967 i.yr1968 i.fylke_1 i.fylke_2 i.fylke_3 i.fylke_4 i.fylke_5 i.fylke_6 i.fylke_9 i.fylke_10 i.fylke_11 i.mil95org i.komund93 i.mil95  i.valg89 i.komund96 i.monitor13 i.monitor11 i.monitor09 i.monitor07 if birth==1 & sample==1, cluster(idfylkecohort)
margins, dydx(*)

*TRENDPLACEBO
reg voter faketcohortXrogaland rogaland yr1947 yr1948 yr1949 yr1957 yr1958 fylke_1 fylke_2 fylke_3 fylke_4 fylke_5 fylke_6 fylke_9 fylke_10 fylke_11 mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fakenewsample==1, cluster(idfylkecohort)

*COUNTYPLACEBO
reg voter tcohXfake_hed hed yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_opp opp yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_bus bus yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_ves ves yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_tel tel yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_aag aag yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_sfj sfj yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_mro mro yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_str str yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)
reg voter tcohXfake_ntr ntr yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1 & rogaland==0, cluster(idfylkecohort)

*EXCLUDING ONE COUNTY AT THE TIME
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_1==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_2==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_3==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_4==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_5==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_6==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_8==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_9==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_10==0 & sample==1, cluster(idfylkecohort)
reg voter tcohortXrogaland rogaland yr1957 yr1958 yr1959 yr1967 yr1968 fylke_* mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & fylke_11==0 & sample==1, cluster(idfylkecohort)

*WITHOUT COUNTY AND BIRTH FE TO GET "MAIN EFFECTS"
reg voter tcohortXrogaland tcohort rogaland  mil95org komund93 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 if birth==1 & sample==1, cluster(idfylkecohort)

*WLS ON AGGREGATED DATA
keep if birth==1 & sample==1
reg voter tcohortXrogaland rogaland fylke_1 fylke_2 fylke_3 fylke_4 fylke_5 fylke_6 fylke_9 fylke_10 fylke_11 yr1957 yr1958 yr1959 yr1967 yr1968 mil95org komund93 mil95 omn02 valg89 komund96 monitor13 monitor11 monitor09 monitor07 monitor05 lokal2007 lokal2003 lokal2011 lokal1995 lokal1999 if birth==1 & sample==1, cluster(idfylkecohort)
keep if e(sample)==1
by idfylkecohort, sort: egen noobs = count(_n)
collapse (mean)  voter tcohortXrogaland noobs rogaland fylke_* yr1957 yr1958 yr1959 yr1967 yr1968, by(fylke yrbrn)
gen w = sqrt(noobs)
reg voter tcohortXrogaland fylke_* yr1957 yr1958 yr1959 yr1967 yr1968 [aweight= w], robust

