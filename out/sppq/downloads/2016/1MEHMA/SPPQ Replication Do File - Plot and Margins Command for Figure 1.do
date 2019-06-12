***SPPQ Model and Commands for Figure 1***

*Model 2 (with partisan election X professionalization interaction term) from Table 4*

regress ln_amount_2012index incumbent cj_incumbent qual_candidate female competitive_60 prior_close_race odd_year district_system number_seats multimember_contest log_limits_all_2012 attorney cycle partisan_elect_rev2##c.scprof_Squire1, vce(cluster election_case)


*Margins command for incumbent X partisan election interaction*

margins partisan_elect_rev2, at(scprof_Squire1=(.2(.1).9))


*Plot command for incumbent X partisan election interaction*

marginsplot, xdimension(at(scprof_Squire1)) recast(line) recastci(rarea)
