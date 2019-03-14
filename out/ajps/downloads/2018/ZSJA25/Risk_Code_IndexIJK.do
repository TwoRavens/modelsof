quietly gen p_harm_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="harm" & risknum==`value'
quietly predict p_harmx if risknum==`value'
quietly replace p_harm_risk=p_harmx if risknum==`value'
quietly drop p_harmx
}

quietly gen p_fairness_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="fairness" & risknum==`value'
quietly predict p_fairnessx if risknum==`value'
quietly replace p_fairness_risk=p_fairnessx if risknum==`value'
quietly drop p_fairnessx
}

quietly gen p_responsibility_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint[pweight=rakewt] if index=="responsibility" & risknum==`value'
quietly predict p_responsibilityx if risknum==`value'
quietly replace p_responsibility_risk=p_responsibilityx if risknum==`value'
quietly drop p_responsibilityx
}

quietly gen p_worry_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="worry" & risknum==`value'
quietly predict p_worryx if risknum==`value'
quietly replace p_worry_risk=p_worryx if risknum==`value'
quietly drop p_worryx
}

quietly gen p_longterm_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="longterm" & risknum==`value', cluster(responseid)
quietly predict p_longtermx if risknum==`value'
quietly replace p_longterm_risk=p_longtermx if risknum==`value'
drop p_longtermx
}

quietly gen p_disaster_risk=.

forvalues value = 1(1)100 {
quietly logit outcome republican democrat female white college hiosint [pweight=rakewt] if index=="disaster" & risknum==`value', cluster(responseid)
quietly predict p_disasterx if risknum==`value'
quietly replace p_disaster_risk=p_disasterx if risknum==`value'
quietly drop p_disasterx
}
