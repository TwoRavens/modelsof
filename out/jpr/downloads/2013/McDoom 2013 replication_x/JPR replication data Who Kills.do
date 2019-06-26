* ****************************************************************
* This Stata do file replicates the results in 
* McDoom, Omar Shahabudin, "Who Killed in Rwanda's Genocide: 
* Micro-space, Social Influence, and Individual Participation in
* Intergroup Violence" 
* Journal of Peace Research
* If you use these data, please cite the above paper.  
* 
* Last Updated: August 26th 2013
* For queries relating to these data, please contact the author at 
* o.s.mcdoom@lse.ac.uk
*
* **************************************************************


* ********************************************************************************************
*  Models 1-6 replicate the logistic regressions in Table III using convicted and suspected 
*  perpetrators as the dependent variable(convict/suspect=1, non-convict/non-suspect=0)
* ********************************************************************************************

use JPR Replication dataset v1.dta

//Find and install regression output program//
findit estout

//Model 1//
logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_100m_suspects neighborhood_100m_targets household_suspects household_size popdensity100m2 distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14
est store m1
esttab m1 using test1.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 

//Model 2//
logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_100m_convicts neighborhood_100m_targets household_convicts household_size popdensity100m2 distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14 
est store m2
esttab m2 using test2.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 3//
logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_200m_suspects neighborhood_200m_targets household_suspects household_size popdensity200m2 distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14
est store m3
esttab m3 using test3.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 

//Model 4//
logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_200m_convicts neighborhood_200m_targets household_convicts household_size popdensity200m2 distance_mobilizer     distance_communitycenter         elevation slope if ethnicity==0 & age>14
est store m4
esttab m4 using test4.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 

//Model 5//
logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_300m_suspects neighborhood_300m_targets household_suspects household_size popdensity300m2 distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14
est store m5
esttab m5 using test5.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 

//Model 6//
logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_300m_convicts neighborhood_300m_targets household_convicts household_size popdensity300m2 distance_mobilizer     distance_communitycenter        elevation slope if ethnicity==0 & age>14
est store m6
esttab m6 using test6.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 


* ********************************************************************************************
*  Models 7-32 replicate the logistic regressions found in the online appendix 
*  agin using convicted and suspected perpetrators as the dependent variable(convict/suspect=1, non-convict/non-suspect=0)
* ********************************************************************************************


//Additional neighborhood sizes tested//
//Model 7//
logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_400m_suspects neighborhood_400m_targets household_suspects household_size popdensity400m2 distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14
est store m7
esttab m7 using test7.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 8//
logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_400m_convicts neighborhood_400m_targets household_convicts household_size popdensity400m2 distance_mobilizer     distance_communitycenter        elevation slope if ethnicity==0 & age>14
est store m8
esttab m8 using test8.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 9//
logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_500m_suspects neighborhood_500m_targets household_suspects household_size popdensity500m2 distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14
est store m9
esttab m9 using test9.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 10//
logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_500m_convicts neighborhood_500m_targets household_convicts household_size popdensity500m2 distance_mobilizer     distance_communitycenter        elevation slope if ethnicity==0 & age>14
est store m10
esttab m10 using test10.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 

//Individual-level predictors only//

//Model 11//
logistic suspect sex age age_squared hhhead  interethnic_union distance_communitycenter elevation slope if ethnicity==0 & age>14  
est store m1
esttab m1 using test1.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 12//
logistic convicted sex age age_squared hhhead  interethnic_union  distance_communitycenter elevation slope if ethnicity==0 & age>14
est store m2
esttab m2 using test2.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 

//Household level predictors only//

//Model 13//
logistic suspect  sex age age_squared hhhead interethnic_union   household_suspects household_size if ethnicity==0 & age>14
est store m1
esttab m1 using test1.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 14//
logistic convicted sex age age_squared hhhead interethnic_union   household_convicts household_size if ethnicity==0 & age>14
est store m2
esttab m2 using test2.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 


//Neighbourhood level predictors only//

