clear
clear matrix
clear mata
discard
program drop _all
program drop _allado

set mem 200m
set matsize 5000
set maxvar 30000
set more off

local J = 500
local I = 2

local sig_x = 3
local rho_x = 0.9

local sig_eps = 3
local rho_eps = 0.9

local v_w = 1
local v_n = 0.5

/* Put ID to have 1/2 of units treated and J for 1/2 of cluster treated (all units in the same cluster are treated) */
local treat = "j"

local N = `I'*`J'
set obs `N'
gen id = _n
gen j = ceil(id/`I')
bysort j: gen i = _n

/* gen t = mod(`treat',2) */
gen t = (j <=`J'/2)

gen double x_cluster = rnormal()
replace x_cluster = . if i > 1
replace x_cluster = x_cluster[_n-1] if x_cluster == .
gen double x_unit = rnormal()
gen double x = `sig_x'*(sqrt(`rho_x')*x_cluster + sqrt(1 - `rho_x')*x_unit)

gen double eps_cluster = rnormal()
replace eps_cluster = . if i > 1
replace eps_cluster = eps_cluster[_n-1] if eps_cluster == .
gen double eps_unit = rnormal()
gen double eps = `sig_eps'*(sqrt(`rho_eps')*eps_cluster + sqrt(1 - `rho_eps')*eps_unit)

gen double eta = rnormal(0,sqrt(`v_n'))
replace eta = . if i > 1
replace eta = eta[_n-1] if eta == .
gen double omega = rnormal(0,sqrt(`v_w'))

*gen double y = t*x + eta + omega
gen double y = t*x + eps

nnmatch_wcluster y t x, rob(1)
nnmatch_wcluster y t x, rob(1) pop
nnmatch_wcluster y t x, cluster(j)
nnmatch_wcluster y t x, cluster(j) pop keep(tau_match) keephet(v_match) replace

keep id i j x t y
save adi_data, replace

end
