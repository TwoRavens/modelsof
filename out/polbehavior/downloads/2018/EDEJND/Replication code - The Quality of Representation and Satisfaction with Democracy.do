
***********************************************************************************************
** REPLICATION CODE - The Quality of Representation and Satisfaction with Democracy
***********************************************************************************************

** bivariate models **

ologit satdem congr_policy_std [pweight= FINALweightg], cluster(muninum)
ologit satdem congr_sv_std [pweight= FINALweightg], cluster(muninum)
ologit satdem c.age##c.age [pweight= FINALweightg], cluster(muninum)
ologit satdem female [pweight= FINALweightg], cluster(muninum)
ologit satdem educ [pweight= FINALweightg], cluster(muninum)
ologit satdem polinterest [pweight= FINALweightg], cluster(muninum)
ologit satdem econsit [pweight= FINALweightg], cluster(muninum)
ologit satdem lr_folded [pweight= FINALweightg], cluster(muninum)
ologit satdem partysymp [pweight= FINALweightg], cluster(muninum)
ologit satdem govsupport [pweight= FINALweightg], cluster(muninum)
xi: ologit satdem i.vote_w1 [pweight= FINALweightg], cluster(muninum)


** multivariate models **

ologit satdem congr_policy_std congr_sv_std [pweight= FINALweightg], cluster(muninum)

ologit satdem congr_policy_std congr_sv_std  ///
	c.age##c.age female educ polinterest econsit lr_folded partysymp govsupport ///
	[pweight= FINALweightg], cluster(muninum)

xi: ologit satdem congr_policy_std congr_sv_std  ///
	c.age##c.age female educ polinterest econsit lr_folded partysymp i.vote_w1 ///
	[pweight= FINALweightg], cluster(muninum)

