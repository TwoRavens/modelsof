* labelling and renaming

label variable slot_esp "experimental session"
label variable id "individual id"
notes treatment: 1 is the low_default treatment, 2 is high_default, 3 is low_majority and ///
4 high_majority
notes carta: 1 is the top-left card on the screen, whereas 16 is the bottom-righ 
notes fitness: number of pixels differing from the target figure
label variable pay "payoff"
notes sceltacartamaggioranza: 1 if the subject chose the default or majority card, 0 otherwise 
label variable temposcaduto "out of time"
notes temposcaduto: 1 if subject ran out of time, 0 otherwise
label variable posizionecartascelta "card chosen position"
notes posizionecartascelta: 1 is the top-left card on the screen, whereas 16 is the bottom-righ
label variable rankscelta "choice quality rank"
notes rankscelta: 1 if best card in terms of minimum amount of squares different from  ///
the target card, 16 if worst card
label variable qdeclared "difference squared declared"
notes qdeclared: squared subjects declared differed between their chosen card and the ///
 target card 
label variable qveri "real difference in squares"
notes qveri: real difference in squares from the target card
notes difficulty: answer to Question 2, Ex-post questionnaire
rename var16 belief_relative
notes belief_relative: answer to Question 3, Ex-post questionnaire
notes var17: answer to Question 4, Ex-post questionnaire
notes var18: answer to Question 5, part 1, Ex-post questionnaire 
notes var19: answer to Question 5, part 2, Ex-post questionnaire
notes var20: answer to Question 6, Ex-post questionnaire
notes var21: answer to Question 7, Ex-post questionnaire
label variable var22 "year of birth": answer to Question 9, Ex-post questionnaire
notes var23: answer to Question 8, Ex-post questionnaire
label variable guadagno_scommessa "correct belief quality card"
notes guadagno_scommessa: 1 if the answer from Question 4, Ex-post questionnaire, is equal to ///
variable qveri
label variable pay_alnetto_scommessa "pay net of correct belief"
notes pay_alnetto_scommessa: payoff minus 1 Euro earned in case of correct belief 
notes info: 1 if majority treatments, 0 if default treatments
notes cost: 1 if high-cost treatments, 0 if low-cost treatments
notes info_cost: 1 if high_majority, 0 if low-default
notes male: 1 if male, 0 if female

rename quadratinidifferenzadichiarati qdeclared
rename quadratinidifferenzaveri qveri
rename rankingcartascelta rankscelta
rename var15 difficulty

/* 
Treatment 1: low_default
Treatment 2: high_default
Treatment 3: low_majority
Treatment 4: high_majority
*/



**********************************
*   generation of new variables  *
**********************************

bysort treatment id: gen age= 2013 - var22
bysort treatment id: gen solo= 1 if _n == 1
bysort treatment id: gen girata = _n 
bysort treatment id: gen numero = _N
gen posiz_scelta_m = .
replace posiz_scelta_m = girata/ numero if carta == posizionecartascelta
bysort treatment id: egen posiz_scelta_max = max(posiz_scelta_m)
bysort treatment id: egen posiz_scelta_min = min(posiz_scelta_m)
bysort treatment id: egen totale_secondi = total(secondi)
****************
gen rankgirata = fitness - 4   
replace rankgirata = (fitness / 4) - 4 if treatment == 2 | treatment ==4
bysort id treatment: egen max_rankgirata = max(rankgirata)
bysort id treatment: egen min_rankgirata = min(rankgirata)

******************************* temporal distance analysis ************************************
gen best = girata if rankgirata == min_rankgirata  
gen carta_scelta = girata if rankscelta == rankgirata
bysort id treatment: gen difference=carta_scelta - best
bysort id treatment: egen best_max = max(best)
bysort id treatment: egen carta_scelta_max = max(carta_scelta)
bysort id treatment:  gen difference = abs(carta_scelta_max - best_max)
bysort treatment: sum difference if solo == 1 & temposcaduto!=1

bysort cost: sum difference if solo == 1 & temposcaduto!=1 
ranksum difference, by (cost) 
gen dummy_girata = 0
replace dummy_girata = 1 if carta_scelta_max > best_max
bysort treatment: sum dummy_girata if solo == 1 & temposcaduto!=1

ranksum difference, by (cost) if solo == 1 & temposcaduto!=1 

****************************** normalization of uncovered cards ****************************************
bysort id treatment: gen diff_normal = difference/ numero  
bysort treatment: sum diff_normal if solo == 1 & temposcaduto!=1
bysort treatment: sum diff_normal if solo == 1 & temposcaduto!=1 & dummy_girata==1
bysort treatment: sum diff_normal if solo == 1 & temposcaduto!=1 & dummy_girata==0
bysort cost: sum diff_normal if solo == 1 & temposcaduto!=1
bysort cost: sum diff_normal if solo == 1 & temposcaduto!=1 & dummy_girata==0
bysort cost: sum diff_normal if solo == 1 & temposcaduto!=1 & dummy_girata==1
bysort cost: sum diff_normal if solo == 1 & temposcaduto!=1 & dummy_girata==1
bysort cost: sum diff_normal if solo == 1 & temposcaduto!=1 & dummy_girata==0

