/* REPLICATION MATERIALS FOR DATAVERSE

Kane & Newman:  "Organized Labor as the New Undeserving Rich?  Mass Media, Class-Based 
Anti-Union Rhetoric, and Public Support for Unions in the U.S."  
Published in British Journal of Political Science, 2017

*****************************************
STUDY 1:  Long Island Railroad Workers (M-Turk Sample)
*****************************************

DATA = "Kane_Newman_CAR_LIRR Study 1.dta" */

*(1) Figure 1 / Table D1 
ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1

*(2) Figure 3 / Table D3
ologit dvSim X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1

*(3) Results by PID and Political Interest - Table D2
ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic union if Citiz==1 & PID01>.5

ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic union if Citiz==1 & PID01<.5

ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1 & polint>3

ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1 & polint<4

*(4) Additional Controlled Interactions: Table D4
ologit dvSim X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  Age male black hispanic PID01 union X2XIncome_01 X3XIncome_01  X2XPID01 X3XPID01 if Citiz==1

*(5) Mediation Analyses:  Figure 2
* NOTE:  PERFORMED USING "MEDIATION" PACKAGE IN R (Non-citizens excluded prior to analyses)

** Mediator=Similarity; Outcome=Favor Laws Allowing Workers to Strike
med.fitSimStr<-polr(dvSimFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 1, method="logistic")
summary(med.fitSimStr)

out.fitSimStr<-glm(dvStr01~dvSimFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 1, family=binomial("logit"))
summary(out.fitSimStr)

med.outSimStr<-mediate(med.fitSimStr,
+ out.fitSimStr,
+ treat="X3",
+ mediator="dvSimFactor",
+ sims=1000,
+ )
summary(med.outSimStr)

** Mediator=Similarity; Outcome=Favor Strong Laws For Collective Bargaining
med.fitSimForm<-polr(dvSimFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 1, method="logistic")
summary(med.fitSimForm)

out.fitSimForm<-polr(dvFormFactor~dvSimFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 1, method="logistic")
summary(out.fitSimForm)

med.outSimForm<-mediate(med.fitSimForm,
+ out.fitSimForm,
+ treat="X3",
+ mediator="dvSimFactor",
+ sims=1000,
+ boot=TRUE
+ )
summary(med.outSimForm)


*****************************************
/* STUDY 2:  United Auto Workers
*****************************************

DATA = "Kane_Newman_CAR_UAW Study.dta" */

*(1) Figure 1 / Table D1 
ologit dvDes X2 X3 edu_01 Income_01  age male black hispanic PID01 union if Citiz==1

*(2) Figure 3 / Table D3
ologit dvDes X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  age male black hispanic PID01 union if Citiz==1

*(3) Results by PID and Political Interest - Table D2
ologit dvDes X2 X3 edu_01 Income_01  age male black hispanic union if Citiz==1 & PID01<.5

ologit dvDes X2 X3 edu_01 Income_01  age male black hispanic union if Citiz==1 & PID01>.5

ologit dvDes X2 X3 edu_01 Income_01  age male black hispanic PID01 union if Citiz==1 & polint>3

ologit dvDes X2 X3 edu_01 Income_01  age male black hispanic PID01 union if Citiz==1 & polint<4

*(4) Additional Controlled Interactions: Table D4
ologit dvDes X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  age male black hispanic PID01 union X2XIncome_01 X3XIncome_01  X2XPID01 X3XPID01 if Citiz==1

*(5) Mediation Analyses:  Figure 2
* NOTE:  PERFORMED USING "MEDIATION" PACKAGE IN R (Non-citizens excluded prior to analyses)

**Mediator=Deservingness; Outcome=Favor Laws Allowing Workers to Strike
med.fitDesStr<-polr(dvDesFactor~ X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_UAW Study, method="logistic")
summary(med.fitDesStr)

out.fitDesStr<-glm(dvStr01~dvDesFactor+ X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_UAW Study, family=binomial("logit"))
summary(out.fitDesStr)

med.outDesStr<-mediate(med.fitDesStr,
+ out.fitDesStr,
+ treat="X3",
+ mediator="dvDesFactor",
+ sims=1000,
+ )
summary(med.outDesStr)

** Mediator=Similarity; Outcome=Favor Strong Laws For Collective Bargaining
med.fitDesForm<-polr(dvDesFactor~ X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_UAW Study, method="logistic")
summary(med.fitDesForm)

out.fitDesForm<-polr(dvFormFactor~dvDesFactor+ X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_UAW Study, method="logistic")
summary(out.fitDesForm)

