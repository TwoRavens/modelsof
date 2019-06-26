
/*
CIRI - CIRI repression index
PTS - Political terror scales
dm - Polity2 democracy
vandem - Vanhanen democracy index
dv - GDP per capita
pop - log population
wlth - log of energy consumption per capita
REP - CIRI binary
CIE_WLTH - CIE/wlth
dmmat - democratic maturity
lschool - education
forcon - foriegn conflict 
civcon - civil conflict
mil2 - military regime
brit - British colonial history
*/

sum

ologit  CIRI  dm     dv       pop lCIRI, cluster(panel)
ologit  CIRI  dm     dv   CIE pop lCIRI, cluster(panel)
ologit  PTS   dm     dv   CIE pop  lPTS, cluster(panel)
ologit  CIRI  vandem dv   CIE pop lCIRI, cluster(panel)
ologit  CIRI  dm     wlth CIE pop lCIRI, cluster(panel)
ologit  CIRI  dm     limr CIE pop lCIRI, cluster(panel)
ologit  CIRI              CIE pop lCIRI, cluster(panel)

logit   REP CIE      pop lREP, cluster(panel)
logit   REP CIE_WLTH pop lREP, cluster(panel)

ologit  CIRI CIE  dmmat trade west urbanpop lschool forcon civcon mil2 brit        pop lCIRI, cluster(panel)
ologit  CIRI CIE  dmmat                     lschool        civcon           ginhat pop lCIRI, cluster(panel)
ologit  PTS  CIE  dmmat trade west urbanpop lschool forcon civcon mil2 brit        pop  lPTS, cluster(panel)
ologit  PTS  CIE  dmmat trade               lschool        civcon           ginhat      lPTS, cluster(panel)


