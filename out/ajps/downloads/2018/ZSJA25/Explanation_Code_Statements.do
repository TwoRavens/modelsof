
drop r1 r2 r3 r4 r5 r6 r7 r8
drop f1 f2 f3 f4 f5 f6 f7 f8

*Generate demographic dummies
gen democrat=cond(party=="Democrat",1,0)
gen republican=cond(party=="Republican",1,0)
gen independent=cond(party=="Independent" | party=="Other",1,0)
gen female=cond(gender=="Female",1,0)
gen college=cond(education=="College" | education=="Graduate School",1,0)
gen white=strpos(race, "White") > 0
replace white=0 if hispanic=="Yes"
gen black=strpos(race, "Black") > 0

gen fairness=0
replace fairness=1 if exp_fe1_p!=""
gen responsibility=1-fairness


*Generate survey weights -- fix this based on margins
gen equalweights=1

gen collegetot=cond(college==0,347,153)
gen partywt=cond(republican==1,"Republican",cond(democrat==1,"Democrat","Independent"))
gen partytot=cond(republican==1,167,cond(democrat==1,167,166))
gen femaletot=cond(female==1,250,250)
gen whitetot=cond(white==1,320,180)

survwgt rake equalweights, by(college partywt female white) totvar(collegetot partytot femaletot whitetot) gen(rakewt)
drop equalweights collegetot partywt partytot femaletot whitetot

