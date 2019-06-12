use "symbolic ideology replication.dta", clear

*Table 1, "Symbolic ideology"
logit hvote  c.relprox##i.nonmoderate age black hispanic female college ownhome attendchurch  partyid  repinc10 incumbency relspend10 sample06 [pw=v101] , cluster (district)
*Effect estimates
*75th percentile
margins, at(relprox=( -2.12 (.1) 3.08) nonmoderat=(1))vsquish
margins, at(incumbency=(-1 (1) 1)) vsquish
margins, at(relspend10=(-4.8 (.1) 5.8)) vsquish
margins, at(partyid=(-2 (1) 2)) vsquish

*Figure 3a
logit hvote  c.relprox##i.nonmoderate age black hispanic female college ownhome attendchurch  partyid  repinc10 incumbency relspend10 sample06 [pw=v101] , cluster (district)
margins, at(relprox=(-2.12(.1) 3.08) nonmoderate=(0 1) partyid=(0) relspend10=(0) ) vsquish
marginsplot, xdimension(relprox) recast(line) recastci(rarea) 

*Figure 4a
logit hvote  c.relprox##i.nonmoderate age black hispanic female college ownhome attendchurch  partyid  repinc10 incumbency relspend10 sample06 [pw=v101] , cluster (district)
margins, at(relprox=(-5(.5) 5) nonmoderate=(0 1) partyid=(-2 2) relspend10==(0) incumbency==(0)) vsquish
marginsplot, xdimension(relprox) recast(line) recastci(rarea) 

*Table 2, "Symbolic ideology"
logit hvote  c.relprox##i.nonmoderate age black hispanic female college ownhome attendchurch  partyid  repinc10 incumbency relspend10 sample06 [pw=v101] if placeboth==1, cluster (district)
margins, at(relprox=( -2.12 (1) 3.08) nonmoderat=(1))vsquish
margins, at(partyid=(-2 (1) 2)) vsquish

*Table 3, "Symbolic ideology"
logit hvote  c.relprox##i.nonmoderate age black hispanic female college ownhome attendchurch  partyid  repinc10 incumbency relspend10 sample06 [pw=v101] if tween==1, cluster (district)
margins, at(relprox=( -1.24 (1) 2.65) nonmoderat=(1))vsquish
margins, at(partyid=(-2 (1) 2)) vsquish
margins, at(relspend10=(-4.8 (.1) 5.8)) vsquish
margins, at(incumbency=(-1 (1) 1)) vsquish




