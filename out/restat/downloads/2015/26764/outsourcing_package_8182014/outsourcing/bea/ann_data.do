cd "H:\anndata\"
clear
set more off
set mem 400m

capture log close
log using H:\logs\ann_data.log, replace

/*================================================
 Program: ann_data.do
 Author:  Avi Ebenstein
 Created: June 2007
 Purpose: Take Andrew Waxman's code to create 
          annual data sets from the Access tables. 
          The ODBC commands allow STATA to talk to
          Access, and then we merge across Access
          tables by the entity ID number. The
          names are changed slightly so that they
          will agree over the years.
Note: This program sputters through producing 
cautionary messages in red because several variables
sotred in hte acces database are unacceptable as 
stata variable names.
=================================================*/

/*
odbc load, table(11B77RF1) dsn(77B)
rename Aff_cty country
rename Sales sales
rename Assets assets
rename Employment emp
rename Aff_ind industry
gen year=1977
save aff1977,replace
clear
*/

/* Since researchers are now mapping to the S drive, all the ODBC links need to be changed from L to S */

odbc load, table(11B82RF5) dsn(82B)
keep ENTITY_ID_10 NAME_82 PAR_ID_6 AFF_ID_4 IND_82  CTY_82 PTR_82 NET_INCOME_82  FOREIGN_INC_TAX_82 DEPLETION_82 OTH_TAX_82 PROD_ROYAL_82 SUBSIDIES_82 CCA_82 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename IND_82 industry
rename NAME_82 name
rename CTY_82 country
rename PTR_82 ptr
rename NET_INCOME_82 net_income
rename FOREIGN_INC_TAX_82 foreign_inc_tax
rename DEPLETION_82 depletion
rename OTH_TAX_82 oth_tax
rename PROD_ROYAL_82 prod_royal
rename SUBSIDIES_82 subsidies
rename CCA_82 cca
sort ENTITY_ID_10
save 82RF5, replace
clear

odbc load, table(11B82RF1) dsn(82B)
keep  Aff_ID_alpha_8 Par_ID_6 Aff_ID_4 var19 var29 Inventories_82 Oth_cur_assets_82 var91 Assets_82 Long_term_debt_82 Total_income_82 Foreign_income_tax_82 Net_income_82
rename Par_ID_6 us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename Aff_ID_4 foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
rename var19 Own_direct_fa
rename var29 Own_indirect_fa
rename var91 net_ppe 
rename Inventories_82 inventories
rename Oth_cur_assets_82 oth_cur_assets
rename Assets_82 assets
rename Long_term_debt_82 LTdebt
rename Total_income_82 tot_income
rename Foreign_income_tax_82 foreign_inc_tax
rename Net_income_82 net_income2
sort ENTITY_ID_10
save 82RF1, replace
clear

odbc load, table(11B82RF2) dsn(82B)
rename Par_ID_6 us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename Aff_ID_4 foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
rename var9 maj_min
rename var13 PPE_exp_min
rename var23 Curr_Depr_Depl
rename Employment_82 emp
rename Sales_tot_82 sales
rename var26 Acc_Depr_Depl
rename var30 Chg_oth_ED
rename var31 Cap_ED_exp
rename var32 Tot_ED 
rename Exp_land_tim_min_82 exp_land_tim_min
rename Chg_mineral_rights_82 chg_mineral_rights
sort ENTITY_ID_10
save 82RF2, replace
clear

odbc load, table(11B82RF3) dsn(82B)
keep Aff_ID_alpha_8  Par_ID_6 Aff_ID_4 Exp_crude_82 Exp_crude_usrep_82 Exp_crude_o_us_82 Exp_pet_82 Exp_pet_usrep_82 Exp_pet_o_us_82 Exp_coal_82 Exp_coal_usrep_82 Exp_coal_o_us_82 Exp_metal_82 Exp_metal_usrep_82 Exp_metal_o_us_82
rename Par_ID_6 us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename Aff_ID_4 foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
rename Exp_crude_82 exp_crude
rename Exp_crude_usrep_82 exp_crude_usrep
rename Exp_crude_o_us_82 exp_crude_o_us
rename Exp_pet_82 exp_pet
rename Exp_pet_usrep_82 exp_pet_usrep
rename Exp_pet_o_us_82 exp_pet_o_us
rename Exp_coal_82 exp_coal
rename Exp_coal_usrep_82 exp_coal_usrep
rename Exp_coal_o_us_82 exp_coal_o_us
rename Exp_metal_82 exp_metal
rename Exp_metal_usrep_82 exp_metal_usrep
rename Exp_metal_o_us_82 exp_metal_o_us
sort ENTITY_ID_10
merge ENTITY_ID_10 using 82RF5 82RF1 82RF2
tabulate _merge1
tabulate _merge2
tabulate _merge3
drop _merge1 _merge2 _merge3 _merge
ge year=1982
**drop if industry<=100 | industry>=148
save aff1982, replace
clear

odbc load, table(11B83RF5) dsn(83B)
keep ENTITY_ID_10 NAME_83 PAR_ID_6 AFF_ID_4  INDUSTRY_83  COUNTRY_83 PTR_83 NET_INCOME_83  FOREIGN_INC_TAX_83 DEPLETION_83 OTH_TAX_83 PROD_ROYAL_83  CCA_83
rename INDUSTRY_83 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_83 country
rename NAME_83 name
rename	PTR_83 ptr
rename	NET_INCOME_83 net_income
rename	 FOREIGN_INC_TAX_83 foreign_inc_tax
rename DEPLETION_83 depletion
rename OTH_TAX_83 oth_tax
rename	PROD_ROYAL_83 prod_royal
rename	CCA_83 cca
sort ENTITY_ID_10
save 82RF5, replace
clear