*Rename the choice options
replace choice_1="control" if choice_1=="Victims cannot control their exposure to this risk"
replace choice_2="control" if choice_2=="Victims cannot control their exposure to this risk"
replace choice_3="control" if choice_3=="Victims cannot control their exposure to this risk"
replace choice_4="control" if choice_4=="Victims cannot control their exposure to this risk"
replace choice_5="control" if choice_5=="Victims cannot control their exposure to this risk"
replace choice_6="control" if choice_6=="Victims cannot control their exposure to this risk"
replace choice_7="control" if choice_7=="Victims cannot control their exposure to this risk"
replace choice_8="control" if choice_8=="Victims cannot control their exposure to this risk"
replace choice_9="control" if choice_9=="Victims cannot control their exposure to this risk"
replace choice_10="control" if choice_10=="Victims cannot control their exposure to this risk"
replace choice_1="inequity" if choice_1=="This risk is not equally distributed across society"
replace choice_2="inequity" if choice_2=="This risk is not equally distributed across society"
replace choice_3="inequity" if choice_3=="This risk is not equally distributed across society"
replace choice_4="inequity" if choice_4=="This risk is not equally distributed across society"
replace choice_5="inequity" if choice_5=="This risk is not equally distributed across society"
replace choice_6="inequity" if choice_6=="This risk is not equally distributed across society"
replace choice_7="inequity" if choice_7=="This risk is not equally distributed across society"
replace choice_8="inequity" if choice_8=="This risk is not equally distributed across society"
replace choice_9="inequity" if choice_9=="This risk is not equally distributed across society"
replace choice_10="inequity" if choice_10=="This risk is not equally distributed across society"
replace choice_1="scope" if choice_1=="This risk affects a large number of people"
replace choice_2="scope" if choice_2=="This risk affects a large number of people"
replace choice_3="scope" if choice_3=="This risk affects a large number of people"
replace choice_4="scope" if choice_4=="This risk affects a large number of people"
replace choice_5="scope" if choice_5=="This risk affects a large number of people"
replace choice_6="scope" if choice_6=="This risk affects a large number of people"
replace choice_7="scope" if choice_7=="This risk affects a large number of people"
replace choice_8="scope" if choice_8=="This risk affects a large number of people"
replace choice_9="scope" if choice_9=="This risk affects a large number of people"
replace choice_10="scope" if choice_10=="This risk affects a large number of people"
replace choice_1="foreign" if choice_1=="This risk is produced by foreign actors"
replace choice_2="foreign" if choice_2=="This risk is produced by foreign actors"
replace choice_3="foreign" if choice_3=="This risk is produced by foreign actors"
replace choice_4="foreign" if choice_4=="This risk is produced by foreign actors"
replace choice_5="foreign" if choice_5=="This risk is produced by foreign actors"
replace choice_6="foreign" if choice_6=="This risk is produced by foreign actors"
replace choice_7="foreign" if choice_7=="This risk is produced by foreign actors"
replace choice_8="foreign" if choice_8=="This risk is produced by foreign actors"
replace choice_9="foreign" if choice_9=="This risk is produced by foreign actors"
replace choice_10="foreign" if choice_10=="This risk is produced by foreign actors"
replace choice_1="malign" if choice_1=="This risk is deliberately inflicted on its victims"
replace choice_2="malign" if choice_2=="This risk is deliberately inflicted on its victims"
replace choice_3="malign" if choice_3=="This risk is deliberately inflicted on its victims"
replace choice_4="malign" if choice_4=="This risk is deliberately inflicted on its victims"
replace choice_5="malign" if choice_5=="This risk is deliberately inflicted on its victims"
replace choice_6="malign" if choice_6=="This risk is deliberately inflicted on its victims"
replace choice_7="malign" if choice_7=="This risk is deliberately inflicted on its victims"
replace choice_8="malign" if choice_8=="This risk is deliberately inflicted on its victims"
replace choice_9="malign" if choice_9=="This risk is deliberately inflicted on its victims"
replace choice_10="malign" if choice_10=="This risk is deliberately inflicted on its victims"
replace choice_1="suffering" if choice_1=="This risk causes extreme pain and suffering"
replace choice_2="suffering" if choice_2=="This risk causes extreme pain and suffering"
replace choice_3="suffering" if choice_3=="This risk causes extreme pain and suffering"
replace choice_4="suffering" if choice_4=="This risk causes extreme pain and suffering"
replace choice_5="suffering" if choice_5=="This risk causes extreme pain and suffering"
replace choice_6="suffering" if choice_6=="This risk causes extreme pain and suffering"
replace choice_7="suffering" if choice_7=="This risk causes extreme pain and suffering"
replace choice_8="suffering" if choice_8=="This risk causes extreme pain and suffering"
replace choice_9="suffering" if choice_9=="This risk causes extreme pain and suffering"
replace choice_10="suffering" if choice_10=="This risk causes extreme pain and suffering"
replace choice_1="irreversibility" if choice_1=="This risk causes damage that cannot be undone"
replace choice_2="irreversibility" if choice_2=="This risk causes damage that cannot be undone"
replace choice_3="irreversibility" if choice_3=="This risk causes damage that cannot be undone"
replace choice_4="irreversibility" if choice_4=="This risk causes damage that cannot be undone"
replace choice_5="irreversibility" if choice_5=="This risk causes damage that cannot be undone"
replace choice_6="irreversibility" if choice_6=="This risk causes damage that cannot be undone"
replace choice_7="irreversibility" if choice_7=="This risk causes damage that cannot be undone"
replace choice_8="irreversibility" if choice_8=="This risk causes damage that cannot be undone"
replace choice_9="irreversibility" if choice_9=="This risk causes damage that cannot be undone"
replace choice_10="irreversibility" if choice_10=="This risk causes damage that cannot be undone"
replace choice_1="publicgoods" if choice_1=="Citizens need government assistance to reduce this risk"
replace choice_2="publicgoods" if choice_2=="Citizens need government assistance to reduce this risk"
replace choice_3="publicgoods" if choice_3=="Citizens need government assistance to reduce this risk"
replace choice_4="publicgoods" if choice_4=="Citizens need government assistance to reduce this risk"
replace choice_5="publicgoods" if choice_5=="Citizens need government assistance to reduce this risk"
replace choice_6="publicgoods" if choice_6=="Citizens need government assistance to reduce this risk"
replace choice_7="publicgoods" if choice_7=="Citizens need government assistance to reduce this risk"
replace choice_8="publicgoods" if choice_8=="Citizens need government assistance to reduce this risk"
replace choice_9="publicgoods" if choice_9=="Citizens need government assistance to reduce this risk"
replace choice_10="publicgoods" if choice_10=="Citizens need government assistance to reduce this risk"
replace choice_1="abnormality" if choice_1=="This risk is not a normal part of society"
replace choice_2="abnormality" if choice_2=="This risk is not a normal part of society"
replace choice_3="abnormality" if choice_3=="This risk is not a normal part of society"
replace choice_4="abnormality" if choice_4=="This risk is not a normal part of society"
replace choice_5="abnormality" if choice_5=="This risk is not a normal part of society"
replace choice_6="abnormality" if choice_6=="This risk is not a normal part of society"
replace choice_7="abnormality" if choice_7=="This risk is not a normal part of society"
replace choice_8="abnormality" if choice_8=="This risk is not a normal part of society"
replace choice_9="abnormality" if choice_9=="This risk is not a normal part of society"
replace choice_10="abnormality" if choice_10=="This risk is not a normal part of society"
replace choice_1="rights" if choice_1=="Government can reduce this risk without infringing civil liberties"
replace choice_2="rights" if choice_2=="Government can reduce this risk without infringing civil liberties"
replace choice_3="rights" if choice_3=="Government can reduce this risk without infringing civil liberties"
replace choice_4="rights" if choice_4=="Government can reduce this risk without infringing civil liberties"
replace choice_5="rights" if choice_5=="Government can reduce this risk without infringing civil liberties"
replace choice_6="rights" if choice_6=="Government can reduce this risk without infringing civil liberties"
replace choice_7="rights" if choice_7=="Government can reduce this risk without infringing civil liberties"
replace choice_8="rights" if choice_8=="Government can reduce this risk without infringing civil liberties"
replace choice_9="rights" if choice_9=="Government can reduce this risk without infringing civil liberties"
replace choice_10="rights" if choice_10=="Government can reduce this risk without infringing civil liberties"

