***********************
* Refugees, ethnic power relations and civil conflict in the country of asylum
* Replication file
* Seraina RŸegger (ruegger@icr.gess.ethz.ch)
***********************

use "data.dta"

* Table I
* Model 1
logit onset_do_flag kin_refs_flagl status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 2
logit onset_do_flag i.kin_refs_flagl##i.status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 3
logit onset_do_flag kref_size_catl status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 4
logit onset_do_flag kin_refs_flagl trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 


* Table II
* Model 5
logit onset_do_flag r_dum_cons trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 6
logit onset_do_flag i.r_dum_cons##i.status_excl trefugees_nk_flag_l downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 7
logit onset_do_flag NBkin_refs_flagl trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 8
logit onset_do_flag i.NBkin_refs_flagl##i.status_excl trefugees_nk_flag_l downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 9
logit onset_do_flag kin_refs_flagl seefsu ssa mena asia lamerica trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 10
logit onset_do_flag i.kin_refs_flagl##i.status_excl seefsu ssa mena asia lamerica trefugees_nk_flag_l downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 


* Table III
* Model 11
logit onset_do_flag  kin_refs_flagl trefugees_nk_flag_l tek_isrelevant tek_incidence_flag_lag status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 12
logit onset_do_flag  i.kin_refs_flagl##i.status_excl trefugees_nk_flag_l tek_isrelevant tek_incidence_flag_lag downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 13
logit onset_do_flag kin_refs_flagl trefugees_nk_flag_l tek_isrelevant tek_incidence_flag_lag c c2 status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 14
logit onset_do_flag i.kin_refs_flagl##i.status_excl trefugees_nk_flag_l tek_isrelevant tek_incidence_flag_lag c c2 downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 15
logit onset_do_flag kin_refs_flagl trefugees_nk_flag_l rival status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 16
logit onset_do_flag i.kin_refs_flagl##i.status_excl trefugees_nk_flag_l rival downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 


* Table IV
* Model 6
logit onset_do_flag i.r_dum_cons##i.status_excl trefugees_nk_flag_l downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 
	margins status_excl, dydx(r_dum_cons) post noatlegend level(95)

* Model 8
logit onset_do_flag i.NBkin_refs_flagl##i.status_excl trefugees_nk_flag_l downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 
	margins status_excl, dydx(NBkin_refs_flagl) post noatlegend level(95)

* Model 10
logit onset_do_flag i.kin_refs_flagl##i.status_excl seefsu ssa mena asia lamerica trefugees_nk_flag_l downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 
	margins status_excl, dydx(kin_refs_flagl) post noatlegend level(95)

* Model 12
logit onset_do_flag  i.kin_refs_flagl##i.status_excl trefugees_nk_flag_l tek_isrelevant tek_incidence_flag_lag downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 
	margins status_excl, dydx(kin_refs_flagl) post noatlegend level(95)

* Model 14
logit onset_do_flag i.kin_refs_flagl##i.status_excl trefugees_nk_flag_l tek_isrelevant tek_incidence_flag_lag c c2 downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 
	margins status_excl, dydx(kin_refs_flagl) post noatlegend level(95)

* Model 16
logit onset_do_flag i.kin_refs_flagl##i.status_excl trefugees_nk_flag_l rival downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 
	margins status_excl, dydx(kin_refs_flagl) post noatlegend level(95)


* APPENDIX

* Table IV
* Model 17
logit onset_do_flag kin_refs_flagl3 trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 18
logit onset_do_flag kin_refs_flagl trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0 & tek_isrelevant==1, cluster(ccode_coa) 

* Model 19
logit onset_do_flag kin_refs_flagl tek_incidence_flag_lag tek_excl tek_egip c_egip c2_egip c_excl c2_excl  trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 20
logit onset_do_flag kin_refs_flagl kin_refs_sizelnl trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 21 
logit onset_do_flag kin_refs_flagl kin_refs_rel_al trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 22
logit onset_do_flag	kin_refs_flagl kin_refs_rel_bl trefugees_nk_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 

* Model 23
logit onset_do_flag trefugees_flag_l status_excl downgraded2 b warhist_flag country_incidence_flagl nb_incidence_flag ln_pop_lag ln_rgdppc05_lag peaceyears peaceyrs2 peaceyrs3 if status_monop == 0 & status_dominant == 0, cluster(ccode_coa) 


* Table V
use "data_c.dta", replace

* Model 24
logit onset_do_flag kinrefs_flag_l  nonkinrefugees_flag_l lexclpop pop_ln rgdppc_ln warhist  peaceyears py2 py3, cluster(ccode_coa)

* Model 25
logit onset_do_flag kinexclrefs_flag_l kinegiprefs_flag_l nonkinrefugees_flag_l  lexclpop  pop_ln rgdppc_ln warhist  peaceyears py2 py3, cluster(ccode_coa)

* Model 26
logit onset_do_flag kinrefs_nr_ln_l nonkinrefugees_ln_l lexclpop  pop_ln rgdppc_ln warhist peaceyears py2 py3, cluster(ccode_coa)

* Model 27
logit onset_do_flag kinexclrefs_nr_ln_l kinegiprefs_nr_ln_l nonkinrefugees_ln_l lexclpop  pop_ln rgdppc_ln warhist  peaceyears py2 py3, cluster(ccode_coa)

























