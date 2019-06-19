
** High technology (by SIC 4-digit) **

** Hecker (MLR 1999) covering manufacturing and services: High-tech intensive **

gen byte hitech1 = 0
replace hitech1 = 1 if ( (sic4 == 2810) | (sic4 >= 2830 & sic4 <= 2839) | ///
   (sic4 == 2860) | (sic4 >= 3570 & sic4 <= 3579) | ///
   (sic4 >= 3660 & sic4 <= 3669) | (sic4 >= 3670 & sic4 <= 3679) | ///
   (sic4 >= 3720 & sic4 <= 3729) | (sic4 == 3760) | (sic4 == 3812) | ///
   (sic4 >= 3820 & sic4 <= 3829) | (sic4 >= 7370 & sic4 <= 7379) ) | ///
   (sic4 >= 8730 & sic4 <= 8739)


** Brown et al. (JF 2009) citing U.S. Dept of Commerce **
gen byte hitech2 = 0
replace hitech2 = 1 if ( (sic4 >= 2830 & sic4 <= 2839) | ///
   (sic4 >= 3570 & sic4 <= 3579) | (sic4 >= 3660 & sic4 <= 3669) | ///
   (sic4 >= 3670 & sic4 <= 3679) | (sic4 >= 3720 & sic4 <= 3729) | ///
   (sic4 == 3760) | (sic4 >= 3820 & sic4 <= 3829) | ///
   (sic4 >= 3840 & sic4 <= 3849) )  



label variable hitech1 "High-tech (Hecker)"
label variable hitech2 "High-tech (Brown et al.)"
