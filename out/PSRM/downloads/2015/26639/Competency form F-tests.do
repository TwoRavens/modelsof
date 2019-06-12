version 12.1

**********  Test of the competency form
**********  Joint test if education effects are significantly different across policy positions
estimates use m10.ster
est r

**** samesex: university education effect for each policy position
test 3.education#1.samesex = 3.education#2.samesex 
test 3.education#1.samesex = 3.education#3.samesex 
test 3.education#2.samesex = 3.education#3.samesex 

test 3.education#1.samesex 3.education#2.samesex 3.education#3.samesex 

**** taxpsend: university education effect for each policy position
test 3.education#1.taxspend = 3.education#2.taxspend 
test 3.education#1.taxspend = 3.education#3.taxspend 
test 3.education#2.taxspend = 3.education#3.taxspend 

test 3.education#1.taxspend 3.education#2.taxspend 3.education#3.taxspend 
