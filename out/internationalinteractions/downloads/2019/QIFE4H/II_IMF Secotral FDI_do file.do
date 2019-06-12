*The Catalytic Effect of IMF Lending: Evidence from FDI Sectoral Data
*Tests conducted with Stata v. 13.
*The following user-written commands were used: outreg2, itreatreg, parmby. 
*Note: In this versino of the log file, tests that require user-written commands are blocked out. Install these commands and unblock code to obtain the results in the manuscript

drop if id == .
tsset id year
*rescaling
gen sfdigdp = (bx_klt_dinv_wd_gd_zs-3.297611)/4.912393
gen sgrowth = (ny_gdp_mktp_kd_zg-3.838769)/5.974104
gen gdppct = gdppckd/1000
gen ltradegdp = ln(ne_trd_gnfs_zs)
gen govconb = necongovtkd/1000
gen usaidb = usaid/1000
gen reservesb = fi_res_totl_cd/1000000000
gen sinflation = (fp_cpi_totl_zg-65.60288)/471.668
gen wFDIb = worldFDIflows/1000 

gen nonconcessional = imfsba + imfeff 
replace nonconcessional = 1 if nonconcessional == 2
gen concessional = imfprgf + imfsaf
replace concessional = 1 if concessional == 2

*Full specification
global economy = "sfdigdp gdppct lgdp sgrowth ltradegdp govconb kaopen checks usaidb"
global treatment = "L.imfprogram L.fi_res_totl_cd L.fp_cpi_totl_zg L.gdppckd L.lgdp L.ny_gdp_mktp_kd_zg Lc.fi_res_totl_cd#L.imfprogram Lc.fp_cpi_totl_zg#L.imfprogram Lc.gdppckd#L.imfprogram Lc.lgdp#L.imfprogram Lc.ny_gdp_mktp_kd_zg#L.imfprogram" 

* Table 2 -  IMF programs and sectoral FDI/GDP
*LOW SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*233	Construction/30200
*235	Construction
*236	Construction
*315	Textiles, Clothing, and Leather/20200
*330	Metal and Metal Products/20900
***** 421	Trade/30330 Wholesale Trade, Durable Goods
***** 423	Trade/30330 Merchant Wholesalers, Durable Goods
***** 525	Finance
quietly xi: treatreg F.s30200gdp s30200gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg F.s20200gdp s20200gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m2 
quietly xi: treatreg F.s20900gdp s20900gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m3
quietly xi: treatreg F.s30600gdp s30600gdp $economy  i.id i.year, treat(imfprogram = $treatment)  vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m4

*LOW SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*446	Trade/Health and Personal Care Stores
*454	Trade/Nonstore Retailers
*518	Data processing, hosting, and related services - excluded
*531	Business Activities/Real estate services 30720 - excluded
*561	Community, Social, and Personal Service/31000
*621	Health and Social Services/30900
quietly reg F.s31000gdp s31000gdp $economy imfprogram i.id i.year, vce(cluster id)
estimates table, keep($economy imfprogram) b p
est store m5
quietly reg F.s30900gdp s30900gdp $economy imfprogram i.id i.year, vce(cluster id)
estimates table, keep($economy imfprogram) b p
est store m6
*xi: treatreg F.s30900gdp s30900gdp $economy  i.id i.year, treat(imfprogram = $treatment) 

*HIGH SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*221	Utilities, Electricity, Gas, and Water
*532	Business Activities/Rental and leasing services/30730 - virtually no obs
quietly xi: treatreg F.s30100gdp s30100gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m7

*HIGH SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*212	Note - Mining and Petroleum does not produce a Wald test statistic using RSE. Normal standard errors reported for this sector
*213	Note - Mining and Petroleum does not produce a Wald test statistic using RSE. Normal standard errors reported for this sector
*482	Transport, Storage, and Communications
*486	Transport, Storage, and Communications
*713	
quietly xi: treatreg F.s10200gdp s10200gdp $economy  i.id i.year, treat(imfprogram = $treatment)
estimates table, keep($economy imfprogram) b p
est store m8
quietly xi: treatreg F.s30500gdp s30500gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m9
*outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using table2, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(3) symbol(***, **, *) nocons

* Table 3 - IMF programs and the distribution of FDI
***Distribution of FDI

