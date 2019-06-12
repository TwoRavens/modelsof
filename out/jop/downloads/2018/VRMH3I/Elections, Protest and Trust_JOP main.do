
*three periods
gen period = 1 if DATA>24 | DATA<5
recode period .=0
gen dec25 = 1 if MONTH==12 & DATA==25
recode dec25 .= 0
gen period1 = period - dec25

gen period2 = 1 if DATA >4 &DATA <11
recode period2 .=0

gen electday = 1 if MONTH ==12 & DATA==4
recode electday .=0

gen protestday = 1 if MONTH==12 & DATA==10
recode protestday .=0

gen period1min = period1 - electday
gen period2min = period2 - protestday

gen period3 = 1 if DATA >10 & DATA <26 & MONTH==12
recode period3 .=0 

label variable period3 "Post-Protest" 
label variable period2min "Post-Election"
label variable protestday "Protest day"
label variable electday "Election day"


*trust

gen trustarmy = q9a
recode trustarmy 99 =. 1=5 2=4 4=2 5=1

gen trustpolice = q9b
recode trustpolice 99=. 1=5 2=4 4=2 5=1

gen trustfsb = q9c
recode trustfsb 99=. 1=5 2=4 4=2 5=1

gen trustcourt = q9d
recode trustcourt 99=. 1=5 2=4 4=2 5=1

gen trustmungov = q9e
recode trustmungov 99=. 1=5 2=4 4=2 5=1

gen trustfedgov = q9f
recode trustfedgov 99=. 1=5 2=4 4=2 5=1

gen trustduma = q9g
recode trustduma 99=. 1=5 2=4 4=2 5=1

gen trustprocuracy = q9h
recode trustprocuracy  99=. 1=5 2=4 4=2 5=1

gen trustun = q9j
recode trustun 99=. 1=5 2=4 4=2 5=1

gen trustgovind = (trustarmy + trustpolice +trustfsb + trustcourt +trustmungov +trustfedgov +trustduma +trustprocuracy)/8

label variable trustgovind "Gov't Index"
label variable trustarmy "Army"
label variable trustpolice "Police"
label variable trustfsb "FSB"
label variable trustcourt "Court"
label variable trustmungov "City Gov't"
label variable trustfedgov "Fed Gov't"
label variable trustduma "Duma"
label variable trustprocuracy "Procuracy"
label variable trustun "UN"


*potential confounders

gen age = q1
gen male = q2
recode male 2=0
gen wealth = q3
recode wealth 99=.
gen education = q5
recode education 99=.
gen permres = q59
recode permres 99=. 2=0 3=0
gen nationality = q67
recode nationality 2=0 3=0 4=0 5=0 6=0 7=0 8=0 9=0 10=0 11=0 99=0
gen unemp = 0
replace unemp = 1 if q6 ==11 | q6 ==12 | q6 ==13
gen statesector = 0
replace statesector = 1 if q7 > 9 & q7<13

tab okrug, gen (okrugdv)


*partisanship

gen urplan = 0
replace urplan =1 if q62 ==6
gen urturn = 0
replace urturn =1 if q64 ==6
gen ur = urplan + urturn
label variable ur "United Russia"

gen complan =0
replace complan =1 if q62 ==3
gen compturn =0
replace compturn =1 if q64 ==3
gen comp = complan +compturn

gen ldprplan = 0
replace ldprplan =1 if q62 ==4
gen ldprturn = 0
replace ldprturn =1 if q64 ==4
gen ldpr = ldprplan +ldprturn

gen yabplan = 0
replace yabplan  =1 if q62 ==1
gen yabturn = 0
replace yabturn  =1 if q64 ==1
gen yab = yabplan +yabturn

gen patplan =0
replace patplan =1 if q62 ==2
gen patturn =0
replace patturn =1 if q64 ==2
gen pat = patplan +patturn

gen srplan =0
replace srplan =1 if q62 ==5
gen srturn =0
replace srturn =1 if q64 ==5
gen sr = srplan +srturn

gen rcplan =0
replace rcplan =1 if q62 ==7
gen rcturn =0
replace rcturn =1 if q64 ==7
gen rc = rcplan +rcturn

