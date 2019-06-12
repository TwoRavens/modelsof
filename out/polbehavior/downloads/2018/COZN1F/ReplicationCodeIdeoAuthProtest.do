*Title: Contentious Activities, Disrespectful Protesters: Effect of Protest Context on Protest Support and Mobilization across Ideology and Authoritarianism
*Author: Raynee S. Gutting
*Date: 12.19.18
*All analyses and figures made using Stata/SE 13.1


*cd "C:\Users\rayne\Documents\Dissertation Take III\Polit Behav\Data"
cd "~Insert\your\directory"
use "ExperimentalData.dta", clear

***Table 2. Manipulation Checks: Experimental Effects of Contentiousness and Respect for Police Manipulations
  *on Perceptions of Protesters

  *Perceptions that protesters are peaceful, by manipulation
reg peaceful01 i.contentious##i.disrespectful, robust


  *Perceptions that protesters are disrespectful, by manipulation
reg disrespect01 i.contentious##i.disrespectful, robust

***Figure 1 & Table 3. Experimental Effects of Contentiousness and Respect for Police on Support for Protesters 
  *and Mobilization Potential

  *DV = support for protesters (model 1)
reg agree01 contentious##disrespectful i.sample i.topissue, robust

margins disrespectful#contentious

marginsplot, title("") xtitle("Treatment of Police") ylab(#5) xlab(0"Respectful" 1"Disrespectful") xscale(range(0 1.1)) ///
plot1opts(lpattern("--") lcolor(black) mcolor(black)) ci1opts(color(black)) ///
legend(order(3 "Peaceful" 1 "Contentious") title("Tactics")) ///
ytitle("Support for Potesters", height(7)) graphregion(color(white))  ///
plot2opts(mcolor(black)) ci2opts(color(black)) legend(off) ///
saving(Support, replace)

  *DV = protest intention (model 2)
reg attend01 contentious##disrespectful i.sample i.topissue, robust

margins disrespectful#contentious

marginsplot, title("") xtitle("Treatment of Police") ylab(#5) xlab(0"Respectful" 1"Disrespectful") xscale(range(0 1.1)) ///
plot1opts(lpattern("--") lcolor(black) mcolor(black)) ci1opts(color(black)) ///
legend(order(3 "Peaceful" 1 "Contentious") title("Tactics")) ///
ytitle("Protest Intention", height(7)) graphregion(color(white))  ///
plot2opts(mcolor(black)) ci2opts(color(black)) ///
saving(Mobilization, replace)

grc1leg Support.gph Mobilization.gph, ycommon xcommon


***Table 4: Predicting Protest Support, models 3-6

  *Protest support & ideology (model 3)
reg agree01 ideo01 contentious disrespectful i.sample i.topissue, robust

  *Protest support & ideology, interactions between ideology and protest characteristics (model 4)
reg agree01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.sample i.topissue, robust

  *Protest support & authoritarianism (model 5)
reg agree01 auth01 contentious disrespectful i.sample i.topissue, robust

  *Protest support & authoritarianism, interactions between authoritarianism and protest characteristics (model 6)
reg agree01 c.auth01##i.contentious c.auth01##i.disrespectful i.sample i.topissue, robust

***Table 5: Predicting Self-Reported Protest Intention, models 7-10

  *protest intention & ideology (model 7)
reg attend01 ideo01 contentious disrespectful i.sample i.topissue, robust

  *Protest intention & ideology, interactions between ideology and protest characteristics (model 8)
reg attend01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.sample i.topissue, robust

  *Protest intention & authoritarianism (model 9)
reg attend01 auth01 contentious disrespectful i.sample i.topissue, robust

  *Protest intention & authoritarianism, interactions between authoritarianism and protest characteristics (model 10)
reg attend01 c.auth01##i.contentious c.auth01##i.disrespectful i.sample i.topissue, robust


***Table A1. Sample Descriptives

*gender, by sample
mean male, over(sample)
sum male

*race, by sample
*samples: 1=blog, 2=mturk, 3=student
tab racecat if sample==1
tab racecat if sample==2
tab racecat if sample==3
tab racecat

*age, by sample
*samples: 1=blog, 2=mturk, 3=student
tab agecat if sample==1
tab agecat if sample==2
tab agecat if sample==3
tab agecat

*SES class (self-reported), by sample
*class: 1=lower, 2=working, 3=middle, 4=upper
tab class if sample==1
tab class if sample==2
tab class if sample==3
tab class

*education, by sample
*1=No High School, 2=High School, 3=Some College or A.A.,3=B.A. or equiv., 4=Post-grad.
tab educ2 if sample==1
tab educ2 if sample==2
tab educ2 if sample==3
tab educ2

*ideology, by sample
*1=liberal, 2=moderate, 3=conservative
tab ideo3 if sample==1
tab ideo3 if sample==2
tab ideo3 if sample==3
tab ideo3

***Table A2. Means and Standard Deviation of Authoritarianism Scale across Samples and Ideology

  *Cronbach's alpha for authoritarian items
alpha auth1 auth2 auth3 auth4
alpha auth1 auth2 auth3 auth4 if sample==1
alpha auth1 auth2 auth3 auth4 if sample==2
alpha auth1 auth2 auth3 auth4 if sample==3

mean auth01, over(sample)
mean auth01, over(ideo3 sample)

***Table A4. % of Respondents Rating Each Issue a Top Priority for Obama and Congress in 2015
tab topissue
tab topissue if ideo3==1
tab topissue if ideo3==3

***Figure A2. Perceptions of Protesters’ Peacefulness and Respectfulness of Police across Experimental Manipulations
 
 *DV= perceptions of peacefulness
reg peaceful01 i.contentious##i.disrespectful, robust

margins contentious#disrespectful

marginsplot, title("Peacefulness of Protesters") xtitle("Tactics") ylab(#5) xlab(0"Peaceful" 1"Contentious") xscale(range(0 1.1)) ///
plot1opts(lpattern("--") lcolor(black) mcolor(black)) ci1opts(color(black))  ///
legend(order(3 "Respectful" 1 "Disrespectful") title("Treatment of Police")) ///
ytitle("Peaceful", height(7)) graphregion(color(white)) ///
plot2opts(mcolor(black)) ci2opts(color(black)) 

  *DV= perceptions of disrespectfullness
reg peaceful01 i.contentious##i.disrespectful, robust

margins contentious#disrespectful

marginsplot, title("Peacefulness of Protesters") xtitle("Tactics") ylab(#5) xlab(0"Peaceful" 1"Contentious") xscale(range(0 1.1)) ///
plot1opts(lpattern("--") lcolor(black) mcolor(black)) ci1opts(color(black))  ///
legend(order(3 "Respectful" 1 "Disrespectful") title("Treatment of Police")) ///
ytitle("Peaceful", height(7)) graphregion(color(white)) ///
plot2opts(mcolor(black)) ci2opts(color(black)) 

***Random Assignment Checks

  *ideology
 anova ideo01 condition
 
  *authoritarianism
 anova auth01 condition
 
  *income
 anova income01 condition

  *education
 anova education condition
  
  *age
 anova education condition
 
  *race
 tab condition racecat, chi row
 
  *gender
 tab condition male, chi row

***Figure A3. Mean Protest Support and Protest Intentions across Experimental Conditions

     **Support DV**

*Use the collapse command to make the mean and standard deviation of attend DV by ideo and condition
collapse (mean) meanagree= agree01 (sd) sdagree=agree01 (count) n=agree01, by(condition)

*Now, make the upper and lower values of the confidence interval.
generate hiagree = meanagree + invttail(n-1,0.025)*(sdagree / sqrt(n))
generate loagree = meanagree - invttail(n-1,0.025)*(sdagree / sqrt(n))


twoway (bar meanagree condition, barw(.8)) ///
       (rcap hiagree loagree condition, lcolor("black")), ///
	   legend(off) ///
	   xlabel( 1 "Violent-Respect." 2 "Violent-Disrespect." 3 "Peaceful-Disrespect." 4 "Peaceful-Respect.", noticks angle(45)) ///
       xtitle("") ytitle("Mean Protest Support")



      **Mobilization DV**

*Use the collapse command to make the mean and standard deviation of attend DV by ideo and condition
collapse (mean) meanattend= attend01 (sd) sdattend=attend01 (count) n=attend01, by(condition)

*Now, make the upper and lower values of the confidence interval.
generate hiattend = meanattend + invttail(n-1,0.025)*(sdattend / sqrt(n))
generate loattend = meanattend - invttail(n-1,0.025)*(sdattend / sqrt(n))


twoway (bar meanattend condition, barw(.8)) ///
       (rcap hiattend loattend condition, lcolor("black")), ///
	   legend(off) ///
	   xlabel( 1 "Violent-Respect." 2 "Violent-Disrespect." 3 "Peaceful-Disrespect." 4 "Peaceful-Respect.", noticks angle(45)) ///
       xtitle("") ytitle("Mean Protest Intention")

***Figure A4. Mean Protest Support and Protest Intentions across Conditions by Sample

  **Protest Support DV**

*Use the collapse command to make the mean and standard deviation of attend DV by ideo and condition
collapse (mean) meanagree = agree01 (sd) sdagree=attend01 (count) n=agree01, by(sample condition)

*Now, make the upper and lower values of the confidence interval.
generate hiagree = meanagree + invttail(n-1,0.025)*(sdagree / sqrt(n))
generate loagree = meanagree - invttail(n-1,0.025)*(sdagree / sqrt(n))


*make a variable condsamp that will be a single variable that contains the condition and sample 
*information. 

generate consamp = condition if sample == 1
replace consamp = condition+5 if sample == 2
replace consamp = condition+10 if sample == 3

sort consamp
list consamp sample condition, sepby(sample)
*drop in 13
	   
twoway (bar meanagree consamp if condition==1) ///
       (bar meanagree consamp if condition==2) ///
       (bar meanagree consamp if condition==3) ///
       (bar meanagree consamp if condition==4) ///
       (rcap hiagree loagree consamp), ///
       legend(rows(2) order(1 "Contentious Respectful" 2 "Contentious Disrespectful" 3 "Peaceful Disrespectful" 4 "Peaceful Respectful")) ///
       xlabel( 2.5 "Blog" 7.5 "Mturk" 12.5 "Student", noticks) ///
       xtitle("Sample") ytitle("Mean Protest Support")

   **Mobilization DV**

*Use the collapse command to make the mean and standard deviation of attend DV by ideo and condition
collapse (mean) meanattend= attend01 (sd) sdattend=attend01 (count) n=attend01, by(sample condition)

*Now, make the upper and lower values of the confidence interval.
generate hiattend = meanattend + invttail(n-1,0.025)*(sdattend / sqrt(n))
generate loattend = meanattend - invttail(n-1,0.025)*(sdattend / sqrt(n))


*make a variable condsamp that will be a single variable that contains the condition and sample 
*information. 

generate consamp = condition if sample == 1
replace consamp = condition+5 if sample == 2
replace consamp = condition+10 if sample == 3

sort consamp
list consamp sample condition, sepby(sample)
*drop in 13
	   
twoway (bar meanattend consamp if condition==1) ///
       (bar meanattend consamp if condition==2) ///
       (bar meanattend consamp if condition==3) ///
       (bar meanattend consamp if condition==4) ///
       (rcap hiattend loattend consamp), ///
       legend(rows(2) order(1 "Contentious Respectful" 2 "Contentious Disrespectful" 3 "Peaceful Disrespectful" 4 "Peaceful Respectful")) ///
       xlabel( 2.5 "Blog" 7.5 "Mturk" 12.5 "Student", noticks) ///
       xtitle("Sample") ytitle("Likelihood of Attending Future Protest Event")


***Appendix H. Effects Ideology and Authoritarianism on Protest Support and Protest Intentions within Each Experimental Condition

  **Table A8. Effects of Experimental Condition and Ideology on Support for Protesters
reg agree01 c.ideo01 ib4.condition i.sample i.topissue, robust
reg agree01 c.ideo01##ib4.condition i.sample i.topissue, robust
reg attend01 c.ideo01 ib4.condition i.sample i.topissue, robust
reg attend01 c.ideo01##ib4.condition i.sample i.topissue, robust

  **Table A9. Effects of Authoritarianism and Experimental Conditions on Self-Reported Protest Intention and Protest Intention
reg agree01 c.auth01 ib4.condition i.sample i.topissue, robust
reg agree01 c.auth01##ib4.condition i.sample i.topissue, robust
reg attend01 c.auth01 ib4.condition i.sample i.topissue, robust
reg attend01 c.auth01##ib4.condition i.sample i.topissue, robust
  
  **Table A10. Effects of Ideology, Authoritarianism and Experimental Conditions on Protest Intention, with Additional Controls  
reg attend01 c.ideo01##ib4.condition i.sample i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01, robust
reg attend01 c.auth01##ib4.condition i.sample i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01, robust

***Appendix I. Full Results across Samples

  **Table A.11. Blog Sample: Effects of Ideology, Authoritarianism and Experimental Conditions on Protest Intention, with Additional Controls
reg attend01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==1, robust
reg agree01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==1, robust
reg attend01 c.auth01##i.contentious c.auth01##i.disrespectful  i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==1, robust
reg agree01 c.auth01##i.contentious c.auth01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==1, robust
  
  **Table A.12. MTurk Sample: Effects of Ideology, Authoritarianism and Experimental Conditions on Protest Intention, with Additional Controls
reg attend01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==2, robust
reg agree01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==2, robust
reg attend01 c.auth01##i.contentious c.auth01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==2, robust
reg agree01 c.auth01##i.contentious c.auth01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==2, robust
 
  **Table A.13. Student Sample: Effects of Ideology, Authoritarianism and Experimental Conditions on Protest Intention, with Additional Controls
reg attend01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==3, robust
reg agree01 c.ideo01##i.contentious c.ideo01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==3, robust
reg attend01 c.auth01##i.contentious c.auth01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==3, robust
reg agree01 c.auth01##i.contentious c.auth01##i.disrespectful i.topissue active01 immig01 smallgov raceissues01 environ01 protesteff01 if sample==3, robust
  
  



