use "d:/users/andrey/dropbox/data/investing in violence/replication.dta", clear


*** Table 1

	*Model 2
ivprobit coup  agereg csum unrest milreg  milper1 gdppc3 gdppcgrowth   milexp3 coupyears  t t2 t3 (lnfdi3= mwlgdp  agrprop larea) if democracy<1 , cluster(ccode) robust
	*Model 1
probit coup  agereg csum unrest milreg milper1 gdppc3 gdppcgrowth    milexp3 coupyears  t t2 t3  if democracy<1 & e(sample), cluster(ccode) robust
	capture predict yhat
	*Model 3
ivprobit coup  agereg csum linf unrest  milreg milper1 gdppc3 gdppcgrowth   milexp3  coupyears  t t2 t3 (lnfdi3= mwlgdp  agrprop larea  ) if democracy<1 , cluster(ccode) robust
	*Model 4
ivprobit coup   agereg csum linf unrest milreg  milper1 gdppc3 gdppcgrowth  milexp3  coupyears  t t2 t3  ef cdiv  (lnfdi3= mwlgdp  agrprop larea) if democracy<1 , cluster(ccode) robust
	*Model 5
ivprobit coup   agereg csum linf unrest milreg  milper1 gdppc3 gdppcgrowth  milexp3 coupyears t t2 t3  relfrac (lnfdi3= mwlgdp  agrprop larea  ) if democracy<1 , cluster(ccode) robust
	*Model 6
ivprobit coup  entry_res csum agereg linf  unrest  milreg milper1  gdppc3 gdppcgrowth  coupyears  milexp3 t t2 t3  (lnfdi3= mwlgdp  agrprop larea) if democracy<1 , cluster(ccode) robust
	
	
*** Table 2
	*Model 1
xtreg lnPPE L.yhat L.linf  l.agereg   L.gdppc3 L.gdppcgrowth  L.trade L.school09 L.natrents if democracy <1 ,fe cluster(ccode) robust
	*Model 2
xtreg ppeg L.yhat L.linf  l.agereg   L.gdppc3 L.gdppcgrowth  L.trade L.school09 L.natrents if democracy <1 ,fe cluster(ccode) robust
	*Model 3
xtreg mininggdp L.yhat L.linf  l.agereg   L.gdppc3 L.gdppcgrowth  L.trade L.school09 L.natrents if democracy <1 ,fe cluster(ccode) robust
	*Model 4
xtreg oilgasgdp L.yhat L.linf  l.agereg   L.gdppc3 L.gdppcgrowth  L.trade L.school09 L.natrents if democracy <1 ,fe cluster(ccode) robust
	*Model 5
xtreg industgdp L.yhat L.linf  l.agereg   L.gdppc3 L.gdppcgrowth  L.trade L.school09 L.natrents if democracy <1 ,fe cluster(ccode) robust
	*Model 6
xtreg telcomgdp L.yhat L.linf  l.agereg   L.gdppc3 L.gdppcgrowth  L.trade L.school09 L.natrents if democracy <1 ,fe cluster(ccode) robust


*** Table 3
	*Model 1
xtreg entry_res  L.agereg L.milreg  L.gdppcgrowth L.gdppc3 L.milexp3  if democracy<1, cluster(ccode) robust fe
	*Model 2
xtreg entry_res  L.agereg L.milreg  L.gdppcgrowth L.gdppc3 L.milexp3 L.bank L.currency if democracy<1, cluster(ccode) robust fe
	*Model 3
xtreg entry_res  L.effec1 L.milreg  L.gdppcgrowth L.gdppc3 L.milexp3  if democracy<1 , cluster(ccode) robust fe
	*Model 4
xtreg entry_res  L.effec1 L.milreg  L.gdppcgrowth L.gdppc3 L.milexp3 L.bank L.currency if democracy<1, cluster(ccode) robust fe

	
