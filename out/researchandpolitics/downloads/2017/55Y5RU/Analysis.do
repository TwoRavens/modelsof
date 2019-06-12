/* Load Dataset */

probit Never_Trump1 Conservatism Endorsed_Rival Female Hispanic Mormon Up_For_Reelection Obama_Vote Trump_Primary Muslim_Pop Hispanic_Pop Black_Pop Educated_Pop Manufacturing_Pop Terror_Concerns Race_Resentment Economic_Anxiety Establishment_Record TP_FC Leader Senate
/* Model 1 with 1/0 #NeverTrump dependent variable */

oprobit Never_Trump2 Conservatism Endorsed_Rival Female Hispanic Mormon Up_For_Reelection Obama_Vote Trump_Primary Muslim_Pop Hispanic_Pop Black_Pop Educated_Pop Manufacturing_Pop Terror_Concerns Race_Resentment Economic_Anxiety Establishment_Record TP_FC Leader Senate
/* Model 2 with 1-4 #NeverTrump dependent variable */

egen sConservatism=std(Conservatism)
egen sObama_Vote=std(Obama_Vote)
egen sHispanic_Pop=std(Hispanic_Pop)
egen sEstablishment_Record=std(Establishment_Record)
egen sTrump_Primary=std(Trump_Primary)
/* Standardizing the continuous covariates for Figure 3 */

replace Leader=((Leader*-1)+1)
replace sEstablishment_Record=(sEstablishment_Record*-1)
replace sConservatism=(sConservatism*-1)
replace sTrump_Primary=(sTrump_Primary*-1)
/* Putting each variable's direction on a positive scale for Figure 3 */

probit Never_Trump1 Mormon Female Leader sEstablishment_Record sConservatism Endorsed_Rival sObama_Vote sHispanic_Pop Hispanic Up_For_Reelection Trump_Primary Muslim_Pop Black_Pop Educated_Pop Manufacturing_Pop Terror_Concerns Race_Resentment Economic_Anxiety TP_FC Senate
margins, dydx(Mormon Female Leader sEstablishment_Record sConservatism Endorsed_Rival sObama_Vote sHispanic_Pop) atmeans post cont
fvset clear _all
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter) graphr(c(white)) scheme(s2mono) xtitle(Marginal Effect of Variable on #NeverTrump Probability (Probit)) ytitle(Significant Factors) 
/* 1/0 #NeverTrump dependent variable in Figure 3 */

oprobit Never_Trump2 Mormon Female Leader Endorsed_Rival sConservatism sEstablishment_Record sObama_Vote sHispanic_Pop sTrump_Primary Hispanic Up_For_Reelection Muslim_Pop Black_Pop Educated_Pop Manufacturing_Pop Terror_Concerns Race_Resentment Economic_Anxiety TP_FC Senate
margins, dydx(Mormon Female Leader sEstablishment_Record sConservatism Endorsed_Rival sObama_Vote sHispanic_Pop sTrump_Primary) atmeans post cont predict(outcome(3))
fvset clear _all
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter) graphr(c(white)) scheme(s2mono) xtitle(Marginal Effect of Variable on #NeverTrump Score (OLS)) ytitle(Significant Factors) 
/* 1-4 #NeverTrump dependent variable in Figure 3 */

clear
/* Load Dataset */
probit Never_Trump1 Conservatism Endorsed_Rival Female Hispanic Mormon Up_For_Reelection Obama_Vote Trump_Primary Muslim_Pop Hispanic_Pop Black_Pop Educated_Pop Manufacturing_Pop Terror_Concerns Race_Resentment Economic_Anxiety Establishment_Record TP_FC Leader Senate
margins, atmeans
margins, at(Obama_Vote=.578  Hispanic_Pop=37.05) atmeans
margins, at(Conservatism=.169 Endorsed_Rival=1) atmeans
margins, at(Establishment_Record=-.514 Leader=0) atmeans
margins, at(Female=1 Mormon=1) atmeans
/* Computing the #NeverTrump probability for hypothetical lawmakers */

clear

