
// Fig A-15: share of ARMs, and ARMs that reset downward in 2009:H1, across MSAs
////////////////////////////////

use lps_arms.dta, clear  
/* McDash -- SQL pull from RADAR within Fed system:
SELECT close_dt,prop_zip, as_of_mon_id,cur_int_rate,io_flg_curr,loan_id,mba_stat,mth_pi_pay_amt,prin_bal_amt 
FROM lps.view_join_static_dynamic_lps WHERE (as_of_mon_id >= 200811 AND as_of_mon_id <= 200912 AND lien_type IN ('1') AND int_type IN ('2'))
*/

keep if as_of_mon_id<=200906

keep if inlist(mba_stat,"C", "3", "6", "9", "F")

egen x = min(as_of_mon_id), by(loan_id)
keep if x==200811 // only keep loans that are open in Nov 2008
drop x

gen year = floor(as_of_mon_id/100)
gen month = as_of_mon_id-year*100
gen datem = mofd(mdy(month, 1, year))
format datem %tm
drop year month as_of_mon_id

replace mba_stat = "1" if mba_stat=="C" // numerical value -- 1 means current
replace mba_stat = "12" if mba_stat=="F"
destring mba_stat, replace

egen nid = group(loan_id)

collapse (firstnm) first_rate = cur_int_rate first_month = datem first_mba = mba_stat first_pmt = mth_pi_pay_amt prin_bal_amt ///
	 (lastnm)  last_rate  = cur_int_rate last_month  = datem last_mba  = mba_stat last_pmt  = mth_pi_pay_amt ///
	 (min) min_mba = mba_stat min_pmt = mth_pi_pay_amt (max) max_mba = mba_stat, by(nid prop_zip) fast

qui sum last_month
g remain_in = last_month==r(max)

g change = last_rate - first_rate 

replace change = -5 if change<-5
replace change = 5 if change>5&change<.

g pmt_change_dol = last_pmt - first_pmt
g pmt_change_rel = last_pmt/first_pmt

merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)

// RATE DECREASES -- DO NOT INCLUDE IF PAYMENT WENT UP
g ratedecrease      = change < 0   & pmt_change_rel <=1
g largeratedecrease = change <= -1 & pmt_change_rel <=1 // decrease of 1% or more

// PMT DECREASES  
g pmtdecrease      = pmt_change_rel <= 1  & change < 0     
g largepmtdecrease = pmt_change_rel <= 0.9 & change < 0 // decrease of 10% or more

preserve
	keep if remain_in==1
	collapse ARM_ratedecrease_remain_in = ratedecrease ARM_largeratedecrease_remain_in = largeratedecrease ///
		 ARM_pmdecrease_remain_in   = pmtdecrease  ARM_largepmtdecrease_remain_in  = largepmtdecrease  ///
		 ARM_last_rate_remain_in = last_rate [aw=prin_bal_amt], by(msa) fast
	save temp/ARMdecrease0809_remain_in.dta, replace
restore

collapse ARM_ratedecrease_all = ratedecrease ARM_largeratedecrease_all = largeratedecrease ///
         ARM_pmdecrease_all   = pmtdecrease  ARM_largepmtdecrease_all  = largepmtdecrease  ///
	 ARM_last_rate_all = last_rate [aw=prin_bal_amt], by(msa) fast
save temp/ARMdecrease0809_all.dta, replace

////////////////////////////////////
 
use output/master.dta, clear // from master_merge.do
 
g eq_med = 1 - CLTV_p50/100 // median equity -- new variable of interest

xtset msa datem
format datem %tm

merge m:1 msa using temp/ARMdecrease0809_remain_in.dta, nogen keep(1 3) // from above
merge m:1 msa using temp/ARMdecrease0809_all.dta, nogen keep(1 3)


twoway (scatter arm_share eq_med if datem==m(2008m11) [aw=pop2008], msize(small) m(oh)) ///
(lfit arm_share eq_med if datem==m(2008m11) [aw=pop2008]), xtitle("Median Equity Share, Nov 2008") ytitle("ARM Share among Outstanding Loans, Nov 2008") legend(off)

reg arm_share eq_med if datem==m(2008m11) [aw=pop2008], rob

g ARMwlargeratedecrease_share_all       = arm_share  * ARM_largeratedecrease_all

// decrease of 1% or more
twoway (scatter ARMwlargeratedecrease_share_all eq_med if datem==m(2008m11) [aw=pop2008], msize(small) m(oh)) /// 
          (lfit ARMwlargeratedecrease_share_all eq_med if datem==m(2008m11) [aw=pop2008]), legend(off) ///
xtitle("Median Equity Share, Nov 2008") ytitle("Fraction of mortgages that are ARMs and experience rate" "reduction of 1 ppt or more between Nov 2008 and June 2009", size(small))

reg ARMwlargeratedecrease_share_all eq_med if datem==m(2008m11) [aw=pop2008], rob

// for comparison:
xtset msa datem
gen refi_prop_6m = f2.refi_prop_bw + f3.refi_prop_bw + f4.refi_prop_bw + f5.refi_prop_bw + f6.refi_prop_bw + f7.refi_prop_bw 

reg refi_prop_6m eq_med if datem==m(2008m11) [aw=pop2008], rob

