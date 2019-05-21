/***********************************/
/* Americans Not Partisans Project */
/* SSI Study                       */
/* Experiment #2                   */    
/* Started: April 2016             */ 
/* Finalized: January 2017         */
/***********************************/   

/* Begin wtih study 1 */ 
use "study1_text.dta", clear 
gen study_numb = 1 

/* Append the two studies together */ 
append using study2_text.dta

/* effects on feeling thermometers*/ 
reg opp_party_ft text_prime  
reg opp_party_ft text_prime study_numb, level(90) 
reg opp_party_ft text_prime##study_numb
reg same_ft text_prime 
reg same_ft text_prime study_numb, level(90)  
reg same_ft text_prime##study_numb 
** some v. minor diff on same-party baseline, but no interactive effects ** 
