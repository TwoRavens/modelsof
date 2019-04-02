*##########################################################*
* Lajevardi and Abrajano                                   *
* How Negative Sentiment towards Muslim Americans Predicts *
* Support for Trump in the 2016 Presidential Election      *
* Journal: Journal of Politics                             *
* Stata Replication Code                                   *
* Tested on Stata 15.1                                     *
*##########################################################*

clear all
set more off
cd "/Users/nazita/Desktop/Projects/Resentment Paper/Data"




************ I N   T E X T   T A B L E S ************


*#############*
* Table 1     *
*#############*
									
eststo clear
						
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
eststo: reg supportDT_primary z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female 
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female 
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
eststo: logit supportDT z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female 
restore

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy democrat independent  black otherrace2 age educ income female 
restore

esttab, r2
esttab using table1.tex, se ar2 replace



*#############*
* Table 2    *
*#############*	
			
eststo clear		
							
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
eststo: reg supportDT_primary z_mrr z_fav_muslim  z_cces_rr  democrat independent  black otherrace2 age educ income female 
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
eststo: logit supportDT z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam  democrat independent  black otherrace2 age educ income female
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
restore

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy z_cces_rr z_fav_black z_fav_latino z_fav_asianam  democrat independent  black otherrace2 age educ income female 
restore

esttab, r2
esttab using table2.tex, se ar2 replace

			
			
			
******** O N L I N E   A P P E N D I X   T A B L E S *********
			
		
			
*######################*
* Appendix Table 1     *
*######################*
									
eststo clear
						
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
eststo: reg supportDT_primary z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female 
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female 
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
eststo: logit supportDT z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female 
restore

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy democrat independent  black otherrace2 age educ income female 
restore

esttab, r2
esttab using apptable1.tex, se ar2 replace


	
*######################*
* Appendix Table 2     *
*######################*
							

			
eststo clear		
							
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
eststo: reg supportDT_primary z_mrr z_fav_muslim  z_cces_rr  democrat independent  black otherrace2 age educ income female 
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
eststo: logit supportDT z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam  democrat independent  black otherrace2 age educ income female
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
restore

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy z_cces_rr z_fav_black z_fav_latino z_fav_asianam  democrat independent  black otherrace2 age educ income female 
restore

esttab, r2
esttab using apptable2.tex, se ar2 replace

			
			
			
*######################*
* Appendix Table 3     *
*######################*
													
								
eststo clear
				
						
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
reg supportDT_primary z_mrr z_fav_muslim  z_cces_rr  democrat independent  black otherrace2 age educ income female 
outreg2 using apptable3.tex, replace ctitle(Model 1)
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
quietly logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
margins, dydx(*) post
outreg2 using apptable3.tex, append ctitle(Model 2)
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
quietly logit supportDT z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female
margins, dydx(*) post
outreg2 using apptable3.tex, append ctitle(Model 3)
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
quietly logit trumpvote2016 z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam  democrat independent  black otherrace2 age educ income female
margins, dydx(*) post
outreg2 using apptable3.tex, append ctitle(Model 4)
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
quietly logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
margins, dydx(*) post
outreg2 using apptable3.tex, append ctitle(Model 5)
restore

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
quietly logit trumpvote2016 z_mrr z_fav_muslim z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy z_cces_rr z_fav_black z_fav_latino z_fav_asianam  democrat independent  black otherrace2 age educ income female 
margins, dydx(*) post
outreg2 using apptable3.tex, append ctitle(Model 6)
restore


	
*######################*
* Appendix Table 4     *
*######################*
															
eststo clear
						
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
eststo: reg supportDT_primary z_mrr democrat independent  black otherrace2 age educ income female
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
eststo: logit trumpvote2016 z_mrr democrat independent  black otherrace2 age educ income female
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
eststo: logit supportDT z_mrr democrat independent  black otherrace2 age educ income female
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr democrat independent  black otherrace2 age educ income female
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr democrat independent  black otherrace2 age educ income female
restore

esttab, r2
esttab using apptable4.tex, se ar2 replace



*######################*
* Appendix Table 5     *
*######################*
								
eststo clear 
								
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
eststo: reg supportDT_primary z_cces_rr
restore

