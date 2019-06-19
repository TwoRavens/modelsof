


use temp_mex8.dta,clear

*************************************************************
** PRE AND POST
*************************************************************
gen pre=0
replace pre=1 if YEAR==2007| YEAR==2008
gen post=0
replace post=1 if YEAR>=2009 

*************************************************************
** FOREIGN OWNERSHIP 
*************************************************************
gen dum_fo10=0
replace dum_fo10=1 if dum_mo==1 | forult>=10

gen dum_fo50=0
replace dum_fo50=1 if dum_mo==1 | forult>=50 

sum forult if forult>0,detail

** predetermined FO values
gen pre_fo50=0
replace pre_fo50=1 if dum_fo50==1 & pre==1
gen pre_fo10=0
replace pre_fo10=1 if dum_fo10==1 & pre==1

bys firm_id:egen maxpre_fo50=max(pre_fo50)
drop  pre_fo50
rename  maxpre_fo50  pre_fo50

bys firm_id:egen maxpre_fo10=max(pre_fo10)
drop  pre_fo10
rename  maxpre_fo10  pre_fo10

tab YEAR
drop ratio


*************************************************************
** EXPORTERS 
*************************************************************
** sample of exporters
gen sh_x=(exports/1000)/sales
sum sh_x,detail	
sum sh_x if sh_x>0,detail

gen exporter=0
replace exporter=1 if sh_x>0 & sh_x!=.

				 
gen pred_exp=0
replace pred_exp=1 if sh_x>0 & sh_x!=. & pre==1 
bys firm_id:egen max_pred_exp=max(pred_exp)
drop pred_exp
rename max_pred_exp pred_exp


************************************************************
** CREDIT DATA
************************************************************
gen longliab=totliab-shortliab

** define Western UO bank
gen dum_uobank_west=dum_uo_region2
tab dum_uobank_west

gen pre_uobank_west=0
replace pre_uobank_west=1 if dum_uobank_west==1 & pre==1
bys firm_id BankCode:egen max_pre_uobank_west=max(pre_uobank_west)
drop  pre_uobank_west
rename  max_pre_uobank_west  pre_uobank_west
tab pre_uobank_west

* western bank that was financing short liabilities
gen pre_uobank_west_st=0
replace pre_uobank_west_st=1 if dum_uobank_west==1 & pre==1 & shortbankdebt_specific>0 & shortbankdebt_specific!=.
bys firm_id BankCode:egen max_pre_uobank_west_st=max(pre_uobank_west_st)
drop  pre_uobank_west_st
rename  max_pre_uobank_west_st  pre_uobank_west_st
tab pre_uobank_west_st


* western bank that was financing long liabilities
gen longbankdebt_specific=totbankdebt_specific-shortbankdebt_specific
gen pre_uobank_west_lt=0
replace pre_uobank_west_lt=1 if dum_uobank_west==1 & pre==1 & longbankdebt_specific>0 & longbankdebt_specific!=.
bys firm_id BankCode:egen max_pre_uobank_west_lt=max(pre_uobank_west_lt)
drop  pre_uobank_west_lt
rename  max_pre_uobank_west_lt  pre_uobank_west_lt
tab pre_uobank_west_lt

** by firm and year how much of the credit comes from
** FO banks
** total bank credit
bys firm_id YEAR pre_uobank_west:egen sum_bankdebt_spec_type=sum(totbankdebt_specific) 
drop count
bys firm_id YEAR pre_uobank_west:gen count=_n

gen sum_bankdebt_spec_dobank=sum_bankdebt_spec_type if count==1 & pre_uobank_west==0
gen sum_bankdebt_spec_fobank=sum_bankdebt_spec_type if count==1 & pre_uobank_west==1

bys firm_id YEAR:egen bankdebt_spec_dobank=max(sum_bankdebt_spec_dobank)
bys firm_id YEAR:egen bankdebt_spec_fobank=max(sum_bankdebt_spec_fobank)

replace bankdebt_spec_dobank=0 if bankdebt_spec_dobank==.
replace bankdebt_spec_fobank=0 if bankdebt_spec_fobank==.

drop count sum_bankdebt_*

** short bank credit
bys firm_id YEAR pre_uobank_west:egen sum_stbankdebt_spec_type=sum(shortbankdebt_specific) 

bys firm_id YEAR pre_uobank_west:gen count=_n

gen sum_stbankdebt_spec_dobank=sum_stbankdebt_spec_type if count==1 & pre_uobank_west==0
gen sum_stbankdebt_spec_fobank=sum_stbankdebt_spec_type if count==1 & pre_uobank_west==1

