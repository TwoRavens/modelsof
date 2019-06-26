
* models 
xi: ologit sumcit icsumcit asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumsus icsumsus asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumim icsumim asoon   afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumtot icsumtot asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year

* controls: unit dummy USA 
xi: ologit sumcit icsumcit asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 USA i.year
xi: ologit sumsus icsumsus asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 USA i.year
xi: ologit sumim icsumim asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 USA i.year
xi: ologit sumtot icsumtot asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 USA i.year

* controls: unit dummy Scandinavia 
xi: ologit sumcit icsumcit asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 scandinavia i.year
xi: ologit sumsus icsumsus asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 scandinavia   i.year
xi: ologit sumim icsumim asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 scandinavia  i.year
xi: ologit sumtot icsumtot asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1  scandinavia i.year

* controls: unit dummy colonialism 
xi: ologit sumcit icsumcit asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 colony i.year
xi: ologit sumsus icsumsus asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 colony i.year
xi: ologit sumim icsumim asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 colony  i.year
xi: ologit sumtot icsumtot asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 colony i.year

* controls: time-varying regressors lagged  
xi: ologit sumcit icsumcit asoon afghanistan gnppc_l1 loggdp_l1 me_l1 dpi_mdmh_l1 dpi_checks_l1 gov_right1 gov_left1 i.year
xi: ologit sumsus icsumsus asoon afghanistan gnppc_l1 loggdp_l1 me_l1 dpi_mdmh_l1 dpi_checks_l1 gov_right1 gov_left1 i.year
xi: ologit sumim icsumim asoon afghanistan gnppc_l1 loggdp_l1 me_l1 dpi_mdmh_l1 dpi_checks_l1 gov_right1 gov_left1 i.year
xi: ologit sumtot icsumtot asoon afghanistan gnppc_l1 loggdp_l1 me_l1 dpi_mdmh_l1 dpi_checks_l1 gov_right1 gov_left1 i.year
 
* terrorist incidents (ITERATE)
xi: ologit sumcit icsumcit incidents asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumsus icsumsus asoon incidents afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumim icsumim asoon incidents afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumtot icsumtot asoon incidents afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year

* incidents instrumented (see model 1 of Pluemper-Neumayer, 2010 for choice of instruments)
xi: ologit sumcit icsumcit predinc asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumsus icsumsus predinc asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumim icsumim  predinc asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year
xi: ologit sumtot icsumtot predinc asoon afghanistan wdi_me gdp_log gnppc dpi_mdmh dpi_checks  gov_right1 gov_left1 i.year

* casewise Jacknife test
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=1
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=2
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=3
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=4
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=5
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=6
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=7
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=8
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=9
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=10
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=11
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=12
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=13
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=14
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=15
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=16
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=17
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=18
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=19
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=20
ologit sumcit icsumcit asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=21

ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=1
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=2
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=3
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=4
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=5
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=6
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=7
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=8
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=9
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=10
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=11
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=12
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=13
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=14
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=15
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=16
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=17
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=18
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=19
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=20
ologit sumsus  icsumsus asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=21

ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=1
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=2
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=3
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=4
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=5
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=6
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=7
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=8
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=9
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=10
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=11
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=11
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=13
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=14
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=15
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=16
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=17
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=18
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=19
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=20
ologit sumimm  icsumim asoon  afghanistan wdi_me gdp_log gnppc dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=21


ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=1
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=2
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=3
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=4
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=5
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=6
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=7
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=8
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=9
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=10
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=11
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=11
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=13
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=14
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=15
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=16
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=17
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=18
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=19
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=20
ologit sumtot  icsumtot asoon  afghanistan wdi_me gdp_log gnppc  dpi_mdmh  dpi_checks  gov_right1 gov_left1 i.year if id~=21








