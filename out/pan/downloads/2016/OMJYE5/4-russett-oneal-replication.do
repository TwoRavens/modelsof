* Replicate Russett and Oneal original analysis,
* and estimate pooled logit with naive clustering.

use "~/Dropbox/dyadic-variance/pa-submission/replication-files/TRIANGLE.DTA", clear

gen smldmat=demauta if demauta<=demautb & demautb~=.  

replace smldmat=demautb if demautb<demauta & demauta~=.  

gen smldep=dependa if dependa<=dependb & dependb~=. 

replace smldep=dependb if dependb<dependa & dependa~=.  

gen dyadid=(1000*statea)+stateb  

iis dyadid  

tis year  

keep dispute1 smldmat smldep smigoabi lcaprat allies noncontg logdstab minrpwrs statea stateb dyadid year

xtgee dispute1 allies lcaprat smldmat smldep smigoabi noncontg logdstab minrpwrs, family(binomial) link(logit) corr(ar1) force robust nolog

logit dispute1 allies lcaprat smldmat smldep smigoabi noncontg logdstab minrpwrs, robust

logit dispute1 allies lcaprat smldmat smldep smigoabi noncontg logdstab minrpwrs, cluster(dyadid)

saveold "~/Dropbox/dyadic-variance/pa-submission/replication-files/TRIANGLE-out.DTA", replace
