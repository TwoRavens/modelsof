* Date: February 5, 2019
* Description: Analyze blame rankings for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Treatments

drop if treat_info==.

gen pattern = 0
replace pattern = 1 if treat_info==2

gen reform = 0
replace reform = 1 if treat_info==3


* Interactions

gen saccounty = 0
replace saccounty = 1 if county=="sacramento"
replace saccounty = . if county==""

gen sac_pattern = saccounty * pattern
gen sac_reform = saccounty * reform


gen black = 0
replace black = 1 if race==2
replace black = . if race==.

gen black_pattern = black * pattern
gen black_reform = black * reform


* Format variables for reshape

rename blame_clark blame_1
rename blame_officers blame_2
rename blame_hahn blame_3
rename blame_steinberg blame_4
rename blame_schubert blame_5
rename blame_brown blame_6
rename blame_senators blame_7


reshape long blame_, i(idno) j(option)


* Define option characteristics

gen victim = 0
replace victim = 1 if option==1

gen officers = 0
replace officers = 1 if option==2

gen police = 0
replace police = 1 if option==2 | option==3

gen mayor = 0
replace mayor = 1 if option==4

gen local = 0
replace local = 1 if option==4 | option==5

gen statefed = 0
replace statefed = 1 if option==6 | option==7


* Table A2
* Blame for the death of Stephon Clark

set more off

rologit blame police treat_info#c.police treat_info#c.police ///
     local treat_info#c.local treat_info#c.local ///
     statefed treat_info#c.statefed treat_info#c.statefed ///
     c.saccounty#c.(police treat_info#c.police treat_info#c.police) ///
     c.saccounty#c.(local treat_info#c.local treat_info#c.local) ///
     c.saccounty#c.(statefed treat_info#c.statefed treat_info#c.statefed) ///
     c.black#c.(police treat_info#c.police treat_info#c.police) ///
     c.black#c.(local treat_info#c.local treat_info#c.local) ///
     c.black#c.(statefed treat_info#c.statefed treat_info#c.statefed) ///
     , group(idno)


* Table 1
* Test blame coefficients, non-Sacramento

test police = 0
test (police + 2.treat_info#c.police) = 0
test (police + 3.treat_info#c.police) = 0

test local = 0
test (local + 2.treat_info#c.local) = 0
test (local + 3.treat_info#c.local) = 0

test statefed = 0
test (statefed + 2.treat_info#c.statefed) = 0
test (statefed + 3.treat_info#c.statefed) = 0


* Test blame coefficients, Sacramento Respondents

test (police + c.saccounty#c.police) = 0
test (police + 2.treat_info#c.police + c.saccounty#c.police + 2.treat_info#c.saccounty#c.police) = 0
test (police + 3.treat_info#c.police + c.saccounty#c.police + 3.treat_info#c.saccounty#c.police) = 0

test (local + c.saccounty#c.local) = 0
test (local + 2.treat_info#c.local + c.saccounty#c.local + 2.treat_info#c.saccounty#c.local) = 0
test (local + 3.treat_info#c.local + c.saccounty#c.local + 3.treat_info#c.saccounty#c.local) = 0

test (statefed + c.saccounty#c.statefed) = 0
test (statefed + 2.treat_info#c.statefed + c.saccounty#c.statefed + 2.treat_info#c.saccounty#c.statefed) = 0
test (statefed + 3.treat_info#c.statefed + c.saccounty#c.statefed + 3.treat_info#c.saccounty#c.statefed) = 0


* Test blame coefficients, Black Respondents

test (police + c.black#c.police) = 0
test (police + 2.treat_info#c.police + c.black#c.police + 2.treat_info#c.black#c.police) = 0
test (police + 3.treat_info#c.police + c.black#c.police + 3.treat_info#c.black#c.police) = 0

test (local + c.black#c.local) = 0
test (local + 2.treat_info#c.local + c.black#c.local + 2.treat_info#c.black#c.local) = 0
test (local + 3.treat_info#c.local + c.black#c.local + 3.treat_info#c.black#c.local) = 0

test (statefed + c.black#c.statefed) = 0
test (statefed + 2.treat_info#c.statefed + c.black#c.statefed + 2.treat_info#c.black#c.statefed) = 0
test (statefed + 3.treat_info#c.statefed + c.black#c.statefed + 3.treat_info#c.black#c.statefed) = 0


* Test differences in blame coefficients, non-Sacramento Respondents

test (police + 2.treat_info#c.police) - (police) = 0
test (police + 3.treat_info#c.police) - (police) = 0

test (local + 2.treat_info#c.local) - (local) = 0
test (local + 3.treat_info#c.local) - (local) = 0

test (statefed + 2.treat_info#c.statefed) - (statefed) = 0
test (statefed + 3.treat_info#c.statefed) - (statefed) = 0


* Test differences in blame coefficients, Sacramento Respondents

test (police + 2.treat_info#c.police + c.saccounty#c.police + 2.treat_info#c.saccounty#c.police) - (police + c.saccounty#c.police) = 0
test (police + 3.treat_info#c.police + c.saccounty#c.police + 3.treat_info#c.saccounty#c.police) - (police + c.saccounty#c.police) = 0

test (local + 2.treat_info#c.local + c.saccounty#c.local + 2.treat_info#c.saccounty#c.local) - (local + c.saccounty#c.local) = 0
test (local + 3.treat_info#c.local + c.saccounty#c.local + 3.treat_info#c.saccounty#c.local) - (local + c.saccounty#c.local) = 0

test (statefed + 2.treat_info#c.statefed + c.saccounty#c.statefed + 2.treat_info#c.saccounty#c.statefed) - (statefed + c.saccounty#c.statefed) = 0
test (statefed + 3.treat_info#c.statefed + c.saccounty#c.statefed + 3.treat_info#c.saccounty#c.statefed) - (statefed + c.saccounty#c.statefed) = 0


* Test differences in blame coefficients, Black Respondents

test (police + 2.treat_info#c.police + c.black#c.police + 2.treat_info#c.black#c.police) - (police + c.black#c.police) = 0
test (police + 3.treat_info#c.police + c.black#c.police + 3.treat_info#c.black#c.police) - (police + c.black#c.police) = 0

test (local + 2.treat_info#c.local + c.black#c.local + 2.treat_info#c.black#c.local) - (local + c.black#c.local) = 0
test (local + 3.treat_info#c.local + c.black#c.local + 3.treat_info#c.black#c.local) - (local + c.black#c.local) = 0

test (statefed + 2.treat_info#c.statefed + c.black#c.statefed + 2.treat_info#c.black#c.statefed) - (statefed + c.black#c.statefed) = 0
test (statefed + 3.treat_info#c.statefed + c.black#c.statefed + 3.treat_info#c.black#c.statefed) - (statefed + c.black#c.statefed) = 0

* End
