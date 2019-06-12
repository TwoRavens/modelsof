xtset  oecd_code year, yearly

%%% TABLE 2

xtpcse  ec_oda  eu_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  un_oda  un_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  ida_oda  ida_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  bil_oda     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise

%%% TABLE 3

xtpcse   ec_grants_oda  eu_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse   edf_grants_oda  eu_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  undp_grants_oda  un_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse   ida_grants_oda  ida_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise

%%% TABLE 4

xtpcse  ec_oda  eu_similarity   eu_size   ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  un_oda  un_similarity   un_size    ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  ida_oda  ida_similarity   ida_size   ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise

%%% TABLE 5

xtpcse  ec_oda  eu_similarity  relative_ec_aid    ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  un_oda  un_similarity  relative_un_aid    ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
xtpcse  ida_oda  ida_similarity   relative_ida_aid   ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise

%%% TABLE 6

xtpcse  un_oda  un_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
mfx compute
mfx compute, at(un_similarity=-0.54)
mfx compute, at(un_similarity=-0.34)
mfx compute, at(un_similarity=0.4)
mfx compute, at(un_similarity=0.8)

xtpcse  ida_oda  ida_similarity     ln_population  gdp_pc govt_consum   trade_gdp        us_econ_weight year, pairwise
mfx compute
mfx compute, at(ida_similarity=-0.52)
mfx compute, at(ida_similarity=-0.26)
mfx compute, at(ida_similarity=0.45)
mfx compute, at(ida_similarity=0.8)
