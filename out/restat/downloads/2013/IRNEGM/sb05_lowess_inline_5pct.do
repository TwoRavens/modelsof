
local bwidth = .05
drop if emp_growth_rate==. | avgemp==.
count

sum freq_weight, meanonly
local total_obs = `r(sum)'

local k = floor((`total_obs'*`bwidth'-0.5)/2)

display "total obs=`total_obs'; k=`k'"

sort avgemp
gen double index=sum(freq_weight)
gen double index_min=index-freq_weight
gen double index_avg=(index_min+index)/2
gen y_hat = .

count
local count_x = `r(N)'
forvalues n = 1/`count_x' {

*or subtract current from index.  "replace index=index-freq_weight"
local xi = avgemp[`n']
local i_min = max(1,index_avg[`n']-`k')
local i_max = min(index_avg[`n']+`k',`total_obs')

display "xi=`xi'; i_min=`i_min'; i_max=`i_max'"

sum avgemp if `i_min'>index_min & `i_min'<=index, meanonly
local xi_min = `r(sum)'
sum avgemp if `i_max'>=index_min & `i_max'<index, meanonly
local xi_max = `r(sum)'

if `xi_min'~=`xi_max' {
gen freq_weight2=freq_weight
replace freq_weight2=`i_max'-index_min if avgemp==`xi_max'
replace freq_weight2=index-`i_min'+1 if avgemp==`xi_min'

local delta = 1.0001*max(`xi_max' - avgemp[`n'], avgemp[`n'] - `xi_min')

display "xi_min=`xi_min'; xi_max=`xi_max'; delta=`delta'"

gen wj= freq_weight2*((1-(abs(avgemp-`xi')/`delta')^3)^3)

sum emp_growth_rate [weight=wj] if wj>0, meanonly
replace y_hat = `r(mean)' in `n'
drop wj freq_weight2
}

else {
display "xi_min=`xi_min'; xi_max=`xi_max';"

replace y_hat = emp_growth_rate in `n' 
}

}

* title("Net job creation rate, by establishment size (10% bandwidth)")

format avgemp %9.0gc
replace y_hat = y_hat*100

