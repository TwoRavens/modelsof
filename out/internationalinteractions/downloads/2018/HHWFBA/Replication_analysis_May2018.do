*Analyses in the paper

*Use dataset "ReplicationData_Must_Rustad_II_May2018.dta"

*Table 1
set more off
logit ShProtNR rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit UseVio rev_q15 male newage q7  q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit only_protest rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit violence rev_q15 male newage q7  q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)

*Table 2
set more off
logit ShProtNR recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit UseVio recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit only_protest recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit violence recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)

/*Table 3*/
set more off
logit ShProtNR rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit UseVio rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit only_protest rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit violence rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)

/*Descriptivs*/
sum ShProtNR UseVio only_protest violence rev_q31c rev_q15 recode_q50  male newage q7  q16a rev_q14 rural q45a 
corr ShProtNR UseVio only_protest violence rev_q31c rev_q15 recode_q50  male newage q7  q16a rev_q14 rural q45a 


*Appendix
/*Objective HI*/
/*Table A_1*/
 /*Generate Asset Wealth Index*/
 pca  q17a q17b q17c q17d q17e
predict pca_variable

sum pca_variable

/*asset wealth indext individual - compared to the highest score*/ 
*The higher score the better off
gen relative_AWI_induvidual =1- (pca_variable/3.138478)

*Table 1
set more off
logit ShProtNR rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit UseVio rev_q15 male newage q7  q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit only_protest rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit violence rev_q15 male newage q7  q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)

*Table 2
set more off
logit ShProtNR recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit UseVio recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit only_protest recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit violence recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)

/*Table 3*/
set more off
logit ShProtNR rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit UseVio rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit only_protest rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)
logit violence rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* relative_AWI_induvidual, vce(cluster villnum)


/*Imputation*/
/Table A_2/
 *Multiple impute
*Table 1
mi set mlong
mi register imputed rev_q15 
set seed 29390

mi xtset, clear

mi impute mvn rev_q15 = ShProtNR UseVio  only_protest violence  male newage q7 q16a rev_q14 rural q45a feadmin2_* , add(10) force
mi estimate: logistic ShProtNR rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic UseVio rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic only_protest rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic violence rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_* 


*Table 2
*You might have to upload the dataset again to run this analysis, and run it with out running the previous imputations
mi set mlong
mi register imputed recode_q50 
set seed 29390

mi impute mvn recode_q50 = ShProtNR UseVio  only_protest violence  male newage q7 q16a rev_q14 rural q45a feadmin2_* , add(11) force
mi estimate: logistic ShProtNR recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic UseVio recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic only_protest recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic violence recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_* 


*Table 3
*You might have to upload the dataset again to run this analysis, and run it with out running the previous imputations
mi set mlong
mi register imputed rev_q31c
set seed 29390

mi impute mvn rev_q31c = ShProtNR UseVio  only_protest violence  male newage q7 q16a rev_q14 rural q45a feadmin2_* , add(10) force
mi estimate: logistic ShProtNR rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic UseVio rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic only_protest rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_* 
mi estimate: logistic violence rev_q31c  male newage q7 q16a rev_q14 rural q45a feadmin2_* 


/*Interactions*/
/*Table A_3*/
logit violence rev_q31c male rev_q31c_men newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit violence rev_q15 male rev_q15_edu newage q7  q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)

/*Adding all the variables into the same table*/
/*Table A_4*/
set more off
logit ShProtNR rev_q31c rev_q15 recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit UseVio rev_q31c rev_q15 recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit only_protest rev_q31c rev_q15 recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit violence rev_q31c rev_q15 recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)

/*General attitudes to protest*/
/*Table A_5*/
logit ShProt rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit ShProt recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)
logit ShProt rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)

/*Distance to riots*/
/Table A_6/
/*Table 1*/
set more off
logit ShProtNR rev_q15 male newage q7  q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit UseVio rev_q15 male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit only_protest rev_q15 male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit violence rev_q15 male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)

/*Table 2*/
set more off
logit ShProtNR recode_q50 male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit UseVio recode_q50  male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit only_protest recode_q50  male newage q7  q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit violence recode_q50  male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)

/*Table 3*/
set more off
logit ShProtNR rev_q31c male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit UseVio rev_q31c male newage q7 q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit only_protest rev_q31c male newage q7  q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)
logit violence rev_q31c male newage q7  q16a rev_q14 rural q45a acled_dist feadmin2_*, vce(cluster villnum)

/*Protest and Violence together*/
/*Table A_7*/
logit protest recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_*, vce(cluster villnum)


