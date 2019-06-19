local p = 100 /* # integration rounds */
local w = 20 /* support for integration */
local w = 20 /* range of integration */
local p = 100 /* no of steps */
local r = `w'/2 /* upper limit of integration for epsilon */
gen z = `w'/`p' /* z = the step in the integration, `p'*`z' = `w' has to hold */
gen xbs = ess1 /* xb - note that lnhaettu = ln(haet_kust)+ln(1-s_H) */
gen q = xbs-ytheta+lnlnes  /* creation of q used in nu0<=q+crh*e and e>nu-q, note that crh<0*/
gen xi = .
gen cdf_xi = .
local i=0
while `i'<`p'+1 {
	local i1 = `i'-1
	replace xi = -`r'+`i'*z
	gen prob_xi_`i' = . /* prob(xi=xi_i) */
	replace prob_xi_`i' = (z/2)*(normalden((xi-0.5*z),0,csig_nu)+normalden((xi+0.5*z),0,csig_nu)) if hakija ==1
	if xi>q replace prob_xi_`i'=0
	gen cdf_x`i' = .
	replace cdf_x`i' = prob_xi_`i'
	if `i'>0 replace cdf_x`i' = cdf_x`i' + cdf_x`i1'
	
	gen prob_3a_`i'=. /* hakukust*prob(xi=xi_i) */
	replace prob_3a_`i' = (exp(ytheta+e+xi))*prob_xi_`i' if hakija ==1
	replace prob_3a_`i' = cond(`i'>0, (prob_3a_`i' + prob_3a_`i1'), prob_3a_`i')

	if `i'>0 drop prob_3a_`i1' prob_xi_`i1' cdf_x`i1' 
	local i = `i'+1
}

local p = 100


gen f3unc`p'_hak=. /* application costs e=ehat */
replace f3unc`p'_hak = prob_3a_`p'/cdf_x`p'

gen f1unc`p'_hak=. /* prof w/o s e=ehat */
replace f1unc`p'_hak= (xbs+e-1)*exp(xbs+e) if hakija==1

gen f2unc`p'_hak=. /* mprof e=ehat  */

replace f2unc`p'_hak= exp(xbs+e) if hakija==1

gen f4unc`p'_hak=. /* net profits with es*prob(xi=xi_i) */

replace f4unc`p'_hak = exp(xbs+e)*(lnes)- f3unc`p'_hak if hakija ==1

gen f5unc`p'_hak=. /* increase in gross profits due to es */
replace f5unc`p'_hak = exp(xbs+e)*lnes if hakija ==1

gen f6unc`p'_hak=. /* increase in net profits due to s */
replace f6unc`p'_hak = -ln(1-tukint)*exp(xbs+e)-f3unc`p'_hak if hakija ==1

gen f7unc`p'_hak=. /* increase in gross profit due to s */
replace f7unc`p'_hak = exp(xbs+e)*(-ln(1-tukint)) if hakija ==1

gen f8unc`p'_hak=. /* private rate of return w/o s */
replace f8unc`p'_hak = (xbs+e-1) if hakija ==1

gen f9unc`p'_hak=. /* private gross rate of return with es */
replace f9unc`p'_hak = (1-es_i)*(xbs+e+lnes-1) if hakija ==1

gen f10unc`p'_hak=. /* private gross rate of return with s */
replace f10unc`p'_hak = (1-tukint)*(xbs+e-ln(1-tukint)-1) if hakija ==1

gen f11unc`p'_hak=. /* private net rate of return with es */
replace f11unc`p'_hak = (1-es_i)*(xbs+e+lnes-1)-(f3unc`p'_hak)/exp(xbs+e) if hakija ==1

gen f12unc`p'_hak=. /* private net rate of return with s */
replace f12unc`p'_hak = ((1-tukint)*(xbs+e-ln(1-tukint)-1)-(f3unc`p'_hak)/exp(xbs+e)) if hakija ==1

drop z xbs q xi cdf_xi prob_3a_100 cdf_x100 prob_xi_100


