** Bartels, Brandon L., and Andrew J. O'Geen. N.d. "The Nature of Legal Change on the U.S. Supreme Court: Jurisprudential Regimes Theory and Its Alternatives."
** American Journal of Political Science

* To replicate the random intercept model in the paper (presented in Table A1), execute these commands. 

* Note: we use gllamm to estimate the model. To install gllamm, type "ssc install gllammm" in the Stata command window. 
* Gllamm has attractive post-estimation features that facilitate generating predicted probabilities (namely, using average partial effects) for these models. 
* Post-estimation procedures are included below. 

* We use adaptive quadrature to estimate the model, which requires one to specify the number integration, or quadrature, points. 

* In order to facilitate convergence, we follow Rabe-Hesketh and Skrondal's advice to start with a low number of quad. points (i.e., 4), then save those results, 
* and estimate another model with a higher number of quadrature points (i.e., 8) that uses the prior model's estimates as start values. Again, save those results
* and estimate a final model with 12 quadrature points that uses the prior model's estimates as start values. Models with even more quadrature points (16 and 20)
* suggest that there's convergence with 12 quadrature points, which is common for this type of model.

* One can also use the "xtlogit" command, which also employs adaptive quadrature, to estimate this model. The default number quadrature points for xtlogit
* is 12. Estimating the model using xtlogit gives the same results as the final gllamm model (with 12 quad. points), which is not surprising given this is
* not a very complicated model.

gllamm mydir mq_med cb cn vin war1 war_g reh cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t) nip(4) l(logit) f(binomial) adapt
mat a=e(b)

gllamm mydir mq_med cb cn vin war1 war_g reh cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t) nip(8) l(logit) f(binomial) adapt from(a)
mat a=e(b)

gllamm mydir mq_med cb cn vin war1 war_g reh cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t) nip(12) l(logit) f(binomial) adapt from(a)
mat a=e(b)

* Generating post-estimation, simulated predicted probabilities from this last gllamm model (with 12 quadrature points)
* Note: The following commands MUST be executed with the above model as the most recently estimated model

* Before running, install the "backup" and "backto" programs by typing, in the command window: 
net from http://home.gwu.edu/~bartels/stata

*Click on both "backup" and "backto" to install

*Create backup versions of the variables which will be replaced below; creates new versions of these variables with "_bkp" extension
backup cb cn vin war1 war_g reh cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh

set obs 1000

*Simulate 1000 estimates, based on model estimates and var-cov matrix; Clarify-like procedure
matrix params=e(b)
matrix P=e(V)
drawnorm b1-b36, means(params) cov(P) double n(1000)

*Generate variables where simulated probabilities will be stored
gen pr_cb_vin_sim=.
gen pr_cn_vin_sim =.
gen pr_lp_vin_sim =.
gen pr_cb_war1_sim =.
gen pr_cn_war1_sim =.
gen pr_lp_war1_sim =.
gen pr_cb_war_g_sim =.
gen pr_cn_war_g_sim =.
gen pr_lp_war_g_sim =.
gen pr_cb_bur_g_sim =.
gen pr_cn_bur_g_sim =.
gen pr_lp_bur_g_sim =.
gen pr_cb_reh_sim =.
gen pr_cn_reh_sim =.
gen pr_lp_reh_sim=.

