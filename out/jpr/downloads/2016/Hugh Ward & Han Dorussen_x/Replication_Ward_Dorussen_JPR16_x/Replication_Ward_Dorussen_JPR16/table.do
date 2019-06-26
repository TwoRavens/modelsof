
/* Open data; PKO Ward_Dorussen_JPR is based on data collected originally by Tobias Boehmelt and Vincenzo Bove:					 */
/* Bove, Vincenzo & Leandro Elia (2011) Supplying peace: Participation in and troop contribution to peacekeeping missions.   */
/* Journal of Peace Research 48(6): 699Ð714. We thank them for sharing their data                                            */ 


/* Creating Table I */

xtregar prop_troop eigen eigen_sq rgdppcB distw, re rhotype(tscorr)
outreg using table_1, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table I. Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011) replace
xtregar prop_troop eigen eigen_sq rgdppcB distw c1-c199, re rhotype(tscorr)
outreg using table_1, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop eigen eigen_sq rgdppcB distw num_missions US polity2B comcol col45 ratio_pop, re rhotype(tscorr)
outreg using table_1, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **)  merge
xtregar prop_troop s_eigen s_eigen_sq eigen_i eigen_sq_i s_rgdppcB rgdppcB_i s_polity2B polity2B_i  s_ratio_pop ratio_pop_i s_num_missions num_missions_i distw US comcol col45, re rhotype(tscorr)
outreg using table_1, bdec(2) bfmt(e) starlevels(10 5 1)  sigsymbols(+ * **) merge


/* Creating Table II Y= ln_prop_troop excluding cases where a country never contributed to a particular mision */

xtregar ln_prop_troop eigen eigen_sq rgdppcB distw, re rhotype(tscorr)
outreg using table_2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table II. Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011) replace
xtregar ln_prop_troop eigen eigen_sq rgdppcB distw c1-c199, re rhotype(tscorr)
outreg using table_2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **)  merge
xtregar ln_prop_troop eigen eigen_sq rgdppcB distw num_missions US polity2B comcol col45 ratio_pop, re rhotype(tscorr)
outreg using table_2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **)  merge
xtregar ln_prop_troop s_eigen s_eigen_sq eigen_i eigen_sq_i s_rgdppcB rgdppcB_i s_polity2B polity2B_i  s_ratio_pop ratio_pop_i distw s_num_missions num_missions_i US comcol col45, re rhotype(tscorr)
outreg using table_2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge


/* Creating Table III Robustness */

xtregar prop_troop eigen eigen_sq distw num_missions US polity2B comcol col45 ratio_pop mil_per_sold, re rhotype(tscorr)
outreg using table_3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table III. Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011. Robustness checks) replace
xtregar prop_troop eigen eigen_sq rgdppcB distw num_missions US UK Russia China France polity2B comcol col45 ratio_pop, re rhotype(tscorr)
outreg using table_3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop eigen eigen_sq abs_idealpointB rgdppcB distw num_missions US polity2B comcol col45 ratio_pop, re rhotype(tscorr)
outreg using table_3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop eigen eigen_sq rgdppcB distw num_missions US polity2B comcol col45 ratio_pop igo_cent r_trade_cent , re rhotype(tscorr)
outreg using table_3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge

/* Creating Table A.I Y = number of troops */

xtregar troop eigen eigen_sq rgdppcB distw, re rhotype(tscorr)
outreg using table_A1, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table A.I Contribution of troops to UN peacekeeping operations, 1990 Ð 2011, GLS with AR(1) disturbances) replace
xtregar troop eigen eigen_sq rgdppcB distw c1-c199, re rhotype(tscorr)
outreg using table_A1, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar troop eigen eigen_sq rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A1, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **)  merge
xtregar troop s_eigen s_eigen_sq eigen_i eigen_sq_i s_rgdppcB rgdppcB_i s_polity2B polity2B_i  s_ratio_pop ratio_pop_i distw s_num_missions num_missions_i US comcol col45, re rhotype(tscorr)
outreg using table_A1, bdec(2) bfmt(e) starlevels(10 5 1)  sigsymbols(+ * **) merge


