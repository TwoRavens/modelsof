use C:\Users\Shahadat\Desktop\international_interaction\3rd_edition_definition.dta 
probit dstatus_eco f_pol_goal1 f_pol_goal2 f_pol_goal3 f_pol_goal4
predict yhat_probit if e(sample)
mfx if e(sample)
probit dstatus_eco f_pol_goal1 f_pol_goal2 f_pol_goal3 f_pol_goal4 rcompol3 intcop3 rintass3 priorrel3 duration, robust
predict yhat_probit_1 if e(sample)
mfx if e(sample)
probit dstatus_eco f_pol_goal1 f_pol_goal2 f_pol_goal3 f_pol_goal4 rcompol3 intcop3 rintass3 priorrel3 duration ctt3 gnpratio3 tradelink3 rhealths3 costsender3, robust
predict yhat_probit_2 if e(sample)
mfx if e(sample)