gen lfd30200z = ln(F.fditot30200)
gen lfd20200z = ln(F.fditot20200)
gen lfd20900z = ln(F.fditot20900)
gen lfd30600z = ln(F.fditot30600)
gen lfd31000z = ln(F.fditot31000)
gen lfd30900z = ln(F.fditot30900)
gen lfd30100z = ln(F.fditot30100)
gen lfd10200z = ln(F.fditot10200)
gen lfd30500z = ln(F.fditot30500)

gen lfd30200z2 = ln(fditot30200)
gen lfd20200z2 = ln(fditot20200)
gen lfd20900z2 = ln(fditot20900)
gen lfd30600z2 = ln(fditot30600)
gen lfd31000z2 = ln(fditot31000)
gen lfd30900z2 = ln(fditot30900)
gen lfd30100z2 = ln(fditot30100)
gen lfd10200z2 = ln(fditot10200)
gen lfd30500z2 = ln(fditot30500)

quietly xi: treatreg lfd30200z lfd30200z2 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg lfd20200z lfd20200z2 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: treatreg lfd20900z lfd20900z2 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m3
quietly xi: treatreg lfd30600z lfd30600z2 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m4
quietly reg lfd31000z lfd31000z2 $economy imfprogram  i.id i.year, vce(cluster id)
estimates table, keep($economy imfprogram) b p
est store m5
quietly reg lfd30900z lfd30900z2 $economy imfprogram i.id i.year, vce(cluster id)
estimates table, keep($economy imfprogram) b p
est store m6
quietly xi: treatreg lfd30100z lfd30100z2 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m7
quietly xi: treatreg lfd10200z lfd10200z2 $economy  i.id i.year, treat(imfprogram = $treatment)
estimates table, keep($economy imfprogram) b p
est store m8
quietly xi: treatreg lfd30500z lfd30500z2 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m9
*outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using table3, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Table 4 -  IMF program design and sectoral FDI (interactions)
* Note(the relevant command -itreatreg- must be installed to produce this table - the variable in gen() needs to be entered differently each time the code is run
*** Interactions with conditionality
gen loansize2 = loansize/100
drop loansize
rename loansize2 loansize

global economy = "sfdigdp gdppct lgdp sgrowth ltradegdp govconb kaopen checks usaidb"
global treatment = "L.imfprogram L.fi_res_totl_cd L.fp_cpi_totl_zg L.gdppckd L.lgdp L.ny_gdp_mktp_kd_zg Lc.fi_res_totl_cd#L.imfprogram Lc.fp_cpi_totl_zg#L.imfprogram Lc.gdppckd#L.imfprogram Lc.lgdp#L.imfprogram Lc.ny_gdp_mktp_kd_zg#L.imfprogram" 

quietly xi: itreatreg fs30200gdp s30200gdp $economy  i.id i.year, treat(imfprogram = $treatment) x(imfprogramXcon=logtotalcon_alt) gen(xx21)
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: itreatreg fs20900gdp s20900gdp $economy  i.id i.year, treat(imfprogram = $treatment) x(imfprogramXcon=logtotalcon_alt) gen(xx31)
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: itreatreg fs30600gdp s30600gdp $economy  i.id i.year, treat(imfprogram = $treatment) x(imfprogramXcon=logtotalcon_alt) gen(xx41)
estimates table, keep($economy imfprogram) b p
est store m3
quietly xi: itreatreg fs30200gdp s30200gdp $economy i.id i.year, treat(imfprogram=$treatment) x(imfprogramXloansize=loansize) gen(xx51)
estimates table, keep($economy imfprogram) b p
est store m4
*DOES NOT CONVERGE xi: itreatreg fs20900gdp s20900gdp $economy i.id i.year, treat(imfprogram=$treatment) x(imfprogramXloansize=loansize) gen(xx6)
*est store m5
quietly xi: itreatreg fs30600gdp s30600gdp $economy i.id i.year, treat(imfprogram=$treatment) x(imfprogramXloansize=loansize) gen(xx71)
estimates table, keep($economy imfprogram) b p
est store m5
*outreg2 [m1 m2 m3 m4 m5] using table4, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Figure 1
* This figure was constructed using the user written command parmby. Download and run this command using the following base specification:
* global economy = "bx_klt_dinv_wd_gd_zs gdppckd lgdp ny_gdp_mktp_kd_zg ne_trd_gnfs_zs necongovtkd kaopen checks usaid"
* global treatment = "L.imfprogram L.fi_res_totl_cd L.fp_cpi_totl_zg L.gdppckd L.lgdp L.ny_gdp_mktp_kd_zg Lc.fi_res_totl_cd#L.imfprogram Lc.fp_cpi_totl_zg#L.imfprogram Lc.gdppckd#L.imfprogram Lc.lgdp#L.imfprogram Lc.ny_gdp_mktp_kd_zg#L.imfprogram" 
* The command creates a second dataset which requires cleaning and manual steps to create and combine separate panels into Figure 1

**** Supplementary Information begins here

*Table A1
*Descriptive statistics
tabstat imfprogram s20400gdp s10200gdp s20300gdp s30100gdp s30300gdp s30700gdp s30200gdp s20600gdp s30600gdp s21000gdp s20200gdp $economy, stat(mean sd min max n) col(stat)

*Table A2
*Countries in sample
tabstat fdi30200 fdi20200 fdi20900 fdi30600 fdi31000 fdi30900 fdi30100 fdi10200 fdi30500, by(countryname) stat(n)

*Table A3 - Sunk costs by sector
*Data for this table is from Compustat

*Table A4 - Dependence on external finance by sector
*Data for this table is from Compustat

*Table A5 - Gen
* This model follows the same specification as Baur et al (2012)
global economy = "bx_klt_dinv_wd_gd_zs gdppct lgdp ny_gdp_mktp_kd_zg ne_trd_gnfs_zs govconb wFDIb kaopen checks usaidb"
global treatment = "L.imfprogram L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg Lc.reservesb#L.imfprogram Lc.sinflation#L.imfprogram Lc.gdppct#L.imfprogram Lc.lgdp#L.imfprogram Lc.ny_gdp_mktp_kd_zg#L.imfprogram" 
quietly xi: treatreg F.bx_klt_dinv_wd_gd_zs $economy  i.id i.year, treat(imfprogram = $treatment)
est store base
estimates table, keep($economy imfprogram) b p
*outreg2 [base] using tablea5, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, LDV, YES) bdec(3) symbol(***, **, *) nocons
gen in_model = e(sample)
probit imfprogram $treatment if  in_model==1
estat classification

