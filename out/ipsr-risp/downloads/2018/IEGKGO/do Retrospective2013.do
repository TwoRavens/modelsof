
*** DO FILE FOR THE ARTICLE "Retrospective voting in Italy during the 2013 election"

use "Retrospective2013.dta", clear

*Fig 1 - MAP 
spmap gov2013 using "prov-coord", id(stid) fcolor(Blues) clmethod(custom) clbreaks(15 25 35 45 55) legend(symy(*2) symx(*2) size(small) position (2))

* DESCRIPTIVES

*Tab 2 
form  gov2008 gov2013 unemployment lagcunemployment deltapcturnout respmonti %9.2f
sum gov2008 gov2013 unemployment lagcunemployment deltapcturnout respmonti, format

*Tab A.2
form logpop lagclogpop indgov2008 indgov2013  %9.2f
sum logpop lagclogpop indgov2008 indgov2013, format

* DIRECT MODELS

*Tab 3 
glm pgov2013 pgov2008 respmonti deltaturnout, link(logit) family(binomial) cluster (district)
glm pgov2013 pgov2008 unemployment deltaturnout, link(logit) family(binomial) cluster (district)
glm pgov2013 pgov2008 lagcunemployment deltaturnout, link(logit) family(binomial) cluster (district)
glm pgov2013 pgov2008 unemployment lagcunemployment deltaturnout, link(logit) family(binomial) cluster (district)

*Tab A.3
glm pindgov2013 pindgov2008 respmonti deltaturnout, link(logit) family(binomial) cluster (district)
glm pindgov2013 pindgov2008 unemployment deltaturnout, link(logit) family(binomial) cluster (district)
glm pindgov2013 pindgov2008 lagcunemployment deltaturnout, link(logit) family(binomial) cluster (district)
glm pindgov2013 pindgov2008 unemployment lagcunemployment deltaturnout, link(logit) family(binomial) cluster (district)

*margins
margins, at (respmonti=(4 5))
*aic bic
estat ic


*INTERACTIONS

*Tab A.4 (Fig. 2)
glm pgov2013 pgov2008 c.unemployment##c.logpop deltaturnout, link(logit) family(binomial) cluster(district)
glm pgov2013 pgov2008 c.lagcunemployment##c.lagclogpop deltaturnout, link(logit) family(binomial) cluster(district)

*Tab A.5 (fig.A.1)
glm pindgov2013 pindgov2008 c.unemployment##c.logpop deltaturnout, link(logit) family(binomial) cluster(district)
glm pindgov2013 pindgov2008 c.lagcunemployment##c.lagclogpop deltaturnout, link(logit) family(binomial) cluster(district)

*Plots internal marginal effects
margins, dydx( unemployment ) at(logpop =(10.9(0.1)15.2)) vsquish
marginsplot, recast (line) recastci(rline) ciopts(lpattern(dash)) yline(0, lcolor(red)) addplot(histogram logpop, color(bluishgray) bin(50) percent yaxis(2)) legend(off) title("Marginal effect of unemployment", size(medium))

*Plots contiguous marginal effects
margins, dydx( lagcunemployment ) at(lagclogpop =(11.6(0.1)14)) vsquish
marginsplot, recast (line) recastci(rline) ciopts(lpattern(dash)) yline(0, lcolor(red)) addplot(histogram lagclogpop, color(bluishgray) bin(50) percent yaxis(2)) legend(off) title("Marginal effect of contiguous unemployment", size(medium))

*Fig. A.2
glm pgov2013 pgov2008 c.unemployment##c.logpop lagcunemployment deltaturnout, link(logit) family(binomial) cluster(district)
glm pgov2013 pgov2008 unemployment c.lagcunemployment##c.lagclogpop deltaturnout, link(logit) family(binomial) cluster(district)

