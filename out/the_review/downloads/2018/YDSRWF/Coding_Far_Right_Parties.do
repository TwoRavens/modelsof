***********************************
***** PARTY CLOSEST TO 
***********************************


g close_far_right = .
*** this means that all people who refused to answer or said DNK are coded as missing 
label var close_far_right "Feel close far right party"
*** then anyone who has answered yes is asked about which party. 0 are converted into 1 if they mention a far right party
*** individuals who refuse to answer or said DNK are coded as missing 



***** Great Britain

*** essround 1, 2,4, 5, 6
**replace close_far_right = 1 if cntry =="GB" & prtclgb == 7 & essround == XXXXX

replace close_far_right = 0 if clsprty == 2 & cntry =="GB" & essround == 3
replace close_far_right = 0 if clsprty == 1 & cntry =="GB" & essround == 3
replace close_far_right = 1 if cntry =="GB" & prtclagb == 7 & essround == 3
replace close_far_right = 1 if cntry =="GB" & prtclagb == 8 & essround == 3
** dropped Northern Ireland observations
replace close_far_right = . if cntry =="GB" & prtclagb > 8 &  essround == 3
*** no answer, DNKs
replace close_far_right = . if cntry =="GB" & inlist(prtclagb,77,88,99)


replace close_far_right = 0 if clsprty == 2 & cntry =="GB" & essround == 7
replace close_far_right = 0 if clsprty == 1 & cntry =="GB" & essround == 7
replace close_far_right = 1 if cntry =="GB" & prtclbgb == 7 & essround == 7
** dropped Northern Ireland observations
replace close_far_right = . if cntry =="GB" & prtclbgb > 8 & essround == 7

*** no answer, DNKs
replace close_far_right = . if cntry =="GB" & inlist(prtclbgb,77,88,99)



***** France 

replace close_far_right = 0 if clsprty == 2 & cntry =="FR" 
replace close_far_right = 0 if clsprty == 1 & cntry =="FR" 

replace close_far_right = 1 if cntry =="FR" & prtclfr == 3 & essround == 1
replace close_far_right = 1 if cntry =="FR" & prtclfr == 7 & essround == 1
replace close_far_right = 1 if cntry =="FR" & prtclfr == 3 & essround == 2
replace close_far_right = 1 if cntry =="FR" & prtclfr == 7 & essround == 2
*** no answer, DNKs
replace close_far_right = . if cntry =="FR" & inlist(prtclfr,77,88,99)

replace close_far_right = 1 if cntry =="FR" & prtclafr == 2  & essround == 3
replace close_far_right = 1 if cntry =="FR" & prtclafr == 6  & essround == 3
*** no answer, DNKs
replace close_far_right = . if cntry =="FR" & inlist(prtclafr,77,88,99)


replace close_far_right = 1 if cntry =="FR" & prtclbfr == 2  & essround == 4
*** no answer, DNKs
replace close_far_right = . if cntry =="FR" & inlist(prtclbfr,77,88,99)


replace close_far_right = 1 if cntry =="FR" & prtclcfr == 2  & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="FR" & inlist(prtclcfr,77,88,99)


replace close_far_right = 1 if cntry =="FR" & prtcldfr == 2  & essround == 6
*** no answer, DNKs
replace close_far_right = . if cntry =="FR" & inlist(prtcldfr,77,88,99)


replace close_far_right = 1 if cntry =="FR" & prtclcfr == 2  & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="FR" & inlist(prtclcfr,77,88,99)


***** Denmark

replace close_far_right = 0 if clsprty == 2 & cntry =="DK" 
replace close_far_right = 0 if clsprty == 1 & cntry =="DK" 

replace close_far_right = 1 if cntry =="DK" & prtcldk == 6 & essround == 1
replace close_far_right = 1 if cntry =="DK" & prtcldk == 6 & essround == 2
*** no answer, DNKs
replace close_far_right = . if cntry =="DK" & inlist(prtcldk,77,88,99)

replace close_far_right = 1 if cntry =="DK" & prtcladk == 6  & essround == 3
*** no answer, DNKs
replace close_far_right = . if cntry =="DK" & inlist(prtcladk,77,88,99)

replace close_far_right = 1 if cntry =="DK" & prtclbdk == 5  & essround == 4
replace close_far_right = 1 if cntry =="DK" & prtclbdk == 5  & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="DK" & inlist(prtclbdk,77,88,99)


