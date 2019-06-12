/*Condon and Wichowsky. "Inequality in the Social Mind: Social Comparison and Support for Redistribution .  Journal of Politics.  Replication Syntax. */

use "InequalitySocialMind.dta", clear

*create treatment indicators
gen upward=0
replace upward=1 if H1_Male==1 | H1_Male1==1 | H2_Female==1 | H2_Female1==1
label variable upward "Upward comparison"
 
gen downward=0
replace downward=1 if L1_Male==1 | L1_Male2==1 | L2_Female==1 | L2_Female2==1
label variable downward "Downward comparison"
 
gen control=0
replace control=1 if upward==0 & downward==0
label variable control "Control"

*treatment assignment variable 
gen treatment=.
replace treatment=1 if upward==1
replace treatment=2 if control==1
replace treatment=3 if downward==1

label define treatment 1 "Upward" 2 "Control" 3 "Downward"
label values treatment treatment
label variable treatment "Social Position Treatment Assignment"
 
*Recode variables
 
replace Q1=. if Q1==-1
rename Q1 placement

recode II1 (1=4)(2=3)(3=2)(4=1)(else=.), gen(equalop)
recode II2 (1=4)(2=3)(3=2)(4=1)(else=.), gen(incdiff)


replace PQ1A_1=. if PQ1A_1==-1
replace PQ1B_1=. if PQ1B_1==-1
replace PQ1C_1=. if PQ1C_1==-1
replace PQ1D_1=. if PQ1D_1==-1

replace PQ1A=. if PQ1A==-1
replace PQ1B=. if PQ1B==-1
replace PQ1C=. if PQ1C==-1
replace PQ1D=. if PQ1D==-1

gen collegeaid=PQ1A
replace collegeaid=PQ1A_1 if collegeaid==.

gen socialsec=PQ1B
replace socialsec=PQ1B_1 if socialsec==.

gen foodstamps=PQ1C
replace foodstamps=PQ1C_1 if foodstamps==.

gen unemployment=PQ1D
replace unemployment=PQ1D_1 if unemployment==.

recode PPGENDER (1=0 "Male")(2=1 "Female")(else=.), gen(female)

recode XPARTY7 (1 2 3 =1 "Republican")(4 5 6 7 9=0 "Not Republican"), gen(republican)
recode XPARTY7 (5 6 7 =1 "Democrat")(1 2 3 4 9=0 "Democrat"), gen(democrat)

recode XIDEO (1 2 3 =1 "Liberal")(4 5 6 7 9=0 "Not Liberal"), gen(liberal)
recode XIDEO (5 6 7 =1 "Conservative")(1 2 3 4 9=0 "Not Conservative"), gen(conservative)

recode PPETHM (1 3 4 5 =0)(2=1)(else=.), gen(black)
recode PPETHM (1 2 3 5 =0)(4=1)(else=.), gen(hispanic)
recode PPETHM (1 2 4 =0)(3 5 =1)(else=.), gen(other)
recode PPETHM (2 3 4 5 =0)(1=1)(else=.), gen(white)

recode PPMSACAT (1 = 0 "Not rural") (0=1 "Rural") (else=.), gen(rural)
 
rename PPEDUCAT educ

rename PPINCIMP income

rename ppagecat age

*create social spending scale
factor socialsec collegeaid foodstamps unemployment, pcf
rotate
predict f1
rename f1 spending

*standardize gov't redistribution
egen incdiff_mean=mean(incdiff)
egen incdiff_sd=sd(incdiff)
replace incdiff=(incdiff-incdiff_mean)/incdiff_sd
drop incdiff_mean incdiff_sd

*standardize Social Security item
egen socialsec_mean=mean(socialsec)
egen socialsec_sd=sd(socialsec)
replace socialsec=(socialsec-socialsec_mean)/socialsec_sd
drop socialsec_mean socialsec_sd

*standardize College aid item
egen collegeaid_mean=mean(collegeaid)
egen collegeaid_sd=sd(collegeaid)
replace collegeaid=(collegeaid-collegeaid_mean)/collegeaid_sd
drop collegeaid_mean collegeaid_sd

*standardize Food Stamps item
egen foodstamps_mean=mean(foodstamps)
egen foodstamps_sd=sd(foodstamps)
replace foodstamps=(foodstamps-foodstamps_mean)/foodstamps_sd
drop foodstamps_mean foodstamps_sd

*standardize Unemployment item
egen unemployment_mean=mean(unemployment)
egen unemployment_sd=sd(unemployment)
replace unemployment=(unemployment-unemployment_mean)/unemployment_sd
drop unemployment_mean unemployment_sd

