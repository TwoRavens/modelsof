*Replication file for data analysis in Plümper, Troeger, Winner: "Why is there no Race to the Bottom in Capital Taxation?"*

*cd c:\vera\tp\tax_evol\isq
set more off

*final ISQ models*

log using replication_Pluemperetal_ISQ.log, replace

*Table 4*

*Table 4: Model 1a*

ivreg2 tcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp   _x_*, bw(2) kernel(bartlett)


*Table 4: Model 1b*

ivreg2 tcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)


*Table 4: Model 2a*

ivreg2 tlab_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp   _x_*, bw(2) kernel(bartlett)


*Table 4: Model 2b*

ivreg2 tlab_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)


*Table 4: Model 3a*

ivreg2 tlabcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp   _x_*, bw(2) kernel(bartlett)


*Table 4: Model 3b*

ivreg2 tlabcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)




*Robustness*

*ISSP*

*Table 6*

*Table 6: Model 4*

ivreg2 tcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi)  m_red_incinequ sd_red_incinequ l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)


*Table 6: Model 5*

ivreg2 tlab_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi)  m_red_incinequ sd_red_incinequ l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)


*Table 6: Model 6*

ivreg2 tlabcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi)  m_red_incinequ sd_red_incinequ l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)


*corporate tax revenue*
*Table 7: Model 7*

ivreg2  taxrev_corp_pertotal (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem  _x_*, bw(2) kernel(bartlett)


*SEM correlated errors*
*Table 7: Model 8*

ivreg2 tcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem e_lab e_labcap  _x_*, bw(2) kernel(bartlett)


*Table 7: Model 9*

ivreg2 tlab_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem e_cap  e_labcap _x_*, bw(2) kernel(bartlett)


*Table 7: Model 10*

ivreg2 tlabcap_dhvt23 (sl_tcap23_fdi =  sl_quinnall_fdi sl_ginipsi_fdi  sl_gdppc_fdi sl_govcon_fdi sl_trade_fdi  sl_poptotal_fdi) igini_psi abs_red l3.idebt_pergdp pop65 l.unemp_wdi l.gdp_growth l.trade_pergdp log_poptotal mquinn_cap lngdppc optlagleft optlagcdem e_lab e_cap  _x_*, bw(2) kernel(bartlett)



log close
