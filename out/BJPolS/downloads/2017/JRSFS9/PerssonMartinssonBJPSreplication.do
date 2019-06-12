clear
set more off
use "\\micro.intra\Projekt\P0462$\P0462_permik\martinsson persson\vu06+inc.dta"

* Replication data for Persson & Martinsson "Patrimonial Economic Voting and Asset Value" in BJPS.


**** RECODE DEP  VAR AND CONTROLS
recode V7000 (1/2=0) (3/6=1) (7=0) (8/9=0) (.i=0) (.b=0) , gen(block)
recode V7000 (1/4=0) (5=1) (6/7=0) (8/9=0) (.i=0) (.b=0) , gen(m)
ren utbny edu
gen occupation = 0
replace occupation =1 if V765 == 1
replace occupation =1 if V765 == 2
replace occupation =1 if V765 == 3
ren V1010 ideology
recode V598 (1=0) (3=0.5) (5=1) , gen(valence)

**** RECODE BINARY
recode y6_ratt (0=0) (1/1000000000000=1) , gen(bostadsratt)
recode y6_ahus (0=0) (1/1000000000000=1) , gen(hus)
recode y6_itids (0=0) (1/1000000000000=1) , gen(fritidshus)
gen home = .
replace home = 1 if bostadsratt == 1
replace home = 1 if hus == 1
replace home = 0 if hus == 0 & bostadsratt == 0
recode y6_res (0=0) (1/1000000000000=1) , gen(rental)
recode y6_rsaktier (0=0) (1/1000000000000=1) , gen(stocks)
recode y6_ntefonder (0=0) (1/1000000000000=1) , gen(rantefonder)
recode y6_ligationer (0=0) (1/1000000000000=1) , gen(obligationer)
gen savings = .
replace savings =1 if rantefonder == 1
replace savings =1 if obligationer == 1
replace savings =0 if rantefonder == 0 & obligationer == 0
recode y6_rdb (0=0) (1/1000000000000=1) , gen(farm)
recode y6_v (0=0) (1/1000000000000=1) , gen(company)
gen farm_company =.
replace farm_company = 1 if farm ==1
replace farm_company = 1 if company ==1
replace farm_company = 0 if company == 0 & farm == 0

**** REOCDE ASSETS VALUE
ren y6_ratt bostadsrattvalue
ren y6_ahus husvalue
ren y6_itids fritidshusvalue
ren y6_ntefonder rantefondervalue
ren y6_ligationer obligationervalue
gen savingsvalue = rantefondervalue + obligationervalue
gen homevalue = bostadsrattvalue + husvalue
gen lowriskvalue = bostadsrattvalue + husvalue + fritidshusvalue + rantefondervalue + obligationervalue
ren y6_rdb farmvalue
ren y6_v companyvalue 
ren y6_rsaktier aktiervalue
ren y6_drafonder fondervalue
ren y6_res rentalvalue
gen stocksvalue = aktiervalue + fondervalue
gen highriskvalue = farmvalue  + fondervalue + aktiervalue + rentalvalue 
gen totalvalue = y6_altill + y6_nanstill
gen highrisk = farm + stocks + rental
gen lowrisk = home + fritidshus + savings

* table 1
sum homevalue fritidshusvalue savingsvalue fondervalue aktiervalue farmvalue rentalvalue , detail
sum homevalue if homevalue > 0
sum fritidshusvalue if fritidshusvalue > 0
sum savingsvalue if savingsvalue > 0
sum fondervalue if fondervalue > 0
sum aktiervalue if aktiervalue > 0
sum farmvalue if farmvalue > 0
sum rentalvalue if rentalvalue > 0

* table 2
tab lowrisk
tab highrisk

* table a1
pca homevalue fritidshusvalue  farmvalue savingsvalue fondervalue aktiervalue  ,  factor(3)
rotate, varimax  blanks(.3)

