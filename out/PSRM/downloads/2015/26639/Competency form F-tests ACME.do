version 12.1

**********  Test of the competency form
**********  Joint test if education effects are significantly different across policy positions
*********** Separate regression with interaction EDUCATION * SAMESEX
use data.dta, clear
reg Y i.education##i.samesex pol_interest left_right gender age italian ftstudent lyceum edu_imp inc_imp hon_imp taxspend_imp samesex_imp survey, cl(IDContatto)

foreach x of numlist 1(1)3 {
lincom 3.education + 3.education#`x'.samesex
}

*samesex: university education effect for each policy position
test 3.education#1.samesex 3.education#2.samesex 3.education#3.samesex 
test 3.education#1.samesex = 3.education#2.samesex 
test 3.education#1.samesex = 3.education#3.samesex 
test 3.education#2.samesex = 3.education#3.samesex 

*********** Separate regression with interaction EDUCATION * TAXSPEND
use data.dta, clear
reg Y i.education##i.taxspend pol_interest left_right gender age italian ftstudent lyceum edu_imp inc_imp hon_imp taxspend_imp taxspend_imp survey, cl(IDContatto)

foreach x of numlist 1(1)3 {
lincom 3.education + 3.education#`x'.taxspend
}

*taxspend: university education effect for each policy position
test 3.education#1.taxspend 3.education#2.taxspend 3.education#3.taxspend 
test 3.education#1.taxspend = 3.education#2.taxspend 
test 3.education#1.taxspend = 3.education#3.taxspend 
test 3.education#2.taxspend = 3.education#3.taxspend 