odbc load, table(11B83RF) dsn(83B)
keep  ENTITY_ID_10 Doc_type_83  Inventories_83 Employment_83 Oth_cur_assets_83 var32 var33  Oth_noncur_assets_83 Assets_83  Current_liab_83 var37 Sales_83 Total_income_83  Foreign_inc_tax_83  Net_income_83  var53  Other_tax_83
rename var32 Gross_ppe 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var33 Acc_Depr_Depl
rename var37 LT_debt
rename var53 Curr_Depr_Depl
ge liab_debt=Current_liab_83+LT_debt
rename Doc_type_83 doc_type
rename Inventories_83 inventories
rename Employment_83 emp
rename Oth_cur_assets_83 oth_cur_assets
rename Oth_noncur_assets_83 oth_noncur_assets
rename Assets_83 assets
rename Current_liab_83 curr_liab
rename Sales_83 sales
rename Total_income_83 tot_income
rename Foreign_inc_tax_83  foreign_inc_tax
rename Net_income_83 net_income2
rename Other_tax_83 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 82RF5
ge year=1983
tabulate _merge
drop _merge
**drop if industry<=100 | industry>=148
save aff1983, replace
clear

odbc load, table(11B84RF5) dsn(84B)
keep ENTITY_ID_10 NAME_84 PAR_ID_6 AFF_ID_4  COUNTRY_84  INDUSTRY_84 PTR_84 NET_INCOME_84  FOREIGN_INC_TAX_84 DEPLETION_84 OTH_TAX_84 PROD_ROYAL_84 CCA_84
rename INDUSTRY_84 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_84 country
rename NAME_84 name
rename	PTR_84 ptr
rename	NET_INCOME_84 net_income
rename	 FOREIGN_INC_TAX_84 foreign_inc_tax
rename DEPLETION_84 depletion
rename OTH_TAX_84 oth_tax
rename	PROD_ROYAL_84 prod_royal
rename	CCA_84 cca
sort ENTITY_ID_10
save 84RF5, replace
clear

odbc load, table(11B84RF) dsn(84B)
keep ENTITY_ID_10 Doc_type_84 var30  Employment_84 Inventories_84 Oth_cur_assets_84 var30 var31  Oth_noncur_assets_84 Assets_84  Current_liab_84 var35 Sales_84 Total_income_84  Foreign_inc_tax_84  Net_income_84  var51  Other_tax_84
rename var30 Gross_ppe  
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var31 Acc_Depr_Depl
rename Employment_84 emp
rename var35 LT_debt
rename var51 Curr_Depr_Depl
ge liab_debt=Current_liab_84+LT_debt
rename Doc_type_84 doc_type
rename Inventories_84 inventories
rename Oth_cur_assets_84 oth_cur_assets
rename Oth_noncur_assets_84 oth_noncur_assets
rename Assets_84 assets
rename Current_liab_84 cur_liab_84
rename Sales_84 sales
rename Total_income_84 tot_income
rename Foreign_inc_tax_84  foreign_inc_tax
rename Net_income_84  net_income2
rename Other_tax_84 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 84RF5
ge year=1984
tabulate _merge
drop _merge
**drop if industry<=100 | industry>=148
save aff1984, replace
clear

odbc load, table(11B85RF5) dsn(85B)
keep ENTITY_ID_10 NAME_85 PAR_ID_6 AFF_ID_4  COUNTRY_85  INDUSTRY_85 PTR_85 NET_INCOME_85  FOREIGN_INC_TAX_85 DEPLETION_85 OTH_TAX_85 PROD_ROYAL_85  CCA_85 
rename INDUSTRY_85 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_85 country
rename NAME_85 name
rename	PTR_85 ptr
rename	NET_INCOME_85 net_income
rename	 FOREIGN_INC_TAX_85 foreign_inc_tax
rename DEPLETION_85 depletion
rename OTH_TAX_85 oth_tax
rename	PROD_ROYAL_85 prod_royal
rename	CCA_85 cca
sort ENTITY_ID_10
save 85RF5, replace
clear

odbc load, table(11B85RF) dsn(85B)
keep ENTITY_ID_10 Doc_type_85 Inventories_85 Employment_85 Oth_cur_assets_85 var30 var31 Oth_noncur_assets_85 Assets_85 Current_liab_85 var35  Sales_85 Total_income_85 Foreign_inc_tax_85 Net_income_85 var51 Other_tax_85 Prod_royalty_85
rename var30 Gross_ppe 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var31 Acc_Depr_Depl
rename var35 LT_debt
rename var51 Curr_Depr_Depl
ge liab_debt=Current_liab_85+LT_debt
rename Doc_type_85 doc_type
rename Employment_85 emp
rename Inventories_85 inventories
rename Oth_cur_assets_85 oth_cur_assets
rename Oth_noncur_assets oth_noncur_assets
rename Assets_85 assets
rename Current_liab_85 current_liab
rename Sales_85 sales
rename Total_income_85 tot_income
rename Foreign_inc_tax_85 foreign_inc_tax
rename Net_income_85 net_income2
rename Other_tax_85 oth_tax
rename Prod_royalty_85 prod_royal2
sort ENTITY_ID_10
merge ENTITY_ID_10 using 85RF5
ge year=1985
tabulate _merge
drop _merge
*drop if industry<=100 | industry>=148
save aff1985, replace
clear

odbc load, table(11B86RF5) dsn(86B)
keep ENTITY_ID_10 NAME_86 PAR_ID_6 AFF_ID_4  COUNTRY_86 INDUSTRY_86 PTR_86 NET_INCOME_86 FOREIGN_INC_TAX_86 DEPLETION_86 OTH_TAX_86 PROD_ROYAL_86  CCA_86 
rename INDUSTRY_86 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_86 country
rename NAME_86 name
rename	PTR_86 ptr
rename	NET_INCOME_86 net_income
rename	FOREIGN_INC_~86 foreign_inc_tax
rename DEPLETION_86 depletion
rename OTH_TAX_86 oth_tax
rename	PROD_ROYAL_86 prod_royal
rename	CCA_86 cca
sort ENTITY_ID_10
save 86RF5, replace
clear

