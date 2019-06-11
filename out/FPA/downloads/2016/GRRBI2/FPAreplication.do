
**Replication materials for Gallagher and Allen, "Presidential Personality"

lab var ususe "Opportunity to Use Force"

lab var unem "Unemployment"

lab var unified "Unified Government"

lab var prior "Has President Used Force Before"

lab var warcow "Ongoing War"

lab var lag1mo "Presidential Approval"

lab var cpi "Consumer Price Index"

lab var cinc "Composite Index of National Capability"

lab var o4 "Openness to Action"

lab var e5 "Excitement Seeking"

lab var c6 "Deliberation"

lab var a3 "Altruism"

%%Baseline Probit Model

prob ususe unem unified prior warcow lag1mo cpi cinc, cluster(presnum)


%%Probit Model with Personality Characteristics

prob ususe unem unified prior warcow lag1mo cpi cinc o4 e5 c6 a3, robust


%%Heteroskedastic Probit Model

hetprob ususe unem unified prior warcow lag1mo cpi cinc o4 e5 c6 a3, het(o4dum e5dum)



