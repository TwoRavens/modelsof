* Replication commands for Burnett Research and Politics Submission

*Creating composite scores from individual questions from each category

*All individual questions were coded as being correct or incorrect where a 1 
*is a correct answer and a 0 is an incorrect answer

* Sports

gen total_sports_score = ((pga_wins + kobe + jags + golf_inv + yanks + hockey_hat + super_b + tennis + fifa + horses)/10)

*Popular Cultures

gen total_pop_score = ((jackson + davis + oscars + albums + hefner + winfrey + diana + depp + starwrs + jamaica)/10)

*Political Knowledge

gen total_poliknow_score = ((president + supreme + term + ferraro + house_reps + const_law + veto + biden + hse_speaker + daley)/10)

*Rules of the Road

gen total_road_score = ((passing + alcohol + seatblts + stop + trailer)/5)

*Economics

gen total_econ_score = ((us_gdp + a_smith + wage + dollar + stocks)/5)

*Geography

gen total_geography_score = ((texas + alamo_loc + n_canada + heathrow + l_canada)/5)

*Consumer Knowledge

gen total_consumer_score = ((sq_ft + boyc + coco + cash_adv + fees + nader + gasoline + electric + car_price + mac)/10)

*All categories

gen total_all_score = ((pga_wins + kobe + jags + golf_inv + yanks + hockey_hat + super_b + tennis + fifa + horses + jackson + davis + oscars + albums + hefner + winfrey + diana + depp + starwrs + jamaica + president + supreme + term + ferraro + house_reps + const_law + veto + biden + hse_speaker + daley + passing + alcohol + seatblts + stop + trailer + us_gdp + a_smith + wage + dollar + stocks + texas + alamo_loc + n_canada + heathrow + l_canada + sq_ft + boyc + coco + cash_adv + fees + nader + gasoline + electric + car_price + mac)/55)

*Difference in Means Tests used in Figure 1
ttest total_sports_score, by(online)
ttest total_pop_score, by(online)
ttest total_poliknow_score, by(online)
ttest total_road_score, by(online)
ttest total_econ_score, by(online)
ttest total_geography_score, by(online)
ttest total_consumer_score, by(online)
ttest total_all_score, by(online)


*Analysis used to construct Figure 2

sum total_all_score if online==1, detail
sum total_all_score if online==0, detail

*Analysis of Don't Know Responses

gen total_dk_score = ( most_pga_dk+ kobe_dk+ jaguars_dk+ golf_dk+ yankee_dk+ hat_trick_dk+ super_bowl_dk+ grass_courts_dk+ fifa_wc_dk+ triple_crown_dk+ michael_jackson_dk+ miles_davis_dk+ most_oscars_dk+ most_albums_dk+ playboy_founder_dk+ oprah_dk+ diana_dk+ pirates_dk+ sw_dk+ reggae_dk+ obama_dk+ aj_dk+ pterm_dk+ wvp_dk+ hcontrol_dk+ const_dk+ veto_dk+ biden_dk+ jb_dk+ cs_dk+  passing_dk+ bac_dk+ belt_dk+ stop_dk+ trac_dk+ gdp_dk+ smith_dk+ wage_dk+ currency_dk+ exchange_dk+ mass_dk+ alamo_dk+ cn_n_dk+ pic_dk+ cn_l_dk+ sf_dk+ bcott_dk+ cnut_dk+ cadv_dk+ tuition_dk+ cvair_dk+ unlead_dk+ kwatt_dk+ msrp_dk+ bigmac_dk)
ttest total_dk_score, by(online)

*Analysis of Hardest Questions

gen total_hardest_score=(( heathrow+ nader+ horses+  oscars+ us_gdp+ coco+ ferraro+ diana+ supreme+ pga_wins+ l_canada+ a_smith + seatblts + passing)/14)
ttest total_hardest_score, by(online)

*Difference in differences equation:
reg total_all_score online total_hardest_score c.total_hardest_score#i.online

*Analysis of Easiest Questions

gen total_easiest_score=(( depp+ hefner+ yanks+ super_b+ n_canada+ texas+ president+ biden+ gasoline+ boyc+ wage+ stocks+ alcohol+ trailer)/14)
ttest total_easiest_score, by(online)

*Analysis of Hardest Questions Conditional on Being at or Above the Median on the Easiest Questions
ttest total_hardest_score if total_easiest_score>=.892, by(online)