odbc load, table(11B86RF) dsn(86B)
keep ENTITY_ID_10 Doc_type_86   Employment_86 Inventories_86 Oth_cur_assets_86 var32 var33 Oth_noncur_assets_86 Assets_86 Current_liab_86 var37 Sales_86 Total_income_86 Foreign_inc_tax_86 Net_income_86 var53 Other_tax_86  Prod_royalty_86
rename var32 Gross_ppe 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var33 Acc_Depr_Depl
rename var37 LT_debt
rename var53 Curr_Depr_Depl
ge liab_debt=Current_liab_86+LT_debt
rename Doc_type_86 doc_type
rename Inventories_86 inventories
rename Employment_86 emp
rename Oth_cur_assets_86 oth_cur_assets
rename Oth_noncur_assets_86 oth_noncur_assets
rename Assets_86 assets
rename Current_liab_86 current_liab
rename Sales_86 sales
rename Total_income_86 tot_income
rename Foreign_inc_tax_86 foreign_inc_tax
rename Net_income_86 net_income2
rename Other_tax_86  oth_tax
rename Prod_royalty_86 prod_royal2
sort ENTITY_ID_10
merge ENTITY_ID_10 using 86RF5
ge year=1986
tabulate _merge
drop _merge
*drop if industry<=100 | industry>=148
save aff1986, replace
clear

odbc load, table(11B87RF5) dsn(87B)
keep ENTITY_ID_10 NAME_87 PAR_ID_6 AFF_ID_4  COUNTRY_87 INDUSTRY_87 PTR_87 NET_INCOME_87 FOREIGN_INC_TAX_87 DEPLETION_87 OTH_TAX_87 PROD_ROYAL_87 CCA_87
rename INDUSTRY_87 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_87 country
rename	PTR_87 ptr
rename NAME_87 name
rename	NET_INCOME_87 net_income
rename	FOREIGN_INC_~87 foreign_inc_tax
rename DEPLETION_87 depletion
rename OTH_TAX_87 oth_tax
rename	PROD_ROYAL_87 prod_royal
rename	CCA_87 cca
sort ENTITY_ID_10
save 87RF5, replace
clear

odbc load, table(11B87RF) dsn(87B)
keep  ENTITY_ID_10 Doc_type_87 Inventories_87 Employment_87 Oth_cur_assets_87 var32 var33 Oth_noncur_assets_87 Assets_87 Current_liab_87 var37 Sales_87 Total_income_87 Foreign_inc_tax_87 Net_income_87 var53 Other_tax_87 Prod_royalty_87
rename var32 Gross_ppe 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var33 Acc_Depr_Depl
rename var37 LT_debt
rename var53 Curr_Depr_Depl
ge liab_debt=Current_liab_87+LT_debt
rename Doc_type_87 doc_type
rename Employment_87 emp
rename Inventories_87 inventories
rename Oth_cur_assets_87 oth_cur_assets
rename Oth_noncur_assets_87 oth_noncur_assets
rename Assets_87 assets
rename Current_liab_87 current_liab
rename Sales_87 sales
rename Total_income_87 tot_income
rename Foreign_inc_tax_87 foreign_inc_tax
rename Net_income_87 net_income2
rename Other_tax_87 oth_tax
rename Prod_royalty_87 prod_royal2
sort ENTITY_ID_10
merge ENTITY_ID_10 using 87RF5
tabulate _merge
drop _merge
*drop if industry<=100 | industry>=148
ge year=1987
save aff1987, replace
clear

odbc load, table(11B88RF5) dsn(88B)
keep ENTITY_ID_10 NAME_88 PAR_ID_6 AFF_ID_4  COUNTRY_88 INDUSTRY_88 PTR_88 NET_INCOME_88 FOREIGN_INC_TAX_88 DEPLETION_88 OTH_TAX_88 PROD_ROYAL_88  CCA_88
rename INDUSTRY_88 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_88 country
rename NAME_88 name
rename	PTR_88 ptr
rename	NET_INCOME_88 net_income
rename	FOREIGN_INC_~88 foreign_inc_tax
rename DEPLETION_88 depletion
rename OTH_TAX_88 oth_tax
rename	PROD_ROYAL_88 prod_royal
rename	CCA_88 cca
sort ENTITY_ID_10
save 88RF5, replace
clear

odbc load, table(11B88RF) dsn(88B)
keep  ENTITY_ID_10 Doc_type_88 Inventories_88  Employment_88 Oth_cur_assets_88 var32 var33 Oth_noncur_assets_88 Assets_88 Current_liab_88 var37 Liabilities_88 Sales_88 Total_income_88 Foreign_inc_tax_88 Net_income_88 var53 Prod_royalty_88 Other_tax_88
rename var32 Gross_ppe 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var33 Acc_Depr_Depl
rename var37 LT_debt
rename var53 Curr_Depr_Depl
ge liab_debt=Current_liab_88+LT_debt
rename Doc_type_88 doc_type
rename Inventories_88 inventories
rename Oth_cur_assets_88 oth_cur_assets
rename Oth_noncur_assets_88 oth_noncur_assets
rename Assets_88 assets
rename Current_liab_88 current_liab
rename Liabilities_88 liabilities
rename Sales_88 sales
rename Employment_88 emp
rename Total_income_88 tot_income
rename Foreign_inc_tax_88 foreign_inc_tax
rename Net_income_88 net_income2
rename Prod_royalty_88 prod_royal2
rename Other_tax_88 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 88RF5
tabulate _merge
drop _merge
*drop if industry<=100 | industry>=148
ge year=1988
save aff1988, replace
clear

odbc load, table(11B89RF5) dsn(89B)
keep  ENTITY_ID_10 name us_id  foreign_id industry country ptr net_income  foreign_inc_tax depletion prod_royal oth_tax subsidies cca
rename us_id PAR_ID_6 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename foreign_id AFF_ID_4 
sort ENTITY_ID_10
save 89RF5, replace
clear