replace close_far_right = 1 if cntry =="DK" & prtclcdk == 5  & essround == 6
replace close_far_right = 1 if cntry =="DK" & prtclcdk == 5  & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="DK" & inlist(prtclcdk,77,88,99)



***** Sweden

*replace close_far_right = 1 if cntry =="SE" & prtclse == 8 & essround < 5
*** = 8 for wave 1 - 4, but this is a residual category so we might have a pb (SD was 8th in the elections in 2002 )

replace close_far_right = 0 if clsprty == 2 & cntry =="SE" & inlist(essround,5,6,7)
replace close_far_right = 0 if clsprty == 1 & cntry =="SE" & inlist(essround,5,6,7)


replace close_far_right = 1 if cntry =="SE" & prtclase == 10  & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="SE" & inlist(prtclase,77,88,99)


replace close_far_right = 1 if cntry =="SE" & prtclbse == 10  & essround == 6
replace close_far_right = 1 if cntry =="SE" & prtclbse == 10  & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="SE" & inlist(prtclbse,77,88,99)



***** Netherlands

replace close_far_right = 0 if clsprty == 2 & cntry =="NL" 
replace close_far_right = 0 if clsprty == 1 & cntry =="NL" 


replace close_far_right = 1 if cntry =="NL" & prtclnl == 4 & essround == 1
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtclnl,77,88,99)


replace close_far_right = 1 if cntry =="NL" & prtclanl == 4 & essround == 2
replace close_far_right = 1 if cntry =="NL" & prtclanl == 12 & essround == 2
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtclanl,77,88,99)


replace close_far_right = 1 if cntry =="NL" & prtclnl == 4 & essround == 3
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtclnl,77,88,99)


replace close_far_right = 1 if cntry =="NL" & prtclbnl == 4  & essround == 4
replace close_far_right = 1 if cntry =="NL" & prtclbnl == 11  & essround == 4
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtclbnl,77,88,99)


replace close_far_right = 1 if cntry =="NL" & prtclcnl == 3  & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtclcnl,77,88,99)


replace close_far_right = 1 if cntry =="NL" & prtcldnl == 3  & essround == 6
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtcldnl,77,88,99)


replace close_far_right = 1 if cntry =="NL" & prtclenl == 3  & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="NL" & inlist(prtclenl,77,88,99)



*************************** No first stage 

*** Belgium 

replace close_far_right = 0 if clsprty == 2 & cntry =="BE" 
replace close_far_right = 0 if clsprty == 1 & cntry =="BE" 


replace close_far_right = 1 if cntry =="BE" & prtclbe == 8 & essround == 1
replace close_far_right = 1 if cntry =="BE" & prtclbe == 15 & essround == 1
*** no answer, DNKs
replace close_far_right = . if cntry =="BE" & inlist(prtclbe,77,88,99)


replace close_far_right = 1 if cntry =="BE" & prtclabe == 8 & essround == 2
replace close_far_right = 1 if cntry =="BE" & prtclabe == 12 & essround == 2
replace close_far_right = 1 if cntry =="BE" & prtclabe == 8 & essround == 3
replace close_far_right = 1 if cntry =="BE" & prtclabe == 12 & essround == 3
*** no answer, DNKs
replace close_far_right = . if cntry =="BE" & inlist(prtclabe,77,88,99)


replace close_far_right = 1 if cntry =="BE" & prtclbbe == 8 & essround == 4
replace close_far_right = 1 if cntry =="BE" & prtclbbe == 12 & essround == 4
*** no answer, DNKs
replace close_far_right = . if cntry =="BE" & inlist(prtclbbe,77,88,99)


replace close_far_right = 1 if cntry =="BE" & prtclcbe == 11 & essround == 5
replace close_far_right = 1 if cntry =="BE" & prtclcbe == 7 & essround == 5
replace close_far_right = 1 if cntry =="BE" & prtclcbe == 11 & essround == 6
replace close_far_right = 1 if cntry =="BE" & prtclcbe == 7 & essround == 6
replace close_far_right = 1 if cntry =="BE" & prtclcbe == 11 & essround == 7
replace close_far_right = 1 if cntry =="BE" & prtclcbe == 7 & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="BE" & inlist(prtclcbe,77,88,99)


**** Germany 

replace close_far_right = 0 if clsprty == 2 & cntry =="DE" & essround > 1
replace close_far_right = 0 if clsprty == 1 & cntry =="DE" & essround > 1

