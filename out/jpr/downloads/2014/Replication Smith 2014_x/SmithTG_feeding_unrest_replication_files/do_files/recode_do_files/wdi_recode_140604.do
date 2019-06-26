**** PREP WDI DATA *****

clear
*insheet using "data/raw_data/WDI_dld_130808.csv", comma
wbopendata, indicator(ag.con.fert.zs; ag.lnd.agri.zs; ag.lnd.irig.ag.zs; ag.lnd.totl.k2; ag.lnd.trac.zs; ag.prd.food.xd; ag.yld.crel.kg; bx.klt.dinv.wd.gd.zs; eg.use.comm.gd.pp.kd; nv.agr.totl.zs; ny.gdp.mktp.kd; ny.gdp.mktp.kd.zg; ny.gdp.pcap.kd; ny.gdp.petr.rt.zs; sh.sta.mmrt; sh.sta.mmrt.ne; si.pov.2day; si.pov.dday; si.pov.nahc; sl.agr.empl.zs; sn.itk.defc.zs; sp.dyn.imrt.in; sp.dyn.le00.in; sp.pop.0014.to.zs; sp.pop.1564.to.zs; sp.pop.65up.to.zs; sp.pop.grow; sp.pop.totl; sp.urb.totl; tm.val.food.zs.un; tx.val.agri.zs.un; tx.val.food.zs.un) clear long

