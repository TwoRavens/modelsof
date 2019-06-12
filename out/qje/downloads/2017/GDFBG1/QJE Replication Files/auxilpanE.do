*This program assumes that the following macros are defined: ${key} ${row}, ${col}, ${pan}, ${varlist}, ${Vt} (true variance), ${Vols} OLS variance*
*Equations are formatted as columns, so different coefficients are placed in different rows. (${row},${col}) is the starting position of the 1st coef*
*This program produces the following variables for each member of the varlist: ${b_${row}_${col}_${pan}}, ${se_${row}_${col}_${pan}}, ${seo_${row}_${col}_${pan}}*

if $key==1 {
global V1 ${Vt}
run RDstd 
foreach w of varlist $varlist {
global w `w'
global se_${w}_${col}_${pan}=${S`w'}
}

if $key==2 {
global V1 ${Vols}
est res M
run RDstd 
foreach w of varlist $varlist {
global w `w'
global seo_${w}_${col}_${pan}=${S`w'}
}
}
}

*est res M
if "$varlist"!="" {
foreach w in $varlist {
global w `w'
global b_${w}_${col}_${pan}=_b[`w']
if $key==0 {
global se_${w}_${col}_${pan}=_se[`w']
}
if $log==1 & ("$w"!="$lvar" | "$lvar"=="") {
global b_${w}_${col}_${pan}=${b_${w}_${col}_${pan}}
global se_${w}_${col}_${pan}=${se_${w}_${col}_${pan}}
cap mat def A=e(ci_percentile)
cap mat def l=A[1,"${w}".."${w}"]
cap global lb_${w}_${col}_${pan}=l[1,1]
cap mat def u=A[2,"${w}".."${w}"]
cap global ub_${w}_${col}_${pan}=u[1,1]
}
global pv=2*(1-normal(abs(${b_${w}_${col}_${pan}}/${se_${w}_${col}_${pan}})))
global a_${w}_${col}_${pan} "`=cond($pv>0.1,"",cond($pv>0.05,"*",cond($pv>0.01,"**","***")))'"
}
}

