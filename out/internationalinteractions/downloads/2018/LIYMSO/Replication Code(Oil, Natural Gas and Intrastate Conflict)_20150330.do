use "C:\Users\Tim\Documents\Uni Konstanz\Ressourcenprojekt\Daten\Final Data - Oil ownership\Öleigentumsdaten\Oil, Natural Gas and Intrastate Conflict_ReplicationData.dta", clear
**** Tables of "Oil, Natural Gas and Intrastate Conflict: Does ownership matter?" International Interactions - March 2015 ****
*** Table I: Total Hydrocarbon Production and Civil War Onset ***
* est1
eststo: logit  onset1v410 onset1v410_peace  L1_PC_total_production  L1_PC_total_production_SQR L1_mixed55l L1_instab_comp L1_gdppc  L1_pop_log  L1_gdpgrowthannual L1_elf  _spline1 _spline2 _spline3,cluster(cowcode)
* est2
eststo: logit  onset1v410 onset1v410_peace  L1_GDP_total_production  L1_GDP_total_production_SQR L1_mixed55l L1_instab_comp L1_gdppc  L1_pop_log  L1_gdpgrowthannual L1_elf  _spline1 _spline2 _spline3,cluster(cowcode)
esttab est1 est2 using ownercon_140816_tableI.rtf, se pr2 starlevels(* 0.10 ** 0.05 *** 0.01 ***** 0.001) compress nogap
*** Table II: State and Private Hydrocarbon Production (per capita and as Share of GDP) and Civil War Onset ***
* est3
eststo: logit  onset1v410 onset1v410_peace  L1_PC_priv_production  L1_PC_priv_production_SQR L1_PC_gov_production  L1_PC_gov_production_SQR _spline1 _spline2 _spline3 if check2_docper>0.60 & check2_docper!=.,cluster (cowcode)
* est4
eststo: logit  onset1v410 onset1v410_peace  L1_PC_priv_production  L1_PC_priv_production_SQR L1_PC_gov_production  L1_PC_gov_production_SQR L1_mixed55l L1_instab_comp L1_gdppc  L1_pop_log  L1_gdpgrowthannual L1_elf  _spline1 _spline2 _spline3 if check2_docper>0.60 & check2_docper!=.,cluster(cowcode)
* est5
eststo: logit  onset1v410 onset1v410_peace  L1_GDP_priv_production  L1_GDP_priv_production_SQR L1_GDP_gov_production  L1_GDP_gov_production_SQR  _spline1 _spline2 _spline3 if check2_docper>0.60 & check2_docper!=.,cluster(cowcode)
* est6
eststo: logit  onset1v410 onset1v410_peace L1_GDP_priv_production  L1_GDP_priv_production_SQR L1_GDP_gov_production  L1_GDP_gov_production_SQR  L1_mixed55l L1_instab_comp L1_gdppc  L1_pop_log  L1_gdpgrowthannual L1_elf  _spline1 _spline2 _spline3 if check2_docper>0.60 & check2_docper!=.,cluster(cowcode)
esttab est3 est4 est5 est6  using ownercon_140816_tableII.rtf, se pr2 starlevels(* 0.10 ** 0.05 *** 0.01 ***** 0.001) compress nogap
*** Table III: Per Capita State and Private Hydrocarbon Production and Welfare Spending ***
*est7
eststo: xtreg  imputedwelfspend  L1_PC_priv_production  L1_PC_priv_production_SQR L1_PC_gov_production L1_PC_gov_production_SQR yd1-yd20 if check2_docper>0.60 & check2_docper!=.,fe
tsset  cowcode year
*est8
eststo: xtreg  imputedwelfspend  L1_PC_priv_production  L1_PC_priv_production_SQR L1_PC_gov_production  L1_PC_gov_production_SQR l1.gdppc l1.gdpgrowthannual l1.elections_dpi l1.wdi_infl l1.left_largestparty_dpi l1.pwt_openk yd1-yd20 if check2_docper>0.60 & check2_docper!=.,fe
esttab est7 est8 using ownercon_140816_tableIII.rtf, se pr2 starlevels(* 0.10 ** 0.05 *** 0.01 ***** 0.001) compress nogap
*** Figure I: Per capita State-controlled hydrocarbon production and civil war onset ***
logit  onset1v410 onset1v410_peace  L1_PC_priv_production  L1_PC_priv_production_SQR L1_PC_gov_production  L1_PC_gov_production_SQR  L1_gdppc  L1_pop_log  L1_gdpgrowthannual L1_elf   if check2_docper>0.60 & check2_docper!=.,cluster(cowcode)
gen onset1v410_peace_g1=onset1v410_peace
gen L1_PC_priv_production_g= L1_PC_priv_production
gen L1_PC_priv_production_SQR_g=L1_PC_priv_production_SQR  
gen  L1_gdppc_g=L1_gdppc
gen L1_pop_log_g=L1_pop_log
gen  L1_gdpgrowthannual_g=L1_gdpgrowthannual 
gen L1_elf_g=L1_elf
logit  onset1v410 onset1v410_peace_g1  L1_PC_priv_production_g  L1_PC_priv_production_SQR_g L1_PC_gov_production  L1_PC_gov_production_SQR  L1_gdppc_g  L1_pop_log_g  L1_gdpgrowthannual_g L1_elf_g   if check2_docper>0.60 & check2_docper!=.,cluster(cowcode)
quietly sum  onset1v410_peace, det
replace  onset1v410_peace_g1= r(p50)
quietly sum  L1_PC_priv_production, det
replace  L1_PC_priv_production_g=r(p50)
quietly sum L1_PC_priv_production_SQR, det
replace L1_PC_priv_production_SQR_g=r(p50)
quietly sum  L1_gdppc, det
replace  L1_gdppc_g=r(p50)
quietly sum  L1_pop_log, det
replace  L1_pop_log_g=r(p50)
quietly sum  L1_gdpgrowthannual, det
replace  L1_gdpgrowthannual_g=r(p50)
quietly sum  L1_elf, det
replace  L1_elf_g=r(p50)
sort  L1_PC_gov_production
predict pr, p
predict logodds, xb
predict stderr, stdp
generate lodds_lb = logodds - 1.96*stderr
generate lodds_ub = logodds + 1.96*stderr
generate ub_p = exp(lodds_ub)/(1+exp(lodds_ub)) 
generate lb_p = exp(lodds_lb)/(1+exp(lodds_lb)) 
twoway (rarea lb_p ub_p  L1_PC_gov_production, bcolor(gs14)) (line pr  L1_PC_gov_production, clcolor(black) clwidth(medthick)),xline(0, lp(dash) lc(gs14) lw(thin)) ylabel(#8, labsize(small)) xlabel(#20, labsize(small)) ytitle(conflict onset, size(small)) xtitle(state-controlled oil production, size(small))legend(order(2 "Probability of conflict onset" 1 "95% confidence interval") size(small) rows(1)) graphregion(color(white))|| if  L1_PC_gov_production<0.6 






