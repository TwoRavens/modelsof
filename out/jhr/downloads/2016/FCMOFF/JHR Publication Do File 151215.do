*Table 2
*Level of Disappearances
*Ordered Logit: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009
set more off

*Level of Disappearances Excludes Controls
ologit disap  killchangelagiccprratified killchangelag iccprratified  disaplag, robust cluster (ccode)
**outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 2: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace

*Level of Disappearances Includes Other Types of Violations & Excludes political economic and conflict controls 
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  disaplag, robust cluster (ccode)
**outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(*, **, *, ^) label ti(Table 2: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Includes Other Types of Violations & Domestic Political Factors &  & Excludes economic and conflict controls
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol  disaplag, robust cluster (ccode)
**outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 2: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Includes Other Types of Violations & Domestic Political Factors & Economic Factors & conflict controls 
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc  logpop openc  disaplag, robust cluster (ccode)
**outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 2: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model
set more off
ologit disap killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
**outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 2: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Two Stage Least Squares: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009
*Level of Disappearances Full Model
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (iccprratified =  regionalintegration), robust endogtest (iccprratified) ffirst
**outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 2: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Table 3
*Change in Disappearances Excludes Controls
ologit disapchange  killchangelagiccprratified killchangelag iccprratified  disaplag, robust cluster (ccode)
**outreg2 using table3, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 4: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) replace

*Change in Disappearances Includes Other Types of Violations & Excludes political economic and conflict controls 
set more off
ologit disapchange  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  disaplag, robust cluster (ccode)
**outreg2 using table3, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 4: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append

*Change in Disappearances Includes Other Types of Violations & Domestic Political Factors &  & Excludes economic and conflict controls
set more off
ologit disapchange  killchangelagiccprratified killchangelag iccprratified tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol  disaplag, robust cluster (ccode)
**outreg2 using table3, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 4: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append

*Change in Disappearances Includes Other Types of Violations & Domestic Political Factors & Economic Factors & conflict controls 
set more off
ologit disapchange  killchangelagiccprratified killchangelag iccprratified tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc  logpop openc  disaplag, robust cluster (ccode)
**outreg2 using table3, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 4: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append

*Change in Disappearances Full Model
set more off
ologit disapchange  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
**outreg2 using table3, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 4: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append
*margins, dydx(killchangelagiccprratified)
*mfx, predict (p outcome(2)) at (killchangelagiccprratified=-2)
*mfx, predict (p outcome(2)) at (killchangelagiccprratified=-1)
*mfx, predict (p outcome(2)) at (killchangelagiccprratified=0)
*mfx, predict (p outcome(2)) at (killchangelagiccprratified=1)
*mfx, predict (p outcome(2)) at (killchangelagiccprratified=2)
*mfx, predict (p outcome(1)) at (killchangelagiccprratified=-2)
*mfx, predict (p outcome(1)) at (killchangelagiccprratified=-1)
*mfx, predict (p outcome(1)) at (killchangelagiccprratified=0)
*mfx, predict (p outcome(1)) at (killchangelagiccprratified=1)
*mfx, predict (p outcome(1)) at (killchangelagiccprratified=2)
*mfx, predict (p outcome(0)) at (killchangelagiccprratified=-2)
*mfx, predict (p outcome(0)) at (killchangelagiccprratified=-1)
*mfx, predict (p outcome(0)) at (killchangelagiccprratified=0)
*mfx, predict (p outcome(0)) at (killchangelagiccprratified=1)
*mfx, predict (p outcome(0)) at (killchangelagiccprratified=2)
*mfx, predict (p outcome(-1)) at (killchangelagiccprratified=-2)
*mfx, predict (p outcome(-1)) at (killchangelagiccprratified=-1)
*mfx, predict (p outcome(-1)) at (killchangelagiccprratified=0)
*mfx, predict (p outcome(-1)) at (killchangelagiccprratified=1)
*mfx, predict (p outcome(-1)) at (killchangelagiccprratified=2)
*mfx, predict (p outcome(-2)) at (killchangelagiccprratified=-2)
*mfx, predict (p outcome(-2)) at (killchangelagiccprratified=-1)
*mfx, predict (p outcome(-2)) at (killchangelagiccprratified=0)
*mfx, predict (p outcome(-2)) at (killchangelagiccprratified=1)
*mfx, predict (p outcome(-2)) at (killchangelagiccprratified=2)

*Two Stage Least Squares: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009
*Change in Disappearances Full Model
set more off
ivreg2 disapchange killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration), robust endogtest (iccprratified) ffirst
**outreg2 using table3, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Table 4: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append


