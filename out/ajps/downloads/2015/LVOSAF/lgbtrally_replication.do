**Replication file for Social Esteem and Participation in Contentious Politics

*Table 1
ttest intended if newsletter==1|control==1, by(newsletter) unequal
ttest intended if facebook==1|control==1, by(facebook) unequal
ttest intended, by(esteem) unequal
ttest attended if newsletter==1|control==1, by(newsletter) unequal
ttest attended if facebook==1|control==1, by(facebook) unequal
ttest attended, by(esteem) unequal

*Table 2
bootstrap, reps(2000) dots: ivregress 2sls intended (openedesteem=esteem)
bootstrap, reps(2000) dots: ivregress 2sls attended (openedesteem=esteem)

*Table 3
ttest reported_attended if (newsletter==1 | control==1), by(newsletter) unequal
ttest reported_attended if (facebook==1 | control==1), by(facebook) unequal
ttest reported_attended, by(esteem) unequal

**no pickup robustness check
gen nopickup=0
replace nopickup=1 if reported_attended==1 & attended==0
tab nopickup control
tab nopickup newsletter
tab nopickup facebook

*Table 4
ttest forcause if reported_attended==1, by(esteem) unequal
ttest forsocial if reported_attended==1, by(esteem) unequal
ttest forfun if reported_attended==1, by(esteem) unequal
ttest fortime if reported_attended==1, by(esteem) unequal
ttest foradmiration if reported_attended==1, by(esteem) unequal
ttest forleadership if reported_attended==1, by(esteem) unequal
ttest forimportant if reported_attended==1, by(esteem) unequal

ttest forcause if reported_attended==0, by(esteem) unequal
ttest forsocial if reported_attended==0, by(esteem) unequal
ttest forfun if reported_attended==0, by(esteem) unequal
ttest fortime if reported_attended==0, by(esteem) unequal
ttest foradmiration if reported_attended==0, by(esteem) unequal
ttest forleadership if reported_attended==0, by(esteem) unequal
ttest forimportant if reported_attended==0, by(esteem) unequal

**Appendix
*Table 5
sum female fivemiles yearshpccpreexp intended attended
sum female fivemiles groupwarmth yearshpccpreexp age education unemployed retired vote_08 vote_09 vote_10 democrat reported_attended attended if surveyrespondent==1

*Table 6
ttest age, by(esteem) unequal
ttest female if surveyrespondent==1, by(esteem) unequal
ttest education, by(esteem) unequal
ttest unemployed, by(esteem) unequal
ttest retired, by(esteem) unequal
ttest vote_08, by(esteem) unequal
ttest vote_09, by(esteem) unequal
ttest vote_10, by(esteem) unequal
ttest democrat, by(esteem) unequal

*Table 7
regress intended newsletter facebook female fivemiles fouryears, vce(robust)
regress attended newsletter facebook female fivemiles fouryears, vce(robust)
**robustness to logit:
logit intended newsletter facebook female fivemiles fouryears, vce(robust)
logit attended newsletter facebook female fivemiles fouryears, vce(robust)


*Table 8
bootstrap, reps(2000) dots: ivregress 2sls intended (openednewsletter=newsletter) if newsletter==1 | control==1
bootstrap, reps(2000) dots: ivregress 2sls attended (openednewsletter=newsletter) if newsletter==1 | control==1
bootstrap, reps(2000) dots: ivregress 2sls intended (openedfacebook=facebook) if facebook==1 | control==1
bootstrap, reps(2000) dots: ivregress 2sls attended (openedfacebook=facebook) if facebook==1 | control==1

*Table 9
tab surveyrespondent control 
tab surveyrespondent newsletter 
tab surveyrespondent facebook


*Table 10
bootstrap, reps(2000) dots: ivregress 2sls intended (openedesteem=esteem) female fivemiles fiveyears
bootstrap, reps(2000) dots: ivregress 2sls attended (openedesteem=esteem) female fivemiles fiveyears

*Table 11
regress reported_attended newsletter facebook female previous_attend vote_10 young unemployed democrat if surveyrespondent==1
**robustness to logit:
logit reported_attended newsletter facebook female previous_attend vote_10 young unemployed democrat if surveyrespondent==1

