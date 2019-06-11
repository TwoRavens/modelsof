***************************************************
*BJPolS GEE Robustness Checks
***************************************************
clear
insheet using "http://alexkroeger.weebly.com/uploads/5/6/1/7/56177689/bjpols_r2.csv", comma

gen regime_type = 1 if gwf_personal==1

replace regime_type = 2 if gwf_party==1

replace regime_type = 3 if gwf_military==1

global varsint2 i.regime_type##i.election_any_corrected i.opposition i.attempt_corrected sppop_l1 i.high_rents ln_cgdppc_l1 growth_l1 c.leader_tenure##c.leader_tenure##c.leader_tenure

xtset obsid year


* Table 1 Model 2 and average marginal effects


nbreg sacks $varsint2, vce(cluster obsid)  exposure(cabinet_size_l1)

margins, dydx(*) 



*Table 1 Model 4 with average marginal effects


nbreg shuffled $varsint2,  vce(cluster obsid) exposure(cabinet_size_l1)


margins, dydx(*) 


*XTGEE models


xtgee sacks $varsint2, family(nbinomial) link(log) corr(ar 1) vce(robust) exposure(cabinet_size_l1)
eststo

xtgee shuffled $varsint2, family(nbinomial) link(log) corr(ar 1) vce(robust) exposure(cabinet_size_l1)
eststo

estout, style(tex) cells(b(star fmt(3)) se(fmt(3)))



