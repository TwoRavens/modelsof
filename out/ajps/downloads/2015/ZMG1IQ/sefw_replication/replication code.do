/*
Replication code for tables in

Substituting the End for the Whole:
Why Voters Respond Primarily to the Election-Year Economy


Andrew Healy
Loyola Marymount University

Gabriel S. Lenz
University of California, Berkeley 
*/

version 12.1


program define normv
 summarize  `1'
 replace `1' = (`1'-r(min))/(r(max)-r(min))
 summarize  `1'
end

************************
*******Table 2**********
************************

use "RDI 40_09", clear
sort year 
tsset year
g RDI_y  = ln(rdi/l.rdi)*100 
replace RDI_y  = round(RDI_y ,.1)
g RDI_1 =l3.RDI_y
g RDI_2 =l2.RDI_y
g RDI_3 =l.RDI_y
g RDI_4 = RDI_y

merge 1:1 year using presidents
keep if _merge == 3
generate inc_margin = demvote -repvote  if dem_inc == 1
replace inc_margin = repvote - demvote if dem_inc == 0

***Column 1 coefficients***
reg inc_margin RDI_1 RDI_2 RDI_3 RDI_4,
     outreg2 using table_2, se  auto(2) noas  e(rmse) replace word

***Column 3 means and standard errors***
use "study_A1", clear
ci q187_*


************************
*******Table 3**********
************************
use "RDI 40_09", clear

tsset year
sort year 
g RDI_y  = ln(rdi/l.rdi)*100 
replace RDI_y  = round(RDI_y ,.1)
g RDI_1 =l3.RDI_y
g RDI_2 =l2.RDI_y
g RDI_3 =l.RDI_y
g RDI_4 = RDI_y


merge year using presidents
generate inc_margin = demvote -repvote  if dem_inc == 1
replace inc_margin = repvote - demvote if dem_inc == 0

sort year
save RDI_1217, replace

*prepare survey results
insheet using "study_B1.csv", clear
sum epc_*
drop if epc_2013 ==.
drop if epc_1949 ==.
sum epc_*
sum attention_*
keep if attention_2green == 1 & attention_2yellow== 1
sum epc_*
reshape long epc_, i(responseid) j(year)  
replace year = year-5
sort year
joinby year using RDI_1217, 
rename epc_ economy
norm economy
replace economy = economy*10
collapse economy RDI_*  demvote- inc_margin, by(year)

***Column 1 coefficients and p-values***
reg economy RDI_1 RDI_2 RDI_3 RDI_4
     outreg2 using table_3, se  auto(2) noas  e(rmse) replace word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 
***Column 2 coefficients and p-values***
normv inc_margin
reg inc_margin RDI_1 RDI_2 RDI_3 RDI_4
     outreg2 using table_3, se  auto(2) noas  e(rmse) append word
***Column 3 coefficients and p-values***
normv economy
reg economy RDI_1 RDI_2 RDI_3 RDI_4
     outreg2 using table_3, se  auto(2) noas  e(rmse) append word


***Code for Table 3 Column 4 coefficients and p-values***
version 11.1
clear
*prepare survey data
  insheet using "study_B2.csv",c clear
 *keep only respondents from second study
 keep if study_number == 1218
 *drop people who fail either attention test
   sum attention_*
    keep if attention_2green == 1 & attention_2yellow == 1
      sum  epc_*   
*reshape
  reshape long epc_  , i(responseid) j(year) 
  norm epc_    
   collapse epc_ , by(year )  
   sort year
   save econ_1218, replace
*randomly generate growth data
clear
drawnorm growth, n(120) means(2) sds(2) seed(40)
generate RDI  = round(growth,.1)
drawnorm initial, n(120) means(32343) sds(100) seed(5) 
* replace growth = round(RDI,.1)
generate count =_n -1
sort count
generate year = 1949+ count
drop if year > 2048
tsset count
g RDI_1 = growth
g RDI_2 = f.growth
g RDI_3 = f2.growth
g RDI_4 = f3.growth
*merge percent change 
joinby year using econ_1218, 
drop if epc_==.
generate econ_pc_ = epc_*10

***Table 3 Column 4 coefficients and p-values***
regress econ_pc_   RDI_1 RDI_2 RDI_3 RDI_4
     outreg2 using table_3, se  auto(2) noas  e(rmse) append word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 




************************
*******   C1  **********
************************
*Replication of result mentioned in text (no table):
*"After 232 participants rated 17 real-world economies for the experiment we presented earlier (Study B1), 
*we asked, “Say you were trying to forecast the average economy in the four years following these periods. 
*Would all years during these terms be equally predictive of the future? Would later years matter a little 
*more or a little less than earlier years? Tell us what you think by assigning percentage weights to each year.” 
*Based on their responses, participants did not appear to see later years as considerably more informative: the 
*average weights they reported are 19.8%, 22.8%, 26.5%, and 30.9%, respectively (see p. 17 of the SI for details). "

insheet using "study_B1.csv", clear
sum epc_*
drop if epc_2013 ==.
drop if epc_1949 ==.
sum epc_*
sum attention_*
keep if attention_2green == 1 & attention_2yellow== 1
sum epc_*

*Key finding:
sum econ_weight_futureyear*



************************
*******Table 4**********
************************
version 10.1
clear
drawnorm growth, n(120) means(2) sds(2) seed(8)   
 replace growth = round(growth,.1)
drawnorm initial, n(120) means(32343) sds(100) seed(3) 
generate count =_n -1
sort count
generate year = 1949+ count
drop if year > 2048
tsset count
g RDI_1 = growth
g RDI_2 = f.growth
g RDI_3 = f2.growth
g RDI_4 = f3.growth
sort year
save RDI_1033, replace
*prepare survey data
insheet using "study_C2.csv", clear
  *it doesn't look like we used any screener questions on this survey, which is strange
  *percentage change
      sum  epc_*  
 reshape long epc_, i(responseid) j(year)  
   drop if epc_==. 
   normv epc_    
sort year 
joinby year using RDI_1033    
generate econ_pc_ = epc_*10
collapse econ_pc_ RDI_* , by(year)  
***Column 1 coefficients and p-values***
regress econ_pc_ RDI_* 
     outreg2 using table_4, se  auto(2)  e(rmse) replace word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 

	 
***Code to for Table 4 Column 2 & 3 coefficients and p-values***
version 10.1
clear
drawnorm RDI, n(120) means(2) sds(2) seed(5)   
 replace RDI  = round(RDI,.1)
generate count =_n -1
sort count
generate year = 1949+ count
drop if year > 2048
tsset count

g RDI_1 = RDI
g RDI_2 = f.RDI
g RDI_3 = f2.RDI
g RDI_4 = f3.RDI
sort year
save four_year2, replace

*prepare survey results
insheet using "study_C3_years.CSV", clear
sum econ_*
drop if econ_2045 ==.
drop if econ_1949 ==.
sum econ_*
keep if green == "green" & black == "black"
sum econ_*
reshape long econ_, i(responseid) j(year)  
sort year
joinby year using four_year2, 
rename econ_ economy
norm economy
label values economy economy
replace economy = economy*10
collapse economy RDI_*  , by(year)
***Column 2 coefficients and p-values***
regress economy RDI_*
     outreg2 using table_4, se  auto(2)  e(rmse) append word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 	 
	 
insheet using "study_C3_term.CSV", clear
sum econ_*
drop if econ_2045 ==.
drop if econ_1949 ==.
sum econ_*
keep if green == "green" & black == "black"
sum econ_*
reshape long econ_, i(responseid) j(year)  
sort year
joinby year using four_year2, 
rename econ_ economy
norm economy
label values economy economy
replace economy = economy*10
collapse economy RDI_*  , by(year)
***Column 3 coefficients and p-values***
regress economy RDI_*
     outreg2 using table_4, se  auto(2)  e(rmse) append word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 	 



************************
*******Table 5**********
************************
version 10.1
clear
drawnorm RDI, n(120) means(2) sds(2) seed(7)   
 replace RDI  = round(RDI,.1)
generate count =_n -1
sort count
generate year = 1949+ count
drop if year > 2048
tsset count

*Create Cumulative RDI over Four Years
g RDI_ct = RDI
  *cumulative over 16 quarters-dropping quarters 1 and 16
   for num 1(4)97:replace RDI_ct = RDI+l.RDI if count ==X
   for num 2(4)98:replace RDI_ct = RDI+l.RDI+l2.RDI if count ==X
   for num 3(4)99:replace RDI_ct = RDI+l.RDI+l2.RDI+l3.RDI if count ==X
replace RDI_ct= round(RDI_ct,.2)
sort count
tsset count
g RDI_1 = RDI
g RDI_2 = f.RDI
g RDI_3 = f2.RDI
g RDI_4 = f3.RDI
sort year
save RDI_1028, replace


*prepare survey results
insheet using "study_D1_nocuml.CSV", clear
sum econ_*
drop if econ_2045 ==.
drop if econ_1949 ==.
sum econ_*
keep if green == "green" & black == "black"
sum  econ_*
reshape long econ_, i(responseid) j(year)  
sort year
joinby year using RDI_1028, 
rename econ_ economy
norm economy
label values economy economy
replace economy = economy*10
g treatment =0
drop v47
save no_cum, replace

*cumulative prepare survey results
insheet using "study_D1_cuml.CSV", clear
sum econ_*
drop if econ_2045 ==.
drop if econ_1949 ==.
sum econ_*
keep if green == "green" & black == "black"
sum econ_*
reshape long econ_, i(responseid) j(year)  
sort year
joinby year using RDI_1028, 
rename econ_ economy
norm economy
label values economy economy
replace economy = economy*10
*for var RDI_*: norm X
g treatment =1
append using no_cum, 
collapse economy RDI_*  year1-year4 , by(year treatment)

***Columns 1 & 2 coefficients and p-values***
regress economy RDI_1  RDI_2  RDI_3  RDI_4  if treatment == 0
     outreg2 using table_5, se  auto(2)  e(rmse) replace word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 	 
regress economy RDI_1  RDI_2  RDI_3  RDI_4  if treatment == 1
     outreg2 using table_5, se  auto(2)  e(rmse) append word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 	 

***Code for Columns 3 & 4 coefficients and p-values***
*prepare survey data
  insheet using "study_D2.csv", clear
 *drop people who fail either attention test
   sum attention_*
   drop if attention_13 == 1
   keep if attention_2green == 1 & attention_2yellow == 1
  reshape long epc_ ly_ yl_ , i(responseid) j(year) 
  norm epc_  
  norm ly_     
  norm yl_    
   collapse epc_ ly_ yl_ , by(year )  
   sort year
   save econ_1101, replace
*four years, yearly  (1101a) vs four years, levels & yearly twop plots (1101b)
version 10.1
clear
drawnorm growth, n(120) means(2) sds(2) seed(5)
 replace growth  = round(growth,.1)
 generate RDI  = growth
drawnorm initial, n(120) means(32343) sds(100) seed(5) 
generate count =_n -1
sort count
generate year = 1949+ count
drop if year > 2048
tsset count
g RDI_ct=.
forvalues i = 1949(4)2048 {
 replace RDI_ct= initial if year == `i'
 }
