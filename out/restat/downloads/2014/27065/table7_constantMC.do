clear all
set more off

infile v1 v2 v3 v4 v5 using dif1.raw
save dif1, replace

log using table7_constantMC.log, replace

mata:

function est00(transmorphic M,
                    real rowvector b,
                    real colvector f)
{
	real colvector p
	p = moptimize_util_xb(M, b, 1)
	f = (p:<0):*p:^2
}

M = moptimize_init()
moptimize_init_which(M, "min")
moptimize_init_evaluator(M, &est00())
varnames = "v1 v2 v3 v4 v5"

moptimize_init_eq_indepvars(M, 1, varnames)
moptimize_init_eq_cons(M, 1, "off")
moptimize_init_search(M,"off")
moptimize_init_conv_maxiter(M,1000)

Cc = (1,0,0,0,0,1)

moptimize_init_constraints(M, Cc)

moptimize(M)
moptimize_result_display(M)

b0 = moptimize_result_eq_coefs(M)
Y = moptimize_util_xb(M, b0, 1)
fn = Y:>0
sumfn = colsum(fn)
sumfn

cond_satisfied = 100*sumfn/1360
cond_satisfied

b = b0'
st_matrix("b3",b)

end

clear 
mat list b3

svmat b3
outsheet b3 using dynamic_params1.txt, nonames replace

log close
