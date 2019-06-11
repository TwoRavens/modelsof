

/*==============================================================================
                          Reshape Univervity_students_new 
==============================================================================*/

*** data set-up

* import data 
clear all								
use	"$path/data/student_data_RAG", clear

* drop duplicates
duplicates drop student_id, force

* gen new student_id	
drop student_id
gen student_id = _n 
lab var student_id "Unique Student ID (i = 1,...,N)"

*** reshape data as long 

* organize degrees
keep student_id deg_uni* deg_mat_dum deg_year* deg_type* 

* reshape data
reshape long deg_year deg_uni, i(student_id) j(number)

* rename year => deg_year
ren deg_year year

* save degree entry (string) in same column for every student 
gen deg = ""
forvalues x = 0(1)11 {
	replace deg = deg_type`x' if number == `x'
}
* drop columns deg_type which are now redundant 
drop deg_type*
drop if year == .

*** standardize degrees 

/* Note: for comments within delimits we switch to "//" instead of "*" 
	since "*" would result in errors because everything in the delimiter after "*" 
	would not be used by Stata" */ 

**	 arts degrees 
#delimit ;
// set up indicator if student obtained a bachelor in arts 	
gen deg_art_bac = 	
	regexm(deg,"bacc. art.") == 1 |
	regexm(deg,"bacc. decr.") == 1 ; 
// set up indicator if student obtained a license in arts
gen deg_art_lic = 	
	regexm(deg,"lic. art.") == 1 |
	regexm(deg,"lic. decr.") == 1 ;
// set up indicator if student obtained a magister in arts
gen deg_art_mag = 	
	regexm(deg,"mag. art.") == 1 ;
// set up indicator if student obtained a doctorate in arts
gen deg_art_doc = 	
	regexm(deg,"dr. art. et phil.") == 1 |
	regexm(deg,"dr. decr.") == 1 |
	regexm(deg,"dr. art.") == 1 ;
#delimit cr	
replace deg_art_bac = 1 if deg == "bacc."	
replace deg_art_lic = 1 if deg == "lic."	
replace deg_art_mag = 1 if deg == "mag."	
replace deg_art_doc = 1 if deg == "dr."	
	
** 	law degrees	
#delimit ;	
// BAs
gen deg_law_bac = 	
	regexm(deg,"bacc. iur.") == 1 |
	regexm(deg,"bacc. iur. civ.") == 1 |
	regexm(deg,"bacc. iur. can.") == 1 |
	regexm(deg,"bacc. utr. iur.") == 1 |
	regexm(deg,"bacc. leg.") == 1 ; 
// license
gen deg_law_lic = 	
	regexm(deg,"lic. iur.") == 1 |
	regexm(deg,"lic. iur. can.") == 1 |
	regexm(deg,"lic. iur. civ.") == 1 |
	regexm(deg,"lic. utr. iur.") == 1 |
	regexm(deg,"lic. leg.") == 1;
// MAs
gen deg_law_mag = regexm(deg,"mag. iur."); 
// PH.Ds
gen deg_law_doc = 	
	regexm(deg,"dr. iur.") == 1 |
	regexm(deg,"dr. iur. can.") == 1 |
	regexm(deg,"dr. iur. civ.") == 1 |
	regexm(deg,"dr. utr. iur.") == 1 |
	regexm(deg,"dr. lic. utr. iur.") == 1 | 
	regexm(deg,"dr. leg.") == 1; 
#delimit cr	
	
// theology degrees	
#delimit ;	
gen deg_the_bac = 	
	regexm(deg,"bacc. bibl. theol.") == 1 |
	regexm(deg,"bacc. curs. theol.") == 1 |
	regexm(deg,"bacc. form. theol.") == 1 |
	regexm(deg,"bacc. sent. theol.") == 1 |
	regexm(deg,"bacc. theol.") == 1 ;
#delimit cr	
gen deg_the_lic = regexm(deg,"lic. theol.")	
gen deg_the_mag = regexm(deg,"mag. theol.")	
gen deg_the_doc = regexm(deg,"dr. theol.")	
	
// medical	
gen deg_med_bac = regexm(deg,"bacc. med.")	
gen deg_med_mag = regexm(deg,"mag. med.")	
#delimit ;	
gen deg_med_lic = regexm(deg,"lic. med.") == 1 | regexm(deg,"lic. med. chir.") == 1 ;	
gen deg_med_doc = 	
	regexm(deg,"dr. med.") == 1 |
	regexm(deg,"dr. med. phys.") == 1 |
	regexm(deg,"dr. med. utr.") == 1 ;
#delimit cr	


*** aggregate and label data 

* collapse degrees to student-year-university level
#delimit ;
collapse (sum) deg_a* deg_l* deg_me* deg_t*, 
by(student_id deg_uni deg_mat_dum year) ;
#delimit cr


* variable labels	
lab var deg_uni "University Awarding Degree"
lab var year "Year" 		

forvalues j = 1(1)4 {
	local fields "art law med the"
	local Fields "Art Law Medicine Theology"
	local k: word `j' of `fields'
	local m: word `j' of `Fields'
	forvalues n = 1(1)4 {
		local qualifications "bac lic mag doc"
		local Qualifications "Bachelors License Masters Doctorate"
		local s: word `n' of `qualifications'
		local t: word `n' of `Qualifications'
		lab var deg_`k'_`s' "Count: `t' of `m'"
	}
}

* Save transformed data
saveold "$path/data/student_data_RAG_panel.dta", replace
