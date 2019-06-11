*********************************************************
*Winzorize Program
*********************************************************
capture program drop winzorize

program winzorize
syntax, var(varname) pct(int)

summ `var', d
if `pct'==1{
replace `var'=r(p99) if (`var'>r(p99) & `var'!=. & `var'!=0)
summ `var', d
replace `var'=r(p1) if (`var'<r(p1) & `var'!=. & `var'!=0)
}
if `pct'==5{
replace `var'=r(p95) if (`var'>r(p95) & `var'!=. & `var'!=0)
summ `var', d
replace `var'=r(p5) if (`var'<r(p5) & `var'!=. & `var'!=0)
}
if `pct'==10{
replace `var'=r(p90) if (`var'>r(p90) & `var'!=. & `var'!=0)
summ `var', d
replace `var'=r(p10) if (`var'<r(p10) & `var'!=. & `var'!=0)
}
if (`pct'!=1 & `pct'!=5&  `pct'!=10) {
disp "pct invalid. Use pct equals 1, 5, or 10."
}  
end
