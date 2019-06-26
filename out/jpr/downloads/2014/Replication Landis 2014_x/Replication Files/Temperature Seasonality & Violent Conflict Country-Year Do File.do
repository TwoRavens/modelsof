# County-Year Replication Commands for "Temperature Seasonality & Violent Conflict: The Inconsistencies of a Warming Planet" 

#Model 1: Pooled ACD 25 Dead
logit onset temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino  t_onset t2_onset t3_onset, robust cluster(ccode)

#Model 2: Conditional FE ACD 25 Dead
xtlogit onset temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_onset t2_onset t3_onset, fe i(ccode) 

#Model 3: Pooled ACD 1000 Dead
logit onset_1k temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_onset_1k t2_onset_1k t3_onset_1k, robust cluster(ccode)

#Model 4: Conditional FE ACD 1000 Dead
xtlogit onset_1k temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_onset_1k t2_onset_1k t3_onset_1k, fe i(ccode) 

#Model 5: Pooled UCDP Nonstate 
nbreg onsetcount onsetcount_lag temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_onsetcount t2_onsetcount t3_onsetcount, robust cluster(ccode)

#Model 6: Conditional FE UCDP Nonstate 
xtnbreg onsetcount onsetcount_lag temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_onsetcount t2_onsetcount t3_onsetcount, fe i(ccode) difficult noconstant

#Model 7: Pooled Violent SCAD
nbreg violent_SCADevent violent_SCADevent_lag temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_violent_SCADevent t2_violent_SCADevent t3_violent_SCADevent, robust cluster(ccode)

#Model 8: Conditional FE Violent SCAD
xtnbreg violent_SCADevent violent_SCADevent_lag temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_violent_SCADevent t2_violent_SCADevent t3_violent_SCADevent, fe i(ccode) noconstant

#Model 9: Pooled ICEWS
nbreg ICEWS_violence ICEWS_violence_lag temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_ICEWS_violence t2_ICEWS_violence t3_ICEWS_violence, robust cluster(ccode)

#Model 10:Conditional FE ICEWS
xtnbreg ICEWS_violence ICEWS_violence_lag temp_mean temp_shock temp_shock_sq precip_mean precip_shock precip_shock_sq xpolity_lag gdp_pc_lag population_lag El_Nino t_ICEWS_violence t2_ICEWS_violence t3_ICEWS_violence, fe i(ccode) noconstant
