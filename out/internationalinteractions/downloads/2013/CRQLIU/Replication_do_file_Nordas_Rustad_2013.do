**Replication file Nordås & Rustad (2013)
**"Sexual Exploitation and Abuse by Peacekeepers: Understanding Variation"

. use "Nordas_Rustad_2013_replication.dta", clear


*Table 2. Multivariate regressions: 1-2: Mission; 3-4: Host; 5: All*
logit sea post2005 year_count d_womres spousalrapelaw_tcc, cluster(mission)
logit sea post2005 year_count d_womres spousalrapelaw_tcc ln_milsizeavg, cluster(mission)
logit sea post2005 year_count lnhostgdp spousalrape_host, cluster(mission)
logit sea post2005 year_count lnhostgdp spousalrape_host ConflictSV ConflLevel, cluster(mission)
logit sea post2005 year_count d_womres spousalrapelaw_tcc ln_milsizeavg lnhostgdp spousalrape_host ConflictSV ConflLevel , cluster(mission)


**Online appendix**

*A1: Descriptive statistics
sum sea post2005 year_count d_womres spousalrapelaw_tcc ln_milsizeavg  lnhostgdp spousalrape_host ConflictSV ConflLevel

*A2: Correlation matrix
corr sea post2005 year_count d_womres spousalrapelaw_tcc ln_milsizeavg  lnhostgdp spousalrape_host ConflictSV ConflLevel

*A3. Bivariate regressions*
logit sea  post2005 , cluster(mission)
logit sea  year_count , cluster(mission)
logit sea  d_womres , cluster(mission)
logit sea  spousalrapelaw_tcc , cluster(mission)
logit sea  ln_milsizeavg , cluster(mission)
logit sea  lnhostgdp  , cluster(mission)
logit sea  spousalrape_host  , cluster(mission)
logit sea  ConflictSV  , cluster(mission)
logit sea  ConflLevel  , cluster(mission)
