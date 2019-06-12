*
*Analysis for IMF paper
*
clear
clear matrix
set mem 300m
set more off

**************************************
*************load  data***************
**************************************
use "Cur_Cris_IMF.dta", clear


******Tables 2-3******

*probit basic (model 1)
probit curcris1 lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d, robust

*probit full (model 2)
probit curcris1 lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov, robust

*bivariate probit (model 3)
biprobit (curcris1=lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov) (imfstab =  veto_players log_reserves log_inflation logGDPpc current_account output_loss tradeshock2 bankcris lag_imfstab), vce(robust)

*probit currency collapse (model 4)
probit curcris3 lag_curcris3 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov, robust

*bivariate probit with currency collapse (model 5)
biprobit (curcris3=lag_curcris3 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov) (imfstab =  veto_players log_reserves log_inflation logGDPpc current_account output_loss tradeshock2 bankcris lag_imfstab), vce(robust)


******Tables 3-4******

*probit with fixed_exchange rate (model 6)
probit curcris1 lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov fixed_exchange_rate, robust

*bivariate probit with fixed exchange rate (model 7)
biprobit (curcris1=lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov fixed_exchange_rate) (imfstab =  veto_players log_reserves log_inflation logGDPpc current_account output_loss tradeshock2 bankcris lag_imfstab), vce(robust)

*probit with extra controls (model 8)
probit curcris1 lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov  reserves_shorttermdebt gdpgrowthannual fixed_exchange_rate, robust

*bivariate probit with extra controls (model 9)
biprobit (curcris1=lag_curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov reserves_shorttermdebt gdpgrowthannual fixed_exchange_rate) (imfstab =  veto_players log_reserves log_inflation logGDPpc current_account output_loss tradeshock2 bankcris lag_imfstab), vce(robust)

*bivariate probit using currency crash (model 10)
biprobit (curcris2=lag_curcris2 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov) (imfstab =  veto_players log_reserves log_inflation logGDPpc current_account output_loss tradeshock2 bankcris lag_imfstab), vce(robust)

*probit post 1990 (model 11)
probit curcris1 logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov if year>=1991, robust

*bivariate probit post 1990 (model 12)
biprobit (curcris1=logGDPpc ext_debtstocks_gni current_account imfstab imfstab_X_bnkconc_d bnkconc_d reer bankcris kaopen M2_reserves gov_budget_gdp export_growth  domestic_credit_growth LEIC turnover divided_gov) (imfstab =  veto_players log_reserves log_inflation logGDPpc current_account output_loss tradeshock2 bankcris lag_imfstab) if year>=1991, vce(robust)






















