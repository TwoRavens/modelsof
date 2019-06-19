clear
set mem 200m
set matsize 700
set more off

use "c:\data\gini.dta"

replace biasrel=biasrel/100

gen inv_corrterm=((groups^2)-1)/(groups^2)
gen inv_gini=12/gini

for any Austria Belgium Denmark Finland France Germany Greece Italy Luxembourg Netherlands Portugal Spain Sweden UK US: gen inv_gini_X=0 \ replace /*
	*/ inv_gini_X=inv_gini if country=="X"

for num 50/2: gen inv_gini_num_X=0 \ replace inv_gini_num_X=inv_gini if groups==X

***DO REGRESSIONS CHECKING THE DIFFERENCE IN BIAS***

log using "c:\data\bias_regressions.log", replace

constraint 1 inv_corrterm=1
cnsreg biasrel inv_corrterm inv_gini_num_*, noconstant robust constraints(1)
quietly {
	predict temp
	sum temp
	local temp3=r(Var)
	sum biasrel
	local temp4=r(Var)
	replace temp=temp^2
	sum temp
	local temp=r(sum)
	replace temp=biasrel^2
	sum temp
	local temp2=r(sum)
	drop temp
}
di as text "uncentered R2=" as result `temp'/`temp2'
di as text "R2=" as result `temp3'/`temp4'

log close
