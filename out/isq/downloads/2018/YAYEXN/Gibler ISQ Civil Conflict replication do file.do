**these models replicate table 2 of Gibler, "Combining Behavioral and Structural Predictors of Violent Civil Conflict: Getting Scholars and Policymakers to Talk to Each Other", International Studies Quarterly

logit UCDPintra exprgdpols logtpop newlmtnest ncontig oil udsmean udsmean2 udsinstab ethnic religion peaceyr* if month<2&year>1945

eststo modelstructure1

logit UCDPintra exprgdpols logtpop newlmtnest ncontig oil udsmean udsmean2 udsinstab ethnic religion peaceyr* if month<2&year>1999

eststo modelstructure2 

logit yearlyICG exprgdpols logtpop newlmtnest ncontig oil udsmean udsmean2 udsinstab ethnic religion yearsdur* if year>2002&month<2

eststo modelstructure3

***the following models replicate Table 4, of Gibler, Combining Behavioral and Structural Predictors of Violent Civil Conflict: Getting Scholars and Policymakers to Talk to Each Other, International Studies Quarterly
logit ucdpgovintraconflict lag1UCDP lag1protest lag1riot lag1arrest lag1repress lag1elect lag1coup lag1terror lag1rebel lag1ethnic lag1sanction lag1nonUNmediat  lag1UNmediation lag1peacekeep if ICG==1

eststo model1 

heckprob ucdpgovintraconflict lag1UCDP  lag1protest lag1riot lag1arrest lag1repress lag1elect lag1coup lag1terror lag1rebel lag1ethnic lag1sanction lag1nonUNmediat  lag1UNmediation lag1peacekeep if year>1945, sel (ICG1 =exprgdpols logtpop newlmtnest ncontig oil udsmean udsmean2 udsinstab ethnic religion peaceyr*) 

eststo model2



logit ucdpgovintraconflict lag1UCDP  lag2protest lag2riot lag2arrest lag2repress lag2elect lag2coup lag2terror lag2rebel lag2ethnic lag2sanction lag2nonUNmediat  lag2UNmediation lag2peacekeep if ICG==1

eststo model3

heckprob ucdpgovintraconflict lag1UCDP  lag2protest lag2riot lag2arrest lag2repress lag2elect lag2coup lag2terror lag2rebel lag2ethnic lag2sanction lag2nonUNmediat  lag2UNmediation lag2peacekeep if year>1945, sel (ICG1 =exprgdpols logtpop newlmtnest ncontig oil udsmean udsmean2 udsinstab ethnic religion peaceyr*)  

eststo model4



logit ucdpgovintraconflict lag1UCDP  lag3protest lag3riot lag3arrest lag3repress lag3elect lag3coup lag3terror lag3rebel lag3ethnic lag3sanction lag3nonUNmediat  lag3UNmediation lag3peacekeep if ICG==1

eststo model5

heckprob ucdpgovintraconflict lag1UCDP  lag3protest lag3riot lag3arrest lag3repress lag3elect lag3coup lag3terror lag3rebel lag3ethnic lag3sanction lag3nonUNmediat  lag3UNmediation lag3peacekeep if year>1945, sel (ICG1 =exprgdpols logtpop newlmtnest ncontig oil udsmean udsmean2 udsinstab ethnic religion  peaceyr*) 

eststo model6

