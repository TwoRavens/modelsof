*Preliminaries
clear all
set more off
log using tables5and6.log, replace

*Load data
use firm-level.dta 
rename pat_app x
drop pat_grant
drop if year<1982

*Generate firm id's such that id of "OTHER" is 0
egen id=group(firm) if firm~="OTHER"
replace id=0 if id==.

*Generate relative sales and prices
gen sales_other0 = sales if firm == "OTHER"
egen sales_other = total(sales_other0), by(year)
drop sales_other0

gen price_other0 = price if firm == "OTHER"
egen price_other = total(price_other0), by(year)
drop price_other0

gen rel_mkt_sh = log(sales/sales_other)
gen rel_price = price - price_other

*Generate xi's under three assumptions:
*	1. Constant marginal cost 		(alpha = -0.3025)
*	2. Linear marginal cost 		(alpha = -0.3540; gamma0 = 7.8250; gamma1 = 1.3760)
*	3. Exponential marginal cost 	(alpha = -0.2216; gamma0 = 3.3509; gamma1 = 0.2851)
*These numbers may change

scalar alpha1 = -0.3025
scalar alpha2 = -0.3540
scalar alpha3 = -0.2216

*I am setting gamma0_1 and gamma0_2 equal to 0 because we do not need them in forward simulations
scalar gamma0_1 = 0
scalar gamma0_2 = 0 // gamma0_3 is generated below

scalar gamma1_1 = 0
scalar gamma1_2 = 1.3760 
scalar gamma1_3 = 0.2851

*Generate xi's
for num 1/3: gen xiX0 = rel_mkt_sh - alphaX*rel_price

quietly tabulate year, gen(yr)
quietly tabulate firm, gen(ii)

*Adjust xi's for firm- and year- fixed effects then readjust to make xi(OTHER)=0
forvalues j = 1/3{
	quietly reg xi`j'0 yr* ii*
	predict unadj_xi`j', residuals 
	gen xi_adj`j' = unadj_xi`j' if firm=="OTHER"
	egen xi_adjb`j' = sum(xi_adj`j'), by(year)
	gen xi`j' = unadj_xi`j'-xi_adjb`j'
	drop xi_adj`j' xi_adjb`j'
}

*Compare various xi's
sum xi* unadj_xi*
correlate xi* unadj_xi*

/*Generate the Constant in the MC function as suggested by Jo.
We only need it when marginal cost is exponential. For the other two cases,
the constant terms cancel out when we construct relative prices pj-p0*/
egen   Tsales=sum(sales), by(year)
gen    share=sales/Tsales
gen mc = price + ( 1/(alpha3*(1-share)) )
gen const = log(mc) - gamma1_3*xi30
reg const yr* ii*
scalar gamma0_3 = _b[_cons]
scalar list
gen zeta = log(mc) - gamma0_3 - gamma1_3*xi3
sum zeta
sum zeta if firm=="OTHER"
gen zeta_other0 = zeta if firm == "OTHER"
egen zeta_other = total(zeta_other0), by(year)
gen rel_zeta = zeta - zeta_other
sum rel_zeta


*create text files containing demand and MC parameters
forvalues j = 1/3{
	matrix ddmc`j' = (alpha`j'\gamma0_`j'\gamma1_`j')
	svmat ddmc`j'
	outsheet ddmc`j' using ddmc_params`j'.txt, nonames replace
}

drop xi10 xi20 xi30 
drop yr* ii*

*Generate dxi
foreach xi in xi1 xi2 xi3{
	bysort firm (year): gen `xi'_lag = `xi'[_n-1]
	gen d`xi' = `xi' - `xi'_lag
	gen `xi'_lag_sq = `xi'_lag^2
}

gen logx = log(1+x)

drop if firm=="OTHER"

*Preliminary regressions
for num 1/3: regress dxiX logx xiX_lag xiX_lag_sq

/* I wrote the following codes to `endogenously' choose the step size. Now that 
we have settled or demand and MC estiamtes, a step size of 0.2 seems the 
most reasonable to me. */
foreach xi in xi1 xi2 xi3{
	*quietly sum `xi'
	*scalar `xi'_mean=r(mean)
	*scalar `xi'_sd=r(sd)
	*scalar `xi'_upr_lmt = `xi'_mean + 3*`xi'_sd
	*scalar `xi'_lwr_lmt = `xi'_mean - 3*`xi'_sd
	*scalar `xi'_vals = 15 /*the number of discrete values that xi can take*/
	*scalar `xi'_step = (`xi'_upr_lmt-`xi'_lwr_lmt)/(`xi'_vals-1)
	scalar `xi'_step = 0.2
	*scalar list
}

