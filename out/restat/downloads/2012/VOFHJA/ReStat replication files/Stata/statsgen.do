******************************************************************************************************************
* Title: statsgen.do 
* Author: Shaq 
* Created Date: Dec 22, 2008
* Goal: Generate tables 2 through 6 for 100 bill paper.
*
*******************************************************************************************************************
clear
set more off
set mem 500M
capture log close

/* MODIFY THIS LINE TO SET THE DIRECTORY */
local datadir "~mainil/100_bill/100_Bill_on_the_Sidewalk"

local company "a av co du k m s"

* Now generate table 2. 
foreach y of local company {
   use `datadir'/Stata/data/`y'_old, clear 
   count
   su male 
   su age
   su tenure
   tabstat yearpay, s(median)
   gen everPart = 1 - neverPart
   su everPart 
   gen cont98 = 0
   replace cont98 = 1 if atcont98 > 0 | btcont98 > 0
   su cont98
   preserve
   keep if participation == 1 
   tabstat totbal, s(median)
   restore
   
   use `datadir'/Stata/data/`y'_young, clear
   count
   su male 
   su age
   su tenure
   tabstat yearpay, s(median)
   gen everPart = 1 - neverPart
   su everPart 
   gen cont98 = 0
   replace cont98 = 1 if atcont98 > 0 | btcont98 > 0
   su cont98
   preserve
   keep if participation == 1 
   tabstat totbal, s(median)
   restore
}


* Now generate table 3. 
foreach y of local company {
   use `datadir'/Stata/data/`y'_old, clear 
   count if undersaverMyopicV == 1 
   su undersaverMyopicV
   * Now among those who have arbitrage losses: 
   keep if undersaverMyopicV == 1 
   gen maxMatchPct = lossUndersaverMyopicV / maxMatchMyopicV
   su maxMatchPct
   gen nonPart = 1 - participation 
   su nonPart 
   preserve
   keep if nonPart == 1
   su neverPart
   restore
   su lossUndersaverMyopicVPct  
   su lossUndersaverMyopicV

   * Now the percentile information. 
   preserve 
   collapse (max) maxPct=lossUndersaverMyopicVPct maxDollar=lossUndersaverMyopicV (p95) p95Pct=lossUndersaverMyopicVPct p95Dollar=lossUndersaverMyopicV (p90) p90Pct=lossUndersaverMyopicVPct p90Dollar=lossUndersaverMyopicV (p75) p75Pct=lossUndersaverMyopicVPct p75Dollar=lossUndersaverMyopicV (p50) p50Pct=lossUndersaverMyopicVPct p50Dollar=lossUndersaverMyopicV (p25) p25Pct=lossUndersaverMyopicVPct p25Dollar=lossUndersaverMyopicV (p10) p10Pct=lossUndersaverMyopicVPct p10Dollar=lossUndersaverMyopicV (p5) p5Pct=lossUndersaverMyopicVPct p5Dollar=lossUndersaverMyopicV (min) minPct=lossUndersaverMyopicVPct minDollar=lossUndersaverMyopicV  
   list
   restore   
}


* Now generate table 4. 
foreach y of local company {
   use `datadir'/Stata/data/`y'_old, clear 
   drop if lossUndersaverMyopicV == .
   gen hourlypay = yearpay / 1750 
   * First replace arb loss variable of those people whose arb. loss is less than 0.1% of their annual income. 
   * so that they don't count as people who bear arb. loss in the following analysis. 
   replace lossUndersaverMyopicV = 0 if lossUndersaverMyopicVPct <= 0.1 
      
   * Case A1: 1/2 hour, 3 hours annually.        
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 0.5 * 3 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore

   * Case A2: 1/2 hour, 6 hours annually. 
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 0.5 * 6 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore

   * Case A3: 1/2 hour, 12 hours annually. 
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 0.5 * 12 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore

   * Case B1: 3/4 hour, 3 hours annually.        
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 0.75 * 3 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore

   * Case B2: 3/4 hour, 6 hours annually. 
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 0.75 * 6 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore


   * Case B3: 3/4 hour, 12 hours annually. 
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 0.75 * 12 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore


   * Case C1: 1 hour, 3 hours annually.        
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 1 * 3 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore


   * Case C2: 1 hour, 6 hours annually. 
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 1 * 6 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore


   * Case C3: 1 hour, 12 hours annually. 
   preserve
   gen hasloss = 0
   gen lossNetTime = lossUndersaverMyopicV - 1 * 12 * hourlypay
   replace hasloss = 1 if lossNetTime > 0
   su hasloss
   keep if hasloss == 1 
   collapse (mean) lossNetTime  
   list
   restore
}