*standardize equal opportunity
egen equalop_mean=mean(equalop)
egen equalop_sd=sd(equalop)
replace equalop=(equalop-equalop_mean)/equalop_sd
drop equalop_mean equalop_sd
 
*adjust household income for household size
gen income_dollar=.
replace income_dollar=5000 if income==1
replace income_dollar=6260 if income==2
replace income_dollar=8750 if income==3
replace income_dollar=11250 if income==4
replace income_dollar=13750 if income==5
replace income_dollar=17500 if income==6
replace income_dollar=22500 if income==7
replace income_dollar=27500 if income==8
replace income_dollar=32500 if income==9
replace income_dollar=37500 if income==10
replace income_dollar=45000 if income==11
replace income_dollar=55000 if income==12
replace income_dollar=67500 if income==13
replace income_dollar=80000 if income==14
replace income_dollar=92500 if income==15
replace income_dollar=112500 if income==16
replace income_dollar=137500 if income==17
replace income_dollar=162500 if income==18
replace income_dollar=250000 if income==19

*adjusting for household size
gen PPHHSIZE_new=PPHHSIZE

generate income_adj=income_dollar/(PPHHSIZE^.5)

replace income_adj=income_adj*(2.5^.5)

*state cost of living
sort PPSTATEN
merge PPSTATEN using "state_cpi.dta"
replace income_adj=income_adj*state_col_adj

*estimate for analytic sample
drop if equalop==. | incdiff==. | spending==.
 
*balance test—Table A3 in the online appendix
mlogit treatment age educ income_adj black hispanic other female liberal conservative republican democrat,  baseoutcome(1)
est store m1
esttab m1 using TableBalance.csv, replace cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.20 ** 0.10 *** 0.05 )

*effect of upward comparison on self-placement, reported in text.  
*blocking on gender

tabstat placement if female==0 & control==0, by(treatment) stat(mean semean n)

*MEN
*treatment       mean		se(mean)	N
		
*Upward   		5.150943	.1700412	159
*Downward   	5.855172	.1275992	145		
*Total   		5.486842	.1094753	304
		
		
tabstat placement if female==1 & control==0, by(treatment) stat(mean semean n)

*WOMEN
*treatment		mean		se(mean)	N
			
*Upward			5.12		.1373837	150
*Downward		5.557576	.1301973	165			
*Total			5.349206	.0951555	315
			
*adjusting means for blocked design: 
*upward comparison: (5.15*.49) + (5.12*.51) = 5.14
*standard errors: (.17*.49)+(.14*.51) = 0.15
*downward comparison: (5.89*.49)+(5.56*.51) = 5.70
*standard error: (.13*.49)+(.13*.51) = 0.13

		
*unadjusted for blocked design, reported in Table A3 in online appendix
ttest placement if control==0, by(upward)


*means and standard errors by treatment condition; DV= gov't should reduce income differences 
*blocking on gender, used to construct Figure 1
tabstat incdiff if female==0, by(treatment) stat(mean semean n)
tabstat incdiff if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design, reported in Table A3 in online appendix
tabstat incdiff, by(treatment) stat(mean semean n)
 
*means and standard errors by treatment condition; DV= social spending scale 
*blocking on gender, used to construct Figure 1
tabstat spending if female==0, by(treatment) stat(mean semean n)
tabstat spending if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design, reported in Table A3 in online appendix
tabstat spending, by(treatment) stat(mean semean n)

*means and standard errors by treatment condition; DV= spending on program 
*blocking on gender, used to construct Figure 2
tabstat socialsec if female==0, by(treatment) stat(mean semean n)
tabstat socialsec if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design, reported in Table A3 in online appendix
tabstat socialsec, by(treatment) stat(mean semean n)

*blocking on gender, used to construct Figure 2
tabstat collegeaid if female==0, by(treatment) stat(mean semean n)
tabstat collegeaid if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design, reported in Table A3 in online appendix
tabstat collegeaid, by(treatment) stat(mean semean n)

*blocking on gender, used to construct Figure 2
tabstat foodstamps if female==0, by(treatment) stat(mean semean n)
tabstat foodstamps if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design, reported in Table A3 in online appendix
tabstat foodstamps, by(treatment) stat(mean semean n)

*blocking on gender, used to construct Figure 2
tabstat unemployment if female==0, by(treatment) stat(mean semean n)
tabstat unemployment if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design, reported in Table A3 in online appendix
tabstat unemployment, by(treatment) stat(mean semean n)

*effect of upward comparison on placement by social group, reported in Table A6 in online appendix 
ttest placement if republican==1 & control==0, by(upward) 
ttest placement if democrat==1 & control==0, by(upward) 

