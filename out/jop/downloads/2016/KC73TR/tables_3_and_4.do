use data\QCEW_data, clear


*Table 3

*QCEW
         *we have slightly fewer data points for unemployment so run unemployment first to restrict the sample
         reg dem_pct2  daunemployment_change dem_pct2_lag i.year [aw=totalvote] , cluster(fips)
  reg dem_pct2 dem_pct2_lag c.index_simple_dv_inc i.year if e( sample)==1 [aw=totalvote], cluster(fips)
    	outreg2 using results/table_3, replace word auto(2) se 
  areg dem_pct2  c.index_simple_dv_inc dem_pct2_lag  pc_income_1988* i.year if e( sample)==1 [aw=totalvote], absorb(name_state) cluster(fips)
    	outreg2 using results/table_3, append word auto(2) se
  areg dem_pct2  c.index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year if e( sample)==1 [aw=totalvote], absorb(name_state) cluster(fips)
    	outreg2 using results/table_3, append word auto(2) se
*BLS unemployment
  areg dem_pct2  daunemployment_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e( sample)==1, absorb(name_state) cluster(fips)
    	outreg2 using results/table_3, append word auto(2) se
*SAIPE income
  areg dem_pct2  daincome_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
    	outreg2 using results/table_3, append word auto(2) se
		
		
*Table 4

*QCEW Column 1		
use data\QCEW_data, clear
capture file close myfile
file open myfile using results/table_4_col_1.rtf, write replace
file write myfile _tab "Effect of employment plus wage growth (SE)" _n 
   areg dem_pct2  index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
   areg dem_pct2  daincome_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
   areg dem_pct2  daunemployment_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
areg dem_pct2  index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips) 
  	file write myfile %9s "All estimated in same sample" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 