* Table A6 and A7 - BEA log of FDI/GDP
global economy = "sfdigdp gdppct lgdp sgrowth ltradegdp govconb kaopen checks usaidb"
global treatment = "L.imfprogram L.fi_res_totl_cd L.fp_cpi_totl_zg L.gdppckd L.lgdp L.ny_gdp_mktp_kd_zg Lc.fi_res_totl_cd#L.imfprogram Lc.fp_cpi_totl_zg#L.imfprogram Lc.gdppckd#L.imfprogram Lc.lgdp#L.imfprogram Lc.ny_gdp_mktp_kd_zg#L.imfprogram" 
* BEA regressions
 gen x_man_total_manufacturing =  man_total_manufacturing/nygdpmktpkd 
 gen x_man_food = man_food/nygdpmktpkd 
 gen x_man_chemicals = man_chemicals/nygdpmktpkd  
 gen x_man_primary_fabricated_metals = man_primary_fabricated_metals/nygdpmktpkd  
 gen x_man_machinery =  man_machinery/nygdpmktpkd  
 gen x_man_computers_electronics = man_computers_electronics/nygdpmktpkd  
 gen x_man_electrical_appliances = man_electrical_appliances/nygdpmktpkd 
 gen x_man_transportation_equipment =  man_transportation_equipment/nygdpmktpkd  
 gen x_man_other_manufacturing = man_other_manufacturing/nygdpmktpkd 
 gen x_all_industries_total = all_industries_total/nygdpmktpkd 
 gen x_mining = mining/nygdpmktpkd 
 gen x_utilities =   utilities/nygdpmktpkd 
 gen x_wholesale_trade = wholesale_trade/nygdpmktpkd  
 gen x_information =  information/nygdpmktpkd  
 gen x_depository_institutions =  depository_institutions/nygdpmktpkd 
 gen x_finance_insurance =  finance_insurance/nygdpmktpkd
 gen x_professional_ss =  professional_scientific_services/nygdpmktpkd  
 gen x_holding_companies = holding_companies/nygdpmktpkd 

 gen lx_man_total_manufacturing =  ln(x_man_total_manufacturin)
 gen lx_man_food = ln(x_man_food) 
 gen lx_man_chemicals = ln(x_man_chemicals)  
 gen lx_man_primary_fabricated_metals = ln(x_man_primary_fabricated_metals)  
 gen lx_man_machinery =  ln(x_man_machinery)  
 gen lx_man_computers_electronics = ln(x_man_computers_electronics)  
 gen lx_man_electrical_appliances = ln(x_man_electrical_appliances) 
 gen lx_man_transportation_equipment =  ln(x_man_transportation_equipment)  
 gen lx_man_other_manufacturing = ln(x_man_other_manufacturing)
 gen lx_all_industries_total = ln(x_all_industries_total) 
 gen lx_mining = ln(x_mining) 
 gen lx_utilities =   ln(x_utilities)
 gen lx_wholesale_trade = ln(x_wholesale_trade)  
 gen lx_information =  ln(x_information)  
 gen lx_depository_institutions =  ln(x_depository_institutions) 
 gen lx_finance_insurance =  ln(x_finance_insurance)
 gen lx_professional_ss =  ln(x_professional_ss) 
 gen lx_holding_companies = ln(x_holding_companies)
 
