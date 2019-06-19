
cd "/data/"
use cl.dta, clear

***** Table 1 *****
gen table1=1
replace table1=0 if state=="AK" | state=="CT" | state=="GA"| state=="HI" | state=="IL" | state=="IN" | state=="ME" | state=="MA" | state=="MI" | state=="NE" | state=="NH" | state=="NY" | state=="OH" | state=="PA" | state=="RI" | state=="VT" | state=="VA" | state=="WI"
tab duemth if table1==1

***** Table 2 *****

* # Months Before Due Date
gen timeuntil=.
replace timeuntil=duemth-fmth if duemth>=fmth & agedue1<=12
replace timeuntil=duemth+12-fmth if duemth>=fmth & agedue1>12 & agedue1!=.
replace timeuntil=duemth+12-fmth if duemth<fmth

* # Months After Due Date
* first identify the calendar month of the previous due date
foreach y of numlist 1999/2008 {
  foreach i of numlist 1/4 {
    gen hold`i'_`y'=(t`i'_yr`y'-fyr)*12+(t`i'_mth`y'-fmth)
    replace hold`i'_`y'=. if hold`i'_`y'>0
    }
  }
  
* next create age at previous due date
gen lastdueage=-1000000000000
foreach y of numlist 2004/2008 {
  foreach i of numlist 1/4 {
    replace lastdueage=hold`i'_`y' if hold`i'_`y'>lastdueage & hold`i'_`y'!=.
	 }
  }
replace lastdueage=. if lastdueage<-20

* now create calendar month of LAST due date
gen lastmth=.
replace lastmth=fmth+lastdueage
replace lastmth=lastmth+12 if lastmth<=0

* finally, create time SINCE variable/dummies
gen timesince=.
replace timesince=fmth-lastmth if fmth>=lastmth
replace timesince=fmth+12-lastmth if fmth<lastmth

preserve

	qui tab duemth, gen(duemth) mi
	qui tab timeuntil, gen(timeuntil) mi
	qui tab timesince, gen(timesince) mi
	
	* Drop states with non-uniform due dates
	drop if state=="AK" | state=="CT" | state=="GA" | state=="ID" | state=="IN" | state=="IA" | state=="NE" | state=="OH" | state=="IL"
	
	collapse (mean) duemth1-duemth12 timeuntil1-timeuntil5 timesince1-timesince5, by(fmth fyr state)
	
	cd "/data/"
	sort fmth fyr state
	save duemthdummy.dta, replace
	
restore

preserve
	* Drop states with non-uniform due dates
	drop if state=="AK" | state=="CT" | state=="GA" | state=="ID" | state=="IN" | state=="IA" | state=="NE" | state=="OH" | state=="IL"
	
	gen one=1
		
	collapse (count) cnt=one (mean) duemth1-duemth12 fico sale_price cltv fulldoc init_rate var_rate, by(fmth fyr state)
	sort fmth state
	merge 1:1 fmth fyr state using duemthdummy.dta
	drop _merge


	foreach var of varlist cnt fico sale_price cltv fulldoc init_rate var_rate {
		xi: areg `var' timeuntil1-timeuntil5 timesince2-timesince5 i.fmth, absorb(state) robust
		estimates store m2
		estout m2, cells(b(star fmt(2)) se(par fmt(2)))
		estimates clear
	}
	
restore

***** Table 3 *****

***** # States Observed *****
bys agegrp: tab state

***** Panel A *****

foreach var of varlist sale_price fico cltv fulldoc pp_pen init_rate var_rate dti_b {
  qui summ `var' if agegrp==1
  local mean_`var'_1==round(r(mean),.001) 
  local se_`var'_1=round(r(sd)/sqrt(r(N)),.0001)
  qui reg `var' i.agegrp
  foreach grp of numlist 2/4 {
    local mean_`var'_`grp'=round(_b[_Iagegrp_`grp'],.001)
    local se_`var'_`grp'=round(_se[_Iagegrp_`grp'],.0001)
    }

  disp "`var'" _col(15) "& " `mean_`var'_1' _col(30) "& " `mean_`var'_2' _col(45) "& " `mean_`var'_3' _col(60) "& " `mean_`var'_4' 
  disp _col(15) "& " `se_`var'_1' _col(30) "& " `se_`var'_2' _col(45) "& " `se_`var'_3' _col(60) "& " `se_`var'_4'
  } 

