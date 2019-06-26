
use "~/Replication_Dataset.dta", clear

* Table 1: Summary Statistics (Non-Kurds vs Kurds)

set more off

bys dummy_kurd: sum female age married akp ohal2 dummy_kurd urban ramadan leveleducation hhincome

bys dummy_kurd: sum smartphone car computer washingmachine dishwasher

bys dummy_kurd: sum coverhair alcohol pray

bys dummy_kurd: sum seerefpubtrans seerefstreet businessref socialref marketref

*** Tables C.4 and C.5: Randomization Checks 

set more off

logit educated expenditure balance arms positive if dummy_kurdish==0

logit educated expenditure balance arms positive if dummy_kurdish==1

logit urban expenditure balance arms positive if dummy_kurdish==0

logit urban expenditure balance arms positive if dummy_kurdish==1

logit ohal2 expenditure balance arms positive if dummy_kurdish==0

logit ohal2 expenditure balance arms positive if dummy_kurdish==1

reg agegroup expenditure balance arms positive if dummy_kurdish==0

reg agegroup expenditure balance arms positive if dummy_kurdish==1

reg alcohol expenditure balance arms positive if dummy_kurdish==0

reg alcohol expenditure balance arms positive if dummy_kurdish==1

reg smartphone expenditure balance arms positive if dummy_kurdish==0

reg smartphone expenditure balance arms positive if dummy_kurdish==1

reg refugee_exposure expenditure balance arms positive if dummy_kurdish==0

reg refugee_exposure expenditure balance arms positive if dummy_kurdish==1


** table D.6: Correlates of Refugee Exposure

set more off

reg refugee_exposure camp_in_district

reg refugee_exposure camp_in_district akp ohal2 dummy_kurd agegroup i.female  religious urban ramadan educated wealth

reg refugee_exposure camp_in_district akp ohal2 dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode


** Regressions

** Tables E.7 and E.8: Treatment Effects on Main Dependent Variables

set more off

reg dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode  


** Tables F.9 and F.10: Treatment Effects on Main Dependent Variables with an Alternative Measure of Exposure to Violence

set more off

reg dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 

reg dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 

reg dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 

reg dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 

reg dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 

reg dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 

reg dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp sum_clashes refugee_exposure  dummy_kurd camp_in_province distance_km agegroup i.female  religious urban ramadan educated wealth 


*** Tables F.11 and F.12: Treatment Effects on Main Dependent Variables with no controls except for Kurdish dummy

set more off

reg dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 

reg dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 

reg dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 

reg dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 

reg dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 

reg dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 

reg dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  dummy_kurd 


** Tables F.13 and F.14: Results in Camp Provinces Only

set more off

reg dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1

reg dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1

reg dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1

reg dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1

reg dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1

reg dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1

reg dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive akp ohal2 refugee_exposure  dummy_kurd  female  religious urban ramadan educated wealth i.provincecode if camp_in_province==1


*** Table F.15: Are the results driven by favorable answers provided by Kurdish respondents?

set more off

reg dv_turkey akp ohal2 refugee_exposure dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_turkey akp ohal2 refugee_exposure dummy_kurd kurd_X_ohal2 agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_turkey expenditure balance arms positive   akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_turkey expenditure balance arms positive   akp ohal2 refugee_exposure   dummy_kurd kurd_X_ohal2 agegroup i.female  religious urban ramadan educated wealth i.provincecode


** Tables F.16 and F.17: Treatment Effects on Main Dependent Variables - Heterogenous Treatment Effects with Exposure to Refugees

set more off

reg dv_arabref expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_alawiteref expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_kurdishref expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_sunniref expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode

reg dv_ecothreat expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_lesssafe expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode 

reg dv_peaceprocess expenditure balance arms positive hiexp_X_exp hiexp_X_bal hiexp_X_arms hiexp_X_pos dummy_kurd akp ohal2 high_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode


******* Tables F.18 and F.19: Weighted Treatment Effects on Main Dependent Variables 

set more off

reg dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 
 
reg dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 

reg dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 

reg dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 

reg dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 

reg dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 

reg dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode [iweight=weight] 


**** Tables F.20 and F.21: Treatment Effects on Main Dependent Variables (Ordered Probit)

set more off

oprobit dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

oprobit dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

oprobit dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

oprobit dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

oprobit dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

oprobit dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode

oprobit dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode


**** Tables F.22 and F.23: Non-Kurdish Respondents Only

set more off

reg dv_arabref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0

reg dv_alawiteref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0

reg dv_kurdishref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0

reg dv_sunniref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0

reg dv_ecothreat expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0

reg dv_lesssafe expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0

reg dv_peaceprocess expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==0


**** Tables F.24 and F.25: Kurdish Respondents Only

set more off

reg dv_arabref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1

reg dv_alawiteref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1

reg dv_kurdishref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1

reg dv_sunniref expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1

reg dv_ecothreat expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1

reg dv_lesssafe expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1

reg dv_peaceprocess expenditure balance arms positive akp ohal2 refugee_exposure agegroup i.female  religious urban ramadan educated wealth i.provincecode if dummy_kurd==1


**** Regressions with Bootstrapped Standard Errors for Coefficient Plots in Figures 3 and 4 

****Arab Refugees*********

set more off

capture program drop interaction
program define interaction, rclass
 reg dv_arabref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction


*******Alawite Refugees*******

set more off

capture program drop interaction
program define interaction, rclass
 reg dv_alawiteref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction

*******Kurdish Refugees*******


set more off

capture program drop interaction
program define interaction, rclass
 reg dv_kurdishref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction


*******Sunni Refugees*******

set more off

capture program drop interaction
program define interaction, rclass
 reg dv_sunniref expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction

*******Less Safe*******

set more off

capture program drop interaction
program define interaction, rclass
 reg dv_lesssafe expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction


*******Economic Threat*******


set more off

capture program drop interaction
program define interaction, rclass
 reg dv_ecothreat expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction

******* Peace Process *******

set more off

capture program drop interaction
program define interaction, rclass
 reg dv_peaceprocess expenditure balance arms positive kurd_X_expenditure kurd_X_balance kurd_X_arms kurd_X_positive  akp ohal2 refugee_exposure   dummy_kurd agegroup i.female  religious urban ramadan educated wealth i.provincecode
  matrix coeff= e(b)
  return scalar expend=coeff[1,1]
  return scalar balance=coeff[1,2]
  return scalar arms=coeff[1,3]
  return scalar positive=coeff[1,4]
  return scalar kurd_expend=coeff[1,1]+coeff[1,5]
  return scalar kurd_balance=coeff[1,2]+coeff[1,6]
    return scalar kurd_arms=coeff[1,3]+coeff[1,7]
    return scalar kurd_positive=coeff[1,4]+coeff[1,8]
    return scalar akp= coeff[1,9]
      return scalar ohal2= coeff[1,10]
      return scalar refugee_exposure=coeff[1,11]
         return scalar dummy_kurd= coeff[1,12]
end


*Bootstrap
bootstrap expend=r(expend) balance=r(balance) arms=r(arms) positive=r(positive) kurd_expend=r(kurd_expend) kurd_balance=r(kurd_balance) kurd_arms=r(kurd_arms) kurd_positive=r(kurd_positive) akp=r(akp) ohal2=r(ohal2) refugee_exposure=r(refugee_exposure) dummy_kurd=r(dummy_kurd), nodots reps(5000)  strata(strata): interaction
