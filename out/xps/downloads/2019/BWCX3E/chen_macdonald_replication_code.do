* Index measure setup
gen issue = (q41 + q42 + q43 + q51 + q52 + q53a + q54 + q55 + q56) / 9
gen compliance = (q44 + q45 + q46) / 3
gen satisfaction = (q61 + q62 + q63) / 3

* Make text variables into numeric, label 
encode q13, gen(income) label("Recode of Q13")

encode q9, gen(female) label("Recode of Q9")
recode female (2=.) (3=0)

encode q10, gen(married) label("Recode of Q10")
recode married (1=0) (3=0) (2=1) (4=.)

encode q11, gen(iswhitecollar) label("Recode of Q11")
recode iswhitecollar (1=0) (2=1) (3=1) (4=1) (5=0) (6=0) (7=0) (8=1) (9=0)

encode q11, gen(inworkforce) label("Recode of Q11")
recode inworkforce (2=1) (3=1) (4=1) (5=0) (6=0) (7=1) (8=0) (9=1)

encode q12, gen(partymember) label("Recode of Q12")
recode partymember (2=0)

encode q15, gen(education) label("Recode of Q15")

encode q17, gen(urbanhukou) label("Recode of Q17")
recode urbanhukou (2=0) (3=0) (4=0)

encode q18, gen(chaiqianexp) label("Recode of Q18")
recode chaiqianexp (2=0) (3=.)

encode city, gen(guangzhou) label("Recode of city")
recode guangzhou (2=0)

recode q7 (1=1), gen(newsfreq)

recode q14 (1=1), gen(age)

recode survey (3 = 1) (else = 0), gen(issports)

*** Table 1 - Demographics
mean age if((survey==3 | survey==7) & guangzhou==0)
mean age if((survey==3 | survey==7) & guangzhou==1)
mean age if(survey==3 | survey==7)

mean female if((survey==3 | survey==7) & guangzhou==0)
mean female if((survey==3 | survey==7) & guangzhou==1)
mean female if(survey==3 | survey==7)

sum income if((survey==3 | survey==7) & guangzhou==0), detail
sum income if((survey==3 | survey==7) & guangzhou==1), detail
sum income if(survey==3 | survey==7), detail

sum education if((survey==3 | survey==7) & guangzhou==0), detail
sum education if((survey==3 | survey==7) & guangzhou==1), detail
sum education if(survey==3 | survey==7), detail

mean urbanhukou if((survey==3 | survey==7) & guangzhou==0)
mean urbanhukou if((survey==3 | survey==7) & guangzhou==1)
mean urbanhukou if(survey==3 | survey==7)

*** Table 2 - Balance Test
ttest age if(survey==3 | survey==7), by(survey) 
ttest income if(survey==3 | survey==7), by(survey) 
ttest married if(survey==3 | survey==7), by(survey) 
ttest chaiqianexp if(survey==3 | survey==7), by(survey) 
ttest education if(survey==3 | survey==7), by(survey) 
ttest partymember if(survey==3 | survey==7), by(survey) 
ttest female if(survey==3 | survey==7), by(survey) 
ttest urbanhukou if(survey==3 | survey==7), by(survey) 
ttest iswhitecollar if(survey==3 | survey==7), by(survey) 
ttest inworkforce if(survey==3 | survey==7), by(survey) 

*** Table 3 - Question Responses

* Issue
ttest q51 if(survey==3 | survey==7), by(survey) unequal
ttest q52 if(survey==3 | survey==7), by(survey) unequal
ttest q53a if(survey==3 | survey==7), by(survey) unequal
ttest q54 if(survey==3 | survey==7), by(survey) unequal

* Compliance 
ttest q44 if(survey==3 | survey==7), by(survey) unequal
ttest q45 if(survey==3 | survey==7), by(survey) unequal
ttest q46 if(survey==3 | survey==7), by(survey) unequal

* Satisfaction 
ttest q61 if(survey==3 | survey==7), by(survey) unequal
ttest q62 if(survey==3 | survey==7), by(survey) unequal
ttest q63 if(survey==3 | survey==7), by(survey) unequal

* Others (Pooled Comparison)
ttest q41 if(survey==3 | survey==7), by(survey) unequal
ttest q42 if(survey==3 | survey==7), by(survey) unequal
ttest q43 if(survey==3 | survey==7), by(survey) unequal

ttest q55 if(survey==3 | survey==7), by(survey) unequal
ttest q56 if(survey==3 | survey==7), by(survey) unequal

*** Table 4 - Index Test
ttest compliance if(survey==3 | survey==7), by(survey) unequal
ttest satisfaction if(survey==3 | survey==7), by(survey) unequal

*** Table 5 - Regression
eststo clear

eststo: reg q44 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg q45 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg q46 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg compliance issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)

eststo: reg q61 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg q62 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7) 
eststo: reg q63 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg satisfaction issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)

*esttab using regression.tex, title("Regression Results") replace p(2) mtitles("C1" "C2" "C3" "C Index" "S1" "S2" "S3" "S Index") r2 b(2) noconstant wide star(* 0.05 ** 0.01)
esttab using regression-main.csv, title("Regression Results") replace p(2) mtitles("C1" "C2" "C3" "C Index" "S1" "S2" "S3" "S Index") star(* 0.05 ** 0.01) r2 b(2) noconstant
eststo clear

*** Table 6 - Issue regression
eststo clear
eststo: reg q51 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg q52 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7) 
eststo: reg q53a issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
eststo: reg q54 issports newsfreq female married iswhitecollar inworkforce partymember income education age urbanhukou chaiqianexp guangzhou if(survey==3 | survey==7)
esttab using regression-issues.csv, title("Regression Results") replace p(2) mtitles("I1" "I2" "I3" "I4") star(* 0.05 ** 0.01) r2 b(2) noconstant
eststo clear

*** Table 7 - Correlation
pwcorr q51 q52 q53a q54 q62 if(survey==3 | survey==7)
