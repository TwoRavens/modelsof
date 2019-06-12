*
* Jonathan D. Caverley and Todd S. Sechser
* "Military Technology and the Duration of Civil Conflict"
* International Studies Quarterly, forthcoming
*


* Purpose
* This is a Stata replication file for "Military Technology and the Duration of Civil Conflict."  This file will reproduce the regressions, tables, and charts from the original article, as well as the regressions from the appendices.
*
* Location
* This command file and the associated dataset can be downloaded from <http://dataverse.harvard.edu/dataverse/tsechser>.
*
* Requirements
* 1. This file requires the "estout" Stata package.  It can be installed by typing "ssc install estout" (without quotes) into the Stata command window, or by visiting <http://repec.org/bocode/e/estout/installation.html>.
* 2. This file requires the Stata dataset "Caverley-Sechser-Appendices.dta", which can be downloaded from <http://dataverse.harvard.edu/dataverse/tsechser>.
*
* Version
* Last updated: January 13, 2017


* Table 2

eststo M1: streg ground_mechanization aircraft_mechanization combined_arms if coup==0 , robust dist(w) cl(gwno) time nolog
eststo M2: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M3: streg ground_mechanization aircraft_mechanization combined_arms rebel_fighting_capacity rebel_strength if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M4: streg ground_mechanization aircraft_mechanization combined_arms natural_resources rough_terrain if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M5: streg ground_mechanization aircraft_mechanization combined_arms  incumbent_democracy if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M6: streg ground_mechanization aircraft_mechanization combined_arms gdp_per_capita if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M7: streg ground_mechanization aircraft_mechanization combined_arms external_support_govt external_support_rebels if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M8: streg ground_mechanization aircraft_mechanization combined_arms sons_of_soil if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M9: streg ground_mechanization aircraft_mechanization combined_arms insurgency if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M10: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy gdp_per_capita external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years if coup==0, robust  dist(w) cl(gwno) time nolog
eststo M11: streg ground_mechanization_s aircraft_mechanization_s combined_arms_s distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain incumbent_democracy gdp_per_capita external_support_govt external_support_rebels  sons_of_soil insurgency post_cold_war_years if coup==0, robust  dist(w) cl(gwno) time nolog

esttab M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) rename (ground_mechanization_s ground_mechanization aircraft_mechanization_s aircraft_mechanization combined_arms_s combined_arms) 


* Table 3

eststo M12: logit status ground_mechanization aircraft_mechanization combined_arms days days2 days3 if coup==0, robust cluster(gwno)
eststo M13: logit status ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance days days2 days3 if coup==0,robust cluster(gwno)
eststo M14: logit status ground_mechanization aircraft_mechanization combined_arms rebel_fighting_capacity rebel_strength days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M15: logit status ground_mechanization aircraft_mechanization combined_arms natural_resources rough_terrain days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M16: logit status ground_mechanization aircraft_mechanization combined_arms  incumbent_democracy days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M17: logit status ground_mechanization aircraft_mechanization combined_arms gdp_per_capita days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M18: logit status ground_mechanization aircraft_mechanization combined_arms external_support_govt external_support_rebels days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M19: logit status ground_mechanization aircraft_mechanization combined_arms sons_of_soil days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M20: logit status ground_mechanization aircraft_mechanization combined_arms insurgency days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M21: logit status ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy gdp_per_capita external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years days days2 days3 if coup==0 ,robust cluster(gwno)
eststo M22: logit status ground_mechanization_s aircraft_mechanization_s combined_arms_s distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain incumbent_democracy gdp_per_capita external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years days days2 days3 if coup==0 ,robust cluster(gwno)

esttab M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) rename (ground_mechanization_s ground_mechanization aircraft_mechanization_s aircraft_mechanization combined_arms_s combined_arms) drop (days*)


* Table 4

eststo M23: logit incumbent_victory_bk ground_mechanization aircraft_mechanization combined_arms, robust
eststo M24: logit incumbent_victory_bk ground_mechanization aircraft_mechanization combined_arms conventional_war_bk irregular_war_bk oil_exporter_bk ethnic_fractionalization_bk rough_bk incumbent_democracy_bk gdp_bk post_cold_war_bk population_bk, robust
eststo M25: logit rebel_victory_bk ground_mechanization aircraft_mechanization combined_arms, robust
eststo M26: logit rebel_victory_bk ground_mechanization aircraft_mechanization combined_arms conventional_war_bk irregular_war_bk oil_exporter_bk ethnic_fractionalization_bk rough_bk incumbent_democracy_bk gdp_bk post_cold_war_bk population_bk, robust

esttab M23 M24 M25 M26, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


* Table 5

eststo M27: streg ground_mechanization aircraft_mechanization combined_arms if insurgency==1 & coup==0, robust dist(w) cl(gwno) time nolog
eststo M28: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy post_cold_war_years gdp_per_capita external_support_govt external_support_rebels sons_of_soil if insurgency == 1 & coup==0, robust dist(w) cl(gwno) time nolog

esttab M27 M28, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


* Figure 1

drop yhat
reg aircraft_mechanization ground_mechanization
predict yhat
twoway(scatter aircraft_mechanization ground_mechanization) (line yhat ground_mechanization) if e(sample) & ground_mechanization>3.5, legend(off)  xtitle(Ground Mechanization) ytitle(Aircraft Mechanization)



