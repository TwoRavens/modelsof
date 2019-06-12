* load data for full sample models
use "(filepath)/Div&Div_RepData.dta"

* load data for democratic sample models
use "(filepath)/Div&Div_RepData.dta"
* load data for authoritarian sample models
use "(filepath)/Div&Div_RepData.dta"

* code for Figure 1
twoway scatter ethfrac ethpol


* code for results in Table 1 -- run with each sample
logit cwinit apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp ethnicfrac lagmunr c.lagmunr#c.ethnicfrac, vce(cluster dyadid)

* code for Figure 2 -- run with Full Sample for graph in manuscript
logit cwinit apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp ethnicfrac lagmunr c.lagmunr#c.ethnicfrac, vce(cluster dyadid)
margins, at(lagmunr=(0(1)20) ethnicfrac=(.15 .64)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea) legend(pos(11) ring(0) cols(1) bmargin(small) lstyle(none))


* code for results in Table 2 -- run with each sample
logit cwinit apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp ethpol lagmunr c.lagmunr#c.ethpol, vce(cluster dyadid)

* code for Figure 3 -- run with Full Sample for graph in Manuscript
logit cwinit apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp ethpol lagmunr c.lagmunr#c.ethpol, vce(cluster dyadid)
margins, at(lagmunr=(0(1)20) ethpol=(.28 .74)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea) legend(pos(11) ring(0) cols(1) bmargin(small) lstyle(none))


* code for results in Table 3 -- run with each sample
logit cwinit apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp kinadj lagmunr c.lagmunr#c.kinadj, vce(cluster dyadid) 

* code for Figure 4 -- run with Full Sample for graph in manuscript
logit cwinit apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp kinadj lagmunr c.lagmunr#c.kinadj, vce(cluster dyadid) 
margins, at(lagmunr=(0(1)20) kinadj=(0 1)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea) legend(pos(11) ring(0) col(1) bmargin(small) lstyle(none))




*Robustness Checks -- run code for each sample

*contemporaneous mass unrest: Table 1A

logit cwinit ethnicfrac munr c.munr#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit ethpol munr c.munr#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit kinadj munr c.munr#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, vce(cluster dyadid)


*two year mass unrest: Table 1B

logit cwinit ethnicfrac twoyrmunr c.twoyrmunr#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit ethpol twoyrmunr c.twoyrmunr#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit kinadj twoyrmunr c.twoyrmunr#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, vce(cluster dyadid)


*natural log of lagged mass unrest: Table 1C

logit cwinit ethnicfrac lnmunr c.lnmunr#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit ethpol lnmunr c.lnmunr#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit kinadj lnmunr c.lnmunr#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, vce(cluster dyadid) 


* Lagged aggregate (mass + elite) unrest: Table 2A

logit cwinit ethnicfrac lagunrest c.lagunrest#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit ethpol lagunrest c.lagunrest#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit kinadj lagunrest c.lagunrest#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, vce(cluster dyadid)


*GDP Growth (Gleditsch): Table 2B

logit cwinit ethnicfrac growth c.growth#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit ethpol growth c.growth#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit cwinit kinadj growth c.growth#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, vce(cluster dyadid)


* Disputes with at least display of force: Table 3A

logit forcedisp ethnicfrac lagmunr c.lagmunr#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit forcedisp ethpol lagmunr c.lagmunr#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

logit forcedisp kinadj lagmunr c.lagmunr#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, vce(cluster dyadid) 


* alternative diversity measures: Tables 4A (Full Sample), 4B (Democracies) , 4C (Autocracies)

* Soviet Atlas
logit cwinit elf lagmunr c.lagmunr#c.elf apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* N Star
logit cwinit nstar lagmunr c.lagmunr#c.nstar apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* Alesina et al
logit cwinit ethnic lagmunr c.lagmunr#c.ethnic apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* Largest Group Proportion
logit cwinit gpro lagmunr c.lagmunr#c.gpro apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* # of groups
logit cwinit groups lagmunr c.lagmunr#c.groups apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* Language-Religion Cross Fractionalization
logit cwinit lrf lagmunr c.lagmunr#c.lrf apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* Desmet et al level 5
logit cwinit elf5 lagmunr c.lagmunr#c.elf5 apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* Desmet et al level 1
logit cwinit elf1 lagmunr c.lagmunr#c.elf1 apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)

* Desmet et al Level 10
logit cwinit elf10 lagmunr c.lagmunr#c.elf10 apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, vce(cluster dyadid)


* Regional Fixed Effects: Table 5A

logit cwinit ethnicfrac lagmunr c.lagmunr#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo reg1 reg2 reg3 reg4 reg5 reg6, vce(cluster dyadid)

logit cwinit ethpol lagmunr c.lagmunr#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo reg1 reg2 reg3 reg4 reg5 reg6, vce(cluster dyadid)

logit cwinit kinadj lagmunr c.lagmunr#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic reg1 reg2 reg3 reg4 reg5 reg6, vce(cluster dyadid) 


* GEE models: Table 5B

xtgee cwinit ethnicfrac lagmunr c.lagmunr#c.ethnicfrac apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, i(dyadid) t(year) fam(bin) link(logit) vce(robust) corr(ar1)

xtgee cwinit ethpol lagmunr c.lagmunr#c.ethpol apwr polity1 polity2 dist cwpceyrs pceyrs2 pceyrs3 adep sglo othdisp, i(dyadid) t(year) fam(bin) link(logit) vce(robust) corr(ar1)

xtgee cwinit kinadj lagmunr c.lagmunr#c.kinadj apwr polity1 polity2 cwpceyrs pceyrs2 pceyrs3 adep sglo ethnic othdisp, i(dyadid) t(year) fam(bin) link(logit) vce(robust) corr(ar1)




