###County-Month Replication Commands for "Temperature Seasonality & Violent Conflict: The Inconsistencies of a Warming Planet"### 

### Global Sample Table III###


##Correction, add the following via https://www.prio.org/Data/Stata-Tools/ ## 

btscs onset_1k time ccode, g(t_onset_1k)
generate t2_onset_1k=t_onset_1k *t_onset_1k 
generate t3_onset_1k=t2_onset_1k*t_onset_1k 


####################################################


#Model 1: Pooled ACD 25 Dead Global Sample#
logit onset temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onset t2_onset t3_onset, robust cluster(ccode)

#Model 2: Pooled ACD 1000 Dead Global Sample#
logit onset_1k temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onset_1k t2_onset_1k t3_onset_1k, robust cluster(ccode)

#Model 3: Pooled UCDP Nonstate Global Sample# 
nbreg onsetcount onsetcount_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onsetcount t2_onsetcount t3_onsetcount, robust cluster(ccode)

#Model 4: Pooled Violent SCAD Global Sample#
nbreg violent_scadevent violent_scadevent_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_violent_scadevent t2_violent_scadevent t3_violent_scadevent, robust cluster(ccode)

#Model 5: Conditional FE Violent SCAD Global Sample#
xtnbreg violent_scadevent violent_scadevent_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_violent_scadevent t2_violent_scadevent t3_violent_scadevent, fe i(ccode)

#Model 6: Pooled ICEWS Global Sample#
nbreg icews_violence icews_violence_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_icews_violence t2_icews_violence t3_icews_violence, robust cluster(ccode)

#Model 7:Conditional FE ICEWS Global Sample#
xtnbreg icews_violence icews_violence_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_icews_violence t2_icews_violence t3_icews_violence, fe i(ccode) 

#Model 8: Pooled ACLED Rebel Violence Global Sample#
nbreg ACLED_rebel_violence lag_ACLED_rebel temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_rebel t2_ACLED_rebel t3_ACLED_rebel, robust cluster(ccode)

#Model 9: Conditional FE Rebel Violence Global Sample (note, there is a typo in the Table for the first coefficent. It should be insignificant not significant) #
xtnbreg ACLED_rebel_violence lag_ACLED_rebel temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_rebel t2_ACLED_rebel t3_ACLED_rebel, fe i(ccode)

#Model 10: Pooled ACLED Civilian Violence Global Sample#
nbreg ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil, robust cluster(ccode)

#Model 11: Conditional FE Rebel Violence Global Sample#
xtpoisson ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil, fe i(ccode)
matrix _s=e(b)
xtnbreg ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil, fe i(ccode) from(_s, skip) 


### Strong Seasonality Table IV####

#Model 1: Pooled ACD 25 Dead Strong Seasonality#
logit onset temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onset t2_onset t3_onset if strong_seasonality==1, robust cluster(ccode)

#Model 2: Pooled ACD 1000 Dead Strong Seasonality#
logit onset_1k temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onset_1k t2_onset_1k t3_onset_1k if strong_seasonality==1, robust cluster(ccode)

#Model 3: Pooled UCDP Nonstate Strong Seasonality#
nbreg onsetcount onsetcount_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onsetcount t2_onsetcount t3_onsetcount if strong_seasonality==1, robust cluster(ccode)

#Model 4: Pooled Violent SCAD Strong Seasonality#
nbreg violent_scadevent violent_scadevent_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_violent_scadevent t2_violent_scadevent t3_violent_scadevent if strong_seasonality==1, robust cluster(ccode)

#Model 5: Conditional FE Violent SCAD Strong Seasonality#
xtnbreg violent_scadevent violent_scadevent_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_violent_scadevent t2_violent_scadevent t3_violent_scadevent if strong_seasonality==1, fe i(ccode) noconstant

#Model 6: Pooled ICEWS Strong Seasonality#
nbreg icews_violence icews_violence_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_icews_violence t2_icews_violence t3_icews_violence if strong_seasonality==1, robust cluster(ccode)