* Now generate table 5. 
foreach y of local company {
   use `datadir'/Stata/data/`y'_old, clear 
   count if moneyLeaver == 1 
   su moneyLeaver 
   * Now among those below the threshold
   keep if moneyLeaver == 1 
   gen maxMatchPct = lossRaw / maxMatch 
   su maxMatchPct
   gen nonPart = 1 - participation 
   su nonPart 
   preserve
   keep if nonPart == 1
   su neverPart 
   restore
   su lossRawPct 
   su lossRaw 

   use `datadir'/Stata/data/`y'_young, clear 
      su moneyLeaver 
   * Now among those below the threshold
   keep if moneyLeaver == 1 
   gen maxMatchPct = lossRaw / maxMatch 
   su maxMatchPct
   gen nonPart = 1 - participation 
   su nonPart 
   preserve
   keep if nonPart == 1
   su neverPart 
   restore
   su lossRawPct 
   su lossRaw 
}


* Table 6. 
use `datadir'/Stata/data/all_old.dta, clear
ren v42 eligpay

* age2 is the age measured by the date 1/1/1998. 
gen age2 = age - 1

gen log_tenure = log(tenure)
gen log_salary = log(yearpay) 

gen age60 = 0
replace age60 = 1 if age2>=60 & age2<61
gen age61 = 0
replace age61 = 1 if age2>=61 & age2<62
gen age62 = 0
replace age62 = 1 if age2>=62 & age2<63
gen age63 = 0
replace age63 = 1 if age2>=63 & age2<64
gen age64 = 0
replace age64 = 1 if age2>=64 & age2<65
gen age65 = 0
replace age65 = 1 if age2>=65

gen FirstMatchRate = matchrtOne
replace FirstMatchRate = matchrtTwo if FirstMatchRate == 0 
* gen maxMatchPct = maxMatch / yearpay
gen maxMatchPct = maxMatch / eligpay
replace maxMatchPct = maxMatch / 160000 if eligpay > 160000


dprobit undersaverMyopicV male married log_tenure log_salary age60 age61 age62 age63 age64 age65 A_dum AV_dum CO_dum DU_dum K_dum M_dum S_dum
dprobit undersaverMyopicV male married log_tenure log_salary age60 age61 age62 age63 age64 age65 FirstMatchRate maxMatchPct vestingMyopic 

dprobit moneyLeaver male married log_tenure log_salary age60 age61 age62 age63 age64 age65 A_dum AV_dum CO_dum DU_dum K_dum M_dum S_dum
dprobit moneyLeaver male married log_tenure log_salary age60 age61 age62 age63 age64 age65 FirstMatchRate maxMatchPct vestingMyopic

* Now we are going to exclude those people who are contributing below the match threshold but to whom we do not attribute any arbitrage losses.
* preserve because we are only dropping the following specific group for the regression with dep var as arb loss (% of yearpay), not in the regression with dep var as match 
* forgone (as % of yearpay) 
preserve
drop if lossRawPct > 0.1 & undersaverMyopicV == 0
drop if vestingMyopic == 0 
drop if lossRawPct < 0.1 & ataxb98 > 0 & (A_dum == 1 | DU_dum == 1 | M_dum ==1)

* This censor variable value is for cnreg command below. It is set to be -1 if an individual contributes to the maximum, 
* 0 if an individual contributes less than the max but still greater than 0, 1 if an individual contributes 0.
gen censor_var = -1
replace censor_var = 0 if lossRawPct < 100*maxMatchPct & lossRawPct > 0.1
replace censor_var = 1 if lossRawPct >= 100*maxMatchPct 
cnreg lossUndersaverMyopicVPct male married log_tenure log_salary age60 age61 age62 age63 age64 age65 A_dum AV_dum CO_dum DU_dum K_dum M_dum S_dum, censored(censor_var)
cnreg lossUndersaverMyopicVPct male married log_tenure log_salary age60 age61 age62 age63 age64 age65 FirstMatchRate maxMatchPct vestingMyopic, censored(censor_var)
restore

gen censor_var = -1
replace censor_var = 0 if lossRawPct < 100*maxMatchPct & lossRawPct > 0.1
replace censor_var = 1 if lossRawPct >= 100*maxMatchPct 
cnreg lossRawPct male married log_tenure log_salary age60 age61 age62 age63 age64 age65 A_dum AV_dum CO_dum DU_dum K_dum M_dum S_dum, censored(censor_var)
cnreg lossRawPct male married log_tenure log_salary age60 age61 age62 age63 age64 age65 FirstMatchRate maxMatchPct vestingMyopic, censored(censor_var)

* Now if we do the truncation by code: drop if lossRawPct > 0.1 & undersaverMyopicV == 0, here are some interesting effects. 
* 1. In the first regression (Has arbitrage loss - first column), we have the log-tenure coefficient now as -.027 as opposed to the positive 0.034 we had. * Still significant at 1%. 
* 2. In the second regression (Contributes < match threshold - second column), we have %Vested coefficient now as 0.22 as opposed to -0.097. Now at 1% * significance, while it was at 5% significance. 
* 3. In the last regression (Matching contributions foregone (% of salary) - second column), we have %Vested coefficient now as 0.053 and insignificant as * opposed to 0.454 and significant.

* Now for the second regression table. (TABLE 7)
use `datadir'/Stata/data/all_young.dta, clear
ren v42 eligpay
* age2 is the age measured by the date 1/1/1998. 
gen age2 = age - 1
gen log_tenure = log(tenure)
gen log_salary = log(yearpay) 

