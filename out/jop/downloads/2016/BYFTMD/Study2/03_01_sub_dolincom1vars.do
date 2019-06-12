
 unab temp : `var2'
 local var2 = "`temp'"

 local t2 : variable label `var2'
 if "`var1'"=="-" {
  local t1= "minus "
 }
 else {
  local t1 = ""
 }
 
 qui lincom `var1'`var2'
 local fx = `r(estimate)'
 local tstat = abs(`r(estimate)'/`r(se)')
 local pvalue=ttail(`r(df)',`tstat')*2
 
 *di "`model';`t1'`t2';`r(estimate)';`r(se)';`pvalue'"
 file write myfile "`model';`t1'`t2';`r(estimate)';`r(se)';`pvalue'" _n
 