logit masskilling l.assassinations l.constraints l.interstatewar l.civilwar l.lnrgdppc l.lnpopulation  vsyr vsyr2 vsyr3, cluster(ccode)
predict p1, xb
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))
gen capphi = normal(p1)
generate invmills = phi/capphi
