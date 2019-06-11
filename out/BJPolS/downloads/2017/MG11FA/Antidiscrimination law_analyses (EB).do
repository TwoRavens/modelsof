************************************************************
*  Ziller / Helbling (2017) Antidiscrimination laws,       *
*  Policy Knowledge, and Political Support                 *
*  27 Jun 2017                                             *
*  Analyses file                                           *
************************************************************

************************************************************
* NOTE 1: DUE TO RESTRICTIONS IN DATA AVAILABILITY         *
* VARIABLE std2fb_c (PROPORTIONS OF FOREIGN-BORN) IS NOT   *
* INCLUDED IN THE REPLICATION DATA FILE. PLEASE VISIT      *
* EUROSTAT IN ORDER TO OBTAIN THE MICRODATA, WHICH CAN BE  *
* AGGREGATED TO COUNTRY-YEAR FIGURES.                      *
* MODELS CAN ALTERNATIVELY BE ESTIMATED WITHOUT THIS       *
* CONTROL VARIABLE. TO DO SO, FIND AND REPLACE (Ctrl+H)    * 
* ANY "std2fb_c" IN THE DO-FILE.                           *
************************************************************ 

************************************************************
* NOTE 2: TO REPLICATE COEFFICIENT PLOTS PLEASE FIRST      *
* EXECUTE THIS FILE AND SUBSEQUENTLY THE ESS ANALYSIS      *
************************************************************


use "Antidiscrimination laws_data (EB).dta", clear



********* 1. AVERAGE EFFECTS


mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c i.year i.idx ||year_cnt:  
eststo po_sit_nat_f

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c i.year i.idx ||year_cnt: if gender==1  
eststo po_sit_gender_f

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c i.year i.idx ||year_cnt: if first==1  
eststo po_sit_first_f






estimates dir
estimates replay po_sit_nat_f
estimates replay po_sit_gender_f
estimates replay po_sit_first_f

 


estimates restore po_sit_nat_f
eret list
estimates save "myestEB.est" , replace
estimates restore po_sit_gender_f
eret list
estimates save "myestEB.est" , append
estimates restore po_sit_first_f
eret list
estimates save "myestEB.est" , append




********* 2. Interaction with discrimination


 

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c    c.std2know_c##c.discr i.year i.idx ||year_cnt: discr     
eststo po_sit_nat_f_dis


mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c   c.std2know_c##c.discr i.year i.idx ||year_cnt: discr   if gender==1      
eststo po_sit_gender_f_dis

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c   c.std2know_c##c.discr  i.year i.idx ||year_cnt: discr   if first==1      
eststo po_sit_first_f_dis

	

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c   c.std2adp_c##c.discr i.year i.idx ||year_cnt: discr     
eststo po_sit_nat_f_disA


mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c    c.std2adp_c##c.discr  i.year i.idx ||year_cnt: discr   if gender==1  
eststo po_sit_gender_f_disA

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3        ///
std2unempl_c std2fb_c std2adp_c   std2know_c   c.std2adp_c##c.discr  i.year i.idx ||year_cnt: discr   if first==1   
eststo po_sit_first_f_disA





esttab  po_sit_nat_f_disA po_sit_nat_f_dis po_sit_gender_f_disA po_sit_gender_f_dis po_sit_first_f_disA po_sit_first_f_dis ///
using "Table_2a.rtf", b(3)  star(* 0.05 ** 0.01 )  se   stats(N r2) transform(ln*: exp(@) exp(@)) replace




estimates dir
estimates replay po_sit_nat_f_dis
estimates replay po_sit_gender_f_dis
estimates replay po_sit_first_f_dis
 estimates replay po_sit_nat_f_disA
estimates replay po_sit_gender_f_disA
estimates replay po_sit_first_f_disA

 


estimates restore po_sit_nat_f_dis
eret list
estimates save "myestEB_dis2.est" , replace
estimates restore po_sit_gender_f_dis
eret list
estimates save "myestEB_dis2.est" , append
estimates restore po_sit_first_f_dis
eret list
estimates save "myestEB_dis2.est" , append
estimates restore po_sit_nat_f_disA
eret list
estimates save "myestEB_dis2.est" , append
estimates restore po_sit_gender_f_disA
eret list
estimates save "myestEB_dis2.est" , append
estimates restore po_sit_first_f_disA
eret list
estimates save "myestEB_dis2.est" , append








//3. Test interaction with individual-level knowledge

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c c.std2know_c##c.know  i.year  i.idx ||year_cnt:  know      
eststo po_sit_nat_f_k 

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c c.std2know_c##c.know  i.year i.idx ||year_cnt:  know   if gender==1  
eststo po_sit_gender_f_k

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c c.std2know_c##c.know  i.year i.idx ||year_cnt:  know   if first==1  
eststo po_sit_first_f_k




mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c c.std2adp_c##c.know  i.year i.idx ||year_cnt: know      
eststo po_sit_nat_f_kA

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c c.std2adp_c##c.know  i.year i.idx ||year_cnt:  know   if gender==1  
eststo po_sit_gender_f_kA

mixed std2evalpa know std2age  gender first educ_2-educ_5 std2feel_inc unemp3 u2 u3       ///
std2unempl_c std2fb_c std2adp_c   std2know_c c.std2adp_c##c.know  i.year i.idx ||year_cnt:  know   if first==1  
eststo po_sit_first_f_kA



