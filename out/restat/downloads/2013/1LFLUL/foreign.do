use foreign.dta
frontier lnc_ lny1_ lny2_ lny3_ lnp1_ y1y1 y2y2 y3y3 y1y2 y1y3 y2y3 p1p1 y1p1 y2p1 y3p1 t tt y1t y2t y3t pt br r crr slr mac, cost nolog technique(bfgs)
 predict e, te
 generate costeff = 1/e