/* Creating Table A.II  Y = prop_troops excluding all zero contributions */

xtregar prop_troop eigen eigen_sq rgdppcB distw if prop_troop > 0, re rhotype(tscorr)
outreg using table_A2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table A.II Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011, GLS with AR(1) disturbances, excluding zero contributions) replace
xtregar prop_troop eigen eigen_sq rgdppcB distw c1-c199 if prop_troop > 0, re rhotype(tscorr)
outreg using table_A2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop eigen eigen_sq rgdppcB distw US polity2B comcol col45 ratio_pop num_missions if prop_troop > 0, re rhotype(tscorr)
outreg using table_A2, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop s_eigen s_eigen_sq eigen_i eigen_sq_i s_rgdppcB rgdppcB_i s_polity2B polity2B_i  s_ratio_pop ratio_pop_i distw s_num_missions num_missions_i US comcol col45 if prop_troop > 0, re rhotype(tscorr)
outreg using table_A2, bdec(2) bfmt(e) starlevels(10 5 1)  sigsymbols(+ * **) merge

/* Creating Table A.III Y = ln_prop_troop excluding all zero contibutions */

xtregar ln_prop_troop eigen eigen_sq rgdppcB distw if prop_troop > 0, re rhotype(tscorr)
outreg using table_A3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table A.III Proportionate contribution of troops to UN peacekeeping operations (log), 1990 Ð 2011, GLS with AR(1) disturbances, excluding zero contributions) replace
xtregar ln_prop_troop eigen eigen_sq rgdppcB distw c1-c199 if prop_troop > 0, re rhotype(tscorr)
outreg using table_A3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar ln_prop_troop eigen eigen_sq rgdppcB distw US polity2B comcol col45 ratio_pop num_missions if prop_troop > 0, re rhotype(tscorr)
outreg using table_A3, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar ln_prop_troop s_eigen s_eigen_sq eigen_i eigen_sq_i s_rgdppcB rgdppcB_i s_polity2B polity2B_i  s_ratio_pop ratio_pop_i distw s_num_missions num_missions_i US comcol col45 if prop_troop > 0, re rhotype(tscorr)
outreg using table_A3, bdec(2) bfmt(e) starlevels(10 5 1)  sigsymbols(+ * **) merge


/* Table A.IV Robustness, interaction eigen and wealth, trade, alliance */
xtregar prop_troop eigen_sq c.rgdppcB##c.eigen distw US polity2B comcol col45 ratio_pop, re rhotype(tscorr)
outreg using table_A4, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table A.IV Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011, GLS with AR(1) disturbances, additional models) replace
xtregar prop_troop eigen eigen_sq rgdppcB distw US polity2B comcol col45 ratio_pop r_dyadic_trade num_missions, re rhotype(tscorr)
outreg using table_A4, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop eigen eigen_sq rgdppcB distw US polity2B comcol col45 ratio_pop defense num_missions, re rhotype(tscorr)
outreg using table_A4, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge

/* Table A.V Robustness, alternative spatial ideal-point controls */
xtregar prop_troop abs_idealpointB rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A5, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table A.V Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011, GLS with AR(1) disturbances, additional models policy position) replace
xtregar prop_troop idealpointB idealpointB_sq rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A5, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop similarityAB rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A5, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge
xtregar prop_troop eigen eigen_sq similarityAB rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A5, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge


/* Table A.VI Spatial lag */
xtregar prop_troop SL_prop_troop rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A6, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) title(Table A.V Proportionate contribution of troops to UN peacekeeping operations, 1990 Ð 2011, GLS with AR(1) disturbances, spatial lags) replace
xtregar prop_troop eigen eigen_sq SL_prop_troop rgdppcB distw US polity2B comcol col45 ratio_pop num_missions, re rhotype(tscorr)
outreg using table_A6, bdec(2) bfmt(e) starlevels(10 5 1) sigsymbols(+ * **) merge








