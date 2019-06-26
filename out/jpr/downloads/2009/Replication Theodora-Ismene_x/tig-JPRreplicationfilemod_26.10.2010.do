/* Replication file "Gender Empowerment and United Nations Peace-building"
1 December 2007
tig@essex.ac.uk */



* Open repliction data
use "TIG-JPRdata3.dta"

* Model 1 in paper
logit pbs5s6 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp  decade expratio unexp

* Model 2 in paper
logit pbs2s6 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp  decade expratio unexp

* Model 3 in paper
logit pbs5s3 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop  exp decade expratio unexp

* Model 4 in paper
logit pbs5s3 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp decade expratio unexp  africa

* Model 5 in paper
logit pbs5s3 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp decade expratio unexp easteur

* Model 6 in paper
logit pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp decade expratio unexp

* Model 7 in paper
logit pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp decade expratio unexp easteur

* Model 8 in paper
logit pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap unop treaty develop exp decade expratio unexp africa



