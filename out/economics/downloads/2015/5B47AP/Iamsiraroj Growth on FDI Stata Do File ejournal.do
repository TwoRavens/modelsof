*** Data Construction by Dr. Sasi Iamsiraroj, Deakin University, sasi.iamsiraroj@deakin.edu.au 


*** FUNNEL PLOTS****
*** Figure 1 Funnel plot of growth-FDI partial correlations, all estimates (n = 946)
scatter prec pc if f_outward< 1 

*** Figure 2 Funnel plot of growth-FDI partial correlations, developing countries (n = 574)
scatter prec pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1


**** TABLE 1  FAT-PET and PEESE MRA, all studies
*** PANEL A All estimates
*** Table 1 column 1 
reg pc if f_outward< 1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 2, FAT-PET
reg pc se_pc if f_outward < 1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 3, PEESE
reg pc se_pcSQR if f_outward< 1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 4
reg pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 5, FAT-PET
reg pc se_pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 6, PEESE
reg pc se_pcSQR if fdiintodevelopingcountriesonly > 0 & f_outward< 1 [aweight = precisionSqr], cluster(study)


**** TABLE 1  PANEL B
*** Table 1 column 1
reg pc if f_outward< 1 & es_inst ==1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 2, FAT-PET
reg pc se_pc if f_outward < 1 & es_inst ==1 [aweight = precisionSqr], cluster(study)

*** Table 1 column 3, PEESE
reg pc se_pcSQR if f_outward< 1 & es_inst ==1  [aweight = precisionSqr], cluster(study)

*** Table 1 column 4
reg pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & es_inst ==1  [aweight = precisionSqr], cluster(study)

*** Table 1 column 5, FAT-PET
reg pc se_pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & es_inst ==1  [aweight = precisionSqr], cluster(study)

*** Table 1 column 6, PEESE
reg pc se_pcSQR if fdiintodevelopingcountriesonly > 0 & f_outward< 1   & es_inst ==1  [aweight = precisionSqr], cluster(study)




**** TABLE 2 FAT-PET and PEESE MRA, Single Country Estimates
*** Table 2 column 1
reg pc if f_outward< 1 & data_sin >0 [aweight = precisionSqr], cluster(study)

*** Table 2 column 2
reg pc se_pc if f_outward< 1 & data_sin > 0 [aweight = precisionSqr], cluster(study)

*** Table 2 column 3
reg pc se_pcSQR if f_outward< 1 & data_sin >0 [aweight = precisionSqr], cluster(study)

*** Table 2 column 4
reg pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & data_sin >0 [aweight = precisionSqr], cluster(study)


*** Table 2 column 5
reg pc se_pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & data_sin > 0 [aweight = precisionSqr], cluster(study)

*** Table 2 column 6
reg pc se_pcSQR if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & data_sin >0 [aweight = precisionSqr], cluster(study)


**** TABLE 3 FAT-PET and PEESE MRA, Cross-Country Estimates
*** Table 3 column 1
reg pc if f_outward< 1 & data_sin ==0 [aweight = precisionSqr], cluster(study)
display "adjusted R2 = " e(r2_a)

*** Table 3 column 2
reg pc se_pc if f_outward< 1 & data_sin == 0 [aweight = precisionSqr], cluster(study)
display "adjusted R2 = " e(r2_a)

*** Table 3 column 3
reg pc se_pcSQR if f_outward< 1 & data_sin ==0 [aweight = precisionSqr], cluster(study)
display "adjusted R2 = " e(r2_a)

*** Table 3 column 4
reg pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & data_sin ==0 [aweight = precisionSqr], cluster(study)
display "adjusted R2 = " e(r2_a)

*** Table 3 column 5
reg pc se_pc if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & data_sin == 0 [aweight = precisionSqr], cluster(study)
display "adjusted R2 = " e(r2_a)

*** Table 3 column 6
reg pc se_pcSQR if fdiintodevelopingcountriesonly > 0 & f_outward< 1 & data_sin ==0 [aweight = precisionSqr], cluster(study)
display "adjusted R2 = " e(r2_a)




*** TABLE 4 Multiple Meta-Regression Analysis 
*** All estimates
stepwise, pr(0.10): reg pc se_pc e_dinf  a_la a_cee a_me a_sa a_sea a_ea a_na a_we a_aus g_lagged data_panel data_sin es_inst s_fe e_trade e_inf e_tax e_int e_wage e_exch e_tariff e_hc avyearrel1990 e_cap ssciimpactfactor resources governancedummy marketsize e_lfdi  f_gross dummyfdigdporfdignp if f_outward< 1 [aweight = precisionSqr], cluster(study)
reg pc a_na g_lagged data_sin e_tax e_int e_exch e_cap resources dummyfdigdporfdignp if f_outward< 1 [aweight = precisionSqr], cluster(study)

*** Developing countries only
stepwise, pr(0.10): reg pc se_pc e_dinf  a_la a_cee a_me a_sa a_sea a_ea a_na a_we g_lagged data_panel data_sin es_inst s_fe e_trade e_inf e_tax e_int e_wage e_exch e_tariff e_hc avyearrel1990 e_cap ssciimpactfactor resources governancedummy marketsize e_lfdi  f_gross dummyfdigdporfdignp if fdiintodevelopingcountriesonly > 0 &  f_outward< 1 [aweight = precisionSqr], cluster(study)
reg pc se_pc  g_lagged  data_sin  e_inf e_tax   e_tariff     marketsize   if fdiintodevelopingcountriesonly > 0 &  f_outward< 1 [aweight = precisionSqr], cluster(study)

*** Note that sample size is larger if specific models are developed without stepwise function and t-statistics are somewhat larger: 
*** stepwise produces more conservative estimates in this MRA.


*** Table 5: Robustness checks
*** robustness checks
reg pc se_pc e_dinf  a_la a_cee a_me a_sa a_sea a_ea a_na a_we a_aus g_lagged data_panel data_sin es_inst s_fe e_trade e_inf e_tax e_int e_wage e_exch e_tariff e_hc avyearrel1990 e_cap ssciimpactfactor resources governancedummy marketsize e_lfdi  f_gross dummyfdigdporfdignp if f_outward< 1 [aweight = precisionSqr], cluster(study)
*** Test for p > 0.3
test se_pc a_sa a_ea a_aus es_inst s_fe e_tariff governancedummy marketsize  a_la a_cee e_wage e_hc avyearrel1990  a_me  a_sea   a_we ssciimpactfactor
*** Column 2 model with p < 0.3
reg pc e_dinf  a_na g_lagged data_panel data_sin e_trade e_inf e_tax e_int e_exch e_cap resources e_lfdi  f_gross dummyfdigdporfdignp if f_outward< 1 [aweight = precisionSqr], cluster(study)
*** Column 3 df weights
reg pc e_dinf  a_na g_lagged data_panel data_sin e_trade e_inf e_tax e_int e_exch e_cap resources e_lfdi  f_gross dummyfdigdporfdignp if f_outward< 1 [aweight = df], cluster(study)
*** Column 4 no estimates weights
reg pc e_dinf  a_na g_lagged data_panel data_sin e_trade e_inf e_tax e_int e_exch e_cap resources e_lfdi  f_gross dummyfdigdporfdignp if f_outward< 1 [aweight = inverseno], cluster(study)
*** Column 5 with study level
reg t prec e_lfdiSE f_grossSE e_infSE e_tradeSE panelSE e_dinfSE a_naSE g_laggedSE data_sinSE e_taxSE e_intSE e_exchSE e_capSE resourcesSE dummySE i.study if f_outward< 1 , noconstant cluster(study)









