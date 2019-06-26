	
	
	***Freedom of Foreign Movement, Economic Opportunities Abroad, and Protest on Non-Democratic Regimes***
						

* MAIN PAPER MODELS - TABLE 1 *
nbreg totalprotest unemploy_g7 kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & democracy==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2&democracy==0, robust


* Appendix Models Excluding Japan *
nbreg totalprotest unemploy_NAEUR kof_eg  kofegXG6unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg totalprotest unemploy_NAEUR formov unemploy_NAEUR_formov kof_eg  kofegXG6unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg totalprotest unemploy_NAEUR formov unemploy_NAEUR_formov kof_eg  kofegXG6unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & democracy==0, robust
nbreg totalprotest unemploy_NAEUR formov unemploy_NAEUR_formov kof_eg  kofegXG6unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2, robust
nbreg totalprotest unemploy_NAEUR formov unemploy_NAEUR_formov kof_eg  kofegXG6unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2&democracy==0, robust


* Appendix Models using OECD Unemployment *
nbreg totalprotest unemploy_oecd kof_eg  kofeg_oecd_unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg totalprotest unemploy_oecd formov OECD_unemp_formov kof_eg  kofeg_oecd_unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if oecd==0, robust
nbreg totalprotest unemploy_oecd formov OECD_unemp_formov kof_eg  kofeg_oecd_unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if oecd==0 & democracy==0, robust
nbreg totalprotest unemploy_oecd formov OECD_unemp_formov kof_eg  kofeg_oecd_unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if oecd==0 & rights<2, robust
nbreg totalprotest unemploy_oecd formov OECD_unemp_formov kof_eg  kofeg_oecd_unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if oecd==0 & rights<2&democracy==0, robust


* Appendix Models using Zero-Inflated Negative Binomial models *
zinb totalprotest unemploy_g7 kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, inflate(physint peaceyr_tp growth polityb) vuong
zinb totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, inflate(physint peaceyr_tp growth polityb) vuong
zinb totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & democracy==0, inflate(physint peaceyr_tp growth polityb) vuong
zinb totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2, inflate(physint peaceyr_tp growth polityb) vuong
zinb totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2&democracy==0, inflate(physint peaceyr_tp growth polityb) vuong


* Appendix Models using country fixed effects *
nbreg totalprotest unemploy_g7 kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp country_fe* if G7==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp country_fe* if G7==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp country_fe* if G7==0 & democracy==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp country_fe* if G7==0 & rights<2, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp country_fe* if G7==0 & rights<2&democracy==0, robust


* Appendix Models with t-1 lag structure *
nbreg F.totalprotest unemploy_g7 kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg F.totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0, robust
nbreg F.totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & democracy==0, robust
nbreg F.totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2, robust
nbreg F.totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp if G7==0 & rights<2&democracy==0, robust

* Appendix Models with spatial lag based on average protest in states 50 km or less from the referent *
nbreg totalprotest unemploy_g7 kof_eg kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp adjprotest1 if G7==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp adjprotest1 if G7==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp adjprotest1 if G7==0 & democracy==0, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp adjprotest1 if G7==0 & rights<2, robust
nbreg totalprotest unemploy_g7 formov g7formov kof_eg  kofegXg7unemp dommov physint polityb ln_develop growth ln_population adultpop war colonydum  peaceyr_tp adjprotest1 if G7==0 & rights<2&democracy==0, robust