*Appendix A Descriptive Statistics
sum disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year regionalintegration
sum year if year<2010

*Appendix B Pairwise Correlations
corr  killchangelagiccprratified killchangelag tortlag polprislag ingosipol igosipol iccprratified loggdppc  percentchangegdppc democ logpop openc interstatewarincidence civilwarincidence  defactojudicialindependencelag year
collin   killchangelagiccprratified killchangelag tortlag polprislag ingosipol igosipol iccprratified loggdppc  percentchangegdppc democ logpop openc interstatewarincidence civilwarincidence  defactojudicialindependencelag year

corr totalICCPRrat icrg_bq taxratio killchangelagiccprratified killchangelag tortlag polprislag ingosipol igosipol iccprratified loggdppc  percentchangegdppc democ logpop openc interstatewarincidence civilwarincidence  defactojudicialindependencelag year
collin  totalICCPRrat taxratio killchangelagiccprratified killchangelag tortlag polprislag ingosipol igosipol iccprratified loggdppc  percentchangegdppc democ logpop openc interstatewarincidence civilwarincidence  defactojudicialindependencelag year

*Note Appendix C is disucssion of the first stage instruments.

*Appendix D

*Two Stage Least Squares LIML: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009
*Level of Disappearances Full Model LIML Model
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc  democ logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration), robust liml endogtest (iccprratified) ffirst
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixC: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace


*Two Stage Least Squares GMM: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009
*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration), robust gmm2s endogtest (iccprratified) ffirst
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixC: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Bivariate Ordered Probit: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009
*Level of Disappearances Full Model Bivariate Ordered Probit
set more off
bioprobit(disap = iccprratified killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration), robust cluster(ccode)
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixC: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Appendix E

*Two Stage Least Squares LIML: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009
*Change in Disappearances Full Model
set more off
ivreg2 disapchange killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc  democ logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration), robust liml endogtest (iccprratified) ffirst
**outreg2 using AppendixE, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixD: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) replace

*Two Stage Least Squares GMM: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009
*Change in Disappearances Full Model
set more off
ivreg2 disapchange killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration), robust gmm2s endogtest (iccprratified) ffirst
**outreg2 using AppendixE, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixD: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append

*Bivariate Ordered Probit: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009
*Change in Disappearances Full Model
set more off
bioprobit(disapchange = iccprratified killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration), robust cluster(ccode)
**outreg2 using AppendixE, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixD: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced disapchangepearance 1981-2009, All Countries) ct(Forced disapchangepearance) append


*Appendix F

*Addition of ICC Membership
*Two Stage Least Squares: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009
*Level of Disappearances Full Model
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  iccmembership democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
**outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixE: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace

*Level of Disappearances Full Model 2SLS
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag iccmembership democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust endogtest (iccprratified) ffirst
**outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixE: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model LML
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag iccmembership democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust liml endogtest (iccprratified) ffirst
**outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixE:: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag iccmembership democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust gmm2s endogtest (iccprratified) ffirst
**outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixE: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model
set more off
bioprobit(disap = iccprratified killchangelagiccprratified killchangelag iccmembership tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration), robust cluster(ccode)
**outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixE: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Appendix G
*Removing Latin American and Carribean Cases 

*Level of Disappearances Full Model
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag if latinamericacarrib==0, robust cluster (ccode)
**outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixF: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace

*Level of Disappearances Full Model 2SLS
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (iccprratified =  regionalintegration) if latinamericacarrib==0, robust endogtest (iccprratified) ffirst
**outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixF: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model LML
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration) if latinamericacarrib==0,robust liml endogtest (iccprratified) ffirst
**outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixF: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration) if latinamericacarrib==0,robust gmm2s endogtest (iccprratified) ffirst
**outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixF: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model Bivariate Ordered Probit
set more off
bioprobit(disap = iccprratified killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration) if latinamericacarrib==0, robust cluster(ccode)
**outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixF: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Appendix H
*Adding measure of State Capacity, ICRG Measure 

*Level of Disappearances Full Model
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag icrg_bq ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
**outreg2 using AppendixH, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixG: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace


