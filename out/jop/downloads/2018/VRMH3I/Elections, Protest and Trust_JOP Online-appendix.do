
*ONLINE APPENDIX

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


*meetings

gen invite1 = q57a
recode invite1 99=. 2=0
label variable invite1 "Meeting 1"

gen invite2 = q57b 
recode invite2 99=. 2=0
label variable invite2 "Meeting 2"

gen invite3 = q57c
recode invite3 99=. 2=0
label variable invite3 "Meeting 3"

gen inviteind = invite1 + invite2 + invite3
label variable inviteind "Meeting Index"


*potential confounders

gen wealth = q3
recode wealth 99=.
gen education = q5
recode education 99=.
tab okrug, gen (okrugdv)


*partisanship

gen urplan = 0
replace urplan =1 if q62 ==6
gen urturn = 0
replace urturn =1 if q64 ==6
gen ur = urplan + urturn
label variable ur "United Russia"

gen dkplan = 0
replace dkplan = 1 if q62==99
gen dkturn = 0
replace dkturn = 1 if q64==99
gen dk = dkplan + dkturn

gen nopart = 0
replace nopart =1 if q61==2 | q63==2  | q62 ==0


*Online-Appendix 1

tab DATA if MONTH==11
tab DATA if MONTH==12


*Online-Appendix 2

*Table 2A Determinants of trust in institutions

reg trustgovind period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 
 
reg trustarmy period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustpolice period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustfsb period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustcourt period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustmungov period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustfedgov period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustduma period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustprocuracy period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustun period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2, keep(period3 period2min protestday electday) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label excel


*Table 2 with opposition voters getting information from TV

reg trustgovind period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 
reg trustarmy period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustpolice period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustfsb period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustcourt period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustmungov period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustfedgov period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustduma period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustprocuracy period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg trustun period3 period2min protestday electday wealth education okrugdv1-okrugdv10 if q30_2==1 & ur==0, robust 
outreg2 using tab2, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label excel


*Table 2B Partisan impact of the election and protest on trust

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
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 

reg trustarmy period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustpolice period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustfsb period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustcourt period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustmungov period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustfedgov period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustduma period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustprocuracy period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label

reg trustun period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust
test period2min = period3
local F : display %3.2f `r(F)'
local p : display %4.3f `r(p)'
outreg2 using tab2b, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds("F-test: Post-Protest = Post-Election", `F', "Prob > F", `p') dec(2) alpha(0.001, 0.05) symbol(*,*) label excel


*Online-Appendix 3

*Table 3.1
dprobit invite1 period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab3.1, keep(period3 period2min protestday electday) adds(Pseudo R-squared,`e(r2_p)') dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 
dprobit invite2 period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab3.1, keep(period3 period2min protestday electday) adds(Pseudo R-squared,`e(r2_p)') dec(2) alpha(0.001, 0.05) symbol(*,*) label 
dprobit invite3 period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust  
outreg2 using tab3.1, keep(period3 period2min protestday electday) adds(Pseudo R-squared,`e(r2_p)') dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg inviteind period3 period2min protestday electday wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab3.1, keep(period3 period2min protestday electday) dec(2) alpha(0.001, 0.05) symbol(*,*) label excel

*Table 3.2
dprobit invite1 period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab3.2, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds(Pseudo R-squared,`e(r2_p)') dec(2) alpha(0.001, 0.05) symbol(*,*) label replace 
dprobit invite2 period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab3.2, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) adds(Pseudo R-squared,`e(r2_p)') dec(2) alpha(0.001, 0.05) symbol(*,*) label 
dprobit invite3 period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust  
outreg2 using tab3.2, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) addstat(Pseudo R-squared,`e(r2_p)') dec(2) alpha(0.001, 0.05) symbol(*,*) label
reg inviteind period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection wealth education okrugdv1-okrugdv10, robust 
outreg2 using tab3.2, keep(period3 period2min protestday electday ur urafterprotest urpostelection apolitical apolafterprotest apolpostelection) dec(2) alpha(0.001, 0.05) symbol(*,*) label excel
