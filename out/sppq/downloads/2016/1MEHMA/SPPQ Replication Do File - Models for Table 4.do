***SPPQ Models 1 and 2 in Table 4***

*First - Non-interactive Model*

regress ln_amount_2012index incumbent cj_incumbent qual_candidate female competitive_60 prior_close_race odd_year partisan_elect_rev2 district_system scprof_Squire1 number_seats multimember_contest log_limits_all_2012 attorney cycle, vce(cluster election_case)


*Second - Interactive Model*

regress ln_amount_2012index incumbent cj_incumbent qual_candidate female competitive_60 prior_close_race odd_year partisan_elect_rev2 district_system scprof_Squire1 number_seats multimember_contest log_limits_all_2012 attorney partisanrXsquire1 cycle, vce(cluster election_case)