*Level of Disappearances Full Model 2SLS
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag icrg_bq ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (iccprratified =  regionalintegration), robust endogtest (iccprratified) ffirst
**outreg2 using AppendixH, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixG: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model LML
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag icrg_bq ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust liml endogtest (iccprratified) ffirst
**outreg2 using AppendixH, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixG: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag icrg_bq ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust gmm2s endogtest (iccprratified) ffirst
**outreg2 using AppendixH, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixG: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model Bivariate Ordered Probit
set more off
bioprobit(disap = iccprratified killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag icrg_bq ingosipol igosipol loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration), robust cluster(ccode)
**outreg2 using AppendixH, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixG: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Appendix I
*Adding measure of State Capacity, Tax Ratio Measure 

*Level of Disappearances Full Model
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag taxratio ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
**outreg2 using AppendixI, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixH: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace


*Level of Disappearances Full Model 2SLS
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag taxratio ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (iccprratified =  regionalintegration), robust endogtest (iccprratified) ffirst
**outreg2 using AppendixH, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixH: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model LML
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag taxratio ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust liml endogtest (iccprratified) ffirst
**outreg2 using AppendixI, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixH: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag taxratio ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust gmm2s endogtest (iccprratified) ffirst
**outreg2 using AppendixI, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixH: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model
set more off
bioprobit(disap = iccprratified killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag taxratio ingosipol igosipol loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration), robust cluster(ccode)
**outreg2 using AppendixI, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixH: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Appendix J
*Adding measure of ICCPR Regime Strength  

*Level of Disappearances Full Model
set more off
ologit disap  killchangelagiccprratified killchangelag iccprratified tortlag polprislag  democ defactojudicialindependencelag ingosipol totalICCPRrat  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
**outreg2 using AppendixJ, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixI: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace


*Level of Disappearances Full Model 2SLS
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol totalICCPRrat loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (iccprratified =  regionalintegration), robust endogtest (iccprratified) ffirst
**outreg2 using AppendixJ, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixI: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model LML
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol totalICCPRrat loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust liml endogtest (iccprratified) ffirst
**outreg2 using AppendixJ, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixI: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol totalICCPRrat loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag (iccprratified =  regionalintegration),robust gmm2s endogtest (iccprratified) ffirst
**outreg2 using AppendixJ, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixI: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Level of Disappearances Full Model Bivariate Ordered Probit
set more off
bioprobit(disap = iccprratified killchangelagiccprratified killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol totalICCPRrat loggdppc  percentchangegdppc  logpop openc interstatewarincidence civilwarincidence year  disaplag)  (iccprratified =  regionalintegration), robust cluster(ccode)
**outreg2 using AppendixJ, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(AppendixI: Ratification of the International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append


*Appendix K
*Adding measure of Optional Protocol 

*Level of Disappearances Full Model
set more off
ologit disap killchangelagoptionalprotocolrat killchangelag optionalprotratification tortlag polprislag  democ defactojudicialindependencelag ingosipol igosipol  loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence  year  disaplag, robust cluster (ccode)
*outreg2 using AppendixK, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Appendix K: Ratification of the Optional Protocol International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) replace

*Level of Disappearances Full Model 2SLS
set more off
ivreg2 disap killchangelagoptionalprotocolrat killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (optionalprotratification =  regionalintegration), robust endogtest (optionalprotratification) ffirst
*outreg2 using AppendixK, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Appendix K: Ratification of the Optional Protocol International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model LIML
set more off
ivreg2 disap killchangelagoptionalprotocolrat killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (optionalprotratification =  regionalintegration), robust liml endogtest (optionalprotratification) ffirst
*outreg2 using AppendixK, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Appendix K: Ratification of the Optional Protocol International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model GMM
set more off
ivreg2 disap killchangelagoptionalprotocolrat killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag  (optionalprotratification =  regionalintegration), robust gmm2s endogtest (optionalprotratification) ffirst
*outreg2 using AppendixK, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Appendix K: Ratification of the Optional Protocol International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

*Level of Disappearances Full Model Bivariate Ordered Probit
set more off
bioprobit (disap = killchangelagoptionalprotocolrat killchangelag tortlag polprislag democ defactojudicialindependencelag ingosipol igosipol loggdppc  percentchangegdppc logpop openc interstatewarincidence civilwarincidence year  disaplag)  (optionalprotratification =  regionalintegration), robust cluster(ccode)
*outreg2 using AppendixK, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) label ti(Appendix K: Ratification of the Optional Protocol International Covenant on Civil and Political Rights & The Substitution of Extra Judicial Killing and Forced Disappearance 1981-2009, All Countries) ct(Forced Disappearance) append

log close




