*JPR Analysis for Mitchell, Ring, Spellman

*Table 1, Model 1
ologit  pts_a  pts_a_lag  p_polity2  ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil common mixed hensel_coldum  h_j, robust

*Robustness: setting common law as omitted category
ologit  pts_a  pts_a_lag  p_polity2  ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil islamic mixed hensel_coldum  h_j, robust

*Robustness: using dummy variables for the lagged DV value
ologit  pts_a  pts_a_lag1 pts_a_lag2 pts_a_lag3 pts_a_lag4 p_polity2  ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil common mixed hensel_coldum  h_j, robust 

*Table 1, Model 2; adding freedom from corruption
ologit  pts_a  pts_a_lag  p_polity2  ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil common mixed hensel_coldum  h_j hf_corrupt, robust

*Table 1, Model 3; adding democracy squared
ologit  pts_a  pts_a_lag  p_polity2  p_polity2squared ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil common mixed hensel_coldum  h_j, robust

*Table 1, Model 4; adding og length of state age 
ologit  pts_a  pts_a_lag  p_polity2 ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil common mixed hensel_coldum  h_j llength, robust

*Calculating substantive effects for model 1, Table 1
estsimp ologit  pts_a  pts_a_lag  p_polity2  ln_gdpcap  ln_pop dpi_cemo ucdp_type2 ucdp_type3 civil common mixed hensel_coldum  h_j, robust

*Baseline for Islamic Law
setx (pts_a_lag  p_polity2  ln_gdpcap  ln_pop) mean (dpi_cemo ucdp_type2 ucdp_type3 hensel_coldum  h_j) median (civil common mixed) 0
simqi, pr

*Civil law
setx (pts_a_lag  p_polity2  ln_gdpcap  ln_pop) mean (dpi_cemo ucdp_type2 ucdp_type3 hensel_coldum  h_j) median (common mixed) 0 (civil) 1
simqi, pr

*Common law
setx (pts_a_lag  p_polity2  ln_gdpcap  ln_pop) mean (dpi_cemo ucdp_type2 ucdp_type3 hensel_coldum  h_j) median (civil mixed) 0 (common) 1
simqi, pr

*Mixed law
setx (pts_a_lag  p_polity2  ln_gdpcap  ln_pop) mean (dpi_cemo ucdp_type2 ucdp_type3 hensel_coldum  h_j) median (common civil) 0 (mixed) 1
simqi, pr

*First differences, used to create substantive effects Table 2
setx (pts_a_lag  p_polity2  ln_gdpcap  ln_pop) mean (dpi_cemo ucdp_type2 ucdp_type3 hensel_coldum  h_j) median (civil common mixed) 0
simqi, fd(pr) changex(civil 0 1)
simqi, fd(pr) changex(common 0 1)
simqi, fd(pr) changex(mixed 0 1)
simqi, fd(pr) changex(p_polity2 min max)
simqi, fd(pr) changex(ln_gdpcap min max)
simqi, fd(pr) changex(ln_pop min max)
simqi, fd(pr) changex(ucdp_type3 min max)
simqi, fd(pr) changex(hensel_coldum 0 1)
simqi, fd(pr) changex(h_j 0 1)
simqi, fd(pr) changex(dpi_cemo 0 1)
simqi, fd(pr) changex(ucdp_type2 min max)