//Model 15//
logistic suspect sex age age_squared hhhead interethnic_union   neighborhood_100m_suspects neighborhood_100m_targets   popdensity100m2  if ethnicity==0 & age>14
est store m1
esttab m1 using test1.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 16//
logistic convicted sex age age_squared hhhead interethnic_union   neighborhood_100m_convicts neighborhood_100m_targets  popdensity100m2   if ethnicity==0 & age>14
est store m2
esttab m2 using test2.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 17//
logistic suspect sex age age_squared hhhead interethnic_union   neighborhood_200m_suspects neighborhood_200m_targets   popdensity200m2  if ethnicity==0 & age>14
est store m3
esttab m3 using test3.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 18//
logistic convicted  sex age age_squared hhhead interethnic_union  neighborhood_200m_convicts neighborhood_200m_targets  popdensity200m2 if ethnicity==0 & age>14
est store m4
esttab m4 using test4.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 19//
logistic suspect sex age age_squared hhhead interethnic_union   neighborhood_300m_suspects neighborhood_300m_targets   popdensity300m2  if ethnicity==0 & age>14
est store m5
esttab m5 using test5.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 20//
logistic convicted  sex age age_squared hhhead interethnic_union  neighborhood_300m_convicts neighborhood_300m_targets  popdensity300m2 if ethnicity==0 & age>14
est store m6
esttab m6 using test6.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 


//Neighbourhood and household level predictors only//

//Model 21//
logistic suspect sex age age_squared hhhead interethnic_union  neighborhood_100m_suspects neighborhood_100m_targets household_suspects household_size popdensity100m2  if ethnicity==0 & age>14
est store m1
esttab m1 using test1.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 22//
logistic convicted sex age age_squared hhhead interethnic_union  neighborhood_100m_convicts neighborhood_100m_targets household_convicts household_size popdensity100m2  if ethnicity==0 & age>14 
est store m2
esttab m2 using test2.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 23//
logistic suspect sex age age_squared hhhead interethnic_union   neighborhood_200m_suspects neighborhood_200m_targets household_suspects household_size popdensity200m2 if ethnicity==0 & age>14 
est store m3
esttab m3 using test3.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 24//
logistic convicted sex age age_squared hhhead interethnic_union  neighborhood_200m_convicts neighborhood_200m_targets household_convicts household_size popdensity200m2 if ethnicity==0 & age>14
est store m4
esttab m4 using test4.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 25//
logistic suspect sex age age_squared hhhead interethnic_union   neighborhood_300m_suspects neighborhood_300m_targets household_suspects household_size popdensity300m2  if ethnicity==0 & age>14
est store m5
esttab m5 using test5.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 26//
logistic convicted sex age age_squared hhhead interethnic_union  neighborhood_300m_convicts neighborhood_300m_targets household_convicts household_size popdensity300m2 if ethnicity==0 & age>14
est store m6
esttab m6 using test6.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 


//Stepwise backward elimination using Likelihood Ratio test//

//Model 27//
sw logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_100m_suspects neighborhood_100m_targets popdensity100m2 household_suspects household_size distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14, pr(0.05) pe (0.01) lr
est store m1
esttab m1 using test1.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 28//
sw logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_100m_convicts neighborhood_100m_targets popdensity100m2 household_convicts household_size distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14 , pr(0.05) pe (0.01) lr
est store m2
esttab m2 using test2.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 29//
sw logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_200m_suspects neighborhood_200m_targets popdensity200m2 household_suspects household_size distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14, pr(0.05) pe (0.01) lr
est store m3
esttab m3 using test3.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 30//
sw logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_200m_convicts neighborhood_200m_targets popdensity200m2 household_convicts household_size distance_mobilizer     distance_communitycenter         elevation slope if ethnicity==0 & age>14, pr(0.05) pe (0.01) lr
est store m4
esttab m4 using test4.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 31//
sw logistic suspect sex age age_squared hhhead interethnic_union    neighborhood_300m_suspects neighborhood_300m_targets popdensity300m2 household_suspects household_size distance_mobilizer     distance_communitycenter           elevation slope if ethnicity==0 & age>14, pr(0.05) pe (0.01) lr
est store m5
esttab m5 using test5.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 
//Model 32//
sw logistic convicted sex age age_squared hhhead interethnic_union    neighborhood_300m_convicts neighborhood_300m_targets popdensity300m2 household_convicts household_size distance_mobilizer     distance_communitycenter      elevation slope if ethnicity==0 & age>14, pr(0.05) pe (0.01) lr
est store m6
esttab m6 using test6.rtf, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)wide nocon pr2 one nogaps compress label eform noobs replace 


//Robustness checks//

//Collinearity check:  If VIF>10 or Tolerance<0.2, then collinearity is problematic//
//Find and install collinearity check program//
findit collin
collin sex age hhhead interethnic_union  neighborhood_100m_suspects neighborhood_100m_targets  popdensity100m2 household_suspects household_size distance_mobilizer     distance_communitycenter           elevation slope 

//Correlation check:  If correlation coefficient>0.8, then correlation is problematic)
pwcorr sex age hhhead interethnic_union  neighborhood_100m_suspects  neighborhood_100m_targets  popdensity100m2 household_suspects household_size distance_mobilizer     distance_communitycenter           elevation slope, star (0.05)


