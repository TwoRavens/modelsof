*Reshape the data so that each row reflects an explanation

drop r1 r2 r3 r4 r5 r6 r7 r8
drop f1 f2 f3 f4 f5 f6 f7 f8

gen fairness=0
replace fairness=1 if exp_fe1_p!=""
gen responsibility=1-fairness

*reshape

reshape long exp_, i(id) j(explanation, string)

*Isolate the pair in question

gen comp1=0
replace comp1=1 if explanation=="fe1_mo" | explanation=="fe1_po" | explanation=="re1_mo" | explanation=="re1_po"

gen comp2=0
replace comp2=1 if explanation=="fe2_mo" | explanation=="fe2_po" | explanation=="re2_mo" | explanation=="re2_po"

gen comp3=0
replace comp3=1 if explanation=="fe3_mo" | explanation=="fe3_po" | explanation=="re3_mo" | explanation=="re3_po"

gen comp4=0
replace comp4=1 if explanation=="fe4_mo" | explanation=="fe4_po" | explanation=="re4_mo" | explanation=="re4_po"

gen comp5=0
replace comp5=1 if explanation=="fe5_mo" | explanation=="fe5_po" | explanation=="re5_mo" | explanation=="re5_po"

gen comp6=0
replace comp6=1 if explanation=="fe6_mo" | explanation=="fe6_po" | explanation=="re6_mo" | explanation=="re6_po"

gen comp7=0
replace comp7=1 if explanation=="fe7_mo" | explanation=="fe7_po" | explanation=="re7_mo" | explanation=="re7_po"

gen comp8=0
replace comp8=1 if explanation=="fe8_mo" | explanation=="fe8_po" | explanation=="re8_mo" | explanation=="re8_po"

drop if comp1+comp2+comp3+comp4+comp5+comp6+comp7+comp8==0
drop if exp_==""

gen winner=""
gen loser=""

replace winner=f1y if fairness==1 & comp1==1
replace winner=f2y if fairness==1 & comp2==1
replace winner=f3y if fairness==1 & comp3==1
replace winner=f4y if fairness==1 & comp4==1
replace winner=f5y if fairness==1 & comp5==1
replace winner=f6y if fairness==1 & comp6==1
replace winner=f7y if fairness==1 & comp7==1
replace winner=f8y if fairness==1 & comp8==1

replace loser=f1n if fairness==1 & comp1==1
replace loser=f2n if fairness==1 & comp2==1
replace loser=f3n if fairness==1 & comp3==1
replace loser=f4n if fairness==1 & comp4==1
replace loser=f5n if fairness==1 & comp5==1
replace loser=f6n if fairness==1 & comp6==1
replace loser=f7n if fairness==1 & comp7==1
replace loser=f8n if fairness==1 & comp8==1

replace winner=r1y if fairness==0 & comp1==1
replace winner=r2y if fairness==0 & comp2==1
replace winner=r3y if fairness==0 & comp3==1
replace winner=r4y if fairness==0 & comp4==1
replace winner=r5y if fairness==0 & comp5==1
replace winner=r6y if fairness==0 & comp6==1
replace winner=r7y if fairness==0 & comp7==1
replace winner=r8y if fairness==0 & comp8==1

replace loser=r1n if fairness==0 & comp1==1
replace loser=r2n if fairness==0 & comp2==1
replace loser=r3n if fairness==0 & comp3==1
replace loser=r4n if fairness==0 & comp4==1
replace loser=r5n if fairness==0 & comp5==1
replace loser=r6n if fairness==0 & comp6==1
replace loser=r7n if fairness==0 & comp7==1
replace loser=r8n if fairness==0 & comp8==1

drop if winner==""
drop if loser==""

keep exp_ winner loser fairness id
