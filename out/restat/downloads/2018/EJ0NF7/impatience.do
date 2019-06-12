/////////////////////////////////////////////////////
/// IMPATIENCE AND TIME DISCOUNTING
////////////////////////////////////////////////////////////////
lab var amt_month "AMOUNT OF $ RESPONDENT WOULD WAIT 1 MONTH TO RECEIVE $1K"
lab var amt_year "AMOUNT OF $ RESPONDENT WOULD WAIT 1 YEAR TO RECEIVE $1K"
lab var amt_month_low "AMOUNT OF $ RESPONDENT WOULD WAIT 1 MONTH TO RECEIVE $1K - LOW"
lab var amt_year_low "AMOUNT OF $ RESPONDENT WOULD WAIT 1 YEAR TO RECEIVE $1K - HIGH"
lab var amt_month_high "AMOUNT OF $ RESPONDENT WOULD WAIT 1 MONTH TO RECEIVE $1K - LOW"
lab var amt_year_high "AMOUNT OF $ RESPONDENT WOULD WAIT 1 YEAR TO RECEIVE $1K - HIGH"
lab var int_mood "ATTITUDE OF R DURING INTERVIEW"

quietly mvdecode _all, mv(-5=. \ -4=. \ -3=. \ -2=. \ -1=.)

gen impatient = (int_mood==3) & inrange(year,1980,1993)   // Olga expanded time to include info up to 1993
bys caseid: egen temp = total(impatient)
replace impatient = 1 if temp>0 & !mi(temp)
drop temp


gen imp93=int_mood==3 & year==1993 if !mi(int_mood)
bys caseid: egen temp = max(imp93)
replace imp93 = temp
drop temp

gen imp=(int_mood==3) if !mi(int_mood) & year>1979
bys case: gen simp=sum(imp)
bys case: gen obs=_n
gen fimp=simp/obs

gen fimp93=fimp if year==1993
bys caseid: egen temp = max(fimp93)
replace fimp93 = temp
drop temp obs 

*************************
*winsorized at the 95 percentile* or drop, if above $5000, 10000 like Keys
*fill in missing values with interval variables first

replace amt_year=(amt_year_low +amt_year_high)/2 if mi(amt_year)
replace amt_month=(amt_month_low +amt_month_high)/2 if mi(amt_month)


egen annual_max=pctile(amt_year), p(95)
egen month_max=pctile(amt_month), p(95)


//winsorized
replace amt_year=annual_max if amt_year>annual_max & amt_year!=.
replace amt_month=month_max if amt_month>month_max & amt_month!=.

drop annual_max month_max amt_year_low amt_year_high amt_month_low amt_month_high
***************************************

gen df_annual = 1000/(1000+amt_year) if amt_year!=.
gen df_month = (1000/(1000+amt_month))^(1/12) if amt_month!=.


gen delta = ((1000+amt_month)/(1000+amt_year))^(12/11)
gen beta = 1000/(delta*(1000+amt_year))


*above or below the median

sum beta [aw=weight]  if year==2006, detail
gen beta_p50=r(p50) 

sum delta [aw=weight] if year==2006, detail
gen delta_p50=r(p50)

egen beta_p=pctile(beta)  if year==2006, p(50)
egen delta_p=pctile(delta)  if year==2006 , p(50)

gen presentbias=(beta<=beta_p50) if !mi(beta)
gen highdiscount=(delta<=delta_p50) if !mi(delta)

label var presentbias "low relative beta, p50"
label var highdiscount "low relative delta, p50"