***************************************** analysis of the chosen quality ******************
bysort id treatment: gen diff_quality =  rankscelta - 1
gen guadagno_scommessa = 0
replace guadagno_scommessa = 1 if qdeclared == qveri  
gen pay_alnetto_scommessa = pay - guadagno_scommessa  
gen secondi_veri= secondi/1000
bysort treatment id: egen totale_secondi_veri = total(secondi_veri)

gen info = 0
replace info = 1 if treatment ==3|  treatment ==4
gen cost = 0
replace cost = 1 if treatment ==2|  treatment ==4
gen info_cost = info*cost
gen male = 0
replace male =1 if var23 == "MA" 
sum male if solo == 1 & temposcaduto!=1
sum age if solo == 1 & temposcaduto!=1
gen belief = qveri/qdeclared

**************************
* Figure 5:
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & cost == 1, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & cost == 0, frequency
***************************
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & info == 1, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & info == 0, frequency
histogram posiz_scelta_min if solo == 1 & temposcaduto!=1, frequency
histogram posiz_scelta_min if solo == 1 & temposcaduto!=1 & cost == 1, frequency
histogram posiz_scelta_min if solo == 1 & temposcaduto!=1 & cost == 0, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & treatment ==1, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & treatment ==2, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & treatment ==3, frequency
histogram posiz_scelta_max if solo == 1 & temposcaduto!=1 & treatment ==4, frequency

********************************************
****** Descriptive Statistics **************
********************************************

* Table 2:
sum male age pay pay_alnetto_scommessa totale_secondi_veri numero difficulty belief if ///
solo == 1 & temposcaduto!=1
*************************************
* Table 3:
by treatment: sum pay pay_alnetto_scommessa totale_secondi numero difficulty belief if ///
solo == 1 & temposcaduto!=1
*************************************
by treatment: sum pay if solo == 1 & temposcaduto!=1
by treatment: sum numero if solo == 1 & temposcaduto!=1
by treatment: tab guadagno_scommessa if solo == 1 & temposcaduto!=1
tab rankscelta treatment  if rankscelta>8 & solo == 1 & temposcaduto!=1
sum male if solo == 1 & temposcaduto!=1
by treatment: sum pay if solo == 1 & temposcaduto!=1
by treatment: sum belief if solo == 1 & temposcaduto!=1
by treatment: sum pay_alnetto_scommessa if solo == 1 & temposcaduto!=1
by treatment: sum numero if solo==1 & temposcaduto!=1
by treatment: sum difficulty if solo==1 & temposcaduto!=1
*Table 5:
tab scelta treatment if solo==1 & temposcaduto!=1
*******************************************
tab guadagno_scommessa treatment if solo==1 & temposcaduto!=1
by treatment: sum totale_secondi if solo == 1 & temposcaduto!=1
tab temposcad treatment if solo==1

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum pay, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum pay_alnetto, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum secondi, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum totale_secondi, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum totale_secondi, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum numero, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum numero, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum difficulty, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum difficulty, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum belief, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & info ==1
ranksum belief, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & info ==0
ranksum belief, by (cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & cost ==1
ranksum belief, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & cost ==0
ranksum belief, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum belief, by (info)
restore

preserve
keep if solo == 1 & temposcaduto!=1
tab posiz_scelta_max
ranksum posiz_scelta_max, by (cost) 
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & cost==0
ranksum belief, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & cost==1
ranksum belief, by (info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum diff_normal, by (cost) 
restore

preserve 
keep if solo == 1 & temposcaduto!=1
ranksum diff_normal, by (info) 
restore

* Regression (Table 4):
reg pay info cost male difficulty totale_secondi if solo == 1 & temposcaduto!=1
*******************************************

****************************** prtest for dummy variables - test of proportions ***************************
preserve
keep if solo == 1 & temposcaduto!=1
drop if info == 1 & cost == 0
drop if info == 0 & cost == 1
tab1 scelta info_cost
prtest scelta, by(info_cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1
prtest scelta, by(cost)
prtest scelta, by(info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & info==1
prtest scelta, by(cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & cost==1
prtest scelta, by(info)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & info==0
prtest scelta, by(cost)
restore

preserve 
keep if solo == 1 & temposcaduto!=1 & cost==0
prtest scelta, by(info)
restore

* Figure 4:
graph box pay if solo == 1 & temposcaduto!=1, over(treatment)
**********************************************