replace close_far_right = 1 if cntry =="DE" & prtclade == 7 & essround == 2
*** no answer, DNKs
replace close_far_right = . if cntry =="DE" & inlist(prtclade,77,88,99)

replace close_far_right = 1 if cntry =="DE" & prtclbde == 7 & essround == 3
replace close_far_right = 1 if cntry =="DE" & prtclbde == 7 & essround == 4
*** no answer, DNKs
replace close_far_right = . if cntry =="DE" & inlist(prtclbde,77,88,99)

replace close_far_right = 1 if cntry =="DE" & prtclcde == 7 & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="DE" & inlist(prtclcde,77,88,99)

replace close_far_right = 1 if cntry =="DE" & prtcldde == 7 & essround == 6
*** no answer, DNKs
replace close_far_right = . if cntry =="DE" & inlist(prtcldde,77,88,99)

replace close_far_right = 1 if cntry =="DE" & prtclede == 6 & essround == 7
replace close_far_right = 1 if cntry =="DE" & prtclede == 8 & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="DE" & inlist(prtclede,77,88,99)



** Finland 

replace close_far_right = 0 if clsprty == 2 & cntry =="FI" 
replace close_far_right = 0 if clsprty == 1 & cntry =="FI" 

replace close_far_right = 1 if cntry =="FI" & prtclfi == 5 & essround == 1
replace close_far_right = 1 if cntry =="FI" & prtclfi == 5 & essround == 2
replace close_far_right = 1 if cntry =="FI" & prtclfi == 5 & essround == 3
*** no answer, DNKs
replace close_far_right = . if cntry =="FI" & inlist(prtclfi ,77,88,99)


replace close_far_right = 1 if cntry =="FI" & prtclafi == 5 & essround == 4
*** no answer, DNKs
replace close_far_right = . if cntry =="FI" & inlist(prtclafi ,77,88,99)


replace close_far_right = 1 if cntry =="FI" & prtclbfi == 5 & essround == 5
replace close_far_right = 1 if cntry =="FI" & prtclbfi == 7 & essround == 5
replace close_far_right = 1 if cntry =="FI" & prtclbfi == 8 & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="FI" & inlist(prtclbfi ,77,88,99)


replace close_far_right = 1 if cntry =="FI" & prtclcfi == 4 & essround == 6
replace close_far_right = 1 if cntry =="FI" & prtclcfi == 6 & essround == 6
replace close_far_right = 1 if cntry =="FI" & prtclcfi == 4 & essround == 7
replace close_far_right = 1 if cntry =="FI" & prtclcfi == 6 & essround == 7
*** no answer, DNKs
replace close_far_right = . if cntry =="FI" & inlist(prtclcfi ,77,88,99)




*** Greece

replace close_far_right = 0 if clsprty == 2 & cntry =="GR" & inlist(essround,1,2,4,5)
replace close_far_right = 0 if clsprty == 1 & cntry =="GR" & inlist(essround,1,2,4,5)

replace close_far_right = 1 if cntry =="GR" & prtclgr == 6 & essround == 1
*** no answer, DNKs
replace close_far_right = . if cntry =="GR" & inlist(prtclgr,77,88,99)

replace close_far_right = 1 if cntry =="GR" & prtclagr == 6 & essround == 2
*** no answer, DNKs
replace close_far_right = . if cntry =="GR" & inlist(prtclagr,77,88,99)

replace close_far_right = 1 if cntry =="GR" & prtclbgr == 5 & essround == 4
*** no answer, DNKs
replace close_far_right = . if cntry =="GR" & inlist(prtclbgr,77,88,99)

replace close_far_right = 1 if cntry =="GR" & prtclcgr == 4 & essround == 5
*** no answer, DNKs
replace close_far_right = . if cntry =="GR" & inlist(prtclcgr,77,88,99)


*** Italy

replace close_far_right = 0 if clsprty == 2 & cntry =="IT" & inlist(essround,1,6)
replace close_far_right = 0 if clsprty == 1 & cntry =="IT" & inlist(essround,1,6)

replace close_far_right = 1 if cntry =="IT" & prtclit == 11 & essround == 1
*** no answer, DNKs
replace close_far_right = . if cntry =="IT" & inlist(prtclit,77,88,99)

replace close_far_right = 1 if cntry =="IT" & prtclbit == 9 & essround == 6
replace close_far_right = 1 if cntry =="IT" & prtclbit == 10 & essround == 6
*** no answer, DNKs
replace close_far_right = . if cntry =="IT" & inlist(prtclbit,77,88,99)