* table a2
pca homevalue fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue   ,  factor(3)
sem (Faktor_3_1 -> homevalue@0 fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue  )  ///
    (Faktor_3_2 -> homevalue fritidshusvalue savingsvalue@0 farmvalue fondervalue aktiervalue  )  ///
	(Faktor_3_3 -> homevalue fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue@0  ), ///
	variance(Faktor_3_1@1 Faktor_3_2@1 Faktor_3_3@1) standardized iterate(30)

	pca homevalue fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue   ,  factor(2)
	sem (Faktor_2_1 -> homevalue@0 fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue  )  ///
    (Faktor_2_2 -> homevalue fritidshusvalue savingsvalue@0 farmvalue fondervalue aktiervalue  )  , ///
	variance(Faktor_2_1@1 Faktor_2_2@1) standardized iterate(30)
	estat gof, stat(all)
	
	pca homevalue fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue   ,  factor(1)
	sem (Faktor1_1 -> homevalue fritidshusvalue savingsvalue farmvalue fondervalue aktiervalue  ) , ///
	variance(Faktor1_1@1) standardized iterate(30)
	estat gof, stat(all)

*** new indexes
gen houses_value_new = homevalue + fritidshusvalue + farmvalue
gen savings_value_new = savingsvalue + fondervalue
alpha savingsvalue fondervalue , item 
alpha homevalue fritidshusvalue  farmvalue , item
replace houses_value_new = houses_value_new + 1
gen log_houses_value_new =ln(houses_value_new)
replace savings_value_new = savings_value_new + 1
gen log_savings_value_new =ln(savings_value_new)
replace log_savings_value_new = 1 if log_savings_value_new == .

replace aktiervalue = aktiervalue + 1
gen logaktiervalue  =ln(aktiervalue)
replace aktiervalue = aktiervalue - 1

*** table 3
eststo: logit block age sex edu INK5  occupation   , robust
eststo: logit block age sex edu INK5  occupation    lowrisk highrisk   
eststo: logit block age sex edu INK5  occupation     log_houses_value_new log_savings_value_new logaktiervalue  , robust

*** table a3
eststo: logit block age sex edu INK5  occupation   ideology
eststo: logit block age sex edu INK5  occupation     lowrisk highrisk ideology
eststo: logit block age sex edu INK5  occupation    log_houses_value_new log_savings_value_new logaktiervalue ideology

*** table a4
eststo: logit block age sex edu INK5  occupation valence  
eststo: logit block age sex edu INK5  occupation valence   lowrisk highrisk 
eststo: logit block age sex edu INK5  occupation valence    log_houses_value_new log_savings_value_new logaktiervalue 

* table 4
eststo: reg ideology age sex edu INK5  occupation  
eststo: reg ideology age sex edu INK5  occupation     lowrisk highrisk
reg ideology age sex edu INK5  occupation    log_houses_value_new log_savings_value_new logaktiervalue  , robust

* table a5
eststo: reg ideology age sex edu INK5  occupation  valence
eststo: reg ideology age sex edu INK5  occupation   valence  lowrisk highrisk
eststo: reg ideology age sex edu INK5  occupation  valence  log_houses_value_new log_savings_value_new logaktiervalue  


* recode into categories and log
replace aktiervalue = aktiervalue + 1
replace aktiervalue = . if aktiervalue == 1
egen aktiercut =cut(aktiervalue),group(5)
replace aktiercut = aktiercut + 1
replace aktiercut = 0 if aktiercut == .
replace aktiervalue = 1 if aktiervalue == .


replace houses_value_new = . if houses_value_new == 1
egen houses_value_cat =cut(houses_value_new),group(5)
replace houses_value_cat = houses_value_cat + 1
replace houses_value_cat = 0 if houses_value_cat == .
replace houses_value_new = 1 if houses_value_new == .

replace savings_value_new = savings_value_new + 1
replace savings_value_new = . if savings_value_new == 1
egen savings_value_cat =cut(savings_value_new),group(5)
replace savings_value_cat = savings_value_cat + 1
replace savings_value_cat = 0 if savings_value_cat == .
replace savings_value_new = 1 if savings_value_new == .




