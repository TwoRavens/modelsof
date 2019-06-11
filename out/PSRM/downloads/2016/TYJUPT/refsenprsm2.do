set more off
probit voteref calsenz calgovz greens libconf eccog vrisk surisk vurisk incz educ gender ///
 black hispanic orace repid demid opid jobless agez ///
 demcon repcon obamalk [iweight=weightd] 
fitstat
predict p1
recode p1 0/.5=0 .5000001/1=1
tab voteref p1 [iweight=weightd], col


