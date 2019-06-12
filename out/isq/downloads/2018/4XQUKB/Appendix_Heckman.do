clear
use "use.dta"

*Table 1, Appendix

*Direct-Conventional Government
logit brutegov sp5 sp5sq neighbors us_pergdp relrebcap intense000 mountains ethrel  dem, cluster(conflict)

*Direct-Conventional Rebel
logit bruterebel sp5 sp5sq neighbors us_pergdp relrebcap intense000 mountains ethrel  dem, cluster(conflict)

*Direct-Coercive Government
logit coercgov sp5 sp5sq neighbors us_pergdp relrebcap intense000 mountains ethrel  dem, cluster(conflict)

*Direct-Coercive Rebel
logit coercrebel sp5 sp5sq neighbors us_pergdp relrebcap intense000 mountains ethrel  dem, cluster(conflict)

*Indirect Government
logit indigov sp5 sp5sq neighbors us_pergdp relrebcap intense000 mountains ethrel  dem, cluster(conflict)

*Indirect Rebel
logit indirebel sp5 sp5sq neighbors us_pergdp relrebcap intense000 mountains ethrel  dem, cluster(conflict)