odbc load, table(11B89RF) dsn(89B)
keep  ENTITY_ID_10 Maj1_Min0_89 Inventories_89 Employment_89 Sales_89 Oth_cur_assets_89 Gross_ppe_89 Accum_deprec_depl_89 Oth_noncur_assets_89 Assets_89 Sales_89 Income_89 Net_income_89 O_cur_liab__lt_debt_89 Liabilities_89
rename Maj1_Min0_89 maj_min 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename Inventories_89 inventories
rename Oth_cur_assets_89 oth_cur_assets
rename Gross_ppe_89 Gross_ppe
rename Accum_deprec_depl_89 Acc_Depr_Depl
rename Oth_noncur_assets_89 oth_noncur_assets
rename Assets_89 assets
rename Employment_89 emp
rename Sales_89 sales
rename Income_89 tot_income
rename Net_income_89 net_income2
rename O_cur_liab__lt_debt_89 liab_debt
rename Liabilities_89 liabilities
sort ENTITY_ID_10
save 89RF, replace
clear

odbc load, table(EXV1) dsn(89B)
keep  entity_id us_id foreign_id doc_type  exp_expl_dev_89 prod_roy_89 oth_tax_89 subsidies_89 sales_89 depreciation_89 depletion_89 net_ppe_89
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
rename exp_expl_dev_89 Tot_ED
rename prod_roy_89 prod_royal2
rename oth_tax_89 oth_tax
rename subsidies_89 subsidies
rename depreciation_89 depreciation
rename depletion_89 depletion
rename net_ppe_89 net_ppe
sort ENTITY_ID_10
save 89exv1, replace
clear


odbc load, table("new aff 89r") dsn(89B)
keep us_id foreign_id estab
rename estab Estd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 89newaff, replace
clear

odbc load, table(EXV2) dsn(89B)
keep entity_id us_id foreign_id ex_crude ex_crude_us_rep ex_petro ex_petro_us_rep ex_coal ex_coal_us_rep ex_metal ex_metal_us_rep
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
sort ENTITY_ID_10
merge ENTITY_ID_10 using 89RF5 89RF 89exv1 89newaff
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=1989
*drop if industry<=100 | industry>=148
save aff1989, replace
clear


odbc load, table(11B90RF5) dsn(90B)
keep ENTITY_ID_10 NAME_90 PAR_ID_6 AFF_ID_4 INDUSTRY_90 COUNTRY_90 PTR_90 NET_INCOME_90 FOREIGN_INC_TAX_90 DEPLETION_90 OTH_TAX_90 PROD_ROYAL_90 CCA_90
rename INDUSTRY_90 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_90 country
rename NAME_90 name
rename	PTR_90 ptr
rename	NET_INCOME_90 net_income
rename	FOREIGN_INC_~90 foreign_inc_tax
rename DEPLETION_90 depletion
rename OTH_TAX_90 oth_tax
rename	PROD_ROYAL_90 prod_royal
rename	CCA_90 cca
sort ENTITY_ID_10
save 90RF5, replace
clear

odbc load, table(11B90RF) dsn(90B)
keep   ENTITY_ID_10  var13  var15 var16 var17 Employment_90 var18 Inventories_90 Oth_cur_assets_90 var35 var36 Oth_noncur_assets_90 Assets_90 var40 Sales_90 Total_income_90 Foreign_income_tax_90 Net_income_90 var57 Prod_royalty_90 Other_tax_90
rename var13 doc_type 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var15 Own_direct
rename var16 Own_indirect
rename var17 Own_total
rename var18 Estd
rename var35 Gross_ppe
rename var36 Acc_Depr_Depl
rename var40 liab_debt
rename Employment_90 emp
rename var57 Curr_Depr_Depl
rename Inventories_90 inventories
rename Oth_cur_assets_90 oth_cur_assets
rename Oth_noncur_assets_90 oth_noncur_assets
rename Assets_90 assets
rename Sales_90 sales
rename Total_income_90 tot_income
rename Foreign_income_tax_90 foreign_inc_tax
rename Net_income_90 net_income2
rename Prod_royalty_90 prod_royal2
rename Other_tax_90 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 90RF5
tabulate _merge
drop _merge
*drop if industry<=100 | industry>=148
ge year=1990
save aff1990, replace
clear

odbc load, table(11B91RF5) dsn(91B)
keep  ENTITY_ID_10 NAME_91 PAR_ID_6 AFF_ID_4 INDUSTRY_91 COUNTRY_91 PTR_91 NET_INCOME_91 FOREIGN_INC_TAX_91 DEPLETION_91 OTH_TAX_91 PROD_ROYAL_91 CCA_91
rename INDUSTRY_91 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_91 country
rename NAME_91 name
rename	PTR_91 ptr
rename	NET_INCOME_91 net_income
rename	FOREIGN_INC_TAX_91 foreign_inc_tax
rename DEPLETION_91 depletion
rename OTH_TAX_91 oth_tax
rename	PROD_ROYAL_91 prod_royal
rename	CCA_91 cca
sort ENTITY_ID_10
save 91RF5, replace
clear

odbc load, table(11B91RF) dsn(91B)
keep  ENTITY_ID_10 var13 var15 Employment_91 var16 var17 var18 Inventories_91 Oth_cur_assets_91 var35 var36 Oth_noncur_assets_91 Assets_91 var40  Sales_91 Total_income_91 Foreign_income_tax_91 Net_income_91 var57 Prod_royalty_91 Other_tax_91
rename var13 doc_type 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var15 Own_direct
rename var16 Own_indirect
rename var17 Own_total
rename var18 Estd
rename var35 Gross_ppe
rename Employment_91 emp
rename var36 Acc_Depr_Depl
rename var40 liab_debt
rename var57 Curr_Depr_Depl
rename Inventories_91 inventories
rename Oth_cur_assets_91 oth_cur_assets
rename Oth_noncur_assets_91 oth_noncur_assets
rename Assets_91 assets
rename Sales_91 sales
rename Total_income_91 tot_income
rename Foreign_income_tax_91 foreign_income_tax
rename Net_income_91 net_income2
rename Prod_royalty_91 prod_royal
rename Other_tax_91 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 91RF5
tabulate _merge
drop _merge
ge year=1991
*drop if industry<=100 | industry>=148
save aff1991, replace
clear

