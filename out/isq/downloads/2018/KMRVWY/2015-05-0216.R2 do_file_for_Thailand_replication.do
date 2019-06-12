** COUP RUMOR

*ordered logistic regression for sub-sample with no prior exposure to coup rumor
ologit believe_coup distrust_military threat_perception male age muslim income education social_trust local_participation if heard_coup_rumor==0, r or
eststo

*ordered logistic regression for full sample
ologit believe_coup distrust_military threat_perception heard_coup_rumor male age muslim income education social_trust local_participation, r or
eststo

esttab using coup_rumor.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform

*multinomial logistic regression for sub-sample with no prior exposure to coup rumor

mlogit believe_coup distrust_military threat_perception male age muslim income education social_trust local_participation if heard_coup_rumor==0, base(0) r rrr
eststo
esttab using mlogit_coup_unexposed.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform 

*multinomial logistic regression for full sample
mlogit believe_coup distrust_military threat_perception heard_coup_rumor male age muslim income education social_trust local_participation, base(0) r rrr
eststo
esttab using mlogit_coup_full_sample.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform 


** FLOOD RUMOR

*ordered logistic regression for sub-sample with no prior exposure to flood rumor
ologit believe_flood distrust_government economic_fear male age muslim income education social_trust local_participation if heard_flood_rumor==0, r or
eststo

*ordered logistic regression for full sample
ologit believe_flood distrust_government economic_fear heard_flood_rumor male age muslim income education social_trust local_participation, r or
eststo

esttab using flood_rumor.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform

*multinomial logistic regression for sub-sample with no prior exposure to flood rumor
mlogit believe_flood distrust_government economic_fear male age muslim income education social_trust  local_participation if heard_flood_rumor==0, base(0) r rrr
eststo
esttab using flood_mlogit_final_unexposed.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform

*multinomial logistic regression for full sample
mlogit believe_flood distrust_government economic_fear heard_flood_rumor male age muslim income education social_trust  local_participation, base(0) r rrr
eststo
esttab using flood_mlogit_final_exposed.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform


** Impact of credulity on perceptions of peace process

logit intractable mongery distrust_military economic_fear distrust_government threat_perception male age muslim income education social_trust local_participation, r or
eststo

esttab using mongery.csv, replace se starlevels(* 0.05 ** 0.01  *** 0.001 ) constant eform