file write myfile "A." _tab  _n 
  local largest = 0
  foreach i of num 1992(4)2012 {
   areg dem_pct2 index_simple_dv_inc dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic i.year if year!=`i' [aw=totalvote], absorb(name_state) cluster(fips) 
   if _b[index_simple_dv_inc] > `largest' {
     local largest = _b[index_simple_dv_inc]
	 local largest_se = _se[index_simple_dv_inc]
     }
   }
   file write myfile %9s "Largest effect excluding election individually and reestimating" _tab %7.1f (`largest') "(" %-1.3g (`largest_se') ")"  _n 
  local smallest = 1000
  foreach i of num 1992(4)2012 {
   areg dem_pct2 index_simple_dv_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year if year!=`i' [aw=totalvote], absorb(name_state) cluster(fips) 
   if _b[index_simple_dv_inc] < `smallest' {
     local smallest = _b[index_simple_dv_inc]
	 local smallest_se = _se[index_simple_dv_inc]
     }
   }
   file write myfile %9s "Smallest effect excluding election individually and reestimating" _tab %7.1f (`smallest') "(" %-1.3g (`smallest_se') ")"  _n 
file write myfile _tab  _n 
file write myfile "B. Controlling for Additional Variables" _tab  _n 
  areg dem_pct2 c.index_simple_dv_inc i.year#c.dem_pct2_lag  i.year#c.pc_income_1988 i.year#c.percent_black i.year#c.percent_white i.year#c.percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "All controls interacted with election-year indicators" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc l4.annual_wage c.dem_pct2_lag pc_income_1988*  lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With lagged annual wage" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc l4.annual_wage l4.annual_wage_2 l4.annual_wage_3  c.dem_pct2_lag pc_income_1988*  lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With lagged annual wage, squared, and cubed" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
 areg dem_pct2 index_simple_dv_inc pop_change c.dem_pct2_lag pc_income_1988* lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With population growth" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile _tab  _n 
file write myfile "C. Dropping Smaller Counties and Not Using Weights" _tab  _n 
  areg dem_pct2 index_simple_dv_inc  c.dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year if totalvote>25000, absorb(name_state) cluster(fips) 
  	file write myfile %9s "Counties with 25,000 voters or more (no weights)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc  c.dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic i.year if totalvote>50000, absorb(name_state) cluster(fips) 
  	file write myfile %9s "Counties with 50,000 voters or more (no weights)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile _tab  _n 
file write myfile "D. Varying the Economic Measure" _tab  _n 
  *areg dem_pct2 i.fips#c.year c.index_simple_inc dem_pct2_lag  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  areg dem_pct2 c.index_simple_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "Employment plus wages not deviated" _tab %7.1f (_b[index_simple_inc]) "(" %-1.3g (_se[index_simple_inc]) ")"  _n 
  areg dem_pct2 emp_growth6_dv_inc dem_pct2_lag  pc_income_1988*  percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "Employment growth" _tab %7.1f (_b[emp_growth6_dv_inc]) "(" %-1.3g (_se[emp_growth6_dv_inc]) ")"  _n 
  areg dem_pct2 wage_growth6_dv_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "Wage growth" _tab %7.1f (_b[wage_growth6_dv_inc]) "(" %-1.3g (_se[wage_growth6_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple1yr_dv_inc  dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Wage employment growth avg. for one year before Election" _tab %7.1f (_b[index_simple1yr_dv_inc]) "(" %-1.3g (_se[index_simple1yr_dv_inc]) ")"  _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s "E is. Placebo Tests Using Post-Election Economy Measure" _tab   _n 
   areg dem_pct2 index_simple_dv_f1_inc dem_pct2_lag  pc_income_1988*  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Regression from Table 3, Column 2" _tab %7.1f (_b[index_simple_dv_f1_inc]) "(" %-1.3g (_se[index_simple_dv_f1_inc]) ")"  _n 
   areg dem_pct2 index_simple_dv_f1_inc dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Regression from Table 3, Column 3" _tab %7.1f (_b[index_simple_dv_f1_inc]) "(" %-1.3g (_se[index_simple_dv_f1_inc]) ")"  _n 
file close myfile 

*Unemployment column 2
use data\QCEW_data, clear
   *these set the sample for the first regression
   areg dem_pct2  c.index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
   areg dem_pct2  daincome_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
replace index_simple_dv_f1_inc=fdaunemployment_change
replace index_simple_dv_inc=daunemployment_change
replace index_simple_inc=dunemployment_change
capture file close myfile
file open myfile using results/table_4_col_2.rtf, write replace
file write myfile _tab "Effect of employment plus wage growth (SE)" _n 
   areg dem_pct2  daunemployment_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
   areg dem_pct2  index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
	file write myfile %9s "All controls interacted with election-year indicators" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile "A." _tab  _n 
  local largest = 0
  foreach i of num 1992(4)2012 {
   areg dem_pct2 index_simple_dv_inc dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic i.year if year!=`i' [aw=totalvote], absorb(name_state) cluster(fips) 
   if _b[index_simple_dv_inc] < `largest' {
     local largest = _b[index_simple_dv_inc]
	 local largest_se = _se[index_simple_dv_inc]
     }
   }
   file write myfile %9s "Largest effect excluding election individually and reestimating" _tab %7.1f (`largest') "(" %-1.3g (`largest_se') ")"  _n 
  local smallest = 1000
  foreach i of num 1992(4)2012 {
   areg dem_pct2 index_simple_dv_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year if year!=`i' [aw=totalvote], absorb(name_state) cluster(fips) 
   if _b[index_simple_dv_inc] < abs(`smallest') {
     local smallest = _b[index_simple_dv_inc]
	 local smallest_se = _se[index_simple_dv_inc]
     }
   }
   file write myfile %9s "Smallest effect excluding election individually and reestimating" _tab %7.1f (`smallest') "(" %-1.3g (`smallest_se') ")"  _n 
file write myfile _tab  _n 
file write myfile "B. Controlling for Additional Variables" _tab  _n 
  areg dem_pct2 c.index_simple_dv_inc i.year#c.dem_pct2_lag  i.year#c.pc_income_1988 i.year#c.percent_black i.year#c.percent_white i.year#c.percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "All controls interacted with election-year indicators" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc l4.annual_wage c.dem_pct2_lag pc_income_1988*  lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With lagged annual wage" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc l4.annual_wage l4.annual_wage_2 l4.annual_wage_3  c.dem_pct2_lag pc_income_1988*  lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With lagged annual wage, squared, and cubed" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
 areg dem_pct2 index_simple_dv_inc pop_change c.dem_pct2_lag pc_income_1988* lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With population growth" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile _tab  _n 
file write myfile "C. Dropping Smaller Counties and Not Using Weights" _tab  _n 
  areg dem_pct2 index_simple_dv_inc  c.dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year if totalvote>25000, absorb(name_state) cluster(fips) 
  	file write myfile %9s "Counties with 25,000 voters or more (no weights)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc  c.dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic i.year if totalvote>50000, absorb(name_state) cluster(fips) 
  	file write myfile %9s "Counties with 50,000 voters or more (no weights)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile _tab  _n 
file write myfile "D. Varying the Economic Measure" _tab  _n 
  *areg dem_pct2 i.fips#c.year c.index_simple_inc dem_pct2_lag  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  areg dem_pct2 c.index_simple_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "not deviated" _tab %7.1f (_b[index_simple_inc]) "(" %-1.3g (_se[index_simple_inc]) ")"  _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s "E is. Placebo Tests Using Post-Election Economy Measure" _tab   _n 
   areg dem_pct2 index_simple_dv_f1_inc dem_pct2_lag  pc_income_1988*  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Regression from Table 3, Column 2" _tab %7.1f (_b[index_simple_dv_f1_inc]) "(" %-1.3g (_se[index_simple_dv_f1_inc]) ")"  _n 
   areg dem_pct2 index_simple_dv_f1_inc dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Regression from Table 3, Column 3" _tab %7.1f (_b[index_simple_dv_f1_inc]) "(" %-1.3g (_se[index_simple_dv_f1_inc]) ")"  _n 
file close myfile 


*Income column 3
use data\QCEW_data, clear
   areg dem_pct2  c.index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
   areg dem_pct2  daincome_change dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
replace index_simple_dv_f1_inc=fdaincome_change
replace index_simple_dv_inc=daincome_change
replace index_simple_inc=dincome_change
capture file close myfile
file open myfile using results/table_4_col_3.rtf, write replace
file write myfile _tab "Effect of employment plus wage growth (SE)" _n 
areg dem_pct2  index_simple_dv_inc dem_pct2_lag  pc_income_1988* percent_black percent_white percent_hispanic i.year [aw=totalvote] if e(sample) == 1, absorb(name_state) cluster(fips)
  	file write myfile %9s "All estimated in same sample (2000-2012)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile "A." _tab  _n 
  local largest = 0
  foreach i of num 1992(4)2012 {
   areg dem_pct2 index_simple_dv_inc dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic i.year if year!=`i' [aw=totalvote], absorb(name_state) cluster(fips) 
   if _b[index_simple_dv_inc] > `largest' {
     local largest = _b[index_simple_dv_inc]
	 local largest_se = _se[index_simple_dv_inc]
     }
   }
   file write myfile %9s "Largest effect excluding election individually and reestimating" _tab %7.1f (`largest') "(" %-1.3g (`largest_se') ")"  _n 
  local smallest = 1000
  foreach i of num 1992(4)2012 {
   areg dem_pct2 index_simple_dv_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year if year!=`i' [aw=totalvote], absorb(name_state) cluster(fips) 
   if _b[index_simple_dv_inc] < `smallest' {
     local smallest = _b[index_simple_dv_inc]
	 local smallest_se = _se[index_simple_dv_inc]
     }
   }
   file write myfile %9s "Smallest effect excluding election individually and reestimating" _tab %7.1f (`smallest') "(" %-1.3g (`smallest_se') ")"  _n 
file write myfile _tab  _n 
file write myfile "B. Controlling for Additional Variables" _tab  _n 
  areg dem_pct2 c.index_simple_dv_inc i.year#c.dem_pct2_lag  i.year#c.pc_income_1988 i.year#c.percent_black i.year#c.percent_white i.year#c.percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s "All controls interacted with election-year indicators" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc l4.annual_wage c.dem_pct2_lag pc_income_1988*  lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With lagged annual wage" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc l4.annual_wage l4.annual_wage_2 l4.annual_wage_3  c.dem_pct2_lag pc_income_1988*  lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With lagged annual wage, squared, and cubed" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
 areg dem_pct2 index_simple_dv_inc pop_change c.dem_pct2_lag pc_income_1988* lnpop1990 percent_black percent_white percent_hispanic i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "With population growth" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile _tab  _n 
file write myfile "C. Dropping Smaller Counties and Not Using Weights" _tab  _n 
  areg dem_pct2 index_simple_dv_inc  c.dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic i.year if totalvote>25000, absorb(name_state) cluster(fips) 
  	file write myfile %9s "Counties with 25,000 voters or more (no weights)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
  areg dem_pct2 index_simple_dv_inc  c.dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic i.year if totalvote>50000, absorb(name_state) cluster(fips) 
  	file write myfile %9s "Counties with 50,000 voters or more (no weights)" _tab %7.1f (_b[index_simple_dv_inc]) "(" %-1.3g (_se[index_simple_dv_inc]) ")"  _n 
file write myfile _tab  _n 
file write myfile "D. Varying the Economic Measure" _tab  _n 
  *areg dem_pct2 i.fips#c.year c.index_simple_inc dem_pct2_lag  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  areg dem_pct2 c.index_simple_inc dem_pct2_lag pc_income_1988*  percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips)
  	file write myfile %9s " not deviated" _tab %7.1f (_b[index_simple_inc]) "(" %-1.3g (_se[index_simple_inc]) ")"  _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s " " _tab   _n 
  file write myfile %9s "E is. Placebo Tests Using Post-Election Economy Measure" _tab   _n 
   areg dem_pct2 index_simple_dv_f1_inc dem_pct2_lag  pc_income_1988*  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Regression from Table 3, Column 2" _tab %7.1f (_b[index_simple_dv_f1_inc]) "(" %-1.3g (_se[index_simple_dv_f1_inc]) ")"  _n 
   areg dem_pct2 index_simple_dv_f1_inc dem_pct2_lag pc_income_1988* percent_black percent_white percent_hispanic  i.year [aw=totalvote], absorb(name_state) cluster(fips) 
  	file write myfile %9s "Regression from Table 3, Column 3" _tab %7.1f (_b[index_simple_dv_f1_inc]) "(" %-1.3g (_se[index_simple_dv_f1_inc]) ")"  _n 
file close myfile 
