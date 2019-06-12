/***********************************/
/* Americans Not Partisans Project */
/* SSI Study                       */
/* Experiment #1                   */    
/* Started: July 2015              */ 
/* Finalized: January 2017         */
/***********************************/   

/* Use the data the RA coded with the correct categorization of likes/dislikes */ 
use "SSI_Final_with_codes.dta"

**************************
** Treatment Assignment **
************************** 
 
gen treatment = . 
replace treatment = 0 if Q49 == 1  
replace treatment = 1 if Q370 == 1

// Partisanship 
gen party = . 
replace party = 1 if Q2 == 1 & Q4 == 1 
replace party = 2 if Q2 == 1 & Q4 == 2 
replace party = 3 if Q2 == 3 & Q8 == 1  
replace party = 4 if Q2 == 3 & Q8!= 1 & Q8!=2 
replace party = 5 if Q2 == 3 & Q8 == 2 
replace party = 6 if Q2 == 2 & Q6 == 2 
replace party = 7 if Q2 == 2 & Q6 == 1 

gen dem = 0 
replace dem = 1 if party < 4 

*************************
** Sample Demographics ** 
************************* 

gen yrborn = Q17 + 1928 
gen age = 2015 - yrborn  

gen female = . 
replace female = 0 if Q18 == 1 
replace female = 1 if Q18 == 2 

gen hispanic = 0
replace hispanic = 1 if Q47 == 1  

gen non_white = 0 
replace non_white = 1 if Q19 > 1 

// sample demographic breakdown 
summarize age, detail 
mean dem 
mean female 
tabulate Q19 
mean hispanic 

reg treatment i.Q19 i.party hispanic female age 
/* no predictive power (F-test is easily rejected, p=.72) */ 

************************
** Manipulation Check ** 
************************

alpha Q45 Q44 Q39 Q79 Q80 Q81 
/* alpha = 0.90, so form into a scale */ 
egen ai = rmean(Q44 Q45 Q39 Q79 Q80 Q81) 
gen amer_iden = (-1*ai) + 6 
/* amer_iden is scaled so that higher values mean you identify more strongly as an American */ 
ttest amer_iden, by(treatment) 
/* manipulation check passed [diff of 0.10 on 1-5 scale, or 1/7th an SD] */ 

/* factor analysis of items */ 
factor Q44 Q45 Q39 Q79 Q80 Q81, mineigen(1) altdivisor 
/* Look item by item */ 
reg Q45 treatment 
reg Q44 treatment 
reg Q39 treatment 
reg Q79 treatment 
reg Q80 treatment 
reg Q81 treatment 
/* same effects item-by-item (coefs are negative because scales are reversed) */ 


*************************
** Dependent Variables **
************************* 

//Feeling Thermometer Items  
gen outparty_ft = . 
replace outparty_ft = Q45_2 if dem == 0 
replace outparty_ft = Q45_3 if dem == 1 
gen sameparty_ft = . 
replace sameparty_ft = Q45_2 if dem == 1
replace sameparty_ft = Q45_3 if dem == 0 
gen ft_pol = sameparty_ft - outparty_ft  

// Trait Ratings 
egen pos_trait_d = rmean(Q50_1 Q50_2 Q50_3 Q50_4 Q50_5) 
egen neg_trait_d = rmean(Q50_7 Q50_8 Q50_9) 
egen pos_trait_r = rmean(Q51_1 Q51_2 Q51_3 Q51_4 Q51_5) 
egen neg_trait_r = rmean(Q51_7 Q51_8 Q51_9) 
gen pt = . 
replace pt = pos_trait_d if dem == 0 
replace pt = pos_trait_r if dem == 1 
gen nt = . 
replace nt = neg_trait_d if dem == 0 
replace nt = neg_trait_r if dem == 1 
gen pos_trait = (-1*pt) + 6 
gen neg_trait = (-1*nt) + 6 

/* Look at pooled trait index */ 
/* Should see higher values on positive traits, and lower values on negative ones */ 
gen tr_american = (-1*Q50_1) + 6 if dem == 0   
replace tr_american = (-1*Q51_1) + 6 if dem == 1 
gen tr_intelligent = (-1*Q50_2) + 6 if dem == 0   
replace tr_intelligent = (-1*Q51_2) + 6 if dem == 1 
gen tr_honest = (-1*Q50_3) + 6 if dem == 0   
replace tr_honest = (-1*Q51_3) + 6 if dem == 1 
gen tr_open = (-1*Q50_4) + 6 if dem == 0   
replace tr_open = (-1*Q51_4) + 6 if dem == 1 
gen tr_generous = (-1*Q50_5) + 6 if dem == 0   
replace tr_generous = (-1*Q51_5) + 6 if dem == 1 
gen tr_hypocritical = (-1*Q50_7) + 6 if dem == 0   
replace tr_hypocritical = Q51_7 if dem == 1 
gen tr_selfish = Q50_8 if dem == 0   
replace tr_selfish = Q51_8 if dem == 1 
gen tr_mean = Q50_9 if dem == 0   
replace tr_mean = Q51_9 if dem == 1 

