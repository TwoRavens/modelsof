use "/Users/kathleencunningham/Dropbox/Non-Violence Project/JPR final.dta"

*TABLE 2:
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*PREDICTED PROBABILITIES without both category 
estsimp mlogit strategic3  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)
setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx democracy 0
simqi, pr

setx democracy 1
simqi, pr

setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx loggdppc p25
simqi, pr

setx loggdppc p75
simqi, pr

setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx logSDsize_relative p25
simqi, pr

setx logSDsize_relative p75
simqi, pr

setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx groupcon 2
simqi, pr

setx groupcon 3
simqi, pr


setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx kin 0
simqi, pr

setx kin 1
simqi, pr


setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx avgecdis p25
simqi, pr

setx avgecdis p75
simqi, pr


setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx logfactions p25
simqi, pr

setx logfactions p75
simqi, pr

setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx indep 0 
simqi, pr

setx indep 1 
simqi, pr

setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 

setx logpop p25
simqi, pr
setx logpop p75
simqi, pr

*effect for political exclusion
drop b*
estsimp mlogit strategic3  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1 & kgcid!=435, cluster(kgcid)
setx democracy 0 instab 0 loggdppc mean  logpop mean logSDsize_relative mean groupcon 3  kin 1 excluded 1 avgecdis 2 logfactions mean indep 0  last3years_nvcampaign 0 last3years_civilwar1000 0 


setx excluded 0
simqi, pr

setx excluded 1
simqi, pr


*exluding all nv cases sequentailly
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=106, cluster(kgcid)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=115, cluster(kgcid)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=137, cluster(kgcid)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=212, cluster(kgcid)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=421, cluster(kgcid)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=435, cluster(kgcid)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1 & kgcid!=116, cluster(kgcid)

*with 25 battle death measure
mlogit strategic1  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with decade dummies
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  sixties seventies eighties if active==1, cluster(kgcid)

*with cold war
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  coldwar if active==1, cluster(kgcid)

*with regional dummies
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  eeurop lamerica ssafrica asia nafrme if active==1, cluster(kgcid)

*group size and group size sqaured
mlogit strategic2  democracy instab loggdppc logSDsize_relative logSDsize_relative_sq groupcon kin  logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with absolute size:
mlogit strategic2  democracy instab loggdppc logabsoultesize groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with oil
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  oilexpanded if active==1, cluster(kgcid)

*with state military funding 
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  milexpc if active==1, cluster(kgcid)

*with lagged state military funding 
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  lagmilexpc if active==1, cluster(kgcid)

*with onesided violence
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  onesided if active==1, cluster(kgcid)

*with democ and income interacted
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  democincome if active==1, cluster(kgcid)

*with majority making same demand
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  majority last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with colonial legacy (french)
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  colfra last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with Cedermand inequality measure
mlogit strategic2  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop lineq last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with polity score
mlogit strategic2  polity2 instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000 if active==1, cluster(kgcid)

*with relative size and power exclusion interacted *no both category
mlogit strategic3  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  relsize_excluded if active==1, cluster(kgcid)
mlogit strategic3  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  relsize_excluded if active==1 & kgc!=435, cluster(kgcid)

*with just civil war as the outcome
logit civilwar1000  democracy instab loggdppc logSDsize_relative groupcon kin   logfactions indep excluded avgecdis logpop  last3years_nvcampaign last3years_civilwar1000  if active==1, cluster(kgcid)