* Model 2		9/2016 ANES
preserve
use "2016_9_ANES standardized.dta",replace
eststo: logit votetrump2016 z_cces_rr z_fav_black z_fav_latino z_fav_asianam
restore

* Model 3		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
eststo: logit trumpvote2016 z_cces_rr z_fav_black z_fav_latino z_fav_asianam
restore

* Model 4		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
eststo: logit supportDT z_fav_black z_fav_latino z_fav_asianam
restore

* Model 5		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_fav_black z_fav_latino z_fav_asianam
restore 

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_cces_rr z_fav_black z_fav_latino z_fav_asianam
restore

esttab, r2
esttab using apptable5.tex, se ar2 replace

	

*######################*
* Appendix Table 6     *
*######################*
													
eststo clear
				
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
eststo: reg supportDT_primary z_mrr z_fav_muslim z_cces_rr democrat independent  black otherrace2 age educ income female terror economy immigration
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female  terror economy immigration
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
eststo: logit supportDT z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female  terror economy
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female  economy terror
restore 

esttab, r2
esttab using apptable6.tex, se ar2 replace



*######################*
* Appendix Table 7     *
*######################*			
			
eststo clear
							
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
eststo: logit muslim_ban2 z_mrr z_fav_muslim z_cces_rr black otherrace2 age income female educ democrat independent 
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
eststo: logit muslim_ban2 z_mrr z_fav_muslim z_cces_rr z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
restore

* Model 3		12/2016 SSI (0-100 scale)
preserve 
use "2016_12_SSI standardized.dta", replace
eststo: reg banmuslims z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female
restore

* Model 4		1/2017 MTurk (1-5 scale)
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: reg banmuslims z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit banmuslims z_mrr z_cces_rr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam democrat independent  black otherrace2 age educ income female 
restore

* Model 6		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit banmuslims z_mrr z_cces_rr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy democrat independent  black otherrace2 age educ income female 
restore

esttab, r2
esttab using apptable7.tex, se ar2 replace


			
*######################*
* Appendix Table 8     *
*######################*			
				

*5/2016 MTurk
clear	
use "2016_5_MTurk standardized.dta", replace 
list		
		
*9/2016 ANES
clear		
use "2016_9_ANES standardized.dta", replace 
list 
						
*10/2016 CCAP
clear
use "2016_10_CCAP standardized.dta", replace			
list 
			
*12/2016 SSI 
clear
use "2016_12_SSI standardized.dta", replace
list 

*1/2017 MTurk 			
clear
use "2017_1_MTurk standardized.dta", replace 			
list 
			
*6/2017 MTurk			
clear
use "2017_6_MTurk standardized.dta", replace 			
list 			
			
			
			
		
*######################*
* Appendix Table 9     *
*######################*			
				

*5/2016 MTurk
clear	
use "2016_5_MTurk standardized.dta", replace 
tab concern_financialcrisis		
		
*9/2016 ANES
clear		
use "2016_9_ANES standardized.dta", replace 
tab economy 
						
*10/2016 CCAP
clear
use "2016_10_CCAP standardized.dta", replace			
tab anger_economy
			
*12/2016 SSI 
clear
use "2016_12_SSI standardized.dta", replace
tab economy 

*1/2017 MTurk 			
clear
use "2017_1_MTurk standardized.dta", replace 			
tab economy 

*6/2017 MTurk n/a


*######################*
* Appendix Table 10    *
*######################*			
				

*5/2016 MTurk
clear	
use "2016_5_MTurk standardized.dta", replace 
tab	immigration	
		
*9/2016 ANES
clear		
use "2016_9_ANES standardized.dta", replace 
tab immigration
						
*10/2016 CCAP
clear
use "2016_10_CCAP standardized.dta", replace			
tab pp_immi_makedifficult
			
*12/2016 SSI n/a

*1/2017 MTurk 			
clear
use "2017_1_MTurk standardized.dta", replace 			
tab eo_wall
			
