
local N = 21

if ("`2'" != "") {
 local N = `2'
}

local absorbVariable = "$absorbVariable"
local instrument = "$instrument"

di "================"
di "RESULTS: `1' ..." 
di "================"
** add hetero-robustness ...
predict ee, resid
di "N_g: $N_g"
summ ee
replace ee = ee*ee
summ ee
mat Ei = J($N_g, $N_g, 0)
capture drop wgt
gen wgt = .
forvalues g = 1(1)$N_g {
 qui summ ee if `absorbVariable' == `g'
 local res = 1 / r(mean)
 ** qui replace wgt = `res' if  `absorbVariable' == `g'
 mat Ei[`g', `g'] = `res'
}
keep log_`1' log_payroll `instrument' _I* cons
order log_payroll log_`1' `instrument' _I* cons
mata
data = st_data(., .)
payroll = data[1..., 1]
y = data[1..., 2]
inst = data[1..., 3]
cols = cols(data)
fes = data[1..., 4..cols]
X = (payroll, fes)
Z = (inst, fes)
Ei = st_matrix("Ei")
i = I(`N')
O = i # Ei
V = invsym(X'*O*Z*invsym(Z'*O*Z)*Z'*O*X)
betas_iv = V * (X'*O*Z*invsym(Z'*O*Z)*Z'*O*y)
sd = sqrt(diagonal(V))
results = (betas_iv, sd)
results = results[1,1...]
results
pval = 2*ttail(rows(X) - cols(X), abs(results[1,1] / results[1,2]))
pval
N = rows(X)
N
end