odbc load, table(11B92RF5) dsn(92B)
keep  ENTITY_ID_10 NAME_92 PAR_ID_6 AFF_ID_4 INDUSTRY_92 COUNTRY_92 PTR_92 NET_INCOME_92 FOREIGN_INC_TAX_92 DEPLETION_92 OTH_TAX_92 PROD_ROYAL_92 CCA_92
rename INDUSTRY_92 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	COUNTRY_92 country
rename NAME_92 name
rename	PTR_92 ptr
rename	NET_INCOME_92 net_income
rename	FOREIGN_INC_~92 foreign_inc_tax
rename DEPLETION_92 depletion
rename OTH_TAX_92 oth_tax
rename	PROD_ROYAL_92 prod_royal
rename	CCA_92 cca
sort ENTITY_ID_10
save 82RF5, replace
clear

odbc load, table(11B92RF) dsn(92B)
keep   ENTITY_ID_10 Doc_type_92 Employment_92 var15 var16 var17 Est_code_92 Inventories_92 Oth_cur_assets_92 var35 var36 Oth_noncur_assets_92 Assets_92 var40  Sales_92 Total_income_92 Foreign_income_tax_92 Net_income_92 var57 Prod_royalty_92 Oth_tax_92
rename Doc_type_92 doc_type 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename var15 Own_direct
rename var16 Own_indirect
rename var17 Own_total
rename  Est_code_92  Estd
rename var35 Gross_ppe
rename var36 Acc_Depr_Depl
rename var40 liab_debt
rename Employment_92 emp
rename var57 Curr_Depr_Depl
rename Inventories_92 inventories
rename Oth_cur_assets_92 oth_cur_assets 
rename Oth_noncur_assets_92 oth_noncur_assets
rename Assets_92 assets
rename Sales_92 sales
rename Total_income_92 tot_income
rename Foreign_income_tax_92 foreign_income_tax
rename Net_income_92 net_income2
rename Prod_royalty_92 prod_royal2
rename Oth_tax_92 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 82RF5
tabulate _merge
drop _merge
ge year=1992
*drop if industry<=100 | industry>=148
save aff1992, replace
clear

odbc load, table(11B93RF5) dsn(93B)
keep ENTITY_ID_10 name_93 PAR_ID_6 AFF_ID_4 industry_93 country_93 ptr_93 net_income_93 foreign_inc_tax_93 depletion_93 prod_royal_93 oth_tax_93 cca_93
rename industry_93 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	country_93 country
rename name_93 name 
rename	ptr_93 ptr
rename	net_income_93 net_income
rename	foreign_inc_~93 foreign_inc_tax
rename depletion_93 depletion
rename oth_tax_93 oth_tax
rename	prod_royal_93 prod_royal
rename	cca_93 cca
sort ENTITY_ID_10
save 93RF5, replace
clear

odbc load, table(11B93RF) dsn(93B)
keep ENTITY_ID_10 doc_type_93  estab_93 emp_93 own_dir_93 own_93 own_93 inventories_93 oth_curr_assets_93 gross_ppe_93 accum_depr_93 oth_noncurr_assets_93 assets_93 curr_liab_ltd_93 sales_93 income_93 fgn_income_tax_93 net_income_93 prod_roy_93 tax_oth_93 
rename doc_type_93 doc_type 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename estab_93 Estd
rename own_dir_93 own_dir
rename own_93 own
rename emp_93 emp
rename inventories_93 inventories
rename oth_curr_assets_93 oth_cur_assets
rename gross_ppe_93 Gross_ppe
rename accum_depr_93 Acc_Depr_Depl
rename oth_noncurr_assets_93 oth_noncur_assets
rename assets_93 assets
rename curr_liab_ltd_93 liab_debt
rename sales_93 sales
rename income_93 tot_income
rename fgn_income_tax_93 foreign_income_tax
rename net_income_93 net_income2
rename prod_roy_93 prod_royal2
rename tax_oth_93 oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 93RF5
tabulate _merge
drop _merge
*drop if industry<=100 | industry>=148
ge year=1993
save aff1993, replace
clear

odbc load, table(11B94RF5) dsn(94B)
keep  ENTITY_ID_10 name_94 us_id foreign_id industry_94 par_ind_94 country_94 ptr_94 net_income_94 foreign_inc_tax_94 depletion_94 prod_royal_94 subsidies_94 cca_94
rename industry_94 industry 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename	country_94 country
rename name_94 name
rename  par_ind_94 par_ind 
rename	ptr_94 ptr
rename	net_income_94 net_income
rename	foreign_inc_~94 foreign_inc_tax
rename depletion_94 depletion
rename	prod_royal_94 prod_royal
rename	cca_94 cca
rename subsidies_94 subsidies 
sort ENTITY_ID_10
save 94RF5, replace
clear

odbc load, table(11B94RF) dsn(94B)
keep ENTITY_ID_10 doc_type_94 maj_min_code_94 emp_94 own_dir_94 own_ind_94 own_94 inventories_94 oth_curr_assets_94 gross_ppe_94 accum_depr_94 oth_noncurr_assets_94 assets_94  prod_roy_94 tax_oth_94  sales_94 income_94 fgn_income_tax_94 net_income_94 curr_liab_ltd_94
rename maj_min_code_94 maj_min 
rename ENTITY_ID_10 entity_raw
egen ENTITY_ID_10=ends(entity_raw), punct(x) h tr
rename doc_type_94 doc_type
rename emp_94 emp
rename own_dir_94 own_dir
rename own_ind_94 own_ind
rename own_94 own
rename inventories_94 inventories
rename oth_curr_assets_94 oth_cur_assets
rename gross_ppe_94 Gross_ppe
rename accum_depr_94 Acc_Depr_Depl
rename oth_noncurr_assets_94 oth_noncur_assets
rename assets_94 assets 
rename prod_roy_94 prod_royal
rename tax_oth_94 oth_tax
rename sales_94 sales
rename income_94 tot_income
rename fgn_income_tax_94 foreign_inc_tax
rename net_income_94 net_income2
rename curr_liab_ltd_94 liab_debt
sort ENTITY_ID_10
save 94RF, replace
clear

