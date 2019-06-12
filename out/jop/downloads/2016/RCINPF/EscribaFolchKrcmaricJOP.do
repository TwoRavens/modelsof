
**Table 1**
use EscribaFolchKrcmaricJOP.dta 
logit exile_1  atopally_update_cow colony_secession log_distance, cluster(ccode1)
logit exile_1  atopally_update_cow colony_secession log_trade01 log_distance, cluster(ccode1)
logit exile_1  atopally_update_cow colony_secession log_trade01 log_distance majpow2 cgv_democracy_2 l_past_hosted_dummy_2 icc_ratified_year_2 l_civilwar_2 l_intwar_2, cluster(ccode1)
logit exile_1  atopally_update_cow colony_secession log_trade01 log_distance majpow2 l_past_hosted_dummy_2 icc_ratified_year_2 gwf_personal_2 gwf_military_2 gwf_party_2 gwf_monarchy_2  l_civilwar_2 l_intwar_2 , cluster(ccode1)

**Figure 1 - Map**
use worlddata.dta
spmap exile_categories3 using worldcoor.dta if admin!="Antarctica", id(id) clmethod(unique)

**Figure 2 - Substantive Effects**
use EscribaFolchKrcmaricJOP.dta 
estsimp logit exile_1  atopally_update_cow colony_secession log_trade01 log_distance majpow2 cgv_democracy_2 l_past_hosted_dummy_2 icc_ratified_year_2 l_civilwar_2 l_intwar_2, cluster(ccode1)
setx median
simqi, fd(prval(1)) changex(atopally_update_cow 0 1) 
setx median
simqi, fd(prval(1)) changex(colony_secession 0 1) 
setx median
simqi, fd(prval(1)) changex(log_trade01 p25 p75) 
setx median
simqi, fd(prval(1)) changex(log_distance p25 p75)
setx median
simqi, fd(prval(1)) changex(majpow2 0 1) 
setx median
simqi, fd(prval(1)) changex(cgv_democracy_2 0 1) 
setx median
simqi, fd(prval(1)) changex(l_past_hosted_dummy_2 0 1) 
setx median
simqi, fd(prval(1)) changex(icc_ratified_year_2 0 1) 
setx median
simqi, fd(prval(1)) changex(l_civilwar_2 0 1) 
setx median
simqi, fd(prval(1)) changex(l_intwar_2 0 1) 

