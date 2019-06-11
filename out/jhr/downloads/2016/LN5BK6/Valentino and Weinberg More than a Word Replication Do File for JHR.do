gen def_genocide = q13
recode def_genocide 1=1 .=. else=0

gen prob_genocide = q13
recode prob_genocide 2=1 .=. else=0

gen def_holocaust = q15
recode def_holocaust 1=1 .=. else=0

gen prob_holocaust = q15
recode prob_holocaust 2=1 .=. else=0

gen prob_or_def_holocaust = q15
recode prob_or_def_holocaust 1=1 2=1 .=. else=0

gen civil_war_genocide_dummy = q23
recode civil_war_genocide_dummy 1=1 2=1 .=. else=0

gen q1_dummy=q1
recode q1_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q2_dummy=q2
recode q2_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q3_dummy=q3
recode q3_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q5_dummy=q5
recode q5_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q6_dummy=q6
recode q6_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q7_dummy=q7
recode q7_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q11_dummy=q11
recode q11_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q12_dummy=q12
recode q12_dummy 1=0 2=0 3=0 4=1 5=1 6=1

gen q17_dummy=q17
recode q17_dummy 1=0 2=0 3=0 4=1 5=1 6=1

mean def_genocide, over(treat), [pweight=weight]
mean prob_genocide, over(treat), [pweight=weight]

mean def_holocaust, over(treat), [pweight=weight]
mean prob_holocaust, over (treat), [pweight=weight]

mean def_genocide, over(treat), [pweight=weight]
test control = genocide

mean prob_or_def_holocaust, over(treat), [pweight=weight]
test control = holocaust

mean prob_holocaust, over(treat), [pweight=weight]
test control = holocaust

mean def_holocaust, over(treat), [pweight=weight]
test control = holocaust

mean civil_war_genocide_dummy [pweight=weight]

mean q1, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q2, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q3, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q5, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q6, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q7, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q11, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q12, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q17, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q1_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q2_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q3_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q5_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q6_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q7_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q11_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q12_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean q17_dummy, over(treat), [pweight=weight]
test control = holocaust
test control = genocide

mean civil_war_genocide_dummy [pweight=weight]

