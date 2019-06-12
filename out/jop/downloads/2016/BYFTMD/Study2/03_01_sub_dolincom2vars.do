
 unab temp : `var1'
 local var1 = "`temp'"
 unab temp : `var2'
 local var2 = "`temp'"

 local t1 : variable label `var1'
 local t2 : variable label `var2'
 qui lincom  `var1' -`var2'
 local fx = `r(estimate)'
 local tstat = abs(`r(estimate)'/`r(se)')
 local pvalue=ttail(`r(df)',`tstat')*2
 *di "`model';`t1' minus `t2';`r(estimate)';`r(se)';`pvalue'"
 file write myfile "`model';`t1' minus `t2';`r(estimate)';`r(se)';`pvalue'" _n
