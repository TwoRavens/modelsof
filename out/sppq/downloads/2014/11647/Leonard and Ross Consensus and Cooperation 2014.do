Table 3: 
logit unanimous contestable_election  nonrandom_opassign iac prof_1 size constitution_considered amicus_no government_partytocase affirm courtdiversity dist_court_leg1 divided_gov, or vce(bootstrap, rep(1000) cluster(state_id))
logit unanimous mos nonrandom_opassign iac prof_1 size constitution_considered amicus_no government_partytocase affirm courtdiversity dist_court_leg1 divided_gov, or vce(bootstrap, rep(1000) cluster(state_id))
logit unanimous partisan nonpartisan onlyretention nonrandom_opassign iac prof_1 size constitution_considered amicus_no government_partytocase affirm courtdiversity dist_court_leg1 divided_gov, or vce(bootstrap, rep(1000) cluster(state_id))
Percent Correctly Predicted: estat clas

Table 4: 
Predicted Probabilities and Confidence Intervals
post prediction (mfx)

Table 5: 
nbreg num_op_nomaj contestable_election  nonrandom_opassign iac prof_1 size constitution_considered amicus_no government_partytocase affirm courtdiversity dist_court_leg1 divided_gov, vce(bootstrap, rep(1000) cluster(state_id))
nbreg num_op_nomaj mos nonrandom_opassign iac prof_1 size constitution_considered amicus_no government_partytocase affirm courtdiversity dist_court_leg1 divided_gov, vce(bootstrap, rep(1000) cluster(state_id))
nbreg num_op_nomaj partisan nonpartisan onlyretention nonrandom_opassign iac prof_1 size constitution_considered amicus_no government_partytocase affirm courtdiversity dist_court_leg1 divided_gov, vce(bootstrap, rep(1000) cluster(state_id))

Table 6:

quietly prvalue, x(partisan=1) save
prvalue, x(partisan=0) dif
quietly prvalue, x(nonpartisan=1) save
prvalue, x(nonpartisan=0) dif
quietly prvalue, x(contestable_election=1) save
prvalue, x(contestable_election=0) dif