ttest placement if conservative==1 & control==0, by(upward) 
ttest placement if liberal==1 & control==0, by(upward) 

ttest placement if white==1 & female==0 & educ<4 & control==0, by(upward)
ttest placement if white==1 & female==1 & educ<4 & control==0, by(upward) 
ttest placement if white==1 & female==0 & educ==4 & control==0, by(upward) 
ttest placement if white==1 & female==1 & educ==4 & control==0, by(upward) 
ttest placement if white==0 &  educ<4 & control==0, by(upward) 
ttest placement if white==0 &  educ==4 & control==0, by(upward) 

*means and standard errors by PID and ideology, reported in Table A6 in online appendix

tabstat incdiff if republican==1, by(treatment) stat(mean semean n)
tabstat incdiff if democrat==1, by(treatment) stat(mean semean n)
  
tabstat incdiff if conservative==1, by(treatment) stat(mean semean n)
tabstat incdiff if liberal==1, by(treatment) stat(mean semean n)

tabstat spending if republican==1, by(treatment) stat(mean semean n)
tabstat spending if democrat==1, by(treatment) stat(mean semean n)
  
tabstat spending if conservative==1, by(treatment) stat(mean semean n)
tabstat spending if liberal==1, by(treatment) stat(mean semean n)
  
*means and standard errors for non-hispanic white men without college degree
tabstat incdiff if white==1 & female==0 & educ<4, by(treatment) stat(mean semean n)
tabstat spending if white==1 & female==0 & educ<4, by(treatment) stat(mean semean n)

*means and standard errors for non-hispanic white women wihtout college degree
tabstat incdiff if white==1 & female==1 & educ<4, by(treatment) stat(mean semean n)
tabstat spending if white==1 & female==1 & educ<4, by(treatment) stat(mean semean n)

*means and standard errors for non-hispanic white men with college degree
tabstat incdiff if white==1 & female==0 & educ==4, by(treatment) stat(mean semean n)
tabstat spending if white==1 & female==0 & edu==4, by(treatment) stat(mean semean n)
  
*means and standard errors for non-hispanic white women with college degree
tabstat incdiff if white==1 & female==1 & educ==4, by(treatment) stat(mean semean n)
tabstat spending if white==1 & female==1 & edu==4, by(treatment) stat(mean semean n)
    
*means and standard errors for non-white without college degree
tabstat incdiff if white==0 &  educ<4, by(treatment) stat(mean semean n)
tabstat spending if white==0  & educ<4, by(treatment) stat(mean semean n)
 
*means and standard errors for non-white with college degree
tabstat incdiff if white==0 &  educ==4, by(treatment) stat(mean semean n)
tabstat spending if white==0  & educ==4, by(treatment) stat(mean semean n) 
   

*means and standard errors for alternative item, gov't should do more to ensure equal opportunity
*reported in footnote #7 and supplemental appendix
*blocking on gender
tabstat equalop if female==0, by(treatment) stat(mean semean n)
tabstat equalop if female==1, by(treatment) stat(mean semean n)

*unadjusted for blocked design
tabstat equalop, by(treatment) stat(mean semean n)


*means and standard errors by PID and ideology

tabstat equalop if republican==1, by(treatment) stat(mean semean n)
tabstat equalop if democrat==1, by(treatment) stat(mean semean n)
  
tabstat equalop if conservative==1, by(treatment) stat(mean semean n)
tabstat equalop if liberal==1, by(treatment) stat(mean semean n)

*means and standard errors for non-hispanic white men without college degree
tabstat equalop if white==1 & female==0 & educ<4, by(treatment) stat(mean semean n)

*means and standard errors for non-hispanic white women wihtout college degree
tabstat equalop if white==1 & female==1 & educ<4, by(treatment) stat(mean semean n)

*means and standard errors for non-hispanic white men with college degree
tabstat equalop if white==1 & female==0 & educ==4, by(treatment) stat(mean semean n)
  
*means and standard errors for non-hispanic white women with college degree
tabstat equalop if white==1 & female==1 & educ==4, by(treatment) stat(mean semean n)
    
*means and standard errors for non-white without college degree
tabstat equalop if white==0 &  educ<4, by(treatment) stat(mean semean n)
 
*means and standard errors for non-white with college degree
tabstat equalop if white==0 &  educ==4, by(treatment) stat(mean semean n)


*Replication study with ladder only treatment, reported in Table A2 in online appendix
use "ladder_replication.dta", clear
tabstat placement, by(treatment) stat(mean semean n)


 
