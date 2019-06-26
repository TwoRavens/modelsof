// replication data for //
// Eck, Kristine (2018) "The Origins of Policing Institutions: Legacies of Colonial Insurgency" Journal of Peace Research v.55 //

set more off


* / TI descriptive data / *

xtile policequart = max_police_exp, nq(4)

list country if policequart==1
list country if policequart==2
list country if policequart==3
list country if policequart==4
list country if max_police_exp==.


* / T2: IV: PRE-INDEP CONF, DV: POLICE EXP / *

reg max_police_exp colconf, robust

reg max_police_exp colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest, robust

reg max_police_exp colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density, robust


* / T3: IV: PRE-INDEP CONF, DV: POLICE RELIABILITY / *

reg wef_rps_2014 colconf, robust 

reg wef_rps_2014 colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest, robust

reg wef_rps_2014 colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density, robust


* / T4: IV: SECURITY INPUTS, DV: POLICE RELIABILITY / *

reg wef_rps_2014 max_police_exp, robust

reg wef_rps_2014 max_police_exp indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density, robust


* / ROBUSTNESS TESTS / *

* / Africa dummy included / *

reg max_police_exp colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest africa, robust

reg max_police_exp colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density africa, robust

reg wef_rps_2014 colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest africa, robust

reg wef_rps_2014 colconf indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density africa, robust

reg wef_rps_2014 max_police_exp indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density africa, robust


* / Singapore omitted / *

reg max_police_exp colconfnosing, robust

reg max_police_exp colconfnosing indep precolonial_dev eur_pop_at_colonial_exit mtnest, robust

reg max_police_exp colconfnosing indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density, robust

reg wef_rps_2014 colconfnosing, robust 

reg wef_rps_2014 colconfnosing indep precolonial_dev eur_pop_at_colonial_exit mtnest, robust

reg wef_rps_2014 colconfnosing indep precolonial_dev eur_pop_at_colonial_exit mtnest precolonial_pop_density, robust