*reshape

reshape long exp_, i(id) j(explanation, string)
rename exp_ choice
drop if choice==""
drop if explanation=="fe1_mo" | explanation=="fe1_po"
drop if explanation=="fe2_mo" | explanation=="fe2_po"
drop if explanation=="fe3_mo" | explanation=="fe3_po"
drop if explanation=="fe4_mo" | explanation=="fe4_po"
drop if explanation=="fe5_mo" | explanation=="fe5_po"
drop if explanation=="fe6_mo" | explanation=="fe6_po"
drop if explanation=="fe7_mo" | explanation=="fe7_po"
drop if explanation=="fe8_mo" | explanation=="fe8_po"

*Isolate the pair in question

gen comp1=0
replace comp1=1 if explanation=="fe1_m" | explanation=="fe1_p" | explanation=="re1_m" | explanation=="re1_p"

gen comp2=0
replace comp2=1 if explanation=="fe2_m" | explanation=="fe2_p" | explanation=="re2_m" | explanation=="re2_p"

gen comp3=0
replace comp3=1 if explanation=="fe3_m" | explanation=="fe3_p" | explanation=="re3_m" | explanation=="re3_p"

gen comp4=0
replace comp4=1 if explanation=="fe4_m" | explanation=="fe4_p" | explanation=="re4_m" | explanation=="re4_p"

gen comp5=0
replace comp5=1 if explanation=="fe5_m" | explanation=="fe5_p" | explanation=="re5_m" | explanation=="re5_p"

gen comp6=0
replace comp6=1 if explanation=="fe6_m" | explanation=="fe6_p" | explanation=="re6_m" | explanation=="re6_p"

gen comp7=0
replace comp7=1 if explanation=="fe7_m" | explanation=="fe7_p" | explanation=="re7_m" | explanation=="re7_p"

gen comp8=0
replace comp8=1 if explanation=="fe8_m" | explanation=="fe8_p" | explanation=="re8_m" | explanation=="re8_p"

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

gen place=cond(comp1==1,1,cond(comp2==1,2,cond(comp3==1,3,cond(comp4==1,4,cond(comp5==1,5,cond(comp6==1,6,cond(comp7==1,7,cond(comp8==1,8,.))))))))
drop comp*
rename place comparison

drop if winner==""
drop if loser==""
drop f1y f1n f2y f2n f3y f3n f4y f4n f5y f5n f6y f6n f7y f7n f8y f8n
drop r1y r1n r2y r2n r3y r3n r4y r4n r5y r5n r6y r6n r7y r7n r8y r8n

*Create dummy for primary versus alternate explanation
gen primary=0
replace primary=1 if explanation=="re1_p" | explanation=="re2_p" | explanation=="re3_p" | explanation=="re4_p" | explanation=="re5_p" | explanation=="re6_p" | explanation=="re7_p" | explanation=="re8_p" | explanation=="fe1_p" | explanation=="fe2_p" | explanation=="fe3_p" | explanation=="fe4_p" | explanation=="fe5_p" | explanation=="fe6_p" | explanation=="fe7_p" | explanation=="fe8_p"
gen multiple=1-primary