*6/2017 MTurk n/a			
		
			
*######################*
* Appendix Table 11    *
*######################*			
			
									
eststo clear
				
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
rename concern_terroristattack terror
rename concern_financialcrisis economy 
eststo: reg supportDT_primary z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female terror economy immigration
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
rename terror terror1
rename anger_economy economy
rename anger_extreme terror
eststo: logit trumpvote2016 z_mrr z_fav_muslim  democrat independent  black otherrace2 age educ income female  terror economy immigration
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
rename satisfied directioncountry
eststo: logit supportDT z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female  terror economy
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr z_fav_muslim democrat independent  black otherrace2 age educ income female  economy terror
restore 

esttab, r2
esttab using apptable11.tex, se ar2 replace
			
			
			
			
*######################*
* Appendix Table 12    *
*######################*			
					
			
eststo clear 		
						
* Model 1		5/2016 MTurk
preserve
use "2016_5_MTurk standardized.dta", replace 
eststo: reg supportDT_primary z_mrr 
restore

* Model 2		10/2016 CCAP
preserve
use "2016_10_CCAP standardized.dta", replace
eststo: logit trumpvote2016 z_mrr 
restore

* Model 3		12/2016 SSI
preserve 
use "2016_12_SSI standardized.dta", replace
eststo: logit supportDT z_mrr 
restore

* Model 4		1/2017 MTurk
preserve
use "2017_1_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr 
restore 

* Model 5		6/2017 MTurk
preserve
use "2017_6_MTurk standardized.dta", replace 
eststo: logit trumpvote2016 z_mrr 
restore

esttab, r2
esttab using apptable12.tex, se ar2 replace

		
		
		
		
*######################*
* Appendix Table 13    *
*######################*			
				
	
*Mturk 5/2016
clear all
use "2016_5_MTurk standardized.dta"
factor mrr1 -mrr9, ipf factor(3)
screeplot
rotate, varimax horst
rotate, varimax horst blanks(.3)  
sem(Mrr -> mrr1-mrr9), standardized
estat gof, stats(all)
alpha mrr1-mrr9, item

*CCAP 10/2016
clear all
use "2016_10_CCAP standardized.dta"
factor mrr1 -mrr9, ipf factor(3)
screeplot
sem(Mrr -> mrr1-mrr9), standardized
estat gof, stats(all)
alpha mrr1-mrr9, item

*SSI 12/2016
clear all
use "2016_12_SSI standardized.dta"
factor mrr1 -mrr9, ipf factor(3)
screeplot
factor mrr1 -mrr9, ipf factor(2)
rotate, varimax horst
rotate, varimax horst blanks(.3)  
sem(Mrr -> mrr1-mrr9), standardized
estat gof, stats(all)
alpha mrr1-mrr9, item

*MTurk 1/2017
clear all
use "2017_1_MTurk standardized.dta"
factor mrr1 -mrr9, ipf factor(3)
screeplot
sem(Mrr -> mrr1-mrr9), standardized
estat gof, stats(all)
alpha mrr1-mrr9, item


*MTurk 6/2017
clear all
use "2017_6_MTurk standardized.dta"
factor mrr1 -mrr9, ipf factor(3)
screeplot
sem(Mrr -> mrr1-mrr9), standardized
estat gof, stats(all)
alpha mrr1-mrr9, item



		
*######################*
* Appendix Table 14    *
*######################*				
				
*Mturk 5/2016
clear all
use "2016_5_MTurk standardized.dta"
alpha mrr1-mrr9, item
alpha cces_rr1 cces_rr2 cces_rr3 cces_rr4, item 

*ANES 9/2016
clear all
use "2016_9_ANES standardized.dta"
alpha cces_rr1 cces_rr2 cces_rr3 cces_rr4, item 

*CCAP 10/2016
clear all
use "2016_10_CCAP standardized.dta", replace
alpha mrr1-mrr9, item
alpha cces_rr1 cces_rr3 cces_rr4, item

*SSI 12/2016
clear all
use "2016_12_SSI standardized.dta"
alpha mrr1-mrr9, item

*MTurk 1/2017
clear all
use "2017_1_MTurk standardized.dta"
alpha mrr1-mrr9, item

*MTurk 6/2017
clear all
use "2017_6_MTurk standardized.dta"
alpha mrr1-mrr9, item
alpha cces_rr1 cces_rr2 cces_rr3 cces_rr4, item 



*######################*
* Appendix Table 15    *
*######################*	