bys firm_id YEAR:egen bankdebtst_spec_dobank=max(sum_stbankdebt_spec_dobank)
bys firm_id YEAR:egen bankdebtst_spec_fobank=max(sum_stbankdebt_spec_fobank)

replace bankdebtst_spec_dobank=0 if bankdebtst_spec_dobank==.
replace bankdebtst_spec_fobank=0 if bankdebtst_spec_fobank==.

drop count sum_st* 

** long bank credit
bys firm_id YEAR pre_uobank_west:egen sum_ltbankdebt_spec_type=sum(longbankdebt_specific) 

bys firm_id YEAR pre_uobank_west:gen count=_n

gen sum_ltbankdebt_spec_dobank=sum_ltbankdebt_spec_type if count==1 & pre_uobank_west==0
gen sum_ltbankdebt_spec_fobank=sum_ltbankdebt_spec_type if count==1 & pre_uobank_west==1

bys firm_id YEAR:egen bankdebtlt_spec_dobank=max(sum_ltbankdebt_spec_dobank)
bys firm_id YEAR:egen bankdebtlt_spec_fobank=max(sum_ltbankdebt_spec_fobank)

replace bankdebtlt_spec_dobank=0 if bankdebtlt_spec_dobank==.
replace bankdebtlt_spec_fobank=0 if bankdebtlt_spec_fobank==.

drop count sum_lt*

*** identify the banks that were present 
*** both prior and after 2009
sort firm_id BankCode YEAR
br firm_id BankCode YEAR 
gen time=2007 if YEAR<=2007

br firm_id BankCode YEAR  time
replace time=2009 if YEAR>=2009
br firm_id BankCode YEAR  time
gen prior=1 if time==2007
bys firm_bank:egen maxprior=max(prior)
br firm_id firm_bank BankCode YEAR  time maxprior
drop time prior


*************************************************************
** COMPLETE THE PANEL: IF A BANK APPEARS IN POST PRIOR SHOULD
** HAVE ZERO VALUES AND IF IT DISAPPEARS IN POST IT SHOULD HAVE 
** ZERO VALUES THEN
*************************************************************
tsset firm_bank YEAR
br firm_id BankCode YEAR firm_bank gdp_defl totbankdebt_aggregate totbankdebt_specific
tab YEAR
tsfill,full
br firm_id BankCode YEAR firm_bank totbankdebt_aggregate totbankdebt_specific shortbankdebt_specific

drop if YEAR==2008

* replace in here the bank credit like this I know which are the
* true missing
local varlist totbankdebt_aggregate totbankdebt_specific dollbankdebt_specific shortbankdebt_specific longbankdebt_specific shortdollbankdebt_specific shortbankdebt_aggregate longbankdebt_aggregate
foreach var of local varlist{
replace `var'=0 if `var'==. & firm_id==. & BankCode==.
}

bys firm_bank:egen maxfirm_id=max(firm_id)
bys firm_bank:egen maxBankCode=max(BankCode)
br firm_id BankCode firm_bank YEAR gdp_defl
bys YEAR:egen maxgdp_defl=max(gdp_defl)

drop firm_id BankCode gdp_defl
rename maxfirm_id firm_id
rename maxBankCode BankCode
rename maxgdp_defl gdp_defl

** replace the missing values generated for post and pre
mdesc pre post
drop pre post

gen pre=0
replace pre=1 if YEAR==2007| YEAR==2008
gen post=0
replace post=1 if YEAR>=2009 
mdesc pre post


gen time=2008 if pre==1
replace time=2009 if post==1
tab time,missing


** Instrument
* 1. looking at total bank credit:share of bank b credit in total credit
** instrument
gen sh_bc=totbankdebt_specific/totbankdebt_aggregate
sum sh_bc,detail
sum sh_bc if sh_bc>0,detail
mdesc sh_bc
replace sh_bc=1.0009 if sh_bc>1.4 & sh_bc!=.
replace sh_bc=0 if totbankdebt_specific==0 & totbankdebt_aggregate==0
mdesc sh_bc

** w_ib:share of bank B credit in total bank credit of firm i
** pre crisis
tab YEAR
br firm_id BankCode sh_bc if YEAR==2007
gen sh_bc_07=sh_bc if YEAR==2007

local varlist sh_bc_07 
foreach var of local varlist{
bys firm_id BankCode:egen max`var'=max(`var')
drop `var'
rename max`var' `var'
}

sort firm_id BankCode YEAR