/* `up', `stay' and `down' variables will be used to construct the likelihood below.
`up' takes the value one if dxi>xi_step/2. `down' takes the value one if dxi<-xi_step/2.
`stay' takes the value one if dxi is between -xi_step/2 and xi_step/2 */
forvalues j = 1/3{
gen up`j' = 0
replace up`j' = 1 if dxi`j'>(xi`j'_step/2)
gen down`j' = 0
replace down`j' = 1 if dxi`j'<(-xi`j'_step/2)
gen stay`j' = 0
replace stay`j' = 1 if dxi`j'<=(xi`j'_step/2) & dxi`j'>=(-xi`j'_step/2)
count if up`j'==1
count if stay`j'==1
count if down`j'==1
}

*This is the likelihood function
program myLL
	version 10
	args lnf theta1 theta2
	tempvar d p p_u p_d p_s
	quietly gen double `d' = `theta1'
	quietly gen double `p' = exp(-exp(-`theta2'))
	quietly gen double `p_u' = `p'*(1-`d')
	quietly gen double `p_d' = `d'*(1-`p')
	quietly gen double `p_s' = 1-`p_u'-`p_d'
	quietly replace `lnf' = ln(`p_u'*$ML_y1+`p_s'*$ML_y2+`p_d'*$ML_y3)	 
end

forvalues j = 1/3{
	*Define `theta1' and `theta2' for the likelihood function
	ml model lf myLL (up`j' stay`j' down`j' = ) (up`j' stay`j' down`j' = logx xi`j'_lag xi`j'_lag_sq, noconstant), vce(robust)
	*Estimate state-transition parameters by likelihood
	ml maximize
	test xi`j'_lag xi`j'_lag_sq
	mat beta`j' = e(b)'
	mat list beta`j', format(%9.4f)
	svmat beta`j'
	*Save the parameters in a .txt file for later use
	outsheet beta`j' using state_trans_params`j'.txt, nonames replace
	
	/*Use the estimated state-transition parameters and generate
	the probabilities of xi going up, staying the same or going down. 
	Plot these probabilities against x and xi to have a visual idea of how 
	they vary with state and control variables.
	*/
	scalar d`j' = beta`j'[1,1] // d is short for depreciation
	gen p`j' = exp(-exp( -(beta`j'[2,1]*logx+beta`j'[3,1]*xi`j'_lag+beta`j'[4,1]*xi`j'_lag_sq) ))
	gen p_u`j' = p`j'*(1-beta`j'[1,1])
	gen p_d`j' =beta`j'[1,1]*(1-p`j')
	gen p_s`j' = 1 - p_u`j' - p_d`j'
	sum p_u`j' p_s`j' p_d`j'

	reg p_u`j' logx xi`j'_lag xi`j'_lag_sq
	reg p_d`j' logx xi`j'_lag xi`j'_lag_sq
	reg p_s`j' logx xi`j'_lag xi`j'_lag_sq
	/*
	scatter p_u`j' logx, nodraw name(g11_`j')
	scatter p_u`j' x, nodraw name(g12_`j')

	scatter p_s`j' logx, nodraw name(g21_`j')
	scatter p_s`j' x, nodraw name(g22_`j')

	scatter p_d`j' logx, nodraw name(g31_`j')
	scatter p_d`j' x, nodraw name(g32_`j')

	gr combine g11_`j' g12_`j' g21_`j' g22_`j' g31_`j' g32_`j', col(2) xsize(6) ysize(8)
	gr export fig_trans_prob_x_`j'.ps, replace

	scatter p_u`j' xi`j'_lag, nodraw name(g1_`j')
	scatter p_s`j' xi`j'_lag, nodraw name(g2_`j')
	scatter p_d`j' xi`j'_lag, nodraw name(g3_`j')

	gr combine g1_`j' g2_`j' g3_`j', col(1) ysize(8)
	gr export fig_trans_prob_xi_`j'.ps, replace

	gr drop _all
	*/
	*Estimate policy functions
	gen xi`j'_lag_cb = xi`j'_lag^3
	bysort year: egen xi`j'_lag_mean = mean(xi`j'_lag)
	bysort year: egen xi`j'_lag_sd = sd(xi`j'_lag)
	bysort year: egen xi`j'_lag_skew = skew(xi`j'_lag)
	bysort year: egen xi`j'_lag_kurt = kurt(xi`j'_lag)
	bysort year: egen xi`j'_lag_rank = rank(xi`j'_lag)
	bysort year: egen xi`j'_lag_iqr = iqr(xi`j'_lag)
	bysort year: egen xi`j'_lag_max = max(xi`j'_lag)
	
	regress logx xi`j'_lag*
	mat beta_`j' = e(b)'
	mat list beta_`j', format(%9.4f)
	svmat beta_`j'
	outsheet beta_`j' using policy_params`j'.txt, nonames replace
	predict xhat`j'
	test xi`j'_lag xi`j'_lag_sq xi`j'_lag_cb
	correlate xhat`j' logx
	
	*Discrete xi has the range {-1.4,1.4} with increments of 0.2 (the same as xi_step above)
	drop if xi`j'_lag==.
	gen xi`j'_d = 0.2*round(xi`j'_lag/0.2)
	replace xi`j'_d=1.4 if xi`j'_d>1.4
	replace xi`j'_d=-1.4 if xi`j'_d<-1.4
	sum id year xi`j'_lag xi`j'_d
	correlate xi`j'_lag xi`j'_d
	
	outsheet id year xi`j'_d rel_mkt_sh rel_price using data`j'.txt, nonames replace

	}

log close
