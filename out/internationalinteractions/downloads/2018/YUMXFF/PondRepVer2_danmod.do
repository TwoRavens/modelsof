

/* DAN modified code:

(1) I created the interaction variable "labrights_polit" = longlaborrights*polity2
(2) code isn't working because i.year is a factor variable. But code will work if "est sto" is specified after the regression runs.
	So, I reset the estimates store line post each regression command. 
(3) Then, the "esttab" command will produce a table including each year dummy, wich no one wants. So I modify the esttab line so 
	in the options, I "keep" only the main variables in the regressions.
*/




*sort data for time series
sort iso3n year
xtset iso3n year

set more off

*Limit sample to those included in regression models
sureg (capinnonresident  longlaborrights polity2 labrights_polit  i.year, cluster(iso3n) robust) (capoutresident  longlaborrights polity2 labrights_polit  i.year, cluster(iso3n) robust) if midlowincome==1, corr
est sto labortimespolity_parse

predict newvar1 if e(sample)

****

*Regression models for table three
tsset iso3n year
xtabond2 capinnonresident L.capinnonresident  longlaborrights polity2 labrights_polit  i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident labortimespolity longlaborrights polity2)) robust small
est sto gmmininteract_parse

xtabond2 capinnonresident L.capinnonresident capoutresident  longlaborrights polity2 labrights_polit  i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmininteract_other

xtabond2 capinnonresident L.capinnonresident capoutresident  longlaborrights polity2 labrights_polit  balance loggdp gdppc totaltrade imf i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmininteract

xtabond2 capinnonresident L.capinnonresident capoutresident  longlaborrights polity2 labrights_polit  logintldebt balance loggdp gdppc totaltrade imf i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmininteractdebt

xtabond2 capoutresident L.capoutresident  longlaborrights polity2 labrights_polit  i.year  if midlowincome==1 , gmmstyle(L.(l.capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmoutinteract_parse

xtabond2 capoutresident L.capoutresident capinnonresident  longlaborrights polity2 labrights_polit  i.year  if midlowincome==1 , gmmstyle(L.(capinnonresident l.capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmoutinteract_other

xtabond2 capoutresident L.capoutresident capinnonresident  longlaborrights polity2 labrights_polit  balance loggdp gdppc totaltrade imf i.year  if midlowincome==1 , gmmstyle(L.(capinnonresident l.capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmoutinteract

xtabond2 capoutresident L.capoutresident capinnonresident  longlaborrights polity2 labrights_polit  logintldebt balance loggdp gdppc totaltrade imf i.year if midlowincome==1 , gmmstyle(L.(capinnonresident l.capoutresident labortimespolity longlaborrights polity2)) robust small
est sto gmmoutinteractdebt

*TABLE THREE
*Results for System GMM Models
esttab gmmininteract_parse gmmininteract_other gmmininteract gmmininteractdebt gmmoutinteract_parse gmmoutinteract_other gmmoutinteract gmmoutinteractdebt, replace b(2) se ar2 star(* 0.10 ** 0.05 *** 0.01) nogaps label keep(L.capoutresident capinnonresident  longlaborrights polity2 labrights_polit  logintldebt balance loggdp gdppc totaltrade imf)

esttab gmmininteract_parse gmmininteract_other gmmininteract gmmininteractdebt gmmoutinteract_parse gmmoutinteract_other gmmoutinteract gmmoutinteractdebt using tab3.rtf, compress replace b(2) se ar2 star(* 0.10 ** 0.05 *** 0.01) nogaps label keep(L.capoutresident capinnonresident  longlaborrights polity2 labrights_polit  logintldebt balance loggdp gdppc totaltrade imf)



***dan mod*****

cd "C:\Users\Daniel\Dropbox\Journal (II)\Replication Files\Pond\Vesion2_repl"


sureg (capinnonresident  longlaborrights polity2 labrights_polit  i.year, cluster(iso3n) robust) (capoutresident  longlaborrights polity2 labrights_polit  i.year, cluster(iso3n) robust) if midlowincome==1, corr
est sto labortimespolity_parse

esttab  labortimespolity_parse , b(2) se ar2 star(* 0.10 ** 0.05 *** 0.01) nogaps label




esttab  using file.tex, replace b(2) se ar2 star(* 0.10 ** 0.05 *** 0.01) nogaps label 



predict newvar1 if e(sample)


