alpha tr_american tr_intelligent tr_honest tr_open tr_generous tr_hypocritical tr_selfish tr_mean
/* alpha = 0.8 */ 
egen trait_index = rmean(tr_american tr_intelligent tr_honest tr_open tr_generous tr_hypocritical tr_selfish tr_mean)

// Likes and Dislikes 
gen likes = n_likes_valid_dem if dem == 0 
replace likes = n_likes_rep_valid if dem == 1 
gen dislikes = n_dislikes_valid_dem if dem == 0 
replace dislikes = n_dislikes_valid_rep if dem == 1 
gen net_likes = likes - dislikes 

*************
** Table 1 ** 
*************

reg outparty_ft treatment, level(90) 
outreg2 using ssi_results.doc, noaster replace ctitle (Out-Party FT) 
reg sameparty_ft treatment, level(90)  
outreg2 using ssi_results.doc, noaster append ctitle(Same-Party FT) 
reg Q45_4 treatment if dem == 0, level(90) 
outreg2 using ssi_results.doc, noaster append ctitle(Obama FT (R)) 
reg Q45_4 treatment if dem == 1, level(90) 
outreg2 using ssi_results.doc, noaster append ctitle(Obama FT (D)) 
reg trait_index treatment, level(90)  
outreg2 using ssi_results.doc, noaster append ctitle(Trait Index)
reg pos_trait treatment, level(90)  
outreg2 using ssi_results.doc, noaster append ctitle(Positive Traits) 
reg neg_trait treatment, level(90)  
outreg2 using ssi_results.doc, noaster append ctitle(Negative Traits) 
reg tr_american treatment, level(90)  
outreg2 using ssi_results.doc, noaster append ctitle(American)  
reg likes treatment, level(90) 
outreg2 using ssi_results.doc, noaster append ctitle(Likes) 
reg dislikes treatment, level(90)  
outreg2 using ssi_results.doc, noaster append ctitle(Dislikes) 

// Look at differences in the distribution of FT ratings  
gen ft_cat = . 
replace ft_cat = 1 if outparty_ft == 0 
replace ft_cat = 2 if outparty_ft > 0 & outparty_ft < 26 
replace ft_cat = 3 if outparty_ft > 25 & outparty_ft < 50 
replace ft_cat = 4 if outparty_ft > 50 
tabulate ft_cat if treatment == 0 
tabulate ft_cat if treatment == 1 


*************
** Table 2 ** 
*************

/* Look at Differential Effects by Strong Partisans/Sorted Individauls */ 
gen sp = 0 
replace sp = 1 if party == 1 | party == 7 

gen libcon = Q37 if Q37 != . 
gen sorted = 0 
replace sorted = 1 if dem == 1 & libcon < 4 
replace sorted = 1 if dem == 0 & libcon > 4 
replace sorted = . if party == . | libcon == . 

outreg2 using ssi_table2.doc, noaster 
reg outparty_ft treatment##sp, level(90)  
outreg2 using ssi_table2.doc, noaster append 
reg outparty_ft treatment##sorted, level(90)  
outreg2 using ssi_table2.doc, noaster append 
reg Q45_4 treatment##sp if dem == 0, level(90)  
outreg2 using ssi_table2.doc, noaster append 
reg Q45_4 treatment##sorted if dem == 0, level(90)  
outreg2 using ssi_table2.doc, noaster append 
reg trait_index treatment##sp, level(90)  
outreg2 using ssi_table2.doc, noaster append 
reg trait_index treatment##sorted, level(90)  
outreg2 using ssi_table2.doc, noaster append 
reg likes treatment##sp, level(90) 
outreg2 using ssi_table2.doc, noaster append 
reg likes treatment##sorted, level(90)  
outreg2 using ssi_table2.doc, noaster append 

***************************
** Analyses for Appendix **
*************************** 
 
 
// Analysis without partisan leaners 
gen leaner = 0 
replace leaner = 1 if party == 3 | party == 5 
table party leaner 

reg outparty_ft treatment if leaner == 0 
outreg2 using leaners.doc, noaster append 
reg sameparty_ft treatment if leaner == 0 
outreg2 using leaners.doc, noaster append 
reg Q45_4 treatment if dem == 0 & leaner == 0 
outreg2 using leaners.doc, noaster append 
reg trait_index treatment if leaner == 0  
outreg2 using leaners.doc, noaster append 
reg likes treatment if leaner == 0 
outreg2 using leaners.doc, noaster append 
reg dislikes treatment if leaner == 0 
outreg2 using leaners.doc, noaster append 


/* Racial & Partisan Treatment Heterogeneity */ 
reg outparty_ft treatment##dem 
outreg2 using rp_het.doc, noaster append 
reg outparty_ft treatment##non_white 
outreg2 using rp_het.doc, noaster append 
reg trait_index treatment##dem
outreg2 using rp_het.doc, noaster append 
reg trait_index treatment##non_white 
outreg2 using rp_het.doc, noaster append 
reg likes treatment##dem 
outreg2 using rp_het.doc, noaster append 
reg likes treatment##non_white 
outreg2 using rp_het.doc, noaster append 
reg dislikes treatment##dem  
outreg2 using rp_het.doc, noaster append 
reg dislikes treatment##non_white 
outreg2 using rp_het.doc, noaster append 