reg F.lx_man_total_manufacturing $economy imfprogram i.id i.year, vce(robust)
est store m1
reg F.lx_man_food $economy imfprogram i.id i.year, vce(robust)
est store m2
reg F.lx_man_chemicals $economy imfprogram i.id i.year, vce(robust)
est store m3
reg F.lx_man_primary_fabricated_metals $economy imfprogram i.id i.year, vce(robust)
est store m4
reg F.lx_man_machinery $economy imfprogram i.id i.year, vce(robust)
est store m5
reg F.lx_man_computers_electronics $economy imfprogram i.id i.year, vce(robust)
est store m6
reg F.lx_man_electrical_appliances $economy imfprogram i.id i.year, vce(robust)
est store m7
reg F.lx_man_transportation_equipment $economy imfprogram i.id i.year, vce(robust)
est store m8
reg F.lx_man_other_manufacturing $economy imfprogram i.id i.year, vce(robust)
est store m9
reg F.lx_all_industries_total $economy imfprogram i.id i.year, vce(robust)
est store m10
reg F.lx_mining $economy imfprogram i.id i.year, vce(robust)
est store m11
reg F.lx_utilities $economy imfprogram i.id i.year, vce(robust)
est store m12
reg F.lx_wholesale_trade $economy imfprogram i.id i.year, vce(robust)
est store m13
reg F.lx_information $economy imfprogram i.id i.year, vce(robust)
est store m14
reg F.lx_depository_institutions $economy imfprogram i.id i.year, vce(robust)
est store m15
reg F.lx_finance_insurance $economy imfprogram i.id i.year, vce(robust)
est store m16 
reg F.lx_professional_ss $economy imfprogram i.id i.year, vce(robust)
est store m17 
reg F.lx_holding_companies $economy imfprogram i.id i.year, vce(robust)
est store m18 
*outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15 m16 m17 m18] using tablea6-7, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Table A8 - Log of FDI/raw/unscaled
***Log transformation of raw FDI
gen lfdi30200 = ln(fdi30200)
gen lfdi20200 = ln(fdi20200)
gen lfdi20900 = ln(fdi20900)
gen lfdi30600 = ln(fdi30600)
gen lfdi31000 = ln(fdi31000)
gen lfdi30900 = ln(fdi30900)
gen lfdi30100 = ln(fdi30100)
gen lfdi10200 = ln(fdi10200)
gen lfdi30500 = ln(fdi30500)

*LOW SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*233	Construction/30200
*235	Construction
*236	Construction
*315	Textiles, Clothing, and Leather/20200
*330	Metal and Metal Products/20900
***** 421	Trade/30330 Wholesale Trade, Durable Goods
***** 423	Trade/30330 Merchant Wholesalers, Durable Goods
***** 525	Finance
quietly xi: treatreg F.lfdi30200 lfdi30200 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg F.lfdi20200 lfdi20200 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust) 
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: treatreg F.lfdi20900 lfdi20900 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m3
quietly xi: treatreg F.lfdi30600 lfdi30600 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m4