gen dkplan = 0
replace dkplan = 1 if q62==99
gen dkturn = 0
replace dkturn = 1 if q64==99
gen dk = dkplan + dkturn

gen nopart = 0
replace nopart =1 if q61==2 | q63==2  | q62 ==0


*non-response variables

gen trustgovindnr = trustgovind 
recode trustgovindnr min/.85 =1 .86/max =0
recode trustgovindnr .=1 

gen trustarmynr = q9a
recode trustarmynr 99 =1 1=0 2=0 3=0 4=0 5=0

gen trustpolicenr = q9b
recode trustpolicenr 99 =1 1=0 2=0 3=0 4=0 5=0  

gen trustfsbnr = q9c
recode trustfsbnr  99 =1 1=0 2=0 3=0 4=0 5=0  

gen trustcourtnr = q9d
recode trustcourtnr 99 =1 1=0 2=0 3=0 4=0 5=0

gen trustmungovnr = q9e
recode trustmungovnr 99 =1 1=0 2=0 3=0 4=0 5=0

gen trustfedgovnr = q9f
recode trustfedgovnr  99 =1 1=0 2=0 3=0 4=0 5=0

gen trustdumanr = q9g
recode trustdumanr 99 =1 1=0 2=0 3=0 4=0 5=0

gen trustprocuracynr = q9h
recode trustprocuracynr  99 =1 1=0 2=0 3=0 4=0 5=0

gen trustunnr = q9j
recode trustunnr 99 =1 1=0 2=0 3=0 4=0 5=0


*Table 1

*Period1 vs. period2
ttest trustarmy if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustpolice if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfsb if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustcourt if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustmungov if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfedgov if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustduma if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustprocuracy if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustun if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustgovind if period3~=1 & electday~=1 & protestday~=1, by (period1min)

*Period1 vs. period3 
ttest trustarmy if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustpolice if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfsb if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustcourt if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustmungov if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfedgov if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustduma if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustprocuracy if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustun if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustgovind if period2min~=1 & electday~=1 & protestday~=1, by (period1min)

*Period2 vs. period3 
ttest trustarmy if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustpolice if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustfsb if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustcourt if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustmungov if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustfedgov if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustduma if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustprocuracy if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustun if period1min~=1 & electday~=1 & protestday~=1, by (period2min)
ttest trustgovind if period1min~=1 & electday~=1 & protestday~=1, by (period2min)


*Table 2

reg trustgovind period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 
reg trustarmy period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2)alpha(0.001, 0.05) symbol(*,*) label
reg trustpolice period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustfsb period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustcourt period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustmungov period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustfedgov period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustduma period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustprocuracy period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustun period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label excel


*Figure 1

gen period123 =1 if period1min==1
recode period123 .=2 if period2min==1
recode period123 .=3 if period3==1

gen party =1 if ur==1
recode party .=0
recode party 0=2 if comp==1
recode party 0=3 if ldpr==1

gen opposition=yab+pat+sr+rc
recode party 0=4 if opposition==1 
recode party 0=5 if nopart==1
recode party 0=6 if dk==1

gen trustgovind1 =1 if period1min==1
recode trustgovind1 .=0

gen trustgovind2 =1 if period2min==1
recode trustgovind2 .=0

gen trustgovind3 =1 if period3==1
recode trustgovind3 .=0

graph bar (mean) trustgovind, over(period123) over(party, relabel(1 "UR" 2 "CPRF" 3 "LDPR" 4 "Opposition" 5 "Non voters" 6 "Undecided")) ytitle(Trust in Government Index)


*Table 3

gen urafterprotest = ur*period3
label variable urafterprotest "United Russia x Post-Protest"

gen urpostelection = ur*period2min
label variable urpostelection "United Russia x Post-Election"

gen apolitical = nopart + dk
label variable apolitical "Apolitical"

gen apolafterprotest = apolitical*period3 
label variable apolafterprotest "Apolitical x Post-Protest"

