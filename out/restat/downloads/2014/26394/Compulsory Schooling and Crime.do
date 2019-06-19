


*****************************************************************************************************************************
*Table 2. Descriptive stats for all variables
*****************************************************************************************************************************
*Total crime rate for male 16-18 yr-olds
sum total_crime1_rate real_min_wage mda18 real_ipc2000 pop_dense_thou popratio1618 popratio1315 popratio_male popratio_black agency_count mlda19 mlda20 mlda21  if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1 | mda17 == 1 | mda18 == 1)
*Total crime rate for male 13-15 yr-olds
sum total_crime1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1 | mda17 == 1 | mda18 == 1)
*Total crime rate for female 16-18 yr-olds
sum total_crime1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1 | mda17 == 1 | mda18 == 1)
*Total crime rate for female 13-15 yr-olds
sum total_crime1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1 | mda17 == 1 | mda18 == 1)



*****************************************************************************************************************************
*Table 3. Descriptive stats for arrest rates
*****************************************************************************************************************************
*Males
sum property1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum property1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum property1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum property1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum property1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum property1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum larceny_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum larceny_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum larceny_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum larceny_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum larceny_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum larceny_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum burglary_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum burglary_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum burglary_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum burglary_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum burglary_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum burglary_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum mvt_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum mvt_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum mvt_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum mvt_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum mvt_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum mvt_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum arson_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum arson_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum arson_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum arson_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum arson_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum arson_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum violent1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum violent1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum violent1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum violent1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum violent1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum violent1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum murder_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum murder_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum murder_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum murder_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum murder_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum murder_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum rape_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum rape_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum rape_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum rape_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum rape_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum rape_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum robbery_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum robbery_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum robbery_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum robbery_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum robbery_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum robbery_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum agg_assault_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum agg_assault_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum agg_assault_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum agg_assault_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum agg_assault_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum agg_assault_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum other_assault_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum other_assault_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum other_assault_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum other_assault_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum other_assault_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum other_assault_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_drug_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_drug_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_drug_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_drug_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_drug_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_drug_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_sale_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_sale_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_sale_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_sale_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_sale_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_sale_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_possess_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_possess_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_possess_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_possess_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_possess_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_possess_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_crime1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_crime1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_crime1_rate if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_crime1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_crime1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_crime1_rate if (age == 1315) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

*Females
sum property1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum property1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum property1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum property1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum property1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum property1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum larceny_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum larceny_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum larceny_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum larceny_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum larceny_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum larceny_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_larceny != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum burglary_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum burglary_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum burglary_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum burglary_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum burglary_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum burglary_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_burglary != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum mvt_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum mvt_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum mvt_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum mvt_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum mvt_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum mvt_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_mvt != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum arson_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum arson_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum arson_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum arson_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum arson_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum arson_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_arson != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum violent1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum violent1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum violent1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum violent1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum violent1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum violent1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum murder_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum murder_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum murder_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum murder_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum murder_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum murder_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_murder != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum rape_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum rape_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum rape_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum rape_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum rape_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum rape_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_rape != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum robbery_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum robbery_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum robbery_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum robbery_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum robbery_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum robbery_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_robbery != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum agg_assault_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum agg_assault_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum agg_assault_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum agg_assault_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum agg_assault_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum agg_assault_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_agg_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum other_assault_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum other_assault_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum other_assault_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum other_assault_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum other_assault_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum other_assault_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_other_assault != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_drug_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_drug_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_drug_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_drug_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_drug_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_drug_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_sale_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_sale_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_sale_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_sale_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_sale_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_sale_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_drug_sale != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_possess_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_possess_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_possess_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum drug_possess_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum drug_possess_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum drug_possess_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_drug_possess != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_crime1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_crime1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_crime1_rate if (age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1

sum total_crime1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda16less == 1)
sum total_crime1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & (mda17 == 1)
sum total_crime1_rate if (age == 1315) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) & mda18 == 1



***************************************************
*Data for Figure 1. Years Relative to MDA Increase
***************************************************
*Results for graph on timing of laws
*****Merge in file for timing of MDA Laws*****
xi: xtreg total_crime1_rate lead2 lead1 time0 lag1 lag2 lag3 lag4 lag5 i.year if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe




********************************************************
*Table 4. Teen Arrest Rates and the Minmium Dropout Age
********************************************************
*note: run with areg to obtain R^2
*******************
*Male total crime
*******************
*County FEs and Year FEs
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10  [pweight = ave_county_pop], fe cluster(state_fips)

*********************
*Male property crime
*********************
*County FEs and Year FEs
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*********************
*Male violent crime
*********************
*County FEs and Year FEs
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*************************
*Male total drug
*************************
*County FEs and Year FEs
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*******************
*Female total crime
*******************
*County FEs and Year FEs
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*********************
*Female property crime
*********************
*County FEs and Year FEs
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_property1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*********************
*Female violent crime
*********************
*County FEs and Year FEs
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_violent1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*************************
*Female total drug
*************************
*County FEs and Year FEs
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, and covariates
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)
*County FEs, Year FEs, covariates, and trends
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_total_drug != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)




***********************************************
*Table 5. Male Teen Arrest Rates by Crime Type
************************************************
*Larceny
xi:  xtreg larceny_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_larceny != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Burglary
xi:  xtreg burglary_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_burglary != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*MVT
xi:  xtreg mvt_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_mvt != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Arson
xi:  xtreg arson_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_arson != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Murder
xi:  xtreg murder_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_murder != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Rape
xi:  xtreg rape_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_rape != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Robbery
xi:  xtreg robbery_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_robbery != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Aggravated Assault
xi:  xtreg agg_assault_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_agg_assault != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Simple Assault
xi:  xtreg other_assault_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_other_assault != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Selling of drugs
xi:  xtreg drug_sale_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_sale != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Possession of drugs
xi:  xtreg drug_possess_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_drug_possess != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)



**************************************************
*Table 6. Teen Arrest Rates for Petty Delinquency
**************************************************
*Males
*Disorderly conduct
xi:  xtreg dis_conduct_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_dis_conduct != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Vandalism
xi:  xtreg vandalism_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_vandalism != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Curfew violation
xi:  xtreg curfew_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_curfew != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Females
*Disordelry conduct
xi:  xtreg dis_conduct_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_dis_conduct != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Vandalism
xi:  xtreg vandalism_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_vandalism != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Curfew violation
xi:  xtreg curfew_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_curfew != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Prostitution
xi:  xtreg prostitution_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 0 & flag_females != 1 & sd_flag_prostitution != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)



**************************************************
*Table 7. Interaction Terms and Male Arrest Rates
**************************************************
*%Black below median
gen below_median_black = 0
replace below_median_black = 1 if popratio_black < 0.2
replace below_median_black = . if popratio_black == .

gen mda18_age1618_below_med_black = mda18_age1618*below_median_black

*All crimes
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 below_median_black mda18_age1618_below_med_black mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Property crime
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 below_median_black mda18_age1618_below_med_black mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Violent crime
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 below_median_black mda18_age1618_below_med_black mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Drug crime
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 below_median_black mda18_age1618_below_med_black mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)


*Income below median
gen below_median_income = 0
replace below_median_income = 1 if real_ipc2000 < 21000
replace below_median_income = . if real_ipc2000 == . 

gen mda18_age1618_below_med_income = mda18_age1618*below_median_income

*All crimes
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 below_median_income mda18_age1618_below_med_income mlda19 mlda20 mlda21 log_wage popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Property crime
xi:  xtreg property1_rate age1618 mda18 mda18_age1618 below_median_income mda18_age1618_below_med_income mlda19 mlda20 mlda21 log_wage popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Violent crime
xi:  xtreg violent1_rate age1618 mda18 mda18_age1618 below_median_income mda18_age1618_below_med_income mlda19 mlda20 mlda21 log_wage popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Drug crime
xi:  xtreg total_drug_rate age1618 mda18 mda18_age1618 below_median_income mda18_age1618_below_med_income mlda19 mlda20 mlda21 log_wage popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)