*Now fill in the primary choices
gen primary_choice=""
replace primary_choice=choice_1 if choice=="Choice_1" & primary==1
replace primary_choice=choice_2 if choice=="Choice_2" & primary==1
replace primary_choice=choice_3 if choice=="Choice_3" & primary==1
replace primary_choice=choice_4 if choice=="Choice_4" & primary==1
replace primary_choice=choice_5 if choice=="Choice_5" & primary==1
replace primary_choice=choice_6 if choice=="Choice_6" & primary==1
replace primary_choice=choice_7 if choice=="Choice_7" & primary==1
replace primary_choice=choice_8 if choice=="Choice_8" & primary==1
replace primary_choice=choice_9 if choice=="Choice_9" & primary==1
replace primary_choice=choice_10 if choice=="Choice_10" & primary==1
replace primary_choice="other" if choice=="Other reasons" & primary==1

*Generate primary dummies

gen primary_control=cond(primary_choice=="control",1,0) if primary==1
gen primary_scope=cond(primary_choice=="scope",1,0) if primary==1
gen primary_foreign=cond(primary_choice=="foreign",1,0) if primary==1
gen primary_inequity=cond(primary_choice=="inequity",1,0) if primary==1
gen primary_irreversibility=cond(primary_choice=="irreversibility",1,0) if primary==1
gen primary_malign=cond(primary_choice=="malign",1,0) if primary==1
gen primary_abnormality=cond(primary_choice=="abnormality",1,0) if primary==1
gen primary_publicgoods=cond(primary_choice=="publicgoods",1,0) if primary==1
gen primary_rights=cond(primary_choice=="rights",1,0) if primary==1
gen primary_suffering=cond(primary_choice=="suffering",1,0) if primary==1
gen primary_other=cond(primary_choice=="other",1,0) if primary==1

*Gen multiple dummies. 

gen a1=strpos(choice, "Choice_1") > 0 if multiple==1 
gen a1_1=choice_1 if a1==1
drop a1

gen a2=strpos(choice, "Choice_2") > 0 if multiple==1 
gen a2_1=choice_1 if a2==1
drop a2

gen a3=strpos(choice, "Choice_3") > 0 if multiple==1 
gen a3_1=choice_3 if a3==1
drop a3

gen a4=strpos(choice, "Choice_4") > 0 if multiple==1 
gen a4_1=choice_4 if a4==1
drop a4

gen a5=strpos(choice, "Choice_5") > 0 if multiple==1 
gen a5_1=choice_5 if a5==1
drop a5

gen a6=strpos(choice, "Choice_6") > 0 if multiple==1 
gen a6_1=choice_6 if a6==1
drop a6

gen a7=strpos(choice, "Choice_7") > 0 if multiple==1 
gen a7_1=choice_7 if a7==1
drop a7

gen a8=strpos(choice, "Choice_8") > 0 if multiple==1 
gen a8_1=choice_8 if a8==1
drop a8

gen a9=strpos(choice, "Choice_9") > 0 if multiple==1 
gen a9_1=choice_9 if a9==1
drop a9

gen a10=strpos(choice, "Choice_10") > 0 if multiple==1 
gen a10_1=choice_1 if a10==1
drop a10

gen aother=strpos(choice, "Other reasons") > 0 if multiple==1 
gen aother_1="other" if aother==1
drop aother