gen apolpostelection = apolitical*period2min
label variable apolpostelection "Apolitical x Post-Election"

reg trustgovind period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 
reg trustarmy period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustpolice period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustfsb period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustcourt period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustmungov period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustfedgov period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustduma period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustprocuracy period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustun period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
outreg2 using tab3, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label excel


*Figure 2

reg trustgovind period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
margins, dydx (period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) post
marginsplot, horizontal xline (0) yscale  (reverse) recast (scatter)


*APPENDIX
*Appendix I Distribution of respondents across districts by periods

*Period1 vs. period2 test without electday and protestday
ttest okrugdv1 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv2 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv3 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv4 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv5 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv6 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv7 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv8 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv9 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 
ttest okrugdv10 if period3~=1 & electday~=1 & protestday~=1, by (period1min) 

*Period1 vs. period3 test without electday and protestday 
ttest okrugdv1 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv2 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv3 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv4 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv5 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv6 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv7 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv8 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv9 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest okrugdv10 if period2min~=1 & electday~=1 & protestday~=1, by (period1min)

*Period2 vs. period3 test without electday and protestday 
ttest okrugdv1 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv2 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv3 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv4 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv5 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv6 if period1min~=1 & electday~=1 & protestday~=1, by (period3) 
ttest okrugdv7 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv8 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv9 if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest okrugdv10 if period1min~=1 & electday~=1 & protestday~=1, by (period3)


*Appendix II Balance tests

*Period1 vs. period2 test without electday and protestday
ttest age if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest male if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest education if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest wealth if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest permres if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest nationality if period3~=1 & electday~=1 & protestday~=1, by (period1min) //Russian Ethnicity
ttest unemp if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest statesector if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest ur if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest comp if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest opposition if period3~=1 & electday~=1 & protestday~=1, by (period1min)

*Period1 vs. period3 test without electday and protestday 
ttest age if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest male if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest education if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest wealth if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest permres if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest nationality if period2min~=1 & electday~=1 & protestday~=1, by (period1min) //Russian Ethnicity
ttest unemp if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest statesector if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest ur if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest comp if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest opposition if period2min~=1 & electday~=1 & protestday~=1, by (period1min)

*Period2 vs. period3 test without electday and protestday 
ttest age if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest male if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest education if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest wealth if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest permres if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest nationality if period1min~=1 & electday~=1 & protestday~=1, by (period3) //Russian Ethnicity
ttest unemp if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest statesector if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest ur if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest comp if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest opposition if period1min~=1 & electday~=1 & protestday~=1, by (period3)


*Appendix III Differences in Partisanship Across Periods

graph bar (mean) ur comp ldpr opposition dk, over(period123) /// rotate categories in bar region properties


*Appendix IV Non-responces

*Period1 vs. period2
ttest trustgovindnr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustarmynr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustpolicenr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfsbnr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustcourtnr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustmungovnr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfedgovnr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustdumanr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustprocuracynr if period3~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustunnr if period3~=1 & electday~=1 & protestday~=1, by (period1min)

*Period1 vs. period3
ttest trustgovindnr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustarmynr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustpolicenr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfsbnr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustcourtnr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustmungovnr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustfedgovnr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustdumanr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustprocuracynr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)
ttest trustunnr if period2min~=1 & electday~=1 & protestday~=1, by (period1min)

*Period2 vs. period3
ttest trustgovindnr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustarmynr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustpolicenr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustfsbnr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustcourtnr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustmungovnr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustfedgovnr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustdumanr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustprocuracynr if period1min~=1 & electday~=1 & protestday~=1, by (period3)
ttest trustunnr if period1min~=1 & electday~=1 & protestday~=1, by (period3)


*Appendix V Daily Responses

gen date = DATA
sum date
tabulate date, gen (datedv) 
gen trend = date
recode trend 25 = 1 26=2 27 =3 28=4 29 =5 30 =6 1= 7 2=8 3=9 4=10 5=11 6=12 7=13 8=14 9=15 10=16 11=17 12 =18 13= 19 14=20 15=21 16=22 17=23 18=24 19=25 20=26 21=27 22=28 23=29 24=30 
 
