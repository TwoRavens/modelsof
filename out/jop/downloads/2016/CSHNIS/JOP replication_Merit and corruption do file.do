
*analysis for Careers, Connections, and Corruption Risks: Investigating the impact of bureaucratic meritocracy on public procurement processes
*by Nicholas Charron, Carl Dahlström, Mihály Fazekas, and Victor Lapuente
*published in Journal of Politics (2016)


*use data file: "JOP replication data.dta"


**TABLES**
**summary stats of variables
sum lcri_euc1_r lcri_neu_r allbribe pubmerit logpopdens capital logppp11 logppp00 pppgrowth theil_10 povrisk pctwomenparl trust partyfrac turnout pctprot pctcath noneuborn litrate_1880 yrsdem ethdiv wdi_gini t_ave w_c_ave

**Table 1 DV correlations
pwcorr lcri_euc1_r lcri_neu_r allbribe  eqi2013 revcorrpercepindex allbribe , sig obs

**Table 3: models 1-9 - after each 'estat vif' to check for multicollinearity
reg lcri_euc1_r pubmerit logpopdens capital [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit logppp11 [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit logppp00 [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit pppgrowth [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit noneuborn trust [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit theil_10 pctwomenparl [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit partyfrac turnout [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit logpopdens capital logppp11 noneuborn trust theil_10 pctwomenparl [w= eu_popweights ], vce(cluster country)

**searching for outliers (model 8 in Table 3), regression run without weights or robust standard errors to obtain Cook's D statistic
reg lcri_euc1_r pubmerit logpopdens capital logppp11 noneuborn trust theil_10 pctwomenparl 
predict d1, cooksd
**show outliers
tab nuts_r if d1>4/176 & d1!=.
**model removing outliers
reg lcri_euc1_r pubmerit logpopdens capital logppp11 noneuborn trust theil_10 pctwomenparl [w= eu_popweights ] if d1<4/176 & d1!=. , vce(cluster country)

**Table 4: marginal effects of meritocracy from model 8 in Table 4 (at means of all other IVs)
reg lcri_euc1_r pubmerit logpopdens capital logppp11 noneuborn trust theil_10 pctwomenparl [w= eu_popweights ], vce(cluster country)
margins, at( pubmerit=(2.21 3.62 4.07 4.64 5.7)) atmeans

**Table 5: model 1-6, IV regression (2SLS)
reg  pubmerit litrate_1880 [w= eu_popweights ], vce(cluster country)
reg  pubmerit pctprot [w= eu_popweights ], vce(cluster country)
reg  pubmerit litrate_1880 pctprot [w= eu_popweights ], vce(cluster country)
ivreg2 lcri_euac1_r logpopdens logppp11 trust pctwomenparl (pubmerit= pctprot litrate_1880) [w=eu_popweights ], r first
ivreg2 lcri_neu_r logpopdens logppp11 trust pctwomenparl (pubmerit= pctprot litrate_1880) [w=eu_popweights ], r first
ivreg2 allbribe logpopdens logppp11 trust pctwomenparl (pubmerit= pctprot litrate_1880) [w=eu_popweights ], r first

***manual check of intrument validity***
reg lcri_euc1_r pubmerit logpopdens logppp11  trust  pctwomenparl [w= eu_popweights ], vce(cluster country)
predict ehat2, resid
reg  ehat2 litrate_1880 [w= eu_popweights ], vce(cluster country)
reg  ehat2 pctprot [w= eu_popweights ], vce(cluster country)
reg  ehat2 litrate_1880 pctprot [w= eu_popweights ], vce(cluster country)

**Table 6: models 1-7, country level controls
xtmixed lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl yrsdem  [w= eu_popweights ] || country:, r
reg lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl yrsdem  [w= eu_popweights ], vce(cluster country)
xtmixed lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl ethdiv  [w= eu_popweights ] || country:, r
reg lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl ethdiv [w= eu_popweights ], vce(cluster country)
xtmixed lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl pressfreedom  [w= eu_popweights ] || country:, r
reg lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl pressfreedom [w= eu_popweights ], vce(cluster country)
xtmixed lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl yrsdem ethdiv pressfreedom  [w= eu_popweights ] || country:, r
reg lcri_euc1_r pubmerit logpopdens  logppp11  trust  pctwomenparl yrsdem ethdiv pressfreedom [w= eu_popweights ], vce(cluster country)

**Table A3: robust checks with alternative measrues of DV
reg lcri_neu_r pubmerit logpopdens capital  logppp00  noneuborn trust theil_10 pctwomenparl   [w= eu_popweights ], vce(cluster country)
reg lcri_neu_r pubmerit logpopdens capital  logppp00   trust  pctwomenparl  partyfrac turnout [w= eu_popweights ], vce(cluster country)
xtmixed lcri_neu_r pubmerit logpopdens  logppp11  trust  pctwomenparl yrsdem ethdiv pressfreedom  [w= eu_popweights ] || country:, r
reg allbribe pubmerit logpopdens capital  logppp00   noneuborn trust theil_10 pctwomenparl   [w= eu_popweights ], vce(cluster country)
reg allbribe pubmerit logpopdens capital  logppp00   trust  pctwomenparl  partyfrac turnout [w= eu_popweights ], vce(cluster country)
xtmixed allbribe pubmerit logpopdens  logppp11  trust  pctwomenparl yrsdem ethdiv pressfreedom  [w= eu_popweights ] || country:, r

**Table A4: robustness checks modelling spatial dependenceies of corruption**
reg lcri_euc1_r pubmerit logpopdens capital t_ave [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit logppp11 t_ave [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit logppp00 t_ave [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit pppgrowth t_ave[w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit noneuborn trust t_ave [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit theil_10 pctwomenparl t_ave [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit partyfrac turnout t_ave [w= eu_popweights ], vce(cluster country)
reg lcri_euc1_r pubmerit logpopdens capital logppp11 noneuborn trust theil_10 pctwomenparl t_ave [w= eu_popweights ], vce(cluster country)


**FIGURES**

**Figure A1 (bivariate correlations and scatterplots)
pwcorr lcri_euc1_r lcri_neu_r allbribe pubmerit, sig obs
scatter lcri_euc1_r pubmerit, saving(SB)
scatter lcri_neu_r pubmerit, saving(CRI_)
scatter allbribe pubmerit, saving(bribery)
gr combine  SB.gph CRI_.gph bribery.gph

**Figures 2 and 3: Boxplots
graph hbox lcri_neu_r if lcri_neu_r !=., over(country, sort (1))
graph hbox lcri_euac1_r if lcri_euac1_r !=., over(country, sort( 1))


***For Table 2 and Figure 1 see: digiwhist.eu/resources/data


**end file**