*LOW SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*446	Trade/Health and Personal Care Stores
*454	Trade/Nonstore Retailers
*518	Data processing, hosting, and related services - excluded
*531	Business Activities/Real estate services 30720 - excluded
*561	Community, Social, and Personal Service/31000
*621	Health and Social Services/30900
reg F.lfdi31000 lfdi31000 $economy imfprogram i.id i.year, vce(robust)
est store m5
reg F.lfdi30900 lfdi30900 $economy imfprogram i.id i.year, vce(robust)
est store m6

*HIGH SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*221	Utilities, Electricity, Gas, and Water
*532	Business Activities/Rental and leasing services/30730 - virtually no obs
quietly xi: treatreg F.lfdi30100 lfdi30100 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m7

*HIGH SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*212	Oil, Gas, and Mining
*213	Oil, Gas, and Mining
*482	Transport, Storage, and Communications
*486	Transport, Storage, and Communications
*713	
quietly xi: treatreg F.lfdi10200 lfdi10200 $economy  i.id i.year, treat(imfprogram = $treatment)
estimates table, keep($economy imfprogram) b p
est store m8
quietly xi: treatreg F.lfdi30500 lfdi30500 $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m9
*outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using tablea8, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Table A9 - Change in FDI/GDP
*LOW SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*233	Construction/30200
*235	Construction
*236	Construction
*315	Textiles, Clothing, and Leather/20200
*330	Metal and Metal Products/20900
***** 421	Trade/30330 Wholesale Trade, Durable Goods
***** 423	Trade/30330 Merchant Wholesalers, Durable Goods
***** 525	Finance
quietly xi: treatreg FD.s30200gdp s30200gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg FD.s20200gdp s20200gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: treatreg FD.s20900gdp s20900gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m3
quietly xi: treatreg FD.s30600gdp s30600gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m4

*LOW SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*446	Trade/Health and Personal Care Stores
*454	Trade/Nonstore Retailers
*518	Data processing, hosting, and related services - excluded
*531	Business Activities/Real estate services 30720 - excluded
*561	Community, Social, and Personal Service/31000
*621	Health and Social Services/30900
reg FD.s31000gdp s31000gdp $economy imfprogram i.id i.year, vce(robust)
est store m5
reg FD.s30900gdp s30900gdp $economy imfprogram i.id i.year, vce(robust)
est store m6

*HIGH SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*221	Utilities, Electricity, Gas, and Water
*532	Business Activities/Rental and leasing services/30730 - virtually no obs
quietly xi: treatreg FD.s30100gdp s30100gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m7

*HIGH SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*212	Oil, Gas, and Mining
*213	Oil, Gas, and Mining
*482	Transport, Storage, and Communications
*486	Transport, Storage, and Communications
*713	
quietly xi: treatreg FD.s10200gdp s10200gdp $economy  i.id i.year, treat(imfprogram = $treatment) 
estimates table, keep($economy imfprogram) b p
est store m8
quietly xi: treatreg FD.s30500gdp s30500gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m9
*outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using tablea9, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