forvalues i =1950(4)2049 {
 replace RDI_ct= l.initial + (growth/100*l.initial) if year == `i'
 }
forvalues i =1951(4)2050 {
 replace RDI_ct= l.RDI_ct + (growth/100*l.RDI_ct) if year == `i'
 }
forvalues i =1952(4)2051 {
 replace RDI_ct= l.RDI_ct + (growth/100*l.RDI_ct) if year == `i'
 }
replace RDI_ct = round(RDI_ct, 100)
sort count
g RDI_1 = growth
g RDI_2 = f.growth
g RDI_3 = f2.growth
g RDI_4 = f3.growth
sort year
joinby year using econ_1101, 
drop if epc_==.
generate econ_pc_ = epc_*10
replace ly_ = ly_*10
replace yl_ = yl_*10 
rename econ_pc_ economy
***Columns 3 & 4 coefficients and p-values***
regress economy  RDI_1 RDI_2 RDI_3 RDI_4
     outreg2 using table_5, se  auto(2) noas  e(rmse) append word
	 test  RDI_4 = RDI_1 
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3  
regress yl_  RDI_2 RDI_3 RDI_4   
     outreg2 using table_5, se  auto(2) noas  e(rmse) append word
	 test  RDI_4 = RDI_2 
	 test  RDI_4 = RDI_3 

