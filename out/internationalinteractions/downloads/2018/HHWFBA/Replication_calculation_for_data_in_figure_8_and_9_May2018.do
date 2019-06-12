
*Use dataset "ReplicationData_Must_Rustad_II_May2018.dta"

*Codes for installing clarify program
*net from http://gking.harvard.edu/clarify/ net install clarify
*net install clarify

*The Figures are made i excel based on the data calculated here. The excel documents are also attached

/*Model 1*/
set more off 
capture drop b*
estsimp logit ShProtNR rev_q31c male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6, vce(cluster villnum)


setx (male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6 ) mean
 
setx rev_q31c 1
simqi, pr level(95)
 
setx rev_q31c 2
simqi, pr level(95)

setx rev_q31c 3
simqi, pr level(95)

setx rev_q31c 4
simqi, pr level(95)

setx rev_q31c 5
simqi, pr level(95)

 /*Model 5*/ 
 
set more off 
capture drop b*
estsimp logit ShProtNR rev_q15 male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6, vce(cluster villnum)


setx (male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6 ) mean
 
setx rev_q15 1
simqi, pr level(95)
 
setx rev_q15 2
simqi, pr level(95)

setx rev_q15 3
simqi, pr level(95)

setx rev_q15 4
simqi, pr level(95)

setx rev_q15 5
simqi, pr level(95)


*Model 9

capture drop b*
set more off 
capture drop b*
estsimp logit ShProtNR recode_q50 male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6, vce(cluster villnum)

setx (male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6 ) mean
 
setx recode_q50 1 
simqi, pr level(95)
 
setx recode_q50 2
simqi, pr level(95)

setx recode_q50 3
simqi, pr level(95)

setx recode_q50 4
simqi, pr level(95)



*Extracting data for Figure 9

/*Model 7*/
 set more off
capture drop b*
estsimp logit only_protest recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_2 feadmin2_3 feadmin2_4 feadmin2_5 feadmin2_6, vce(cluster villnum)

setx (male newage q7 q16a rev_q14 rural q45a feadmin2_2 feadmin2_3 feadmin2_4 feadmin2_5 feadmin2_6) mean
 
setx recode_q50 1 
simqi, pr level(95)
 
setx recode_q50 2
simqi, pr level(95)

setx recode_q50 3
simqi, pr level(95)

setx recode_q50 4
simqi, pr level(95)

/*Model 8*/
 set more off
capture drop b*
estsimp logit violence recode_q50  male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6, vce(cluster villnum)

setx (male newage q7 q16a rev_q14 rural q45a feadmin2_1 feadmin2_2 feadmin2_4 feadmin2_5 feadmin2_6) mean
 
setx recode_q50 1 
simqi, pr level(95)
 
setx recode_q50 2
simqi, pr level(95)

setx recode_q50 3
simqi, pr level(95)

setx recode_q50 4
simqi, pr level(95)
