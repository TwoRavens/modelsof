*commands to get data for Table 1

tab electnumber if retention==1 [iweight=weight]
tab challnumber if retention==1 [iweight=weight]
tab opennumber if retention==1 [iweight=weight]
tab number60 if retention==1 [iweight=weight]
tab lndonatetotpop if retention==1 [iweight=weight]
tab knowmeanuse if retention==1 [iweight=weight]

tab electnumber if partisan==1 [iweight=weight]
tab challnumber if partisan==1 [iweight=weight]
tab opennumber if partisan==1 [iweight=weight]
tab number60 if partisan==1 [iweight=weight]
tab lndonatetotpop if partisan==1 [iweight=weight]
tab knowmeanuse if partisan==1 [iweight=weight]

tab electnumber if nonpartisan==1 [iweight=weight]
tab challnumber if nonpartisan==1 [iweight=weight]
tab opennumber if nonpartisan==1 [iweight=weight]
tab number60 if nonpartisan==1 [iweight=weight]
tab lndonatetotpop if nonpartisan==1 [iweight=weight]
tab knowmeanuse if nonpartisan==1 [iweight=weight]

*models for Table 2
xtmixed legittot0 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 opennumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 number60 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 challnumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 electnumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 knowmeanuse c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 lndonatetotpop c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 openlow openmid openhigh b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)


*models for footnote 9 analysis
xtmixed legittot0 c.partisan##c.educ01 nonpartisan retention b3.q20  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.partisan##c.aware01 nonpartisan retention b3.q20  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.partisan c.nonpartisan##c.aware01 retention b3.q20  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)

*models for footnote 10 analysis
*model with partisan primary states counted as partisan states
xtmixed legittot0 c.partisanwithMIOH nonpartisannoMIOH retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*model with retention elections after multi-candidate election counted as retention election state
xtmixed legittot0 c.partisanminus nonpartisan retentionplus b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)

*model for footnote 11 analysis
xtmixed legittot0 challnumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)

*latent variable analysis
sem (Activity ->  opennumber number60 lndonatetotpop electnumber  challnumber knowmeanuse) (Legitimacy -> legit1 legit2 legit3 legit4) (Legitimacy <- Activity id1 id2 id4 id5 partisan nonpartisan retention rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female)  if aware1>1 [pweight=weight], method(mlmv) vce(cluster inputstate)

*models for footnote 13
xtmixed legittot0 opennumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&appointment==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 opennumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 opennumber c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&compelect==1 [pweight=weight] || inputstate:, pwscale(size)

*Models for Table 3
xtmixed legittot0 opennumber  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 number60  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 electnumber  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 knowmeanuse b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 lndonatetotpop b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==1 [pweight=weight] || inputstate:, pwscale(size)

xtmixed legittot0 opennumber  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&compelect==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 number60  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&compelect==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 electnumber  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&compelect==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 knowmeanuse  b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&compelect==1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 lndonatetotpop b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&compelect==1 [pweight=weight] || inputstate:, pwscale(size)

*Models for interactions of individual levels variables with election activity indicators - discussed on pg 23
*interactions with court awareness
xtmixed legittot0 c.opennumber##c.aware01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.number60##c.aware01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.challnumber##c.aware01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.electnumber##c.aware01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.knowmeanuse##c.aware01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.lndonatetotpop##c.aware01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*interactions with support for the rule of law
xtmixed legittot0 c.opennumber##c.rlaw01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.number60##c.rlaw01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.challnumber##c.rlaw01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.electnumber##c.rlaw01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.knowmeanuse##c.rlaw01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.lndonatetotpop##c.rlaw01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*interactions with perceived election fairness
xtmixed legittot0 c.opennumber##c.elect01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.number60##c.elect01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.challnumber##c.elect01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.electnumber##c.elect01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.knowmeanuse##c.elect01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.lndonatetotpop##c.elect01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*interactions with education
xtmixed legittot0 c.opennumber##c.educ01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.number60##c.educ01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.challnumber##c.educ01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.electnumber##c.educ01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.knowmeanuse##c.educ01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.lndonatetotpop##c.educ01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*interactions with political interest
xtmixed legittot0 c.opennumber##c.interest01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.number60##c.interest01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.challnumber##c.interest01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.electnumber##c.interest01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.knowmeanuse##c.interest01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.lndonatetotpop##c.interest01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*interactions with ideological self-placement
xtmixed legittot0 c.opennumber##c.ideo01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.number60##c.ideo01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.challnumber##c.ideo01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1&retention==0 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.electnumber##c.ideo01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.knowmeanuse##c.ideo01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
xtmixed legittot0 c.lndonatetotpop##c.ideo01 c.partisan nonpartisan retention b3.ideodiff  rlaw01 aware01  elect01 educ01 c.age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight] || inputstate:, pwscale(size)


*Predicted Values for Figure 2 created using the results from this model which uses the mean-centered control variables
xtmixed legittot0 opennumber c.partisan nonpartisan retention b3.ideodiff  rlaw01mean aware01mean  elect01mean educ01mean c.age10mean interest01mean ideo01mean blackmean hispanicmean femalemean if aware1>1 [pweight=weight] || inputstate:, pwscale(size)

*To determine the predicted values and confidence intervals used in Figure 3, I use a model with mean-centered variables. Since the constant is the 
*predicted value when all other variables are zero, the constant gives the predicted value along with standard error for the omitted category from the perceived ideological difference variable.
*The constant in the model below is the predicted value along with the confidence interval around that predicted value for when ideodiff==1 in an appointment state with 0 open-seat elections with all other variables held at their means
xtmixed legittot0 opennumber c.partisan nonpartisan retention b1.ideodiff  rlaw01mean aware01mean  elect01mean educ01mean c.age10mean interest01mean ideo01mean blackmean hispanicmean femalemean if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*The constant in the model below is the same for when ideodiff==2
xtmixed legittot0 opennumber c.partisan nonpartisan retention b2.ideodiff  rlaw01mean aware01mean  elect01mean educ01mean c.age10mean interest01mean ideo01mean blackmean hispanicmean femalemean if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*The constant in the model below is the same for when ideodiff==3
xtmixed legittot0 opennumber c.partisan nonpartisan retention b3.ideodiff  rlaw01mean aware01mean  elect01mean educ01mean c.age10mean interest01mean ideo01mean blackmean hispanicmean femalemean if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*The constant in the model below is the same for when ideodiff==4
xtmixed legittot0 opennumber c.partisan nonpartisan retention b4.ideodiff  rlaw01mean aware01mean  elect01mean educ01mean c.age10mean interest01mean ideo01mean blackmean hispanicmean femalemean if aware1>1 [pweight=weight] || inputstate:, pwscale(size)
*The constant in the model below is the same for when ideodiff==5
xtmixed legittot0 opennumber c.partisan nonpartisan retention b5.ideodiff  rlaw01mean aware01mean  elect01mean educ01mean c.age10mean interest01mean ideo01mean blackmean hispanicmean femalemean if aware1>1 [pweight=weight] || inputstate:, pwscale(size)

