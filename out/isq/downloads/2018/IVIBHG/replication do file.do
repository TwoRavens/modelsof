
* set data for time-series analysis

tsset idorigin year, yearly


* TABLE 3 [non-instrumented models]

* MODEL 1 
xtfevd ihrfactor llandineq lincineq lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq, invariant (llandineq lincineq llnpcgdp llnpop lethnicf lethsq) ar1 cluster(idorigin)

* MODEL 2 
xtfevd ihrfactor llandineq lincineq lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq if comunist~=1, invariant (llandineq lincineq llnpcgdp llnpop lethnicf lethsq) ar1 cluster(idorigin)

* MODEL 3 
xtfevd ihrfactor llandineq lincineq lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq if OECD~=1, invariant (llandineq lincineq llnpcgdp llnpop lethnicf lethsq) ar1 cluster(idorigin)

* MODEL 4 
xtfevd ihrfactor llandineq lincineq lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq if NcomNoecd==1, invariant (llandineq lincineq llnpcgdp llnpop lethnicf lethsq) ar1 cluster(idorigin)


* TABLE 4 [2SLS instrumented models]

* MODEL 1 
xtfevd ihrfactor lincineq llandineq lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq, invariant (llandineq lincineq llnpcgdp  llnpop lethnicf lethsq) ar1 cluster(idorigin) s2iv_endog(llandineq lincineq) s2iv_exog(agricva fuel minerals iberiancol)  

* MODEL 2 
xtfevd ihrfactor lincineq llandineq  lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq if comunist~=1, invariant (llandineq lincineq llnpcgdp  llnpop lethnicf lethsq) ar1 cluster(idorigin)  s2iv_endog(lincineq llandineq) s2iv_exog(agricva fuel minerals iberiancol)

* MODEL 3 
xtfevd ihrfactor lincineq llandineq lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq if OECD~=1, invariant (llandineq lincineq llnpcgdp  llnpop lethnicf lethsq) ar1 cluster(idorigin) s2iv_endog(lincineq llandineq) s2iv_exog(agricva fuel minerals cath iberiancol)

* MODEL 4 
xtfevd ihrfactor lincineq llandineq  lPOLITY2 llnpcgdp ldomconf llnpop lethnicf lethsq if NcomNoecd==1, invariant (llandineq lincineq llnpcgdp  llnpop lethnicf lethsq) ar1 cluster(idorigin) s2iv_endog(lincineq llandineq) s2iv_exog(agricva fuel minerals cath iberiancol)