* 2. share of SHORT-TERM bank b credit in SHORT BANK credit
** instrument
gen sh_stbc=shortbankdebt_specific/shortbankdebt_aggregate
sum sh_stbc,detail
mdesc sh_stbc
replace sh_stbc=1 if sh_stbc>1 & sh_stbc!=.
replace sh_stbc=0 if shortbankdebt_specific==0 & shortbankdebt_aggregate==0
replace sh_stbc=. if sh_stbc<0 & sh_stbc!=.
mdesc sh_stbc

** w_ib:share of bank B credit in total bank credit of firm i
** pre crisis
gen sh_stbc_07=sh_stbc if YEAR==2007

local varlist sh_stbc_07
foreach var of local varlist{
bys firm_id BankCode:egen max`var'=max(`var')
drop `var'
rename max`var' `var'
}

* 3. share of LONG-TERM bank b credit in LONG BANK credit
** instrument
gen sh_ltbc=longbankdebt_specific/longbankdebt_aggregate
sum sh_ltbc,detail
mdesc sh_ltbc
replace sh_ltbc=1 if sh_ltbc>1 & sh_ltbc!=.
replace sh_ltbc=0 if longbankdebt_specific==0 & longbankdebt_aggregate==0
replace sh_ltbc=. if sh_ltbc<0 & sh_ltbc!=.
mdesc sh_ltbc

** w_ib:share of bank B credit in total bank credit of firm i
** pre crisis
gen sh_ltbc_07=sh_ltbc if YEAR==2007

local varlist sh_ltbc_07 
foreach var of local varlist{
bys firm_id BankCode:egen max`var'=max(`var')
drop `var'
rename max`var' `var'
}


* replace the missing values for pre_uobank_west
mdesc pre_uobank_west pre_uobank_west_st pre_uobank_west_lt
local varlist pre_uobank_west pre_uobank_west_st pre_uobank_west_lt
foreach var of local varlist{
bys firm_id BankCode:egen max`var'=max(`var')
drop `var'
rename max`var' `var'
mdesc `var'
}

* overall
gen wib_WB_07=sh_bc_07*pre_uobank_west

* short term
gen wib_WB_st_07=sh_stbc_07*pre_uobank_west

* long term
gen wib_WB_lt_07=sh_ltbc_07*pre_uobank_west


* the instrument is at the firm level and is the weighted
* sum of wib_WB
bys firm_id:egen F_wib_WB_07=sum(wib_WB_07) if wib_WB_07!=. & YEAR==2007
bys firm_id:egen maxF_wib_WB_07=max(F_wib_WB_07)
drop F_wib_WB_07 
rename maxF_wib_WB_07 F_wib_WB_07
sum F_wib_WB_07 ,detail
sum F_wib_WB_07 if F_wib_WB_07>0,detail

** create an indicator based  on whether the share is higher
** than the median value
* median
gen dum_F_wib_WB_07=0
replace dum_F_wib_WB_07=1 if F_wib_WB_07>0.53
bys firm_id:egen maxdum_F_wib_WB_07=max(dum_F_wib_WB_07)
drop dum_F_wib_WB_07
rename maxdum_F_wib_WB_07 dum_F_wib_WB_07


** instrument for short-term (based on whether FO bank or not)
bys firm_id:egen F_wib_WB_st_07=sum(wib_WB_st_07) if wib_WB_st_07!=. & YEAR==2007
bys firm_id:egen maxF_wib_WB_st_07=max(F_wib_WB_st_07)
drop F_wib_WB_st_07 
rename maxF_wib_WB_st_07 F_wib_WB_st_07
sum F_wib_WB_st_07 ,detail
sum F_wib_WB_st_07 if F_wib_WB_st_07>0,detail

** create an indicator based  on whether the share is higher
** than the median value 
* median
gen dum_F_wib_WB_st_07=0
replace dum_F_wib_WB_st_07=1 if F_wib_WB_st_07>0.55
bys firm_id:egen maxdum_F_wib_WB_st_07=max(dum_F_wib_WB_st_07)
drop dum_F_wib_WB_st_07
rename maxdum_F_wib_WB_st_07 dum_F_wib_WB_st_07

** instrument for long-term (based on whether FO bank or not)
bys firm_id:egen F_wib_WB_lt_07=sum(wib_WB_lt_07) if wib_WB_lt_07!=. & YEAR==2007
bys firm_id:egen maxF_wib_WB_lt_07=max(F_wib_WB_lt_07)
drop F_wib_WB_lt_07 
rename maxF_wib_WB_lt_07 F_wib_WB_lt_07
sum F_wib_WB_lt_07 ,detail
sum F_wib_WB_lt_07 if F_wib_WB_lt_07>0,detail

** create an indicator based  on whether the share is higher
** than the median value 
* median
gen dum_F_wib_WB_lt_07=0
replace dum_F_wib_WB_lt_07=1 if F_wib_WB_lt_07>0.41
bys firm_id:egen maxdum_F_wib_WB_lt_07=max(dum_F_wib_WB_lt_07)
drop dum_F_wib_WB_lt_07
rename maxdum_F_wib_WB_lt_07 dum_F_wib_WB_lt_07


** CREDIT CHANNEL USING THE FULL PANEL 2007-2011
gen pre_uobank_west_post=pre_uobank_west*post
gen pre_uobank_west_st_post=pre_uobank_west_st*post
gen pre_uobank_west_lt_post=pre_uobank_west_lt*post

gen ln_credit_fbt=ln((totbankdebt_specific/gdp_defl)+1)

sum shortbankdebt_specific,detail
replace shortbankdebt_specific=. if shortbankdebt_specific<0 & shortbankdebt_specific!=.
gen ln_stcredit_fbt=ln((shortbankdebt_specific/gdp_defl)+1)

sum longbankdebt_specific,detail
replace longbankdebt_specific=. if longbankdebt_specific<0 & longbankdebt_specific!=.
gen ln_ltcredit_fbt=ln((longbankdebt_specific/gdp_defl)+1)

sum ln_credit_fbt ln_stcredit_fbt ln_ltcredit_fbt,detail


mdesc pre_fo10 pre_fo50
local varlist pre_fo10 pre_fo50
foreach var of local varlist{
bys firm_id:egen max`var'=max(`var')
drop `var'
rename max`var' `var'
}