* table a6
set scheme sj
logit block age sex edu INK5  occupation i.aktiercut  , robust
margins i.aktiercut 
set scheme sj
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(0 "0" .25 "25" .5 "50" .75 "75" ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Stocks") ///
ytitle(" ") ///
xtitle("Value") ///
name(A, replace)
 
eststo: logit block age sex edu INK5  occupation   i.houses_value_cat  
margins i.houses_value_cat 
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(0 "0" .25 "25" .5 "50" .75 "75" ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Real estate properties") ///
ytitle(" ") ///
xtitle("Value") ///
name(B , replace)

eststo: logit block age sex edu INK5  occupation  i.savings_value_cat 
margins i.savings_value_cat
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(0 "0" .25 "25" .5 "50" .75 "75" ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Savings") ///
ytitle(" ") ///
xtitle("Value") ///
name(C , replace)

graph combine A B C , ycommon rows(1) xsize(15) ysize(5) graphregion(color(white))
 
* table a7
set scheme sj
eststo: reg ideology  age sex edu INK5  occupation  i.savings_value_cat 
margins i.savings_value_cat
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(4(1)7 ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Savings") ///
ytitle(" ") ///
xtitle("Value") ///
name(F , replace)


eststo: reg ideology  age sex edu INK5  occupation   i.houses_value_cat  
margins i.houses_value_cat 
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(4(1)7 ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Real estate properties") ///
ytitle(" ") ///
xtitle("Value") ///
name(E , replace)
 
eststo: reg ideology age sex edu INK5  occupation i.aktiercut  
margins i.aktiercut 
set scheme sj
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(4(1)7 ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Stocks") ///
ytitle(" ") ///
xtitle("Value") ///
name(D, replace)

graph combine D E F , ycommon rows(1) xsize(15) ysize(5) graphregion(color(white))


* table 8
set scheme sj
eststo: logit block age sex edu INK5  occupation valence i.aktiercut   , robust
margins i.aktiercut 
set scheme sj
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(0 "0" .25 "25" .5 "50" .75 "75" ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Stocks") ///
ytitle(" ") ///
xtitle("Value") ///
name(A, replace)

eststo: logit block age sex edu INK5  occupation valence   i.houses_value_cat  
margins i.houses_value_cat 
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(0 "0" .25 "25" .5 "50" .75 "75" ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Real estate properties") ///
ytitle(" ") ///
xtitle("Value") ///
name(B , replace)

eststo: logit block age sex edu INK5  occupation valence  i.savings_value_cat 
margins i.savings_value_cat
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(0 "0" .25 "25" .5 "50" .75 "75" ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Savings") ///
ytitle(" ") ///
xtitle("Value") ///
name(C , replace)

 graph combine A B C , ycommon rows(1) xsize(15) ysize(5) graphregion(color(white))

* table a9
set scheme sj
eststo: reg ideology age sex edu INK5  occupation valence i.aktiercut  
margins i.aktiercut 
set scheme sj
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(4(1)7 ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Stocks") ///
ytitle(" ") ///
xtitle("Value") ///
name(D, replace)

eststo: reg ideology  age sex edu INK5  occupation valence  i.houses_value_cat  
margins i.houses_value_cat 
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(4(1)7 ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Real estate properties") ///
ytitle(" ") ///
xtitle("Value") ///
name(E , replace)

 
eststo: reg ideology  age sex edu INK5  occupation valence  i.savings_value_cat 
margins i.savings_value_cat
marginsplot,  recast(dot)  ///
graphregion(color(white)) plotregion(color(white)) ylabel(4(1)7 ) /// 
xlabel(0 "0" 1 "0-20" 2 "21-40" 3 "41-60" 4 "61-80" 5 "81-100" ) ///
xsize(10) ysize(10) ///
title("Savings") ///
ytitle(" ") ///
xtitle("Value") ///
name(F , replace)
 
 graph combine D E F , ycommon rows(1) xsize(15) ysize(5) graphregion(color(white))
