clear
set more offuse "/Users/peterjohnloewen/Dropbox/PMB 1/AJPS/Final Data and Do Files/Main Data.dta"

*****Data set-up
**excluding two excluded members
drop if excluded==1**indicator of legislation initiated in the Senatereplace senate=0 if senate==.**indicator for members who had to power to propose but did notgen OPTOUT=0replace OPTOUT=1 if place<=87 & election==2006 & check==0replace OPTOUT=1 if place<117 & election==2008 & check==0***creating indicator of power to proposegen P2P=0replace P2P=1 if place<=87 & election==2006 replace P2P=1 if place<117 & election==2008**interaction with membership in government caucusgen govP2P=gov*P2P***Variables for mediation analysis 
**Amount of avaiable campaign funds as a share of constituency spending limit gen transfersshare=transfers/limitreplace transfersshare=0 if transferss==. & spending~=.gen donationsshare=amount/limitreplace donationss=0 if donationss==. & spending~=.gen SHARE=transferss+donationssreplace SHARE=1 if SHARE>1 & SHARE~=.********************************************************************************************************************************
****************************************************************
****************************************************************
**RESULTS IN REVISED PAPER**********************************************************************************************************************************************************************
****************************************************************
****************************************************************

**Main Results

**Figure 1
bys gov: ttest current, by(P2P)

**Table 1
regress current  govP2P gov P2P previous y2006, cluster(id)
lincom P2P+govP2P
**Mediation tests in paper *Media mentionsttest media_ if gov==1, by(P2P)*Qualityttest quality if gov==1, by(P2P)*Moneyttest SHARE if gov==1, by(P2P)***NOTE: Individual-level survey responses from the Canadian Election Study are available in a second dataset and dofile titled: Individual Level CES_revised_vf_desposited2013.do 
****SUPPORTING INFORMATION
*TABLE SI1: Treatment rate by Parliament and government/opposition statusbys y2006: ttest P2P, by(gov)
bys gov: ttest P2P, by(y2006)
*Table SI2: Randomization Checks
ttest years_s, by(P2P)
bys y2006: ttest years_s, by(P2P)
ttest exminister, by(P2P)
bys y2006: ttest exminister, by(P2P)ttest female, by(P2P)
bys y2006: ttest female, by(P2P)*the table footnote notes the following Wilcoxon rank sums
ranksum years_s, by(P2P)
bys y2006: ranksum years_s, by(P2P)
ranksum exminister, by(P2P)
bys y2006: ranksum exminister, by(P2P)ranksum female, by(P2P)
bys y2006: ranksum female, by(P2P)

*the table footnote notes the following f-test
regress P2P years exminister female

*NOTE: Tables SI3 and SI4 results are in a third do file named: Reoffering_analysis_vf_desposited2013

*Table SI5
ttest current, by(P2P)
ttest previous, by(P2P)
bys gov: ttest current, by(P2P)bys gov: ttest previous, by(P2P)bys gov y2006: ttest current, by(P2P)bys gov y2006: ttest previous, by(P2P)
**Robustness checks. First check with outlier regression, then with quantile regression
*Table SI6
regress  current  govP2P gov P2P previous y2006, robust cluster(id)
lincom P2P+govP2P
*Table S17
qreg  current  govP2P gov P2P previous y2006
lincom P2P+govP2P


**Repeating analysis with place on paper, calculated as distance from the top of the list, normalized from 0 to 1gen DISTANCE=(newplace-1)/231 if y2006==1replace DISTANCE=(newplace-1)/254 if y2006==0gen govDISTANCE=gov*DISTANCE*Table SI8estsimp regress current govDISTANCE gov DISTANCE previous y2006


*Table SI9.  Opt outs left out.
regress  current  govP2P gov P2P previous y2006 if OPTOUT==0, cluster(id)
lincom P2P+govP2P

**Table SI10. Results excluding those who used Senate initiated legislation to jump the queue
regress  current  govP2P gov P2P previous y2006 if senate==0, cluster(id)
lincom P2P+govP2P
