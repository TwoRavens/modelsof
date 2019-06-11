*sort data for time series
sort iso3n year
xtset iso3n year

*Limit sample to those included in regression models
eststo labortimespolity_parse: sureg (capinnonresident c.longlaborrights##c.polity2 i.year, cluster(iso3n) robust) (capoutresident c.longlaborrights##c.polity2 i.year, cluster(iso3n) robust) if midlowincome==1, corr
predict newvar1 if e(sample)

*Regression models for table three
tsset iso3n year
eststo gmmininteract_parse: xtabond2 capinnonresident L.capinnonresident labortimespolity longlaborrights polity2 i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident labortimespolity longlaborrights polity2)) robust small
eststo gmmininteract_other: xtabond2 capinnonresident L.capinnonresident capoutresident labortimespolity longlaborrights polity2 i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident capoutresident labortimespolity longlaborrights polity2)) robust small
eststo gmmininteract: xtabond2 capinnonresident L.capinnonresident capoutresident labortimespolity longlaborrights polity2 balance loggdp gdppc totaltrade imf i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident capoutresident labortimespolity longlaborrights polity2)) robust small
eststo gmmininteractdebt: xtabond2 capinnonresident L.capinnonresident capoutresident labortimespolity longlaborrights polity2 logintldebt balance loggdp gdppc totaltrade imf i.year  if midlowincome==1 , gmmstyle(L.(l.capinnonresident capoutresident labortimespolity longlaborrights polity2)) robust small
eststo gmmoutinteract_parse: xtabond2 capoutresident L.capoutresident labortimespolity longlaborrights polity2 i.year  if midlowincome==1 , gmmstyle(L.(l.capoutresident labortimespolity longlaborrights polity2)) robust small
eststo gmmoutinteract_other: xtabond2 capoutresident L.capoutresident capinnonresident labortimespolity longlaborrights polity2 i.year  if midlowincome==1 , gmmstyle(L.(capinnonresident l.capoutresident labortimespolity longlaborrights polity2)) robust small
eststo gmmoutinteract: xtabond2 capoutresident L.capoutresident capinnonresident labortimespolity longlaborrights polity2 balance loggdp gdppc totaltrade imf i.year  if midlowincome==1 , gmmstyle(L.(capinnonresident l.capoutresident labortimespolity longlaborrights polity2)) robust small
eststo gmmoutinteractdebt: xtabond2 capoutresident L.capoutresident capinnonresident labortimespolity longlaborrights polity2 logintldebt balance loggdp gdppc totaltrade imf i.year if midlowincome==1 , gmmstyle(L.(capinnonresident l.capoutresident labortimespolity longlaborrights polity2)) robust small

*TABLE THREE
*Results for System GMM Models
esttab gmmininteract_parse gmmininteract_other gmmininteract gmmininteractdebt gmmoutinteract_parse gmmoutinteract_other gmmoutinteract gmmoutinteractdebt using file.tex, replace se ar2 star(* 0.10 ** 0.05 *** 0.01) nogaps label 