****************************************************************************
*Table 8. Sensitivity of Male Arrest Results to Alternative Specifications
****************************************************************************
*DD estimate (correct estimate based on sample selection criteria used throughout paper)
xi:  xtreg total_crime1_rate mda18 mlda19 mlda20 mlda21 log_wage log_income popratio1618 pop_dense_thou popratio_male popratio_black agency_count state_fe* i.year if (age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*DD estimate (estimate that was incorrectly left in paper based on sample that does not exclude potential outliers due to likely misreported crime data)
xi:  xtreg total_crime1_rate mda18 mlda19 mlda20 mlda21 log_wage log_income popratio1618 pop_dense_thou popratio_male popratio_black agency_count state_fe* i.year if (age == 1618) & male == 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*log(arrest rate)
xi:  xtreg log_total_crime1 age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*add age-specific trends
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* age_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*Add age-by-year and age-by-state FEs
quietly tabulate year, generate(year_dum_)

foreach var of varlist year_* {
	gen age1618_fe_`var' = `var'*age1618
}	

drop year_dum*

*First, generate state fixed effects
quietly tabulate state_fips, generate(state_dum_)

foreach var of varlist state_dum* {
	gen age1618_fe_`var' = `var'*age1618
}	

drop state_dum*

xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* age1618_fe_* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*19-year olds as controls
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 19 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 [pweight = ave_county_pop], fe cluster(state_fips)

*No sample restrictions
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 [pweight = ave_county_pop], fe cluster(state_fips)

*Only counties in states with major exemptions
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (state_fips == 1 | state_fips == 2 | state_fips == 4 | state_fips == 6 | state_fips == 9 | state_fips == 10 | state_fips == 12 | state_fips == 13 | state_fips == 16 | state_fips == 17 | state_fips == 19 | state_fips == 21 | state_fips == 22 | state_fips == 24 | state_fips == 25 | state_fips == 26 | state_fips == 27 | state_fips == 29 | state_fips == 30 | state_fips == 31 | state_fips == 32 | state_fips == 33 | state_fips == 34 | state_fips == 35 | state_fips == 36 | state_fips == 37 | state_fips == 38 | state_fips == 39 | state_fips == 40 | state_fips == 41 | state_fips == 44 | state_fips == 45 | state_fips == 46 | state_fips == 49 | state_fips == 50 | state_fips == 51 | state_fips == 53 | state_fips == 54 | state_fips == 56) [pweight = ave_county_pop], fe cluster(state_fips)

*Exclude CA, FL, NY, and TX counties
xi:  xtreg total_crime1_rate age1618 mda18 mda18_age1618 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (state_fips != 6 & state_fips != 12 & state_fips != 36 & state_fips != 48) [pweight = ave_county_pop], fe cluster(state_fips)



***************************************************
*Table 9. Male Arrest Rates for 19 to 21 year olds
***************************************************
**************MERGE IN FILE ON MLDA LAWS LAGS*******************


*Account for the fact that NYC changed their drop age, but the rest of the state did not
replace lag3 = 17 if state_fips == 36 & county_fips == 61
replace lag2 = 17 if state_fips == 36 & county_fips == 61
replace lag1 = 17 if state_fips == 36 & county_fips == 61

drop statecod lag3 lag2 lag1
order mda18_lag3 mda18_lag2 mda18_lag1 _merge_mdalags, after(_merge_laws)

gen age1921 = 0
replace age1921 = 1 if age == 1921
gen mda18_lag3_age1921 = mda18_lag3*age1921

*Total crime
xi:  xtreg total_crime1_rate age1921 mda18_lag3 mda18_lag3_age1921 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 popratio1921 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618 | age == 1921) & male == 1 & flag_males != 1 & sd_flag_totalcrime != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)

*Property crime
xi:  xtreg property1_rate age1921 mda18_lag3 mda18_lag3_age1921 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 popratio1921 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618 | age == 1921) & male == 1 & flag_males != 1 & sd_flag_property1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)

*Violent crime
xi:  xtreg violent1_rate age1921 mda18_lag3 mda18_lag3_age1921 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 popratio1921 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618 | age == 1921) & male == 1 & flag_males != 1 & sd_flag_violent1 != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)

*Drug crime
xi:  xtreg total_drug_rate age1921 mda18_lag3 mda18_lag3_age1921 mlda19 mlda20 mlda21 log_wage log_income popratio1315 popratio1618 popratio1921 pop_dense_thou popratio_male popratio_black agency_count i.year state_fe* if (age == 1315 | age == 1618 | age == 1921) & male == 1 & flag_males != 1 & sd_flag_total_drug != 1 & count > 10 & (log_wage != . & log_income != . & popratio1618 != . & pop_dense_thou != . & popratio_male != . & popratio_black != . & agency_count != .) [pweight = ave_county_pop], fe cluster(state_fips)


