mata:

mata matuse Bmatrix1c, replace

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

cond_satisfied = sumfn
cond_satisfied

b = b0

B = (B\b)
//st_matrix("b3",b)

mata matsave Bmatrix1c B, replace

mata clear

end