gen age20 = 0
replace age20 = 1 if age2 >= 20 & age2 < 30
gen age30 = 0
replace age30 = 1 if age2 >= 30 & age2 < 40
gen age40 = 0
replace age40 = 1 if age2 >= 40 & age2 < 50
gen age50 = 0 
replace age50 = 1 if age2 >= 50 & age2 < 60 

gen FirstMatchRate = matchrtOne
replace FirstMatchRate = matchrtTwo if FirstMatchRate == 0 

* gen maxMatchPct = maxMatch / yearpay
gen maxMatchPct = maxMatch / eligpay
drop if maxMatchPct == .

dprobit moneyLeaver male married log_tenure log_salary age20 age30 age40 age50  A_dum AV_dum CO_dum DU_dum K_dum M_dum S_dum
dprobit moneyLeaver male married log_tenure log_salary age20 age30 age40 age50 FirstMatchRate maxMatchPct vestingMyopic

gen censor_var = -1
replace censor_var = 0 if lossRawPct < 100*maxMatchPct & lossRawPct > 0.1
replace censor_var = 1 if lossRawPct >= 100*maxMatchPct 
cnreg lossRawPct male married log_tenure log_salary age20 age30 age40 age50 A_dum AV_dum CO_dum DU_dum K_dum M_dum S_dum, censored(censor_var)
cnreg lossRawPct male married log_tenure log_salary age20 age30 age40 age50 FirstMatchRate maxMatchPct vestingMyopic, censored(censor_var)
capture log close

*** now generate the data for Figure 1
use `datadir'/Stata/data/all_full.dta, clear
gen agex = int(age)
collapse undersaverMyopicV moneyLeaver, by(agex)
drop if agex < 20 & agex > 65
list

clear all
capture log close

*** end code