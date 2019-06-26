stset months_duration, failure(negotiation_attempt)
streg, dist(weibull)
streg, dist(loglogistic)
streg, dist(lognormal)
stcurve, hazard
summarize insurgent_collapse negotiation_attempt months_duration
summarize leader_uncertainty ethnic_conflict gov_capability ex_constraints
stset months_duration, failure(insurgent_collapse=1)
streg leader_uncertainty ethnic_conflict gov_capability ex_constraints, dist(weibull) time
stset months_duration, failure(negotiation_attempt)
streg leader_uncertainty ethnic_conflict gov_capability ex_constraints, dist(lognormal)


