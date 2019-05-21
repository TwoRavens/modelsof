** Table 1, columns 2 and 3
use "2006 CCES replication.dta"
logit voted  age income i.race divergence educ female competitive i.st_id,cl(cluster)
logit voted  age income i.race divergence educ  ideology female competitive partisan mobilized i.st_id,cl(cluster)


** Generate predicted probabilities for Figure 3
quietly logit voted  age income i.race divergence educ  ideology female competitive partisan mobilized i.st_id,cl(cluster)
margins,at(divergence=(0.3 .4 .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2) inc=8 educ=3 race=1 age=5.21 ideology=0 competitive=-1.767 mobilized=1) atmeans


** Generating predicted probabilities for Figure 4
logit voted  age income i.race c.divergence##c.educ  ideology female competitive partisan mobilized i.st_id,cl(cluster)
margins,at(divergence=(0.3 .4 .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2) inc=8 educ=2 race=1 age=5.21 ideology=0 competitive=-1.767 mobilized=1) atmeans
margins,at(divergence=(0.3 .4 .5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2) inc=8 educ=4 race=1 age=5.21 ideology=0 competitive=-1.767 mobilized=1) atmeans