gen one=1
foreach grp of numlist 1/4 {
  qui summ one if agegrp==`grp'
  local ss`grp'=r(N)
  }

disp "Sample Size" _col(15) "& " `ss1' _col(30) "& " `ss2' _col(45) "& " `ss3' _col(60) "& " `ss4'


***** Panel B *****
foreach var of varlist sale_price fico cltv fulldoc pp_pen init_rate var_rate dti_b {

  qui xi: reg `var' i.state i.fyr i.duemth 
  qui predict `var'_resid , resid 
  qui summ `var' 
  qui gen `var'_radj=r(mean) + `var'_resid 

  qui summ `var'_radj if agegrp==1
  local mean_`var'_1==round(r(mean),.001) 
  local se_`var'_1=round(r(sd)/sqrt(r(N)),.0001)
  
  qui xi: reg `var'_radj i.agegrp
  foreach grp of numlist 2/4 {
    local mean_`var'_`grp'=round(_b[_Iagegrp_`grp'],.001)
    local se_`var'_`grp'=round(_se[_Iagegrp_`grp'],.0001)
    }

  disp "`var'" _col(15) "& " `mean_`var'_1' _col(30) "& " `mean_`var'_2' _col(45) "& " `mean_`var'_3' _col(60) "& " `mean_`var'_4'
  disp _col(15) "& " `se_`var'_1' _col(30) "& " `se_`var'_2' _col(45) "& " `se_`var'_3' _col(60) "& " `se_`var'_4'
  }
  

***** Table 4 *****

***** Panel A *****

foreach var of varlist prop_inc2004 proptax_inc installnum hpa cltv_adj ue_12mo def30_1year {
  qui summ `var' if agegrp==1
  local mean_`var'_1==round(r(mean),.001) 
  local se_`var'_1=round(r(sd)/sqrt(r(N)),.0001)
  qui reg `var' i.agegrp
  foreach grp of numlist 2/4 {
    local mean_`var'_`grp'=round(_b[_Iagegrp_`grp'],.001)
    local se_`var'_`grp'=round(_se[_Iagegrp_`grp'],.0001)
    }

  disp "`var'" _col(15) "& " `mean_`var'_1' _col(30) "& " `mean_`var'_2' _col(45) "& " `mean_`var'_3' _col(60) "& " `mean_`var'_4' 
  disp _col(15) "& " `se_`var'_1' _col(30) "& " `se_`var'_2' _col(45) "& " `se_`var'_3' _col(60) "& " `se_`var'_4'
  } 

gen one=1
foreach grp of numlist 1/4 {
  qui summ one if agegrp==`grp'
  local ss`grp'=r(N)
  }

disp "Sample Size" _col(15) "& " `ss1' _col(30) "& " `ss2' _col(45) "& " `ss3' _col(60) "& " `ss4' 


***** Panel B *****
foreach var of varlist prop_inc2004 proptax_inc installnum hpa cltv_adj ue_12mo def30_1year {

  qui xi: reg `var' i.state i.fyr i.duemth 
  qui predict `var'_resid , resid 
  qui summ `var' 
  qui gen `var'_radj=r(mean) + `var'_resid 

  qui summ `var'_radj if agegrp==1
  local mean_`var'_1==round(r(mean),.001) 
  local se_`var'_1=round(r(sd)/sqrt(r(N)),.0001)
  
  qui xi: reg `var'_radj i.agegrp
  foreach grp of numlist 2/4 {
    local mean_`var'_`grp'=round(_b[_Iagegrp_`grp'],.001)
    local se_`var'_`grp'=round(_se[_Iagegrp_`grp'],.0001)
    }

  disp "`var'" _col(15) "& " `mean_`var'_1' _col(30) "& " `mean_`var'_2' _col(45) "& " `mean_`var'_3' _col(60) "& " `mean_`var'_4'
  disp _col(15) "& " `se_`var'_1' _col(30) "& " `se_`var'_2' _col(45) "& " `se_`var'_3' _col(60) "& " `se_`var'_4'
  }