* APPENDIX

* Cox instead of Weibull (footnote 21)

eststo M1c: stcox ground_mechanization aircraft_mechanization combined_arms if coup==0, robust cl(gwno) nolog
eststo M2c: stcox ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance if coup==0, robust cl(gwno) nolog
eststo M3c: stcox ground_mechanization aircraft_mechanization combined_arms rebel_fighting_capacity rebel_strength if coup==0, robust cl(gwno) nolog
eststo M4c: stcox ground_mechanization aircraft_mechanization combined_arms natural_resources rough_terrain if coup==0, robust cl(gwno) nolog
eststo M5c: stcox ground_mechanization aircraft_mechanization combined_arms  incumbent_democracy if coup==0, robust cl(gwno) nolog
eststo M6c: stcox ground_mechanization aircraft_mechanization combined_arms gdp_per_capita if coup==0, robust cl(gwno) nolog
eststo M7c: stcox ground_mechanization aircraft_mechanization combined_arms external_support_govt external_support_rebels if coup==0, robust cl(gwno) nolog
eststo M8c: stcox ground_mechanization aircraft_mechanization combined_arms sons_of_soil if coup==0, robust cl(gwno) nolog
eststo M9c: stcox ground_mechanization aircraft_mechanization combined_arms insurgency if coup==0, robust cl(gwno) nolog
eststo M10c: stcox ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy gdp_per_capita external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years if coup==0, robust cl(gwno) nolog
eststo M11c: stcox ground_mechanization_s aircraft_mechanization_s combined_arms_s distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain incumbent_democracy gdp_per_capita external_support_govt external_support_rebels  sons_of_soil insurgency post_cold_war_years if coup==0, robust cl(gwno) nolog

esttab M1c M2c M3c M4c M5c M6c M7c M8c M9c M10c M11c, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) rename (ground_mechanization_s ground_mechanization aircraft_mechanization_s aircraft_mechanization combined_arms_s combined_arms) 


*Table 2, Insurgencies Only

eststo M1i: streg ground_mechanization aircraft_mechanization combined_arms if coup==0 & insurgency==1, robust dist(w) cl(gwno) time nolog
eststo M2i: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M3i: streg ground_mechanization aircraft_mechanization combined_arms rebel_fighting_capacity rebel_strength if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M4i: streg ground_mechanization aircraft_mechanization combined_arms natural_resources rough_terrain if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M5i: streg ground_mechanization aircraft_mechanization combined_arms  incumbent_democracy if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M6i: streg ground_mechanization aircraft_mechanization combined_arms gdp_per_capita if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M7i: streg ground_mechanization aircraft_mechanization combined_arms external_support_govt external_support_rebels if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M8i: streg ground_mechanization aircraft_mechanization combined_arms sons_of_soil if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M10i: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy gdp_per_capita external_support_govt external_support_rebels sons_of_soil post_cold_war_years if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog
eststo M11i: streg ground_mechanization_s aircraft_mechanization_s combined_arms_s distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain incumbent_democracy gdp_per_capita external_support_govt external_support_rebels  sons_of_soil post_cold_war_years if coup==0 & insurgency==1, robust  dist(w) cl(gwno) time nolog

esttab M1i M2i M3i M4i M5i M6i M7i M8i M10i M11i, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) rename (ground_mechanization_s ground_mechanization aircraft_mechanization_s aircraft_mechanization combined_arms_s combined_arms) 


* Alternative GDP Measures

gen gdp = exp(gdp_per_capita) * exp(population)
gen log_gdp = log(gdp)

eststo M7gdp: streg ground_mechanization aircraft_mechanization combined_arms gdp if coup==0, dist(w) cl(gwno) time nolog
eststo M7loggdp: streg ground_mechanization aircraft_mechanization combined_arms log_gdp if coup==0, dist(w) cl(gwno) time nolog
eststo M10gdp: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy gdp external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years if coup==0, dist(w) cl(gwno) time nolog
eststo M10loggdp: streg ground_mechanization aircraft_mechanization combined_arms distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain  incumbent_democracy log_gdp external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years if coup==0, dist(w) cl(gwno) time nolog
eststo M11gdp: streg ground_mechanization_s aircraft_mechanization_s combined_arms_s distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain incumbent_democracy gdp external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years if coup==0, dist(w) cl(gwno) time nolog
eststo M11loggdp: streg ground_mechanization_s aircraft_mechanization_s combined_arms_s distance_to_capital conflict_at_border border_x_distance rebel_fighting_capacity rebel_strength natural_resources rough_terrain incumbent_democracy log_gdp external_support_govt external_support_rebels sons_of_soil insurgency post_cold_war_years if coup==0, dist(w) cl(gwno) time nolog

esttab M7gdp M10gdp M11gdp, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) rename (ground_mechanization_s ground_mechanization aircraft_mechanization_s aircraft_mechanization combined_arms_s combined_arms) 
esttab M*log*, se(3) b(3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) rename (ground_mechanization_s ground_mechanization aircraft_mechanization_s aircraft_mechanization combined_arms_s combined_arms) 

