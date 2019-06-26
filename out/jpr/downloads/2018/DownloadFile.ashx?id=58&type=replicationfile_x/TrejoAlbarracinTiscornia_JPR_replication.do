** Replication of Trejo, Albarracin and Tiscornia JPR: Breaking State Impunity in Post-Authoritarian Regimes

use "TrejoAlbarracinTiscornia_JPR_replication.dta", clear

*************************
*********TABLE I*********
*************************

*Table 1. FE Models Global Sample

xtreg homTOT guilty tc_ord amnesty_new gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom, fe vce(cluster cowcode)
eststo Model1

xtreg homTOT stockguilt1 stocktc1 stockam0 gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom, fe vce(cluster cowcode)
eststo Model2 

xtreg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom, fe vce(cluster cowcode)
eststo Model3

xtreg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom, fe vce(cluster cowcode)
eststo Model4

esttab Model1 Model2 Model3 Model4 using "modelsFE_world_replication.csv", se star(+ 0.10 * 0.05 ** 0.01) nodep mtitles (Model1 Model2 Model3 Model4) ///
order (guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom) replace


*************************
*********TABLE II********
*************************

*Table 2. FE Models Latin America

xtreg homTOT guilty tc_ord amnesty_new gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom if reg4==1 | reg5==1, fe vce(cluster cowcode)
eststo Model5

xtreg homTOT stockguilt1 stocktc1 stockam0 gdplog gdpgrowth gini youth_male_percent PTS_S rupture counter laghom if reg4==1 | reg5==1, fe vce(cluster cowcode)
eststo Model6

xtreg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 gdplog gdpgrowth gini youth_male_percent PTS_S rupture counter laghom if reg4==1 | reg5==1, fe vce(cluster cowcode)
eststo Model7

xtreg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent PTS_S rupture counter laghom if reg4==1 | reg5==1, fe vce(cluster cowcode)
eststo Model8

esttab Model5 Model6 Model7 Model8 using "modelsFE_LATAM_replication.csv", se star(+ 0.10 * 0.05 ** 0.01) nodep mtitles (Model5 Model6 Model7 Model8) ///
order (guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom) replace


*************************
*********TABLE III*******
*************************

*Table 3. FE Models Global Sample (CEM)

cem laghom (15 40) gdplog (6 7) gdpgrowth (3) gini (30 40 55) youth_male_percent (9) PTS_S (3) counter(0), treatment(treatstocktc2) 

reg homTOT guilty tc_ord amnesty_new gdplog gdpgrowth gini youth_male_percent rupture PTS_S  counter laghom i.cowcode i.year [aweight=cem_weights]
eststo Model9

reg homTOT stockguilt1 stocktc1 stockam0 gdplog gdpgrowth gini youth_male_percent rupture PTS_S  counter laghom i.cowcode i.year [aweight=cem_weights]
eststo Model10

reg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 gdplog gdpgrowth gini youth_male_percent rupture PTS_S  counter laghom i.cowcode i.year [aweight=cem_weights]
eststo Model11

reg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent rupture PTS_S  counter laghom i.cowcode i.year [aweight=cem_weights]
eststo Model12

** Model 13:
cem laghom (15 40) gdplog (6 7) gini (30 40 55) PTS_S (3) counter(0), treatment(treatstocktc2) 

reg homTOT guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gini rupture PTS_S  counter laghom i.cowcode i.year [aweight=cem_weights]
eststo Model13

esttab Model9 Model10 Model11 Model12 Model13 using "matching_replication.csv", se star(+ 0.10 * 0.05 ** 0.01) nodep mtitles (Model9 Model10 Model11 Model12) ///
keep (guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom _cons) ///
order (guilty stockguilt1 tc_ord stocktc1 amnesty_new stockam0 guilttruthstock gdplog gdpgrowth gini youth_male_percent rupture PTS_S counter laghom _cons) replace


*************************
*********FIGURE 2********
*************************
** Avg Marginal Effects
quietly xtreg homTOT guilty c.stockguilt1 tc_ord c.stocktc1 i.amnesty_new c.stockam0 c.stockguilt1##c.stocktc1 gdplog gdpgrowth gini youth_male_percent PTS_S rupture counter laghom if reg4==1 | reg5==1, fe vce(cluster cowcode)
margins, dydx(stockguilt1) at(stocktc1=(0(1)15)) vsquish 
marginsplot, yline(0) title("") ytitle("Effects on linear prediction") xtitle("Truth commission (cumulative)") graphregion(color(white)) plotopts(lcolor(black) mcolor(black)) ciopts(lcolor(black))

*************************
*********FIGURE 3********
*************************
** Homicide Rate (linear prediction)
quietly xtreg homTOT guilty c.stockguilt1 tc_ord c.stocktc1 i.amnesty_new c.stockam0 c.stockguilt1##c.stocktc1 gdplog gdpgrowth gini youth_male_percent PTS_S rupture counter laghom if reg4==1 | reg5==1, fe vce(cluster cowcode)
margins, at(stocktc1=(0(1)15) stockguilt1=(0(11)11)) atmeans vsquish
marginsplot, title("") ytitle("Homicide rate (linear prediction)") xtitle("Truth commission (cumulative)") graphregion(color(white)) plot( , label("Trials (cumulative)=0" "Trials (cumulative)=11")) plot1opts(lcolor(black) mcolor(black)) plot2opts(lcolor(gs7) mcolor(gs7))  /// 
ci1opts(lcolor(black)) ci2opts(lcolor(gs7)) 



