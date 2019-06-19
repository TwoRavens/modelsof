use private.dta
 frontier lnc lny1 lny2 lny3 lnp1 y1y1 y2y2 y3y3 y1y2 y1y3 y2y3 p1p1 y1p1 y2p1 y3p1 t tt y1t y2t y3t pt br r crr slr mac o_n ony1 ony2 ony3 onp onr, distribution(tnormal) cm(r t tt o_n onr, noconstant) cost nolog
 predict e, te
 generate costeff = 1/e




