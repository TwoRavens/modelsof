clear
set more off

*****Data set-up
**excluding two excluded members
drop if excluded==1
**Amount of avaiable campaign funds as a share of constituency spending limit 
****************************************************************
****************************************************************
**RESULTS IN REVISED PAPER**************************************
****************************************************************
****************************************************************

**Main Results

**Figure 1
bys gov: ttest current, by(P2P)

**Table 1
regress current  govP2P gov P2P previous y2006, cluster(id)
lincom P2P+govP2P


*TABLE SI1: Treatment rate by Parliament and government/opposition status
bys gov: ttest P2P, by(y2006)
*Table SI2: Randomization Checks
ttest years_s, by(P2P)
bys y2006: ttest years_s, by(P2P)
ttest exminister, by(P2P)
bys y2006: ttest exminister, by(P2P)
bys y2006: ttest female, by(P2P)
ranksum years_s, by(P2P)
bys y2006: ranksum years_s, by(P2P)
ranksum exminister, by(P2P)
bys y2006: ranksum exminister, by(P2P)
bys y2006: ranksum female, by(P2P)


regress P2P years exminister female

*NOTE: Tables SI3 and SI4 results are in a third do file named: Reoffering_analysis_vf_desposited2013

*Table SI5
ttest current, by(P2P)
ttest previous, by(P2P)
bys gov: ttest current, by(P2P)
**Robustness checks. First check with outlier regression, then with quantile regression
*Table SI6
regress  current  govP2P gov P2P previous y2006, robust cluster(id)
lincom P2P+govP2P
*Table S17
qreg  current  govP2P gov P2P previous y2006
lincom P2P+govP2P


**Repeating analysis with place on paper, calculated as distance from the top of the list, normalized from 0 to 1


*Table SI9.  Opt outs left out.
regress  current  govP2P gov P2P previous y2006 if OPTOUT==0, cluster(id)
lincom P2P+govP2P

**Table SI10. Results excluding those who used Senate initiated legislation to jump the queue
regress  current  govP2P gov P2P previous y2006 if senate==0, cluster(id)
lincom P2P+govP2P
