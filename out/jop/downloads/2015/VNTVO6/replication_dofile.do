*** Replication file for "Economic Sanctions, Transnational Terrorism, and the Incentive to Misrepresent" 
*** Navin A. Bapat, Luis De la Calle, Kaisa H. Hinkkainen, and Elena V. McLean
*** Forthcoming in The Journal of Politics

use replication_data.dta, replace

*** Table 4: Sanction Imposition by the U.S. against States Where Its Interests Have Been Attacked *** 

global controls attacks_total tta polity2 populationln  intrastate_war lnUS_exports_GDP lnUS_imports_GDP s3un no_attack_years  t2 t3

xi: logit  imposition  c.GDPpc_rescaled##c.GDPpc_rescaled  $controls, vce(cluster ccode) nolog
xi: logit  imposition  c.GDPpc_ln##c.GDPpc_ln $controls, vce(cluster ccode) nolog
xi: logit  imposition  c.rpr_work##c.rpr_work $controls, vce(cluster ccode) nolog
xi: logit  imposition  c.rpr_eap##c.rpr_eap $controls, vce(cluster ccode) nolog

*** Figures 3-4: Predicted Effects of State Capacity Measures on Sanction Probability  ***

global controls attacks_total tta polity2 populationln  intrastate_war lnUS_exports_GDP lnUS_imports_GDP s3un no_attack_years  t2 t3

xi: logit  imposition  c.GDPpc_rescaled##c.GDPpc_rescaled  $controls, vce(cluster ccode) nolog
margins, at(GDPpc_rescaled =(0(1)82))
marginsplot, recast(line) recastci(rline) addplot(hist GDPpc_rescaled)

xi: logit  imposition  c.GDPpc_ln##c.GDPpc_ln $controls, vce(cluster ccode) nolog
margins, at(GDPpc_ln=(3.9(.5)11.5))
marginsplot, recast(line) recastci(rline) addplot(hist GDPpc_ln)

xi: logit  imposition  c.rpr_work##c.rpr_work $controls, vce(cluster ccode) nolog
margins, at(rpr_work=(0(.02)1.7))
marginsplot, recast(line) recastci(rline) addplot(hist rpr_work, yaxis(2))

xi: logit  imposition  c.rpr_eap##c.rpr_eap $controls, vce(cluster ccode) nolog
margins, at(rpr_eap=(0.5(.02)1.4))
marginsplot, recast(line) recastci(rline) addplot(hist rpr_eap, yaxis(2))