*Mturk 5/2016
clear all
use "2016_5_MTurk standardized.dta"
 estpost corr z_mrr z_fav_muslim z_cces_rr, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*CCAP 10/2016
clear all
use "2016_10_CCAP standardized.dta"
 estpost corr z_mrr z_cces_rr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*SSI 12/2016
clear all
use "2016_12_SSI standardized.dta"
 estpost corr z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*MTurk 1/2016
clear all
use "2017_1_MTurk standardized.dta"
 estpost corr z_mrr z_fav_muslim z_fav_black z_fav_latino z_fav_asianam, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*MTurk 6/2017
clear all
use "2017_6_MTurk standardized.dta"
 estpost corr z_mrr z_fav_muslim z_muslim_patriotic z_muslim_intelligent z_muslim_lazy z_muslim_violent z_muslim_trustworthy z_cces_rr z_fav_black z_fav_latino z_fav_asianam, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex





*######################*
* Appendix Table 16    *
*######################*	

*Mturk 5/2016
clear all
use "2016_5_MTurk standardized.dta"
 estpost corr z_mrr age female male republican democrat independent white black otherrace2 educ income, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*CCAP 10/2016
clear all
use "2016_10_CCAP standardized.dta"
 estpost corr z_mrr age female male republican democrat independent white black otherrace2 educ income, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*SSI 12/2016
clear all
use "2016_12_SSI standardized.dta"
 estpost corr z_mrr age female male republican democrat independent white black otherrace2 educ income, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*MTurk 1/2016
clear all
use "2017_1_MTurk standardized.dta"
 estpost corr z_mrr age female male republican democrat independent white black otherrace2 educ income, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex

*MTurk 6/2017
clear all
use "2017_6_MTurk standardized.dta"
 estpost corr z_mrr age female male republican democrat independent white black otherrace2 educ income, matrix
 esttab . using myfile.tex, not unstack compress noobs replace booktabs page
!texify -p -c -b --run-viewer myfile.tex




*######################*
* Appendix Table 17    *
*######################*	

 
clear 
eststo clear
 
*Mturk 5/2016
preserve
use "2016_5_MTurk standardized.dta"
eststo: quietly reg supportDT_primary z_mrr z_fav_muslim democrat independent age educ income female if white ==1
eststo: quietly reg supportDT_primary z_mrr z_fav_muslim democrat independent age educ income female if white ==0
restore

*CCAP 10/2016
preserve
use "2016_10_CCAP standardized.dta"
eststo: quietly logit trumpvote2016 z_mrr z_fav_muslim democrat independent age educ income female if white ==1 
eststo: quietly logit trumpvote2016 z_mrr z_fav_muslim democrat independent age educ income female if white ==0
restore

*SSI 12/2016
preserve
use "2016_12_SSI standardized.dta"
eststo: quietly logit supportDT z_mrr z_fav_muslim democrat independent age educ income female if white ==1
eststo: quietly logit supportDT z_mrr z_fav_muslim democrat independent age educ income female if white ==0
restore

esttab, se ar2
esttab using apptable17.tex, se ar2 replace


 
 
 
*######################*
* Appendix Table 18    *
*######################*	


clear 
eststo clear

*MTurk 1/2017

preserve
use "2017_1_MTurk standardized.dta"
eststo: quietly logit trumpvote2016 z_mrr z_fav_muslim democrat independent age educ income female if white ==1
eststo: quietly logit trumpvote2016 z_mrr z_fav_muslim democrat independent age educ income female if white ==0
restore


*MTurk 6/2017

preserve
use "2017_6_MTurk standardized.dta"
eststo: quietly  logit trumpvote2016 z_mrr z_fav_muslim democrat independent age educ income female if white ==1
eststo: quietly logit trumpvote2016 z_mrr z_fav_muslim democrat independent age educ income female if white ==0
restore


esttab, se ar2
esttab using apptable18.tex, se ar2 replace

 





 
*######################*
* Appendix Table 19    *
*######################*	

*See R Script


 
*######################*
* Appendix Figure 1    *
*######################*	



*See R Script
 
*######################*
* Appendix Figure 2    *
*######################*	



*See R Script






		
				
				
