
*** generate most serious prior dummies

gen murderp=(msprior==1 | msprior==2)
la var murderp "Murder, att. murder"
gen sex_off=0
replace sex_off=1 if msprior==3 | msprior==5 | mspriora==3 | mspriora==5
label var sex_off "Felony sex offense"
gen assault=0
replace assault=1 if msprior==7 | msprior==22 | mspriora==7 | mspriora==22
la var assault "Assault"
gen agg_ass=0
replace agg_ass=1 if msprior==7 | mspriora==7
la var agg_ass "Aggravated Assault"
gen ass_nonag=0
replace ass_nonag=1 if msprior==22 | mspriora==22
la var ass_nonag "Assault, non-aggravated"
gen robbery=0
replace robbery=1 if msprior==6 | msprior==8 | mspriora==6 | mspriora==8
la var robber "Robbery"
gen weapon=0 
replace weapon=1 if msprior==11 | mspriora==11 
la var weapon "Weapon or firearm offense"
gen drug_off=0
replace drug_off=1 if msprior==15 | mspriora==15
la var drug_off "Felony drug offense"
gen misdrug_off=0
replace misdrug_off=1 if msprior==22  | mspriora==22
la var misdrug_off "Felony drug offense"
gen burglary=0
replace burglary=1 if msprior==12 | mspriora==12 
la var burglary "Burglary"
gen auto_theft=0
replace auto_theft=1 if msprior==13 | mspriora==13
la var auto_theft "Auto theft"
gen petlarceny=0
replace petlarceny=1 if msprior==24 | mspriora==24 
la var petlarceny "Petty larceny, excl. auto"
gen gralarceny=0
replace gralarceny=1 if msprior==14 | mspriora==14 
la var gralarceny "Grand larceny, excl. auto"
gen larceny = (gralarceny==1 | petlarceny==1)
gen drugtot=(drug_off==1 | misdrug_off==1)




********************************************
**** new recidivism variables ***************
********************************************

*new arrest indicator (ignores violation of parole)
gen tarrest1=tarrest
forvalues x=35/46  {
replace tarrest1=0 if msoff1yr==`x'
}
replace tarrest1 = tar_vop if RELEASE_YR>=910


*new felony arrest indicator (
gen tarrfel1=tarrfel
replace tarrfel1= tarrfel_both if RELEASE_YR==1011 | RELEASE_YR==910


*new conviction indicator
gen tconvict1=tconvict
forvalues x=35/46  {
replace tconvict1=0 if msoff1yr==`x'
}
replace tconvict1 = tcn_vop if RELEASE_YR>=910


*new felony conviction indicator
gen tconvfel1=tconvfel
replace tconvfel1= tconvfel_both if RELEASE_YR==1011 | RELEASE_YR==910



*new commitment indicator
gen commita1=commita
forvalues x=35/46  {
replace commita1=0 if msoff1yr==`x'
}

*new tprison indicator
gen tprison1=tprison

* any lockup
gen anypris=0
replace anypris=1 if commita1==1 | tprison1==1

*label
la var tarrest1 "Arrest within 1yr"
la var tarrfel1 "Felony arrest withn 1yr"
la var tconvict1 "Convicted within 1yr"
la var tconvfel1 "Felony conviction within 1yr"
la var anypris "Adult or juv. prison 1yr"

********************************************
***** types of crimes  *****
********************************************

* make a violent felony indicator
gen violfel=0
forvalues x=1/11{
replace violfel=1 if msoff1yr==`x'
}

* make a property felony indicator
gen propfel=0
foreach x in 12 13 14 18{
replace propfel=1 if msoff1yr==`x'
}

* make a misdemeanor indicator
gen misdemeanor=0
forvalues x=22/34{
replace misdemeanor=1 if msoff1yr==`x'
}