med.outDesForm<-mediate(med.fitDesForm,
+ out.fitDesForm,
+ treat="X3",
+ mediator="dvDesFactor",
+ sims=1000,
+ boot=TRUE
+ )
> summary(med.outDesForm)


*****************************************
/* STUDY 3:  Teachers Union 
*****************************************

DATA = "Kane_Newman_CAR_Teachers Study.dta */

*(1) Figure 1 / Table D1 
ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1

ologit dvDes X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1

*(2) Figure 3 / Table D3
ologit dvSim X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1

ologit dvDes X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1

*(3) Results by PID and Political Interest - Table D2
								* DV=Similarity
ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic union if Citiz==1 & PID01>.5

ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic union if Citiz==1 & PID01<.5

ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1 & polint>3

ologit dvSim X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1 & polint<4
								*DV=Deservingness
ologit dvDes X2 X3 edu_01 Income_01  Age male black hispanic union if Citiz==1 & PID01>.5

ologit dvDes X2 X3 edu_01 Income_01  Age male black hispanic union if Citiz==1 & PID01<.5

ologit dvDes X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1 & polint>3

ologit dvDes X2 X3 edu_01 Income_01  Age male black hispanic PID01 union if Citiz==1 & polint<3

*(4) Additional Controlled Interactions: Table D4
ologit dvSim X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  Age male black hispanic PID01 union X2XIncome_01 X3XIncome_01  X2XPID01 X3XPID01 if Citiz==1

ologit dvDes X2 X3 WrkrIDCOMBINED01 X2XWrkrIDCOMBINED01 X3XWrkrIDCOMBINED01 edu_01 Income_01  Age male black hispanic PID01 union X2XIncome_01 X3XIncome_01  X2XPID01 X3XPID01 if Citiz==1

*(5) Mediation Analyses:  Figure 2
* NOTE:  PERFORMED USING "MEDIATION" PACKAGE IN R (Non-citizens excluded prior to analyses)

** Mediator=Similarity; Outcome=Favor Laws Allowing Workers to Strike
med.fitSimStr<-polr(dvSimFactor ~ X2 + X3 + edu01 + income01 + age + 
    male + black + hispanic + pid01 + union, data = Kane_Newman_CAR_Teachers Study, 
    method = "logistic")
summary(med.fitSimStr)

out.fitSimStr<-glm(dvStr01 ~ dvSimFactor + X2 + X3 + edu01 + income01 + 
    age + male + black + hispanic + pid01 + union, family = binomial("logit"), 
    data = Kane_Newman_CAR_Teachers Study)
summary(out.fitSimStr)

med.outSimStr<-mediate(med.fitSimStr,
+ out.fitSimStr,
+ treat="X3",
+ mediator="dvSimFactor",
+ sims=1000,
+ )
summary(med.outDesForm)

** Mediator=Similarity; Outcome=Favor Strong Laws For Collective Bargaining
med.fitSimForm<-polr(dvSimFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_Teachers Study, method="logistic")
summary(med.fitSimForm)

out.fitSimForm<-polr(dvFormFactor~dvSimFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_Teachers Study, method="logistic")
summary(out.fitSimForm)

med.outSimForm<-mediate(med.fitSimForm,
+ out.fitSimForm,
+ treat="X3",
+ mediator="dvSimFactor",
+ sims=1000,
+ boot=TRUE
+ )

summary(med.outSimForm)
** Mediator=Deservingness; Outcome=Favor Laws Allowing Workers to Strike
med.fitDesStr<-polr(dvDesFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_Teachers Study, method="logistic")
summary(med.fitDesStr)

out.fitDesStr<-glm(dvStr01~dvDesFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_Teachers Study, family=binomial("logit"))
summary(out.fitDesStr)

med.outDesStr<-mediate(med.fitDesStr,
+ out.fitDesStr,
+ treat="X3",
+ mediator="dvDesFactor",
+ sims=1000,
+ )
summary(med.outDesStr)


** Mediator=Deservingness; Outcome=Favor Strong Laws For Collective Bargaining
med.fitDesForm<-polr(dvDesFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_Teachers Study, method="logistic")
summary(med.fitDesForm)

out.fitDesForm<-polr(dvFormFactor~dvDesFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_Teachers Study, method="logistic")
summary(out.fitDesForm)

med.outDesForm<-mediate(med.fitDesForm,
+ out.fitDesForm,
+ treat="X3",
+ mediator="dvDesFactor",
+ sims=1000,
+ boot=TRUE
+ )
summary(med.outDesForm)


