*****TABLE 1*****

*Table 1, Model 1*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail

*Table 1, Model 2*
capture drop mg h sca* sch*
stcox ethnic ethfrac gdp2 lnpop1 demo auto incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Table 1, Model 3*
capture drop mg h sca* sch*
stcox ethnic ethfrac ethfracsq gdp2 lnpop1 demo auto incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Table 1, Model 4*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw milper, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Table 1, Model 5*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw sideb2nd, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail


*****ALTERNATIVE SPECIFICATIONS*****

*Model 2, Alesina ethnic fractionalization measure*
capture drop mg h sca* sch*
stcox ethnic alesinafrac gdp2 lnpop1 demo auto incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 3, Alesina ethnic fractionalization measure*
capture drop mg h sca* sch*
stcox ethnic alesinafrac alesinafracsq gdp2 lnpop1 demo auto incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 1, using Polity2*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 polity2 incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 1, using Polity2 and its square*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 polity2 polity2sq incompatibility cw, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 4, using milex (milex1 is COW's milex variable divided by 1000)*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw milex1, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 4, using cinc*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw cinc, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 1, with regional dummies*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw eur mideast asia africa, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 1, Weibull parametric distribution*
streg ethnic plural gdp2 lnpop1 demo auto incompatibility cw, cluster(location) dist(weibull) robust  

*Model 4, fixing PH violation*
*gen fix1=incompatibility*_t*
*gen fix2=cw*_t*

capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto incompatibility cw milper fix1 fix2, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*) 
stphtest, detail

*Model 1, subset by incompatibility*
*governmental conflicts*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto cw if incompatibility==0, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail

*territorial conflicts*
capture drop mg h sca* sch*
stcox ethnic plural gdp2 lnpop1 demo auto cw if incompatibility==1, efron robust cluster(location) basehc(h) mgale(mg) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
