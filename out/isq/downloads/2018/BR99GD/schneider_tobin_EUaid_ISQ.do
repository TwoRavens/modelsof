*/Table 2: Interest Coalitions and EU Multilateral Ad*/
*/model 1*/
xtpcse Y Y_lag  strategic_power_france_std strategic_power_germany_std het_std ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly

*/model 2*/
xtpcse Y Y_lag  IC_std het_std ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly

*/model 3*/
xtpcse Y Y_lag het_std IC_std het_interest_std  ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly

*/model 4*/
xtpcse Y Y_lag het_std IC_std  ln_gdp_cap het_gdp_std  recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly


*/Table 3: Robustness Checks, Interest Coalitions I*/
*/model 5*/
xtpcse Y Y_lag het_predicted ic_predicted ln_pop nat_dis_deaths aid_change year wall, correlation(ar1) hetonly

*/model 6*/
xtpcse Y Y_lag sscore_het   sscore_std     ln_gdp_cap  recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly

*/model 7*/
xtpcse Y Y_lag predict_het_si predict_ic_si predict_ic_dev predict_het_dev ln_pop    nat_dis_deaths aid_change year wall, correlation(ar1) hetonly

*/Table 4: Robustness Checks, Interest Coalitions II*/
*/model 8*/
xtpcse Y Y_lag  strategic_power_france_std strategic_power_germany_std  ic_no_frger  ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly

*/model 9*/
xtpcse Y Y_lag  bilat_aid_pop_std  ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly

*/Table 5: Robustness Checks, Model Specification */
*/model 10*/
xtreg Y Y_lag het_std IC_std  ln_gdp_cap  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, fe

*/model 11*/
xtreg Y het_std IC_std  ln_gdp_cap  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, fe

*/model 12*/
xtabond2 Y  Y_lag  het_std IC_std  ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos, iv(Y_lag ln_gdp_cap recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos  het_std IC_std, eq(level)) small h(1) robust

*/model 13*/
xttobit Y Y_lag het_std IC_std  ln_gdp_cap  recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall


*/Table 6: Robustness Checks, Dependent Variable*/
*/model 14*/
xtpcse ln_usd_amount_real_2000_pop ln_usd_amount_real_2000_pop_n1 het_std IC_std  ln_gdp_cap  recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly


*/model 15*/
xtpcse  usd_amount_real_2000_gdp_ln usd_amount_real_2000_gdp_n1_ln het_std IC_std  ln_gdp_cap  recip_SSA recip_mena recip_asia recip_lacarribean colony distance  imports_eu ln_pop    nat_dis_deaths aid_change polity_pos year wall, correlation(ar1) hetonly