odbc load, table(dbo_be10_aff_data7) dsn(94B)
keep us_id foreign_id exp_petro_mining
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 94d7, replace
clear

odbc load, table("new aff 94r") dsn(94B)
keep us_id foreign_id estab
rename us_id us_id_raw
rename estab Estd
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 94affnew, replace
clear

odbc load, table(dbo_be10_aff_data10) dsn(94B)
keep us_id foreign_id ex_petro ex_petro_us_rep ex_petro_oth_us ex_coal ex_coal_us_rep ex_coal_oth_us ex_metal ex_metal_us_rep  ex_metal_oth_us
rename ex_petro exp_pet
rename ex_petro_us_rep exp_pet_usrep
rename ex_petro_oth_us exp_pet_o_us
rename ex_coal exp_coal
rename ex_coal_us_rep exp_coal_usrep
rename ex_coal_oth_us exp_coal_o_us
rename ex_metal exp_metal
rename ex_metal_us_rep exp_metal_usrep
rename ex_metal_oth_us exp_metal_o_us
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
merge ENTITY_ID_10 using 94RF5 94RF 94d7 94affnew
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=1994
*drop if industry<=100 | industry>=148
save aff1994, replace
clear

odbc load, table(11B95RF5) dsn(95B)
keep ENTITY_ID_10 name_95 PAR_ID_6 AFF_ID_4 industry_95 par_ind_95 country_95 ptr_95 net_income_95 foreign_inc_tax_95 depletion_95 oth_tax_95 prod_royal_95 subsidies_95 cca_95
rename ENTITY_ID_10 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename industry_95 industry
rename name_95 name
rename	country_95 country
rename  par_ind_95 par_ind 
rename	ptr_95 ptr
rename	net_income_95 net_income
rename	foreign_inc_~95 foreign_inc_tax
rename depletion_95 depletion
rename oth_tax_95 oth_tax
rename	prod_royal_95 prod_royal
rename	cca_95 cca
rename subsidies_95 subsidies 
sort ENTITY_ID_10
save 95RF5, replace
clear

odbc load, table(dbo_be11_bal_inc) dsn(95B)
keep us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename fgn_income_tax foreign_inc_tax
rename income tot_income
rename gross_ppe Gross_ppe
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename accum_depr Acc_Depr_Depl
rename net_income net_income2
sort ENTITY_ID_10
save 95_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(95B)
keep  us_id foreign_id  doc_type estab estab_date  own_dir own_indir own
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename estab Estd
sort ENTITY_ID_10
save 95_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(95B)
keep us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 95_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(95B)
keep  us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Curr_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 95RF5 95_bal_inc 95_ident 95_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=1995
*drop if industry<=100 | industry>=148
save aff1995, replace
clear



odbc load, table(11B96RF5) dsn(96B)
keep  ENTITY_ID_10 name_96 PAR_ID_6 AFF_ID_4 par_ind_96 industry_96 country_96 ptr_96 net_income_96 foreign_inc_tax_96 depletion_96 oth_tax_96 prod_royal_96 subsidies_96 cca_96
rename ENTITY_ID_10 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename industry_96 industry
rename name_96 name
rename	country_96 country
rename  par_ind_96 par_ind
rename	ptr_96 ptr
rename	net_income_96 net_income
rename	foreign_inc_~96 foreign_inc_tax
rename depletion_96 depletion
rename oth_tax_96 oth_tax
rename	prod_royal_96 prod_royal
rename	cca_96 cca
rename subsidies_96 subsidies 
sort ENTITY_ID_10
save 96RF5, replace
clear