local i=1
while `i'<=1000 {
	mkmat b1-b36 if _n==`i', matrix(a`i')
	qui replace vin=1
	qui replace war1=0
	qui replace war_g=0
	qui replace reh=0
	qui replace cbXwar1=0 
	qui replace cnXwar1=0 
	qui replace cbXwar_g=0 
	qui replace cnXwar_g=0 
	qui replace cbXreh=0
	qui replace cnXreh=0

	qui replace cb=1
	qui replace cn=0
	qui replace cbXvin=1 
	qui replace cnXvin=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==1
	qui replace pr_cb_vin_sim=r(mean) in `i'
	qui drop prob
	
	qui replace cb=0
	qui replace cn=1
	qui replace cbXvin=0 
	qui replace cnXvin=1
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==1
	qui replace pr_cn_vin_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=0
	qui replace cbXvin=0 
	qui replace cnXvin=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==1
	qui replace pr_lp_vin_sim=r(mean) in `i'
	qui drop prob
	
	qui replace vin=0
	qui replace war1=1
	qui replace war_g=0
	qui replace reh=0
	qui replace cbXvin=0 
	qui replace cnXvin=0 
	qui replace cbXwar_g=0 
	qui replace cnXwar_g=0 
	qui replace cbXreh=0
	qui replace cnXreh=0

	qui replace cb=1
	qui replace cn=0
	qui replace cbXwar1=1 
	qui replace cnXwar1=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==2
	qui replace pr_cb_war1_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=1
	qui replace cbXwar1=0 
	qui replace cnXwar1=1
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==2
	qui replace pr_cn_war1_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=0
	qui replace cbXwar1=0 
	qui replace cnXwar1=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==2
	qui replace pr_lp_war1_sim=r(mean) in `i'
	qui drop prob
	
	qui replace vin=0
	qui replace war1=0
	qui replace war_g=1
	qui replace reh=0
	qui replace cbXvin=0 
	qui replace cnXvin=0 
	qui replace cbXwar1=0 
	qui replace cnXwar1=0 
	qui replace cbXreh=0
	qui replace cnXreh=0

	qui replace cb=1
	qui replace cn=0
	qui replace cbXwar_g=1 
	qui replace cnXwar_g=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==3
	qui replace pr_cb_war_g_sim=r(mean) in `i'
	qui drop prob
	
	qui replace cb=0
	qui replace cn=1
	qui replace cbXwar_g=0 
	qui replace cnXwar_g=1
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==3
	qui replace pr_cn_war_g_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=0
	qui replace cbXwar_g=0 
	qui replace cnXwar_g=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==3
	qui replace pr_lp_war_g_sim=r(mean) in `i'
	qui drop prob
	
	qui replace vin=0
	qui replace war1=0
	qui replace war_g=0
	qui replace reh=0
	qui replace cbXvin=0 
	qui replace cnXvin=0 
	qui replace cbXwar1=0 
	qui replace cnXwar1=0 
	qui replace cbXwar_g=0
	qui replace cnXwar_g=0
	qui replace cbXreh=0
	qui replace cnXreh=0

	qui replace cb=1
	qui replace cn=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==4
	qui replace pr_cb_bur_g_sim=r(mean) in `i'
	qui drop prob
	
	qui replace cb=0
	qui replace cn=1
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==4
	qui replace pr_cn_bur_g_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==4
	qui replace pr_lp_bur_g_sim=r(mean) in `i'
	qui drop prob
	
	qui replace vin=0
	qui replace war1=0
	qui replace war_g=0
	qui replace reh=1
	qui replace cbXvin=0 
	qui replace cnXvin=0 
	qui replace cbXwar1=0 
	qui replace cnXwar1=0 
	qui replace cbXwar_g=0
	qui replace cnXwar_g=0

	qui replace cb=1
	qui replace cn=0
	qui replace cbXreh=1 
	qui replace cnXreh=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==5
	qui replace pr_cb_reh_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=1
	qui replace cbXreh=0 
	qui replace cnXreh=1
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==5
	qui replace pr_cn_reh_sim=r(mean) in `i'
	qui drop prob

	qui replace cb=0
	qui replace cn=0
	qui replace cbXreh=0 
	qui replace cnXreh=0
	qui gllapred prob, mu marginal from(a`i')
	qui su prob if timespan==5
	qui replace pr_lp_reh_sim=r(mean) in `i'
	qui drop prob
	qui mat drop a`i'
	
	disp `i'
	local i=`i'+1
}

*Replace variables back to their original versions using "backto" program
backto cb cn vin war1 war_g reh cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh


* Figure 1: To generate predicted probabilities for each juris. category for each CJ timespan, like in Figure 1, simply summarize the simulated probs:
su pr_cb_vin_sim - pr_lp_bur_g_sim

* Note that the probabilities may differ somewhat since they're based on simulations

* Figures 2A and 2B: To generate differences in the probabilities and the standard errors for these differences (which will be the standard deviation when
* summarized, simply generate differences between the simulated probs variables
* e.g., to generate: prob(CB_Warren1) - prob(CB_Vinson), which is the first entry in Figure 2A: 
gen d_war1vin_cb_sim = pr_cb_war1_sim - pr_cb_vin_sim

* e.g., to generate: prob(CB_Vin) - prob(CN_Vin), which is the first entry in Figure 2B: 
gen d_cbcn_vin_sim = pr_cb_vin_sim - pr_cn_vin_sim

*********************************************************************************************************************************
** Results from changing the baseline categories for jurisprudential variable and Chief Justice timespan; replicates results in Table A2

* VINSON (vin is baseline, omitted category for the CJ timespan variable)
* lp is baseline for juris variable; coeff. for cb thus represents "CB (relative to LP)" in Table A2; coeff. for cn represents "CN (relative to LP)"
xtlogit mydir mq_med cb cn war1 war_g bur_g reh cbXbur_g cnXbur_g cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* cn is baseline category; coeff. for cb represents "CB (relative to CN)"
xtlogit mydir mq_med cb lp war1 war_g bur_g reh cbXbur_g lpXbur_g cbXwar1 lpXwar1 cbXwar_g lpXwar_g cbXreh lpXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* WARREN 1 (war1 is baseline category for CJ timespan variable)
* lp is baseline for juris variable; coeff. for cb thus represents "CB (relative to LP)" in Table A2; coeff. for cn represents "CN (relative to LP)"
xtlogit mydir mq_med cb cn vin war_g bur_g reh cbXbur_g cnXbur_g cbXvin cnXvin cbXwar_g cnXwar_g cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* cn is baseline category; coeff. for cb represents "CB (relative to CN)"
xtlogit mydir mq_med cb lp vin war_g bur_g reh cbXbur_g lpXbur_g cbXvin lpXvin cbXwar_g lpXwar_g cbXreh lpXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* WARREN 2 (war_g is baseline category for CJ timespan variable)
* lp is baseline for juris variable; coeff. for cb thus represents "CB (relative to LP)" in Table A2; coeff. for cn represents "CN (relative to LP)"
xtlogit mydir mq_med cb cn vin war1 bur_g reh cbXbur_g cnXbur_g cbXvin cnXvin cbXwar1 cnXwar1 cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* cn is baseline category; coeff. for cb represents "CB (relative to CN)"
xtlogit mydir mq_med cb lp vin war1 bur_g reh cbXbur_g lpXbur_g cbXvin lpXvin cbXwar1 lpXwar1 cbXreh lpXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* BURGER (bur_g is baseline category for CJ timespan variable)
* lp is baseline for juris variable; coeff. for cb thus represents "CB (relative to LP)" in Table A2; coeff. for cn represents "CN (relative to LP)"
xtlogit mydir mq_med cb cn vin war1 war_g reh cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g cbXreh cnXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* cn is baseline category; coeff. for cb represents "CB (relative to CN)"
xtlogit mydir mq_med cb lp vin war1 war_g reh cbXvin lpXvin cbXwar1 lpXwar1 cbXwar_g lpXwar_g cbXreh lpXreh act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* REHNQUIST (reh is baseline category for CJ timespan variable)
* lp is baseline for juris variable; coeff. for cb thus represents "CB (relative to LP)" in Table A2; coeff. for cn represents "CN (relative to LP)"
xtlogit mydir mq_med cb cn vin war1 bur_g war_g cbXbur_g cnXbur_g cbXvin cnXvin cbXwar1 cnXwar1 cbXwar_g cnXwar_g act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)

* cn is baseline category; coeff. for cb represents "CB (relative to CN)"
xtlogit mydir mq_med cb lp vin war1 bur_g war_g cbXbur_g lpXbur_g cbXvin lpXvin cbXwar1 lpXwar1 cbXwar_g lpXwar_g act1 act3 act4 act5 act6 act7 gov0 gov1 gov2 gov3 gov5 ident1 ident2 ident3 ident4 ident5 ident6 ident7 ident8, i(t)