*****************************************
/* STUDY 4:  Long Island Railroad Workers (Qualtrics Sample) 
*****************************************

DATA = "Kane_Newman_CAR_LIRR Study 2.dta" */

*(1) Figure 4, Panel A / Table D5
ologit dvSim X2 X3 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0

ologit dvDes X2 X3 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0

*(2) Table D6 
ologit dvSim X2 X3 edu01 income01 age male black hispanic unionmem if readtimeoutlier==0 & PID01<.5

ologit dvSim X2 X3 edu01 income01 age male black hispanic unionmem if readtimeoutlier==0 & PID01>.5

ologit dvSim X2 X3 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0 & polint<4

ologit dvSim X2 X3 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0 & polint> 3

ologit dvDes X2 X3 edu01 income01 age male black hispanic unionmem if readtimeoutlier==0 & PID01<.5

ologit dvDes X2 X3 edu01 income01 age male black hispanic unionmem if readtimeoutlier==0 & PID01>.5

ologit dvDes X2 X3 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0 & polint< 4

ologit dvDes X2 X3 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0 & polint> 3

*(3) Figure 4 Panel C / Table D7 
ologit dvSim X2 X3 idworker_01 X2Xidworker_01 X3Xidworker_01 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0

ologit dvDes X2 X3 idworker_01 X2Xidworker_01 X3Xidworker_01 edu01 income01 age male black hispanic PID01 unionmem if readtimeoutlier==0

*(4) Table D8
ologit dvSim X2 X3 idworker_01 X2Xidworker_01 X3Xidworker_01 edu01 income01 age male black hispanic PID01 unionmem X2Xincome01 X3Xincome01 X2XPID01 X3XPID01 if readtimeoutlier==0

ologit dvDes X2 X3 idworker_01 X2Xidworker_01 X3Xidworker_01 edu01 income01 age male black hispanic PID01 unionmem X2Xincome01 X3Xincome01 X2XPID01 X3XPID01 if readtimeoutlier==0


*(5) Mediation Analyses:  Figure 4, Panel B
* NOTE:  PERFORMED USING "MEDIATION" PACKAGE IN R ("read time outliers" excluded prior to analyses)

** Mediator=Similarity; Outcome=Favor Laws Allowing Workers to Strike
med.fitSimStr<-polr(dvSimFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union,data=Kane_Newman_CAR_LIRR Study 2, method="logistic")
summary(med.fitSimStr)

out.fitSimStr<-glm(dvStr01~dvSimFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, family=binomial("logit"))
summary(out.fitSimStr)

med.outSimStr<-mediate(med.fitSimStr,
+ out.fitSimStr,
+ treat="X3",
+ mediator="dvSimFactor",
+ sims=1000,
+ )
summary(med.outSimStr)

** Mediator=Similarity; Outcome=Favor Strong Laws For Collective Bargaining
med.fitSimForm<-polr(dvSimFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, method="logistic")
summary(med.fitSimForm)

out.fitSimForm<-polr(dvFormFactor~dvSimFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, method="logistic")
summary(out.fitSimForm)

med.outSimForm<-mediate(med.fitSimForm,
+ out.fitSimForm,
+ treat="X3",
+ mediator="dvSimFactor",
+ sims=1000,
+ boot=TRUE
+ )
summary(med.outSimForm)

** Mediator=Deservingness; Outcome=Favor Laws Allowing Workers to Strike

med.fitDesStr<-polr(dvDesFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, method="logistic")
summary(med.fitDesStr)

out.fitDesStr<-glm(dvStr01~dvDesFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, family=binomial("logit"))
summary(out.fitDesStr)

med.outDesStr<-mediate(med.fitDesStr,
+ out.fitDesStr,
+ treat="X3",
+ mediator="dvDesFactor",
+ sims=1000,
+ )
summary(med.outDesStr)

** Mediator=Deservingness; Outcome=Favor Strong Laws For Collective Bargaining

med.fitDesForm<-polr(dvDesFactor~X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, method="logistic")
summary(med.fitDesForm)

out.fitDesForm<-polr(dvFormFactor~dvDesFactor+X2+X3+edu01+income01+age+male+black+hispanic+pid01+union, data=Kane_Newman_CAR_LIRR Study 2, method="logistic")
summary(out.fitDesForm)

med.outDesForm<-mediate(med.fitDesForm,
+ out.fitDesForm,
+ treat="X3",
+ mediator="dvDesFactor",
+ sims=1000,
+ boot=TRUE
+ )
summary(med.outDesForm)
