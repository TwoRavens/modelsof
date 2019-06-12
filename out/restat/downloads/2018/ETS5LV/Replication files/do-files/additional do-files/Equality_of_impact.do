
*** This do-file tests for the equality of the impact of the cash-transfer program and the rainfall shocks ***

use "$data/podes_pkhrollout.dta", clear


*** Parameters for comparison ***

global cct_value=22.45 // Dollar value of cct
global consumption_impact= 18000*12 // Consumption impact of one sd rainfall in Rupia per year (from log specification and median consumption)
global exchange_rate = 10000 // Exchange rate Rupiah per dollar in 2005 (rounded).

global share_farm=0.56 // Share of farmers from PODES(population affected by rainfall shocks)
global share_poor=0.1 // Share of ultra poor (target population of CCT)



xtset kecid t
global year year2000 year2003 year2005 year2011 year2014



	** Generate weights
		
	gen weight=sqrt(pop_sizebaseline)
	
	** Generate weighted variables
	
	foreach var in nsuicidespc z_rain post  {
	gen w`var'=`var'*weight
	}
	

	** Partial out weighted fixed effects
	hdfe  wnsuicidespc wz_rain wpost   , absorb( i.year#c.weight i.kecid2000#c.weight ) gen(h_)

	
	

*** Store rollout results ***

	
reg h_wnsuicidespc h_wpost   if year>=2005

est store rollout


*** Store rainfall results ***

	
reg h_wnsuicidespc h_wz_rain 


est store rain

*** Testing for equality in dollar terms ***

suest rollout rain, cluster(kabuid)




*** Test for equality of coefficients

test [rain_mean]h_wz_rain / $consumption_impact * $exchange_rate  = [rollout_mean]h_wpost  /$cct_value


*** Test for equality of marginal impact in dollar terms (on total rate, account for fraction treated).

test [rain_mean]h_wz_rain / $consumption_impact * $exchange_rate / $share_farm = [rollout_mean]h_wpost  /$cct_value / $share_poor

di "The p-value of equality of population effects in dollar terms on the population suicide rate for cct and rainfall is:" r(p)

*** Implied direct effect ***

test [rain_mean]h_wz_rain / $consumption_impact * $exchange_rate * 0.14/0.08  = [rollout_mean]h_wpost  /$cct_value * 3.6/ 0.36


di "The p-value of equality of implied direct effects in dollar terms on the suicide rate for cct and rainfall is:" r(p)














