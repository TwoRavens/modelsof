/***********************************/
/* Americans Not Partisans Project */
/* Identity Prime as Treatment     */  
/* Experiment #3                   */   
/* Started: August 2016            */ 
/* Finalized: January 2017         */
/***********************************/   

/* Read in the data */ 
use "American_Identity_Prime_only_with_social_identity_questions_replication.dta"

/* Party ID */ 
gen pid = . 
replace pid = 1 if Q2 == 1 & Q4 == 1 
replace pid = 2 if Q2 == 1 & Q4 == 2 
replace pid = 3 if Q2 == 3 & Q8 == 1 
replace pid = 4 if Q2 == 3 & Q8 == . 
replace pid = 5 if Q2 == 3 & Q8 == 2 
replace pid = 6 if Q2 == 2 & Q6 == 2 
replace pid = 7 if Q2 == 2 & Q6 == 1 
table pid 

gen dem = 0 
replace dem = 1 if pid < 4 


/* Feeling Thermometers */ 
gen same_ft = . 
replace same_ft = Q45_2 if dem == 1 
replace same_ft = Q45_3 if dem == 0 

gen other_ft = . 
replace other_ft = Q45_2 if dem == 0 
replace other_ft = Q45_3 if dem == 1 

reg other_ft treatment, level(90) 
reg same_ft treatment, level(90)  
/* no effect on same-party ratings, big effect on out-party ratings */ 

/* Look at just those in treatment: stronger ID, bigger effect? */ 
gen id_strength = (-1*Q161)+6 
gen id_import = -1*Q162+6 
gen id_desc = -1*Q163 + 6 
gen id_typ = -1*Q164 + 6 
gen id_we = -1*Q165 + 6 
alpha id_strength id_import id_desc id_typ id_we 
egen amer_id = rmean(id_strength id_import id_desc id_typ id_we) 

reg other_ft amer_id if treat == 1 
graph twoway (scatter other_ft amer_id) (lfit other_ft amer_id)  
/* yes: stronger your American ID, the bigger the effect */ 