odbc load, table(dbo_be11_bal_inc) dsn(96B)
keep  us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets  sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename accum_depr Acc_Depr_Depl
rename income tot_income
rename gross_ppe Gross_ppe
rename fgn_income_tax foreign_inc_tax
rename net_income net_income2
sort ENTITY_ID_10
save 96_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(96B)
keep  us_id foreign_id doc_type estab_part_year estab estab_date own_dir own_indir own
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename estab Estd
sort ENTITY_ID_10
save 96_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(96B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 96_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(96B) 
keep  us_id foreign_id exp_ppe curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename tax_oth oth_tax
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
sort ENTITY_ID_10
merge ENTITY_ID_10 using 96RF5 96_bal_inc 96_ident 96_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
*drop if industry<=100 | industry>=148
ge year=1996
save aff1996, replace
clear

odbc load, table(11B97RF5) dsn(97B)
keep  ENTITY_ID_10 PAR_ID_6 name_97 AFF_ID_4 par_ind_97 industry_97 country_97 ptr_97 net_income_97 foreign_inc_tax_97 depletion_97 prod_royal_97 subsidies_97 oth_tax_97 cca_97
rename ENTITY_ID_10 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename industry_97 industry
rename name_97 name
rename	country_97 country
rename   par_ind_97 par_ind
rename	ptr_97 ptr
rename	net_income_97 net_income
rename	foreign_inc_~97 foreign_inc_tax
rename depletion_97 depletion
rename oth_tax_97 oth_tax
rename	prod_royal_97 prod_royal
rename	cca_97 cca
rename subsidies_97 subsidies
sort ENTITY_ID_10
save 97RF5, replace 
clear

odbc load, table(dbo_be11_bal_inc) dsn(97B)
keep  us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales  income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename accum_depr Acc_Depr_Depl
rename income tot_income 
rename fgn_income_tax foreign_inc_tax
rename gross_ppe Gross_ppe
rename net_income net_income2
sort ENTITY_ID_10
save 97_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(97B)
keep  us_id foreign_id doc_type estab_part_year estab estab_date own_dir own_indir own
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename estab Estd
sort ENTITY_ID_10
save 97_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(97B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 97_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(97B)
keep us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 97RF5 97_bal_inc 97_ident 97_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=1997
*drop if industry<=100 | industry>=148
save aff1997, replace
clear

odbc load, table(11B98RF5) dsn(98B)
keep ENTITY_ID_10 PAR_ID_6 name_98 par_ind_98 AFF_ID_4 industry_98 country_98 ptr_98 net_income_98 foreign_inc_tax_98 depletion_98 oth_tax_98 prod_royal_98 subsidies_98 cca_98
replace ENTITY_ID_10="00005001" if ENTITY_ID_10=="/"
rename ENTITY_ID_10 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename industry_98 industry
rename name_98 name
rename	country_98 country
rename  par_ind_98 par_ind 
rename	ptr_98 ptr
rename	net_income_98 net_income
rename	foreign_inc_~98 foreign_inc_tax
rename depletion_98 depletion
rename oth_tax_98 oth_tax
rename	prod_royal_98 prod_royal
rename	cca_98 cca
rename subsidies_98 subsidies 
sort ENTITY_ID_10
save 98RF5, replace
clear

odbc load, table(dbo_be11_bal_inc) dsn(98B)
keep us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename accum_depr Acc_Depr_Depl
rename income tot_income
rename gross_ppe Gross_ppe
rename fgn_income_tax foreign_inc_tax
rename net_income net_income2
sort ENTITY_ID_10
save 98_bal_inc, replace
clear


odbc load, table(dbo_be11_ident) dsn(98B)
keep us_id foreign_id doc_type estab_part_year estab estab_date dir_equity own_dir own_indir
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename estab Estd
sort ENTITY_ID_10
save 98_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(98B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 98_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(98B)
keep  us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 98RF5 98_bal_inc 98_ident 98_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=1998
*drop if industry<=100 | industry>=148
save aff1998, replace
clear

odbc load, table(11B99RF5) dsn(99B)
keep  ENTITY_ID_11 name PAR_ID_6 AFF_ID_5 par_ind par_ind_sic industry ind_SIC country ptr net_income foreign_inc_tax depletion oth_tax prod_royal subsidies cca
rename ENTITY_ID_11 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename AFF_ID_5 AFF_ID_4
*rename industry ind_naics AE
*rename ind_SIC industry
rename par_ind par_ind_naics
rename par_ind_sic par_ind
sort ENTITY_ID_10
save 99RF5, replace
clear

odbc load, table(dbo_be10_ident) dsn(99B)
keep  us_id foreign_id  doc_type maj_min_code estab_part_year estab estab_date dir_equity_cy
rename maj_min_code maj_min
destring maj_min, replace
rename estab Estd
renam dir_equity_cy dir_equity
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 99_ident, replace
clear

odbc load, table(dbo_be10_misc) dsn(99B)
keep  us_id foreign_id prod_roy tax_oth subs_recd roy_rec roy_recd_us_per roy_recd_fa roy_recd_oth_fgn roy_pay roy_pay_us_per roy_pay_fa roy_pay_oth_fgn emp 
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename prod_roy prod_royal2
rename tax_oth oth_tax
rename subs_recd subsidies2
sort ENTITY_ID_10
save 99_misc, replace
clear

odbc load, table(dbo_be10_bal_sheet) dsn(99B)
keep  us_id foreign_id inventories_cy oth_curr_assets_cy oth_ppe_cy accum_depr_cy  oth_noncurr_assets_cy assets_cy
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename inventories_cy inventories
rename oth_curr_assets_cy oth_cur_assets
rename oth_ppe_cy oth_ppe
rename accum_depr_cy Acc_Depr_Depl
rename oth_noncurr_assets_cy oth_noncur_assets
rename assets_cy assets
sort ENTITY_ID_10
save 99_bal_sheet, replace
clear

odbc load, table(dbo_be10_exports) dsn(99B)
keep  us_id foreign_id ex_crude ex_crude_us_rep ex_crude_oth_us ex_fuels_lubs ex_fuels_lubs_us_rep ex_fuels_lubs_oth_us
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
rename ex_crude exp_crude
rename ex_crude_us_rep exp_crude_usrep
rename ex_crude_oth_us exp_crude_o_us
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 99_exports, replace
clear

odbc load, table(dbo_be10_external_fin) dsn(99B)
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 99_external_fin, replace
clear

odbc load, table(dbo_be10_inc_stmt) dsn(99B)
keep  us_id foreign_id sales fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename net_income net_income2
rename fgn_income_tax foreign_inc_tax
sort ENTITY_ID_10
save 99_inc_stmt, replace
clear

odbc load, table(dbo_be10_line1009) dsn(99B)
keep  us_id foreign_id estab_part_year estab estab_date
rename estab Estd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
merge ENTITY_ID_10 using 99RF5 97_bal_inc 99_ident 99_external_fin 99_inc_stmt 99_external_fin 99_exports 99_bal_sheet 99_misc
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
tabulate _merge5
tabulate _merge6
tabulate _merge7
tabulate _merge8
tabulate _merge9
drop _merge1 _merge2 _merge3 _merge4 _merge5 _merge6 _merge7 _merge8 _merge9 _merge
ge year=1999
*drop if ind_naics<2111 | ind_naics>=2133
save aff1999, replace
clear

odbc load, table(11B00RF5) dsn(00B)
keep  ENTITY_ID_10 name us_id AFF_ID_4 industry par_ind country ptr net_income foreign_inc_tax depletion oth_tax prod_royal subsidies cca
rename ENTITY_ID_10 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename us_id PAR_ID_6
*rename industry ind_naics
sort ENTITY_ID_10
save 00RF5, replace
clear


odbc load, table(dbo_be11_bal_inc) dsn(00B)
keep us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename accum_depr Acc_Depr_Depl
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename income tot_income
rename gross_ppe Gross_ppe
rename net_income net_income2
renam fgn_income_tax foreign_inc_tax
sort ENTITY_ID_10
save 00_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(00B)
keep  us_id foreign_id  doc_type estab_part_year estab estab_date  dir_equity  own_dir  own_indir 
rename estab Estd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 00_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(00B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 00_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(00B)
keep  us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 00RF5 00_bal_inc 00_ident 00_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
*drop if ind_naics<2111 | ind_naics>=2133
ge year=2000
save aff2000, replace
clear

odbc load, table(11B01RF5) dsn(01B)
keep  ENTITY_ID_10 name PAR_ID_6 AFF_ID_4 industry par_ind country ptr net_income foreign_inc_tax depletion oth_tax prod_royal subsidies cca
rename ENTITY_ID_10 entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
*rename industry ind_naics
sort ENTITY_ID_10
save 01RF5, replace
clear

odbc load, table(dbo_be11_bal_inc) dsn(01B)
keep us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename accum_depr Acc_Depr_Depl
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename net_income net_income2
rename gross_ppe Gross_ppe
rename income tot_income
renam fgn_income_tax foreign_income_tax
sort ENTITY_ID_10
save 01_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(01B)
keep  us_id foreign_id naics_id sic_ind ctry doc_type estab_part_year estab estab_date  dir_equity own_indir own_dir own
rename estab Estd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
*rename sic_ind industry 
rename naics_id industry
sort ENTITY_ID_10
save 01_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(01B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
rename curr_liab_ltd liab_debt
save 01_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(01B)
keep  us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 01RF5 01_bal_inc 01_ident 01_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=2001
*drop if ind_naics<2111 | ind_naics>=2133
save aff2001, replace
clear

odbc load, table(11B02RF5) dsn(02B)
keep  us_id foreign_id name naics_id ctry ptr02 net_income02 fgn_income_tax02 depletion02 tax_oth02 prod_roy02 subs_recd02 cca02
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename us_id PAR_ID_6
rename foreign_id AFF_ID_4
rename naics_id industry
rename ptr02 ptr
rename net_income02 net_income
rename fgn_income_t~02 foreign_inc_tax
rename depletion02 depletion
rename prod_roy02 prod_royal
rename tax_oth02 oth_tax
rename subs_recd02 subsidies
rename cca02 cca
rename ctry country
sort ENTITY_ID_10
save 02RF5, replace
clear


odbc load, table(dbo_be11_bal_inc) dsn(02B)
keep us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename accum_depr Acc_Depr_Depl
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename gross_ppe Gross_ppe
rename net_income net_income2
rename income tot_income
renam fgn_income_tax foreign_income_tax
sort ENTITY_ID_10
save 02_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(02B)
keep  us_id foreign_id doc_type estab_part_year estab estab_date  dir_equity own_dir own_indir
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
rename estab Estd
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 02_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(02B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
rename curr_liab_ltd liab_debt
save 02_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(02B)
keep  us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 02RF5 02_bal_inc 02_ident 02_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
ge year=2002
*drop if ind_naics<2111 | ind_naics>=2133
save aff2002, replace
clear

odbc load, table(11B03RF5) dsn(03B)
keep entity_id us_id name foreign_id  naics_id  ctry ptr03 rep_ind net_income03  fgn_income_tax03 depletion03 tax_oth03 prod_roy03 subs_recd03 cca03
rename us_id PAR_ID_6 
rename foreign_id AFF_ID_4
rename entity_id entity_id_raw
egen ENTITY_ID_10=ends(entity_id_raw), punct(x) h tr
rename naics_id ind_naics
rename rep_ind par_ind
rename ctry country
rename ptr03 ptr
rename net_income03 net_income
rename fgn_income_tax03 foreign_inc_tax
rename depletion03 depletion
rename tax_oth03 oth_tax
rename prod_roy03 prod_royal
rename subs_recd03 subsidies
rename cca03 cca
ge year=2003
*drop if ind_naics<2111 | ind_naics>=2133
sort ENTITY_ID_10
save 03RF5, replace
clear


odbc load, table(dbo_be11_bal_inc) dsn(03B)
keep us_id foreign_id inventories oth_curr_assets gross_ppe accum_depr oth_noncurr_assets assets sales income fgn_income_tax net_income
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename net_income net_income2
rename oth_curr_assets oth_cur_assets
rename oth_noncurr_assets oth_noncur_assets
rename gross_ppe Gross_ppe
sort ENTITY_ID_10
save 03_bal_inc, replace
clear

odbc load, table(dbo_be11_ident) dsn(03B)
keep  us_id foreign_id naics_id sic_ind ctry doc_type estab_part_year estab estab_date dir_equity
*rename maj_min_code maj_min
rename estab Estd
rename naics_id industry
*rename sic_ind industry
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
sort ENTITY_ID_10
save 03_ident, replace
clear

odbc load, table(dbo_be11_external_fin) dsn(03B)
keep  us_id foreign_id curr_liab_ltd
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_liab_ltd liab_debt
sort ENTITY_ID_10
save 03_external_fin, replace
clear

odbc load, table(dbo_be11_misc) dsn(03B)
keep  us_id foreign_id curr_depr prod_roy tax_oth emp
rename us_id us_id_raw
egen us_id=ends(us_id_raw), punct(x) h tr
rename foreign_id foreign_id_raw
egen foreign_id=ends(foreign_id_raw), punct(x) h tr
egen ENTITY_ID_10=concat(us_id foreign_id)
tostring ENTITY_ID_10, replace
rename curr_depr Acc_Depr_Depl
rename prod_roy prod_royal2
rename tax_oth oth_tax
sort ENTITY_ID_10
merge ENTITY_ID_10 using 03RF5 03_bal_inc 03_ident 03_external_fin
tabulate _merge1
tabulate _merge2
tabulate _merge3
tabulate _merge4
drop _merge1 _merge2 _merge3 _merge4 _merge
*drop if ind_naics<2111 | ind_naics>=2133
save aff2003, replace
clear

**************************************************************;
* End of Program (note: I append data with affiliate_data.do) ;
**************************************************************;

exit