gen pre_fo10_post=pre_fo10*post
gen pre_fo50_post=pre_fo50*post

mdesc ln_credit_fbt pre_uobank_west

gen FO50_pre_uobank_west_post=pre_fo50*pre_uobank_west_post
gen FO10_pre_uobank_west_post=pre_fo10*pre_uobank_west_post



* not including firm-bank FE
xi:reghdfe ln_credit_fbt  pre_uobank_west_post ///
				pre_uobank_west , absorb(firm_id#YEAR YEAR) vce(cluster firm_bank)	
estimates store m1
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "no" 
estadd local cluster "firm-bank" 
estadd local sample "ALL" 
* including firm-bank FE
xi:reghdfe ln_credit_fbt  pre_uobank_west_post ///
				pre_uobank_west , absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m2
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "ALL"
* FO10 sample
xi:reghdfe ln_credit_fbt pre_uobank_west_post ///
				 if pre_fo10==1, absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m3
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "FO10"
* DO10 sample
xi:reghdfe ln_credit_fbt pre_uobank_west_post ///
				 if pre_fo10==0, absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m4
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "DO10"
**** Short term debt
* FO10 sample
xi:reghdfe ln_stcredit_fbt pre_uobank_west_post ///
				 if pre_fo10==1, absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m5
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "FO10"
* DO10 sample
xi:reghdfe ln_stcredit_fbt pre_uobank_west_post ///
				 if pre_fo10==0, absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m6
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "DO10"
**** LONG term debt
* FO10 sample
xi:reghdfe ln_ltcredit_fbt pre_uobank_west_post ///
				 if pre_fo10==1, absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m7
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "FO10"
* DO10 sample
xi:reghdfe ln_ltcredit_fbt pre_uobank_west_post ///
				 if pre_fo10==0, absorb(firm_id#YEAR firm_bank YEAR) vce(cluster firm_bank)	
estimates store m8
estadd local firm "yes"
estadd local year "yes"
estadd local firmbank "yes" 
estadd local cluster "firm-bank" 
estadd local sample "DO10"


esttab   m1 m2 m3 m4 m5 m6 m7 m8 using Table10.csv, ///
          cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
           stats(N r2 firm year firmbank cluster sample, fmt(%9.0g %9.2g) ///
		  labels(Obs. R$^2$ "Firm FE" "Year FE" "Firm-Bank FE" "Cluster" "Sample")) /// 
          starlevel(* 0.10 ** 0.05 *** 0.001)    ///
          title("Bank Debt and Foreign Ownership") replace
		  	

		  
*****************************************************
** KEEP ONLY ONE OBSERVATION PER FIRM-YEAR
*** I need to compute the averages at the firm level
*** using only firm-year observations
tab YEAR
drop if ticker=="" 
tab YEAR
drop count
bys firm_id YEAR:gen count=_n
keep if count==1
tab YEAR


******************************************************
** Credit channel at the firm level
******************************************************

tab YEAR
tab time

* instrument
gen F_wib_WB_07_post=F_wib_WB_07*post
gen dum_F_wib_WB_07_post=dum_F_wib_WB_07*post

gen F_wib_WB_st_07_post=F_wib_WB_st_07*post
gen dum_F_wib_WB_st_07_post=dum_F_wib_WB_st_07*post

gen F_wib_WB_lt_07_post=F_wib_WB_lt_07*post
gen dum_F_wib_WB_lt_07_post=dum_F_wib_WB_lt_07*post


gen ln_aggcredit_ft=ln((totbankdebt_aggregate/gdp_defl)+1)
gen ln_STcredit_ft=ln((shortbankdebt_aggregate/gdp_defl)+1)
gen ln_LTcredit_ft=ln((longbankdebt_aggregate/gdp_defl)+1)

sum ln_aggcredit_ft  ln_STcredit_ft  ln_LTcredit_ft,detail

sort firm_id YEAR
xtset firm_id YEAR

drop lag_ass
bys firm_id:gen lag_ass=L.defl_totasst

gen ln_lagass=ln(lag_ass)

gen lev=totliab/totasst
sum lev,detail
bys firm_id:gen lag_lev=L.lev
gen ln_lag_ass=ln(lag_ass)
 
gen FO10_F_wib_WB_07_post=pre_fo10*F_wib_WB_07_post
gen FO50_F_wib_WB_07_post=pre_fo50*F_wib_WB_07_post

gen FO10_dum_F_wib_WB_07_post=pre_fo10*dum_F_wib_WB_07_post
gen FO50_dum_F_wib_WB_07_post=pre_fo50*dum_F_wib_WB_07_post

gen FO10_dum_F_wib_WB_st_07_post=pre_fo10*dum_F_wib_WB_st_07*post
gen FO10_dum_F_wib_WB_lt_07_post=pre_fo10*dum_F_wib_WB_lt_07*post


*** Credit channel: INSTRUMENT BASED ON SHARE firm level
** Total Debt
* Domestic
xi:reghdfe ln_aggcredit_ft  F_wib_WB_07_post ///
                 if pre_fo10==0   , absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m1
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "no"
estadd local cluster "firm-year" 
estadd local sample "ALL"
* Foreign
xi:reghdfe ln_aggcredit_ft  F_wib_WB_07_post ///
                 if pre_fo10==1   , absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m2
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "no"
estadd local cluster "firm-year" 
estadd local sample "ALL"

** Total Debt
* Domestic
xi:reghdfe ln_aggcredit_ft  F_wib_WB_07_post ///
                 if pre_fo10==0   , absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m1
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "no"
estadd local cluster "firm-year" 
estadd local sample "ALL"
* Foreign
xi:reghdfe ln_aggcredit_ft  F_wib_WB_07_post ///
                 if pre_fo10==1   , absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m2
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "no"
estadd local cluster "firm-year" 
estadd local sample "ALL"
** short term
xi:reghdfe ln_STcredit_ft  F_wib_WB_st_07_post ///
                  if pre_fo10==0, absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m3
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "yes"
estadd local cluster "firm-year" 
estadd local sample "DO"
xi:reghdfe ln_STcredit_ft  F_wib_WB_st_07_post ///
                  if pre_fo10==1, absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m4
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "yes"
estadd local cluster "firm-year" 
estadd local sample "FO"
** long term
xi:reghdfe ln_LTcredit_ft  F_wib_WB_lt_07_post ///
                  if pre_fo10==0, absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m5
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "yes"
estadd local cluster "firm-year" 
estadd local sample "DO"
xi:reghdfe ln_LTcredit_ft  F_wib_WB_lt_07_post ///
                  if pre_fo10==1, absorb(firm_id YEAR) vce(cluster firm_id#YEAR)	
estimates store m6
estadd local firm "yes"
estadd local year "yes"
estadd local foreignyear "yes"
estadd local cluster "firm-year" 
estadd local sample "FO"


esttab   m1 m2 m3 m4 m5 m6 using Table11.csv, ///
          cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
           stats(N r2 firm year foreignyear cluster sample, fmt(%9.0g %9.2g) ///
		  labels(Obs. R$^2$ "Firm FE" "Year FE" "Foreign-YEAR FE" "Cluster" "Sample")) /// 
          starlevel(* 0.10 ** 0.05 *** 0.001)    ///
          title("Bank Debt and Foreign Ownership") replace	
			