********************************************
****  generate most serious recidivism dummies (6months)
gen r6sex_off=0
replace r6sex_off=1 if msoff6mo==3 | msoff6mo==5 | msadj6mo==3 | msadj6mo==5 
label var r6sex_off "Sex offense"
gen r6agg_ass=0
replace r6agg_ass=1 if msoff6mo==7 | msadj6mo==7
la var r6agg_ass "Aggravated Assault"
gen r6ass_nonag=0
replace r6ass_nonag=1 if msoff6mo==22 | msadj6mo==22
la var r6ass_nonag "Assault, non-aggravated"
gen r6robbery=0
replace r6robbery=1 if msoff6mo==6 | msoff6mo==8 | msadj6mo==6 | msadj6mo==8
la var r6robber "Robbery"
gen r6weapon=0 
replace r6weapon=1 if msoff6mo==11 | msadj6mo==11
la var r6weapon "Weapon or firearm offense"
gen r6drug_off=0
replace r6drug_off=1 if msoff6mo==15  | msadj6mo==15 
la var r6drug_off "Drug offense"
gen r6misdrug_off=0
replace r6misdrug_off=1  if msoff6mo==27 |  msadj6mo==27
la var r6misdrug_off "Drug offense"
gen r6burglary=0
replace r6burglary=1 if msoff6mo==12 | msadj6mo==12
la var r6burglary "Burglary"
gen r6auto_theft=0
replace r6auto_theft=1 if msoff6mo==13 | msadj6mo==13
la var r6auto_theft "Auto theft"
gen r6gralarceny=0
replace r6gralarceny=1 if msoff6mo==14  | msadj6mo==14 
la var r6gralarceny "Grand larceny, excl. auto"
gen r6petlarceny=0
replace r6petlarceny=1 if msoff6mo==24 | msadj6mo==24 
la var r6petlarceny "Grand larceny, excl. auto"
gen r6assault=(r6agg_ass==1 | r6ass_nonag==1)
gen r6drugtot=(r6drug_off==1 | r6misdrug_off==1)
gen r6larceny=(r6gralarceny==1 | r6petlarceny==1)

*** generate most serious recidivism dummies (1yr)
gen r1sex_off=0
replace r1sex_off=1 if msoff1yr==3 | msoff1yr==5 | msadj1yr==3 | msadj1yr==5 
label var r1sex_off "Sex offense"
gen r1agg_ass=0
replace r1agg_ass=1 if msoff1yr==7 | msadj1yr==7
la var r1agg_ass "Aggravated Assault"
gen r1ass_nonag=0
replace r1ass_nonag=1 if msoff1yr==22 | msadj1yr==22
la var r1ass_nonag "Assault, non-aggravated"
gen r1robbery=0
replace r1robbery=1 if msoff1yr==6 | msoff1yr==8 | msadj1yr==6 | msadj1yr==8
la var r1robber "Robbery"
gen r1weapon=0 
replace r1weapon=1 if msoff1yr==11 | msadj1yr==11
la var r1weapon "Weapon or firearm offense"
gen r1drug_off=0
replace r1drug_off=1 if msoff1yr==15  | msadj1yr==15 
la var r1drug_off "Drug offense"
gen r1misdrug_off=0
replace r1misdrug_off=1  if msoff1yr==27 |  msadj1yr==27
la var r1misdrug_off "Drug offense"
gen r1burglary=0
replace r1burglary=1 if msoff1yr==12 | msadj1yr==12
la var r1burglary "Burglary"
gen r1auto_theft=0
replace r1auto_theft=1 if msoff1yr==13 | msadj1yr==13
la var r1auto_theft "Auto theft"
gen r1gralarceny=0
replace r1gralarceny=1 if msoff1yr==14  | msadj1yr==14 
la var r1gralarceny "Grand larceny, excl. auto"
gen r1petlarceny=0
replace r1petlarceny=1 if msoff1yr==24 | msadj1yr==24 
la var r1petlarceny "Grand larceny, excl. auto"
gen r1assault=(r1agg_ass==1 | r1ass_nonag==1)
gen r1drugtot=(r1drug_off==1 | r1misdrug_off==1)
gen r1larceny=(r1gralarceny==1 | r1petlarceny==1)


foreach x in sex_off robbery agg_ass  weapon  burglary auto_theft gralarceny drug_off ass_nonag misdrug_off petlarceny{
gen r`x'=(r1`x'==1 | r6`x'==1)
}
gen rassault=(ragg_ass==1 | rass_nonag==1)
gen rdrugtot=(rdrug_off==1 | rmisdrug_off==1)
gen rlarceny=(rgralarceny==1 | rpetlarceny==1)