*Table A10 - 3-year moving average of FDI
foreach var of varlist s10000gdp-s31200gdp {
generate mave3`var' =(F1.`var' + `var' + L1.`var')/ 3
}
  
*LOW SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*233	Construction/30200
*235	Construction
*236	Construction
*315	Textiles, Clothing, and Leather/20200
*330	Metal and Metal Products/20900
***** 421	Trade/30330 Wholesale Trade, Durable Goods
***** 423	Trade/30330 Merchant Wholesalers, Durable Goods
***** 525	Finance
quietly xi: treatreg mave3s30200gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg mave3s20200gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: treatreg mave3s20900gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m3
quietly xi: treatreg mave3s30600gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m4

*LOW SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*446	Trade/Health and Personal Care Stores
*454	Trade/Nonstore Retailers
*518	Data processing, hosting, and related services - excluded
*531	Business Activities/Real estate services 30720 - excluded
*561	Community, Social, and Personal Service/31000
*621	Health and Social Services/30900
reg mave3s31000gdp $economy imfprogram i.id i.year, vce(robust)
est store m5
reg mave3s30900gdp $economy imfprogram i.id i.year, vce(robust)
est store m6

*HIGH SUNK COSTS AND HIGH DEPENDENCE ON EXTERNAL FINANCE	
*221	Utilities, Electricity, Gas, and Water
*532	Business Activities/Rental and leasing services/30730 - virtually no obs
quietly xi: treatreg mave3s30100gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m7

*HIGH SUNK COSTS AND LOW DEPENDENCE ON EXTERNAL FINANCE	
*212	Oil, Gas, and Mining
*213	Oil, Gas, and Mining
*482	Transport, Storage, and Communications
*486	Transport, Storage, and Communications
*713	
quietly xi: treatreg mave3s10200gdp $economy  i.id i.year, treat(imfprogram = $treatment)
estimates table, keep($economy imfprogram) b p
est store m8
quietly xi: treatreg mave3s30500gdp $economy  i.id i.year, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m9
*outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using tablea10, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Table A11 - Concessional/nc checks on statistically significant sectors. Simple TFX model as many do not converge with full spec
quietly xi: treatreg F.s30200gdp s30200gdp $economy  i.id i.year, treat(concessional = L.concessional L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg)
estimates table, keep($economy concessional) b p
est store m1
quietly xi: treatreg F.s20900gdp s20900gdp $economy  i.id i.year, treat(concessional = L.concessional L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg)
estimates table, keep($economy concessional) b p
est store m2
quietly xi: treatreg F.s30600gdp s30600gdp $economy  i.id i.year, treat(concessional = L.concessional L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) 
estimates table, keep($economy concessional) b p
est store m3
quietly xi: treatreg F.s30200gdp s30200gdp $economy  i.id i.year, treat(nonconcessional = L.nonconcessional L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) 
estimates table, keep($economy nonconcessional) b p
est store m4
quietly xi: treatreg F.s20900gdp s20900gdp $economy  i.id i.year, treat(nonconcessional = L.nonconcessional L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) 
estimates table, keep($economy nonconcessional) b p
est store m5
quietly xi: treatreg F.s30600gdp s30600gdp $economy  i.id i.year, treat(nonconcessional = L.nonconcessional L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg)
estimates table, keep($economy nonconcessional) b p
est store m6
*outreg2 [m1 m2 m3 m4 m5 m6] using tablea11, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Table A12 - treatment effects without interactions in first stage (statistically significant sectors)
quietly xi: treatreg F.s30200gdp s30200gdp $economy  i.id i.year, treat(imfprogram = L.imfprogram L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg F.s20900gdp s20900gdp $economy  i.id i.year, treat(imfprogram = L.imfprogram L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: treatreg F.s30600gdp s30600gdp $economy  i.id i.year, treat(imfprogram = L.imfprogram L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m3
*outreg2 [m1 m2 m3] using tablea12, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

*Table A13 - Log of FDI/GDP 1995-2008
*Some models do not converge so we use a basic specifciation
quietly xi: treatreg F.s30200gdp s30200gdp $economy  i.id i.year if year > 1994, treat(imfprogram = L.imfprogram L.reservesb L.sinflation L.gdppct L.lgdp L.ny_gdp_mktp_kd_zg) 
estimates table, keep($economy imfprogram) b p
est store m1
quietly xi: treatreg F.s20900gdp s20900gdp $economy  i.id i.year if year > 1994, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m2
quietly xi: treatreg F.s30600gdp s30600gdp $economy  i.id i.year if year > 1994, treat(imfprogram = $treatment) vce(robust)
estimates table, keep($economy imfprogram) b p
est store m3
*outreg2 [m1 m2 m3] using tablea13, word replace auto(2) eqdrop(athrho lnsigma) sortvar()  drop() keep() e(ll lambda sigma rho chi2 chi2_c p_c) addtext(Country FE, YES, Year FE, YES, LDV, YES) bdec(2) symbol(***, **, *) nocons

* Model checks - reported in main text
* xtunitroot fisher s30200gdp, dfuller drift lags(2) demean
*Does not produce test statistic* xtunitroot fisher s20900gdp, dfuller drift lags(2) demean
* xtunitroot fisher s30600gdp, dfuller drift lags(2) demean

* reg F.s30200gdp s30200gdp $economy
* vif
* reg F.s20900gdp s20900gdp $economy
* vif
* reg F.s30600gdp s30600gdp $economy
* vif
