/* **********************************************************/
/* Code to Replicate Results in 					        */
/* Strickland, James	                                    */
/* "America's Crowded Statehouses:                          */
/* Measuring and Explaining Lobbying in the American States"*/
/* In: State Politics and Policy Quarterly   				*/

*.do file for replicating regression results and figures presented in main text, using "Statehouses.dta"

use Statehouses.dta

*for generating descriptive statistics found in Table 2:

sum dyads, det
sum clients, det
sum lobbyists, det
sum foldedranney6yr, det
sum initiativestate,det
sum genexp, det
sum bowen000, det
sum termlimit, det
sum definitions, det
sum prohibitions, det
sum reports, det

*for generating Figure 2:

gen ratio = dyads/clients000
graph box clients dyads ratio if year==1989 | dyads<=12500 & year==2011, over(year)
drop ratio 

*for generating results of four models in Table 3, along with AIC:

nbreg dyads clients000 initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire, cluster(fips)
estat ic
nbreg dyads clients000 foldedranney6yr initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire, cluster(fips)
estat ic
nbreg dyads clients000 initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire i.fips i.year
estat ic
nbreg dyads clients000 foldedranney6yr initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire i.fips i.year
estat ic

*for generating results for four models in Table 4, along with AIC:

nbreg dyads clients000 lobbyists000 initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire, cluster(fips)
estat ic
nbreg dyads clients000 lobbyists000 foldedranney6yr initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire, cluster(fips)
estat ic
nbreg dyads clients000 lobbyists000 initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire i.fips i.year
estat ic
nbreg dyads clients000 lobbyists000 foldedranney6yr initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire i.fips i.year
estat ic

*for estimating models that were mentioned in footnote 5 on page 24, replace "bowen000" with "ncslstaff" in all models

*for generating Figure 3, first re-estimate Model 8 from Table 4:

nbreg dyads clients000 lobbyists000 foldedranney6yr initiativestate lnexp bowen000 termlimit definitions prohibitions reports defpro defrep  firmreport noexpire i.fips i.year

*then find predicted dyad totals for definitions under two reporting conditions, while holding all other variables at their means:

margins, at(definitions=0 reports=0 defrep=0) atmeans
margins, at(definitions=1 reports=0 defrep=0) atmeans
margins, at(definitions=2 reports=0 defrep=0) atmeans
margins, at(definitions=3 reports=0 defrep=0) atmeans
margins, at(definitions=4 reports=0 defrep=0) atmeans
margins, at(definitions=5 reports=0 defrep=0) atmeans
margins, at(definitions=6 reports=0 defrep=0) atmeans
margins, at(definitions=7 reports=0 defrep=0) atmeans

margins, at(definitions=0 reports=7 defrep=0) atmeans
margins, at(definitions=1 reports=7 defrep=7) atmeans
margins, at(definitions=2 reports=7 defrep=14) atmeans
margins, at(definitions=3 reports=7 defrep=21) atmeans
margins, at(definitions=4 reports=7 defrep=28) atmeans
margins, at(definitions=5 reports=7 defrep=35) atmeans
margins, at(definitions=6 reports=7 defrep=42) atmeans
margins, at(definitions=7 reports=7 defrep=49) atmeans

*these predicted values can then be inputed into a separate spreadsheet to create Figure 3:

use Figure3.dta
xtset reports
xtline dyads ci95 ciminus95 definitions