gen multiple_control=cond(a1_1=="control" | a2_1=="control" | a3_1=="control" | a4_1=="control" | a5_1=="control" | a6_1=="control" | a7_1=="control" | a8_1=="control" | a9_1=="control" | a10_1=="control",1,0)
gen multiple_scope=cond(a1_1=="scope" | a2_1=="scope" | a3_1=="scope" | a4_1=="scope" | a5_1=="scope" | a6_1=="scope" | a7_1=="scope" | a8_1=="scope" | a9_1=="scope" | a10_1=="scope",1,0)
gen multiple_foreign=cond(a1_1=="foreign" | a2_1=="foreign" | a4_1=="foreign" | a4_1=="foreign" | a5_1=="foreign" | a6_1=="foreign" | a7_1=="foreign" | a8_1=="foreign" | a9_1=="foreign" | a10_1=="foreign",1,0)
gen multiple_inequity=cond(a1_1=="inequity" | a2_1=="inequity" | a3_1=="inequity" | a4_1=="inequity" | a5_1=="inequity" | a6_1=="inequity" | a7_1=="inequity" | a8_1=="inequity" | a9_1=="inequity" | a10_1=="inequity",1,0)
gen multiple_irreversibility=cond(a1_1=="irreversibility" | a2_1=="irreversibility" | a3_1=="irreversibility" | a4_1=="irreversibility" | a5_1=="irreversibility" | a6_1=="irreversibility" | a7_1=="irreversibility" | a8_1=="irreversibility" | a9_1=="irreversibility" | a10_1=="irreversibility",1,0)
gen multiple_malign=cond(a1_1=="malign" | a2_1=="malign" | a3_1=="malign" | a4_1=="malign" | a5_1=="malign" | a6_1=="malign" | a7_1=="malign" | a8_1=="malign" | a9_1=="malign" | a10_1=="malign",1,0)
gen multiple_abnormality=cond(a1_1=="abnormality" | a2_1=="abnormality" | a3_1=="abnormality" | a4_1=="abnormality" | a5_1=="abnormality" | a6_1=="abnormality" | a7_1=="abnormality" | a8_1=="abnormality" | a9_1=="abnormality" | a10_1=="abnormality",1,0)
gen multiple_publicgoods=cond(a1_1=="publicgoods" | a2_1=="publicgoods" | a3_1=="publicgoods" | a4_1=="publicgoods" | a5_1=="publicgoods" | a6_1=="publicgoods" | a7_1=="publicgoods" | a8_1=="publicgoods" | a9_1=="publicgoods" | a10_1=="publicgoods",1,0)
gen multiple_rights=cond(a1_1=="rights" | a2_1=="rights" | a3_1=="rights" | a4_1=="rights" | a5_1=="rights" | a6_1=="rights" | a7_1=="rights" | a8_1=="rights" | a9_1=="rights" | a10_1=="rights",1,0)
gen multiple_suffering=cond(a1_1=="suffering" | a2_1=="suffering" | a3_1=="suffering" | a4_1=="suffering" | a5_1=="suffering" | a6_1=="suffering" | a7_1=="suffering" | a8_1=="suffering" | a9_1=="suffering" | a10_1=="suffering",1,0)
gen multiple_other=cond(aother_1=="other",1,0)

drop a1_1 a2 a3 a4 a5 a6 a7 a8 a9 a10 aother

egen expid=concat(comparison rid)
sort expid

egen controla=sum(multiple_control), by(expid)
egen scopea=sum(multiple_scope), by(expid)
egen foreigna=sum(multiple_foreign), by(expid)
egen inequitya=sum(multiple_inequity), by(expid)
egen irreversibilitya=sum(multiple_irreversibility), by(expid)
egen maligna=sum(multiple_malign), by(expid)
egen abnormalitya=sum(multiple_abnormality), by(expid)
egen publicgoodsa=sum(multiple_publicgoods), by(expid)
egen rightsa=sum(multiple_rights), by(expid)
egen sufferinga=sum(multiple_suffering), by(expid)
egen othera=sum(multiple_other), by(expid)

replace multiple_control=1 if primary==1 & controla==1
replace multiple_scope=1 if primary==1 & scopea==1
replace multiple_foreign=1 if primary==1 & foreigna==1
replace multiple_inequity=1 if primary==1 & inequitya==1
replace multiple_irreversibility=1 if primary==1 & irreversibilitya==1
replace multiple_malign=1 if primary==1 & maligna==1
replace multiple_abnormality=1 if primary==1 & abnormalitya==1
replace multiple_publicgoods=1 if primary==1 & publicgoodsa==1
replace multiple_rights=1 if primary==1 & rightsa==1
replace multiple_suffering=1 if primary==1 & sufferinga==1
replace multiple_other=1 if primary==1 & othera==1

replace multiple_control=1 if primary_control==1
replace multiple_scope=1 if primary_scope==1
replace multiple_foreign=1 if primary_foreign==1
replace multiple_inequity=1 if primary_inequity==1
replace multiple_irreversibility=1 if primary_irreversibility==1
replace multiple_malign=1 if primary_malign==1
replace multiple_abnormality=1 if primary_abnormality==1
replace multiple_publicgoods=1 if primary_publicgoods==1
replace multiple_rights=1 if primary_rights==1
replace multiple_suffering=1 if primary_suffering==1
replace multiple_other=1 if primary_other==1


drop choice_* choice
drop primary_choice
drop controla scopea foreigna inequitya irreversibilitya maligna abnormalitya publicgoodsa rightsa sufferinga othera
drop expid explanation

sort rid comparison
drop if primary==0