gen trenddv1 = 1 if trend==1
recode trenddv1 .=0
replace trenddv1 = 0 if MONTH ==12 & DATA==25

gen trenddv2 = 1 if trend ==2
recode trenddv2 .=0

gen trenddv3 = 1 if trend ==3
recode trenddv3 .=0

gen trenddv4 = 1 if trend ==4
recode trenddv4 .=0

gen trenddv5 = 1 if trend ==5
recode trenddv5 .=0

gen trenddv6 = 1 if trend ==6
recode trenddv6 .=0

gen trenddv7 = 1 if trend ==7
recode trenddv7 .=0

gen trenddv8 = 1 if trend ==8
recode trenddv8 .=0

gen trenddv9 = 1 if trend ==9
recode trenddv9 .=0

gen trenddv10 = 1 if trend ==10
recode trenddv10 .=0

gen trenddv11 = 1 if trend ==11
recode trenddv11 .=0

gen trenddv12 = 1 if trend ==12
recode trenddv12 .=0

gen trenddv13 = 1 if trend ==13
recode trenddv13 .=0

gen trenddv14 = 1 if trend ==14
recode trenddv14 .=0

gen trenddv15 = 1 if trend ==15
recode trenddv15 .=0

gen trenddv16 = 1 if trend ==16
recode trenddv16 .=0

gen trenddv17 = 1 if trend ==17
recode trenddv17 .=0

gen trenddv18 = 1 if trend ==18
recode trenddv18 .=0

gen trenddv19 = 1 if trend ==19
recode trenddv19 .=0

gen trenddv20 = 1 if trend ==20
recode trenddv20 .=0

gen trenddv21 = 1 if trend ==21
recode trenddv21 .=0

gen trenddv22 = 1 if trend ==22
recode trenddv22 .=0

gen trenddv23 = 1 if trend ==23
recode trenddv23 .=0

gen trenddv24 = 1 if trend ==24
recode trenddv24 .=0

gen trenddv25 = 1 if trend ==25
recode trenddv25 .=0

gen trenddv26 = 1 if trend ==26
recode trenddv26 .=0

gen trenddv27 = 1 if trend ==27
recode trenddv27 .=0

gen trenddv28 = 1 if trend ==28
recode trenddv28 .=0

gen trenddv29 = 1 if trend ==29
recode trenddv29 .=0

gen trenddv30 = 1 if trend==30
recode trenddv30 .=0
replace trenddv30 = 0 if MONTH ==11 & DATA==25
 
gen nov25 = trenddv1
gen nov26 = trenddv2
gen nov27 = trenddv3
gen nov28 = trenddv4
gen nov29 = trenddv5
gen nov30 = trenddv6
gen dec1 = trenddv7
gen dec2 = trenddv8
gen dec3 = trenddv9
gen dec4 = trenddv10
gen dec5 = trenddv11
gen dec6 = trenddv12
gen dec7 = trenddv13
gen dec8 = trenddv14
gen dec9 = trenddv15
gen dec10 = trenddv16
gen dec11 = trenddv17
gen dec12 = trenddv18
gen dec13 = trenddv19
gen dec14 = trenddv20
gen dec15 = trenddv21
gen dec16 = trenddv22
gen dec17 = trenddv23
gen dec18 = trenddv24
gen dec19 = trenddv25
gen dec20 = trenddv26
gen dec21 = trenddv27
gen dec22 = trenddv28
gen dec23 = trenddv29
gen dec24 = trenddv30

reg trustgovind  dec5 dec6 dec7 dec8 dec9 dec10 dec11 dec12 dec13 dec14 dec15 dec16 dec17 dec18 dec19 dec20 dec21 dec22 dec23 dec24 dec25 education wealth, robust    
margins, dydx ( dec5 dec6 dec7 dec8 dec9 dec10 dec11 dec12 dec13 dec14 dec15 dec16 dec17 dec18 dec19 dec20 dec21 dec22 dec23 dec24 dec25 education wealth) post
marginsplot, horizontal xline (0) yscale (reverse) recast (scatter)