*tempfile `wdi'
*save wdi, replace
/*
clear
insheet using "data/raw_data/WFP_dld_121111.csv", comma
gen countrycode = ""
replace countrycode = "DZA" if recipient == "Algeria"
replace countrycode = "AGO" if recipient == "Angola"
replace countrycode = "BEN" if recipient == "Benin"
replace countrycode = "BWA" if recipient == "Botswana"
replace countrycode = "BFA" if recipient == "Burkina Faso"
replace countrycode = "BDI" if recipient == "Burundi"
replace countrycode = "CMR" if recipient == "Cameroon"
replace countrycode = "CPV" if recipient == "Cape Verde"
replace countrycode = "CAF" if recipient == "Central African Republic"
replace countrycode = "TCD" if recipient == "Chad"
replace countrycode = "COM" if recipient == "Comoros"
replace countrycode = "COG" if recipient == "Congo"
replace countrycode = "CIV" if recipient == "C̫te d'Ivoire"
replace countrycode = "CIV" if recipient == "C?te d'Ivoire"
replace countrycode = "ZAR" if recipient == "Democratic Republic of the Congo (DRC)"
replace countrycode = "DJI" if recipient == "Djibouti"
replace countrycode = "EGY" if recipient == "Egypt"
replace countrycode = "GNQ" if recipient == "Equatorial Guinea"
replace countrycode = "ERI" if recipient == "Eritrea"
replace countrycode = "ETH" if recipient == "Ethiopia"
replace countrycode = "GAB" if recipient == "Gabon"
replace countrycode = "GMB" if recipient == "Gambia"
replace countrycode = "GHA" if recipient == "Ghana"
replace countrycode = "GIN" if recipient == "Guinea"
replace countrycode = "GNB" if recipient == "Guinea-Bissau"
replace countrycode = "KEN" if recipient == "Kenya"
replace countrycode = "LSO" if recipient == "Lesotho"
replace countrycode = "LBR" if recipient == "Liberia"
replace countrycode = "LBY" if recipient == "Libya"
replace countrycode = "MDG" if recipient == "Madagascar"
replace countrycode = "MWI" if recipient == "Malawi"
replace countrycode = "MLI" if recipient == "Mali"
replace countrycode = "MRT" if recipient == "Mauritania"
replace countrycode = "MUS" if recipient == "Mauritius"
replace countrycode = "MAR" if recipient == "Morocco"
replace countrycode = "MOZ" if recipient == "Mozambique"
replace countrycode = "NAM" if recipient == "Namibia"
replace countrycode = "NER" if recipient == "Niger"
replace countrycode = "NGA" if recipient == "Nigeria"
replace countrycode = "RWA" if recipient == "Rwanda"
replace countrycode = "SEN" if recipient == "Senegal"
replace countrycode = "SYC" if recipient == "Seychelles"
replace countrycode = "SLE" if recipient == "Sierra Leone"
replace countrycode = "SOM" if recipient == "Somalia"
replace countrycode = "ZAF" if recipient == "South Africa"
replace countrycode = "SSD" if recipient == "South Sudan"
replace countrycode = "SDN" if recipient == "Sudan, the"
replace countrycode = "SWZ" if recipient == "Swaziland"
replace countrycode = "STP" if recipient == "Ṣo Tom̩ and Principe"
replace countrycode = "STP" if recipient == "S?o Tom? and Principe"
replace countrycode = "TZA" if recipient == "Tanzania"
replace countrycode = "TGO" if recipient == "Togo"
replace countrycode = "TUN" if recipient == "Tunisia"
replace countrycode = "UGA" if recipient == "Uganda"
replace countrycode = "ZMB" if recipient == "Zambia"
replace countrycode = "ZWE" if recipient == "Zimbabwe"
drop if recipient == "Cyprus"
drop if recipient == "Iran, Islamic Republic of"
drop if recipient == "Iraq"
drop if recipient == "Israel"
drop if recipient == "Jordan"
drop if recipient == "Lebanon"
drop if recipient == "Occupied Palestinian Territory"
drop if recipient == "Syrian Arab Republic, the"
drop if recipient == "Turkey"
drop if recipient == "Yemen"
drop recipient
order countrycode
gen food_aid = emergency + programme + project

merge 1:1 countrycode year using wdi
drop _merge
*merge 1:1 countrycode year using wdi_2
*drop if _merge != 3
*drop _merge
*drop region regioncode
*/
rename countrycode wb_code
*replace emergency = 0 if emergency == .
*replace programme = 0 if programme == .
*replace project = 0 if project == .
*replace food_aid = 0 if food_aid == .

rename sp_dyn_le00_in life_exp
lab var life_exp "Life expectancy at birth total (years)"
rename sp_dyn_imrt_in inf_mort
lab var inf_mort "Mortality rate infant (per 1000 live births)"
rename sh_sta_mmrt_ne mat_mort
rename sh_sta_mmrt mat_mort_mod
rename si_pov_nahc pov_hc
rename sn_itk_defc_zs malnutr
rename sp_pop_65up_to_zs pop_old
rename sp_pop_1564_to_zs pop_adult
rename ag_lnd_trac_zs ag_mach
rename ag_yld_crel_kg cereal
rename si_pov_dday pov_125
rename si_pov_2day pov_200
order pov_125 pov_200, a(pov_hc)
rename ag_lnd_irig_ag_zs irrig
rename tx_val_agri_zs_un ag_exp_wdi
rename ny_gdp_petr_rt_zs oil_rents
rename nv_agr_totl_zs ag_va
lab var ag_va "Agriculture value added (% of GDP)"
rename sl_agr_empl_zs ag_emp
rename ny_gdp_mktp_kd gdp
rename ag_lnd_agri_zs ag_land
*rename ny_gdp_mktp_kd_zg gdp_growth
rename ny_gdp_pcap_kd gdppc_wb
rename bx_klt_dinv_wd_gd_zs fdi
lab var fdi "Foreign direct investment net inflows (% of GDP)"
rename tm_val_food_zs_un food_imp_wdi
rename tx_val_food_zs_un food_exp_wdi
rename ag_prd_food_xd food_prod
*rename sp_pop_grow pop_growth
rename eg_use_comm_gd_pp_kd energy_use
rename sp_pop_0014_to_zs pop_youth
rename ag_lnd_totl_k2 area
rename ag_con_fert_zs fert

rename sp_pop_totl pop
rename sp_urb_totl pop_urb

encode wb_code, gen(wb_num)
order wb_num, a(wb_code)

xtset wb_num year

gen py_fdi = l.fdi
lab var py_fdi "Previous year foreign direct investment net inflows (% of GDP)"

replace pop_youth = (pop_youth / 100) * pop
lab var pop_youth "Youth Population (14 & under)"

gen r_tot = log(pop/pop[_n-1])/12 if wb_num == wb_num[_n-1]
gen r_urb = log(pop_urb/pop_urb[_n-1])/12 if wb_num == wb_num[_n-1]
gen r_youth = log(pop_youth/pop_youth[_n-1])/12 if wb_num == wb_num[_n-1]
expand 12
sort wb_num year
gen month = 1
replace month = month[_n-1] + 1 if wb_num == wb_num[_n-1] & year == year[_n-1]
order month, a(year)
gen time = ((year - 1960) * 12) + (month - 1)
order time, a(month)
xtset wb_num time
replace pop = . if month != 7
replace pop_urb = . if month != 7
replace pop_youth = . if month != 7

replace pop = l.pop * exp(r_tot) if month != 7
replace pop_urb = l.pop_urb * exp(r_urb) if month != 7
replace pop_youth = l.pop_youth * exp(r_youth) if month != 7

gen pct_urb = pop_urb / pop * 100
lab var pct_urb "Urban population (% of total)"
gen pct_youth = pop_youth / pop * 100
lab var pct_youth "Youth population (% of total 14 & under)"

gen pop_growth = ((pop - l.pop) / l.pop) * 100
lab var pop_growth "Population growth (monthly %)"
gen urb_growth = ((pop_urb - l.pop_urb) / l.pop_urb) * 100
lab var urb_growth "Urban population growth (monthly %)"
gen youth_growth = ((pop_youth - l.pop_youth) / l.pop_youth) * 100
lab var youth_growth "Youth population growth (monthly %)"

gen gdp_growth = ((gdp - l.gdp) / l.gdp) * 100
lab var gdp_growth "GDP growth (monthly %)"
gen gdppc = gdp/pop/1000
lab var gdppc "GDP per capita (thousands of constant 2005 USD)"

order gdppc, a(gdp)
replace pop = pop/1000000
lab var pop "Population (millions)"
replace gdp = gdp/1000000
lab var gdp "GDP (million of constant 2005 USD)"

*rename ag_aid_food_mt food_aid
*lab var food_aid "Total food aid (cereals and noncereal) deliveries (FAO tonnes)"
*gen py_faid = l.food_aid
*gen py_faid_pc = py_faid * 10 / pop
*lab var py_faid_pc "Previous year annual food aid (cereals and noncereal) deliveries (100 kg per capita) (FAO)"
*gen food_aid_pc = food_aid * 1000 / 12 / pop
*lab var food_aid_pc "Average monthly food aid (cereals and noncereal) deliveries (kg per capita) (FAO)"

drop country wb_num r_tot r_urb r_youth

save "data/wdi_recode.dta", replace

exit
