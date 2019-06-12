
/*==============================================================================
                 DEFINE PROGRAM PREPARE AND COLLAPSE DATA 
==============================================================================*/

*** set up program

* drop program if it exists already
capture program drop prepare_collapse_data

* define program 
program prepare_collapse_data 
	
* collapse to territory-decade cells
#delimit ;
collapse (sum) towns building1400_1470 build_count_1 build_count_2 build_count_3 build_count_4 
build_count_5 build_count_6 build_count_7 build_count_all build_count_secular, 
by(decade holder* ever_protestant indicator_religion_euratlas);
#delimit cr

 
*** Protestantism-Year Interaction Setup 1: one pre & two post reformation indicators

* split post indicator in two periods
gen post_t1 = decade >= 1520 & decade <= 1540
gen post_t2 = decade >= 1550 

* interactions of new post indicators with Protestant
gen post_t1_x_prot = post_t1 * ever_protestant
gen post_t2_x_prot = post_t2 * ever_protestant

* label new indicators
lab var post_t1_x_prot  "Protestant * 1520-1549"
lab var post_t2_x_prot "Protestant * 1550-1599"


* Protestantism-Year Interaction Setup 2: interact Protest. and every decade 
forvalues j = 1470(10)1590 {
	gen prot_x_dec`j' = ever_protestant * (decade == `j')
	label var prot_x_dec`j' "Protestant * `j'"
}


*** generate regression variables 

* construction levels & decade interactions 
forvalues j = 1470(10)1590 {
	gen build1470_x_dec`j' = building1400_1470 * (decade == `j')
	label var build1470_x_dec`j' "Building pre-1470 * `j'"
}

* dependent variables
gen build_count_church = build_count_1 
gen build_count_public = build_count_2 + build_count_4 + build_count_5

* label construction counts 
lab var build_count_church "Church"
lab var build_count_secular "Secular"
lab var build_count_public "Administrative"


***  construct "pre-treatment outcome levels" controls \`a la Hornbeck  

* 1. pre-treatment level outcomes (necessary for interactions in step 2 below)

* pre-treatment levels of church construcion
foreach y of numlist 1450(10)1510 {
	gen build_count_church_`y' = .
	replace build_count_church_`y' = build_count_church if decade==`y'
	bysort holder1500_id (build_count_church_`y'): replace build_count_church_`y'=build_count_church_`y'[1]
}

* pre-treatment levels of secular construcion
foreach y of numlist 1450(10)1510 {
	gen build_count_secular_`y' = .
	replace build_count_secular_`y' = build_count_secular if decade==`y'
	bysort holder1500_id (build_count_secular_`y'): replace build_count_secular_`y'=build_count_secular_`y'[1]
}

* pre-treatment levels of public construcion
foreach y of numlist 1450(10)1510 {
	gen build_count_public_`y' = .
	replace build_count_public_`y' = build_count_public if decade==`y'
	bysort holder1500_id (build_count_public_`y'): replace build_count_public_`y'=build_count_public_`y'[1]
}

* 2. interactions of pre-treatment levels with decade dummys 

* generate decade dummys
foreach j of numlist 1470(10)1590 {
	gen dec`j' = (decade==`j')
}

/* generate interactions for each level of church construction (1450-1510, by decade)
	with every decade from (1450 - 1590) */
	
foreach y of numlist 1470(10)1510 {
	foreach j of numlist 1470(10)1590 {
		gen build_chu_`y'_x_dec`j' = build_count_church_`y' * dec`j'
	}
}


/* generate interactions for each level of secular construction (1450-1510, by decade)
	* with every decade from (1450 - 1590) */

foreach y of numlist 1470(10)1510 {
	foreach j of numlist 1470(10)1590 {
		gen build_sec_`y'_x_dec`j' = build_count_secular_`y' * dec`j'
	}
}


/* generate interactions for each level of public construction (1450-1510, by decade)
	with every decade from (1450 - 1590) */

foreach y of numlist 1470(10)1510 {
	foreach j of numlist 1470(10)1590 {
		gen build_pub_`y'_x_dec`j' = build_count_public_`y' * dec`j'
	}
}


end 
