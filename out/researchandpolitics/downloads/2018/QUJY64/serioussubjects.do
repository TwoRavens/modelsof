ranksum infolev, by (treatment)
tabulate infolevbin treatment, chi2
pwcorr timespent infolev, sig
oneway timespent treatment, tabulate scheffe
anova timespent infolev treatment
anova timespent infolev##treatment
*table1
tabulate treatment infolev, row
  
*table 2
tabulate infolev treatment, summarize(timespent)

ranksum territory, by (treatment)
ranksum oil, by (treatment)
