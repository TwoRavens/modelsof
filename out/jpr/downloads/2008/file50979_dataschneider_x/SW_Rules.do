

**********

*Schneider/Wiesehomeier, Rules that matter, June 2007

***********



*set mem 15m

*Table 1

*use "SW_Rules", clear

stset ifinish, fail(onset) enter(istart) exit(efinish)

stcox lnpop lncgdp Demo ef  efdom6090 Polarization PolarizationDemo efDemo efdomDemo durable, texp(ln(_t)) tvc(lnpop lncgdp efdom6090 Polarization efdomDemo PolarizationDemo) strata(sumfail) cluster(NAMES_STD) efron robust nolog noshow 



*Table 2

*use ""SW_Rules", clear

stset ifinish, fail(onset) enter(istart) exit(efinish) origin(regime_leg==0) if(regime_leg!=1)

stcox  lnpop  lncgdp durable  ef efdom6090 Polarization ,  strata(sumfail) cluster(NAMES_STD) efron robust nolog noshow 



stcox lnpop  lncgdp durable  ef efdom6090 Polarization  major  efmajor efdommajor polmajor,texp(ln(_t)) tvc( efdom6090) strata(sumfail) efron cluster(NAMES_STD) robust nolog noshow 



stcox lnpop  lncgdp durable  ef efdom6090 Polarization enep enep2 efenep efenep2  efdomenep efdomenep2 polenep polenep2,texp(ln(_t)) tvc( Polarization enep enep2 ) strata(sumfail) efron cluster(NAMES_STD) robust nolog noshow 



stcox lnpop  lncgdp durable  ef efdom6090 Polarization presidential efpresi efdompresi polpresi, texp(ln(_t)) tvc(lnpop efdompresi )  strata(sumfail) efron cluster(NAMES_STD) robust nolog noshow



stcox  lnpop  lncgdp durable  ef efdom6090 Polarization  fedpol3  effed efdomfed polfed, texp(ln(_t)) tvc(lnpop efdomfed ) efron cluster(NAMES_STD) strata(sumfail) robust nolog noshow 



stcox lnpop  lncgdp durable  ef efdom6090 Polarization prop lnavemag  lnavemagprop efdomlnavemag eflnavemag pollnavemag pollnavemagprop efdomlnavemagprop eflnavemagprop polprop efprop efdomprop , strata(sumfail) texp(ln(_t)) tvc(Polarization efdom6090 ef eflnavemag pollnavemag) efron cluster(NAMES_STD) robust nolog noshow 