#Model 7:Conditional FE ICEWS Strong Seasonality#
xtnbreg icews_violence icews_violence_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_icews_violence t2_icews_violence t3_icews_violence if strong_seasonality==1, fe i(ccode) 

#Model 8: Pooled ACLED Rebel Violence Strong Seasonality#
nbreg ACLED_rebel_violence lag_ACLED_rebel temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_rebel t2_ACLED_rebel t3_ACLED_rebel if strong_seasonality==1, robust cluster(ccode)

#Model 9: Conditional FE Rebel Violence Strong Seasonality#
xtnbreg ACLED_rebel_violence lag_ACLED_rebel temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_rebel t2_ACLED_rebel t3_ACLED_rebel if strong_seasonality==1, fe i(ccode)

#Model 10: Pooled ACLED Civilian Violence Strong Seasonality#
nbreg ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil if strong_seasonality==1, robust cluster(ccode)

#Model 11: Conditional FE Rebel Violence Strong Seasonality#
xtnbreg ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil if strong_seasonality==1, fe i(ccode)



### Weak Seasonality Table V###



#Model 1: Pooled ACD 25 Dead Weak Seasonality#
logit onset temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onset t2_onset t3_onset if weak_seasonality==1, robust cluster(ccode)

#Model 2: Pooled ACD 1000 Dead Weak Seasonality#
logit onset_1k temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onset_1k t2_onset_1k t3_onset_1k if weak_seasonality==1, robust cluster(ccode)

#Model 3: Pooled UCDP Nonstate Weak Seasonality#
nbreg onsetcount onsetcount_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino january t_onsetcount t2_onsetcount t3_onsetcount if weak_seasonality==1, robust cluster(ccode)

#Model 4: Pooled Violent SCAD Weak Seasonality#
nbreg violent_scadevent violent_scadevent_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_violent_scadevent t2_violent_scadevent t3_violent_scadevent if weak_seasonality==1, robust cluster(ccode)

#Model 5: Conditional FE Violent SCAD Weak Seasonality#
xtnbreg violent_scadevent violent_scadevent_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_violent_scadevent t2_violent_scadevent t3_violent_scadevent if weak_seasonality==1, fe i(ccode) 

#Model 6: Pooled ICEWS Weak Seasonality#
nbreg icews_violence icews_violence_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_icews_violence t2_icews_violence t3_icews_violence if weak_seasonality==1, robust cluster(ccode)

#Model 7:Conditional FE ICEWS Weak Seasonality#
xtnbreg icews_violence icews_violence_lag temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_icews_violence t2_icews_violence t3_icews_violence if weak_seasonality==1, fe i(ccode) 

#Model 8: Pooled ACLED Rebel Violence Weak Seasonality#
nbreg ACLED_rebel_violence lag_ACLED_rebel temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_rebel t2_ACLED_rebel t3_ACLED_rebel if weak_seasonality==1, robust cluster(ccode)

#Model 9: Conditional FE Rebel Violence Weak Seasonality#
xtnbreg ACLED_rebel_violence lag_ACLED_rebel temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_rebel t2_ACLED_rebel t3_ACLED_rebel if weak_seasonality==1, fe i(ccode)

#Model 10: Pooled ACLED Civilian Violence Weak Seasonality#
nbreg ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil if weak_seasonality==1, robust cluster(ccode)

#Model 11: Conditional FE Rebel Violence Weak Seasonality#
xtnbreg ACLED_civil_violence lag_ACLED_civil temp_mean positive_temp_dev positive_temp_dev_sq negative_temp_dev negative_temp_dev_sq precip_mean positive_precip_dev positive_precip_dev_sq negative_precip_dev negative_precip_dev_sq xpolity_lag gdp_pc_lag population_lag el_nino t_ACLED_civil t2_ACLED_civil t3_ACLED_civil if weak_seasonality==1, fe i(ccode)





